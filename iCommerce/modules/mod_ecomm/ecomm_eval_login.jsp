<%-- 
    Document   : ecomm_eval_login
    Created on : 03-sep-2014, 15:48:46
    Author     : ZeusGalindo
--%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Tablas.vta_pedidosdeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.DocumentException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="comSIWeb.Operaciones.Reportes.PDFEventPage"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="comSIWeb.Operaciones.Reportes.CIP_Formato"%>
<%@page import="comSIWeb.Operaciones.Formatos.Formateador"%>
<%@page import="ERP.Ticket"%>
<%@page import="Tablas.vta_cliente_dir_entrega"%>
<%@page import="com.SIWeb.struts.LoginAction"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%
   //Iniciamos valores
   VariableSession varSesiones = new VariableSession(request);
//Abrimos la conexion
   Conexion oConn = new Conexion(null, this.getServletContext());
   oConn.open();
   //Consultamos los estados
   ArrayList<String> lstEstado = new ArrayList<String>();
   String strSql = "select * from estadospais where PA_ID = 1";
   ResultSet rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      lstEstado.add(rs.getString("ESP_NOMBRE"));
   }
   rs.close();
   //Obtenemos la tasa de impuesto por aplicar
   double dblFactorImpuesto = 0;
   strSql = "select * from vta_tasaiva where TI_ID = 1";
   rs = oConn.runQuery(strSql);
   while (rs.next()) {
      dblFactorImpuesto = rs.getDouble("TI_TASA");
      dblFactorImpuesto = 0;
   }
   rs.close();
   //Configuracion sitio
   Site webBase = new Site(oConn);

   String strMod = request.getParameter("mod");
   if (strMod == null) {
      strMod = "html";
   }
   //Evaluamos la sesion
   if (strMod.equals("json1")) {
      JSONObject objJsonCte = new JSONObject();
      boolean bolError = false;
      String strMsgError = "";
      String strUser = request.getParameter("email-login");
      String strPass = request.getParameter("password-login");
      if (strUser == null
              || strPass == null) {
         bolError = true;
         strMsgError = "Debe llenar los campos de usuario y password";
      } else {
         if (strUser.isEmpty()
                 || strPass.isEmpty()) {
            bolError = true;
            strMsgError = "Debe llenar los campos de usuario y password";
         }

      }
      //Resultado...
      if (bolError) {
         objJsonCte.put("error", strMsgError);
      } else {
         objJsonCte.put("success", "Exito has ingresado al sistema");
      }
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
      out.println(objJsonCte.toString());
   }
   //Evaluamos los campos para usuario nuevo
   if (strMod.equals("json2")) {
      JSONObject objJsonCte = new JSONObject();
      boolean bolError = false;

      String confirm = request.getParameter("confirm");
      String email = request.getParameter("email");
      String fax = request.getParameter("fax");
      String firstname = request.getParameter("firstname");
      String lastname = request.getParameter("lastname");
      String password = request.getParameter("password");
      String telephone = request.getParameter("telephone");
      String agree = request.getParameter("agree");

      boolean bolconfirm = false;
      boolean bolemail = false;
      boolean bolfax = false;
      boolean bolfirstname = false;
      boolean bollastname = false;
      boolean bolpassword = false;
      boolean boltelephone = false;
      boolean bolagree = false;
      boolean bolEqualMail = false;
      boolean bolEqualPassword = false;
      if (email.isEmpty()) {
         Mail mail = new Mail();
         if (!mail.isEmail(email)) {
            bolemail = true;
            bolError = true;
         }
      }
      if (fax.isEmpty()) {
         Mail mail = new Mail();
         if (!mail.isEmail(fax)) {
            bolfax = true;
            bolError = true;
         } else {
            if (!fax.equals(email)) {
               bolEqualMail = true;
               bolError = true;
            }
         }
      }
      if (firstname.isEmpty()) {
         bolfirstname = true;
         bolError = true;
      }
      if (lastname.isEmpty()) {
         bollastname = true;
         bolError = true;
      }
      if (telephone.isEmpty()) {
         boltelephone = true;
         bolError = true;
      } else {
         String pattern = "dd/MM/yyyy";
         SimpleDateFormat format = new SimpleDateFormat(pattern);
         try {
            Date date = format.parse(telephone);
            System.out.println(date);
         } catch (ParseException e) {
            boltelephone = true;
            bolError = true;
         }
      }
      if (password.isEmpty()) {
         bolpassword = true;
         bolError = true;
      }
      if (confirm.isEmpty()) {
         bolconfirm = true;
         bolError = true;
      } else {
         if (!confirm.equals(password)) {
            bolEqualPassword = true;
            bolError = true;
         }

      }
      if (agree == null) {
         bolagree = true;
         bolError = true;
      } else {
         if (!agree.equals("1")) {
            bolagree = true;
            bolError = true;
         }
      }
      //Resultado...
      if (bolError) {
         //Respuesta de error
         JSONObject objJsonCte3 = new JSONObject();
         if (bolfirstname) {
            objJsonCte3.put("firstname", "Debe capturar el nombre!");
         }
         if (bollastname) {
            objJsonCte3.put("lastname", "Debe capturar el apellido!");
         }
         if (bolpassword) {
            objJsonCte3.put("password", "Debe capturar el password!");
         }
         if (bolconfirm) {
            objJsonCte3.put("confirm", "Debe capturar la confirmacion del password!");
         }
         if (bolEqualPassword) {
            objJsonCte3.put("password", "La confirmacion del password no coincide!");
         }
         if (boltelephone) {
            objJsonCte3.put("telephone", "La fecha de nacimiento no es valida(dd/mm/yyyy)!");
         }
         if (bolemail) {
            objJsonCte3.put("email", "La direcci\u00f3n de E-Mail no es valida!");
         }
         if (bolfax) {
            objJsonCte3.put("fax", "La direcci\u00f3n de E-Mail no es valida!");
         }
         if (bolEqualMail) {
            objJsonCte3.put("fax", "La direcci\u00f3n de confirmarción de E-Mail no es igual a la primera!");
         }
         if (bolagree) {
            objJsonCte3.put("warning", "Advertencia: Usted debe estar de acuerdo con the Politicas de Privacidad!");
         }
         objJsonCte.put("error", objJsonCte3);
      } else {
         boolean boolGuardoOK = true;

         //Guardamos el nuevo cliente en el sistema...
         //Para manejo de fechas
         Fechas fecha = new Fechas();
         Periodos periodo = new Periodos();
         int intreferrer = 0;
         //OJO MOVER AL NODO QUE SERA PUBLICO GENERAL...
         if (intreferrer == 0) {
            intreferrer = 3;
         }

         //Llamamos objeto para guardar los datos de la tabla
         CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
         objTabla.Init("CLIENTES", true, true, false, oConn);
         objTabla.setBolGetAutonumeric(true);
         out.clearBuffer();//Limpiamos buffer
         //atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML7
         //objTabla.ObtenParams(true, true, false, false, request, oConn);
         objTabla.setFieldInt("SC_ID", webBase.getIntSC_ID());
         objTabla.setFieldInt("EMP_ID", webBase.getIntEMP_ID());
         objTabla.setFieldInt("CT_UPLINE", intreferrer);
         objTabla.setFieldInt("CT_ACTIVO", 1);
         objTabla.setFieldInt("CT_LPRECIOS", 1);
         objTabla.setFieldInt("MON_ID", 1);
         objTabla.setFieldInt("CT_SPONZOR", intreferrer);
         objTabla.setFieldInt("MPE_ID", periodo.getPeriodoActual(oConn));

         objTabla.setFieldString("CT_RAZONSOCIAL", firstname + " " + lastname);
         objTabla.setFieldString("CT_NOMBRE", firstname);
         objTabla.setFieldString("CT_APATERNO", lastname);
         objTabla.setFieldString("CT_AMATERNO", "");
         objTabla.setFieldString("CT_RFC", "XAXX010101000");
         objTabla.setFieldString("CT_CRED_ELECTOR", "");
         objTabla.setFieldString("CT_CALLE", "");
         objTabla.setFieldString("CT_NUMERO", "");
         objTabla.setFieldString("CT_NUMINT", "");
         objTabla.setFieldString("CT_COLONIA", "");
         objTabla.setFieldString("CT_MUNICIPIO", "");
         objTabla.setFieldString("CT_LOCALIDAD", "");
         objTabla.setFieldString("CT_ESTADO", "");
         objTabla.setFieldString("CT_CP", "");
         objTabla.setFieldString("CT_TELEFONO1", "");
         objTabla.setFieldString("CT_TELEFONO2", "");
         objTabla.setFieldString("CT_CONTACTO1", "");
         objTabla.setFieldString("CT_EMAIL1", email);
         objTabla.setFieldString("CT_EMAIL2", "");
         objTabla.setFieldString("CT_CTABANCO1", "");
         objTabla.setFieldString("CT_CTABANCO2", "");
         objTabla.setFieldString("CT_CTA_BANCO1", "");
         objTabla.setFieldString("CT_CTA_BANCO2", "");
         objTabla.setFieldString("CT_CTA_SUCURSAL1", "");
         objTabla.setFieldString("CT_CTA_SUCURSAL2", "");
         objTabla.setFieldString("CT_CTA_CLABE1", "");
         objTabla.setFieldString("CT_CTA_CLABE2", "");
         objTabla.setFieldString("CT_FECHAREG", fecha.getFechaActual());
         objTabla.setFieldString("CT_FECHA_NAC", fecha.FormateaBD(telephone, "/"));
         objTabla.setFieldString("CT_NOTAS", "");
         /**
          * Generamos un password aleatorio
          */
         objTabla.setFieldString("CT_PASSWORD", password);

         //Generamos una alta
         String strResult = objTabla.Agrega(oConn);
         String strKey = objTabla.getValorKey();
         int idCt = 0;
         if (strResult.equals("OK")) {

            if (!strKey.equals("") || strKey != null) {
               idCt = Integer.parseInt(strKey);
            }

            //Direccion de entrega
            /*
             * vta_cliente_dir_entrega dirEnt = new vta_cliente_dir_entrega();
             if (strResult.equals("OK")) {
             dirEnt.setFieldString("CDE_NOMBRE", firstname + " " + lastname);
             dirEnt.setFieldString("CDE_TELEFONO1", "");
             dirEnt.setFieldString("CDE_EMAIL", email);
             dirEnt.setFieldString("CDE_CALLE", "");
             dirEnt.setFieldString("CDE_NUMERO", "");
             dirEnt.setFieldString("CDE_NUMINT", "");
             dirEnt.setFieldString("CDE_COLONIA", "");
             dirEnt.setFieldString("CDE_ESTADO", "");
             dirEnt.setFieldString("CDE_MUNICIPIO", "");
             dirEnt.setFieldString("CDE_CP", "");
             dirEnt.setFieldString("CDE_LOCALIDAD", "MEXICO");
             dirEnt.setFieldString("CDE_DESCRIPCION", "");
             dirEnt.setFieldInt("EMP_ID", webBase.getIntEMP_ID());
             dirEnt.setFieldInt("CT_ID", idCt);

             String strResEntrega = dirEnt.Agrega(oConn);
             }*/
            String strSqlUsuarios = "";
            //validamos que hallan puesto el mail
            Mail mail = new Mail();
            if (!email.isEmpty()) {
               String strLstMail = "";
               //Validamos si el mail del cliente es valido
               if (mail.isEmail(email)) {
                  strLstMail += "," + email;
               }
               //Buscamos usuario que tengan la bandera de ingresos
               strSqlUsuarios = "SELECT EMAIL FROM usuarios WHERE BOL_MAIL_INGRESOS=1";
               try {
                  rs = oConn.runQuery(strSqlUsuarios);

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
               //Intentamos mandar el mail
               mail.setBolDepuracion(false);
               mail.getTemplate("MSG_ING", oConn);
               mail.getMensaje();
               String strSqlEmp = "SELECT * FROM vta_cliente"
                       + " where CT_ID=" + objTabla.getValorKey() + "";
               try {
                  rs = oConn.runQuery(strSqlEmp);
                  mail.setReplaceContent(rs);
                  rs.close();
               } catch (SQLException ex) {
                  //this.strResultLast = "ERROR:" + ex.getMessage();
                  ex.fillInStackTrace();
               }
               mail.setDestino(strLstMail);
               boolean bol = mail.sendMail();
               if (bol) {
                  //strResp = "MAIL ENVIADO.";
               } else {
                  //strResp = "FALLO EL ENVIO DEL MAIL.";
               }

            } else {
               //strResp = "ERROR: INGRESE UN MAIL";
            }
         }
         boolGuardoOK = true;
         if (boolGuardoOK) {
            objJsonCte.put("success", "Exito has sido registrado en el sistema, en breve te llegara un correo.");
            //Logueamos al usuario
            //Objeto para validar la seguridad
            LoginAction action = new LoginAction();
            action.setBolSoloCliente(true);
            //solo evaluamos si el password esta lleno
            if (!password.isEmpty()) {
               action.authentication_user(oConn, idCt + "", password, request);
            }
         } else {
            JSONObject objJsonCte3 = new JSONObject();
            objJsonCte3.put("warning", "Advertencia: Hubo un problema al guardar sus datos. Intentelo más tarde.");
            objJsonCte.put("error", objJsonCte3);
         }
      }
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
      out.println(objJsonCte.toString());
   }
   //Pintamos el html
   if (strMod.equals("html")) {

%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="cart-info" style="border:0px;text-align: center;">
   <h2>CLIENTE NUEVO</h2>
   <br style="clear:both">
   <center>
      <div >
         <span class="required" style="text-align:left;">*</span> Nombre:<br>
         <input name="firstname" value="" class="large-field" style="background:#C2C2C2;" type="text">
         <br>
         <br>
         <span class="required">*</span> Apellido/s:<br>
         <input name="lastname" value="" class="large-field" style="background:#C2C2C2;" type="text">
         <br>  
         <br>
         <span class="required">*</span>Fecha Nacimiento<br>
         <input name="telephone" value="" class="large-field" style="background:#C2C2C2;" type="text">
         <br>
         <br>
         <span class="required">*</span> E-Mail:<br>
         <input name="email" value="" class="large-field" style="background:#C2C2C2;" type="text">
         <br>
         <br>
         Confirmar Email<br>
         <input name="fax" value="" class="large-field" style="background:#C2C2C2;" type="text">
         <br>
         <br>
         <span class="required">*</span> Contraseña:<br>
         <input name="password" value="" class="large-field" style="background:#C2C2C2;" type="password">
         <br>
         <br>
         <span class="required">*</span> Confirma contraseña: <br>
         <input name="confirm" value="" class="large-field" style="background:#C2C2C2;" type="password">
         <br>
         <br>
         <br>
      </div>
   </center>
   <div style="clear: both; padding-top: 15px; border-top: 1px solid #EEEEEE; display:none;">
      <input name="newsletter" value="1" id="newsletter" style="background:#C2C2C2;" type="checkbox">
      <label for="newsletter">Deseo suscribirme al boletín de noticias de Casa Josefa.</label>
      <br>
      <input name="shipping_address" value="1" id="shipping" checked="checked" style="background:#C2C2C2;" type="checkbox">
      <label for="shipping">Mi dirección de entrega y facturación es la misma.</label>
      <br>
      <br>
      <br>
   </div>
   <div class="buttons">
      <div>
         He leido y acepto los <a class="thickbox" href="http://casajosefa.com/index.php?route=information/information/info&amp;information_id=3" alt="Politicas de Privacidad"><b>Politicas de Privacidad</b></a>  	  
         <input name="agree" value="1" type="checkbox">
         <br>
         <br style="clear:both">
         <input value="CONTINUAR" id="button-register" class="type_button" type="button">    
      </div>
   </div>


</div>
<!--
<div id="login" style="float: right; margin-right:30px">

   <h2>CLIENTE REGISTRADO</h2>
   <br style="clear:both">  
   <b>E-Mail:</b><br>
   <input name="email-login" value="" style="background:#C2C2C2;" type="text">
   <br>
   <br>
   <b>Contraseña:</b><br>
   <input name="password-login" value="" style="background:#C2C2C2; " type="password">
   <br>
   <a href="http://casajosefa.com/index.php?route=account/forgotten">¿ Olvidaste la contraseña ?</a><br>
   <br>
   <input value="INICIAR SESION" id="button-login" class="type_button" type="button"><br>
   <br>
</div>
-->
<%   }

   //shipping address
   if (strMod.equals("json3")) {
      String estado = "";
%>
<div class="left" style="width:25%">
   <div id="shipping-new" style="display: block;">
      <table class="form">
         <tr>
            <td><span class="required">*</span> Nombre:</td>
         </tr>    
         <tr>
            <td><input type="text" name="firstname" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Apellido/s:</td>
         </tr>    
         <tr>
            <td><input type="text" name="lastname" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Calle :</td>
         </tr>    
         <tr>
            <td><input type="text" name="calle" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td>Numero :</td>
         </tr>    
         <tr>
            <td><input type="text" name="numero" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td>Numero interior:</td>
         </tr>    
         <tr>
            <td><input type="text" name="numero_int" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td>Colonia:</td>
         </tr>    
         <tr>
            <td><input type="text" name="colonia" value="" class="large-field" /></td>
         </tr>

         <tr>
            <td><span id="shipping-postcode-required" class="required">*</span> Código postal:</td>
         </tr>    
         <tr>
            <td><input type="text" name="postcode" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> País:</td>
         </tr>    
         <tr>
            <td><select name="country_id" class="large-field" disabled>
                  <option value=""> --- Por favor Selecciona--- </option>
                  <option value="138" selected="selected">Mexico</option>

               </select></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Estado:</td>
         </tr>    
         <tr>
            <td><select name="zone_id" class="large-field">
                  <%
                     //Mostramos los estados.
                     Iterator<String> it = lstEstado.iterator();
                     while (it.hasNext()) {
                        String strEstado = it.next();
                        if (strEstado.equals(estado)) {
                  %><option id="<%=strEstado%>" selected><%=strEstado%></option><%
                  } else {
                  %><option id="<%=strEstado%>"><%=strEstado%></option><%
                        }
                     }
                  %>
               </select></td>
         </tr>

         <tr>
            <td><span class="required">*</span> Municipio:</td>
         </tr>    
         <tr>            
            <td><input type="text" name="city" value="" class="large-field" /></td>
         </tr>
      </table>
   </div>
   <br />
   <div class="buttons">
      <div class="right">
         <input type="button" value="Continuar" id="button-shipping-address" class="button" style="width:100%" />
      </div>
   </div>

</div>

<div class="right" style="width:65%">

   <jsp:include page="ecomm_car_view_small.jsp" />
</div>

<script type="text/javascript"><!--
$('#shipping-address input[name=\'shipping_address\']').live('change', function() {
      if (this.value == 'new') {
         $('#shipping-existing').hide();
         $('#shipping-new').show();
      } else {
         $('#shipping-existing').show();
         $('#shipping-new').hide();
      }
   });
//--></script> 
<script type="text/javascript"><!--

//--></script>
   <%         }
      //payment address
      if (strMod.equals("json4")) {
         String estado = "";
   %>
<div class="left" style="width:25%">
   <div id="payment-new" style="display: block;">
      <table class="form">
         <tr>
            <td><span class="required">*</span> Nombre:</td>
         </tr>    
         <tr>
            <td><input type="text" name="firstname" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Apellido/s:</td>
         </tr>    
         <tr>
            <td><input type="text" name="lastname" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Calle :</td>
         </tr>    
         <tr>
            <td><input type="text" name="calle" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span>Numero :</td>
         </tr>    
         <tr>
            <td><input type="text" name="numero" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td>Numero interior:</td>
         </tr>    
         <tr>
            <td><input type="text" name="numero_int" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span>Colonia:</td>
         </tr>    
         <tr>
            <td><input type="text" name="colonia" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span id="payment-postcode-required" class="required">*</span> Código postal:</td>
         </tr>    
         <tr>
            <td><input type="text" name="postcode" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> País:</td>
         </tr>    
         <tr>
            <td><select name="country_id" class="select-large-field" style="background: #d8d6d6" disabled>
                  <option value=""> --- Por favor Selecciona--- </option>
                  <option value="138" selected="selected">Mexico</option>

               </select></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Estado:</td>
         </tr>    
         <tr>
            <td><select name="zone_id" class="select-large-field" style="background: #d8d6d6">
                  <%
                     //Mostramos los estados.
                     Iterator<String> it = lstEstado.iterator();
                     while (it.hasNext()) {
                        String strEstado = it.next();
                        if (strEstado.equals(estado)) {
                  %><option id="<%=strEstado%>" selected><%=strEstado%></option><%
                  } else {
                  %><option id="<%=strEstado%>"><%=strEstado%></option><%
                        }
                     }
                  %>
               </select></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Municipio:</td>
         </tr>    
         <tr>
            <td><input type="text" name="city" value="" class="large-field" /></td>
         </tr>
      </table>
   </div>
   <br />
   <div class="buttons" align="center">
      <input type="submit" value="CONTINUAR" id="button-payment-address" class="type_button"/>

   </div>

</div>

<div class="right" style="width:65%">

   <jsp:include page="ecomm_car_view_small.jsp" />
</div>
<script type="text/javascript"><!--

   $('#breadcumb_1').css('color', 'white');
   $('#breadcumb_2').css('color', 'white');
   $('#breadcumb_3').css('color', 'white');
   $('#breadcumb_4').css('color', 'white');
   $('#breadcumb_5').css('color', 'white');

   $('#breadcumb_3').css('color', 'gray');

   $('#payment-address input[name=\'payment_address\']').live('change', function() {
      if (this.value == 'new') {
         $('#payment-existing').hide();
         $('#payment-new').show();
      } else {
         $('#payment-existing').show();
         $('#payment-new').hide();
      }
   });
//--></script> 
<script type="text/javascript"><!--

//--></script>
   <%         }

      //eval payment address
      if (strMod.equals("json5")) {
         JSONObject objJsonCte = new JSONObject();
         boolean bolError = false;
         String route = request.getParameter("route");
         String payment_address = request.getParameter("payment_address");
         if (payment_address == null) {
            payment_address = "";
         }
         if (route == null) {
            route = "payment_address/validate";
         }
         //Asignamos id de direccion de envio al pedido
         if (route.equals("payment_address/validate") && payment_address.equals("existing")) {
            String address_id = request.getParameter("address_id");
            //Guardamos el id de la direccion de envio
            String strLst = Sesiones.gerVarSession(request, "CarSell");
            JSONObject objJsonCarrito = new JSONObject(strLst);
            if (!strLst.equals("0")) {
               int intAddress_id = 0;
               try {
                  intAddress_id = Integer.valueOf(address_id);
                  objJsonCarrito.remove("address_id");
                  objJsonCarrito.put("address_id", intAddress_id);
                  //Actualizamos el carrito
                  Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());
               } catch (NumberFormatException ex) {
               }

            }
         }
         if (route.equals("payment_address/validate") && !payment_address.equals("existing")) {
            String calle = request.getParameter("calle");
            String city = request.getParameter("city");
            String colonia = request.getParameter("colonia");
            String country_id = request.getParameter("country_id");
            String firstname = request.getParameter("firstname");
            String lastname = request.getParameter("lastname");
            String numero = request.getParameter("numero");
            String numero_int = request.getParameter("numero_int");
            String postcode = request.getParameter("postcode");
            String zone_id = request.getParameter("zone_id");
            boolean bolcalle = false;
            boolean bolcity = false;
            boolean bolcolonia = false;
            boolean bolcountry_id = false;
            boolean bolfirstname = false;
            boolean bollastname = false;
            boolean bolnumero = false;
            boolean bolpostcode = false;
            boolean bolzone_id = false;
            if (firstname.isEmpty()) {
               bolfirstname = true;
               bolError = true;
            }
            if (lastname.isEmpty()) {
               bollastname = true;
               bolError = true;
            }
            if (calle.isEmpty()) {
               bolcalle = true;
               bolError = true;
            }
            if (numero.isEmpty()) {
               bolnumero = true;
               bolError = true;
            }
            if (colonia.isEmpty()) {
               bolcolonia = true;
               bolError = true;
            }
            if (postcode.isEmpty()) {
               bolpostcode = true;
               bolError = true;
            }
            if (city.isEmpty()) {
               bolcity = true;
               bolError = true;
            }
            //Resultado...


            if (bolError) {
               //Respuesta de error
               JSONObject objJsonCte3 = new JSONObject();
               if (bolfirstname) {
                  objJsonCte3.put("firstname", "Debe capturar el nombre!");
               }
               if (bollastname) {
                  objJsonCte3.put("lastname", "Debe capturar el apellido!");
               }
               if (bolcalle) {
                  objJsonCte3.put("calle", "Debe capturar la calle");
               }

               if (bolcolonia) {
                  objJsonCte3.put("colonia", "Debe capturar la colonia");
               }
               if (bolnumero) {
                  objJsonCte3.put("numero", "Debe capturar el numero");
               }
               if (bolzone_id) {
                  objJsonCte3.put("zone_id", "Debe capturar el estado");
               }
               if (bolpostcode) {
                  objJsonCte3.put("postcode", "Debe capturar el estado");
               }
               if (bolcity) {
                  objJsonCte3.put("city", "Debe capturar el municipio");
               }
               objJsonCte.put("error", objJsonCte3);
            } else {
               varSesiones.getVars();
               //Guardamos la direccion de envio capturada
               vta_cliente_dir_entrega dirEnt = new vta_cliente_dir_entrega();
               dirEnt.setFieldString("CDE_NOMBRE", firstname + " " + lastname);
               dirEnt.setFieldString("CDE_TELEFONO1", "");
               dirEnt.setFieldString("CDE_EMAIL", "");
               dirEnt.setFieldString("CDE_CALLE", calle);
               dirEnt.setFieldString("CDE_NUMERO", numero);
               dirEnt.setFieldString("CDE_NUMINT", numero_int);
               dirEnt.setFieldString("CDE_COLONIA", colonia);
               dirEnt.setFieldString("CDE_ESTADO", zone_id);
               dirEnt.setFieldString("CDE_MUNICIPIO", city);
               dirEnt.setFieldString("CDE_CP", postcode);
               dirEnt.setFieldString("CDE_LOCALIDAD", "MEXICO");
               dirEnt.setFieldString("CDE_DESCRIPCION", "Dir");
               dirEnt.setFieldInt("EMP_ID", webBase.getIntEMP_ID());
               dirEnt.setFieldInt("CT_ID", varSesiones.getIntNoUser());
               dirEnt.setBolGetAutonumeric(true);
               String strResEntrega = dirEnt.Agrega(oConn);
               //Asignamos la direccion de entrega al carrito
               String strLst = Sesiones.gerVarSession(request, "CarSell");
               JSONObject objJsonCarrito = new JSONObject(strLst);
               if (!strLst.equals("0")) {
                  int intAddress_id = 0;
                  try {
                     intAddress_id = Integer.valueOf(dirEnt.getValorKey());
                     objJsonCarrito.remove("address_id");
                     objJsonCarrito.put("address_id", intAddress_id);
                     //Actualizamos el carrito
                     Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());
                  } catch (NumberFormatException ex) {
                  }
               }

            }
         }

         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(objJsonCte.toString());
      }

      if (strMod.equals("json6")) {

   %>
<div class="left" style="width:25%">
   <input type="radio" name="payment_address" value="existing" id="payment-address-existing" checked="checked" />
   <label for="payment-address-existing">Quiero usar una dirección existente</label>
   <div id="payment-existing">
      <select id='address_id_temp' name="address_id" style="width: 100%; margin-bottom: 15px;" size="5">
         <%
            //Recuperamos la ultima dirección de envio
            varSesiones.getVars();
            if (varSesiones.getIntNoUser() != 0) {
               String strSqlEnvio = "select * from vta_cliente_dir_entrega where CT_ID = " + varSesiones.getIntNoUser();
               ResultSet rsDir = oConn.runQuery(strSqlEnvio, true);
               while (rsDir.next()) {
                  String strDireccionEnvio = rsDir.getString("CDE_CALLE") + " "
                          + rsDir.getString("CDE_NUMERO") + ""
                          + rsDir.getString("CDE_NUMINT") + ""
                          + rsDir.getString("CDE_COLONIA") + ""
                          + rsDir.getString("CDE_MUNICIPIO") + ""
                          + rsDir.getString("CDE_ESTADO") + ""
                          + rsDir.getString("CDE_CP") + "";
         %>
         <option value="<%=rsDir.getInt("CDE_ID")%>" selected="selected"><%=strDireccionEnvio%></option>
         <%
               }
               rsDir.close();
            }
         %>

      </select>
   </div>
   <p>
      <input type="radio" name="payment_address" value="new" id="payment-address-new" />
      <label for="payment-address-new">Quiero usar una nueva dirección</label>
   </p>

   <script>
      $('#address_id_temp > option:first-child').attr('selected', true);
   </script>

   <div id="payment-new" style="display: none;">
      <table class="form">
         <tr>
            <td><span class="required">*</span> Nombre:</td>
         </tr>    
         <tr>
            <td><input type="text" name="firstname" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Apellido/s:</td>
         </tr>    
         <tr>
            <td><input type="text" name="lastname" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Calle :</td>
         </tr>    
         <tr>
            <td><input type="text" name="calle" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Numero :</td>
         </tr>    
         <tr>
            <td><input type="text" name="numero" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td>Numero interior:</td>
         </tr>    
         <tr>
            <td><input type="text" name="numero_int" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Colonia:</td>
         </tr>    
         <tr>
            <td><input type="text" name="colonia" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span id="payment-postcode-required" class="required">*</span> Código postal:</td>
         </tr>    
         <tr>
            <td><input type="text" name="postcode" value="" class="large-field" /></td>
         </tr>
         <tr>
            <td><span class="required">*</span> País:</td>
         </tr>    
         <tr>
            <td><select name="country_id" class="select-large-field" style="background: #d8d6d6" disabled>
                  <option value=""> --- Por favor Selecciona--- </option>
                  <option value="138" selected="selected">Mexico</option>

               </select></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Estado:</td>
         </tr>    
         <tr>
            <td><select name="zone_id" class="select-large-field" style="background: #d8d6d6">
                  <option value=""> --- Por favor Selecciona--- </option>
                  <%
                     //Mostramos los estados.
                     String estado = "";
                     Iterator<String> it = lstEstado.iterator();
                     while (it.hasNext()) {
                        String strEstado = it.next();
                        if (strEstado.equals(estado)) {
                  %><option id="<%=strEstado%>" selected><%=strEstado%></option><%
                  } else {
                  %><option id="<%=strEstado%>"><%=strEstado%></option><%
                        }
                     }
                  %>
               </select></td>
         </tr>
         <tr>
            <td><span class="required">*</span> Municipio:</td>
         </tr>    
         <tr>
            <td><input type="text" name="city" value="" class="large-field" /></td>
         </tr>
      </table>
   </div>
   <br />
   <div class="buttons" align="center">
      <input type="submit" value="CONTINUAR" id="button-payment-address" class="type_button"/>

   </div>

</div>

<div class="right" style="width:65%">

   <jsp:include page="ecomm_car_view_small.jsp" />
</div>
<script type="text/javascript"><!--

   $('#breadcumb_1').css('color', 'white');
   $('#breadcumb_2').css('color', 'white');
   $('#breadcumb_3').css('color', 'white');
   $('#breadcumb_4').css('color', 'white');
   $('#breadcumb_5').css('color', 'white');

   $('#breadcumb_3').css('color', 'gray');

   $('#payment-address input[name=\'payment_address\']').live('change', function() {
      if (this.value == 'new') {
         $('#payment-existing').hide();
         $('#payment-new').show();
      } else {
         $('#payment-existing').show();
         $('#payment-new').hide();
      }
   });
//--></script> 
<script type="text/javascript"><!--
//--></script>
   <%   }
      //Mostramos los metodos de pago
      if (strMod.equals("json7")) {
         out.clearBuffer();
   %>
<div class="left" style="width:25%">
   <p><b>Por favor selecciona el método de pago a usar en este pedido.</b></p>
   <table class="radio">
      <%
         //Consultamos las formas de pago en línea
         String strSqlEnvio = "select * from ecomm_payments where PAYMENT_ACTIVE = 1 ";
         ResultSet rsDir = oConn.runQuery(strSqlEnvio, true);
         while (rsDir.next()) {
            String strPAYMENT_TYPE = rsDir.getString("PAYMENT_TYPE");
            String strPAYMENT_DESC = rsDir.getString("PAYMENT_DESC");
            String strChecked = "";
            if (rsDir.getInt("PAYMENT_DEFAULT") == 1) {
               strChecked = " checked=\"checked\" ";
            }
      %>
      <tr class="highlight">
         <td><label for="<%=strPAYMENT_TYPE%>"><%=strPAYMENT_DESC%></label></td>
         <td><input type="radio" name="payment_method" value="<%=strPAYMENT_TYPE%>" id="<%=strPAYMENT_TYPE%>" <%=strChecked%> /></td>
      </tr>
      <%
         }
         rsDir.close();

      %>
   </table>
   <br />
   <b>Añade comentarios sobre tu pedido</b>
   <textarea name="comment" rows="8" style="width: 98%;"></textarea>
   <br />
   <br />
   <div class="buttons">
      <div >He leido y acepto los <a class="thickbox" href="http://casajosefa.com/index.php?route=information/information/info&amp;information_id=5" alt="Terminos y Condiciones"><b>Terminos y Condiciones</b></a>        <input type="checkbox" name="agree" value="1" />
         <div style='clear:both'></div>
         <div class="right">
            <input type="button" value="Continuar" id="button-payment-method" class="type_button" />
         </div>
      </div>
   </div>

</div>

<div class="right" style="width:65%">


   <jsp:include page="ecomm_car_view_small.jsp" />
</div>

<script type="text/javascript"><!--

   $('#breadcumb_1').css('color', 'white');
   $('#breadcumb_2').css('color', 'white');
   $('#breadcumb_3').css('color', 'white');
   $('#breadcumb_4').css('color', 'white');
   $('#breadcumb_5').css('color', 'white');

   $('#breadcumb_4').css('color', 'gray');

   $('.colorbox').colorbox({
      width: 640,
      height: 480
   });
//--></script> 
   <%
      }
      //Validamos los metodos de pago
      if (strMod.equals("json8")) {
         String comment = request.getParameter("comment");
         String payment_method = request.getParameter("payment_method");
         String agree = request.getParameter("agree");
         boolean bolagree = false;
         if (agree == null) {
            bolagree = true;

         } else {
            if (!agree.equals("1")) {
               bolagree = true;

            }
         }
         //Respuesta de error
         JSONObject objJsonCte = new JSONObject();
         JSONObject objJsonCte3 = new JSONObject();
         if (bolagree) {
            objJsonCte3.put("warning", "Advertencia: Usted debe estar de acuerdo con the Terminos y Condiciones!");
            objJsonCte.put("error", objJsonCte3);
         } else {
            //Guardamos el metodo de pago y las notas
            String strLst = Sesiones.gerVarSession(request, "CarSell");
            JSONObject objJsonCarrito = new JSONObject(strLst);
            if (!strLst.equals("0")) {
               objJsonCarrito.remove("payment_method");
               objJsonCarrito.put("payment_method", payment_method);
               objJsonCarrito.remove("comment");
               objJsonCarrito.put("comment", comment);
               System.out.println(objJsonCarrito.toString());
               //Actualizamos el carrito
               Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());
            }

            objJsonCte.put("sucess", "");
         }
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(objJsonCte.toString());
      }
      //Guardamos el pedido y mostramos los metodos de pago para aplicar
      if (strMod.equals("json9")) {
         //Generamos el pedido
         int intNumPedido = GeneraPedidoCarrito(
                 oConn, varSesiones,
                 request,
                 webBase, dblFactorImpuesto);
         System.out.println("intNumPedido:" + intNumPedido);
   %>

<div>

   <div class="checkout-product">
      <table>
         <thead>
            <tr>
               <td class="name">Nombre del producto</td>
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
               double dblImpuesto = 0;
               double dblSubTotal = 0;
               if (!strLst.equals("0")) {


                  //Parseamos el objeto json
                  objJsonCarrito = new JSONObject(strLst);
                  jsonChild = objJsonCarrito.getJSONArray("carritoCompras");

                  //Obtenemos el resumen del carrito
                  for (int i = 0; i < jsonChild.length(); i++) {
                     JSONObject row = jsonChild.getJSONObject(i);
                     dblTotal += row.getDouble("Precio") * row.getInt("Cantidad");
                  }
                  //Calculamos el impuesto 
                  dblSubTotal = dblTotal / (1 + (dblFactorImpuesto / 100));
                  dblImpuesto = dblTotal - dblSubTotal;
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
                     strNombreImagen = "http://casajosefa.com/image/cache/" + strImg1.replace(".jpg", "-500x500.jpg");
            %>
            <tr>
               <td class="name"><a href="index.jsp?mod=ecomm_cat&cat_id=<%=row.getInt("ModeloId")%>"><%=row.getString("Modelo")%></a>
                  <br />
                  &nbsp;<small> - Colores: <%=row.getString("Color")%></small>
                  <br />
                  &nbsp;<small> - Tallas: <%=row.getString("Talla")%></small>
               </td>
               <td class="model"><%=row.getString("Codigo")%></td>
               <td class="quantity"><%=row.getInt("Cantidad")%></td>
               <td class="price">MX $<%=NumberString.FormatearDecimal(dblImporte, 2)%></td>
               <td class="total">MX $<%=NumberString.FormatearDecimal(dblImporte, 2)%></td>
            </tr>
            <%
                  }
               }
            %>
         </tbody>
         <tfoot>
            <tr>
               <td colspan="4" class="price"><b>Sub-Total:</b></td>
               <td class="total">MX <%=NumberString.FormatearDecimal(dblSubTotal, 2)%></td>
            </tr>
            <tr>
               <td colspan="4" class="price"><b>Impuesto:</b></td>
               <td class="total">MX $<%=NumberString.FormatearDecimal(dblImpuesto, 2)%></td>
            </tr>
            <tr>
               <td colspan="4" class="price"><b>Total:</b></td>
               <td class="total">MX <%=NumberString.FormatearDecimal(dblTotal, 2)%></td>
            </tr>
         </tfoot>
      </table>
   </div>
