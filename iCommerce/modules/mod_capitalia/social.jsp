<%-- 
    Document   : social
    Created on : 17-abr-2013, 11:43:44
    Author     : aleph_79
--%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mx.siweb.ui.web.TemplateParams"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
//Obtenemos parametros generales de la pagina a mostrar
   Site webBase = new Site(oConn);
   //Inicializamos los parametros del template
   TemplateParams templateparams = new TemplateParams(oConn, "v15matriz", webBase.getStrLanguage());
   
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="well ">
   <h3 class="page-header">Cont&aacute;ctanos</h3>
   <%
            String strSql = "select * "
                 + " from ecomm_social where ES_ACTIVO = 1 ";
         ResultSet rs;
         try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
   %>
   <a href="<%=rs.getString("ES_LINK") %>"  target="_new"><img src="<%=rs.getString("ES_SRC_IMG") %>" border="0" width="50" height="50" alt="<%=rs.getString("ES_TITLE") %>" title="<%=rs.getString("ES_TITLE") %>" /></a>
   <%
            }
            rs.close();
         } catch (SQLException ex) {
            out.println(ex.getMessage());
         }
   
   %>
</div>
<%
oConn.close();
%>