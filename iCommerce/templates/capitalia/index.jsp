<%-- 
    Document   : index
    Pagina inicial para el template de pagina ecommcer para la fuerza de ventas
    Created on : 03-feb-2013, 2:20:40
    Author     : aleph_79
--%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.mx.siweb.ui.web.HtmlSpecialChars"%>
<%@page import="com.mx.siweb.ui.web.Document"%>
<%@page import="com.mx.siweb.ui.web.TemplateParams"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>

<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Obtenemos parametros generales de la pagina a mostrar
   Site webBase = new Site(oConn);
   //Inicializamos los parametros del template
   TemplateParams templateparams = new TemplateParams(oConn, "capitalia", webBase.getStrLanguage());
   // get params
   String strColor = templateparams.getColor();
   String strLogo = templateparams.getLogo();
   String strNavposition = templateparams.getPosition();
   Document doc = new Document(oConn);
   doc.getInfoModules();
   // check modules
   int showRightColumn = 1;
   int showbottom = 0;
   int showleft = 0;
   int showno = 0;
   if (doc.getLstCountModules().contains("position-3") || doc.getLstCountModules().contains("position-6") || doc.getLstCountModules().contains("position-8")) {
      showRightColumn = 1;
   }
   if (doc.getLstCountModules().contains("position-9") || doc.getLstCountModules().contains("position-10") || doc.getLstCountModules().contains("position-11")) {
      showbottom = 1;
   }
   if (doc.getLstCountModules().contains("position-4") || doc.getLstCountModules().contains("position-7") || doc.getLstCountModules().contains("position-5")) {
      showleft = 1;
   }
   if (showRightColumn == 0 && showleft == 0) {
      showno = 0;
   }
   String browserType = (String) request.getHeader("User-Agent");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/template.css", "", "");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/smoothness/jquery-ui-1.10.2.custom.css", "", "");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/ui.jqgrid4.4.4.css", "", "");
   if (!strColor.isEmpty()) {
      doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/" + strColor + ".css", "", "");
   }
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/superfish.css", "", "");

   //mootools
   doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/mootools-core.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/core.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/caption.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/mootools-more.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery-1.9.1.min.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/grid.locale-es.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery.jqGrid.4.4.4.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery-ui-1.10.0.custom.min.js", "text/javascript");

   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/hoverIntent.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/superfish.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jQuery.circleMenu.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/ui.datepicker-es.js", "text/javascript");

   //Evaluamos que modulo representar
   String strModulo = request.getParameter("mod");
   if (strModulo == null) {
      strModulo = "inicio";
   }

   //Validamos el idioma
   //El idioma mx es el default
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%= webBase.getStrLanguage()%>" lang="<%= webBase.getStrLanguage()%>" dir="<%= webBase.getStrDirection()%>" >
   <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <%= webBase.getHeader(templateparams)%>
      <%= doc.writeHtmlStyles()%>
      <%= doc.writeHtmlJavaScript()%>
      <%
         if (templateparams.isGoogleFont()) {
      %>
      <link href='http://fonts.googleapis.com/css?family=<%=templateparams.getGoogleFontName()%>' rel='stylesheet' type='text/css' />
      <style type="text/css">
         h1,h2,h3,h4,h5,h6,.site-title{
            font-family: '<%=templateparams.getGoogleFontName().replace("+", " ")%>', sans-serif;
         }
      </style>
      <%
         }
      %>
      <%if (10 == 9) {%>
      <style type="text/css">
         body.site
         {
            border-top: 3px solid <%=templateparams.getColor()%>;
            background-color: <%=templateparams.getBackgroundColor()%>
         }
         a
         {
            color: <%=templateparams.getColor()%>;
         }
         .navbar-inner, .nav-list > .active > a, .nav-list > .active > a:hover, .dropdown-menu li > a:hover, .dropdown-menu .active > a, .dropdown-menu .active > a:hover, .nav-pills > .active > a, .nav-pills > .active > a:hover,
         .btn-primary
         {
            background: <%=templateparams.getColor()%>;
         }
         .navbar-inner
         {
            -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, .25), inset 0 -1px 0 rgba(0, 0, 0, .1), inset 0 30px 10px rgba(0, 0, 0, .2);
            -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, .25), inset 0 -1px 0 rgba(0, 0, 0, .1), inset 0 30px 10px rgba(0, 0, 0, .2);
            box-shadow: 0 1px 3px rgba(0, 0, 0, .25), inset 0 -1px 0 rgba(0, 0, 0, .1), inset 0 30px 10px rgba(0, 0, 0, .2);
         }
      </style>
      <%}%>
      <!--[if lt IE 9]>
         <script src="<%=webBase.getUrlSite()%>media/jui/js/html5.js"></script>
      <![endif]-->
   </head>

   <body class="site com_content view-article no-layout no-task itemid-435">

      <!-- Body -->
      <div class="body">
         <div class="container">
            <!-- Header -->
            <div class="header">
               <div class="header-inner clearfix">
                  <div class="header-search pull-left">
                     <%=doc.getModule("", "position-0", "none", "")%>
                     <!--Menu Area -->
                     <jsp:include page="../../modules/mod_menu/menu.jsp" />
                  </div>
               </div>
            </div>

            <% if (doc.getLstCountModules().contains("position-1")) {%>
            <div class="navigation">
               <%=doc.getModule("", "position-1", "none", "")%>
            </div>
            <%}%>

            <%=doc.getModule("", "banner", "xhtml", "")%>

            <div class="row-fluid">
               <% if (doc.getLstCountModules().contains("position-8")) {%>
               <!-- Begin Sidebar -->
               <div id="sidebar" class="span3">
                  <div class="sidebar-nav">
                     <%=doc.getModule("", "position-8", "xhtml", "")%>
                  </div>
               </div>
               <!-- End Sidebar -->
               <%}%>


               <div id="content" class="span9">
                  <!-- Begin Content -->
                  <%=doc.getModule("", "position-3", "xhtml", "")%>
                  <%=doc.getMessage("")%>       
                  <%=doc.getComponent("")%>
                  <%=doc.getModule("", "position-2", "none", "")%>
                  <%
                     //******************* MODULOS DE FUERZA DE VENTAS ****************
                     //Inicio
                     if (strModulo.equals("inicio")) {
                  %><jsp:include page="../../modules/mod_capitalia/home.jsp" />
                  <%}
                     //Login
                     if (strModulo.equals("FZWebLogin2")) {
                  %><jsp:include page="../../modules/mod_capitalia/login_eval.jsp" />
                  <%}
                     //Logo out
                     if (strModulo.equals("FZWebLogOut")) {
                  %><jsp:include page="../../modules/mod_capitalia/logout.jsp" /><%                     }
                     //Ingresos
                     if (strModulo.equals("FZWebIngresos")) {
                  %><jsp:include page="../../modules/mod_capitalia/ingresos.jsp" />
                  <%}
                     //Red
                     if (strModulo.equals("FZWebRed")) {
                  %><jsp:include page="../../modules/mod_capitalia/red.jsp" />
                  <%                     }
                     //Vista de red en tabla
                     if (strModulo.equals("red_tabla")) {
                  %><jsp:include page="../../modules/mod_capitalia/red_tabla.jsp" />
                  <%                     }
                     //Vista de red en grafica
                     if (strModulo.equals("red_grafica")) {
                  %><jsp:include page="../../modules/mod_capitalia/red_grafica.jsp" />
                  <%                     }
                     if (strModulo.equals("red_grafica2")) {
                  %><jsp:include page="../../modules/mod_capitalia/redOrgChart.jsp" />
                  <%}
                     //Compensacion
                     if (strModulo.equals("FZWebCompensacion")) {
                  %><jsp:include page="../../modules/mod_capitalia/compensacion.jsp" />
                  <%}
                     //Ventas
                     if (strModulo.equals("FZWebVentas")) {
                  %><jsp:include page="../../modules/mod_capitalia/ventas.jsp" />
                  <%}
                     //Sugerencias
                     if (strModulo.equals("FZWebSugerencias")) {
                  %><jsp:include page="../../modules/mod_capitalia/sugerencias.jsp" />
                  <%}
                     //Sugerencias
                     if (strModulo.equals("ingresos_save")) {
                  %><jsp:include page="../../modules/mod_capitalia/ingresos_save.jsp" />
                  <%}
                     //Sugerencias_save
                     if (strModulo.equals("sugerencias_save")) {
                  %><jsp:include page="../../modules/mod_capitalia/sugerencias_save.jsp" />
                  <%                     }
                     //ecommerce
                     if (strModulo.equals("ecomm")) {
                  %><jsp:include page="../../modules/mod_ecomm/ecomm.jsp" />
                  <%                     }
                     //Formulario edit ingresos
                     if (strModulo.equals("FZWebEditIngresos")) {
                  %><jsp:include page="../../modules/mod_capitalia/ingresos_edit.jsp" />
                  <%                     }
                     //guarda modificacion
                     if (strModulo.equals("FZWebEditIngresosSave")) {
                  %><jsp:include page="../../modules/mod_capitalia/ingresos_edit_save.jsp" />
                  <%                     }
                     //Cambio de Contraseña
                     if (strModulo.equals("FZWebCambioContrasena")) {
                  %><jsp:include page="../../modules/mod_capitalia/cambio_contrasena.jsp" />
                  <%}

                     //******************* MODULOS DE FUERZA DE VENTAS ****************
