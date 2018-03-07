
<%-- 
    Document   : ingresos
    Este jsp contiene la pantalla de captura de nuevos ingresos
    Created on : 16-abr-2013, 15:31:53
    Author     : aleph_79
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="ERP.Precios"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0) {

      //Recuperamos los nombres de los estados
      ArrayList<String> lstEstado = new ArrayList<String>();
      ArrayList<String> lstBancos = new ArrayList<String>();
      ArrayList<String> lstTipoIngreso = new ArrayList<String>();
      ArrayList<Integer> intTipoIngresoID = new ArrayList<Integer>();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();
      //Consultamos los estados
      String strSql = "select * from estadospais where PA_ID = 1";
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         lstEstado.add(rs.getString("ESP_NOMBRE"));
      }
      rs.close();

      //Consultamos los estados
      String strSqlBancos = "select * from vta_nombcos";
      rs = oConn.runQuery(strSqlBancos, true);
      while (rs.next()) {
         lstBancos.add(rs.getString("NB_DESCRIPCION"));
      }
      rs.close();

      //Consultamos los Tipo de Ingresos
      String strSqlTIngreso = "select * from vta_cliecat1 ";
      rs = oConn.runQuery(strSqlTIngreso, true);
      while (rs.next()) {
         intTipoIngresoID.add(rs.getInt("CC1_ID"));
         lstTipoIngreso.add(rs.getString("CC1_DESCRIPCION"));
      }
      rs.close();

      //precios
      Precios prec = new Precios();
      //Kits de ingreso
      StringBuilder strOpciones = new StringBuilder();
      strSql = "select PR_ID,PR_DESCRIPCION from vta_producto where PR_ESKITINC = 1";
      rs = oConn.runQuery(strSql, true);

      while (rs.next()) {
         double dblPrecio = 0;

         strSql = "select PR_ID,PP_PRECIO,PP_APDESC,PP_PTOSLEAL,PP_PTOSLEALCAM "
                 + ",PP_PRECIO_USD,PP_PUNTOS,PP_NEGOCIO,PP_PPUBLICO,PP_APDESC,PP_APDESCPTO,PP_APDESCNEGO,PP_PUTILIDAD "
                 + " from vta_prodprecios where PR_ID = " + rs.getInt("PR_ID") + " AND LP_ID= 1";
         ResultSet rs2;
         try {
            rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               dblPrecio = rs2.getDouble("PP_PRECIO");
            }
            rs2.close();
         } catch (SQLException ex) {
         }

         strOpciones.append("<option value='" + rs.getInt("PR_ID") + "'>" + rs.getString("PR_DESCRIPCION") + " $" + comSIWeb.Utilerias.NumberString.FormatearDecimal(dblPrecio, 2) + "</option>");
      }
      rs.close();
      oConn.close();
