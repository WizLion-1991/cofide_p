<%-- 
    Document   : ERP_MailMasivo
Este jsp manda mails al listado de facturas seleccionado
    Created on : 8/04/2011, 04:22:44 PM
    Author     : zeus
--%>
<%@page import="java.io.File"%>
<%@page import="comSIWeb.Operaciones.Reportes.PDFEventPage"%>
<%@page import="comSIWeb.Operaciones.Reportes.CIP_Formato"%>
<%@page import="comSIWeb.Operaciones.Formatos.Formateador"%>
<%@page import="comSIWeb.Operaciones.Formatos.FormateadorMasivo"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="ERP.ERP_MapeoFormato"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="Tablas.cuenta_contratada"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
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
        //Posicion inicial para el numero de pagina
        String strPosX = "";
        String strTitle = "";
        strPosX = this.getServletContext().getInitParameter("PosXTitle");
        strTitle = this.getServletContext().getInitParameter("TitleApp");
        //Respuesta del servicio
        String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
        strXML += "<vta_mails>";

        boolean bolEsNC = false;
        //Cargamos datos del mail
        cuenta_contratada miCuenta = new cuenta_contratada();
        miCuenta.ObtenDatos(1, oConn);
        //Recuperamos paths de web.xml
        String strPathXML = this.getServletContext().getInitParameter("PathXml");
        String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";

        //Recibimos parametros
        String strlstFAC_ID = request.getParameter("LST_FAC_ID");
        String strVIEW_COPIA = request.getParameter("VIEW_COPIA");
        String strVIEW_ASUNTO = request.getParameter("VIEW_ASUNTO");
        String strVIEW_MAIL = request.getParameter("VIEW_MAIL");
        String strVIEW_CC = request.getParameter("VIEW_CC");
        int intVIEW_Templete = Integer.parseInt(request.getParameter("VIEW_TEMPLETE"));
        if (strlstFAC_ID == null) {
            bolEsNC = true;
            strlstFAC_ID = request.getParameter("LST_NC_ID");
        }
        if (strVIEW_COPIA == null) {
            strVIEW_COPIA = "";
        }
        if (strVIEW_CC == null) {
            strVIEW_CC = "1";
        }
        //Validamos que todos los datos del mail esten completos
        if (!miCuenta.getFieldString("smtp_server").equals("")
                && !miCuenta.getFieldString("smtp_user").equals("")
                && !miCuenta.getFieldString("smtp_pass").equals("")
                && !miCuenta.getFieldString("smtp_port").equals("")) {
            //Recorremos las operaciones seleccionado
            String[] lstFac = strlstFAC_ID.split(",");
            for (int i = 0; i < lstFac.length; i++) {
                //Recuperamos la factura
                int intFAC_ID = 0;
                try {
                    intFAC_ID = Integer.valueOf(lstFac[i]);
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

                //Recuperamos el numero de folio que queremos imprimir
                String strSql = "select FAC_ID,CT_ID,FAC_FOLIO,FAC_TIPOCOMP,FAC_NOMFORMATO,EMP_ID,FAC_RAZONSOCIAL,FAC_FECHA,FAC_ES_CFD,FAC_ES_CBB from vta_facturas where FAC_ID = " + intFAC_ID;
                if (bolEsNC) {
                    strSql = "select CT_ID,NC_FOLIO,NC_TIPOCOMP,NC_NOMFORMATO,EMP_ID,NC_RAZONSOCIAL,NC_FECHA,NC_ES_CFD,NC_ES_CBB from vta_ncredito where NC_ID = " + intFAC_ID;
                }
                ResultSet rs = oConn.runQuery(strSql, true);
                //Buscamos el nombre del archivo
                while (rs.next()) {
                    if (!bolEsNC) {
                        strNumFolio = rs.getString("FAC_FOLIO");
                        intEMP_TIPOCOMP = rs.getInt("FAC_TIPOCOMP");
                        intEMP_ID = rs.getInt("EMP_ID");
                        intCT_ID = rs.getInt("CT_ID");
                        strFAC_NOMFORMATO = rs.getString("FAC_NOMFORMATO");
                        strFAC_RAZONSOCIAL = rs.getString("FAC_RAZONSOCIAL");
                        strFAC_FECHA = rs.getString("FAC_FECHA");
                        intFAC_ES_CFD = rs.getInt("FAC_ES_CFD");
                        intFAC_ES_CBB = rs.getInt("FAC_ES_CBB");
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
                rs.close();
                //Buscamos si EL CLIENTE tiene mail
                String strMailCte = "";
                String strMailCte2 = "";
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
                    rs = oConn.runQuery(strSql, true);
                    //Buscamos el nombre del archivo
                    while (rs.next()) {
                        intEMP_USACODBARR = rs.getInt("EMP_USACODBARR");
                        intEMP_CFD_CFDI = rs.getInt("EMP_CFD_CFDI");
                    }
                    rs.close();
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
                    //Mandamos el mail
                    Mail mail = new Mail();
                    mail.setBolDepuracion(false);
                    if (miCuenta.getFieldInt("smtp_usaTLS") == 1) {
                        mail.setBolUsaTls(true);
                    }
                    if (miCuenta.getFieldInt("smtp_usaSTLS") == 1) {
                        mail.setBolUsaStartTls(true);
                    }
                    mail.setHost(miCuenta.getFieldString("smtp_server"));
                    mail.setUsuario(miCuenta.getFieldString("smtp_user"));
                    mail.setContrasenia(miCuenta.getFieldString("smtp_pass"));
                    mail.setPuerto(miCuenta.getFieldString("smtp_port"));
                    //Adjuntamos archivos
                    mail.setFichero(strFilePdf);
                    if (intEMP_USACODBARR == 0) {
                        //Validamos si existe el archivo con el formato viejo
                        File file = new File(strFileXML);//specify the file path 
                        if (!file.exists()) {
                            System.out.println("Enviamos a otro ");
                            //Version 2.0
                            StringBuilder strNomFile = new StringBuilder("");
                            ERP_MapeoFormato mapeoXml = null;
                            mapeoXml = new ERP_MapeoFormato(1);
                            strFileXML = strPathXML + (getNombreFileXml(mapeoXml, intFAC_ID, strFAC_RAZONSOCIAL, strFAC_FECHA, strNumFolio));
                            System.out.println("strFileXML(2) " + strFileXML);
                        }
                        mail.setFichero(strFileXML);
                    }
                    if (intVIEW_Templete == 1) {

                        String[] lstMail = getMailTemplate("FACTURA", oConn);
                        String strMsgAsunto = lstMail[0].replace("%folio%", strNumFolio);
                        String strMsgMensaje = lstMail[1].replace("%folio%", strNumFolio);
                        mail.setAsunto(strMsgAsunto);
                        //Preparamos el mail
                        mail.setDestino(strEmailSend);
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
                strXML += "<vta_mail id=\"" + intFAC_ID + "\" code=\"" + strCode + "\" res=\"" + strResp + "\" />";
            }
        }

        strXML += "</vta_mails>";
        out.clearBuffer();//Limpiamos buffer
        atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
        out.println(strXML);
    } else {
    }
    oConn.close();
%>

<%!
    /**
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
%>