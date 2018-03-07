<%-- 
    Document   : vta_rep_timbres_fiscales
    Created on : 16/02/2015, 01:38:41 PM
    Author     : siweb
--%>

<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_ContratoXMes"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_ClienteXMes"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Contrato"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Cliente"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Mes"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Anio"%>
<%@page import="ERP.ContabilidadRestfulClient"%>
<%@page import="java.sql.ResultSet"%>
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

         if (strid.equals("1")) {
            String periodo = request.getParameter("Parametro");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();

            //ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            //client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            //client.setoConn(oConn);
            //String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            //strCodigo = client.logIn();
            //String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            //client.logOut();
            RepoFacTimbFisc_Anio ci = new RepoFacTimbFisc_Anio(periodo, oConn, varSesiones);

            //   ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepAnio_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.RepAnio_GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("2")) {

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

            // ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            // client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            // client.setoConn(oConn);
            // String strCodigo = null;
            // client.setStrCodigoSesion(strCodigo);
            // strCodigo = client.logIn();
            // String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            // client.logOut();
            RepoFacTimbFisc_Anio ci = new RepoFacTimbFisc_Anio(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_timbres_fiscales_anio" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_timbres_fiscales_anio.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepAnio_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.RepAnio_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
               ci.RepAnio_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

         if (strid.equals("3")) {
            String periodo = request.getParameter("Parametro");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();

            //ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            //client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            //client.setoConn(oConn);
            //String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            //strCodigo = client.logIn();
            //String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            //client.logOut();
            RepoFacTimbFisc_Mes ci = new RepoFacTimbFisc_Mes(periodo, oConn, varSesiones);

            //   ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepMes_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.RepMes_GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("4")) {

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
            // ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            // client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            // client.setoConn(oConn);
            // String strCodigo = null;
            // client.setStrCodigoSesion(strCodigo);
            // strCodigo = client.logIn();
            // String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            // client.logOut();

            RepoFacTimbFisc_Mes ci = new RepoFacTimbFisc_Mes(periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_timbres_fiscales_mes" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_timbres_fiscales_mes.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepMes_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.RepMes_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
               ci.RepMes_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

         if (strid.equals("5")) {
            String idCte = request.getParameter("Parametro");
            String periodo = request.getParameter("Parametro1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();

            //ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            //client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            //client.setoConn(oConn);
            //String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            //strCodigo = client.logIn();
            //String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            //client.logOut();
            RepoFacTimbFisc_Cliente ci = new RepoFacTimbFisc_Cliente(idCte, periodo, oConn, varSesiones);

            //   ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepCliente_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.RepCliente_GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("6")) {

            String idCte = request.getParameter("Parametro");
            String periodo = request.getParameter("Parametro1");
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
            // ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            // client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            // client.setoConn(oConn);
            // String strCodigo = null;
            // client.setStrCodigoSesion(strCodigo);
            // strCodigo = client.logIn();
            // String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            // client.logOut();

            RepoFacTimbFisc_Cliente ci = new RepoFacTimbFisc_Cliente(idCte, periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_timbres_fiscales_cliente" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_timbres_fiscales_cliente.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepCliente_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.RepCliente_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
               ci.RepCliente_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

         if (strid.equals("7")) {
            String idCtoa = request.getParameter("Parametro");
            String periodo = request.getParameter("Parametro1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();

            //ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            //client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            //client.setoConn(oConn);
            //String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            //strCodigo = client.logIn();
            //String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            //client.logOut();
            RepoFacTimbFisc_Contrato ci = new RepoFacTimbFisc_Contrato(idCtoa, periodo, oConn, varSesiones);

            //   ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepContrato_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.RepContrato_GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("8")) {

            String idCtoa = request.getParameter("Parametro");
            String periodo = request.getParameter("Parametro1");
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
            // ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            // client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            // client.setoConn(oConn);
            // String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            // strCodigo = client.logIn();
            // String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            // client.logOut();

            RepoFacTimbFisc_Contrato ci = new RepoFacTimbFisc_Contrato(idCtoa, periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_timbres_fiscales_contrato" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_timbres_fiscales_contrato.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepContrato_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.RepContrato_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
               ci.RepContrato_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

         if (strid.equals("9")) {
            String periodo = request.getParameter("Parametro");
            String idCte = request.getParameter("Parametro1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();

            //ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            //client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            //client.setoConn(oConn);
            //String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            //strCodigo = client.logIn();
            //String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            //client.logOut();
            RepoFacTimbFisc_ClienteXMes ci = new RepoFacTimbFisc_ClienteXMes(idCte, periodo, oConn, varSesiones);

            //   ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepCteXMes_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.RepCteXMes_GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("10")) {

            String periodo = request.getParameter("Parametro");
            String idCte = request.getParameter("Parametro1");
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
            // ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            // client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            // client.setoConn(oConn);
            // String strCodigo = null;
            // client.setStrCodigoSesion(strCodigo);
            // strCodigo = client.logIn();
            // String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            // client.logOut();

            RepoFacTimbFisc_ClienteXMes ci = new RepoFacTimbFisc_ClienteXMes(idCte, periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_timbres_fiscales_ctexmes" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_timbres_fiscales_ctexmes.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepCteXMes_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.RepCteXMes_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
               ci.RepCteXMes_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

         if (strid.equals("11")) {
            String idCtoa = request.getParameter("Parametro");
            String periodo = request.getParameter("Parametro1");
            int intIdEmpresa = 0;

            String strSql = "select EMP_CONTA_ID_EMPRESA "
                    + " from vta_empresas "
                    + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
            }
            rs.close();

            //ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            //client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            //client.setoConn(oConn);
            //String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            //strCodigo = client.logIn();
            //String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            //client.logOut();
            RepoFacTimbFisc_ContratoXMes ci = new RepoFacTimbFisc_ContratoXMes(idCtoa, periodo, oConn, varSesiones);

            //   ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepContratoXMes_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.RepContratoXMes_GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("12")) {

            String idCtoa = request.getParameter("Parametro");
            String periodo = request.getParameter("Parametro1");
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
            // ContabilidadRestfulClient client = new ContabilidadRestfulClient();
            // client.setIntEmpresa(varSesiones.getIntIdEmpresa());
            // client.setoConn(oConn);
            // String strCodigo = null;
            //client.setStrCodigoSesion(strCodigo);
            // strCodigo = client.logIn();
            // String strXml = client.getPolizas(intIdEmpresa, periodo, 10000);
            // client.logOut();

            RepoFacTimbFisc_ContratoXMes ci = new RepoFacTimbFisc_ContratoXMes(idCtoa, periodo, oConn, varSesiones);
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_timbres_fiscales_contratoxmes" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_timbres_fiscales_contratoxmes.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepContratoXMes_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            if (strboton_1.equals("PDF")) {
               strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
               ci.RepContratoXMes_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
               ci.RepContratoXMes_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

      }
   }
   oConn.close();


%>
