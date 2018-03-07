<%-- 
    Document   : ecomm_clasific
Este jsp genera el xml de las clasificaciones a mostrar
    Created on : 25-abr-2013, 11:12:41
    Author     : aleph_79
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
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

   String strClasId = request.getParameter("Clasific");
   String strClasValue = request.getParameter("ClasValue");
   if (strClasId == null) {
      strClasId = "2";
   }
   if (strClasValue == null) {
      strClasValue = "0";
   }
   //Cadena con el XML
   StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
   strXML.append("<clasificaciones>");
   String strNomCat1 = "PR_CATEGORIA2";
   String strNomCat2 = "PC2_DESCRIPCION";
   String strSql = "select DISTINCT PR_CATEGORIA2,vta_prodcat2.PC2_DESCRIPCION from vta_producto,vta_prodcat2 "
           + " where vta_producto.PR_CATEGORIA1 = " + strClasValue + " AND vta_prodcat2.PC2_ID = PR_CATEGORIA2";
   if (strClasId.equals("3")) {
      strSql = "select DISTINCT PR_CATEGORIA3,vta_prodcat3.PC3_DESCRIPCION from vta_producto,vta_prodcat3 "
              + " where vta_producto.PR_CATEGORIA2 = " + strClasValue + " AND vta_prodcat3.PC3_ID = PR_CATEGORIA3";
      strNomCat1 = "PR_CATEGORIA3";
      strNomCat2 = "PC3_DESCRIPCION";
   }
   if (strClasId.equals("4")) {
      strSql = "select DISTINCT PR_CATEGORIA4,vta_prodcat4.PC4_DESCRIPCION from vta_producto,vta_prodcat4 "
              + " where vta_producto.PR_CATEGORIA3 = " + strClasValue + " AND vta_prodcat4.PC4_ID = PR_CATEGORIA4";
      strNomCat1 = "PR_CATEGORIA4";
      strNomCat2 = "PC4_DESCRIPCION";
   }
   if (strClasId.equals("5")) {
      strSql = "select DISTINCT PR_CATEGORIA5,vta_prodcat5.PC5_DESCRIPCION from vta_producto,vta_prodcat5 "
              + " where vta_producto.PR_CATEGORIA4 = " + strClasValue + " AND vta_prodcat5.PC5_ID = PR_CATEGORIA5";
      strNomCat1 = "PR_CATEGORIA5";
      strNomCat2 = "PC5_DESCRIPCION";
   }
   if (strClasId.equals("6")) {
      strSql = "select DISTINCT PR_CATEGORIA6,vta_prodcat6.PC6_DESCRIPCION from vta_producto,vta_prodcat6 "
              + " where vta_producto.PR_CATEGORIA5 = " + strClasValue + " AND vta_prodcat6.PC6_ID = PR_CATEGORIA6";
      strNomCat1 = "PR_CATEGORIA6";
      strNomCat2 = "PC6_DESCRIPCION";
   }
   if (strClasId.equals("7")) {
      strSql = "select DISTINCT PR_CATEGORIA7,vta_prodcat7.PC7_DESCRIPCION from vta_producto,vta_prodcat7 "
              + " where vta_producto.PR_CATEGORIA6 = " + strClasValue + " AND vta_prodcat7.PC7_ID = PR_CATEGORIA7";
      strNomCat1 = "PR_CATEGORIA7";
      strNomCat2 = "PC7_DESCRIPCION";
   }
   ResultSet rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      strXML.append("<clas id=\"" + rs.getString(strNomCat1) + "\" desc=\"" + rs.getString(strNomCat2) + "\" />");
   }
   rs.close();
   strXML.append("</clasificaciones>");
   //Pintamos el XML
   out.clearBuffer();//Limpiamos buffer
   atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
   out.println(strXML.toString());//Pintamos el resultado   
//Cerramos conexion
   oConn.close();
%>