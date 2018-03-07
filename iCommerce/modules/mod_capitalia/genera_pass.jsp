<%-- 
    Document   : genera_pass
    Created on : Oct 1, 2015, 11:10:26 AM
    Author     : CasaJosefa
--%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="nl.captcha.Captcha"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.SQLException" %>
<%@page import="comSIWeb.Utilerias.Mail" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mx.siweb.ui.web.Document"%>
<%@page import="com.mx.siweb.ui.web.TemplateParams"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="java.sql.SQLException"%>
<%@page import="ERP.Precios"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="nl.captcha.Captcha"%>

<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    /*Definimos parametros de la aplicacion*/
    String strOpt = request.getParameter("Opt");
    if (strOpt == null) {
        strOpt = "";
    }
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio

    //Pantalla con acceso publico
    //Pantalla para recuperar la contrasenia
    System.out.println("strOpt " + strOpt);
    if (strOpt.equals("getScLose")) {

        //Recuperamos los nombres de los estados
        ArrayList<String> lstEstado = new ArrayList<String>();
        ArrayList<String> lstPaises = new ArrayList<String>();
        ArrayList<Integer> intIdPais = new ArrayList<Integer>();
        ArrayList<String> lstBancos = new ArrayList<String>();
        ArrayList<String> lstTipoIngreso = new ArrayList<String>();
        ArrayList<Integer> intTipoIngresoID = new ArrayList<Integer>();
        //Abrimos la conexion
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
            <h3 class="page-header">RECUPERAR CONTRASEÑA</h3>
            <form action="modules/mod_fz/genera_pass_proced.jsp" method="post" onsubmit="return  EvaluaFormulariopass();" id="login-form" class="form-inline">
                <div class="userdata">
                    <div id="form-new-submit" class="control-group">
                        <div class="controls">
                            <span class="required">* Los campos marcados en rojo son obligatorios</span>
                        </div>
                    </div>


                    <div id="form-new-nombre" class="control-group">
                        <div class="controls">

                            <table cellpadding="4" cellspacing="1" border="0" style="background-color: #739dd3;">

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
                                        <img alt="Captcha"  id="captcha_img" src="../stickyImg" /> <button type="button" tabindex="1" name="Refrescar" class="btn btn-primary btn" onclick="recargaCaptcha()" >Cambiar imagen</button>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
                                    </td>
                                </tr>


                            </table>

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

            function EvaluaFormulariopass() {

                if (document.getElementById("modlgn-email1").value == "") {
                    alert("Es necesario que capture el correo electronico ");
                    document.getElementById("modlgn-email1").focus();
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



        <%                     }
           %>