<%-- 
    Document   : ERP_XML
   Este jsp lee el archivo xml guardado y lo manda como html para poderlo imprimir
   Nomenclatura del XML XmlSAT[IDOPERACION] .xml
    Created on : 9/01/2011, 10:57:25 PM
    Author     : zeus
--%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
      /*Obtenemos las variables de sesion*/
      VariableSession varSesiones = new VariableSession(request);
      varSesiones.getVars();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();
      //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
      Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
      if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
         String strPathXML = this.getServletContext().getInitParameter("PathXml");
         /*Definimos parametros de la aplicacion*/
         String strXML = "";
         String strValorBuscar = request.getParameter("FAC_ID");
         String strPathFile = strPathXML + "XmlSAT" + strValorBuscar + " .xml";
         if (strValorBuscar == null) {
            strValorBuscar = request.getParameter("NC_ID");
            strPathFile = strPathXML + "NC_XML" + strValorBuscar + ".xml";
         }
         if (strValorBuscar != null) {
            File dbFileXml = new File(strPathFile);
            if (dbFileXml.exists()) {
               //StringBuffer contenidoPDF = new StringBuffer();
               BufferedReader br = null;
               try {
                  br = new BufferedReader(new FileReader(dbFileXml));
                  String linea;
                  while ((linea = br.readLine()) != null) {
                     strXML += linea + "\n";
                  }
               } catch (Exception e) {
                  System.out.println("Excepcion - " + e.toString());
               } finally {
                  if (br != null) {
                     br.close();
                  }
               }
            } else {
               strXML = "No existe el XML";
            }
         }else{
            strXML = "No existe el XML";
         }

         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      } else {
      }
      oConn.close();
%>