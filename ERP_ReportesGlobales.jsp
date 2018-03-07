<%-- 
    Document   : ERP_ReportesGlobales
    Created on : 26/06/2014, 11:00:25 AM
    Author     : siweb
--%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_Vtas_globales_prod_cte"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_Vtas_globales_mayor_venta_prod"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_Ventas_Globales_Cat"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteEV_DetallePor_Producto"%>
<%@page import="com.mx.siweb.erp.reportes.entities.RDPG_Notas_CreditoE"%>
<%@page import="com.mx.siweb.erp.reportes.RDPG_Nominas"%>
<%@page import="com.mx.siweb.erp.reportes.RDPG_Notas_Credito"%>
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
      String strid = request.getParameter("id");
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
            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               ReporteVentasDetalle repVta = new ReporteVentasDetalle();

               repVta.llamarSP(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);

               String reporte = repVta.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }

         }

         if (strid.equals("2")) {

            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               RepoVentasResumen repVtaR = new RepoVentasResumen();

               repVtaR.llamarSp(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);
               String reporte = repVtaR.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }
         }

         if (strid.equals("3")) {

            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               RepoProductosDeta repoPD = new RepoProductosDeta();

               repoPD.llamarSP(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);
               String reporte = repoPD.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }
         }

         if (strid.equals("4")) {

            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               RepoProductosResumen repoPr = new RepoProductosResumen();

               repoPr.llamarSp(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);
               String reporte = repoPr.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }
         }

         if (strid.equals("5")) {

            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               RepoCartera cartera = new RepoCartera();

               cartera.llamarSp(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);
               String reporte = cartera.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }
         }
         if (strid.equals("6")) {

            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               RepoPagos pago = new RepoPagos();

               pago.llamarSp(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);
               String reporte = pago.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }

         }
         if (strid.equals("7")) {

            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               RepoDevoluciones devol = new RepoDevoluciones();

               devol.llamarSp(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);
               String reporte = devol.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }
         }

         if (strid.equals("8")) {

            if (Integer.valueOf(request.getParameter("EST_CLIENTE")) == null) {
               intCtid = 0;
            } else {
               intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));

               int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
               int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
               int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
               String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
               String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");

               RepoIndicadores indi = new RepoIndicadores();

               indi.llamarSp(oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin);
               String reporte = indi.generarXML();
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
               out.println(reporte);
            }
         }

         if (strid.equals("31")) {
            //VENTAS DETALLES EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "repo_EST_vtadeta.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            if (formato.equals(".xls")) {
               String targetFileName = "rep_ventasDetalles_" + intCtid + ".xls";
               ReporteVentasDetalle repvta = new ReporteVentasDetalle();
               repvta.generarExcel(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }
            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_ventasDetalles_" + intCtid + ".pdf";
               ReporteVentasDetalle repvta = new ReporteVentasDetalle();
               repvta.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }
         if (strid.equals("32")) {
            //VENTAS RESUMEN EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_EST_vtaRes.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            if (formato.equals(".xls")) {
               String targetFileName = "rep_ventasResumen_" + intCtid + ".xls";
               RepoVentasResumen repvta = new RepoVentasResumen();
               repvta.generarEXCEL(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }

            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_ventasResumen_" + intCtid + ".pdf";
               RepoVentasResumen repvta = new RepoVentasResumen();
               repvta.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }
         if (strid.equals("33")) {
            //PRODUCTOS_DETA EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_EST_prodDeta.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;
            if (formato.equals(".xls")) {
               String targetFileName = "rep_productDeta_" + intCtid + ".xls";
               RepoProductosDeta rep = new RepoProductosDeta();
               rep.generarExcel(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }
            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_prodcutDeta_" + intCtid + ".pdf";
               RepoProductosDeta rep = new RepoProductosDeta();
               rep.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }
         if (strid.equals("34")) {
            //PRODUCTOS_RES EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_EST_prodRes.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            if (formato.equals(".xls")) {
               String targetFileName = "rep_prodResumen_" + intCtid + ".xls";
               RepoProductosResumen rep = new RepoProductosResumen();
               rep.generarExcel(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }
            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_prodResumen_" + intCtid + ".pdf";
               RepoProductosResumen rep = new RepoProductosResumen();
               rep.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }
         if (strid.equals("35")) {
            //CARTERA EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_EST_cartera.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;
            if (formato.equals(".xls")) {
               String targetFileName = "rep_Cartera_" + intCtid + ".xls";
               RepoCartera rep = new RepoCartera();
               rep.generarExcel(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }
            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_cartera_" + intCtid + ".pdf";
               RepoCartera rep = new RepoCartera();
               rep.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }
         if (strid.equals("36")) {
            //PAGOS EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_EST_pagos.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;
            if (formato.equals(".xls")) {
               String targetFileName = "rep_pagos_" + intCtid + ".xls";
               RepoPagos rep = new RepoPagos();
               rep.generarExcel(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }

            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_pagos_" + intCtid + ".pdf";
               RepoPagos rep = new RepoPagos();
               rep.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }
         if (strid.equals("37")) {
            //DEVOLUCIONES EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_EST_devoluciones.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;
            if (formato.equals(".xls")) {
               String targetFileName = "rep_devoluciones" + intCtid + ".xls";
               RepoDevoluciones rep = new RepoDevoluciones();
               rep.generarExcel(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }
            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_devoluciones_" + intCtid + ".pdf";
               RepoDevoluciones rep = new RepoDevoluciones();
               rep.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }
         if (strid.equals("38")) {
            //INDICADORES EST_CTE
            //Recibimos la respuesta
            String formato = request.getParameter("formato");
            intCtid = Integer.valueOf(request.getParameter("EST_CLIENTE"));
            int intMoneda = Integer.valueOf(request.getParameter("EST_MONEDA"));
            int intConvertido = Integer.valueOf(request.getParameter("EST_CONVERT"));
            int intScId = Integer.valueOf(request.getParameter("EST_BODEGA"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("EST_FECHA1"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("EST_FECHA2"), "/");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_EST_indicadores.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;
            if (formato.equals(".xls")) {
               String targetFileName = "rep_indicadores_" + intCtid + ".xls";
               RepoIndicadores rep = new RepoIndicadores();
               rep.generarExcel(strPathBaseimg, varSesiones, strReportPath, targetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + targetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               outputstream.flush();
               outputstream.close();
            }
            if (formato.equals(".pdf")) {
               String strTargetFileName = "rep_indicadores_" + intCtid + ".pdf";
               RepoIndicadores rep = new RepoIndicadores();
               rep.generarReporte(strPathBaseimg, varSesiones, strReportPath, strTargetFileName, oConn, intCtid, intMoneda, intConvertido, intScId, strFechaIni, strFechaFin, byteArrayOutputStream);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
               // clear the output stream.
               outputstream.flush();
               outputstream.close();
            }

         }

         /**
          * ESTADISTICAS DE PRODUCTOS
          */
         if (strid.equals("9")) {
            String codigo = request.getParameter("CI_CODIGO");
            String descripcion = request.getParameter("CI_DESCRIPCION");
            String sc_id = request.getParameter("CI_BODEGA");
            String emp_id = request.getParameter("CI_EEMPRESA_ID");
            String pv_id = request.getParameter("CI_PROVEEDOR");
            String categoria1 = request.getParameter("CI_CATEGORIA1");
            String categoria2 = request.getParameter("CI_CATEGORIA2");
            String categoria3 = request.getParameter("CI_CATEGORIA3");
            String categoria4 = request.getParameter("CI_CATEGORIA4");
            String categoria5 = request.getParameter("CI_CATEGORIA5");
            String categoria6 = request.getParameter("CI_CATEGORIA6");
            String categoria7 = request.getParameter("CI_CATEGORIA7");
            String categoria8 = request.getParameter("CI_CATEGORIA8");
            String categoria9 = request.getParameter("CI_CATEGORIA9");
            String categoria10 = request.getParameter("CI_CATEGORIA10");

            ControlInventarios ci = new ControlInventarios(oConn,
                    0,
                    codigo,
                    descripcion,
                    Integer.parseInt(sc_id),
                    Integer.parseInt(emp_id),
                    Integer.parseInt(pv_id),
                    Integer.parseInt(categoria1),
                    Integer.parseInt(categoria2),
                    Integer.parseInt(categoria3),
                    Integer.parseInt(categoria4),
                    Integer.parseInt(categoria5),
                    Integer.parseInt(categoria6),
                    Integer.parseInt(categoria7),
                    Integer.parseInt(categoria8),
                    Integer.parseInt(categoria9),
                    Integer.parseInt(categoria10));

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("10")) {
            String codigo = request.getParameter("CI_CODIGO");

            ExistenciaBodega ci = new ExistenciaBodega(oConn, codigo, varSesiones);

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("11")) {
            String codigo = request.getParameter("CI_CODIGO_ID");

            PedidosPendientes ci = new PedidosPendientes(oConn, Integer.valueOf(codigo), varSesiones);

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("12")) {
            String codigo = request.getParameter("CI_CODIGO_ID");

            OrdenesCompraPendientes ci = new OrdenesCompraPendientes(oConn, Integer.valueOf(codigo), varSesiones);

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("13")) {
            String moneda = request.getParameter("DC_MONEDA");
            String convertido = request.getParameter("DC_CONVERTIDO");
            String fechaI = request.getParameter("DC_FECHA_I");
            String fechaF = request.getParameter("DC_FECHA_F");
            String bodega = request.getParameter("DC_BODEGAS");
            String empresa = request.getParameter("DC_EMPRESA");

            DetalleCobranza ci = new DetalleCobranza(
                    Integer.parseInt(moneda),
                    Integer.parseInt(convertido),
                    fecha.FormateaBD(fechaI, "/").substring(0, 6),
                    fecha.FormateaBD(fechaF, "/").substring(0, 6),
                    Integer.parseInt(bodega),
                    Integer.parseInt(empresa),
                    oConn
            );

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("14")) {
            String moneda = request.getParameter("DC_MONEDA");
            String convertido = request.getParameter("DC_CONVERTIDO");
            String fechaI = request.getParameter("DC_FECHA_I");
            String fechaF = request.getParameter("DC_FECHA_F");
            String bodega = request.getParameter("DC_BODEGAS");
            String empresa = request.getParameter("DC_EMPRESA");

            CobrosNoIdentificados ci = new CobrosNoIdentificados(
                    Integer.parseInt(moneda),
                    Integer.parseInt(convertido),
                    fecha.FormateaBD(fechaI, "/").substring(0, 6),
                    fecha.FormateaBD(fechaF, "/").substring(0, 6),
                    Integer.parseInt(bodega),
                    Integer.parseInt(empresa),
                    oConn
            );

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("15")) {
            //Recibimos la respuesta
            String codigo = request.getParameter("CI_CODIGO");
            String descripcion = request.getParameter("CI_DESCRIPCION");
            String sc_id = request.getParameter("CI_BODEGA");
            String emp_id = request.getParameter("CI_EEMPRESA_ID");
            String pv_id = request.getParameter("CI_PROVEEDOR");
            String categoria1 = request.getParameter("CI_CATEGORIA1");
            String categoria2 = request.getParameter("CI_CATEGORIA2");
            String categoria3 = request.getParameter("CI_CATEGORIA3");
            String categoria4 = request.getParameter("CI_CATEGORIA4");
            String categoria5 = request.getParameter("CI_CATEGORIA5");
            String categoria6 = request.getParameter("CI_CATEGORIA6");
            String categoria7 = request.getParameter("CI_CATEGORIA7");
            String categoria8 = request.getParameter("CI_CATEGORIA8");
            String categoria9 = request.getParameter("CI_CATEGORIA9");
            String categoria10 = request.getParameter("CI_CATEGORIA10");
            String strboton_1 = request.getParameter("boton_1");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_control_Inventarios" + codigo + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_control_Inventarios.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ControlInventarios ci = new ControlInventarios(oConn,
                    0,
                    codigo,
                    descripcion,
                    Integer.parseInt(sc_id),
                    Integer.parseInt(emp_id),
                    Integer.parseInt(pv_id),
                    Integer.parseInt(categoria1),
                    Integer.parseInt(categoria2),
                    Integer.parseInt(categoria3),
                    Integer.parseInt(categoria4),
                    Integer.parseInt(categoria5),
                    Integer.parseInt(categoria6),
                    Integer.parseInt(categoria7),
                    Integer.parseInt(categoria8),
                    Integer.parseInt(categoria9),
                    Integer.parseInt(categoria10));

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML

            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("16")) {

            String codigo = request.getParameter("CI_CODIGO");
            String descripcion = request.getParameter("CI_DESCRIPCION");
            String strboton_1 = request.getParameter("boton_1");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gon_existencia_bodega" + codigo + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gon_existencia_bodega.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ExistenciaBodega ci = new ExistenciaBodega(oConn, codigo, varSesiones);

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, descripcion, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, descripcion, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("17")) {

            String codigoid = request.getParameter("CI_CODIGO_ID");
            String codigo = request.getParameter("CI_CODIGO");
            String descripcion = request.getParameter("CI_DESCRIPCION");
            String strboton_1 = request.getParameter("boton_1");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_pedidos_pend" + codigo + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_pedidos_pend.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            PedidosPendientes ci = new PedidosPendientes(oConn, Integer.valueOf(codigoid), varSesiones);

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, codigo, descripcion, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, codigo, descripcion, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("18")) {

            String codigo = request.getParameter("CI_CODIGO");
            String descripcion = request.getParameter("CI_DESCRIPCION");
            String strboton_1 = request.getParameter("boton_1");
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_ordenes_comp_pendientes" + codigo + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_ordenes_comp_pendientes.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            OrdenesCompraPendientes ci = new OrdenesCompraPendientes(oConn, Integer.valueOf(codigo), varSesiones);

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, descripcion, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, descripcion, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            };
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("30")) {

            String moneda = request.getParameter("DC_MONEDA");
            String convertido = request.getParameter("DC_CONVERTIDO");
            String fechaI = request.getParameter("DC_FECHA_I");
            String fechaF = request.getParameter("DC_FECHA_F");
            String bodega = request.getParameter("DC_BODEGAS");
            String empresa = request.getParameter("DC_EMPRESA");
            String strboton_1 = request.getParameter("boton_1");

            DetalleCobranza ci = new DetalleCobranza(
                    Integer.parseInt(moneda),
                    Integer.parseInt(convertido),
                    fecha.FormateaBD(fechaI, "/").substring(0, 6),
                    fecha.FormateaBD(fechaF, "/").substring(0, 6),
                    Integer.parseInt(bodega),
                    Integer.parseInt(empresa),
                    oConn
            );
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_detalle_cobranza" + fechaF + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_detalle_cobranza.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("31")) {

            String moneda = request.getParameter("DC_MONEDA");
            String convertido = request.getParameter("DC_CONVERTIDO");
            String fechaI = request.getParameter("DC_FECHA_I");
            String fechaF = request.getParameter("DC_FECHA_F");
            String bodega = request.getParameter("DC_BODEGAS");
            String empresa = request.getParameter("DC_EMPRESA");
            String strboton_1 = request.getParameter("boton_1");

            CobrosNoIdentificados ci = new CobrosNoIdentificados(
                    Integer.parseInt(moneda),
                    Integer.parseInt(convertido),
                    fecha.FormateaBD(fechaI, "/").substring(0, 6),
                    fecha.FormateaBD(fechaF, "/").substring(0, 6),
                    Integer.parseInt(bodega),
                    Integer.parseInt(empresa),
                    oConn
            );
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_cobros_nidentificados" + fechaF + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_cobros_nidentificados.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }

         /**
          * ESTADISTICAS GLOBALES
          */
         //Modulo de Detalle de Facturas de Estadistica de Ventas
         if (strid.equals("20")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            ReporteEV_DetalleFactura repEv_Detalle_Fac = new ReporteEV_DetalleFactura();
            repEv_Detalle_Fac.setoConn(oConn);
            repEv_Detalle_Fac.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin);
            String reporte = repEv_Detalle_Fac.generarXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }
         //Modulo de Resumen de Clientes en Estadistica de ventas
         if (strid.equals("21")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            ReporteEV_Resumen_Clientes RC = new ReporteEV_Resumen_Clientes();
            RC.setoConn(oConn);
            RC.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin);
            String reporte = RC.generarXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }
         //Modulo de Clientes de Mayor venta en Estadistica de Ventas
         if (strid.equals("22")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }
            int intNumeroClientes = 0;
            if (request.getParameter("NumeroClientes") != null) {
               intNumeroClientes = Integer.valueOf(request.getParameter("NumeroClientes"));
            }
            ReporteEV_Cliente_MVenta CMV = new ReporteEV_Cliente_MVenta();
            CMV.setoConn(oConn);
            CMV.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin, intNumeroClientes);
            String reporte = CMV.generarXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }
         //Modulo de Camparativo mensual de Estadistica de Ventas
         if (strid.equals("23")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            int strFechaIni = 0;
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = Integer.valueOf(request.getParameter("FECHA_INI"));
            }

            ReporteEV_Comp_Mensual COMM = new ReporteEV_Comp_Mensual();
            COMM.setoConn(oConn);
            COMM.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni);
            String reporte = COMM.generarXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }
         //Modulo de Camparativo anual de Estadistica de Ventas
         if (strid.equals("24")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            int strFechaIni = 0;
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = Integer.valueOf(request.getParameter("FECHA_INI"));
            }

            int strFechaFin = 0;
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = Integer.valueOf(request.getParameter("FECHA_FIN"));
            }

            ReporteEV_Comp_Anual COMA = new ReporteEV_Comp_Anual();
            COMA.setoConn(oConn);
            COMA.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin);
            String reporte = COMA.generarXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }
         //Modulo de Impresion en PDF/XLS de Detalle Factura venta en Estadistica de Ventas
         if (strid.equals("25")) {

            //Recibimos la respuesta
            int intMoneda = Integer.valueOf(request.getParameter("intMoneda"));
            int intConvertido = Integer.valueOf(request.getParameter("intConvertido"));
            int intEmpId = Integer.valueOf(request.getParameter("intEmpId"));
            int intScId = Integer.valueOf(request.getParameter("intScId"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("strFechaIni"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("strFechaFin"), "/");
            String strOpcion = request.getParameter("boton_1");
            String strExtencion = "";
            String strContentType = "";
            //Aqui se ira la respuesta
            if (strOpcion.equals("PDF")) {
               strExtencion = ".pdf";
               strContentType = "application/pdf";
            }
            if (strOpcion.equals("XLS")) {
               strExtencion = ".xls";
               strContentType = "application/vnd.ms-excel";
            }
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "ReporteDetalleFactura" + strFechaIni + strExtencion;
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_glob_DetalleFactura.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ReporteEV_DetalleFactura RV_CMV = new ReporteEV_DetalleFactura();
            RV_CMV.setoConn(oConn);
            RV_CMV.setSourceFileName(strReportPath);
            RV_CMV.setTargetFileName(strTargetFileName);
            RV_CMV.setIntMoneda(intMoneda);
            RV_CMV.setIntConvertido(intConvertido);
            RV_CMV.setIntEmpId(intEmpId);
            RV_CMV.setIntScId(intScId);
            RV_CMV.setStrFechaIni(strFechaIni);
            RV_CMV.setStrFechaFin(strFechaFin);

            if (strOpcion.equals("PDF")) {
               RV_CMV.GeneraPDF(varSesiones, byteArrayOutputStream);
            }
            if (strOpcion.equals("XLS")) {
               RV_CMV.GeneraXLS(varSesiones, byteArrayOutputStream);
            }

            //Tags para que identifique el browser el tipo de archivo
            response.setContentType(strContentType);
            //Limpiamos cache y nombre del archivo
            response.setHeader("Cache-Control", "max-age=0");
            response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
            outputstream.write(byteArrayOutputStream.toByteArray());
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }

         //Modulo de Impresion en PDF/XLS de Resumen de Clientes venta en Estadistica de Ventas
         if (strid.equals("26")) {

            //Recibimos la respuesta
            int intMoneda = Integer.valueOf(request.getParameter("intMoneda"));
            int intConvertido = Integer.valueOf(request.getParameter("intConvertido"));
            int intEmpId = Integer.valueOf(request.getParameter("intEmpId"));
            int intScId = Integer.valueOf(request.getParameter("intScId"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("strFechaIni"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("strFechaFin"), "/");
            String strOpcion = request.getParameter("boton_1");
            String strExtencion = "";
            String strContentType = "";
            //Aqui se ira la respuesta
            if (strOpcion.equals("PDF")) {
               strExtencion = ".pdf";
               strContentType = "application/pdf";
            }
            if (strOpcion.equals("XLS")) {
               strExtencion = ".xls";
               strContentType = "application/vnd.ms-excel";
            }
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "ReporteResumenCliente" + strFechaIni + strExtencion;
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_glob_ResumenClientes.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ReporteEV_Resumen_Clientes RV_CMV = new ReporteEV_Resumen_Clientes();
            RV_CMV.setoConn(oConn);
            RV_CMV.setSourceFileName(strReportPath);
            RV_CMV.setTargetFileName(strTargetFileName);
            RV_CMV.setIntMoneda(intMoneda);
            RV_CMV.setIntConvertido(intConvertido);
            RV_CMV.setIntEmpId(intEmpId);
            RV_CMV.setIntScId(intScId);
            RV_CMV.setStrFechaIni(strFechaIni);
            RV_CMV.setStrFechaFin(strFechaFin);

            if (strOpcion.equals("PDF")) {
               RV_CMV.GeneraPDF(varSesiones, byteArrayOutputStream);
            }

            if (strOpcion.equals("XLS")) {
               RV_CMV.GeneraXLS(varSesiones, byteArrayOutputStream);
            }

            //Tags para que identifique el browser el tipo de archivo
            response.setContentType(strContentType);
            //Limpiamos cache y nombre del archivo
            response.setHeader("Cache-Control", "max-age=0");
            response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
            outputstream.write(byteArrayOutputStream.toByteArray());
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }

         //Modulo de Impresion en PDF de Clientes de Mayor venta en Estadistica de Ventas
         if (strid.equals("27")) {

            //Recibimos la respuesta
            int intMoneda = Integer.valueOf(request.getParameter("intMoneda"));
            int intConvertido = Integer.valueOf(request.getParameter("intConvertido"));
            int intEmpId = Integer.valueOf(request.getParameter("intEmpId"));
            int intScId = Integer.valueOf(request.getParameter("intScId"));
            int intCuantos = Integer.valueOf(request.getParameter("intCuantos"));
            String strFechaIni = fecha.FormateaBD(request.getParameter("strFechaIni"), "/");
            String strFechaFin = fecha.FormateaBD(request.getParameter("strFechaFin"), "/");
            String strOpcion = request.getParameter("boton_1");
            String strExtencion = "";
            String strContentType = "";
            //Aqui se ira la respuesta
            if (strOpcion.equals("PDF")) {
               strExtencion = ".pdf";
               strContentType = "application/pdf";
            }
            if (strOpcion.equals("XLS")) {
               strExtencion = ".xls";
               strContentType = "application/vnd.ms-excel";
            }
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "ReporteClienteMVenta" + strFechaIni + strExtencion;
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_glob_ClienteMVenta.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ReporteEV_Cliente_MVenta RV_CMV = new ReporteEV_Cliente_MVenta();
            RV_CMV.setoConn(oConn);
            RV_CMV.setSourceFileName(strReportPath);
            RV_CMV.setTargetFileName(strTargetFileName);
            RV_CMV.setIntMoneda(intMoneda);
            RV_CMV.setIntConvertido(intConvertido);
            RV_CMV.setIntEmpId(intEmpId);
            RV_CMV.setIntScId(intScId);
            RV_CMV.setStrFechaIni(strFechaIni);
            RV_CMV.setStrFechaFin(strFechaFin);
            RV_CMV.setIntCuantos(intCuantos);

            if (strOpcion.equals("PDF")) {
               RV_CMV.GeneraPDF(varSesiones, byteArrayOutputStream);
            }
            if (strOpcion.equals("XLS")) {
               RV_CMV.GeneraXLS(varSesiones, byteArrayOutputStream);
            }

            //Tags para que identifique el browser el tipo de archivo
            response.setContentType(strContentType);
            //Limpiamos cache y nombre del archivo
            response.setHeader("Cache-Control", "max-age=0");
            response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
            outputstream.write(byteArrayOutputStream.toByteArray());
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }

         //Modulo de Impresion en PDF de Comparativo Mensual venta en Estadistica de Ventas
         if (strid.equals("28")) {

            //Recibimos la respuesta
            int intMoneda = Integer.valueOf(request.getParameter("intMoneda"));
            int intConvertido = Integer.valueOf(request.getParameter("intConvertido"));
            int intEmpId = Integer.valueOf(request.getParameter("intEmpId"));
            int intScId = Integer.valueOf(request.getParameter("intScId"));
            String strAnio = request.getParameter("strAnio");
            String strOpcion = request.getParameter("boton_1");
            String strExtencion = "";
            String strContentType = "";
            //Aqui se ira la respuesta
            if (strOpcion.equals("PDF")) {
               strExtencion = ".pdf";
               strContentType = "application/pdf";
            }
            if (strOpcion.equals("XLS")) {
               strExtencion = ".xls";
               strContentType = "application/vnd.ms-excel";
            }
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "ReporteComparativoMensual" + strAnio + strExtencion;
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_glob_CompMensual.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ReporteEV_Comp_Mensual RV_CMV = new ReporteEV_Comp_Mensual();
            RV_CMV.setoConn(oConn);
            RV_CMV.setSourceFileName(strReportPath);
            RV_CMV.setTargetFileName(strTargetFileName);
            RV_CMV.setIntMoneda(intMoneda);
            RV_CMV.setIntConvertido(intConvertido);
            RV_CMV.setIntEmpId(intEmpId);
            RV_CMV.setIntScId(intScId);
            RV_CMV.setAnio(strAnio);

            if (strOpcion.equals("PDF")) {
               RV_CMV.GeneraPDF(varSesiones, byteArrayOutputStream);
            }
            if (strOpcion.equals("XLS")) {
               RV_CMV.GeneraXLS(varSesiones, byteArrayOutputStream);
            }

            //Tags para que identifique el browser el tipo de archivo
            response.setContentType(strContentType);
            //Limpiamos cache y nombre del archivo
            response.setHeader("Cache-Control", "max-age=0");
            response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
            outputstream.write(byteArrayOutputStream.toByteArray());
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }

         //Modulo de Impresion en PDF de Comparativo Anual venta en Estadistica de Ventas
         if (strid.equals("29")) {

            //Recibimos la respuesta
            int intMoneda = Integer.valueOf(request.getParameter("intMoneda"));
            int intConvertido = Integer.valueOf(request.getParameter("intConvertido"));
            int intEmpId = Integer.valueOf(request.getParameter("intEmpId"));
            int intScId = Integer.valueOf(request.getParameter("intScId"));
            String strAnioini = request.getParameter("strAnioIni");
            String strAnioFin = request.getParameter("strAnioFin");
            String strOpcion = request.getParameter("boton_1");
            String strExtencion = "";
            String strContentType = "";
            //Aqui se ira la respuesta
            if (strOpcion.equals("PDF")) {
               strExtencion = ".pdf";
               strContentType = "application/pdf";
            }
            if (strOpcion.equals("XLS")) {
               strExtencion = ".xls";
               strContentType = "application/vnd.ms-excel";
            }
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "ReporteComparativoAnual" + strAnioini + "_" + strAnioFin + strExtencion;
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_glob_CompAnual.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ReporteEV_Comp_Anual RV_CMV = new ReporteEV_Comp_Anual();
            RV_CMV.setoConn(oConn);
            RV_CMV.setSourceFileName(strReportPath);
            RV_CMV.setTargetFileName(strTargetFileName);
            RV_CMV.setIntMoneda(intMoneda);
            RV_CMV.setIntConvertido(intConvertido);
            RV_CMV.setIntEmpId(intEmpId);
            RV_CMV.setIntScId(intScId);
            RV_CMV.setStrAnioIni(strAnioini);
            RV_CMV.setStrAnioFin(strAnioFin);

            if (strOpcion.equals("PDF")) {
               RV_CMV.GeneraPDF(varSesiones, byteArrayOutputStream);
            }
            if (strOpcion.equals("XLS")) {
               RV_CMV.GeneraXLS(varSesiones, byteArrayOutputStream);
            }

            //Tags para que identifique el browser el tipo de archivo
            response.setContentType(strContentType);
            //Limpiamos cache y nombre del archivo
            response.setHeader("Cache-Control", "max-age=0");
            response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
            outputstream.write(byteArrayOutputStream.toByteArray());
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("40")) {

            String periodo = request.getParameter("Periodo");
            String strboton_1 = request.getParameter("boton_1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Facturas ci = new RDPG_Facturas(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_facturas" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_facturas.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("41")) {

            String periodo = request.getParameter("Periodo");
            String strboton_1 = request.getParameter("boton_1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Cuentas_pp ci = new RDPG_Cuentas_pp(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_cuentas" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_cuentas.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("42")) {

            String periodo = request.getParameter("Periodo");
            String strboton_1 = request.getParameter("boton_1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Pagos ci = new RDPG_Pagos(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_pagos" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_pagos.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("43")) {

            String periodo = request.getParameter("Periodo");
            String strboton_1 = request.getParameter("boton_1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Cobros ci = new RDPG_Cobros(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_cobros" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_cobros.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("44")) {

            String periodo = request.getParameter("Periodo");
            String strboton_1 = request.getParameter("boton_1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Bancos ci = new RDPG_Bancos(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_bancos" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_bancos.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }
         if (strid.equals("45")) {
            String periodo = request.getParameter("Periodo");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Facturas ci = new RDPG_Facturas(periodo, oConn, varSesiones);

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("46")) {
            String periodo = request.getParameter("Periodo");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Cuentas_pp ci = new RDPG_Cuentas_pp(periodo, oConn, varSesiones);

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("47")) {
            String periodo = request.getParameter("Periodo");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Pagos ci = new RDPG_Pagos(periodo, oConn, varSesiones);

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("48")) {
            String periodo = request.getParameter("Periodo");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Cobros ci = new RDPG_Cobros(periodo, oConn, varSesiones);

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }
         if (strid.equals("49")) {
            String periodo = request.getParameter("Periodo");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Bancos ci = new RDPG_Bancos(periodo, oConn, varSesiones);

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("50")) {
            String periodo = request.getParameter("Periodo");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Notas_Credito ci = new RDPG_Notas_Credito(periodo, oConn, varSesiones);

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("51")) {
            String periodo = request.getParameter("Periodo");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Nominas ci = new RDPG_Nominas(periodo, oConn, varSesiones);

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("52")) {

            String periodo = request.getParameter("Periodo");
            String strboton_1 = request.getParameter("boton_1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Notas_Credito ci = new RDPG_Notas_Credito(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_notas_credito" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_notas_credito.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }

         if (strid.equals("53")) {

            String periodo = request.getParameter("Periodo");
            String strboton_1 = request.getParameter("boton_1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();
            ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            client.setoConn(oConn);
            String strCodigo = null;
            client.setStrCodigoSesion(strCodigo);
            strCodigo = client.logIn();
            String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            client.logOut();

            RDPG_Nominas ci = new RDPG_Nominas(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_gob_nominas" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_gob_nominas.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".xls");
               ci.getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }

         //Reporte detalle por producto
         if (strid.equals("54")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }
            ReporteEV_DetallePor_Producto detaPR = new ReporteEV_DetallePor_Producto();
            detaPR.setoConn(oConn);
            detaPR.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin);
            String reporte = detaPR.generarXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }//Fin ID 54

         //Reporte detalle por genero
         if (strid.equals("55")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            int intCategoria = 0;
            if (request.getParameter("CATEGORIA") != null) {
               intCategoria = Integer.valueOf(request.getParameter("CATEGORIA"));
            }
            ReporteEV_Ventas_Globales_Cat VtaCat = new ReporteEV_Ventas_Globales_Cat();
            VtaCat.setoConn(oConn);
            VtaCat.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin, intCategoria);
            String reporte = VtaCat.generaXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);

         }//Fin ID 55

         //Reporte Producto con mas compras
         if (strid.equals("56")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            int intCuantosPr = 0;
            if (request.getParameter("CUANTOSPR") != null) {
               intCuantosPr = Integer.valueOf(request.getParameter("CUANTOSPR"));
            }
            ReporteEV_Vtas_globales_mayor_venta_prod vtaPr = new ReporteEV_Vtas_globales_mayor_venta_prod();
            vtaPr.setoConn(oConn);
            vtaPr.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin, intCuantosPr);
            String reporte = vtaPr.generaXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }//Fin ID 56

         //Reporte cliente que mas compra por categoria
         if (strid.equals("57")) {
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            int intCategoria = 0;
            if (request.getParameter("CATEGORIA") != null) {
               intCategoria = Integer.valueOf(request.getParameter("CATEGORIA"));
            }
            ReporteEV_Vtas_globales_prod_cte vtaCatCte = new ReporteEV_Vtas_globales_prod_cte();
            vtaCatCte.setoConn(oConn);
            vtaCatCte.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin, intCategoria);
            String reporte = vtaCatCte.generaXML();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);
            out.println(reporte);
         }//Fin ID 57

         //Exportar REPORTE detalles de venta por producto
         if (strid.equals("58")) {
            String strboton_1 = request.getParameter("boton_1");
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String[] lstJrxml =  getNameReportJrxml(oConn, "EVTA_6");
            String strTargetFileName = lstJrxml[1] + ".pdf";
            if (strboton_1.equals("XLS")) {
               strTargetFileName = lstJrxml[1] + ".xls";
            }
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = lstJrxml[0];//"rep_EV_DetallePor_Producto.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }
            Fechas fec = new Fechas();
            String newFecIni = fec.Formatea(strFechaIni, "/");
            String newFecFin = fec.Formatea(strFechaFin, "/");
            ReporteEV_DetallePor_Producto detaPR = new ReporteEV_DetallePor_Producto();
            detaPR.setoConn(oConn);
            String strBodega = detaPR.getSucursal(intSC_ID);
            String strMoneda = detaPR.getMoneda(intMoneda);
            detaPR.Consume_EV(1, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin);
            
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               detaPR.ReportaDetallePor_Producto(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strMoneda, strBodega, newFecIni, newFecFin);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               detaPR.ReportaDetallePor_Producto(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strMoneda, strBodega, newFecIni, newFecFin);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }//Fin ID 58

         //Exportar REPORTE detalles de venta por categoria
         if (strid.equals("59")) {
            String strboton_1 = request.getParameter("boton_1");
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String[] lstJrxml =  getNameReportJrxml(oConn, "EVTA_7");
            String strTargetFileName = lstJrxml[1] + ".pdf";
            if (strboton_1.equals("XLS")) {
               strTargetFileName = lstJrxml[1] + ".xls";
            }
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = lstJrxml[0];//"rep_EV_Ventas_Globales_Cat.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            int intCategoria = 0;
            if (request.getParameter("CATEGORIA") != null) {
               intCategoria = Integer.valueOf(request.getParameter("CATEGORIA"));
            }
            Fechas fec = new Fechas();
            String newFecIni = fec.Formatea(strFechaIni, "/");
            String newFecFin = fec.Formatea(strFechaFin, "/");
            ReporteEV_Ventas_Globales_Cat VtaCat = new ReporteEV_Ventas_Globales_Cat();
            VtaCat.setoConn(oConn);
            VtaCat.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin, intCategoria);
            String strBodega = VtaCat.getSucursal(intSC_ID);
            String strMoneda = VtaCat.getMoneda(intMoneda);
            String strCategoria = intCategoria + "";
            
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               VtaCat.ReportaEV_Ventas_Globales_Cat(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strMoneda, strBodega, newFecIni, newFecFin, strCategoria);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               VtaCat.ReportaEV_Ventas_Globales_Cat(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strMoneda, strBodega, newFecIni, newFecFin, strCategoria);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }//Fin ID 59
         //TOP DE PRODUCTOS QUE SE COMPRAN MAS
         if (strid.equals("60")) {
            String strboton_1 = request.getParameter("boton_1");
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String[] lstJrxml =  getNameReportJrxml(oConn, "EVTA_8");
            String strTargetFileName = lstJrxml[1] + ".pdf";
            if (strboton_1.equals("XLS")) {
               strTargetFileName = lstJrxml[1] + ".xls";
            }
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = lstJrxml[0];//"rep_EV_Vtas_globales_mayor_venta_prod.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            int intCuantosPr = 0;
            if (request.getParameter("CUANTOSPR") != null) {
               intCuantosPr = Integer.valueOf(request.getParameter("CUANTOSPR"));
            }
            Fechas fec = new Fechas();
            String newFecIni = fec.Formatea(strFechaIni, "/");
            String newFecFin = fec.Formatea(strFechaFin, "/");
            ReporteEV_Vtas_globales_mayor_venta_prod vtaPr = new ReporteEV_Vtas_globales_mayor_venta_prod();
            vtaPr.setoConn(oConn);
            String strBodega = vtaPr.getSucursal(intSC_ID);
            String strMoneda = vtaPr.getMoneda(intMoneda);
            vtaPr.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin, intCuantosPr);

            
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               vtaPr.ReportaEV_Vtas_globales_mayor_venta_prod(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strMoneda, strBodega, newFecIni, newFecFin, intCuantosPr);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               vtaPr.ReportaEV_Vtas_globales_mayor_venta_prod(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strMoneda, strBodega, newFecIni, newFecFin, intCuantosPr);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();
         }//Fin ID 60

         //Reporte cliente que mas compra por categoria
         if (strid.equals("61")) {
            String strboton_1 = request.getParameter("boton_1");
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String[] lstJrxml =  getNameReportJrxml(oConn, "EVTA_9");
            String strTargetFileName = lstJrxml[1] + ".pdf";
            if (strboton_1.equals("XLS")) {
               strTargetFileName = lstJrxml[1] + ".xls";
            }
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = lstJrxml[0];//"rep_EV_Vtas_globales_prod_cte.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;
            int intMoneda = 0;
            if (request.getParameter("MON_ID") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
            }
            int intConvertido = 0;
            if (request.getParameter("CONVERTIDO") != null) {
               intConvertido = Integer.valueOf(request.getParameter("CONVERTIDO"));
            }

            int intEMP_ID = 0;
            if (request.getParameter("EMP_ID") != null) {
               intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
            }
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFechaIni = "";
            if (request.getParameter("FECHA_INI") != null) {
               strFechaIni = fecha.FormateaBD(request.getParameter("FECHA_INI"), "/");
            }

            String strFechaFin = "";
            if (request.getParameter("FECHA_FIN") != null) {
               strFechaFin = fecha.FormateaBD(request.getParameter("FECHA_FIN"), "/");
            }

            int intCategoria = 0;
            if (request.getParameter("CATEGORIA") != null) {
               intCategoria = Integer.valueOf(request.getParameter("CATEGORIA"));
            }
            Fechas fec = new Fechas();
            ReporteEV_Vtas_globales_prod_cte vtaCatCte = new ReporteEV_Vtas_globales_prod_cte();
            vtaCatCte.setoConn(oConn);
            String newFecIni = fec.Formatea(strFechaIni, "/");
            String newFecFin = fec.Formatea(strFechaFin, "/");
            String strBodega = vtaCatCte.getSucursal(intSC_ID);
            String strMoneda = vtaCatCte.getMoneda(intMoneda);
            vtaCatCte.Consume_EV(intMoneda, intConvertido, intEMP_ID, intSC_ID, strFechaIni, strFechaFin, intCategoria);
            String strCategoria = "" + intCategoria;
            
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               vtaCatCte.ReportaVtas_globales_prod_cte(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strMoneda, strBodega, newFecIni, newFecFin, strCategoria);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/pdf");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            //XLS
            if (strboton_1.equals("XLS")) {
               vtaCatCte.ReportaVtas_globales_prod_cte(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strMoneda, strBodega, newFecIni, newFecFin, strCategoria);
               //Tags para que identifique el browser el tipo de archivo
               response.setContentType("application/vnd.ms-excel");
               //Limpiamos cache y nombre del archivo
               response.setHeader("Cache-Control", "max-age=0");
               response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
               outputstream.write(byteArrayOutputStream.toByteArray());
            }
            // clear the output stream.
            outputstream.flush();
            outputstream.close();

         }//Fin ID 61
      }
   }
   oConn.close();

%>


<%!
   /**Recupera el nombre del JRXML asociado al reporte*/
   public String[] getNameReportJrxml(Conexion oConn, String strAbrv) {
      String[] strNameJrxml = new String[2];
      String strSql = "select REP_JRXML,REP_NOM_FILE from repo_master where REP_ABRV = '" + strAbrv + "'";
      try {
         ResultSet rs = oConn.runQuery(strSql, true);
         while(rs.next()){
            strNameJrxml[0] = rs.getString("REP_JRXML");
            strNameJrxml[1] = rs.getString("REP_NOM_FILE");
         }
         //if(rs.getStatement() != null )rs.getStatement().close(); 
         rs.close();
      } catch (Exception ex) {
         System.out.println(ex.getMessage());
      }
      return strNameJrxml;

   }
%>