<!--Codigo seguimiento google analytics -->
<!-- Google Code for prospectos Conversion Page -->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 965683400;
var google_conversion_language = "es";
var google_conversion_format = "2";
var google_conversion_color = "ffffff";
var google_conversion_label = "bAnWCImO7FYQyNG8zAM";
var google_remarketing_only = false;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/965683400/?label=bAnWCImO7FYQyNG8zAM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>
<!--Codigo seguimiento google analytics -->
   <%
      //Guardamos el metodo de pago y las notas
      strLst = Sesiones.gerVarSession(request, "CarSell");
      objJsonCarrito = new JSONObject(strLst);
      if (!strLst.equals("0")) {

         if (objJsonCarrito.getString("payment_method").equals("bank_transfer")) {

            //Consultamos los datos del metodo de pago
            String strTexto = null;
            String strSqlEnvio = "select * from ecomm_payments where "
                    + " PAYMENT_ACTIVE = 1 AND PAYMENT_TYPE = 'bank_transfer' ";
            ResultSet rsDir = oConn.runQuery(strSqlEnvio, true);
            while (rsDir.next()) {
               strTexto = rsDir.getString("PAYMENT_MEMO");
            }
            rsDir.close();
   %>
   <div class="payment"><h2>Instrucciones para el deposito en efectivo en el banco</h2>
      <div class="content">
         <%=strTexto%>
      </div>
      <div class="buttons">
         <div class="right">
            <%if (!objJsonCarrito.getString("payment_method").equals("compro_pago")) {
            %>
            <input type="button" value="Confirmar Orden" id="button-confirm" class="button" />
            <%                  }
            %>

         </div>
      </div>
      <script type="text/javascript"><!--
      $('#button-confirm').bind('click', function() {
            $.ajax({
               type: 'get',
               url: 'modules/mod_ecomm/ecomm_eval_login.jsp?mod=json10&route=payment/bank_transfer/confirm',
               success: function() {
                  location = 'index.jsp?mod=ecomm_car_checkout_sucess';
               }
            });
         });
         //--></script> 
   </div>
   <%      }
      if (objJsonCarrito.getString("payment_method").equals("pp_standard")) {

         //Consultamos los datos del metodo de pago
         String strUrl = null;
         String strMail = null;
         String strCurrency = null;
         String strUrlSucess = null;
         String strUrlFailed = null;
         String strUrlNotify = null;
         String strSqlEnvio = "select * from ecomm_payments where "
                 + " PAYMENT_ACTIVE = 1 AND PAYMENT_TYPE = 'pp_standard' ";
         ResultSet rsDir = oConn.runQuery(strSqlEnvio, true);
         while (rsDir.next()) {
            strUrl = rsDir.getString("PAYMENT_POST_URL");
            strMail = rsDir.getString("PAYMENT_MAIL");
            strCurrency = rsDir.getString("PAYMENT_CURRENCY");
            strUrlSucess = webBase.getUrlSite() + "/" + rsDir.getString("PAYMENT_SUCESS_URL");
            strUrlFailed = webBase.getUrlSite() + "/" + rsDir.getString("PAYMENT_FAILED_URL");
            strUrlNotify = webBase.getUrlSite() + "/" + rsDir.getString("PAYMENT_NOTIFY_URL");
         }
         rsDir.close();
   %>
   <form method="post" action="<%=strUrl%>">
      <!--<form method="post" action="https://www.sandbox.paypal.com/cgi-bin/webscr">-->
      <input type="hidden" value="_cart" name="cmd">
      <input type="hidden" value="1" name="upload">
      <input type="hidden" value="<%=strMail%>" name="business">
      <!--<input type="hidden" value="zgalindo@siwebmx.com" name="business">-->
      <%
         //Listamos todo lo del carrito de compras
         strLst = Sesiones.gerVarSession(request, "CarSell");
         objJsonCarrito = new JSONObject();
         jsonChild = null;
         dblTotal = 0;
         if (!strLst.equals("0")) {


            //Parseamos el objeto json
            objJsonCarrito = new JSONObject(strLst);
            jsonChild = objJsonCarrito.getJSONArray("carritoCompras");

            //Obtenemos el resumen del carrito
            for (int i = 0; i < jsonChild.length(); i++) {
               JSONObject row = jsonChild.getJSONObject(i);
               dblTotal += row.getDouble("Precio") * row.getInt("Cantidad");
            }
            //Obtenemos el resumen del carrito
            for (int i = 0; i < jsonChild.length(); i++) {
               JSONObject row = jsonChild.getJSONObject(i);
               double dblImporte = row.getDouble("Precio") * row.getInt("Cantidad");
      %>
      <input type="hidden" value="<%=row.getString("Modelo")%>" name="item_name_1">
      <input type="hidden" value="<%=row.getString("Codigo")%>" name="item_number_1">
      <input type="hidden" value="<%=NumberString.FormatearDecimal(dblTotal, 2)%>" name="amount_1">
      <input type="hidden" value="<%=row.getInt("Cantidad")%>" name="quantity_1">
      <input type="hidden" value="0" name="weight_1">
      <input type="hidden" value="Colores" name="on0_1">
      <input type="hidden" value="<%=row.getString("Color")%>" name="os0_1">
      <input type="hidden" value="Tallas" name="on1_1">
      <input type="hidden" value="<%=row.getString("Talla")%>" name="os1_1">
      <%
            }
         }
         //Obtenemos datos del cliente
         String first_name = "";
         String last_name = "";
         String address1 = "";
         String address2 = "";
         String city = "";
         String zip = "";
         String mail = "";
         String invoice = "Pedido " + intNumPedido;
         varSesiones.getVars();
         //Obtenemos los datos de envio
         strSqlEnvio = "select * from vta_cliente_dir_entrega where CDE_ID = " + objJsonCarrito.getInt("address_id");
         rsDir = oConn.runQuery(strSqlEnvio, true);
         while (rsDir.next()) {

            address1 = rsDir.getString("CDE_CALLE") + " "
                    + rsDir.getString("CDE_NUMERO") + ""
                    + rsDir.getString("CDE_NUMINT") + "";
            address2 = rsDir.getString("CDE_COLONIA");
            city = rsDir.getString("CDE_ESTADO");
            zip = rsDir.getString("CDE_CP");
         }
         rs.close();
         strSqlEnvio = "select CT_RAZONSOCIAL,CT_EMAIL1 from vta_cliente where CT_ID = " + varSesiones.getIntNoUser();
         rsDir = oConn.runQuery(strSqlEnvio, true);
         while (rsDir.next()) {
            first_name = rsDir.getString("CT_RAZONSOCIAL");
            mail = rsDir.getString("CT_EMAIL1");
         }
         rs.close();

      %>
      <input type="hidden" value="Envío, manipulación, descuentos &amp; impuestos" name="item_name_2">
      <input type="hidden" value="" name="item_number_2">
      <input type="hidden" value="<%=NumberString.FormatearDecimal(dblImpuesto, 2)%>" name="amount_2">
      <input type="hidden" value="1" name="quantity_2">
      <input type="hidden" value="0" name="weight_2">
      <input type="hidden" value="<%=strCurrency%>" name="currency_code">

      <input type="hidden" value="<%=first_name%>" name="first_name">
      <input type="hidden" value="<%=last_name%>" name="last_name">
      <input type="hidden" value="<%=address1%>" name="address1">
      <input type="hidden" value="<%=address2%>" name="address2">
      <input type="hidden" value="<%=city%>" name="city">
      <input type="hidden" value="<%=zip%>" name="zip">
      <input type="hidden" value="MX" name="country">
      <input type="hidden" value="0" name="address_override">
      <input type="hidden" value="<%=mail%>" name="email">
      <input type="hidden" value="<%=invoice%>" name="invoice">
      <input type="hidden" value="es" name="lc">
      <input type="hidden" value="2" name="rm">
      <input type="hidden" value="1" name="no_note">
      <input type="hidden" value="utf-8" name="charset">
      <input type="hidden" value="<%=strUrlSucess%>" name="return">
      <input type="hidden" value="<%=strUrlNotify%>" name="notify_url">
      <input type="hidden" value="<%=strUrlFailed%>" name="cancel_return">
      <input type="hidden" value="sale" name="paymentaction">
      <input type="hidden" value="<%=intNumPedido%>" name="custom">
      <input type="hidden" value="SIWEB_WPS" name="bn">
      <div class="buttons">
         <div class="right">
            <input type="submit" class="type_button" value="Confirmar Orden">
         </div>
      </div>
   </form>
   <%         }
      //Compropago
      if (objJsonCarrito.getString("payment_method").equals("compro_pago")) {
         //Obtenemos datos del cliente
         String first_name = "";
         String last_name = "";
         String address1 = "";
         String address2 = "";
         String city = "";
         String zip = "";
         String mail = "";
         String invoice = "";
         String telefono1 = "";
         varSesiones.getVars();
         //Obtenemos los datos de envio
         String strSqlEnvio = "select * from vta_cliente_dir_entrega where CDE_ID = " + objJsonCarrito.getInt("address_id");
         ResultSet rsDir = oConn.runQuery(strSqlEnvio, true);
         while (rsDir.next()) {

            address1 = rsDir.getString("CDE_CALLE") + " "
                    + rsDir.getString("CDE_NUMERO") + ""
                    + rsDir.getString("CDE_NUMINT") + "";
            address2 = rsDir.getString("CDE_COLONIA");
            city = rsDir.getString("CDE_ESTADO");
            zip = rsDir.getString("CDE_CP");
         }
         rs.close();
         strSqlEnvio = "select CT_RAZONSOCIAL,CT_EMAIL1,CT_TELEFONO1 from vta_cliente where CT_ID = " + varSesiones.getIntNoUser();
         rsDir = oConn.runQuery(strSqlEnvio, true);
         while (rsDir.next()) {
            first_name = rsDir.getString("CT_RAZONSOCIAL");
            mail = rsDir.getString("CT_EMAIL1");
            telefono1 = rsDir.getString("CT_TELEFONO1");
         }
         rs.close();
         //Consultamos los datos del metodo de pago
         String strUrl = null;
         String strKey = null;
         String strCurrency = null;
         String strUrlSucess = null;
         String strUrlFailed = null;
         strSqlEnvio = "select * from ecomm_payments where "
                 + " PAYMENT_ACTIVE = 1 AND PAYMENT_TYPE = 'compro_pago' ";
         rsDir = oConn.runQuery(strSqlEnvio, true);
         while (rsDir.next()) {
            strUrl = rsDir.getString("PAYMENT_POST_URL");
            strKey = rsDir.getString("PAYMENT_HASH");
            strCurrency = rsDir.getString("PAYMENT_CURRENCY");
            strUrlSucess = webBase.getUrlSite() + "/" + rsDir.getString("PAYMENT_SUCESS_URL");
            strUrlFailed = webBase.getUrlSite() + "/" + rsDir.getString("PAYMENT_FAILED_URL");
         }
         rsDir.close();
   %>
   <div class="payment"><form action="<%=strUrl%>" method="post">
         <input type="hidden" name="public_key" value="<%=strKey%>">
         <input type="hidden" name="product_price" value="<%=dblTotal%>">
         <input type="hidden" name="product_name" value="Orden de Pago: <%=intNumPedido%>">
         <input type="hidden" name="product_id" value="<%=intNumPedido%>">
         <input type="hidden" name="customer_name" value="<%=first_name%>">
         <input type="hidden" name="customer_email" value="<%=mail%>">
         <input type="hidden" name="customer_phone" value="<%=telefono1%>">
         <input type="hidden" name="image_url" value="https://compropago.s3.amazonaws.com/button/image_url/1804/4__12_.jpg">
         <input type="hidden" name="success_url" value="<%=strUrlSucess%>">
         <input type="hidden" name="failed_url" value="<%=strUrlFailed%>">
         <input type="image" src="https://www.compropago.com/assets/payment-green-btn.png" border="0" name="submit" alt="Pagar con ComproPago">
      </form></div>
      <%
         }
         //Compropago
         if (objJsonCarrito.getString("payment_method").equals("banamex")) {
            Locale locale = new Locale("es", "MX"); // elegimos Mexico
            NumberFormat nf = NumberFormat.getCurrencyInstance(locale);
            //Consultamos los datos del metodo de pago
            String strUrl = null;
            String strKey = null;
            String strCurrency = null;
            String strUrlSucess = null;
            String strUrlFailed = null;
            String strMerchantId = null;
            String strAccessCode = null;
            String strSqlEnvio = "select * from ecomm_payments where "
                    + " PAYMENT_ACTIVE = 1 AND PAYMENT_TYPE = 'banamex' ";
            ResultSet rsDir = oConn.runQuery(strSqlEnvio, true);
            while (rsDir.next()) {
               strUrl = rsDir.getString("PAYMENT_POST_URL");
               strKey = rsDir.getString("PAYMENT_HASH");
               strCurrency = rsDir.getString("PAYMENT_CURRENCY");
               strMerchantId = rsDir.getString("PAYMENT_MERCHANTID");
               strAccessCode = rsDir.getString("PAYMENT_ACCESS_CODE");
               strUrlSucess = webBase.getUrlSite() + rsDir.getString("PAYMENT_SUCESS_URL");
            }
            rsDir.close();
      %>

   <form action="<%=strUrl%>" method="post" accept-charset="ISO-8859-1">
      <!-- get user input -->
      <input name="virtualPaymentClientURL" type="hidden" value="https://banamex.dialectpayments.com/vpcpay" />
      <input name="vpc_Version" type="hidden" value="1" />
      <input name="vpc_Command" type="hidden" value="pay" />
      <input name="vpc_AccessCode" type="hidden" value="<%=strAccessCode%>" />
      <input name="vpc_Merchant" type="hidden" value="<%=strMerchantId%>" />
      <input name="vpc_MerchTxnRef" type="hidden" value="<%=intNumPedido%>" />
      <input name="vpc_OrderInfo" type="hidden" value="Pedido <%=intNumPedido%>" />
      <input name="vpc_ReturnURL" type="hidden" value="<%=strUrlSucess%>" maxlength="250"/>

      <input name="vpc_Locale" type="hidden" value="es_MX" />
      <input name="vpc_Currency" type="hidden" value="<%=strCurrency%>" />

      <input type="hidden" name="vpc_CustomPaymentPlanPlanId" value="" size="20" maxlength="16">
      <input name="vpc_Amount" type="hidden" value="<%=NumberString.FormatearDecimal(dblTotal, 2).replace(".", "").replace(",", "")%>" maxlength="10"/>
      <table width="80%" align="center" border="0" cellpadding='0' cellspacing='0'>
         <tr>
            <td>&nbsp;</td>
            <td><input type="submit" class="button" NAME="SubButL" value="Realizar el pago!!!"></td>
         </tr>
      </table>
   </form>
   <%
         }
      }
   %>
