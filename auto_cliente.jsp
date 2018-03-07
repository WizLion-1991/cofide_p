<%-- 
    Document   : auto_cliente
    Created on : 18-feb-2015, 18:39:22
    Author     : ZeusGalindo
--%>
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
      Conexion oConn = new Conexion(varSesiones.getStrUser(),this.getServletContext());
      oConn.open();
      //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
      Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
      if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
         /*Definimos parametros de la aplicacion*/
         String strValorBuscar = request.getParameter("term");
         if(strValorBuscar == null)strValorBuscar = "";
         //Declaramos objeto json
         JSONArray jsonChild = new JSONArray();
         if(!strValorBuscar.trim().equals("")){
            //Busca el valor en la tabla de beneficiarios....
            String strSql = "SELECT CT_ID,CT_RAZONSOCIAL,CT_RFC " +
                    "FROM vta_cliente where " +
                    "CT_RAZONSOCIAL LIKE '%" + strValorBuscar + "%' AND EMP_ID = " + varSesiones.getIntIdEmpresa() + " ORDER BY CT_RAZONSOCIAL";
            ResultSet rsCombo;
            try {
               rsCombo = oConn.runQuery(strSql, true);
               while (rsCombo.next()) {
                  String strNumero = rsCombo.getString("CT_ID");
                  String strNombre = rsCombo.getString("CT_RAZONSOCIAL") + "";
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
      }else{
      }
      oConn.close();
%>