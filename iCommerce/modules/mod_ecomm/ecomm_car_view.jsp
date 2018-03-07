<%-- 
    Document   : ecomm_car_view
    Despliega el checkout mas sencillo...
    Created on : 02-sep-2014, 18:07:26
    Author     : ZeusGalindo
--%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   //Iniciamos valores
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
//Abrimos la conexion
   Conexion oConn = new Conexion(null, this.getServletContext());
   oConn.open();
   Site webBase = new Site(oConn);
   //Recuperamos informacion del carrito de compras
   String strLst = Sesiones.gerVarSession(request, "CarSell");
   JSONObject objJsonCarrito = new JSONObject();
   JSONArray jsonChild = null;
   int intTotCantidad = 0;
   double dblTotal = 0;
   if (!strLst.equals("0")) {
      //Parseamos el objeto json
      objJsonCarrito = new JSONObject(strLst);
      jsonChild = objJsonCarrito.getJSONArray("carritoCompras");

   } else {
      jsonChild = new JSONArray();
   }
   //Obtenemos el resumen del carrito
   for (int i = 0; i < jsonChild.length(); i++) {
      JSONObject row = jsonChild.getJSONObject(i);
      intTotCantidad += row.getInt("Cantidad");
      dblTotal += row.getDouble("Precio") * row.getInt("Cantidad");
   }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="cart">  
   <div class="heading">
      <a><span id="cart-total"><%=intTotCantidad%> Producto(s) - MX $<%=NumberString.FormatearDecimal(dblTotal, 2)%></span></a></div>
   <div class="content">
      <div class="mini-cart-info">

         <%
//Obtenemos el resumen del carrito
            for (int i = 0; i < jsonChild.length(); i++) {
               JSONObject row = jsonChild.getJSONObject(i);
               double dblImporte = row.getDouble("Precio") * row.getInt("Cantidad");
               int intProducId = row.getInt("ProducId");
               //Obtenemos imagen
               String strImg1 = "";
               String strSql = "select  PR_NOMIMG1,PR_NOMIMG2,PR_NOMIMG3 "
                       + "from vta_producto "
                       + " where PR_ID = " + intProducId + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1"
                       + " ";
               ResultSet rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  strImg1 = rs.getString("PR_NOMIMG1");
               }
               rs.close();
               String strNombreImagen = webBase.getUrlSite().replace("/iCommerce/", "") + strImg1;
               strNombreImagen = "http://casajosefa.com/" + strImg1;
         %>
         <div style='margin-bottom: 10px;padding-bottom: 10px;border-bottom: 1px solid #DDD;'>
            <div class="left">
               <a href="index.jsp?mod=ecomm_cat_deta&product_id=<%=row.getInt("ProducId")%>">
                  <img src="<%=strNombreImagen%>" alt="<%=row.getString("Modelo") %>" title="<%=row.getString("Modelo") %>"  width="74" height="74" /></a>
            </div>     		
            <div class="right" style='position:relative;'>

               <div style='right: 0px;float: left;top: 16px;position: absolute;'>
                  <img src="http://casajosefa.com/catalog/view/theme/default/image/remove-small.png" alt="Remover" title="Remover" onclick="(getURLVar('route') == 'checkout/cart' || getURLVar('route') == 'checkout/checkout') ?
                                location = 'modules/mod_ecomm/ecomm_car_remove.jsp?remove=<%=i%>' :
                                $('#cart').load('modules/mod_ecomm/ecomm_car_remove.jsp?remove=<%=i%>' + ' #cart > *');" />
               </div>

               <a style="border-bottom:1px solid #000; padding-bottom:5px;" href="iCommerce/index.jsp?mod=ecomm_cat&cat_id=2"><%=row.getString("Modelo")%></a>

               <div style='margin-bottom: 10px;margin-left: 3px;'>Estilo #<%=row.getString("Codigo")%> </div>				

               <table style='margin-left: 0px; padding-left:0px'>       
                  <tr> 
                     <td class="total">MX $<%=NumberString.FormatearDecimal(dblImporte,2)%></td>
                  </tr>         

                  <tr>
                     <td class="total">
                        <%=row.getString("Color")%></td>	
                  </tr>
                  <tr>
                     <td class="total">
                        Tallas <%=row.getString("Talla")%>	</td>	
                  </tr>


                  <tr>
                     <td class="quantity">Cantidad:<%=row.getInt("Cantidad")%></td>
                  </tr>          	
               </table>
            </div>
            <div style='clear:both'></div>
         </div>		
         <%
            }
         %>






      </div>
      <div class="mini-cart-total">
         <table align="left" style="margin-left: 130px;">
            <tr>
               <td class="right"><b>Sub-Total:</b></td>
               <td class="right">MX $<%=NumberString.FormatearDecimal(dblTotal, 2)%></td>
            </tr>
            <tr>
               <td class="right"><b>Total:</b></td>
               <td class="right">MX $<%=NumberString.FormatearDecimal(dblTotal, 2)%></td>
            </tr>
         </table>
      </div>
      <br style="clear:both">
      <div class="checkout">
         <a href="index.jsp?mod=ecomm_checkout" style="color:#FFF; background:#000; padding: 5px 15px 5px 15px;" ><span style="color:#FFF;" >VER BOLSA DE COMPRA</span></a>
      </div>
   </div>
</div>
<%
   oConn.close();
%>