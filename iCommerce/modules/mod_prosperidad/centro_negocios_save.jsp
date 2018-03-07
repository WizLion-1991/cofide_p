<%-- 
    Document   : centro_negocios_save
    Created on : 16-jul-2015, 12:28:17
    Author     : ZeusGalindo
--%>

<%@page import="com.mx.siweb.mlm.compensacion.wenow.ActivaBinario"%>
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
        //Para manejo de fechas
        Fechas fecha = new Fechas();
        Periodos periodo = new Periodos();

        //Recuperamos todos los valores
        Conexion oConn2 = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn2.open();

        String strAnswer = request.getParameter("answer");
        String strCodigo = request.getParameter("mdlgn-codigo_promo");

        String strResult = "";
        int intDigito = 0;
        String strKey = "";
        int intPr_Id = 0;
        String strDescripcion = "";
        double dblPrecio = 0;
        double dblPuntos = 0;
        double dblNegocio = 0;
        String strRegimenFiscal = "";
        int intExento1 = 0;
        int intExento2 = 0;
        int intExento3 = 0;
        int intUnidadMedida = 0;
        String strUnidadMedida = "";

        boolean existsCodigo = false;
        if (strCodigo != "") {
            String strQuery = "select *  from mlm_codigo_promocion where  MCP_ACTIVO = '1' and MCP_USADO = '0'  and MCP_CODIGO_PROMOCION = '" + strCodigo + "' ";
            try {
                ResultSet rs1 = oConn2.runQuery(strQuery);
                while (rs1.next()) {
                    existsCodigo = true;
                }
                rs1.close();
            } catch (SQLException ex) {
                System.out.println(ex.getMessage());
            }

            if (existsCodigo) {
                //Validamos el captcha
                Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
                if (captcha.isCorrect(strAnswer)) {
                    //Abrimos la conexion
                    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
                    oConn.open();

                    String strSql = "update mlm_codigo_promocion set MCP_USADO = 1 ,MCP_USUARIO ='" + varSesiones.getintIdCliente() + "' where MCP_CODIGO_PROMOCION = '" + strCodigo + "';";
                    oConn.runQueryLMD(strSql);
                    
                    String strSql1 = "update vta_cliente set CT_ACTIVO = 1  where CT_ID = " + varSesiones.getintIdCliente();
                    oConn.runQueryLMD(strSql1);

                    strResult = "OK";


                    oConn.close();
                } else {
                    strResult = "ERROR:El texto de la imagen no coincide";
                }
            } else {
                strResult = "EL CÓDIGO DE PROMOCIÓN NO EXISTE O YA FUE OCUPADO";
            }

        }

        //Validamos si fue exitoso
        if (strResult.equals("OK")) {

%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Se ha registrado el nuevo centro de negocios con el siguiente numero:</br> <%=varSesiones.getintIdCliente()%> </h3>
</div>
<%
} else {
%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Error al registrar el nuevo distribuidor, mensaje de error <%=strResult%> </h3>
    <input type="button" name="back" value="Regresar" class="btn btn-primary btn" onClick="window.history.back()"/>
</div>
<%
        }

    }

%>