%>
<div class="well ">
   <h3 class="page-header">Nuevo distribuidor</h3>
   <form action="index.jsp?mod=ingresos_save" method="post"  id="login-form" class="form-inline">
      <div class="userdata">
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <span class="required">* Los campos marcados en rojo son obligatorios</span>
            </div>
         </div>



         <!--Nombre-->
         <div id="form-new-nombre" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Nombre"/>
                     <label for="modlgn-nombre" >Nombre:</label>
                  </span>
                  <input id="modlgn-nombre" type="text" name="nombre" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Nombre"/> <span class="required">*</span>
               </div>
            </div>
         </div>
         <!--Apellido Paterno-->
         <div id="form-new-apaterno" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Apellido Paterno"/>
                     <label for="modlgn-apaterno" >Apellido Paterno:</label>
                  </span>
                  <input id="modlgn-apaterno" type="text" name="apaterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Apellido Paterno"/><span class="required">*</span>
               </div>
            </div>
         </div>
         <!--Apellido Materno-->
         <div id="form-new-amaterno" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Apellido Materno"/>
                     <label for="modlgn-amaterno" >Apellido Materno:</label>
                  </span>
                  <input id="modlgn-amaterno" type="text" name="amaterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Apellido Materno"/><span class="required">*</span>
               </div>
            </div>
         </div>

         <!--Fecha de nacimiento-->
         <div id="form-new-nacimiento" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Fecha de nacimiento"/>
                     <label for="modlgn-nacimiento" >Fecha de nacimiento:</label>
                  </span>
                  <input id="modlgn-nacimiento" type="text" name="nacimiento" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Fecha de nacimiento"/><span class="required">*</span>
               </div>
            </div>
         </div>


         <!--Telefono 1-->
         <div id="form-new-telefono1" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="telefono1"/>
                     <label for="modlgn-telefono1" >Telefono casa(10 digitos):</label>
                  </span>
                  <input id="modlgn-telefono1" type="text" name="telefono1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono casa"/><span class="required">*</span>
               </div>
            </div>
         </div>
         <!--Telefono 2-->
         <div id="form-new-telefono2" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="telefono2"/>
                     <label for="modlgn-telefono2" >Telefono celular(10 digitos):</label>
                  </span>
                  <input id="modlgn-telefono2" type="text" name="telefono2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono celular"/><span class="required">*</span>
               </div>
            </div>
         </div>
         <!--Email 1-->
         <div id="form-new-email1" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="email1"/>
                     <label for="modlgn-email1" >Cuenta de correo electr&oacute;nico:</label>
                  </span>
                  <input id="modlgn-email1" type="text" name="email1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Cuenta de correo electr&oacute;nico"/><span class="required">*</span>
               </div>
            </div>
         </div>

         <!--Numero de cuenta de banco 1-->
         <div id="form-new-cuenta_bancaria1" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="cuenta_bancaria1"/>
                     <label for="modlgn-cuenta_bancaria1" >Cuenta Bancaria 1:</label>
                  </span>
                  <input id="modlgn-cuenta_bancaria1" type="text" name="cuenta_bancaria1" class="input-small" tabindex="0" size="20" maxlength="20" placeholder="Cuenta Bancaria 1"/><span class="required" > *</span>

                  <select id="dir_ent_banco1" name="dir_ent_banco1" class="combo1"  placeholder="Estado">
                     <option id="">Seleccione</option>
                     <%
                        //Mostramos los estados.
                        Iterator<String> it3 = lstBancos.iterator();
                        while (it3.hasNext()) {
                           String strBanco = it3.next();
                     %><option id="<%=strBanco%>"><%=strBanco%></option><%
                        }
                     %>
                  </select>


               </div>
            </div>
         </div>

         <div id="modlgn-estado1" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Estado"/>
                     <label for="modlgn-estado2" >Estado:</label> 
                  </span>


                  <select id="modlgn-estado" name="modlgn-estado" class="combo1"  placeholder="Estado"> 
                     <option id="">Seleccione</option> 
                     <%
                        //Mostramos los estados.
                        Iterator<String> it = lstEstado.iterator();
                        while (it.hasNext()) {
                           String strEstado = it.next();
                     %><option id="<%=strEstado%>"><%=strEstado%></option><%
                        }
                     %>
                  </select> <span class="required">*</span>


               </div>
            </div>
         </div>
         <!--Num de folio-->
         <div id="form-new-nombre" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Num de Folio"/>
                     <label for="modlgn-folio" >Num. de Folio:</label>
                  </span>
                  <input id="modlgn-folio" type="text" name="num de folio" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Num de Folio"/> <span class="required">*</span>
               </div>
            </div>
         </div>

         <div id="form-new-answer" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="answer"/>
                     <label for="modlgn-cuenta_answer" >&nbsp;</label>
                  </span>
                  <img alt="Captcha"  src="../stickyImg" /><input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
               </div>
            </div>
         </div>
         <br>
         <br>
         <!--Boton-->
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <button type="button" tabindex="0" name="Submit" onclick="EvaluaFormulario()" class="btn btn-primary btn" >Guardar</button>
            </div>
         </div>

      </div>
   </form>
