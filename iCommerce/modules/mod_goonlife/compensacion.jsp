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

%>
<div class="well ">
   <h3 class="page-header">Comisiones</h3>
   <form action="index.jsp?mod=comi_view" method="post"   id="login-form" class="form-inline">
      <div class="userdata">
         <!--Periodo-->
         <div id="form-new-periodo" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span title="Periodo"/>
                     <label for="modlgn-periodo" >Periodo:</label>
                  </span>
                  <select id="modlgn-periodo" name="periodo" class="combo1"  placeholder="Periodo">
                     <option value="0">Seleccione</option>
                     <%
                        //Consultamos los periodos
                        String strSql = "select * from mlm_periodos order by MPE_ABRV";
                        ResultSet rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                     %><option value="<%=rs.getString("MPE_ID")%>"><%=rs.getString("MPE_NOMBRE")%></option><%
                        }
                        rs.close();
                     %>
                  </select>
                  <span class="required">*</span>
               </div>
            </div>
         </div>

         <!--Boton-->
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <button type="button" tabindex="0" name="Submit" class="btn btn-primary btn" onClick="EvaluaFormulario()" >Imprimir</button>
            </div>
         </div>
      </div>
   </form>

</div>
<script type="text/javascript">
                  //Validamos el formulario
                  function EvaluaFormulario() {
                     if (document.getElementById("modlgn-periodo").value == "0") {
                        alert("Es necesario que capture el periodo");
                        document.getElementById("modlgn-periodo").focus();
                        return false;
                     }
                     var strHtml = CreaHidden("MPE_ID", document.getElementById("modlgn-periodo").value);
                     strHtml += CreaHidden("CT_ID", <%=varSesiones.getintIdCliente()%>);
                     openFormatComis("COM_DETA", "PDF", strHtml);
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
<%
      oConn.close();
   }
%>
