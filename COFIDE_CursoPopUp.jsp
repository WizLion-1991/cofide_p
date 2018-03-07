<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<!DOCTYPE html>

<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    Fechas fec = new Fechas();
    ResultSet rs;
    String strCurso = "";
    String strFecha = "";
    String strSede = "";
    String NParticipante = "0";
    String strPresencial = "0";
    String strOnline = "0";
    int intEquipoA = 0; //a = 1
    int intEquipoB = 0; //d = 2
    int intEquipoC = 0; //e = 3
    String strIdCurso = request.getParameter("id");
    String strSqlInfCurso = "select CC_CURSO_ID, CC_NOMBRE_CURSO, CC_FECHA_INICIAL, CC_IS_PRESENCIAL,CC_IS_ONLINE, "
            + "(select CSH_SEDE from cofide_sede_hotel where CSH_ID = CC_SEDE_ID) as SEDE, CC_INSCRITOS "
            + "from cofide_cursos where cc_curso_id = " + strIdCurso;
    rs = oConn.runQuery(strSqlInfCurso, true);
    while (rs.next()) {
        strCurso = rs.getString("CC_NOMBRE_CURSO");
        strFecha = rs.getString("CC_FECHA_INICIAL");
        strSede = rs.getString("SEDE");
        NParticipante = rs.getString("CC_INSCRITOS");
        strPresencial = rs.getString("CC_IS_PRESENCIAL");
        strOnline = rs.getString("CC_IS_ONLINE");
    }
    rs.close();
    if (strPresencial.equals("1")) {
        strPresencial = "Presencial";
    }
    if (strOnline.equals("1")) {
        strPresencial += " / OnLine";
    }
    String strEquipos = "select (select US_GRUPO from usuarios where id_usuarios = FAC_US_ALTA) as equipo from view_ventasglobales where CC_CURSO_ID = " + strIdCurso;
    rs = oConn.runQuery(strEquipos, true);
    while (rs.next()) {
        if (rs.getString("equipo").equals("1")) {
            intEquipoA += 1;
        }
        if (rs.getString("equipo").equals("2")) {
            intEquipoB += 1;
        }
        if (rs.getString("equipo").equals("3")) {
            intEquipoC += 1;
        }
    }
    rs.close();
    String strSql = "select CT_ID, "
            + "concat(CP_NOMBRE,' ',CP_APPAT,' ',CP_APMAT) as Nombre, "
            + "(select FAC_ID from view_ventasglobales where CC_CURSO_ID = CP_ID_CURSO and view_ventasglobales.CT_ID = p.CT_ID limit 1) as FAC_ID,"
            + "(select FAC_PAGADO from view_ventasglobales where CC_CURSO_ID = CP_ID_CURSO and view_ventasglobales.CT_ID = p.CT_ID limit 1) as Estatus, "
            + "(select (select nombre_usuario from usuarios where id_usuarios = FAC_US_ALTA) from view_ventasglobales where CC_CURSO_ID = CP_ID_CURSO and view_ventasglobales.CT_ID = p.CT_ID limit 1) as Agente "
            + "from cofide_participantes as p where cp_id_curso = " + strIdCurso;

%>
<head>
    <!--Version 1.9.0.min -->
    <script type="text/javascript" src="jqGrid/jquery-1.9.0.min.js" ></script>
    <script type="text/javascript" src="jqGrid/grid.locale-es4.7.0.js" ></script>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script type="text/javascript" src="javascript/cofide_curso_activo.js"></script> <!-- importar archivo javascript--> 
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">   
    <script type="text/javascript" src="javascript/Ventanas.js"></script>
    <!-- script de grafica -->
    <title>
        Participantes del Curso <%=strCurso%>
    </title>
