/* 
 * Esta libreria contiene las operaciones de la pantalla de consulta de ventas
 */
function  vta_viewncargoprov() {//Funcion necesaria para que pueda cargarse la libreria en automatico
}
var bolAnularVta = false;
var bolSoyMain = false;
var strNomMain = false;
function InitViewNCargoProv() {
   try {
      document.getElementById("btn1").style.display = "none";

   } catch (err) {

   }
   //Validamossi somos el main
   strNomMain = objMap.getNomMain();
   if (strNomMain == "CON_NCARGOPROV") {
      bolSoyMain = true;
   }
   ActivaButtonsNCargoProv(false, false,  !bolSoyMain,false);
   //Obtenemos permisos
   $("#dialogWait").dialog("open");
   $.ajax({
      type: "POST",
      data: "keys=98",
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "Acceso.do",
      success: function (datos) {
         var objsc = datos.getElementsByTagName("Access")[0];
         var lstKeys = objsc.getElementsByTagName("key");
         for (i = 0; i < lstKeys.length; i++) {
            var obj = lstKeys[i];
            if (obj.getAttribute('id') == 98 && obj.getAttribute('enabled') == "true") {
               bolAnularVta = true;
            }
         }
         $("#dialogWait").dialog("close");
      },
      error: function (objeto, quepaso, otroobj) {
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Se encarga de enviar la peticion de consulta de las ventas*/
var strNomFormView = "";
var strKeyView = "";
var strTipoVtaView = "";
var strNomOrderView = "";
/**Ejecuta el filtro para consultar las ventas*/
function ViewNCargoProvDo() {
   //Validamossi somos el main
   bolSoyMain = false;
   strNomMain = objMap.getNomMain();
   if (strNomMain == "CON_NCARGOPROV") {
      bolSoyMain = true;
   }
   var bolPasa = true;

   //Si pasa enviamos la peticion de la consulta
   if (bolPasa) {
      //Inicializamos todos los botones
      ActivaButtonsNCargoProv(false, false,  !bolSoyMain,false);
      //Prefijos dependiendo del tipo de venta
      var strPrefijoMaster = "NCA";
      strNomOrderView = "NCA_FECHA";
      strNomFormView = "VIEWNCARGOPROV";
      strKeyView = "NCA_ID";
      strTipoVtaView = "2";
      ActivaButtonsNCargoProv(bolAnularVta, true,  !bolSoyMain,true);

      //Armamos el filtro
      var strParams = "&" + strPrefijoMaster + "_ANULADA=999";
      strParams += "&" + strPrefijoMaster + "_ESRECU=999";
      var strFecha1 = document.getElementById("VIEW_FECHA1").value;
      var strFecha2 = document.getElementById("VIEW_FECHA2").value;
      var strId = document.getElementById("VIEW_ID").value;
      //Si seleccionaron el ID filtramos por el
      if (strId != "0" && strId != "") {
         strParams += "&" + strKeyView + "=" + strId + "";
      } else {
         if (strFecha1 != "" && strFecha2 != "") {
            strParams += "&" + strPrefijoMaster + "_FECHA1=" + strFecha1 + "&" + strPrefijoMaster + "_FECHA2=" + strFecha2 + "";
         }
         if (document.getElementById("VIEW_SUCURSAL").value != "0") {
            strParams += "&SC_ID=" + document.getElementById("VIEW_SUCURSAL").value + "";
         }
         if (document.getElementById("VIEW_CLIENTE").value != "0") {
            strParams += "&PV_ID=" + document.getElementById("VIEW_CLIENTE").value + "";
         }
         if (document.getElementById("VIEW_TIPO").value == "1") {
            if (document.getElementById("VIEW_FOLIO").value != "") {
               strParams += "&" + strPrefijoMaster + "_FOLIO_C=" + document.getElementById("VIEW_FOLIO").value + "";
            }

         } else {
            if (document.getElementById("VIEW_FOLIO").value != "") {
               strParams += "&" + strPrefijoMaster + "_FOLIO=" + document.getElementById("VIEW_FOLIO").value + "";
            }
         }
         if (document.getElementById("VIEW_EMP").value != "0") {
            strParams += "&EMP_ID=" + document.getElementById("VIEW_EMP").value + "";
         }
         if (document.getElementById("VIEW_MONTO") != null) {
            if (document.getElementById("VIEW_MONTO").value != "0") {
               strParams += "&" + strPrefijoMaster + "_TOTAL=" + document.getElementById("VIEW_MONTO").value + "";
            }
         }
      }
      //Hacemos trigger en el grid
      var grid = jQuery("#VIEW_GRID1");
      grid.setGridParam({
         url: "CIP_TablaOp.jsp?ID=5&opnOpt=" + strNomFormView + "&_search=true" + strParams
      });
      grid.setGridParam({
         sortname: strNomOrderView
      }).trigger('reloadGrid');

   }
}
/**Imprime el documento seleccionado*/
function VtaViewNCargoProvPrint() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      Abrir_Link("JasperReport?REP_ID=90&boton_1=PDF&doc_folio1="
              + "&doc_folio2="
              + "&doc_id=" + lstRow.NCA_ID, '_reporte', 500, 600, 0, 0);
   }
}
/**pregunta si queremos anular la operacion seleccionada*/
function VtaViewNCargoProvAnul() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null && bolAnularVta) {
      document.getElementById("SioNO_inside").innerHTML = "";
      $("#SioNO").dialog("open");
      $("#SioNO").dialog('option', 'title', lstMsg[46]);
      document.getElementById("btnSI").onclick = function () {
         $("#SioNO").dialog("close");
         VtaViewNCargoProvAnulDo()
      };
      document.getElementById("btnNO").onclick = function () {
         $("#SioNO").dialog("close")
      };
   }
}
/**Anula el documento seleccionado*/
function VtaViewNCargoProvAnulDo() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      $("#dialogWait").dialog("open");
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      //Hacemos la peticion por POST

      //Es la cancelacion de una factura de tickets
      $.ajax({
         type: "POST",
         data: encodeURI("idAnul=" + lstRow.NCA_ID),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "NotasCargoMovProv.do?id=2",
         success: function (dato) {
            dato = trim(dato);
            if (dato != "OK") {
               alert(dato);
            }
            grid.setGridParam({
               sortname: strNomOrderView
            }).trigger('reloadGrid');
            $("#dialogWait").dialog("close");
         },
         error: function (objeto, quepaso, otroobj) {
            alert(":NCargoAnul:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });

   }
}

/**
 *Reseteamos el grid
 **/
function resetGridViewNCargoProv() {
   var grid = jQuery("#VIEW_GRID1");
   grid.clearGridData();
}
/**
 *Nos salimos de la ventana de consulta
 **/
function VtaViewNCargoProvSalir() {
   strNomMain = objMap.getNomMain();
   if (strNomMain != "VTAS_VIEW") {
      $("#dialogView").dialog("close");
   }
}
/**
 *Nos Muestra el XML para que lo podamos imprimir
 **/
function VtaViewNCargoProvXML() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      openXMLNCargoProv(lstRow.NCA_ID);
   }

}