%>
                  <!-- End Content -->
               </div>


               <div id="aside" class="span3">
                  <!-- Begin Right Sidebar -->
                  <%=doc.getModule("", "position-7", "well", "")%>
                  <!-- End Right Sidebar -->
                  <!--Ecomm -->
                  <!--<jsp:include page="../../modules/mod_ecomm/ecomm_right.jsp" />-->
                  <!--Ecomm -->
                  <!--Formato de login-->
                  <jsp:include page="../../modules/mod_capitalia/login.jsp" />
                  <!--Formato de login-->
                  <!--Link para las redes sociales-->
                  <jsp:include page="../../modules/mod_social/social.jsp" />
                  <!--Link para las redes sociales-->
                  <!--Ecomm -->
                  <jsp:include page="../../modules/mod_ecomm/ecomm_right_bot.jsp" />
                  <!--Ecomm -->

               </div>

            </div>
         </div>
      </div>
      <!-- Footer -->
      <div class="footer">
         <div class="container">
            <hr />
            <%=doc.getModule("", "position-14", "", "")%>
            <p class="pull-right"><a href="#top" id="back-top">Subir al inicio</a></p>
               <p>&copy; <%=templateparams.getSitetitle()%> <% Fechas fecha = new Fechas();
               out.println(fecha.getAnioActual());%></p>
         </div>
      </div>
   </body>
</html>
<%
   oConn.close();
%>