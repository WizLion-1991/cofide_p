<%-- 
    Document   : ecomm_car_checkout_sell
    Created on : 03-sep-2014, 15:27:18
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
   //Recuperamos informacion del carrito de compras


%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


	<div class="breadcrumb">

	        <a id="breadcumb_1" href="index.jsp?mod=ecomm_checkout">BOLSA DE COMPRAS</a>
         » <a style="color:gray" id="breadcumb_2" href="index.jsp?mod=ecomm_car_checkout_sell">REGISTRO</a>
         » <a id="breadcumb_3" href="">ENVIO</a>
         » <a id="breadcumb_4" href="">PAGO</a>
         » <a id="breadcumb_5" href="">GRACIAS</a>
      
      </div>
  

  

<div id="content"><div id="content-top">
   </div>


   <div>
      <div class="checkout">
         <div id="checkout">
            <div class="checkout-heading" style="display:none;">Paso 1: Opciones de compra</div>
            <div style="display: block;" class="checkout-content">

               <br style="clear:both">
            </div>
         </div>
         <div id="payment-address">
            <div class="checkout-heading" style="display:none;"><span>Paso 2: Detalles de cuenta &amp; facturación</span></div>
            <div class="checkout-content"></div>
         </div>
         <div id="shipping-address" style="display:none">
            <div class="checkout-heading" style="display:none;">Paso 3: Detalles de entrega</div>
            <div class="checkout-content"></div>
         </div>
         <div id="shipping-method" style="display:none">
            <div class="checkout-heading" style="display:none;">Paso 4: Método de entrega</div>
            <div class="checkout-content"></div>
         </div>
         <div id="payment-method">
            <div class="checkout-heading" style="display:none;">Paso 5: Método de pago</div>
            <div class="checkout-content"></div>
         </div>
         <div id="confirm">
            <div class="checkout-heading" style="display:none;">Paso 6: Confirmar Pedido</div>
            <div class="checkout-content"></div>
         </div>
      </div>
   </div>    