/**
 *Se encarga de activar o inactivar botones de acuerdo al tipo de documento
 **/
function ActivaButtonsNCargoProv(bolAnular, bolPrint, 
        bolExit,bolXML) {
   //vv_btnXML
   if (bolXML) {
      document.getElementById("vnc_btnXML").style.display = "block";
   } else {
      document.getElementById("vnc_btnXML").style.display = "none";
   }
   //vv_btnCancel
   if (bolAnular) {
      document.getElementById("vncp_btnCancel").style.display = "block";
   } else {
      document.getElementById("vncp_btnCancel").style.display = "none";
   }

   //vv_btnPrint
   if (bolPrint) {
      document.getElementById("vncp_btnPrint").style.display = "block";
   } else {
      document.getElementById("vncp_btnPrint").style.display = "none";
   }

   //vv_btnExit
   if (bolExit) {
      document.getElementById("vncp_btnExit").style.display = "block";
   } else {
      document.getElementById("vncp_btnExit").style.display = "none";
   }


}
function OpnDiagCteViewNCargoProv() {
   if (typeof bolUsaOpnCte != "undefined") {
      if (bolUsaOpnCte != null) {
         bolUsaOpnCte = false;
      }
   }
   OpnOpt('PROVEEDOR', 'grid', 'dialogCte', false, false);
}
/**Manda abrir un xml*/
function openXMLNCargoProv(strFacId) {
   var strHtml = "<form action=\"ERP_XML_Download.jsp\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NCA_IDP", strFacId);
   strHtml += "</form>";
   document.getElementById("formHidden").innerHTML = strHtml;
   document.getElementById("formSend").submit();
}
/**Reordenamos en base a la busqueda*/
function _onSortViewNCargoProv(index, iCol, sortorder) {
   var strNomOrden = index;
   var strOpciona = document.getElementById("VIEW_TIPO").value;
   if (strOpciona == "1") {
      if (strNomOrden == "TKT_ID")
         strNomOrden = "FAC_ID";
      if (strNomOrden == "TKT_RAZONSOCIAL")
         strNomOrden = "FAC_RAZONSOCIAL";
      if (strNomOrden == "TKT_FOLIO")
         strNomOrden = "FAC_FOLIO";
      if (strNomOrden == "TKT_FECHA")
         strNomOrden = "FAC_FECHA";
      if (strNomOrden == "TKT_ANULADA")
         strNomOrden = "FAC_ANULADA";
      if (strNomOrden == "TKT_ESRECU")
         strNomOrden = "FAC_ESRECU";
   } else {
      if (strOpciona == "3") {
         if (strNomOrden == "TKT_ID")
            strNomOrden = "PD_ID";
         if (strNomOrden == "TKT_RAZONSOCIAL")
            strNomOrden = "PD_RAZONSOCIAL";
         if (strNomOrden == "TKT_FOLIO")
            strNomOrden = "PD_FOLIO";
         if (strNomOrden == "TKT_FECHA")
            strNomOrden = "PD_FECHA";
         if (strNomOrden == "TKT_ANULADA")
            strNomOrden = "PD_ANULADA";
         if (strNomOrden == "TKT_ESRECU")
            strNomOrden = "PD_ESRECU";
      } else {
         if (strOpciona == "4") {
            if (strNomOrden == "TKT_ID")
               strNomOrden = "COT_ID";
            if (strNomOrden == "TKT_RAZONSOCIAL")
               strNomOrden = "COT_RAZONSOCIAL";
            if (strNomOrden == "TKT_FOLIO")
               strNomOrden = "COT_FOLIO";
            if (strNomOrden == "TKT_FECHA")
               strNomOrden = "COT_FECHA";
            if (strNomOrden == "TKT_ANULADA")
               strNomOrden = "COT_ANULADA";
            if (strNomOrden == "TKT_ESRECU")
               strNomOrden = "COT_ESRECU";
         }
      }
   }
   $('#VIEW_GRID1').setGridParam({
      sortname: strNomOrden
   });
   return 'stop';
}


