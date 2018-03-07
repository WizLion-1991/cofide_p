<%-- 
    Document   : ERP_PagareArrendamiento
    Created on : 2/07/2013, 03:08:57 PM
    Author     : SIWEB
--%>


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
        String strFiltro = " PAG_ID = '" + strCon + "' ";
        
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
        document.open();
        /**Formateador Masivo*/
        FormateadorMasivo format = new FormateadorMasivo();
        format.setIntTypeOut(Formateador.FILE);
        //format.setStrPath(this.getServletContext().getRealPath("/"));
        format.setStrPath("c:/zeus/");
        format.InitFormat(oConn, "PAGARE ARREN");
        //format.addComodinPersonalizado("[LIC]", "JUAN MARTÍN ALCANTARA TORRES");
        //Consultamos los datos del cliente
        String strSql = "SELECT * FROM vta_contrato_arrend a, vta_cliente b, vta_empresas c, vta_bcos f, vta_monedas g "
                + "WHERE a.CTE_ID = b.CT_ID "
                + "AND b.EMP_ID = c.EMP_ID "
                + "AND a.CTOA_CUENTA = f.BC_ID "
                + "AND f.BC_MONEDA = g.MON_ID "
                + "AND a.CTOA_ID = " + CTOA_ID;
        ResultSet rs = oConn.runQuery(strSql);
        //System.out.println(rs);
        while (rs.next()) {
            format.addComodinPersonalizado("[representante]", rs.getString("CT_RLEGAL"));
            format.addComodinPersonalizado("[empresa]", rs.getString("CTE_NOMBRE"));
            String strFechaIni = fecha.DameFechaenLetra(rs.getString("CTOA_INICIO"));
            String strFechaFin = fecha.DameFechaenLetra(rs.getString("CTOA_VENCIMIENTO"));
            String strPeriodoFechas = "";
            if (!rs.getString("CTOA_INICIO").isEmpty() && !rs.getString("CTOA_VENCIMIENTO").isEmpty()) {
                strPeriodoFechas = fecha.difDiasEntre2fechasMesStr(rs.getString("CTOA_INICIO"), rs.getString("CTOA_VENCIMIENTO")) + " MESES ";
            }
            format.addComodinPersonalizado(" [fechavencimiento]", fecha.FormateaDDMMAAAA(rs.getString("CTOA_VENCIMIENTO"), "/"));
            double cantidad = Double.parseDouble(rs.getString("CTOA_VARES"));
            StringofNumber enletras = new StringofNumber();
            String letras = enletras.getStringOfNumber(cantidad);
            format.addComodinPersonalizado("[cantidadletra]", letras);
            format.addComodinPersonalizado("[cantidad]", rs.getString("CTOA_VARES"));
            format.addComodinPersonalizado("[folio]", rs.getString("CTOA_FOLIO"));
            format.addComodinPersonalizado("[banco]", rs.getString("BC_DESCRIPCION"));
            format.addComodinPersonalizado("[cuenta]", rs.getString("CTOA_NUMPOLIZA"));
            format.addComodinPersonalizado("[clave]", rs.getString("BC_CLABE"));
            format.addComodinPersonalizado("[fechafirma]", fecha.FormateaDDMMAAAA(rs.getString("CTOA_FECHA_ACTUAL"), "/"));
            format.addComodinPersonalizado("[fiador]", rs.getString("CTE_FIADOR"));
        }
        rs.close();


        String strRes = format.DoFormat(oConn, strFiltro);

        //Definimos parametros para que el cliente sepa que es un PDF
        response.setContentType("application/pdf");
        response.setHeader("content-disposition", "attachment; filename=" + format.getStrTitulo().replace(" ", "_") + "Contrato.pdf");
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
