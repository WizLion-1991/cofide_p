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
               dblPrecio = dblPrecio ;
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

    <form action="index.jsp?mod=ingresos_save" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
        <div class="userdata">
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <span class="required">* Los campos marcados en rojo son obligatorios</span>
                </div>
            </div>



            <!--Nombre-->
            <div id="form-new-nombre" class="control-group">
                <div class="controls">

                    <table cellpadding="4" cellspacing="1" border="0" style="background-color: #739dd3;">
                        <tr>
                            <td>&nbsp;<label for="modlgn-nombre">Nombre:</label></td>
                            <td>&nbsp;<input id="modlgn-nombre" type="text" name="nombre" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Nombre"/> <span class="required">*</span></td>
                        </tr>
                        <tr>
                            <td>&nbsp;<label for="modlgn-apaterno">Apellido Paterno:</label></td>
                            <td>&nbsp;<input id="modlgn-apaterno" type="text" name="apaterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Apellido Paterno"/><span class="required">*</span></td>
                        </tr>
                        <tr>
                            <td>&nbsp;<label for="modlgn-amaterno">Apellido Materno:</label></td>
                            <td>&nbsp;<input id="modlgn-amaterno" type="text" name="amaterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Apellido Materno"/><span class="required">*</span></td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-nacimiento">Fecha de nacimiento:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-nacimiento" type="text" name="nacimiento" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Fecha de nacimiento"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-rfc">Registro Federal de Contribuyentes:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-rfc" type="text" name="rfc" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Registro Federal de Contribuyentes" value="XAXX010101000"  /><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-calle">Calle:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-calle" type="text" name="calle" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Calle"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-numero">Numero:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-numero" type="text" name="numero" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Numero"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-numeroInterno">Numero Interno:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-numeroInterno" type="text" name="numeroInterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Numero Interno"/>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-colonia">Colonia:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-colonia" type="text" name="colonia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Colonia"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-municipio">Municipio:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-municipio" type="text" name="municipio" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Municipio"/><span class="required">*</span>
                            </td>
                        </tr>

                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-estado">Estado:</label>
                            </td>
                            <td>&nbsp;
                                <select id="modlgn-estado" name="estado" class="combo1"  placeholder="Estado">
                                    <option id="">Seleccione</option>
                                    <%
                                        //Mostramos los estados.
                                        Iterator<String> it = lstEstado.iterator();
                                        while (it.hasNext()) {
                                            String strEstado = it.next();
                                    %><option id="<%=strEstado%>"><%=strEstado%></option><%
                                        }
                                    %>
                                </select>
                                <span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-cp">C&oacute;digo Postal:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-cp" type="text" name="cp" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="C&oacute;digo Postal"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-telefono1">Telefono casa(10 digitos):</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-telefono1" type="text" name="telefono1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono casa"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-telefono2">Telefono celular(10 digitos):</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-telefono2" type="text" name="telefono2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono celular"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-email1">Cuenta de correo electr&oacute;nico:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-email1" type="text" name="email1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Cuenta de correo electr&oacute;nico"/><span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-email2">Verifique cuenta de correo electr&oacute;nico:</label>
                            </td>
                            <td>&nbsp;
                                <input id="modlgn-email2" type="text" name="email2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Verifique cuenta de correo electr&oacute;nico:"/><span class="required">*</span>
                            </td>
                        </tr>

                        <tr>
                            <td>&nbsp;
                                <label for="modlgn-kit_ingreso">Kit de ingreso:</label>
                            </td>
                            <td>&nbsp;
                                <select id="modlgn-kit_ingreso" name="kit_ingreso" class="combo1"  placeholder="Kit de ingreso9">
                                    <%=strOpciones%>
                                </select><span class="required">*</span>
                            </td>
                        </tr>


                        <td>&nbsp;
                            <label for="Texto">Referencia:</label>
                        </td>
                        <td>&nbsp;
                            <TEXTAREA  id="Texto" style="width: 334px; height: 162px;" onBlur="pasaValor()">
                    </TEXTAREA> 
                    <input type="hidden" id="texto" name="texto"/>
                     </td>
                  </tr>
                  <tr>
                     <td>&nbsp;
                        <img alt="Captcha"  id="captcha_img" src="../stickyImg" /> <button type="button" tabindex="1" name="Refrescar" class="btn btn-primary btn" onclick="recargaCaptcha()" >Cambiar imagen</button>
                     </td>
                     <td>&nbsp;
                        <input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
                     </td>
                  </tr>

               </table>

            <br>
            <br>
            <!--Boton-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
                </div>
            </div>
            
            </div>
            
         </div>
         <!--Boton-->
      </div>

    </form>
