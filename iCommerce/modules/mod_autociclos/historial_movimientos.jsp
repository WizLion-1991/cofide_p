<%-- 
    Document   : historial_movimientos
    Created on : 31-jul-2015, 0:11:59
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   if (varSesiones.getIntNoUser() != 0) {

      //Recuperamos los nombres de los estados
      ArrayList<String> lstEstado = new ArrayList<String>();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();

      //Declaramos las variables
      Fechas fecha = new Fechas();
      //Validamos si hay que mostrar un nodo en particular
      int intClienteActual = varSesiones.getintIdCliente();
      if (request.getParameter("cuentaSel") != null) {
         intClienteActual = Integer.valueOf(request.getParameter("cuentaSel"));
      }

      //Obtenemos la lista de cuentas que podemos consultar
      String strOpts = "<option value=" + varSesiones.getintIdCliente() + ">" + varSesiones.getintIdCliente() + ".-" + varSesiones.getStrUser() + "</option>";
      if (intClienteActual == varSesiones.getintIdCliente()) {
         strOpts = "<option value=" + varSesiones.getintIdCliente() + " selected>" + varSesiones.getintIdCliente() + ".-" + varSesiones.getStrUser() + "</option>";
      }
      String strSqlCN = "select CT_ID,CT_RAZONSOCIAL from vta_cliente where KL_ID_MASTER = " + varSesiones.getintIdCliente();
      ResultSet rsCN = oConn.runQuery(strSqlCN, true);
      while (rsCN.next()) {
         if (intClienteActual == rsCN.getInt("CT_ID")) {
            strOpts += "<option value=" + rsCN.getInt("CT_ID") + " selected >" + rsCN.getInt("CT_ID") + ".-" + rsCN.getString("CT_RAZONSOCIAL") + "</option>";
         } else {
            strOpts += "<option value=" + rsCN.getInt("CT_ID") + ">" + rsCN.getInt("CT_ID") + ".-" + rsCN.getString("CT_RAZONSOCIAL") + "</option>";
         }
      }
      rsCN.close();
      //Factor de conversión
      double dblFactorConv1 = 0;
      double dblFactorConv2 = 0;
      strSqlCN = "select KL_FACTOR_CONV1,KL_FACTOR_CONV2 from cuenta_contratada";
      rsCN = oConn.runQuery(strSqlCN, true);
      while (rsCN.next()) {
         dblFactorConv1 = rsCN.getDouble("KL_FACTOR_CONV1");
         dblFactorConv2 = rsCN.getDouble("KL_FACTOR_CONV2");
      }
      rsCN.close();
      //Declaramos totales
      double dblAbonoDinero = 0;
      double dblCargoDinero = 0;
      double dblAbonoPtos = 0;
      double dblCargoPtos = 0;

%>
<form action="index.jsp?mod=FZWebHistorial" method="post"   id="tree-form" class="form-inline">
   <div class="userdata">       
      <div id="form-new-submit" class="control-group">
         <div class="controls">
            <span class="required">Seleccione su cuenta</span>
            <span class="required">
               <select id="cuentaSel" name="cuentaSel" onBlur="ActualizaHistorialComisiones()">
                  <%=strOpts%>
               </select>
               </br>
               </br>
            </span>
         </div>
      </div>
   </div>
   <hr/>
   <br/>
   <table id="historial_comisiones" cellpadding="2" cellspacing="1" border="1">
      <tr>
         <th>&nbsp;Fecha</th>
         <th>&nbsp;Abono Dinero</th>
         <th>&nbsp;Abono Puntos</th>
         <th>&nbsp;Uso Dinero</th>
         <th>&nbsp;Uso Puntos</th>
         <th>&nbsp;Concepto</th>
      </tr>
      <%
         //Recorremos todo
         String strSql = "select * from mlm_mov_comis where CT_ID = " + intClienteActual;
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {

            dblAbonoDinero += rs.getDouble("MMC_ABONO");
            dblCargoDinero += rs.getDouble("MMC_CARGO");
            dblAbonoPtos += rs.getDouble("MMC_CARGO") / dblFactorConv1;
            dblCargoPtos += rs.getDouble("MMC_CARGO") / dblFactorConv1;
      %>
      <tr>
         <td>&nbsp;<%=fecha.FormateaDDMMAAAA(rs.getString("MMC_FECHA"), "/")%></td>
         <td align="right">&nbsp;<%=NumberString.FormatearDecimal(rs.getDouble("MMC_ABONO"), 2)%></td>
         <td align="right">&nbsp;<%=NumberString.FormatearDecimal(rs.getDouble("MMC_ABONO") / dblFactorConv1, 2)%></td>
         <td align="right">&nbsp;<%=NumberString.FormatearDecimal(rs.getDouble("MMC_CARGO"), 2)%></td>
         <td align="right">&nbsp;<%=NumberString.FormatearDecimal(rs.getDouble("MMC_CARGO") / dblFactorConv1, 2)%></td>
         <td>&nbsp;<%=rs.getString("MMC_NOTAS")%></td>
      </tr>
      <%

         }
      %>
      <tr>
         <th>&nbsp;Totales</th>
         <th align="right">&nbsp;<%=NumberString.FormatearDecimal(dblAbonoDinero, 2)%></th>
         <th align="right">&nbsp;<%=NumberString.FormatearDecimal(dblCargoDinero, 2)%></th>
         <th align="right">&nbsp;<%=NumberString.FormatearDecimal(dblAbonoPtos, 2)%></th>
         <th align="right">&nbsp;<%=NumberString.FormatearDecimal(dblCargoPtos, 2)%></th>
         <th>&nbsp;</th>
      </tr>
   </table>
</form>
<script type="text/javascript">

//Reporte por grafica
   function ActualizaHistorialComisiones() {
      document.getElementById("tree-form").action = "index.jsp?mod=FZWebHistorial";
      document.getElementById("tree-form").submit();
   }


</script>
<%

      oConn.close();
   }
%>