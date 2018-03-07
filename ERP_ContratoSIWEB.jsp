<%-- 
    Document   : ERP_ContratoSIWEB
    Genera las facturas de contratos para SIWEB
    Created on : 09-feb-2015, 14:05:12
    Author     : ZeusGalindo
--%>

<%@page import="org.apache.struts.util.MessageResources"%>
<%@page import="com.SIWeb.struts.SelEmpresaAction"%>
<%@page import="com.mx.siweb.erp.especiales.siweb.FacturacionMasiva"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Tablas.vta_pedidos"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="ERP.FacturaMasiva"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.CIP_Form" %>
<%@page import="Tablas.Usuarios" %>
<%@page import="Tablas.vta_ticketsdeta" %>
<%@page import="Tablas.vta_pedidosdeta" %>
<%@page import="Tablas.vta_facturadeta" %>
<%@page import="Tablas.vta_cotizadeta" %>
<%@page import="Tablas.vta_mov_cte_deta" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
<%@page import="ERP.Ticket" %>
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
      //Recuperamos paths de web.xml
      String strPathXML = this.getServletContext().getInitParameter("PathXml");
      String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
      String strmod_Inventarios = this.getServletContext().getInitParameter("mod_Inventarios");
      String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
      String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
      String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
      if (strSist_Costos == null) {
         strSist_Costos = "0";
      }
      if (strfolio_GLOBAL == null) {
         strfolio_GLOBAL = "SI";
      }
      if (strmod_Inventarios == null) {
         strmod_Inventarios = "NO";
      }
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid == null) {
         strid = "1";
      }
      if (strid != null) {
         //Facturacion de pedidos recurrentes
         if (strid.equals("1")) {
            //Recibimos parametros
            String strAnio = request.getParameter("Anio");
            String strMes = request.getParameter("Mes");
            int intMes = 0;
            try {
               intMes = Integer.valueOf(strMes);
            } catch (NumberFormatException ex) {

            }

            //Generamos objeto de facturacion recurrente
            FacturacionMasiva mas = new FacturacionMasiva(oConn, varSesiones, request);

            //Obtenemos mensajes de struts
            SelEmpresaAction sel = new SelEmpresaAction();
            MessageResources msgRes = sel.getmessageResources(request);

            mas.setContext(this.getServletContext());
            mas.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            //mas.setMsgRes(msgRes);
            mas.setStrPATHBase(strPathXML);
            mas.setStrPathPrivateKeys(strPathPrivateKeys);
            mas.setStrPathXML(strPathXML);
            mas.setStrPathFonts(strPathFonts);

            mas.setStrAnio(strAnio);
            mas.setIntMes(intMes);
            mas.setIntSC_ID(1);
            mas.doTrx();
            mas.doInvoices();

            //Recuperamos resultado de la operacion
            String strRes = mas.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
      }
   } else {
   }
   oConn.close();
%>