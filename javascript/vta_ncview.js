/*
 * Esta libreria contiene las operaciones de la pantalla de consulta de ventas
 */
function vta_ncview() {//Funcion necesaria para que pueda cargarse la libreria en automatico
}
var bolAnularVta = false;
var bolSoyMain = false;
var strNomMain = false;
function InitViewVNC() {
   try {
      document.getElementById("btn1").style.display = "none";

   } catch (err) {

   }
   //Validamossi somos el main
   strNomMain = objMap.getNomMain();
   if (strNomMain == "NC_VIEW") {
      bolSoyMain = true;
   }
   ActivaButtonsNC(false, false, false, !bolSoyMain);
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
      success: function(datos) {
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
      error: function(objeto, quepaso, otroobj) {
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Se encarga de enviar la peticion de consulta de las ventas*/
var strNomFormView = "";
var strKeyView = "";
var strNomFormatPrint = "";
var strTipoVtaView = "";
var strNomOrderView = "";
/**Ejecuta el filtro para consultar las ventas*/
function ViewDoNC() {
   //Validamossi somos el main
   bolSoyMain = false;
   strNomMain = objMap.getNomMain();
   if (strNomMain == "NC_VIEW") {
      bolSoyMain = true;
   }
   //Inicializamos todos los botones
   ActivaButtonsNC(bolAnularVta, true, true, !bolSoyMain);
   //Prefijos dependiendo del tipo de venta
   var strPrefijoMaster = "NC";
   strNomOrderView = "NC_ID";
   strNomFormView = "NCVIEW_PRI";
   strKeyView = "NC_ID";
   strNomFormatPrint = "NCREDITO";
   strTipoVtaView = "2";
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
         strParams += "&CT_ID=" + document.getElementById("VIEW_CLIENTE").value + "";
      }
      if (document.getElementById("VIEW_FOLIO").value != "") {
         strParams += "&" + strPrefijoMaster + "_FOLIO=" + document.getElementById("VIEW_FOLIO").value + "";
      }
      if (document.getElementById("VIEW_EMP").value != "0") {
         strParams += "&EMP_ID=" + document.getElementById("VIEW_EMP").value + "";
      }
   }
   //Hacemos trigger en el grid
   var grid = jQuery("#VIEW_GRIDNC1");
   grid.setGridParam({
      url: "CIP_TablaOp.jsp?ID=5&opnOpt=" + strNomFormView + "&_search=true" + strParams
   });
   grid.setGridParam({
      sortname: strNomOrderView
   }).trigger('reloadGrid');
}
//Limpia el campo antes de validarlo
function ValidaCleanNC(strNomField) {
   var objDivErr = document.getElementById("err_" + strNomField);
   if (objDivErr != null) {
      objDivErr.innerHTML = "";
      objDivErr.setAttribute("class", "");
      objDivErr.setAttribute("className", "");
   }
}
//Muestra el error de la validacion
function ValidaShowNC(strNomField, strMsg) {
   var objDivErr = document.getElementById("err_" + strNomField);
   objDivErr.setAttribute("class", "");
   objDivErr.setAttribute("class", "inError");
   objDivErr.setAttribute("className", "inError");
   objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsg;
}
/**Imprime el documento seleccionado*/
function VtaViewPrintNC() {
   var grid = jQuery("#VIEW_GRIDNC1");
   if (grid.getGridParam("selrow") != null) {
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      if (intImprimeTicket == 1) {
         ImprimeconFolioNCView(lstRow.NC_ID,strNomFormatPrint,6);
      } else {
         var strHtml = CreaHidden("NC_ID", lstRow.NC_ID);
         openWhereverFormat("ERP_SendNC?id=" + lstRow.NC_ID, strNomFormatPrint, "PDF", strHtml);
      }
   }
}
/**pregunta si queremos anular la operacion seleccionada*/
function VtaViewAnulNC() {
   var grid = jQuery("#VIEW_GRIDNC1");
   if (grid.getGridParam("selrow") != null && bolAnularVta) {
      document.getElementById("SioNO_inside").innerHTML = "";
      $("#SioNO").dialog("open");
      $("#SioNO").dialog('option', 'title', lstMsg[46]);
      document.getElementById("btnSI").onclick = function() {
         $("#SioNO").dialog("close");
         VtaViewAnulDoNC()
      };
      document.getElementById("btnNO").onclick = function() {
         $("#SioNO").dialog("close")
      };
   }
}
/**Anula el documento seleccionado*/
function VtaViewAnulDoNC() {
   var grid = jQuery("#VIEW_GRIDNC1");
   if (grid.getGridParam("selrow") != null) {
      $("#dialogWait").dialog("open");
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      //Es la cancelacion de una factura de tickets
      $.ajax({
         type: "POST",
         data: encodeURI("idAnul=" + lstRow.NC_ID),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "NCMov.do?id=2",
         success: function(dato) {
            dato = trim(dato);
            if (dato != "OK") {
               alert(dato);
            }
            grid.setGridParam({
               sortname: strNomOrderView
            }).trigger('reloadGrid');
            $("#dialogWait").dialog("close");
         },
         error: function(objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
}
/**
 *Reseteamos el grid
 **/
function resetGridViewNC() {
   var grid = jQuery("#VIEW_GRIDNC1");
   grid.clearGridData();
}
/**
 *Nos salimos de la ventana de consulta
 **/
function VtaViewSalirNC() {
   strNomMain = objMap.getNomMain();
   if (strNomMain != "VTAS_VIEW") {
      $("#dialogView").dialog("close");
   }
}
/**
 *Nos Muestra el XML para que lo podamos imprimir
 **/
function VtaViewXMLNC() {
   var grid = jQuery("#VIEW_GRIDNC1");
   if (grid.getGridParam("selrow") != null) {
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      openXMLNC(lstRow.NC_ID);
   }

}
/**Carga un pedido recurrente*/
function VtaViewEditNC() {
   strNomMain = objMap.getNomMain();
   var grid = jQuery("#VIEW_GRIDNC1");
   var idSel = grid.getGridParam("selrow");
   if (idSel != null) {
      if (document.getElementById("VIEW_TIPO").value == "3") {
         var lstRow = grid.getRowData(idSel);
         if (lstRow.NC_ANULADA == "NO") {
            if (strNomMain == "VENTAS") {
               getPedidoenVenta(idSel, "PEDIDO");
            } else {
               if (strNomMain == "SERVICIOS") {
                  //Editamos servicio
                  getPedidoenVentaSrv(idSel, "PEDIDO");
               }
            }
         }
      }
   }
}
/**
 *Se encarga de activar o inactivar botones de acuerdo al tipo de documento
 **/
function ActivaButtonsNC(bolAnular, bolPrint, bolXML, bolExit) {

   //vv_btnCancel
   if (bolAnular) {
      document.getElementById("vv_btnCancel").style.display = "block";
   } else {
      document.getElementById("vv_btnCancel").style.display = "none";
   }
   //vv_btnPrint
   if (bolPrint) {
      document.getElementById("vv_btnPrint").style.display = "block";
   } else {
      document.getElementById("vv_btnPrint").style.display = "none";
   }
   //vv_btnXML
   if (bolXML) {
      document.getElementById("vv_btnXML").style.display = "block";
   } else {
      document.getElementById("vv_btnXML").style.display = "none";
   }
   //vv_btnExit
   if (bolExit) {
      document.getElementById("vv_btnExit").style.display = "block";
   } else {
      document.getElementById("vv_btnExit").style.display = "none";
   }

}
function OpnDiagCte() {
   OpnOpt('CLIENTES', 'grid', 'dialogCte', false, false);
}
/**Manda abrir un xml*/
function openXMLNC(strNCId) {
   var strHtml = "<form action=\"ERP_XML_Download.jsp\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NC_ID", strNCId);
   strHtml += "</form>";
   document.getElementById("formHidden").innerHTML = strHtml;
   document.getElementById("formSend").submit();
}

/**Imprime el ticket directamente a la impresora*/
function ImprimeconFolioNCView(strKey, strNomFormat, intOpt) {
   strNomFormat += "1";
   $.ajax({
      type: "POST",
      data: "ID=" + strKey + "&NOM_FORMATO=" + strNomFormat,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "html",
      url: "ERP_Varios.jsp?id=" + intOpt,
      success: function(datos) {

         var miapplet = document.getElementById("PrintTickets");
         miapplet.DoImpresion(datos,
                 strCodEscape, strImpresora);
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":ImprimeFolio:" + objeto + " " + quepaso + " " + otroobj);
      }
   });

}