<%-- 
    Document   : COFIDE_AutorizaCurso
    Created on : 28-oct-2016, 12:38:04
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
            //Consulta los cursos por confirmar
            if (strid.equals("1")) {
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<CursosConfirmar>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "SELECT CC_CURSO_ID,CC_NOMBRE_CURSO,CC_SEDE,CC_FECHA_INICIAL,CC_FICHA_TECNICA,CC_CONFIRM_INSTR,CC_PUBLICADO,CC_CLAVES,CC_NOMBRE_CURSO "
                        + "FROM cofide_cursos where CC_FECHA_INICIAL like '%" + strAnio + strMes + "%' and CC_CLAVES <> '' order by CC_FECHA_INICIAL";
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        String strSedeAsig = "";
                        String strFechaAsig = "";
                        if (rs.getString("CC_SEDE") != null) {
                            strSedeAsig = util.Sustituye(rs.getString("CC_SEDE"));
                        }
                        if (rs.getString("CC_FECHA_INICIAL") != null) {
                            strFechaAsig = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "/");
                        }
                        strXML.append("<datos");
                        strXML.append(" CC_CURSO_ID = \"").append(rs.getInt("CC_CURSO_ID")).append("\"");
                        strXML.append(" CC_NOMBRE_CURSO = \"").append(util.Sustituye(rs.getString("CC_NOMBRE_CURSO"))).append("\"");
                        strXML.append(" CC_SEDE = \"").append(util.Sustituye(strSedeAsig)).append("\"");
                        strXML.append(" CC_FECHA_INICIAL = \"").append(strFechaAsig).append("\"");
                        strXML.append(" CC_FICHA_TECNICA = \"").append((rs.getInt("CC_FICHA_TECNICA") == 1 ? "SI" : "NO")).append("\"");
                        strXML.append(" CC_CONFIRM_INSTR = \"").append((rs.getInt("CC_CONFIRM_INSTR") == 1 ? "SI" : "NO")).append("\"");
                        strXML.append(" CC_PUBLICADO = \"").append((rs.getInt("CC_PUBLICADO") == 1 ? "SI" : "NO")).append("\"");
                        strXML.append(" CC_CLAVES = \"").append(rs.getInt("CC_CLAVES")).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</CursosConfirmar>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta CURSOS CONFIRMAR: " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 1
            
            //Confirma Instructor
            if (strid.equals("2")) {
                String strIdCurso = request.getParameter("IdCurso");
                strSql = "update cofide_cursos set CC_CONFIRM_INSTR = 1 where CC_CURSO_ID = " + strIdCurso;
                oConn.runQueryLMD(strSql);
                if(oConn.getStrMsgError().equals("")){
                    strRes = "OK";
                }else{
                    strRes = oConn.getStrMsgError();
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 2

        } else {
            out.print("SIN CONEXION.");
        }
        oConn.close();
    }


%>