<%-- 
    Document   : COFIDE_RepoCobranza
    Created on : 01-nov-2016, 9:29:43
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
                strXML.append("<ReporteCobranza>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "select FAC_FECHA,FAC_FOLIO,FAC_FOLIO_C,FAC_RAZONSOCIAL,FAC_IMPORTE,FAC_IMPUESTO1,FAC_TOTAL,FAC_SERIE,"
                        + "(select GROUP_CONCAT(CONCAT_WS(\",\",FACD_DESCRIPCION)) from vta_facturasdeta where vta_facturasdeta.FAC_ID =  vta_facturas.FAC_ID) as RC_DESCRIPCION,"
                        + "(select COFIDE_CODIGO from usuarios where id_usuarios = vta_facturas.FAC_US_ALTA)as USUARIO from vta_facturas "
                        + "where (select COFIDE_CODIGO from usuarios where id_usuarios = vta_facturas.FAC_US_ALTA) = '" + strBase + "' "
                        + "and FAC_FECHA like '%" + strAnio + strMes + "%';";

                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strXML.append("<datos");
                        strXML.append(" FAC_FECHA = \"").append(fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA"), "/")).append("\"");
                        strXML.append(" FAC_FOLIO_C = \"").append(util.Sustituye(rs.getString("FAC_FOLIO_C"))).append("\"");
                        strXML.append(" FAC_RAZONSOCIAL = \"").append(util.Sustituye(rs.getString("FAC_RAZONSOCIAL"))).append("\"");
                        strXML.append(" FAC_SERIE = \"").append(util.Sustituye(rs.getString("FAC_SERIE"))).append("\"");
                        strXML.append(" RC_DESCRIPCION = \"").append(util.Sustituye(rs.getString("RC_DESCRIPCION"))).append("\"");
                        strXML.append(" FAC_IMPORTE = \"").append(rs.getDouble("FAC_IMPORTE")).append("\"");
                        strXML.append(" FAC_IMPUESTO1 = \"").append(rs.getDouble("FAC_IMPUESTO1")).append("\"");
                        strXML.append(" FAC_TOTAL = \"").append(rs.getDouble("FAC_TOTAL")).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</ReporteCobranza>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta Cobranza[1] " + ex.getLocalizedMessage());
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