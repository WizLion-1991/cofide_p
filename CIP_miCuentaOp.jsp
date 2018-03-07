<%-- 
    Document   : CIP_miCuentaOp
    Este jsp se encarga de almacenar todas las operaciones
   respecto a la configuración general del sistema
    Created on : 26/07/2010, 04:08:44 PM
    Author     : zeus
--%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
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
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         /*Recibimos los datos del programa*/
         String strNombre = request.getParameter("nombre");
         String strRfc = request.getParameter("rfc");
         String strDireccion1 = request.getParameter("direccion1");
         String strDireccion2 = request.getParameter("direccion2");
         String strTelefonooficina = request.getParameter("telefonooficina");
         String strTelefonocasa = request.getParameter("telefonocasa");
         String strTelefonomovil = request.getParameter("telefonomovil");
         String strEmail = request.getParameter("email");
         String strCtam_id = request.getParameter("ctam_id");
         String strSmtp_server = request.getParameter("smtp_server");
         String strSmtp_user = request.getParameter("smtp_user");
         String strSmtp_pass = request.getParameter("smtp_pass");
         String strSmtp_port = request.getParameter("smtp_port");
         String strSmtp_usaTLS= request.getParameter("smtp_usaTLS");
         String strSmtp_usaSTLS= request.getParameter("smtp_usaSTLS");
         String strPRECIOCONIMP= request.getParameter("PRECIOCONIMP");
         
         //Actualizamos la info de la cuenta
         String strUpdate = "UPDATE cuenta_contratada set "
                 + "  nombre          = '" + strNombre + "' "
                 + " ,rfc             = '" + strRfc + "' "
                 + " ,direccion1      = '" + strDireccion1 + "' "
                 + " ,direccion2      = '" + strDireccion2 + "' "
                 + " ,telefonooficina = '" + strTelefonooficina + "' "
                 + " ,telefonocasa    = '" + strTelefonocasa + "' "
                 + " ,telefonomovil   = '" + strTelefonomovil + "' "
                 + " ,email           = '" + strEmail + "' "
                 + " ,smtp_server     = '" + strSmtp_server + "' "
                 + " ,smtp_user       = '" + strSmtp_user + "' "
                 + " ,smtp_pass       = '" + strSmtp_pass + "' "
                 + " ,smtp_port       = '" + strSmtp_port + "' "
                 + " ,smtp_usaTLS    = '" + strSmtp_usaTLS + "' "
                 + " ,smtp_usaSTLS    = '" + strSmtp_usaSTLS + "' "
                 + " ,PRECIOCONIMP    = '" + strPRECIOCONIMP + "' "
                 + " where ctam_id = " + strCtam_id;
         oConn.runQueryLMD(strUpdate);

         %>
         <bean:message key="main.message75"/>
         <%
         
      } else {
      }
      oConn.close();
%>