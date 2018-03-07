<%-- 
    Document   : COFIDE_Historial_llamadas
    Created on : 15-abr-2016, 11:32:04
    Author     : juliocesar
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
<link rel="stylesheet" type="text/css" href="css/CIP_Cofide.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    Fechas fec = new Fechas();
%>
<title>Historial de Llamadas</title>
<style>
    body {font-family: Arial, Helvetica, sans-serif;}

    table {     font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
                font-size: 14px;    margin: 45px;     width: 800px; height: 70px; text-align: center; border-color: #000000;
                align: center; }

    th {     font-size: 13px;     font-weight: normal;     padding: 8px;     background: #A9F5A9;
             border-top: 4px solid #A9F5A9;    border-bottom: 1px solid #fff; color: #039; }

    td {    padding: 8px;     background: #ffffff;     border-bottom: 1px solid #fff;
            color: #000000;    border-top: 1px solid transparent; width: 50px}
    tr:hover td { background: #81F781; color: #339; }
</style>
<body oncontextmenu='return false;' onmousedown='return false;' onselectstart='return false'>
<center>
    <div id="Tab_Llamada">
        <table class="table" border="5" cellpadding="30">
            <thead>
                <tr>
                    <th class="th">Fecha de llamada</th>
                    <th class="th">Hora de llamada</th>
                    <th class="th">Comentarios</th>
                    <th class="th">Agente</th>
                    <th class="th">Próxima Llamada</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String strIdCTE = request.getParameter("CT_ID");
                    String strFecha = "";
                    String strFechaNext = "00000000";
                    String strHora = "";
                    String strComentario = "";
                    String strAgente = "";
                    String strCTE = "";
                    String strFormatFecha = "";
                    String strFormatFechaNext = "";

                    String strSql = "select CL_FECHA, CL_HORA,CL_ID,CL_ID_CLIENTE, CL_COMENTARIO, "
                            + " (select CT_RAZONSOCIAL from vta_cliente where vta_cliente.CT_ID = cofide_llamada.CL_ID_CLIENTE) as CL_CLIENTE, "
                            + "CL_USUARIO, CL_PROXIMA_FECHA from cofide_llamada where CL_ID_CLIENTE = " + strIdCTE + " order by CL_FECHA DESC";
                    ResultSet rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strFecha = rs.getString("CL_FECHA");
                        strFechaNext = rs.getString("CL_PROXIMA_FECHA");
                        if (!strFecha.equals("")) {
                            strFormatFecha = fec.FormateaDDMMAAAA(strFecha, "/");
                        }
                        if (!strFechaNext.equals("")) {
                            strFormatFechaNext = fec.FormateaDDMMAAAA(strFechaNext, "/");
                        }
                %>
                <tr class="tr">
                    <td class="td">&nbsp; <%=strFormatFecha%></td>
                    <td class="td">&nbsp; <%=rs.getString("CL_HORA")%> hrs.</td>
                    <td class="td">&nbsp; <%=rs.getString("CL_COMENTARIO")%></td>
                    <td class="td">&nbsp; <%=rs.getString("CL_USUARIO")%></td>
                    <td class="td">&nbsp; <%=strFormatFechaNext%></td>
                </tr>
                <%                }
                    rs.close();
                %>
            </tbody>
        </table>
    </div>
</center>
</body>