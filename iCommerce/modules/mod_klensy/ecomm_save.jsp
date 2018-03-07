<%-- 
    Document   : ecomm_save
Este jsp se encarga de realizar el guardado de un pedido por ecommerce
    Created on : 30-abr-2013, 17:57:37
    Author     : aleph_79
--%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="com.mercadopago.MP"%>
<%@page import="comSIWeb.Operaciones.Reportes.CIP_Formato"%>
<%@page import="comSIWeb.Operaciones.Formatos.Formateador"%>
<%@page import="comSIWeb.Operaciones.Reportes.PDFEventPage"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.DocumentException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.SQLException"%>
<%@page import="Tablas.vta_cliente_facturacion"%>
<%@page import="Tablas.vta_cliente_dir_entrega"%>
<%@page import="Tablas.vta_pedidos_cajas_master"%>
<%@page import="Tablas.vta_pedidos_cajas"%>
<%@page import="ERP.Folios"%>
<%@page import="Core.FirmasElectronicas.SATXmlLala"%>
<%@page import="Core.FirmasElectronicas.Addendas.SATAddendaMabe"%>
<%@page import="Core.FirmasElectronicas.SATXml"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Tablas.vta_pedidos"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="ERP.FacturaMasiva"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.CIP_Form" %>
<%@page import="Tablas.Usuarios" %>
<%@page import="Tablas.vta_ticketsdeta" %>
<%@page import="Tablas.vta_pedidosdeta" %>
<%@page import="Tablas.vta_facturadeta" %>
<%@page import="Tablas.vta_cotizadeta" %>
<%@page import="Tablas.vta_mov_cte_deta" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
<%@page import="ERP.Ticket" %>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (seg.ValidaURL(request)) {
        //Inicializamos datos
        Fechas fecha = new Fechas();
        //Recuperamos paths de web.xml
        String strPathXML = this.getServletContext().getInitParameter("PathXml");
        String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
        String strmod_Inventarios = this.getServletContext().getInitParameter("mod_Inventarios");
        String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
        String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
        String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
        if (strfolio_GLOBAL == null) {
            strfolio_GLOBAL = "SI";
        }
        if (strmod_Inventarios == null) {
            strmod_Inventarios = "NO";
        }
        if (strSist_Costos == null) {
            strSist_Costos = "0";
        }
        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            // <editor-fold defaultstate="collapsed" desc="Genera una nueva operacion de ventas">
            if (strid.equals("1")) {
                //Instanciamos el objeto que generara la venta
                Ticket ticket = new Ticket(oConn, varSesiones, request);
                ticket.setStrPATHKeys(strPathPrivateKeys);
                ticket.setStrPATHXml(strPathXML);
                ticket.setStrPATHFonts(strPathFonts);
                //Desactivamos inventarios
                if (strmod_Inventarios.equals("NO")) {
                    ticket.setBolAfectaInv(false);
                }
                //Validamos si envian la peticion con la bandera de afectar inventarios
                if (request.getParameter("INV") != null) {
                    if (request.getParameter("INV").equals("0")) {
                        ticket.setBolAfectaInv(false);
                    }
                }
                //Definimos el sistema de costos
                try {
                    ticket.setIntSistemaCostos(Integer.valueOf(strSist_Costos));
                } catch (NumberFormatException ex) {
                    System.out.println("No hay sistema de costos definido");
                }
                //Recibimos parametros
                String strPrefijoMaster = "TKT";
                String strPrefijoDeta = "TKTD";
                String strTipoVtaNom = Ticket.TICKET;
                //Recuperamos el tipo de venta 1:FACTURA 2:TICKET 3:PEDIDO
                String strTipoVta = request.getParameter("TIPOVENTA");
                if (strTipoVta == null) {
                    strTipoVta = "2";
                }
                if (strTipoVta.equals("1")) {
                    strPrefijoMaster = "FAC";
                    strPrefijoDeta = "FACD";
                    strTipoVtaNom = Ticket.FACTURA;
                    ticket.initMyPass(this.getServletContext());
                }
                if (strTipoVta.equals("3")) {
                    strPrefijoMaster = "PD";
                    strPrefijoDeta = "PDD";
                    strTipoVtaNom = Ticket.PEDIDO;
                }
                if (strTipoVta.equals("4")) {
                    strPrefijoMaster = "PD";
                    strPrefijoDeta = "PDD";
                    strTipoVtaNom = Ticket.COTIZACION;
                }
                ticket.setStrTipoVta(strTipoVtaNom);
                //Validamos si tenemos un empresa seleccionada
                if (varSesiones.getIntIdEmpresa() != 0) {
                    //Asignamos la empresa seleccionada
                    ticket.setIntEMP_ID(varSesiones.getIntIdEmpresa());
                }
                //Validamos si usaremos un folio global
                if (strfolio_GLOBAL.equals("NO")) {
                    ticket.setBolFolioGlobal(false);
                }
                //Recibimos datos para el encabezado
                int intPD_ID = 0;
                if (request.getParameter("PD_ID") != null) {
                    //Validamos si recibimos una lista de pedidos
                    if (request.getParameter("FAC_PEDI") != null) {
                        if (request.getParameter("FAC_PEDI").contains("1")) {
                            ticket.getListPedidos(request.getParameter("PD_ID"));
                        }
                    } else {
                        try {
                            intPD_ID = Integer.valueOf(request.getParameter("PD_ID"));
                        } catch (NumberFormatException ex) {
                            System.out.println("ERP_Ventas PD_ID " + ex.getMessage());
                        }
                    }

                }
                ticket.setIntPedidoGenero(intPD_ID);
                if (strTipoVta.equals("1") || strTipoVta.equals("2")) {
                    ticket.getDocument().setFieldInt("PD_ID", intPD_ID);
                } else {
                    //Edicion de un pedido
                    if (strTipoVta.equals("3")) {
                        //Si llega el campo de pedido entonces estamos editando un pedido
                        if (request.getParameter("PD_ID") != null) {
                            ticket.getDocument().setFieldInt("PD_ID", intPD_ID);
                            //Validamos si la modificacion de un pedido
                            if (ticket.getDocument().getFieldInt("PD_ID") != 0) {
                                //Generamos transaccion
                                ticket.getDocument().setValorKey(ticket.getDocument().getFieldInt("PD_ID") + "");
                                ticket.Init();
                            }
                        }
                    }
                }
                ticket.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                ticket.getDocument().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CT_ID")));
                if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", 1);
                } else {
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
                }
                //Clave de vendedor
                int intVE_ID = 0;
                try {
                    intVE_ID = Integer.valueOf(request.getParameter("VE_ID"));
                } catch (NumberFormatException ex) {
                    System.out.println("ERP_Ventas VE_ID " + ex.getMessage());
                }
                //Tarifas de IVA
                int intTI_ID = 0;
                int intTI_ID2 = 0;
                int intTI_ID3 = 0;
                try {
                    intTI_ID = Integer.valueOf(request.getParameter("TI_ID"));
                    intTI_ID2 = Integer.valueOf(request.getParameter("TI_ID2"));
                    intTI_ID3 = Integer.valueOf(request.getParameter("TI_ID3"));
                } catch (NumberFormatException ex) {
                    System.out.println("ERP_Ventas TI_ID " + ex.getMessage());
                }
                //Tipo de comprobante
                int intFAC_TIPOCOMP = 0;
                try {
                    intFAC_TIPOCOMP = Integer.valueOf(request.getParameter("FAC_TIPOCOMP"));
                } catch (NumberFormatException ex) {
                    System.out.println("ERP_Ventas FAC_TIPOCOMP " + ex.getMessage());
                }
                //Asignamos los valores al objeto
                ticket.getDocument().setFieldInt("VE_ID", intVE_ID);
                ticket.getDocument().setFieldInt("TI_ID", intTI_ID);
                ticket.getDocument().setFieldInt("TI_ID2", intTI_ID2);
                ticket.getDocument().setFieldInt("TI_ID3", intTI_ID3);
                ticket.setIntFAC_TIPOCOMP(intFAC_TIPOCOMP);
                ticket.getDocument().setFieldInt(strPrefijoMaster + "_ESSERV", Integer.valueOf(request.getParameter(strPrefijoMaster + "_ESSERV")));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA"), "/"));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", request.getParameter(strPrefijoMaster + "_NOTAS"));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", request.getParameter(strPrefijoMaster + "_NOTASPIE"));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));
                if (request.getParameter(strPrefijoMaster + "_METODOPAGO") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_METODODEPAGO", request.getParameter(strPrefijoMaster + "_METODOPAGO"));
                }
                if (request.getParameter(strPrefijoMaster + "_NUMCUENTA") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", request.getParameter(strPrefijoMaster + "_NUMCUENTA"));
                }
                ticket.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", request.getParameter(strPrefijoMaster + "_FORMADEPAGO"));
                //ticket.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", "En una sola Exhibicion");
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE")));
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO1")));
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO2")));
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO3")));
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(request.getParameter(strPrefijoMaster + "_TOTAL")));
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA1")));
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA2")));
                ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA3")));
                if (request.getParameter(strPrefijoMaster + "_TASAPESO") != null) {
                    if (Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")) == 0) {
                        ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                    } else {
                        ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")));
                    }
                } else {
                    ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                }
                //Validamos IEPS
                if (request.getParameter(strPrefijoMaster + "_USO_IEPS") != null) {
                    try {
                        ticket.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_USO_IEPS")));
                        ticket.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TASA_IEPS")));
                        ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE_IEPS")));
                    } catch (NumberFormatException ex) {
                    }
                }
                //Validamos CONSIGNACION
                if (request.getParameter(strPrefijoMaster + "_CONSIGNACION") != null) {
                    try {
                        ticket.getDocument().setFieldInt(strPrefijoMaster + "_CONSIGNACION", Integer.valueOf(request.getParameter(strPrefijoMaster + "_CONSIGNACION")));
                    } catch (NumberFormatException ex) {
                    }
                }
                //Validamos MLM
                if (request.getParameter(strPrefijoMaster + "_PUNTOS") != null) {
                    try {
                        ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_PUNTOS", Double.valueOf(request.getParameter(strPrefijoMaster + "_PUNTOS")));
                        ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_NEGOCIO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NEGOCIO")));
                    } catch (NumberFormatException ex) {
                    }
                }
                //Addenda MABE
                if (request.getParameter("ADD_MABE") != null) {
                    if (request.getParameter("ADD_MABE").equals("1")) {
                        ticket.getDocument().setFieldString("MB_CODIGOPROVEEDOR", request.getParameter("MB_CODIGOPROVEEDOR"));
                        try {
                            ticket.getDocument().setFieldInt("MB_PLANTA", Integer.valueOf(request.getParameter("MB_PLANTA")));
                        } catch (NumberFormatException ex) {
                            System.out.println("Error: al recuperar valor numerico MB_PLANTA " + ex.getMessage());
                        }
                        ticket.getDocument().setFieldString("MB_CALLE", request.getParameter("MB_CALLE"));
                        ticket.getDocument().setFieldString("MB_NO_EXT", request.getParameter("MB_NO_EXT"));
                        ticket.getDocument().setFieldString("MB_NO_INT", request.getParameter("MB_NO_INT"));
                        ticket.getDocument().setFieldString("MB_ORDENCOMPRA", request.getParameter("MB_ORDENCOMPRA"));
                        //Agregamos objetos para la addenda
                        SATXml satGen = new SATXml();
                        SATAddendaMabe mabe = new SATAddendaMabe();
                        satGen.setSatAddenda(mabe, Core.FirmasElectronicas.SAT_MABE.ObjectFactory.class);
                        ticket.setSAT(satGen);
                    }
                }
                //Adenda AMECE
                if (request.getParameter("ADD_AMECE") != null) {
                    if (request.getParameter("ADD_AMECE").equals("1")) {
                        ticket.getDocument().setFieldString("HM_ON", request.getParameter("HM_ON"));
                        ticket.getDocument().setFieldString("HM_DIV", request.getParameter("HM_DIV"));
                        ticket.getDocument().setFieldString("HM_SOC", request.getParameter("HM_SOC"));
                        ticket.getDocument().setFieldString("HM_REFERENCEDATE", request.getParameter("HM_REFERENCEDATE"));
                        ticket.getDocument().setFieldString("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY", request.getParameter("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY"));
                        ticket.getDocument().setFieldString("HM_NAME", request.getParameter("HM_NAME"));
                        ticket.getDocument().setFieldString("HM_STREET", request.getParameter("HM_STREET"));
                        ticket.getDocument().setFieldString("HM_CITY", request.getParameter("HM_CITY"));
                        ticket.getDocument().setFieldString("HM_POSTALCODE", request.getParameter("HM_POSTALCODE"));
                        //Agregamos objetos para la addenda
                        SATXmlLala satGen = new SATXmlLala();
                        satGen.setStrPathConfigPAC(strPathPrivateKeys);
                        ticket.setSAT(satGen);
                    }
                }
                //Datos de la aduana
                ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMPEDI", request.getParameter(strPrefijoMaster + "_NUMPEDI"));
                String strFechaPedimento = request.getParameter(strPrefijoMaster + "_FECHAPEDI");
                if (strFechaPedimento.contains("/") && strFechaPedimento.length() == 10) {
                    strFechaPedimento = fecha.FormateaBD(strFechaPedimento, "/");
                }
                ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", strFechaPedimento);
                ticket.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", request.getParameter(strPrefijoMaster + "_ADUANA"));
                //Si no hay moneda seleccionada que ponga tasa 1
                if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                    ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                }
                if (request.getParameter(strPrefijoMaster + "_DIASCREDITO") != null) {
                    if (Double.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")) == 0) {
                        ticket.getDocument().setFieldDouble(strPrefijoMaster + "_DIASCREDITO", 1);
                    }
                }
                //Validamos parametros para recibos de honorarios}
                if (request.getParameter(strPrefijoMaster + "_RETISR") != null && strTipoVtaNom.equals(Ticket.FACTURA)) {
                    ticket.getDocument().setFieldDouble(strPrefijoMaster + "_RETISR", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETISR")));
                }
                if (request.getParameter(strPrefijoMaster + "_RETIVA") != null && strTipoVtaNom.equals(Ticket.FACTURA)) {
                    ticket.getDocument().setFieldDouble(strPrefijoMaster + "_RETIVA", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETIVA")));
                }
                if (request.getParameter(strPrefijoMaster + "_NETO") != null && strTipoVtaNom.equals(Ticket.FACTURA)) {
                    ticket.getDocument().setFieldDouble(strPrefijoMaster + "_NETO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NETO")));
                }
                //Opciones de facturacion recurrente
                if (request.getParameter(strPrefijoMaster + "_ESRECU") != null) {
                    int intEsRecu = 0;
                    int intPeriodicidad = 1;
                    int intDiaPer = 1;
                    try {
                        intEsRecu = Integer.valueOf(request.getParameter(strPrefijoMaster + "_ESRECU"));
                    } catch (NumberFormatException ex) {
                        System.out.println("Ventas: Error convertir campo " + strPrefijoMaster + "_ESRECU" + " " + ex.getMessage());
                    }
                    try {
                        intPeriodicidad = Integer.valueOf(request.getParameter(strPrefijoMaster + "_PERIODICIDAD"));
                    } catch (NumberFormatException ex) {
                        System.out.println("Ventas: Error convertir campo " + strPrefijoMaster + "_PERIODICIDAD" + " " + ex.getMessage());
                    }

                    try {
                        intDiaPer = Integer.valueOf(request.getParameter(strPrefijoMaster + "_DIAPER"));
                    } catch (NumberFormatException ex) {
                        System.out.println("Ventas: Error convertir campo " + strPrefijoMaster + "_DIAPER" + " " + ex.getMessage());
                    }
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_ESRECU", intEsRecu);
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_PERIODICIDAD", intPeriodicidad);
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_DIAPER", intDiaPer);
                }
                //Recibimos el regimen fiscal
                if (request.getParameter(strPrefijoMaster + "_REGIMENFISCAL") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_REGIMENFISCAL", request.getParameter(strPrefijoMaster + "_REGIMENFISCAL"));
                }
                //Recibimos datos de los items o partidas
                int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
                for (int i = 1; i <= intCount; i++) {
                    TableMaster deta = null;
                    if (strTipoVtaNom.equals(Ticket.TICKET)) {
                        deta = new vta_ticketsdeta();
                    }
                    if (strTipoVtaNom.equals(Ticket.FACTURA)) {
                        deta = new vta_facturadeta();
                    }
                    if (strTipoVtaNom.equals(Ticket.PEDIDO)) {
                        deta = new vta_pedidosdeta();
                    }
                    if (strTipoVtaNom.equals(Ticket.COTIZACION)) {
                        deta = new vta_cotizadeta();
                    }
                    deta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                    deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO1" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO2" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO3" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_ESREGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESREGALO" + i)));
                    deta.setFieldString(strPrefijoDeta + "_CVE", request.getParameter(strPrefijoDeta + "_CVE" + i));
                    deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", request.getParameter(strPrefijoDeta + "_DESCRIPCION" + i));
                    deta.setFieldString(strPrefijoDeta + "_NOSERIE", request.getParameter(strPrefijoDeta + "_NOSERIE" + i));
                    deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPORTE" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", Double.valueOf(request.getParameter(strPrefijoDeta + "_CANTIDAD" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_TASAIVA1", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA1" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_TASAIVA2", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA2" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_TASAIVA3", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA3" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO1" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO2" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO3" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_IMPORTEREAL", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPORTEREAL" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_PRECIO", Double.valueOf(request.getParameter(strPrefijoDeta + "_PRECIO" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_DESCUENTO", Double.valueOf(request.getParameter(strPrefijoDeta + "_DESCUENTO" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_PORDESC", Double.valueOf(request.getParameter(strPrefijoDeta + "_PORDESC" + i)));
                    deta.setFieldDouble(strPrefijoDeta + "_PRECREAL", Double.valueOf(request.getParameter(strPrefijoDeta + "_PRECREAL" + i)));
                    //Retencion de ISR
                    if (request.getParameter(strPrefijoDeta + "_RET_ISR" + i) != null) {
                        try {
                            deta.setFieldDouble(strPrefijoDeta + "_RET_ISR", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_ISR" + i)));
                            deta.setFieldDouble(strPrefijoDeta + "_RET_IVA", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_IVA" + i)));
                            deta.setFieldDouble(strPrefijoDeta + "_RET_FLETE", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_FLETE" + i)));
                        } catch (NumberFormatException ex) {
                            System.out.println("EN ERP_Ventas falta definir retencion ISR");
                        }

                    }
                    //Solo aplica si es ticket o factura
                    if (strTipoVtaNom.equals(Ticket.TICKET) || strTipoVtaNom.equals(Ticket.FACTURA)) {
                        deta.setFieldInt(strPrefijoDeta + "_ESDEVO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESDEVO" + i)));
                    }
                    deta.setFieldInt(strPrefijoDeta + "_PRECFIJO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_PRECFIJO" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_ESREGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESREGALO" + i)));
                    deta.setFieldString(strPrefijoDeta + "_COMENTARIO", request.getParameter(strPrefijoDeta + "_NOTAS" + i));
                    //UNIDAD DE MEDIDA UNIDAD_MEDIDA
                    if (request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i) != null) {
                        deta.setFieldString(strPrefijoDeta + "_UNIDAD_MEDIDA", request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i));
                    }
                    //Evaluamos si envian el id del pedido
                    if (request.getParameter("PDD_ID" + i) != null) {
                        deta.setFieldInt("PDD_ID", Integer.valueOf(request.getParameter("PDD_ID" + i)));
                    }
                    //Validamos MLM
                    if (request.getParameter(strPrefijoDeta + "_PUNTOS" + i) != null) {
                        try {
                            deta.setFieldDouble(strPrefijoDeta + "_PUNTOS", Double.valueOf(request.getParameter(strPrefijoDeta + "_PUNTOS" + i)));
                            deta.setFieldDouble(strPrefijoDeta + "_VNEGOCIO", Double.valueOf(request.getParameter(strPrefijoDeta + "_VNEGOCIO" + i)));
                            deta.setFieldDouble(strPrefijoDeta + "_IMP_PUNTOS", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMP_PUNTOS" + i)));
                            deta.setFieldDouble(strPrefijoDeta + "_IMP_VNEGOCIO", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMP_VNEGOCIO" + i)));
                            deta.setFieldDouble(strPrefijoDeta + "_DESC_ORI", Double.valueOf(request.getParameter(strPrefijoDeta + "_DESC_ORI" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_DESC_PREC", Integer.valueOf(request.getParameter(strPrefijoDeta + "_DESC_PREC" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_DESC_PUNTOS", Integer.valueOf(request.getParameter(strPrefijoDeta + "_DESC_PTO" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_DESC_VNEGOCIO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_DESC_VN" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_REGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_REGALO" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_ID_PROMO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ID_PROMO" + i)));
                        } catch (NumberFormatException ex) {
                            System.out.println("Error al recuperar los valores de MLM " + ex.getMessage() + " " + ex.getLocalizedMessage() + " " + ex.toString());
                            ex.fillInStackTrace();
                        }
                    }
                    //Validamos si estan enviando datos de movimientos de surtido de numeros de serie
                    if (request.getParameter(strPrefijoDeta + "_SERIES_MPD" + i) != null) {
                        String[] lstSeriesMPD = request.getParameter(strPrefijoDeta + "_SERIES_MPD" + i).split(",");
                        for (int iSerM = 0; iSerM < lstSeriesMPD.length; iSerM++) {
                            int intMPD_ID = 0;
                            try {
                                intMPD_ID = Integer.valueOf(lstSeriesMPD[iSerM]);
                                ticket.addItemLstSeries(intMPD_ID);
                            } catch (NumberFormatException ex) {
                            }
                        }

                    }
                    //
                    ticket.AddDetalle(deta);
                }
                //Recibimos los pagos
                int intCountPagos = Integer.valueOf(request.getParameter("COUNT_PAGOS"));

                for (int i = 1; i <= intCountPagos; i++) {
                    if (Double.valueOf(request.getParameter("MCD_IMPORTE" + i)) > 0) {
                        vta_mov_cte_deta detaPago = new vta_mov_cte_deta();
                        detaPago.setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CT_ID")));
                        detaPago.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                        detaPago.setFieldInt("MCD_MONEDA", Integer.valueOf(request.getParameter("MCD_MONEDA" + i)));
                        detaPago.setFieldString("MCD_FOLIO", request.getParameter("MCD_FOLIO" + i));
                        detaPago.setFieldString("MCD_FORMAPAGO", request.getParameter("MCD_FORMAPAGO" + i));
                        detaPago.setFieldString("MCD_NOCHEQUE", request.getParameter("MCD_NOCHEQUE" + i));
                        detaPago.setFieldString("MCD_BANCO", request.getParameter("MCD_BANCO" + i));
                        detaPago.setFieldString("MCD_NOTARJETA", request.getParameter("MCD_NOTARJETA" + i));
                        detaPago.setFieldString("MCD_TIPOTARJETA", request.getParameter("MCD_TIPOTARJETA" + i));
                        detaPago.setFieldDouble("MCD_IMPORTE", Double.valueOf(request.getParameter("MCD_IMPORTE" + i)));
                        detaPago.setFieldDouble("MCD_TASAPESO", Double.valueOf(request.getParameter("MCD_TASAPESO" + i)));
                        detaPago.setFieldDouble("MCD_CAMBIO", Double.valueOf(request.getParameter("MCD_CAMBIO" + i)));
                        //Validamos si tenemos un empresa seleccionada
                        if (varSesiones.getIntIdEmpresa() != 0) {
                            //Asignamos la empresa seleccionada
                            detaPago.setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
                        }
                        ticket.AddDetalle(detaPago);
                    }
                }
                //Evaluamos si hay que guardar los datos de la direccion de entrega y la factura
                if (varSesiones.getIntNoUser() == 0) {

                    //Obtenemos el nombre de la sucursal default
                    int intEMP_ID = 0;
                    String strSql = "select EMP_ID "
                            + " from vta_cliente "
                            + " where  vta_cliente.CT_ID = " + varSesiones.getintIdCliente();
                    ResultSet rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        intEMP_ID = rs.getInt("EMP_ID");
                    }
                    rs.close();

                    vta_cliente_dir_entrega dirEntrega = new vta_cliente_dir_entrega();
                    dirEntrega.setBolGetAutonumeric(true);
                    dirEntrega.setFieldString("CDE_CALLE", request.getParameter("Calle_ent"));
                    dirEntrega.setFieldString("CDE_COLONIA", request.getParameter("Colonia_ent"));
                    //dirEntrega.setFieldString("CDE_LOCALIDAD", request.getParameter(""));
                    dirEntrega.setFieldString("CDE_MUNICIPIO", request.getParameter("Municipio_ent"));
                    dirEntrega.setFieldString("CDE_ESTADO", request.getParameter("Estado_ent"));
                    dirEntrega.setFieldString("CDE_CP", request.getParameter("cp_ent"));
                    dirEntrega.setFieldString("CDE_NUMERO", request.getParameter("Numero_ent"));
                    dirEntrega.setFieldString("CDE_NUMINT", request.getParameter("NumeroInt_ent"));
                    dirEntrega.setFieldInt("EMP_ID", intEMP_ID);
                    dirEntrega.setFieldString("CDE_DESCRIPCION", request.getParameter("Nombre"));
                    dirEntrega.setFieldInt("CT_ID", varSesiones.getintIdCliente());
                    dirEntrega.setFieldString("CDE_NOMBRE", request.getParameter("Nombre"));
                    dirEntrega.setFieldString("CDE_EMAIL", request.getParameter("Email"));
                    dirEntrega.Agrega(oConn);
                    int intCDE_ID = 0;
                    try {
                        intCDE_ID = Integer.valueOf(dirEntrega.getValorKey());
                        ticket.getDocument().setFieldInt("CDE_ID", intCDE_ID);
                    } catch (NumberFormatException ex) {
                        System.out.println("Error in CDE_ID");
                    }

                    //No esta logueado hay que guardar la direccion de entrega y la factura
                    String siFacturo = request.getParameter("siFacturo");
                    if (siFacturo == null) {
                        siFacturo = "0";
                    }
                    if (siFacturo.equals("1")) {
                        vta_cliente_facturacion dfact = new vta_cliente_facturacion();
                        dfact.setBolGetAutonumeric(true);
                        dfact.setFieldString("DFA_RAZONSOCIAL", request.getParameter("razonsocial"));
                        dfact.setFieldString("DFA_RFC", request.getParameter("rfc"));
                        dfact.setFieldString("DFA_CALLE", request.getParameter("Calle"));
                        dfact.setFieldString("DFA_NUMERO", request.getParameter("Numero"));
                        dfact.setFieldString("DFA_NUMINT", request.getParameter("NumeroInt"));
                        dfact.setFieldString("DFA_COLONIA", request.getParameter("Colonia"));
                        //dfact.setFieldString("DFA_LOCALIDAD", request.getParameter(""));
                        dfact.setFieldString("DFA_MUNICIPIO", request.getParameter("Municipio"));
                        dfact.setFieldString("DFA_ESTADO", request.getParameter("Estado"));
                        dfact.setFieldString("DFA_CP", request.getParameter("cp_fact"));
                        dfact.setFieldInt("CT_ID", varSesiones.getintIdCliente());
                        dfact.Agrega(oConn);
                        int intDFA_ID = 0;
                        try {
                            intDFA_ID = Integer.valueOf(dfact.getValorKey());
                            ticket.getDocument().setFieldInt("DFA_ID", intDFA_ID);
                        } catch (NumberFormatException ex) {
                            System.out.println("Error in CDE_ID");
                        }
                    }
                }
                //Direccion de entrega adicional
                String appDirEntrega = request.getParameter("appDirEntrega");
                if (appDirEntrega == null) {
                    appDirEntrega = "0";
                }
                if (appDirEntrega.equals("1")) {

                    //Obtenemos el nombre de la sucursal default
                    int intEMP_ID = 0;
                    String strSql = "select EMP_ID "
                            + " from vta_cliente "
                            + " where  vta_cliente.CT_ID = " + varSesiones.getintIdCliente();
                    ResultSet rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        intEMP_ID = rs.getInt("EMP_ID");
                    }
                    rs.close();
                    //Agregamos con el objeto de la direccion de entrega
                    vta_cliente_dir_entrega dirEntrega = new vta_cliente_dir_entrega();
                    dirEntrega.setBolGetAutonumeric(true);
                    dirEntrega.setFieldString("CDE_CALLE", request.getParameter("Calle_nw"));
                    dirEntrega.setFieldString("CDE_COLONIA", request.getParameter("Colonia_nw"));
                    //dirEntrega.setFieldString("CDE_LOCALIDAD", request.getParameter(""));
                    dirEntrega.setFieldString("CDE_MUNICIPIO", request.getParameter("Municipio_nw"));
                    dirEntrega.setFieldString("CDE_ESTADO", request.getParameter("Estado_nw"));
                    dirEntrega.setFieldString("CDE_CP", request.getParameter("cp_fact_nw"));
                    dirEntrega.setFieldString("CDE_NUMERO", request.getParameter("Numero_nw"));
                    dirEntrega.setFieldString("CDE_NUMINT", request.getParameter("NumeroInt_nw"));
                    dirEntrega.setFieldInt("EMP_ID", intEMP_ID);
                    dirEntrega.setFieldString("CDE_DESCRIPCION", "");
                    dirEntrega.setFieldInt("CT_ID", varSesiones.getintIdCliente());
                    dirEntrega.setFieldString("CDE_NOMBRE", request.getParameter("Nombre_nw"));
                    dirEntrega.setFieldString("CDE_EMAIL", request.getParameter("Email_nw"));
                    dirEntrega.Agrega(oConn);
                    int intCDE_ID = 0;
                    try {
                        intCDE_ID = Integer.valueOf(dirEntrega.getValorKey());
                        ticket.getDocument().setFieldInt("CDE_ID", intCDE_ID);
                    } catch (NumberFormatException ex) {
                        System.out.println("Error in CDE_ID");
                    }
                }
                //Validamos si es un pedido que se esta editando para solo modificar el pedido anterior
                if (strTipoVta.equals("3") && ticket.getDocument().getFieldInt("PD_ID") != 0) {
                    ticket.doTrxMod();
                } else {
                    ticket.Init();
                    //Generamos transaccion
                    ticket.doTrx();
                }
                String strRes = "";
                if (ticket.getStrResultLast().equals("OK")) {
                    strRes = "OK." + ticket.getDocument().getValorKey();
                } else {
                    strRes = ticket.getStrResultLast();
                }
                //Envio del pedido por mail
                String strMailCte = getMail(varSesiones.getintIdCliente(), oConn);

                if (!strMailCte.isEmpty()) {
                    String strRespPdf = GeneraImpresionPDF(oConn, strPathXML,
                            "PEDIDO", ticket.getDocument().getFieldString("PD_FOLIO"), Integer.valueOf(ticket.getDocument().getValorKey()),
                            strPathFonts);
                    System.out.println("strRespPdf" + strRespPdf);
                    if (strRespPdf.equals("OK")) {
                        String strRespEnvio = GeneraMail(oConn, strMailCte, "",
                                ticket.getDocument().getFieldString("PD_FOLIO"),
                                strPathXML);
                        System.out.println("strRespEnvio:" + strRespEnvio);
                    }
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            // </editor-fold>
            //Nos regresa el folio del ticket pedido o cotizacion
            if (strid.equals("4")) {
                //Recuperamos el id del cliente
                String strKEY_ID = request.getParameter("KEY_ID");
                if (strKEY_ID == null) {
                    strKEY_ID = "0";
                }
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<vta_folio>";
                //Consultamos la info
                String strFolio = "";
                //PEDIDOS
                String strSql = "select PD_FOLIO "
                        + "from vta_pedidos where PD_ID = " + strKEY_ID;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strFolio = rs.getString("PD_FOLIO");
                }
                rs.close();

                //El detalle
                strXML += "<vta_folios "
                        + " FOLIO = \"" + strFolio + "\"  "
                        + " />";
                strXML += "</vta_folio>";
                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }

            if (strid.equals("5")) {
                //Recuperamos el id del cliente
                String Total = request.getParameter("Total");

                String PAYMENT_CLIENT_ID = request.getParameter("PAYMENT_CLIENT_ID");
                String PAYMENT_CLIENT_SECRET = request.getParameter("PAYMENT_CLIENT_SECRET");

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<link>";
                //Consultamos la info


                /*Mercado Pago*/
                MP mp = new MP(PAYMENT_CLIENT_ID, PAYMENT_CLIENT_SECRET);

                String preferenceData = "{'items':"
                        + "[{"
                        + "'title':'Pedido',"
                        + "'description':'',"
                        + "'quantity':1,"
                        + "'currency_id':'MXN'," + // Available currencies at: https://api.mercadopago.com/currencies
                        "'unit_price': " + Total
                        + "}]"
                        + "}";

                JSONObject preference = mp.createPreference(preferenceData);
                mp.sandboxMode(true);
                if (Integer.parseInt(preference.get("status").toString()) == 200) {
                    System.out.print(preference.get("response"));
                }

                String initPoint = preference.getJSONObject("response").getString("init_point");

              

                //El detalle                
                strXML += "<linkdeta "
                        + " link = \"" + initPoint + "\"  "
                        + " />";
                strXML += "</link>";
                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }

        }
    } else {
    }
    oConn.close();
%>

<%!
    /**
     * Funciones
     */
    /**
     * Envia el mail al cliente
     *
     * @param strMailCte Es el mail del cliente
     * @param strMailCte2 Es el segundo mail del cliente
     * @param strFolio Es el folio
     * @param strPath Es el path donde se alojara temporalmente el pdf
     * @return Regresa OK si fue exitoso el envio del mail
     */
    protected String GeneraMail(Conexion oConn, String strMailCte, String strMailCte2,
            String strFolio,
            String strPath) {
        String strResp = "OK";
        //Nombre de archivo
        //Obtenemos datos del smtp
        String strsmtp_server = "";
        String strsmtp_user = "";
        String strsmtp_pass = "";
        String strsmtp_port = "";
        String strsmtp_usaTLS = "";
        String strsmtp_usaSTLS = "";
        //Buscamos los datos del SMTP
        String strSql = "select * from cuenta_contratada where ctam_id = 1";
        ResultSet rs;
        try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                strsmtp_server = rs.getString("smtp_server");
                strsmtp_user = rs.getString("smtp_user");
                strsmtp_pass = rs.getString("smtp_pass");
                strsmtp_port = rs.getString("smtp_port");
                strsmtp_usaTLS = rs.getString("smtp_usaTLS");
                strsmtp_usaSTLS = rs.getString("smtp_usaSTLS");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        //Obtenemos los textos para el envio del mail
        String strNomTemplate = "PEDIDO_WEB";
        String[] lstMail = getMailTemplate(oConn, strNomTemplate);

        /**
         * Si estan llenos todos los datos mandamos el mail
         */
        if (!strsmtp_server.equals("")
                && !strsmtp_user.equals("")
                && !strsmtp_pass.equals("")) {
            //armamos el mail
            Mail mail = new Mail();
            //Activamos envio de acuse de recibo
            mail.setBolAcuseRecibo(true);
            //Obtenemos los usuarios a los que mandaremos el mail
            String strLstMail = "";
            //Validamos si el mail del cliente es valido
            if (mail.isEmail(strMailCte)) {
                strLstMail += "," + strMailCte;
            }
            if (mail.isEmail(strMailCte2)) {
                strLstMail += "," + strMailCte2;
            }
            //Mandamos mail si hay usuarios
            if (!strLstMail.equals("")) {
                String strMsgMail = lstMail[1];
                strMsgMail = strMsgMail.replace("%folio%", strFolio);
                //Establecemos parametros
                mail.setUsuario(strsmtp_user);
                mail.setContrasenia(strsmtp_pass);
                mail.setHost(strsmtp_server);
                mail.setPuerto(strsmtp_port);
                mail.setAsunto(lstMail[0].replace("%folio%", strFolio));
                mail.setDestino(strLstMail);
                mail.setMensaje(strMsgMail);
                //Adjuntamos XML y PDF
                mail.setFichero(strPath + "Pedido_web" + strFolio + ".pdf");

                if (strsmtp_usaTLS.equals("1")) {
                    mail.setBolUsaTls(true);
                }
                if (strsmtp_usaSTLS.equals("1")) {
                    mail.setBolUsaStartTls(true);
                }
                boolean bol = mail.sendMail();
                if (!bol) {
                    strResp = "Fallo el envio del Mail.";
                }
            }
        }
        return strResp;
    }

    /**
     * Obtenemos los valores del template para el mail
     *
     * @param strNom Es el nombre del template
     * @return Regresa un arreglo con los valores del template
     */
    public String[] getMailTemplate(Conexion oConn, String strNom) {
        String[] listValores = new String[2];
        String strSql = "select MT_ASUNTO,MT_CONTENIDO from mailtemplates where MT_ABRV ='" + strNom + "'";
        ResultSet rs;
        try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                listValores[0] = rs.getString("MT_ASUNTO");
                listValores[1] = rs.getString("MT_CONTENIDO");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return listValores;
    }

    /**
     * Genera el formato de impresion en PDF
     *
     * @param strPath Es el path
     * @param intEMP_TIPOCOMP Es el tipo de comprobante
     * @param intEmpId Es el id de la empresa
     * @param strFAC_NOMFORMATO Es el nombre del formato
     * @return Regresa OK si se genero el formato
     */
    protected String GeneraImpresionPDF(Conexion oConn, String strPath,
            String strFAC_NOMFORMATO, String strFolio, int intTransaccion,
            String strPATHFonts) {
        String strResp = "OK";
        //Posicion inicial para el numero de pagina
        String strPosX = null;
        String strTitle = "";
        strTitle = "Factura ";

        try {
            Document document = new Document();
            PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(strPath + "Pedido_web" + strFolio + ".pdf"));
            //Objeto que dibuja el numero de paginas
            PDFEventPage pdfEvent = new PDFEventPage();
            pdfEvent.setStrTitleApp(strTitle);
            //Colocamos el numero donde comienza X por medio del parametro del web Xml por si necesitamos algun ajuste
            if (strPosX != null) {
                try {
                    int intPosX = Integer.valueOf(strPosX);
                    pdfEvent.setIntXPageNum(intPosX);
                } catch (NumberFormatException ex) {
                }
            } else {
                pdfEvent.setIntXPageNum(300);
                pdfEvent.setIntXPageNumRight(50);
                pdfEvent.setIntXPageTemplate(252.3f);
            }
            //Anexamos el evento
            writer.setPageEvent(pdfEvent);
            document.open();
            Formateador format = new Formateador();
            format.setIntTypeOut(Formateador.FILE);
            format.setStrPath(strPath);
            format.InitFormat(oConn, strFAC_NOMFORMATO);
            String strRes = format.DoFormat(oConn, intTransaccion);
            if (strRes.equals("OK")) {
                CIP_Formato fPDF = new CIP_Formato();
                fPDF.setDocument(document);
                fPDF.setWriter(writer);
                fPDF.setStrPathFonts(strPATHFonts);
                fPDF.EmiteFormato(format.getFmXML());
            } else {
                strResp = strRes;
            }
            document.close();
            writer.close();
        } catch (FileNotFoundException ex) {
            System.out.println(ex.getMessage());
            strResp = "ERROR:" + ex.getMessage();
        } catch (DocumentException ex) {
            System.out.println(ex.getMessage());
            strResp = "ERROR:" + ex.getMessage();
        }
        return strResp;
    }

    /**
     * Obtenemos el mail del cliente
     */
    public String getMail(int intIdUser, Conexion oConn) {
        String strMail = "";
        String strSql = "select CT_EMAIL1 from vta_cliente where CT_ID = " + intIdUser;
        try {
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                strMail = rs.getString("CT_EMAIL1");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return strMail;
    }
%>