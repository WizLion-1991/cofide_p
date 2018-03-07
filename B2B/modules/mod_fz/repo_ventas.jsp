<%-- 
    Document   : repo_ventas
    Created on : Sep 18, 2015, 3:50:10 PM
    Author     : CasaJosefa
--%>

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


%>
<div class="well ">
   <h3 class="page-header">Ventas de mis productos</h3>
   <form action="index.jsp?mod=FZWebRepoVentasList" method="post"  onsubmit="return  EvaluaFormulario();"   id="tree-form" class="form-inline">
      <div class="userdata">
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <span class="required">Seleccione el periodo de fechas por visualizar</span>
            </div>
         </div>   


         <!--FECHA_INICIAL-->
         <div id="form-new-finicial" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="FECHA INICIAL"/>
                     <label for="fechaInicial" >FECHA INICIAL: </label>                                
                  </span>
                  <input id="fechaInicial" type="text" name="finicial" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/><span class="required">*</span>
               </div>
            </div>
         </div>
         <!--FECHA_FINAL-->
         <div id="form-new-ffinal" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="FECHA FINAL"/>
                     <label for="fechaFinal" >FECHA FINAL: </label>                                
                  </span>
                  <input id="fechaFinal" type="text" name="ffinal" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/><span class="required">*</span>
               </div>
            </div>
         </div>
            <!--Boton-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Consultar</button>
                </div>
            </div>
      </div>
   </form>
</div>
<script type="text/javascript">
   $("#fechaInicial").datepicker({
      changeMonth: true,
      changeYear: true
   });
   $("#fechaFinal").datepicker({
      changeMonth: true,
      changeYear: true
   });
   
    function EvaluaFormulario() {
        

        if (document.getElementById("fechaInicial").value == "") {
            alert("Es necesario que capture la fecha inicial");
            document.getElementById("fechaInicial").focus();
            return false;
        }
        if (document.getElementById("fechaFinal").value == "") {
            alert("Es necesario que capture la fecha final");
            document.getElementById("fechaFinal").focus();
            return false;
        }
        
        return true;
    }
    
</script>
<%         }
%>
