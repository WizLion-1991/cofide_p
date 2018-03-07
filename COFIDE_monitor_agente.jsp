<%-- 
    Document   : COFIDE_monitor_agente
    Created on : 04-ene-2016, 18:52:52
    Author     : juliocesar
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
<link rel="stylesheet" type="text/css" href="css/CIP_Cofide.css" />
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
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

//    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
    String strEjecutivo = "";
    String strLlamadas = "";
    String strRegistro = "";
    String strProsp = "";
    String strVentasc = "";
    String strVentasv = "";
    String strSql = "select (select user from usuarios where id_usuarios = CL_USUARIO) as USUARIO"
            + ", count(CL_USUARIO) as LLAMADAS, "
            + "(select count(*) from vta_cliente) as REGISTRO, "
            + "(select count(*) from vta_cliente where CT_ES_PROSPECTO = 1) as PROSPECTO,"
            + "(select sum(CC_PRECIO_PRES) from cofide_cursos) as VENTASC, "
            + "(select sum(CC_PRECIO_VID) from cofide_cursos) as VENTASV  "
            + "from cofide_llamada group by CL_USUARIO order by CL_USUARIO";
    ResultSet rs = oConn.runQuery(strSql, true);
    while (rs.next()) {
        strEjecutivo = rs.getString("USUARIO");
        strLlamadas = rs.getString("LLAMADAS");
        strRegistro = rs.getString("REGISTRO");
        strProsp = rs.getString("PROSPECTO");
        strVentasc = rs.getString("VENTASC");
        strVentasv = rs.getString("VENTASV");
%>
<center>
    <table width="680" cellspacing="0" cellpadding="0" border="0">
        <td width="489">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <tbody>
                    <tr>
                        <td class="txt00 txt05 decora02">
                            <a class="txt05 decora01"> </a>
                        </td>
                    </tr>
                    <tr>
                        <td height="5">
                            <img width="1" height="5" border="0" src="images/spacer.gif">
                        </td>
                    </tr>
                    <tr>
                        <td class="bg_img06" height="2">
                            <img width="1" height="2" border="0" src="images/spacer.gif">
                        </td>
                    </tr>
                    <tr>
                        <td height="5">
                            <img width="1" height="5" border="0" src="images/spacer.gif">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" cellspacing="10" cellpadding="0" border="0">
                                <tbody>
                                    <tr>
                                        <td class="txt00 txt04 decora02"><%=strEjecutivo%></td>
                                    </tr>
                                    <tr>
                                        <td class="txt00 txt04 decora02"></td>
                                    </tr>
                                    <tr>
                                        <td class="bg_img05 txt00 txt01" width="85"><%=strRegistro%></td>
                                <span style="color: gray"></span>
                    </tr>
                    <tr>
                        <td class="bg_img05 txt00 txt01" width="85"><%=strProsp%></td>

                <span style="color: gray"></span>

                </tr>
                <tr>
                    <td class="bg_img05 txt00 txt01" width="85"><%=strLlamadas%></td>

                <span style="color: gray"></span>


                </tbody>
            </table>
        </td>
        </tr>
        </tbody>
    </table>
</td>
<td class="padding01" width="91" valign="middle" align="right">
    <table width="150" cellspacing="0" cellpadding="0" border="0">
        <tbody>
        <tbody>
        <td class="txt00 txt05 decora02">
            <a class="txt05 decora01" >Ventas Curso</a>
        </td>

        <tr>
            <td class="txt00 txt04 decora02"><%="$ " + strVentasc%></td>
        </tr>
        <tr>
            <td class="txt00 txt05 decora02">
                <a class="txt05 decora01" >pagados</a>
            </td>
        </tr>
        <tr>
            <td class="txt00 txt05 decora02">
                <a class="txt05 decora01" >reservados</a>
            </td>
        </tr>
        <tr>
            <td class="txt00 txt05 decora02">
                <a class="txt05 decora01" >No. ventas</a>
            </td>
        </tr>
        </tbody>
    </table>
<td class="padding01" width="91" valign="middle" align="right">
    <table width="71" cellspacing="0" cellpadding="0" border="0">

        <tbody>
        <td class="txt00 txt05 decora02">
            <a class="txt05 decora01">Ventas Videos</a>
        </td>

        <tr>
            <td class="txt00 txt04 decora02"><%="$ " + strVentasv%></td>
        </tr>
        <tr>
            <td class="txt00 txt05 decora02">
                <a class="txt05 decora01">pagados</a>
            </td>
        </tr>
        <tr>
            <td class="txt00 txt05 decora02">
                <a class="txt05 decora01">reservado</a>
            </td>
        </tr>
        <tr>
            <td class="txt00 txt05 decora02">
                <a class="txt05 decora01" >No. ventas </a>
            </td>
        </tr>
        </tbody>
    </table>
</td>


<td class="padding01" width="91" valign="middle" align="right">
    <table width="71" cellspacing="0" cellpadding="0" border="0">

        <tbody>
        <td><i class = "fa fa-video-camera" style="font-size:30px; width:200px" onclick=""></i></td>
        <tr>
            <td><i class = "fa fa-volume-up" style="font-size:30px; width:200px" onclick=""></i></td>
        </tr>
        </tbody>
    </table>
</td>
</tbody>
</center>
<% }
    oConn.close();
%>
