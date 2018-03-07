<%-- 
    Document   : ERP_AperCaja
    Created on : 14-ene-2016, 8:32:10
    Author     : casajosefa
--%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
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
    String strSql;
    ResultSet rs;

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            if (strid.equals("1")) {
                strSql = "";
                rs = null;
                //Consultamos los detalles de cada combo
                String strIdCaja = request.getParameter("APC_ID");
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Datos_Caja>";
                try {
                    
                    strSql = "select * from vta_aper_caja_deta where APC_ID = " + strIdCaja;
                    rs = oConn.runQuery(strSql);
                    while (rs.next()) {
                        strXMLData += "<aper_caja";
                        strXMLData += " SI_VALOR =\"" + rs.getDouble("APCD_VALOR") + "\"";
                        strXMLData += " SI_PESOS =\"" + rs.getDouble("APCD_PESOS") + "\"";
                        strXMLData += " SI_DOLARES =\"" + rs.getDouble("APCD_DOLARES") + "\"";
                        strXMLData += "/>";
                    }
                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</Datos_Caja>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin ID 1

        }//Fin ID Null
    } else {
        out.println("Sin acceso");
    }
    oConn.close();
%>