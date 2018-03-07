<%-- 
    Document   : COFIDE_CursoMes
    Created on : 8/10/2016, 06:03:04 PM
    Author     : WizLion
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!-- 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="css/CIP_Cofide.css" />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
</head>
-->
<style>
    .headTable{
        padding-top: 0%;
    }
    table{
        font-size: 12px;
        width: 95%;
        padding-left: 10%;
        text-align: left;
        border-collapse: collapse;
        margin: auto;
        background-color: #E6E6E6;
    }
    .table1{
        border: black 3px solid;
    }
    .tr1{
        border: black 3px solid;
    }
    .td1{
        border: black 3px solid;
        padding: 10px;
    }
    .fecha{
        color:green;
    }
    .inTable{
        text-align: center;
    }
    .Curso{
        width: 40%;
    }
    .FechaCurso{
        width: 9%;
        font-size: 18px;
    }
    .DetalleCurso{
        width: 20%;
    }
    .CursosDisp{
        width: 10%;
    }
    .iconos{
        font-size: 25px;
    }
</style>
<body style="font-family: Verdana, Geneva, serif;">
    <div class="headTable">
        <table class="table1">
            <%
                /*Obtenemos las variables de sesion*/
                VariableSession varSesiones = new VariableSession(request);
                varSesiones.getVars();
                //Abrimos la conexion
                Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
                oConn.open();
                Fechas fec = new Fechas();
                SimpleDateFormat conver = new SimpleDateFormat("yyyyMMdd");
                SimpleDateFormat formatDiaLetra = new SimpleDateFormat("E. "); //obtener día de la semana
                SimpleDateFormat formatDia = new SimpleDateFormat("dd"); //obtener día en numero
                SimpleDateFormat formatMesAnio = new SimpleDateFormat("MMM,yyyy"); //obtener mes y año
                int intNFechas = 1;
                String strFechaIni = "";
                String strLiga = "";
                String strTipo = "";
                String strMes = request.getParameter("CACT_MES2");
                String strFechaActual = fec.getFechaActual();
                String strMesActual = strFechaActual.substring(4, 6);
                String strSQLNFecha = "";
                
                //valida si es tmk
                String strIsTMK = "select IS_TMK from usuarios where IS_TMK = 1 and id_usuarios = " + varSesiones.getIntNoUser();
                ResultSet rsTMK = oConn.runQuery(strIsTMK, true);
                boolean bolIsTMK = false;
                while (rsTMK.next()) {
                    bolIsTMK = true; //es telemarketing
                }
                rsTMK.close();
                //valida si es tmk
                
                if (strMes.equals(strMesActual)) { //si el curso seleccionado es el curso actual, muestra apartir del dia actual del mes
                    strSQLNFecha = "select count(CC_FECHA_INICIAL) as NFechas , CC_FECHA_INICIAL"
                            + " from cofide_cursos where CC_FECHA_INICIAL between '" + fec.getFechaActual() + "' and '" + fec.getAnioActual() + strMesActual + "31' GROUP BY CC_FECHA_INICIAL ORDER BY CC_FECHA_INICIAL";
                } else { //muestra el mes seleccionado, siempre y cuando no sea el actual
                    strSQLNFecha = "select count(CC_FECHA_INICIAL) as NFechas , CC_FECHA_INICIAL"
                            + " from cofide_cursos where CC_FECHA_INICIAL between '" + fec.getAnioActual() + strMes + "01' and '" + fec.getAnioActual() + strMes + "31' GROUP BY CC_FECHA_INICIAL ORDER BY CC_FECHA_INICIAL";
                }
                //obtenemos las fechas y cuantos cursos tiene
                ResultSet rsNFechas = oConn.runQuery(strSQLNFecha, true);
                while (rsNFechas.next()) {
                    //obtener los cursos de cada fecha
                    intNFechas = rsNFechas.getInt("NFechas");
                    strFechaIni = rsNFechas.getString("CC_FECHA_INICIAL");
                    Date date = conver.parse(strFechaIni);
            %>
            <tr class="tr1">
                <td class="fecha td1 FechaCurso" rowspan="<%=intNFechas%>">
                    <table class="inTable FechaCurso">
                        <tr><td><%=formatDiaLetra.format(date)%></td></tr>
                        <tr><td><%=formatDia.format(date)%></td></tr>
                        <tr><td><%=formatMesAnio.format(date)%></td></tr>
                    </table>
                </td>
                <%
                    String strSQL = "select *,"
                            + "(CC_MONTAJE - CC_INSCRITOS) as Disponibles,"
                            + "((select count(*) from vta_tickets where CC_CURSO_ID = cc.CC_CURSO_ID and TKT_COFIDE_PAGADO = 1) + "
                            + "(select count(*) from vta_facturas where CC_CURSO_ID = cc.CC_CURSO_ID and FAC_COFIDE_PAGADO = 1)) as Pagado,"
                            + "((select count(*) from vta_tickets where CC_CURSO_ID = cc.CC_CURSO_ID and TKT_COFIDE_PAGADO = 0) + "
                            + "(select count(*) from vta_facturas where CC_CURSO_ID = cc.CC_CURSO_ID and FAC_COFIDE_PAGADO = 0)) as Pendiente,"
                            + "(select CSH_COLOR from cofide_sede_hotel where CSH_ID = CC_SEDE_ID) as HCOLOR "
                            + "from cofide_cursos cc where CC_FECHA_INICIAL = '" + rsNFechas.getString("CC_FECHA_INICIAL") + "' order by CC_FECHA_INICIAL";
                    ResultSet rs = oConn.runQuery(strSQL, true);
                    while (rs.next()) {
                        if (rs.getString("CC_IS_SEMINARIO").equals("1") && rs.getString("CC_IS_DIPLOMADO").equals("0")) {
                            strTipo = "3";
                        }
                        if (rs.getString("CC_IS_SEMINARIO").equals("0") && rs.getString("CC_IS_DIPLOMADO").equals("1")) {
                            strTipo = "2";
                        } else {
                            strTipo = "1";
                        }
                        strLiga = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "") + rs.getString("CC_CURSO_ID") + strTipo;
                %>
                <td class="td1" style="background-color: <%=rs.getString("HCOLOR")%>;"></td>
                <td class="td1 Curso">
                    <a href="http://cofide.org/cofide2016/cofide_det.php?id_evento=<%=strLiga%>&screen=index" target="_blank">
                        <%=rs.getString("CC_NOMBRE_CURSO")%>
                    </a>
                </td>
                <td class="td1 DetalleCurso">
                    <table>
                        <tr><td><%=rs.getString("CC_INSTRUCTOR")%></td></tr>
                        <tr><td><i class="fa fa-clock-o"></i> <%=rs.getString("CC_SESION")%> Hrs. 
                                <br> 
                                <i class="fa fa-hourglass-half"></i> <%=rs.getString("CC_DURACION_HRS")%> Hrs.</td></tr>
                    </table>
                </td>
                <td class="td1 DetalleCurso">
                    <table>
                        <tr><td><i class="fa fa-user iconos"></i></td><td>$ <%=rs.getString("CC_PRECIO_PRES")%> + IVA <br>$ <%=rs.getString("CC_IVA_PRES")%></td></tr>
                        <tr><td><i class="fa fa-desktop iconos"></i></td><td>$ <%=rs.getString("CC_PRECIO_ON")%> + IVA <br>$ <%=rs.getString("CC_IVA_ON")%></td></tr>
                    </table>
                </td>
                <td class="td1 CursosDisp">
                    <table>
                        <tr><td><i class="fa fa-shopping-cart iconos" style="color: #00D827"> </i></td><td><%=rs.getString("CC_INSCRITOS")%></td></tr>
                        <tr><td><i class="fa fa-shopping-cart iconos" style="color: gray"> </i></td><td><%=rs.getString("Disponibles")%></td></tr>
                    </table>
                </td>
                <td class="td1 CursosDisp">
                    <table style="width: 115px">
                        <tr><td><i class="fa fa-usd iconos" style="color: #00D827"> </i></td><td><%=rs.getString("Pagado")%></td></tr>
                        <tr><td><i class="fa fa-usd iconos" style="color: gray"> </i></td><td><%=rs.getString("Pendiente")%></td></tr>
                    </table>
                </td>
                <%
                    if (!bolIsTMK) {
                %>
                <td class="td1">
                    <input style="button" value="Lista asistencia" onclick="OpnDetalleCurso(<%=rs.getString("CC_CURSO_ID")%>)" size="10px" class="btn btn-default btn-lg active" title="Lista asistencia">
                </td>
                <%
                    }
                %>
            </tr>
            <%
                    }
                    rs.close();
                }
                rsNFechas.close();
            %>
        </table>
    </div>
</body>
<%    oConn.close();
%>
