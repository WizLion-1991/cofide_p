<%-- 
    Document   : redOrgChart
    Created on : 30-ago-2014, 13:47:13
    Author     : ZeusGalindo
--%>
<%@page import="com.mx.siweb.ui.web.TemplateParams"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mx.siweb.mlm.utilerias.Redes"%>
<%@page import="Tablas.vta_cliente"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0) {

      
%>
<iframe src="modules/mod_capitalia/redOrgChartIframe.jsp" id="container" style="width:90%;height:1000px;"></iframe>
<%
   }
%>
