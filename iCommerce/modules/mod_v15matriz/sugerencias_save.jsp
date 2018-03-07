<%-- 
    Document   : sugerencias_save
    Created on : 18/04/2013, 04:14:51 PM
    Author     : N4v1d4d3s
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="Tablas.vta_sugerencias"%>
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
    if (varSesiones.getIntNoUser() != 0) {
        //Para manejo de fechas
        Fechas fecha = new Fechas();

        //Recuperamos todos los valores
        String strFecha = request.getParameter("fecha");
        String strDirigido = request.getParameter("dirigido");
        String strCorreo = "ventas@v15matriz.com"/*request.getParameter("correo")*/;
        String strTexto = request.getParameter("texto");


        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        /*Creamos el objeto*/
        vta_sugerencias sug = new vta_sugerencias();
        sug.setFieldString("SUG_FECHA", fecha.FormateaBD(strFecha, "/"));
        sug.setFieldString("SUG_DIRIGIDO", strDirigido);
        sug.setFieldString("SUG_CORREO", strCorreo);
        sug.setFieldString("SUG_COMENTARIO", strTexto);
        sug.setFieldInt("CT_ID", varSesiones.getintIdCliente());


        String strResult = "";
        //Generamos una alta
        strResult = sug.Agrega(oConn);
        String strSqlUsuarios = "";
        ResultSet rs;
        if (strResult.equals("OK")) {

            //validamos que hallan puesto el mail
            Mail mail = new Mail();
            if (!strCorreo.isEmpty()) {
                String strLstMail = "";
                //Validamos si el mail del cliente es valido
                if (mail.isEmail(strCorreo)) {
                    strLstMail += "," + strCorreo;
                }


                strSqlUsuarios = "SELECT EMAIL FROM usuarios WHERE BOL_MAIL_SUGERENCIAS=1";
                try {
                    rs = oConn.runQuery(strSqlUsuarios);
                   
                    while (rs.next()) {
                        if (!rs.getString("EMAIL").equals("")) {
                            strLstMail += "," + rs.getString("EMAIL");
                        }
                    }

                    rs.close();
                } catch (SQLException ex) {
                    //this.strResultLast = "ERROR:" + ex.getMessage();
                    ex.fillInStackTrace();
                }
                //Intentamos mandar el mail
                mail.setBolDepuracion(false);
                mail.getTemplate("MSG_SUG", oConn);
                mail.getMensaje();
                mail.setDestino(strLstMail);
                 String strSqlEmp = "SELECT SUG_ID,DATE_FORMAT(CURDATE(), '%d/%m/%Y') as FECHA FROM vta_sugerencias"
                        + " where SUG_ID=" + sug.getValorKey()+ "";
                try {
                    rs = oConn.runQuery(strSqlEmp);
                    mail.setReplaceContent(rs);
                    rs.close();
                } catch (SQLException ex) {
                    //this.strResultLast = "ERROR:" + ex.getMessage();
                    ex.fillInStackTrace();
                }
                mail.setDestino(strLstMail);
                
                
                boolean bol = mail.sendMail();
                if (bol) {
%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Se ha registrado su sugerencia su Numero de reporte es:</br> <%=sug.getValorKey()%> </h3>
</div>

<%             } else {
            //strResp = "FALLO EL ENVIO DEL MAIL.";
        }

    } else {
        //strResp = "ERROR: INGRESE UN MAIL";
    }



%>

<%
} else {
%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Error al registrar su mensaje<%=strResult%> </h3>
</div>
<%
        }

        oConn.close();

    }

%>