<%-- 
    Document   : ecomm_fletes
    Created on : 03-ago-2015, 13:19:06
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
<div id="FormasFletes">
   <ul>
      <%            String strSql = "select * "
                 + " from vta_transportista where TR_ACTIVO = 1 ";
         ResultSet rs;
         try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
      %>
      <li><input type="radio" name="fletes_<%=rs.getString("TR_ID")%>" id="fletes_sel" value="<%=rs.getString("TR_ID")%>" /><%=rs.getString("TR_TRANSPORTISTA")%>&nbsp;</li>
         <%

               }
               rs.close();
            } catch (SQLException ex) {
            }

         %>
   </ul>
   <div id="Importe_Flete">
      Importe Flete: <label id="Importe_flete_cobrar" value=""></label>
   </div>

</div>
<%
oConn.close();
%>