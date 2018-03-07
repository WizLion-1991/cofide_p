<%-- 
    Document   : mobil_main
    Created on : 09-feb-2013, 14:29:59
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
      <!--Pagina inicial -->
      <div data-role="page" id="Main" data-title="Mi oficina virtual">

         <div data-role="header">

            <h1>Mi oficina virtual</h1>
            <a href="index.jsp" data-role="button" data-icon="home" data-transition="flow">Home</a> 
            <a href="login.jsp" data-role="button" data-icon="back" data-transition="flow">Regresar</a> 
         </div><!-- /header -->

         <div data-role="content">	
            <center>
               <img src="../images/ptovta/logoSIWEB.png" border="0" alt="Soluciones Informaticas Web"  title="Soluciones Informaticas Web"/>
               <img src="../images/ptovta/LogoCliente.png" border="0" alt="Tu empresa"  title="Logo empresa"/>
            </center>
            Seleccione la opción deseada:
            <ul data-role="listview" data-inset="true" data-filter="false">
               <!--Menus cliente-->
               <li><a href="login.jsp" data-transition="flip">Mi información</a></li>
               <li><a href="login.jsp" data-transition="flip">Mis Pedidos</a></li>
               <li><a href="login.jsp" data-transition="flip">Mis Facturas</a></li>
               <li><a href="login.jsp" data-transition="flip">Nuevo Pedido</a></li>
               <!--Menus cliente-->
               <!--Menus mlm-->
               <li><a href="login.jsp" data-transition="flip">Ingresos</a></li>
               <li><a href="login.jsp" data-transition="flip">Descendencia</a></li>
               <!--Menus mlm-->
               <!--Menus backoffice-->
               <!--Menus backoffice-->
               <!--Ejemplo pop up borrar<li><a href="#popupBasic" data-rel="popup">Open Popup</a></li>-->
               <li><a href="contacto.jsp" data-transition="flip">Salir</a></li>
               <!--Solo si -->
            </ul>            
            <div data-role="popup" id="popupBasic">
               <p>This is a completely basic popup, no options set.<p>
            </div>

         </div><!-- /content --> 
         <div data-role="footer">
            <div style="font-size:smaller;text-align: center; ">Todos los derechos reservados </br>
               <h4>Soluciones Informaticas Web S.A. de C.V.</h4>
            </div>
         </div><!-- /footer -->
      </div><!-- /page -->
      <!--Pagina inicial -->


   </body>
</html>