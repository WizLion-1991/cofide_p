<%-- 
    Document   : ERP_DireccionesEntrega
    Created on : 23/07/2013, 10:33:01 AM
    Author     : N4v1d4d3s
--%>
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
            //OBTENEMOS LAS DIRECCIONES DE ENTREGA DEL CLIENTE SELECCIONADO
            if (strid.equals("1")) {
                DireccionesEntrega dir = new DireccionesEntrega(varSesiones);
                int intId = 0;
                if (request.getParameter("ct_id") != null) {
                    intId = Integer.parseInt(request.getParameter("ct_id"));
                }
                String strRespXML = dir.getDirecciones(intId, oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado

            }
            //SIRVE PARA DAR DE ALTA UNA NUEVA DIRECCION DE ENTREGA
            if (strid.equals("2")) {
                DireccionesEntrega dir = new DireccionesEntrega(varSesiones);
                int intId = 0;

                dir.getDIR().setFieldString("CDE_CALLE", request.getParameter("CDE_CALLE"));
                dir.getDIR().setFieldString("CDE_COLONIA", request.getParameter("CDE_COLONIA"));
                dir.getDIR().setFieldString("CDE_LOCALIDAD", request.getParameter("CDE_LOCALIDAD"));
                dir.getDIR().setFieldString("CDE_MUNICIPIO", request.getParameter("CDE_MUNICIPIO"));
                dir.getDIR().setFieldString("CDE_ESTADO", request.getParameter("CDE_ESTADO"));
                dir.getDIR().setFieldString("CDE_CP", request.getParameter("CDE_CP"));
                dir.getDIR().setFieldString("CDE_NUMERO", request.getParameter("CDE_NUMERO"));
                dir.getDIR().setFieldString("CDE_NUMINT", request.getParameter("CDE_NUMINT"));
                dir.getDIR().setFieldString("CDE_TELEFONO1", request.getParameter("CDE_TELEFONO1"));
                dir.getDIR().setFieldString("CDE_NOMBRE", request.getParameter("CDE_NOMBRE"));
                dir.getDIR().setFieldString("CDE_EMAIL", request.getParameter("CDE_EMAIL"));
                dir.getDIR().setFieldString("CDE_DESCRIPCION", request.getParameter("CDE_DESCRIPCION"));
                dir.getDIR().setFieldString("CDE_PAIS", request.getParameter("CDE_PAIS"));
                if (request.getParameter("CT_ID") != null) {
                    try {
                        intId = Integer.parseInt(request.getParameter("CT_ID"));
                    } catch (NumberFormatException e) {
                        e.getMessage();
                    }
                }
                dir.getDIR().setFieldInt("CT_ID", intId);
                dir.getDIR().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());

                String strRespXML = dir.saveDireccionEntrega(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado

            }

            //NOS REGRESA TRUE O FALSE DE SI YA FUE USADA LA DIRECCION
            if (strid.equals("3")) {

                int intIdDir = 0;
                ResultSet rs;
                String strResp = "";
                if (request.getParameter("id_dir") != null) {
                    intIdDir = Integer.parseInt(request.getParameter("id_dir"));
                }

                try {
                    String strSelect = "SELECT count(CDE_ID) as NUM FROM vta_facturas WHERE CDE_ID =" + intIdDir;
                    rs = oConn.runQuery(strSelect);

                    while (rs.next()) {

                        strResp = "OK";
                    }

                } catch (SQLException Ex) {
                    strResp = Ex.getMessage();
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado

            }
            //SIRVE PARA BORRAR UNA DIRECCION DE ENTREGA DE LA BASE DE DATOS
            if (strid.equals("4")) {
                DireccionesEntrega dir = new DireccionesEntrega(varSesiones);
                int intId = 0;
                if (request.getParameter("dir_id") != null) {
                    intId = Integer.parseInt(request.getParameter("dir_id"));
                    dir.getDIR().setFieldInt("CDE_ID", intId);
                }
                String strResp = dir.delDireccionEntrega(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado

            }
        }

    }


%>