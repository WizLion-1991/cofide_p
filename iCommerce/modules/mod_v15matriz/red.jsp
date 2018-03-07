<%-- 
    Document   : red
      Pantalla de seleccion de reporte de descendencia
    Created on : 16-abr-2013, 15:48:38
    Author     : aleph_79
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

      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
%>
<div class="well ">
   <h3 class="page-header">Mi red</h3>
   <form action="index.jsp?mod=red_tabla" method="post"   id="tree-form" class="form-inline">
      <div class="userdata">
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <span class="required">Seleccione el tipo de visualizacion</span>
            </div>
         </div>   
         <!--Boton tabla-->
         <div id="form-new-submit" class="control-group">
            <div class="controls" style="text-align: center;">
               <button type="button" tabindex="0" name="Submit"  onClick="RedTabla()"><img src="images/tabla2.png" border="0"/></button>
            </div>
            <div style="text-align: center;"><h2>Tabla</h2></div>
         </div>
         <!--Boton grafico UNILEVEL-->
         <div id="form-new-submit" class="control-group">
            <div class="controls" style="text-align: center;">
               <button type="button" tabindex="0" name="Submit"  onClick="RedGraficaUnilevel()"><img src="images/grafica3.png" border="0"/></button>
            </div>
            <div style="text-align: center;"><h2>Gr&aacute;fico Unilevel</h2></div>
         </div>
         
         
      </div>
   </form>
</div>
<script type="text/javascript">
      //Reporte por tabla
      function RedTabla() {
         document.getElementById("tree-form").submit();
      }
      //Reporte por grafica
      function RedGraficaUnilevel() {
         document.getElementById("tree-form").action = "index.jsp?mod=red_grafica&Modo=Unilevel";
         document.getElementById("tree-form").submit();
      }
      //Reporte por grafica
      function RedGraficaBinario() {
         document.getElementById("tree-form").action = "index.jsp?mod=red_grafica&Modo=Binario";
         document.getElementById("tree-form").submit();
      }
      //Reporte por grafica
      function RedGraficaBinario() {
         document.getElementById("tree-form").action = "index.jsp?mod=red_grafica&Modo=BinarioA";
         document.getElementById("tree-form").submit();
      }
      //Reporte por grafica
      function RedGraficaBinario() {
         document.getElementById("tree-form").action = "index.jsp?mod=red_grafica&Modo=BinarioG";
         document.getElementById("tree-form").submit();
      }


</script>
<%         }
%>
