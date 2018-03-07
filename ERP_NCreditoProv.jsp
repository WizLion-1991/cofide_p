<%-- 
    Document   : ERP_NCredito de proveedores
    Este jsp se encarga de ejecutar las operaciones(modelo) del modelo vista diseño
      para las notas de credito
    Created on : 2/05/2011, 01:12:41 PM
    Author     : zeus
--%>

<%@page import="ERP.NCreditoProv"%>
<%@page import="Tablas.vta_facturadeta"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="Tablas.vta_facturas"%>
<%@page import="comSIWeb.Operaciones.Reportes.CIP_Formato"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="ERP.ERP_MapeoFormato"%>
<%@page import="comSIWeb.Operaciones.Formatos.Formateador"%>
<%@page import="comSIWeb.Operaciones.Formatos.FormateadorMasivo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Tablas.vta_ncreditodeta_prov"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="ERP.NCredito"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Inicializamos datos
        Fechas fecha = new Fechas();
        //Recuperamos paths de web.xml
        String strPathXML = this.getServletContext().getInitParameter("PathXml");
        String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
        String strmod_Inventarios = this.getServletContext().getInitParameter("mod_Inventarios");
        String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
        String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
        String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
        if (strSist_Costos == null) {
            strSist_Costos = "0";
        }
        if (strfolio_GLOBAL == null) {
            strfolio_GLOBAL = "SI";
        }
        if (strmod_Inventarios == null) {
            strmod_Inventarios = "NO";
        }
        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            //Genera una nueva operacion de ventas
            if (strid.equals("1")) {
                System.out.println("Esyoy aui jajjja ");
                //Instanciamos el objeto que generara la venta
                NCreditoProv ncredito = new NCreditoProv(oConn, varSesiones, request);
                ncredito.setStrPATHKeys(strPathPrivateKeys);
                ncredito.setStrPATHXml(strPathXML);
                ncredito.setStrPATHFonts(strPathFonts);
                //Desactivamos inventarios
                if (strmod_Inventarios.equals("NO")) {
                    ncredito.setBolAfectaInv(false);
                }
                ncredito.initMyPass(this.getServletContext());
                //Definimos el sistema de costos
                try {
                    ncredito.setIntSistemaCostos(Integer.valueOf(strSist_Costos));
                } catch (NumberFormatException ex) {
                    System.out.println("No hay sistema de costos definido");
                }
                //Recibimos parametros
                String strPrefijoMaster = "NC";
                String strPrefijoDeta = "NCD";
                //Validamos si tenemos un empresa seleccionada
                if (varSesiones.getIntIdEmpresa() != 0) {
                    //Asignamos la empresa seleccionada
                    ncredito.setIntEMP_ID(varSesiones.getIntIdEmpresa());
                }
                //Validamos si usaremos un folio global
                if (strfolio_GLOBAL.equals("NO")) {
                    ncredito.setBolFolioGlobal(false);
                }
                ncredito.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                ncredito.getDocument().setFieldInt("PV_ID", Integer.valueOf(request.getParameter("PV_ID")));
                if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                    ncredito.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", 1);
                } else {
                    ncredito.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
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
                    System.out.println("ERP_NCREDITOPROV TI_ID " + ex.getMessage());
                }
                //Tipo de comprobante
              /*  int intFAC_TIPOCOMP = 0;
                 try {
                 intFAC_TIPOCOMP = Integer.valueOf(request.getParameter(strPrefijoMaster + "_TIPOCOMP"));
                 } catch (NumberFormatException ex) {
                 System.out.println("ERP_NCREDITO NC_TIPOCOMP " + ex.getMessage());
                 }*/
                //Asignamos los valores al objeto
                ncredito.getDocument().setFieldInt("TI_ID", intTI_ID);
                ncredito.getDocument().setFieldInt("TI_ID2", intTI_ID2);
                ncredito.getDocument().setFieldInt("TI_ID3", intTI_ID3);

                //  ncredito.setIntFAC_TIPOCOMP(intFAC_TIPOCOMP);
                ncredito.getDocument().setFieldInt(strPrefijoMaster + "_ESSERV", Integer.valueOf(request.getParameter(strPrefijoMaster + "_ESSERV")));
                ncredito.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA"), "/"));
                ncredito.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
                ncredito.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", request.getParameter(strPrefijoMaster + "_NOTAS"));
                ncredito.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", request.getParameter(strPrefijoMaster + "_NOTASPIE"));

                ncredito.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));
                // ncredito.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE").replace(",", "")));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO1").replace(",", "")));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO2").replace(",", "")));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO3").replace(",", "")));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(request.getParameter(strPrefijoMaster + "_TOTAL").replace(",", "")));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA1")));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA2")));
                ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA3")));
                ncredito.getDocument().setFieldInt(strPrefijoMaster + "_SC_ID2", Integer.valueOf(request.getParameter(strPrefijoMaster + "_SC_ID2")));
                /* if (request.getParameter(strPrefijoMaster + "_METODOPAGO") != null) {
                 ncredito.getDocument().setFieldString(strPrefijoMaster + "_METODODEPAGO", request.getParameter(strPrefijoMaster + "_METODOPAGO"));
                 }
                 if (request.getParameter(strPrefijoMaster + "_NUMCUENTA") != null) {
                 ncredito.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", request.getParameter(strPrefijoMaster + "_NUMCUENTA"));
                 }*/

                if (request.getParameter(strPrefijoMaster + "_TASAPESO") != null) {
                    if (Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")) == 0) {
                        ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                    } else {
                        ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")));
                    }
                } else {
                    ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                }
                //Datos de la aduana
                // ncredito.getDocument().setFieldString(strPrefijoMaster + "_NUMPEDI", request.getParameter(strPrefijoMaster + "_NUMPEDI"));
                //ncredito.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", request.getParameter(strPrefijoMaster + "_FECHAPEDI"));
                //  ncredito.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", request.getParameter(strPrefijoMaster + "_ADUANA"));
                //Si no hay moneda seleccionada que ponga tasa 1
                if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                    ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                }
                //Validamos IEPS
                if (request.getParameter(strPrefijoMaster + "_USO_IEPS") != null) {
                    try {
                        ncredito.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_USO_IEPS")));
                        ncredito.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TASA_IEPS")));
                        ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE_IEPS")));
                    } catch (NumberFormatException ex) {
                    }
                }
                //Validamos parametros para recibos de honorarios}
                if (request.getParameter(strPrefijoMaster + "_RETISR") != null) {
                    ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_RETISR", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETISR")));
                }
                if (request.getParameter(strPrefijoMaster + "_RETIVA") != null) {
                    ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_RETIVA", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETIVA")));
                }
                if (request.getParameter(strPrefijoMaster + "_NETO") != null) {
                    ncredito.getDocument().setFieldDouble(strPrefijoMaster + "_NETO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NETO")));
                }
                //Opciones de facturacion recurrente
               /* if (request.getParameter(strPrefijoMaster + "_ESRECU") != null) {
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
                 ncredito.getDocument().setFieldInt(strPrefijoMaster + "_ESRECU", intEsRecu);
                 ncredito.getDocument().setFieldInt(strPrefijoMaster + "_PERIODICIDAD", intPeriodicidad);
                 ncredito.getDocument().setFieldInt(strPrefijoMaster + "_DIAPER", intDiaPer);
                 }
                 //Recibimos el regimel fiscal
                 /*  if (request.getParameter(strPrefijoMaster + "_REGIMENFISCAL") != null) {
                 ncredito.getDocument().setFieldString(strPrefijoMaster + "_REGIMENFISCAL", request.getParameter(strPrefijoMaster + "_REGIMENFISCAL"));
                 }*/
                //Recibimos el ID de la factura
                if (request.getParameter("FAC_ID") != null) {

                    ncredito.getDocument().setFieldInt("CXP_ID", Integer.valueOf(request.getParameter("FAC_ID")));
                }

                //Validamos si tenemos un empresa seleccionada
                if (varSesiones.getIntIdEmpresa() != 0) {
                    //Asignamos la empresa seleccionada
                    ncredito.getDocument().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
                }
                //Recibimos datos de los items o partidas
                int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));

                for (int i = 1; i <= intCount; i++) {
                    TableMaster deta = new vta_ncreditodeta_prov();
                    boolean bolValido = false;
                    try {
                        /*intCant1 = Integer.valueOf(request.getParameter(strPrefijoDeta + "_CAN_DEV" + i));
                         intCant2 = Integer.valueOf(request.getParameter(strPrefijoDeta + "_DEVOLVER" + i));

                         strUpdateFacDeta = "UPDATE vta_facturasdeta SET "
                         + " FACD_CAN_DEV =" + (intCant1 + intCant2)
                         + " ,FACD_SERIES_DEV ='" + request.getParameter(strPrefijoDeta + "_SERIES_DEV" + i) + "' "
                         + " WHERE FACD_ID = " + request.getParameter("FACD_ID" + i);
                         oConn.runQueryLMD(strUpdateFacDeta);*/
                        if (request.getParameter(strPrefijoDeta + "_DEVOLVER" + i) == null) {
                            deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", 1);
                        } else {
                            deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", Double.valueOf(request.getParameter(strPrefijoDeta + "_DEVOLVER" + i)));
                        }

                        deta.setFieldInt("FACD_ID", Integer.valueOf(request.getParameter("FACD_ID" + i)));
                        deta.setFieldString(strPrefijoDeta + "_NOSERIE", request.getParameter(strPrefijoDeta + "_SERIES_DEV" + i));

                    } catch (NumberFormatException ex) {
                        System.out.println(ex.getMessage());
                        try {
                            if (request.getParameter(strPrefijoDeta + "_CANTIDAD" + i) != null) {
                                deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", Double.valueOf(request.getParameter(strPrefijoDeta + "_CANTIDAD" + i)));
                            }
                        } catch (NumberFormatException ex2) {
                            System.out.println(ex2.getMessage());
                        }
                    }
                    //Validamos si tiene una cantidad a devolver solo consideraremos los que se van a devolver
                    if (deta.getFieldDouble(strPrefijoDeta + "_CANTIDAD") > 0) {
                        bolValido = true;
                    }

                    deta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                    deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO1" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO2" + i)));
                    deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO3" + i)));
                    deta.setFieldString(strPrefijoDeta + "_CVE", request.getParameter(strPrefijoDeta + "_CVE" + i));
                    deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", request.getParameter(strPrefijoDeta + "_DESCRIPCION" + i));

                    deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPORTE" + i)));

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
                    deta.setFieldString(strPrefijoDeta + "_COMENTARIO", request.getParameter(strPrefijoDeta + "_NOTAS" + i));
                    //deta.setFieldString(strPrefijoDeta + "_SCDESTINO", request.getParameter(strPrefijoDeta + "_SCDESTINO" + i));
                    if (bolValido) {
                        ncredito.AddDetalle(deta);
                    }
                }

                ncredito.Init();
                //Generamos transaccion
                ncredito.doTrx();
                String strRes = "";
                if (ncredito.getStrResultLast().equals("OK")) {
                    strRes = "OK." + ncredito.getDocument().getValorKey();
                } else {
                    strRes = ncredito.getStrResultLast();
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            //Anula la operacion
            if (strid.equals("2")) {
                //Instanciamos el ticvet
                NCreditoProv ncredito = new NCreditoProv(oConn, varSesiones, request);
                ncredito.setStrPATHKeys(strPathPrivateKeys);
                ncredito.setStrPATHXml(strPathXML);
                ncredito.initMyPass(this.getServletContext());

                //Recibimos parametros
                String strPrefijoMaster = "NC";
                //Asignamos el id de la operacion por anular
                String strIdAnul = request.getParameter("idAnul");
                int intId = 0;
                if (strIdAnul == null) {
                    strIdAnul = "0";
                }
                intId = Integer.valueOf(strIdAnul);
                ncredito.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
                ncredito.Init();
                ncredito.doTrxAnul();
                String strRes = ncredito.getStrResultLast();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            //Impresion Masiva de Notas de credito
            if (strid.equals("4")) {
                /*Definimos parametros de la aplicacion*/
                String strFAC_FOLIO1 = request.getParameter("NC_FOLIO1");
                if (strFAC_FOLIO1 == null) {
                    strFAC_FOLIO1 = "";
                }
                String strFAC_FOLIO2 = request.getParameter("NC_FOLIO2");
                if (strFAC_FOLIO2 == null) {
                    strFAC_FOLIO2 = "";
                }
                String strFAC_FECHA1 = request.getParameter("NC_FECHA1");
                if (strFAC_FECHA1 == null) {
                    strFAC_FECHA1 = "";
                } else {
                    strFAC_FECHA1 = fecha.FormateaBD(strFAC_FECHA1, "/");
                }
                String strFAC_FECHA2 = request.getParameter("NC_FECHA2");
                if (strFAC_FECHA2 == null) {
                    strFAC_FECHA2 = "";
                } else {
                    strFAC_FECHA2 = fecha.FormateaBD(strFAC_FECHA2, "/");
                }
                int intEMP_ID = 0;
                int intSC_ID = 0;
                int intTipo_Comp = 0;
                if (request.getParameter("EMP_ID") != null) {
                    try {
                        intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
                    } catch (NumberFormatException ex) {
                        System.out.println("ERROR:" + ex.getMessage());
                    }
                }
                if (request.getParameter("SC_ID") != null) {
                    try {
                        intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
                    } catch (NumberFormatException ex) {
                        System.out.println("ERROR:" + ex.getMessage());
                    }
                }
                if (request.getParameter("NC_TIPOCOMP") != null) {
                    try {
                        intTipo_Comp = Integer.valueOf(request.getParameter("NC_TIPOCOMP"));
                    } catch (NumberFormatException ex) {
                        System.out.println("ERROR:" + ex.getMessage());
                    }
                }
                //Filtro para el reporte
                String strFiltro = " AND vta_ncredito.EMP_ID = " + intEMP_ID;
                if (!strFAC_FOLIO1.equals("") && !strFAC_FOLIO2.equals("")) {
                    strFiltro += " AND NC_FOLIO>='" + strFAC_FOLIO1 + "' AND NC_FOLIO<='" + strFAC_FOLIO1 + "' ";
                } else {
                    if (!strFAC_FECHA1.equals("") && !strFAC_FECHA2.equals("")) {
                        strFiltro += " AND NC_FECHA>='" + strFAC_FECHA1 + "' AND NC_FECHA<='" + strFAC_FECHA2 + "' ";
                    }
                }
                if (intSC_ID != 0) {
                    strFiltro += " AND SC_ID = " + intSC_ID;
                }
                //Buscamos si la empresa usa CBB
                int intEMP_USACODBARR = 0;
                String strSql = "select EMP_USACODBARR from vta_empresas where EMP_ID = " + intEMP_ID;
                ResultSet rs = oConn.runQuery(strSql, true);
                //Buscamos el nombre del archivo
                while (rs.next()) {
                    intEMP_USACODBARR = rs.getInt("EMP_USACODBARR");
                }
                rs.close();
                /**
                 * Formateador Masivo
                 */
                FormateadorMasivo format = new FormateadorMasivo();
                format.setIntTypeOut(Formateador.OBJECT);
                format.setStrPath(this.getServletContext().getRealPath("/"));
                //Seleccionamos el tipo de comprobante
                ERP_MapeoFormato mapeo = new ERP_MapeoFormato(intTipo_Comp);
                String strNomFormato = mapeo.getStrNomFormato();
                if (intEMP_USACODBARR == 1) {
                    strNomFormato += "_CBB";
                }
                format.InitFormat(oConn, strNomFormato);
                String strRes = format.DoFormat(oConn, strFiltro);
                if (strRes.equals("OK") && format.getIntNumRows() > 0) {
                    //Documento donde guardaremos el formato
                    Document document = new Document();
                    PdfWriter writer = PdfWriter.getInstance(document,
                            response.getOutputStream());
                    document.open();
                    //Definimos parametros para que el cliente sepa que es un PDF
                    response.setContentType("application/pdf");
                    response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "Masivo.pdf");
                    response.setHeader("cache-control", "no-cache");
                    CIP_Formato fPDF = new CIP_Formato();
                    fPDF.setDocument(document);
                    fPDF.setWriter(writer);
                    fPDF.setStrPathFonts(strPathFonts);
                    fPDF.EmiteFormatoMasivo(format.getFmXML());
                    document.close();
                    writer.close();
                } else {
                    response.setContentType("text/plain");
                    response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + ".txt");
                    response.setHeader("cache-control", "no-cache");
                    if (!strRes.equals("OK")) {
                        out.println(strRes);
                    } else {
                        out.println("NO HAY DOCUMENTOS POR IMPRIMIR...");
                    }
                }
            }
            //Regresa los datos de la factura para devolver piezas
            if (strid.equals("5")) {
                String strFAC_ID = "";
                if (strFAC_ID == null) {
                    strFAC_ID = "0";
                }
                strFAC_ID = request.getParameter("FAC_ID");

                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
                String[] lstFacturas = strFAC_ID.split(",");
                if (lstFacturas.length > 1) {
                    strXML.append("<vta_facturas> ");
                }
                for (int iFac = 0; iFac < lstFacturas.length; iFac++) {
                    strXML.append("<vta_factura ");
                    //Recuperamos info de pedidos
                    vta_facturas factura = new vta_facturas();
                    factura.ObtenDatos(Integer.valueOf(lstFacturas[iFac]), oConn);
                    String strValorPar = factura.getFieldPar();
                    strXML.append(strValorPar + " > ");
                    //Obtenemos el detalle
                    vta_facturadeta deta = new vta_facturadeta();
                    ArrayList<TableMaster> lstDeta = deta.ObtenDatosVarios(" FAC_ID = " + factura.getFieldInt("FAC_ID"), oConn);
                    Iterator<TableMaster> it = lstDeta.iterator();
                    ResultSet rs = null;
                    String strSql;
                    while (it.hasNext()) {
                        TableMaster tbn = it.next();
                        int intPR_REQEXIST = 0;
                        double dblExistencia = 0;
                        String strPR_CODBARRAS = "";
                        int intPR_USO_NOSERIE = 0;
                        int intPR_CATEGORIA1 = 0;
                        int intPR_CATEGORIA2 = 0;
                        int intPR_CATEGORIA3 = 0;
                        int intPR_CATEGORIA4 = 0;
                        int intPR_CATEGORIA5 = 0;
                        int intPR_CATEGORIA6 = 0;
                        int intPR_CATEGORIA7 = 0;
                        int intPR_CATEGORIA8 = 0;
                        int intPR_CATEGORIA9 = 0;
                        int intPR_CATEGORIA10 = 0;
                        //Consultamos la existencia y si requiera de existencia para su venta
                        strSql = "select PR_REQEXIST,PR_EXISTENCIA,PR_CODBARRAS,PR_USO_NOSERIE "
                                + ",PR_CATEGORIA1,PR_CATEGORIA2,PR_CATEGORIA3,PR_CATEGORIA4,PR_CATEGORIA5,"
                                + "PR_CATEGORIA6,PR_CATEGORIA7,PR_CATEGORIA8,PR_CATEGORIA9,PR_CATEGORIA10 "
                                + " from vta_producto where PR_ID = " + tbn.getFieldInt("PR_ID");
                        rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            intPR_REQEXIST = rs.getInt("PR_REQEXIST");
                            dblExistencia = rs.getDouble("PR_EXISTENCIA");
                            strPR_CODBARRAS = rs.getString("PR_CODBARRAS");
                            intPR_USO_NOSERIE = rs.getInt("PR_USO_NOSERIE");
                            intPR_CATEGORIA1 = rs.getInt("PR_CATEGORIA1");
                            intPR_CATEGORIA2 = rs.getInt("PR_CATEGORIA2");
                            intPR_CATEGORIA3 = rs.getInt("PR_CATEGORIA3");
                            intPR_CATEGORIA4 = rs.getInt("PR_CATEGORIA4");
                            intPR_CATEGORIA5 = rs.getInt("PR_CATEGORIA5");
                            intPR_CATEGORIA6 = rs.getInt("PR_CATEGORIA6");
                            intPR_CATEGORIA7 = rs.getInt("PR_CATEGORIA7");
                            intPR_CATEGORIA8 = rs.getInt("PR_CATEGORIA8");
                            intPR_CATEGORIA9 = rs.getInt("PR_CATEGORIA9");
                            intPR_CATEGORIA10 = rs.getInt("PR_CATEGORIA10");
                        }
                        rs.close();
                        strXML.append("<deta ");
                        strXML.append(tbn.getFieldPar() + " PR_REQEXIST = \"" + intPR_REQEXIST + "\" PR_USO_NOSERIE=\"" + intPR_USO_NOSERIE + "\" "
                                + " PR_EXISTENCIA=\"" + dblExistencia + "\" PR_CODBARRAS=\"" + strPR_CODBARRAS + "\""
                                + " PR_CAT1 = \"" + intPR_CATEGORIA1 + "\"  "
                                + " PR_CAT2 = \"" + intPR_CATEGORIA2 + "\"  "
                                + " PR_CAT3 = \"" + intPR_CATEGORIA3 + "\"  "
                                + " PR_CAT4 = \"" + intPR_CATEGORIA4 + "\"  "
                                + " PR_CAT5 = \"" + intPR_CATEGORIA5 + "\"  "
                                + " PR_CAT6 = \"" + intPR_CATEGORIA6 + "\"  "
                                + " PR_CAT7 = \"" + intPR_CATEGORIA7 + "\"  "
                                + " PR_CAT8 = \"" + intPR_CATEGORIA8 + "\"  "
                                + " PR_CAT9 = \"" + intPR_CATEGORIA9 + "\"  "
                                + " PR_CAT10 = \"" + intPR_CATEGORIA10 + "\"  ");
                        //Si usa numeros de serie buscamos los numeros de serie vinculados al surtimiento de este pedido(en caso de aplicar)

                        String strSeriesDev = "";
                        int intCantDev = 0;
                        //Recuperamos los numeros devueltos s es que los hay
                        String strSqlDev = "SELECT FACD_CAN_DEV,FACD_SERIES_DEV "
                                + "  FROM vta_facturasdeta deta "
                                + "  WHERE deta.FACD_ID= " + tbn.getFieldInt("FACD_ID");

                        rs = oConn.runQuery(strSqlDev, true);
                        while (rs.next()) {
                            strSeriesDev = rs.getString("FACD_SERIES_DEV");
                            intCantDev = rs.getInt("FACD_CAN_DEV");
                        }
                        String numerosSeries = strSeriesDev.replace(",", "','");

                        if (intPR_USO_NOSERIE == 1) {
                            strXML.append(">");
                            boolean bolFound = false;
                            //Consulta de movimientos de producto ligados a este pedido
                            String strSqlProd = "SELECT MPD_ID,PL_NUMLOTE,MPD_SERIE_VENDIDO FROM vta_movproddeta "
                                    + "WHERE MPD_IDORIGEN = " + tbn.getFieldInt("FACD_ID") + " AND MPD_SALIDAS > 0 AND PL_NUMLOTE NOT IN('" + numerosSeries + "')";
                            rs = oConn.runQuery(strSqlProd, true);
                            while (rs.next()) {
                                int intMPD_ID = rs.getInt("MPD_ID");
                                String strPL_NUMLOTE = rs.getString("PL_NUMLOTE");
                                int intMPD_SERIE_VENDIDO = rs.getInt("MPD_SERIE_VENDIDO");
                                strXML.append("<series MPD_ID=\"" + intMPD_ID + "\" PL_NUMLOTE=\"" + strPL_NUMLOTE + "\" MPD_SERIE_VENDIDO=\"" + intMPD_SERIE_VENDIDO + "\" "
                                        + "/>");
                                bolFound = true;
                            }
                            rs.close();
                            //Si no encontro series entonces se surtido por un pedido
                            if (!bolFound) {
                                String strSqlProd2 = "SELECT vta_facturasdeta.FACD_NOSERIE,MPD_ID,PL_NUMLOTE,MPD_SERIE_VENDIDO FROM vta_movproddeta,vta_pedidosdeta,vta_facturasdeta "
                                        + " WHERE "
                                        + " vta_movproddeta.MPD_IDORIGEN = vta_pedidosdeta.pdd_id  and "
                                        + " vta_facturasdeta.PDD_ID = vta_pedidosdeta.pdd_id and "
                                        + " vta_facturasdeta.FACD_ID =  " + tbn.getFieldInt("FACD_ID") + " AND MPD_SALIDAS > 0 AND PL_NUMLOTE NOT IN('" + numerosSeries + "')";
                                rs = oConn.runQuery(strSqlProd2, true);
                                while (rs.next()) {
                                    int intMPD_ID = rs.getInt("MPD_ID");
                                    String strPL_NUMLOTE = rs.getString("PL_NUMLOTE");
                                    int intMPD_SERIE_VENDIDO = rs.getInt("MPD_SERIE_VENDIDO");
                                    strXML.append("<series MPD_ID=\"" + intMPD_ID + "\" PL_NUMLOTE=\"" + strPL_NUMLOTE + "\" MPD_SERIE_VENDIDO=\"" + intMPD_SERIE_VENDIDO + "\" "
                                            + "/>");
                                    bolFound = true;
                                }
                                rs.close();
                            }
                            strXML.append("</deta>");
                        } else {
                            strXML.append("/>");
                        }

                    }
                    strXML.append("</vta_factura>");
                }
                if (lstFacturas.length > 1) {
                    strXML.append("</vta_facturas> ");
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML.toString());//Pintamos el resultado
            }
        } else {
            //Peticion Nula
        }
    } else {
    }

    oConn.close();
%>