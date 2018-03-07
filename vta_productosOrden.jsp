<%-- 
    Document   : vta_productosOrden
    Created on : 23/10/2012, 12:53:25 PM
    Author     : N4v1d4d3s
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="ERP.Precios" %>
<%@ page import="ERP.Producto" %>
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
      String strid = request.getParameter("ID");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {

         //NOS REGRESA LOS DATOS DE LOS PRODUCTOS CON ORDENES DE COMPRA
         if (strid.equals("1")) {
            String strId = "";
            String strFiltro = "";
            String strReplace = "";

            if (request.getParameter("codigo") != null && !request.getParameter("codigo").equals("")) {
               strId = request.getParameter("codigo");
               strFiltro = " AND a.PR_CODIGO like '" + strId + "%'";
            }
            String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            //utilerias
            UtilXml util = new UtilXml();
            Fechas fecha = new Fechas();
            //Armamos el xml
            try {

               String strConsulta = "SELECT b.COM_ID,a.PR_CODIGO,a.PR_DESCRIPCION,b.COM_FOLIO,b.COM_FECHA_PROMESA,c.COMD_CANTIDAD,b.COM_FECHA,b.COM_FECHA_DISP_VTA,DATEDIFF(b.COM_FECHA_DISP_VTA,CURDATE()) AS COM_DIAS"
                       + ",(select TOD_DESC from vta_tipoodc where vta_tipoodc.TOD_ID = b.TOD_ID) as tipoodc"
                       + " FROM vta_producto a, vta_compra b, vta_compradeta c"
                       + " WHERE b.COM_ID = c.COM_ID"
                       + " AND b.COM_SURTIDA = 0"
                       + " AND b.COM_AUTORIZA=1"
                       + " AND b.COM_STATUS  IN (1,2,4)"
                       + " AND c.COMD_CANTIDADSURTIDA < c.COMD_CANTIDAD"
                       + " AND a.PR_ID=c.PR_ID "
                       + " AND b.EMP_ID = " + varSesiones.getIntIdEmpresa()
                       + " " + strFiltro;
               ResultSet rs = oConn.runQuery(strConsulta);

               strXMLData += "<folios>";
               strXMLData += "<folio>";
               while (rs.next()) {

                  strReplace = rs.getString("PR_DESCRIPCION").replace(",", "");
                  strReplace = util.Sustituye(strReplace);

                  strXMLData += "<datos";
                  strXMLData += " PR_CODIGO=\"" + util.Sustituye(rs.getString("PR_CODIGO")) + "\"";
                  strXMLData += " PR_DESCRIPCION=\"" + util.Sustituye(strReplace) + "\"";
                  strXMLData += " COM_ID=\"" + rs.getString("COM_FOLIO") + "\"";
                  if(!rs.getString("COM_FECHA_PROMESA").isEmpty())
                  {    
                  strXMLData += " PR_FECHA_PROMESA=\"" + fecha.FormateaDDMMAAAA(rs.getString("COM_FECHA_PROMESA"), "/") + "\"";
                  }
                  else {
                      strXMLData += " PR_FECHA_PROMESA=\"\"";
                  }
                  strXMLData += " COMD_CANTIDAD=\"" + rs.getInt("COMD_CANTIDAD") + "\"";
                  strXMLData += " COM_ID_HIDDEN=\"" + rs.getInt("COM_ID") + "\"";
                  strXMLData += " COM_FECHA=\"" + fecha.FormateaDDMMAAAA(rs.getString("COM_FECHA"), "/") + "\"";
                  if(!rs.getString("COM_FECHA_DISP_VTA").isEmpty())
                  {
                  strXMLData += " COM_FECHA_DISP_VTA=\"" + fecha.FormateaDDMMAAAA(rs.getString("COM_FECHA_DISP_VTA"), "/") + "\"";
                  }
                  else
                  {
                      strXMLData += " COM_FECHA_DISP_VTA=\"\"";
                  }
                  if (rs.getString("COM_DIAS") != null) {
                     strXMLData += " COM_DIAS=\"" + rs.getString("COM_DIAS") + "\"";
                  } else {
                     strXMLData += " COM_DIAS=\"" + "" + "\"";
                  }
                  
                  strXMLData += " tipoodc=\"" + rs.getString("tipoodc") + "\"";
                  strXMLData += "/>";
               }
               strXMLData += "</folio>";
               strXMLData += "</folios>";
               rs.close();

            } catch (SQLException ex) {
               ex.fillInStackTrace();
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXMLData);//Mandamos a pantalla el resultado
         }
         //SIRVE PARA MODIFICAR LA FECHA PROMESA 
         if (strid.equals("2")) {
            Fechas fecha = new Fechas();
            String strComId = "0";
            String strFecha = "";
            String strRes = "";


            if (!request.getParameter("idCompra").equals("") && !request.getParameter("idCompra").equals(null)) {
               strComId = request.getParameter("idCompra");
               strFecha = fecha.FormateaBD(request.getParameter("fecha"), "/");
               String strUpdate = "UPDATE vta_compra set COM_FECHA_DISP_VTA=" + strFecha + " WHERE COM_ID=" + strComId;

               oConn.runQueryLMD(strUpdate);
               strRes = "OK";
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Mandamos a pantalla el resultado

         }
         //NOS REGRESA LOS DATOS DE LOS PRODUCTOS DE RECIEN INGRESO
         if (strid.equals("3")) {
            String strId = "";
            String strFiltro = "";
            String strReplace = "";
            Fechas fecha = new Fechas();
            if (request.getParameter("codigo") != null && !request.getParameter("codigo").equals("")) {
               strId = request.getParameter("codigo");
               strFiltro = " AND a.PR_CODIGO like '" + strId + "%'";
            }
            if (request.getParameter("fecha_ini") != null && !request.getParameter("fecha_ini").equals("")
                    && request.getParameter("fecha_fin") != null && !request.getParameter("fecha_fin").equals("")) {
               String strFechaIni = request.getParameter("fecha_ini");
               String strFechFin = request.getParameter("fecha_fin");
               if(!strFechaIni.isEmpty()){
                  strFechaIni = fecha.FormateaBD(strFechaIni, "/");
               }
               if(!strFechFin.isEmpty()){
                  strFechFin = fecha.FormateaBD(strFechFin, "/");
               }
               strFiltro += " AND b.MP_FECHA>= '" + strFechaIni + "' AND  b.MP_FECHA<= '" + strFechFin + "'";
            }
            StringBuilder strXMLData = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>") ;
            //utilerias
            UtilXml util = new UtilXml();
            
            //Armamos el xml
            try {

               String strConsulta = "SELECT a.PR_CODIGO,a.PR_DESCRIPCION,"
                       + " b.MP_FOLIO,b.MP_FECHA,SUM(c.MPD_ENTRADAS) as TEntrada,a.PR_EXISTENCIA,b.MP_FECHA "
                       + " FROM vta_producto a, vta_movprod b, vta_movproddeta c"
                       + "  WHERE b.MP_ID = c.MP_ID"
                       + "  AND a.PR_ID=c.PR_ID"
                       + "  AND c.MPD_ENTRADAS > 0 AND b.OC_ID <> 0"
                       + " " + strFiltro 
                       + " AND b.EMP_ID = " + varSesiones.getIntIdEmpresa()
                       + " GROUP BY a.PR_CODIGO,a.PR_DESCRIPCION,"
                       + " b.MP_FOLIO,b.MP_FECHA,a.PR_EXISTENCIA,b.MP_FECHA";
               ResultSet rs = oConn.runQuery(strConsulta);

               strXMLData.append( "<folios>");
               strXMLData.append("<folio>");
               while (rs.next()) {

                  strReplace = rs.getString("PR_DESCRIPCION").replace(",", "");
                  strReplace = util.Sustituye(strReplace);

                  strXMLData.append("<datos");
                  strXMLData.append(" PR_CODIGO=\"" + util.Sustituye(rs.getString("PR_CODIGO")) + "\"");
                  strXMLData.append(" PR_DESCRIPCION=\"" + util.Sustituye(strReplace) + "\"");
                  strXMLData.append(" MP_FOLIO=\"" + rs.getString("MP_FOLIO") + "\"");
                  strXMLData.append(" MP_FECHA=\"" + fecha.FormateaDDMMAAAA(rs.getString("MP_FECHA"), "/") + "\"");
                  strXMLData.append(" ENTRADAS=\"" + rs.getDouble("TEntrada") + "\"");
                  strXMLData.append(" EXISTENCIA=\"" + rs.getInt("PR_EXISTENCIA") + "\"");
                  strXMLData.append("/>");
               }
               strXMLData.append("</folio>");
               strXMLData.append("</folios>" );
               rs.close();

            } catch (SQLException ex) {
               ex.fillInStackTrace();
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXMLData.toString());//Mandamos a pantalla el resultado
         }
      } else {
      }
      oConn.close();
   }
%>