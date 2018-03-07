<%-- 
    Document   : COFIDE_Telemarketing_vta
    Created on : 21-ene-2016, 23:50:45
    Author     : juliocesar
--%>

<%@page import="com.mx.siweb.erp.especiales.cofide.COFIDE_Mail_cursos"%>
<%@page import="comSIWeb.Operaciones.Reportes.PDFEventPage"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="comSIWeb.Operaciones.Formatos.Formateador"%>
<%@page import="comSIWeb.Operaciones.Formatos.FormateadorMasivo"%>
<%@page import="comSIWeb.Operaciones.Reportes.CIP_Formato"%>
<%@page import="java.io.File"%>
<%@page import="ERP.ERP_MapeoFormato"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.erp.especiales.cofide.SincronizarPaginaWeb"%>
<%@page import="com.mx.siweb.erp.especiales.cofide.Telemarketing"%>
<%@page import="Tablas.vta_mov_cte_deta"%>
<%@page import="Tablas.vta_cotizadeta"%>
<%@page import="Tablas.vta_pedidosdeta"%>
<%@page import="Tablas.vta_facturadeta"%>
<%@page import="Tablas.vta_ticketsdeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="ERP.Ticket"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>

<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    UtilXml util = new UtilXml();
    Fechas fec = new Fechas();
    COFIDE_Mail_cursos mg = new COFIDE_Mail_cursos();

    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("ID");
        if (strid != null) {
            if (strid.equals("1")) { //obtenemos datos del curso
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<vta>";
                String strNomCurso = request.getParameter("CEV_NOMCURSO");
                String strClasCurso = request.getParameter("Clasifica");
                if (strClasCurso == null) {
                    strClasCurso = "1";
                }
                String strNombre = "";
                int intLimite = 0;
                int intInscritos = 0;
                int intIdCurso = 0;
                double douPrecioUnit = 0;
                String strFechaIni = "";
                String strFec = "";
                //String strSql = "select * from cofide_cursos where CC_NOMBRE_CURSO = '" + strNomCurso + "'";
                String strSql = "select * from cofide_cursos where CC_CURSO_ID = '" + strNomCurso + "'";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strNombre = rs.getString("CC_NOMBRE_CURSO");
                    intLimite = rs.getInt("CC_MONTAJE");
                    intInscritos = rs.getInt("CC_INSCRITOS");
                    douPrecioUnit = rs.getDouble("CC_PRECIO_UNIT");
                    intIdCurso = rs.getInt("CC_CURSO_ID");
                    if (strClasCurso.equals("1")) {
                        douPrecioUnit = rs.getDouble("CC_PRECIO_PRES");
                    }
                    if (strClasCurso.equals("2")) {
                        douPrecioUnit = rs.getDouble("CC_PRECIO_ON");
                    }
                    if (strClasCurso.equals("3")) {
                        douPrecioUnit = rs.getDouble("CC_PRECIO_VID");
                    }
                    if (strClasCurso.equals("4")) {
                        douPrecioUnit = rs.getDouble("CC_PRECIO_PREON");
                    }
                    if (rs.getString("CC_FECHA_INICIAL") != null && rs.getString("CC_FECHA_INICIAL") != "") {
                        strFec = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "/");
                        //strFec = rs.getString("CC_FECHA_INICIAL");
                    }

                }
                rs.close();
                strXML += "<datos "
                        + " CEV_LIMITE = \"" + intLimite + "\" "
                        + " CEV_OCUPADO = \"" + intInscritos + "\" "
                        + " CEV_PRECIO_UNIT = \"" + douPrecioUnit + "\" "
                        + " CEV_FECINICIO = \"" + strFec + "\" "
                        + " CEV_IDCURSO = \"" + intIdCurso + "\" "
                        + " />";
                strXML += "</vta>";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //1
            if (strid.equals("2")) { //obtenemos datos de facturacion
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<vta>";
                int intIdCte = Integer.parseInt(request.getParameter("CT_NO_CLIENTE"));
                String strNCliente = "";
                String strNombre = "";
                String strRfc = "";
                String strCalle = "";
                String strColonia = "";
                String strDelegacion = "";
                String strEstado = "";
                String strCP = "";
                String strTelefono = "";
                String strCorreo1 = "";
                String strCorreo2 = "";
                int DFA_ID = 0;
                String strSql = "select DFA_RAZONSOCIAL, CT_ID, DFA_RFC, DFA_CALLE, DFA_COLONIA, DFA_MUNICIPIO, "
                        + "DFA_ESTADO, DFA_CP, DFA_TELEFONO, DFA_EMAIL, DFA_EMAI2 "
                        + "from vta_cliente_facturacion "
                        + "where CT_ID = " + intIdCte + " "
                        + "group by DFA_RAZONSOCIAL, CT_ID, DFA_RFC, DFA_CALLE, DFA_COLONIA, DFA_MUNICIPIO, "
                        + "DFA_ESTADO, DFA_CP, DFA_TELEFONO, DFA_EMAIL, DFA_EMAI2";
                //String strSql = "select * from vta_cliente_facturacion where CT_ID = " + intIdCte;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strNCliente = rs.getString("CT_ID");
                    strRfc = rs.getString("DFA_RFC");
                    strNombre = rs.getString("DFA_RAZONSOCIAL");
                    strCalle = rs.getString("DFA_CALLE");
                    strColonia = rs.getString("DFA_COLONIA");
                    strDelegacion = rs.getString("DFA_MUNICIPIO");
                    strEstado = rs.getString("DFA_ESTADO");
                    strCP = rs.getString("DFA_CP");
                    strTelefono = rs.getString("DFA_TELEFONO");
                    strCorreo1 = rs.getString("DFA_EMAIL");
                    strCorreo2 = rs.getString("DFA_EMAI2");
                    DFA_ID++;
                    strXML += "<datos "
                            //+ " CEV_ID = \"" + rs.getInt("DFA_ID") + "\" "
                            + " CEV_ID = \"" + DFA_ID + "\" "
                            + " CEV_NUMERO = \"" + strNCliente + "\" "
                            + " CEV_RFC = \"" + strRfc + "\" "
                            + " CEV_NOMBRE = \"" + strNombre + "\" "
                            + " CEV_CALLE = \"" + strCalle + "\" "
                            + " CEV_COLONIA = \"" + strColonia + "\" "
                            + " CEV_MUNICIPIO = \"" + strDelegacion + "\" "
                            + " CEV_ESTADO = \"" + strEstado + "\" "
                            + " CEV_CP = \"" + strCP + "\" "
                            + " CEV_TELEFONO = \"" + strTelefono + "\" "
                            + " CEV_EMAIL1 = \"" + strCorreo1 + "\" "
                            + " CEV_EMAIL2 = \"" + strCorreo2 + "\" "
                            + " />";
                }
                rs.close();

                strXML += "</vta>";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }
            if (strid.equals("5")) { //guardamos la venta
                //Inicializamos datos
                Fechas fecha = new Fechas();
                //Recuperamos paths de web.xml
                String strPathXML = this.getServletContext().getInitParameter("PathXml");
                String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
                String strmod_Inventarios = this.getServletContext().getInitParameter("mod_Inventarios");
                String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
                String strClienteUniversal = this.getServletContext().getInitParameter("ClienteUniversal");
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
                if (strClienteUniversal == null) {
                    strClienteUniversal = "0";
                }
                int intCevPublicidad = Integer.valueOf(request.getParameter("CEV_MPUBLICIDAD"));
                //Validamos si es un cliente de la base lo almacenamos
                //Guardamos el prospecto o lo actualizamos
                int intCT_ID = Integer.valueOf(request.getParameter("CT_ID"));
                String strCT_NO_CLIENTE = request.getParameter("CT_NO_CLIENTE");
                String strRazonsocial = request.getParameter("CT_RAZONSOCIAL");
                String strRfc = request.getParameter("CT_RFC");
                String strSede = request.getParameter("CT_SEDE");
                String strGiro = request.getParameter("CT_GIRO");
                String strArea = request.getParameter("CT_AREA");
                String strContacto = request.getParameter("CT_CONTACTO");
                String strContacto2 = request.getParameter("CT_CONTACTO2");
                String strCorreo = request.getParameter("CT_CORREO");
                String strCorreo2 = request.getParameter("CT_CORREO2");
                String strCev_Correo = request.getParameter("CEV_CORREO");
                String strCev_Correo2 = request.getParameter("CEV_CORREO2");
                String strBolBase = request.getParameter("CT_BOLBASE");
                String strCp = request.getParameter("CT_CP");
                String strCalle = request.getParameter("CT_CALLE");
                String strCol = request.getParameter("CT_COL");
                String strNumEx = request.getParameter("CT_NUM");
                String strNombre = request.getParameter("CT_NOMBRE");
                String strConmutador = request.getParameter("CT_CONMUTADOR");
                String strFacSerie = request.getParameter("FAC_SERIE");
                //String strComentario = request.getParameter("CEV_COMENTARIO");
                final String strComentario = URLDecoder.decode(new String(request.getParameter("CEV_COMENTARIO").getBytes(
                        "iso-8859-1")), "UTF-8");

                //Guardado del telemarketing
                Telemarketing tele = new Telemarketing();
                String strResultado = tele.doSaveProspectoBase(oConn, strBolBase, intCT_ID, strCT_NO_CLIENTE, strRazonsocial, strRfc,
                        strContacto, strContacto2, strCorreo, strCorreo2, "", "", "", strSede, strGiro, strArea, strCp, strCalle, strNumEx, strCol,
                        varSesiones, 0, strNombre, strConmutador);
                intCT_ID = Integer.valueOf(strResultado.replace("OK", ""));
                //Guardamos los contactos
                strResultado = tele.guardaContactos(oConn, varSesiones, request, intCT_ID);
                //Guardamos datos de facturacion
                int intDfaId = tele.saveDatosFactura(oConn, varSesiones, request, intCT_ID);
                //Instanciamos el objeto que generara la venta
                Ticket ticket = new Ticket(oConn, varSesiones, request);
                ticket.setStrPATHKeys(strPathPrivateKeys);
                ticket.setStrPATHXml(strPathXML);
                ticket.setStrPATHFonts(strPathFonts);

                ticket.setBolAfectaInv(false);
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

                //Edicion de pedidos
                ticket.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                ticket.getDocument().setFieldInt("CT_ID", intCT_ID);
                if (isUserInBound(oConn, varSesiones.getIntNoUser())) {
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_INBOUND", 1);
                } else {
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_INBOUND", 0);
                }

                if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", 1);
                } else {
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
                }

                //Categoria del cliente
                String strCCID1 = request.getParameter("CC1_ID");
                if (strCCID1 != null) {
                    ticket.getDocument().setFieldInt("CC1_ID", Integer.valueOf(request.getParameter("CC1_ID")));
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
                ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.getFechaActual());
                if(request.getParameter("CEV_FECHAPAGO") != null){
                    String strFechaCobro = fecha.FormateaBD(request.getParameter("CEV_FECHAPAGO"), "/");
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHA_COBRO", strFechaCobro);
                }
                ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO_C", request.getParameter(strPrefijoMaster + "_FOLIO"));
                ticket.getDocument().setFieldString("CC_CURSO_ID", request.getParameter("CEV_IDCURSO"));
                final String strNotas = URLDecoder.decode(new String(request.getParameter(strPrefijoMaster + "_NOTAS").getBytes(
                        "iso-8859-1")), "UTF-8");
                final String strNotasPie = URLDecoder.decode(new String(request.getParameter(strPrefijoMaster + "_NOTASPIE").getBytes(
                        "iso-8859-1")), "UTF-8");
                ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", strNotas);
                if (!strFacSerie.equals(null)) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_SERIE", strFacSerie); //numero de serie
                }
                ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", strNotasPie); //guarda el comentario del agente sobre la venta
                ticket.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));
                ticket.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));
                if (request.getParameter(strPrefijoMaster + "_METODOPAGO") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_METODODEPAGO", request.getParameter(strPrefijoMaster + "_METODOPAGO"));
                }
                if (request.getParameter(strPrefijoMaster + "_NUMCUENTA") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", request.getParameter(strPrefijoMaster + "_NUMCUENTA"));
                }
                if (request.getParameter("CEV_NOM_FILE") != null) {
                    ticket.getDocument().setFieldInt(strPrefijoMaster + "_COFIDE_PAGADO", 1);
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_NOMPAGO", request.getParameter("CEV_NOM_FILE"));
                } //si suben un comprobante, la venta queda pagada, si no, sigue siendo una venta pendiente
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

                //Si no hay moneda seleccionada que ponga tasa 1
                if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                    ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                }
                if (request.getParameter(strPrefijoMaster + "_DIASCREDITO") != null) {
                    if (Double.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")) == 0) {
                        ticket.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", 1);
                    } else {
                        ticket.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", Integer.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")));
                    }
                }
                //Cliente final
                if (intDfaId != 0l) {
                    try {
                        ticket.getDocument().setFieldInt("DFA_ID", intDfaId);
                    } catch (NumberFormatException ex) {
                        System.out.println("Ventas CT_CLIENTEFINAL " + ex.getMessage());
                    }
                }
                /*Campos flete, transportista , num guia VENTAS*/
                try {
                    ticket.getDocument().setFieldInt("TR_ID", Integer.valueOf(request.getParameter("TR_ID")));
                } catch (NumberFormatException ex) {
                    System.out.println("ERP_Compras TR_ID " + ex.getMessage());
                }
                try {
                    ticket.getDocument().setFieldInt("ME_ID", Integer.valueOf(request.getParameter("ME_ID")));
                } catch (NumberFormatException ex) {
                    System.out.println("ERP_Compras ME_ID " + ex.getMessage());
                }
                try {
                    ticket.getDocument().setFieldInt("TF_ID", Integer.valueOf(request.getParameter("TF_ID")));
                } catch (NumberFormatException ex) {
                    System.out.println("ERP_Compras TF_ID " + ex.getMessage());
                }
                if (request.getParameter(strPrefijoMaster + "_NUM_GUIA") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_NUM_GUIA", request.getParameter(strPrefijoMaster + "_NUM_GUIA"));
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
                //Recibimos el regimen fiscal
                if (request.getParameter(strPrefijoMaster + "_REGIMENFISCAL") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_REGIMENFISCAL", request.getParameter(strPrefijoMaster + "_REGIMENFISCAL"));
                }
                //Recibimos la serie por guardar...
                if (request.getParameter(strPrefijoMaster + "_SERIE") != null) {
                    ticket.getDocument().setFieldString(strPrefijoMaster + "_SERIE", request.getParameter(strPrefijoMaster + "_SERIE"));
                }
                //Recibimos el turno de la operacion
                if (request.getParameter(strPrefijoMaster + "_TURNO") != null) {
                    try {
                        ticket.getDocument().setFieldInt(strPrefijoMaster + "_TURNO", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TURNO")));
                    } catch (NumberFormatException ex) {
                        System.out.println("Error al convertir turno");
                    }
                }
                //Periodos para los multiniveles
                Periodos periodo = new Periodos();
                ticket.getDocument().setFieldInt("MPE_ID", periodo.getPeriodoActual(oConn));
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
                    deta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                    deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO1" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO2" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO3" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_ESREGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESREGALO" + i)));
                    deta.setFieldString(strPrefijoDeta + "_CVE", request.getParameter(strPrefijoDeta + "_CVE" + i));
                    final String strDescripcion = URLDecoder.decode(new String(request.getParameter(strPrefijoDeta + "_DESCRIPCION" + i).getBytes(
                            "iso-8859-1")), "UTF-8");

                    final String strNotasDeta = URLDecoder.decode(new String(request.getParameter(strPrefijoDeta + "_NOTAS" + i).getBytes(
                            "iso-8859-1")), "UTF-8");
                    deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", strDescripcion);
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
                    deta.setFieldString(strPrefijoDeta + "_COMENTARIO", strComentario);
                    //UNIDAD DE MEDIDA UNIDAD_MEDIDA
                    if (request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i) != null) {
                        deta.setFieldString(strPrefijoDeta + "_UNIDAD_MEDIDA", request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i));
                    }
                    //ID DE SERVICIO
                    if (request.getParameter(strPrefijoDeta + "_CF_ID" + i) != null) {
                        deta.setFieldString("CF_ID", request.getParameter(strPrefijoDeta + "_CF_ID" + i));
                    }
                    //Evaluamos si envian el id del pedido
                    if (request.getParameter("PDD_ID" + i) != null) {
                        deta.setFieldInt("PDD_ID", Integer.valueOf(request.getParameter("PDD_ID" + i)));
                    }
                    if (request.getParameter(strPrefijoDeta + "_DESC_PREC" + i) != null) {
                        try {
                            deta.setFieldDouble(strPrefijoDeta + "_DESC_ORI", Double.valueOf(request.getParameter(strPrefijoDeta + "_DESC_ORI" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_DESC_PREC", Integer.valueOf(request.getParameter(strPrefijoDeta + "_DESC_PREC" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_REGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_REGALO" + i)));
                            deta.setFieldInt(strPrefijoDeta + "_ID_PROMO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ID_PROMO" + i)));
                        } catch (NumberFormatException ex) {
                            System.out.println("Error al recuperar los valores de MLM " + ex.getMessage() + " " + ex.getLocalizedMessage() + " " + ex.toString());
                            ex.fillInStackTrace();
                        }
                    }

                    ticket.AddDetalle(deta);
                }
                //Recibimos los pagos
                int intCountPagos = Integer.valueOf(request.getParameter("COUNT_PAGOS"));

                for (int i = 1; i <= intCountPagos; i++) {
                    if (Double.valueOf(request.getParameter("MCD_IMPORTE" + i)) > 0) {
                        vta_mov_cte_deta detaPago = new vta_mov_cte_deta();
                        detaPago.setFieldInt("CT_ID", intCT_ID);
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

                //Inicializamos objeto
                ticket.setBolSendMailMasivo(false);
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
                    int intIdVta = Integer.valueOf(ticket.getDocument().getValorKey());
                    //Posicion inicial para el numero de pagina
                    String strPosX = "";
                    String strTitle = "";
                    strPosX = this.getServletContext().getInitParameter("PosXTitle");
                    strTitle = this.getServletContext().getInitParameter("TitleApp");
                    //strTipoVta = 2 es un ticket o cotizacion
                    //strTipoVta = 1 es una factura
                    System.out.println("el correo se enviara a los sigueintes correos " + strCev_Correo + " y " + strCev_Correo2);
                    enviaMailMasivo(oConn, strPosX, strTitle, ticket.getDocument().getValorKey(), varSesiones, strTipoVta,
                            strCev_Correo, strCev_Correo2);

                    //agregar a la funcion de mail masivo el campo de tipodoc
                    //Solo aplica en pedidos, tickets y cotizaciones
                    if (strTipoVta.equals("2") || strTipoVta.equals("3") || strTipoVta.equals("4")) {
                        //Enviamos por correo el formato en caso de ser diferente de factura
                        String strTipoDoc = "";
                        if (strTipoVta.equals("2")) { //si es ticket, manda correo con el ticket
                            strTipoDoc = "TICKET";
                        }

                        try {
                            //pendiente
                            ticket.generaMail(oConn, Integer.valueOf(ticket.getDocument().getValorKey()), strTipoDoc, strPathXML, strPathFonts, strCev_Correo);
                        } catch (NumberFormatException ex) {
                        }
                    }

                    //Guardamos los participantes del curso
                    int intIdTicket = 0;
                    int intIdFactura = 0;
                    if (strTipoVta.equals("1")) {
                        intIdFactura = intIdVta;
                    } else {
                        intIdTicket = intIdVta;
                    }
                    strResultado = tele.guardaParticipantes(oConn, varSesiones, request, intCT_ID, intIdTicket, intIdFactura,
                            Integer.valueOf(request.getParameter("CEV_FAC")),
                            Integer.valueOf(request.getParameter("CEV_MIMP")),
                            Integer.valueOf(request.getParameter("CEV_TIPO_CURSO")),
                            request.getParameter("CEV_FECHAPAGO"),
                            request.getParameter("CEV_DIGITO"),
                            request.getParameter("CEV_NOM_FILE")
                    );
                    SincronizarPaginaWeb sincroniza = new SincronizarPaginaWeb(oConn);
                    sincroniza.peticionDescargaMaterial(intIdTicket, intIdFactura);
                    //Afectamos otros objetos de negocio
                } else {
                    strRes = ticket.getStrResultLast();

                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            } //5
            if (strid.equals("3")) { //CP
                String strCp = request.getParameter("CEV_CP");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<Sepomex>");
                String strColonia = "";
                String strMunicipio = "";
                String strEstado = "";
                int cont = 0;
                String strSql = "select * from cofide_sepomex where cmx_cp = " + strCp;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strColonia = rs.getString("CMX_COLONIA");
                    strMunicipio = rs.getString("CMX_MUNICIPIO");
                    strEstado = rs.getString("CMX_ESTADO");
                    if (cont == 0) {
                        strXML.append("<General ");
                        strXML.append(" CMX_MUNICIPIO = \"").append(strMunicipio).append("\" ");
                        strXML.append(" CMX_ESTADO = \"").append(strEstado).append("\" ");
                        strXML.append(" >");
                    }
                    strXML.append("<Colonia ");
                    strXML.append(" CMX_COLONIA = \"").append(strColonia).append("\"");
                    strXML.append(" />");
                    cont++;
                }
                strXML.append("</General>");
                strXML.append("</Sepomex>");
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML.toString());//Pintamos el resultado
            } //fin 3
            if (strid.equals("4")) { //llenar datos fiscales de venta
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<vta>";
                String strIdCte = request.getParameter("CT_NO_CLIENTE");
                String strRazonSocial = "";
                String strNumero = "";
                String strRFC = "";
                String strCalle = "";
                String strColonia = "";
                String strMunicipio = "";
                String strEstado = "";
                String strCP = "";
                String strCorreo = "";
                String strCC = "";
                String strTelefono = "";
                String strSql = "select * from vta_cliente_facturacion where ct_id = " + strIdCte;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strRazonSocial = rs.getString("DFA_RAZONSOCIAL");
                    strNumero = rs.getString("DFA_NUMERO");
                    strRFC = rs.getString("DFA_RFC");
                    strCalle = rs.getString("DFA_CALLE");
                    strColonia = rs.getString("DFA_COLONIA");
                    strMunicipio = rs.getString("DFA_MUNICIPIO");
                    strEstado = rs.getString("DFA_ESTADO");
                    strCP = rs.getString("DFA_CP");
                    strCorreo = rs.getString("DFA_EMAIL");
                    strCC = rs.getString("DFA_EMAI2");
                    strTelefono = rs.getString("DFA_TELEFONO");

                    strXML += "<datos "
                            + " DFA_RAZONSOCIAL = \"" + strRazonSocial + "\"  "
                            + " DFA_RFC = \"" + strRFC + "\"  "
                            + " DFA_CALLE = \"" + strCalle + "\"  "
                            + " DFA_COLONIA = \"" + strColonia + "\"  "
                            + " DFA_MUNICIPIO = \"" + strMunicipio + "\"  "
                            + " DFA_ESTADO = \"" + strEstado + "\"  "
                            + " DFA_CP = \"" + strCP + "\"  "
                            + " DFA_EMAIL = \"" + strCorreo + "\"  "
                            + " DFA_EMAI2 = \"" + strCC + "\"  "
                            + " DFA_NUMERO = \"" + strNumero + "\"  "
                            + " DFA_TELEFONO = \"" + strTelefono + "\" "
                            + " />";
                }
                rs.close();
                strXML += "</vta>";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 4
            if (strid.equals("6")) {
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<vta>";
                String strSupervisor = request.getParameter("SC_NOMBRE");
                //GeneraMailDip_Sem(oConn, "jchavez@solucionesinformaticasweb.com.mx", "1205", varSesiones.getStrUser());
                //GeneraMailDiplomado(oConn, "jchavez@solucionesinformaticasweb.com.mx", "1205", varSesiones.getStrUser());
                //GeneraMailSeminario(oConn, "jchavez@solucionesinformaticasweb.com.mx", "1205", varSesiones.getStrUser());
                String strPass = "";
                String strSql = "select SC_PASSWORD from cofide_supervisor where SC_ID = " + strSupervisor;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strPass = rs.getString("SC_PASSWORD");
                }
                strXML += "<datos "
                        + " SC_PASSWORD = \"" + strPass + "\" "
                        + " />";
                strXML += "</vta>";
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 6
            if (strid.equals("7")) {
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<vta>";
                String strFechaActual = fec.getFechaActual();
                strXML += "<datos "
                        + " fecha = \"" + strFechaActual + "\" "
                        + " />";
                strXML += "</vta>";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 7
            if (strid.equals("8")) {
                int intIdCurso = Integer.parseInt(request.getParameter("id_curso"));
                String strCTE = request.getParameter("id_cte");
                String strFac_Tkt = request.getParameter("fac_id");
                String strExt = request.getParameter("extension");
                String strCorreo = "";
                String strParticipante = "";
                String strRazonsocial = "";
                int intID_US = varSesiones.getIntNoUser();
                String strSqlCtes = "";
                String strSqlParticipante = "";
                String strConcatParticipante = "";
                if (strExt.equals("FAC")) {
                    strSqlCtes = "select concat(CP_TITULO, ' ',CP_NOMBRE,' ',CP_APPAT,' ',CP_APMAT ) as PARTICIPANTE, CP_CORREO, "
                            + "(select CT_RAZONSOCIAL from vta_cliente where ct_id = " + strCTE + ") as RAZONSOCIAL "
                            + "from cofide_participantes where ct_id = " + strCTE + " and CP_FAC_ID = " + strFac_Tkt;
                }
                if (strExt.equals("TKT")) {
                    strSqlCtes = "select concat(CP_TITULO, ' ',CP_NOMBRE,' ',CP_APPAT,' ',CP_APMAT ) as PARTICIPANTE, CP_CORREO, "
                            + "(select CT_RAZONSOCIAL from vta_cliente where ct_id = " + strCTE + ") as RAZONSOCIAL "
                            + "from cofide_participantes where ct_id = " + strCTE + " and CP_TKT_ID = " + strFac_Tkt;
                }
                ResultSet rsCtes;
                rsCtes = oConn.runQuery(strSqlCtes, true);
                while (rsCtes.next()) {
                    strRazonsocial = rsCtes.getString("RAZONSOCIAL");
                    strParticipante = rsCtes.getString("PARTICIPANTE");
                    strCorreo = rsCtes.getString("CP_CORREO");
                    //concatenar participantes
                    if (strExt.equals("FAC")) {
                        strSqlParticipante = "select concat(CP_TITULO, ' ',CP_NOMBRE,' ',CP_APPAT,' ',CP_APMAT ) as PARTICIPANTE "
                                + " from cofide_participantes where ct_id = " + strCTE + " and CP_FAC_ID = " + strFac_Tkt;
                    }
                    if (strExt.equals("TKT")) {
                        strSqlParticipante = "select concat(CP_TITULO, ' ',CP_NOMBRE,' ',CP_APPAT,' ',CP_APMAT ) as PARTICIPANTE "
                                + " from cofide_participantes where ct_id = " + strCTE + " and CP_TKT_ID = " + strFac_Tkt;
                    }
                    ResultSet rs = oConn.runQuery(strSqlParticipante, true);
                    while (rs.next()) {
                        strConcatParticipante += rs.getString("PARTICIPANTE") + " / ";
                    }
                    rs.close();
                    //concatenar participantes
                    //termina de concatenar y manda el correo a lso aprticipantes concatenados
                    //mg.MailReservacion(oConn, strCorreo, strParticipante, strRazonsocial, intIdCurso, intID_US);
                    mg.MailReservacion(oConn, strCorreo, strConcatParticipante, strRazonsocial, intIdCurso, intID_US);
                }
                rsCtes.close();
                out.clearBuffer();//Limpiamos buffer
            } //8
            if (strid.equals("9")) {
                String strFac_ID = request.getParameter("fac_id");
                String strTipoDoc = request.getParameter("tipo_doc");
                PagarFactura(oConn, strFac_ID, strTipoDoc); //paga la factura
                String strCT_ID = "";
                String strCurso = "";
                int intCurso_id = 0;
                String strCorreo = "";
                String strParticipante = "";
                String strRazonsocial = "";
                int intID_US = varSesiones.getIntNoUser();
                String strSqlParticipante = "";
                String strConcatParticipante = "";
                String strSqlFac = "";
                String strSqlCte = "";
                String strDOC = "";
                if (strTipoDoc.equals("1")) {
                    strSqlFac = "select * from vta_facturas where FAC_ID = " + strFac_ID;
                    strDOC = "FAC";
                } else {
                    strSqlFac = "select * from vta_tickets where TKT_ID = " + strFac_ID;
                    strDOC = "TKT";
                }
                ResultSet rs = oConn.runQuery(strSqlFac, true);
                while (rs.next()) {
                    strCT_ID = rs.getString("CT_ID");
                    intCurso_id = rs.getInt("CC_CURSO_ID");
                }
                rs.close();
                strSqlCte = "select concat(CP_TITULO, ' ',CP_NOMBRE,' ',CP_APPAT,' ',CP_APMAT ) as PARTICIPANTE, CP_CORREO, "
                        + "(select CT_RAZONSOCIAL from vta_cliente where ct_id = " + strCT_ID + ") as RAZONSOCIAL, CP_MATERIAL_IMPRESO "
                        + "from cofide_participantes where CT_ID = " + strCT_ID + " and CP_" + strDOC + "_ID = " + strFac_ID;
                ResultSet rsCtes;
                rsCtes = oConn.runQuery(strSqlCte, true);
                while (rsCtes.next()) {
                    if (rsCtes.getInt("CP_MATERIAL_IMPRESO") == 1) { //si quieren material impreso, les manda el mail
                        strRazonsocial = rsCtes.getString("RAZONSOCIAL");
                        strParticipante = rsCtes.getString("PARTICIPANTE");
                        strCorreo = rsCtes.getString("CP_CORREO");
                        //if (strExt.equals("FAC")) {
                        strSqlParticipante = "select concat(CP_TITULO, ' ',CP_NOMBRE,' ',CP_APPAT,' ',CP_APMAT ) as PARTICIPANTE "
                                + " from cofide_participantes where ct_id = " + strCT_ID + " and CP_" + strDOC + "_ID = " + strFac_ID;
                        rs = oConn.runQuery(strSqlParticipante, true);
                        while (rs.next()) {
                            strConcatParticipante += rs.getString("PARTICIPANTE") + " / ";
                        }
                        rs.close();

                        mg.MailDescargaMaterial(oConn, strCorreo, strConcatParticipante, strRazonsocial, intCurso_id, intID_US);
                    }
                }
                rsCtes.close();
                String strSQLEXparticipante = "update vta_cliente set CT_ES_PROSPECTO = 0 where CT_ID = " + strCT_ID;
                oConn.runQueryLMD(strSQLEXparticipante);
            } //9
            if (strid.equals("10")) { //10
                String strFac_ID = "";
                String strTDoc = "";
                String strTabla = "";

                strFac_ID = request.getParameter("fac_id");
                strTDoc = request.getParameter("tipo_doc");
                if (strTDoc.equals("FAC")) {
                    strTabla = "vta_facturas";
                } else {
                    strTabla = "vta_tickets";
                }

                String strCancel = "update " + strTabla + " set " + strTDoc + "_ANULADA = 1, "
                        + strTDoc + "_FECHAANUL = '" + fec.getFechaActual() + "', "
                        + "" + strTDoc + "_HORANUL = '" + fec.getHoraActual() + "', "
                        + "" + strTDoc + "_US_ANUL = '" + varSesiones.getIntNoUser() + "' where " + strTDoc + "_ID = " + strFac_ID;
                oConn.runQueryLMD(strCancel);
            } //10

            //Valida si es usuario unbound
            if (strid.equals("11")) { //11
                String strRes = "";
                String strCodigoUser = "";
                try {
                    String strSql = "";
                    strSql = "select COFIDE_CODIGO from usuarios where id_usuarios = " + varSesiones.getIntNoUser();
                    ResultSet rsCod = oConn.runQuery(strSql, true);
                    while (rsCod.next()) {
                        if (rsCod.getString("COFIDE_CODIGO") != "") {
                            strCodigoUser = "OK" + rsCod.getString("COFIDE_CODIGO");
                        }
                    }
                    rsCod.close();
                } catch (SQLException ex) {
                    System.out.println("Error GetBaseUsuario: " + ex.getLocalizedMessage());
                }

                if (strCodigoUser.equals("")) {
                    strCodigoUser = "El Usuario No tiene configurada una Base.";
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strCodigoUser);//Pintamos el resultado
            }//Fin ID 11
        } //fin if strid != null
    }
    oConn.close();

