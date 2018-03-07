<%-- 
    Document   : ERP_Wskdjcmglt6s
Este jsp se encarga de almacenar la información del portal de contactos de la página web
en el sistema SIWEBSmall a fin de otorgarle el sistema
    Created on : 03-mar-2014, 23:05:14
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%
   /*Atributos generales de la pagina*/
   atrJSP.atrJSP(request, response, true, false);
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   Seguridad seg = new Seguridad();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();

   //Recibimos parametros
   //'nombre','rfc','email','calle','numero_int','numero_ext','colonia','delegacion','estado','localidad','regimen','teléfono
   String nombre = request.getParameter("nombre");
   String rfc = request.getParameter("rfc");
   String email = request.getParameter("email");
   String calle = request.getParameter("calle");
   String numero_int = request.getParameter("numero_int");
   String numero_ext = request.getParameter("numero_ext");
   String colonia = request.getParameter("colonia");
   String delegacion = request.getParameter("delegacion");
   String estado = request.getParameter("estado");
   String localidad = request.getParameter("localidad");
   String regimen = request.getParameter("regimen");
   String teléfono = request.getParameter("teléfono");

   //Validamos que el nombre no este vacio
   if (nombre != null) {
      if (!nombre.isEmpty()) {
         //Guardamos en la tabla de vta_empresas
         String strInsert = "insert into vta_empresas("
                 + "EMP_RAZONSOCIAL"
                 + ",EMP_RFC"
                 + ",EMP_TELEFONO2"
                 + ",EMP_CALLE"
                 + ",EMP_NUMINT"
                 + ",EMP_NUMERO"
                 + ",EMP_COLONIA"
                 + ",EMP_MUNICIPIO"
                 + ",EMP_ESTADO"
                 + ",EMP_LOCALIDAD"
                 + ",EMP_FRASE1"
                 + ",EMP_TELEFONO1"
                 + ",EMP_VTA_DETA"
                 + ")values("
                 + "'" + nombre + "'"
                 + ",'" + rfc + "'"
                 + ",'" + email + "'"
                 + ",'" + calle + "'"
                 + ",'" + numero_int + "'"
                 + ",'" + numero_ext + "'"
                 + ",'" + colonia + "'"
                 + ",'" + delegacion + "'"
                 + ",'" + estado + "'"
                 + ",'" + localidad + "'"
                 + ",'" + regimen + "'"
                 + ",'" + teléfono + "'"
                 + ",'0'"
                 + ")";
         oConn.runQueryLMD(strInsert);
      }
   }

   //Damos la alta en el PAC

   oConn.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>JSP Page</title>
   </head>
   <body>
      <h1>Is offline</h1>
   </body>
</html>
