<%-- 
    Document   : PRO_Contrato
    Created on : 3/10/2013, 11:41:17 AM
    Author     : siweb
--%>

<%@page import="comSIWeb.Operaciones.Reportes.CIP_Formato"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Formatos.Formateador"%>
<%@page import="comSIWeb.Operaciones.Formatos.FormateadorMasivo"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
      Fechas fecha = new Fechas();
      //Path para el documento
      String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
      /*Definimos parametros de la aplicacion*/
      String strCon = request.getParameter("ID");
      //System.out.println("CONTRATO:  " + strCon);
      if (strCon == null) {
         strCon = strCon;
      }
      //Filtro para el reporte
      String strFiltro = " CON_ID = '" + strCon + "' ";
      String intCTO_ID = "CTO_ID = '" + request.getParameter("CTO_ID") + "'";
      String strFiltro2 = " or FM_ABRV = 'ANEXOA' or FM_ABRV = 'FIRMAS' or FM_ABRV = 'SOLICITUD1' or FM_ABRV = 'SOLICITUD2' or FM_ABRV = 'CROQUIS' or FM_ABRV = 'PAGARE'; ";
      //System.out.println("CREDITO:  " + intCTO_ID);
      //Documento donde guardaremos el formato
      Document document = new Document();
      PdfWriter writer = PdfWriter.getInstance(document,
              response.getOutputStream()/*new FileOutputStream(strPathFile + "SarquisMasivo.pdf")*/);
      document.open();
      /**
       * Formateador Masivo
       */
      FormateadorMasivo format = new FormateadorMasivo();
      format.setIntTypeOut(Formateador.FILE);
      //format.setStrPath(this.getServletContext().getRealPath("/"));
      //format.setStrPath("c:/zeus/");

      String strid = request.getParameter("ID");
      if (strid != null) {
         if (strid.equals("1")) {
            format.InitFormat(oConn, "CONTRATO");
            //Consultamos los datos del cliente
            String strSql = "select CT_NOM,OB_NOMBRE from cat_credito where CTO_ID = " + intCTO_ID;
            ResultSet rs = oConn.runQuery(strSql);
            //System.out.println(rs);
            while (rs.next()) {
               format.addComodinPersonalizado("[ACREDITADO]", rs.getString("CT_NOM"));
               format.addComodinPersonalizado("[OBLIGADO]", rs.getString("OB_NOMBRE"));

            }
            rs.close();


            String strRes = format.DoFormat(oConn, strFiltro);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }
         } else {
         }

         if (strid.equals("2")) {
            format.InitFormat(oConn, "CARATULA");
            String strRes = format.DoFormat(oConn, intCTO_ID);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }

         }

         if (strid.equals("3")) {
            format.InitFormat(oConn, "PAGARE");
            String strRes = format.DoFormat(oConn, intCTO_ID);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }
         }
         if (strid.equals("4")) {
            format.InitFormat(oConn, "SOLICITUD1");
            String strRes = format.DoFormat(oConn, intCTO_ID);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }
         }
         if (strid.equals("5")) {
            format.InitFormat(oConn, "SOLICITUD2");
            String strRes = format.DoFormat(oConn, intCTO_ID);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }
         }
         if (strid.equals("6")) {
            format.InitFormat(oConn, "ANEXOA");
            //System.out.println("credito: " + intCTO_ID);            
            String strRes = format.DoFormat(oConn, intCTO_ID);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }
         }
         if (strid.equals("7")) {
            format.InitFormat(oConn, "FIRMAS");
            //System.out.println("credito: " + intCTO_ID);            
            String strRes = format.DoFormat(oConn, intCTO_ID);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }
         }
         if (strid.equals("8")) {
            format.InitFormat(oConn, "CROQUIS");
            //System.out.println("credito: " + intCTO_ID);            
            String strRes = format.DoFormat(oConn, intCTO_ID);

            //Definimos parametros para que el cliente sepa que es un PDF
            response.setContentType("application/pdf");
            response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "_Contrato.pdf");
            response.setHeader("cache-control", "no-cache");

            //System.out.println("strRes: " + strRes);
            if (strRes.equals("OK")) {
               CIP_Formato fPDF = new CIP_Formato();
               fPDF.setDocument(document);
               fPDF.setWriter(writer);
               fPDF.setStrPathFonts(strPathFonts);
               fPDF.EmiteFormatoMasivo(format.getFmXML());
               document.close();
               writer.close();
            }
         }
      }
   }

   oConn.close();

%>