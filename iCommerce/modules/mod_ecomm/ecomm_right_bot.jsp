<%-- 
    Document   : ecomm_right_bot
    Created on : 24-may-2013, 12:49:37
    Author     : ZeusGalindo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   String strModulo = request.getParameter("mod");
   if (strModulo == null) {
      strModulo = "inicio";
   }
   //ecommerce
   if (strModulo.equals("ecomm")) {
%>
<div class="well" id="ecomm_mas_vendido">
   <h3>&nbsp;Lo más vendido</h3>
   <div id="ecomm_mas_vendido_div"></div>
</div>
<div class="well" id="ecomm_mas_nuevo">
   <h3>&nbsp;Lo más nuevo</h3>
   <div id="ecomm_mas_nuevo_div"></div>
</div>
<%               }%>