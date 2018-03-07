/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function cofide_valida_facturas() {

}

function initValidaFacturas() {
    getFacturasValidar();
}

function getFacturasValidar() {
    var strAnio = document.getElementById("VF_ANIO").value;
    var strMes = document.getElementById("VF_MES").value;
    var strBaseCt = document.getElementById("US_BASE").value;
    var strValidos = document.getElementById("VF_VALIDOS1").checked;
    var intValidos = 0;
    if (strValidos) {
        intValidos = 1;
    }
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "strMes=" + strMes + "&strAnio=" + strAnio + "&CtBase=" + strBaseCt + "&Validos=" + intValidos,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_ValidaFactura.jsp?id=1",
        success: function (datos) {
            jQuery("#GR_VAL_FAC").clearGridData();
            var lstXml = datos.getElementsByTagName("ValidaFacturas")[0];
            var lstCom = lstXml.getElementsByTagName("datos");

            for (var i = 0; i < lstCom.length; i++) {
                var obj = lstCom[i];
                var rowValFac = {
                    VF_CONTADOR: getMaxGridValidaFac("#GR_VAL_FAC"),
                    FAC_FECHA: obj.getAttribute("FAC_FECHA"),
                    FAC_FECHA_PAGO: obj.getAttribute("FAC_FECHA_PAGO"),
                    FAC_SERIE: obj.getAttribute("FAC_SERIE"),
                    FAC_FOLIO_C: obj.getAttribute("FAC_FOLIO_C"),
                    FAC_RAZONSOCIAL: obj.getAttribute("FAC_RAZONSOCIAL"),
                    FAC_NOMPAGO: obj.getAttribute("FAC_NOMPAGO"),
                    FAC_IMPORTE: obj.getAttribute("FAC_IMPORTE"),
                    FAC_IMPUESTO1: obj.getAttribute("FAC_IMPUESTO1"),
                    FAC_TOTAL: obj.getAttribute("FAC_TOTAL"),
                    FAC_COFIDE_VALIDA: obj.getAttribute("FAC_COFIDE_VALIDA"),
                    FAC_COFIDE_PAGADO: obj.getAttribute("FAC_COFIDE_PAGADO"),
                    FAC_ID: obj.getAttribute("FAC_ID")
                };
                jQuery("#GR_VAL_FAC").addRowData(getMaxGridValidaFac("#GR_VAL_FAC"), rowValFac, "last");
            }//Fin FOR
            sumaRepoValidaFacturas();
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin getFacturasValidar


function getMaxGridValidaFac(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridCursosMaterial

function printArchivoPago() {
    var grid = jQuery("#GR_VAL_FAC");
    if (grid.getGridParam("selrow")) {
        $("#dialogWait").dialog("open");
        var id = grid.getGridParam("selrow");
        var lstVal = grid.getRowData(id);
        var strPost = "FAC_ID=" + lstVal.FAC_ID;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_ValidaFactura.jsp?id=3",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    var strPathDocumento = datos.replace("OK.","");
                    Abrir_Link(strPathDocumento, "_new", 200, 200, 0, 0);
                    $("#dialogWait").dialog("close");
                } else {
                    $("#dialogWait").dialog("close");
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
    } else {
        alert("Selecciona una Factura.")
    }
}//Fin printArchivoPago

function AutorizarPago() {
    var grid = jQuery("#GR_VAL_FAC");
    if (grid.getGridParam("selrow")) {
        $("#dialogWait").dialog("open");
        var id = grid.getGridParam("selrow");
        var lstVal = grid.getRowData(id);
        if (lstVal.FAC_COFIDE_PAGADO == "SI") {
            var strPost = "FAC_ID=" + lstVal.FAC_ID;
            strPost += "&strOpc=1";
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "html",
                url: "COFIDE_ValidaFactura.jsp?id=2",
                success: function (datos) {
                    if (datos.substring(0, 2) == "OK") {
                        getFacturasValidar();
                        $("#dialogWait").dialog("close");
                    } else {
                        $("#dialogWait").dialog("close");
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                }
            }); //fin del ajax
        } else {
            $("#dialogWait").dialog("close");
            alert("El documento debe estar pagado para autorizarlo.");
        }
    } else {
        alert("Selecciona una Factura.")
    }
}//Fin AutorizarPago

function opnDenegarPago() {
    var grid = jQuery("#GR_VAL_FAC");
    if (grid.getGridParam("selrow")) {
        $("#dialog").dialog("open");
        var strHTML = "<select id=\"strDenegacion\">"
        strHTML += "  <option value=\"Duplicidad de pago\">Duplicidad de pago</option>";
        strHTML += "  <option value=\"El importe pagado no corresponde al facturado\">El importe pagado no corresponde al facturado</option>";
        strHTML += "  <option value=\"No se encuentra registrado en estados de cuenta\">No se encuentra registrado en estados de cuenta</option>";
        strHTML += "  <option value=\"Cheque devuelto\">Cheque devuelto</option>";
        strHTML += "</select>";
        strHTML += "<br>";
        strHTML += "<br>";
        strHTML += "<button type=\"button\" onclick=\"DenegarPagoDo()\">Denegar</button>";
        strHTML += "<button type=\"button\" onclick=\"closeDatePicher()\">Cerrar</button>";
        document.getElementById("dialog_inside").innerHTML = strHTML;
    } else {
        alert("Seleccione una Factura");
    }
}//Fin opnDenegarPago

function DenegarPagoDo() {
    var grid = jQuery("#GR_VAL_FAC");
    if (grid.getGridParam("selrow")) {
        $("#dialogWait").dialog("open");
        var id = grid.getGridParam("selrow");
        var lstVal = grid.getRowData(id);
        var strPost = "FAC_ID=" + lstVal.FAC_ID;
        strPost += "&strOpc=2";
        strPost += "&strMotivoDen=" + document.getElementById("strDenegacion").value;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_ValidaFactura.jsp?id=2",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    getFacturasValidar();
                    $("#dialogWait").dialog("close");
                    closeDatePicher();
                } else {
                    $("#dialogWait").dialog("close");
                    closeDatePicher();
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
    } else {
        alert("Selecciona una Factura.")
    }
}//Fin DenegarPago

function EditFechaPago() {
    var grid = jQuery("#GR_VAL_FAC");
    if (grid.getGridParam("selrow")) {
        $("#dialogWait").dialog("open");
        var id = grid.getGridParam("selrow");
        var lstVal = grid.getRowData(id);
        var strPost = "FAC_ID=" + lstVal.FAC_ID;
        strPost += "&FechaPago=" + document.getElementById("departing").value;
        strPost += "&strOpc=3";
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_ValidaFactura.jsp?id=2",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    getFacturasValidar();
                    $("#dialogWait").dialog("close");
                    closeDatePicher();
                } else {
                    $("#dialogWait").dialog("close");
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
    } else {
        alert("Selecciona una Factura.")
    }
}//Fin EditFechaPago

function opnSetFechaPago() {
    var grid = jQuery("#GR_VAL_FAC");
    if (grid.getGridParam("selrow")) {
        $("#dialog").dialog("open");
        var strHTML = "<input type=\"text\" id=\"departing\"><br><br>";
        strHTML += "<button type=\"button\" onclick=\"EditFechaPago()\">Aceptar</button>";
        strHTML += "<button type=\"button\" onclick=\"closeDatePicher()\">Cerrar</button>";
        document.getElementById("dialog_inside").innerHTML = strHTML;
        setTimeout(setDatePicker(), 1000);
    } else {
        alert("Seleccione una Factura");
    }
}//Fin opnSetFechaPago

function setDatePicker() {
    $("#departing").datepicker();
}//Fin setDatePicker

function closeDatePicher() {
    $("#dialog").dialog("close");
}//Fin closeDatePicher


/*Realiza la suma de el reporte de validad Facturas*/
function sumaRepoValidaFacturas() {
    var grid = jQuery("#GR_VAL_FAC");
    var dblTotalImporte = 0;
    var dblTotalIva = 0;
    var dblTotal = 0;
    var arr = grid.getDataIDs();
    if (arr != null) {
        for (var i = 0; i < arr.length; i++) {
            var id = arr[i];
            var lstVal = grid.getRowData(id);
            dblTotalImporte = dblTotalImporte + parseFloat(lstVal.FAC_IMPORTE);
            dblTotalIva = dblTotalIva + parseFloat(lstVal.FAC_IMPUESTO1);
            dblTotal = dblTotal + parseFloat(lstVal.FAC_TOTAL);
        }
    }
    /*Ponemos el total en el pie de las columnas*/
    grid.footerData('set', {FAC_NOMPAGO: "TOTAL", FAC_IMPORTE: dblTotalImporte, FAC_IMPUESTO1: dblTotalIva, FAC_TOTAL: dblTotal});
}//Fin sumaRepoValidaFacturas