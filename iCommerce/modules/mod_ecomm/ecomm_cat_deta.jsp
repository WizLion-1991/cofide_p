<%-- 
    Document   : ecomm_cat_deta
    Created on : 01-sep-2014, 4:45:46
    Author     : ZeusGalindo
--%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
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

   //Obtenemos la tasa de impuesto default
   double dblFactorImpuesto = 0;
   String strSqlI = "select * from vta_tasaiva where TI_ID = 1";
   ResultSet rsI = oConn.runQuery(strSqlI);
   while (rsI.next()) {
      dblFactorImpuesto = rsI.getDouble("TI_TASA");
      dblFactorImpuesto = 0;
   }
   rsI.close();

   //Obtenemos parametros generales de la pagina a mostrar
   Site webBase = new Site(oConn);
   String strProduct_id = request.getParameter("product_id");
   if (strProduct_id == null) {
      strProduct_id = "0";
   }
   String strDescripcion = "";
   String strModelo = "";
   String strImg1 = "";
   String strImg2 = "";
   String strImg3 = "";
   int intIdModelo = 0;
   double dblPrecio = 0;
   int intExistencia = 0;
   //Consultamos los datos del producto

   String strSql = "select vta_prodcat2.PC2_ID,vta_prodcat2.PC2_DESCRIPCION, vta_prodcat2.PC2_ORDEN,PR_DESCRIPCIONCORTA, "
           + " PR_NOMIMG1,PR_NOMIMG2,PR_NOMIMG3,PR_EXISTENCIA "
           + "from vta_prodcat2 INNER JOIN vta_producto ON vta_prodcat2.PC2_ID = vta_producto.PR_CATEGORIA2"
           + " where PR_ID = " + strProduct_id + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1"
           + " ";
   ResultSet rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      strDescripcion = rs.getString("PR_DESCRIPCIONCORTA");
      strImg1 = rs.getString("PR_NOMIMG1");
      strImg2 = rs.getString("PR_NOMIMG2");
      strImg3 = rs.getString("PR_NOMIMG3");
      strModelo = rs.getString("PC2_DESCRIPCION");
      intIdModelo = rs.getInt("PC2_ID");
      intExistencia = rs.getInt("PR_EXISTENCIA");
   }
   rs.close();
   if (varSesiones.getIntNoUser() != 0) {
      strSql = "select PP_PRECIO "
              + "from vta_prodprecios where PR_ID = " + strProduct_id + " AND LP_ID = 1";
   } else {
      strSql = "select PP_PRECIO "
              + "from vta_prodprecios where PR_ID = " + strProduct_id + " AND LP_ID = 2";
   }
   ResultSet rs2 = oConn.runQuery(strSql, true);
   while (rs2.next()) {
      dblPrecio = rs2.getDouble("PP_PRECIO");
   }
   rs2.close();
   //Agregamos el impuesto
   double dblImpuesto = dblPrecio * (dblFactorImpuesto / 100);
   dblPrecio += dblImpuesto;
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%

//Consultamos los datos del producto seleccionado...

   String strNombreImagen = "";
   strNombreImagen = "http://casajosefa.com/" + strImg1;
   String strNombreImagen2 = "";
   strNombreImagen2 = "http://casajosefa.com/" + strImg2;
   String strNombreImagen3 = "";
   strNombreImagen3 = "http://casajosefa.com/" + strImg3;
   String strNombreImagen4 = "";
   strNombreImagen4 = "http://casajosefa.com/" + strImg1;
   String strNombreImagen5 = "";
   strNombreImagen5 = "http://casajosefa.com/" + strImg1;