</div>
<script type="text/javascript">
    $("#modlgn-nacimiento").datepicker({
        changeMonth: true,
        changeYear: true,
        yearRange: '1945:' + (new Date).getFullYear()
    });

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
        if (document.getElementById("modlgn-rfc").value == "") {
            alert("Es necesario que capture el rfc");
            document.getElementById("modlgn-rfc").focus();
            return false;
        }
        if (document.getElementById("modlgn-nacimiento").value == "") {
            alert("Es necesario que capture la fecha de nacimiento");
            document.getElementById("modlgn-nacimiento").focus();
            return false;
        }
        if (document.getElementById("modlgn-calle").value == "") {
            alert("Es necesario que capture la calle");
            document.getElementById("modlgn-calle").focus();
            return false;
        }
        if (document.getElementById("modlgn-numero").value == "") {
            alert("Es necesario que capture el numero");
            document.getElementById("modlgn-numero").focus();
            return false;
        }
        if (document.getElementById("modlgn-colonia").value == "") {
            alert("Es necesario que capture la colonia");
            document.getElementById("modlgn-colonia").focus();
            return false;
        }
        if (document.getElementById("modlgn-municipio").value == "") {
            alert("Es necesario que capture la municipio");
            document.getElementById("modlgn-municipio").focus();
            return false;
        }
        var combo = document.getElementById("modlgn-estado");
        var selected = combo.options[combo.selectedIndex].text;
        if (selected == "Seleccione") {
            alert("Es necesario que capture el estado");
            document.getElementById("modlgn-estado").focus();
            return false;
        }
        if (document.getElementById("modlgn-cp").value == "") {
            alert("Es necesario que capture el codigo postal");
            document.getElementById("modlgn-cp").focus();
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
        if (document.getElementById("modlgn-email1").value == "") {
            alert("Es necesario que capture el correo electronico");
            document.getElementById("modlgn-email1").focus();
            return false;
        }
        if (document.getElementById("modlgn-email2").value == "") {
            alert("Es necesario que confirme el correo");
            document.getElementById("modlgn-email2").focus();
            return false;
        }
        if (document.getElementById("modlgn-answer").value == "") {
            alert("Es necesario que capture el codigo de la imagen");
            document.getElementById("modlgn-answer").focus();
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
        //Email 2
        if (document.getElementById("modlgn-email2").value != "") {
            var bolExpReg = _EvalExpReg(document.getElementById("modlgn-email2").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
            if (!bolExpReg) {
                alert("El formato del mail es incorrecto");
                document.getElementById("modlgn-email2").focus();
                return false;
            }
        }
        //RFC 
        if (document.getElementById("modlgn-rfc").value != "") {
            var bolExpReg = _EvalExpReg(document.getElementById("modlgn-rfc").value, "^[A-Z,Ñ,&]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,0-9]?[A-Z,0-9]?[0-9,A-Z]?$");
            if (!bolExpReg) {
                alert("El formato del registro federal de contribuyentes es incorrecto");
                document.getElementById("modlgn-rfc").focus();
                return false;
            }
        }
        //Codigo postal
        if (document.getElementById("modlgn-cp").value != "") {
            var bolExpReg = _EvalExpReg(document.getElementById("modlgn-cp").value, "^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$");
            if (!bolExpReg) {
                alert("El formato del codigo postal es incorrecto");
                document.getElementById("modlgn-cp").focus();
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


        if (validaDireccionEntrega() != true) {

            return false;
        }

        if (verificaCorreo() != true) {
            return false;
        }
        return true;
    }

    /*Copia los datos de facturacion*/
    function copyDireccion() {

    }

    function verificaCorreo() {
        //Verifica correo      
        if (document.getElementById("modlgn-email1").value == document.getElementById("modlgn-email2").value) {
            return true;
        } else {
            alert("Es necesario que el correo y la confirmacion sean iguales");
            document.getElementById("modlgn-email2").focus();
            return false;
        }
        return true;
    }

    /*Valida los campos de direccion de entrega*/
    function validaDireccionEntrega() {

        return true;
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
    function recargaCaptcha() {
        var dateNow = new Date();
        $("#captcha_img").attr("src", "../stickyImg?" + dateNow.getTime());
    }


                  </script>

<%         }
%>
