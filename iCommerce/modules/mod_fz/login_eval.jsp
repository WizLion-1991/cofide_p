<%-- 
    Document   : login_eval
Este jsp se encarga de validar que el usuario tenga permisos
    Created on : 16-abr-2013, 10:29:49
    Author     : aleph_79
--%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="com.SIWeb.struts.LoginAction"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.SetVars(0, 0, 0, 0, "", "", 0, "", 0);

   //Evaluamos si tiene acceso el usuario
   String strUser = request.getParameter("username");
   String strPass = request.getParameter("password");
   //Objeto para validar la seguridad
   LoginAction action = new LoginAction();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   action.setBolSoloCliente(true);
   action.setBolEsBackOffice(false);
   //solo evaluamos si el password esta lleno
   if (!strPass.isEmpty()) {
      action.authentication_user(oConn, strUser, strPass, request);
   }
   oConn.close();


   //Si tuvimos acceso mostramos la bienvenido sino mostramos error
   if (action.isBolTieneAcceso() && action.isBolAccesoCte()) {
      varSesiones.getVars();
      //Limpiamos el carrito de compras anterior
      Sesiones.SetSession(request, "CarSell", "0");
      //Evaluamos si tiene que cambiar el password
      if (action.isBolCambiarPass()) {
         Sesiones.SetSession(request, "EvalPassword1", "1");
%>
<center>
   <h1>BIENVENIDO USUARIO <%=varSesiones.getStrUser()%></h1>
   <h2>Por motivos de seguridad es necesario cambiar su contraseña</h2>
</center>

<%

} else {
   Sesiones.SetSession(request, "EvalPassword1", "0");
%>
<div id="welcome_fz">
<center>
   <h1>BIENVENIDO</h1>
   <h2><%=varSesiones.getStrUser()%></h2>
</center>
</div>
<%
   }

} else {
   String strMsgError = "EL USUARIO O PASSWORD NO COINCIDEN, VERIFIQUELOS";
   if (action.isBolErrorLogged()) {
      strMsgError = "EL USUARIO YA HA INICIADO SESION";
   } else {
      if (action.isBolErrorBloqued()) {
         strMsgError = "EL USUARIO O PASSWORD NO COINCIDEN, VERIFIQUELOS";
      }
   }
%>
<center>
   <h1><%=strMsgError%></h1>
   <a href="index.jsp" class="button">Regresar</a>
</center>

<%         }
%>
