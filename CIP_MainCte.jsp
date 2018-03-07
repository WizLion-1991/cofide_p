<%-- 
    Document   : CIP_MainCte
    Created on : 30/09/2010, 03:23:35 AM
    Author     : zeus
--%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Utilerias.Fechas" %>
<%@ page import="comSIWeb.Operaciones.CIP_Menu" %>
<%@ page import="java.util.List" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="Tablas.cuenta_contratada" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
      /*Atributos generales de la pagina*/
      atrJSP.atrJSP(request, response, true, false);
      /*Obtenemos las variables de sesion*/
      VariableSession varSesiones = new VariableSession(request);
      varSesiones.getVars();
      Seguridad seg = new Seguridad();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();
      if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
         Fechas fecha = new Fechas();
         String strRazonSocial = "";
         String strNomSucursal = "";
         String strCt_Id = "";
         double dblTasa1 = 0;
         double dblTasa2 = 0;
         double dblTasa3 = 0;
         int intSImp1_2 = 0;
         int intSImp1_3 = 0;
         int intSImp2_3 = 0;
         int intMoneda = 0;
         short intNumCeros = 0;
         //Obtenemos el id de la cuenta
         int intIdCta = 0;
         String strSql = "Select ctam_id FROM usuarios WHERE id_usuarios = '" + varSesiones.getIntNoUser() + "' and UsuarioActivo = 1 ";
         ResultSet rs;
         try {
            //Obtenemos el nombre de la sucursal default
            strSql = "select SC_CLAVE,SC_NOMBRE,CT_ID," +
                    "SC_TASA1,SC_TASA2,SC_TASA3,SC_SOBRIMP1_2,SC_SOBRIMP1_3,SC_SOBRIMP2_3,SC_DIVISA " +
                    "from vta_sucursal where SC_ID = " + varSesiones.getIntSucursalDefault();
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strNomSucursal = rs.getString("SC_CLAVE") + ".-"  + rs.getString("SC_NOMBRE");
               strCt_Id = rs.getString("CT_ID");
               dblTasa1 = rs.getDouble("SC_TASA1");
               dblTasa2 = rs.getDouble("SC_TASA2");
               dblTasa3 = rs.getDouble("SC_TASA3");
               intSImp1_2 = rs.getInt("SC_SOBRIMP1_2");
               intSImp1_3 = rs.getInt("SC_SOBRIMP1_3");
               intSImp2_3 = rs.getInt("SC_SOBRIMP2_3");
               intMoneda = rs.getInt("SC_DIVISA");
            }
            rs.close();

         } catch (SQLException ex) {
            ex.fillInStackTrace();
         }
         /*Obtenemos informacion de la cuenta contratada*/
         cuenta_contratada miCuenta = new cuenta_contratada();
         miCuenta.ObtenDatos(intIdCta, oConn);
         strRazonSocial = miCuenta.getFieldString("nombre");
         int intPreciosconImp = miCuenta.getFieldInt("PRECIOCONIMP");
         /*URL que enviaremos para reinicializar la sesion y que no se nos termine*/
         String strPOST_Check = "a=" + varSesiones.getStrUser() + "&b=" + varSesiones.getIntNoUser()
                 + "&c=" + varSesiones.getIntEsCaptura() + "&d=" + varSesiones.getintIdCliente()
                 + "&e=" + varSesiones.getIntAnioWork() + "&f=" + varSesiones.getNumDigitos();
         /*Objeto para generar el menu*/
         CIP_Menu menu = new CIP_Menu();
         out.clearBuffer();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <meta name="robots" content="noindex, nofollow">
      <title><bean:message key="gen.title"/></title>
      <link rel="stylesheet" type="text/css" href="jqGrid/css/ui-lightness/jquery-ui-1.8.custom.css" />
      <link rel="stylesheet" type="text/css" href="jqGrid/ui.jqgrid.css" />
      <link rel="stylesheet" type="text/css" href="css/jquery.calculator.css" />
      <link rel="stylesheet" type="text/css" href="css/CIP_Main.css" />
      <link rel="stylesheet" type="text/css" href="css/FishEyeMenu.css" />
      <script type="text/javascript" src="jqGrid/jquery-1.4.2.min.js" ></script>
      <script type="text/javascript" src="jqGrid/grid.locale-sp.js" ></script>
      <script type="text/javascript" src="jqGrid/jquery.jqGrid.js" ></script>
      <script type="text/javascript" src="jqGrid/jquery-ui-1.8.custom.min.js" ></script>
      <script type="text/javascript" src="jqGrid/jquery.layout.min.js"></script>
      <script type="text/javascript" src="jqGrid/jquery.calculator.min.js"></script>
      <script type="text/javascript" src="jqGrid/jquery.calculator-es.js"></script>
      <script type="text/javascript" src="javascript/controlDom.js"></script>
      <script type="text/javascript" src="javascript/Cadenas.js"></script>
      <script type="text/javascript" src="javascript/Combos.js"></script>
      <script type="text/javascript" src="javascript/ValidaDato.js"></script>
      <script type="text/javascript" src="javascript/CIP_Config.js"></script>
      <script type="text/javascript" src="javascript/CIP_Main.js"></script>
      <script type="text/javascript" src="javascript/Ventanas.js"></script>
      <script type="text/javascript" src="javascript/jquery.hotkeys-0.7.9.min.js"></script>
      <script type="text/javascript" src="jqGrid/ui.datepicker-es.js" ></script>
      <!--Autocomplete-->
      <script type="text/javascript" src="autocomplete/jquery.bgiframe.min.js"></script>
      <script type="text/javascript" src="autocomplete/jquery.autocomplete.min.js"></script>
      <link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
      <!--Autocomplete-->
      <!--upload-->
      <script type="text/javascript" src="jqGrid/ajaxfileupload.js"></script>
      <!--maskEdit-->
      <script type="text/javascript" src="jqGrid/jquery.maskedinput.js"></script>
      <!--maskEdit-->
      <!--compatibilidad IE-->
      <script type="text/javascript" src="javascript/fixgetElementByIdIE.js"></script>
      <!--Ayuda-->
      <script type="text/javascript" src="javascript/vta_Ayuda.js"></script>
      <!--Ayuda-->
      <script type="text/javascript" src="javascript/FishEyeMenu.js"></script>
      <script type="text/javascript" src="javascript/vta_repo_formato.js"></script>
      <script type="text/javascript" src="javascript/vta_taxes.js"></script>
      <!--Pass-->
      <script type="text/javascript" src="javascript/CIP_PASS.js"></script>
      <style type="text/css">
         .ui-layout-pane-center {
            padding:		0;
            padding:		15px;
            position:		relative; /* REQUIRED to contain the Datepicker Header */;
         }
         /* the 'fix' for the datepicker */
         #ui-datepicker-div { z-index: 5; }
      </style>
      <script type="text/javascript">
         //Lista de mensajes
         var strTitleAltas = "REGISTRO DE NUEVOS ";
         var strTitleBajas = "BORRAR ";
         var strTitleCambios = "MODIFICAR ";
         var strTitleImpresion = "IMPRESION DEL ";
         var strTitleImpresion2 = "Imprime";
         var strTitleImpresion3 = "Excel";
         var strMsgVal7 = "Necesita capturar los datos solicitados en el campo: ";
         var strMsgVal8 = "¿Confirme que desea borrar al ";
         var strMsgVal9 = " con los siguientes datos?";
         //Lista de variables
         var strRazonSocial = "<%=strRazonSocial%>";
         var intNumdecimal = 2;
         var intNumTabs = 0;
         var myLayout; // a var is required because this page utilizes: myLayout.allowOverflow() method
         var strTitlePanel = "SELECCIONAR TODO";
         var bolMuestraDiv = false;
         var intNumDigitos = <%=varSesiones.getNumDigitos() + ""%>;
         var strURLHelp = "http://www.misfinanzas.com.mx/TuAyudaEnVentas";
         var strPOST_Check = "<%=strPOST_Check%>";
         //Datos de la sucursal default
         var strNomSucursal = "<%=strNomSucursal%>";
         var intSucDefa = "<%=varSesiones.getIntSucursalDefault()%>";
         var dblTasa1 = "<%=dblTasa1%>";
         var dblTasa2 = "<%=dblTasa2%>";
         var dblTasa3 = "<%=dblTasa3%>";
         var intSImp1_2 = "<%=intSImp1_2%>";
         var intSImp1_3 = "<%=intSImp1_3%>";
         var intSImp2_3 = "<%=intSImp2_3%>";
         var intMonedaDefa = "<%=intMoneda%>";
         var intCteDefa = "<%=strCt_Id%>";
         var strUserName = "<%=varSesiones.getStrUser()%>";
         var logoMoneda = "<bean:message key="LogoMoneda"/>";
         var intPreciosconImp = <%=intPreciosconImp%>;
         var d = document;//abreviacion para document
         $(document).ready(function () {
            myLayout = $('body').layout({
               // enable showOverflow on west-pane so popups will overlap north pane
               /*west__showOverflowOnHover: true
               ,*/	west__fxSettings_open: { easing: "easeOutBounce", duration: 750 }
            });
            $("#accordion").accordion();
            if(navigator.appName != "Microsoft Internet Explorer"){
               $('#accordion').accordion('option', 'animated', 'bounceslide');
               $('#accordion').accordion('option', 'autoHeight', false);
            }
            $('#Calculator').calculator({showOn: 'both', buttonImageOnly: true,buttonImage: 'images/layout/calculator1.png'});
            $("#dialog").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide'});
            $("#dialog2").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide'});
            $("#SioNO").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide'});
            $("#dialogWait").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide'});
            $("#dialogWait2").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide'});
            $("#dialogCte").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide',position: 'top',width: "auto"});
            $("#dialogVend").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide',position: 'top',width: "auto"});
            $("#dialogProd").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide',position: 'top',width: "auto"});
            $("#dialogPagos").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide',position: 'top',width: "auto"});
            $("#dialogDevo").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide',position: 'top',width: "auto"});
            $("#dialogView").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide',position: 'top',width: "auto"});
            $("#tabsM").tabs({ fx: { opacity: 'toggle' } });
            $("#dialogHelp").dialog({ autoOpen: false ,draggable: true ,modal: true,resizable: true,show: 'slide',position: 'top',width: "auto"});
            setInterval(checker, 90000);
         });
      </script>
      <!--Idioma-->
      <script type="text/javascript" src="javascript/vta_esmx.js"></script>
      <!--Idioma-->
   </head>
   <body oncontextmenu="return false">
      <!-- manually attach allowOverflow method to pane onmouseover="myLayout.allowOverflow('north')" onmouseout="myLayout.resetOverflow(this)"  -->
      <div class="ui-layout-north" >
         <table border=0 width="100%">
            <tr><td rowspan="2" class="ui-Title"><img src="images/ptovta/LogoFacturacion.png" border="0" alt=""></td>
               <td align="center" class="ui-Title2"><%=strRazonSocial%></td>
               <td align="right"><bean:message key="main.message2"/> <%=varSesiones.getStrUser()%></td>
            </tr>
            <tr>
               <td align="center"><img src="images/ptovta/LogoCliente.png" width="100" height="100" border="0" alt="">
               </td>
               <td align="right"><bean:message key="main.message4"/><%=fecha.getFechaActualDDMMAAAADiagonal()%>&nbsp;</td>
            </tr>
         </table>
      </div>
      <!-- allowOverflow auto-attached by option: west__showOverflowOnHover = true -->
      <div class="ui-layout-west">
         <!--Accordion-->
         <div id="accordion">
            <%
            /*Generamos el menu desde la base de datos y dependiendo de los permisos del usuario*/
            String strMenu = menu.DrawMenu(oConn, request, response,varSesiones);
            out.println(strMenu);
            %>
         </div>
         <!--Accordion javascript:OpnOpt('CALC')-->
      </div>

      <div class="ui-layout-south">
         <input type="text" value= "" style="display:none" size="1" id="Calculator">
         <a href="javascript:Abrir_Link(strURLHelp,'_help',500,600,0,0);"><img src="images/layout/help.png" border="0" alt=""></a>
         <div id='test'></div><center>Desarrollado por <a href="http://www.solucionesinformaticasweb.com.mx" target="_new">Soluciones Informaticas Web</a></center>
      </div>

      <div class="ui-layout-east">
         <div id="rightPanel"></div>
      </div>

      <div class="ui-layout-center" >
         <div id="MainPanel">
            <center>

               <!-- Begin Tabs-->
               <div id="tabsM">
                  <ul>
                     <li><a href="#tabs-1"><bean:message key="main.message1"/></a></li>
                  </ul>
                  <div id="tabs-1">
                     <%
                              /*Mostramos las noticias actuales
                              set msg2 = new MsgNoticias
                              response.write msg2.MuestraNoticias(connBD,strFechaActual)*/
                     %>

                  </div>
               </div>
               <!-- End Tabs-->

            </center>
         </div>
      </div>
      <div id="dialog" title="Basic dialog">
         <div id="dialog_inside"></div>
      </div>
      <div id="dialog2" title="Basic dialog2">
         <div id="dialog2_inside"></div>
      </div>
      <div id="dialogWait" title="<bean:message key="main.message44"/>">
         <div id="dialogWait_inside" align="center"><img src="images/ptovta/ajax-loader.gif" border="0" alt=""></div>
      </div>
      <div id="dialogWait2" title="<bean:message key="main.message44"/>">
         <div id="dialogWait2_inside" align="center"><img src="images/ptovta/ajax-loader.gif" border="0" alt=""></div>
      </div>
      <div id="dialogCte" title="Catalogo de Cliente">
         <div id="dialogCte_inside"></div>
      </div>
      <div id="dialogVend" title="Catalogo de Vendedores">
         <div id="dialogVend_inside"></div>
      </div>
      <div id="dialogProd" title="Catalogo de Productos">
         <div id="dialogProd_inside"></div>
      </div>
      <div id="dialogPagos" title="Cobranza">
         <div id="dialogPagos_inside"></div>
      </div>
      <div id="dialogDevo" title="Devolución">
         <div id="dialogDevo_inside"></div>
      </div>
      <div id="dialogView" title="">
         <div id="dialogView_inside"></div>
      </div>
      <div id="SioNO" title="">
         <input type="hidden" id="Operac" value="">
         <div id="SioNO_inside"></div>
         <table>
            <tr>
               <td><input type="button" name="btnSI" id="btnSI" onClick="ConfirmaSI();" value="<bean:message key="main.message48"/>"></td>
               <td><input type="button" name="btnNO" id="btnNO" onClick="ConfirmaNO();" value="<bean:message key="main.message49"/>"></td>
            </tr>
         </table>
      </div>
      <div id="dialogHelp" title="SiWebVentas-Ayuda Rapida">
         <div id="dialogHelp_inside"></div>
      </div>
      <iframe name="iframeUpload" style="display:none"></iframe>
      <div id="formHidden" style="display:none"></div>
   </body>
</html>
<%

      } else {
%>
<bean:message key="main.message46"/>
<jsp:forward page="/frmLogin.jsp"></jsp:forward>
<%         }
      oConn.close();
%>