<%-- 
    Document   : menu_right
    Created on : 30-ago-2014, 12:38:52
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="com.mx.siweb.ui.web.TemplateParams"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
   oConn.close();
%>
<div class="well ">
   <h3 class="page-header">Oficina Virtual: </h3>
   <h4>&nbsp;<%=varSesiones.getStrUser() %></h4>
   <div id="accordion">

      <h3>Mi información</h3>
      <div>
         <ul>            
            <li><a href="index.jsp?mod=FZWebEditIngresos" class="aMenu"><img src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/MI INFORMACION.png"%>" border="0" width="40" height="40" alt="Mis datos" title="Mis datos" />Mis datos</a></li>
            <li><a href="index.jsp?mod=FZWebCambioContrasena" class="aMenu"><img src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/CAMBIAR CONTRA.png"%>" border="0" width="40" height="40" alt="Cambio password" title="Cambio password" />Cambio password</a></li>
         </ul>
      </div>
      <h3>Mi organizacion</h3>
      <div>
         <ul>
            <li><a href="index.jsp?mod=FZWebIngresos" class="aMenu"><img src="images/INGRESOS.jpg" border="0" width="40" height="40" alt="Ingresos" title="Ingresos" />Ingresos</a></li>
            <li><a href="index.jsp?mod=FZWebRed" class="aMenu"><img src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/RED.png"%>" border="0" width="40" height="40" alt="Mi Red" title="Mi Red" />Mi Red</a></li>
            <li><a href="#" class="aMenu"><img src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/REFERENCIADAS-01.png"%>" border="0" width="40" height="40" alt="Mi Red" title="Mi Red" />Referenciadas</a></li>
         </ul>
      </div>
      <h3>Mis reportes</h3>
      <div>
         <ul>
            <li><a href="index.jsp?mod=FZWebCompensacion" class="aMenu"><img src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/COMPENSACION.png"%>" border="0" width="40" height="40" alt="Compensacion" title="Compensacion" />Compensaci&oacuten</a></li>
            <li><a href="index.jsp?mod=FZWebVentas" class="aMenu"><img src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/VENTAS.png"%>" border="0" width="40" height="40" alt="Ventas" title="Ventas" />Ventas</a></li>
         </ul>
      </div>
      <h3>Mis notificaciones</h3>
      <div>
         <ul>
            <li><a href="index.jsp?mod=FZWebSugerencias" class="aMenu"><img src="<%=webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/SUGERENCIAS.png"%>" border="0" width="40" height="40" alt="Sugerencias" title="Sugerencias" />Sugerencias</a></li>
         </ul>
      </div>
   </div>
   <form action="index.jsp?mod=FZWebLogOut" method="post" id="login-form" class="form-inline">
      <div class="logout-button">
         <input type="submit" name="Submit" class="button" value="Salir"/>
      </div>
   </form>
</div>
<script type="text/javascript">
   /* $('#menu').circleMenu({
    item_diameter: 40,
    circle_radius: 100,
    direction: 'bottom-right'
    });
    */
   $(function() {
      $("#accordion").accordion();
   });
</script>