<%-- 
    Document   : ReportesJasper
   Este jsp se encarga de las operaciones de administracion de los reportes jasper
    Created on : 17-may-2013, 14:37:05
    Author     : ZeusGalindo
--%>
<%@page import="com.mx.siweb.erp.reportes.ReportParams"%>
<%@page import="Tablas.repo_params"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Bitacora" %>
<%@ page import="comSIWeb.Operaciones.CIP_Tabla" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>

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
      /*Definimos parametros de la aplicacion*/
      String strid = request.getParameter("id");
      if (strid == null) {
         strid = "0";
      }
      // <editor-fold defaultstate="collapsed" desc="Nuevo parametro">
      if (strid.equals("1")) {
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         ReportParams params = new ReportParams(oConn);
         repo_params r = new repo_params();
         r.setFieldInt("REP_ID", Integer.valueOf(request.getParameter("REP_ID")));
         r.setFieldString("REPP_NOMBRE", request.getParameter("REPP_NOMBRE"));
         r.setFieldString("REPP_VARIABLE", request.getParameter("REPP_VARIABLE"));
         r.setFieldString("REPP_TIPO", request.getParameter("REPP_TIPO"));
         r.setFieldString("REPP_DATO", request.getParameter("REPP_DATO"));
         r.setFieldString("REPP_TABLAEXT", request.getParameter("REPP_TABLAEXT"));
         r.setFieldString("REPP_ENVIO", request.getParameter("REPP_ENVIO"));
         r.setFieldString("REPP_MOSTRAR", request.getParameter("REPP_MOSTRAR"));
         r.setFieldString("REPP_PRE", request.getParameter("REPP_PRE"));
         r.setFieldString("REPP_POST", request.getParameter("REPP_POST"));
         r.setFieldString("REPP_DEFAULT", request.getParameter("REPP_DEFAULT"));
         String strRes = params.Agrega(r);
         out.println(strRes);//Pintamos el resultado
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Modificar parametro">
      if (strid.equals("2")) {
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         ReportParams params = new ReportParams(oConn);
         repo_params r = new repo_params();
         r.ObtenDatos(Integer.valueOf(request.getParameter("REPP_ID")), oConn);
         r.setFieldInt("REP_ID", Integer.valueOf(request.getParameter("REP_ID")));
         r.setFieldString("REPP_NOMBRE", request.getParameter("REPP_NOMBRE"));
         r.setFieldString("REPP_VARIABLE", request.getParameter("REPP_VARIABLE"));
         r.setFieldString("REPP_TIPO", request.getParameter("REPP_TIPO"));
         r.setFieldString("REPP_DATO", request.getParameter("REPP_DATO"));
         r.setFieldString("REPP_TABLAEXT", request.getParameter("REPP_TABLAEXT"));
         r.setFieldString("REPP_ENVIO", request.getParameter("REPP_ENVIO"));
         r.setFieldString("REPP_MOSTRAR", request.getParameter("REPP_MOSTRAR"));
         r.setFieldString("REPP_PRE", request.getParameter("REPP_PRE"));
         r.setFieldString("REPP_POST", request.getParameter("REPP_POST"));
         r.setFieldString("REPP_DEFAULT", request.getParameter("REPP_DEFAULT"));
         String strRes = params.Modifica(r);
         out.println(strRes);//Pintamos el resultado
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Borrar parametro">
      if (strid.equals("3")) {
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         ReportParams params = new ReportParams(oConn);
         repo_params r = new repo_params();
         r.ObtenDatos(Integer.valueOf(request.getParameter("REPP_ID")), oConn);

         String strRes = params.Borra(r);
         out.println(strRes);//Pintamos el resultado
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Consultar parametro">
      if (strid.equals("4")) {
         String strIdRepo = request.getParameter("IdRepo");
         if(strIdRepo == null)strIdRepo = "0";
         
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         ReportParams params = new ReportParams(oConn);

         String strRes = params.ConsultaXML(strIdRepo);
         out.println(strRes);//Pintamos el resultado
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Obtenemos los datos de un reporte">
      if (strid.equals("6")) {
         String strIdRepo = request.getParameter("IdRepo");
         if(strIdRepo == null)strIdRepo = "0";
         
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         ReportParams params = new ReportParams(oConn);

         String strRes = params.GetDataRepo(Integer.valueOf( strIdRepo),varSesiones.getIntNoUser());
         out.println(strRes);//Pintamos el resultado
      }
      // </editor-fold>

   } else {
      //Validamos si se acabo la sesion del usuario
      if (varSesiones.getIntNoUser() == 0) {
         String strid = request.getParameter("ID");
         if (strid == null) {
            strid = "0";
         }
         if (!strid.equals("0")) {
            out.clearBuffer();//Limpiamos buffer
            if (strid.equals("2") || strid.equals("4") || strid.equals("5")) {
               //respuesta en xml
               String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
               strXML += "<ERROR>" + "";
               strXML += "<msg>LOST_SESSION</msg>";
               strXML += "<ERROR>";
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strXML);//Pintamos el resultado
            } else {
               //respuesta en txt
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println("LOST_SESSION");//Pintamos el resultado
            }
         }
      }
   }
   oConn.close();
%>