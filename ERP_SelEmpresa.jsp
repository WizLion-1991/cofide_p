<%-- 
    Document   : ERP_SelEmpresa
    Created on : 4/12/2010, 04:09:43 PM
    Author     : zeus
--%>
<%

//Obtenemos la lista de empresas
    String strLstEmp = "";
%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        out.clearBuffer();//Limpiamos buffer
        atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
        strLstEmp += "<option value='0'></option>";
        //Buscamos las empresas definidas para este usuario
        String strSql = "select vta_empresas.EMP_ID,vta_empresas.EMP_RAZONSOCIAL,vta_empresas.EMP_RFC "
                + " from  vta_userempresa,vta_empresas where "
                + " vta_userempresa.EMP_ID = vta_empresas.EMP_ID "
                + " and id_usuarios = " + varSesiones.getIntNoUser() + " ";
        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            strLstEmp += "<option value='" + rs.getInt("EMP_ID") + "'>"
                    + rs.getInt("EMP_ID") + ".-"
                    + rs.getString("EMP_RAZONSOCIAL") + "</option>";
        }
        rs.close();
        //Evaluamos si tiene opcion de seleccionar la sucursal
        int intSelSucursal = 0;
        strSql = "select US_SEL_SUCURSAL from usuarios where id_usuarios =  " + varSesiones.getIntNoUser();
        rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            intSelSucursal = rs.getInt("US_SEL_SUCURSAL");
        }
        rs.close();

        //Buscamos las empresas definidas para este usuario
        boolean bolModoDemo = false;
        strSql = "select modo_demo from cuenta_contratada";
        rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            if (rs.getInt("modo_demo") == 1) {
                bolModoDemo = true;
            }
        }
        rs.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="robots" content="noindex, nofollow">
        <title><bean:message key="gen.title" /></title>
        <link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
        <link rel="stylesheet" type="text/css" href="jqGrid/css/smoothness_1.10.4/jquery-ui-1.10.4.custom.min.css" />
        <script type="text/javascript" src="jqGrid/jquery-1.9.0.min.js" ></script>
        <script src="jqGrid/jquery-ui-1.10.4.custom.min.js" type="text/javascript"></script>
        <script type="text/javascript" src="javascript/controlDom.js"></script>
        <script type="text/javascript" src="javascript/Cadenas.js"></script>
        <script type="text/javascript" src="javascript/Combos.js"></script>
        <link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
        <!--Tutoriales en el sistema en línea -->
        <script type="text/javascript" src="jqGrid/jquery.joyride-2.1.js"></script>
        <link rel="stylesheet" type="text/css" href="css/joyride-2.1.css" />
        <!--Tutoriales en el sistema en línea -->
    </head>
    <body oncontextmenu="return false">
    <center>

        <div id="portada">
            <div id="letreros">
                <h1>
                    <a href="http://www.solucionesinformaticasweb.com.mx/">
                        <img src="images/fondo_erp_small.png" width="400" height="" border="0 " />
                    </a>
                </h1>
                <h3>Ver 2.2015</h3>
                <form id="frmEmpresa" name="frmEmpresa" action="MainDo.do" method="post">
                    <table border=0 width="0%" cellpadding="1" class="table2" align="center">

                        <tr>
                            <td align="center" colspan="2"><bean:message key="acceso.title6"/></td>
                        </tr>
                        <tr><td align="center" colspan="2">
                                <%if (intSelSucursal == 0) {%>
                                <!--OPCION 1 seleccion de empresa y bodega-->
                        <tr>
                            <td > <bean:message key="acceso.title7"/></td>
                        </tr>
                        <tr>
                            <td >
                                <span class="input-group-addon">
                                    <i class="fa fa-group"></i>
                                </span>
                                <select id="EMP_ID" name="EMP_ID" onchange="RefreshBodegas()"><%=strLstEmp%></select>
                            </td>
                        </tr>
                        <tr><td> <bean:message key="acceso.title8"/></td></tr>
                        <tr><td>
                                <span class="input-group-addon">
                                    <i class="fa fa-truck"></i>
                                </span>
                                <select id="SC_ID" name="SC_ID"></select>
                            </td></tr>
                            <%} else {%>
                        <!--OPCION 2 seleccion de empresa, sucursal y bodega -->
                        <tr><td align="center"> <bean:message key="acceso.title7"/></td><td align="center">
                                <span class="input-group-addon">
                                    <i class="fa fa-group"></i>
                                </span>
                                <select id="EMP_ID" name="EMP_ID" onchange="RefreshSucursales()"><%=strLstEmp%></select>
                            </td></tr>
                        <tr><td align="center"> Sucursal</td><td align="center">
                                <span class="input-group-addon">
                                    <i class="fa fa-truck"></i>
                                </span>
                                <select id="SM_ID" name="SM_ID" onchange="RefreshBodegasSuc()"></select>
                            </td></tr>
                        <tr><td align="center"> <bean:message key="acceso.title8"/></td><td align="center">
                                <select id="SC_ID" name="SC_ID"></select>
                            </td></tr>
                            <%}%>
                        <tr><td align="center" colspan="2">
                                <input type="button" value="Continuar" styleClass="btn btn-default btn-lg btn-block ladda-button" onClick="ValidaEnvio();" />
                            </td></tr>
                    </table>
                </form>

                <p class="note">Desarrollado por Soluciones Informaticas Web</p>
            </div>


        </div>
    </center> 
    <script language="javascript">
        //Ponemos el foco default
        document.getElementById("EMP_ID").focus();
        //Valida el envio
        function ValidaEnvio() {
            var objEmp = document.getElementById("EMP_ID");
            var objSuc = document.getElementById("SC_ID");
            if (parseInt(objEmp.value) == 0) {
                alert("Le falta seleccionar una empresa");
            } else {
                if (objSuc.value == "") {
                    alert("Le falta seleccionar una bodega");
                } else {
                    if (parseInt(objSuc.value) == 0) {
                        alert("Le falta seleccionar una bodega");
                    } else {
                        document.getElementById("frmEmpresa").submit();
                    }
                }
            }
        }
        //Regresa las bodegas en base a la empresa
        function RefreshBodegas() {
            $("#dialogWait").dialog("open");
            var strPOST = "EMP_ID=" + document.getElementById("EMP_ID").value;
            $.ajax({
                type: "POST",
                data: strPOST,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "ERP_Sucursales.jsp?id=5",
                success: function (datos) {
                    var objsF = datos.getElementsByTagName("Bodegas")[0];
                    var lstBodega = objsF.getElementsByTagName("Bodega");
                    var sel = document.getElementById("SC_ID");
                    select_clear(sel);
                    for (i = 0; i < lstBodega.length; i++) {
                        var obj = lstBodega[i];
                        select_add(sel, obj.getAttribute('nombre'), obj.getAttribute('id'));
                    }
                    $("#dialogWait").dialog("close");

                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
                }
            });
        }

        function RefreshSucursales() {
            $("#dialogWait").dialog("open");
            var strPOST = "EMP_ID=" + document.getElementById("EMP_ID").value;
            $.ajax({
                type: "POST",
                data: strPOST,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "ERP_Sucursales.jsp?id=6",
                success: function (datos) {
                    var objsF = datos.getElementsByTagName("Sucursales")[0];
                    var lstBodega = objsF.getElementsByTagName("Sucursal");
                    var sel = document.getElementById("SM_ID");
                    select_clear(sel);
                    //Limpiamos las bodegas
                    var selBodegas = document.getElementById("SC_ID");
                    select_clear(selBodegas);
                    //Llenamos las sucursales
                    select_add(sel, "SELECCIONE", 0);
                    if (﻿lstBodega.length == 0) {
                        //No hay sucursales definidas cargamos todas las bodegas
                        RefreshBodegas();
                    } else {
                        for (i = 0; i < lstBodega.length; i++) {
                            var obj = lstBodega[i];
                            select_add(sel, obj.getAttribute('nombre'), obj.getAttribute('id'));
                        }

                    }
                    $("#dialogWait").dialog("close");

                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
                }
            });
        }

        function RefreshBodegasSuc() {
            $("#dialogWait").dialog("open");
            var strPOST = "SM_ID=" + document.getElementById("SM_ID").value;
            $.ajax({
                type: "POST",
                data: strPOST,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "ERP_Sucursales.jsp?id=7",
                success: function (datos) {
                    var objsF = datos.getElementsByTagName("Bodegas")[0];
                    var lstBodega = objsF.getElementsByTagName("Bodega");
                    var sel = document.getElementById("SC_ID");
                    select_clear(sel);
                    for (i = 0; i < lstBodega.length; i++) {
                        var obj = lstBodega[i];
                        select_add(sel, obj.getAttribute('nombre'), obj.getAttribute('id'));
                    }
                    $("#dialogWait").dialog("close");

                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
                }
            });
        }
    </script>

    <ol id="chooseID" class="joyRideTipContent">
        <li data-id="EMP_ID" data-button="Siguiente">
            <h2>Paso #1</h2>
            <p>Seleccione la empresa con la que desea trabajar</p>
        </li>
        <%if (intSelSucursal == 0) {%>
        <li data-id="SC_ID" data-button="Siguiente">
            <h2>Paso #2</h2>
            <p>Seleccione la bodega con la que desea trabajar</p>
        </li>
        <%} else {%>
        <!--OPCION 2 seleccion de empresa, sucursal y bodega -->
        <li data-id="SM_ID" data-button="Siguiente">
            <h2>Paso #2</h2>
            <p>Seleccione la sucursal con la que desea trabajar</p>
        </li>
        <li data-id="SC_ID" data-button="Siguiente">
            <h2>Paso #3</h2>
            <p>Seleccione la bodega con la que desea trabajar</p>
        </li>
        <%} %>         
    </ol>
    <%if (bolModoDemo) { %>
    <script>
        $(window).load(function () {
            $('#chooseID').joyride({
                autoStart: true,
                postStepCallback: function (index, tip) {
                },
                modal: true,
                expose: true
            });
        });
    </script>
    <%} %>
</body>
</html>
<%

    } else {
    }
    oConn.close();
%>
