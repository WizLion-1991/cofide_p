<%-- 
    Document   : ERP_FacRecu
      Realiza las operaciones de generacion de facturas recurrentes en base a los pedidos
    Created on : 15/02/2011, 12:44:52 PM
    Author     : zeus
--%>

<%@page import="ERP.FacRecurrente"%>
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
      if (strid != null) {
         //Facturacion de pedidos recurrentes
         if (strid.equals("1")) {
            //Recibimos parametros
            String strlstPD_ID = request.getParameter("LST_PD_ID");
            //Generamos objeto de facturacion recurrente
            FacRecurrente recurrente = new FacRecurrente(oConn, varSesiones, request, this.getServletContext());
            recurrente.Init();
            recurrente.setStrPathPrivateKeys(strPathPrivateKeys);
            recurrente.setStrPathXML(strPathXML);
            recurrente.setStrPathFonts(strPathFonts);
            recurrente.setBolEsLocal(false);
            if (strmod_Inventarios.equals("SI")) {
               recurrente.setBolAfectaInv(true);
            } else {
               recurrente.setBolAfectaInv(false);
            }
            //Definimos el sistema de costos
            try {
               recurrente.setIntSistemaCostos(Integer.valueOf(strSist_Costos));
            } catch (NumberFormatException ex) {
               System.out.println("No hay sistema de costos definido");
            }
            recurrente.setBolTransaccionalidad(true);
            if (strfolio_GLOBAL.equals("SI")) {
               recurrente.setBolFolioGlobal(true);
            } else {
               recurrente.setBolFolioGlobal(false);
            }
            recurrente.setStrLstIdFacturar(strlstPD_ID);
            //Obtenemos la fecha definida por el usuario
            if (request.getParameter("USA_FECHAUSER") != null) {
               //Objeto para manejo de fechas
               Fechas fecha = new Fechas();
               int intUSA_FECHAUSER = 0;
               try {
                  intUSA_FECHAUSER = Integer.valueOf(request.getParameter("USA_FECHAUSER"));
               } catch (NumberFormatException ex) {
               }
               //Si el valor es 1 quiere decir que usaremos la fecha definida por el usuario
               if (intUSA_FECHAUSER == 1) {
                  recurrente.setBolUsaFechUser(true);
                  recurrente.setStrFechaUser(fecha.FormateaBD(request.getParameter("FAC_FECHA_US"), "/"));
               }
            }
            recurrente.doTrx();
            //Recuperamos resultado de la operacion
            String strRes = "";
            if (recurrente.getStrResultLast().equals("OK")) {
               strRes = "OK." + recurrente.getStrFolioGen1() + " - " + recurrente.getStrFolioGen2();
            } else {
               strRes = recurrente.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
      }
   } else {
   }
   oConn.close();
%>