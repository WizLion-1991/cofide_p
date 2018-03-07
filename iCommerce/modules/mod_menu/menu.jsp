<%-- 
    Document   : menu
   Pinta el menu del modulo de cliente o distribuidor
    Created on : 16-abr-2013, 14:54:04
    Author     : aleph_79
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
%>
<ul class="sf-menu" id="menu_fz">
   <li class="current">
      <a href="index.jsp">Inicio</a>
   </li>
   <li>
      <a href="#">Nosotros</a>
   </li>
   <li>
      <a href="#">Plan de carrera</a>
   </li>	
   <li>
      <a href="#">Productos</a>
   </li>	
   <li>
      <a href="#">Promociones</a>
   </li>	
   <li>
      <a href="#">Eventos</a>
   </li>	
   <li>
      <a href="#">Testimonios</a>
   </li>	
   <li>
      <a href="#">Contacto y Oficina</a>
   </li>	
   <%
   //Solo si tiene acceso el usuario le mostramos las opciones de oficina virtual
   if (varSesiones.getIntNoUser() != 0 ) {
      %>
      <%
   }
   %>
</ul>