<%-- 
    Document   : CIP_PASS
    Este jsp nos muestra las pantallas y operaciones de cambio de recuperacion
de contrasenas
    Created on : 11/09/2010, 11:24:14 PM
    Author     : zeus
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="nl.captcha.Captcha"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.SQLException" %>
<%@page import="comSIWeb.Utilerias.Mail" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<%
      /*Obtenemos las variables de sesion*/
      VariableSession varSesiones = new VariableSession(request);
      varSesiones.getVars();
      /*Definimos parametros de la aplicacion*/
      String strOpt = request.getParameter("Opt");
      if (strOpt == null) {
         strOpt = "";
      }
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();
      //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
      Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
      if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
         //Screen change Pass
         if (strOpt.equals("getScChange")) {
            //Contrasena anterior
            String strPasswordBack = "";
            String strSql = "select password from usuarios  where id_usuarios = '" + varSesiones.getIntNoUser() + "'";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strPasswordBack = rs.getString("password");
            }
            rs.close();
%>
<form name="form1" id="form1" action="" method="POST">
   <input type="hidden" id="passback" name="passback" value="<%=strPasswordBack%>" />
   <table border="0" cellpadding="1" cellspacing="0"  class="tabla" align="center">
      <tr>
         <td colspan="2" class="form_head"><bean:message key="pass.msg1"/></td>
      </tr>
      <tr>
         <td class="form_field"><bean:message key="pass.msg2"/></td>
         <td><input type="password" name="oldpass" id="oldpass" value="" class="outEdit" onblur="QuitaFoco(this,3)" onfocus="PonFoco(this)" maxlength="15" size="15" /><font color="red">*</font></td>
      </tr>
      <tr>
         <td class="form_field"><bean:message key="pass.msg3"/></td>
         <td><input type="password" name="nvopass" id="nvopass" value="" class="outEdit" onblur="QuitaFoco(this,3)" onfocus="PonFoco(this)"  maxlength="15" size="15" /><font color="red">*</font></td>
      </tr>
      <tr>
         <td class="form_field"><bean:message key="pass.msg4"/></td>
         <td><input type="password" name="nvopass2" id="nvopass2" value="" class="outEdit" onblur="QuitaFoco(this,3)" onfocus="PonFoco(this)"  maxlength="15" size="15" /><font color="red">*</font></td>
      </tr>
      <tr>
         <td class="form_field" colspan="2"><div class="oblig"><bean:message key="pass.msg11"/></div></td>
      </tr>
      <tr>
         <td class="form_field" colspan="2"><img alt="Captcha"  src="stickyImg" /></td>
      </tr>
      <tr>
         <td class="form_field"><bean:message key="pass.msg5"/></td>
         <td><input type="text" name="answer" id="answer" value="" class="outEdit"  onblur="QuitaFoco(this,3)" onfocus="PonFoco(this)" maxlength="30" size="15" /><font color="red">*</font></td>
      </tr>
      <tr>
         <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
         <td colspan="2" align="center"><input type="button" name="saveme" id="saveme" value="<bean:message key="pass.msg6"/>" onClick="doChangePass()"/></td>
      </tr>
      <tr>
         <td colspan="2">&nbsp;</td>
      </tr>
   </table>
