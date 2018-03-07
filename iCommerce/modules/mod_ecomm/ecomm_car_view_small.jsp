<%-- 
    Document   : ecomm_car_view_small
Solo despliega el listado del carrito de compras
    Created on : 05-sep-2014, 5:37:33
    Author     : ZeusGalindo
--%>

<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%

//Abrimos la conexion
   Conexion oConn = new Conexion(null, this.getServletContext());
   oConn.open();

   //Obtenemos la tasa de impuesto por aplicar
   double dblFactorImpuesto = 0;
   String strSql = "select * from vta_tasaiva where TI_ID = 1";
   ResultSet rs = oConn.runQuery(strSql);
   while (rs.next()) {
      dblFactorImpuesto = rs.getDouble("TI_TASA");
   }
   rs.close();
      //Configuracion sitio
   Site webBase = new Site(oConn);
   %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
   <form action="index.jsp?mod=ecomm_checkout" method="post" enctype="multipart/form-data">
      <div class="cart-info" style="border:0px">
         <table border="0" cellpadding="0" cellspacing="0">
            <thead>
               <tr>
                  <td class="image" style="border:0;">&nbsp;</td>
                  <td class="name">Producto</td>
                  <td class="model">Modelo</td>
                  <td class="quantity">Cantidad</td>
                  <td class="price">Precio</td>
                  <td class="total">Total</td>
               </tr>
            </thead>
            <tbody>
               <%
                  //Pintamos el contenido del carrito de compras
                  //Recuperamos informacion del carrito de compras
                  String strLst = Sesiones.gerVarSession(request, "CarSell");
                  JSONObject objJsonCarrito = new JSONObject();
                  JSONArray jsonChild = null;
                  double dblTotal = 0;
                  //Parseamos el objeto json
                  objJsonCarrito = new JSONObject(strLst);
                  jsonChild = objJsonCarrito.getJSONArray("carritoCompras");

                  //Obtenemos el resumen del carrito
                  for (int i = 0; i < jsonChild.length(); i++) {
                     JSONObject row = jsonChild.getJSONObject(i);
                     dblTotal += row.getDouble("Precio") * row.getInt("Cantidad");
                  }
                  //Calculamos el impuesto 
                  double dblSubTotal = dblTotal / (1 + (dblFactorImpuesto / 100));
                  double dblImpuesto = dblTotal - dblSubTotal;
                  //Obtenemos el resumen del carrito
                  for (int i = 0; i < jsonChild.length(); i++) {
                     JSONObject row = jsonChild.getJSONObject(i);
                     double dblImporte = row.getDouble("Precio") * row.getInt("Cantidad");
                     //Obtenemos imagen
                     String strImg1 = "";
                     strSql = "select  PR_NOMIMG1,PR_NOMIMG2,PR_NOMIMG3 "
                             + "from vta_producto "
                             + " where PR_ID = " + row.getInt("ProducId") + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1"
                             + " ";
                     rs = oConn.runQuery(strSql, true);
                     while (rs.next()) {
                        strImg1 = rs.getString("PR_NOMIMG1");
                     }
                     rs.close();
                     String strNombreImagen = webBase.getUrlSite().replace("/iCommerce/", "") + strImg1;
                     strNombreImagen = "http://casajosefa.com/" + strImg1;
               %>
               <tr>
                  <td class="image" style="border:0;">
                     <a href="index.jsp?mod=ecomm_cat_deta&product_id=<%=row.getInt("ProducId")%>">
                        <img src="<%=strNombreImagen%>" alt="<%=row.getString("Modelo")%>" title="Modelo"  width="74" height="74" /></a>
                  </td>
                  <td class="name"><a href="index.jsp?mod=ecomm_cat&cat_id=<%=row.getInt("ModeloId")%>"><%=row.getString("Modelo")%></a>
                     <div>
                        - <small>Colores: <%=row.getString("Color")%></small><br />
                        - <small>Tallas: <%=row.getString("Talla")%></small><br />
                     </div>
                  </td>
                  <td class="model"><%=row.getString("Codigo")%></td>
                  <td align="center"><%=row.getInt("Cantidad")%></td>
                  <td class="price">MX $<%=NumberString.FormatearDecimal(dblImporte, 2)%></td>
                  <td class="total">MX $<%=NumberString.FormatearDecimal(dblImporte, 2)%></td>            
               </tr>
               <%
                  }
               %>
            </tbody>
         </table>
      </div>
   </form>

   <div class="cart-total" style="border:0px">


      <table id="total" style="color:#000;" width="380">
         <tr>
            <td class="left" style="padding: 0px !Important; text-transform: uppercase;"><b>Sub-Total:</b></td>
            <td class="right">MX $<%=NumberString.FormatearDecimal(dblSubTotal, 2)%></td>
         </tr>
         <tr>
            <td class="left" style="padding: 0px !Important; text-transform: uppercase;"><b>Impuesto:</b></td>
            <td class="right">MX $<%=NumberString.FormatearDecimal(dblImpuesto, 2)%></td>
         </tr>
         <tr>
            <td class="left" style="padding: 0px !Important; text-transform: uppercase;"><b>Total:</b></td>
            <td class="right">MX $<%=NumberString.FormatearDecimal(dblTotal, 2)%></td>
         </tr>
      </table>
      <div class="info" style="clear:both; float:right; margin-top:30px; border-top:1px solid #CCC; padding-top:10px">
         ¿Problemas o dudas en tu orden? 01 (55) 55 30 22 21 
      </div>
      <div class="info" style="clear:both; float:right; margin-top:30px; padding-top:10px">
         <img src="http://casajosefa.com/catalog/view/theme/mystore/image/payment_paypal.png">
         <img src="http://casajosefa.com/catalog/view/theme/mystore/image/payment_visa.png">
         <img src="http://casajosefa.com/catalog/view/theme/mystore/image/payment_mastercard.png">
      </div>  
   </div>
<%
   
oConn.close();
%>