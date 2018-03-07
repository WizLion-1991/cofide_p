<%-- 
    Document   : COFIDE_ValFac_Duplicados
    Created on : 18-nov-2016, 13:10:47
    Author     : casajosefa
--%>

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

            //Consulta Tickets con la bandera COFIDE_DUPLICIDAD = 1
            if (strid.equals("1")) {
                String strFiltro = request.getParameter("strFiltro");
                String strTipoFiltro = request.getParameter("strTipoFiltro");
                String strSqlFiltro = "";
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<VtasDuplicadas>");
                if (strTipoFiltro.equals("2")) {
                    //Razon Social
                    strSqlFiltro = "and CT_RAZONSOCIAL like '%" + strFiltro + "%';";
                }
                if (strTipoFiltro.equals("3")) {
                    //RFC
                    strSqlFiltro = "and CT_RFC like '%" + strFiltro + "%';";
                }
                if (strTipoFiltro.equals("4")) {
                    //Corrreo
                    strSqlFiltro = "and CT_EMAIL1 like '%" + strFiltro + "%' or CT_EMAIL2 like '%" + strFiltro + "%';";
                }
                strSql = "select TKT_ID,vta_cliente.CT_ID,CT_RAZONSOCIAL,CT_RFC,CT_EMAIL1,CT_EMAIL2,CT_CLAVE_DDBB,COFIDE_DUPLICIDAD_ID,"
                        + "(select nombre_usuario from usuarios where usuarios.COFIDE_CODIGO = CT_CLAVE_DDBB limit 1) as AGENTE "
                        + "from vta_tickets,vta_cliente "
                        + "where vta_tickets.CT_ID = vta_cliente.CT_ID "
                        + "and COFIDE_DUPLICIDAD = 1 "
                        + strSqlFiltro;
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strXML.append("<datos");
                        strXML.append(" CT_ID = \"").append(rs.getString("TKT_ID")).append("\"");
                        strXML.append(" COFIDE_DUPLICIDAD_ID = \"").append(rs.getString("COFIDE_DUPLICIDAD_ID")).append("\"");
                        strXML.append(" CT_CLAVE_DDBB = \"").append(util.Sustituye(rs.getString("CT_CLAVE_DDBB"))).append("\"");
                        strXML.append(" CT_RAZONSOCIAL = \"").append(util.Sustituye(rs.getString("CT_RAZONSOCIAL"))).append("\"");
                        strXML.append(" ESTATUS = \"").append("").append("\"");
                        strXML.append(" AGENTE = \"").append(util.Sustituye(rs.getString("AGENTE"))).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</VtasDuplicadas>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta VentasTICKETS Duplicados " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado

            }//Fin ID 1

            //Consulta coincidencias del correo 
            if (strid.equals("2")) {
                String strTktId = request.getParameter("intTkt");
                String strEmail = "";
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<CtCoincidencia>");

                strSql = "select vta_tickets.CT_ID, (select CT_EMAIL1 from vta_cliente where CT_ID = vta_tickets.CT_ID) as strEmail"
                        + " from vta_tickets where TKT_ID = " + strTktId;
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strEmail = rs.getString("strEmail");
                    }
                    rs.close();

                    if (!strEmail.equals("")) {
                        strSql = "select CT_ID,CT_NOMBRE,CT_EMAIL1,CT_RAZONSOCIAL,CT_CLAVE_DDBB,(select nombre_usuario from usuarios where COFIDE_CODIGO = CT_CLAVE_DDBB )as strAgente "
                                + "from vta_cliente where CT_EMAIL1 like '%" + strEmail + "%'";
                        rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            strXML.append("<datos");
                            strXML.append(" CT_ID = \"").append(rs.getString("CT_ID")).append("\"");
                            strXML.append(" CT_NOMBRE = \"").append(util.Sustituye(rs.getString("CT_NOMBRE"))).append("\"");
                            strXML.append(" CT_CLAVE_DDBB = \"").append(util.Sustituye(rs.getString("CT_CLAVE_DDBB"))).append("\"");
                            strXML.append(" CT_RAZONSOCIAL = \"").append(util.Sustituye(rs.getString("CT_RAZONSOCIAL"))).append("\"");
                            strXML.append(" CT_EMAIL1 = \"").append(util.Sustituye(rs.getString("CT_EMAIL1"))).append("\"");
                            strXML.append(" strAgente = \"").append(util.Sustituye(rs.getString("strAgente"))).append("\"");
                            strXML.append(" />");
                        }
                        rs.close();
                    }

                    strXML.append("</CtCoincidencia>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta coincidencias Clientes Duplicados " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado

            }//Fin ID 2

            //Confirma CT y Base del Ticket
            if (strid.equals("3")) {
                String strTKTID = request.getParameter("TKT_ID");
                String strCtId = request.getParameter("CT_ID");
                String strCtBase = request.getParameter("CT_BASE");

                strSql = "update vta_tickets set CT_ID = " + strCtId + ", COFIDE_DUPLICIDAD = 0 where TKT_ID = " + strTKTID;
                oConn.runQueryLMD(strSql);
                strSql = "update vta_cliente set CT_CLAVE_DDBB = '" + strCtBase + "' where CT_ID = " + strCtId;
                oConn.runQueryLMD(strSql);
                strRes = oConn.getStrMsgError();
                if (strRes.equals("")) {
                    strRes = "OK";
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin Id 3
            
            //Anula un TKT
            if (strid.equals("4")) {
                String strTKTID = request.getParameter("TKT_ID");

                strSql = "update vta_tickets set TKT_ANULADA = 1, TKT_FECHAANUL = '" + fec.getFechaActual() + "', TKT_US_ANUL = " + varSesiones.getIntNoUser() + "  where TKT_ID = " + strTKTID;
                oConn.runQueryLMD(strSql);
                strRes = oConn.getStrMsgError();
                if (strRes.equals("")) {
                    strRes = "OK";
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin Id 4

        }
        oConn.close();
    } else {
        out.print("Sin Acceso");
    }
%>