<%-- 
    Document   : CIP_Main
    Created on : 24/01/2010, 01:17:57 AM
    Author     : zeus
--%>
<%@page import="com.mx.siweb.ui.web.SuperFishMenu"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Utilerias.Fechas" %>
<%@ page import="comSIWeb.Operaciones.CIP_Menu" %>
<%@ page import="java.util.List" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="Tablas.cuenta_contratada" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
    /*Atributos generales de la pagina*/
    atrJSP.atrJSP(request, response, true, false);
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    Seguridad seg = new Seguridad();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strPruebas = this.getServletContext().getInitParameter("Pruebas");
        if (strPruebas == null) {
            strPruebas = "";
        }
        Fechas fecha = new Fechas();
        String strRazonSocial = "";
        String strNomSucursal = "";
        String strPrefCodBar = "";
        String strCt_Id = "";
        double dblTasa1 = 0;
        double dblTasa2 = 0;
        double dblTasa3 = 0;
        int intIdTasa1 = 0;
        int intIdTasa2 = 0;
        int intIdTasa3 = 0;
        int intSImp1_2 = 0;
        int intSImp1_3 = 0;
        int intSImp2_3 = 0;
        int intMoneda = 0;
        short intNumCeros = 0;
        int intEMP_ID = 0;
        int intEMP_TIPOCOMP = 0;
        int intEMP_TIPOPERS = 0;
        int intEMP_NO_ISR = 0;
        int intEMP_NO_IVA = 0;
        int intSucDefOfertas = 0;
        int intSucursalDefault = 0;
        int intSucursalMasterDefault = 0;
        int intTicket = 0;
        String strImpresora = "";
        String strCodEscape = "";
        //Activamos la bandera de la empresa
        if (request.getParameter("EMP_ID") != null) {
            intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            varSesiones.setIntIdEmpresa(intEMP_ID);
            //Asignamos la sucursal default
            if (request.getParameter("SC_ID") != null) {
                intSucursalDefault = Integer.valueOf(request.getParameter("SC_ID"));
                varSesiones.setIntSucursalDefault(intSucursalDefault);
            }
            //Asignamos la sucursal default
            if (request.getParameter("SM_ID") != null) {
                intSucursalMasterDefault = Integer.valueOf(request.getParameter("SM_ID"));
                varSesiones.setIntSucursalMaster(intSucursalMasterDefault);
            }
        } else {
            //Tomamos la primer empresa asignada al usuario
            String strSql = "Select EMP_ID FROM vta_userempresa WHERE ID_USUARIOS = '" + varSesiones.getIntNoUser() + "' ";
            ResultSet rs;
            try {
                rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intEMP_ID = rs.getInt("EMP_ID");
                }
                rs.close();
                //Si la empresa sigue siendo cero asignamos la primera
                if (intEMP_ID == 0) {
                    strSql = "Select EMP_ID FROM vta_empresas LIMIT 0,1";
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        intEMP_ID = rs.getInt("EMP_ID");
                    }
                    rs.close();
                }
                varSesiones.setIntIdEmpresa(intEMP_ID);
            } catch (SQLException ex) {
                ex.fillInStackTrace();
            }
        }
        //Evaluamos si selecciono la sucursal default
        if (intSucursalDefault == 0) {
            //Validamos la sucursal defaults
            try {
                String strSql = "Select SC_ID FROM vta_sucursal WHERE EMP_ID = " + varSesiones.getIntIdEmpresa();
                ResultSet rs;
                int intSucTemp = 0;
                boolean bolFound = false;
                rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intSucTemp = rs.getInt("SC_ID");
                    if (intSucTemp == varSesiones.getIntSucursalDefault()) {
                        bolFound = true;
                    }
                }
                rs.close();
                if (!bolFound) {
                    varSesiones.setIntSucursalDefault(intSucTemp);
                }
            } catch (SQLException ex) {
                ex.fillInStackTrace();
            }
        }
        //Evaluamos el perfil de acuerdo a la sucursal default
        try {
            String strSql = "Select PF_ID FROM usuarios_bodegas WHERE "
                    + " SC1_ID = " + varSesiones.getIntSucursalDefault()
                    + " AND id_usuarios = " + varSesiones.getIntNoUser();
            ResultSet rs;
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                //Si tiene un perfil especial lo asignamos
                varSesiones.setIntIdPerfil(rs.getInt("PF_ID"));
            }
            rs.close();
        } catch (SQLException ex) {
            ex.fillInStackTrace();
        }
        //Validamos que solo se muestren las sucursales de la empresa con la que estemos trabajando
        String strLstSuc = "";
        String strSQL_QUERY;

        if (intSucursalDefault == 0) {
            strSQL_QUERY = "select vta_sucursal.SC_ID from usuarios_sucursales,vta_sucursal "
                    + " where usuarios_sucursales.SC_ID = vta_sucursal.SC_ID "
                    + " and id_usuarios = '" + varSesiones.getIntNoUser() + "' and EMP_ID = '" + varSesiones.getIntIdEmpresa() + "'";

        } else {
            strSQL_QUERY = "select vta_sucursal.SC_ID from usuarios_sucursales,vta_sucursal "
                    + " where usuarios_sucursales.SC_ID = vta_sucursal.SC_ID "
                    + " and id_usuarios = '" + varSesiones.getIntNoUser() + "' and EMP_ID = '" + varSesiones.getIntIdEmpresa()
                    + "'";/*+ "' and vta_sucursal.SC_ID = " + intSucursalDefault;*/

        }

        ResultSet rs2 = oConn.runQuery(strSQL_QUERY, true);
        while (rs2.next()) {
            strLstSuc += rs2.getString("SC_ID") + ",";
        }
        rs2.close();
        if (strLstSuc.endsWith(",")) {
            strLstSuc = strLstSuc.substring(0, strLstSuc.length() - 1);
        }
        if (!strLstSuc.isEmpty()) {
            varSesiones.setStrLstSucursales(strLstSuc);
        }

        //Obtenemos el id de la cuenta
        int intIdCta = 0;
        String strSql = "Select ctam_id FROM usuarios WHERE id_usuarios = '" + varSesiones.getIntNoUser() + "' and UsuarioActivo = 1 ";
        ResultSet rs;
        try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                intIdCta = rs.getInt("ctam_id");
            }
            rs.close();
            //Obtenemos el nombre de la sucursal default
            strSql = "select SC_CLAVE,SC_NOMBRE,CT_ID,"
                    + "SC_TASA1,SC_TASA2,SC_TASA3,SC_SOBRIMP1_2,SC_SOBRIMP1_3,SC_SOBRIMP2_3,SC_DIVISA,"
                    + "TI_ID,TI_ID2,TI_ID3,SC_ACTIVA_OFERTA,SC_PREFIJO_COD_BAR,SC_NOM_FORMATO_TICKET,SC_NOM_IMP1,SC_COD_ESCAPE1 "
                    + "from vta_sucursal where SC_ID = " + varSesiones.getIntSucursalDefault();
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                strNomSucursal = rs.getString("SC_CLAVE") + ".-" + rs.getString("SC_NOMBRE");
                strPrefCodBar = rs.getString("SC_PREFIJO_COD_BAR");
                strCt_Id = rs.getString("CT_ID");
                dblTasa1 = rs.getDouble("SC_TASA1");
                dblTasa2 = rs.getDouble("SC_TASA2");
                dblTasa3 = rs.getDouble("SC_TASA3");
                intIdTasa1 = rs.getInt("TI_ID");
                intIdTasa2 = rs.getInt("TI_ID2");
                intIdTasa3 = rs.getInt("TI_ID3");
                intSImp1_2 = rs.getInt("SC_SOBRIMP1_2");
                intSImp1_3 = rs.getInt("SC_SOBRIMP1_3");
                intSImp2_3 = rs.getInt("SC_SOBRIMP2_3");
                intMoneda = rs.getInt("SC_DIVISA");
                intSucDefOfertas = rs.getInt("SC_ACTIVA_OFERTA");
                intTicket = rs.getInt("SC_NOM_FORMATO_TICKET");
                strImpresora = rs.getString("SC_NOM_IMP1");
                strCodEscape = rs.getString("SC_COD_ESCAPE1");
            }
            rs.close();
        } catch (SQLException ex) {
            ex.fillInStackTrace();
        }
        /*Obtenemos informacion de la cuenta contratada*/
        cuenta_contratada miCuenta = new cuenta_contratada();
        miCuenta.ObtenDatos(intIdCta, oConn);
        strRazonSocial = miCuenta.getFieldString("nombre");
        int intPreciosconImp = miCuenta.getFieldInt("PRECIOCONIMP");
        String strPathImgEmp = "";
        //Si la empresa seleccionada es diferente de cero obtenemos sus datos
        if (intEMP_ID != 0) {
            strSql = "select vta_empresas.EMP_ID,vta_empresas.EMP_RAZONSOCIAL,vta_empresas.EMP_PATHIMG,"
                    + "vta_empresas.EMP_RFC,vta_empresas.EMP_TIPOCOMP,vta_empresas.EMP_TIPOPERS,"
                    + "vta_empresas.EMP_NO_ISR,vta_empresas.EMP_NO_IVA "
                    + " from  vta_empresas "
                    + " where vta_empresas.EMP_ID = " + intEMP_ID + " ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                strRazonSocial = rs.getString("EMP_RAZONSOCIAL");
                intEMP_TIPOCOMP = rs.getInt("EMP_TIPOCOMP");
                intEMP_TIPOPERS = rs.getInt("EMP_TIPOPERS");
                intEMP_NO_ISR = rs.getInt("EMP_NO_ISR");
                intEMP_NO_IVA = rs.getInt("EMP_NO_IVA");
                strPathImgEmp = rs.getString("EMP_PATHIMG");
            }
            rs.close();
        }
        /*URL que enviaremos para reinicializar la sesion y que no se nos termine*/
        String strPOST_Check = "X-aSS=" + varSesiones.getStrUser() + "&X-bSS=" + varSesiones.getIntNoUser()
                + "&X-cSS=" + varSesiones.getIntEsCaptura() + "&X-dSS=" + varSesiones.getIntClienteWork()
                + "&X-eSS=" + varSesiones.getIntAnioWork() + "&X-fSS=" + varSesiones.getNumDigitos()
                + "&X-gSS=" + varSesiones.getIntIdPerfil() + "&X-hSS=" + varSesiones.getintIdCliente()
                + "&X-iSS=" + varSesiones.getIntSucursalDefault() + "&X-jSS=" + varSesiones.getStrLstSucursales()
                + "&X-kSS=" + varSesiones.getIntIdEmpresa();
        /*Objeto para generar el menu*/
        SuperFishMenu menu = new SuperFishMenu();
        out.clearBuffer();
        String strURLImg = "images/logo_erp.png";
        //Validacion para imprimir el logo del cliente
        if (!strPathImgEmp.equals("")) {
            strURLImg = strPathImgEmp;
        }
        strRazonSocial = strRazonSocial.replace("\"", "");
        //Definimos atributos globales para la base de datos
        if (oConn.getStrDriverName().contains("MySQL")) {
            oConn.runQuery("SET SESSION group_concat_max_len = 1000000;");
        }
