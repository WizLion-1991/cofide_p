<%-- 
    Document   : COFIDE_ValidaFactura
    Created on : 01-nov-2016, 12:26:17
    Author     : casajosefa
--%>

<%@page import="java.io.File"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    String strRes = "";
    String strSql = "";
    ResultSet rs = null;

    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("id");
        if (strid != null) {

            //Consulta el reporte de comisiones por mes y en base a la base de los usuarios
            if (strid.equals("1")) {
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                String strBase = request.getParameter("CtBase");
                String strValidos = request.getParameter("Validos");
                String strFechaPago = "";
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<ValidaFacturas>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "select FAC_ID,FAC_FECHA,FAC_FECHA_COBRO,FAC_SERIE,FAC_FOLIO,FAC_FOLIO_C,FAC_RAZONSOCIAL,FAC_NOMPAGO,FAC_IMPORTE,FAC_IMPUESTO1,FAC_TOTAL,FAC_COFIDE_VALIDA,FAC_COFIDE_PAGADO "
                        + "from vta_facturas "
                        + "where (select COFIDE_CODIGO from usuarios where id_usuarios = vta_facturas.FAC_US_ALTA) = '" + strBase + "' "
                        + "and FAC_FECHA like '%" + strAnio + strMes + "%' and FAC_COFIDE_VALIDA = " + strValidos + ";";
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strFechaPago = "";
                        if (rs.getString("FAC_FECHA_COBRO") != null && rs.getString("FAC_FECHA_COBRO") != "") {
                            strFechaPago = fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA_COBRO"), "/");
                        }
                        strXML.append("<datos");
                        strXML.append(" FAC_FECHA = \"").append(fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA"), "/")).append("\"");
                        strXML.append(" FAC_FECHA_PAGO = \"").append(strFechaPago).append("\"");
                        strXML.append(" FAC_SERIE = \"").append(util.Sustituye(rs.getString("FAC_SERIE"))).append("\"");
                        strXML.append(" FAC_FOLIO_C = \"").append(util.Sustituye(rs.getString("FAC_FOLIO_C"))).append("\"");
                        strXML.append(" FAC_RAZONSOCIAL = \"").append(util.Sustituye(rs.getString("FAC_RAZONSOCIAL"))).append("\"");
                        strXML.append(" FAC_NOMPAGO = \"").append(util.Sustituye(rs.getString("FAC_NOMPAGO"))).append("\"");
                        strXML.append(" FAC_IMPORTE = \"").append(rs.getDouble("FAC_IMPORTE")).append("\"");
                        strXML.append(" FAC_IMPUESTO1 = \"").append(rs.getDouble("FAC_IMPUESTO1")).append("\"");
                        strXML.append(" FAC_TOTAL = \"").append(rs.getDouble("FAC_TOTAL")).append("\"");
                        strXML.append(" FAC_COFIDE_VALIDA = \"").append((rs.getInt("FAC_COFIDE_VALIDA") == 1 ? "SI" : "NO")).append("\"");
                        strXML.append(" FAC_COFIDE_PAGADO = \"").append((rs.getInt("FAC_COFIDE_PAGADO") == 1 ? "SI" : "NO")).append("\"");
                        strXML.append(" FAC_ID = \"").append(rs.getInt("FAC_ID")).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</ValidaFacturas>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta Validar Facturas[1] " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 1

            //Transacciones Valida(1), Deniega(2) y Edita Fecha Pago(3) de las Facturas
            if (strid.equals("2")) {
                String strOpc = request.getParameter("strOpc");

                if (strOpc.equals("1")) {
                    //Validamos la Factura
                    String strFacId = request.getParameter("FAC_ID");
                    strSql = "update vta_facturas set FAC_COFIDE_VALIDA = 1 where FAC_ID = " + strFacId;
                    oConn.runQueryLMD(strSql);
                    if (oConn.getStrMsgError().equals("")) {
                        strRes = "OK";
                    } else {
                        strRes = oConn.getStrMsgError();
                    }
                }//Fin Valida

                if (strOpc.equals("2")) {
                    //Denegamos la Factura
                    String strFacId = request.getParameter("FAC_ID");
                    String strFacDenegar = request.getParameter("strMotivoDen");
                    strSql = "update vta_facturas set FAC_COFIDE_VALIDA = 0,FAC_COFIDE_PAGADO = 0 where FAC_ID = " + strFacId;
                    oConn.runQueryLMD(strSql);
                    if (oConn.getStrMsgError().equals("")) {
                        //Enviamos el MAIL al cliente
                        strRes = getMailDenegarPago(oConn, strFacId, strFacDenegar);
                    } else {
                        strRes = oConn.getStrMsgError();
                    }
                }//Fin Deniega

                if (strOpc.equals("3")) {
                    //Edita Fecha de Pago
                    String strFacId = request.getParameter("FAC_ID");
                    String strFechaPago = request.getParameter("FechaPago");
                    strFechaPago = fec.FormateaBD(strFechaPago, "/");
                    strSql = "update vta_facturas set FAC_FECHA_COBRO = '" + strFechaPago + "' where FAC_ID = " + strFacId;
                    oConn.runQueryLMD(strSql);
                    if (oConn.getStrMsgError().equals("")) {
                        strRes = "OK";
                    } else {
                        strRes = oConn.getStrMsgError();
                    }
                }//Fin Deniega

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin ID 2

            //Imprime el documento que se adjunto a la FACTURA.
            if (strid.equals("3")) {
                String strFacId = request.getParameter("FAC_ID");
                String strNombrePago = "";
                String strFechaCreate = "";
                String strFilePath = "";
                strSql = "select FAC_FECHACREATE,FAC_NOMPAGO from vta_facturas where FAC_ID = " + strFacId;
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strNombrePago = rs.getString("FAC_NOMPAGO");
                        strFechaCreate = rs.getString("FAC_FECHACREATE").substring(0, 6);
                    }
                    rs.close();
                } catch (SQLException ex) {
                    System.out.println("Get Nombre del Pago de la Factura [ID:3]: " + ex.getLocalizedMessage());
                }
                String strPathBase = this.getServletContext().getRealPath("/");
                String strSeparator = System.getProperty("file.separator");
                if (strSeparator.equals("\\")) {
                    strSeparator = "/";
                    strPathBase = strPathBase.replace("\\", "/");
                }
                strFilePath = strPathBase +  "document" + strSeparator + "Comprobantes" + strSeparator + strFechaCreate + strSeparator + strNombrePago;
                File saveTo = new File(strFilePath);
                if (!saveTo.exists()) {
                    strRes = "El archivo " + strNombrePago + ". No Existe.";
                }else{
                    strFilePath =  "document" + strSeparator + "Comprobantes" + strSeparator + strFechaCreate + strSeparator + strNombrePago;
                    strRes = "OK." + strFilePath;
                }
                
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
                
            }//Fin ID 3
        }
        oConn.close();
    } else {
        out.print("Sin Acceso");
    }
