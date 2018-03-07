<%-- 
    Document   : ERP_InventariosRepo
    Created on : 23/04/2014, 11:10:46 AM
    Author     : N4v1d4d3s
--%>

<%@page import="com.mx.siweb.erp.reportes.InventariosCompras"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="Tablas.vta_mov_cta_bcos_deta"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>

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
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Genera una nueva operacion de pagos en base a la transaccion que nos envian
         if (strid.equals("1")) {
            //Instanciamos el objeto que nos trae los datos  


            String strFechaInicial = fecha.FormateaBD(request.getParameter("FECHAINICIAL"), "/");
            String strFechaFinal = fecha.FormateaBD(request.getParameter("FECHAFINAL"), "/");
            String strCodigo = "";
            if (request.getParameter("CODIGO") != null) {
               strCodigo = request.getParameter("CODIGO");
            }
            int intFamilia = 0;
            if (request.getParameter("FAMILIA") != null) {
               intFamilia = Integer.valueOf(request.getParameter("FAMILIA"));
            }
            int intSeleccion = 0;
            if (request.getParameter("SELECCION") != null) {
               intSeleccion = Integer.valueOf(request.getParameter("SELECCION"));
            }
            
            int intSucursal = 0;
            if (request.getParameter("SUCURSAL") != null) {
               intSucursal = Integer.valueOf(request.getParameter("SUCURSAL"));
            }
            int intEmpresa=0;
                  

            InventariosCompras b = new InventariosCompras(strFechaInicial,strFechaFinal,strCodigo,intFamilia ,intSeleccion ,intSucursal,intEmpresa, oConn);
            b.setIntEmpresa(varSesiones.getIntIdEmpresa());
            b.CalcularReporte();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            String reporte = b.GeneraXml();
            //  System.out.println(reporte);
            out.println(reporte + "");//Pintamos el resultado   
         }

      }}
      oConn.close();
%>