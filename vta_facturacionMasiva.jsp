<%-- 
    Document   : vta_facturacionMasiva
    Created on : 25-feb-2015, 10:44:54
    Author     : siweb
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Anio"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.especiales.siweb.FacturacionMasiva"%>
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
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {

        String strid = request.getParameter("ID");
        //Si la peticion no fue nula proseguimos
        if (!strid.equals(null)) {

            if (strid.equals("1")) {
                String periodo = request.getParameter("Parametro");
                FacturacionMasiva facMasiva = new FacturacionMasiva(oConn, varSesiones);
                facMasiva.setStrAnio(periodo);
                facMasiva.doTrx();
                facMasiva.RepAnio_GeneraXml();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(facMasiva.RepAnio_GeneraXml().toString());
            }//FIn IF 1

            if (strid.equals("2")) {
                String anio = request.getParameter("ANIO");
                String mes = request.getParameter("MES");
                int intMes = Integer.parseInt(mes);
                FacturacionMasiva facMasiva = new FacturacionMasiva(oConn, varSesiones);
                facMasiva.setStrAnio(anio);
                facMasiva.setIntMes(intMes);
                facMasiva.doTrx();
                facMasiva.GeneraImporte();
                facMasiva.RepAnio_GeneraXml_MES();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(facMasiva.RepAnio_GeneraXml_MES().toString());
            }//FIN IF 2

            if (strid.equals("3")) {

                String periodo = request.getParameter("Periodo");
                String strboton_1 = request.getParameter("boton_1");
                String anio = request.getParameter("ANIO");
                String mes = request.getParameter("MES");
                int intMes = Integer.parseInt(mes);
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
                FacturacionMasiva facMasivaRepo = new FacturacionMasiva(oConn, varSesiones);
            //RepoFacTimbFisc_Anio ci = new RepoFacTimbFisc_Anio(periodo, oConn, varSesiones);
                //Aqui se ira la respuesta
                ServletOutputStream outputstream = response.getOutputStream();
                final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                String strTargetFileName = "rep_facturacion_contratosMES.jrxml" + ".pdf";
                String strPathBase = this.getServletContext().getRealPath("/");
                String strSeparator = System.getProperty("file.separator");
                String strReportFile = "rep_facturacion_contratosMES.jrxml";
                String strReportPath = strPathBase + "/WEB-INF"
                   + strSeparator + "jreports"
                   + strSeparator + strReportFile;

                //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
                facMasivaRepo.setStrAnio(anio);
                facMasivaRepo.setIntMes(intMes);
                facMasivaRepo.doTrx();
                facMasivaRepo.GeneraImporte();
                //facMasivaRepo.RepAnio_GeneraXml();
                //facMasivaRepo.RepAnio_HacerReporte();
                out.clearBuffer();//Limpiamos buffer
                if (strboton_1.equals("PDF")) {
                    strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
                    facMasivaRepo.RepAnio_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
                    facMasivaRepo.RepAnio_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

            }//FIN IF 3
            
            
            if (strid.equals("4")) {

                String strboton_1 = request.getParameter("boton_1");
                String anio = request.getParameter("ANIO");
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
                FacturacionMasiva facMasivaRepo = new FacturacionMasiva(oConn, varSesiones);
            //RepoFacTimbFisc_Anio ci = new RepoFacTimbFisc_Anio(periodo, oConn, varSesiones);
                //Aqui se ira la respuesta
                ServletOutputStream outputstream = response.getOutputStream();
                final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                String strTargetFileName = "rep_facturacion_contratos.jrxml" + ".pdf";
                String strPathBase = this.getServletContext().getRealPath("/");
                String strSeparator = System.getProperty("file.separator");
                String strReportFile = "rep_facturacion_contratos.jrxml";
                String strReportPath = strPathBase + "/WEB-INF"
                   + strSeparator + "jreports"
                   + strSeparator + strReportFile;

                //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
                facMasivaRepo.setStrAnio(anio);
                facMasivaRepo.doTrx();
                facMasivaRepo.RepAnio_GeneraXml();
                //facMasivaRepo.RepAnio_HacerReporte();
                out.clearBuffer();//Limpiamos buffer
                if (strboton_1.equals("PDF")) {
                    strTargetFileName = strReportFile.replace(".jrxml", ".pdf");
                    facMasivaRepo.RepAnio_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 1, strPathBase);
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
                    facMasivaRepo.RepAnio_getReportPrint(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strPathBase);
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

            }//FIN IF 4
            

        }//Fin SI LA PETICION ES NULL       
    }//Fin VARSESIONES
    oConn.close();

%>
