<%-- 
    Document   : red
      Pantalla de seleccion de reporte de descendencia
    Created on : 16-abr-2013, 15:48:38
    Author     : aleph_79
--%>

<%@page import="java.sql.ResultSet"%>
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
      int intWN_ID_TRAINING = 0;
      int intWN_ID_AFILIADO = 0;
      int intWN_ID_GLOBAL = 0;
      String strSql = "select CT_ID,WN_ID_TRAINING,WN_ID_AFILIADO,WN_ID_GLOBAL from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         intWN_ID_TRAINING = rs.getInt("WN_ID_TRAINING");
         intWN_ID_AFILIADO = rs.getInt("WN_ID_AFILIADO");
         intWN_ID_GLOBAL = rs.getInt("WN_ID_GLOBAL");
      }
      rs.close();
      
      oConn.close();
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
            <div style="text-align: center;"><h2>TRAINING ESTRUCTURAL</h2></div>
         </div>

         <!--Boton grafico Binario-->
         <%if(intWN_ID_TRAINING != 0){%>
         <div id="form-new-submit" class="control-group">
            <div class="controls" style="text-align: center;">
               <button type="button" tabindex="0" name="Submit"  onClick="RedGraficaBinario()"><img src="images/grafica3.png" border="0"/></button>
            </div>
            <div style="text-align: center;"><h2>TRAINING</h2></div>
         </div>
         <%}%>

         <!--Boton grafico Binario-->
         <%if(intWN_ID_AFILIADO != 0){%>
         <div id="form-new-submit" class="control-group">
            <div class="controls" style="text-align: center;">
               <button type="button" tabindex="0" name="Submit"  onClick="RedGraficaBinarioA()"><img src="images/grafica3.png" border="0"/></button>
            </div>
            <div style="text-align: center;"><h2>REDES INTELIGENTES.</h2></div>
         </div>
         <%}%>

         <!--Boton grafico Binario-->
         <%if(intWN_ID_GLOBAL != 0){%>
         <div id="form-new-submit" class="control-group">
            <div class="controls" style="text-align: center;">
               <button type="button" tabindex="0" name="Submit"  onClick="RedGraficaBinarioG()"><img src="images/grafica3.png" border="0"/></button>
            </div>
            <div style="text-align: center;"><h2>ASOCIADO GLOBAL</h2></div>
         </div>
         <%}%>

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
   function RedGraficaBinarioA() {
      document.getElementById("tree-form").action = "index.jsp?mod=red_grafica&Modo=BinarioA";
      document.getElementById("tree-form").submit();
   }
   //Reporte por grafica
   function RedGraficaBinarioG() {
      document.getElementById("tree-form").action = "index.jsp?mod=red_grafica&Modo=BinarioG";
      document.getElementById("tree-form").submit();
   }


</script>
<%         }
%>
