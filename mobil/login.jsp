<%-- 
    Document   : login
    Created on : 09-feb-2013, 12:29:36
    Author     : aleph_79
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
      <div data-role="page" id="login" data-title="Login">

         <div data-role="header">
            <h1>Login</h1>
            <a href="index.jsp" data-role="button" data-icon="home" data-transition="flow">Home</a> 
            <a href="index.jsp" data-role="button" data-icon="back" data-transition="flow">Regresar</a> 
         </div><!-- /header -->

         <div data-role="content">	
            <center>
               <img src="../images/ptovta/logoSIWEB.png" border="0" alt="Soluciones Informaticas Web"  title="Soluciones Informaticas Web"/>
               <img src="../images/ptovta/LogoCliente.png" border="0" alt="Tu empresa"  title="Logo empresa"/>
            </center>
            <p>Ingrese sus datos de acceso:</p>		
            <form action="login_eval.jsp" method="post" id="post_login"  data-ajax="false">
               <div data-role="fieldcontain">
               <label for="user">Usuario:</label>
               <input type="text" name="user" id="user"/>
               </div>
               
               <div data-role="fieldcontain">
               <label for="password">Password</label>
               <input type="password" name="password" id="password"/>
               </div>
               
               <input type="submit" value="Ingresar" />
               <input type="reset" value="Cancelar" />
            </form> 
         </div><!-- /content -->

         <div data-role="footer">
            <div style="font-size:smaller;text-align: center; ">Todos los derechos reservados </br>
               <h4>Soluciones Informaticas Web S.A. de C.V.</h4>
            </div>
         </div><!-- /footer -->
      </div><!-- /page -->

   </body>
</html>