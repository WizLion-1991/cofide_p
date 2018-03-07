<%-- 
    Document   : subir_archivo
    Created on : 8/01/2016, 12:58:10 PM
    Author     : smarin
--%>
<%@page import="com.sun.xml.rpc.processor.modeler.j2ee.xml.string"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Tablas.vta_cliente"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0) {
        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();


       
           
%>   
<!--upload-->
<script type="text/javascript" src="../jqGrid/ajaxfileupload.js"></script>    
<script type="text/javascript">
    function upfilemlm() {
        var File = document.getElementById("archivo_doc");
        if (File.value == "") {
            alert("Requiere seleccionar un archivo");
            File.focus();
        } else {
            if (File.value.toUpperCase().substring(File.value.length - 3, File.value.length) == "PDF") {
                $.ajaxFileUpload({
                    url: 'modules/mod_prosperidad/upfilemulti.jsp',
                    secureuri: false,
                    fileElementId: "archivo_doc",
                    dataType: 'json',
                    success: function (data, status)
                    {
                        if (typeof (data.error) != 'undefined') {
                            if (data.error != '') {
                                alert(data.error);
                            } else {
                                alert("ARCHIVO SUBIDO CORRECTAMENTE");
                            }
                        } else {
                            alert("ok");
                        }
                        $("#dialogWait").dialog('close');
                    },
                    error: function (data, status, e) {
                        alert(e);
                        $("#dialogWait").dialog('close');
                    }
                }

                );
            } else {
                alert("Se aceptan archivos con extension pdf");
                File.focus();
            }
        }
    }


</script>
<div id="form-new-submit" class="control-group">
    <h1>Subir Documentacion</h1>
    <form  method="post" action="action.cgi" enctype="multipart/form-data">
        Elige el archivo:
    </form> 
    <input type="file" name="Examinar" id="archivo_doc">
    <!--Boton-->
    <div id="form-new-submit" class="control-group">
        <div class="controls">
            <button type="submit" tabindex="0" onclick="upfilemlm()"  name="Submit" class="btn btn-primary btn" >Guardar</button> 

        </div>
    </div>


    <!--Tabla-->
    <div id = "div Principal">
        <div id="div_titulo" class="panel panel-default">
            <div class="panel-heading"></div>
            <div style="text-align: center">
                <table cellpadding="10" cellspacing="5" border="5" >
                    <%                        Fechas fecha = new Fechas();
                        String strSql1 = "select LIS_NOMARCHIVO,LIS_PATHIMGFORM,LIS_ID, CT_ID  FROM mlm_listado where CT_ID =  " + varSesiones.getintIdCliente() ;
                        String LIS_NOMARCHIVO = "";
                        String LIS_PATHIMGFORM = "";
                        String LIS_ID = "";
                        String CT_ID = "";

                       ResultSet rs = oConn.runQuery(strSql1, true);
                        while (rs.next()) {
                            LIS_NOMARCHIVO = rs.getString("LIS_NOMARCHIVO");
                            LIS_PATHIMGFORM = rs.getString("LIS_PATHIMGFORM");
                            LIS_ID = rs.getString("LIS_ID");
                            CT_ID = rs.getString("CT_ID");
                    %>
                    <tr>
                        <td><font size=2><%=LIS_ID%></font></td>
                        <td><font size=2><%=LIS_NOMARCHIVO%></font></td>



                    </tr>

                    <%
                        }
                        rs.close();
                    %>
                </table>
            </div>
        </div>
    </div>
</div>


<%
        oConn.close();
    }
%>
