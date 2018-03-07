<%-- 
    Document   : ingresos
    Este jsp contiene la pantalla de captura de nuevos ingresos
    Created on : 16-abr-2013, 15:31:53
    Author     : aleph_79
--%>

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

        //Recuperamos los nombres de los estados
        ArrayList<String> lstEstado = new ArrayList<String>();
        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
%>
<div class="well ">
    <h3 class="page-header">Quejas y Sugerencias</h3>
    <form action="index.jsp?mod=sugerencias_save" method="post" onsubmit="return  EvaluaFormulario();"  id="login-form" class="form-inline">
        <div class="userdata">
            <div id="img-quejas">
                
            </div>

            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <span class="required">* Los campos marcados en rojo son obligatorios</span>
                </div>
            </div>
            <!--Fecha-->
            <div id="form-new-fecha" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Fecha"/>
                            <label for="modlgn-fecha" >Fecha:</label>
                        </span>
                        <input id="modlgn-datepicker" type="text" name="fecha"  tabindex="0" size="30" maxlength="29" placeholder="Fecha"/><span class="required">*</span>

                    </div>
                </div>
            </div>
            <!--Dirigido a-->
            <div id="form-new-adirigido" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="A quien va dirigido"/>
                            <label for="modlgn-dirigido" >Dirigido a:</label>
                        </span>
                        <input id="modlgn-dirigido" type="text" name="dirigido" value="Kapitalia" tabindex="0" size="30" maxlength="50" placeholder="A quien va dirigido"/readonly><span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Correo-->
            <div id="form-new-correo" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Correo"/>
                            <label for="modlgn-correo" >Correo:</label>
                        </span>
                        <input id="modlgn-correo" type="text" name="correo" value="quejasysugerencias@kapitaliamexico.com"  tabindex="0" size="30" maxlength="29" placeholder="Correo"/ readonly><span class="required">*</span>

                    </div>
                </div>
            </div>

            <!--Dirigido a-->
            <div id="form-new-mensaje" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                    </div>
                    <TEXTAREA COLS=100 ROWS=10 id="Texto" style="width: 562px; height: 197px;" onBlur="pasaValor()">
                    </TEXTAREA> 
                    <input type="hidden" id="texto" name="texto"/>
                </div>
            </div>

            <!--Boton-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
                </div>
            </div>

        </div>
    </form>
</div>
<script>
    $(function() {
        $( "#modlgn-datepicker" ).datepicker({       
            dateFormat: 'dd/mm/yy',
            defaultDate: new Date()
        });
        $('#modlgn-datepicker').datepicker().datepicker('setDate',new Date());
    });
</script>

<script>
    function EvaluaFormulario(){
       
        if(document.getElementById("modlgn-datepicker").value==""){
           
           
            alert("Seleccione una fecha");
            document.getElementById("modlgn-datepicker").focus();
            return false;
        }
       
        if(document.getElementById("modlgn-dirigido").value==""){
           
            alert("Capture el nombre de la persona a quien va dirigido");
            document.getElementById("modlgn-dirigido").focus();
            return false;
        }
       
        if(document.getElementById("modlgn-correo").value!=""){
           
            var bolExpReg = _EvalExpReg(document.getElementById("modlgn-correo").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
            if (!bolExpReg) {
                alert("El formato del mail es incorrecto");
                document.getElementById("modlgn-correo").focus();
                return false;
            }
        }
        
        if( document.getElementById("texto").value==""){
         
            alert("Escriba aqui el texto");
            document.getElementById("Texto").focus();
            return false;
        }
       
       
        return true;
       
    }
   
    /*PASA LO QUE ESCRIBES EN TEXTAREA A UN HIDDEN PARA VALIDARLO*/
    function pasaValor(){
        
        document.getElementById("texto").value= document.getElementById("Texto").value;
    }
   
    //Valida un cadena conforme una expresion regular
    function _EvalExpReg(YourValue, YourExp)
    {
        var Template = new RegExp(YourExp)
        return (Template.test(YourValue)) ? 1 : 0 //Compara "YourAlphaNumeric" con el formato "Template" y si coincidevuelve verdadero si no devuelve falso
    }
</script>

<%         }
%>
