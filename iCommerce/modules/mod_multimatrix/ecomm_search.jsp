<%-- 
    Document   : ecomm_search
    Este jsp pinta el cabezero de busqueda del ecommerce
    Created on : 27-abr-2013, 12:32:07
    Author     : aleph_79
--%>

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

%>
<!--Cabezero-->
<div class="well" id="ecomm">
   <h3>
      <table border="0" width="100%">
         <tr>
            <td align="left">
               <image src="../images/klensy-logo.png" width="338" height="125" border ="0" alt="Klensy" /></td>
            <td align="right">
               &nbsp&nbsp&nbsp<input type="text" id="_search" name="_search" value="" placeholder="Buscar producto" />
               &nbsp<a href="javascript:listaProductosSearch();"><img src="images/search1.png" border="0" alt="Carrito de compras" title="Carrito de compras" /></a>
            </td>
         </tr>
      </table>

   </h3>
   <h4 class="h3">&nbsp;
      Categoría 1:&nbsp;<select id="clas1" name="clas1" onchange="RefreshClas(this, 0)">
         <%
            //Consultamos la primer clasificacion
            String strSql = "select PC_ID,PC_DESCRIPCION from vta_prodcat1  WHERE PC_ACTIVO = 1 ORDER BY PC1_ORDEN";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
         %><option value="<%=rs.getInt("PC_ID")%>"><%=rs.getString("PC_DESCRIPCION")%></option><%
            }
            rs.close();
         %>
      </select>
      <input id="clas2" name="clas2" type="hidden" value="0" />
      <input id="clas3" name="clas3" type="hidden" value="0" />
      <input id="clas4" name="clas4" type="hidden" value="0" />
      <input id="clas5" name="clas5" type="hidden" value="0" />

   </h4>
</div>
<%
oConn.close();
%>