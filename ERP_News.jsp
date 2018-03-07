<%-- 
    Document   : ERP_News
    Created on : 11-feb-2015, 12:53:46
    Author     : ZeusGalindo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/rssutils.tld" prefix="rss" %>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>

<%
   /*Atributos generales de la pagina*/
   atrJSP.atrJSP(request, response, true, false);
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   Seguridad seg = new Seguridad();

   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
%>
<center>
   <div id="rss_news" class="panel">
      <%
         try {
      %>
      <!--RSS para las noticias-->
      <rss:feed
         url="http://www.siwebmx.com/RssSiWeb.xml" feedId="siwebRss"/>
      <b> </b><rss:channelImage feedId="siwebRss"/><br>
      <b><h1><font color="red"><rss:channelTitle feedId="siwebRss"/></font></h1> </b></br>
      <b>Suscribase aquí: </b><rss:channelLink feedId="siwebRss" asLink="true"/> </br>
      <b></b><rss:channelDescription feedId="siwebRss"/><br>
      <ul>
         <rss:forEachItem feedId="siwebRss">
            <li><h2><rss:itemTitle feedId="siwebRss" /></h2> &nbsp;
               <br> <rss:itemDescription feedId="siwebRss"/>&nbsp; </br> 
               <a href='<rss:itemLink feedId="siwebRss" />' target="_new"> Ver más...</a> </br></br>
            </rss:forEachItem>
      </ul>
      <!--RSS para las noticias -->
      <%   } catch (Exception ex) {
         }
      %>

   </div>
</center>
<%         }

%>