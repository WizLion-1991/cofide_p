<%-- 
    Document   : contacto
    Created on : 09-feb-2013, 12:39:33
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
      <div data-role="page" id="contacto" data-title="Contacto">

         <div data-role="header">
            <h1>Contacto:</h1>
            <a href="index.jsp" data-role="button" data-icon="home" data-transition="flow">Home</a> 
            <a href="index.jsp" data-role="button" data-icon="back" data-transition="flow">Regresar</a> 
         </div><!-- /header -->

         <div data-role="content">	
            <center>
               <img src="../images/ptovta/logoSIWEB.png" border="0" alt="Soluciones Informaticas Web"  title="Soluciones Informaticas Web"/>
               <img src="../images/ptovta/LogoCliente.png" border="0" alt="Tu empresa"  title="Logo empresa"/>
            
            <p>Nombre de la empresa</p>		
            <p>Contacto:</p>		
            <p>Telefono:<a href="tel:15555555555">Phone: tel:15555555555</a></p>		
            <p>Email:<a href="mailto:"></a></p>		
            </center>
         </div><!-- /content -->

         <div data-role="footer">
            <div style="font-size:smaller;text-align: center; ">Todos los derechos reservados </br>
               <h4>Soluciones Informaticas Web S.A. de C.V.</h4>
            </div>
         </div><!-- /footer -->
      </div><!-- /page -->

   </body>
</html>