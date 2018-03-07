<%-- 
    Document   : index
    Este jsp es la entrada al modulo de fza de ventas o acceso del cliente
    Tiene la funcionalidad de tener varios templates y poder generar nuevos
    estos con el fin de hacer mas sencilla la integración y más flexible el programa

    Created on : 03-feb-2013, 0:40:02
    Author     : aleph_79
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
//Redireccionamos al template activo
   /**
    * TODO: Hay que generar la clase que ubique el template activo
    */
   String strNomTemplateActivo = "templates/protostar/index.jsp";

   /*Atributos generales de la pagina*/
   atrJSP.atrJSP(request, response, true, false);
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Tomamos la primer empresa asignada al usuario
   String strSql = "SELECT ecom_template.TEM_URL, "
           + " ecom_site.WP_ID, "
           + " ecom_site.WP_NOMSITE"
           + " FROM ecom_template INNER JOIN ecom_site ON ecom_template.TEM_ID = ecom_site.TEM_ID "
           + " WHERE WP_PROVEEDOR='1' ";
   ResultSet rs;
   try {
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         //strNomTemplateActivo = rs.getString("TEM_URL");
          strNomTemplateActivo = "templates/protostar/index.jsp";
         System.out.println("Hola aqui estamos...");
      }
      rs.close();

   } catch (SQLException ex) {
      ex.fillInStackTrace();
   }
   oConn.close();
   
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Acceso clientes</title>
   </head>
   <body>
      <jsp:forward page="<%=strNomTemplateActivo%>"  ></jsp:forward>
   </body>
</html>
