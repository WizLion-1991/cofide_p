<%@page import="Tablas.vta_cliente_dir_entrega"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.generateData"%>
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

   //Recuperamos parametros
   String firstname = request.getParameter("firstname");
   String lastname = request.getParameter("lastname");
   String email = request.getParameter("email");
   String fecha_nacimiento = request.getParameter("fecha_nacimiento");
   String password = request.getParameter("password");
   String confirm = request.getParameter("confirm");
   String telefono = request.getParameter("telefono");
   if (telefono == null) {
      telefono = "";
   }
   String ife = request.getParameter("ife");
   if (ife == null) {
      ife = "";
   }
   String referrer = request.getParameter("referrer");
   if (referrer == null) {
      referrer = "0";
   }
   String newsletter = request.getParameter("newsletter");
   if (newsletter == null) {
      newsletter = "0";
   }
   String agree = request.getParameter("agree");
   if (agree == null) {
      agree = "0";
   }
   String calle = request.getParameter("calle");
   if (calle == null) {
      calle = "";
   }
   String numero = request.getParameter("numero");
   if (numero == null) {
      numero = "";
   }
   String numero_int = request.getParameter("numero_int");
   if (numero_int == null) {
      numero_int = "";
   }
   String colonia = request.getParameter("colonia");
   if (colonia == null) {
      colonia = "";
   }
   String cp = request.getParameter("cp");
   if (cp == null) {
      cp = "";
   }
   String country_id = request.getParameter("country_id");
   if (country_id == null) {
      country_id = "";
   }
   String estado = request.getParameter("estado");
   if (estado == null) {
      estado = "";
   }
   String municipio = request.getParameter("municipio");
   if (municipio == null) {
      municipio = "";
   }


   //Mensajes de error
   String firstnameError = "";
   String lastnameError = "";
   String emailError = "";
   String fecha_nacimientoError = "";
   String passwordError = "";
   String confirmError = "";
   String telefonoError = "";
   String referrerError = "";
   String agreeError = "";
   String calleError = "";
   String numeroError = "";
   String coloniaError = "";
   String cpError = "";
   String estadoError = "";
   String municipioError = "";
   String ifeError = "";
   int idCt = 0;

   //Evaluamos si enviaron la peticion para guardar
   boolean boolGuardar = false;
   boolean boolGuardoOK = false;
   boolean boolValidacionOK = true;
   if (request.getParameter("Guardar") != null) {
      if (request.getParameter("Guardar").equals("1")) {
         boolGuardar = true;
      }
   }

   //Validamos los campos
   if (firstname.isEmpty()) {
      boolValidacionOK = false;
      firstnameError = "El nombre debe tener entre 1 y 32 carácteres!";
   }
   if (lastname.isEmpty()) {
      boolValidacionOK = false;
      lastnameError = "El apellido/s debe tener entre 1 y 32 carácteres!";
   }
   if (email.isEmpty()) {
      boolValidacionOK = false;
      emailError = "La dirección de email no parece ser válida!";
   }
   if (fecha_nacimiento.isEmpty()) {
      boolValidacionOK = false;
      fecha_nacimientoError = "Debe ingresar una fecha de nacimiento valida";
   }
   if (password.isEmpty()) {
      boolValidacionOK = false;
      passwordError = "La contraseña debe tener entre 4 y 20 carácteres!";
   }
   if (confirm.isEmpty()) {
      boolValidacionOK = false;
      confirmError = "No coincide el password";
   }
   if (telefono.isEmpty()) {
      boolValidacionOK = false;
      telefonoError = "Es necesario un numero telefonico valido";
   }
   if (!referrer.isEmpty()) {

      try {
         int intreferrer = Integer.valueOf(referrer);
      } catch (NumberFormatException ex) {
         boolValidacionOK = false;
         referrerError = "Es id de referido es un valor numerico";
      }

   }
   if (agree.equals("0")) {
      boolValidacionOK = false;
      agreeError = "Cuidado: Debes aceptar las Politicas de Privacidad!";
   }
   if (calle.isEmpty()) {
      boolValidacionOK = false;
      calleError = "Es necesario indicar la calle";
   }
   if (numero.isEmpty()) {
      boolValidacionOK = false;
      numeroError = "Es necesario indicar el numero";
   }
   if (colonia.isEmpty()) {
      boolValidacionOK = false;
      coloniaError = "Es necesario indicar la colonia";
   }
   if (cp.isEmpty()) {
      boolValidacionOK = false;
      cpError = "Es necesario indicar el código postal";
   }
   if (estado.isEmpty()) {
      boolValidacionOK = false;
      estadoError = "Es necesario indicar el estado";
   }
   if (municipio.isEmpty()) {
      boolValidacionOK = false;
      municipioError = "Es necesario indicar el municipio";
   }

   //Evaluamos si enviaron el formulario para guardar e intentamos hacerlo
   if (boolGuardar && boolValidacionOK) {
      //Procedemos a guardar la información del cliente nuevo...
      //Obtenemos parametros generales de la pagina a mostrar
      Site webBase = new Site(oConn);

      //Para manejo de fechas
      Fechas fecha = new Fechas();
      Periodos periodo = new Periodos();
      int intreferrer = 0;
      try {
         intreferrer = Integer.valueOf(referrer);
      } catch (NumberFormatException ex) {
         boolValidacionOK = false;
         referrerError = "Es id de referido es un valor numerico";
      }
      if (intreferrer == 0) {
         intreferrer = 1;
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
      objTabla.setFieldString("CT_CRED_ELECTOR", ife);
      objTabla.setFieldString("CT_CALLE", calle);
      objTabla.setFieldString("CT_NUMERO", numero);
      objTabla.setFieldString("CT_NUMINT", numero_int);
      objTabla.setFieldString("CT_COLONIA", colonia);
      objTabla.setFieldString("CT_MUNICIPIO", municipio);
      objTabla.setFieldString("CT_LOCALIDAD", "");
      objTabla.setFieldString("CT_ESTADO", estado);
      objTabla.setFieldString("CT_CP", cp);
      objTabla.setFieldString("CT_TELEFONO1", telefono);
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
      objTabla.setFieldString("CT_FECHA_NAC", fecha.FormateaBD(fecha_nacimiento, "/"));
      objTabla.setFieldString("CT_NOTAS", "");
      /**
       * Generamos un password aleatorio
       */
      objTabla.setFieldString("CT_PASSWORD", password);

      //Generamos una alta
      String strResult = objTabla.Agrega(oConn);
      String strKey = objTabla.getValorKey();
      if (strResult.equals("OK")) {

         if (!strKey.equals("") || strKey != null) {
            idCt = Integer.parseInt(strKey);
         }
         //Direccion de entrega
         vta_cliente_dir_entrega dirEnt = new vta_cliente_dir_entrega();
         if (strResult.equals("OK")) {
            dirEnt.setFieldString("CDE_NOMBRE", firstname + " " + lastname);
            dirEnt.setFieldString("CDE_TELEFONO1", telefono);
            dirEnt.setFieldString("CDE_EMAIL", email);
            dirEnt.setFieldString("CDE_CALLE", calle);
            dirEnt.setFieldString("CDE_NUMERO", numero);
            dirEnt.setFieldString("CDE_NUMINT", numero_int);
            dirEnt.setFieldString("CDE_COLONIA", colonia);
            dirEnt.setFieldString("CDE_ESTADO", estado);
            dirEnt.setFieldString("CDE_MUNICIPIO", municipio);
            dirEnt.setFieldString("CDE_CP", cp);
            dirEnt.setFieldString("CDE_LOCALIDAD", "MEXICO");
            dirEnt.setFieldString("CDE_DESCRIPCION", "");
            dirEnt.setFieldInt("EMP_ID", webBase.getIntEMP_ID());
            dirEnt.setFieldInt("CT_ID", idCt);

            String strResEntrega = dirEnt.Agrega(oConn);
         }

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

         boolGuardoOK = true;
      }
   }
   //Evaluamos si mostramos despliegue de guardado o los datos por capturar
   if (boolGuardoOK) {
%>

<div class="content">
   <h1>TU CUENTA HA SIDO CREADA</h1>
   <h4>TU ID DE CLIENTE ES <%=idCt%></h4>
   <p>
      Enhorabuena! Tu nueva cuenta ha sido creada satisfactoriamente!!!
   </p>
   <p>
      Ahora puedes beneficiarte de los privilegios de los miembros que aumentan tu experiencia de usuario.
   </p><p>
      Si tienes alguna duda de la operación de esta tienda online, por favor escríbenos un mail.
   </p><p>
      Un mensaje de confirmación ha sido enviada al correo proporcionado. Si no lo has recibido en una hora, por favor contáctanos.
   </p>
   <a href="index.jsp" class="button">Continuar</a>
</div>
<%      } else {
%>
<form action="index.jsp?mod=NewIng" method="post"  id="login-form" class="form-inline">
   <div class="content">
      <%if (!agreeError.isEmpty()) {%><div class="warning"><%=agreeError%></div><%}%>
      boolGuardoOK:<%=boolGuardoOK%>

      <input type="hidden" name="Guardar" value="1">
      <table class="form">
         <tr>
            <td><span class="required">*</span> Nombre:</td>
            <td><input type="text" name="firstname" value="<%=firstname%>" />
               <span class="error"><%if (!firstnameError.isEmpty()) {
                     out.println(firstnameError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td><span class="required">*</span> Apellido/s:</td>
            <td><input type="text" name="lastname" value="<%=lastname%>" />
               <span class="error"><%if (!lastnameError.isEmpty()) {
                     out.println(lastnameError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td><span class="required">*</span> E-Mail:</td>
            <td><input type="text" name="email" value="<%=email%>" />
               <span class="error"><%if (!emailError.isEmpty()) {
                     out.println(emailError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td><span class="required">*</span> Fecha de Nacimiento:</td>
            <td><input id='fecha_nacimiento' type="text" name="fecha_nacimiento" value="<%=fecha_nacimiento%>" />
               <span class="error"><%if (!fecha_nacimientoError.isEmpty()) {
                     out.println(fecha_nacimientoError);
                  }%></span>
            </td>
         </tr>

         <tr>
            <td><span class="required">*</span>Telefono:</td>
            <td><input type="text" name="telefono" value="<%=telefono%>" />
               <span class="error"><%if (!telefonoError.isEmpty()) {
                     out.println(telefonoError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td>
               ID Referido:
            </td>
            <td>
               <input type="text" name="referrer" value="<%=referrer%>" />
               <span class="error"><%if (!referrerError.isEmpty()) {
                     out.println(referrerError);
                  }%></span>
            </td>
            </td>
         </tr>
      </table>
   </div>
   <h2>Tu dirección</h2>
   <div class="content">
      <table class="form">  
         <tr>
            <td><span class="required">*</span> Calle:</td>
            <td><input type="text" name="calle" value="<%=calle%>" />
               <span class="error"><%if (!calleError.isEmpty()) {
                     out.println(calleError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td><span class="required">*</span> Numero:</td>
            <td><input type="text" name="numero" value="<%=numero%>" />
               <span class="error"><%if (!numeroError.isEmpty()) {
                     out.println(numeroError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td> Numero interior:</td>
            <td><input type="text" name="numero_int" value="<%=numero_int%>" /></td>
         </tr>
         <tr>
            <td><span id="cp-required" class="required">*</span> Colonia:</td>
            <td><input type="text" name="colonia" value="<%=colonia%>" />
               <span class="error"><%if (!coloniaError.isEmpty()) {
                     out.println(coloniaError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td><span id="cp-required" class="required">*</span> Código postal:</td>
            <td><input type="text" name="cp" value="<%=cp%>" />
               <span class="error"><%if (!cpError.isEmpty()) {
                     out.println(cpError);
                  }%></span>
            </td>
         </tr>
         <tr>		
            <td><span class="required">*</span> País:</td>
            <td><select name="country_id" >
                  <option value="138" selected="selected">Mexico</option>
               </select>
            </td>
         </tr>
         <tr>
            <td><span class="required">*</span> Estado:</td>
            <td><select name="estado">
                  <option id="">Seleccione</option>
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
               </select>
               <span class="error"><%if (!estadoError.isEmpty()) {
                     out.println(estadoError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td><span class="required">*</span> Municipio:</td>
            <td><input type="text" name="municipio" value="<%=municipio%>" />
               <span class="error"><%if (!municipioError.isEmpty()) {
                     out.println(municipioError);
                  }%></span>
            </td>
         </tr>

      </table>
   </div>
   <h2>Tu contraseña</h2>
   <div class="content">
      <table class="form">
         <tr>
            <td><span class="required">*</span> Contraseña:</td>
            <td><input type="password" name="password" value="<%=password%>" />
               <span class="error"><%if (!passwordError.isEmpty()) {
                     out.println(passwordError);
                  }%></span>
            </td>
         </tr>
         <tr>
            <td><span class="required">*</span> Confirma contraseña:</td>
            <td><input type="password" name="confirm" value="<%=confirm%>" />
               <span class="error"><%if (!confirmError.isEmpty()) {
                     out.println(confirmError);
                  }%></span>
            </td>
         </tr>
      </table>
   </div>
   <h2>Boletín de noticias</h2>
   <div class="content">
      <table class="form">
         <tr>
            <td>Suscripción:</td>
            <td>            <input type="radio" name="newsletter" value="1" />
               Si            <input type="radio" name="newsletter" value="0" checked="checked" />
               No            </td>
         </tr>
      </table>
   </div>
   <div class="buttons">
      <div class="right">He leido y acepto las <a class="thickbox" 
                                                  href="http://casajosefa.com/index.php?route=information/information/info&amp;information_id=3" alt="Politicas de Privacidad">
            <b>Politicas de Privacidad</b></a>                
         <input type="checkbox" name="agree" value="1" <%if (agreeError.equals("1")) {
               out.println("checked");
            }%>  />
         <input type="submit" value="Continuar" class="button" />
      </div>
   </div>
</form>

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script type="text/javascript"><!--

   $(function() {
      $("#datepicker").datepicker();
   });

   $('input[name=\'customer_group_id\']:checked').live('change', function() {
      var customer_group = [];

      customer_group[1] = [];
      customer_group[1]['company_id_display'] = '1';
      customer_group[1]['company_id_required'] = '0';
      customer_group[1]['tax_id_display'] = '0';
      customer_group[1]['tax_id_required'] = '1';


      if (customer_group[this.value]) {
         if (customer_group[this.value]['company_id_display'] == '1') {
            $('#company-id-display').show();
         } else {
            $('#company-id-display').hide();
         }

         if (customer_group[this.value]['company_id_required'] == '1') {
            $('#company-id-required').show();
         } else {
            $('#company-id-required').hide();
         }

         if (customer_group[this.value]['tax_id_display'] == '1') {
            $('#tax-id-display').show();
         } else {
            $('#tax-id-display').hide();
         }

         if (customer_group[this.value]['tax_id_required'] == '1') {
            $('#tax-id-required').show();
         } else {
            $('#tax-id-required').hide();
         }
      }
   });

   $('input[name=\'customer_group_id\']:checked').trigger('change');
   //--></script> 

<script type="text/javascript"><!--
   $(document).ready(function() {
      $('.colorbox').colorbox({
         width: 640,
         height: 480
      });

      $("#fecha_nacimiento").datepicker({
         dateFormat: 'dd/mm/yy',
         maxDate: "0",
      });
   });
   //--></script> 

<%         }
%>


<%
   oConn.close();
%>