<%-- 
    Document   : login_eval
Este jsp se encarga de validar que el usuario tenga permisos
    Created on : 16-abr-2013, 10:29:49
    Author     : aleph_79
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="com.SIWeb.struts.LoginAction"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.SetVars(0, 0, 0, 0, "", "", 0, "", 0);

   //Evaluamos si tiene acceso el usuario
   String strUser = request.getParameter("username");
   String strPass = request.getParameter("password");
   //Objeto para validar la seguridad
   LoginAction action = new LoginAction();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   action.setBolSoloCliente(true);
   action.setBolEsBackOffice(false);
   //solo evaluamos si el password esta lleno
   if (!strPass.isEmpty()) {
      action.authentication_user(oConn, strUser, strPass, request);
   }
   


   //Si tuvimos acceso mostramos la bienvenido sino mostramos error
   if (action.isBolTieneAcceso() && action.isBolAccesoCte()) {
      varSesiones.getVars();
      //Limpiamos el carrito de compras anterior
      Sesiones.SetSession(request, "CarSell", "0");
      //Evaluamos si tiene que cambiar el password
      if (action.isBolCambiarPass()) {
         Sesiones.SetSession(request, "EvalPassword1", "1");
%>
<center>
   <h1>BIENVENIDO USUARIO <%=varSesiones.getStrUser()%></h1>
   <h2>Por motivos de seguridad es necesario cambiar su contraseña</h2>
</center>
<%

} else {
   Sesiones.SetSession(request, "EvalPassword1", "0");
%>
<div id="welcome_fz">
<center>
   <h1>BIENVENIDO</h1>
   <h2><image src="../images/epoints-logo.png" border ="0" alt="Klensy" />&nbsp; <%=varSesiones.getStrUser()%></h2>
</center>
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
</div>
<%
   }

} else {
   String strMsgError = "EL USUARIO O PASSWORD NO COINCIDEN, VERIFIQUELOS";
   if (action.isBolErrorLogged()) {
      strMsgError = "EL USUARIO YA HA INICIADO SESION";
   } else {
      if (action.isBolErrorBloqued()) {
         strMsgError = "EL USUARIO O PASSWORD NO COINCIDEN, VERIFIQUELOS";
      }
   }
%>
<center>
   <h1><%=strMsgError%></h1>
   <a href="index.jsp" class="button">Regresar</a>
</center>

<%         }
   
   oConn.close();
%>
