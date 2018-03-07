<%-- 
    Document   : mod_splash
    Created on : 16-oct-2014, 11:41:10
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
%>
<div id="container">
   <div id="header">

      <div class="LogoRight">

         <div id="menu">

         </div>

      </div>
   </div>
   <div id="notification"></div>
   <br style="clear:both">
   <br style="clear:both">
   <div id="column-left">
      <div class="box">

         <div class="box-content">
            <div class="box-category">
               <ul>
                  <%
                     //Consultamos las categorias

                     String strSql = "select *"
                             + " ,(select count(distinct PR_CATEGORIA2) from vta_producto where PR_ACTIVO = 1 AND PR_CATEGORIA1 = vta_prodcat1.PC_ID AND SC_ID = 1 ) as cuantos "
                             + " from vta_prodcat1 "
                             + " ";
                     ResultSet rs = oConn.runQuery(strSql, true);
                     while (rs.next()) {
                  %>
                  <li style="border:0;background: url('http://casajosefa.com/catalog/view/theme/mystore/image/arrow-right.png') 10px 50% no-repeat;">
                     <a href="index.jsp?mod=ecomm_cat&cat_id=<%=rs.getString("PC_ID")%>"><%=rs.getString("PC_DESCRIPCION")%> </a>
                  </li>
                     <%
                        }
                        rs.close();
                     %>
               </ul>
            </div>
         </div>
      </div>
   </div>


   <div style="border-left: 1px solid #333; padding-left:10px;" id="content"><div id="content-top">
      </div>
      <div class="category-info">

         <div class="image"><img alt="Mujeres" src="http://casajosefa.com/image/cache/data/Multinivel de ropa México Vestido-715x508.jpg"></div>

      </div>
   </div>
</div>

<%
   oConn.close();
%>