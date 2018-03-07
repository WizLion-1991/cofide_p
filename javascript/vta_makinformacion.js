/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function vta_makinformacion() {
}


function initmakinformacion() {

    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    var lstRow = grid.getRowData(id);
    if (grid.getGridParam("selrow") != null) {
        document.getElementById("INF_PRECORIG").value = FormatNumber(parseFloat(lstRow.FACD_PRECREAL), 2, true, false, true, false);
        document.getElementById("INF_PRECACTUAL").value = FormatNumber(parseFloat(lstRow.FACD_PRECIO), 2, true, false, true, false);

        var itemIdCob = 0;
        var intCantTotalTr = 0;
        var strPOST = "&strBackOrder=" + lstRow.FACD_DETALLE_BACKORDER;
        $.ajax({
            type: "POST",
            data: strPOST,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "ERP_PedidosMakProcs.jsp?id=21",
            success: function (datos) {
                jQuery("#GRID_BACKORD").clearGridData();
                var lstXml = datos.getElementsByTagName("backorder")[0];
                var lstprecio = lstXml.getElementsByTagName("backorder_deta");
                for (var i = 0; i < lstprecio.length; i++) {
                    var obj = lstprecio[i];
                    var strCantidad = obj.getAttribute("cantidad").replace("-", "");
                    var datarow = {
                        GRD_SUCURSAL: obj.getAttribute("sucursal"),
                        GRD_CANTIDAD: strCantidad.replace("-", "")
                    };

                    intCantTotalTr = parseInt(intCantTotalTr) + parseInt(strCantidad);

                    //Anexamos el fregistro al GRID
                    itemIdCob++;
                    jQuery("#GRID_BACKORD").addRowData(itemIdCob, datarow, "last");

                }

                document.getElementById("INF_CANTTRAN").value = intCantTotalTr;

            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });


    } else {
        $("#dialog2").dialog("close");
        $("#dialog").dialog("close");
        $("#dialogWait").dialog("close");
        alert("Selecciona un producto en la tabla");

    }
}

function ClosePupUoInfMak() {
    var objSecModiVta = objMap.getScreen("INFORMACION_MAK");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    $("#dlgMakInformacion").dialog("close");
}

function initHistPed() {
    addHistorialPediMak("1", 0, 0, 0);

}

function CerrarHistorial() {
    $("#dlgMakHistrial").dialog("close");
}