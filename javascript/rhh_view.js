/* 
 * Este js realiza las operaciones de consulta de nóminas, así como la reimpresión de recibos y cfdi y anulación de los mismos.
 */
function rhh_view() {

}
var bolAnularNomina = false;
var bolSoyMainRHH = false;
var strNomMainRHH = false;
/**Inicializa la pantalla de nóminas*/
function InitViewNomina() {
   //*******************************************************
      document.getElementById("btn1").style.display = "none";

   
//*******************************************************
   //Validamossi somos el main
   strNomMainRHH = objMap.getNomMain();
   if (strNomMainRHH == "NOM_VIEW1") {
      bolSoyMainRHH = true;
   }
   ActivaButtonsNominas(false, false, false, false, !bolSoyMainRHH);
   //Obtenemos permisos
   $("#dialogWait").dialog("open");
   $.ajax({
      type: "POST",
      data: "keys=505",
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
            if (obj.getAttribute('id') == 505 && obj.getAttribute('enabled') == "true") {
               bolAnularNomina = true;
            }
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert("nominas:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}

/**Consulta de nóminas*/
function ViewNominasDo() {
   //Validamossi somos el main
   bolSoyMain = false;
   strNomMain = objMap.getNomMain();
   if (strNomMain == "VTAS_VIEW") {
      bolSoyMain = true;
   }
   //Inicializamos todos los botones
   ActivaButtonsNominas(true, true, true, true, !bolSoyMain);
   //Prefijos dependiendo del tipo de venta
   var strPrefijoMaster = "NOM";
   strNomOrderView = "NOM_ID";
   strNomFormView = "NOM_VIEW2";
   strKeyView = "NOM_ID";
   //Armamos el filtro
   var strParams = "&" + strPrefijoMaster + "_ANULADA=999";
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
      if (document.getElementById("VIEW_EMPLEADO").value != "0") {
         strParams += "&EMP_NUM=" + document.getElementById("VIEW_EMPLEADO").value + "";
      }
      if (document.getElementById("VIEW_FOLIO").value != "") {
         strParams += "&" + strPrefijoMaster + "_FOLIO=" + document.getElementById("VIEW_FOLIO").value + "";
      }
      if (document.getElementById("VIEW_EMP").value != "0") {
         strParams += "&EMP_ID=" + document.getElementById("VIEW_EMP").value + "";
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


/**Abreb pop up de empleados por seleccionar.*/
function OpnDiagEmp1() {
   OpnOpt('rhh_emplea', 'grid', 'dialogCte', false, false);
}

/**
 *Se encarga de activar o inactivar botones de acuerdo al tipo de documento
 **/
function ActivaButtonsNominas(bolPrint1, bolPrint2, bolXML, bolAnular, bolExit) {

   //vv_btnCancel
   if (bolAnular) {
      document.getElementById("vv_btnCancel").style.display = "block";
   } else {
      document.getElementById("vv_btnCancel").style.display = "none";
   }
   //vv_btnPrint1
   if (bolPrint1) {
      document.getElementById("vv_btnPrint1").style.display = "block";
   } else {
      document.getElementById("vv_btnPrint1").style.display = "none";
   }
   //vv_btnPrint2
   if (bolPrint2) {
      document.getElementById("vv_btnPrint2").style.display = "block";
   } else {
      document.getElementById("vv_btnPrint2").style.display = "none";
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

function NomViewPrint1() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      //Abrimos ventana para emitir reporte
      Abrir_Link("JasperReport?REP_ID=46&boton_1=PDF&nom_folio1=" + lstRow.NOM_FOLIO
              + "&nom_folio2=" + lstRow.NOM_FOLIO
              + "&sc_id=" + document.getElementById("VIEW_SUCURSAL").value
              + "&emp_id=" + document.getElementById("VIEW_EMP").value, '_reporte', 500, 600, 0, 0);
   }
}

function NomViewPrint2() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      //Abrimos ventana para emitir reporte
      Abrir_Link("JasperReport?REP_ID=47&boton_1=PDF&nom_folio1=" + lstRow.NOM_FOLIO
              + "&nom_folio2=" + lstRow.NOM_FOLIO
              + "&sc_id=" + document.getElementById("VIEW_SUCURSAL").value
              + "&emp_id=" + document.getElementById("VIEW_EMP").value, '_reporte', 500, 600, 0, 0);
   }
}

function NomViewXML() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      openXMLNomina(lstRow.NOM_ID);
   }
}

function NomViewAnul() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null && bolAnularNomina) {
      document.getElementById("SioNO_inside").innerHTML = "";
      $("#SioNO").dialog("open");
      $("#SioNO").dialog('option', 'title', lstMsg[228]);
      document.getElementById("btnSI").onclick = function() {
         $("#SioNO").dialog("close");
         NomViewAnulDo()
      };
      document.getElementById("btnNO").onclick = function() {
         $("#SioNO").dialog("close")
      };
   }
}

function NomViewAnulDo() {
   var grid = jQuery("#VIEW_GRID1");
   if (grid.getGridParam("selrow") != null) {
      $("#dialogWait").dialog("open");
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      //Hacemos la peticion por POST
      //Es la cancelacion de una factura de tickets
      $.ajax({
         type: "POST",
         data: encodeURI("idAnular=" + lstRow.NOM_ID),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "ERP_Nominas.jsp?id=2",
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
            alert(":nominas view 1:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });

   }
}

function NomViewSalir() {
   strNomMain = objMap.getNomMain();
   if (strNomMain != "NOM_VIEW1") {
      $("#dialogView").dialog("close");
   }
}
/**Manda abrir un xml*/
function openXMLNomina(strNomId) {
   var strHtml = "<form action=\"ERP_XML_Download.jsp\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NOM_ID", strNomId);
   strHtml += "</form>";
   document.getElementById("formHidden").innerHTML = strHtml;
   document.getElementById("formSend").submit();
}