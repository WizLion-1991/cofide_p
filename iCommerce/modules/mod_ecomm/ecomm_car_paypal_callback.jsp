<%-- 
    Document   : ecomm_car_paypal_callback
    Created on : 05-sep-2014, 10:48:00
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>JSP Page</title>
   </head>
   <body>
      <h1>Callbak paypal!</h1>
      <%@ page import = "java.util.*" %>
      <%
         //Bitacora para el cliente...
         System.out.println("Test callbak paypal!.");
         Enumeration parameterList = request.getParameterNames();
         while (parameterList.hasMoreElements()) {
            String sName = parameterList.nextElement().toString();

            String[] sMultiple = request.getParameterValues(sName);
            if (1 >= sMultiple.length) // parameter has a single value. print it.
            {

               System.out.println(sName + " = " + request.getParameter(sName) + "<br>");
            } else {
               for (int i = 0; i < sMultiple.length; i++) // if a paramater contains multiple values, print all of them
               {
                  System.out.println(sName + "[" + i + "] = " + sMultiple[i] + "<br>");
               }
            }
         }
         /**
          * Example call back: Test callbak paypal!. tax2 = 0.00<br>
          * residence_country = MX<br>
          * tax1 = 0.00<br>
          * num_cart_items = 2<br>
          * invoice = Pedido 6<br>
          * address_city = Miguel Hidalgo<br>
          * payer_id = MTUQEYYHJK34J<br>
          * first_name = SandboxTest<br>
          * txn_id = 5LH77306BD918313K<br>
          * receiver_email = zgalindo-facilitator@siwebmx.com<br>
          * custom = 75<br>
          * payment_date = 11:23:40 Sep 12, 2014 PDT<br>
          * option_name1_1 = Colores<br>
          * mod = payment/pp_standard/callback<br>
          * option_name2_1 = Tallas<br>
          * charset = windows-1252<br>
          * address_country_code = MX<br>
          * option_selection2_1 = Menta<br>
          * payment_gross = <br>
          * item_name2 = Env?o, manipulaci?n, descuentos & impuestos<br>
          * address_zip = 11580<br>
          * item_name1 = Adonia<br>
          * ipn_track_id = ae318e9627f4e<br>
          * mc_handling = 0.00<br>
          * mc_handling1 = 0.00<br>
          * tax = 0.00<br>
          * mc_handling2 = 0.00<br>
          * address_name = SandboxTest Account<br>
          * last_name = Account<br>
          * receiver_id = XQC5RCFJ85AH8<br>
          * verify_sign =
          * ARz.6oXiv51QGRr0mx8LZyY24hpoAtJCS4BdrBUn0RdwcMBfQWhSkMUW<br>
          * address_country = Mexico<br>
          * business = zgalindo-facilitator@siwebmx.com<br>
          * payment_status = Pending<br>
          * address_status = unconfirmed<br>
          * transaction_subject = 75<br>
          * protection_eligibility = Eligible<br>
          * payer_email = aleph_79_z@me.com<br>
          * notify_version = 3.8<br>
          * txn_type = cart<br>
          * mc_gross = 283.34<br>
          * test_ipn = 1<br>
          * payer_status = verified<br>
          * mc_currency = MXN<br>
          * mc_shipping = 0.00<br>
          * mc_gross_1 = 249.00<br>
          * mc_gross_2 = 34.34<br>
          * mc_shipping2 = 0.00<br>
          * mc_shipping1 = 0.00<br>
          * item_number2 = <br>
          * item_number1 = TQ12050516M<br>
          * option_selection1_1 = <br>
          * quantity1 = 1<br>
          * quantity2 = 1<br>
          * address_state = Ciudad de Mexico<br>
          * pending_reason = multi_currency<br>
          * payment_type = instant<br>
          * address_street = Calle Juarez 1<br>
          */
         //Iniciamos valores
         VariableSession varSesiones = new VariableSession(request);
         varSesiones.getVars();
         //Abrimos la conexion
         Conexion oConn = new Conexion(null, this.getServletContext());
         oConn.open();
         String strIdPedido = request.getParameter("custom");
         //Limpiamos el carrito de compras anterior
         Sesiones.SetSession(request, "CarSell", "0");
         //Instanciamos objeto para mails
         Mail mail = new Mail();
         String strLstMail = "";
         //Buscaos usuario que reciban notificaciones
         String strSqlUsuarios = "SELECT EMAIL FROM usuarios WHERE BOL_MAIL_PAGOS_WEB=1";
         try {
            ResultSet rs = oConn.runQuery(strSqlUsuarios);

            while (rs.next()) {
               if (!rs.getString("EMAIL").equals("")) {
                  strLstMail += "," + rs.getString("EMAIL");
               }
            }

            rs.close();
         } catch (SQLException ex) {
            //this.strResultLast = "ERROR:" + ex.getMessage();
            ex.fillInStackTrace();
         }
         //Si hay correos enviamos el mail
         if (!strLstMail.isEmpty()) {
            //Intentamos mandar el mail
            mail.setBolDepuracion(false);
            mail.getTemplate("PAGO_WEB", oConn);
            mail.getMensaje();
            mail.setDestino(strLstMail);
            String strSqlEmp = "SELECT *,DATE_FORMAT(CURDATE(), '%d/%m/%Y') as FECHA,'Paypal' as MEDIO_PAGO FROM vta_pedidos"
                    + " where PD_ID=" + strIdPedido + "";
            try {
               ResultSet rs = oConn.runQuery(strSqlEmp);
               mail.setReplaceContent(rs);

               rs.close();
            } catch (SQLException ex) {
               //this.strResultLast = "ERROR:" + ex.getMessage();
               ex.fillInStackTrace();
            }
            mail.setDestino(strLstMail);


            boolean bol = mail.sendMail();
            if (bol) {
            }
         }

         oConn.close();
      %>
   </body>
</html>
