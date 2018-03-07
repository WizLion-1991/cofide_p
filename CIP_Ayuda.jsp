<%-- 
    Document   : CIP_Ayuda
      Este jsp regresa el texto del tema de ayuda que nos solicitan
    Created on : 22/07/2010, 11:23:59 AM
    Author     : zeus
--%>
<%@page import="java.sql.ResultSet"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Utilerias.Fechas" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="ERP.movCliente" %>
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
      //Obtenemos parametros
      String strid = request.getParameter("id");
      String strIdForms = request.getParameter("idForms");
      String strTypeForms = request.getParameter("TypeForms");
      //Si la peticion no fue nula proseguimos
      atrJSP.atrJSP(request, response, true, false);
      out.clearBuffer();
      if (strid != null) {
         String strSql = "select * from ayudafast where AF_ID = " + strid;
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            out.println(rs.getString("AF_CONTENIDO"));
         }
         rs.close();
      } else {
         if (strIdForms == null) {

            out.println("Tema no encontrado...");
         } else {
            out.clear();
            String strSql = "select * from ayudafast_formularios where FRM_ID = " + strIdForms;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               if(strTypeForms.equals("BTN")){
                  out.println(rs.getString("AC_BOTONES"));
               }else{
                  out.println(rs.getString("AC_CAPTURA"));
               }
               
            }
            rs.close();
         }
      }
   } else {
   }
   oConn.close();
%>