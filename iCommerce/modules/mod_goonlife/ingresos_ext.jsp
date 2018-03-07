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
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    //if (varSesiones.getIntNoUser() != 0) {

    //Recuperamos los nombres de los estados
    ArrayList<String> lstEstado = new ArrayList<String>();
    ArrayList<String> lstZona = new ArrayList<String>();
    ArrayList<String> lstBancos = new ArrayList<String>();
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
        <link href='http://fonts.googleapis.com/css?family=<%=templateparams.getGoogleFontName()%>' rel='stylesheet' type='text/css' />
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
            <h3 class="page-header">Nueva Mama Bambi</h3>
            <form action="modules/mod_goonlife/ingresos_save_ext.jsp" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
                <div class="userdata">
                    <div id="form-new-submit" class="control-group">
                        <div class="controls">
                            <span class="required">* Los campos marcados en rojo son obligatorios</span>
                        </div>
                    </div>
                    <!--QUIEN LO RECOMIENDA-->
                    <div id="form-new-nombre" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="la persona que recomienda"/>
                                    <label for="modlgn-recomienda" >La persona que recomienda:</label>
                                </span>
                                <input id="modlgn-recomienda" type="text" name="recomienda" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="la persona que recomienda"/> 
                            </div>
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
                                <input id="modlgn-apaterno" type="text" name="apaterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Apellido Paterno"/>
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
                    <!--Sponsor-->
                    <input id="modlgn-sponsor" type="hidden" name="sponsor"  value="1"/>
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
                    <!--RFC-->
                    <div id="form-new-rfc" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="Registro Federal de Contribuyentes"/>
                                    <label for="modlgn-rfc" >Registro Federal de Contribuyentes:</label>
                                </span>
                                <input id="modlgn-rfc" type="text" name="rfc" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Registro Federal de Contribuyentes"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--Calle-->
                    <div id="form-new-calle" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="Calle"/>
                                    <label for="modlgn-calle" >Calle:</label>
                                </span>
                                <input id="modlgn-calle" type="text" name="calle" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Calle"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--Numero-->
                    <div id="form-new-numero" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="numero"/>
                                    <label for="modlgn-numero" >Numero:</label>
                                </span>
                                <input id="modlgn-numero" type="text" name="numero" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Numero"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--Boton-->
                    <!--Numero interno-->
                    <div id="form-new-numeroInterno" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="numeroInterno"/>
                                    <label for="modlgn-numeroInterno" >Numero Interno:</label>
                                </span>
                                <input id="modlgn-numeroInterno" type="text" name="numeroInterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Numero Interno"/>
                            </div>
                        </div>
                    </div>
                    <!--Colonia-->
                    <div id="form-new-colonia" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="colonia"/>
                                    <label for="modlgn-colonia" >Colonia:</label>
                                </span>
                                <input id="modlgn-colonia" type="text" name="colonia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Colonia"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>

                    <!--Municipio-->
                    <div id="form-new-municipio" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="municipio"/>
                                    <label for="modlgn-municipio" >Municipio</label>
                                </span>
                                <input id="modlgn-municipio" type="text" name="municipio" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Municipio"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--Localidad-->
                    <div id="form-new-localidad" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="localidad"/>
                                    <label for="modlgn-localidad" >Localidad</label>
                                </span>
                                <input id="modlgn-localidad" type="text" name="localidad" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Localidad"/>
                            </div>
                        </div>
                    </div>
                    <!--Estado-->
                    <div id="form-new-estado" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="estado"/>
                                    <label for="modlgn-estado" >Estado:</label>
                                </span>
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
                            </div>
                        </div>
                    </div>
                    <!--Codigo Postal-->
                    <div id="form-new-cp" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="cp"/>
                                    <label for="modlgn-cp" >C&oacute;digo Postal:</label>
                                </span>
                                <input id="modlgn-cp" type="text" name="cp" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="C&oacute;digo Postal"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--zona-->
                    <div id="form-new-zona" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="zona"/>
                                    <label for="modlgn-zona" >Zona:</label>
                                </span>
                                <input id="modlgn-zona" type="text" name="zona" class="input-medium-ingresos" tabindex="0" size="30" maxlength="50" value=" 1"/>
                            </div>
                        </div>
                    </div>
                    <!--Telefono 1-->
                    <div id="form-new-telefono1" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="telefono1"/>
                                    <label for="modlgn-telefono1" >Telefono casa:</label>
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
                                    <label for="modlgn-telefono2" >Telefono celular:</label>
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
                    <!--Email 2-->
                    <div id="form-new-email2" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="email2"/>
                                    <label for="modlgn-email2" >Cuenta de correo electr&oacute;nico:</label>
                                </span>
                                <input id="modlgn-email2" type="text" name="email2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Cuenta de correo electr&oacute;nico"/>
                            </div>
                        </div>
                    </div>
                    <!--Contacto 1
                    <div id="form-new-contacto1" class="control-group">
                       <div class="controls">
                          <div class="input-prepend input-append">
                             <span class="add-on">
                                <span title="contacto1"/>
                                <label for="modlgn-contacto1" >Contacto:</label>
                             </span>
                             <input id="modlgn-contacto1" type="text" name="contacto1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="30" placeholder="Contacto"/>
                          </div>
                       </div>
                    </div>-->
                    <!--Numero de cuenta de banco 1
                    <div id="form-new-cuenta_bancaria1" class="control-group">
                       <div class="controls">
                          <div class="input-prepend input-append">
                             <span class="add-on">
                                <span title="cuenta_bancaria1"/>
                                <label for="modlgn-cuenta_bancaria1" >Cuenta Bancaria 1:</label>
                             </span>
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

              </div>
           </div>
        </div>-->
                    <!--Numero de cuenta de banco 2
                    <div id="form-new-cuenta_bancaria2" class="control-group">
                       <div class="controls">
                          <div class="input-prepend input-append">
                             <span class="add-on">
                                <span title="cuenta_bancaria2"/>
                                <label for="modlgn-cuenta_bancaria2" >Cuenta Bancaria 2:</label>
                             </span>
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

              </div>
           </div>
        </div>-->


                    <!--Tipo de kit -->
                    <div id="form-new-kit_ingreso" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="kit_ingreso"/>
                                    <label for="modlgn-kit_ingreso" >Kit de ingreso:</label>
                                    <select id="modlgn-kit_ingreso" name="kit_ingreso" class="combo1"  placeholder="Kit de ingreso9">
                                        <%=strOpciones%>
                                    </select><span class="required">*</span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div id="tabs-2" >
                        <h4>Direccion de entrega</h4>
                        <!--Copia direccion -->
                        <div id="form-new-nombre" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="Nombre"/>
                                        <label for="modlgn-nombre" >Copiar direcion de Facturación:</label>
                                    </span>
                                    <input type="checkbox" id="copia" onchange="copyDireccion()"/></div>
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
                                    <input id="dir_ent_nombre" type="text" name="dir_ent_nombre" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Nombre"/> <span class="required">*</span>
                                </div>
                            </div>
                        </div>
                        <!--Nombre-->
                        <div id="form-new-nombre" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="Nombre"/>
                                        <label for="modlgn-nombre" >Telefono:</label>
                                    </span>
                                    <input id="dir_ent_telefono" type="text" name="dir_ent_telefono" class="input-medium-ingresos" tabindex="0" size="30" maxlength="15" placeholder="Telefono"/> <span class="required">*</span>
                                </div>
                            </div>
                        </div>
                        <!--Email-->
                        <div id="form-new-nombre" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="Nombre"/>
                                        <label for="modlgn-nombre" >Email:</label>
                                    </span>
                                    <input id="dir_ent_email" type="text" name="dir_ent_email" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Email"/>
                                </div>
                            </div>
                        </div>
                        <!--Calle-->
                        <div id="form-new-nombre" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="Nombre"/>
                                        <label for="modlgn-nombre" >Calle:</label>
                                    </span>
                                    <input id="dir_ent_calle" type="text" name="dir_ent_calle" class="input-medium-ingresos" tabindex="0" size="30" maxlength="50" placeholder="Calle"/> <span class="required">*</span>
                                </div>
                            </div>
                        </div>
                        <!--Numero-->
                        <div id="form-new-numero" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="numero"/>
                                        <label for="modlgn-numero" >Numero:</label>
                                    </span>
                                    <input id="dir_ent_numero" type="text" name="dir_ent_numero" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Numero"/><span class="required">*</span>
                                </div>
                            </div>
                        </div>
                        <!--Boton-->
                        <!--Numero interno-->
                        <div id="form-new-numeroInterno" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="numeroInterno"/>
                                        <label for="modlgn-numeroInterno" >Numero Interno:</label>
                                    </span>
                                    <input id="dir_ent_numeroInterno" type="text" name="dir_ent_numeroInterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Numero Interno"/>
                                </div>
                            </div>
                        </div>
                        <!--Colonia-->
                        <div id="form-new-colonia" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="colonia"/>
                                        <label for="modlgn-colonia" >Colonia:</label>
                                    </span>
                                    <input id="dir_ent_colonia" type="text" name="dir_ent_colonia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Colonia"/><span class="required">*</span>
                                </div>
                            </div>
                        </div>
                        <!--Estado-->
                        <div id="form-new-estado" class="control-group">
                            <div class="controls">
                                <div class="input-prepend input-append">
                                    <span class="add-on">
                                        <span title="estado"/>
                                        <label for="modlgn-estado" >Estado:</label>
                                    </span>
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
                                </div>
                            </div>
                        </div>

                    </div>
                    <!--Municipio-->
                    <div id="form-new-cp" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="cp"/>
                                    <label for="modlgn-cp" >Municipio:</label>
                                </span>
                                <input id="dir_ent_mun" type="text" name="dir_ent_mun" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Municipio"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>

                    <!--CP-->
                    <div id="form-new-cp" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="cp"/>
                                    <label for="modlgn-cp" >C&oacute;digo Postal:</label>
                                </span>
                                <input id="dir_ent_cp" type="text" name="dir_ent_cp" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="C&oacute;digo Postal"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>

                    <!--Referencia
                    <div id="form-new-mensaje" class="control-group">
                       <div class="controls">
                          <div class="input-prepend input-append">
                             <label for="modlgn-cp" >Referencia:</label>
                          </div>
                          <TEXTAREA  id="Texto" style="width: 334px; height: 162px;" onBlur="pasaValor()">
                         </TEXTAREA> 
                         <input type="hidden" id="texto" name="texto"/>
                     </div>
                 </div>     -->  

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
                                    <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
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

                                function EvaluaFormulario() {

                                    if (document.getElementById("modlgn-nombre").value == "") {
                                        alert("Es necesario que capture el nombre");
                                        document.getElementById("modlgn-nombre").focus();
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
                                    /*
                                     var combo2 = document.getElementById("modlgn-zona");
                                     var selected2 = combo2.options[combo2.selectedIndex].text;
                                     if (selected2 == "Seleccione") {
                                     alert("Es necesario que capture la Zona");
                                     document.getElementById("modlgn-zona").focus();
                                     return false;
                                     }*/
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
                                    } else {
                                        alert("Es necesario que capture el correo electronico");
                                        document.getElementById("modlgn-email1").focus();
                                        return false;
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
                                        var bolExpReg = _EvalExpReg(document.getElementById("modlgn-rfc").value.toUpperCase(), "^[A-Z,Ñ,&]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,0-9]?[A-Z,0-9]?[0-9,A-Z]?$");
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
                                            alert("El formato del numero de telefono es incorrecto deben ser 10 digitos sin guiones");
                                            document.getElementById("modlgn-telefono1").focus();
                                            return false;
                                        }
                                    }
                                    //Telefono
                                    if (document.getElementById("modlgn-telefono2").value != "") {
                                        var bolExpReg = _EvalExpReg(document.getElementById("modlgn-telefono2").value, "^[0-9]{10}$");
                                        if (!bolExpReg) {
                                            //alert("El formato del numero de telefono es incorrecto deben ser 10 digitos sin guiones");
                                            document.getElementById("modlgn-telefono2").focus();
                                            return false;
                                        }
                                    }

                                    if (document.getElementById("modlgn-kit_ingreso").value == "0") {
                                        alert("Es necesario que capture el Tipo de kit");
                                        document.getElementById("modlgn-kit_ingreso").focus();
                                        return false;
                                    }
                                    if (validaDireccionEntrega() != true) {

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
                                    if (document.getElementById("dir_ent_cp").value == "") {
                                        alert("Es necesario que capture un Codigo postal.");
                                        document.getElementById("dir_ent_cp").focus();
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


                                }



                            </script>

                            <%     //    }
%>
                            </body>
                            </html>