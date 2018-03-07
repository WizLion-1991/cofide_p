<%-- 
    Document   : ERP_EdoCtaProv
    Created on : 4/12/2013, 06:08:18 PM
    Author     : siwebmx5
--%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="ERP.EstadoCuentaProveedor"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
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
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         EstadoCuentaProveedor edo = new EstadoCuentaProveedor(oConn);
         //Regresa los periodos
         if (strid.equals("1")) {
            String strXML = edo.getPeriodos();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado
         }
         //Regresa la informacion general de un cliente
         if (strid.equals("2")) {
            int intIdProveedor = 0;
            if (request.getParameter("PV_ID") != null) {
               try {
                  intIdProveedor = Integer.valueOf(request.getParameter("PV_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            String strXML = edo.getInfoGral(intIdProveedor);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresa los saldos globales de un periodo
         if (strid.equals("3")) {
            String strPeriodo = request.getParameter("Periodo");
            int intIdProveedor = 0;
            int intMoneda = 0;
            if (request.getParameter("PV_ID") != null) {
               try {
                  intIdProveedor = Integer.valueOf(request.getParameter("PV_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("MON_ID") != null) {
               try {
                  intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            String strXML = edo.getInfoSaldos(intIdProveedor, intMoneda, strPeriodo);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }

         //Regresa los documentos de un periodo
         if (strid.equals("4")) {
            String strPeriodo = request.getParameter("Periodo");
            int intIdProveedor = 0;
            int intMoneda = 0;
            int intConSaldo = 0;
            if (request.getParameter("PV_ID") != null) {
               try {
                  intIdProveedor = Integer.valueOf(request.getParameter("PV_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("MON_ID") != null) {
               try {
                  intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("ConSaldo") != null) {
               try {
                  intConSaldo = Integer.valueOf(request.getParameter("ConSaldo"));
               } catch (NumberFormatException ex) {
               }
            }
            String strXML = edo.getSaldosPeriodos(intIdProveedor, intMoneda, strPeriodo, intConSaldo);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   

         }
         //Regresa el historial de movimiento de una cuenta por pagar
         if (strid.equals("5")) {
            int intIdProveedor = 0;
            int intMoneda = 0;
            int intIdCxp = 0;
            if (request.getParameter("PV_ID") != null) {
               try {
                  intIdProveedor = Integer.valueOf(request.getParameter("PV_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("MON_ID") != null) {
               try {
                  intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("FAC_ID") != null) {
               try {
                  intIdCxp = Integer.valueOf(request.getParameter("FAC_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            String strXML = edo.getHistorialCxp(intIdProveedor, intMoneda, intIdCxp);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         
         //Impresion del edo de cuenta
         if (strid.equals("6")) {
            //Recibimos la respuesta
            int intIdProveedor = Integer.valueOf(request.getParameter("Proveedor"));
            int intMoneda = Integer.valueOf(request.getParameter("Moneda"));
            String strPeriodo = request.getParameter("Periodo");
            int intSoloConSaldo = Integer.valueOf(request.getParameter("iConSaldo"));
            //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_edo_cta_proveedor_" + intIdProveedor + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_edo_cta_prov_print.jrxml";
            String strReportPath = strPathBase + "WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            EstadoCuentaProveedor edoCta = new EstadoCuentaProveedor();
            edoCta.setoConn(oConn);
            edoCta.setSourceFileName(strReportPath);
            edoCta.setTargetFileName(strTargetFileName);
            edoCta.getReportPrint(intIdProveedor, intMoneda, strPeriodo, intSoloConSaldo, varSesiones, byteArrayOutputStream);

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
   }
%>