<%-- 
    Document   : index
    Created on : 03-feb-2013, 1:11:25
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
   TemplateParams templateparams = new TemplateParams(oConn, "beez5", webBase.getStrLanguage());

// get params
   String strcolor = "";
   String strlogo = "";
   String strnavposition = "";
   String strapp = "";
   Document doc = new Document(oConn);
   doc.getInfoModules();
   String browserType = (String) request.getHeader("User-Agent");

%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%if (templateparams.isIsHTML5()) {%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%} else {%>
<!DOCTYPE html>
<%}%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%= webBase.getStrLanguage()%>" lang="<%= webBase.getStrLanguage()%>" dir="<%= webBase.getStrDirection()%>" >
   <head>
      <%= webBase.getHeader(templateparams)%>
      <link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/system/css/system.css" type="text/css" />
      <link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/position.css" type="text/css" media="screen,projection" />
      <link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/layout.css" type="text/css" media="screen,projection" />
      <link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/print.css" type="text/css" media="Print" />
      <link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/beez5.css" type="text/css" />
      <link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/general.css" type="text/css" />
      <%if (browserType.contains("Opera")) {%><link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/general_opera.css" type="text/css" /><%}%>
      <%if (browserType.contains("Firefox")) {%><link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/general_mozilla.css" type="text/css" /><%}%>
      <%if (browserType.contains("konqueror")) {%><link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/general_konqueror.css" type="text/css" /><%}%>

      <%if (webBase.getStrDirection().equals("ltr")) {%>
      <link rel="stylesheet" href="<%=webBase.getUrlSite()%>/templates/<%=templateparams.getNombre()%>/css/template_rtl.css" type="text/css" />
      <%}%>
      <!--[if lte IE 6]>
         <link href="<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/css/ieonly.css" rel="stylesheet" type="text/css" />
      <![endif]-->
      <!--[if IE 7]>
         <link href="<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/css/ie7only.css" rel="stylesheet" type="text/css" />
      <![endif]-->
      <%if (templateparams.isIsHTML5()) {%>
      <!--[if lt IE 9]>
         <script type="text/javascript" src="<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/javascript/html5.js"></script>
      <![endif]-->
      <%}%>
      <script type="text/javascript" src="<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/javascript/hide.js"></script>

      <script type="text/javascript">
         /*
         var big ='<?php echo (int)$this->params->get('wrapperLarge');?>%';
         var small='<?php echo (int)$this->params->get('wrapperSmall'); ?>%';
         var altopen='<?php echo JText::_('TPL_BEEZ5_ALTOPEN', true); ?>';
         var altclose='<?php echo JText::_('TPL_BEEZ5_ALTCLOSE', true); ?>';
         var bildauf='<?php echo $this->baseurl ?>/templates/<?php echo $this->template; ?>/images/plus.png';
         var bildzu='<?php echo $this->baseurl ?>/templates/<?php echo $this->template; ?>/images/minus.png';
         var rightopen='<?php echo JText::_('TPL_BEEZ5_TEXTRIGHTOPEN', true); ?>';
         var rightclose='<?php echo JText::_('TPL_BEEZ5_TEXTRIGHTCLOSE', true); ?>';
         var fontSizeTitle='<?php echo JText::_('TPL_BEEZ5_FONTSIZE', true); ?>';
         var bigger='<?php echo JText::_('TPL_BEEZ5_BIGGER', true); ?>';
         var reset='<?php echo JText::_('TPL_BEEZ5_RESET', true); ?>';
         var smaller='<?php echo JText::_('TPL_BEEZ5_SMALLER', true); ?>';
         var biggerTitle='<?php echo JText::_('TPL_BEEZ5_INCREASE_SIZE', true); ?>';
         var resetTitle='<?php echo JText::_('TPL_BEEZ5_REVERT_STYLES_TO_DEFAULT', true); ?>';
         var smallerTitle='<?php echo JText::_('TPL_BEEZ5_DECREASE_SIZE', true); ?>';*/
      </script>

   </head>
   <body>
      <div id="all">
         <div id="back">
            <%if (templateparams.isIsHTML5()) {%>
            <div id="header">
               <%} else {%>
               <header id="header">
                  <%}%>

                  <div class="logoheader">
                     <h1 id="logo">

                        <%if (templateparams.getLogo() != null) {%>
                        <img src="<%=webBase.getUrlSite()%>/<%=HtmlSpecialChars.Parser(templateparams.getLogo())%>" alt="<%=HtmlSpecialChars.Parser(templateparams.getSitetitle())%>" />
                        <%} else {%>
                        <%=templateparams.getSitetitle()%>
                        <%}%>
                        <span class="header1">
                           <%=templateparams.getSitedescription()%>
                        </span></h1>
                  </div>
                  <!-- end logoheader -->

                  <ul class="skiplinks">
                     <li><a href="#main" class="u2"><?php echo JText::_('TPL_BEEZ5_SKIP_TO_CONTENT'); ?></a></li>
                     <li><a href="#nav" class="u2"><?php echo JText::_('TPL_BEEZ5_JUMP_TO_NAV'); ?></a></li>
                     <?php if($showRightColumn ):?>
                     <li><a href="#additional" class="u2"><?php echo JText::_('TPL_BEEZ5_JUMP_TO_INFO'); ?></a></li>
                     <?php endif; ?>
                  </ul>
                  <h2 class="unseen"><?php echo JText::_('TPL_BEEZ5_NAV_VIEW_SEARCH'); ?></h2>
                  <h3 class="unseen"><?php echo JText::_('TPL_BEEZ5_NAVIGATION'); ?></h3>
                  <!-- Comienzan los elementos de la posición 1-->
                  <jdoc:include type="modules" name="position-1" />
                  <div id="line">
                     <div id="fontsize"></div>
                     <h3 class="unseen"><?php echo JText::_('TPL_BEEZ5_SEARCH'); ?></h3>
                     <jdoc:include type="modules" name="position-0" />
                  </div> <!-- end line -->
                  <div id="header-image">
                     <jdoc:include type="modules" name="position-15" />
                     <?php if ($this->countModules('position-15')==0): ?>
                     <img src="<%=webBase.getUrlSite()%>/<%="templates/" + templateparams.getNombre()%>/images/fruits.jpg"  alt="<?php echo JText::_('TPL_BEEZ5_LOGO'); ?>" />
                     <?php endif; ?>
                  </div>

                  <%if (templateparams.isIsHTML5()) {%>
            </div><!-- end header -->
            <%} else {%>
            </header><!-- end header -->
            <%}%>

            <div id="<?php echo $showRightColumn ? 'contentarea2' : 'contentarea'; ?>">
               <div id="breadcrumbs">

                  <jdoc:include type="modules" name="position-2" />

               </div>

               <?php if ($navposition=='left' and $showleft) : ?>

               <?php if(!$this->params->get('html5', 0)): ?>
               <div class="left1 <?php if ($showRightColumn==NULL){ echo 'leftbigger';} ?>" id="nav">
                  <?php else: ?>
                  <nav class="left1 <?php if ($showRightColumn==NULL){ echo 'leftbigger';} ?>" id="nav">
                     <?php endif; ?>

                     <jdoc:include type="modules" name="position-7" style="beezDivision" headerLevel="3" />
                     <jdoc:include type="modules" name="position-4" style="beezHide" headerLevel="3" state="0 " />
                     <jdoc:include type="modules" name="position-5" style="beezTabs" headerLevel="2"  id="3" />

                     <?php if(!$this->params->get('html5', 0)): ?>
               </div><!-- end navi -->
               <?php else: ?>
               </nav>
               <?php endif; ?>

               <?php endif; ?>

               <div id="<?php echo $showRightColumn ? 'wrapper' : 'wrapper2'; ?>" <?php if (isset($showno)){echo 'class="shownocolumns"';}?>>

                    <div id="main">

                     <?php if ($this->countModules('position-12')): ?>
                     <div id="top"><jdoc:include type="modules" name="position-12"   />
                     </div>
                     <?php endif; ?>

                     <jdoc:include type="message" />
                     <jdoc:include type="component" />

                  </div><!-- end main -->

               </div><!-- end wrapper -->

               <?php if ($showRightColumn) : ?>
               <h2 class="unseen">
                  <?php echo JText::_('TPL_BEEZ5_ADDITIONAL_INFORMATION'); ?>
               </h2>
               <div id="close">
                  <a href="#" onclick="auf('right')">
                     <span id="bild">
                        <?php echo JText::_('TPL_BEEZ5_TEXTRIGHTCLOSE'); ?></span></a>
               </div>

               <?php if (!$templateparams->get('html5', 0)): ?>
               <div id="right">
                  <?php else: ?>
                  <aside id="right">
                     <?php endif; ?>

                     <a id="additional"></a>
                     <jdoc:include type="modules" name="position-6" style="beezDivision" headerLevel="3"/>
                     <jdoc:include type="modules" name="position-8" style="beezDivision" headerLevel="3"  />
                     <jdoc:include type="modules" name="position-3" style="beezDivision" headerLevel="3"  />

                     <?php if(!$templateparams->get('html5', 0)): ?>
               </div><!-- end right -->
               <?php else: ?>
               </aside>
               <?php endif; ?>
               <?php endif; ?>

               <?php if ($navposition=='center' and $showleft) : ?>

               <?php if (!$this->params->get('html5', 0)): ?>
               <div class="left <?php if ($showRightColumn==NULL){ echo 'leftbigger';} ?>" id="nav" >
                  <?php else: ?>
                  <nav class="left <?php if ($showRightColumn==NULL){ echo 'leftbigger';} ?>" id="nav">
                     <?php endif; ?>

                     <jdoc:include type="modules" name="position-7"  style="beezDivision" headerLevel="3" />
                     <jdoc:include type="modules" name="position-4" style="beezHide" headerLevel="3" state="0 " />
                     <jdoc:include type="modules" name="position-5" style="beezTabs" headerLevel="2"  id="3" />

                     <?php if (!$templateparams->get('html5', 0)): ?>
               </div><!-- end navi -->
               <?php else: ?>
               </nav>
               <?php endif; ?>
               <?php endif; ?>

               <div class="wrap"></div>

            </div> <!-- end contentarea -->

         </div><!-- back -->

      </div><!-- all -->

      <div id="footer-outer">

         <?php if ($showbottom) : ?>
         <div id="footer-inner">

            <div id="bottom">
               <?php if ($this->countModules('position-9')): ?>
               <div class="box box1"> <jdoc:include type="modules" name="position-9" style="beezDivision" headerlevel="3" /></div>
               <?php endif; ?>
               <?php if ($this->countModules('position-10')): ?>
               <div class="box box2"> <jdoc:include type="modules" name="position-10" style="beezDivision" headerlevel="3" /></div>
               <?php endif; ?>
               <?php if ($this->countModules('position-11')): ?>
               <div class="box box3"> <jdoc:include type="modules" name="position-11" style="beezDivision" headerlevel="3" /></div>
               <?php endif ; ?>
            </div>
         </div>
         <?php endif ; ?>

         <div id="footer-sub">

            <%if (templateparams.isIsHTML5()) {%>
            <div id="footer">
               <%} else {%>
               <footer id="footer">
                  <%}%>

                  <jdoc:include type="modules" name="position-14" />
                  <p>
                     <?php echo JText::_('TPL_BEEZ5_POWERED_BY');?> <a href="http://www.solucionesinformaticas.web.com.mx/">SIWeb!&#174;</a>
                  </p>

                  <%if (templateparams.isIsHTML5()) {%>
            </div><!-- end footer -->
            <%} else {%>
            </footer>
            <%}%>

         </div>

      </div>
   </body>
</html>
<%
   oConn.close();
%>