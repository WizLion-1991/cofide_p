<%-- 
    Document   : centro_negocios
    Created on : 16-jul-2015, 12:28:06
    Author     : ZeusGalindo
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="ERP.Precios"%>
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

        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        //precios
        Precios prec = new Precios();
        //Kits de ingreso
        StringBuilder strOpciones = new StringBuilder();
        //Buscamos los kits de ingreso
        String strSql = "select count(KL_ID_MASTER) as nivel from vta_cliente where KL_ID_MASTER = '" + varSesiones.getintIdCliente() + "';";
        ResultSet rs = oConn.runQuery(strSql, true);
        int intNiveles = 0;
        while (rs.next()) {
            intNiveles = rs.getInt("nivel");
        }
        rs.close();

        oConn.close();
%>
<div class="well ">
    <h3 class="page-header">AGREGAR NUEVA CUENTA</h3>
    <%
      if(intNiveles >= 2){
          out.print("Has hecho mas de 3 ingresos.");
      } else{  
    %>
    <form action="index.jsp?mod=FZWebNvoCentroSave" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
        <div class="userdata">

            <div id="form-new-cuenta-referencias" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Código de promoción"/>
                            <label for="mdlgn-codigo_promo" >Código de promoción:</label>
                            <input type="text" name="mdlgn-codigo_promo" id="mdlgn-codigo_promo" value="" placeholder="Código de promoción" onBlur="checkCodigo()" /><span class="required">*</span>
                            <img id="imgValida"/>
                        </span>
                    </div>
                </div>
            </div>

            <div id="form-new-answer" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="answer"/>
                            <label for="modlgn-cuenta_answer" >&nbsp;</label>
                        </span>
                        <img alt="Captcha"  src="../stickyImg" /><input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
                    </div>
                </div>
            </div>
            <br>
            <br>
            <!--Boton-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
                </div>
            </div>

        </div>
    </form>
    <%
      }
    %>      
    
</div>

<script type="text/javascript">
function checkCodigo() {
        $("#dialogWait").dialog('open');
        document.getElementById("imgValida").innerHTML = "<img id=\"imgValida\" src = \"images/lightbox-ico-loading.gif\"/>";
        var strPOST = "CODIGO=" + document.getElementById("mdlgn-codigo_promo").value;
        $.ajax({
            type: "POST",
                     data: strPOST,
                     scriptCharset: "utf-8",
                     contentType: "application/x-www-form-urlencoded;charset=utf-8",
                     cache: false,
                     dataType: "html",
                     url: "modules/mod_v15matriz/valida_codigo.jsp?ID=1",
            success: function (datos) {
                document.getElementById("imgValida").innerHTML = datos;
                $("#dialogWait").dialog('close');
            },
            error: function (objeto, quepaso, otroobj) {
                alert("Error: Al cargar comprobar codigo:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    }
</script>
<%         }
%>