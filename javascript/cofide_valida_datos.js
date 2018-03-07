/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function cofide_valida_datos() {
}

function initValidaDuplicados() {
    getVtasDuplicadas();
}

function opnSelectBase() {
    var grid = jQuery("#GR_VTAS_DP");
    var ids = grid.getGridParam("selrow");
    if (ids != null) {
        var objSecModiVta = objMap.getScreen("CT_DUPLICADO");
        if (objSecModiVta != null) {
            objSecModiVta.bolActivo = false;
            objSecModiVta.bolMain = false;
            objSecModiVta.bolInit = false;
            objSecModiVta.idOperAct = 0;
        }
        OpnOpt("CT_DUPLICADO", "_ed", "dialog", false, false, true);
    } else {
        alert("Seleccione un Ticket en la lista.");
    }
}

function initSetCtBase() {
    var grid = jQuery("#GR_VTAS_DP");
    var ids = grid.getGridParam("selrow");
    if (ids != null) {
        var lstRow = grid.getRowData(ids);
        var intIdTkt = lstRow.VL_ID;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: "intTkt=" + intIdTkt,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_ValFac_Duplicados.jsp?id=2",
            success: function (datos) {
                jQuery("#GRD_DUPLICADOS").clearGridData();
                var lstXml = datos.getElementsByTagName("CtCoincidencia")[0];
                var lstCom = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCom.length; i++) {
                    var obj = lstCom[i];
                    var rowComision = {
                        VL_CONTADOR: getMaxGridDuplicados("#GRD_DUPLICADOS"),
                        VL_ID: obj.getAttribute("CT_ID"),
                        VL_NOMBRE: obj.getAttribute("CT_NOMBRE"),
                        VL_CT_BASE: obj.getAttribute("CT_CLAVE_DDBB"),
                        VL_RAZONSOCIAL: obj.getAttribute("CT_RAZONSOCIAL"),
                        VL_EMAIL: obj.getAttribute("CT_EMAIL1"),
                        VL_AGENTE: obj.getAttribute("strAgente")
                    };
                    jQuery("#GRD_DUPLICADOS").addRowData(getMaxGridDuplicados("#GRD_DUPLICADOS"), rowComision, "last");
                }//Fin FOR
                $("#dialogWait").dialog("close");
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });
    } else {
        alert("Seleccione un Ticket en la lista.");
    }
}//Fin opnDenegarPago

function getVtasDuplicadas() {
    var strFiltro = document.getElementById("TXT_CONSULTA").value;
    var strTipoFiltro = document.getElementById("MB_COMBO").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "strFiltro=" + strFiltro + "&strTipoFiltro=" + strTipoFiltro,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_ValFac_Duplicados.jsp?id=1",
        success: function (datos) {
            jQuery("#GR_VTAS_DP").clearGridData();
            var lstXml = datos.getElementsByTagName("VtasDuplicadas")[0];
            var lstCom = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCom.length; i++) {
                var obj = lstCom[i];
                var rowComision = {
                    VL_CONTADOR: getMaxGridDuplicados("#GR_VTAS_DP"),
                    VL_ID: obj.getAttribute("CT_ID"),
                    VL_ID_OLD: obj.getAttribute("COFIDE_DUPLICIDAD_ID"),
                    VL_CT_BASE: obj.getAttribute("CT_CLAVE_DDBB"),
                    VL_RAZONSOCIAL: obj.getAttribute("CT_RAZONSOCIAL"),
                    VL_ESTATUS: obj.getAttribute("ESTATUS"),
                    VL_AGENTE: obj.getAttribute("AGENTE")
                };
                jQuery("#GR_VTAS_DP").addRowData(getMaxGridDuplicados("#GR_VTAS_DP"), rowComision, "last");
            }//Fin FOR
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}


function getMaxGridDuplicados(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridCursosMaterial

function setConfirmCliente() {
    var grid = jQuery("#GR_VTAS_DP");
    var ids = grid.getGridParam("selrow");
    var intIdTkt = 0;
    if (ids != null) {
        var lstRow = grid.getRowData(ids);
        intIdTkt = lstRow.VL_ID;
    }

    var grid = jQuery("#GR_VTAS_DP");
    var ids = grid.getGridParam("selrow");
    if (ids != null) {
        var lstRow = grid.getRowData(ids);
        var intCtId = lstRow.VL_ID;
        var strPost = "";
        strPost += "TKT_ID=" + intIdTkt;
        strPost += "&CT_ID=" + intCtId;
        strPost += "&CT_BASE=" + document.getElementById("SEL_BASE").value;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_ValFac_Duplicados.jsp?id=3",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    $("#dialog").dialog("close");
                    $("#dialogWait").dialog("close");
                    getVtasDuplicadas();
                } else {
                    alert(datos);
                    $("#dialogWait").dialog("close");
                }
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    } else {
        alert("Seleccione un Ticket en la lista.");
    }
}



function setAnulTkt() {
    var grid = jQuery("#GR_VTAS_DP");
    var ids = grid.getGridParam("selrow");
    var intIdTkt = 0;
    if (ids != null) {
        var lstRow = grid.getRowData(ids);
        intIdTkt = lstRow.VL_ID;
        var strPost = "TKT_ID=" + intIdTkt;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_ValFac_Duplicados.jsp?id=4",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    $("#dialogWait").dialog("close");
                    getVtasDuplicadas();
                } else {
                    alert(datos);
                    $("#dialogWait").dialog("close");
                }
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    } else {
        alert("Seleccione un Ticket en la lista.");
    }
}