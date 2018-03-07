<%-- 
    Document   : PRO_Documento
    Created on : 2/04/2013, 06:02:26 PM
    Author     : SIWEB
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mx.siweb.prosefi.Credito"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
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
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      String strid = request.getParameter("ID");
      if (strid != null) {

         //Sirve para eliminar un documento
         if (strid.equals("2")) {
            String strId = request.getParameter("DMN_ID");
            try {
               //SACAMOS LAS PÀRTIDAS CORRESPONDIENTES AL PEDIDO
               String strDelete = "DELETE FROM cat_documentacion"
                       + " WHERE DMN_ID=" + strId;

               oConn.runQueryLMD(strDelete);

            } catch (Exception ex) {
               ex.fillInStackTrace();

            }
            String strRes = "OK";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Sirve para enviar el path de un documento
         if (strid.equals("4")) {
            String strId = request.getParameter("DMN_ID");
            if(strId == null)strId = "0";
            String strNomDoc = null;
            try {
               //Obtenemos el nombre del documento
               String strSql = "Select DMN_NOMBRE  FROM cat_documentacion"
                       + " WHERE DMN_ID=" + strId;

               try {
                  ResultSet rs = oConn.runQuery(strSql, true);
                  while (rs.next()) {
                     strNomDoc = rs.getString("DMN_NOMBRE");
                  }
                  rs.close();
               } catch (SQLException ex) {
                  System.out.println("SQLException:" + ex.getMessage() + " " + ex.getSQLState() + " " + ex.getLocalizedMessage());
               }

            } catch (Exception ex) {
               ex.fillInStackTrace();

            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println("document/credito/" + strNomDoc);//Pintamos el resultado
         }

      }
   }
%>
