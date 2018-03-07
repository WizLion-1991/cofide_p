<%-- 
    Document   : testMail
    Este jsp prueba los parametros del smtp del mail que nos envian
    Created on : 26/07/2010, 08:05:48 PM
    Author     : zeus
--%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
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
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         /*Recibimos los datos del programa*/
         String strsmtp_server = request.getParameter("smtp_server");
         String strsmtp_user = request.getParameter("smtp_user");
         String strsmtp_pass = request.getParameter("smtp_pass");
         String strsmtp_port = request.getParameter("smtp_port");
         String strsmtp_usaTLS = request.getParameter("smtp_usaTLS");
         String strsmtp_usaSTLS = request.getParameter("smtp_usaSTLS");

         //Instanciamos el objeto mail
         Mail mail = new Mail();
         //mail.setBolDepuracion(true);
         mail.setUsuario(strsmtp_user);
         mail.setContrasenia(strsmtp_pass);
         mail.setHost(strsmtp_server);
         mail.setPuerto(strsmtp_port);
         mail.setAsunto("SiWeb.Ventas.Mensaje de prueba");
         mail.setDestino(strsmtp_user);
         mail.setMensaje("<b>Esta es una prueba</b> de envio de mail");
         if(strsmtp_usaTLS.equals("1"))mail.setBolUsaTls(true);
         if(strsmtp_usaSTLS.equals("1"))mail.setBolUsaStartTls(true);
         boolean bol = mail.sendMail();
         out.println("server:" + strsmtp_server);
         out.println("smtp_user:" + strsmtp_user);
         out.println("smtp_pass:*******");
         out.println("smtp_port:" + strsmtp_port);
         //Validamos si paso el mail
         if (bol) {
%>
<bean:message key="main.message76"/>
<%                  } else {
%>
<bean:message key="main.message77"/><%=mail.getErrMsg()%>
<%                  }
      } else {
      }
      oConn.close();
%>