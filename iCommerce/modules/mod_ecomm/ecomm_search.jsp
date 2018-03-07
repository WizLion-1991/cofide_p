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
               i-Commerce</td>
            <td align="right">
               &nbsp&nbsp&nbsp<input type="text" id="_search" name="_search" value="" placeholder="Buscar producto" />
               &nbsp<a href="javascript:listaProductosSearch();"><img src="images/search1.png" border="0" alt="Carrito de compras" title="Carrito de compras" /></a>
            </td>
         </tr>
      </table>

   </h3>
   <h4 class="h5_title">&nbsp;
      Categoría 1:&nbsp;<select id="clas1" name="clas1" onchange="RefreshClas(this, 2)">
         <%
            //Consultamos la primer clasificacion
            String strSql = "select PC_ID,PC_DESCRIPCION from vta_prodcat1  WHERE PC_ACTIVO = 1";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
         %><option value="<%=rs.getInt("PC_ID")%>"><%=rs.getString("PC_DESCRIPCION")%></option><%
            }
            rs.close();
         %>
      </select>
      Categoría 2:&nbsp;<select id="clas2" name="clas2" onchange="RefreshClas(this, 3)"><option value="0">Seleccione</option> </select>
      Categoría 3:&nbsp;<select id="clas3" name="clas3" onchange="RefreshClas(this, 4)"><option value="0">Seleccione</option> </select>

   </h4>
   <h4 class="h5_title">&nbsp;
      Categoría 4:&nbsp;<select id="clas4" name="clas4" onchange="RefreshClas(this, 5)"><option value="0">Seleccione</option> </select>
      Categoría 5:&nbsp;<select id="clas5" name="clas5" onchange="RefreshClas(this, 0)"><option value="0">Seleccione</option> </select>
   </h4>
</div>
<%
oConn.close();
%>