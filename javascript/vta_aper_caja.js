/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function vta_aper_caja() {
}

function showSaldoCajaChica() {
    var itemIdCob = 0;
    $("#dialogWait").dialog("open");
    if (document.getElementById("APC_ID").value != "") {
        var strPost = "APC_ID=" + document.getElementById("APC_ID").value;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "ERP_AperCaja.jsp?id=1",
            success: function (datos) {
                jQuery("#GR_SALDOS_INI").clearGridData();
                var objofrt = datos.getElementsByTagName("Datos_Caja")[0];
                var lstProms = objofrt.getElementsByTagName("aper_caja");
                for (var i = 0; i < lstProms.length; i++) {
                    var obj = lstProms[i];
                    var dataRow = {
                        SI_VALOR: obj.getAttribute("SI_VALOR"),
                        SI_PESOS: obj.getAttribute("SI_PESOS"),
                        SI_DOLARES: obj.getAttribute("SI_DOLARES"),
                        EDITA_PESO: 0,
                        EDITA_DOLAR: 0
                    };
                    //Anexamos el registro al GRID
                    itemIdCob++;
                    jQuery("#GR_SALDOS_INI").addRowData(itemIdCob, dataRow, "last");
                }
                $("#dialogWait").dialog("close");
            }, error: function () {
                alert("Error Datos de Usuario!");
                $("#dialogWait").dialog("close");
            }
        });
    }
    $("#dialogWait").dialog("close");
}

function printAperCaja() {
    //Abrimos ventana para emitir reporte
    MakeReportInside(100, "", "", "1");
}