</form>
<%                     }
         //Realiza el cambio de contrasenia
         if (strOpt.equals("doChangePass")) {
            String strResp = "OK";
            request.setCharacterEncoding("UTF-8"); // Do this so we can capture non-Latin chars
            String strNvoPass = request.getParameter("nvopass");
            String strAnswer = request.getParameter("answer");
            //validamos nulos
            if (strNvoPass == null) {
               strNvoPass = "";
            }
            if (strAnswer == null) {
               strAnswer = "";
            }
            //Valor del captcha generado
            Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
            if (captcha.isCorrect(strAnswer)) {

               //Acctualizamos el nuevo password
               String strUpdate = "UPDATE usuarios set password = '" + strNvoPass + "' "
                       + "where id_usuarios = '" + varSesiones.getIntNoUser() + "'";
               oConn.runQueryLMD(strUpdate);

               //Bitacora de acciones
               bitacorausers logUser = new bitacorausers();
               Fechas fecha = new Fechas();
               logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
               logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
               logUser.setFieldString("BTU_NOMMOD", "PASSWORD");
               logUser.setFieldString("BTU_NOMACTION", "CHANGE");
               logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
               logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
               logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
               logUser.Agrega(oConn);

               //Buscamos el mail en la bd
               boolean bolEncontro = false;
               String strMail = "";
               String strSql = "select * from usuarios  where id_usuarios='" + varSesiones.getIntNoUser() + "'";
               ResultSet rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  bolEncontro = true;
                  strMail = rs.getString("EMAIL");
               }
               //Si encontro el mail mandamos el password
               if (bolEncontro) {
                  //validamos que hallan puesto el mail
                  Mail mail = new Mail();
                  if (!strMail.equals("")) {
                     if (mail.isEmail(strMail)) {
                        //Intentamos mandar el mail
                        mail.setBolDepuracion(false);
                        mail.getTemplate("CHANGEPASS", oConn);
                        mail.setReplaceContent(rs);
                        mail.setDestino(strMail);
                        boolean bol = mail.sendMail();
                        if (bol) {
                           //strResp = "MAIL ENVIADO.";
                        } else {
                           //strResp = "FALLO EL ENVIO DEL MAIL.";
                        }
                     } else {
                        //strResp = "ERROR: NO ES UN MAIL VALIDO";
                     }
                  } else {
                     //strResp = "ERROR: INGRESE UN MAIL";
                  }
               } else {
                  strResp = "ERROR: EL MAIL DEL USUARIO NO SE ENCONTRO";
               }
               rs.close();
            } else {
               strResp = "ERROR: EL VALOR DEL TEXTO NO CORRESPONDE CON LA IMAGEN";
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResp);//Pintamos el resultado
         }
      } else {
         //Pantalla con acceso publico
         //Pantalla para recuperar la contrasenia
         System.out.println("strOpt " + strOpt);
         if (strOpt.equals("getScLose")) {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <meta name="robots" content="noindex, nofollow" />
      <title><bean:message key="gen.title"/></title>
      <link rel="stylesheet" type="text/css" href="jqGrid/css/flick/jquery-ui-1.8.custom.css" />
      <link rel="stylesheet" type="text/css" href="jqGrid/ui.jqgrid.css" />
      <link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
      <script src="jqGrid/jquery-1.4.2.min.js" type="text/javascript"></script>
      <script src="jqGrid/jquery-ui-1.8.custom.min.js" type="text/javascript"></script>
      <script type="text/javascript" src="javascript/Cadenas.js"></script>
      <script type="text/javascript" src="javascript/CIP_PASS.js"></script>
      <script type="text/javascript" src="javascript/ValidaDato.js"></script>
      <script type="text/javascript" src="javascript/controlDom.js"></script>
      <script type="text/javascript" src="javascript/fixgetElementByIdIE.js"></script>
   </head>
   <body>
      <div>
         <table border=0 width="100%">
            <tr><td rowspan="2" align="left" class="ui-Title" valign="top" width="25%"><img src="images/ptovta/SiWebVentas.png" border="0" alt="" /></td>
               <td align="center"  valign="top" class="ui-Title" width="50%"></td>
               <td align="right" valign="top" class="ui-Title2" width="25%"><img src="images/ptovta/LogoCliente.png" border="0" alt="" /></td>
            </tr>
            <tr>
               <td>
                  <div id="contentform" align="center">
                     <form name="form1" id="form1" action="" method="POST">
                        <table border="0" cellpadding="1" cellspacing="0"  class="tabla">
                           <tr>
                              <td colspan="2" class="form_head"><bean:message key="pass.msg7"/></td>
                           </tr>
                           <tr>
                              <td class="form_field"><bean:message key="pass.msg8"/></td>
                              <td><input type="mimail" name="mimail" id="mimail" class="outEdit" value=""  onblur="QuitaFoco(this,3)" onfocus="PonFoco(this)" maxlength="40" size="30"/><font color="red">*</font></td>
                           </tr>
                           <tr>
                              <td class="form_field" colspan="2"><img alt="Captcha"  src="stickyImg" /></td>
                           </tr>
                           <tr>
                              <td class="form_field"><bean:message key="pass.msg9"/></td>
                              <td><input type="text" name="answer" id="answer" class="outEdit" value=""  onblur="QuitaFoco(this,3)" onfocus="PonFoco(this)" maxlength="30" size="30"/><font color="red">*</font></td>
                           </tr>
                           <tr>
                              <td colspan="2">&nbsp;</td>
                           </tr>
                           <tr>
                              <td colspan="2" align="center"><input type="button" name="saveme" id="saveme" value="<bean:message key="pass.msg10"/>" onClick="doLosePass()"/></td>
                           </tr>
                           <tr>
                              <td colspan="2">&nbsp;</td>
                           </tr>
                        </table>
                     </form>
                  </div>
               </td>
               <td></td>
            </tr>
         </table>
      </div>
   </body>
</html>
<%                     }
         //Manda un correo al mail de la persona que perdio el password
         if (strOpt.equals("doGetLosePass")) {
            String strResp = "OK";
            request.setCharacterEncoding("UTF-8"); // Do this so we can capture non-Latin chars
            String strMail = request.getParameter("mail");
            String strAnswer = request.getParameter("answer");
            //validamos nulos
            if (strMail == null) {
               strMail = "";
            }
            if (strAnswer == null) {
               strAnswer = "";
            }
            //Valor del captcha generado
            Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
            if (captcha.isCorrect(strAnswer)) {
               //validamos que hallan puesto el mail
               Mail mail = new Mail();
               if (!strMail.equals("")) { //correos a donde enviare concatenado con comas
                  if (mail.isEmail(strMail)) {
                     //Buscamos el mail en la bd
                     boolean bolEncontro = false;
                     int intIdUser = 0;
                     String strNomUser = "";
                     String strSql = "select * from usuarios  where EMAIL='" + strMail + "'";
                     ResultSet rs = oConn.runQuery(strSql, true);
                     while (rs.next()) {
                        bolEncontro = true;
                        intIdUser = rs.getInt("id_usuarios");
                        strNomUser = rs.getString("nombre_usuario");
                     }
                     //Si encontro el mail mandamos el password
                     if (bolEncontro) {
                        //Intentamos mandar el mail
                        mail.setBolDepuracion(false);
                        mail.getTemplate("GETPASS", oConn);
                        mail.setReplaceContent(rs);
                        mail.setDestino(strMail);
                        boolean bol = mail.sendMail();
                        if (bol) {
                           //Bitacora de acciones
                           bitacorausers logUser = new bitacorausers();
                           Fechas fecha = new Fechas();
                           logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                           logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                           logUser.setFieldString("BTU_NOMMOD", "PASSWORD");
                           logUser.setFieldString("BTU_NOMACTION", "GETLOSE");
                           logUser.setFieldInt("BTU_IDOPER", intIdUser);
                           logUser.setFieldInt("BTU_IDUSER", intIdUser);
                           logUser.setFieldString("BTU_NOMUSER", strNomUser);
                           logUser.Agrega(oConn);
                        } else {
                           strResp = "ERROR:FALLO EL ENVIO DEL MAIL INTENTE MAS TARDE.";
                        }
                     } else {
                        strResp = "ERROR: EL MAIL DEL USUARIO NO SE ENCONTRO";
                     }
                     rs.close();
                  } else {
                     strResp = "ERROR: NO ES UN MAIL VALIDO";
                  }
               } else {
                  strResp = "ERROR: INGRESE UN MAIL";
               }
            } else {
               strResp = "ERROR: EL VALOR DEL TEXTO NO CORRESPONDE CON LA IMAGEN";
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResp);//Pintamos el resultado
         }
      }
      oConn.close();
%>