%>

<%!
    public void PagarFactura(Conexion oConn, String strFac_ID, String strTipoDoc) {
        String strSql = "";
        if (strTipoDoc.equals("1")) {
            strSql = "update vta_facturas set FAC_COFIDE_PAGADO = 1 where FAC_ID =" + strFac_ID;
        } else {
            strSql = "update vta_tickets set TKT_COFIDE_PAGADO = 1 where TKT_ID =" + strFac_ID;
        }
        oConn.runQueryLMD(strSql);
    }
%>

<%!
    public void enviaMailMasivo(Conexion oConn, String strPosX, String strTitle, String strFacId, VariableSession varSesiones, String strTipoVta, String strCorreovta1, String strCorreovta2) {

//Respuesta del servicio
        boolean bolEsNC = false;
        //Cargamos datos del mail
        //cuenta_contratada miCuenta = new cuenta_contratada();

        //Recuperamos paths de web.xml
        String strPathXML = this.getServletContext().getInitParameter("PathXml");
        String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";

        //Recibimos parametros
        String strlstFAC_ID = "";
        String strVIEW_COPIA = "";
        String strVIEW_ASUNTO = "";
        String strVIEW_MAIL = "";//mail del cliente
        String strVIEW_CC = "1";
        String strMailCte = "";
        String strMailCte2 = "";
        int intVIEW_Templete = 1;

        if (strVIEW_COPIA == null) {
            strVIEW_COPIA = "";
        }
        if (strVIEW_CC == null) {
            strVIEW_CC = "1";
        }
//consulta a la cuenta de correo del varsessiones -------------------------
        int intUsuario = varSesiones.getIntNoUser();
        String strNombre = "";
        String strUsuario = "";
        String strPassword = "";
        String strDominio = "";
        String strPuerto = "";
        int intSSL = 0;
        int intSSSL = 0;
        String strSqlCuentaEjecutivo = "select nombre_usuario, SMTP, PORT, SMTP_US, SMTP_PASS, SMTP_USATLS, SMTP_USASTLS from usuarios where id_usuarios = " + intUsuario;
        try {
            ResultSet rsCuenta = oConn.runQuery(strSqlCuentaEjecutivo, true);
            while (rsCuenta.next()) {
                strNombre = rsCuenta.getString("nombre_usuario");
                strDominio = rsCuenta.getString("SMTP");
                strPuerto = rsCuenta.getString("PORT");
                strUsuario = rsCuenta.getString("SMTP_US");
                strPassword = rsCuenta.getString("SMTP_PASS");
                intSSL = rsCuenta.getInt("SMTP_USATLS");
                intSSSL = rsCuenta.getInt("SMTP_USASTLS");
            }
            rsCuenta.close();
        } catch (SQLException e) {
            System.out.println("Obtiene Datos para el ENVIO - MAIL: " + e.getLocalizedMessage());
        }
        String strSmtpServer = strDominio;
        String strSmtpUser = strUsuario;
        String strSmtpPassword = strPassword;
        String strSmtpPort = strPuerto;
        int intSmtpUsaSSL = intSSL;
        int intSmtpUsaSSSL = intSSSL;
        //Validamos que todos los datos del mail esten completos
        if (!strSmtpServer.equals("")
                && !strSmtpUser.equals("")
                && !strSmtpPassword.equals("")
                && !strSmtpPort.equals("")) {
            //Recorremos las operaciones seleccionado
            //Recuperamos la factura
            int intFAC_ID = 0;
            try {
                intFAC_ID = Integer.valueOf(strFacId);
            } catch (NumberFormatException ex) {
            }
            //Resultado
            String strResp = "OK";
            String strCode = "OK";
            boolean bolIsOkFacPDF = false;
            //Obtenemos el folio
            String strNumFolio = "";
            int intEMP_TIPOCOMP = 0;
            int intEMP_ID = 0;
            int intCT_ID = 0;
            String strFAC_NOMFORMATO = "";
            String strFAC_RAZONSOCIAL = "";
            String strFAC_FECHA = "";
            int intFAC_ES_CFD = 0;
            int intFAC_ES_CBB = 0;
            String strSql = "";
            // si strTipoVta == 1 es Factura
            if (strTipoVta.equals("1")) {
                strSql = "select FAC_ID,CT_ID,FAC_FOLIO,FAC_TIPOCOMP,FAC_NOMFORMATO,EMP_ID,FAC_RAZONSOCIAL,FAC_FECHA,FAC_ES_CFD,FAC_ES_CBB from vta_facturas where FAC_ID = " + intFAC_ID;
            }
            // si strTipoVta == 2 es Ticket
            if (strTipoVta.equals("2")) {
                strSql = "select TKT_ID,CT_ID,TKT_FOLIO,TKT_TIPOCOMP, TKT_NOMFORMATO,EMP_ID,TKT_RAZONSOCIAL,TKT_FECHA from vta_tickets where TKT_ID = " + intFAC_ID;
            }
            //Recuperamos el numero de folio que queremos imprimir
            if (bolEsNC) {
                strSql = "select CT_ID,NC_FOLIO,NC_TIPOCOMP,NC_NOMFORMATO,EMP_ID,NC_RAZONSOCIAL,NC_FECHA,NC_ES_CFD,NC_ES_CBB from vta_ncredito where NC_ID = " + intFAC_ID;
            }
            try {
                ResultSet rs = oConn.runQuery(strSql, true);
                //Buscamos el nombre del archivo
                while (rs.next()) {
                    //System.out.println("VENTA: " + strTipoVta);
                    if (strTipoVta.equals("1")) { //fac
                        //System.out.println("ENTRO FACTURA ");
                        //if (!bolEsNC) {
                        strNumFolio = rs.getString("FAC_FOLIO");
                        intEMP_TIPOCOMP = rs.getInt("FAC_TIPOCOMP");
                        intEMP_ID = rs.getInt("EMP_ID");
                        intCT_ID = rs.getInt("CT_ID");
                        strFAC_NOMFORMATO = rs.getString("FAC_NOMFORMATO");
                        strFAC_RAZONSOCIAL = rs.getString("FAC_RAZONSOCIAL");
                        strFAC_FECHA = rs.getString("FAC_FECHA");
                        intFAC_ES_CFD = rs.getInt("FAC_ES_CFD");
                        intFAC_ES_CBB = rs.getInt("FAC_ES_CBB");
                        //}
                    } else {
                        if (strTipoVta.equals("2")) { //tkt
                            //System.out.println("ENTRO TICKETS ");
                            //if (!bolEsNC) {
                            strNumFolio = rs.getString("TKT_FOLIO");
                            intEMP_TIPOCOMP = rs.getInt("TKT_TIPOCOMP");
                            intEMP_ID = rs.getInt("EMP_ID");
                            intCT_ID = rs.getInt("CT_ID");
                            strFAC_NOMFORMATO = "";
                            strFAC_RAZONSOCIAL = rs.getString("TKT_RAZONSOCIAL");
                            strFAC_FECHA = rs.getString("TKT_FECHA");
                            intFAC_ES_CFD = 0;
                            intFAC_ES_CBB = 0;
                            //}
                        } else {
                            strNumFolio = rs.getString("NC_FOLIO");
                            intEMP_TIPOCOMP = rs.getInt("NC_TIPOCOMP");
                            intEMP_ID = rs.getInt("EMP_ID");
                            intCT_ID = rs.getInt("CT_ID");
                            strFAC_NOMFORMATO = rs.getString("NC_NOMFORMATO");
                            strFAC_RAZONSOCIAL = rs.getString("NC_RAZONSOCIAL");
                            strFAC_FECHA = rs.getString("NC_FECHA");
                            intFAC_ES_CFD = rs.getInt("NC_ES_CFD");
                            intFAC_ES_CBB = rs.getInt("NC_ES_CBB");
                        }
                    }

                }
                rs.close();
                //Buscamos si EL CLIENTE tiene mail

                strSql = "select CT_EMAIL1,CT_EMAIL2 from vta_cliente where CT_ID = " + intCT_ID;
                rs = oConn.runQuery(strSql, true);
                //Buscamos el nombre del archivo
                while (rs.next()) {
                    if (strVIEW_CC.equals("1")) {
                        strMailCte = rs.getString("CT_EMAIL1");
                        strMailCte2 = rs.getString("CT_EMAIL2");
                    }
                }
                rs.close();
                //System.out.println(strCorreovta1 + " correo al que se le facturo");
//destinatarios proporcionados en la venta
                strMailCte = strCorreovta1;
                strMailCte2 = strCorreovta2;
//destinatarios proporcionados en la venta

            } catch (SQLException ex) {
                System.out.println(". . . ..  Error al enviar mail 1 " + ex.getMessage());
            }

//agregamos el correo del ejecutivo como copia
            strVIEW_COPIA = strUsuario;
            //Si el cliente tiene mail lo enviamos
            if (!strMailCte.equals("") || !strVIEW_COPIA.equals("")) {
                //Mail personalizado
                String strMailOK = new String(strVIEW_MAIL);
                strMailOK = strMailOK.replace("[FOLIO]", strNumFolio);
                strMailOK = strMailOK.replace("[RAZONSOCIAL]", strFAC_RAZONSOCIAL);
                strMailOK = strMailOK.replace("[FECHA]", strFAC_FECHA);
                strMailOK = strMailOK.replace("[MES]", strFAC_FECHA.substring(5, 6));
                String strMailASOK = new String(strVIEW_ASUNTO);
                strMailASOK = strMailASOK.replace("[FOLIO]", strNumFolio);
                strMailASOK = strMailASOK.replace("[RAZONSOCIAL]", strFAC_RAZONSOCIAL);
                strMailASOK = strMailASOK.replace("[FECHA]", strFAC_FECHA);
                strMailASOK = strMailASOK.replace("[MES]", strFAC_FECHA.substring(5, 6));

                //Lista de correo alos que se los enviaremos
                String strEmailSend = "";
                if (!strMailCte.equals("")) {
                    strEmailSend = strMailCte;
                }
                if (!strMailCte2.equals("")) {
                    if (!strMailCte.equals("")) {
                        strEmailSend += ",";
                    }
                    strEmailSend += strMailCte2;
                }
                if (!strVIEW_COPIA.equals("")) {
                    if (!strMailCte.equals("") || !strMailCte2.equals("")) {
                        strEmailSend += ",";
                    }
                    strEmailSend += strVIEW_COPIA;
                }
                //Buscamos si la empresa usa CBB
                int intEMP_USACODBARR = 0;
                int intEMP_CFD_CFDI = 0;
                strSql = "select EMP_USACODBARR,EMP_CFD_CFDI from vta_empresas where EMP_ID = " + intEMP_ID;
                try {
                    ResultSet rs = oConn.runQuery(strSql, true);
                    //Buscamos el nombre del archivo
                    while (rs.next()) {
                        intEMP_USACODBARR = rs.getInt("EMP_USACODBARR");
                        intEMP_CFD_CFDI = rs.getInt("EMP_CFD_CFDI");
                    }
                    rs.close();
                } catch (SQLException ex) {

                }
                ERP_MapeoFormato mapeo = new ERP_MapeoFormato(intEMP_TIPOCOMP);
                String strNomFormato = mapeo.getStrNomFormato();
                if (intEMP_USACODBARR == 1) {
                    strNomFormato += "_CBB";
                }
                if (intEMP_CFD_CFDI == 1 && intFAC_ES_CFD == 0 && intFAC_ES_CBB == 0) {
                    strNomFormato += "_cfdi";
                }
                //Nombres de archivos
                String strFilePdf = strPathXML + "/" + strNomFormato + "_" + intEMP_ID + "_" + strNumFolio + ".pdf";
                String strFileXML = strPathXML + "/" + "XmlSAT" + intFAC_ID + " .xml";
                if (bolEsNC) {
                    strFileXML = strPathXML + "/" + "NC_XML" + intFAC_ID + ".xml";
                }
                //Generamos el formato de impresion
                try {
                    Document document = new Document();
                    PdfWriter writer = PdfWriter.getInstance(document,
                            new FileOutputStream(strFilePdf));
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
                    FormateadorMasivo format = new FormateadorMasivo();
                    format.setBolSeisxHoja(true);
                    format.setIntTypeOut(Formateador.FILE);
                    format.setStrPath(this.getServletContext().getRealPath("/"));
                    format.InitFormat(oConn, strNomFormato);
                    String strRes = format.DoFormat(oConn, intFAC_ID);
                    if (strRes.equals("OK")) {
                        CIP_Formato fPDF = new CIP_Formato();
                        fPDF.setDocument(document);
                        fPDF.setWriter(writer);
                        fPDF.setBolSeisxHoja(true);
                        fPDF.setStrPathFonts(strPathFonts);
                        fPDF.EmiteFormatoMasivo(format.getFmXML());
                        document.close();
                        bolIsOkFacPDF = true;
                    }
                } catch (Exception ex) {
                    System.out.println("error generar formato " + ex.getMessage());
                }
                //Mandamos el mail
                Mail mail = new Mail();
                mail.setBolDepuracion(false);
                if (intSmtpUsaSSL == 1) {
                    mail.setBolUsaTls(true);
                }
                if (intSmtpUsaSSSL == 1) {
                    mail.setBolUsaStartTls(true);
                }
                mail.setHost(strSmtpServer);
                mail.setUsuario(strSmtpUser);
                mail.setContrasenia(strSmtpPassword);
                mail.setPuerto(strSmtpPort);
                //Adjuntamos archivos
                mail.setFichero(strFilePdf);
                if (intEMP_USACODBARR == 0) {
                    //Validamos si existe el archivo con el formato viejo
                    File file = new File(strFileXML);//specify the file path 
                    if (!file.exists()) {
                        //Version 2.0
                        StringBuilder strNomFile = new StringBuilder("");
                        ERP_MapeoFormato mapeoXml = null;
                        mapeoXml = new ERP_MapeoFormato(1);
                        strFileXML = strPathXML + (getNombreFileXml(mapeoXml, intFAC_ID, strFAC_RAZONSOCIAL, strFAC_FECHA, strNumFolio));
                    }
                    mail.setFichero(strFileXML);
                }
                if (intVIEW_Templete == 1) {

                    String[] lstMail = getMailTemplate("FACTURA", oConn);
                    String strMsgAsunto = lstMail[0].replace("%folio%", strNumFolio);
//                    String strMsgMensaje = lstMail[1].replace("%folio%", strNumFolio);
                    String strMsgMensaje = lstMail[1].replace("%folio%", strNumFolio).replace("%CT_RAZONSOCIAL%", strFAC_RAZONSOCIAL);

                    mail.setAsunto(strMsgAsunto);
                    //Preparamos el mail
                    mail.setDestino(strEmailSend);
                    System.out.println(strEmailSend + " emails a los que se les enviara!!!! ------------------------------------------");
                    mail.setMensaje(strMsgMensaje);

                    //Reemplazamos campos personalizados
                    String strSqlMail = "select * from vta_facturas where FAC_ID = " + intFAC_ID;

                    ResultSet rsMail;
                    try {
                        rsMail = oConn.runQuery(strSqlMail, true);
                        mail.setReplaceContent(rsMail);
                    } catch (SQLException ex) {
                        System.out.println(ex);
                    } catch (Exception ex) {
                        System.out.println(ex);
                    }
                    //Reemplazamos campos personalizados en la empresa...
                    strSqlMail = "select * from vta_empresas where EMP_ID = " + varSesiones.getIntIdEmpresa();
                    try {
                        rsMail = oConn.runQuery(strSqlMail, true);
                        mail.setReplaceContent(rsMail);
                    } catch (SQLException ex) {
                        System.out.println(ex);
                    } catch (Exception ex) {
                        System.out.println(ex);
                    }

                } else {
                    mail.setAsunto(strMailASOK);
                    //Preparamos el mail
                    System.out.println(strEmailSend + " destinatario del correo---------------------------------------");
                    mail.setDestino(strEmailSend);
                    mail.setMensaje(strMailOK);
                }

                //Enviamos el mail
                boolean bol = mail.sendMail();//
                if (!bol) {
                    strResp = "NO SE PUDO ENVIAR EL MAIL.";
                }
            } else {
                strResp = "NO EXISTEN MAILS.";
            }
        }
        //return intFAC_ID;
    }
