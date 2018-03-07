<%-- 
    Document   : home
Este jsp sera el que se cargara al inicio del Icommerce
    Created on : 25-abr-2013, 0:58:01
    Author     : aleph_79
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--slide 3d -->
<link rel="stylesheet" type="text/css" href="modules/mod_slide/css/demo.css" />
<link rel="stylesheet" type="text/css" href="modules/mod_slide/css/slicebox.css" />
<link rel="stylesheet" type="text/css" href="modules/mod_slide/css/custom.css" />
<!--slide 3d -->
<!--slide 3d -->
<div class="wrapper">

   <ul id="sb-slider" class="sb-slider">
      <%
         /*Inicializamos las variables de sesion limpias*/
         VariableSession varSesiones = new VariableSession(request);
         varSesiones.getVars();

         Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
         oConn.open();

         //Consultamos las imagenes del slide
         String strSql = "select * from ecom_slides where SL_ACTIVO = 1 order by SL_ORDEN";
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
      %>
      <li>
         <a href="<%=rs.getString("SL_URL")%>" target="_blank"><img src="<%=rs.getString("SL_PATH")%>" alt="<%=rs.getString("SL_ALT")%>"/></a>
         <div class="sb-description">
            <h3><%=rs.getString("SL_TEXTO")%></h3>
         </div>
      </li>
      <%         }
         rs.close();

         oConn.close();
      %>
      
   </ul>

   <div id="shadow" class="shadow"></div>

   <div id="nav-arrows" class="nav-arrows">
      <a href="#">Next</a>
      <a href="#">Previous</a>
   </div>

   <div id="nav-options" class="nav-options">
      <span id="navPlay">Play</span>
      <span id="navPause">Pause</span>
   </div>

</div><!-- /wrapper -->
<script type="text/javascript" src="modules/mod_slide/js/modernizr.custom.js"></script>
<script type="text/javascript" src="modules/mod_slide/js/jquery.slicebox.js"></script>
<script type="text/javascript">
   $(function() {

      var Page = (function() {

         var $navArrows = $('#nav-arrows').hide(),
                 $navOptions = $('#nav-options').hide(),
                 $shadow = $('#shadow').hide(),
                 slicebox = $('#sb-slider').slicebox({
            onReady: function() {

               $navArrows.show();
               $navOptions.show();
               $shadow.show();

            },
            orientation: 'h',
            cuboidsCount: 3
         }),
         init = function() {
            initEvents();
         },
                 initEvents = function() {
            // add navigation events
            $navArrows.children(':first').on('click', function() {

               slicebox.next();
               return false;

            });
            $navArrows.children(':last').on('click', function() {
               slicebox.previous();
               return false;
            });
            $('#navPlay').on('click', function() {
               slicebox.play();
               return false;
            });
            $('#navPause').on('click', function() {
               slicebox.pause();
               return false;

            });
         };
         return {init: init};

      })();

      Page.init();

   });
</script>