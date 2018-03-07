<%-- 
    Document   : COFIDE_Auto_curso
    Created on : 02-feb-2016, 16:24:32
    Author     : juliocesar
--%>

<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="com.google.common.base.Ascii"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
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
        /*Definimos parametros de la aplicacion*/
        //String strValorBuscar = request.getParameter("term");
        String strId = request.getParameter("ID");
        if (strId != null) {
            if (strId.equals("1")) {
                String strValorBuscar = Ascii.toUpperCase(request.getParameter("term"));
                if (strValorBuscar == null) {
                    strValorBuscar = "";
                }
                //Declaramos objeto json
                JSONArray jsonChild = new JSONArray();
                if (!strValorBuscar.trim().equals("")) {
                    //Busca el valor en la tabla de beneficiarios....
                    String strSql = "SELECT CEC_CURSO1 "
                            + "FROM cofide_ev_cursos where "
                            + "CEC_CURSO1 LIKE '%" + strValorBuscar + "%' ORDER BY CEC_CURSO1";
                    ResultSet rsCombo;
                    try {
                        rsCombo = oConn.runQuery(strSql, true);
                        while (rsCombo.next()) {
                            String strCurso1 = rsCombo.getString("CEC_CURSO1");
                            JSONObject objJson = new JSONObject();
                            objJson.put("value", strCurso1);
                            objJson.put("label", strCurso1);
                            jsonChild.put(objJson);
                        }
                        rsCombo.close();
                    } catch (SQLException ex) {
                        ex.fillInStackTrace();
                    }
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(jsonChild.toString());//Pintamos el resultado
            }
            if (strId.equals("2")) {
                String strValorBuscar = Ascii.toUpperCase(request.getParameter("term"));
                if (strValorBuscar == null) {
                    strValorBuscar = "";
                }
                //Declaramos objeto json
                JSONArray jsonChild = new JSONArray();
                if (!strValorBuscar.trim().equals("")) {
                    //Busca el valor en la tabla de beneficiarios....
                    String strSql = "SELECT CEC_CURSO2 "
                            + "FROM cofide_ev_cursos where "
                            + "CEC_CURSO2 LIKE '%" + strValorBuscar + "%' ORDER BY CEC_CURSO2";
                    ResultSet rsCombo;
                    try {
                        rsCombo = oConn.runQuery(strSql, true);
                        while (rsCombo.next()) {
                            String strCurso1 = rsCombo.getString("CEC_CURSO2");
                            JSONObject objJson = new JSONObject();
                            objJson.put("value", strCurso1);
                            objJson.put("label", strCurso1);
                            jsonChild.put(objJson);
                        }
                        rsCombo.close();
                    } catch (SQLException ex) {
                        ex.fillInStackTrace();
                    }
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(jsonChild.toString());//Pintamos el resultado
            }
            if (strId.equals("3")) {
                String strCC_CURSO_ID = request.getParameter("CC_CURSO_ID");
                String strAsp1 = request.getParameter("CEC_ASP1");
                String strAsp2 = request.getParameter("CEC_ASP2");
                String strAsp3 = request.getParameter("CEC_ASP3");
                String strAsp4 = request.getParameter("CEC_ASP4");
                String strPromAsp = request.getParameter("CEC_PROM_ASPECTOS");
                String strIns1 = request.getParameter("CEC_INS1");
                String strIns2 = request.getParameter("CEC_INS2");
                String strIns3 = request.getParameter("CEC_INS3");
                String strIns4 = request.getParameter("CEC_INS4");
                String strIns5 = request.getParameter("CEC_INS5");
                String strPromIns = request.getParameter("CEC_PROM_INSTRUCTOR");
                String strIn1 = request.getParameter("CEC_IN1");
                String strIn2 = request.getParameter("CEC_IN2");
                String strIn3 = request.getParameter("CEC_IN3");
                String strIn4 = request.getParameter("CEC_IN4");
                String strIn5 = request.getParameter("CEC_IN5");
                String strPromIn = request.getParameter("CEC_PROM_INSTALACION");
                String strCurso1 = request.getParameter("CEC_CURSO1");
                String strCurso2 = request.getParameter("CEC_CURSO2");
                String strSql = "INSERT INTO cofide_ev_cursos (CEC_CURSO_ID, CEC_ASP_Q1, CEC_ASP_Q2, CEC_ASP_Q3, CEC_ASP_Q4, "
                        + "CEC_INS_Q1, CEC_INS_Q2, CEC_INS_Q3, CEC_INS_Q4, CEC_INS_Q5, CEC_IN_Q1, CEC_IN_Q2, CEC_IN_Q3, "
                        + "CEC_IN_Q4, CEC_IN_Q5, CEC_CURSO1, CEC_CURSO2, CEC_PROM_INSTRUCTOR, CEC_PROM_INSTALACION, "
                        + "CEC_PROM_ASPECTOS) VALUES "
                        + "(" + strCC_CURSO_ID + ", " + strAsp1 + ", " + strAsp2 + ", " + strAsp3 + ", " + strAsp4 + ","
                        + " " + strIns1 + ", " + strIns2 + ", " + strIns3 + ", " + strIns4 + ", " + strIns5 + ", "
                        + " " + strIn1 + ", " + strIn2 + ", " + strIn3 + ", " + strIn4 + ", " + strIn5 + ", "
                        + " '" + strCurso1 + "', '" + strCurso2 + "', " + strPromAsp + ", " + strPromIns + ", " + strPromIn + ")";
                oConn.runQueryLMD(strSql);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println("OK");//Pintamos el resultado
            }
            if (strId.equals("4")) {
                UtilXml utilXML = new UtilXml();
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<vta>";
                String strCC_CURSO_ID = request.getParameter("CC_CURSO_ID");
                String strAsp1 = "";
                String strAsp2 = "";
                String strAsp3 = "";
                String strAsp4 = "";
                String strInst1 = "";
                String strInst2 = "";
                String strInst3 = "";
                String strInst4 = "";
                String strInst5 = "";
                String strIn1 = "";
                String strIn2 = "";
                String strIn3 = "";
                String strIn4 = "";
                String strIn5 = "";
                String strPromAsp = "";
                String strPromIns = "";
                String strPromIn = "";
                String strCurso1 = "";
                String strCurso2 = "";
                String strSql = "select * from cofide_ev_cursos where CEC_CURSO_ID = " + strCC_CURSO_ID;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strAsp1 = rs.getString("CEC_ASP_Q1");//rs.getString("CEC_ASP1");
                    strAsp2 = rs.getString("CEC_ASP_Q2");
                    strAsp3 = rs.getString("CEC_ASP_Q3");
                    strAsp4 = rs.getString("CEC_ASP_Q4");
                    strInst1 = rs.getString("CEC_INS_Q1");
                    strInst2 = rs.getString("CEC_INS_Q2");
                    strInst3 = rs.getString("CEC_INS_Q3");
                    strInst4 = rs.getString("CEC_INS_Q4");
                    strInst5 = rs.getString("CEC_INS_Q5");
                    strIn1 = rs.getString("CEC_IN_Q1");
                    strIn2 = rs.getString("CEC_IN_Q2");
                    strIn3 = rs.getString("CEC_IN_Q3");
                    strIn4 = rs.getString("CEC_IN_Q4");
                    strIn5 = rs.getString("CEC_IN_Q5");
                    strPromAsp = rs.getString("CEC_PROM_ASPECTOS");
                    strPromIns = rs.getString("CEC_PROM_INSTRUCTOR");
                    strPromIn = rs.getString("CEC_PROM_INSTALACION");
                    strCurso1 = rs.getString("CEC_CURSO1");
                    strCurso2 = rs.getString("CEC_CURSO2");
                    strXML += "<datos "
                            + " CEC_ASP_Q1 = \"" + strAsp1 + "\"  "
                            + " CEC_ASP_Q2 = \"" + strAsp2 + "\"  "
                            + " CEC_ASP_Q3 = \"" + strAsp3 + "\" "
                            + " CEC_ASP_Q4 = \"" + strAsp4 + "\" "
                            + " CEC_INS_Q1 = \"" + strInst1 + "\" "
                            + " CEC_INS_Q2 = \"" + strInst2 + "\" "
                            + " CEC_INS_Q3 = \"" + strInst3 + "\" "
                            + " CEC_INS_Q4 = \"" + strInst4 + "\" "
                            + " CEC_INS_Q5 = \"" + strInst5 + "\" "
                            + " CEC_IN_Q1 = \"" + strIn1 + "\" "
                            + " CEC_IN_Q2 = \"" + strIn2 + "\" "
                            + " CEC_IN_Q3 = \"" + strIn3 + "\" "
                            + " CEC_IN_Q4 = \"" + strIn4 + "\" "
                            + " CEC_IN_Q5 = \"" + strIn5 + "\" "
                            + " CEC_PROM_ASPECTOS = \"" + strPromAsp + "\" "
                            + " CEC_PROM_INSTRUCTOR = \"" + strPromIns + "\" "
                            + " CEC_PROM_INSTALACION = \"" + strPromIn + "\" "
                            + " CEC_CURSO1 = \"" + strCurso1 + "\" "
                            + " CEC_CURSO2 = \"" + strCurso2 + "\" "
                            + " />";
                } //fin del while
                strXML += "</vta>";
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin del caso
            if (strId.equals("5")) {
                String strCC_CURSO_ID = request.getParameter("CC_CURSO_ID");
                String strAsp1 = request.getParameter("LEV_ASP1");
                String strAsp2 = request.getParameter("LEV_ASP2");
                String strAsp3 = request.getParameter("LEV_ASP3");
                String strAsp4 = request.getParameter("LEV_ASP4");
                String strInst1 = request.getParameter("LEV_INS1");
                String strInst2 = request.getParameter("LEV_INS2");
                String strInst3 = request.getParameter("LEV_INS3");
                String strInst4 = request.getParameter("LEV_INS4");
                String strInst5 = request.getParameter("LEV_INS5");
                String strIn1 = request.getParameter("LEV_IN1");
                String strIn2 = request.getParameter("LEV_IN2");
                String strIn3 = request.getParameter("LEV_IN3");
                String strIn4 = request.getParameter("LEV_IN4");
                String strIn5 = request.getParameter("LEV_IN5");
                String strPromAsp = request.getParameter("LEV_P1");
                String strPromIns = request.getParameter("LEV_P2");
                String strPromIn = request.getParameter("LEV_P3");
                String strCurso1 = request.getParameter("LEV_CURSOS1");
                String strCurso2 = request.getParameter("LEV_CURSOS2");
                String strSqlUpdate = "UPDATE cofide_ev_cursos SET CEC_ASP_Q1= " + strAsp1 + ", CEC_ASP_Q2= " + strAsp2 + ", CEC_ASP_Q3= " + strAsp3 + ", CEC_ASP_Q4= " + strAsp4 + ", "
                        + "CEC_INS_Q1= " + strInst1 + ", CEC_INS_Q2= " + strInst2 + ", CEC_INS_Q3= " + strInst3 + ", CEC_INS_Q4= " + strInst4 + ", CEC_INS_Q5= " + strInst5 + ", "
                        + "CEC_IN_Q1= " + strIn1 + ", CEC_IN_Q2= " + strIn2 + ", CEC_IN_Q3= " + strIn3 + ", CEC_IN_Q4= " + strIn4 + ", CEC_IN_Q5= " + strIn5 + ", "
                        + "CEC_CURSO1= '" + strCurso1 + "', CEC_CURSO2= '" + strCurso2 + "', "
                        + "CEC_PROM_INSTRUCTOR= " + strPromIns + ", CEC_PROM_INSTALACION= " + strPromIn + ", CEC_PROM_ASPECTOS= " + strPromAsp + " "
                        + "WHERE  CEC_CURSO_ID = " + strCC_CURSO_ID;
                oConn.runQueryLMD(strSqlUpdate);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println("OK");//Pintamos el resultado
            } //fin del caso
        }
    }
    oConn.close();
%>
