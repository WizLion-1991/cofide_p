<%-- 
    Document   : ERP_ContratoCV
    Created on : 2/07/2013, 10:25:41 AM
    Author     : SIWEB
--%>


<%@page import="comSIWeb.Operaciones.Reportes.PDFEventPage"%>
<%@page import="comSIWeb.Utilerias.StringofNumber"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="comSIWeb.Operaciones.Reportes.CIP_Formato"%>
<%@page import="comSIWeb.Operaciones.Formatos.Formateador"%>
<%@page import="comSIWeb.Operaciones.Formatos.FormateadorMasivo"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@ page import="comSIWeb.Utilerias.Fechas"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
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
      if (strCon == null) {
         strCon = "2";
      }

      //Filtro para el reporte
      String strFiltro = " CON_ID = '" + strCon + "' ";
      //String strFiltro = " CON_ID = '2' ";

      //Obtenemos los datos del cliente
      //String strCTOA_ID = request.getParameter("CTOA_ID");
      // String strIdContrato = request.getParameter("CTOA_ID");
      String CTOA_ID = request.getParameter("CTOA_ID");
      System.out.println(CTOA_ID);
      /* if (CTOA_ID == null) {
       CTOA_ID = "0";
       }*/

      //Documento donde guardaremos el formato
      Document document = new Document();
      PdfWriter writer = PdfWriter.getInstance(document,
              response.getOutputStream()/*new FileOutputStream(strPathFile + "SarquisMasivo.pdf")*/);
      //Eventos para la paginacion
      PDFEventPage pdfEvent = new PDFEventPage();
      pdfEvent.setStrTitleApp("");

      pdfEvent.setIntXPageNum(300);
      pdfEvent.setIntXPageNumRight(50);
      pdfEvent.setIntXPageTemplate(252.3f);

      //Anexamos el evento
      writer.setPageEvent(pdfEvent);
      document.open();
      /**
       * Formateador Masivo
       */
      FormateadorMasivo format = new FormateadorMasivo();
      format.setIntTypeOut(Formateador.FILE);
      //format.setStrPath(this.getServletContext().getRealPath("/"));
      format.setStrPath("c:/zeus/");
      format.InitFormat(oConn, "CONTRATO_CV");
      //format.addComodinPersonalizado("[LIC]", "JUAN MARTÍN ALCANTARA TORRES");
      //Consultamos los datos del cliente
      String strSql = "SELECT * FROM vta_contrato_arrend a, vta_cliente b, vta_empresas c, vta_bcos f, vta_monedas g "
              + "WHERE a.CTE_ID = b.CT_ID "
              + "AND b.EMP_ID = c.EMP_ID "
              + "AND a.CTOA_CUENTA = f.BC_ID "
              + "AND a.MON_ID  = g.MON_ID "
              + "AND a.CTOA_ID = " + CTOA_ID;
      ResultSet rs = oConn.runQuery(strSql);
      //System.out.println(rs);
      while (rs.next()) {
         format.addComodinPersonalizado("[RAZON_SOCIAL_EMP]", rs.getString("EMP_RAZONSOCIAL"));
         format.addComodinPersonalizado("[representantemak]", rs.getString("EMP_REPRESENTANTE"));
         format.addComodinPersonalizado("[empresa]", rs.getString("CT_RAZONSOCIAL"));
         format.addComodinPersonalizado("[representanteempresa]", rs.getString("CT_RLEGAL"));
         format.addComodinPersonalizado("[concepto]", rs.getString("CTOA_ARRENDAMIENTO"));
         String strFechaIni = fecha.DameFechaenLetra(rs.getString("CTOA_INICIO"));
         String strFechaFin = fecha.DameFechaenLetra(rs.getString("CTOA_VENCIMIENTO"));
         String strPeriodoFechas = "";
         if (!rs.getString("CTOA_INICIO").isEmpty() && !rs.getString("CTOA_VENCIMIENTO").isEmpty()) {
            strPeriodoFechas = fecha.difDiasEntre2fechasMesStr(rs.getString("CTOA_INICIO"), rs.getString("CTOA_VENCIMIENTO")) + " MESES ";
         }
         format.addComodinPersonalizado("[fechacelebracion]", fecha.DameFechaenLetra(rs.getString("CTOA_VENCIMIENTO")));
         double cantidad = Double.parseDouble(rs.getString("CTOA_DEPOSITO"));
         StringofNumber enletras = new StringofNumber();
         String letras = enletras.getStringOfNumber(cantidad);
         format.addComodinPersonalizado("[cantidadletra]", letras);
         format.addComodinPersonalizado("[folio]", rs.getString("CTOA_FOLIO"));
         format.addComodinPersonalizado("[cantidad]", rs.getString("CTOA_DEPOSITO"));
         format.addComodinPersonalizado("[dia]", rs.getString("CTOA_DIASPAGO"));
         format.addComodinPersonalizado("[banco]", rs.getString("BC_DESCRIPCION"));
         format.addComodinPersonalizado("[numero]", rs.getString("BC_CTA_CONT"));
         format.addComodinPersonalizado("[clave]", rs.getString("BC_CLABE"));
         format.addComodinPersonalizado("[moneda]", rs.getString("MON_DESCRIPCION"));

         format.addComodinPersonalizado("[seguro]", rs.getString("CTOA_VALORBMUEBLE"));
         format.addComodinPersonalizado("[suscribir]", rs.getString("CTOA_IMPORTEGARANTIA"));

         format.addComodinPersonalizado("[calle]", rs.getString("EMP_CALLE"));
         format.addComodinPersonalizado("[numero2]", rs.getString("EMP_NUMERO"));
         format.addComodinPersonalizado("[numero3]", rs.getString("EMP_NUMINT"));
         format.addComodinPersonalizado("[colonia]", rs.getString("EMP_COLONIA"));
         format.addComodinPersonalizado("[municipio]", rs.getString("EMP_MUNICIPIO"));
         format.addComodinPersonalizado("[cp]", rs.getString("EMP_CP"));
         format.addComodinPersonalizado("[localidad]", rs.getString("EMP_LOCALIDAD"));
         format.addComodinPersonalizado("[estado]", rs.getString("EMP_ESTADO"));

         format.addComodinPersonalizado("[calle1]", rs.getString("CT_CALLE"));
         format.addComodinPersonalizado("[numero1]", rs.getString("CT_NUMERO"));
         format.addComodinPersonalizado("[numeroint1]", rs.getString("CT_NUMINT"));
         format.addComodinPersonalizado("[colonia1]", rs.getString("CT_COLONIA"));
         format.addComodinPersonalizado("[municipio1]", rs.getString("CT_MUNICIPIO"));
         format.addComodinPersonalizado("[cp1]", rs.getString("CT_CP"));
         format.addComodinPersonalizado("[localidad1]", rs.getString("CT_LOCALIDAD"));
         format.addComodinPersonalizado("[estado1]", rs.getString("CT_ESTADO"));
         format.addComodinPersonalizado("[fechafirma]", fecha.FormateaDDMMAAAA(rs.getString("CTOA_FECHA_ACTUAL"), "/"));
         format.addComodinPersonalizado("[fiador]", rs.getString("CT_FIADOR"));
         // format.addComodinPersonalizado("[moneda]", rs.getString("MON_DESCRIPCION"));


      }
      rs.close();


      String strRes = format.DoFormat(oConn, strFiltro);

      //Definimos parametros para que el cliente sepa que es un PDF
      response.setContentType("application/pdf");
      response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "Contratocv.pdf");
      response.setHeader("cache-control", "no-cache");

      System.out.println("strRes: " + strRes);
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
   oConn.close();
%>
