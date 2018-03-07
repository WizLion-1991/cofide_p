<%-- 
   Document   : ecomm
   Created on : 25-abr-2013, 2:01:57
   Author     : aleph_79
--%>

<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Browser
   String browserType = (String) request.getHeader("User-Agent");

   // ############### Inicializamos valores default
   //Instanciamos la fecha
   Fechas fecha = new Fechas();
   //Validamos si tiene un cliente asignado para recuperar la sucursal
   int intCte = varSesiones.getintIdCliente();
   boolean bolAplicaOfertas = true;
   if (intCte == 0) {
      //Obtenemos parametros generales de la pagina a mostrar
      Site webBase = new Site(oConn);
      intCte = webBase.getIntWP_CT_ID();
      bolAplicaOfertas = false;
   }
   //Obtenemos la sucursal del cliente
   double dblTasa1 = 0;
   double dblTasa2 = 0;
   double dblTasa3 = 0;
   int intIdTasa1 = 0;
   int intIdTasa2 = 0;
   int intIdTasa3 = 0;
   int intSImp1_2 = 0;
   int intSImp1_3 = 0;
   int intSImp2_3 = 0;
   int intSC_ID = 0;
   int intSucDefOfertas = 0;
   int intMON_ID = 0;
   int intLPrecios = 0;
   double dblDescuento = 0;
   String strTerminosyCondiciones = "";
   //Obtenemos el nombre de la sucursal default
   String strSql = "select vta_sucursal.SC_ID,SC_CLAVE,SC_NOMBRE,"
           + "SC_TASA1,SC_TASA2,SC_TASA3,SC_SOBRIMP1_2,SC_SOBRIMP1_3,SC_SOBRIMP2_3,SC_DIVISA,"
           + "vta_sucursal.TI_ID,vta_sucursal.TI_ID2,vta_sucursal.TI_ID3,SC_ACTIVA_OFERTA,CT_DESCUENTO,CT_LPRECIOS "
           + ",vta_cliente.MON_ID"
           + " from vta_sucursal,vta_cliente "
           + " where vta_sucursal.SC_ID = vta_cliente.SC_ID"
           + " AND vta_cliente.CT_ID = " + intCte;
   ResultSet rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      dblTasa1 = rs.getDouble("SC_TASA1");
      dblTasa2 = rs.getDouble("SC_TASA2");
      dblTasa3 = rs.getDouble("SC_TASA3");
      intIdTasa1 = rs.getInt("TI_ID");
      intIdTasa2 = rs.getInt("TI_ID2");
      intIdTasa3 = rs.getInt("TI_ID3");
      intSImp1_2 = rs.getInt("SC_SOBRIMP1_2");
      intSImp1_3 = rs.getInt("SC_SOBRIMP1_3");
      intSImp2_3 = rs.getInt("SC_SOBRIMP2_3");
      intSucDefOfertas = rs.getInt("SC_ACTIVA_OFERTA");
      intLPrecios = rs.getInt("CT_LPRECIOS");
      dblDescuento = rs.getDouble("CT_DESCUENTO");
      intSC_ID = rs.getInt("SC_ID");
      intMON_ID = rs.getInt("MON_ID");
      if (!bolAplicaOfertas) {
         intSucDefOfertas = 0;
      }
   }
   rs.close();
   //Lista de estados
   StringBuilder strLstEdo = new StringBuilder();
   strSql = "select * "
           + "from estadospais "
           + " WHERE PA_ID = 1 order by ESP_NOMBRE";
   rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      strLstEdo.append("<option value='" + rs.getString("ESP_NOMBRE") + "'>" + rs.getString("ESP_NOMBRE") + "</option>");
   }
   rs.close();
   //Obtenemos el id del producto FLETE
   int intPrIdFlete = 0;
   strSql = "select PR_ID "
           + "from vta_producto  "
           + " WHERE EMP_ID = 1  AND SC_ID = 1 AND PR_CODIGO= 'FLETE' ";
   rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      intPrIdFlete = rs.getInt("PR_ID");
   }
   rs.close();
   //Recuperamos los terminos y condiciones
   strSql = "select ETC_TEXTO "
           + "from ecomm_terminosycondiciones "
           + " WHERE ETC_TIPO = 2";
   rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      strTerminosyCondiciones = rs.getString("ETC_TEXTO");
   }
   rs.close();
   //Obtenemos la direccion de entrega en caso de ser un cliente logueado
   String strNombre = "";
   String strDir_Nombre = "";
   String strDir_Telefono = "";
   String strDir_Email = "";
   String strDir_Calle = "";
   String strDir_Numero = "";
   String strDir_NumInt = "";
   String strDir_Colonia = "";
   String strDir_Estado = "";
   String strDir_Municipio = "";
   String strDir_Cp = "";
   String strDir_Descripcion = "";
   String strFecha_Ingreso = "";
   String strRazonsocial = "";
   int intDir_Id = 0;

   //Recuperamos los datos del distribuidor a editar
   String strSelectCliente = "select b.CDE_ID,a.CT_NOMBRE,a.CT_RAZONSOCIAL,b.CDE_NOMBRE,b.CDE_TELEFONO1,b.CDE_EMAIL,"
           + "b.CDE_CALLE,b.CDE_NUMERO,b.CDE_NUMINT,b.CDE_COLONIA,b.CDE_ESTADO,b.CDE_MUNICIPIO,"
           + "b.CDE_CP,b.CDE_DESCRIPCION,a.CT_FECHAREG from vta_cliente a left join vta_cliente_dir_entrega b on a.CT_ID = b.CT_ID  where a.CT_ID = " + varSesiones.getIntNoUser();
   rs = oConn.runQuery(strSelectCliente, true);
   boolean bolExistDirEnvio = true;
   while (rs.next()) {
      strNombre = rs.getString("CT_NOMBRE");
      strDir_Nombre = rs.getString("CDE_NOMBRE");
      strDir_Telefono = rs.getString("CDE_TELEFONO1");
      strDir_Email = rs.getString("CDE_EMAIL");
      strDir_Calle = rs.getString("CDE_CALLE");
      strDir_Numero = rs.getString("CDE_NUMERO");
      strDir_NumInt = rs.getString("CDE_NUMINT");
      strDir_Colonia = rs.getString("CDE_COLONIA");
      strDir_Estado = rs.getString("CDE_ESTADO");
      strDir_Municipio = rs.getString("CDE_MUNICIPIO");
      strDir_Cp = rs.getString("CDE_CP");
      strDir_Descripcion = rs.getString("CDE_DESCRIPCION");
      intDir_Id = rs.getInt("CDE_ID");
      if (strDir_Nombre == null) {
         strDir_Nombre = "";
      }
      if (strDir_Telefono == null) {
         strDir_Telefono = "";
      }
      if (strDir_Email == null) {
         strDir_Email = "";
      }
      if (strDir_Calle == null) {
         strDir_Calle = "";
         bolExistDirEnvio = false;
      }
      if (strDir_Numero == null) {
         strDir_Numero = "";
      }
      if (strDir_NumInt == null) {
         strDir_NumInt = "";
      }
      if (strDir_Colonia == null) {
         strDir_Colonia = "";
      }
      if (strDir_Estado == null) {
         strDir_Estado = "";
      }
      if (strDir_Municipio == null) {
         strDir_Municipio = "";
      }
      if (strDir_Cp == null) {
         strDir_Cp = "";
      }
      if (strDir_Descripcion == null) {
         strDir_Descripcion = "";
      }
      strFecha_Ingreso = rs.getString("CT_FECHAREG");
      strRazonsocial = rs.getString("CT_RAZONSOCIAL");
   }
   rs.close();
   //Puntos disponibles
   double dblDisponible = 0;
   String strSaldoDisponible = "SELECT  "
           + "	SUM(mlm_mov_comis.MMC_ABONO - mlm_mov_comis.MMC_CARGO) as TSALDO"
           + " FROM mlm_mov_comis WHERE CT_ID = " + varSesiones.getintIdCliente();
   ResultSet rsCN = oConn.runQuery(strSaldoDisponible, true);
   while (rsCN.next()) {
      dblDisponible = rsCN.getDouble("TSALDO");
   }
   rsCN.close();

   //Obtenemos la feccha y hora actual para que recargue
   DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHH:mm:ss");
   Date date = new Date();
   String strNow = dateFormat.format(date);
