<%-- 
    Document   : ecomm_formapago
    Created on : 10-jul-2013, 23:35:45
    Author     : ZeusGalindo
--%>

<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();


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
   </ul>


</div>
<%   oConn.close();
%>