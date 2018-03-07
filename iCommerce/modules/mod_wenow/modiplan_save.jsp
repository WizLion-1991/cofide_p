<%-- 
    Document   : ingresos_edit_save
    Created on : 6/05/2013, 05:39:13 PM
    Author     : N4v1d4d3s
--%>

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
    Fechas fecha = new Fechas();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0) {
        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        //Obtenemos parametros

        String strid = request.getParameter("id");

        String strResult = "";

        int intCT_ID = 0;
        int intTRAINING = 0;
        int intAFILIADO = 0;
        int intGLOBAL = 0;
        
        

        String strSql = "select SC_ID,EMP_ID,CT_ID,TI_ID from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {

            intCT_ID = rs.getInt("CT_ID");

        }
        rs.close();

        if (strid.equals("1")) {

            //Llamamos objeto para guardar los datos de la tabla
            CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
            objTabla.Init("CLIENTES", true, true, false, oConn);
            objTabla.setBolGetAutonumeric(true);
            objTabla.ObtenDatos(intCT_ID, oConn);
            out.clearBuffer();//Limpiamos buffer

            objTabla.setFieldString("WN_TRAINING", "1");

            strResult = objTabla.Modifica(oConn);

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado

        }
        if (strid.equals("2")) {

            //Llamamos objeto para guardar los datos de la tabla
            CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
            objTabla.Init("CLIENTES", true, true, false, oConn);
            objTabla.setBolGetAutonumeric(true);
            objTabla.ObtenDatos(intCT_ID, oConn);
            out.clearBuffer();//Limpiamos buffer

            objTabla.setFieldString("WN_AFILIADO", "1");

            strResult = objTabla.Modifica(oConn);

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado

        }
        if (strid.equals("3")) {

            //Llamamos objeto para guardar los datos de la tabla
            CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
            objTabla.Init("CLIENTES", true, true, false, oConn);
            objTabla.setBolGetAutonumeric(true);
            objTabla.ObtenDatos(intCT_ID, oConn);
            out.clearBuffer();//Limpiamos buffer

            objTabla.setFieldString("WN_GLOBAL", "1");

            strResult = objTabla.Modifica(oConn);

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado

        }

        oConn.close();
    }

%>