%>
<script type="text/javascript" src="../javascript/Combos.js"></script>
<script type="text/javascript" src="../javascript/Cadenas.js"></script>
<script type="text/javascript" src="../javascript/vta_taxes.js"></script>
<script type="text/javascript" src="../javascript/controlDom.js"></script>
<script type="text/javascript" src="modules/mod_epoints/js/ventas.js"></script>
<script type="text/javascript" src="modules/mod_epoints/js/ecomm_mx.js"></script>
<script type="text/javascript" src="modules/mod_epoints/js/ecomm.js?date=<%=strNow%>"></script>
<!--slide 3d -->
<link rel="stylesheet" type="text/css" href="modules/mod_slide/css/demo.css" />
<link rel="stylesheet" type="text/css" href="modules/mod_slide/css/slicebox.css" />
<link rel="stylesheet" type="text/css" href="modules/mod_slide/css/custom.css" />
<!--slide 3d -->
<!--light box -->
<script type="text/javascript" src="modules/mod_epoints/js/jquery.lightbox-0.5.min.js"></script>
<link rel="stylesheet" type="text/css" href="modules/mod_epoints/css/jquery.lightbox-0.5.css" media="screen" />
<!--light box -->
<!--ecommerce -->
<link rel="stylesheet" type="text/css" href="modules/mod_epoints/css/ecomm.css?date=<%=strNow%>" />
<%if (browserType.contains("Safari")) {%>
<link rel="stylesheet" type="text/css" href="modules/mod_epoints/css/ecomm_safari.css?date=<%=strNow%>" />
<%}%>
<%if (browserType.contains("Chrome")) {%>
<link rel="stylesheet" type="text/css" href="modules/mod_epoints/css/ecomm_chrome.css?date=<%=strNow%>" />
<%}%>
<!-- Valores globales -->
<input type="hidden" id="FAC_TOT" value="0" />
<input type="hidden" id="FAC_IMPORTE_IEPS" value="0" />
<input type="hidden" id="FAC_IMPUESTO1" value="0" />
<input type="hidden" id="FAC_IMPUESTO2" value="0" />
<input type="hidden" id="FAC_IMPUESTO3" value="0" />
<input type="hidden" id="FAC_IMPORTE" value="0" />
<input type="hidden" id="FAC_DESCUENTO" value="0" />
<input type="hidden" id="FAC_PUNTOS" value="0" />
<input type="hidden" id="FAC_NEGOCIO" value="0" />
<input type="hidden" id="FAC_IMPORTE_REAL" value="0" />
<input type="hidden" id="FAC_PZAS" value="0" />
<input type="hidden" id="FAC_PUNTOS_REAL" value="0" />
<input type="hidden" id="FAC_NEGOCIO_REAL" value="0" />
<input type="hidden" id="FAC_CREDITOS_REAL" value="0" />
<input type="hidden" id="FAC_IMPUESTO1_REAL" value="0" />
<input type="hidden" id="FAC_IMPUESTO2_REAL" value="0" />
<input type="hidden" id="FAC_IMPUESTO3_REAL" value="0" />
<input type="hidden" id="FAC_RETISR" value="0" />
<input type="hidden" id="FAC_RETIVA" value="0" />
<input type="hidden" id="FAC_NETO" value="0" />
<input type="hidden" id="FAC_NOTASPIE" value="" />
<input type="hidden" id="FAC_REFERENCIA" value="" />
<input type="hidden" id="FAC_CONDPAGO" value="" />
<input type="hidden" id="FAC_METODOPAGO" value="" />
<input type="hidden" id="FAC_NUMCUENTA" value="" />
<input type="hidden" id="FAC_FORMADEPAGO" value="" />
<input type="hidden" id="FAC_NUMPEDI" value="" />
<input type="hidden" id="FAC_FECHAPEDI" value="" />
<input type="hidden" id="FAC_ADUANA" value="" />
<input type="hidden" id="FAC_TIPOCOMP" value="" />
<input type="hidden" id="FAC_MONEDA" value="<%=intMON_ID%>" />
<input type="hidden" id="FAC_FECHA" value="<%=fecha.getFechaActualDDMMAAAADiagonal()%>" />
<input type="hidden" id="FCT_ID" value="<%=intCte%>" />
<input type="hidden" id="SC_ID" value="<%=intSC_ID%>" />
<input type="hidden" id="FAC_LPRECIOS" value="<%=intLPrecios%>" />
<input type="hidden" id="FCT_LPRECIOS" value="<%=intLPrecios%>" />
<input type="hidden" id="PR_ID_FLETE" value="<%=intPrIdFlete%>" />
<input type="hidden" id="DISPONIBLES" value="<%=dblDisponible%>" />
<input type="hidden" id="SALDODISPONIBLES" value="<%=dblDisponible%>" />
<!-- checkout -->
<div id="dialogCheckOut" title="CheckOut">
   <div id="dialogCheckOut_inside">
      <h3>Confirmar Venta</h3>
      <div id="tabs">
         <div id="tabs-1" >
            <h4>Paso 1.- Confirmar Carrito de compras</h4>
            <div id="desglose">

            </div>
            <div>Notas:<br><textarea id="Notas_may" name="Notas_may" cols="30" rows="3" ></textarea> </div>    
            <textarea id="Terminos"><%=strTerminosyCondiciones%></textarea>
            <div>Acepto terminos y condiciones?<input type="checkbox" name="aceptoT" class="Condiciones" id="aceptoT" value="1" ></div>    
            <div><img alt="Captcha"  src="../stickyImg" />Escriba el texto de la imagen:<input type="text" name="answer" id="answer" value="" maxlength="30" size="15" /></div>
            <input type="button" name="step1" value="Continuar" onClick="Step1()" />
         </div>
         <div id="tabs-2" style="display: none">
            <h4>Paso 2.- Direccion de entrega</h4>
            <table border="0">
               <tr>
                  <td>&nbsp;Nombre:</td>
                  <td>&nbsp;<input type="text" id="Nombre" name="Nombre" value="" size="50" maxlength="80"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Email:</td>
                  <td>&nbsp;<input type="text" id="Email" name="Email" value="" size="50" maxlength="30"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td colspan="2">&nbsp;Dirección entrega</td>
               </tr>
               <tr>
                  <td>&nbsp;Calle:</td>
                  <td>&nbsp;<input type="text" name="Calle_ent" id="Calle_ent" value="" size="50" maxlength="80"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero:</td>
                  <td>&nbsp;<input type="text" name="Numero_ent" id="Numero_ent" value="" size="50" maxlength="10"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero Int.:</td>
                  <td>&nbsp;<input type="text" name="NumeroInt_ent" id="NumeroInt_ent" value="" size="50" maxlength="10"></td>
               </tr>
               <tr>
                  <td>&nbsp;Colonia:</td>
                  <td>&nbsp;<input type="text" name="Colonia_ent" id="Colonia_ent" value="" size="50" maxlength="80"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Municipio:</td>
                  <td>&nbsp;<input type="text" name="Municipio_ent" id="Municipio_ent" value="" size="50" maxlength="45"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Estado:</td>
                  <td>&nbsp;<select name="Estado_ent" id="Estado_ent" ><%=strLstEdo%></select><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Codigo Postal:</td>
                  <td>&nbsp;<input type="text" name="cp_ent" id="cp_ent" value="" size="8" maxlength="8"><span class="required">*</span></td>
               </tr>
            </table>
            <input type="button" name="step2" value="Continuar"  onClick="Step2()"/>
            <input type="button" name="stepback2" value="Regresar"  onClick="StepBack2()"/>
         </div>
         <div id="tabs-2a" style="display: none">
            <h4>Paso 2.- Direccion de entrega</h4>
            <table border="0">
               <tr>
                  <td colspan="2">&nbsp;Dirección de entrega actual</td>
               </tr>
               <tr>
                  <td>&nbsp;Calle:</td>
                  <td>&nbsp;<%=strDir_Calle%></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero:</td>
                  <td>&nbsp;<%= strDir_Numero%></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero Int.:</td>
                  <td>&nbsp;<%=strDir_NumInt%></td>
               </tr>
               <tr>
                  <td>&nbsp;Colonia:</td>
                  <td>&nbsp;<%= strDir_Colonia%></td>
               </tr>
               <tr>
                  <td>&nbsp;Municipio:</td>
                  <td>&nbsp;<%=strDir_Municipio%></td>
               </tr>
               <tr>
                  <td>&nbsp;Estado:</td>
                  <td>&nbsp;<%=strDir_Estado%> </td>
               </tr>
               <tr>
                  <td>&nbsp;Código Postal:</td>
                  <td>&nbsp;<%=strDir_Cp%></td>
               </tr>
               <tr>
                  <td colspan="2">&nbsp;Usar otra dirección de entrega&nbsp;
                     <%if (bolExistDirEnvio) {%>
                     <input type="checkbox" name="UsarDirEnt" id="UsarDirEnt"  value="1"/></td>
                     <%} else {%>
               <input type="checkbox" name="UsarDirEnt" id="UsarDirEnt" checked onclick="javascript: return false;" value="1"/></td>
               <%}%>
               </tr>
               <tr>
                  <td>&nbsp;Nombre:</td>
                  <td>&nbsp;<input type="text" id="Nombre_ent_n" name="Nombre_ent_n" value="" size="50" maxlength="80"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Email:</td>
                  <td>&nbsp;<input type="text" id="Email_ent_n" name="Email_ent_n" value="" size="50" maxlength="30"></td>
               </tr>
               <tr>
                  <td>&nbsp;Calle:</td>
                  <td>&nbsp;<input type="text" name="Calle_ent_n" id="Calle_ent_n" value="" size="50" maxlength="80"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero:</td>
                  <td>&nbsp;<input type="text" name="Numero_ent_n" id="Numero_ent_n" value="" size="50" maxlength="10"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero Int.:</td>
                  <td>&nbsp;<input type="text" name="NumeroInt_ent_n" id="NumeroInt_ent_n" value="" size="50" maxlength="10"></td>
               </tr>
               <tr>
                  <td>&nbsp;Colonia:</td>
                  <td>&nbsp;<input type="text" name="Colonia_ent_n" id="Colonia_ent_n" value="" size="50" maxlength="80"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Municipio:</td>
                  <td>&nbsp;<input type="text" name="Municipio_ent_n" id="Municipio_ent_n" value="" size="50" maxlength="45"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Estado:</td>
                  <td>&nbsp;<select name="Estado_ent_n" id="Estado_ent_n" ><%=strLstEdo%></select><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;C&oacute;digo Postal:</td>
                  <td>&nbsp;<input type="text" name="cp_ent_n" id="cp_ent_n" value="" size="8" maxlength="8"><span class="required">*</span></td>
               </tr>
            </table>
            <input type="button" name="step2" value="Continuar"  onClick="Step2a()"/>
            <input type="button" name="stepback2" value="Regresar"  onClick="StepBack2()"/>
         </div>
         <div id="tabs-3" style="display: none">
            <h4>Paso 3.- Datos de facturacion</h4>
            <div>Confirmo que deseo facturar?<input type="checkbox" name="siFacturo" id="siFacturo" value="1" onclick="SiFacturo(this)" ></div>     
            <table border="0">
               <tr>
                  <td>&nbsp;Razon social:</td>
                  <td>&nbsp;<input type="text" name="razonsocial" id="razonsocial" value="" size="50" maxlength="90" readonly><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;RFC:</td>
                  <td>&nbsp;<input type="text" name="rfc" id="rfc" value="" size="50" maxlength="25" readonly><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Calle:</td>
                  <td>&nbsp;<input type="text" name="Calle" id="Calle" value="" size="50" maxlength="80" readonly><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero:</td>
                  <td>&nbsp;<input type="text" name="Numero" id="Numero" value="" size="50" maxlength="10" readonly><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Numero Int.:</td>
                  <td>&nbsp;<input type="text" name="NumeroInt" id="NumeroInt" value="" size="50" maxlength="25" readonly></td>
               </tr>
               <tr>
                  <td>&nbsp;Colonia:</td>
                  <td>&nbsp;<input type="text" name="Colonia" id="Colonia" value="" size="50" maxlength="80" readonly><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Municipio:</td>
                  <td>&nbsp;<input type="text" name="Municipio" id="Municipio" value="" size="50" maxlength="45"><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Estado:</td>
                  <td>&nbsp;<select name="Estado" id="Estado" disabled><%=strLstEdo%></select><span class="required">*</span></td>
               </tr>
               <tr>
                  <td>&nbsp;Codigo Postal:</td>
                  <td>&nbsp;<input type="text" name="cp_fact" id="cp_fact" value="" size="8" maxlength="8" readonly ><span class="required">*</span></td>
               </tr>
            </table>
            <input type="button" name="step3" value="Continuar"  onClick="Step3()"/>
            <input type="button" name="stepback2" value="Regresar"  onClick="StepBack3()"/>
         </div>
         <div id="tabs-4" style="display: none">
            <h4>Paso 4.- Fletes y transportes</h4>
            <div>
               <jsp:include page="ecomm_fletes.jsp" />
            </div>
            <input type="button" name="step4" value="Continuar"  onClick="Step4()"/>
            <input type="button" name="stepback3" value="Regresar"  onClick="StepBack4()"/>
         </div>
         <div id="tabs-5" style="display: none">
            <h4>Paso 5.- Formas de pago</h4>
            <div>
               <jsp:include page="ecomm_formapago.jsp" />
            </div>
            <input type="button" name="step5" value="Guardar"  onClick="Step5()"/>
            <input type="button" name="cancelar" value="Cancelar"  onClick="Cancel()"/>
         </div>

         <div id="tabs-6" style="display: none">
            <h4>Pedido generado</h4>
            <div>Numero de pedido generado:<div id="IdPedidoWeb"></div>
            </div>

            <input type="button" name="step5" value="Cerrar"  onClick="Step6()"/>
         </div>

      </div>

   </div>
