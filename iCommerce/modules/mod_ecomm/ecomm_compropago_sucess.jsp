<%-- 
    Document   : ecomm_compropago_sucess
    Created on : 12-sep-2014, 12:16:27
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<center>
   <div id="compropago_sucess">
      <h2>Se ha generado exitosamente los datos para su pago.</h2>
      <h3>Favor de seguir las instrucciones !</h3>
      <a href="index.jsp" class="button">Ir al menu inicial</a>
   </div>
</center>
<%
   //Limpiamos el carrito de compras anterior
   Sesiones.SetSession(request, "CarSell", "0");
%>