%>
<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="robots" content="noindex, nofollow" />
        <title><bean:message key="gen.title"/></title>
        <link href="images/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
        <!--Version 1.9.0.min -->
        <!--<link rel="stylesheet" type="text/css" href="jqGrid/css/smoothness_1.10.4/jquery-ui-1.10.4.custom.min.css" />-->
        <!-- jquery ui -->
        <link rel="stylesheet" type="text/css" href="jquery-ui-1.12.1.cofide/jquery-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="jquery-ui-1.12.1.cofide/jquery-ui.structure.min.css" />
        <link rel="stylesheet" type="text/css" href="jquery-ui-1.12.1.cofide/jquery-ui.theme.min.css" />
        <!-- This is the multiselect file. It should be loaded after jqueryui and befor the grid  -->   
        <link rel="stylesheet" type="text/css" href="jqGrid/ui.multiselect.css"/>
        <!--JQGrid-->
        <link rel="stylesheet" type="text/css" href="jqGrid/ui.jqgrid4.7.0.css" />


        <link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
        <link rel="stylesheet" type="text/css" href="css/FishEyeMenu.css" />

        <!--superfish-->
        <link rel="stylesheet" type="text/css" href="css/superfish.css" media="screen" />


        <!--Version 1.9.0.min -->
        <script type="text/javascript" src="jqGrid/jquery-1.9.0.min.js" ></script>
        <script type="text/javascript" src="jqGrid/grid.locale-es4.7.0.js" ></script>
        
        <!--<script type="text/javascript" src="jqGrid/jquery-ui-1.10.4.custom.min.js" ></script>-->
        <!-- jquery ui -->
        <script type="text/javascript" src="jquery-ui-1.12.1.cofide/jquery-ui.min.js" ></script>
        <script type="text/javascript" src="jqGrid/jquery.layout-1.30.min.js"></script>
        <!-- This is the multiselect file. It should be loaded after jqueryui and befor the grid  -->   
        <script type="text/javascript" src="jqGrid/ui.multiselect.js"></script>
        <script type="text/javascript" src="jqGrid/jquery.jqGrid.min.4.7.0.js" ></script>

        <!--superfish-->
        <script type="text/javascript" src="jqGrid/jquery.hoverIntent.js"></script>
        <script type="text/javascript" src="jqGrid/superfish1.5.1.js"></script>
        <script type="text/javascript" src="jqGrid/supersubs.js"></script>
        <!--superfish-->
        <script type="text/javascript" src="jqGrid/jquery.maskedinput.1.3.1.js"></script>
        <!--Version 1.9.0 -->


        <!--hotkeys-->
        <script type="text/javascript" src="javascript/jquery.hotkeys-0.7.9.min.js"></script>
        <!--Picker-->
        <script type="text/javascript" src="jqGrid/ui.datepicker-es.js" ></script>
        <!--upload-->
        <script type="text/javascript" src="jqGrid/ajaxfileupload.js"></script>      

        <!--compatibilidad IE-->
        <script type="text/javascript" src="javascript/fixgetElementByIdIE.js"></script>
        <!--High Charts-->
        <script type="text/javascript" src="javascript/HighCharts4.0.4/highcharts-all.js"></script>
        <script type="text/javascript" src="javascript/HighCharts4.0.4/modules/exporting.js"></script>
        <script type="text/javascript" src="javascript/HighCharts4.0.4/modules/drilldown.js"></script>
        <!--High Charts-->

        <!--price Format-->
        <script type="text/javascript" src="jqGrid/jquery.formatCurrency-1.4.0.min.js"></script>
        <!--price Format-->

        <!--Custom Pages-->
        <script type="text/javascript" src="javascript/controlDom.js"></script>
        <script type="text/javascript" src="javascript/Cadenas.js"></script>
        <script type="text/javascript" src="javascript/Combos.js"></script>
        <script type="text/javascript" src="javascript/ValidaDato.js"></script>
        <script type="text/javascript" src="javascript/CIP_Config.js"></script>
        <script type="text/javascript" src="javascript/CIP_Main.js"></script>
        <script type="text/javascript" src="javascript/Ventanas.js"></script>
        <script type="text/javascript" src="javascript/CIP_Ventas.js"></script>
        <script type="text/javascript" src="javascript/FishEyeMenu.js"></script>
        <!--Ayuda-->
        <script type="text/javascript" src="javascript/vta_Ayuda.js"></script>
        <!--Ayuda-->
        <script type="text/javascript" src="javascript/vta_repo_formato.js"></script>
        <script type="text/javascript" src="javascript/vta_taxes.js"></script>
        <!--Pass-->
        <script type="text/javascript" src="javascript/CIP_PASS.js"></script>
        <script type="text/javascript" src="javascript/DomControlForm.js"></script>
        <script type="text/javascript" src="javascript/DomTablas.js"></script>
        <script type="text/javascript" src="javascript/reportes_jasper.js"></script>

        <!--Tutoriales en el sistema en línea -->
        <script type="text/javascript" src="jqGrid/jquery.joyride-2.1.js"></script>
        <link rel="stylesheet" type="text/css" href="css/joyride-2.1.css" />
        <!--Tutoriales en el sistema en línea -->
        <!-- Core and extension CSS files -->
        <link rel="stylesheet" media="screen" href="jqGrid/deck/core/deck.core.css">
        <link rel="stylesheet" media="screen" href="jqGrid/deck/extensions/goto/deck.goto.css">
        <link rel="stylesheet" media="screen" href="jqGrid/deck/extensions/menu/deck.menu.css">
        <link rel="stylesheet" media="screen" href="jqGrid/deck/extensions/navigation/deck.navigation.css">
        <link rel="stylesheet" media="screen" href="jqGrid/deck/extensions/status/deck.status.css">
        <link rel="stylesheet" media="screen" href="jqGrid/deck/extensions/scale/deck.scale.css">

        <!-- Style theme. More available in /themes/style/ or create your own. -->
        <!-- Deck Core and extensions -->
        <script src="jqGrid/deck/core/deck.core.js"></script>
        <script src="jqGrid/deck/extensions/menu/deck.menu.js"></script>
        <script src="jqGrid/deck/extensions/goto/deck.goto.js"></script>
        <script src="jqGrid/deck/extensions/status/deck.status.js"></script>
        <script src="jqGrid/deck/extensions/navigation/deck.navigation.js"></script>
        <script src="jqGrid/deck/extensions/scale/deck.scale.js"></script>
        <script src="jqGrid/deck/modernizr.custom.js"></script>

        <!-- Transition theme. More available in /themes/transition/ or create your own. -->
        <link rel="stylesheet" media="screen" href="jqGrid/deck/themes/transition/horizontal-slide.css">

        <script type="text/javascript" src="jqGrid/bootstrap/dropdown.js"></script>
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">

        <!--jstree-->
        <link rel="stylesheet" href="css/tree/default/style.min.css" />
        <!--jstree-->
        <script src="jqGrid/jstree.min.js"></script>

        <script type="text/javascript" src="javascript/dashboards.js"></script>


        <!-- Bootstrap CDN-->
        <!-- Latest compiled and minified CSS -->
        <!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">-->
        <!-- Optional theme -->
        <!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">-->
        <!-- Latest compiled and minified JavaScript -->
        <!--<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>-->
        <!--<link rel="stylesheet" href="jqGrid/SCEditor/square.css" type="text/css" media="all" />
        <script type="text/javascript" src="jqGrid/SCEditor/jquery.sceditor.bbcode.min.js"></script>-->
        <link type="text/css" rel="stylesheet" href="jqGrid/SCEditor/jquery-te-1.4.0.css">
        <script type="text/javascript" src="jqGrid/SCEditor/jquery-te-1.4.0.min.js" charset="utf-8"></script>
        <style type="text/css">
            .ui-layout-pane-center {
                padding:		0;
                padding:		15px;
                position:		relative; /* REQUIRED to contain the Datepicker Header */;
                <%if (strPruebas.equals("SI")) {%>
                background-image:url('images/Ambiente_de_pruebas.png');
                <%}%>
            }
            <%if (strPruebas.equals("SI")) {%>
            .ui-layout-north {
                background-image:url('images/Ambiente_de_pruebas.png');
            }

            <%}%>

            /* the 'fix' for the datepicker */
            #ui-datepicker-div { z-index: 5; }
        </style>
        <script type="text/javascript">
            //Lista de mensajes
            var strTitleAltas = "REGISTRO DE NUEVOS ";
            var strTitleBajas = "BORRAR ";
            var strTitleCambios = "MODIFICAR ";
            var strTitleImpresion = "IMPRESION DEL ";
            var strTitleImpresion2 = "Imprime";
            var strTitleImpresion3 = "Excel";
            var strMsgVal7 = "Necesita capturar los datos solicitados en el campo: ";
            var strMsgVal8 = "¿Confirme que desea borrar al ";
            var strMsgVal9 = " con los siguientes datos?";
            //Lista de variables
            var strRazonSocial = "<%=strRazonSocial%>";
            var intEMP_ID = "<%=intEMP_ID%>";
            var intEMP_TIPOCOMP = "<%=intEMP_TIPOCOMP%>";
            var intEMP_TIPOPERS = "<%=intEMP_TIPOPERS%>";
            var intEMP_NO_ISR = "<%=intEMP_NO_ISR%>";
            var intEMP_NO_IVA = "<%=intEMP_NO_IVA%>";
            var dblFacRetISR = 10;
            var dblFacRetIVA = 10;
            var intNumdecimal = 2;
            var intNumTabs = 0;
            var myLayout; // a var is required because this page utilizes: myLayout.allowOverflow() method
            var strTitlePanel = "SELECCIONAR TODO";
            var bolMuestraDiv = false;
            var intNumDigitos = <%=varSesiones.getNumDigitos() + ""%>;
            var strURLHelp = "http://www.solucionesinformaticasweb.com.mx/";
            var strPOST_Check = "<%=strPOST_Check%>";
            //Datos de la sucursal default
            var strNomSucursal = "<%=strNomSucursal%>";
            var strPrefCodBar = "<%=strPrefCodBar%>";
            var intSucDefa = "<%=varSesiones.getIntSucursalDefault()%>";
            var intSucursalMasterDefault = "<%=varSesiones.getIntSucursalMaster()%>";
            var dblTasa1 = "<%=dblTasa1%>";
            var dblTasa2 = "<%=dblTasa2%>";
            var dblTasa3 = "<%=dblTasa3%>";
            var intIdTasa1 = "<%=intIdTasa1%>";
            var intIdTasa2 = "<%=intIdTasa2%>";
            var intIdTasa3 = "<%=intIdTasa3%>";
            var intSImp1_2 = "<%=intSImp1_2%>";
            var intSImp1_3 = "<%=intSImp1_3%>";
            var intSImp2_3 = "<%=intSImp2_3%>";
            var intMonedaDefa = "<%=intMoneda%>";
            //Ofertas y promociones
            var intSucDefOfertas = <%=intSucDefOfertas == 1 ? true : false%>;
            var strHoyFecha = "<%=fecha.getFechaActualDDMMAAAADiagonal()%>";
            //Ofertas y promociones
            var intCteDefa = "<%=strCt_Id%>";
            var strUserName = "<%=varSesiones.getStrUser()%>";
            var logoMoneda = "<bean:message key="LogoMoneda"/>";
            var intPreciosconImp = <%=intPreciosconImp%>;
            var intImprimeTicket = "<%=intTicket%>";
            var strImpresora = "<%=strImpresora%>";
            var strCodEscape = "<%=strCodEscape%>";
            var d = document;//abreviacion para document
            $(document).ready(function () {
                myLayout = $('body').layout({
                    // enable showOverflow on west-pane so popups will overlap north pane
                    north__showOverflowOnHover: true/*,center__showOverflowOnHover: true*/
                            /* , east__fxSettings_open: {easing: "easeOutElastic", duration: 'slow'}*/
                    , north__fxSettings_open: {easing: "easeOutElastic", duration: 'slow'}
                });
                //myLayout.sizePane("east", 120);
                $("#dialog").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "blind", hide: "explode", width: "auto"});
                $("#dialog2").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "blind", hide: "explode", width: "auto"});
                $("#dialogTMK1").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "blind", hide: "explode", width: "auto"});
                $("#dialogTMK2").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "blind", hide: "explode", width: "auto"});
                $("#dialogTMK3").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "blind", hide: "explode", width: "auto"});
                $("#dialogPCaptura").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', width: "auto"});
                $("#dialogInv").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "blind", hide: "explode", position: 'top', width: "auto"});
                $("#SioNO").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
                $("#SioNO1").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
                $("#SioNO2").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
                $("#dialogWait").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
                $("#dialogWait2").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
                $("#dialogWaitProm").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
                $("#dialogCte").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogVend").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogProd").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogCon").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogPagos").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogDevo").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogView").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogMLM").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogPromociones").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogProv").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogHelp").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogMod").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogProveedores").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogCotiza").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: 'auto'});
                $("#dialogAceptar").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: 'auto'});
                $("#dialogCancelar").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogRepo").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogFiles").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                //******Prosefi
                $("#dialogFno").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogPar").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                $("#dialogAc").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
                //******Prosefi
                //******Grupo Mak
                $("#dlgMakMjs").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakMjsDeta").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakEstadoCnta").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakProductos").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top', height: 800});
                $("#dlgMakBusqProd").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakSubCte").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakBackOrder").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakExist").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakInformacion").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                $("#dlgMakHistrial").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "slide", hide: "explode", width: "auto", position: 'top'});
                //******Grupo Mak
                //Menu
                $("ul.sf-menu").supersubs({
                    minWidth:    12,   // minimum width of sub-menus in em units 
                    maxWidth:    27,   // maximum width of sub-menus in em units 
                    extraWidth:  1     // extra width can ensure lines don't sometimes turn over 
                            // due to slight rounding differences and font-family 
                }).superfish();  // call supersubs first, then superfish, so that subs are 
                                        // not display:none when measuring. Call before initialising 
                                        // containing tabs for same reason. 
                $("input:text").focus(function () {
                    $(this).select();
                });

                //DashBoards
                $("#d_fecha_ini").datepicker({
                    changeMonth: true,
                    changeYear: true
                });
                $("#d_fecha_fin").datepicker({
                    changeMonth: true,
                    changeYear: true
                });
                InitDashBoards();
                setInterval(blinker, 1000);
                setInterval(checker, 100999);
            });
            function blinker() {
                $('.blink_me').fadeOut(500);
                $('.blink_me').fadeIn(500);
            }
        </script>
        <!--Idioma-->
        <script type="text/javascript" src="javascript/vta_esmx.js"></script>
        <script type="text/javascript" src="javascript/cofide_telemarketing.js"></script>
        <!--Idioma-->
        <!--Chat en vivo-->
    </head>
    <body oncontextmenu="return false" onload=" MonitorioAgentes();">


        <div class="ui-layout-north" >
            <div class="ui-corner-all" id="superior">
                <img src="<%=strURLImg%>" height ="40" width="200" border="0" alt=""  title="" style="border: 0; vertical-align: middle;"/>

                <ul id="header_notifs">
                    <li id="notificaciones_main" class="blink_me" ><a href="javascript:LoadNotifMain()"><i class="fa fa-envelope-o">&nbsp;<span class="titles_main_1">Notificaciones</span></i></a></li>
                    <!--<li id="dashboard_main" ><a href="javascript:LoadDashBoardMain()"><i class="fa fa-cubes">&nbsp;<span class="titles_main_1">Tableros de control</span></i></a></li>
                    <li id="news_main" ><a href="javascript:LoadNewsMain()"><i class="fa fa-newspaper-o">&nbsp;<span class="titles_main_1">Noticias</span> </i></a></li>
                    <li id="help_main" ><a href="javascript:LoadAyudaMain()"><i class="fa fa-life-saver">&nbsp;<span class="titles_main_1">Ayuda</span></i></a></li>-->
                </ul>
                <ul id="users_control">
                    <li id="Avatar"><img src="images/avatar/user_defa-32.png" width="20" height="20" border="" alt="" title="" /> </li>
                    <li id="NameUser" style="font-size: 18px"><%=varSesiones.getStrUser()%></li>
                    <!--                     <li class="fa fa-share"><a href="ERP_SelEmpresa.jsp"><span class="titles_main_1">Cambiar empresa</span></a></li> -->
                    <li class="fa fa-sign-out" style="font-size: 18px"><a href="CIP_Salir.jsp"><span class="titles_main_1">Salir</span></a></li>
                </ul>
                    &nbsp;&nbsp;<span class="titulo_empresa" style="font-size: 30px"><%=strRazonSocial%></span>
            </div>
            <div id="superior_menu"> 
                <!--menu-->
                <ul class="sf-menu">
                    <%
                        /*Generamos el menu desde la base de datos y dependiendo de los permisos del usuario*/
                        String strMenu = menu.DrawMenu(oConn, request, response, varSesiones, this.getServletContext());
                        out.println(strMenu);
                    %>
                </ul>

                <!--menu-->
            </div>
        </div>

        <!-- allowOverflow auto-attached by option: west__showOverflowOnHover = true -->

        <!--<div class="ui-layout-east"></div>-->

        <div class="ui-layout-center" >
            <div id="rightPanel"></div>
            <div id="MainPanel">
                <jsp:include page="ERP_DashBoards.jsp" />
            </div>
        </div>
        <div id="dialog" title="Basic dialog">
            <div id="dialog_inside"></div>
        </div>
        <div id="dialog2" title="Basic dialog2">
            <div id="dialog2_inside"></div>
        </div>
        <div id="dialogTMK1" title="B">
            <div id="dialogTMK1_inside"></div>
        </div>
        <div id="dialogTMK2" title="">
            <div id="dialogTMK2_inside"></div>
        </div>
        <div id="dialogTMK3" title="B">
            <div id="dialogTMK3_inside"></div>
        </div>

        <div id="dialogPCaptura" title="Basic dialog2" >
            <div id="dialogPCaptura_inside" ></div>
        </div>
        <div id="dialogInv" title="">
            <div id="dialogInv_inside"></div>
        </div>
        <div id="dialogWait" title="<bean:message key="main.message44"/>">
            <div id="dialogWait_inside" align="center"><img src="images/ptovta/ajax-loader.gif" border="0" alt=""></div>
        </div>
        <div id="dialogWait2" title="<bean:message key="main.message44"/>">
            <div id="dialogWait2_inside" align="center"><img src="images/ptovta/ajax-loader.gif" border="0" alt=""></div>
        </div>
        <div id="dialogWaitProm" title="<bean:message key="main.message280"/>">
            <div id="dialogWaitProm_inside" align="center"><img src="images/ptovta/ajax-loader.gif" border="0" alt=""></div>
        </div>
        <div id="dialogCte" title="Catalogo de Cliente">
            <div id="dialogCte_inside"></div>
        </div>
        <div id="dialogVend" title="Catalogo de Vendedores">
            <div id="dialogVend_inside"></div>
        </div>
        <div id="dialogProd" title="Catalogo de Productos">
            <div id="dialogProd_inside"></div>
        </div>

        <div id="dialogPagos" title="Cobranza">
            <div id="dialogPagos_inside"></div>
        </div>
        <div id="dialogDevo" title="Devolución">
            <div id="dialogDevo_inside"></div>
        </div>
        <div id="dialogView" title="">
            <div id="dialogView_inside"></div>
        </div>
        <div id="dialogProv" title="">
            <div id="dialogProv_inside"></div>
        </div>           
        <div id="dialogMLM" title="">
            <div id="dialogMLM_inside"></div>
        </div>
        <div id="dialogPromociones" title="">
            <div id="dialogPromociones_inside"></div>
        </div>
        <div id="dialogMod" title="Modificar">
            <div id="dialogMod_inside"></div>
        </div>
        <div id="dialogCotiza" title="Cotizar partida">
            <div id="dialogCotiza_inside"></div>
        </div>
        <div id="dialogProveedores" title="Cotizar partida">
            <div id="dialogProveedores_inside"></div>
        </div>
        <div id="dialogAceptar" title="Aceptada">
            <div id="dialogAceptar_inside"></div>
        </div>
        <div id="dialogCancelar" title="Rechazada">
            <div id="dialogCancelar_inside"></div>
        </div>
        <div id="SioNO" title="">
            <input type="hidden" id="Operac" value="">
            <div id="SioNO_inside"></div>
            <table>
                <tr>
                    <td><input type="button" name="btnSI" id="btnSI" value="<bean:message key="main.message48"/>"></td>
                    <td><input type="button" name="btnNO" id="btnNO" value="<bean:message key="main.message49"/>"></td>
                </tr>
            </table>
        </div>
        <div id="SioNO1" title="">
            <input type="hidden" id="Operac" value="">
            <div id="SioNO_inside"></div>
            <table>
                <tr>
                    <td><input type="button" name="btnSI" id="btnSI1" value="<bean:message key="main.message48"/>"></td>
                    <td><input type="button" name="btnNO" id="btnNO1" value="<bean:message key="main.message49"/>"></td>
                </tr>
            </table>
        </div>

        <div id="SioNO2" title="">
            <input type="hidden" id="Operac" value="">
            <div id="SioNO_inside"></div>
            <table>
                <tr>
                    <td><input type="button" name="btnSI" id="btnSI2" value="<bean:message key="main.message48"/>"></td>
                    <td><input type="button" name="btnNO" id="btnNO2" value="<bean:message key="main.message49"/>"></td>
                </tr>
            </table>
        </div>
        <div id="dialogCon" title="Catalogo de Servicios">
            <div id="dialogCon_inside"></div>
        </div>
        <div id="dialogHelp" title="SiWebVentas-Ayuda Rapida">
            <div id="dialogHelp_inside"></div>
        </div>
        <!--Prosefi-->
        <div id="dialogFno" title="Catalogo de Funcionarios">
            <div id="dialogFno_inside"></div>
        </div>      
    </div>      
    <div id="dialogPar" title="Parametros Archivo">
        <div id="dialogPar_inside"></div>
    </div>        
    <div id="dialogAc" title="Actividad Economica">
        <div id="dialogAc_inside"></div>
    </div>  
    <div id="dialogRepo" title="Actividad Economica">
        <div id="dialogRepo_inside"></div>
    </div>  
    <div id="dialogFiles" title="">
        <div id="dialogFiles_inside"></div>
    </div>
    <!--Prosefi-->
    <iframe name="iframeUpload" style="display:none"></iframe>
    <div id="formHidden" style="display:none"></div>
    <!--GrupoMak-->
    <div id="dlgMakMjs" title="Mensajes">
        <div id="dlgMakMjs_inside"></div>
    </div>
    <div id="dlgMakMjsDeta" title="Mensajes Detalle">
        <div id="dlgMakMjsDeta_inside"></div>
    </div>
    <div id="dlgMakEstadoCnta" title="Estado de Cuenta">
        <div id="dlgMakEstadoCnta_inside"></div>
    </div>    
    <div id="dlgMakProductos" title="Productos">
        <div id="dlgMakProductos_inside"></div>
    </div>      
    <div id="dlgMakBusqProd" title="Busqueda Productos">
        <div id="dlgMakBusqProd_inside"></div>
    </div>  
    <div id="dlgMakSubCte" title="Subclientes">
        <div id="dlgMakSubCte_inside"></div>
    </div> 
    <div id="dlgMakBackOrder" title="BacOrder">
        <div id="dlgMakBackOrder_inside"></div>
    </div> 
    <div id="dlgMakExist" title="Existencias">
        <div id="dlgMakExist_inside"></div>
    </div> 
    <div id="dlgMakInformacion" title="Informacion">
        <div id="dlgMakInformacion_inside"></div>
    </div> 
    <div id="dlgMakHistrial" title="Historial">
        <div id="dlgMakHistrial_inside"></div>
    </div>     



    <!--AjaxError-->
    <div class="loading"></div>
    <div class="log"></div>
    <div id="help_fast"></div>
    <% if (intTicket == 1) {%>
<applet id="PrintTickets" code="com.mx.siweb.librerias.applets.Formato_Ticket" archive="applet/Impresion_ticket.jar" 
        style="width: 0px; height: 0px; float: left;" mayscript ></applet>
    <%}%>
<script type="text/javascript">
    $('.log').ajaxError(function (e, xhr, settings, exception) {
        getAjaxError(e, xhr, settings, exception)
    });
    $(".loading").bind("ajaxSend", function (e, xhr, settings, exception) {
        ajaxSendVal(e, xhr, settings, exception);
    });
</script>



</body>
</html>
<%

} else {
%>
<bean:message key="main.message46"/>
<jsp:forward page="/frmLogin.jsp"></jsp:forward>
<%         }
    oConn.close();
%>