</div>
<!--checkout-->
<!--Cuadros de Dialogo-->
<div id="dialogWait" title="Favor de esperar obteniendo informacion">
   <div id="dialogWait_inside" align="center"><img src="../images/ptovta/ajax-loader.gif" border="0" alt=""></div>
</div>
<div id="dialogWait2" title="Favor de esperar">
   <div id="dialogWait2_inside" align="center"><img src="../images/ptovta/ajax-loader.gif" border="0" alt=""></div>
</div>
<div id="dialogWaitProm" title="Ofertas y promociones, favor de esperar">
   <div id="dialogWaitProm_inside" align="center"><img src="../images/ptovta/ajax-loader.gif" border="0" alt=""></div>
</div>
<!--Cuadros de Dialogo-->
<!-- Valores globales -->
<!--ecommerce -->
<!--Seccion ecommerce -->
<!--Mensajes de promociones-->
<div id="PROMOS_LST"></div>
<!--Mensajes de promociones-->
<!--Busqueda-->
<jsp:include page="../../modules/mod_epoints/ecomm_search.jsp" />
<!--Busqueda-->
*Los precios incluyen IVA.
</br>
Puntos disponibles: <%=NumberString.FormatearDecimal(dblDisponible , 2) %> 

<input type="button" class="ecomm_btn1" name="add" id="add" value="Buscar Proveedores" onClick="listaProductos()"> 
                        
