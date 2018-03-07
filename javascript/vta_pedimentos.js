/*
 *Esta libreria realiza todas las operaciones de los pedimentos
 */

var itemIdCXPPedi = 0;
var itemIdCXPPedi2 = 0;
var bolAnadirPediCXP = false;
var bolBorrarPediCXP = false;
var bolFiltroAuto = false;
function vta_pedimentos() {//Funcion necesaria para que pueda cargarse la libreria en automatico
}

function InitPedimentos() {
   bolFiltroAuto = false;
   InitGridCXPagar();
   //Activamos botones
   $.ajax({
      type: "POST",
      data: "keys=172,173",
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
            if (obj.getAttribute('id') == 172 && obj.getAttribute('enabled') == "true") {
               bolAnadirPediCXP = true;
            }
            if (obj.getAttribute('id') == 173 && obj.getAttribute('enabled') == "true") {
               bolBorrarPediCXP = true;
            }
         }
         //Validamos si podemos hacer cambio de fecha
         var strDisplay1 = 'none';
         if (bolAnadirPediCXP)
            strDisplay1 = 'block';
         document.getElementById("bt_Add_CXP1").style.display = strDisplay1;
         document.getElementById("bt_Add_CXP2").style.display = strDisplay1;
         var strDisplay2 = 'none';
         if (bolBorrarPediCXP)
            strDisplay2 = 'block';
         document.getElementById("bt_Drop_CXP1").style.display = strDisplay2;
         document.getElementById("bt_Drop_CXP2").style.display = strDisplay2;
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":pedimentos:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Agrega una cuenta por pagar para los gastos*/
function PediAddCXP1() {
   d.getElementById("Operac").value = "Gastos";
   /*Cerramos La pantalla */
   var objViewCXP1_ = objMap.getScreen("CXP_VIEW");
   if (objViewCXP1_ != null) {
      objViewCXP1_.bolActivo = false;
      objViewCXP1_.bolMain = false;
      objViewCXP1_.bolInit = false;
      objViewCXP1_.idOperAct = 0;
   }
   OpnOpt('CXP_VIEW', '_ed', 'dialogView', false, false, true);
}
/**Borra una cuenta por pagar para los gastos*/
function PediDropCXP1() {
   var grid = jQuery("#GRID1");
   if (grid.getGridParam("selrow") != null) {
      //Mandamos peticion a WS
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      var strPOST = "CXP_ID=" + lstRow.COM_ID;
      //Enviamos la peticion por ajax
      $.ajax({
         type: "POST",
         data: encodeURI(strPOST),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "PediMov.do?id=2",
         success: function(dato) {
            dato = trim(dato);
            if (Left(dato, 2) == "OK") {
               grid.delRowData(grid.getGridParam("selrow"));
            } else {
               alert(dato);
            }
            $("#dialogWait").dialog("close");
         },
         error: function(objeto, quepaso, otroobj) {
            alert(":ODC Save:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
}
/**Agrega una cuenta por pagar de entradas*/
function PediAddCXP2() {
   d.getElementById("Operac").value = "Entradas";
   /*Cerramos La pantalla */
   var objViewCXP1_ = objMap.getScreen("CXP_VIEW");
   if (objViewCXP1_ != null) {
      objViewCXP1_.bolActivo = false;
      objViewCXP1_.bolMain = false;
      objViewCXP1_.bolInit = false;
      objViewCXP1_.idOperAct = 0;
   }
   OpnOpt('CXP_VIEW', '_ed', 'dialogView', false, false, true);
}
/**Borra una cuenta por pagar de entradas*/
function PediDropCXP2() {
   var grid = jQuery("#GRID2");
   if (grid.getGridParam("selrow") != null) {
      //Mandamos peticion a WS
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      var strPOST = "CXP_ID=" + lstRow.MP_ID;
      //Enviamos la peticion por ajax
      $.ajax({
         type: "POST",
         data: encodeURI(strPOST),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "PediMov.do?id=2",
         success: function(dato) {
            dato = trim(dato);
            if (Left(dato, 2) == "OK") {
               grid.delRowData(grid.getGridParam("selrow"));
            } else {
               alert(dato);
            }
            $("#dialogWait").dialog("close");
         },
         error: function(objeto, quepaso, otroobj) {
            alert(":ODC Save:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
}
/**Genera o aplica el prorrateo*/
function ProrrGenera() {
   var a = confirm(lstMsg[94]);
   if (a) {
      $("#dialogWait").dialog("open");
      var strPOST = "PED_ID=" + document.getElementById("PED_ID").value;
      //Enviamos la peticion por ajax
      $.ajax({
         type: "POST",
         data: encodeURI(strPOST),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "PediMov.do?id=4",
         success: function(dato) {
            dato = trim(dato);
            if (Left(dato, 2) == "OK") {
               alert("Prorrateo generado");
            } else {
               alert(dato);
            }
            $("#dialogWait").dialog("close");
         },
         error: function(objeto, quepaso, otroobj) {
            alert(":Pedimento genera:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
}
/**Imprime el prorrateo*/
function ProrrPrint() {
   alert("Imprimimos el prorrateo");
}
/**Cancela el prorrateo*/
function ProrrCancel() {
   var a = confirm(lstMsg[95]);
   if (a) {
      $("#dialogWait").dialog("open");
      var strPOST = "PED_ID=" + document.getElementById("PED_ID").value;
      //Enviamos la peticion por ajax
      $.ajax({
         type: "POST",
         data: encodeURI(strPOST),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "PediMov.do?id=5",
         success: function(dato) {
            dato = trim(dato);
            if (Left(dato, 2) == "OK") {
               alert("Prorrateo cancelado");
            } else {
               alert(dato);
            }
            $("#dialogWait").dialog("close");
         },
         error: function(objeto, quepaso, otroobj) {
            alert(":Pedimento cancela:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
}
/**Simula el prorrateo*/
function ProrrSimula() {
   var strHtml = CreaHidden("PED_ID", document.getElementById("PED_ID").value);
   openReport("PRORRA_SIM", "XLS", strHtml);
}
/**Ocurre al seleccionar una cuenta por pagar*/
function CXPSelPed() {
   var grid = jQuery("#CPX_GRID1");
   var id = grid.getGridParam("selrow");
   if (id != null) {
      var lstRow = grid.getRowData(id);
      var strPOST = "CXP_ID=" + lstRow.CXP_ID;
      strPOST += "&PED_ID=" + document.getElementById("PED_ID").value;
      strPOST += "&PED_COD=" + document.getElementById("PED_COD").value;
      if (d.getElementById("Operac").value == "Gastos") {
         strPOST += "&TIPO=2";
      } else {
         strPOST += "&TIPO=1";
      }
      //Enviamos la peticion por ajax
      $.ajax({
         type: "POST",
         data: encodeURI(strPOST),
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "html",
         url: "PediMov.do?id=1",
         success: function(dato) {
            dato = trim(dato);
            if (Left(dato, 2) == "OK") {
               InitGridCXPagar();
            } else {
               alert(dato);
            }
            $("#dialogView").dialog("close");
            $("#dialogWait").dialog("close");
         },
         error: function(objeto, quepaso, otroobj) {
            alert(":CXP Pedi Save:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
}
/**Carga los grids con las cuentas por pagar*/
function InitGridCXPagar() {
   //Limpiamos los grids
   var grid = jQuery("#GRID1");
   grid.clearGridData();
   var grid2 = jQuery("#GRID2");
   grid2.clearGridData();
   itemIdCXPPedi = 0;
   itemIdCXPPedi2 = 0;
   //Mandamos la peticion por ajax para que nos den el XML de las cuentas por pagars
   $.ajax({
      type: "POST",
      data: "PED_ID=" + document.getElementById("PED_ID").value,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "PediMov.do?id=6",
      success: function(datos) {
         var objCompra = datos.getElementsByTagName("pedimento")[0];
         var lstdeta = objCompra.getElementsByTagName("pedimentos");
         for (i = 0; i < lstdeta.length; i++) {
            var obj = lstdeta[i];
            if (obj.getAttribute('ODC_ID') == 0) {
               var datarow = {
                  COM_ID: obj.getAttribute('CXP_ID'),
                  COM_FOLIO: obj.getAttribute('CXP_FOLIO'),
                  COM_REFERENCIA: obj.getAttribute('CXP_REFERENCIA'),
                  COM_FECHA: obj.getAttribute('CXP_FECHA'),
                  COM_TOTAL: obj.getAttribute('CXP_TOTAL'),
                  COM_PROV: obj.getAttribute('CXP_NOMPROV')
               };
               //Anexamos el registro al GRID
               itemIdCXPPedi++;
               jQuery("#GRID1").addRowData(itemIdCXPPedi, datarow, "last");
            } else {
               var datarow = {
                  MP_ID: obj.getAttribute('CXP_ID'),
                  MP_FOLIO: obj.getAttribute('CXP_FOLIO'),
                  MP_REFERENCIA: obj.getAttribute('CXP_REFERENCIA'),
                  MP_FECHA: obj.getAttribute('CXP_FECHA'),
                  MP_TOTAL: obj.getAttribute('CXP_TOTAL'),
                  MP_PROV: obj.getAttribute('CXP_NOMPROV')
               };
               //Anexamos el registro al GRID
               itemIdCXPPedi2++;
               jQuery("#GRID2").addRowData(itemIdCXPPedi2, datarow, "last");
            }

         }
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":initGridCXP:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Al dar doble click al pedimento*/
function dblClickPedimento(id) {
   var strNomMain = objMap.getNomMain();
   var grid = jQuery("#PEDI_MTO");
   var lstVal = grid.getRowData(id);
   if (strNomMain == "PEDI_MTO") {
      //En caso de catalogo abrimos la opcion de editar
      OpnEdit(document.getElementById("Ed" + strNomMain));
   } else {
      if (strNomMain == "REC_ODC_CX") {
         document.getElementById("COM_PEDIMENTO").value = lstVal.PED_COD;
         ObtenPediODCRecepCXP();
      } else {
         if (strNomMain == "CXPAGAR") {
            document.getElementById("CXP_NUMPEDI").value = lstVal.PED_COD;
            ObtenPediCXP();
         }
      }
   }
   $("#dialogMLM").dialog("close");
}


/**Realiza el filtro automatico*/
function EvalColP() {
   //Evaluamos si estamos en una pantalla detalle
   var strNomMain = objMap.getNomMain();

   var bolOcultaProrrateados = false;
   if (strNomMain == "PEDI_MTO") {
   } else {
      if (strNomMain == "REC_ODC_CX") {
         bolOcultaProrrateados = true;
      } else {
         if (strNomMain == "CXPAGAR") {
            bolOcultaProrrateados = true;
         }
      }
   }
   //Si oculta prorrateo pro default lo hacemos
   if (bolOcultaProrrateados) {
        if (!bolFiltroAuto) {
            setTimeout("ReloadOnlyNotApplied();", 1 * 1000);
        bolFiltroAuto = true;
      }
   }
}
/**Quita los pedimentos ya prorrateados*/
function ReloadOnlyNotApplied() {
   var grid = jQuery("#PEDI_MTO");
   grid.setGridParam({
      url: "CIP_TablaOp.jsp?ID=5&opnOpt=PEDI_MTO&_search=true&PED_APLICADO=0"
              , datatype: "xml",
   }).trigger("reloadGrid");
}

function PediRepocitorio()
{
    var grid = jQuery("#PEDI_MTO");
    if (grid.getGridParam("selrow") != null) {
        OpnOpt('REP_VIEW', '_ed', 'dialogProv', false, false, true);
        setTimeout("UpdatePediDocs();",1500);
    }

}

function PediEliminaArchivo()
{
    var grid = jQuery("#PRE_GRID");
    if (grid.getGridParam("selrow") != null) {
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        var strPRE_ID = lstRow.PRE_ID;
        var strPOST = "PRE_ID="+strPRE_ID;
        //Enviamos la peticion por ajax
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: encodeURI(strPOST),
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "ERP_PedimentoDocu.jsp?id=2",
            success: function(dato) {
                dato = trim(dato);
                if (Left(dato, 2) == "OK") {
                    alert("Se ha quitado exitosamente");
                    UpdatePediDocs();
                } else {
                    alert(dato);
                }
                
                $("#dialogWait").dialog("close");
            },
            error: function(objeto, quepaso, otroobj) {
                alert(":CXP Pedi Doc. Delete:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });
    }
    
}
function PediSubirArchivo()
{
//    alert("Guardando archivo");

    //Validamos
    $("#dialogWait").dialog('open');
    var File = document.getElementById("PRE_FILE");
    var grid = jQuery("#PEDI_MTO");
    var lstRow = grid.getRowData(grid.getGridParam("selrow"));
    var strPOST = "?PED_ID=" + lstRow.PED_ID;
    if (File.value == "") {
        alert("Requiere seleccionar un archivo");
        File.focus();
        $("#dialogWait").dialog('close');
    } else {
        if (Right(File.value.toUpperCase(), 3) == "PDF") {
            $.ajaxFileUpload({
                url: 'ERP_UPFILEPedimento.jsp' + strPOST,
                secureuri: false,
                fileElementId: "PRE_FILE",
                dataType: 'json',
                success: function(data, status)
                {
                    if (typeof(data.error) != 'undefined') {
                        if (data.error != '') {
                            alert(data.error);
                        } else {
                            alert("Archivo guardado Correctamente!");
                        }
                    } else {
                        alert("Archivo guardado Correctamente!");
                    }
                    $("#dialogWait").dialog('close');                   
                    UpdatePediDocs();

                },
                error: function(data, status, e) {
                    alert(e);
                    $("#dialogWait").dialog('close');

                }
            }
            );
        } else {
            alert("Se aceptan archivos con extensi��n pdf");
            $("#dialogWait").dialog('close');
            File.focus();
        }

    }
}

function PediCancelarArchivo()
{
    $("#dialogProv").dialog("close");
}
function UpdatePediDocs()
{
    var grid = jQuery("#PRE_GRID");
    var grid2 = jQuery("#PEDI_MTO");
    var lstRow = grid2.getRowData(grid2.getGridParam("selrow"));
    
    grid.setGridParam({
                        url: "CIP_TablaOp.jsp?ID=5&opnOpt=REP_GRID&_search=true&PED_ID=" + lstRow.PED_ID
                                , datatype: "xml",
                    }).trigger("reloadGrid");
}

function PediAbrirArchivo()
{
    var grid = jQuery("#PRE_GRID");
    if(grid.getGridParam("selrow") != null)
    {
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        var strPOST = "PRE_ID="+lstRow.PRE_ID;
        $.ajax({
            type: "POST",
            data: encodeURI(strPOST),
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "ERP_PedimentoDocu.jsp?id=1",
            success: function(dato) {
                Abrir_Link("document/Pedimentos/"+dato, "_new", 200, 200, 0, 0);
            },
            error: function(objeto, quepaso, otroobj) {
                alert(":Carga Archivo:" + objeto + " " + quepaso + " " + otroobj);
               
            }
        });
    }
}