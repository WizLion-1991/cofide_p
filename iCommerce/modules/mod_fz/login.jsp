<%-- 
    Document   : login
    Created on : 16-abr-2013, 13:55:12
    Author     : aleph_79
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="Tablas.vta_cliente"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0) {

      //Obtenemos la variable de sesion para cambio de password
      String strEvalPassword1 = Sesiones.gerVarSession(request, "EvalPassword1");
      if (strEvalPassword1 == null) {
         strEvalPassword1 = "0";
      }

      //Evaluamos si tenemos acceso a los modulos
      if (strEvalPassword1.equals("1")) {
%>
<div class="well ">
   <h3 class="page-header">Cambiar contraseña</h3>
   <form action="index.jsp?mod=FZWebModPass" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
      <div class="userdata">
         <div id="form-login-password" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span class="icon-lock tip" title="Passwordo"/>
                     <label for="modlgn-passwdo" class="element-invisible">Password Actual</label>
                  </span>
                  <input id="CONTRASENIA_ANT" type="password" name="passwordo" class="input-small" tabindex="0" maxlength="15" size="22" placeholder="Password Actual"/>
               </div>
            </div>
         </div>
         <div id="form-login-password" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span class="icon-lock tip" title="Password"/>
                     <label for="modlgn-passwd" class="element-invisible">Password</label>
                  </span>
                  <input id="CONTRASENIA_NUEVA" type="password" name="password" class="input-small" tabindex="0" maxlength="15" size="22" placeholder="Nuevo Password"/>
               </div>
            </div>
         </div>
         <div id="form-login-password2" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on">
                     <span class="icon-lock tip" title="Password"/>
                     <label for="modlgn-passwd2" class="element-invisible">Repita el Password</label>
                  </span>
                  <input id="CONFIRMAR_CONTRASENIA" type="password" name="password2" class="input-small" tabindex="0" maxlength="15" size="22" placeholder="Repita su Password"/>
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
                     <label for="confirmar_texto" >&nbsp;</label>                                
                  </span>
                  <input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
               </div>
            </div>
         </div>
         <div id="form-login-submit" class="control-group">
            <div class="controls">
               <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn">Cambiar</button>
            </div>
         </div>
      </div>
   </form>
</div>
<script type="text/javascript">
   var bolEvaluado = false;
   function EvaluaFormulario() {
      //Si no esta evaluado el cambio lo validamos
      if (!bolEvaluado) {
         var ConAnt = document.getElementById("CONTRASENIA_ANT").value;
         var ConNueva = document.getElementById("CONTRASENIA_NUEVA").value;
         var ConfNueva = document.getElementById("CONFIRMAR_CONTRASENIA").value;
         if (ConAnt == "")
         {
            alert("Tienes que escribir tu contraseña anterior");
            return false;
         }
         if (ConNueva == "")
         {
            alert("Tienes que escribir la nueva contraseña");
            return false;
         }
         if (ConfNueva == "")
         {
            alert("Tienes que confirmar la nueva contraseña");
            return false;
         }
         if (ConfNueva == ConAnt)
         {
            alert("La nueva contraseña debe ser diferente a la anterior");
            return false;
         }
         else
         {
            if (ConNueva != "")
            {
               if (ConNueva == ConfNueva)
               {
                  //alert("Hacemos el cambio");
                  var answer = document.getElementById("modlgn-answer").value;
                  var Pass = document.getElementById("CONFIRMAR_CONTRASENIA").value;
                  var strPOST = "&answer=" + answer;
                  strPOST += "&password=" + Pass;
                  strPOST += "&ContAnt=" + ConAnt;
                  //alert(strPOST);
                  $.ajax({
                     type: "POST",
                     data: strPOST,
                     scriptCharset: "utf-8",
                     contentType: "application/x-www-form-urlencoded;charset=utf-8",
                     cache: false,
                     dataType: "html",
                     url: "modules/mod_fz/cambio_contrasena_opciones.jsp?ID=1",
                     success: function (datos)
                     {
                        if (datos.substring(0, 2) == "OK")
                        {
                           alert("Se ha cambiado correctamente.");
                           document.getElementById("CONTRASENIA_ANT").value = "";
                           document.getElementById("CONTRASENIA_NUEVA").value = "";
                           document.getElementById("CONFIRMAR_CONTRASENIA").value = "";
                           document.getElementById("modlgn-answer").value = "";
                           bolEvaluado = true;
                           setTimeout("document.getElementById('login-form').submit();", 500);
                        }
                        else
                        {
                           if (datos.substring(0, 6) == "ERRORC")
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
                     error: function (objeto, quepaso, otroobj)
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
      } else {

      }

      //Enviamos peticion por post para el cambio
      return bolEvaluado;
   }


</script>
<%         } else {
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   Fechas fecha = new Fechas();
   Periodos periodo = new Periodos();
   String strPeriodo = periodo.getPeriodoActualNom(oConn);
   //Obtenemos datos del cliente
   String strNomCicloActual = "";
   double dblPuntosGenerados = 0;
   double dblPuntosDisponibles = 0;
   /*String strSql = "select * from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
   ResultSet rs = oConn.runQuery(strSql, false);
   while (rs.next()) {
      
   }
   rs.close();
   */
   oConn.close();

   String strAccessNewPeople = this.getServletContext().getInitParameter("FZ_Ingresos");
   if (strAccessNewPeople == null) {
      strAccessNewPeople = "SI";
   }

%>
<div class="well ">
   <h3 class="page-header">Oficina Virtual </h3>
   <div id="accordion">
      <h3>&nbsp;Bienvenido <strong><%=varSesiones.getStrUser()%></strong>&nbsp;<br>Mi resumen </h3>
      <div>
         <div class="login-greeting">
            <table class="mlm_down1" cellpadding="3" cellspacin="0">
               <tr><td nowrap>&nbsp;Ciclo Actual:</td><td>&nbsp;<strong><%=strNomCicloActual%></strong></td></tr>
               <tr><td nowrap>&nbsp;Puntos Generados:</td><td>&nbsp;<strong><%=NumberString.FormatearDecimal(dblPuntosGenerados, 2)%></strong></td></tr>
               <tr><td nowrap>&nbsp;Puntos disponibles:</td><td>&nbsp;<strong><%=NumberString.FormatearDecimal(dblPuntosDisponibles, 2)%></strong></td></tr>
               <tr><td nowrap>&nbsp;Periodo:</td><td>&nbsp;<strong><%=strPeriodo%></strong></td></tr>
               <tr><td nowrap>&nbsp;Fecha actual:</td><td>&nbsp;<strong><%=fecha.getFechaActualDDMMAAAADiagonal()%></strong></td></tr>
            </table>
         </div>
      </div>
      <h3>Mi información</h3>
      <div>
         <ul>            
            <li><a href="index.jsp?mod=FZWebEditIngresos" class="aMenu"><img src="images/edit.png" border="0" width="40" height="40" alt="Mis datos" title="Mis datos" />Mis datos</a></li>
            <li><a href="index.jsp?mod=FZWebCambioContrasena" class="aMenu"><img src="images/Cont2.png" border="0" width="40" height="40" alt="Cambio password" title="Cambio password" />Cambio password</a></li>
         </ul>
      </div>
      <h3>Mi organizacion</h3>
      <div>
         <ul>
            <%if (strAccessNewPeople.equals("SI")) {%>
            <li><a href="index.jsp?mod=FZWebIngresos" class="aMenu"><img src="images/ingresos2.png" border="0" width="40" height="40" alt="Ingresos" title="Ingresos" />Ingresos</a></li>
                  <%}%>
            <li><a href="index.jsp?mod=FZWebRed" class="aMenu"><img src="images/red.png" border="0" width="40" height="40" alt="Mi Red" title="Mi Red" />Mi Red</a></li>
         </ul>
      </div>
      <h3>Mis reportes</h3>
      <div>
         <ul>
            <li><a href="index.jsp?mod=FZWebCompensacion" class="aMenu"><img src="images/comisiones.png" border="0" width="40" height="40" alt="Compensacion" title="Compensacion" />Compensaci&oacuten</a></li>
            <li><a href="index.jsp?mod=FZWebVentas" class="aMenu"><img src="images/ventas.png" border="0" width="40" height="40" alt="Ventas" title="Ventas" />Ventas</a></li>
         </ul>
      </div>
      <h3>Mis notificaciones</h3>
      <div>
         <ul>
            <li><a href="index.jsp?mod=FZWebSugerencias" class="aMenu"><img src="images/sugerencias.png" border="0" width="40" height="40" alt="Sugerencias" title="Sugerencias" />Sugerencias</a></li>
         </ul>
      </div>
   </div>
   <form action="index.jsp?mod=FZWebLogOut" method="post" id="login-form" class="form-inline">
      <div class="logout-button">
         <input type="submit" name="Submit" class="btn btn-primary" value="Salir"/>
      </div>
   </form>
</div>
<script type="text/javascript">
   /* $('#menu').circleMenu({
    item_diameter: 40,
    circle_radius: 100,
    direction: 'bottom-right'
    });
    */
   $(function () {
      $("#accordion").accordion();
   });
</script>
<%
      //Termina la parte donde pinta los menus para los clientes
   }

} else {
   //Mostramos login
%>
<div class="well ">
   <h3 class="page-header">Acceso Oficina Virtual</h3>
   <form action="index.jsp?mod=FZWebLogin2" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline">
      <div class="userdata">
         <div id="form-login-username" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on2">
                     <span class="icon-user tip" title="User Name"/>
                     <label for="modlgn-username" class="element-invisible">User Name</label>
                  </span>
                  <input id="modlgn-username" type="text" name="username" class="input-small" tabindex="0" size="18" placeholder="User Name"/>
               </div>
            </div>
         </div>
         <div id="form-login-password" class="control-group">
            <div class="controls">
               <div class="input-prepend input-append">
                  <span class="add-on2">
                     <span class="icon-lock tip" title="Password"/>
                     <label for="modlgn-passwd" class="element-invisible">Password</label>
                  </span>
                  <input id="modlgn-passwd" type="password" name="password" class="input-small" tabindex="0" size="18" placeholder="Password"/>
               </div>
            </div>
         </div>
         <div id="form-login-remember" class="control-group checkbox">
            <label for="modlgn-remember" class="control-label">Recordarme</label>
            <input id="modlgn-remember" type="checkbox" name="remember" class="inputbox" value="yes"/>
         </div>
         <div id="form-login-submit" class="control-group">
            <div class="controls">
               <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn">Ingresar</button>
            </div>
         </div>
         <ul class="unstyled">
            <li>
               <a href="/component/users/?view=remind">¿Olvido sus datos de acceso?</a>
            </li>
         </ul>
      </div>
   </form>
</div>
<script type="text/javascript">

   function EvaluaFormulario() {

      if (document.getElementById("modlgn-username").value == "") {
         alert("Es necesario que capture el nombre de usuario");
         document.getElementById("modlgn-username").focus();
         return false;
      }
      if (document.getElementById("modlgn-passwd").value == "") {
         alert("Es necesario que capture el password");
         document.getElementById("modlgn-passwd").focus();
         return false;
      }
      return true;
   }


</script>
<%         }
%>

