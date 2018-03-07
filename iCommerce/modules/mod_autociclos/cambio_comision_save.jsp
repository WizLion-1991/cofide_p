<%-- 
    Document   : cambio_comision_save
    Created on : 24-jul-2015, 14:26:23
    Author     : ZeusGalindo
--%>
<%@page import="nl.captcha.Captcha"%>
<%-- 
    Document   : cambio_comision
    Created on : 24-jul-2015, 14:24:24
    Author     : ZeusGalindo
--%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.sql.SQLException"%>
<%@page import="ERP.Precios"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0) {

      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();

      String strKit_ingreso = request.getParameter("kit_ingreso");
      String strAnswer = request.getParameter("answer");

      String strResult = "";

      //Validamos el captcha
      Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
      if (captcha.isCorrect(strAnswer)) {
         Fechas fecha = new Fechas();
         //Obtenemos la comision disponible
         int intCicloActual = 0;
         int intCicloCerrado = 0;
         int intKL_PLAN_ORO = 0;
         double dblDisponible = 0;
         double dblDisponibleComis1 = 0;
         double dblDisponibleComis2 = 0;
         double dblDisponibleComis3 = 0;
         double dblDisponibleComis4 = 0;
         double dblDisponibleComis5 = 0;
         String strlSqlAdicional = "select KL_CICLO_ACTUAL,KL_CICLO_CERRADO,KL_PLAN_ORO"
                 + ", KL_CICLO1_COMIS"
                 + ", KL_CICLO2_COMIS"
                 + ", KL_CICLO3_COMIS"
                 + ", KL_CICLO4_COMIS"
                 + ", KL_CICLO5_COMIS"
                 + ",(KL_CICLO1_COMIS"
                 + "+ KL_CICLO2_COMIS"
                 + "+ KL_CICLO3_COMIS"
                 + "+ KL_CICLO4_COMIS"
                 + "+ KL_CICLO5_COMIS) as DISPONIBLE"
                 + " from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
         ResultSet rsCN = oConn.runQuery(strlSqlAdicional, true);
         while (rsCN.next()) {
            intCicloActual = rsCN.getInt("KL_CICLO_ACTUAL");
            intCicloCerrado = rsCN.getInt("KL_CICLO_CERRADO");
            intKL_PLAN_ORO = rsCN.getInt("KL_PLAN_ORO");
            dblDisponible = rsCN.getDouble("DISPONIBLE");
            dblDisponibleComis1 = rsCN.getDouble("KL_CICLO1_COMIS");
            dblDisponibleComis2 = rsCN.getDouble("KL_CICLO2_COMIS");
            dblDisponibleComis3 = rsCN.getDouble("KL_CICLO3_COMIS");
            dblDisponibleComis4 = rsCN.getDouble("KL_CICLO4_COMIS");
            dblDisponibleComis5 = rsCN.getDouble("KL_CICLO5_COMIS");
         }
         rsCN.close();
         //Guardamos solicitud y enviamos el correo
         strResult = "OK";
         String strSql = "insert into mlm_canje_comision(CJ_FECHA,CJ_HORA,CT_ID,CJ_IMPORTE)values('" + fecha.getFechaActual() + "','" + fecha.getHoraActual() + "'," + varSesiones.getintIdCliente() + ",'" + dblDisponible + "')";
         oConn.runQueryLMD(strSql);
      } else {
         strResult = "ERROR:El texto de la imagen no coincide";
      }
      //Validamos si fue exitoso
      if (strResult.equals("OK")) {

%>
<!-- Mostramos los datos -->
<div class="well ">
   <h3 class="page-header">Se registro su petición..., en breve nos pondremos en contacto con usted</br> </h3>
</div>
<%} else {
%>
<!-- Mostramos los datos -->
<div class="well ">
   <h3 class="page-header">Error al registrar su petición, mensaje de error <%=strResult%> </h3>
   <input type="button" name="back" value="Regresar" class="btn btn-primary btn" onClick="window.history.back()"/>
</div>
<%
      }

      oConn.close();

   }
%>