%>


<%!    /**
     * Obtenemos los valores del template para el mail
     *
     * @param strNom Es el nombre del template
     * @return Regresa un arreglo con los valores del template
     */
    public String[] getMailTemplate(String strNom, Conexion oConn) {
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
            System.out.println(ex.getErrorCode());
        }

        return listValores;
    }
%>

<%!   /**
     * Genera el nombre del xml
     */
    public String getNombreFileXml(ERP_MapeoFormato mapeo, int intTransaccion, String strNombreReceptor, String strFechaCFDI, String strFolioFiscalUUID) {
        String strNomFileXml = null;
        String strPatronNomXml = mapeo.getStrNomXML("NOMINA");
        strNomFileXml = strPatronNomXml.replace("%Transaccion%", intTransaccion + "").replace("", "").replace("%nombre_receptor%", strNombreReceptor).replace("%fecha%", strFechaCFDI).replace("%UUID%", strFolioFiscalUUID).replace(" ", "_");
        return strNomFileXml;
    }

    public boolean isUserInBound(Conexion oConn, int intNoUser) {
        String strCodigoUser = "";
        boolean isInBound = false;
        try {
            String strSql = "";
            strSql = "select COFIDE_CODIGO from usuarios where id_usuarios = " + intNoUser;
            ResultSet rsCod = oConn.runQuery(strSql, true);
            while (rsCod.next()) {
                strCodigoUser = rsCod.getString("COFIDE_CODIGO");
            }
            rsCod.close();
        } catch (SQLException ex) {
            System.out.println("Es usuario INBOUND: [ERROR:] " + ex.getLocalizedMessage());
        }
        if (strCodigoUser.equals("INBOUND")) {
            isInBound = true;
        } else {
            isInBound = false;
        }
        return isInBound;
    }
%>