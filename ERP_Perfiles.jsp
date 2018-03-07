<%-- 
    Document   : ERP_Perfiles
    Created on : 25/10/2013, 06:03:37 PM
    Author     : N4v1d4d3s
--%>

<%@page import="ERP.UsuariosBodegas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        Fechas fecha = new Fechas();
        //Obtenemos parametros
        String strid = request.getParameter("ID");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            //GUARDA UN NUEVO PERFIL
            if (strid.equals("1")) {
                String strRes = "";
                int intUSER = 0;
                int intPER_ID = 0;
                int intSC_ID = 0;

                /**
                 * Creamos el objeto*
                 */
                UsuariosBodegas ub = new UsuariosBodegas(varSesiones);

                /*OBTENEMOS, PARCEAAMOS LOS PARAMETROS SI EL PARCEO ES CORRECTO SE DEFINE EL VALOR AL CAMPO*/
                try {
                    if (request.getParameter("id_usuarios") != null) {
                        intUSER = Integer.valueOf(request.getParameter("id_usuarios"));
                        ub.getUSU_BO().setFieldInt("id_usuarios", intUSER);
                    }
                } catch (NumberFormatException ex) {
                    ex.getMessage();
                }
                try {
                    if (request.getParameter("PER_ID") != null) {
                        intPER_ID = Integer.valueOf(request.getParameter("PER_ID"));
                        ub.getUSU_BO().setFieldInt("PF_ID", intPER_ID);
                    }
                } catch (NumberFormatException ex) {
                    ex.getMessage();
                }
                try {
                    if (request.getParameter("SC_ID") != null) {
                        intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
                        ub.getUSU_BO().setFieldInt("SC1_ID", intSC_ID);
                    }
                } catch (NumberFormatException ex) {
                    ex.getMessage();
                }
                strRes = ub.doAltaUserPerfil(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }

            //ELIMINA UN NUEVO PERFIL
            if (strid.equals("2")) {
                String strRes = "";
                /**
                 * Creamos el objeto*
                 */
                UsuariosBodegas ub = new UsuariosBodegas(varSesiones);
                int intID = 0;
                try {
                    if (request.getParameter("id") != null) {
                        intID = Integer.valueOf(request.getParameter("id"));
                        ub.getUSU_BO().setFieldInt("PUS_ID", intID);
                    }
                } catch (NumberFormatException ex) {
                    ex.getMessage();
                }

                strRes = ub.deleteUserPerfil(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }

        }

    } else {
    }
    oConn.close();

%>