<%-- 
    Document   : CIP_Exporta
    Exporta a excel el contenido de los catalogos
    Created on : 28/10/2010, 02:12:03 PM
    Author     : zeus
--%>
<%@page import="java.net.URLDecoder"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Operaciones.CIP_Form" %>
<%@page import="comSIWeb.Operaciones.Bitacora" %>
<%@page import="comSIWeb.Operaciones.CIP_Tabla" %>
<%@page import="Tablas.Usuarios" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.SQLException" %>
<%
      /*Obtenemos las variables de sesion*/
      VariableSession varSesiones = new VariableSession(request);
      varSesiones.getVars();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      //oConn.open();
      //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
      Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
      if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
         //Recuperamos los datos
         String strExporta = request.getParameter("datos_a_enviar");
         if (strExporta == null) {
            strExporta = "";
         }
         response.setContentType("application/vnd.ms-excel;charset=UTF-8");
         response.setHeader("content-disposition", "attachment; filename=ExportaDatos.xls");
         response.setHeader("cache-control", "no-cache");
         %>
         <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es">
         <meta http-equiv="content-type" content="application/vnd.ms-excel; charset=utf-8" />
         <head></head>
         <body>
         <%

         //strExporta = URLDecoder.decode(strExporta, "utf-8");
         String strCols = request.getParameter("Cols");
         String strRows = request.getParameter("Rows");

         out.println("<p xml:lang='es'>");
         out.println("<table>");
         for (int i = 0; i <= Integer.valueOf(strRows); i++) {
            out.println("<tr>");
            for (int j = 0; j <= Integer.valueOf(strCols); j++) {
               String strValor = request.getParameter("Fila" + i + "td" + j);

               out.println("<td>" + strValor + "</td>");
            }

            out.println("</tr>");
         }
         out.println("</table>");
         out.println("</p>");
         %>
         </body>
         </html>
         <%
         //out.println(strExporta);
      } else {
      }
      //oConn.close();
%>