</div>
<%
      //Limpiamos el carrito de compras anterior
      //Sesiones.SetSession(request, "CarSell", "0");
   }
   //Confirmamos la venta
   if (strMod.equals("json10")) {
      //Procedmos a guardar el pedido
      //Limpiamos el carrito de compras anterior
      //Sesiones.SetSession(request, "CarSell", "0");
      //Respuesta de error
      JSONObject objJsonCte = new JSONObject();
      JSONObject objJsonCte3 = new JSONObject();
      objJsonCte.put("sucess", "");
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
      out.println(objJsonCte.toString());
   }
   oConn.close();
%>


<%!
   //Genera el pedido del carrito de compra
   public int GeneraPedidoCarrito(
           Conexion oConn, VariableSession varSesiones,
           HttpServletRequest request,
           Site webBase, double dblFactorImpuesto) {
      String strResp = "OK";
      varSesiones.getVars();
      int intIdPedido = 0;

      //Recuperamos objeto json del carrito
      String strLst = Sesiones.gerVarSession(request, "CarSell");
      JSONObject objJsonCarrito = new JSONObject();
      JSONArray jsonChild = null;
      double dblTotal = 0;
      double dblImpuesto = 0;
      if (!strLst.equals("0")) {

         try {
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
            dblImpuesto = dblTotal - dblSubTotal;
            //COMIENZA GUARDADO DE PEDIDO

            //Inicializamos datos
            Fechas fecha = new Fechas();
            //Recuperamos paths de web.xml
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
            String strmod_Inventarios = this.getServletContext().getInitParameter("mod_Inventarios");
            String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
            String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
            String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
            if (strfolio_GLOBAL == null) {
               strfolio_GLOBAL = "SI";
            }
            if (strmod_Inventarios == null) {
               strmod_Inventarios = "NO";
            }
            if (strSist_Costos == null) {
               strSist_Costos = "0";
            }
            //Instanciamos el objeto que generara la venta
            Ticket ticket = new Ticket(oConn, varSesiones, request);
            ticket.setStrPATHKeys(strPathPrivateKeys);
            ticket.setStrPATHXml(strPathXML);
            ticket.setStrPATHFonts(strPathFonts);
            //Desactivamos inventarios
            if (strmod_Inventarios.equals("NO")) {
               ticket.setBolAfectaInv(false);
            }
            //Validamos si envian la peticion con la bandera de afectar inventarios
            if (request.getParameter("INV") != null) {
               if (request.getParameter("INV").equals("0")) {
                  ticket.setBolAfectaInv(false);
               }
            }
            //Definimos el sistema de costos
            try {
               ticket.setIntSistemaCostos(Integer.valueOf(strSist_Costos));
            } catch (NumberFormatException ex) {
               System.out.println("No hay sistema de costos definido");
            }
            //Recibimos parametros
            String strPrefijoMaster = "TKT";
            String strPrefijoDeta = "TKTD";
            String strTipoVtaNom = Ticket.TICKET;
            //Recuperamos el tipo de venta 1:FACTURA 2:TICKET 3:PEDIDO
            String strTipoVta = request.getParameter("TIPOVENTA");
            if (strTipoVta == null) {
               strTipoVta = "3";
            }
            if (strTipoVta.equals("1")) {
               strPrefijoMaster = "FAC";
               strPrefijoDeta = "FACD";
               strTipoVtaNom = Ticket.FACTURA;
               ticket.initMyPass(this.getServletContext());
            }
            if (strTipoVta.equals("3")) {
               strPrefijoMaster = "PD";
               strPrefijoDeta = "PDD";
               strTipoVtaNom = Ticket.PEDIDO;
            }
            ticket.setStrTipoVta(strTipoVtaNom);
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               ticket.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            } else {
               ticket.setIntEMP_ID(webBase.getIntEMP_ID());
            }
            //Validamos si usaremos un folio global
            if (strfolio_GLOBAL.equals("NO")) {
               ticket.setBolFolioGlobal(false);
            }
            System.out.println("varSesiones.getIntNoUser():" + varSesiones.getIntNoUser());
            ticket.getDocument().setFieldInt("SC_ID", webBase.getIntSC_ID());
            ticket.getDocument().setFieldInt("CT_ID", varSesiones.getIntNoUser());
            ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", webBase.getIntMON_ID());

            //Clave de vendedor
            int intVE_ID = 0;

            //Tarifas de IVA
            int intTI_ID = 1;
            int intTI_ID2 = 0;
            int intTI_ID3 = 0;


            //Asignamos los valores al objeto
            ticket.getDocument().setFieldInt("VE_ID", intVE_ID);
            ticket.getDocument().setFieldInt("TI_ID", intTI_ID);
            ticket.getDocument().setFieldInt("TI_ID2", intTI_ID2);
            ticket.getDocument().setFieldInt("TI_ID3", intTI_ID3);
            ticket.getDocument().setFieldInt(strPrefijoMaster + "_ESSERV", 0);
            ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.getFechaActual());
            ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", "");
            ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", objJsonCarrito.getString("comment"));
            ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", objJsonCarrito.getString("payment_method"));
            ticket.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", "");
            ticket.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", "");
            ticket.getDocument().setFieldString(strPrefijoMaster + "_METODODEPAGO", "");
            ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", "");

            ticket.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", "En una sola Exhibicion");
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", dblSubTotal);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", dblImpuesto);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", 0);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", 0);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", dblTotal);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", dblFactorImpuesto);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", 0);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", 0);

            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);

            //Validamos MLM
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_PUNTOS", dblTotal);
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_NEGOCIO", dblTotal);

            ticket.getDocument().setFieldInt("CDE_ID", objJsonCarrito.getInt("address_id"));

            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
            //Recibimos datos de los items o partidas
            //Obtenemos el resumen del carrito
            for (int i = 0; i < jsonChild.length(); i++) {
               JSONObject row = jsonChild.getJSONObject(i);
               double dblImporte = row.getDouble("Precio") * row.getInt("Cantidad");
               double dblImpuestoItem = dblImporte * (dblFactorImpuesto / 100);
               //
               TableMaster deta = null;
               deta = new vta_pedidosdeta();
               deta.setFieldInt("SC_ID", webBase.getIntSC_ID());
               deta.setFieldInt("PR_ID", row.getInt("ProducId"));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO1", 0);
               deta.setFieldInt(strPrefijoDeta + "_EXENTO2", 0);
               deta.setFieldInt(strPrefijoDeta + "_EXENTO3", 0);
               deta.setFieldInt(strPrefijoDeta + "_ESREGALO", 0);
               deta.setFieldString(strPrefijoDeta + "_CVE", row.getString("Codigo"));
               deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", row.getString("Descripcion"));
               deta.setFieldString(strPrefijoDeta + "_NOSERIE", "");
               deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", dblImporte);
               deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", row.getInt("Cantidad"));
               deta.setFieldDouble(strPrefijoDeta + "_TASAIVA1", dblFactorImpuesto);
               deta.setFieldDouble(strPrefijoDeta + "_TASAIVA2", 0);
               deta.setFieldDouble(strPrefijoDeta + "_TASAIVA3", 0);
               deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO1", dblImpuestoItem);
               deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO2", 0);
               deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO3", 0);
               deta.setFieldDouble(strPrefijoDeta + "_IMPORTEREAL", dblImporte);
               deta.setFieldDouble(strPrefijoDeta + "_PRECIO", row.getDouble("Precio"));
               deta.setFieldDouble(strPrefijoDeta + "_DESCUENTO", 0);
               deta.setFieldDouble(strPrefijoDeta + "_PORDESC", 0);
               deta.setFieldDouble(strPrefijoDeta + "_PRECREAL", row.getDouble("Precio"));


               deta.setFieldInt(strPrefijoDeta + "_PRECFIJO", 0);
               deta.setFieldInt(strPrefijoDeta + "_ESREGALO", 0);
               deta.setFieldString(strPrefijoDeta + "_COMENTARIO", "");
               //UNIDAD DE MEDIDA UNIDAD_MEDIDA
               deta.setFieldString(strPrefijoDeta + "_UNIDAD_MEDIDA", "PZA");

               //Validamos MLM
               deta.setFieldDouble(strPrefijoDeta + "_PUNTOS", row.getDouble("Precio"));
               deta.setFieldDouble(strPrefijoDeta + "_VNEGOCIO", row.getDouble("Precio"));
               deta.setFieldDouble(strPrefijoDeta + "_IMP_PUNTOS", dblImporte);
               deta.setFieldDouble(strPrefijoDeta + "_IMP_VNEGOCIO", dblImporte);
               deta.setFieldDouble(strPrefijoDeta + "_DESC_ORI", 0);
               deta.setFieldInt(strPrefijoDeta + "_DESC_PREC", 0);
               deta.setFieldInt(strPrefijoDeta + "_DESC_PUNTOS", 0);
               deta.setFieldInt(strPrefijoDeta + "_DESC_VNEGOCIO", 0);
               deta.setFieldInt(strPrefijoDeta + "_REGALO", 0);
               deta.setFieldInt(strPrefijoDeta + "_ID_PROMO", 0);

               ticket.AddDetalle(deta);
            }


            //Validamos si es un pedido que se esta editando para solo modificar el pedido anterior

            ticket.Init();
            //Generamos transaccion
            ticket.doTrx();
            String strRes = "";
            if (ticket.getStrResultLast().equals("OK")) {
               strRes = "OK." + ticket.getDocument().getValorKey();
            } else {
               strRes = ticket.getStrResultLast();
            }
            try {
               intIdPedido = Integer.valueOf(ticket.getDocument().getValorKey());
            } catch (NumberFormatException ex) {
            }
            //Envio del pedido por mail
            String strMailCte = getMail(varSesiones.getintIdCliente(), oConn);
            //Quitamos coma inicial...
            if (strMailCte.startsWith(",")) {
               strMailCte = strMailCte.substring(1, strMailCte.length());
            }
            System.out.println("Mail del cliente..." + strMailCte);
            if (!strMailCte.isEmpty()) {
               String strRespPdf = GeneraImpresionPDF(oConn, strPathXML,
                       "PEDIDO", ticket.getDocument().getFieldString("PD_FOLIO"), Integer.valueOf(ticket.getDocument().getValorKey()),
                       strPathFonts);
               System.out.println("strRespPdf" + strRespPdf);
               if (strRespPdf.equals("OK")) {
                  String strRespEnvio = GeneraMail(oConn, strMailCte, "",
                          ticket.getDocument().getFieldString("PD_FOLIO"),
                          strPathXML);
                  System.out.println("strRespEnvio:" + strRespEnvio);
               }
            }

         } catch (Exception ex) {
            System.out.println("Error al guardar " + ex.getMessage());
         }
      }


      return intIdPedido;
   }

   /**
    * Funciones
    */
   /**
    * Envia el mail al cliente
    *
    * @param strMailCte Es el mail del cliente
    * @param strMailCte2 Es el segundo mail del cliente
    * @param strFolio Es el folio
    * @param strPath Es el path donde se alojara temporalmente el pdf
    * @return Regresa OK si fue exitoso el envio del mail
    */
   protected String GeneraMail(Conexion oConn, String strMailCte, String strMailCte2,
           String strFolio,
           String strPath) {
      String strResp = "OK";
      //Nombre de archivo
      //Obtenemos datos del smtp
      String strsmtp_server = "";
      String strsmtp_user = "";
      String strsmtp_pass = "";
      String strsmtp_port = "";
      String strsmtp_usaTLS = "";
      String strsmtp_usaSTLS = "";
      //Buscamos los datos del SMTP
      String strSql = "select * from cuenta_contratada where ctam_id = 1";
      ResultSet rs;
      try {
         rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            strsmtp_server = rs.getString("smtp_server");
            strsmtp_user = rs.getString("smtp_user");
            strsmtp_pass = rs.getString("smtp_pass");
            strsmtp_port = rs.getString("smtp_port");
            strsmtp_usaTLS = rs.getString("smtp_usaTLS");
            strsmtp_usaSTLS = rs.getString("smtp_usaSTLS");
         }
         rs.close();
      } catch (SQLException ex) {
         System.out.println("cuenta contratada" + ex.getMessage());
      }
      //Obtenemos los textos para el envio del mail
      String strNomTemplate = "PEDIDO_WEB";
      String[] lstMail = getMailTemplate(oConn, strNomTemplate);

      /**
       * Si estan llenos todos los datos mandamos el mail
       */
      if (!strsmtp_server.equals("")
              && !strsmtp_user.equals("")
              && !strsmtp_pass.equals("")) {
         //armamos el mail
         Mail mail = new Mail();
         //Activamos envio de acuse de recibo
         mail.setBolAcuseRecibo(true);
         mail.getTemplate(strNomTemplate, oConn);
         //Obtenemos los usuarios a los que mandaremos el mail
         String strLstMail = "";
         //Validamos si el mail del cliente es valido
         if (mail.isEmail(strMailCte)) {
            strLstMail += "," + strMailCte;
         }
         if (mail.isEmail(strMailCte2)) {
            strLstMail += "," + strMailCte2;
         }
         if (strLstMail.startsWith(",")) {
            strLstMail = strLstMail.substring(1, strLstMail.length());
         }
         //Mandamos mail si hay usuarios
         if (!strLstMail.equals("")) {
            String strMsgMail = lstMail[1];
            strMsgMail = strMsgMail.replace("%folio%", strFolio);
            //Establecemos parametros
            /*mail.setUsuario(strsmtp_user);
             mail.setContrasenia(strsmtp_pass);
             mail.setHost(strsmtp_server);
             mail.setPuerto(strsmtp_port);

            if (strsmtp_usaTLS.equals("1")) {
             mail.setBolUsaTls(true);
             }
             if (strsmtp_usaSTLS.equals("1")) {
             mail.setBolUsaStartTls(true);
             }*/
            mail.setAsunto(lstMail[0].replace("%folio%", strFolio));
            mail.setDestino(strLstMail);
            mail.setMensaje(strMsgMail);
            //Adjuntamos XML y PDF
            mail.setFichero(strPath + "Pedido_web" + strFolio + ".pdf");

            boolean bol = mail.sendMail();
            if (!bol) {
               strResp = "Fallo el envio del Mail.";
            }
         }
      }
      return strResp;
   }

   /**
    * Obtenemos los valores del template para el mail
    *
    * @param strNom Es el nombre del template
    * @return Regresa un arreglo con los valores del template
    */
   public String[] getMailTemplate(Conexion oConn, String strNom) {
      String[] listValores = new String[2];
      String strSql = "select MT_ASUNTO,MT_CONTENIDO from mailtemplates where MT_ABRV ='" + strNom + "'";
      ResultSet rs;
      try {
         rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            listValores[0] = rs.getString("MT_ASUNTO");
            listValores[1] = rs.getString("MT_CONTENIDO");
         }
         rs.close();
      } catch (SQLException ex) {
         System.out.println("getTemplate" + ex.getMessage());
      }
      return listValores;
   }

   /**
    * Genera el formato de impresion en PDF
    *
    * @param strPath Es el path
    * @param intEMP_TIPOCOMP Es el tipo de comprobante
    * @param intEmpId Es el id de la empresa
    * @param strFAC_NOMFORMATO Es el nombre del formato
    * @return Regresa OK si se genero el formato
    */
   protected String GeneraImpresionPDF(Conexion oConn, String strPath,
           String strFAC_NOMFORMATO, String strFolio, int intTransaccion,
           String strPATHFonts) {
      String strResp = "OK";
      //Posicion inicial para el numero de pagina
      String strPosX = null;
      String strTitle = "";
      strTitle = "Factura ";

      try {
         Document document = new Document();
         PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(strPath + "Pedido_web" + strFolio + ".pdf"));
         //Objeto que dibuja el numero de paginas
         PDFEventPage pdfEvent = new PDFEventPage();
         pdfEvent.setStrTitleApp(strTitle);
         //Colocamos el numero donde comienza X por medio del parametro del web Xml por si necesitamos algun ajuste
         if (strPosX != null) {
            try {
               int intPosX = Integer.valueOf(strPosX);
               pdfEvent.setIntXPageNum(intPosX);
            } catch (NumberFormatException ex) {
            }
         } else {
            pdfEvent.setIntXPageNum(300);
            pdfEvent.setIntXPageNumRight(50);
            pdfEvent.setIntXPageTemplate(252.3f);
         }
         //Anexamos el evento
         writer.setPageEvent(pdfEvent);
         document.open();
         Formateador format = new Formateador();
         format.setIntTypeOut(Formateador.FILE);
         format.setStrPath(strPath);
         format.InitFormat(oConn, strFAC_NOMFORMATO);
         String strRes = format.DoFormat(oConn, intTransaccion);
         if (strRes.equals("OK")) {
            CIP_Formato fPDF = new CIP_Formato();
            fPDF.setDocument(document);
            fPDF.setWriter(writer);
            fPDF.setStrPathFonts(strPATHFonts);
            fPDF.EmiteFormato(format.getFmXML());
         } else {
            strResp = strRes;
         }
         document.close();
         writer.close();
      } catch (FileNotFoundException ex) {
         System.out.println(ex.getMessage());
         strResp = "ERROR:" + ex.getMessage();
      } catch (DocumentException ex) {
         System.out.println(ex.getMessage());
         strResp = "ERROR:" + ex.getMessage();
      }
      return strResp;
   }

   /**
    * Obtenemos el mail del cliente
    */
   public String getMail(int intIdUser, Conexion oConn) {
      String strMail = "";
      String strSql = "select CT_EMAIL1 from vta_cliente where CT_ID = " + intIdUser;
      try {
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            strMail = rs.getString("CT_EMAIL1");
         }
         rs.close();
      } catch (SQLException ex) {
         System.out.println("getMail:" + ex.getMessage());
      }
      return strMail;
   }
%>