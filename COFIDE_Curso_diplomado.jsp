<%-- 
    Document   : COFIDE_Curso_diplomado
    Created on : 16-mar-2016, 10:53:09
    Author     : juliocesar
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
<link rel="stylesheet" type="text/css" href="css/CIP_Cofide.css" />
<script type="text/javascript" src="cofide_curso_activo.js"></script>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
//    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    UtilXml util = new UtilXml();
    Fechas fec = new Fechas();

//    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
    String strFecha = "";
    String strCurso = "";
    String strInstructor = "";
    String strHrIni = "";
    String strHrFin = "";
    String strDuracion = "";
    String strSede = "";
    String strPresencial = "";
    String strPrecioPre = "";
    String strIvaPres = "";
    String strOnLine = "";
    String strPrecioOn = "";
    String strIvaOn = "";
    String strDia = "";
    String strMes = "";
    String MesLetra = "";
    String strAño = "";
    String FechaActual = fec.getFechaActual();
    String strDisponible = "";
    String strVendidos = "";
    String strSql = "select * from cofide_cursos where CC_FECHA_INICIAL >= " + FechaActual + " and cc_is_diplomado = 1 order by CC_FECHA_INICIAL";
    ResultSet rs = oConn.runQuery(strSql, true);
    while (rs.next()) {
        strFecha = rs.getString("CC_FECHA_INICIAL");
        strDia = strFecha.substring(6, 8);
        strMes = strFecha.substring(4, 6);
        int intMes = Integer.parseInt(strMes);
        strAño = strFecha.substring(0, 4);
        if (intMes == 1) {
            MesLetra = "ENERO";
        }
        if (intMes == 2) {
            MesLetra = "MARZO";
        }
        if (intMes == 3) {
            MesLetra = "MARZO";
        }
        if (intMes == 4) {
            MesLetra = "ABRIL";
        }
        if (intMes == 5) {
            MesLetra = "MAYO";
        }
        if (intMes == 6) {
            MesLetra = "JUN";
        }
        if (intMes == 7) {
            MesLetra = "JUL";
        }
        if (intMes == 8) {
            MesLetra = "AGOS";
        }
        if (intMes == 9) {
            MesLetra = "SEPT";
        }
        if (intMes == 10) {
            MesLetra = "OCT";
        }
        if (intMes == 11) {
            MesLetra = "NOV";
        }
        if (intMes == 12) {
            MesLetra = "DIC";
        }
        strCurso = rs.getString("CC_NOMBRE_CURSO");
        strInstructor = rs.getString("CC_INSTRUCTOR");
        strHrIni = rs.getString("CC_HR_EVENTO_INI");
        strHrFin = rs.getString("CC_HR_EVENTO_FIN");
        strDuracion = rs.getString("CC_DURACION_HRS");
        strSede = rs.getString("CC_SEDE");
        strPresencial = rs.getString("CC_IS_PRESENCIAL");
        int Presen = Integer.parseInt(strPresencial);
        if (Presen > 0) {
            strPresencial = "PRESENCIAL";
            strPrecioPre = rs.getString("CC_PRECIO_PRES");
            strIvaPres = rs.getString("CC_IVA_PRES");
        } else {
            strPresencial = "NO DISPONIBLE";
            strPrecioPre = "";
            strIvaPres = "";
        }

        strOnLine = rs.getString("CC_IS_ONLINE");
        int Online = Integer.parseInt(strOnLine);
        if (Online > 0) {
            strOnLine = "ON LINE";
            strPrecioOn = rs.getString("CC_PRECIO_ON");
            strIvaOn = rs.getString("CC_IVA_ON");
        } else {
            strOnLine = "ONLINE NO DISPONIBLE";
            strPrecioOn = "";
            strIvaOn = "";
        }
        strVendidos = rs.getString("CC_INSCRITOS");
        strDisponible = rs.getString("DISPONIBLES");
%>
<center>
    <table width="100%" cellspacing="0" cellpadding=30" border="5">
        <td width="10%" valign="middle">
            <table width="30" cellspacing="0" cellpadding="0" border="0">
                <tr>
                    <td class="fecha" align="center"><%="DIA" + " " + strDia%></td>
                </tr>
                <tr>
                    <td class="fecha decora02" align="center" colspan="2"><%=MesLetra + " ," + strAño%></td>
                </tr>
            </table>
        </td>
        <td width="45%">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <tr>
                    <td class="curso decora02"><%=strCurso%></td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td class="detalle decora02"><%=strInstructor%></td>
                            </tr>
                            <tr>
                                <td class="detalle">
                                    Sesion: <%=strHrIni + " A " + strHrFin + " HRS. || DURACION: " + strDuracion + " HRS. || "%>
                                    <br>
                                    <%=strSede%>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td width="15%" valign="middle" align="right">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <tr>
                    <td class="detalle decora02"><%=strPresencial%></td>
                </tr>
                <tr>
                    <td class="detalle decora02"><%="$ " + strPrecioPre%></td>
                </tr>
                <tr>
                    <td class="detalle decora02"><%="+ IVA $ " + strIvaPres%></td>
                </tr>
                <tr>
                    <td class="detalle decora02"><%=strOnLine%></td>
                </tr>
                <tr>
                    <td class="detalle decora02"><%="$ " + strIvaOn%></td>
                </tr>
                <tr>
                    <td class="detalle decora02"><%="+ IVA $ " + strIvaOn%></td>
                </tr>
            </table>
        </td>
        <td width="10%" valign="middle" align="right">
            <table>
                <tbody>
                    <tr>
                        <td class="detalleCurso decora02"> Disponibles: <%=strDisponible%> Lugares</td>
                    </tr>
                    <tr>
                        <td class="detalleCurso decora02"> Vendidos: <%=strVendidos%> Lugares </td>
                    </tr>
                </tbody>
            </table>
        </td>
    </table>
</center>
<%                                    }
    rs.close();
    oConn.close();
%>