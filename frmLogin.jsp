<%-- 
    Document   : frmLogin
    Created on : 24/01/2010, 12:36:54 AM
    Author     : zeus
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%

   //Abrimos la conexion
   Conexion oConn = new Conexion(null, this.getServletContext());
   oConn.open();

   //Buscamos las empresas definidas para este usuario
   boolean bolModoDemo = false;
   String strSql = "select modo_demo from cuenta_contratada";
   ResultSet rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      if (rs.getInt("modo_demo") == 1) {
         bolModoDemo = true;
      }
   }
   rs.close();
   oConn.close();
%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="robots" content="noindex, nofollow">
      <title><bean:message key="gen.title" /></title>
      <link href="images/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
      <link rel="stylesheet" type="text/css" href="jqGrid/css/smoothness_1.10.4/jquery-ui-1.10.4.custom.min.css" />
      <script type="text/javascript" src="jqGrid/jquery-1.9.0.min.js" ></script>
      <script src="jqGrid/jquery-ui-1.10.4.custom.min.js" type="text/javascript"></script>
      <script type="text/javascript" src="javascript/controlDom.js"></script>
      <script type="text/javascript" src="javascript/Cadenas.js"></script>
      <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
      <link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
      <!--Tutoriales en el sistema en línea -->
      <script type="text/javascript" src="jqGrid/jquery.joyride-2.1.js"></script>
      <link rel="stylesheet" type="text/css" href="css/joyride-2.1.css" />
      <!--Tutoriales en el sistema en línea -->
   </head>
   <body oncontextmenu="return false">

      <div id="portada">
         <div id="letreros">
            <h1>
               <a href="http://www.solucionesinformaticasweb.com.mx/">
                  <img src="images/fondo_erp_small.png" width="400" height="" border="0 " />
               </a>
            </h1>
            <h3>Ver 2.2015</h3>
            <html:form action="/login">
               <table border=0 width="0%" cellpadding="2" class="table2" align="center">
                  <tr><td> <bean:message key="acceso.title2"/></td>
                  </tr>
                  <tr>
                     <td >
                        <span class="input-group-addon">
                           <i class="fa fa-user"></i>
                        </span><html:text  property="usuario" styleId="usuario" styleClass="outEdit" size="50" onfocus="PonFoco(this)" onblur="QuitaFoco(this)" ></html:text>

                        </td></tr>

                     <tr><td > <bean:message key="acceso.title3"/></td>
                  </tr>
                  <tr>
                     <td >
                        <span class="input-group-addon">
                           <i class="fa fa-key"></i>
                        </span>
                        <html:password property="password" styleId="password" styleClass="outEdit" size="50" onfocus="PonFoco(this)" onblur="QuitaFoco(this,3)" ></html:password>
                        </td>
                     </tr>
                     <tr>
                        <td >
                           &nbsp;
                        </td>
                     </tr>
                     <tr><td align="center" colspan="2">
                           <i class="fa fa-check"></i><html:submit  styleId="boton1" value="Iniciar sesion" styleClass="btn btn-default btn-lg btn-block ladda-button" />
                     </td></tr>
                  <tr><td align="center" colspan="2"><bean:write name="LoginForm" property="error" filter="false"/></td></tr>
                  <tr><td align="center" colspan="2"><html:link   href="Contrasenia.do?Opt=getScLose" target="_new" > <bean:message key="acceso.title5"/></html:link></td></tr>
                  </table>
            </html:form>
            <p class="note">Desarrollado por Soluciones Informaticas Web</p>
         </div>


      </div>




      <script language="javascript">
         //document.getElementById("usuario").focus();
      </script>
      <ol id="IngresarSistema" class="joyRideTipContent">
         <li data-id="usuario" data-button="Siguiente">
            <h2>Paso #1</h2>
            <p>Ingrese el login de su usuario</p>
         </li>
         <li data-id="password" data-button="Siguiente">
            <h2>Paso #2</h2>
            <p>Ingrese la contraseña asignada</p>
         </li>
         <li data-id="boton1" data-button="Siguiente">
            <h2>Paso #3</h2>
            <p>De click en iniciar sesión</p>
         </li>
      </ol>
      <%if (bolModoDemo) { %>
      <script>
         $(window).load(function () {
            $('#IngresarSistema').joyride({
               autoStart: true,
               postStepCallback: function (index, tip) {
               },
               modal: true,
               expose: true
            });
         });
      </script>
      <%} %>

   </body>
</html>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.SetVars(0, 0, 0, 0, "", "", 0, "", 0);
   varSesiones.setintIdCliente(0);
%>