</div>
<script type="text/javascript">
   $("#modlgn-nacimiento").datepicker({
      changeMonth: true,
      changeYear: true
   });
   var strbandera = "false";
   function EvaluaFormulario() {
      if (document.getElementById("modlgn-nombre").value == "") {
         alert("Es necesario que capture el nombre");
         document.getElementById("modlgn-nombre").focus();
         return false;
      }
      if (document.getElementById("modlgn-apaterno").value == "") {
         alert("Es necesario que capture el apellido paterno");
         document.getElementById("modlgn-apaterno").focus();
         return false;
      }
      if (document.getElementById("modlgn-amaterno").value == "") {
         alert("Es necesario que capture el apellido materno");
         document.getElementById("modlgn-amaterno").focus();
         return false;
      }

      if (document.getElementById("modlgn-nacimiento").value == "") {
         alert("Es necesario que capture la fecha de nacimiento");
         document.getElementById("modlgn-nacimiento").focus();
         return false;
      }

      if (document.getElementById("modlgn-telefono1").value == "") {
         alert("Es necesario que capture el telefono de casa");
         document.getElementById("modlgn-telefono1").focus();
         return false;
      }
      if (document.getElementById("modlgn-telefono2").value == "") {
         alert("Es necesario que capture el telefono celular");
         document.getElementById("modlgn-telefono2").focus();
         return false;
      }
      //Expresiones regulares
      //Email 1
      if (document.getElementById("modlgn-email1").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("modlgn-email1").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
         if (!bolExpReg) {
            alert("El formato del mail es incorrecto");
            document.getElementById("modlgn-email1").focus();
            return false;
         }
      }
      //Fecha de nacimiento
      if (document.getElementById("modlgn-nacimiento").value != "") {
         var bolExpReg = validateMXDate(document.getElementById("modlgn-nacimiento").value);
         if (!bolExpReg) {
            alert("El formato de la fecha de nacimiento es incorrecto");
            document.getElementById("modlgn-nacimiento").focus();
            return false;
         }
      }
      //Telefono
      if (document.getElementById("modlgn-telefono1").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("modlgn-telefono1").value, "^[0-9]{10}$");
         if (!bolExpReg) {
            alert("El formato del numero de telefono es incorrecto");
            document.getElementById("modlgn-telefono1").focus();
            return false;
         }
      }
      //Telefono
      if (document.getElementById("modlgn-telefono2").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("modlgn-telefono2").value, "^[0-9]{10}$");
         if (!bolExpReg) {
            alert("El formato del numero de telefono es incorrecto");
            document.getElementById("modlgn-telefono2").focus();
            return false;
         }
      }
      if (document.getElementById("modlgn-email1").value == "") {
         alert("Es necesario que capture el email");
         document.getElementById("modlgn-email1").focus();
         return false;
      }

      var combo = document.getElementById("modlgn-estado");
      var selected = combo.options[combo.selectedIndex].text;
      if (selected == "Seleccione") {
         alert("Es necesario que capture el estado");
         document.getElementById("modlgn-estado").focus();
         return false;
      }



      if (document.getElementById("modlgn-folio").value == "") {
         alert("Es necesario que capture su número de folio");
         document.getElementById("modlgn-folio").focus();
         return false;
      }
      
      if (document.getElementById("modlgn-cuenta_bancaria1").value == "") {
         alert("Es necesario que capture su cuenta bancaria");
         document.getElementById("modlgn-cuenta_bancaria1").focus();
         return false;
      } else {
         checkcuentabancaria();
      }
   }

   function checkcuentabancaria() {
      $("#dialogWait").dialog('open');

      var strPOST = "CODIGO=" + document.getElementById("modlgn-cuenta_bancaria1").value;
      $.ajax({
         type: "POST",
         data: strPOST,
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "xml",
         url: "modules/mod_prosperidad/valida_codigo_1.jsp?ID=1",
         success: function(datos) {
            var lstXml = datos.getElementsByTagName("respuesta")[0];
            var lstprecio = lstXml.getElementsByTagName("respuesta_deta");
            for (var i = 0; i < lstprecio.length; i++) {
               var obj = lstprecio[i];
               if (obj.getAttribute("respuesta") == "true") {
                  alert("La cuenta bancaria ya esta registrada");
                  document.getElementById("modlgn-cuenta_bancaria1").focus();
               } else {
                  document.getElementById("login-form").submit();
               }
            }
            $("#dialogWait").dialog('close');
         },
         error: function(objeto, quepaso, otroobj) {
            alert("Error: Al cargar comprobar codigo:" + objeto + " " + quepaso + " " + otroobj);
         }
      });
   }





   /*Copia los datos de facturacion*/
   function copyDireccion() {

      if (document.getElementById("copia").checked == true) {
         document.getElementById("dir_ent_nombre").value = document.getElementById("modlgn-nombre").value;
         document.getElementById("dir_ent_telefono").value = document.getElementById("modlgn-telefono1").value;
         document.getElementById("dir_ent_email").value = document.getElementById("modlgn-email1").value;
         document.getElementById("dir_ent_calle").value = document.getElementById("modlgn-calle").value;
         document.getElementById("dir_ent_numero").value = document.getElementById("modlgn-numero").value;
         document.getElementById("dir_ent_numeroInterno").value = document.getElementById("modlgn-numeroInterno").value;
         document.getElementById("dir_ent_colonia").value = document.getElementById("modlgn-colonia").value;
         document.getElementById("dir_ent_estado").value = document.getElementById("modlgn-estado").value;
         document.getElementById("dir_ent_mun").value = document.getElementById("modlgn-municipio").value;
         //document.getElementById("dir_ent_cp").value = document.getElementById("modlgn-cp").value;

      } else {
         document.getElementById("dir_ent_nombre").value = "";
         document.getElementById("dir_ent_telefono").value = "";
         document.getElementById("dir_ent_calle").value = "";
         document.getElementById("dir_ent_numero").value = "";
         document.getElementById("dir_ent_numeroInterno").value = "";
         document.getElementById("dir_ent_colonia").value = "";
         document.getElementById("dir_ent_estado").value = "";
         document.getElementById("dir_ent_mun").value = "";
         //document.getElementById("dir_ent_cp").value = "";
         document.getElementById("dir_ent_email").value = "";

      }






   }


   /*Valida los campos de direccion de entrega*/
   function validaDireccionEntrega() {

      if (document.getElementById("dir_ent_nombre").value == "") {
         alert("Es necesario que capture el nombre");
         document.getElementById("dir_ent_nombre").focus();
         return false;
      }

      //Telefono
      if (document.getElementById("dir_ent_telefono").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("dir_ent_telefono").value, "^[0-9]{10}$");
         if (!bolExpReg) {
            alert("El formato del numero de telefono es incorrecto");
            document.getElementById("dir_ent_telefono").focus();
            return false;
         }
      } else {
         alert("Captura un Numero de Telefono");
         document.getElementById("dir_ent_telefono").focus();
         return false;

      }

      if (document.getElementById("dir_ent_calle").value == "") {
         alert("Es necesario que capture una calle");
         document.getElementById("dir_ent_calle").focus();
         return false;
      }

      if (document.getElementById("dir_ent_numero").value == "") {
         alert("Es necesario que capture un numero o s/n.");
         document.getElementById("dir_ent_numero").focus();
         return false;
      }

      if (document.getElementById("dir_ent_colonia").value == "") {
         alert("Es necesario que capture una colonia.");
         document.getElementById("dir_ent_colonia").focus();
         return false;
      }

      if (document.getElementById("dir_ent_estado").value == "") {
         alert("Es necesario que seleccione un estado.");
         document.getElementById("dir_ent_estado").focus();
         return false;
      }

      if (document.getElementById("dir_ent_mun").value == "") {
         alert("Es necesario que capture un municipio.");
         document.getElementById("dir_ent_mun").focus();
         return false;
      }


      /*if (document.getElementById("texto").value == "") {
       alert("Capture alguna referencia");
       document.getElementById("Texto").focus();
       return false;
       }*/

   }

   //Valida un cadena conforme una expresion regular
   function _EvalExpReg(YourValue, YourExp)
   {
      var Template = new RegExp(YourExp)
      return (Template.test(YourValue)) ? 1 : 0 //Compara "YourAlphaNumeric" con el formato "Template" y si coincidevuelve verdadero si no devuelve falso
   }

   function validateMXDate(strValue) {
      /************************************************
       DESCRIPTION: Validates that a string contains only
       valid dates with 2 digit month, 2 digit day,
       4 digit year. Date separator can be ., -, or /.
       Uses combination of regular expressions and
       string parsing to validate date.
       Ex. mm/dd/yyyy or mm-dd-yyyy or mm.dd.yyyy
       
       PARAMETERS:
       strValue - String to be tested for validity
       
       RETURNS:
       True if valid, otherwise false.
       
       REMARKS:
       Avoids some of the limitations of the Date.parse()
       method such as the date separator character.
       *************************************************/
      var objRegExp = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/

      //check to see if in correct format
      if (!objRegExp.test(strValue))
         return false; //doesn't match pattern, bad date
      else {
         var strSeparator = strValue.substring(2, 3)
         var arrayDate = strValue.split(strSeparator);
         //create a lookup for months not equal to Feb.
         var arrayLookup = {'01': 31, '03': 31,
            '04': 30, '05': 31,
            '06': 30, '07': 31,
            '08': 31, '09': 30,
            '10': 31, '11': 30, '12': 31}
         var intDay = parseInt(arrayDate[0], 10);

         //check if month value and day value agree
         if (arrayLookup[arrayDate[1]] != null) {
            if (intDay <= arrayLookup[arrayDate[1]] && intDay != 0)
               return true; //found in lookup table, good date
         }

         //check for February (bugfix 20050322)
         //bugfix  for parseInt kevin
         //bugfix  biss year  O.Jp Voutat
         var intMonth = parseInt(arrayDate[1], 10);
         if (intMonth == 2) {
            var intYear = parseInt(arrayDate[2]);
            if (intDay > 0 && intDay < 29) {
               return true;
            }
            else if (intDay == 29) {
               if ((intYear % 4 == 0) && (intYear % 100 != 0) ||
                       (intYear % 400 == 0)) {
                  // year div by 4 and ((not div by 100) or div by 400) ->ok
                  return true;
               }
            }
         }
      }
      return false; //any other values, bad date
   }


   /*PASA LO QUE ESCRIBES EN TEXTAREA A UN HIDDEN PARA VALIDARLO*/
   function pasaValor() {

      document.getElementById("texto").value = document.getElementById("Texto").value.trim();
   }



</script>

<%         }
%>