</div>
<script type="text/javascript">
   $('#checkout .checkout-content input[name=\'account\']').live('change', function() {
      if ($(this).attr('value') == 'register') {
         $('#payment-address .checkout-heading span').html('Paso 2: Detalles de cuenta &amp; facturación');
      } else {
         $('#payment-address .checkout-heading span').html('Paso 2: Detalles de facturación');
      }
   });

   $('.checkout-heading a').live('click', function() {
      $('.checkout-content').slideUp('slow');

      $(this).parent().parent().find('.checkout-content').slideDown('slow');
   });

   $(document).ready(function() {
      $.ajax({
         url: 'modules/mod_ecomm/ecomm_eval_login.jsp',
         dataType: 'html',
         success: function(html) {
            $('#checkout .checkout-content').html(html);

            $('#checkout .checkout-content').slideDown('slow');
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-account').live('click', function() {
      $.ajax({
         url: 'index.php?route=checkout/' + $('input[name=\'account\']:checked').attr('value'),
         dataType: 'html',
         beforeSend: function() {
            $('#button-account').attr('disabled', true);
            $('#button-account').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-account').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(html) {
            $('.warning, .error').remove();

            $('#payment-address .checkout-content').html(html);

            $('#checkout .checkout-content').slideUp('slow');

            $('#payment-address .checkout-content').slideDown('slow');

            $('.checkout-heading a').remove();

            $('#checkout .checkout-heading').append('<a>Modificar &raquo;</a>');
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-login').live('click', function() {
      $.ajax({
         url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json1',
         type: 'post',
         data: $('#checkout #login :input'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-login').attr('disabled', true);
            $('#button-login').after('<span class="wait">&nbsp;<img src="http://casajosefa.com/catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-login').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               $('#checkout .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '</div>');

               $('.warning').fadeIn('slow');
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-register').live('click', function() {
      $.ajax({
         url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json2',
         type: 'post',
         data: $('#checkout input[type=\'text\'], #checkout input[type=\'password\'], #checkout input[type=\'checkbox\']:checked, #checkout input[type=\'radio\']:checked, #checkout input[type=\'hidden\'], #checkout select'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-register').attr('disabled', true);
            $('#button-register').after('<span class="wait">&nbsp;<img src="http://casajosefa.com/catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-register').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               if (json['error']['warning']) {
                  $('#checkout .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }

               if (json['error']['firstname']) {
                  $('#checkout input[name=\'firstname\'] + br').after('<span class="error">' + json['error']['firstname'] + '</span>');
               }

               if (json['error']['lastname']) {
                  $('#checkout input[name=\'lastname\'] + br').after('<span class="error">' + json['error']['lastname'] + '</span>');
               }

               if (json['error']['email']) {
                  $('#checkout input[name=\'email\'] + br').after('<span class="error">' + json['error']['email'] + '</span>');
               }

               if (json['error']['telephone']) {
                  $('#checkout input[name=\'telephone\'] + br').after('<span class="error">' + json['error']['telephone'] + '</span>');
               }

               if (json['error']['company_id']) {
                  $('#payment-address input[name=\'company_id\'] + br').after('<span class="error">' + json['error']['company_id'] + '</span>');
               }

               if (json['error']['tax_id']) {
                  $('#checkout input[name=\'tax_id\'] + br').after('<span class="error">' + json['error']['tax_id'] + '</span>');
               }

               if (json['error']['address_1']) {
                  $('#checkout input[name=\'address_1\'] + br').after('<span class="error">' + json['error']['address_1'] + '</span>');
               }

               if (json['error']['city']) {
                  $('#checkout input[name=\'city\'] + br').after('<span class="error">' + json['error']['city'] + '</span>');
               }

               if (json['error']['postcode']) {
                  $('#checkout input[name=\'postcode\'] + br').after('<span class="error">' + json['error']['postcode'] + '</span>');
               }

               if (json['error']['country']) {
                  $('#checkout select[name=\'country_id\'] + br').after('<span class="error">' + json['error']['country'] + '</span>');
               }

               if (json['error']['zone']) {
                  $('#checkout select[name=\'zone_id\'] + br').after('<span class="error">' + json['error']['zone'] + '</span>');
               }

               if (json['error']['password']) {
                  $('#checkout input[name=\'password\'] + br').after('<span class="error">' + json['error']['password'] + '</span>');
               }

               if (json['error']['confirm']) {
                  $('#checkout input[name=\'confirm\'] + br').after('<span class="error">' + json['error']['confirm'] + '</span>');
               }
            } else {

               var shipping_address = $('#payment-address input[name=\'shipping_address\']:checked').attr('value');

               if (shipping_address) {
                  $.ajax({
                     url: 'index.php?route=checkout/shipping_method',
                     dataType: 'html',
                     success: function(html) {

                        $('#shipping-address .checkout-content').html(html);

                        $('#checkout .checkout-content').slideUp('slow');

                        $('#shipping-address .checkout-content').slideDown('slow');

                        $('#checkout .checkout-heading a').remove();
                        $('#payment-address .checkout-heading a').remove();
                        $('#shipping-address .checkout-heading a').remove();
                        $('#shipping-method .checkout-heading a').remove();
                        $('#payment-method .checkout-heading a').remove();

                        $('#shipping-address .checkout-heading').append('<a>Modificar &raquo;</a>');
                        $('#payment-address .checkout-heading').append('<a>Modificar &raquo;</a>');

                        $('#button-shipping-address').click();

                        $.ajax({
                           url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json3',
                           dataType: 'html',
                           success: function(html) {
                              $('#shipping-address .checkout-content').html(html);
                           },
                           error: function(xhr, ajaxOptions, thrownError) {
                              alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                           }
                        });
                     },
                     error: function(xhr, ajaxOptions, thrownError) {
                        alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                     }
                  });
               } else {
                  $.ajax({
                     url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json3',
                     dataType: 'html',
                     success: function(html) {

                        $('#shipping-address .checkout-content').html(html);

                        $('#checkout .checkout-content').slideUp('slow');

                        $('#payment-address .checkout-content').fadeIn('slow');

                        $('#shipping-address .checkout-content').slideDown('slow');

                        $('#checkout .checkout-heading a').remove();
                        $('#payment-address .checkout-heading a').remove();
                        $('#shipping-address .checkout-heading a').remove();
                        $('#shipping-method .checkout-heading a').remove();
                        $('#payment-method .checkout-heading a').remove();

                        $('#payment-address .checkout-heading').append('<a>Modificar &raquo;</a>');
                     },
                     error: function(xhr, ajaxOptions, thrownError) {
                        alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                     }
                  });
               }

               $.ajax({
                  url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json4',
                  dataType: 'html',
                  success: function(html) {
                     $('#payment-address .checkout-content').html(html);

                     $('#payment-address .checkout-heading span').html('Paso 2: Detalles de facturación');
                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-payment-address').live('click', function() {
   alert("Validamos payment address");
      $.ajax({
         url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json5',
         type: 'post',
         data: $('#payment-address input[type=\'text\'], #payment-address input[type=\'password\'], #payment-address input[type=\'checkbox\']:checked, #payment-address input[type=\'radio\']:checked, #payment-address input[type=\'hidden\'], #payment-address select'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-payment-address').attr('disabled', true);
            $('#button-payment-address').after('<span class="wait">&nbsp;<img src="http://casajosefa.comcatalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-payment-address').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               if (json['error']['warning']) {
                  $('#payment-address .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }

               if (json['error']['firstname']) {
                  $('#payment-address input[name=\'firstname\']').after('<span class="error">' + json['error']['firstname'] + '</span>');
               }

               if (json['error']['lastname']) {
                  $('#payment-address input[name=\'lastname\']').after('<span class="error">' + json['error']['lastname'] + '</span>');
               }

               if (json['error']['telephone']) {
                  $('#payment-address input[name=\'telephone\']').after('<span class="error">' + json['error']['telephone'] + '</span>');
               }

               if (json['error']['company_id']) {
                  $('#payment-address input[name=\'company_id\']').after('<span class="error">' + json['error']['company_id'] + '</span>');
               }

               if (json['error']['tax_id']) {
                  $('#payment-address input[name=\'tax_id\']').after('<span class="error">' + json['error']['tax_id'] + '</span>');
               }

               if (json['error']['address_1']) {
                  $('#payment-address input[name=\'address_1\']').after('<span class="error">' + json['error']['address_1'] + '</span>');
               }

               if (json['error']['city']) {
                  $('#payment-address input[name=\'city\']').after('<span class="error">' + json['error']['city'] + '</span>');
               }

               if (json['error']['postcode']) {
                  $('#payment-address input[name=\'postcode\']').after('<span class="error">' + json['error']['postcode'] + '</span>');
               }

               if (json['error']['country']) {
                  $('#payment-address select[name=\'country_id\']').after('<span class="error">' + json['error']['country'] + '</span>');
               }

               if (json['error']['zone']) {
                  $('#payment-address select[name=\'zone_id\']').after('<span class="error">' + json['error']['zone'] + '</span>');
               }
               if (json['error']['calle']) {
                  $('#payment-address input[name=\'calle\']').after('<span class="error">' + json['error']['calle'] + '</span>');
               }
               if (json['error']['colonia']) {
                  $('#payment-address input[name=\'colonia\']').after('<span class="error">' + json['error']['colonia'] + '</span>');
               }
               if (json['error']['numero']) {
                  $('#payment-address input[name=\'numero\']').after('<span class="error">' + json['error']['numero'] + '</span>');
               }
               if (json['error']['city']) {
                  $('#payment-address input[name=\'city\']').after('<span class="error">' + json['error']['city'] + '</span>');
               }
            } else {
               $.ajax({
                  url: 'index.jsp?route=checkout/shipping_address',
                  dataType: 'html',
                  success: function(html) {
                     $('#shipping-address .checkout-content').html(html);

                     $('#payment-address .checkout-content').slideUp('slow');

                     $('#shipping-address .checkout-content').slideDown('slow');

                     $('#payment-address .checkout-heading a').remove();
                     $('#shipping-address .checkout-heading a').remove();
                     $('#shipping-method .checkout-heading a').remove();
                     $('#payment-method .checkout-heading a').remove();

                     $('#payment-address .checkout-heading').append('<a>Modificar &raquo;</a>');

                     $('#button-shipping-address').click();

                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });

               $.ajax({
                  url: 'index.jsp?route=checkout/payment_address',
                  dataType: 'html',
                  success: function(html) {
                     $('#payment-address .checkout-content').html(html);
                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-shipping-address').live('click', function() {
      $.ajax({
         url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json5',
         type: 'post',
         data: $('#shipping-address input[type=\'text\'], #shipping-address input[type=\'password\'], #shipping-address input[type=\'checkbox\']:checked, #shipping-address input[type=\'radio\']:checked, #shipping-address select'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-shipping-address').attr('disabled', true);
            $('#button-shipping-address').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-shipping-address').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               if (json['error']['warning']) {
                  $('#shipping-address .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }

               if (json['error']['firstname']) {
                  $('#shipping-address input[name=\'firstname\']').after('<span class="error">' + json['error']['firstname'] + '</span>');
               }

               if (json['error']['lastname']) {
                  $('#shipping-address input[name=\'lastname\']').after('<span class="error">' + json['error']['lastname'] + '</span>');
               }

               if (json['error']['email']) {
                  $('#shipping-address input[name=\'email\']').after('<span class="error">' + json['error']['email'] + '</span>');
               }

               if (json['error']['telephone']) {
                  $('#shipping-address input[name=\'telephone\']').after('<span class="error">' + json['error']['telephone'] + '</span>');
               }

               if (json['error']['address_1']) {
                  $('#shipping-address input[name=\'address_1\']').after('<span class="error">' + json['error']['address_1'] + '</span>');
               }

               if (json['error']['city']) {
                  $('#shipping-address input[name=\'city\']').after('<span class="error">' + json['error']['city'] + '</span>');
               }

               if (json['error']['postcode']) {
                  $('#shipping-address input[name=\'postcode\']').after('<span class="error">' + json['error']['postcode'] + '</span>');
               }

               if (json['error']['country']) {
                  $('#shipping-address select[name=\'country_id\']').after('<span class="error">' + json['error']['country'] + '</span>');
               }

               if (json['error']['zone']) {
                  $('#shipping-address select[name=\'zone_id\']').after('<span class="error">' + json['error']['zone'] + '</span>');
               }
            } else {
               $.ajax({
                  url: 'index.php?route=checkout/shipping_method',
                  dataType: 'html',
                  success: function(html) {
                     $('#shipping-method .checkout-content').html(html);

                     $('#shipping-address .checkout-content').slideUp('slow');

                     $('#shipping-method .checkout-content').slideDown('slow');

                     $('#shipping-address .checkout-heading a').remove();
                     $('#shipping-method .checkout-heading a').remove();
                     $('#payment-method .checkout-heading a').remove();

                     $('#shipping-address .checkout-heading').append('<a>Modificar &raquo;</a>');

                     $('#button-shipping-method').click();

                     $.ajax({
                        url: 'index.php?route=checkout/shipping_address',
                        dataType: 'html',
                        success: function(html) {
                           $('#shipping-address .checkout-content').html(html);
                        },
                        error: function(xhr, ajaxOptions, thrownError) {
                           alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                        }
                     });
                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });

               $.ajax({
                  url: 'index.php?route=checkout/payment_address',
                  dataType: 'html',
                  success: function(html) {
                     $('#payment-address .checkout-content').html(html);
                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-guest').live('click', function() {
      $.ajax({
         url: 'index.php?route=checkout/guest/validate',
         type: 'post',
         data: $('#payment-address input[type=\'text\'], #payment-address input[type=\'checkbox\']:checked, #payment-address input[type=\'radio\']:checked, #payment-address input[type=\'hidden\'], #payment-address select'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-guest').attr('disabled', true);
            $('#button-guest').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-guest').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               if (json['error']['warning']) {
                  $('#payment-address .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }

               if (json['error']['firstname']) {
                  $('#payment-address input[name=\'firstname\'] + br').after('<span class="error">' + json['error']['firstname'] + '</span>');
               }

               if (json['error']['lastname']) {
                  $('#payment-address input[name=\'lastname\'] + br').after('<span class="error">' + json['error']['lastname'] + '</span>');
               }

               if (json['error']['email']) {
                  $('#payment-address input[name=\'email\'] + br').after('<span class="error">' + json['error']['email'] + '</span>');
               }

               if (json['error']['telephone']) {
                  $('#payment-address input[name=\'telephone\'] + br').after('<span class="error">' + json['error']['telephone'] + '</span>');
               }

               if (json['error']['company_id']) {
                  $('#payment-address input[name=\'company_id\'] + br').after('<span class="error">' + json['error']['company_id'] + '</span>');
               }

               if (json['error']['tax_id']) {
                  $('#payment-address input[name=\'tax_id\'] + br').after('<span class="error">' + json['error']['tax_id'] + '</span>');
               }

               if (json['error']['address_1']) {
                  $('#payment-address input[name=\'address_1\'] + br').after('<span class="error">' + json['error']['address_1'] + '</span>');
               }

               if (json['error']['city']) {
                  $('#payment-address input[name=\'city\'] + br').after('<span class="error">' + json['error']['city'] + '</span>');
               }

               if (json['error']['postcode']) {
                  $('#payment-address input[name=\'postcode\'] + br').after('<span class="error">' + json['error']['postcode'] + '</span>');
               }

               if (json['error']['country']) {
                  $('#payment-address select[name=\'country_id\'] + br').after('<span class="error">' + json['error']['country'] + '</span>');
               }

               if (json['error']['zone']) {
                  $('#payment-address select[name=\'zone_id\'] + br').after('<span class="error">' + json['error']['zone'] + '</span>');
               }
            } else {

               var shipping_address = $('#payment-address input[name=\'shipping_address\']:checked').attr('value');

               if (shipping_address) {
                  $.ajax({
                     url: 'index.php?route=checkout/shipping_method',
                     dataType: 'html',
                     success: function(html) {
                        $('#shipping-method .checkout-content').html(html);

                        $('#payment-address .checkout-content').slideUp('slow');

                        $('#shipping-method .checkout-content').slideDown('slow');

                        $('#payment-address .checkout-heading a').remove();
                        $('#shipping-address .checkout-heading a').remove();
                        $('#shipping-method .checkout-heading a').remove();
                        $('#payment-method .checkout-heading a').remove();

                        $('#payment-address .checkout-heading').append('<a>Modificar &raquo;</a>');
                        $('#shipping-address .checkout-heading').append('<a>Modificar &raquo;</a>');

                        $.ajax({
                           url: 'index.php?route=checkout/guest_shipping',
                           dataType: 'html',
                           success: function(html) {
                              $('#shipping-address .checkout-content').html(html);
                           },
                           error: function(xhr, ajaxOptions, thrownError) {
                              alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                           }
                        });
                     },
                     error: function(xhr, ajaxOptions, thrownError) {
                        alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                     }
                  });
               } else {
                  $.ajax({
                     url: 'index.php?route=checkout/guest_shipping',
                     dataType: 'html',
                     success: function(html) {
                        $('#shipping-address .checkout-content').html(html);

                        $('#payment-address .checkout-content').slideUp('slow');

                        $('#shipping-address .checkout-content').slideDown('slow');

                        $('#payment-address .checkout-heading a').remove();
                        $('#shipping-address .checkout-heading a').remove();
                        $('#shipping-method .checkout-heading a').remove();
                        $('#payment-method .checkout-heading a').remove();

                        $('#payment-address .checkout-heading').append('<a>Modificar &raquo;</a>');
                     },
                     error: function(xhr, ajaxOptions, thrownError) {
                        alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                     }
                  });
               }
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-guest-shipping').live('click', function() {
   alert("validando...");
      $.ajax({
         url: 'index.php?route=checkout/guest_shipping/validate',
         type: 'post',
         data: $('#shipping-address input[type=\'text\'], #shipping-address select'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-guest-shipping').attr('disabled', true);
            $('#button-guest-shipping').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-guest-shipping').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               if (json['error']['warning']) {
                  $('#shipping-address .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }

               if (json['error']['firstname']) {
                  $('#shipping-address input[name=\'firstname\']').after('<span class="error">' + json['error']['firstname'] + '</span>');
               }

               if (json['error']['lastname']) {
                  $('#shipping-address input[name=\'lastname\']').after('<span class="error">' + json['error']['lastname'] + '</span>');
               }

               if (json['error']['address_1']) {
                  $('#shipping-address input[name=\'address_1\']').after('<span class="error">' + json['error']['address_1'] + '</span>');
               }

               if (json['error']['city']) {
                  $('#shipping-address input[name=\'city\']').after('<span class="error">' + json['error']['city'] + '</span>');
               }

               if (json['error']['postcode']) {
                  $('#shipping-address input[name=\'postcode\']').after('<span class="error">' + json['error']['postcode'] + '</span>');
               }

               if (json['error']['country']) {
                  $('#shipping-address select[name=\'country_id\']').after('<span class="error">' + json['error']['country'] + '</span>');
               }

               if (json['error']['zone']) {
                  $('#shipping-address select[name=\'zone_id\']').after('<span class="error">' + json['error']['zone'] + '</span>');
               }
            } else {
               alert("metodo de envio???");
               $.ajax({
                  url: 'index.php?route=checkout/shipping_method',
                  dataType: 'html',
                  success: function(html) {
                     $('#shipping-method .checkout-content').html(html);

                     $('#shipping-address .checkout-content').slideUp('slow');

                     $('#shipping-method .checkout-content').slideDown('slow');

                     $('#shipping-address .checkout-heading a').remove();
                     $('#shipping-method .checkout-heading a').remove();
                     $('#payment-method .checkout-heading a').remove();

                     $('#shipping-address .checkout-heading').append('<a>Modificar &raquo;</a>');



                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-shipping-method').live('click', function() {
      $.ajax({
         url: 'index.php?route=checkout/shipping_method/validate',
         type: 'post',
         data: $('#shipping-method input[type=\'radio\']:checked, #shipping-method textarea'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-shipping-method').attr('disabled', true);
            $('#button-shipping-method').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-shipping-method').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               if (json['error']['warning']) {
                  $('#shipping-method .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }
            } else {
               $.ajax({
                  url: 'index.php?route=checkout/payment_method',
                  dataType: 'html',
                  success: function(html) {
                     $('#payment-method .checkout-content').html(html);

                     $('#shipping-method .checkout-content').slideUp('slow');

                     $('#payment-method .checkout-content').slideDown('slow');

                     $('#shipping-method .checkout-heading a').remove();
                     $('#payment-method .checkout-heading a').remove();

                     $('#shipping-method .checkout-heading').append('<a>Modificar &raquo;</a>');
                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   $('#button-payment-method').live('click', function() {
      $.ajax({
         url: 'index.php?route=checkout/payment_method/validate',
         type: 'post',
         data: $('#payment-method input[type=\'radio\']:checked, #payment-method input[type=\'checkbox\']:checked, #payment-method textarea'),
         dataType: 'json',
         beforeSend: function() {
            $('#button-payment-method').attr('disabled', true);
            $('#button-payment-method').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
         },
         complete: function() {
            $('#button-payment-method').attr('disabled', false);
            $('.wait').remove();
         },
         success: function(json) {
            $('.warning, .error').remove();

            if (json['redirect']) {
               location = json['redirect'];
            } else if (json['error']) {
               if (json['error']['warning']) {
                  $('#payment-method .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="http://casajosefa.com/catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');

                  $('.warning').fadeIn('slow');
               }
            } else {
               $.ajax({
                  url: 'index.php?route=checkout/confirm',
                  dataType: 'html',
                  success: function(html) {
                     $('#confirm .checkout-content').html(html);

                     $('#payment-method .checkout-content').slideUp('slow');

                     $('#confirm .checkout-content').slideDown('slow');

                     $('#payment-method .checkout-heading a').remove();

                     $('#payment-method .checkout-heading').append('<a>Modificar &raquo;</a>');
                  },
                  error: function(xhr, ajaxOptions, thrownError) {
                     alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                  }
               });
            }
         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   });

   function quickConfirm(module) {
      $.ajax({
         url: 'index.php?route=checkout/confirm',
         dataType: 'html',
         success: function(html) {
            $('#confirm .checkout-content').html(html);
            $('#confirm .checkout-content').slideDown('slow');


            $('.checkout-heading a').remove();

            $('#checkout .checkout-heading a').remove();
            $('#checkout .checkout-heading').append('<a>Modificar &raquo;</a>');

            $('#shipping-address .checkout-heading a').remove();
            $('#shipping-address .checkout-heading').append('<a>Modificar &raquo;</a>');

            $('#shipping-method .checkout-heading a').remove();
            $('#shipping-method .checkout-heading').append('<a>Modificar &raquo;</a>');

            $('#payment-address .checkout-heading a').remove();
            $('#payment-address .checkout-heading').append('<a>Modificar &raquo;</a>');

            $('#payment-method .checkout-heading a').remove();
            $('#payment-method .checkout-heading').append('<a>Modificar &raquo;</a>');

         },
         error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
         }
      });
   }
</script> 

