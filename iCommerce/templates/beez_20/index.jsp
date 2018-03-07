<%-- 
    Document   : index
    Pagina inicial para el template de pagina ecommcer para la fuerza de ventas
    Created on : 03-feb-2013, 2:20:40
    Author     : aleph_79
--%>
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
   TemplateParams templateparams = new TemplateParams(oConn, "beez_20", webBase.getStrLanguage());
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
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/system/css/system.css", "", "");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/position.css", "text/css", "screen,projection");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/layout.css", "text/css", "screen,projection");
   //doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/print.css", "text/css", "print");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/general.css", "", "");
   if (browserType.contains("Opera")) {
      doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/general_opera.css", "", "");
   }
   if (browserType.contains("Firefox")) {
      doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/general_mozilla.css", "", "");
   }
   if (browserType.contains("konqueror")) {
      doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/general_konqueror.css", "", "");
   }

   if (webBase.getStrDirection().equals("ltr")) {
      doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/template_rtl.css", "", "");
   }
   if (!strColor.isEmpty()) {
      doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/" + strColor + ".css", "", "");
   }
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/template.css", "", "");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/superfish.css", "", "");
   //mootools
   /*doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/mootools-core.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/core.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/caption.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/mootools-more.js", "text/javascript");*/
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery-1.9.1.min.js", "text/javascript");
   //doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/cufon-yui.js", "text/javascript");
   //doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/swiss.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/hoverIntent.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/superfish.js", "text/javascript");
   /*doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery.colorbox.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/behaviour.js", "text/javascript");
   do c.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery-1.3.1.min.js", "text/javascript");
   doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery.orbit-1.2.3.min.js", "text/javascript");*/
   /*doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/style.css", "","");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/colorbox.css", "","");
   doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/orbit-1.2.3.css", "","");*/



   //custom
   //doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/md_stylechanger.js", "text/javascript");
   //doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/hide.js", "text/javascript");
   /*
   if (file_exists(JPATH_SITE . '/templates/' . $this->template . '/css/' . $color . '_rtl.css')) {
   $doc->addStyleSheet($this->baseurl.'/templates/'.$this->template.'/css/'.htmlspecialchars($color).'_rtl.css');
   }
   }*/
   //Evaluamos que modulo representar
   String strModulo = request.getParameter("mod");
   if (strModulo == null) {
      strModulo = "inicio";
   }

   //Validamos si es un modulo de fuerza de ventas para validar que tenga acceso
   //FZWeb
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%= webBase.getStrLanguage()%>" lang="<%= webBase.getStrLanguage()%>" dir="<%= webBase.getStrDirection()%>" >
   <head>
      <%= webBase.getHeader(templateparams)%>
      <%= doc.writeHtmlStyles()%>
      <%= doc.writeHtmlJavaScript()%>

      <!--[if lte IE 6]>
      <link href="<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/css/ieonly.css" rel="stylesheet" type="text/css" />
      <%if (strColor.equals("personal")) {%>
      <style type="text/css">
      #line {
         width:98% ;
      }
      .logoheader {
         height:200px;
      }
      #header ul.menu {
         display:block !important;
         width:98.2% ;
      }
      </style>
      <%}%>
      <![endif]-->

      <!--[if IE 7]>
      <link href="<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/css/ie7only.css" rel="stylesheet" type="text/css" />
      <![endif]-->

      <script type="text/javascript">
         var big ='<%=templateparams.getJText("wrapperLarge")%>%';
         var small='<%=templateparams.getJText("wrapperSmall")%>%';
         var altopen='<%=templateparams.getJText("TPL_BEEZ2_ALTOPEN")%>';
         var altclose='<%=templateparams.getJText("TPL_BEEZ2_ALTCLOSE")%>';
         var bildauf='<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/images/plus.png';
         var bildzu='<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/images/minus.png';
         var rightopen='<%=templateparams.getJText("TPL_BEEZ2_TEXTRIGHTOPEN")%>';
         var rightclose='<%=templateparams.getJText("TPL_BEEZ2_TEXTRIGHTCLOSE")%>';
         var fontSizeTitle='<%=templateparams.getJText("TPL_BEEZ2_FONTSIZE")%>';
         var bigger='<%=templateparams.getJText("TPL_BEEZ2_BIGGER")%>';
         var reset='<%=templateparams.getJText("TPL_BEEZ2_RESET")%>';
         var smaller='<%=templateparams.getJText("TPL_BEEZ2_SMALLER")%>';
         var biggerTitle='<%=templateparams.getJText("TPL_BEEZ2_INCREASE_SIZE")%>';
         var resetTitle='<%=templateparams.getJText("TPL_BEEZ2_REVERT_STYLES_TO_DEFAULT")%>';
         var smallerTitle='<%=templateparams.getJText("TPL_BEEZ2_DECREASE_SIZE")%>';

         // JavaScript Document
         $(document).ready(function(){
            // initialise plugin
				var menu = $('#menu_fz').superfish({
					//add options here if required
				});
            

         });
      </script>

   </head>
   <body>
      <div id="all">
         <div id="back">
            <div id="header">
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
                     </span></h1>
               </div>
               <!-- end logoheader -->

               <ul class="skiplinks">
                  <li><a href="#main" class="u2"><%=templateparams.getJText("TPL_BEEZ2_SKIP_TO_CONTENT")%></a></li>
                  <li><a href="#nav" class="u2"><%=templateparams.getJText("TPL_BEEZ2_JUMP_TO_NAV")%></a></li>
                  <%if (showRightColumn == 1) {%>
                  <li><a href="#additional" class="u2"><%=templateparams.getJText("TPL_BEEZ2_JUMP_TO_INFO")%></a></li>
                  <%}%>
               </ul>
               <h2 class="unseen"><%=templateparams.getJText("TPL_BEEZ2_NAV_VIEW_SEARCH")%></h2>
               <h3 class="unseen"><%=templateparams.getJText("TPL_BEEZ2_NAVIGATION")%></h3>
               <%=doc.getModule("", "position-1", "", "")%>
               <div id="line">
                  <div id="fontsize"></div>
                  <h3 class="unseen"><%=templateparams.getJText("TPL_BEEZ2_SEARCH")%></h3>
                  <%=doc.getModule("", "position-0", "", "")%>
               </div> <!-- end line -->
               <!--Menu Area -->
               <jsp:include page="../../modules/mod_menu/menu.html" />

            </div><!-- end header -->
            <!--Contenedor Body -->
            <div class="row-fluid">
               <div id="content" class="span9">
                  <div class="moduletable">

                  </div>
                  <div class="item-page">

                  </div>

                  <ul class="breadcrumb">
                     <li class="active">
                        <span class="divider icon-location hasTooltip" data-original-title="You are here: "/>
                     </li>
                     <li>
                        <span>Inicio</span>
                     </li>
                     <%=doc.getModule("", "position-2", "", "")%>
                  </ul>



                  <%if (strNavposition.equals("left") && showleft == 1) {%>
                  <div class="left1 <%if (showRightColumn == 0) {
                        out.println("leftbigger");
                     }%>" id="nav">
                     <%=doc.getModule("", "position-7", "beezDivision", "3")%>
                     <%=doc.getModule("", "position-4", "beezHide", "3")%>
                     <%=doc.getModule("", "position-5", "beezTabs", "2")%>
                  </div>
                  <!-- end navi -->

                  <%}%>
                  
                  <!--wrapper -->
                  <div id="<%if (showRightColumn == 0) {
                        out.println("wrapper");
                     } else {
                        out.println("wrapper2");
                     }%>" <% if (showno == 1) {
                           out.println("class=\"shownocolumns\"");
                        }%>>
                     <!--main -->
                     <div id="main" role="main">

                        <% if (doc.getLstCountModules().contains("position-12")) {%>
                        <div id="top"><%=doc.getModule("", "position-12", "", "")%>
                        </div>
                        <%}%>
                        <%=doc.getMessage("")%>       
                        <%=doc.getComponent("")%>
                        <%
                           //Cargamos el modulo requerido
                           if (strModulo.equals("FZWebLogOut")) {
                              %><jsp:include page="../../modules/mod_fz/logout.jsp" /><%   
                           }
                           if (strModulo.equals("FZWebLogin2")) {
                              %><jsp:include page="../../modules/mod_fz/login_eval.jsp" /><%                        
                           }


                        %>
                     </div><!-- end main -->

                  </div><!-- end wrapper -->
                  
               </div> <!-- end contentarea -->
               <%if (showRightColumn == 1) {%>
               <h2 class="unseen">
                  <%=templateparams.getJText("TPL_BEEZ2_ADDITIONAL_INFORMATION")%>
               </h2>



               <div id="aside" class="span3">
                  <a id="additional"></a>
                  <!--Formato de login-->
                  <jsp:include page="../../modules/mod_fz/login.html" />
                  <!--Formato de login-->
                  <%=doc.getModule("", "position-6", "beezDivision", "3")%>
                  <%=doc.getModule("", "position-8", "beezDivision", "3")%>
                  <%=doc.getModule("", "position-3", "beezDivision", "3")%>
               </div>
               <!-- end right -->

               <%}%>
            </div>
            <!--End Contenedor Body -->
            <% if (strNavposition.equals("center") && showleft == 1) {%>

            <div class="left <%if (showRightColumn == 0) {
                  out.println("leftbigger");
               }%>" id="nav" >
               <%=doc.getModule("", "position-7", "beezDivision", "3")%>
               <%=doc.getModule("", "position-4", "beezHide", "3")%>
               <%=doc.getModule("", "position-5", "beezTabs", "2")%>


            </div><!-- end navi -->
            <%}%>

            <div class="wrap"></div>



         </div><!-- back -->

      </div><!-- all -->

      <div id="footer-outer">

         <%if (showbottom == 1) {%>

         <div id="footer-inner">
            <div id="bottom">
               <div class="box box1"> <%=doc.getModule("", "position-9", "beezDivision", "3")%></div>
               <div class="box box2"> <%=doc.getModule("", "position-10", "beezDivision", "3")%></div>
               <div class="box box3"> <%=doc.getModule("", "position-11", "beezDivision", "3")%></div>
            </div>
         </div>
         <% }%>

         <div id="footer-sub">


            <div id="footer">
               <%=doc.getModule("", "position-14", "", "")%>
               <p>
                  <%=templateparams.getJText("TPL_BEEZ2_POWERED_BY")%> <a href="http://www.solucionesinformaticas.web.com.mx/">SIWeb!&#174;</a>
               </p>
            </div><!-- end footer -->

         </div>

      </div>
   </body>
</html>
<%
   oConn.close();
%>