<div class="well" id="ecomm_content"></div>
<!--Pie de pagina del ecommerce -->
<jsp:include page="../../modules/mod_epoints/ecomm_foot.jsp" />
<!--Pie de pagina del ecommerce -->
<!--Seccion ecommerce script -->
<script type="text/javascript">

//Datos de la sucursal default
   var logoMoneda = "$";
   var intSucDefa = "<%=varSesiones.getIntSucursalDefault()%>";
   var dblTasaVta1 = "<%=dblTasa1%>";
   var dblTasaVta2 = "<%=dblTasa2%>";
   var dblTasaVta3 = "<%=dblTasa3%>";
   var intIdTasaVta1 = "<%=intIdTasa1%>";
   var intIdTasaVta2 = "<%=intIdTasa2%>";
   var intIdTasaVta3 = "<%=intIdTasa3%>";
   var intSImpVta1_2 = "<%=intSImp1_2%>";
   var intSImpVta1_3 = "<%=intSImp1_3%>";
   var intSImpVta2_3 = "<%=intSImp2_3%>";
   var dblDescuento = "<%=dblDescuento%>";
   var intSucursal = "<%=intSC_ID%>";
   var intCte = "<%=intCte%>";
   var intPreciosconImp = 0;
   //Ofertas y promociones
   var intSucOfertas = <%= intSucDefOfertas == 1 ? true : false%>;
   var strHoyFecha = <%= fecha.getFechaActual()%>;
   var bolPromociones = false;
   var bolCargaPromociones = false;
   var bolDebugPtoVta = false;
   var bolSaveVta = true;
   var bolEcommPromos = true;
   //Ofertas y promociones
   var intTotPzas = 0;
   var lstItems = Array();
   var intTotal = 0;
   var intContaItems = -1;
   var intNumdecimal = 2;
   var strSimboloMoneda = "$";
   var intUnikiD = -1;//Id unico para cada producto
//Evento que ocurre al cargar la pantalla
   $(document).ready(function () {
      $("#dialogWait").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, position: 'top', show: 'slide'});
      $("#dialogWait2").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
      $("#dialogWaitProm").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide'});
      $("#dialogCheckOut").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, position: 'top', show: 'slide', width: "auto"});
      Init();
   });

   /*Realiza la carga inicial de la primer clasificacion y el primer listado*/
   function Init() {
      RefreshClas(document.getElementById("clas1"), 0);
      _EvalPromociones();
   }
</script>
<script type="text/javascript" src="../javascript/vta_esmx.js"></script>
<div id="formHidden" style="display:none"></div>
<%
//Cerramos conexion
   oConn.close();
%>
