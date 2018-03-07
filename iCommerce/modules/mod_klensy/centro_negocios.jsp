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
      String strSql = "select PR_ID,PR_DESCRIPCION from vta_producto where PR_ESKITINC = 1";
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         double dblPrecio = 0;
         strSql = "select PR_ID,PP_PRECIO,PP_APDESC,PP_PTOSLEAL,PP_PTOSLEALCAM "
                 + ",PP_PRECIO_USD,PP_PUNTOS,PP_NEGOCIO,PP_PPUBLICO,PP_APDESC,PP_APDESCPTO,PP_APDESCNEGO,PP_PUTILIDAD "
                 + " from vta_prodprecios where PR_ID = " + rs.getInt("PR_ID") + " AND LP_ID= 1";
         ResultSet rs2;
         try {
            rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               dblPrecio = rs2.getDouble("PP_PRECIO");
               dblPrecio = dblPrecio * 1.16;
            }
            rs2.close();
         } catch (SQLException ex) {
         }

         strOpciones.append("<option value='" + rs.getInt("PR_ID") + "'>" + rs.getString("PR_DESCRIPCION") + " $" + comSIWeb.Utilerias.NumberString.FormatearDecimal(dblPrecio, 2) + "</option>");
      }
      rs.close();

      oConn.close();
%>
<div class="well ">
   <h3 class="page-header">AGREGAR NUEVA CUENTA</h3>
   <form action="index.jsp?mod=FZWebNvoCentroSave" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
      <div class="userdata">

         <div id="form-new-cuenta-referencias" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="A que cuenta se va a referenciar"/>
                     <label for="modlgn-referenciar" >¿A que cuenta se va a referenciar?:</label>
                     <input type="text" name="referenciado_a" id="referenciado_a" value="0" /><span class="required">*</span>
                  </span>
               </div>
            </div>
         </div>

         <!--Tipo de kit-->
         <div id="form-new-kit_ingreso" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="kit_ingreso"/>
                     <label for="modlgn-kit_ingreso" >Kit de ingreso:</label>
                     <select id="modlgn-kit_ingreso" name="kit_ingreso" class="combo1"  placeholder="Kit de ingreso9">
                        <%=strOpciones%>
                     </select><span class="required">*</span>
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
</div>
<%         }
%>