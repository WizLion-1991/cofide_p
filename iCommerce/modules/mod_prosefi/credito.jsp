<%-- 
    Document   : ingresos
    Este jsp contiene la pantalla de captura de nuevos ingresos
    Created on : 16-abr-2013, 15:31:53
    Author     : aleph_79
--%>

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

      //Recuperamos los nombres de los estados
      ArrayList<String> lstEstado = new ArrayList<String>();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();

      String strV_MOVIMIENTO = "";
      String strV_VENCIMIENTO = "";
      String strV_PUNTOS = "";
      String strV_SALDO = "";
      //Buscamos si tenemos un credito
      int intIdCredito = 0;
      double dblMontoCredito = 0;
      double dblSaldo = 0;
      String strEstatus = "NO AUTORIZADO";
      String strSql = "select CTO_ID,CTO_AUTORIZADO,CTO_SALDO,(select cat_monto.MTO_MCREDITO from  cat_monto where cat_monto.MTO_ID = cat_credito.MTO_ID ) as monto from cat_credito where ct_id = " + varSesiones.getintIdCliente() + " and CTO_AUTORIZADO = 1 ";
      ResultSet rs = oConn.runQuery(strSql, true); 
      while (rs.next()) {
         intIdCredito = rs.getInt("CTO_ID");
         dblMontoCredito = rs.getDouble("monto");
         dblSaldo = rs.getDouble("CTO_SALDO");
         if (rs.getInt("CTO_AUTORIZADO") == 1) {
            strEstatus = "AUTORIZADO";
         }

      }
      rs.close();
      //Validar si tiene credito activo
      if (intIdCredito != 0) {
         //Si tiene credito
%>
<div class="well ">
   <h3 class="page-header">Mi Cr&eacute;dito </h3>
   <form action="index.jsp?mod=sugerencias_save" method="post"   id="login-form" class="form-inline">
      <div class="userdata">
         <div id="img-quejas">

         </div>

         <div id="form-new-submit" class="control-group">
            <div class="controls">

            </div>
         </div>
         <!--Monto de credito-->
         <div id="form-new-fecha" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Monto"/>
                     <label for="modlgn-text" >Monto de Cr&eacute;dito:</label>
                  </span>
                  <%=dblMontoCredito%>
               </div>
            </div>
         </div>
         <!--Estatus-->
         <div id="form-new-adirigido" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Estatus"/>
                     <label for="modlgn-dirigido" >Estatus:</label>
                  </span>
                  <%=strEstatus%>
               </div>
            </div>
         </div>

         <!--Tabla-->
         <div id = "div Principal">
            <div id="div_titulo" class="panel panel-default">
               <div class="panel-heading"></div>
               <div style="text-align: center">
                  <table cellpadding="10" cellspacing="5" border="5" >
<tr>

                        <td><font size=2>Num. Pago</font></td>
                        <td><font size=2>Fecha</font></td>
                        <td><font size=2>Puntos</font></td>
                        <td><font size=2>Saldo</font></td>

                     </tr>
                     <%                        Fechas fecha = new Fechas();
                        String strSql1 = "select V_MOVIMIENTO,V_VENCIMIENTO,V_PUNTOS,V_SALDO from cat_vencimiento where CTO_ID = " + intIdCredito;

                        rs = oConn.runQuery(strSql1, true);
                        while (rs.next()) {
                           strV_MOVIMIENTO = rs.getString("V_MOVIMIENTO");
                           strV_VENCIMIENTO = rs.getString("V_VENCIMIENTO");
                           strV_PUNTOS = rs.getString("V_PUNTOS");
                           strV_SALDO = rs.getString("V_SALDO");
                     %>
                     <tr>

                        <td><font size=2><%=strV_MOVIMIENTO%></font></td>
                        <td><font size=2><%=fecha.FormateaDDMMAAAA(strV_VENCIMIENTO, "/")%></font></td>
                        <td><font size=2><%=strV_PUNTOS%></font></td>
                        <td><font size=2><%=strV_SALDO%></font></td>

                     </tr>

                     <%
                        }
                        rs.close();
                     %>
                  </table>
               </div>
            </div>
         </div>


         <!--Saldo Pendiente-->
         <div id="form-new-adirigido" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Saldo Pendiente"/>
                     <label for="modlgn-dirigido" >Saldo Pendiente:</label>
                  </span>
                  <%=dblSaldo%> 
               </div>
            </div>
         </div>
         <!--Boton-->
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
            </div>
         </div>

      </div>
   </form>
</div>
<%
} else {
//Mandar mensaje de error
%>
<div class="well ">
   <h3 class="page-header">Lo sentimos no cuenta con un credito </h3>
</div>

<%
   }


%>




<%         }
%>
