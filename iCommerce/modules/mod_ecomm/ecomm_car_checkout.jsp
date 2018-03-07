<%-- 
    Document   : ecomm_car_checkout
    Created on : 03-sep-2014, 5:21:29
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
   double dblTotal = 0;
   if (!strLst.equals("0")) {
      //Parseamos el objeto json
      objJsonCarrito = new JSONObject(strLst);
      jsonChild = objJsonCarrito.getJSONArray("carritoCompras");

   } else {
      jsonChild = new JSONArray();
   }

   boolean bolModificar = false;

   //Evaluamos si enviaron el parametro de remover
   if (request.getParameter("remove") != null) {
      try {
         int intIdRemove = Integer.valueOf(request.getParameter("remove"));
         System.out.println("Remover:" + intIdRemove);
         //Obtenemos el resumen del carrito
         for (int i = 0; i < jsonChild.length(); i++) {
            if (i == intIdRemove) {
               jsonChild.remove(i);

               bolModificar = true;
               break;
            }
         }
      } catch (NumberFormatException ex) {
      }
   }
   //Evaluamos si enviaron alguna actualizacion

   for (int i = 0; i < jsonChild.length(); i++) {
      JSONObject row = jsonChild.getJSONObject(i);
      boolean bolModificarItem = false;
      if (request.getParameter("quantity" + i) != null) {
         try {
            int intCantidad = Integer.valueOf(request.getParameter("quantity" + i));
            row.remove("Cantidad");
            row.put("Cantidad", intCantidad);
            bolModificar = true;
         } catch (NumberFormatException ex) {
         }
      }
      if (request.getParameter("color" + i) != null) {
         row.remove("ColorId");
         row.put("ColorId", request.getParameter("color" + i));
         String strSql = "select PC4_DESCRIPCION "
                 + "from vta_prodcat4 where PC4_ID = " + row.getString("ColorId") + " ";
         ResultSet rs2 = oConn.runQuery(strSql, true);
         while (rs2.next()) {
            row.remove("Color");
            row.put("Color", rs2.getString("PC4_DESCRIPCION"));
         }
         rs2.close();
         bolModificar = true;
         bolModificarItem = true;
      }

      if (request.getParameter("talla" + i) != null) {
         row.remove("TallaId");
         row.put("TallaId", request.getParameter("talla" + i));
         String strSql = "select PC3_DESCRIPCION "
                 + "from vta_prodcat3 where PC3_ID = " + row.getString("TallaId") + " ";
         ResultSet rs2 = oConn.runQuery(strSql, true);
         while (rs2.next()) {
            row.remove("Talla");
            row.put("Talla", rs2.getString("PC3_DESCRIPCION"));
         }
         rs2.close();
         bolModificar = true;
         bolModificarItem = true;
      }
      //Solo si se modifico el color y la talla
      if (bolModificarItem) {
         //Buscamos el codigo y id del producto cambiado
         String strSql = "select vta_producto.PR_ID,vta_producto.PR_CODIGO,vta_prodcat2.PC2_ID,vta_prodcat2.PC2_DESCRIPCION, vta_prodcat2.PC2_ORDEN,PR_DESCRIPCIONCORTA, "
                 + " PR_NOMIMG1,PR_NOMIMG2 "
                 + "from vta_prodcat2 INNER JOIN vta_producto ON vta_prodcat2.PC2_ID = vta_producto.PR_CATEGORIA2"
                 + " where PC2_ID = " + row.getInt("ModeloId") + " "
                 + " and PR_CATEGORIA3=" + row.getString("TallaId") + " "
                 + " and PR_CATEGORIA4=" + row.getString("ColorId") + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1"
                 + " ";
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            row.remove("Codigo");
            row.put("Codigo", rs.getString("PR_CODIGO"));
            row.remove("ProducId");
            row.put("ProducId", rs.getInt("PR_ID"));
         }
         rs.close();
      }

   }
   //Modificamos el carrito si algo se movio
   if (bolModificar) {
      //Actualizamos el carrito
      Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());
   }

   //Obtenemos el resumen del carrito
   for (int i = 0; i < jsonChild.length(); i++) {
      JSONObject row = jsonChild.getJSONObject(i);
      dblTotal += row.getDouble("Precio") * row.getInt("Cantidad");
   }
   //Parametros para el flete
   boolean bolUsaFlete = true;
   String strCodigoFlete = "ENVIO";
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>





