<%-- 
    Document   : index
    Pagina inicial para el template de pagina ecommcer para la fuerza de ventas
    Created on : 03-feb-2013, 2:20:40
    Author     : aleph_79
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
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
   TemplateParams templateparams = new TemplateParams(oConn, "cjosef", webBase.getStrLanguage());
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
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/smoothness/jquery-ui-1.10.2.custom.min.css", "", "");
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

   String strModulo = request.getParameter("mod");

   //Evaluacion para redireccionar
   if (strModulo != null) {
      if (strModulo.equals("ecomm_car_checkout_sell")) {
         //Evaluamos si esta logueado para reenviarlo a la siguiente pantalla o dejarlo en esta
         if (varSesiones.getIntNoUser() != 0) {


            String redirectURL = "index.jsp?mod=ecomm_car_checkout_confirm";
            response.sendRedirect(redirectURL);

         }
      }

   } else {
      //Evaluamos si esta logueado para reenviarlo a la siguiente pantalla o dejarlo en esta
      if (varSesiones.getIntNoUser() != 0) {
         String redirectURL = "index.jsp?mod=red_grafica2";
         response.sendRedirect(redirectURL);
      }
   }
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%= webBase.getStrLanguage()%>" lang="<%= webBase.getStrLanguage()%>" dir="<%= webBase.getStrDirection()%>" >
   <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <%= webBase.getHeader(templateparams)%>
      <link href="http://casajosefa.com/image/data/cart.png" rel="icon" />
      <link href='//fonts.googleapis.com/css?family=PT+Sans&v1' rel='stylesheet' type='text/css'><link href='//fonts.googleapis.com/css?family=PT+Sans&v1' rel='stylesheet' type='text/css'><link href='//fonts.googleapis.com/css?family=PT+Sans&v1' rel='stylesheet' type='text/css'>

               <%= doc.writeHtmlStyles()%>
               <%= doc.writeHtmlJavaScript()%>
               <%
                  if (templateparams.isGoogleFont()) {
               %>
               <script src="http://code.jquery.com/jquery-migrate-1.2.1.js"></script>
               <link rel="stylesheet" type="text/css" href="http://casajosefa.com/catalog/view/theme/mystore/stylesheet/stylesheet.css"> 
                  <link rel="stylesheet" type="text/css" href="http://casajosefa.com/catalog/view/javascript/jquery/colorbox/colorbox.css" media="screen" />
                  <link rel="stylesheet" type="text/css" href="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/casa_josefa.css"%>"> 

                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/theme/mystore/jquery/ui/external/jquery.cookie.js"></script>
                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/theme/mystore/jquery/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
                     <link rel="stylesheet" type="text/css" href="http://casajosefa.com/catalog/view/theme/mystore/jquery/fancybox/jquery.fancybox-1.3.4.css" media="screen" />
                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/theme/mystore/js/custom/cufon-yui.js"></script>
                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/theme/mystore/js/custom/bell-gothic_400.font.js"></script>

                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/theme/mystore/jquery/jquery.tinycarousel.min.js"></script>		

                     <!--[if IE]>
                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/javascript/jquery/fancybox/jquery.fancybox-1.3.4-iefix.js"></script>
                     <![endif]--> 

                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/javascript/jquery/tabs.js"></script>
                     <script type="text/javascript" src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/common.js"%>"></script>
                     <script type="text/javascript" src="http://casajosefa.com/catalog/view/javascript/jquery/colorbox/jquery.colorbox-min.js"></script>
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
<!--Codigo para casa josefa-->         
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-55751502-1', 'auto');
ga('require', 'displayfeatures');
  ga('send', 'pageview');

</script>
<!--Start of Zopim Live Chat Script-->
<script type="text/javascript">
window.$zopim||(function(d,s){var z=$zopim=function(c){z._.push(c)},$=z.s=
d.createElement(s),e=d.getElementsByTagName(s)[0];z.set=function(o){z.set.
_.push(o)};z._=[];z.set._=[];$.async=!0;$.setAttribute('charset','utf-8');
$.src='//v2.zopim.com/?2UqDeDS8nsBC8cwKAPYWPPYkfr10wzie';z.t=+new Date;$.
type='text/javascript';e.parentNode.insertBefore($,e)})(document,'script');
</script>
<!--End of Zopim Live Chat Script-->
<!--Codigo para casa josefa-->
                     </head>

                     <body>
                        <!-- cabezero-->
                        <div id="topnav">
                           <div class="clsTopmnu">
                              <div id="search">
                                 <input class="search" name="filter_name" value="Buscar" onclick="this.value = '';" type="text">
                                    <div class="button-search"></div>

                              </div>
                              <div style="float:left; width:250px; margin-top:17px;"></div>
                              <div class="links">
                                 <img src="http://casajosefa.com/image/flags/mx.png" alt="Mexico">
                                    <%
                                       //Evaluamos sesion
                                       varSesiones.getVars();

                                       //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
                                       if (varSesiones.getIntNoUser() == 0) {
                                          if (strModulo == null) {
                                    %>
                                    <a href="index.jsp">Iniciar Sesion</a> 
                                    <%                  } else {
                                       if (strModulo.equals("FZWebLogOut")) {
                                    %>
                                    <a href="index.jsp">Iniciar Sesion</a> 
                                    <%                  } else {
                                    %>
                                    <a href="index.jsp">Iniciar Sesion</a> 
                                    <%                        }
                                       }

                                    } else {
                                       if (strModulo == null) {
                                    %>
                                    <a href="index.jsp?mod=red_grafica2">Ver mi Sesion</a> 
                                    <%                  } else {
                                       if (strModulo.equals("FZWebLogOut")) {
                                    %>
                                    <a href="index.jsp">Iniciar Sesion</a> 
                                    <%                  } else {
                                    %>
                                    <a href="index.jsp?mod=red_grafica2">Ver mi Sesion</a> 
                                    <%                           }
                                          }

                                       }
                                    %><jsp:include page="../../modules/mod_ecomm/ecomm_car_view.jsp" /><%
                                    %>

                              </div>  
                           </div>
                        </div>
                        <!-- cabezero-->

                        <!-- Body -->
                        <div id="container">


                           <div id="header">
                              <div id="logo"><a href="http://casajosefa.com/index.php?route=common/home"><img src="http://casajosefa.com/image/data/BANNERS/Multinivel de ropa México Logo Principal-01.png" title="Casa Josefa" alt="Casa Josefa"></a></div>
                              <div class="LogoRight">

                                 <div id="menu">
                                    <ul>
                                       <li><a href="http://casajosefa.com/index.php?route=product/category&amp;path=113">NOSOTROS</a></li>
                                       <li><a href="http://mlm.casajosefa.com:8080/CasaJosefa/iCommerce/index.jsp?mod=mod_splash">Mujeres</a>
                                          <div style="">
                                             <%
                                             %>
                                             <ul>
                                                <%
                                                   //Consultamos las categorias

                                                   String strSql = "select *"
                                                           + " ,(select count(distinct PR_CATEGORIA2) from vta_producto where PR_ACTIVO = 1 AND PR_CATEGORIA1 = vta_prodcat1.PC_ID AND SC_ID = 1 ) as cuantos "
                                                           + " from vta_prodcat1 "
                                                           + " where PC1_ORDEN <= 4";
                                                   ResultSet rs = oConn.runQuery(strSql, true);
                                                   while (rs.next()) {
                                                %>
                                                <li><a href="index.jsp?mod=ecomm_cat&cat_id=<%=rs.getString("PC_ID")%>"><%=rs.getString("PC_DESCRIPCION")%> (<%=rs.getString("cuantos")%>)</a></li>
                                                   <%
                                                      }
                                                      rs.close();
                                                   %>
                                             </ul>
                                             <ul>
                                                <%
                                                   //Consultamos las categorias

                                                   strSql = "select * "
                                                           + " ,(select count(distinct PR_CATEGORIA2) from vta_producto where PR_ACTIVO = 1 AND PR_CATEGORIA1 = vta_prodcat1.PC_ID AND SC_ID = 1 ) as cuantos "
                                                           + "from vta_prodcat1 where PC1_ORDEN > 4 AND PC1_ORDEN <= 7";
                                                   rs = oConn.runQuery(strSql, true);
                                                   while (rs.next()) {
                                                %>
                                                <li><a href="index.jsp?mod=ecomm_cat&cat_id=<%=rs.getString("PC_ID")%>"><%=rs.getString("PC_DESCRIPCION")%> (<%=rs.getString("cuantos")%>)</a></li>
                                                   <%
                                                      }
                                                      rs.close();
                                                   %>
                                             </ul>
                                             <%%>
                                          </div>
                                       </li>

                                       <li><a href="http://casajosefa.com/index.php?route=product/category&amp;path=98">Blog</a>
                                       </li>
                                       <li><a href="http://mlm.casajosefa.com:8080/CasaJosefa/iCommerce/index.jsp?mod=catalogo_flash">Catálogo</a>
                                       </li>
                                       <li>
                                          <a href="http://mlm.casajosefa.com:8080/CasaJosefa/iCommerce/index.jsp">ACCESO SOCIAS</a>
                                       </li>
                                       <li><a href="http://mlm.casajosefa.com:8080/CasaJosefa/iCommerce/index.jsp?mod=mod_asocia">Asóciate</a>
                                       </li>
                                    </ul>
                                 </div>
                              </div>
                           </div>

                           <div id="notification">
                              <%
                                 //Login
                                 if (strModulo != null) {
                                    if (strModulo.equals("FZWebLogin2")) {
                              %><jsp:include page="../../modules/mod_fz/login_eval.jsp" />

                              <%
                                    varSesiones.getVars();
                                 }

                                 //Logo out
                                 if (strModulo.equals("FZWebLogOut")) {
                              %><jsp:include page="../../modules/mod_fz/logout.jsp" /><%
                                       varSesiones.getVars();
                                    }
                                 }
                              %>
                           </div>

                           <!--<div class="warning">
                              
                           </div>-->
                           <!-- column left ecomm--> 
                           <%
                              if (strModulo != null) {
                                 if (strModulo.equals("ecomm_cat")) {
                           %>
                           <div id="column-left">
                              <div class="box">

                                 <div class="box-content">
                                    <div class="box-category">
                                       <ul>
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <%         }
                              }
                           %>
                           <!-- column left ecomm-->

                           <%
                              varSesiones.getVars();

                              //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
                              if (varSesiones.getIntNoUser() != 0) {
                                 if (strModulo != null) {
                                    //Modulos por base de datos
                                    boolean bolModEsp = false;
                                    String strSqlMod = "SELECT "
                                            + " ecom_modules.MOD_ID, "
                                            + " ecom_modules.MOD_POSITION, "
                                            + " ecom_modules.MOD_NAME, "
                                            + " ecom_modules.MOD_PATHBASE, "
                                            + " ecom_modules.MOD_JAVASCRIPT, "
                                            + " ecom_modules.MOD_HTML, "
                                            + " ecom_modules.MOD_CSS "
                                            + " FROM ecom_modules where MOD_POSITION = 'position-center'";
                                    rs = oConn.runQuery(strSqlMod, true);
                                    while (rs.next()) {
                                       if (strModulo.equals(rs.getString("MOD_NAME"))) {
                                          bolModEsp = true;
                                       }
                                    }
                                    rs.close();
                                    if (!strModulo.equals("ecomm_cat")
                                            && !strModulo.equals("ecomm_cat_deta")
                                            && !strModulo.equals("ecomm_checkout")
                                            && !strModulo.equals("ecomm_car_checkout_sell")
                                            && !strModulo.equals("ecomm_car_checkout_sucess")
                                            && !strModulo.equals("ecomm_car_checkout_confirm")
                                            && !bolModEsp) {
                           %>
                           <div id="column-right">
                              <!--Menu -->
                              <jsp:include page="../../modules/mod_fz/menu_right.jsp" />
                           </div>

                           <%      }
                                 }
                              }
                           %>



                           <div id="content">
                              <!--content-->

                              <%
                                 //Evaluamos que modulo representar

                                 if (strModulo == null) {
                              %>
                              <div class="login-content">
                                 <!-- Iniciar sesion -->
                                 <div class="right">
                                    <h2>Cliente Registrado</h2>
                                    <form action="index.jsp?mod=FZWebLogin2" method="post" onsubmit="return EvaluaFormulario();">
                                       <div class="content">

                                          <b>Usuario/ID</b><br>
                                             <input name="username" id="username" style="background: #d8d6d6;" type="text" placeholder="Escribe el numero de usuario proporcionado">
                                                <br>
                                                   <br>
                                                      <b>Contraseña</b><br>
                                                         <input name="password" id="password" value="" type="password" placeholder="Escribe la contraseña asignada">
                                                            <br>
                                                               <a href="http://casajosefa.com/index.php?route=account/forgotten">Contraseña olvidada</a><br>
                                                                  <br>
                                                                     <input value="&nbsp;&nbsp;&nbsp;&nbsp;INICIAR SESION&nbsp;&nbsp;&nbsp;&nbsp;" class="button" style="background: #000; color:#FFF; border:0px; padding-top:5px;padding-bottom:5px;" type="submit">
                                                                        <input name="redirect" value="http://casajosefa.com/index.php?route=account/return" style="background: #d8d6d6;" type="hidden">
                                                                           </div>
                                                                           </form>
                                                                           </div>
                                                                           <!--Iniciar sesion -->

                                                                           <div class="login-content">
                                                                              <div class="left" style="border-left: 1px solid #000; padding-left:5px;">
                                                                                 <!--<h2>Cliente nuevo</h2>-->
                                                                                 <div><div id="content">  

                                                                                       <style>
                                                                                          .ui-widget-header {
                                                                                             border: none !important;
                                                                                             background: #000 !important;
                                                                                          }

                                                                                          .ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {			
                                                                                             color: #BBB !important;
                                                                                          }

                                                                                          .ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active {
                                                                                             color: #000 !important;
                                                                                          }
                                                                                       </style>


                                                                                       <!--<form action="index.jsp?mod=NewIng" method="post"  >

                                                                                          <div class="content">
                                                                                             <table class="form">
                                                                                                <tbody><tr>
                                                                                                      <td><span class="required">*</span> Nombre:</td>
                                                                                                   </tr><tr>
                                                                                                   </tr>
                                                                                                   <tr><td><input name="firstname" type="text" placeholder="Escribe tu nombre">
                                                                                                      </td>
                                                                                                   </tr>
                                                                                                   <tr>
                                                                                                      <td><span class="required">*</span> Apellido/s:</td>
                                                                                                   </tr><tr>
                                                                                                   </tr>
                                                                                                   <tr><td><input name="lastname" type="text" placeholder="Escribe tus apellidos">
                                                                                                      </td>
                                                                                                   </tr>

                                                                                                   <tr>
                                                                                                      <td><span class="required">*</span> Fecha de Nacimiento</td>
                                                                                                   </tr><tr>
                                                                                                   </tr>
                                                                                                   <tr><td>
                                                                                                         
                                                                                                         <input id="fecha_nacimiento" type="text" name="fecha_nacimiento" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Fecha de nacimiento"/>
                                                                                                      </td>
                                                                                                   </tr>

                                                                                                   <tr>
                                                                                                      <td><span class="required">*</span> E-Mail:</td>        
                                                                                                   </tr><tr>
                                                                                                   </tr>
                                                                                                   <tr><td><input name="email" type="text" placeholder="Escribe tu dirección de correo electrónico">
                                                                                                      </td>
                                                                                                   </tr>

                                                                                                   <tr>
                                                                                                      <td><span class="required">*</span>Teléfono</td>
                                                                                                   </tr><tr>
                                                                                                   </tr>
                                                                                                   <tr><td><input name="telefono" type="text" placeholder="Escribe tu numero teléfonico"></td>
                                                                                                   </tr>
                                                                                                   <tr>
                                                                                                      <td><span class="required">*</span> Contraseña:</td>

                                                                                                   </tr><tr>
                                                                                                   </tr>
                                                                                                   <tr><td><input name="password" value="" type="password" placeholder="Escribe tu contraseña alfanumerica">
                                                                                                      </td>
                                                                                                   </tr>
                                                                                                   <tr>
                                                                                                      <td><span class="required">*</span> Confirma contraseña:</td>
                                                                                                   </tr><tr>
                                                                                                   </tr>
                                                                                                   <tr><td><input name="confirm" value="" type="password" placeholder="Confirma tu contraseña">
                                                                                                      </td>
                                                                                                   </tr>
                                                                                                </tbody></table>
                                                                                          </div>

                                                                                          <div class="buttons">
                                                                                             <div class="right">
                                                                                                <input name="agree" value="1" style="display:none" type="checkbox">
                                                                                                   <input value="&nbsp;&nbsp;&nbsp;Continuar&nbsp;&nbsp;&nbsp;" class="button" style="background:#000; color:#FFF; border:0; padding:5px;" type="submit">

                                                                                                      </div>
                                                                                                      </div>
                                                                                                      </form>-->
                                                                                    </div>



                                                                                    <script type="text/javascript">
                                    $(document).ready(function() {
                                       $('.colorbox').colorbox({
                                          width: 640,
                                          height: 480
                                       });

                                       $("#fecha_nacimiento").datepicker({
                                          changeMonth: true,
                                          changeYear: true,
                                          yearRange: "1970:2014"
                                       });


                                    });

                                                                                    </script> 


                                                                                 </div>
                                                                                 <div class="header-inner clearfix">
                                                                                    <!--
                                                                                       <div class="logoheader">
                                                                     
                                                                                          <h1 id="logo">
                                                                     
                                                                                    <%if (templateparams.getLogo() != null) {%>
                                                                                    <img src="<%=webBase.getUrlSite()%>/<%=HtmlSpecialChars.Parser(templateparams.getLogo())%>"  alt="<%=HtmlSpecialChars.Parser(templateparams.getSitetitle())%>" />
                                                                                    <%}%>
                                                                                    <%if (templateparams.getLogo() == null || templateparams.getLogo().isEmpty()) {%>
                                                                                    <%=HtmlSpecialChars.Parser(templateparams.getSitetitle())%>
                                                                                    <%}%>
                                                                                    <span class="header1">
                                                                                    <%=templateparams.getSitedescription()%>
                                                                                 </span>
                                                                              </h1>
                                                         
                                                                           </div>-->
                                                                                    <div class="header-search pull-left">
                                                                                       <%=doc.getModule("", "position-0", "none", "")%>
                                                                                       <!--Menu Area -->
                                                                                       <jsp:include page="../../modules/mod_menu/menu.jsp" />
                                                                                    </div>
                                                                                 </div>
                                                                              </div>

                                                                           </div>
                                                                           <%
                                                                           } else {
                                                                           %>

                                                                           <!-- Begin Content -->

                                                                           <%
                                                                              //******************* MODULOS DE FUERZA DE VENTAS ****************
                                                                              //Inicio
                                                                              if (strModulo == null) {
                                                                           %><jsp:include page="../../modules/mod_fz/home.jsp" />
                                                                           <%}


                                                                              //Ingresos
                                                                              if (strModulo.equals("FZWebIngresos")) {
                                                                           %><jsp:include page="../../modules/mod_fz/ingresos.jsp" />
                                                                           <%}
                                                                              //Ingresos
                                                                              if (strModulo.equals("FZWebLogin2") || strModulo.equals("red_grafica2")) {
                                                                           %><jsp:include page="../../modules/mod_fz/redOrgChart.jsp" />
                                                                           <%}
                                                                              //Red
                                                                              if (strModulo.equals("FZWebRed")) {
                                                                           %><jsp:include page="../../modules/mod_fz/red.jsp" />
                                                                           <%                     }
                                                                              //Vista de red en tabla
                                                                              if (strModulo.equals("red_tabla")) {
                                                                           %><jsp:include page="../../modules/mod_fz/red_tabla.jsp" />
                                                                           <%                     }
                                                                              //Vista de red en grafica
                                                                              if (strModulo.equals("red_grafica")) {
                                                                           %><jsp:include page="../../modules/mod_fz/red_grafica.jsp" />
                                                                           <%                     }
                                                                              //Compensacion
                                                                              if (strModulo.equals("FZWebCompensacion")) {
                                                                           %><jsp:include page="../../modules/mod_fz/compensacion.jsp" />
                                                                           <%}
                                                                              //Ventas
                                                                              if (strModulo.equals("FZWebVentas")) {
                                                                           %><jsp:include page="../../modules/mod_fz/ventas.jsp" />
                                                                           <%}
                                                                              //Sugerencias
                                                                              if (strModulo.equals("FZWebSugerencias")) {
                                                                           %><jsp:include page="../../modules/mod_fz/sugerencias.jsp" />
                                                                           <%}
                                                                              //Sugerencias
                                                                              if (strModulo.equals("ingresos_save")) {
                                                                           %><jsp:include page="../../modules/mod_fz/ingresos_save.jsp" />
                                                                           <%}
                                                                              //Sugerencias_save
                                                                              if (strModulo.equals("sugerencias_save")) {
                                                                           %><jsp:include page="../../modules/mod_fz/sugerencias_save.jsp" />
                                                                           <%                     }
                                                                              //ecommerce
                                                                              if (strModulo.equals("ecomm_cat")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_cat.jsp" />
                                                                           <%                     }
                                                                              //ecommerce deta
                                                                              if (strModulo.equals("ecomm_cat_deta")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_cat_deta.jsp" />
                                                                           <%                     }
                                                                              //ecommerce checkout
                                                                              if (strModulo.equals("ecomm_checkout")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_car_checkout.jsp" />
                                                                           <%                     }
                                                                              //ecommerce ecomm_car_checkout_sell
                                                                              if (strModulo.equals("ecomm_car_checkout_sell")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_car_checkout_sell.jsp" />
                                                                           <%                     }
                                                                              //ecommerce ecomm_car_checkout_sell
                                                                              if (strModulo.equals("ecomm_car_checkout_confirm")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_car_checkout_confirm.jsp" />
                                                                           <%                     }
                                                                              //ecommerce ecomm_car_checkout_sucess
                                                                              if (strModulo.equals("ecomm_car_checkout_sucess")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_car_checkout_sucess.jsp" />
                                                                           <%                     }
                                                                              //ecommerce ecomm_car_checkout_sucess
                                                                              if (strModulo.equals("payment/pp_standard/callback")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_car_paypal_callback.jsp" />
                                                                           <%                     }
                                                                              //ecommerce ecomm_paypal_fail
                                                                              if (strModulo.equals("ecomm_paypal_fail")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_paypal_fail.jsp" />
                                                                           <%                     }
                                                                              //ecommerce ecomm_car_payment_client_dr
                                                                              if (strModulo.equals("ecomm_car_payment_client_dr")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_car_payment_client_dr.jsp" />
                                                                           <%                     }
                                                                              //ecommerce ecomm_compropago_fail
                                                                              if (strModulo.equals("ecomm_compropago_fail")) {
                                                                           %><jsp:include page="../../modules/mod_ecomm/ecomm_compropago_fail.jsp" />
                                                                           <%                     }
                                                                              //Formulario edit ingresos
                                                                              if (strModulo.equals("FZWebEditIngresos")) {
                                                                           %><jsp:include page="../../modules/mod_fz/ingresos_edit.jsp" />
                                                                           <%                     }
                                                                              //guarda modificacion
                                                                              if (strModulo.equals("FZWebEditIngresosSave")) {
                                                                           %><jsp:include page="../../modules/mod_fz/ingresos_edit_save.jsp" />
                                                                           <%                     }
                                                                              //Cambio de Contraseña
                                                                              if (strModulo.equals("FZWebCambioContrasena")) {
                                                                           %><jsp:include page="../../modules/mod_fz/cambio_contrasena.jsp" />
                                                                           <%}
                                                                              //Ingresos externos
                                                                              if (strModulo.equals("NewIng")) {
                                                                           %><jsp:include page="../../modules/mod_fz/ingresos_part2.jsp" />
                                                                           <%}
                                                                              //Catalogo
                                                                              if (strModulo.equals("catalogo_flash")) {
                                                                           %><jsp:include page="../../modules/mod_catalogo/catalogo.jsp" />
                                                                           <%}
                                                                              //Modulos por base de datos
                                                                              String strSqlMod = "SELECT "
                                                                                      + " ecom_modules.MOD_ID, "
                                                                                      + " ecom_modules.MOD_POSITION, "
                                                                                      + " ecom_modules.MOD_NAME, "
                                                                                      + " ecom_modules.MOD_PATHBASE, "
                                                                                      + " ecom_modules.MOD_JAVASCRIPT, "
                                                                                      + " ecom_modules.MOD_HTML, "
                                                                                      + " ecom_modules.MOD_CSS "
                                                                                      + " FROM ecom_modules where MOD_POSITION = 'position-center'";
                                                                              rs = oConn.runQuery(strSqlMod, true);
                                                                              while (rs.next()) {
                                                                                 if (strModulo.equals(rs.getString("MOD_NAME"))) {
                                                                                    //Carga javascript
                                                                                    if (!rs.getString("MOD_JAVASCRIPT").isEmpty()) {
                                                                                       String strPathFileX = rs.getString("MOD_PATHBASE") + "/" + rs.getString("MOD_JAVASCRIPT");
                                                                           %>
                                                                           <script type="text/javascript" src="../../modules/<%=strPathFileX%>"></script> 
                                                                           <%
                                                                              }
                                                                              //Carga css
                                                                              if (!rs.getString("MOD_CSS").isEmpty()) {
                                                                                 String strPathFileX = rs.getString("MOD_PATHBASE") + "/" + rs.getString("MOD_CSS");
                                                                           %>
                                                                           <link rel="stylesheet" type="text/css" href="../../modules/<%=strPathFileX%>"> 
                                                                              <%
                                                                                 }
                                                                                 //Carga modulo
                                                                                 if (!rs.getString("MOD_HTML").isEmpty()
                                                                                         && !rs.getString("MOD_PATHBASE").isEmpty()) {
                                                                                    String strPathFileX = "../../modules/" + rs.getString("MOD_PATHBASE") + "/" + rs.getString("MOD_HTML");
                                                                              %>
                                                                              <jsp:include page="<%= strPathFileX%>" flush="true" />
                                                                              <%
                                                                                       }
                                                                                    }

                                                                                 }
                                                                                 rs.close();
                                                                                 //******************* MODULOS DE FUERZA DE VENTAS ****************
%>
                                                                              <!-- End Content -->



                                                                              <%
                                                                                 }
                                                                              %>
                                                                              <!--content -->   
                                                                              </div>



                                                                              </div>



                                                                              <!-- Footer -->

                                                                              <div id="footer">
                                                                                 <div class="contact">
                                                                                    <p class="heading" style="font-size:18px; color:#000;" align="center">TIENDA</p>
                                                                                    <p style="font-size:14px; color:#000;" align="center">CALLE NORTE 45#1017 LOCAL 5, COL. INDUSTRIAL VALLEJO DEL. AZCAPOTZALCO CP 02300, CIUDAD DE MEXICO</p>
                                                                                 </div>
                                                                                 <div class="clsFooter border_top">
                                                                                    <div class="row">  
                                                                                       <div class="column">
                                                                                          <h3 style="text-align: center;">LLAMANOS</h3>
                                                                                          <div class="telphone" style="text-align: center;">53 68 24 97</div>
                                                                                       </div>

                                                                                       <div class="column border">

                                                                                          <h3>SÍGUENOS</h3>
                                                                                          <div class="social_icons">
                                                                                             <div class="block">
                                                                                                <a href="https://www.facebook.com/pages/Casa-Josefa/313588212135984?fref=ts"><img src="http://casajosefa.com/catalog/view/theme/mystore/image/social_icons/facebook.png"></a>
                                                                                             </div>
                                                                                             <div class="block">
                                                                                                <a href="https://twitter.com/Casajosefa"><img src="http://casajosefa.com/catalog/view/theme/mystore/image/social_icons/twitter.png"></a>
                                                                                             </div>
                                                                                             <div class="block">
                                                                                                <a href="http://casajosefaoficial.tumblr.com/"><img src="http://casajosefa.com/catalog/view/theme/mystore/image/social_icons/twits.png"></a>
                                                                                             </div>
                                                                                             <div class="block">
                                                                                                <a href="https://www.youtube.com/channel/UCqwoL9651WytGQlR6cQOgEA"><img src="http://casajosefa.com/catalog/view/theme/mystore/image/social_icons/youtube.png"></a>
                                                                                             </div>
                                                                                             <div class="block">
                                                                                                <a href="http://instagram.com/casa_josefa"><img src="http://casajosefa.com/catalog/view/theme/mystore/image/social_icons/instagram.png"></a>
                                                                                             </div>
                                                                                             <div class="block">
                                                                                                <a href="http://es.pinterest.com/casajosefa/"><img src="http://casajosefa.com/image/20x20-01.png"></a>
                                                                                             </div>
                                                                                          </div>
                                                                                       </div>

                                                                                       <div class="column">
                                                                                          <h3 class="title_lateral">SUSCRÍBETE</h3>
                                                                                          <div id="ani_content" style="margin-left: 15px;">

                                                                                             <div class="ani_newsblock">
                                                                                                <div>							
                                                                                                   <form name="subscribe" id="subscribe">
                                                                                                      <input style="width:162px; height:22px; margin-left:12px; float:left" name="subscribe_email" id="subscribe_email" class="large-field" placeholder="Tu E-mail" type="text">			        		
                                                                                                         <input onclick="email_subscribe()" class="newsform-btn-field" value="Submit" type="button">
                                                                                                            </form>
                                                                                                            <div style="clear:both"></div>
                                                                                                            <div id="mensaje_newsletter" style="margin-left: 12px;margin-top: 5px;color: #808080;display:none"></div>

                                                                                                            </div>

                                                                                                            </div>			        
                                                                                                            </div>
                                                                                                            <style type="text/css">
                                                                                                               .newsform-btn-field{
                                                                                                                  float: left;
                                                                                                                  background-color: #F8F8F8;
                                                                                                                  border: 1px solid #CCC;
                                                                                                                  border-left: 0px;
                                                                                                                  text-decoration: none;
                                                                                                                  font-size: 12px;
                                                                                                                  padding: 5px 10px;
                                                                                                                  line-height: 18px;
                                                                                                                  color: #333;
                                                                                                                  cursor: pointer;
                                                                                                                  position: absolute;
                                                                                                                  margin: 0px;
                                                                                                               }

                                                                                                               .newsform-btn-field:hover{
                                                                                                                  background-color: #000;
                                                                                                                  color: white;
                                                                                                               }
                                                                                                            </style>
                                                                                                            </div>
                                                                                                            </div>
                                                                                                            <br style="clear:both">
                                                                                                               </div>

                                                                                                               <br style="clear:both">
                                                                                                                  <ul class="principal">


                                                                                                                     <li>	
                                                                                                                        <a href="http://casajosefa.com/index.php?route=information/information&amp;information_id=11">Preguntas Frecuentes</a>
                                                                                                                        <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>      </li>      



                                                                                                                     <li>	
                                                                                                                        <a href="http://casajosefa.com/index.php?route=information/information&amp;information_id=6">Informacion de Envios</a>
                                                                                                                        <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>      </li>      



                                                                                                                     <li>	
                                                                                                                        <a href="http://casajosefa.com/index.php?route=information/information&amp;information_id=7">Políticas de Devolucion</a>
                                                                                                                        <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>      </li>      



                                                                                                                     <li>	
                                                                                                                        <a href="http://casajosefa.com/index.php?route=information/information&amp;information_id=5">Terminos y Condiciones</a>
                                                                                                                     </li>      



                                                                                                                  </ul>
                                                                                                                  <br style="clear:both">
                                                                                                                     <ul class="second">  		


                                                                                                                        <li><a href="http://casajosefa.com/index.php?route=information/information&amp;information_id=10">Contacto</a> 
                                                                                                                           <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>      </li>      



                                                                                                                        <li><a href="http://casajosefa.com/index.php?route=information/information&amp;information_id=4">Acerca de Casa Josefa</a> 
                                                                                                                           <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>      </li>      



                                                                                                                        <li><a href="http://casajosefa.com/index.php?route=information/information&amp;information_id=8">Bolsa de Trabajo</a> 
                                                                                                                           <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>      </li>      



                                                                                                                       


                                                                                                                     </ul>
                                                                                                                     <br style="clear:both">
                                                                                                                        <br style="clear:both">
                                                                                                                           <br style="clear:both">
                                                                                                                              </div>



                                                                                                                              </body>
                                                                                                                              </html>
                                                                                                                              <%
                                                                                                                                 oConn.close();
                                                                                                                              %>