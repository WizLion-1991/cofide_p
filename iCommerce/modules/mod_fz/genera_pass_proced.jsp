<%-- 
    Document   : genera_pass_proced
    Created on : Oct 1, 2015, 12:13:01 PM
    Author     : CasaJosefa
--%>

<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="Tablas.vta_cliente_dir_entrega"%>
<%@page import="Tablas.vta_pedidosdeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="ERP.Impuestos"%>
<%@page import="ERP.Ticket"%>
<%@page import="nl.captcha.Captcha"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.DigitoVerificador"%>
<%@page import="comSIWeb.Utilerias.generateData"%>
<%@page import="java.util.Random"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio

    if (1 == 1 /*varSesiones.getIntNoUser() != 0*/) {
        //Para manejo de fechas
        Fechas fecha = new Fechas();
        Periodos periodo = new Periodos();

        //Recuperamos todos los valores
        Conexion oConn2 = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn2.open();
        /*String MySQL ="Select CC1_ID From vta_cliecat1 Where CC1_DESCRIPCION = '"+strTIngreso+"'";
         ResultSet rs10 = oConn2.runQuery(MySQL);
         while (rs10.next()) {
         strTIngreso = rs10.getString("CC1_ID");            
         }
         rs10.close();
         */

        String strAnswer = request.getParameter("answer");
        String strMail = request.getParameter("email1");

            String strResp = "OK";

        //Validamos el captcha
        Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
        if (captcha.isCorrect(strAnswer)) {
            //Abrimos la conexion
            Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
            oConn.open();

            //validamos nulos
            if (strMail == null) {
                strMail = "";
            }
            if (strAnswer == null) {
                strAnswer = "";
            }

                //validamos que hallan puesto el mail
                Mail mail = new Mail();
                if (!strMail.equals("")) {
                    if (mail.isEmail(strMail)) {
                        //Buscamos el mail en la bd
                        boolean bolEncontro = false;
                        int intIdUser = 0;
                        String strNomUser = "";
                        String strSql = "select * from vta_cliente  where CT_EMAIL1='" + strMail + "'";
                        ResultSet rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            bolEncontro = true;
                            intIdUser = rs.getInt("CT_ID");
                            strNomUser = rs.getString("CT_RAZONSOCIAL");
                        }
                        //Si encontro el mail mandamos el password
                        if (bolEncontro) {
                            //Intentamos mandar el mail
                            mail.setBolDepuracion(false);
                            mail.getTemplate("GETPASSCLIENTE", oConn);
                            mail.setReplaceContent(rs);
                            mail.setDestino(strMail);
                            boolean bol = mail.sendMail();
                            if (bol) {
                                //Bitacora de acciones
                                bitacorausers logUser = new bitacorausers();
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


            oConn.close();
        } else {
            strResp = "ERROR:El texto de la imagen no coincide";
        }
        //Validamos si fue exitoso
        if (strResp.equals("OK")) {

%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">El Envio del correo fue :</br> <%=strResp%> </h3>

</div>
<%
} else {
%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Error al enviar el correo  , mensaje de error <%=strResp%> </h3>
    <input type="button" name="back" value="Regresar" class="btn btn-primary btn" onClick="window.history.back()"/>
</div>
<%
        }

    }

%>
