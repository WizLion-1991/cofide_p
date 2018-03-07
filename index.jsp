<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%
//Validacion para el modulo de acceso de clientes

   String strAcceso_Cte = this.getServletContext().getInitParameter("Acceso_Cte");
   if (strAcceso_Cte == null) {
      strAcceso_Cte = "NO";
   }

//Validacion para el modulo de acceso de Proveedores
    String strAcceso_Prov = this.getServletContext().getInitParameter("Acceso_Prov");
    if (strAcceso_Prov == null) {
        strAcceso_Prov = "NO";
    }

//Validacion para el modulo de acceso de Empleados
    String strAcceso_Empl = this.getServletContext().getInitParameter("Acceso_Empl");
    if (strAcceso_Empl == null) {
        strAcceso_Empl = "NO";
    }
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <title>SiWeb ERP Ventas</title>
      <link href="images/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
      <link rel="stylesheet" type="text/css" href="css/Portada.css" />

   </head>

   <body>
      <script language="Javascript">
         //Detectamos navegador
         /*if (navigator.userAgent.indexOf("iPhone") > 0 || navigator.userAgent.indexOf("Android") > 0)
          self.location = "mobil/";*/
      </script> 
      <div id="portada">
         <div id="letreros">
            <h1>
               <a href="http://www.solucionesinformaticasweb.com.mx/">
                  <img src="images/fondo_erp_small.png" width="1000" height="" border="0 " />
               </a>
            </h1>
            <h3>Ver 2.2015</h3>
            <br />
            <h2>Generando los bloques para hacer crecer su negocio....</h2>
            <h4>Soluciones de sistemas administrativos en la nube</h4>
            <center>
               <br/>
               <div>
                  <span class="links"><a href="Login.do">Acceso administración empresa</a></span>
               </div>
               <br/>
               <!-- 
               <div>
                  <span class="links"><a href="iCommerce">Acceso distribuidores</a></span>

               </div>
                    <br/>
               -->
                    <div>
                        <% if (strAcceso_Prov.equals("SI")) { %>
                        <span class="links"><a href="B2B">Acceso proveedores</a></span>
                        <%           }%>
                    </div>
                    <br/>
                    <div>
                        <% if (strAcceso_Empl.equals("SI")) { %>
                        <span class="links"><a href="iCommerce">Acceso empleados</a></span>
                        <%           }%>
                    </div>
            </center>
            <p class="note">Desarrollado por Soluciones Informaticas Web</p>
         </div>


      </div>
   </body>
</html>
