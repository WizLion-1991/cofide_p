<%-- 
    Document   : MLM_process
    Created on : 17/03/2012, 05:52:32 AM
    Author     : zeus
Esta pagina se encarga de ejecutar todos los procesos del multinivel, tales como comisiones, armado de arbol etc
--%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.Bitacora" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 ) {
      String strNodo = request.getParameter("NodoId");
      if(strNodo == null){
         strNodo = "1";
      }
      %>
      
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <title>Diagrama de red MLM <%=strNodo%></title>

      <!-- CSS Files -->
      <link type="text/css" href="css/jit/base.css" rel="stylesheet" />
      <link type="text/css" href="css/jit/Spacetree.css" rel="stylesheet" />

      <!--[if IE]><script language="javascript" type="text/javascript" src="jqGrid/excanvas.js"></script><![endif]-->

      <!-- JIT Library File -->
      <script language="javascript" type="text/javascript" src="jqGrid/jit.js"></script>

      <!-- Code file -->
      <script language="javascript" type="text/javascript" src="javascript/mlm_jit1.js"></script>
      <!--jquery -->
      <script type="text/javascript" src="jqGrid/jquery-1.9.0.min.js" ></script>
   </head>

   <body onload="init(<%=strNodo%>);">
      <div id="container">

         <div id="left-container">
         </div>

         <div id="center-container" style=" OVERFLOW: auto; WIDTH: 636px; TOP: 48px; HEIGHT: 332px">
            <div id="infovis"></div>    
         </div>

         <div id="right-container">
         </div>

         <div id="log"></div>
      </div>
   </body>
</html>
<%
   }
   oConn.close();
%>

