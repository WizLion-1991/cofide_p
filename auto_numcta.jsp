<%--
    Document   : auto_numcta.jsp
    Created on : 14/06/2012, 03:06:34 PM
    Author     : 
--%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
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
      String strValorBuscar = request.getParameter("term");
      if (strValorBuscar == null) {
         strValorBuscar = "";
      }
//Declaramos objeto json
      JSONArray jsonChild = new JSONArray();
      if (!strValorBuscar.trim().equals("")) {
         //Busca el valor en la tabla de beneficiarios....
         String strSql = "SELECT CT_CTABANCO1,CT_CTABANCO2,CT_CTATARJETA FROM vta_cliente where "
                 + "CT_CTABANCO1 like'%" + strValorBuscar + "' or CT_CTABANCO2 like'%" + strValorBuscar + "' OR CT_CTATARJETA LIKE '%" + strValorBuscar + "' ";

         ResultSet rsCombo;
         try {
            rsCombo = oConn.runQuery(strSql, true);
            while (rsCombo.next()) {
               String strNombre = rsCombo.getString("CT_CTABANCO2");
               String strNombre2 = rsCombo.getString("CT_CTATARJETA");
               String strNombre3 = rsCombo.getString("CT_CTABANCO1");
               //Objeto json del item
               JSONObject objJson = new JSONObject();
               objJson.put("id", strNombre);
               objJson.put("value", strNombre);
               objJson.put("label", strNombre);
               jsonChild.put(objJson);
               objJson = new JSONObject();
               objJson.put("id", strNombre2);
               objJson.put("value", strNombre2);
               objJson.put("label", strNombre2);
               jsonChild.put(objJson);
               objJson = new JSONObject();
               objJson.put("id", strNombre3);
               objJson.put("value", strNombre3);
               objJson.put("label", strNombre3);
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
   } else {
   }
   oConn.close();
%>