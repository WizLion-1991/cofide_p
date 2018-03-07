<%-- 
    Document   : COFIDE_Calendario_cursos
    Created on : 12-abr-2016, 13:09:57
    Author     : juliocesar
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<!DOCTYPE html>
<head>
    <title>Calendario de Cursos</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script type="text/javascript" src="javascript/cofide_curso_activo.js"></script> <!-- importar archivo javascript--> 
    <link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
    <link rel="stylesheet" type="text/css" href="css/CIP_Cofide.css" />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script>
        $(function () {
            $("#tabs").tabs();
        });

    </script>
    <style>
        .imagen{
            background-color: black;
            width: 100%;
            height: 20%;
        }

        .fondoMenu{
            background: gray;
        }
        .fondoMenu:hover{
            background: black;
        }
        .iconos{
            font-size: 5px;
        }
    </style>
</head>
<body style="font-family: Verdana, Geneva, serif;">
    <div>
        <div class="row">
            <div class="col-md-4 imagen">
                <div style="padding-left: 40%">
                    <img src="images/cofide.png" style="width: 220px; padding-top: 3%">
                </div>
            </div>
        </div>
    </div>
    <div style="background: url('images/cofide_bgn.png'); background-size: 100%">
        <div class="row" style="height: 15%">
            <div class="col-md-4 inline-block">
                <div class="col-md-4" style="font-size: 11px"><i class="fa fa-circle iconos" style="color: #0bd7de"></i>Sur</div>
                <div class="col-md-4" style="font-size: 11px"><i class="fa fa-circle iconos" style="color: #560dce"></i>Fiesta Inn Queretaro</div>
                <div class="col-md-4" style="font-size: 11px"><i class="fa fa-circle iconos" Style=" color: #46c13a"></i>Hotel Four Points</div>
            </div>
            <div class="col-md-4 inline-block" style="padding-left: 10%">
                <H1><B>Calendario</B></H1>
            </div>
            <div class="col-md-4 inline-block">
                <div class="col-md-4" style="font-size: 11px"><i class="fa fa-circle iconos" style="color: #afafaf"></i>Puebla Hollyday Inn</div>
                <div class="col-md-4" style="font-size: 11px"><i class="fa fa-circle iconos" style="color: #de5b0b"></i>Crowne Plaza Tlalnepantla</div>
                <div class="col-md-4" style="font-size: 11px"><i class="fa fa-circle iconos" style="color: #eb223e"></i>Benidorm</div>
            </div>
        </div>
    </div>
    <div id="tabs" style="border: none; background: url('images/cofide_bgn.png'); background-size: 100%">
        <ul style="background: transparent; border: none; padding-left: 4%;">
            <li><a href="#tabs-1" style="color: white" class="fondoMenu">Todos</a></li>
            <li><a href="#tabs-2" style="color: white" class="fondoMenu">Mes</a></li>
            <li><a href="#tabs-3" style="color: white" class="fondoMenu">Sede</a></li>
            <li><a href="#tabs-4" style="color: white" class="fondoMenu">Tipo</a></li>
            <li><a href="#tabs-5" style="color: white" class="fondoMenu">Diplomados y Seminarios</a></li>
            <li><a href="#tabs-6" style="color: white" class="fondoMenu">Búsqueda</a></li>
        </ul>
        <div style="padding-left: 80%">
            <B>
                Disponibilidad
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                Pagos
            </B>
        </div>
        <div id="tabs-1">
            <%@include  file = "COFIDE_CursoCalendario.jsp" %>
            <div id="CACT_TODO1"> </div>
        </div>
        <div id="tabs-2">
            <div id="CACT_MES2" style="padding-left: 4%">
                <%                    String strNumMes = "";
                    String strNomMes = "";
                    String strFechaActual = fec.getFechaActual();
                    int intMesActual = Integer.parseInt(strFechaActual.substring(4, 6)); //mes actual
                    for (int i = intMesActual; i <= 12; i++) {
                        if (i == 1) {
                            strNumMes = "01";
                            strNomMes = "Enero";
                        }
                        if (i == 2) {
                            strNumMes = "02";
                            strNomMes = "Febrero";
                        }
                        if (i == 3) {
                            strNumMes = "03";
                            strNomMes = "Marzo";
                        }
                        if (i == 4) {
                            strNumMes = "04";
                            strNomMes = "Abril";
                        }
                        if (i == 5) {
                            strNumMes = "05";
                            strNomMes = "Mayo";
                        }
                        if (i == 6) {
                            strNumMes = "06";
                            strNomMes = "Junio";
                        }
                        if (i == 7) {
                            strNumMes = "07";
                            strNomMes = "Julio";
                        }
                        if (i == 8) {
                            strNumMes = "08";
                            strNomMes = "Agosto";
                        }
                        if (i == 9) {
                            strNumMes = "09";
                            strNomMes = "Septiembre";
                        }
                        if (i == 10) {
                            strNumMes = "10";
                            strNomMes = "Octubre";
                        }
                        if (i == 11) {
                            strNumMes = "11";
                            strNomMes = "Noviembre";
                        }
                        if (i == 12) {
                            strNumMes = "12";
                            strNomMes = "Diciembre";
                        }
                %>
                <input id="btnDip" class="btn btn-default btn-lg active" type="button" value="<%=strNomMes%>" onclick="loadMesScreen(<%=strNumMes%>)">
                <%
                    } // fin for
                %>
            </div>
            <div id="CACT_MES1"> </div>
        </div>
        <div id="tabs-3">
            <div id="CACT_SEDE2" style="padding-left: 4%">
                <%
                    oConn.open();
                    String strSedes = "";
                    //String strIdSedes = "";
                    String strSqlSede = "select distinct CC_ALIAS from cofide_cursos where CC_FECHA_INICIAL >= '" + fec.getFechaActual() + "' "
                            + "and CC_ALIAS <> '' order by CC_ALIAS";
                    ResultSet rsSede = oConn.runQuery(strSqlSede, true);
                    while (rsSede.next()) {
//                        strIdSedes = rsSede.getString("CC_SEDE_ID");
                        strSedes = rsSede.getString("CC_ALIAS");
                %>
                <input id="btnSede" type="button" class="btn btn-default btn-lg active" value="<%=strSedes%>" onclick="loadSedeScreen(<%='\'' + strSedes + '\''%>)">
                <%
                    }
                    rsSede.close();
                %>
            </div>
            <div id="CACT_SEDE1"></div>
        </div>
        <div id="tabs-4">
            <div id="btnTipo" style="padding-left: 3%">
                <input id="btnTipo" class="btn btn-default btn-lg active" type="button" value="PRESENCIAL" onclick="loadTipoScreen(' CC_IS_PRESENCIAL = 1')">
                <input id="btnTipo" class="btn btn-default btn-lg active" type="button" value="ONLINE" onclick="loadTipoScreen(' CC_IS_ONLINE = 1')">
                <input id="btnTipo" class="btn btn-default btn-lg active" type="button" value="VIDEO" onclick="loadTipoScreen(' CC_IS_VIDEO = 1')">
            </div>
            <div id="CACT_TIPO1"> </div>
        </div>
        <div id="tabs-5">            
            <jsp:include page="COFIDE_CursoDipSem.jsp"/>
            <div id="CACT_SEMI1"> </div>
        </div>
        <div id="tabs-6">
            <div id="buscar" style="padding-left: 3%">
                <input id="Buscar" type="text" width="50px" size="50">
                <input id="btnBuscar" class="btn btn-default btn-lg active" type="button" value="Consultar Cursos" onclick="BuscarCurso()"></div>
            <br>
            <div id="CACT_CURSOS"> </div>
        </div>
    </div>
</body>
</html>
<%
    oConn.close();
%>