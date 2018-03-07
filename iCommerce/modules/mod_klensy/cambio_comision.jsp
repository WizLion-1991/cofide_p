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
      String strComiDisponible = NumberString.FormatearDecimal(dblDisponible, 2);

      oConn.close();
%>
<div class="well ">
   <h3 class="page-header">SOLICITAR CAMBIO DE COMISION EN EFECTIVO</h3>
   <form action="index.jsp?mod=FZWebKLCambioSave" method="post"  id="login-form" class="form-inline">
      <div class="userdata">
         <!--Tipo de kit-->
         <div id="form-new-kit_ingreso" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="kit_ingreso"/>
                     <label for="modlgn-kit_ingreso" >Importe por cambiar:</label><h1>$<%=strComiDisponible%></h1><span class="required">*</span>
                  </span>
               </div>
            </div>
         </div>

         <div id="form-new-answer" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="answer"/>
                     <label for="modlgn-cuenta_answer" >&nbsp;</label>
                  </span>
                  <img alt="Captcha"  src="../stickyImg" /><input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
               </div>
            </div>
         </div>
         <br>
         <br>
         <!--Boton-->
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
            </div>
         </div>

      </div>
   </form>
</div>
<%         }
%>