%>
<div id="content">
   <div id="content-top"> </div>
   <div style="border-bottom: 1px solid #CCC; width:100%; margin-bottom:10px;"></div>

   <div class="product-info">
      <div class="left">
         <div class="image"><a rel="fancybox" class="fancybox" title="<%=strModelo%>" href="<%=strNombreImagen%>">
               <img data-default="<%=strNombreImagen%>" id="image" alt="<%=strModelo%>" title="<%=strModelo%>" src="<%=strNombreImagen%>" width="333" height="500">
            </a>
         </div>
         <div class="image-additional">
            <a rel="fancybox" class="fancybox" title="<%=strModelo%>" href="<%=strNombreImagen2%>">
               <img id="additional_image_0" alt="<%=strModelo%>" title="<%=strModelo%>" src="<%=strNombreImagen2%>" width="49" height="74">
            </a>
            <a rel="fancybox" class="fancybox" title="<%=strModelo%>" href="<%=strNombreImagen3%>">
               <img id="additional_image_0" alt="<%=strModelo%>" title="<%=strModelo%>" src="<%=strNombreImagen3%>" width="49" height="74">
            </a>
         </div>
      </div>
      <div class="right">    
         <h1 style="color:#000; font-weight: bold; font-size:20px;border-bottom: 1px solid black;margin-top: 20px;"><%=strModelo%></h1>    	
         <div style="font-size: 20px; color:#999999;" class="price">
            MX  $<%=NumberString.FormatearDecimal(dblPrecio,2)%>		<br>
         </div>
         <div class="options">
            <!--<h2>Opciones disponibles</h2>-->
            <br>
            <div class="option" id="option-273">


               <table class="option-image">
                  <tbody><tr>
                        <%
                           //Listamos los colores definidos
                           strSql = "SELECT DISTINCT 	vta_prodcat4.PC4_ID, 	vta_prodcat4.PC4_DESCRIPCION, vta_prodcat4.PC4_ORDEN, 	"
                                   + " vta_prodcat4.PC4_IMAGEN_22 "
                                   + " FROM vta_producto INNER JOIN vta_prodcat4 ON vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID"
                                   + " where PR_CATEGORIA2 = " + intIdModelo + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1 "
                                   + " order by PC4_ORDEN";
                           rs = oConn.runQuery(strSql, true);
                           while (rs.next()) {
                        %>
                        <td style="width: 1px; display:none;">
                           <input type="radio" id="option-value-<%=rs.getString("PC4_ID")%>" value="<%=rs.getString("PC4_ID")%>" name="option[273]" onclick="borderSelect('<%=rs.getString("PC4_ID")%>', 'Colores');"></td>
                        <td>
                           <label for="option-value-<%=rs.getString("PC4_ID")%>">
                              <img data-option-value-id="<%=rs.getString("PC4_ID")%>" alt="<%=rs.getString("PC4_DESCRIPCION")%>" src="http://casajosefa.com/image/cache/data/<%=rs.getString("PC4_IMAGEN_22")%>" id="imgOptionoption<%=rs.getString("PC4_ID")%>" class="imageMargenColores">
                           </label>
                        </td>
                        <%         }
                           rs.close();
                        %>


                     </tr>
                  </tbody></table>
            </div>

            <div class="option" id="option-274">


               <table class="option-image">
                  <tbody><tr>
                        <%
                           //Listamos las tallas definidos
                           strSql = "SELECT DISTINCT 	vta_prodcat3.PC3_ID, 	vta_prodcat3.PC3_DESCRIPCION, vta_prodcat3.PC3_ORDEN, 	"
                                   + " vta_prodcat3.PC3_IMAGEN_22 "
                                   + " FROM vta_producto INNER JOIN vta_prodcat3 ON vta_producto.PR_CATEGORIA3 = vta_prodcat3.PC3_ID"
                                   + " where PR_CATEGORIA2 = " + intIdModelo + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1 "
                                   + " order by PC3_ORDEN";
                           rs = oConn.runQuery(strSql, true);
                           while (rs.next()) {
                        %>
                        <td style="width: 1px; display:none;">
                           <input type="radio" id="option-value-<%=rs.getString("PC3_ID")%>" value="<%=rs.getString("PC3_ID")%>" name="option[274]" onclick="borderSelect('<%=rs.getString("PC3_ID")%>', 'Tallas');"></td>
                        <td>
                           <label for="option-value-<%=rs.getString("PC3_ID")%>">
                              <img data-option-value-id="<%=rs.getString("PC3_ID")%>" alt="<%=rs.getString("PC3_DESCRIPCION")%>" src="http://casajosefa.com/image/cache/data/COLOR/TALLAS/<%=rs.getString("PC3_IMAGEN_22")%>" id="imgOptionoption<%=rs.getString("PC3_ID")%>" class="imageMargenTallas">
                           </label>
                        </td>

                        <%         }
                           rs.close();
                        %>
                     </tr>
                  </tbody></table>
            </div>

         </div>
         <div style="border:0;" class="cart">
            <div>
               <span style="background: #F2F2F2; padding-left:10px; padding-right:10px; padding-bottom:8px; float:left; font-size:10px;">CANTIDAD</span>
               <select style="background:#f1f1f0;padding: 5px;margin: 0px 3px;border: none;color: #808080;font-size: 11px;" name="quantity">
                  <option value="1">1</option>
                  <option value="2">2</option>
                  <option value="3">3</option>
                  <option value="4">4</option>
                  <option value="5">5</option>
                  <option value="6">6</option>
                  <option value="7">7</option>
                  <option value="8">8</option>
                  <option value="9">9</option>
                  <option value="10">10</option>
               </select>
               <input type="hidden" value="<%=intIdModelo%>" size="2" name="product_id">
               <br><br><br>
               <a style="font-size:14px;" class="button" id="button-cart">
                  &nbsp;&nbsp;&nbsp;AGREGAR A BOLSA&nbsp;&nbsp;&nbsp;</a></div>                
         </div>
         <br style="clear:both;">
         <br style="clear:both;">
         <div style="" class="description">
            <h3 style="border-bottom:1px solid #CCC; padding-bottom:5px;">DESCRIPCION</h3>
            <p><%=strDescripcion%></p>
            <p>Existencia:&nbsp;<%=intExistencia + ""%></p>

         </div>      




      </div>
      <br style="clear:both">     

   </div>

</div>


<script type="text/javascript"><!--
$('.fancybox').fancybox({cyclic: true});
   //--></script> 
