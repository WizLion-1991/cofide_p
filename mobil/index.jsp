<%-- 
    Document   : testJqueryMobil
    Created on : 09-feb-2013, 11:05:01
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
      <script language="javascript">
         $( document ).delegate("#login_eval", "pageinit", function() {
            var strAcceso = document.getElementById("Acceso").value;
            if(strAcceso=="SI"){
               $.mobile.changePage( "mobil_main.jsp", { transition: "slideup"} );
            }
         });
         //$.mobile.changePage();
      </script>
   </head> 
   <body> 
      <!--Pagina inicial -->
      <div data-role="page" id="ini" data-title="Mi oficina virtual">

         <div data-role="header">

            <h1>Mi oficina virtual</h1>
         </div><!-- /header -->

         <div data-role="content">	
            <center>
               <img src="../images/ptovta/logoSIWEB.png" border="0" alt="Soluciones Informaticas Web"  title="Soluciones Informaticas Web"/>
               <img src="../images/ptovta/LogoCliente.png" border="0" alt="Tu empresa"  title="Logo empresa"/>
            </center>
            <ul data-role="listview" data-inset="true" data-filter="false">
               <li><a href="login.jsp" data-transition="flip">Login</a></li>
               <!--Ejemplo pop up borrar<li><a href="#popupBasic" data-rel="popup">Open Popup</a></li>-->
               <li><a href="contacto.jsp" data-transition="flip">Contacto</a></li>
               <li><a href="mobil_main.jsp" data-transition="flip">Menu</a></li>
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