%>

<%!
    public String getMailDenegarPago(Conexion oConn, String strFacId, String strRazonDenegar) {
        String strSql = "select FAC_ID,FAC_FOLIO_C,(select CT_EMAIL1 from vta_cliente where CT_ID = vta_facturas.CT_ID)as MailCt from vta_facturas where FAC_ID = " + strFacId;
        String strFolioFac = "";
        String strMailCT = "";
        String strRes = "";
        Fechas fec = new Fechas();

        try {
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                strFolioFac = rs.getString("FAC_FOLIO_C");
                strMailCT = rs.getString("MailCt");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println("Get Mail Denegar Pago: " + ex.getLocalizedMessage());
        }

        if (!strMailCT.equals("")) {
            Mail mail = new Mail();

            if (mail.isEmail(strMailCT)) {
                //Intentamos mandar el mail
                mail.setBolDepuracion(false);
                mail.getTemplate("FAC_DENEGADA", oConn);
                String strAsuntoMail = mail.getAsunto().replace("%FECHA%", fec.getFechaActualDDMMAAAAguion());
                String strMessage = mail.getMensaje().replace("%FAC_FOLIO_C%", strFolioFac);
                strMessage = strMessage.replace("%RAZON_DENIED%", strRazonDenegar);
                strMessage = replaceCharMailValida(strMessage);
                mail.setMensaje(strMessage);
                mail.setDestino(strMailCT);
                mail.setAsunto(strAsuntoMail);
                boolean bol = mail.sendMail();
                if (bol) {
                    strRes = "OK";
                    //strResp = "MAIL ENVIADO.";
                } else {
                    strRes = "no se envio...";
                    //strResp = "FALLO EL ENVIO DEL MAIL.";
                }
            } else {
                strRes = "El correo del cliente no es valido.";
            }
        } else {
            strRes = "No se ha definido un Correo para el cliente de la factura.";
        }

        return strRes;
    }//Fin getMailInstructor

    public String replaceCharMailValida(String strChar) {
        if (strChar.contains("á")) {
            strChar = strChar.replace("á", "&aacute;");
        }
        if (strChar.contains("é")) {
            strChar = strChar.replace("é", "&eacute;");
        }
        if (strChar.contains("í")) {
            strChar = strChar.replace("í", "&iacute;");
        }
        if (strChar.contains("ó")) {
            strChar = strChar.replace("ó", "&oacute;");
        }
        if (strChar.contains("ú")) {
            strChar = strChar.replace("ú", "&uacute;");
        }
        if (strChar.contains("Á")) {
            strChar = strChar.replace("Á", "&Aacute;");
        }
        if (strChar.contains("É")) {
            strChar = strChar.replace("É", "&Eacute;");
        }
        if (strChar.contains("Í")) {
            strChar = strChar.replace("Í", "&Iacute;");
        }
        if (strChar.contains("Ó")) {
            strChar = strChar.replace("Ó", "&Oacute;");
        }
        if (strChar.contains("Ú")) {
            strChar = strChar.replace("Ú", "&Uacute;");
        }
        return strChar;
    }

%>