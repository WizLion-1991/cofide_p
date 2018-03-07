<%-- 
    Document   : ecomm_car_checkout_sucess
    Created on : 04-sep-2014, 16:16:40
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="content">
<div id="content-top">
	</div>
  
  
<div class="bread_center">

	<div class="breadcrumb">
	        <a href="">BOLSA DE COMPRAS</a>
         » <a href="">REGISTRO</a>
         » <a href="">ENVIO</a>
         » <a href="">PAGO</a>
         » <a href="" style="color:gray">GRACIAS</a>
      </div>
  
</div>
  
  
  <h1>Tu pedido ha sido procesado!</h1>
    <div class="buttons">
       <%
       if(request.getParameter("banamex") != null){
          %>
          N&uacute;mero de orden:<%=request.getParameter("orderInfo")%><br>
          N&uacute;mero de recibo:<%=request.getParameter("receiptNo")%><br>
          N&uacute;mero de autorizaci&oacute;n:<%=request.getParameter("authorizeID")%><br>
          <%
       }
       %>
    <div class="right"><a class="button" href="index.jsp"><span>Continuar</span></a></div>
  </div>
  </div>
<%
   //Limpiamos el carrito de compras anterior
   Sesiones.SetSession(request, "CarSell", "0");
%>