/**Generar un pedido una cotizacion*/
function CotiPedViewNCargProvo() {
   strNomMain = objMap.getNomMain();
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      if (strNomMain == "VENTAS") {
         if (document.getElementById("VIEW_TIPO").value == "5") {
            getCotizaenVenta(grid.getGridParam("selrow"), "PEDIDO");
         }
      }
   }
}
/**Factura una cotizacion*/
function CotiFactViewNCargoProv() {
   strNomMain = objMap.getNomMain();
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      if (strNomMain == "VENTAS") {
         if (document.getElementById("VIEW_TIPO").value == "5") {
            getCotizaenVenta(grid.getGridParam("selrow"), "FACTURA");
         }
      }
   }
}
/**Remisiona una cotizacion*/
function CotiRemiViewNCargoProv() {
   strNomMain = objMap.getNomMain();
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      if (strNomMain == "VENTAS") {
         if (document.getElementById("VIEW_TIPO").value == "5") {
            getCotizaenVenta(grid.getGridParam("selrow"), "REMISION");
         }
      }
   }
}
/**Modifica el estatus de una cotizacion*/
function CotiEstatusViewNCargoProv() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      //Abrimos pop up para mostrar el estatus por modificar.
      OpnOpt('MOD_EST_COT', '_ed', 'dialog2', false, false, true);
   }
}

