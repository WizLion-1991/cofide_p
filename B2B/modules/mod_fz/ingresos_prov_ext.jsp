
<%-- 
    Document   : ingresos_ext
    Este jsp contiene la pantalla de captura de nuevos ingresos
    Created on : 16-abr-2013, 15:31:53
    Author     : aleph_79
--%>

<%@page import="com.mx.siweb.ui.web.Document"%>
<%@page import="com.mx.siweb.ui.web.TemplateParams"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="java.sql.SQLException"%>
<%@page import="ERP.Precios"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="nl.captcha.Captcha"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    //if (varSesiones.getIntNoUser() != 0) {

    //Recuperamos los nombres de los estados
    ArrayList<String> lstEstado = new ArrayList<String>();
    ArrayList<String> lstPaises = new ArrayList<String>();
    ArrayList<Integer> intIdPais = new ArrayList<Integer>();
    ArrayList<String> lstBancos = new ArrayList<String>();
    ArrayList<String> lstTipoIngreso = new ArrayList<String>();
    ArrayList<Integer> intTipoIngresoID = new ArrayList<Integer>();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();

    //Obtenemos parametros generales de la pagina a mostrar
    Site webBase = new Site(oConn, "B2B");
    //Inicializamos los parametros del template
    TemplateParams templateparams = new TemplateParams(oConn, "protostar", webBase.getStrLanguage());
    // get params
    String strColor = templateparams.getColor();
    String strLogo = templateparams.getLogo();
    String strNavposition = templateparams.getPosition();
    Document doc = new Document(oConn);
    doc.getInfoModules();
    // check modules
    int showRightColumn = 1;
    int showbottom = 0;
    int showleft = 0;
    int showno = 0;
    if (doc.getLstCountModules().contains("position-3") || doc.getLstCountModules().contains("position-6") || doc.getLstCountModules().contains("position-8")) {
        showRightColumn = 1;
    }
    if (doc.getLstCountModules().contains("position-9") || doc.getLstCountModules().contains("position-10") || doc.getLstCountModules().contains("position-11")) {
        showbottom = 1;
    }
    if (doc.getLstCountModules().contains("position-4") || doc.getLstCountModules().contains("position-7") || doc.getLstCountModules().contains("position-5")) {
        showleft = 1;
    }
    if (showRightColumn == 0 && showleft == 0) {
        showno = 0;
    }
    String browserType = (String) request.getHeader("User-Agent");
    doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/template.css", "", "");
    doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/smoothness/jquery-ui-1.10.2.custom.min.css", "", "");
    doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/ui.jqgrid4.4.4.css", "", "");
    if (!strColor.isEmpty()) {
        doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/" + strColor + ".css", "", "");
    }
    doc.addStyleSheet(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/css/superfish.css", "", "");

    //mootools
    doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/mootools-core.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/core.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/caption.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/media/system/js/mootools-more.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery-1.9.1.min.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/grid.locale-es.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery.jqGrid.4.4.4.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jquery-ui-1.10.0.custom.min.js", "text/javascript");

    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/hoverIntent.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/superfish.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/jQuery.circleMenu.js", "text/javascript");
    doc.addJavaScript(webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/javascript/ui.datepicker-es.js", "text/javascript");

    //Evaluamos que modulo representar
    String strModulo = request.getParameter("mod");
    if (strModulo == null) {
        strModulo = "inicio";
    }

    //Consultamos los estados
    String strSql = "select * from estadospais  ";
    ResultSet rs = oConn.runQuery(strSql, true);
    while (rs.next()) {
        lstEstado.add(rs.getString("ESP_NOMBRE"));
    }
    rs.close();

    //Consultamos los paises
    String strSql1 = "select * from paises ";
    ResultSet rs1 = oConn.runQuery(strSql1, true);
    while (rs1.next()) {
        lstPaises.add(rs1.getString("PA_NOMBRE"));
        intIdPais.add(rs1.getInt("PA_ID"));
    }
    rs1.close();

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
                dblPrecio = dblPrecio * 1.16;
            }
            rs2.close();
        } catch (SQLException ex) {
        }

        strOpciones.append("<option value='" + rs.getInt("PR_ID") + "'>" + rs.getString("PR_DESCRIPCION") + " $" + comSIWeb.Utilerias.NumberString.FormatearDecimal(dblPrecio, 2) + "</option>");
    }
    rs.close();
    oConn.close();

