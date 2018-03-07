<%@page import="ERP.NOM_CuentaContable"%>
Document   : ERP_ReportesGlobales
Created on : 26/06/2014, 11:00:25 AM
Author     : siweb
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="ERP.ContabilidadRestfulClient"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="com.mx.siweb.erp.reportes.RDPG_Cuentas_pp"%>
<%@page import="com.mx.siweb.erp.reportes.RDPG_Pagos"%>
<%@page import="com.mx.siweb.erp.reportes.RDPG_Cobros"%>
<%@page import="com.mx.siweb.erp.reportes.RDPG_Bancos"%>
<%@page import="com.mx.siweb.erp.reportes.RDPG_Facturas"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="com.mx.siweb.erp.reportes.RepoIndicadores"%>
<%@page import="com.mx.siweb.erp.reportes.RepoDevoluciones"%>
<%@page import="com.mx.siweb.erp.reportes.RepoPagos"%>
<%@page import="com.mx.siweb.erp.reportes.RepoCartera"%>
<%@page import="com.mx.siweb.erp.reportes.RepoProductosResumen"%>
<%@page import="com.mx.siweb.erp.reportes.RepoProductosDeta"%>
<%@page import="com.mx.siweb.erp.reportes.RepoVentasResumen"%>
<%@page import="com.mx.siweb.erp.reportes.OrdenesCompraPendientes"%>
<%@page import="com.mx.siweb.erp.reportes.PedidosPendientes"%>
<%@page import="com.mx.siweb.erp.reportes.CobrosNoIdentificados"%>
<%@page import="com.mx.siweb.erp.reportes.ControlInventarios"%>
<%@page import="com.mx.siweb.erp.reportes.DetalleCobranza"%>
<%@page import="com.mx.siweb.erp.reportes.ExistenciaBodega"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_Comp_Anual"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_Comp_Mensual"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_Cliente_MVenta"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_Resumen_Clientes"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_DetalleFactura"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteVentasDetalle"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>

<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad(); //Valida que la peticion se halla hecho desde el mismo sitio
    Fechas fecha = new Fechas();

    int intCtid = 0;
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Obtenemos parametros
        String strid = request.getParameter("ID");
        //Si la peticion no fue nula proseguimos
        String strPathBaseimg = this.getServletContext().getRealPath("/");
        String strSeparatorimg = System.getProperty("file.separator");
        if (strSeparatorimg.equals("\\")) {
            strSeparatorimg = "/";
            strPathBaseimg = strPathBaseimg.replace("\\", "/");
        }

        //Si la peticion no fue nula proseguimos
        if (!strid.equals(null)) {

            /*ESTADISTICAS DE CLIENTES*/
            if (strid.equals("1")) {
                String idDep = request.getParameter("DP_ID");
                NOM_CuentaContable CC=new NOM_CuentaContable(oConn, Integer.parseInt(idDep));
                CC.Consulta();
                String strRespXML = CC.GeneraXml();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);
            }
            if (strid.equals("2")) {
                String idDep = request.getParameter("DP_ID");
                String descripcion = request.getParameter("Descripcion");
                String percepcion = request.getParameter("Percepcion");
                
                NOM_CuentaContable CC=new NOM_CuentaContable(oConn, Integer.parseInt(idDep));
                CC.Alta(descripcion, Integer.parseInt(percepcion));
            }
            if (strid.equals("3")) {
                String idDep = request.getParameter("DP_ID");
                String idCC = request.getParameter("CCId");
                NOM_CuentaContable CC=new NOM_CuentaContable(oConn, Integer.parseInt(idDep));
                CC.Baja(Integer.parseInt(idCC));
            }
        }
    }
    oConn.close();

%>