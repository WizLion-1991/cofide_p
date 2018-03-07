<%-- 
    Document   : cambio_contraseña_opciones
    Created on : 8/05/2013, 04:46:37 PM
    Author     : siwebmx5
--%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.ui.web.contrasenia.Cambio_Contrasenia"%>
<%@page import="nl.captcha.Captcha"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
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
        String strid = request.getParameter("ID");
        if (strid != null) {
            if (strid.equals("1")) {
                Cambio_Contrasenia CC = new Cambio_Contrasenia();
                String strAnswer = request.getParameter("answer");
                String strPassword = request.getParameter("password");
                String strCntAnt = request.getParameter("ContAnt");
                String strResult = "";

                String strSQL = "Select * From vta_proveedor Where PV_ID =" + varSesiones.getIntNoUser();
                ResultSet rs = oConn.runQuery(strSQL);
                String strPass = "";
                while (rs.next()) {
                    strPass = rs.getString("PV_PASSWORD");
                    System.out.println(strPass+":"+strCntAnt);
                    if (strPass.equals(strCntAnt)) {
                        Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
                        if (captcha.isCorrect(strAnswer)) {
                            strResult = CC.CambiaContraseniaProv(oConn, varSesiones.getIntNoUser(), strPassword);
                            Sesiones.SetSession(request, "EvalPassword1", "0");
                            //Quitamos la bandera de cambio de password
                            String strUpdateCte = "update vta_cliente set CT_CHANGE_PASSWRD = 0 where CT_ID= " + varSesiones.getIntNoUser();
                            oConn.runQueryLMD(strUpdateCte);
                        }
                        else
                        {
                            strResult ="ERRORC";
                        }
                    }
                    else
                    {
                        strResult ="ERROR";
                    }
                }
                //Validamos el captcha

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResult);//Pintamos el resultado
            }
        }

    }
%>