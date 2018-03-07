<%-- 
    Document   : ERP_XML_Download
    Created on : 16-jul-2012, 18:48:25
    Author     : aleph_79
--%>


<%@page import="ERP.Ticket"%>
<%@page import="ERP.ERP_MapeoFormato"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
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
<%@page contentType="application/octet-stream"%> 
<%@page pageEncoding="UTF-8"%> 
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
      int intNomId = 0;
      String strNomRazonSocial = "";
      String strNomFecha = "";
      String strNomUUID = "";
      //Recuperamos el id de la factura
      String strPathXML = this.getServletContext().getInitParameter("PathXml");
      /*Definimos parametros de la aplicacion*/
      String strNomXML = "Factura_{01}.xml";
      String strValorBuscar = request.getParameter("FAC_ID");
      String strPathFile = strPathXML + "XmlSAT" + strValorBuscar + " .xml";
      if (strValorBuscar == null) {
         strValorBuscar = request.getParameter("NC_ID");
         strPathFile = strPathXML + "NC_XML" + strValorBuscar + ".xml";
         strNomXML = "Nota_de_credito_{01}.xml";
         if (strValorBuscar == null) {
            strValorBuscar = request.getParameter("NOM_ID");
            strPathFile = strPathXML + "Nomina_" + strValorBuscar + ".xml";
            strNomXML = "Recibo_de_nomina_{01}.xml";
            if (strValorBuscar == null) {
               strValorBuscar = request.getParameter("RET_ID");
               strPathFile = strPathXML + "Retenciones_" + strValorBuscar + ".xml";
               strNomXML = "Retenciones_{01}.xml";
               if (strValorBuscar == null) {
                  strValorBuscar = request.getParameter("NCA_ID");
                  strPathFile = strPathXML + "NotasCargo_" + strValorBuscar + ".xml";
                  strNomXML = "NotasCargo_{01}.xml";
                  if (strValorBuscar == null) {
                     strValorBuscar = request.getParameter("NCA_IDP");
                     strPathFile = strPathXML + "NotasCargoProv_" + strValorBuscar + ".xml";
                     strNomXML = "NotasCargoProv_{01}.xml";
                  }
               }
            }
         }
      }

      if (strValorBuscar != null) {

         //Buscamos el folio del documento conforme corresponda
         String strFolio = "";
         String strSql = "";
         if (strNomXML.startsWith("Factura_")) {
            strSql = "select FAC_FOLIO,FAC_FOLIO_C, FAC_RAZONSOCIAL,FAC_ID,FAC_FECHA from vta_facturas where FAC_ID = " + strValorBuscar;
         } else if (strNomXML.startsWith("Nota_de_credito_")) {
            strSql = "select NC_FOLIO,NC_FOLIO_C ,NC_ID,NC_RAZONSOCIAL,NC_FECHA  from vta_ncredito where NC_ID = " + strValorBuscar;
         } else if (strNomXML.startsWith("Recibo_de_nomina_")) {
            strSql = "select NOM_FOLIO,NOM_ID,NOM_RAZONSOCIAL,NOM_FECHA,NOM_UUID from rhh_nominas where NOM_ID = " + strValorBuscar;
         } else if (strNomXML.startsWith("Retenciones_")) {
            strSql = "select RET_FOLIOINT from rhh_ret_retenciones where RET_ID = " + strValorBuscar;
         } else if (strNomXML.startsWith("NotasCargo_")) {
            strSql = "select NCA_FOLIO,NCA_FOLIO_C, NCA_RAZONSOCIAL,NCA_ID,NCA_FECHA from vta_notas_cargos where NCA_ID = " + strValorBuscar;
         }else if (strNomXML.startsWith("NotasCargoProv_")) {
            strSql = "select NCA_FOLIO,NCA_FOLIO_C, NCA_RAZONSOCIAL,NCA_ID,NCA_FECHA from vta_notas_cargosprov where NCA_ID = " + strValorBuscar;
         }
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            if (strNomXML.startsWith("Factura_")) {
               strFolio = rs.getString("FAC_FOLIO_C");
               intNomId = rs.getInt("FAC_ID");
               strNomRazonSocial = rs.getString("FAC_RAZONSOCIAL");
               strNomFecha = rs.getString("FAC_FECHA");
               strNomUUID = rs.getString("FAC_FOLIO");
            } else if (strNomXML.startsWith("Nota_de_credito_")) {
               strFolio = rs.getString("NC_FOLIO_C");
               intNomId = rs.getInt("NC_ID");
               strNomRazonSocial = rs.getString("NC_RAZONSOCIAL");
               strNomFecha = rs.getString("NC_FECHA");
               strNomUUID = rs.getString("NC_FOLIO");
            } else if (strNomXML.startsWith("Recibo_de_nomina_")) {
               strFolio = rs.getString("NOM_FOLIO");
               intNomId = rs.getInt("NOM_ID");
               strNomRazonSocial = rs.getString("NOM_RAZONSOCIAL");
               strNomFecha = rs.getString("NOM_FECHA");
               strNomUUID = rs.getString("NOM_UUID");
            } else if (strNomXML.startsWith("Retenciones_")) {
               strFolio = rs.getString("RET_FOLIOINT");
            } else if (strNomXML.startsWith("NotasCargo_")) {
               strFolio = rs.getString("NCA_FOLIO_C");
               intNomId = rs.getInt("NCA_ID");
               strNomRazonSocial = rs.getString("NCA_RAZONSOCIAL");
               strNomFecha = rs.getString("NCA_FECHA");
               strNomUUID = rs.getString("NCA_FOLIO");
            }else if (strNomXML.startsWith("NotasCargoProv_")) {
               strFolio = rs.getString("NCA_FOLIO_C");
               intNomId = rs.getInt("NCA_ID");
               strNomRazonSocial = rs.getString("NCA_RAZONSOCIAL");
               strNomFecha = rs.getString("NCA_FECHA");
               strNomUUID = rs.getString("NCA_FOLIO");
            }

         }
         rs.close();
         strNomXML = strNomXML.replace("{01}", strFolio);
         //Limpiamos  el buffer
         out.clear();
         BufferedInputStream filein = null;
         BufferedOutputStream outputs = null;
         try {
            File file = new File(strPathFile);//specify the file path 

            if (file.exists()) {
               byte b[] = new byte[2048];
               int len = 0;
               filein = new BufferedInputStream(new FileInputStream(file));
               outputs = new BufferedOutputStream(response.getOutputStream());
               response.setHeader("Content-Length", "" + file.length());
               response.setContentType("application/force-download");
               response.setHeader("Content-Disposition", "attachment;filename=" + strNomXML);
               response.setHeader("Content-Transfer-Encoding", "binary");
               while ((len = filein.read(b)) > 0) {
                  outputs.write(b, 0, len);
                  outputs.flush();
               }
            } else {
               //Version 2.0
               StringBuilder strNomFile = new StringBuilder("");
               ERP_MapeoFormato mapeoXml = null;
               if (strNomXML.startsWith("Factura_")) {
                  mapeoXml = new ERP_MapeoFormato(1);
               } else if (strNomXML.startsWith("Nota_de_credito_")) {
                  mapeoXml = new ERP_MapeoFormato(5);
               } else if (strNomXML.startsWith("Recibo_de_nomina_")) {
                  mapeoXml = new ERP_MapeoFormato(7);
               } else if (strNomXML.startsWith("Retenciones_")) {
                  //No implementado...
               } else if (strNomXML.startsWith("NotasCargo_")) {
                  mapeoXml = new ERP_MapeoFormato(8);
               }else if (strNomXML.startsWith("NotasCargoProv_")) {
                  mapeoXml = new ERP_MapeoFormato(9);
               }
               //Objeto para obtener el nombre
               Ticket ticket = new Ticket(oConn, varSesiones);
               strNomFile.append(ticket.getNombreFileXml(mapeoXml, intNomId, strNomRazonSocial, strNomFecha, strNomUUID));
               file = new File(strPathXML + strNomFile.toString());//specify the file path 

               byte b[] = new byte[2048];
               int len = 0;
               filein = new BufferedInputStream(new FileInputStream(file));
               outputs = new BufferedOutputStream(response.getOutputStream());
               response.setHeader("Content-Length", "" + file.length());
               response.setContentType("application/force-download");
               response.setHeader("Content-Disposition", "attachment;filename=" + strNomFile.toString());
               response.setHeader("Content-Transfer-Encoding", "binary");
               while ((len = filein.read(b)) > 0) {
                  outputs.write(b, 0, len);
                  outputs.flush();
               }
            }

         } catch (Exception e) {
            out.println(e);
         }
      }

   } else {
   }
   oConn.close();
%>