<div class="bread_center">

   <div class="breadcrumb">
      <a style="color:gray" href="">BOLSA DE COMPRAS</a>
      » <a href="">REGISTRO</a>
      » <a href="">ENVIO</a>
      » <a href="">PAGO</a>
      » <a href="">GRACIAS</a>
   </div>

</div>


<div id="container">
   <div id="content"><div id="content-top">
      </div>



      <form action="index.jsp?mod=ecomm_checkout" method="post">
         <div class="cart-info" style="border:0px">
            <table border="0" cellpadding="0" cellspacing="0">
               <thead>
                  <tr>
                     <td class="image" style="border:0;">&nbsp;</td>
                     <td class="name">Producto</td>
                     <td class="center">Color</td>
                     <td class="center">Cantidad / Talla</td>
                     <td class="total">Subtotal</td>
                     <td class="total">&nbsp;</td>
                  </tr>
               </thead>
               <tbody>
                  <%
                     //Obtenemos el resumen del carrito
                     for (int i = 0; i < jsonChild.length(); i++) {
                        JSONObject row = jsonChild.getJSONObject(i);
                        double dblImporte = row.getDouble("Precio") * row.getInt("Cantidad");
                        //Obtenemos imagen
                        String strImg1 = "";
                        String strSql = "select  PR_NOMIMG1,PR_NOMIMG2,PR_NOMIMG3 "
                                + "from vta_producto "
                                + " where PR_ID = " + row.getInt("ProducId") + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1"
                                + " ";
                        ResultSet rs = oConn.runQuery(strSql, true);
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
                           <img src="<%=strNombreImagen%>" alt="<%=row.getString("Modelo")%>" title="<%=row.getString("Modelo")%>" width="74" height="74"></a>
                     </td>
                     <td class="name"><div style="margin-bottom: 15px;"><a href="index.jsp?mod=ecomm_cat&cat_id=<%=row.getInt("ModeloId")%>"><%=row.getString("Modelo")%></a></div>
                        <div>
                           <div>Estilo #<%=row.getString("Codigo")%></div>
                           Colores:<%=row.getString("Color")%><br>
                           Tallas: <%=row.getString("Talla")%><br>
                        </div>
                     </td>

                     <!-- COLOR -->
                     <td class="center">

                        <select name="color<%=i%>">
                           <%
                              //Listamos los colores definidos
                              strSql = "SELECT DISTINCT 	vta_prodcat4.PC4_ID, 	vta_prodcat4.PC4_DESCRIPCION, vta_prodcat4.PC4_ORDEN, 	"
                                      + " vta_prodcat4.PC4_IMAGEN_22 "
                                      + " FROM vta_producto INNER JOIN vta_prodcat4 ON vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID"
                                      + " where PR_CATEGORIA2 = " + row.getInt("ModeloId") + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1 "
                                      + " order by PC4_ORDEN";
                              rs = oConn.runQuery(strSql, true);
                              while (rs.next()) {
                                 if (rs.getString("PC4_ID").equals(row.getString("ColorId"))) {
                           %>
                           <option value="<%=rs.getString("PC4_ID")%>" selected="selected"><%=rs.getString("PC4_DESCRIPCION")%></option>
                           <%
                           } else {
                           %>
                           <option value="<%=rs.getString("PC4_ID")%>"><%=rs.getString("PC4_DESCRIPCION")%></option>
                           <%
                                 }
                              }
                              rs.close();
                           %>
                        </select>

                     </td>

                     <!-- CANTIDAD / TALLA -->
                     <td class="center">
                        &nbsp;&nbsp;&nbsp;
                        <select name="quantity<%=i%>">
                           <%
                              for (int iList = 1; iList < 10; iList++) {
                                 if (row.getInt("Cantidad") == iList) {
                           %>
                           <option value="<%=iList%>" selected="selected"><%=iList%></option>
                           <%
                           } else {
                           %>
                           <option value="<%=iList%>"><%=iList%></option>
                           <%
                                 }
                              }
                           %>
                        </select>

                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp;&nbsp;

                        <select name="talla<%=i%>">
                           <%
                              //Listamos las tallas definidos
                              strSql = "SELECT DISTINCT 	vta_prodcat3.PC3_ID, 	vta_prodcat3.PC3_DESCRIPCION, vta_prodcat3.PC3_ORDEN, 	"
                                      + " vta_prodcat3.PC3_IMAGEN_22 "
                                      + " FROM vta_producto INNER JOIN vta_prodcat3 ON vta_producto.PR_CATEGORIA3 = vta_prodcat3.PC3_ID"
                                      + " where PR_CATEGORIA2 = " + row.getInt("ModeloId") + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1 "
                                      + " order by PC3_ORDEN";
                              rs = oConn.runQuery(strSql, true);
                              while (rs.next()) {
                                 if (rs.getString("PC3_ID").equals(row.getString("TallaId"))) {
                           %>
                           <option value="<%=rs.getString("PC3_ID")%>" selected="selected"><%=rs.getString("PC3_DESCRIPCION")%></option>
                           <%
                           } else {
                           %>
                           <option value="<%=rs.getString("PC3_ID")%>"><%=rs.getString("PC3_DESCRIPCION")%></option>
                           <%
                                 }
                              }
                              rs.close();
                           %>

                        </select>
                     </td>
                     <td class="total">MX $<%=NumberString.FormatearDecimal(dblImporte, 2)%></td>
                     <td>
                     <%if(!row.getString("Codigo").equals(strCodigoFlete)){%>
                        <input src="http://casajosefa.com/catalog/view/theme/default/image/update.png" alt="Actualizar" title="Actualizar" type="image">
                        &nbsp;
                        <a href="index.jsp?mod=ecomm_checkout&remove=<%=i%>">
                           <img src="http://casajosefa.com/catalog/view/theme/default/image/remove.png" alt="Remover" title="Remover">
                        </a>                     
                     <%}%>
                     </td>
                  </tr>
                  <%
                     }
                  %>



               </tbody>
            </table>
         </div>
      </form>

      <div class="buttons">
         <div class="right"><a href="index.jsp?mod=ecomm_car_checkout_sell" class="button" style="background:#9f9f9f"><span>PAGAR AHORA</span></a></div>
         <div class="right" style="margin-right:20px"><a href="index.jsp?mod=ecomm_cat&cat_id=1" class="button"><span>SEGUIR COMPRANDO</span></a></div>
      </div>


      <div class="cart-total" style="border:0px">
         <br style="clear:both;">
         <br style="clear:both;">
         <p style="float: right; width: 120px; margin-right: 135px;"><b> Order Summary</b></p>   
         <br style="clear:both;">   
         <div style="width:254px; clear:both; margin-top:0px; border-top:1px solid #000; padding-top:10px; float:right">  	
         </div>

         <br style="clear:both;">

         <div style="float:right">

            <table id="total" style="color:#000; width:250px;">
               <tbody><tr>
                     <td class="left" align="left"><b>Sub-Total:</b></td>
                     <td class="right" align="right">MX $<%=NumberString.FormatearDecimal(dblTotal, 2)%></td>
                  </tr>
                  <tr>
                     <td class="left" align="left"><b>Total:</b></td>
                     <td class="right" align="right">MX $<%=NumberString.FormatearDecimal(dblTotal, 2)%></td>
                  </tr>
               </tbody></table>
         </div>
         <div class="info" style="clear:both; float:right; margin-top:30px; border-top:1px solid #CCC; padding-top:10px">
            ¿Problemas o dudas en tu orden? Comunicate al 53 68 24 97 
         </div>
         <div class="info" style="clear:both; float:right; margin-top:30px; padding-top:10px">
            <img src="http://casajosefa.com/catalog/view/theme/mystore/image/payment_paypal.png">
            <img src="http://casajosefa.com/catalog/view/theme/mystore/image/payment_visa.png">
            <img src="http://casajosefa.com/catalog/view/theme/mystore/image/payment_mastercard.png">
         </div>  
      </div>

   </div>
   <script type="text/javascript"><!--
   $('input[name=\'next\']').bind('change', function() {
         $('.cart-module > div').hide();

         $('#' + this.value).show();
      });
      //--></script>