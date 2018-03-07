<%-- 
    Document   : ERP_Help
    Despliega el menu de opciones de ayua
    Created on : 10-feb-2015, 16:13:13
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   /*Atributos generales de la pagina*/
   atrJSP.atrJSP(request, response, true, false);
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   Seguridad seg = new Seguridad();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
%>
<div id="HelpMain">
   <div id="fast" class="panel"> 
      <h2>Temas de ayuda rápida.</h2>
      <p>
         Seleccione el tema y en la parte inferior apareceran las instrucciones.
      </p>
      <ul>
         <li><i class="fa fa-user"></i>&nbsp;<a href="javascript:OpnAyudaPPT(2)">Dar de alta clientes</a></li>
         <li><i class="fa fa-database"></i>&nbsp;<a href="javascript:OpnAyudaPPT(3)">Dar de alta productos</a></li>
         <li><i class="fa fa-shopping-cart"></i>&nbsp;<a href="javascript:OpnAyudaPPT(4)">Generar una nueva factura comercial</a></li>
         <li><i class="fa fa-shopping-cart"></i>&nbsp;<a href="javascript:OpnAyudaPPT(5)">Generar una nueva factura de servicios</a></li>
         <li><i class="fa fa-minus"></i>&nbsp;<a href="javascript:OpnAyudaPPT(6)">Generar una nueva nota de credito comercial</a></li>
         <li><i class="fa fa-minus"></i>&nbsp;<a href="javascript:OpnAyudaPPT(7)">Generar una nueva nota de credito de servicios</a></li>
      </ul>
      <p>
         Para consultar los manuales completos entre al siguiente link: <a href="http://soporte.siwebmx.com:9996/kb/c1/base-de-conocimientos" target="_new">http://soporte.siwebmx.com:9996/kb/c1/base-de-conocimientos</a>
      </p>
   </div>
   <div id="deck-container" class="deck-container">

   </div>
</div>
<%         }
   oConn.close();
%>