</head>
<style>
    .imagen{
        background-color: black;
        width: 100%;
        height: 20%;
    }
    .TituloDetalle{
        text-align: center;
        font-size: 18px;
    }
    .Detalles{
        padding-left: 10%;
    }
    .Detalles2{
        padding-left: 20%;
    }
    table{
        border-collapse: collapse;
        margin: auto;
        /*background-color: #E6E6E6;*/
        border: black 3px solid;
        width: 80%;
    }
    thead{
        background-color: black;
        color: #C6D880;
        display: block;
    }
    tbody{
        /*background-color: #C6D880;*/
        display: block;
        height: 300px;
        overflow-y: auto;
        overflow-x: hidden;
    }
    tr{
        border: black 3px solid;
    }
    td{
        border: black 3px solid;
        padding: 10px;
    }
    th{
        border: black 3px solid;
        padding: 10px;
        text-align: center;
    }

    table th:first-child{
        width: 90px;
    }
    table th:nth-child(2){
        width: 200px;
    }
    table th:nth-child(3){
        width: 300px;
    }
    table th:nth-child(4){
        width: 200px;
    }
    table th:nth-child(5){
        width: 300px;
    }
    table th:nth-child(6){
        width: 100px;
    }

    table td:first-child{
        width: 90px;
    }
    table td:nth-child(2){
        width: 200px;
    }
    table td:nth-child(3){
        width: 300px;
    }
    table td:nth-child(4){
        width: 200px;
    }
    table td:nth-child(5){
        width: 300px;
    }
    table td:nth-child(6){
        width: 100px;
    }

    .idcurso{
        width: 20%;
    }
    .tipocurso{
        width: 40%;
    }
    .nombre{
        width: 50%;
    }
    .estatus{
        width: 40%;
    }
    .ejecutivo{
        width: 40%;
    }
    .nfactura{
        width: 20%;
    }

</style>
<body onload="DrawGraphic(<%=strIdCurso%>,<%=intEquipoA%>,<%=intEquipoB%>,<%=intEquipoC%>)">
    <div>
        <div class="TituloDetalle">
            <div class=" imagen">
                <div style="padding-left: 4%">
                    <img src="images/cofide.png" style="width: 30%; padding-top: 2%">
                </div>
            </div>
            <h3><p>PARTICIPANTES DEL CURSO</p></h3>
            <div>
            </div>

        </div>
        <div class="row">
            <div class="col-md-4  Detalles">
                <div>
                    <h5>Curso: <b><%=strCurso%></b></h5>
                </div>
                <div>
                    <h5>Fecha: <b><%=fec.FormateaDDMMAAAA(strFecha, "/")%></b></h5>
                </div>
                <div>
                    <h5>Sede: <b><%=strSede%></b></h5>
                </div>
                <div>
                    <h5>Nº. Participantes: <b><%=NParticipante%></b></h5>
                </div>
                <div>
                    <input type="button" value="Exportar a Excel" class="btn btn-default btn-lg active" onclick="openRepCurso(<%=strIdCurso%>)">
                </div>
            </div>
                <!--
            <div class="col-md-4 Detalles2">
                <div>
                    <p>Ventas por equipo</p>
                    <div id="cofide_grafica<%=strIdCurso%>" style="width: 400px; height: 300"></div>
                </div>
            </div> 
                -->
        </div>
        <hr>
        <div>
            <table>
                <thead>
                    <tr>
                        <th class="idcurso">ID Cliente</th>
                        <th class="tipocurso">Tipo</th>
                        <th class="nombre">Nombre Completo</th>
                        <th class="estatus">Estatus</th>
                        <th class="ejecutivo">Ejecutivo</th>
                        <th class="nfactura">Nº. Factura</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            String strEstatus = "";
                            if (rs.getString("Estatus").equals("1")) {
                                strEstatus = "Pagado";
                            } else {
                                strEstatus = "Pendiente";
                            }
                    %>
                    <tr>
                        <td><%=rs.getString("CT_ID")%></td>
                        <td><%=strPresencial%></td>
                        <td><%=rs.getString("Nombre")%></td>
                        <td><%=strEstatus%></td>
                        <td><%=rs.getString("Agente")%></td>
                        <td><%=rs.getString("FAC_ID")%></td>
                    </tr>
                    <%
                        }
                        rs.close();
                    %>
                </tbody>
            </table>
        </div>
        <div>
            <hr>
        </div>
    </div>
</body>
</html>