<%-- 
    Document   : auto_ctemak
    Created on : Dec 14, 2015, 10:13:21 AM
    Author     : CasaJosefa
--%>

<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Operaciones.CIP_Form" %>
<%@page import="Tablas.Usuarios" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.SQLException" %>
<%@page import="comSIWeb.Utilerias.UtilXml" %>

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
        String strValorBuscar = request.getParameter("term");

        if (strValorBuscar == null) {
            strValorBuscar = "";
        }

        String strid = request.getParameter("ID");

        if (strid == null) {
            strid = "1";
        }

        if (strid.equals("1")) {
//Declaramos objeto json
            String strIdSuc = request.getParameter("IdSuc");
            String strIdTipo = request.getParameter("IdTipo");
            JSONArray jsonChild = new JSONArray();
            UtilXml util = new UtilXml();
            if (!strValorBuscar.trim().equals("")) {

                //Busca el valor en la tabla de PRODUCTO....
                String strSql = "select  CT_ID,CT_RAZONSOCIAL "
                        + " from vta_cliente "
                        + " where  CT_RAZONSOCIAL like '%" + strValorBuscar + "%' "
                        + " and EMP_ID = " + varSesiones.getIntIdEmpresa();
                ResultSet rsCombo;
                try {
                    rsCombo = oConn.runQuery(strSql, true);
                    while (rsCombo.next()) {
                        String strNumero = util.Sustituye(rsCombo.getString("CT_ID"));
                        String strNombre = rsCombo.getString("CT_RAZONSOCIAL");
                        //Objeto json del item
                        JSONObject objJson = new JSONObject();
                        objJson.put("id", strNumero);
                        objJson.put("value", strNombre);
                        objJson.put("label", strNombre + "(" + strNumero + ")");
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

    } else {
    }
    oConn.close();
%>