/**Inicializa las opciones de la pantalla*/
function CotiEstatusViewNCargoProvInit() {
   var grid = jQuery("#VIEW_GRID1");
   var opDocumento = document.getElementById("VIEW_TIPO").value;
   $("#dialogWait").dialog("open");
   var lstRow = grid.getRowData(grid.getGridParam("selrow"));
   var strCOT_ID = lstRow.TKT_ID;
   var strPOST = "FAC_ID=" + strCOT_ID;
   strPOST += "&Documento=" + opDocumento;
   $.ajax({
      type: "POST",
      data: strPOST,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "ERP_Ventas.jsp?id=28",
      success: function (datos) {
         var objsF = datos.getElementsByTagName("Facturas")[0];
         var lstFac = objsF.getElementsByTagName("Factura");
         $("#dialogWait").dialog("close");

         $("#dialogWait").dialog("open");
         setTimeout(function () {
            for (i = 0; i < lstFac.length; i++) {
               var obj = lstFac[i];
               document.getElementById("estatus_1").value = obj.getAttribute('COE_ID');
            }
            //Mostramos los elementos
            document.getElementById("estatus_1").parentNode.parentNode.style.display = 'block';
            $("#dialogWait").dialog("close");
         }, 1000);

      },
      error: function (objeto, quepaso, otroobj) {
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}

function CotiEstatusViewNCargoProvClose() {
   CotiEstatusViewNCargoProvReset();
}

function CotiEstatusViewNCargoProvReset() {
   //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
   var objSecModiVta = objMap.getScreen("MOD_EST_COT");
   objSecModiVta.bolActivo = false;
   objSecModiVta.bolMain = false;
   objSecModiVta.bolInit = false;
   objSecModiVta.idOperAct = 0;
   document.getElementById("dialog2_inside").innerHTML = "";
   $("#dialog2").dialog('close');
}


function CotiEstatusViewNCargoProvOK() {
   $("#dialogWait").dialog("open");
   var grid = jQuery("#VIEW_GRID1");
   var opDocumento = document.getElementById("VIEW_TIPO").value;
   var lstRow = grid.getRowData(grid.getGridParam("selrow"));
   var strFAC_ID = lstRow.TKT_ID;
   var strCOE_ID = document.getElementById("estatus_1").value;
   var strPOST = "FAC_ID=" + strFAC_ID;
   strPOST += "&Documento=" + opDocumento;
   strPOST += "&COE_ID=" + strCOE_ID;
   $.ajax({
      type: "POST",
      data: strPOST,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "html",
      url: "ERP_Ventas.jsp?id=34",
      success: function (datos) {
         if (datos == "OK")
         {
            alert("Se guardaron correctamente los cambios");
            $("#dialogWait").dialog("close");
            CotiEstatusViewNCargoProvReset();

         }

      },
      error: function (objeto, quepaso, otroobj) {
         alert(":edit estatus:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });

}
function CotiEstatusViewNCargoProvCANCEL() {
   CotiEstatusViewNCargoProvReset();
}
/**Imprie de manera masiva*/
function ImprimeMasivoNCargoProv() {
   Abrir_Link("JasperReport?REP_ID=90&boton_1=PDF"
           + "&doc_folio1=" + document.getElementById("FAC_FOLIO1").value
           + "&doc_folio2=" + document.getElementById("FAC_FOLIO2").value
           + "&sc_id=" + document.getElementById("SC_ID").value
           + "&emp_id=" + document.getElementById("EMP_ID").value
           + "&doc_id=0", '_reporte', 500, 600, 0, 0);
}