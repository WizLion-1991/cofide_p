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
      strComiDisponible = NumberString.FormatearDecimal(dblDisponible/dblFactorConv1, 2);
   }

   oConn.close();
%>

<div id="FormasdePago">
   <ul>

      <%   
             //Mostramos las formas de pago
              String strSql = "select * "
                 + " from ecomm_payments where PAYMENT_ACTIVE = 1 ";
         ResultSet rs;
         try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
      %>
      <li><input type="radio" name="payment_<%=rs.getString("PAYMENT_ID")%>" id="payments_" value="<%=rs.getString("PAYMENT_ID")%>" /><%=rs.getString("PAYMENT_DESC")%></li>
         <%

               }
               rs.close();
            } catch (SQLException ex) {
            }

         %>
      <li>Uso de puntos:<%=strComiDisponible%> Disponible, Valor en puntos:
   </ul>


</div>
<%   oConn.close();
%>