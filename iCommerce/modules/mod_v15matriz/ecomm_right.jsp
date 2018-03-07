<%-- 
    Document   : ecomm_right
    Mensajes del carrito de compra que se despliegan del lado derecho
    Created on : 25-abr-2013, 10:15:32
    Author     : aleph_79
--%>

<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   String strModulo = request.getParameter("mod");
   if (strModulo == null) {
      strModulo = "inicio";
   }
   
         //Obtenemos la variable de sesion para cambio de password
      String strEvalPassword1 = Sesiones.gerVarSession(request, "EvalPassword1");
      if (strEvalPassword1 == null) {
         strEvalPassword1 = "0";
      }


%>
