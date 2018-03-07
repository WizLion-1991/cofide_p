<%-- 
    Document   : ecomm_islogged
Indica con OK que esta logueado el usuario y con ERROR que no
    Created on : 02-may-2013, 14:39:08
    Author     : aleph_79
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   out.clearBuffer();//Limpiamos buffer
   atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0) {
      out.println("OK");
   } else {
      out.println("ERROR");
   }

%>