%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%= webBase.getStrLanguage()%>" lang="<%= webBase.getStrLanguage()%>" dir="<%= webBase.getStrDirection()%>" >
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <%= webBase.getHeader(templateparams)%>
        <%= doc.writeHtmlStyles()%>
        <%= doc.writeHtmlJavaScript()%>
        <%
            if (templateparams.isGoogleFont()) {
        %>
        <link href='//fonts.googleapis.com/css?family=<%=templateparams.getGoogleFontName()%>' rel='stylesheet' type='text/css' />
        <style type="text/css">
            h1,h2,h3,h4,h5,h6,.site-title{
                font-family: '<%=templateparams.getGoogleFontName().replace("+", " ")%>', sans-serif;
            }
        </style>
        <%
            }
        %>
        <%if (10 == 9) {%>
        <style type="text/css">
            body.site
            {
                border-top: 3px solid <%=templateparams.getColor()%>;
                background-color: <%=templateparams.getBackgroundColor()%>
            }
            a
            {
                color: <%=templateparams.getColor()%>;
            }
            .navbar-inner, .nav-list > .active > a, .nav-list > .active > a:hover, .dropdown-menu li > a:hover, .dropdown-menu .active > a, .dropdown-menu .active > a:hover, .nav-pills > .active > a, .nav-pills > .active > a:hover,
            .btn-primary
            {
                background: <%=templateparams.getColor()%>;
            }
            .navbar-inner
            {
                -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, .25), inset 0 -1px 0 rgba(0, 0, 0, .1), inset 0 30px 10px rgba(0, 0, 0, .2);
                -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, .25), inset 0 -1px 0 rgba(0, 0, 0, .1), inset 0 30px 10px rgba(0, 0, 0, .2);
                box-shadow: 0 1px 3px rgba(0, 0, 0, .25), inset 0 -1px 0 rgba(0, 0, 0, .1), inset 0 30px 10px rgba(0, 0, 0, .2);
            }
        </style>
        <%}%>
        <!--[if lt IE 9]>
           <script src="<%=webBase.getUrlSite()%>media/jui/js/html5.js"></script>
        <![endif]-->
    </head>

    <body class="site com_content view-article no-layout no-task itemid-435">
        <div class="well ">
            <h3 class="page-header">Nuevo Proveedor</h3>
            <form action="modules/mod_fz/ingresos_prov_save_ext.jsp" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
                <div class="userdata">
                    <div id="form-new-submit" class="control-group">
                        <div class="controls">
                            <span class="required">* Los campos marcados en rojo son obligatorios</span>
                        </div>
                    </div>




                    <div id="form-new-nombre" class="control-group">
                        <div class="controls">

                            <table cellpadding="4" cellspacing="1" border="0" style="background-color: #739dd3;">
                                <!--Empresa-->

                                <!--Razon Social-->
                                <tr>
                                    <td>&nbsp;<label for="modlgn-razonSocial">Razon Social:</label></td>
                                    <td>&nbsp;<input id="modlgn-razonSocial" type="text" name="razonSocial" class="input-medium-ingresos" tabindex="0" size="100" maxlength="100" placeholder="Razon Social"  /><span class="required">*</span></td>
                                </tr>
                                <!--R.F.C.-->
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-rfc">Registro Federal de Contribuyentes:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-rfc" type="text" name="rfc" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Registro Federal de Contribuyentes" value="XAXX010101000"  /><span class="required">*</span>
                                    </td>
                                </tr>
                                <!--Calle-->
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-calle">Calle:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-calle" type="text" name="calle" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Calle"/>
                                    </td>
                                </tr>
                                <!--Numero-->
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-numero">Numero:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-numero" type="text" name="numero" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Numero"/>
                                    </td>
                                </tr>
                                <!--Numero Interno-->
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-numeroInterno">Numero Interno:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-numeroInterno" type="text" name="numeroInterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Numero Interno"/>
                                    </td>
                                </tr>
                                <!--Colonia-->
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-colonia">Colonia:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-colonia" type="text" name="colonia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Colonia"/>
                                    </td>
                                </tr>
                                <!--Municipio-->
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-municipio">Municipio:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-municipio" type="text" name="municipio" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Municipio"/>
                                    </td>
                                </tr>
                                <!--Pais-->
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-pais" >Pais:</label>
                                    </td>
                                    <td>&nbsp;
                                        <select id="modlgn-pais" name="pais" class="combo1"  placeholder="Pais"  >
                                            <option id="">Seleccione</option>
                                            <%
                                                //Mostramos los Paises.
                                                Iterator<String> it1 = lstPaises.iterator();
                                                while (it1.hasNext()) {
                                                    String strPais = it1.next();
                                            %><option id="<%=strPais%>"><%=strPais%></option><%
                                                }
                                            %>
                                        </select>

                                    </td>
                                </tr>
                                <!--Estado-->
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

                                    </td>
                                </tr>

                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-cp">C&oacute;digo Postal:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-cp" type="text" name="cp" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="C&oacute;digo Postal"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-telefono1">Telefono casa(10 digitos):</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-telefono1" type="text" name="telefono1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono casa"/>
                                    </td>

                                    <tr>
                                        <td>&nbsp;
                                            <label for="modlgn-email1">Cuenta de correo electr&oacute;nico:</label>
                                        </td>
                                        <td>&nbsp;
                                            <input id="modlgn-email1" type="text" name="email1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Cuenta de correo electr&oacute;nico"/>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>&nbsp;
                                            <label for="modlgn-cuenta_banc">Numero de Cuenta Bancaria:</label>
                                        </td>
                                        <td>&nbsp;
                                            <input id="modlgn-cuenta_banc" type="text" name="cuenbanc" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Numero de Cuenta Bancaria"/><span class="required">*</span>
                                        </td>
                                    </tr>                                    

                                    <tr>
                                        <td>&nbsp;
                                            <label for="modlgn-contacto">Nombre del Representante:</label>
                                        </td>
                                        <td>&nbsp;
                                            <input id="modlgn-contacto" type="text" name="contacto" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Nombre del Representante"/><span class="required">*</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>&nbsp;
                                            <label for="modlgn-telefono2">Telefono del Responsable(10 digitos):</label>
                                        </td>
                                        <td>&nbsp;
                                            <input id="modlgn-telefono2" type="text" name="telefono2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono celular"/><span class="required">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;
                                            <label for="modlgn-email2">Cuenta de correo electr&oacute;nico del Responsable:</label>
                                        </td>
                                        <td>&nbsp;
                                            <input id="modlgn-email2" type="text" name="email2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Cuenta de correo electr&oacute;nico del Responsable"/><span class="required">*</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>&nbsp;
                                            <label for="modlgn-email3">Verifique cuenta de correo electr&oacute;nico:</label>
                                        </td>
                                        <td>&nbsp;
                                            <input id="modlgn-email3" type="text" name="email3" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Verifique cuenta de correo electr&oacute;nico:"/><span class="required">*</span>
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
      <div id="dialogWait" title="Favor de esperar">
         <div id="dialogWait_inside" align="center"><img src="../images/ptovta/ajax-loader.gif" border="0" alt=""></div>
      </div>
      <script type="text/javascript">
          $("#dialogWait").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
          $("#modlgn-nacimiento").datepicker({
              changeMonth: true,
              changeYear: true,
              yearRange: '1945:' + (new Date).getFullYear()
          });
          $("#dialogWait").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});

          function EvaluaFormulario() {
              if (document.getElementById("modlgn-razonSocial").value == "") {
                  alert("Es necesario que capture la razon social");
                  document.getElementById("modlgn-razonSocial").focus();
                  return false;
              }
              if (document.getElementById("modlgn-rfc").value == "") {
                  alert("Es necesario que capture el rfc");
                  document.getElementById("modlgn-rfc").focus();
                  return false;
              }
              if (document.getElementById("modlgn-contacto").value == "") {
                  alert("Es necesario que capture el nombre del representante");
                  document.getElementById("modlgn-contacto").focus();
                  return false;
              }
              if (document.getElementById("modlgn-telefono2").value == "") {
                  alert("Es necesario que capture el telefono celular");
                  document.getElementById("modlgn-telefono2").focus();
                  return false;
              }

              if (document.getElementById("modlgn-cuenta_banc").value == "") {
                  alert("Es necesario que capture el numero de cuanta");
                  document.getElementById("modlgn-cuenta_banc").focus();
                  return false;
              }


              if (document.getElementById("modlgn-email3").value == "") {
                  alert("Es necesario que capture el correo electronico del Representante");
                  document.getElementById("modlgn-email3").focus();
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


              if (verificaCorreo() != true) {
                  return false;
              }

              return true;
              alert("ok");
          }

          function verificaCorreo() {
              //Verifica correo      
              if (document.getElementById("modlgn-email2").value == document.getElementById("modlgn-email3").value) {
                  return true;
              } else {
                  alert("Es necesario que el correo y la confirmacion sean iguales");
                  document.getElementById("modlgn-email2").focus();
                  return false;
              }
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
          function  pasaValor() {

              document.getElementById("texto").value = document.getElementById("Texto").value.trim();
          }
          function recargaCaptcha() {
              var dateNow = new Date();
              $("#captcha_img").attr("src", "../stickyImg?" + dateNow.getTime());
          }



          /**Obtiene el nombre del nodo padre sponzor*/
          function getNameIdSponzor() {
              if (document.getElementById('modlgn-sponsor').value != "0") {
                  $("#dialogWait").dialog("open");
                  document.getElementById('nombreSponsor').value = "";
                  var strPost = "CT_ID=" + document.getElementById('modlgn-sponsor').value;
                  $.ajax({
                      type: "POST",
                      data: strPost,
                      scriptCharset: "utf-8",
                      contentType: "application/x-www-form-urlencoded;charset=utf-8",
                      cache: false,
                      dataType: "xml",
                      url: "../ERP_ConAntCte.jsp?id=2",
                      success: function (datoVal) {

                          var objXML = datoVal.getElementsByTagName("clientes")[0];
                          if (objXML != null) {

                              var lstTiks = objXML.getElementsByTagName("cliente");
                              if (lstTiks.length != 0) {
                                  for (var i = 0; i < lstTiks.length; i++) {
                                      var obj = lstTiks[i];
                                      document.getElementById('nombreSponsor').value = obj.getAttribute("CT_RAZONSOCIAL");
                                  }
                              } else {
                                  alert("EL cliente no existe con ese ID, si no lo conoce dejelo en ceros.");
                                  document.getElementById('modlgn-sponsor').focus();
                              }

                          } else {
                              alert("El upline no existe, si no lo conoce dejelo en ceros.");
                              document.getElementById('modlgn-sponsor').focus();
                          }
                          $("#dialogWait").dialog("close");
                      },
                      error: function (objeto, quepaso, otroobj) {
                          alert(":Upline cte:" + objeto + " " + quepaso + " " + otroobj);
                          $("#dialogWait").dialog("close");
                      }
                  });
              }

          }


                                                                                                                                                                                                        </script>

                                    <%     //    }
%>
   </body>
</html>