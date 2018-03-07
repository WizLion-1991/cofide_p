<%-- 
    Document   : MLM_ConfirmaRegistro
    Created on : 19/01/2016, 11:29:54 AM
    Author     : siweb
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.mx.siweb.mlm.utilerias.Redes"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
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
      String strResp = "proceso terminado";
      Fechas fecha = new Fechas();
      String intIdCliente = "";
      boolean bolHay = false;
      //coNSULTA 
      String strSql = "SELECT * FROM mlm_listado where LIS_APLICO = 1 AND LIS_PROCESO = 0";
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         bolHay = true;
         intIdCliente = rs.getString("CT_ID");
         //cAMBIAR EL NODO A UNA POSICION
         Redes redAlgoritmo = new Redes();
         int intUpline = redAlgoritmo.calculaUpline(1, 3, "", false, oConn, true);

         //Actualizamos el upline
         String strUpdate = "update vta_cliente set CT_UPLINE = " + intUpline + ""
                 + ",CT_FECHA_ACTIVA = '" + fecha.getFechaActual() + "' "
                 + ",CT_ACTIVO = '1' "
                 + "WHERE CT_ID = " + intIdCliente;
         oConn.runQueryLMD(strUpdate);

         //MARCAMOS EL REGISTRO COMO PROCESADO
         strUpdate = "UPDATE mlm_listado SET LIS_PROCESO=1 WHERE CT_ID = " + intIdCliente;
         oConn.runQueryLMD(strUpdate);

      }      
      rs.close();
      if(!bolHay){
         strResp = "No hay proceso";
      }
      //Limpiamos
      out.clearBuffer();
      atrJSP.atrJSP(request, response, true, false, true);//Definimos atributos para el XML
      out.println(strResp);
   }
   oConn.close();
%>