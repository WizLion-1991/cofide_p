<%-- 
    Document   : Compensacion
    Created on : 16-abr-2013, 15:49:16
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
      //Buscamos si tenemos un credito
      int intIdCredito = 0;
      double dblMontoCredito = 0;
      String strSql = "select CTO_ID,(select cat_monto.MTO_MCREDITO from  cat_monto where cat_monto.MTO_ID = cat_credito.MTO_ID ) as monto from cat_credito where ct_id = " + varSesiones.getintIdCliente() + " and CTO_AUTORIZADO = 1 " ;
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
             intIdCredito = rs.getInt("CTO_ID");
             dblMontoCredito = rs.getDouble("monto");
      }
      rs.close();
      //Validar si tiene credito activo
      if(intIdCredito != 0){
            //Si tiene credito
      }else{
         //Mandar mensaje de error
      }

%>
<div class="well ">
   <h3 class="page-header">Cr&eacute;dito</h3>
   <form action="index.jsp?mod=comi_view" method="post" onsubmit="return  EvaluaFormulario();"   id="login-form" class="form-inline">
      <div class="userdata">
         <!--Boton-->
         <div align="left"><br><%=dblMontoCredito%>
            <form>

               <label><h3 class="page-header">Seleccione un Monto</h3>
                  <%
        //Consultamos los estados
        String strSql1 = "select MTO_MCREDITO from cat_monto";
        ResultSet rs1 = oConn.runQuery(strSql1, true);
        while (rs1.next()) {
                  %>
                  <label>
                     <input type="radio" name="monto" value="<%=rs1.getDouble("MTO_MCREDITO") %>"> <%=rs1.getDouble("MTO_MCREDITO") %>
                  </label> </br>
                  <%
              }
              rs1.close();
                  %>
                  <%
        //Consultamos los estados
        String strSql2 = "select DMN_NOMBRE from cat_documentacion where CTO_ID = " + intIdCredito;
        ResultSet rs2 = oConn.runQuery(strSql2,true);
        while (rs2.next()) {
                  %>
                  <tr>
                     <td>
                      <%=rs2.getString("DMN_NOMBRE") %>
                     </td>
                     <td>
                      <%=rs2.getString("DMN_NOMBRE") %>
                     </td>
                  </tr>
                  <%
              }
              rs2.close();
                  %>
                  <%
        //Consultamos los estados
        String strSql3 = "select V_VENCIMIENTO from cat_vencimiento where CTO_ID = " + intIdCredito;
        ResultSet rs3 = oConn.runQuery(strSql3,true);
        while (rs3.next()) {
                  %>
                  <tr>
                     <td>
                      <%=rs3.getString("V_VENCIMIENTO") %>
                     </td>
                     <td>
                      <%=rs3.getString("V_VENCIMIENTO") %>
                     </td>
                  </tr>
                  <%
              }
              rs3.close();
                  %>
            </form>

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
                <tr>
                     <td>&nbsp;<input type="checkbox" id="aceptoCondiciones"/></td>
                     <td>&nbsp;<a for="aceptoCondiciones" href="#" target="_blank">Leí y acepto los términos y condiciones.</a></td>
                  </tr>
                  
                <div class="controls">
                    <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
                </div>
            </div>
            </div>
            
         </div>
<script type="text/javascript">

   //Validamos el formulario
   function EvaluaFormulario() {
      if (document.getElementById("aceptoCondiciones").checked == false) {
         alert("Falta aceptar terminos y condiciones");
         document.getElementById("aceptoCondiciones").focus();
         return false;
      } else {
         return true;
      }
      return false;
   }

   /**Manda abrir un reporte*/
   function openFormatComis(strNomForm, strTipo, strHtmlControl, strMaskFolio) {
      var strHtml = "<form action=\"../Formatos\" method=\"post\" target=\"_blank\" id=\"formSend\">";
      strHtml += CreaHidden("NomForm", strNomForm);
      if (strMaskFolio != undefined) {
         strHtml += CreaHidden("MASK_FOLIO", strMaskFolio);
      }
      strHtml += CreaHidden("report", strTipo);
      strHtml += strHtmlControl;
      strHtml += "</form>";
      document.getElementById("formHidden").innerHTML = strHtml;
      document.getElementById("formSend").submit();
   }
   /*Campo Oculto*/
   function CreaHidden(name, value) {
      var strTipo = "hidden";
      return "<input type=\"" + strTipo + "\" name=\"" + name + "\" id=\"" + name + "\" value=\"" + value +
              "\" />";
   }
</script>
<div id="formHidden" style="display:none"></div>
<%      oConn.close();
   }
%>
