<%--
    Document   : it_Cotizaciones
    Created on : 09/01/2012, 01:08:36 AM
    Author     : sergio
--%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
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

            String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            //NOS REGRESA EL SIGUIENTE NUMERO DE FOLIO
            if (strid.equals("1")) {

                String idPedido = request.getParameter("idPedido");

                //utilerias
                UtilXml util = new UtilXml();
                Fechas fecha = new Fechas();
                //Armamos el xml
                try {
                            

                    String strConsulta = "SELECT a.MP_ID,a.MP_FECHA , b.PD_FOLIO"
                                         + " FROM vta_movprod a,vta_pedidos b"
                                         + " where a.PD_ID = b.PD_ID AND a.PD_ID = " + idPedido;

                    ResultSet rs = oConn.runQuery(strConsulta);
                    strXMLData += "<Fechas>";
                    while (rs.next()) {
                        strXMLData += "<fechas";
                        strXMLData += " MP_ID=\'" + rs.getInt("MP_ID") + "\'";
                        strXMLData += " PD_FOLIO=\'" + rs.getString("PD_FOLIO") + "\'";
                        strXMLData += " MP_FECHA=\'" + fecha.FormateaDDMMAAAA(rs.getString("MP_FECHA"), "/") + "\'";
                        strXMLData += "/>";
                    }
                    strXMLData += "</Fechas>";

                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }

                String strRespXML = strXMLData;
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado
            }


        }
    } else {
    }
    oConn.close();

%>
