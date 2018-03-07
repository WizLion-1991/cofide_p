<%-- 
    Document   : TEST_vta_cofide
    Created on : 16-ago-2016, 16:26:32
    Author     : juliochavez
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Vta Cofide</title>
    </head>
    <body>
    <center>
        <h1>Testeando la conexión a la base de datos de COFIDE</h1>
        <%
            /*Obtenemos las variables de sesion*/
            VariableSession varSesiones = new VariableSession(request);
            varSesiones.getVars();
            //Abrimos la conexion
            Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
            oConn.open();
            String strSQL = "select * from usuarios where id_usuarios = " + varSesiones.getIntNoUser();
            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
                out.println("Usuario que realiza el Test: " + rs.getString("nombre_usuario"));
            }
            rs.close();
        %>
    </center>
</body>
</html>
