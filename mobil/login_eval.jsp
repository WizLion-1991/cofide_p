<%-- 
    Document   : login_eval
    Created on : 09-feb-2013, 13:49:38
    Author     : aleph_79
--%>

<%@page import="com.SIWeb.struts.LoginAction"%>
<%@page import="com.SIWeb.struts.LoginForm"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%
//mandamos a llamar  a los objetos que validen la seguridad
/**LoginForm form = new LoginForm();
form.setUsuario(request.getParameter("user"));
form.setPassword(request.getParameter("password"));
LoginAction action =  new LoginAction();
action.execute(null, form, request, response);
**/

String site = new String("mobil_main.jsp");
   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", site); 
%>
<!DOCTYPE html> 
<html> 
   <head> 
      <title>Mi oficina virtual</title> 
      <link href="../images/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
      <meta name="viewport" content="width=device-width, initial-scale=1"> 
      <link rel="stylesheet" href="../javascript/jquerymobil/themes/siweb_mobil.min.css" />
      <link rel="stylesheet" href="../javascript/jquerymobil/jquery.mobile.custom.structure.min.css" />
      <script src="../jqGrid/jquery-1.8.2.min.js"></script>
      <script src="../javascript/jquerymobil/jquery.mobile.custom.min.js"></script>


   </head> 
   <body> 
      <!-- Start of second page -->
      <div data-role="page" id="login_eval" data-title="Login">

         <div data-role="header">
            <h1>Evaluando accesos</h1>
            <a href="index.jsp" data-role="button" data-icon="home" data-transition="flow">Home</a> 
            <a href="login.jsp" data-role="button" data-icon="back" data-transition="flow">Regresar</a> 
         </div><!-- /header -->

         <div data-role="content">	
            <input type="hidden" id="Acceso" value="SI" />
            <h4>Lo sentimos tus datos son erroneos, vuelve a intentarlo</h4>	

         </div><!-- /content -->

         <div data-role="footer">
            <div style="font-size:smaller;text-align: center; ">Todos los derechos reservados </br>
               <h4>Soluciones Informaticas Web S.A. de C.V.</h4>
            </div>
         </div><!-- /footer -->
      </div><!-- /page -->
      <%
         /*Inicializamos las variables de sesion limpias*/
         VariableSession varSesiones = new VariableSession(request);
         varSesiones.SetVars(0, 0, 0, 0, "", "", 0, "", 0);
      %>
   </body>
</html>