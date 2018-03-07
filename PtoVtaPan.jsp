<%-- 
    Document   : PtoVtaPan
    Created on : 07-oct-2013, 18:41:14
    Author     : ZeusGalindo
--%>
<%@page import="ERP.Turnos"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      //Evaluamos el turno
      Turnos turno = new Turnos();
      turno.setoConn(oConn);
      int intTurno = turno.getTurn(1);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Pan y Pasteles</title>
      <style type="text/css">
         .big_sel {
            -moz-box-shadow:inset 0px 1px 5px 0px #fce2c1;
            -webkit-box-shadow:inset 0px 1px 5px 0px #fce2c1;
            box-shadow:inset 0px 1px 5px 0px #fce2c1;
            background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #ffc477), color-stop(1, #fb9e25) );
            background:-moz-linear-gradient( center top, #ffc477 5%, #fb9e25 100% );
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffc477', endColorstr='#fb9e25');
            background-color:#ffc477;
            -webkit-border-top-left-radius:20px;
            -moz-border-radius-topleft:20px;
            border-top-left-radius:20px;
            -webkit-border-top-right-radius:20px;
            -moz-border-radius-topright:20px;
            border-top-right-radius:20px;
            -webkit-border-bottom-right-radius:20px;
            -moz-border-radius-bottomright:20px;
            border-bottom-right-radius:20px;
            -webkit-border-bottom-left-radius:20px;
            -moz-border-radius-bottomleft:20px;
            border-bottom-left-radius:20px;
            text-indent:0;
            border:1px solid #eeb44f;
            display:inline-block;
            color:#000;
            font-family:Arial;
            font-size:12px;
            font-weight:bold;
            font-style:normal;
            height:50px;
            line-height:50px;
            width:100px;
            text-decoration:none;
            text-align:center;
            text-shadow:1px 1px 0px #cc9f52;
         }
         .big_sel:hover {
            background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #fb9e25), color-stop(1, #ffc477) );
            background:-moz-linear-gradient( center top, #fb9e25 5%, #ffc477 100% );
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#fb9e25', endColorstr='#ffc477');
            background-color:#fb9e25;
         }.big_sel:active {
            position:relative;
            top:1px;
         }

         .cmd_btn {
            -moz-box-shadow:inset 0px 1px 5px 0px #d9fbbe;
            -webkit-box-shadow:inset 0px 1px 5px 0px #d9fbbe;
            box-shadow:inset 0px 1px 5px 0px #d9fbbe;
            background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #b8e356), color-stop(1, #a5cc52) );
            background:-moz-linear-gradient( center top, #b8e356 5%, #a5cc52 100% );
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#b8e356', endColorstr='#a5cc52');
            background-color:#b8e356;
            -webkit-border-top-left-radius:37px;
            -moz-border-radius-topleft:37px;
            border-top-left-radius:37px;
            -webkit-border-top-right-radius:0px;
            -moz-border-radius-topright:0px;
            border-top-right-radius:0px;
            -webkit-border-bottom-right-radius:37px;
            -moz-border-radius-bottomright:37px;
            border-bottom-right-radius:37px;
            -webkit-border-bottom-left-radius:0px;
            -moz-border-radius-bottomleft:0px;
            border-bottom-left-radius:0px;
            text-indent:0;
            border:1px solid #83c41a;
            display:inline-block;
            color:#ffffff;
            font-family:Arial;
            font-size:15px;
            font-weight:bold;
            font-style:normal;
            height:37px;
            line-height:37px;
            width:131px;
            text-decoration:none;
            text-align:center;
            text-shadow:1px 1px 0px #86ae47;
         }
         .cmd_btn:hover {
            background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #a5cc52), color-stop(1, #b8e356) );
            background:-moz-linear-gradient( center top, #a5cc52 5%, #b8e356 100% );
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#a5cc52', endColorstr='#b8e356');
            background-color:#a5cc52;
         }.cmd_btn:active {
            position:relative;
            top:1px;
         }
         .right
         {
            position:absolute;
            right:0px;
            width:300px;
            background-color:#b0e0e6;
         }

         .title1_cmd {
            font-size: 36px;
            line-height: 40px;
         }
         #head_cmd{
            color: black;
         }
         #comand_button{
            color: black;
         }
         #extras{
            color: black;
         }
         #partidas{
            color: black;
         }
         .subtitle5{
            font-style: italic;
            color: red;
            font-size: small;
         }
         #Cantidad{
            font-size:large;
         }
         #Descuento{
            font-size:large;
         }
      </style>
      <link href="css/main_slide.css" rel="stylesheet" type="text/css" />
      <script type="text/javascript">
         function sumaTotales()
         {
            var x = document.getElementById("Total1");
            x.value = parseFloat(x.value) + 1;
            var x1 = document.getElementById("Total2");
            x1.value = parseFloat(x1.value) + 1;
         }
      </script>
   </head>
   <body>
   <center>
      <div>
         <div id="head_cmd">
            <div class="title1_cmd">PASTELERIA DEL ANGEL</div>
            <button id="cmd_btn1" name="cmd_btn1" onclick="NewVta()" class="cmd_btn">Nuevo</button>
            <button id="cmd_btn2" name="cmd_btn2" onclick="SavePtoVta()" class="cmd_btn">Guardar</button>
            <button id="cmd_btn3" name="cmd_btn3" onClick="Cancelar()" class="cmd_btn">Cancelar</button>
            <button id="cmd_btn4" name="cmd_btn4" onClick="salirPtoVta()" class="cmd_btn">Salir</button>
            <div >
               <table border="0">
                  <tr><td colspan="2" align="center">TOTALES:</td></tr>
                  <tr><td>POR COBRAR:$</td><td><input type="text" id="Total1" value="0" readonly /></td></tr>
                  <tr><td>PIEZAS:</td><td><input type="text" id="Total2" value="0" readonly /></td></tr>
                  <tr><td>TURNO:</td><td><input type="text" id="Turno" value="<%=intTurno%>"  readonly width="5" size="5" /></td></tr>
               </table>
            </div>
         </div>

         <div id="comand_button">


         </div>
         <div id="extras">
            <button id="cmd_btnplus" name="cmd_btnplus" onClick="plusCantPza()" class="cmd_btn">+ pza</button>
            <button id="cmd_btnplus" name="cmd_btnplus" onClick="plusCant()" class="cmd_btn">+</button>
            <input type="text" value="1" id="Cantidad"  />
            <button id="cmd_btnminus" name="cmd_btnminus" onClick="minusCant()" class="cmd_btn">-</button>
            <button id="cmd_btnminus" name="cmd_btnminus" onClick="minusCantPza()" class="cmd_btn">- pza</button>
            <br><span class="subtitle5">Introduzca la cantidad</span><br>
            
            <button id="cmd_btnplus2" name="cmd_btnplus2" onClick="plusDesc()" class="cmd_btn">+</button>
            <input type="text" value="0.0" id="Descuento"  />
            <button id="cmd_btnminus2" name="cmd_btnminus2" onClick="minusDesc()"  class="cmd_btn">-</button>
            <br><span class="subtitle5">Introduzca el porcentaje de descuento</span>
         </div>
      </div>
      <div id="partidas">
         Listado de items comprados
         <table id="list_deta" class="scroll" ></table>
         <button id="cmd_btnborraitem" name="cmd_btnborraitem" onClick="BorrarItem()"  class="cmd_btn">Borrar item</button>
      </div>
      <div class="slides">
         <ul> <!-- slides -->
            <li><img src="images/slides/cook1.jpg" alt="image01" />
               <div>Pastel #1</div>
            </li>
            <li><img src="images/slides/cook2.jpg" alt="image02" />
               <div>Pastel #2</div>
            </li>
            <li><img src="images/slides/cook3.jpg" alt="image03" />
               <div>Pastel #3</div>
            </li>
            <li><img src="images/slides/cook4.jpg" alt="image04" />
               <div>Pastel #4</div>
            </li>
            <li><img src="images/slides/cook5.jpg" alt="image04" />
               <div>Pastel #5</div>
            </li>
         </ul>
      </div>
   </center>
</body>
</html>

<%
   }
   oConn.close();
%>
