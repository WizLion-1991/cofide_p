<%-- 
    Document   : rhh_Reportes
    Created on : 27/05/2015, 04:25:54 PM
    Author     : siweb
--%>

<%@page import="com.mx.siweb.erp.reportes.RepoPreNomina"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="com.sun.xml.rpc.processor.modeler.j2ee.xml.string"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
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
   UtilXml util = new UtilXml();

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

            int intTipoNom = Integer.parseInt(request.getParameter("intTipoNom"));
            RepoPreNomina ci = new RepoPreNomina(oConn, varSesiones, intTipoNom);
            ci.RepoPreNomina_HacerReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(ci.GeneraXml());//Pintamos el resultado

         }

         if (strid.equals("2")) {
            
            String strboton_1 = request.getParameter("boton_1");
            
            int intTipoNom = Integer.parseInt(request.getParameter("intTipoNom"));
            RepoPreNomina ci = new RepoPreNomina(oConn, varSesiones, intTipoNom);

              //Aqui se ira la respuesta
            ServletOutputStream outputstream = response.getOutputStream();
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            String strTargetFileName = "rep_prenomina" + ".pdf";
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            String strReportFile = "rep_prenomina.jrxml";
            String strReportPath = strPathBase + "/WEB-INF"
                    + strSeparator + "jreports"
                    + strSeparator + strReportFile;

            //    ci.loadXMLFrom(new java.io.ByteArrayInputStream(strXml.getBytes("UTF-8")));
            ci.RepoPreNomina_HacerReporte();
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

      }
   } else {
      out.println("Sin acceso");
   }
   oConn.close();


%>
