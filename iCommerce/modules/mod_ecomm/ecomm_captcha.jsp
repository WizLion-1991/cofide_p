<%-- 
    Document   : ecomm_captcha
Indica con OK que el captcha tecleado es correcto
    Created on : 02-may-2013, 16:05:29
    Author     : aleph_79
--%>

<%@page import="nl.captcha.Captcha"%>
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
   //if (varSesiones.getIntNoUser() != 0) {
   /*
        String strAnsWerServlet = (String) session.getAttribute("CaptchaAnswer");
      if (strAnsWerServlet.equals(strAnswer)) {

    */
      String strAnswer = request.getParameter("answer");
      Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
      if (captcha.isCorrect(strAnswer)) {
         out.println("OK");
      } else {
         out.println("ERROR");
      }
   /*} else {
      out.println("");
   }*/

%>