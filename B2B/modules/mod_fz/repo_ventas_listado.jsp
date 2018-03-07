<%-- 
    Document   : repo_ventas_listado
    Created on : 18-sep-2015, 16:35:37
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0) {

        //Recibimos parametros
        String strfechaInicial = request.getParameter("finicial");
        String strfechaFinal = request.getParameter("ffinal");
        Fechas fecha = new Fechas();

        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        String strSql = "SELECT "
                + " view_ventasglobales.FAC_ID,view_ventasglobales.FAC_FECHA,view_ventasglobales.FAC_FOLIO,FAC_FOLIO_C,view_ventasglobales.TIPO_DOC ,"
                + " 		vta_cliente.CT_ID,vta_cliente.CT_RAZONSOCIAL,"
                + " 		(SELECT PC_DESCRIPCION FROM   vta_prodcat1 b WHERE b.PC_ID =  vta_producto.PR_CATEGORIA1) AS CLASIFICACION"
                + " 		,	(getConversionMonedas(view_ventasglobales.FAC_MONEDA, 1 , view_ventasglobales.FAC_TASAPESO ,(view_ventasglobalesdeta.FACD_IMPORTE - view_ventasglobalesdeta.FACD_IMPUESTO1) , view_ventasglobales.FAC_FECHA)) as TSUBTOTAL"
                + " 		 , vta_producto.PR_CODIGO,vta_producto.PR_DESCRIPCION,view_ventasglobalesdeta.FACD_CANTIDAD,view_ventasglobalesdeta.CONFIRMADO"
                + " 		FROM view_ventasglobalesdeta INNER JOIN view_ventasglobales "
                + " 		ON  view_ventasglobalesdeta.FAC_ID = view_ventasglobales.FAC_ID "
                + " 		INNER JOIN vta_sucursal ON view_ventasglobales.SC_ID = vta_sucursal.SC_ID"
                + " 		INNER JOIN vta_producto ON view_ventasglobalesdeta.PR_ID = vta_producto.PR_ID"
                + " 		INNER JOIN vta_cliente ON vta_cliente.CT_ID = view_ventasglobales.CT_ID"
                + " 		 WHERE view_ventasglobales.FAC_ANULADA = 0 "
                + " 		AND view_ventasglobales.FAC_FECHA >= '" + fecha.FormateaBD(strfechaInicial, "/") + "' and view_ventasglobales.FAC_FECHA <= '" + fecha.FormateaBD(strfechaFinal, "/") + "'  "
                + " 		AND view_ventasglobales.EMP_ID = " + 1 //varSesiones.getIntIdEmpresa()
                + "   AND view_ventasglobales.TIPO_DOC = view_ventasglobalesdeta.TIPO_DOC"
                + " 		and vta_producto.PV_ID = " + varSesiones.getintIdCliente()
                + " 		order by TSUBTOTAL desc ";
%>

<div id="dialog" title="Ingrese el codigo de la venta.">
    <div> <input type="text" name="Codigo" id="Codigo" title="Codigo de la venta"  size="25" placeholder="Codigo de la venta"> </div>
    <div> <input type="text" name="Nombre" id="Nombre" title="Nombre del cliente"  size="25" placeholder="Nombre del cliente"> </div>
    <div> <input type="hidden" name="strFacId" id="strFacId" > </div>
    <div> <input type="hidden" name="strTipoVenta" id="strTipoVenta"> </div>
    <div> <input type="hidden" name="strCodigo" id="strCodigo"> </div>
    <div> <input type="submit" value="Verificar" onclick="OnSubmit()"> </div>
</div>

<div id="dialog1" title="Respuesta.">
    <div> <input type="text" name="respuesta" id="respuesta" readonly size="150" > </div>
</div>
<div class="well ">
    <h3 class="page-header">Ventas de mis productos en el periodo <%=strfechaInicial%> al <%=strfechaFinal%></h3>
    <table border="0" cellpadding="1" cellspacing="1">
        <tr>
            <th>Fecha</th>
            <th>Folio</th>
            <th>Tipo Venta</th>
            <th>Cliente</th>
            <th>C&oacute;digo</th>
            <th>Descripci&oacute;n</th>
            <th>Cantidad</th>
            <th>Importe</th>
            <th>Confirmado</th>
            <th>Acciones</th>
        </tr>
        <%
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
        %>
        <tr>
            <td><%=fecha.Formatea(rs.getString("FAC_FECHA"), "/")%></td>
            <% if (rs.getString("TIPO_DOC").equals("T")) {%>
            <td><%=rs.getString("FAC_FOLIO")%></td>
            <td>TICKET/REMISION</td>
            <%} else {%>
            <td><%=rs.getString("FAC_FOLIO_C")%></td>
            <td>FACTURA</td>
            <%}%>

            <td><%=rs.getString("CT_RAZONSOCIAL")%></td>
            <td><%=rs.getString("PR_CODIGO")%></td>
            <td><%=rs.getString("PR_DESCRIPCION")%></td>
            <td><%=rs.getInt("FACD_CANTIDAD")%></td>
            <td><%=NumberString.FormatearDecimal(rs.getDouble("TSUBTOTAL"), 2)%></td>

            <% if (rs.getInt("CONFIRMADO") == 1) {%>            
            <td>SI</td>
            <%} else {%>            
            <td>NO</td>
            <%}%>

            <td>&nbsp;<a href="javascript:IngresarCodigo('<%=rs.getString("FAC_ID")%>','<%=rs.getString("TIPO_DOC")%>','<%=rs.getString("PR_CODIGO")%>')">Ingresar Codigo</a></td>

        </tr>
        <%
            }
            rs.close();
        %>
    </table>

</div>
<script type="text/javascript">

    /*Crea dialog jQuery*/
    $("#dialog").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: "blind", hide: "explode", width: "auto"});
    $("#dialog1").dialog({autoOpen: false, draggable: true, modal: false, resizable: true, show: "blind", hide: "explode", width: "auto"});

    function IngresarCodigo(strFacId, strTipoVenta,strCodigo) {
        $("#dialog").dialog("open");
        document.getElementById("strFacId").value = strFacId;
        document.getElementById("strTipoVenta").value = strTipoVenta;
        document.getElementById("strCodigo").value = strCodigo;

    }

    function OnSubmit() {

        var strFacId = document.getElementById("strFacId").value;
        var strTipoVenta = document.getElementById("strTipoVenta").value;
        var strCodigo = document.getElementById("Codigo").value;
        var strNombre = document.getElementById("Nombre").value;
        var strCodigoProd = document.getElementById("strCodigo").value;

        var strPost = "strFacId=" + strFacId;
        strPost += "&strTipoVenta=" + strTipoVenta;
        strPost += "&strCodigo=" + strCodigo;
        strPost += "&strNombre=" + strNombre;
        strPost += "&strCodigoProd=" + strCodigoProd;

        var strRespuesta = "";
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "modules/mod_fz/B2B_Estados.jsp?id=2",
            success: function (datos) {
                var objPdom = datos.getElementsByTagName("CODIGO")[0];
                var lstProms = objPdom.getElementsByTagName("CODIGO_DETA");
                for (var i = 0; i < lstProms.length; i++) {
                    var obj = lstProms[i];
                    strRespuesta = obj.getAttribute("strRespuesta");
                }
                $("#dialog1").dialog("open");
                document.getElementById("respuesta").value = strRespuesta;
                if (strRespuesta == "OK") {
                    $("#dialog").dialog("close");
                       location.reload();

                }
            }
        });
    }

</script>
<%
    oConn.close();
%>
<%         }
%>
