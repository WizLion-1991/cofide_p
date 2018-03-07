<%-- 
    Document   : ecomm_formapago
    Created on : 10-jul-2013, 23:35:45
    Author     : ZeusGalindo
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();

   //Factor de conversión
   double dblFactorConv1 = 0;
   double dblFactorConv2 = 0;
   String strSqlCN = "select KL_FACTOR_CONV1,KL_FACTOR_CONV2 from cuenta_contratada";
   ResultSet rsCN = oConn.runQuery(strSqlCN, true);
   while (rsCN.next()) {
      dblFactorConv1 = rsCN.getDouble("KL_FACTOR_CONV1");
      dblFactorConv2 = rsCN.getDouble("KL_FACTOR_CONV2");
   }
   rsCN.close();

   //Obtenemos la comision disponible
   int intCicloActual = 0;
   int intCicloCerrado = 0;
   int intKL_PLAN_ORO = 0;
   double dblDisponible = 0;
   String strComiDisponible = "";
   if (varSesiones.getintIdCliente() > 0) {
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
      rsCN = oConn.runQuery(strlSqlAdicional, true);
      while (rsCN.next()) {
         intCicloActual = rsCN.getInt("KL_CICLO_ACTUAL");
         intCicloCerrado = rsCN.getInt("KL_CICLO_CERRADO");
         intKL_PLAN_ORO = rsCN.getInt("KL_PLAN_ORO");
         dblDisponible = rsCN.getDouble("DISPONIBLE");
      }
      rsCN.close();
      //Comision disponible para usar
      strComiDisponible = NumberString.FormatearDecimal(dblDisponible / dblFactorConv1, 2);
   }

%>

<div id="FormasdePago">
   <ul>

      <%            //Mostramos las formas de pago
         String strClientId = "";
         String strClientSecret = "";
         String stImageMercado = "";

         String strSql = "select * "
                 + " from ecomm_payments where PAYMENT_ACTIVE = 1 ";
         ResultSet rs;
         try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strClientId = rs.getString("PAYMENT_CLIENT_ID");
               strClientSecret = rs.getString("PAYMENT_CLIENT_SECRET");
               stImageMercado = rs.getString("PAYMENT_IMAGE");
      %>
      <li><input type="radio" id="payment_<%=rs.getString("PAYMENT_ID")%>" name="payments_" value="<%=rs.getString("PAYMENT_ID")%>" /><%=rs.getString("PAYMENT_DESC")%><image src="<%=stImageMercado%>" border="0" alt="" width="371" height="12"></li>

      <%

            }
            rs.close();
         } catch (SQLException ex) {
            System.out.println("Error ecomm payments...:" + ex.getMessage() + " " + ex.getSQLState());
         }

      %>
      <li>Uso de puntos:<%=strComiDisponible%> Disponible, Valor en puntos:
      <input type="hidden" id="PAYMENT_CLIENT_ID" value="<%=strClientId%>" />
      <input type="hidden" id="PAYMENT_CLIENT_SECRET" value="<%=strClientSecret%>" /></li>
      <input type="hidden" id="PAYMENT_IMAGE" value="<%=stImageMercado%>" /></li>

   </ul>


</div>
<%   oConn.close();
%>