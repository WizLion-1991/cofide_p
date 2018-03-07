<%-- 
    Document   : COFIDE_RepoComisiones
    Created on : 31-oct-2016, 10:53:36
    Author     : casajosefa
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
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
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<ReporteComision>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "select FAC_US_ALTA,view_ventasglobales.FAC_TOTAL,FAC_DESCUENTO,"
                        + "(select COFIDE_CODIGO from usuarios where id_usuarios = view_ventasglobales.FAC_US_ALTA)as CT_BASE,"
                        + "(select nombre_usuario from usuarios where id_usuarios = view_ventasglobales.FAC_US_ALTA)as US_NOMBRE,"
                        + "(select sum(vvg2.FAC_TOTAL) from view_ventasglobales as vvg2 where vvg2.FAC_US_ALTA = view_ventasglobales.FAC_US_ALTA and vvg2.FAC_FECHA like '%201610%') as TOTAL_VENDIDO,"
                        + "(select sum(vvg2.FAC_TOTAL) from view_ventasglobales as vvg2 where vvg2.FAC_US_ALTA = view_ventasglobales.FAC_US_ALTA and vvg2.FAC_FECHA like '%201610%' and vvg2.COFIDE_NVO = 1) as TOTAL_VENDIDO_NVO,"
                        + "(select sum(vvg2.FAC_TOTAL) from view_ventasglobales as vvg2 where vvg2.FAC_US_ALTA = view_ventasglobales.FAC_US_ALTA and vvg2.FAC_FECHA like '%201610%' and vvg2.COFIDE_NVO = 0) as TOTAL_VENDIDO_EXP "
                        + "from view_ventasglobales "
                        + "where (select COFIDE_CODIGO from usuarios where id_usuarios = view_ventasglobales.FAC_US_ALTA) = '" + strBase + "' "
                        + "and FAC_FECHA like '%" + strAnio + strMes + "%' "
                        + "and TIPO_DOC = 'F' group by FAC_US_ALTA;";
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        double dblDescuento = 0;
                        double dblTotalNvo = 0;
                        double dblTotalExp = 0;
                        if (rs.getString("FAC_DESCUENTO") != null) {
                            dblDescuento = rs.getDouble("FAC_DESCUENTO");
                        }
                        if (rs.getString("TOTAL_VENDIDO_NVO") != null) {
                            dblTotalNvo = rs.getDouble("TOTAL_VENDIDO_NVO");
                        }
                        if (rs.getString("TOTAL_VENDIDO_EXP") != null) {
                            dblTotalExp = rs.getDouble("TOTAL_VENDIDO_EXP");
                        }
                        strXML.append("<datos");
                        strXML.append(" CT_BASE = \"").append(rs.getString("CT_BASE")).append("\"");
                        strXML.append(" US_NOMBRE = \"").append(util.Sustituye(rs.getString("US_NOMBRE"))).append("\"");
                        strXML.append(" TOTAL_VENDIDO = \"").append(rs.getDouble("TOTAL_VENDIDO")).append("\"");
                        strXML.append(" TOTAL_VENDIDO_NVO = \"").append(dblTotalNvo).append("\"");
                        strXML.append(" TOTAL_VENDIDO_EXP = \"").append(dblTotalExp).append("\"");
                        strXML.append(" FAC_DESCUENTO = \"").append(dblDescuento).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</ReporteComision>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta Comisiones: " + ex.getLocalizedMessage());
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