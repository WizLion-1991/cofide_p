<%-- 
    Document   : ingresos_edit
    Created on : 6/05/2013, 03:36:21 PM
    Author     : N4v1d4d3s
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
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

        Fechas fecha = new Fechas();
        //Recuperamos los nombres de los estados
        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        //Consultamos los estados
        int intCT_ID = 0;

        int intTRAINING = 0;
        int intAFILIADO = 0;
        int intGLOBAL = 0;

        String strTRAINING = "button";
        String strAFILIADO = "button";
        String strGLOBAL = "button";

        String strSql = "select CT_ID,WN_TRAINING,WN_AFILIADO,WN_GLOBAL from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {

            intCT_ID = rs.getInt("CT_ID");
            intTRAINING = rs.getInt("WN_TRAINING");
            intAFILIADO = rs.getInt("WN_AFILIADO");
            intGLOBAL = rs.getInt("WN_GLOBAL");
        }
        rs.close();

        if (intTRAINING == 1) {
            strTRAINING = "none";
        }

        if (intAFILIADO == 1) {
            strAFILIADO = "none";
        }

        if (intGLOBAL == 1) {
            strGLOBAL = "none";
        }

        oConn.close();
%>
<div class="well ">
    <h3 class="page-header">AÑADIR PLAN </h3>
    <form  
        >
        <div class="userdata">
            <div id="form-new-submit" class="control-group">
                <div class="controls">

                </div>
            </div>





            <!--Boton1-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="button" id="boton1" style="display: <%=strTRAINING%>" tabindex="0" name="Submit" class="btn btn-primary btn" onclick="ActivaBotones1()" >Training</button>


                </div>
            </div>
            <!--Boton2-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="button" id="boton2" style="display: <%=strAFILIADO%>" tabindex="0" name="Submit1" class="btn btn-primary btn "  onclick="ActivaBotones2()" >Afiliado</button>
                </div>
            </div>
            <!--Boton3-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="button" id="boton3" style="display: <%=strGLOBAL%>" tabindex="0" name="Submit2" class="btn btn-primary btn" onclick="ActivaBotones3()" >Global</button>
                </div>
            </div>

        </div>
    </form>
</div>
<script type="text/javascript">


    function ActivaBotones1() {

        $.ajax({
            url: 'modules/mod_fz/modiplan_save.jsp?id=1',
            dataType: 'html',
            success: function (datos) {
                document.getElementById("boton1").style = "display:none";

                alert("Su petición ha sido almacenada");
            },
            error: function () {
                alert("fallo");
            }
        });

    }

    function ActivaBotones2() {

        $.ajax({
            url: 'modules/mod_fz/modiplan_save.jsp?id=2',
            dataType: 'html',
            success: function (datos) {
                document.getElementById("boton2").style = "display:none";
                alert("Su petición ha sido almacenada");
            },
            error: function () {
                alert("fallo");
            }
        });

    }

    function ActivaBotones3() {

        $.ajax({
            url: 'modules/mod_fz/modiplan_save.jsp?id=3',
            dataType: 'html',
            success: function (datos) {
                document.getElementById("boton3").style = "display:none";
                alert("Su petición ha sido almacenada");
            },
            error: function () {
                alert("fallo");
            }
        });

    }


</script>

<%         }
%>