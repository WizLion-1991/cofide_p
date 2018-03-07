<%-- 
    Document   : ERP_SubclientesFac
    Created on : 1/11/2013, 12:39:54 PM
    Author     : N4v1d4d3s
--%>

<%@page import="ERP.SubclientesFacturacion"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="ERP.DireccionesEntrega"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            //SIRVE PARA DAR DE ALTA UN SUBCLIENTE
            if (strid.equals("1")) {
                SubclientesFacturacion sub = new SubclientesFacturacion(varSesiones);
                int intId = 0;

                sub.getSUB().setFieldString("DFA_RAZONSOCIAL", request.getParameter("DFA_RAZONSOCIAL"));
                sub.getSUB().setFieldString("DFA_RFC", request.getParameter("DFA_RFC"));
                sub.getSUB().setFieldString("DFA_CALLE", request.getParameter("DFA_CALLE"));
                sub.getSUB().setFieldString("DFA_NUMERO", request.getParameter("DFA_NUMERO"));
                sub.getSUB().setFieldString("DFA_NUMINT", request.getParameter("DFA_NUMINT"));
                sub.getSUB().setFieldString("DFA_COLONIA", request.getParameter("DFA_COLONIA"));
                sub.getSUB().setFieldString("DFA_LOCALIDAD", request.getParameter("DFA_LOCALIDAD"));
                sub.getSUB().setFieldString("DFA_MUNICIPIO", request.getParameter("DFA_MUNICIPIO"));
                sub.getSUB().setFieldString("DFA_ESTADO", request.getParameter("DFA_ESTADO"));
                sub.getSUB().setFieldString("DFA_CP", request.getParameter("DFA_CP"));
                if (request.getParameter("CT_ID") != null) {
                    try {
                        intId = Integer.parseInt(request.getParameter("CT_ID"));
                    } catch (NumberFormatException e) {
                        e.getMessage();
                    }
                }

                sub.getSUB().setFieldInt("CT_ID", intId);

                String strRespXML = sub.save_subClienteFacturacion(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado

            }

        }

    }


%>