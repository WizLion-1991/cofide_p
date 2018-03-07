<%-- 
    Document   : cambio_contraseña
    Created on : 8/05/2013, 02:04:49 PM
    Author     : siwebmx5
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    if (varSesiones.getIntNoUser() != 0) {

        //Recuperamos los nombres de los estados
        ArrayList<String> lstEstado = new ArrayList<String>();
        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        //Consultamos los estados
        String strSql = "select * from estadospais where PA_ID = 1";
        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            lstEstado.add(rs.getString("ESP_NOMBRE"));
        }

        rs.close();
        oConn.close();
%>

<html>
    <head>
        <script>
            function Guarda()
            {
                //alert("La mafia china te vigila (-.(-.(-.-).-).-)");
                var ConAnt = document.getElementById("CONTRASENIA_ANT").value;
                var ConNueva=document.getElementById("CONTRASENIA_NUEVA").value;
                var ConfNueva=document.getElementById("CONFIRMAR_CONTRASENIA").value;
                if(ConAnt == "")
                {
                    alert("Tienes que escribir tu contraseña anterior");
                    return false;
                }
                if(ConNueva == "")
                {
                    alert("Tienes que escribir la nueva contraseña");
                    return false;
                }
                if(ConfNueva == "")
                {
                    alert("Tienes que confirmar la nueva contraseña");
                    return false;
                }
                else
                {
                    if(ConNueva!= "")
                    {
                        if(ConNueva==ConfNueva)
                        {
                            //alert("Hacemos el cambio");
                            var answer = document.getElementById("modlgn-answer").value;
                            var Pass = document.getElementById("CONFIRMAR_CONTRASENIA").value;
                            var strPOST = "&answer="+answer;
                            strPOST += "&password="+Pass;
                            strPOST += "&ContAnt="+ConAnt;
                            //alert(strPOST);
                            $.ajax({
                                type: "POST",
                                data: strPOST,
                                scriptCharset: "utf-8" ,
                                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                                cache: false,
                                dataType:"html",
                                url: "modules/mod_fz/cambio_contrasena_opciones.jsp?ID=1",
                                success: function(datos)
                                {
                                    if(datos.substring(0,2)=="OK")
                                    {
                                        alert("Se ha cambiado correctamente.");
                                        document.getElementById("CONTRASENIA_ANT").value="";
                                        document.getElementById("CONTRASENIA_NUEVA").value="";
                                        document.getElementById("CONFIRMAR_CONTRASENIA").value="";
                                        document.getElementById("modlgn-answer").value="";
                                    }
                                    else
                                    {
                                        if(datos.substring(0,6)=="ERRORC")
                                        {
                                            alert("El texto no corresponde con la imagen");
                                            document.getElementById("modlgn-answer").focus();
                                        }
                                        else
                                        {
                                            alert("Tu contraseña anterior no es correcta");
                                            document.getElementById("CONTRASENIA_ANT").focus();
                                        }
                                    }
                                },
                                error: function(objeto, quepaso, otroobj)
                                {
                                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                                }
                            });  
                        }
                        else
                        {
                            alert("No coinciden las contraseñas nuevas");
                        }
                    }
                }
                
            }
        </script>
    </head>
    <body>
        <div class="well ">
            <h3 class="page-header">Cambio de Contraseña</h3>
            <form class="form-inline">
                <div class="userdata">
                    <!--CONTRASEÑA ANTERIOR--> 
                    <div id="form-new-contant" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="CONTRASENIA_ANTERIOR"/>
                                    <label for="contrasenia_anterior" >Contraseña anterior: </label>                                
                                </span>
                                <input id="CONTRASENIA_ANT" type="password" name="contraseniaant" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--CONTRASEÑA NUEVA--> 
                    <div id="form-new-contnueva" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="CONTRASENIA_NUEVA"/>
                                    <label for="contrasenia_nueva" >Nueva contraseña: </label>                                
                                </span>
                                <input id="CONTRASENIA_NUEVA" type="password" name="contrasenianueva" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--CONFIRMAR CONTRASEÑA--> 
                    <div id="form-new-confcont" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="CONFIRMAR_CONTRASENIA"/>
                                    <label for="confirmar_contrasenia" >Confirme  contraseña: </label>                                
                                </span>
                                <input id="CONFIRMAR_CONTRASENIA" type="password" name="confirmacontrasenia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/><span class="required">*</span>
                            </div>
                        </div>
                    </div>

                    <div id="form-new-img" class="control-group">
                        <div class="controls">
                            <div>
                                <span class="add-on">
                                    <span title="answer"/>
                                    <label for="modlgn-cuenta_answer" >&nbsp;</label>
                                </span>
                                <img alt="Captcha"  src="../stickyImg" />

                            </div>                            
                        </div>

                    </div>
                    <!--TEXTO DE LA IMAGEN--> 
                    <div id="form-new-textimg" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="CONFIRMAR_TEXTO"/>
                                    <label for="confirmar_texto" >Escriba el texto de la imagen:</label>                                
                                </span>
                                <input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <div id="form-new-guardar" class="control-group">
                        <div class="controls">
                            <button type="button" tabindex="0" name="Guardar" class="btn btn-primary btn" onclick="Guarda()" id="BTN_GUARDAR">Guardar</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </body>    
</html>


<%         }
%>