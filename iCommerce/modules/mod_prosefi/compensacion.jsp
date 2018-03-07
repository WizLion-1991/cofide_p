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
   <h3 class="page-header">Cr&eacute;dito</h3>
   <form action="index.jsp?mod=comi_view" method="post"   id="login-form" class="form-inline">
      <div class="userdata">
<!--Boton-->
  <div align="left"><br>
      <form>
   
        <label><h3 class="page-header">Seleccione un Monto</h3>
        <label>
            <input type="radio" name="color" value="azul"> 2000.00
        </label> </br>
        <label>
            <input type="radio" name="color" value="negro"> 4000.00
        </label> </br>
        <label>
            <input type="radio" name="color" value="amarillo"> 5000.00
        </label> </br>
        <label>
            <input type="radio" name="color" value="amarillo"> 9000.00
        </label> </br>   
        <label>
             <input type="radio" name="color" value="amarillo"> 10000.00
        </label> </br>
        <label>
             <input type="radio" name="color" value="amarillo"> 14000.00
        </label> </br>
        <label>
             <input type="radio" name="color" value="amarillo"> 16000.00
        </label> </br>
         <label>
             <input type="radio" name="color" value="amarillo"> 30000.00
        </label> </br>
         <label>
             <input type="radio" name="color" value="amarillo"> 40000.00
        </label> </br>
         <label>
            <input type="radio" name="color" value="amarillo"> 50000.00
        </label> </br>
         <label>
             <input type="radio" name="color" value="amarillo"> 60000.00
        </label> </br>
         <label>
            <input type="radio" name="color" value="amarillo"> 70000.00
        </label> </br>
         <label>
            <input type="radio" name="color" value="amarillo"> 80000.00
        </label> </br>
         <label>
            <input type="radio" name="color" value="amarillo"> 90000.00
        </label> </br>
         <label>
            <input type="radio" name="color" value="amarillo"> 100000.00
        </label> </br> </br>
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
