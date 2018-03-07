<%-- 
    Document   : COFIDE_DiplomadoSeminario
    Created on : 12-nov-2016, 22:12:34
    Author     : Fernando
--%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
    String strRes = "";
    String strSql = "";
    ResultSet rs = null;

    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("id");
        if (strid != null) {

            //Consulta el reporte facturas hechas para cursos que son Diplomados o Seminarios
            if (strid.equals("1")) {
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                String strBase = request.getParameter("CtBase");
                String strFechaPago = "";
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<DiplomadoSeminario>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "select FAC_ID,FAC_FECHA,FAC_FOLIO,FAC_COFIDE_PAGADO,FAC_US_ALTA,"
                        + "(select COFIDE_CODIGO from usuarios where id_usuarios = vta_facturas.FAC_US_ALTA)as CT_BASE,"
                        + "(select nombre_usuario from usuarios where id_usuarios = vta_facturas.FAC_US_ALTA)as US_NOMBRE,"
                        + "(select nombre_usuario from usuarios where IS_SUPERVISOR = 1 and COFIDE_CODIGO = '" + strBase + "') as US_SUPERVISOR,"
                        + "FAC_FECHA_COBRO,FAC_TOTAL,FAC_COFIDE_VALIDA from vta_facturas "
                        + "where (select CC_IS_DIPLOMADO from cofide_cursos where CC_CURSO_ID = vta_facturas.CC_CURSO_ID) = 1 or "
                        + "(select CC_IS_SEMINARIO from cofide_cursos where CC_CURSO_ID = vta_facturas.CC_CURSO_ID) = 1 "
                        + "and (select COFIDE_CODIGO from usuarios where id_usuarios = vta_facturas.FAC_US_ALTA) = '" + strBase + "' "
                        + "and FAC_FECHA like '%" + strAnio + strMes + "%';";
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strFechaPago = "";
                        if (rs.getString("FAC_FECHA_COBRO") != null && !rs.getString("FAC_FECHA_COBRO").equals("")) {
                            strFechaPago = fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA_COBRO"), "/");
                        }
                        double tmpBono = 0;
                        double tmpImporte = 0;
                        
                        tmpImporte = rs.getDouble("FAC_TOTAL");
                        if(tmpImporte > 0 && tmpImporte < 5000){
                            tmpBono = 200;
                        }else{
                            if(tmpImporte >= 5000 && tmpImporte < 10000){
                            tmpBono = 300;
                        }else{
                                if(tmpImporte >= 10000 && tmpImporte < 15000){
                            tmpBono = 500;
                        }else{
                                    if(tmpImporte >= 15000){
                            tmpBono = 700;
                        }
                                }
                            }
                        }
                        strXML.append("<datos");
                        strXML.append(" FAC_FOLIO_C = \"").append(util.Sustituye(rs.getString("FAC_FOLIO"))).append("\"");
                        strXML.append(" FAC_COFIDE_PAGADO = \"").append((rs.getInt("FAC_COFIDE_PAGADO") == 1 ? "PAGADA" : "NO PAGADA")).append("\"");
                        strXML.append(" US_SUPERVISOR = \"").append(util.Sustituye(rs.getString("US_SUPERVISOR"))).append("\"");
                        strXML.append(" US_NOMBRE = \"").append(util.Sustituye(rs.getString("US_NOMBRE"))).append("\"");
                        strXML.append(" FAC_FECHA_PAGO = \"").append(strFechaPago).append("\"");
                        strXML.append(" FAC_TOTAL = \"").append(rs.getDouble("FAC_TOTAL")).append("\"");
                        strXML.append(" FAC_BONO = \"").append(tmpBono).append("\"");
                        strXML.append(" FAC_COFIDE_VALIDA = \"").append((rs.getInt("FAC_COFIDE_VALIDA") == 1 ? "SI" : "NO")).append("\"");
                        strXML.append(" FAC_ID = \"").append(rs.getInt("FAC_ID")).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</DiplomadoSeminario>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta Diplomados, Seminarios " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 1

        }
        oConn.close();
    } else {
        out.print("Sin Acceso");
    }
%>