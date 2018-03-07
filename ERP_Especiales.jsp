<%-- 
    Document   : ERP_Especiales
    Ejecuta diversas aplicaciones especiales de los clientes
    Created on : 23-jun-2013, 10:57:10
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.mx.siweb.erp.especiales.innte.ExportaTickets"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         // <editor-fold defaultstate="collapsed" desc="Exporta información de tickets">
         if (strid.equals("1")) {
            String strFecha_Ini = request.getParameter("Fecha_Ini");
            String strFecha_Fin = request.getParameter("Fecha_Fin");
            Fechas fechas = new Fechas();
            if (strFecha_Ini == null) {
               strFecha_Ini = "";
            } else {
               strFecha_Ini = fechas.FormateaBD(strFecha_Ini, "/");
            }
            if (strFecha_Fin == null) {
               strFecha_Fin = "";
            } else {
               strFecha_Fin = fechas.FormateaBD(strFecha_Fin, "/");
            }
            //Exportamos los tickets
            ExportaTickets exportaTickets = new ExportaTickets();
            String strTXT = exportaTickets.GenerarTxt(oConn, strFecha_Ini, strFecha_Fin);
            out.clearBuffer();//Limpiamos buffer
            response.setContentType("text/plain");
            response.setHeader("content-disposition", "attachment; filename=ExportaOB10.txt");
            response.setHeader("cache-control", "no-cache");
            //text/plain
            out.print(strTXT);//Pintamos el resultado
         }
         // </editor-fold>

         // <editor-fold defaultstate="collapsed" desc="Envia informacion del contrato">
         if (strid.equals("2")) {
            StringBuilder strResp = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strResp.append("<contratos>");
            //Para formatear
            UtilXml objUtilXml = new UtilXml();
            String strFolio = request.getParameter("CTOA_FOLIO");
            //vta_contrato_arrend
            String strSql = "select CTE_ID,CTOA_ARRENDAMIENTO from vta_contrato_arrend where CTOA_FOLIO='" + strFolio + "'";
            try {
               ResultSet rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  strResp.append("<contrato "
                          + " Cliente=\"" + rs.getInt("CTE_ID")  + "\""
                          + " Nota=\"" + objUtilXml.Sustituye(rs.getString("CTOA_ARRENDAMIENTO")) + "\""
                          + "/>");
               }
               rs.close();
            } catch (SQLException ex) {

            }
            strResp.append("</contratos>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResp.toString());//Pintamos el resultado
         }
         // </editor-fold>
      }
   } else {
   }
   oConn.close();
%>