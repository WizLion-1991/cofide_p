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
    ArrayList<String> lstBancos = new ArrayList<String>();
    ArrayList<String> lstTipoIngreso = new ArrayList<String>();
    ArrayList<Integer> intTipoIngresoID = new ArrayList<Integer>();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();

    //Obtenemos parametros generales de la pagina a mostrar
    Site webBase = new Site(oConn);
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
            <h3 class="page-header">Nuevo distribuidor</h3>
            <form action="modules/mod_v15matriz/ingresos_save_ext.jsp" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
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
                                    <td>&nbsp;<label for="modlgn-sponsor">Id de quien Invito:</label></td>
                                    <td>&nbsp;<input id="modlgn-sponsor" type="text" name="sponsor" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Id de quien Invito" value="0" onBlur="getNameIdSponzor()"/></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;<label for="nombreSponsor">Nombre de quien Invito:</label></td>
                                    <td>&nbsp;<input id="nombreSponsor" type="text" name="nombreSponsor" class="input-medium-ingresos" tabindex="0" size="80" maxlength="80" placeholder="Nombre de quien Invito"  readonly="true" /></td>
                                </tr>
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
                                        <label for="modlgn-localidad">Localidad:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-localidad" type="text" name="localidad" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Localidad"/>
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
                                        <label for="modlgn-email2">Cuenta de correo electr&oacute;nico:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-email2" type="text" name="email2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Cuenta de correo electr&oacute;nico"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-contacto1">Contacto:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-contacto1" type="text" name="contacto1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="30" placeholder="Contacto"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-ciudad_nac">Ciudad de Nacimiento:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-ciudad_nac" type="text" name="modlgn-ciudad_nac" class="input-medium-ingresos" tabindex="0" size="30" maxlength="30" placeholder="Ciudad de nacimiento"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-ciudad_residencia">Ciudad de Residencia:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-ciudad_residencia" type="text" name="modlgn-ciudad_residencia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="30" placeholder="Ciudad de residencia"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-beneficiario">Beneficiario:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-beneficiario" type="text" name="modlgn-beneficiario" class="input-medium-ingresos" tabindex="0" size="30" maxlength="30" placeholder="Beneficiario"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-cuenta_bancaria1">Cuenta Bancaria 1:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-cuenta_bancaria1" type="text" name="cuenta_bancaria1" class="input-small" tabindex="0" size="20" maxlength="20" placeholder="Cuenta Bancaria 1"/>
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
                                        Sucursal:<input id="modlgn-suc1" type="text" name="cuenta_suc1" class="input-small" tabindex="0" size="10" maxlength="5" placeholder="Sucursal"/>
                                        Clabe: <input id="modlgn-clb1" type="text" name="cuenta_clb1" class="input-small" tabindex="0" size="20" maxlength="20" placeholder="Clabe"/>

                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="modlgn-cuenta_bancaria2">Cuenta Bancaria 2:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="modlgn-cuenta_bancaria2" type="text" name="cuenta_bancaria2" class="input-small" tabindex="0" size="20" maxlength="20" placeholder="Cuenta Bancaria 2"/>

                                        <select id="dir_ent_banco2" name="dir_ent_banco2" class="combo1"  placeholder="Estado">
                                            <option id="">Seleccione</option>
                                            <%
                                                //Mostramos los estados.
                                                Iterator<String> it2 = lstBancos.iterator();
                                                while (it2.hasNext()) {
                                                    String strBanco = it2.next();
                                            %><option id="<%=strBanco%>"><%=strBanco%></option><%
                                                }
                                            %>
                                        </select>

                                        Sucursal:<input id="modlgn-suc2" type="text" name="cuenta_suc2" class="input-small" tabindex="0" size="10" maxlength="5" placeholder="Sucursal"/>
                                        Clabe: <input id="modlgn-clb2" type="text" name="cuenta_clb2" class="input-small" tabindex="0" size="20" maxlength="20" placeholder="Clabe"/>

                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="mdlgn-codigo_promo">Código de promoción:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="mdlgn-codigo_promo" type="text" name="mdlgn-codigo_promo" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Código de promoción" onBlur="checkCodigo()"/><span class="required">*</span>
                                        <img id="imgValida"/>
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
                                <tr>
                                    <td colspan="2"><h4>Direccion de entrega</h4></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;<label for="copia">Copiar direcion de Facturación:</label></td>
                                    <td>&nbsp;<input type="checkbox" id="copia" onchange="copyDireccion()"/></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_nombre">Nombre:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_nombre" type="text" name="dir_ent_nombre" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Nombre"/> <span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_telefono">Telefono:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_telefono" type="text" name="dir_ent_telefono" class="input-medium-ingresos" tabindex="0" size="30" maxlength="15" placeholder="Telefono"/> <span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_email">Email:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_email" type="text" name="dir_ent_email" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Email"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_calle">Calle:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_calle" type="text" name="dir_ent_calle" class="input-medium-ingresos" tabindex="0" size="30" maxlength="50" placeholder="Calle"/> <span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_numero">Numero:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_numero" type="text" name="dir_ent_numero" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Numero"/><span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_numeroInterno">Numero Interno:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_numeroInterno" type="text" name="dir_ent_numeroInterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Numero Interno"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_colonia">Colonia:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_colonia" type="text" name="dir_ent_colonia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Colonia"/><span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_estado">Estado:</label>
                                    </td>
                                    <td>&nbsp;
                                        <select id="dir_ent_estado" name="dir_ent_estado" class="combo1"  placeholder="Estado">
                                            <option id="">Seleccione</option>
                                            <%
                                                //Mostramos los estados.
                                                Iterator<String> it1 = lstEstado.iterator();
                                                while (it1.hasNext()) {
                                                    String strEstado = it1.next();
                                            %><option id="<%=strEstado%>"><%=strEstado%></option><%
                                                }
                                            %>
                                        </select>
                                        <span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_mun">Municipio:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_mun" type="text" name="dir_ent_mun" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Municipio"/><span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                        <label for="dir_ent_cp">C&oacute;digo Postal:</label>
                                    </td>
                                    <td>&nbsp;
                                        <input id="dir_ent_cp" type="text" name="dir_ent_cp" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="C&oacute;digo Postal"/><span class="required">*</span>
                                    </td>
                                </tr>
                                <tr>
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
                            <td>&nbsp;<label for="modlgn-Testigo1">Testigo 1:</label></td>
                            <td>&nbsp;<input id="modlgn-Testigo1" type="text" name="modlgn-Testigo1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Testigo 1"/> <span class="required">*</span></td>                            
                  </tr>
                  <tr>
                            <td>&nbsp;<label for="modlgn-Testigo2">Testigo 2:</label></td>
                            <td>&nbsp;<input id="modlgn-Testigo2" type="text" name="modlgn-Testigo2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Testigo 2"/> <span class="required">*</span></td>                            
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
                <tr>
                     <td>&nbsp;<input type="checkbox" id="aceptoCondiciones"/></td>
                     <td>&nbsp;<a for="aceptoCondiciones" href="http://sistema.v15matriz.com:8091/Sistema/iCommerce/CONTRATO_mlm.pdf" target="_blank">Leí y acepto los términos y condiciones.</a></td>
                  </tr>
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

              if (document.getElementById("modlgn-Testigo1").value == "") {
                  alert("Necesita escribir el nombre de el Testigo 1");
                  document.getElementById("modlgn-Testigo1").focus();
                  return false;
              }

              if (document.getElementById("modlgn-Testigo2").value == "") {
                  console.log("VALOR:         ....." + document.getElementById("modlgn-Testigo2").value);
                  alert("Necesita escribir el nombre de el Testigo 2");
                  document.getElementById("modlgn-Testigo2").focus();
                  return false;
              }
              if (validaDireccionEntrega() != true) {
                  return false;
              }
              if (document.getElementById("aceptoCondiciones").checked == false) {
                  alert("Falta aceptar terminos y condiciones");
                  document.getElementById("aceptoCondiciones").focus();
                  return false;
              }

              return true;
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
                  document.getElementById("dir_ent_cp").value = document.getElementById("modlgn-cp").value;

              } else {
                  document.getElementById("dir_ent_nombre").value = "";
                  document.getElementById("dir_ent_telefono").value = "";
                  document.getElementById("dir_ent_calle").value = "";
                  document.getElementById("dir_ent_numero").value = "";
                  document.getElementById("dir_ent_numeroInterno").value = "";
                  document.getElementById("dir_ent_colonia").value = "";
                  document.getElementById("dir_ent_estado").value = "";
                  document.getElementById("dir_ent_mun").value = "";
                  document.getElementById("dir_ent_cp").value = "";
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
              if (document.getElementById("dir_ent_telefono").value == "") {

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
              if (document.getElementById("dir_ent_cp").value == "") {
                  alert("Es necesario que capture un Codigo postal.");
                  document.getElementById("dir_ent_cp").focus();
                  return false;
              }

              if (document.getElementById("mdlgn-codigo_promo").value == "") {
                  alert("Es necesario que capture un Código de promoción valido.");
                  document.getElementById("mdlgn-codigo_promo").focus();
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
          function pasaValor() {

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


          function checkCodigo() {
              $("#dialogWait").dialog('open');
              document.getElementById("imgValida").innerHTML = "<img id=\"imgValida\" src = \"images/lightbox-ico-loading.gif\"/>";
              var strPOST = "CODIGO=" + document.getElementById("mdlgn-codigo_promo").value;
              $.ajax({
                  type: "POST",
                  data: strPOST,
                  scriptCharset: "utf-8",
                  contentType: "application/x-www-form-urlencoded;charset=utf-8",
                  cache: false,
                  dataType: "html",
                  url: "modules/mod_v15matriz/valida_codigo.jsp?ID=1",
                  success: function (datos) {
                      document.getElementById("imgValida").innerHTML = datos;
                      $("#dialogWait").dialog('close');
                  },
                  error: function (objeto, quepaso, otroobj) {
                      alert("Error: Al cargar comprobar codigo:" + objeto + " " + quepaso + " " + otroobj);
                  }
              });
          }

                                                                                                                                                                                                        </script>

                                    <%     //    }
%>
   </body>
</html>