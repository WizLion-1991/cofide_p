<%-- 
    Document   : ecomm_right
    Created on : Dec 2, 2015, 11:35:39 AM
    Author     : CasaJosefa
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

      //Evaluamos si tenemos acceso a los modulos
      if (strEvalPassword1.equals("0")) {
   %>
   <div class="well ">
      <h3 class="h3_right"><a href="index.jsp?mod=ecomm"><img src="modules/mod_goonlife/images/Carrito.png" border="0" alt="Carrito de compras" title="Carrito de compras" />&nbsp;Carrito de compras&nbsp;</a></h3>
            <%
               //ecommerce
               if (strModulo.equals("ecomm")) {
            %>
      <h2 class="h2_right">Num. de items:&nbsp;<span id="Total_cantidad" class="iQty">0</span></h3>
         <h2 class="h2_right">Total:&nbsp;<span id="Total_importe" class="iTotal">$0.0</span></h3>
            <h2 class="h2_right"><input type="button" name="Submit" class="btn btn-primary" value="Checkout" onclick="guardarCompra();" /><br><br><input type="button" name="Submit" class="btn btn-primary" value="Limpiar compra" onclick="limpiarCompra();" /></h3>
               </div>
               <%} else {
               %>
            </div>
               <%               }         
      }
%>
