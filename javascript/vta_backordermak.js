/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function vta_backordermak() {
}
var lastselBOMAK;

function initbackordermak() {
    loadgridBackOrderPrMak();
    $("#dlgMakBackOrder").on("dialogclose", function (event, ui) {
        var grid = jQuery("#FAC_GRID");
        var id = grid.getGridParam("selrow");
        if (id != null) {
            var lstRow = grid.getRowData(id);
            lstRow.FACD_CANTIDAD = 0;
            grid.setRowData(id, lstRow);
            grid.trigger("reloadGrid");
        }
    });
}

function loadgridBackOrderPrMak() {
    showGridBackOrdr();
    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var lstRow = grid.getRowData(id);
        var intPrId = lstRow.FACD_CVE;
        var dblCantidad = parseInt(lstRow.FACD_CANTIDAD);
        var dblExistencia = parseInt(lstRow.FACD_EXIST);
        var CantidadFaltante = dblCantidad - dblExistencia;
        document.getElementById("BO_CANTINSF").value = CantidadFaltante;
        jQuery("#BO_GRDSALDOS").clearGridData();
        $.ajax({
            type: "POST",
            data: "intPrId=" + intPrId,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "XML",
            url: "ERP_PedidosMakProcs.jsp?id=19",
            success: function (datos) {
                var objsc = datos.getElementsByTagName("vta_producto_suc")[0];
                var lstProds = objsc.getElementsByTagName("vta_productos");
                for (var i = 0; i < lstProds.length; i++) {
                    var obj = lstProds[i];
                    d.getElementById("BO_NOMPR").value = obj.getAttribute("PR_CODIGO");
                }
                var itemIdCob = 0;
                $.ajax({
                    type: "POST",
                    data: "intPrId=" + intPrId,
                    scriptCharset: "utf-8",
                    contentType: "application/x-www-form-urlencoded;charset=utf-8",
                    cache: false,
                    dataType: "XML",
                    url: "ERP_PedidosMakProcs.jsp?id=18",
                    success: function (datos) {
                        var objsc = datos.getElementsByTagName("vta_producto_suc")[0];
                        var lstProds = objsc.getElementsByTagName("vta_productos");
                        for (var i = 0; i < lstProds.length; i++) {
                            var obj = lstProds[i];
                            var datarow = {
                                GRSAL_SUCURSAL: obj.getAttribute("sucursal"),
                                GRSAL_BODEGA: obj.getAttribute("SC_NOMBRE"),
                                GRSAL_EXISTENCIA: FormatNumber(obj.getAttribute("existencia"), 2, true, false, true, false),
                                GRSAL_ASIGNADO: FormatNumber(obj.getAttribute("asignado"), 2, true, false, true, false),
                                GRSAL_DISPONIBLE: FormatNumber(obj.getAttribute("disponible"), 2, true, false, true, false),
                                GRSAL_CANTXTRNS: "0.0",
                                GRSAL_SUCURSAL_ID: obj.getAttribute("sucursal_ID"),
                                GRSAL_BODEGA_ID: obj.getAttribute("SC_NOMBRE_ID")
                            };


                            itemIdCob++;
                            jQuery("#BO_GRDSALDOS").addRowData(itemIdCob, datarow, "last");
                        }
                        $("#dialogWait").dialog("close");
                    },
                    error: function (objeto, quepaso, otroobj) {
                        alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                    }
                });

            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    }
}


function ModificaCantidadBOMak(rowid, status) {

    editFilaBOMAK(rowid);
}

function editFilaBOMAK(id) {

    var grid = jQuery('#BO_GRDSALDOS');
    if (id != lastselBOMAK) {
        grid.saveRow(lastselBOMAK);
        grid.editRow(id, false);
        lastselBOMAK = id;
    }
}

function SumaPorAgregarBackOrdr(event) {

    if (event.keyCode == 13) {
        var grid = jQuery("#BO_GRDSALDOS");
        grid.saveRow(lastselBOMAK);

        var id = grid.getGridParam("selrow");
        if (id != null) {
            var lstRow = grid.getRowData(id);
            if (grid.getGridParam("selrow") != null) {
                if (parseFloat(lstRow.GRSAL_DISPONIBLE) < parseFloat(lstRow.GRSAL_CANTXTRNS)) {


                    alert("La cantidad solicitada es mayor a la disponible!");
                    lstRow.GRSAL_CANTXTRNS = 0;
                    grid.setRowData(id, lstRow);
                    grid.trigger("reloadGrid");
                } else {
//                    var intCanttrns = 0;
//                    if (document.getElementById("BO_CANTTRANS").value == "") {
//                        intCanttrns = 0;
//                    } else {
//                        intCanttrns = document.getElementById("BO_CANTTRANS").value;
//                    }
//                    
//                    document.getElementById("BO_CANTTRANS").value = parseInt(lstRow.GRSAL_CANTXTRNS) + parseInt(intCanttrns);

                    var intTotal = 0;
                    var grid2 = jQuery("#BO_GRDSALDOS");
                    var arr2 = grid2.getDataIDs();
                    for (var i = 0; i < arr2.length; i++) {
                        var id1 = arr2[i];
                        var lstRowAct = grid2.getRowData(id1);
                        intTotal = intTotal + parseInt(lstRowAct.GRSAL_CANTXTRNS);
                    }
                    document.getElementById("BO_CANTTRANS").value = intTotal;
                }
            }
        }
        lastselBOMAK = 0;
    }
}

function envBackOrdr() {
    if (parseInt(document.getElementById("BO_CANTINSF").value) != parseInt(document.getElementById("BO_CANTTRANS").value)) {
        var objSecModiVta = objMap.getScreen("BACKORPOP_MAK");
        if (objSecModiVta != null) {
            objSecModiVta.bolActivo = false;
            objSecModiVta.bolMain = false;
            objSecModiVta.bolInit = false;
            objSecModiVta.idOperAct = 0;
        }
        OpnOpt('BACKORPOP_MAK', '_ed', 'dialog', false, false, true);
    } else {
        var grid = jQuery("#FAC_GRID");
        var id = grid.getGridParam("selrow");
        if (id != null) {
            var lstRow = grid.getRowData(id);
            //Actualizamos los importes
            lstRowChangePrecioPediMak(lstRow, id, grid);
            var intTipoBackOrder = 0;
            var strBackOrderNom = "";
            if (document.getElementById("PAN_TIPOBO0").checked)
            {
                intTipoBackOrder = 1;
                strBackOrderNom = "OC";
            }
            if (document.getElementById("PAN_TIPOBO1").checked)
            {
                intTipoBackOrder = 2;
                strBackOrderNom = "TI";
            }
            if (document.getElementById("PAN_TIPOBO2").checked)
            {
                intTipoBackOrder = 3;
                strBackOrderNom = "AK";
            }
            var strBackOrder = "";
            if (intTipoBackOrder == 2) {
                var grid1 = jQuery("#BO_GRDSALDOS");
                var arr = grid1.getDataIDs();
                for (var i = 0; i < arr.length; i++) {
                    var id1 = arr[i];
                    var lstRowAct = grid1.getRowData(id1);
                    strBackOrder += "|-" + lstRowAct.GRSAL_BODEGA_ID + "-" + lstRowAct.GRSAL_CANTXTRNS + "-|";
                }
            }
            lstRow.FACD_ES_BACKORDER = "1";
            lstRow.FACD_TIPO_BACKORDER = intTipoBackOrder;
            lstRow.FACD_DETALLE_BACKORDER = strBackOrder;
            lstRow.FACD_TIPO_BACKORDER_LETRA = strBackOrderNom;
            grid.setRowData(id, lstRow);
            grid.trigger("reloadGrid");
        }
        $("#dlgMakBackOrder").dialog("close");
    }
}


function showGridBackOrdr() {
    if (document.getElementById("PAN_TIPOBO1").checked) {
        $("#BO_GRDSALDOS").jqGrid('setGridState', 'visible');//or 'hidden' 
    } else {
        $("#BO_GRDSALDOS").jqGrid('setGridState', 'hidden');//or 'hidden' 

    }
}

function BTN1BackMak() {
    var intCantidadSuc = 0;
    var grid1 = jQuery("#BO_GRDSALDOS");
    var arrMsj = grid1.getDataIDs();
    for (var i = 0; i < arrMsj.length; i++) {
        var id1 = arrMsj[i];
        var lstRowAct1 = grid1.getRowData(id1);
        if (lstRowAct1.GRSAL_CANTXTRNS != 0 && lstRowAct1.GRSAL_CANTXTRNS != "0") {
            intCantidadSuc = intCantidadSuc + parseFloat(lstRowAct1.GRSAL_CANTXTRNS);
        }
    }

    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var lstRow = grid.getRowData(id);

        lstRow.FACD_CANTIDAD = parseFloat(lstRow.FACD_DISPONIBLE) + parseFloat(intCantidadSuc);
        grid.setRowData(id, lstRow);
        grid.trigger("reloadGrid");

        lstRowChangePrecioPediMak(lstRow, id, grid);

        var intTipoBackOrder = 0;
        var strBackOrderNom = "";

        if (document.getElementById("PAN_TIPOBO0").checked)
        {
            intTipoBackOrder = 1;
            strBackOrderNom = "OC";
        }
        if (document.getElementById("PAN_TIPOBO1").checked)
        {
            intTipoBackOrder = 2;
            strBackOrderNom = "TI";
            console.log("Entro tipo de backorder");
        }
        if (document.getElementById("PAN_TIPOBO2").checked)
        {
            intTipoBackOrder = 3;
            strBackOrderNom = "AK";
        }

        var strBackOrder = "";
        if (intTipoBackOrder == 2) {
            for (var i = 0; i < arrMsj.length; i++) {
                var id1 = arrMsj[i];
                var lstRowAct = grid1.getRowData(id1);
                if (lstRowAct.GRSAL_CANTXTRNS != 0 && lstRowAct.GRSAL_CANTXTRNS != "0") {
                    strBackOrder += "|-" + lstRowAct.GRSAL_BODEGA_ID + "-" + lstRowAct.GRSAL_CANTXTRNS + "-|";
                }
            }
        }

        lstRow.FACD_ES_BACKORDER = "1";
        lstRow.FACD_TIPO_BACKORDER = intTipoBackOrder;
        lstRow.FACD_DETALLE_BACKORDER = strBackOrder;
        lstRow.FACD_TIPO_BACKORDER_LETRA = strBackOrderNom;

        grid.setRowData(id, lstRow);
        grid.trigger("reloadGrid");

        $("#dialog").dialog("close");
        $("#dlgMakBackOrder").dialog("close");

    }
}

function BTN2BackMak() {
    $("#dialog").dialog("close");
    $("#dlgMakBackOrder").dialog("close");
}