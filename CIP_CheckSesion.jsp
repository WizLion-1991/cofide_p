<%-- 
    Document   : CIP_CheckSesion
    Created on : 16/02/2010, 11:26:12 PM
    Author     : zeus
--%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.OpUsuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%
   /*
    * Obtenemos las variables de sesion
    */
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      out.clearBuffer();//Limpiamos buffer
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();
      //Guardamos la fecha en el usuario para indicar que esta activo
      OpUsuarios user = new OpUsuarios();
      user.SaveLastActivity(varSesiones.getIntNoUser(), varSesiones.getintIdCliente(), oConn);
      oConn.close();
      
      out.println("OK");
   } else {
      out.println("DOWN");
   }
%>