<script type="text/javascript"><!--
$('#button-cart').bind('click', function() {
      $.ajax({
         url: 'modules/mod_ecomm/ecomm_prod.jsp?Oper=5',
         type: 'post',
         data: $('.product-info input[type=\'text\'], .product-info input[type=\'hidden\'], .product-info input[type=\'radio\']:checked, .product-info input[type=\'checkbox\']:checked, .product-info select, .product-info textarea'),
         dataType: 'json',
         success: function(json) {
            $('.success, .warning, .attention, information, .error').remove();

            if (json['error']) {
               if (json['error']['warning']) {
                  $('#notification').html('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }

               for (i in json['error']['option']) {
                  $('#option-' + i).after('<span class="error">' + json['error']['option'][i] + '</span>');
               }
            }

            if (json['success']) {

               $('#notification').html('<div class="success" style="display: none;">' + json['success'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

               $('.success').fadeIn('slow');

               $('#cart-total').html('');
               $('#cart-total').html(json['total']);

               $('html, body').animate({scrollTop: 0}, 'slow');
            }
         }
      });
   });

   function borderSelect(id, name) {

      $('.imageMargen' + name).css('-webkit-transition', 'none');
      $('.imageMargen' + name).css('-webkit-filter', 'none');
      $('.imageMargen' + name).css('filter', 'none');
      $('.imageMargen' + name).css('filter', 'none');

      $('.imageMargen' + name).parent().css('border-bottom', 'none');

      if (name == 'Colores') {
         $('#imgOptionoption' + id).css('-webkit-transition', 'blur(3px)');
         $('#imgOptionoption' + id).css('-webkit-filter', 'blur(3px)');
         $('#imgOptionoption' + id).css('filter', 'blur(3px)');
         $('#imgOptionoption' + id).css('filter', 'blur(3px)');

         $('#imgOptionoption' + id).parent().css('border-bottom', '2px dotted #AFAFAF');


         var data_value_id = $('#imgOptionoption' + id).data('option-value-id');
         if ($('#additional_image_' + data_value_id).size() > 0)
            $('#image').attr('src', $('#additional_image_' + data_value_id).parent().attr('href'));
         else
            $('#image').attr('src', $('#image').data('default'));



      } else {
         $('#imgOptionoption' + id).css('-webkit-transition', 'blur(1px)');
         $('#imgOptionoption' + id).css('-webkit-filter', 'blur(1px)');
         $('#imgOptionoption' + id).css('filter', 'blur(1px)');
         $('#imgOptionoption' + id).css('filter', 'blur(1px)');

         $('#imgOptionoption' + id).parent().css('border-bottom', '2px dotted #AFAFAF');
      }

   }
   //--></script>
<script type="text/javascript" src="http://casajosefa.com/catalog/view/javascript/jquery/ajaxupload.js"></script>
<script type="text/javascript"><!--
$('#review .pagination a').live('click', function() {
      $('#review').slideUp('slow');

      $('#review').load(this.href);

      $('#review').slideDown('slow');

      return false;
   });

   $('#review').load('index.php?route=product/product/review&product_id=79');

   $('#button-review').bind('click', function() {
      $.ajax({
         type: 'POST',
         url: 'http://casajosefa.com/index.php?route=product/product/write&product_id=79',
         dataType: 'json',
         data: 'name=' + encodeURIComponent($('input[name=\'name\']').val()) + '&text=' + encodeURIComponent($('textarea[name=\'text\']').val()) + '&rating=' + encodeURIComponent($('input[name=\'rating\']:checked').val() ? $('input[name=\'rating\']:checked').val() : '') + '&captcha=' + encodeURIComponent($('input[name=\'captcha\']').val()),
         beforeSend: function() {
            $('.success, .warning').remove();
            $('#button-review').attr('disabled', true);
            $('#review-title').after('<div class="attention"><img src="catalog/view/theme/default/image/loading.gif" alt="" /> Por favor espera!</div>');
         },
         complete: function() {
            $('#button-review').attr('disabled', false);
            $('.attention').remove();
         },
         success: function(data) {
            if (data.error) {
               $('#review-title').after('<div class="warning">' + data.error + '</div>');
            }

            if (data.success) {
               $('#review-title').after('<div class="success">' + data.success + '</div>');

               $('input[name=\'name\']').val('');
               $('textarea[name=\'text\']').val('');
               $('input[name=\'rating\']:checked').attr('checked', '');
               $('input[name=\'captcha\']').val('');
            }
         }
      });
   });
   //--></script> 
<script type="text/javascript"><!--
$('#tabs a').tabs();
   //--></script> 
<script type="text/javascript" src="http://casajosefa.com/catalog/view/javascript/jquery/ui/jquery-ui-timepicker-addon.js"></script> 
<script type="text/javascript"><!--
if ($.browser.msie && $.browser.version == 6) {
      $('.date, .datetime, .time').bgIframe();
   }

   $('.date').datepicker({dateFormat: 'yy-mm-dd'});
   $('.datetime').datetimepicker({
      dateFormat: 'yy-mm-dd',
      timeFormat: 'h:m'
   });
   $('.time').timepicker({timeFormat: 'h:m'});
   //--></script> 




<%
   oConn.close();
%>