<%-- 
    Document   : ERP_MakPrepPedidos Realiza las operaciones de la pantalla de preparación de pedidos
    Created on : 19-ene-2016, 12:52:35
    Author     : ZeusSIWEB
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.especiales.arrendadoramak.PreparacionPedidos"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Abrimos la coneaxion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Emite el listado de pedidos
         if (strid.equals("1")) {
            String strTipo = request.getParameter("Tipo");
            String strEmpresa = request.getParameter("Empresa");
            String strSucursal = request.getParameter("Sucursal");
            String strMoneda = request.getParameter("Moneda");
            //Instanciamos la clase
            PreparacionPedidos prep = new PreparacionPedidos(oConn);
            prep.setRows(30);
            String strRes = prep.getListPedidos(Integer.valueOf(strTipo), Integer.valueOf(strEmpresa), Integer.valueOf(strSucursal), Integer.valueOf(strMoneda));

            //Mostramos los resultados
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
         }
      }

   }
   oConn.close();
%>
