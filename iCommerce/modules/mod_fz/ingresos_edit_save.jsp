<%-- 
    Document   : ingresos_edit_save
    Created on : 6/05/2013, 05:39:13 PM
    Author     : N4v1d4d3s
--%>

<%@page import="Tablas.vta_cliente_dir_entrega"%>
<%@page import="Tablas.vta_pedidosdeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="ERP.Impuestos"%>
<%@page import="ERP.Ticket"%>
<%@page import="nl.captcha.Captcha"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.DigitoVerificador"%>
<%@page import="comSIWeb.Utilerias.generateData"%>
<%@page import="java.util.Random"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0) {
        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        //Consultamos datos de la mama
        int intSC_ID = 0;
        int intEMP_ID = 0;
        int intCT_ID = 0;
        String strSql = "select SC_ID,EMP_ID,CT_ID,TI_ID from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            intSC_ID = rs.getInt("SC_ID");
            intEMP_ID = rs.getInt("EMP_ID");
            intCT_ID = rs.getInt("CT_ID");
        }
        rs.close();
        /*Recuperamos los parametros de direccion de entrega*/
        String strNombreEnt = request.getParameter("dir_ent_nombre");
        String strTelefonoEnt = request.getParameter("dir_ent_telefono");
        String strEmailEnt = request.getParameter("dir_ent_email");
        String strCalleEnt = request.getParameter("dir_ent_calle");
        String strNumeroEnt = request.getParameter("dir_ent_numero");
        String strNunIntEnt = request.getParameter("dir_ent_numeroInterno");
        String strColoniaEnt = request.getParameter("dir_ent_colonia");
        String strEstadoEnt = request.getParameter("dir_ent_estado");
        String strMunicipioEnt = request.getParameter("dir_ent_mun");
        String strCpEnt = request.getParameter("dir_ent_cp");
        String strDesc = request.getParameter("texto");
        String strId = request.getParameter("id");

        String strAnswer = request.getParameter("answer");
        String strResult = "";

        String strKey = "";

        //Validamos el captcha
        Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
        if (captcha.isCorrect(strAnswer)) {

            vta_cliente_dir_entrega dirEnt = new vta_cliente_dir_entrega();
            dirEnt.setFieldString("CDE_NOMBRE", strNombreEnt);
            dirEnt.setFieldString("CDE_TELEFONO1", strTelefonoEnt);
            dirEnt.setFieldString("CDE_EMAIL", strEmailEnt);
            dirEnt.setFieldString("CDE_CALLE", strCalleEnt);
            dirEnt.setFieldString("CDE_NUMERO", strNumeroEnt);
            dirEnt.setFieldString("CDE_NUMINT", strNunIntEnt);
            dirEnt.setFieldString("CDE_COLONIA", strColoniaEnt);
            dirEnt.setFieldString("CDE_ESTADO", strEstadoEnt);
            dirEnt.setFieldString("CDE_MUNICIPIO", strMunicipioEnt);
            dirEnt.setFieldString("CDE_CP", strCpEnt);
            dirEnt.setFieldString("CDE_LOCALIDAD", "MEXICO");
            dirEnt.setFieldString("CDE_DESCRIPCION", strDesc);
            dirEnt.setFieldInt("EMP_ID", intEMP_ID);
            dirEnt.setFieldInt("CT_ID", intCT_ID);
            int idCde = 0;
            if (!strId.equals("") && strId != null) {
                idCde = Integer.valueOf(strId);
            }
            dirEnt.setFieldInt("CDE_ID", idCde);


            strResult = dirEnt.Modifica(oConn);

            oConn.close();
        } else {
            strResult = "ERROR:El texto de la imagen no coincide";
        }
        //Validamos si fue exitoso
        if (strResult.equals("OK")) {

%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Modificaci&oacute;n Exitosa!!</br> <%=strKey%> </h3>
</div>
<%
} else {
%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Error al modificar direcci&oacute;n de entrega, mensaje de error <%=strResult%> </h3>
    <input type="button" name="back" value="Regresar" class="btn btn-primary btn" onClick="window.history.back()"/>
</div>
<%
        }



    }

%>
