<%-- 
    Document   : vta_empresa_ed
    Created on : 20/02/2014, 04:56:30 PM
    Author     : N4v1d4d3s
--%>


<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="ERP.Precios" %>
<%@ page import="ERP.Producto" %>
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
        String strid = request.getParameter("ID");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {

            //OBTIENE LOS DATOS DE LA EMPRESA A EDITAR
            if (strid.equals("1")) {
                UtilXml util = new UtilXml();
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                String strRazon = "";
                int intCon = 0;
                strXMLData += "<Datos>";

                try {
                    String strSelect = "SELECT * FROM vta_empresas WHERE EMP_ID = " + varSesiones.getIntIdEmpresa();
                    ResultSet rs = oConn.runQuery(strSelect);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strRazon = rs.getString("EMP_RAZONSOCIAL");
                        //Armamos el xml
                        strXMLData += " EMP_RAZONSOCIAL = \"" + util.Sustituye(strRazon) + "\"";
                        strXMLData += " EMP_RFC = \"" + rs.getString("EMP_RFC") + "\"";
                        strXMLData += " EMP_CALLE = \"" + rs.getString("EMP_CALLE") + "\"";
                        strXMLData += " EMP_NUMERO = \"" + rs.getString("EMP_NUMERO") + "\"";
                        strXMLData += " EMP_NUMINT = \"" + rs.getString("EMP_NUMINT") + "\"";
                        strXMLData += " EMP_COLONIA = \"" + rs.getString("EMP_COLONIA") + "\"";
                        strXMLData += " EMP_MUNICIPIO = \"" + rs.getString("EMP_MUNICIPIO") + "\"";
                        strXMLData += " EMP_ESTADO = \"" + rs.getString("EMP_ESTADO") + "\"";
                        strXMLData += " EMP_CP = \"" + rs.getString("EMP_CP") + "\"";
                        strXMLData += " EMP_TELEFONO1 = \"" + rs.getString("EMP_TELEFONO1") + "\"";
                        strXMLData += " EMP_TELEFONO2 = \"" + rs.getString("EMP_TELEFONO2") + "\"";
                        strXMLData += " EMP_REPRESENTANTE = \"" + rs.getString("EMP_REPRESENTANTE") + "\"";
                        strXMLData += " EMP_TIPOCOMP = \"" + rs.getInt("EMP_TIPOCOMP") + "\"";
                        strXMLData += " EMP_TIPOPERS = \"" + rs.getInt("EMP_TIPOPERS") + "\"";
                        strXMLData += " EMP_NO_ISR = \"" + rs.getInt("EMP_NO_ISR") + "\"";
                        strXMLData += " EMP_NO_IVA = \"" + rs.getInt("EMP_NO_IVA") + "\"";
                        strXMLData += " EMP_REGISTRO_PATRONAL = \"" + rs.getInt("EMP_REGISTRO_PATRONAL") + "\"";

                        strXMLData += "/>";
                        intCon++;
                    }
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXMLData += "</Datos>";

                String strRespXML = strXMLData;
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado
            }

            //ACTUALIZA DATOS DE LA EMPRESA
            if (strid.equals("2")) {
                String strResp = "";
                String strUpdate = "UPDATE vta_empresas SET EMP_RAZONSOCIAL= \"" + request.getParameter("EMP_RAZONSOCIAL") + "\""
                        + " ,EMP_RFC = \"" + request.getParameter("EMP_RFC") + "\""
                        + " ,EMP_CALLE =\"" + request.getParameter("EMP_CALLE") + "\""
                        + " ,EMP_NUMERO =\"" + request.getParameter("EMP_NUMERO") + "\""
                        + " ,EMP_NUMINT =\"" + request.getParameter("EMP_NUMINT") + "\""
                        + " ,EMP_COLONIA =\"" + request.getParameter("EMP_COLONIA") + "\""
                        + " ,EMP_MUNICIPIO =\"" + request.getParameter("EMP_MUNICIPIO") + "\""
                        + " ,EMP_ESTADO =\"" + request.getParameter("EMP_ESTADO") + "\""
                        + " ,EMP_CP =\"" + request.getParameter("EMP_CP") + "\""
                        + " ,EMP_TELEFONO1 =\"" + request.getParameter("EMP_TELEFONO1") + "\""
                        + " ,EMP_TELEFONO2 =\"" + request.getParameter("EMP_TELEFONO2") + "\""
                        + " ,EMP_REPRESENTANTE =\"" + request.getParameter("EMP_REPRESENTANTE") + "\""
                        + " ,EMP_TIPOCOMP =\"" + request.getParameter("EMP_TIPOCOMP") + "\""
                        + " ,EMP_TIPOPERS =\"" + request.getParameter("EMP_TIPOPERS") + "\""
                        + " ,EMP_NO_ISR =\"" + request.getParameter("EMP_NO_ISR") + "\""
                        + " ,EMP_NO_IVA =\"" + request.getParameter("EMP_NO_IVA") + "\""
                        + " ,EMP_REGISTRO_PATRONAL =\"" + request.getParameter("EMP_REGISTRO_PATRONAL") + "\""
                        + " WHERE EMP_ID= " + varSesiones.getIntIdEmpresa();
                         oConn.runQueryLMD(strUpdate);
                strResp = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado
            }

        }

    } else {
    }
    oConn.close();
%>