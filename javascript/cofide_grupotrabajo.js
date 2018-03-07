function cofide_grupotrabajo() {

}
var itemIdCobGTrabajo = 0;
var itemIdCob = 0;
function initgrupotrabajo() {
    document.getElementById("CGD_MES").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_ANIO").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_IMPVENTA").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_IMPVENTA_COBRO").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_IMPMETA").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_ADDBTN").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_BTNCAN").parentNode.parentNode.style.display = "none";
    if (document.getElementById("CG_ID").value != "") {
        var strPOST = "&CG_ID=" + document.getElementById("CG_ID").value;
        $.ajax({type: "POST", data: strPOST, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_GrupoTrabajo.jsp?ID=1", success: function (datos) {
                jQuery("#GRID_CTE").clearGridData();
                var lstXml = datos.getElementsByTagName("Grupo")[0];
                var lstprecio = lstXml.getElementsByTagName("Grupo_deta");
                for (var i = 0; i < lstprecio.length; i++) {
                    var obj = lstprecio[i];
                    var datarow = {CGD_ID: obj.getAttribute("CGD_ID"), CGD_MES: obj.getAttribute("CGD_MES"), CGD_ANIO: obj.getAttribute("CGD_ANIO"), CGD_IMPVENTA: obj.getAttribute("CGD_IMPVENTA"), CGD_IMPVENTA_COBRO: obj.getAttribute("CGD_IMPVENTA_COBRO"), CGD_IMPMETA: obj.getAttribute("CGD_IMPMETA"), CGD_MES_INT: obj.getAttribute("CGD_MES_int")};
                    itemIdCobGTrabajo++;
                    jQuery("#GRID_GTRABAJO").addRowData(itemIdCobGTrabajo, datarow, "last");
                }
            }, error: function (objeto, quepaso, otroobj) {
                alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }});
    }
}
function dblClickGTrabajo(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#G_TRABAJO");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "G_TRABAJO") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "EV_TELEM") {
            document.getElementById("CE_ID_GTRABAJO").value = lstVal.CG_ID;
            document.getElementById("CE_GTRABAJO").value = lstVal.CG_DESCRIPCION;
            $("#dialog").dialog("close");
        }
    }
}
function NuevoGTrabajo() {
    document.getElementById("BAN_EDIT_GRID").value = "0";
    document.getElementById("CGD_MES").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_ANIO").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_IMPVENTA").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_IMPVENTA_COBRO").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_IMPMETA").parentNode.parentNode.style.display = "";
    document.getElementById("CG_ADDBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CG_BTNCAN").parentNode.parentNode.style.display = "";
    document.getElementById("CG_DELBTN").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_BTNNEW").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_ADDEDIT").parentNode.parentNode.style.display = "none";
}
function CancelarGTrabajo() {
    document.getElementById("CGD_MES").value = 0;
    document.getElementById("CGD_ANIO").value = "";
    document.getElementById("CGD_IMPVENTA").value = "0.0";
    document.getElementById("CGD_IMPVENTA_COBRO").value = "0.0";
    document.getElementById("CGD_IMPMETA").value = "0.0";
    document.getElementById("CGD_MES").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_ANIO").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_IMPVENTA").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_IMPVENTA_COBRO").parentNode.parentNode.style.display = "none";
    document.getElementById("CGD_IMPMETA").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_ADDBTN").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_BTNCAN").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_DELBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CG_BTNNEW").parentNode.parentNode.style.display = "";
    document.getElementById("CG_ADDEDIT").parentNode.parentNode.style.display = "";
}
function delgridGTrabajo() {
    var grid = jQuery("#GRID_GTRABAJO");
    if (grid.getGridParam("selrow") != null) {
        if (document.getElementById("CGD_ID").value != "" || document.getElementById("CGD_ID").value != 0) {
            var strPost = "";
            strPost = "intIdMaster=" + document.getElementById("CG_ID").value;
            $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "COFIDE_GrupoTrabajo.jsp?ID=3", success: function (datos) {
                    if (datos.substring(0, 2) == "OK") {
                        grid.delRowData(grid.getGridParam("selrow"));
                    } else {
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                }, error: function (objeto, quepaso, otroobj) {
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }});
        } else {
            grid.delRowData(grid.getGridParam("selrow"));
        }
    }
}
function EditGTrabajo() {
    document.getElementById("BAN_EDIT_GRID").value = "1";
    document.getElementById("CGD_MES").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_ANIO").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_IMPVENTA").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_IMPVENTA_COBRO").parentNode.parentNode.style.display = "";
    document.getElementById("CGD_IMPMETA").parentNode.parentNode.style.display = "";
    document.getElementById("CG_ADDBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CG_BTNCAN").parentNode.parentNode.style.display = "";
    document.getElementById("CG_DELBTN").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_BTNNEW").parentNode.parentNode.style.display = "none";
    document.getElementById("CG_ADDEDIT").parentNode.parentNode.style.display = "none";
    var grid = jQuery("#GRID_GTRABAJO");
    if (grid.getGridParam("selrow") != null) {
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        document.getElementById("CG_CONTADOR").value = id;
        document.getElementById("CGD_ID").value = lstRow.CGD_ID;
        document.getElementById("CGD_MES").value = lstRow.CGD_MES_INT;
        document.getElementById("CGD_ANIO").value = lstRow.CGD_ANIO;
        document.getElementById("CGD_IMPVENTA").value = lstRow.CGD_IMPVENTA;
        document.getElementById("CGD_IMPVENTA_COBRO").value = lstRow.CGD_IMPVENTA_COBRO;
        document.getElementById("CGD_IMPMETA").value = lstRow.CGD_IMPMETA;
    }
}
function SaveMaster(datos) {
    var intContador = 0;
    var intIdSave = 0;
    if (datos != null) {
        intIdSave = trim(datos).replace("OK", "");
    } else {
        intIdSave = document.getElementById("CG_ID").value;
    }
    var strPost = "";
    strPost += "&intIdMaster=" + intIdSave;
    var grid = jQuery("#GRID_GTRABAJO");
    var idArr = grid.getDataIDs();
    if (idArr.length > 0) {
        for (var i = 0; i < idArr.length; i++) {
            var id = idArr[i];
            var lstRow = grid.getRowData(id);
            if (lstRow.CGD_ID == "") {
                intContador = intContador + 1;
                strPost += "&CGD_ANIO" + intContador + "=" + lstRow.CGD_ANIO + "";
                strPost += "&CGD_IMPVENTA" + intContador + "=" + lstRow.CGD_IMPVENTA + "";
                strPost += "&CGD_IMPVENTA_COBRO" + intContador + "=" + lstRow.CGD_IMPVENTA_COBRO + "";
                strPost += "&CGD_IMPMETA" + intContador + "=" + lstRow.CGD_IMPMETA + "";
                strPost += "&CGD_MES_INT" + intContador + "=" + lstRow.CGD_MES_INT + "";
            }
        }
    }
    strPost += "&Contador=" + intContador;
    $("#dialogWait").dialog("open");
    $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "COFIDE_GrupoTrabajo.jsp?ID=2", success: function (datos) {
            $("#dialogWait").dialog("close");
            if (trim(datos) == "OK") {
                _objSc.RestoreSave();
                _objSc = null;
            } else {
                alert(datos);
            }
        }, error: function (data) {
            $("#dialogWait").dialog("close");
            alert(data);
        }});
}
function addgridGTrabajo() {
    if (document.getElementById("BAN_EDIT_GRID").value == "0") {
        console.log("1");
        if (document.getElementById("CGD_ID").value != "" || document.getElementById("CGD_ID").value != 0) {
            console.log("3");
            var strPost = "";
            strPost = "intIdMaster=" + document.getElementById("CG_ID").value;
            strPost += "&CGD_ID=" + document.getElementById("CGD_ID").value;
            strPost += "&CGD_MES=" + document.getElementById("CGD_MES").value;
            strPost += "&CGD_ANIO=" + document.getElementById("CGD_ANIO").value;
            strPost += "&CGD_IMPVENTA=" + document.getElementById("CGD_IMPVENTA").value;
            strPost += "&CGD_IMPVENTA_COBRO=" + document.getElementById("CGD_IMPVENTA_COBRO").value;
            strPost += "&CGD_IMPMETA=" + document.getElementById("CGD_IMPMETA").value;
            $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "COFIDE_GrupoTrabajo.jsp?ID=3", success: function (datos) {
                    if (datos.substring(0, 2) == "OK") {
                        var intMesIdx = d.getElementById("CGD_MES").selectedIndex;
                        var txtMes = d.getElementById("CGD_MES").options[intMesIdx].text;
                        var dataRow1 = {CGD_MES: txtMes, CGD_ANIO: document.getElementById("CGD_ANIO").value, CGD_IMPVENTA: document.getElementById("CGD_IMPVENTA").value, CGD_IMPVENTA_COBRO: document.getElementById("CGD_IMPVENTA_COBRO").value, CGD_IMPMETA: document.getElementById("CGD_IMPMETA").value, CGD_MES_INT: intMesIdx};
                        itemIdCobGTrabajo++;
                        jQuery("#GRID_GTRABAJO").addRowData(itemIdCobGTrabajo, dataRow1, "last");
                        CancelarGTrabajo();
                    } else {
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                }, error: function (objeto, quepaso, otroobj) {
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }});
        } else {
            console.log("4");
            var intMesIdx = d.getElementById("CGD_MES").selectedIndex;
            var txtMes = d.getElementById("CGD_MES").options[intMesIdx].text;
            var dataRow1 = {CGD_MES: txtMes, CGD_ANIO: document.getElementById("CGD_ANIO").value, CGD_IMPVENTA: document.getElementById("CGD_IMPVENTA").value, CGD_IMPVENTA_COBRO: document.getElementById("CGD_IMPVENTA_COBRO").value, CGD_IMPMETA: document.getElementById("CGD_IMPMETA").value, CGD_MES_INT: intMesIdx};
            itemIdCobGTrabajo++;
            jQuery("#GRID_GTRABAJO").addRowData(itemIdCobGTrabajo, dataRow1, "last");
            CancelarGTrabajo();
        }
    } else {
        console.log(document.getElementById("CGD_ID").value);
        if (document.getElementById("CGD_ID").value != "" && document.getElementById("CGD_ID").value != "0") {
            console.log("7");
            var strPost = "";
            strPost = "intIdMaster=" + document.getElementById("CG_ID").value;
            strPost += "&CGD_ID=" + document.getElementById("CGD_ID").value;
            strPost += "&CGD_MES=" + document.getElementById("CGD_MES").value;
            strPost += "&CGD_ANIO=" + document.getElementById("CGD_ANIO").value;
            strPost += "&CGD_IMPVENTA=" + document.getElementById("CGD_IMPVENTA").value;
            strPost += "&CGD_IMPVENTA_COBRO=" + document.getElementById("CGD_IMPVENTA_COBRO").value;
            strPost += "&CGD_IMPMETA=" + document.getElementById("CGD_IMPMETA").value;
            $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "COFIDE_GrupoTrabajo.jsp?ID=3", success: function (datos) {
                    if (datos.substring(0, 2) == "OK") {
                        var grid = jQuery("#GRID_GTRABAJO");
                        var id = grid.getGridParam("selrow");
                        if (id != null) {
                            var lstRow = grid.getRowData(id);
                            var intMesIdx = d.getElementById("CGD_MES").selectedIndex;
                            var txtMes = d.getElementById("CGD_MES").options[intMesIdx].text;
                            lstRow.CGD_MES = txtMes;
                            lstRow.CGD_ANIO = document.getElementById("CGD_ANIO").value;
                            lstRow.CGD_IMPVENTA = document.getElementById("CGD_IMPVENTA").value;
                            lstRow.CGD_IMPVENTA_COBRO = document.getElementById("CGD_IMPVENTA_COBRO").value;
                            lstRow.CGD_IMPMETA = document.getElementById("CGD_IMPMETA").value;
                            lstRow.CGD_MES_INT = intMesIdx;
                            grid.setRowData(id, lstRow);
                            grid.trigger("reloadGrid");
                            CancelarGTrabajo();
                        }
                    } else {
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                }, error: function (objeto, quepaso, otroobj) {
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }});
        } else {
            console.log("2");
            var grid = jQuery("#GRID_GTRABAJO");
            var id = grid.getGridParam("selrow");
            if (id != null) {
                var lstRow = grid.getRowData(id);
                var intMesIdx = d.getElementById("CGD_MES").selectedIndex;
                var txtMes = d.getElementById("CGD_MES").options[intMesIdx].text;
                lstRow.CGD_MES = txtMes;
                lstRow.CGD_ANIO = document.getElementById("CGD_ANIO").value;
                lstRow.CGD_IMPVENTA = document.getElementById("CGD_IMPVENTA").value;
                lstRow.CGD_IMPVENTA_COBRO = document.getElementById("CGD_IMPVENTA_COBRO").value;
                lstRow.CGD_IMPMETA = document.getElementById("CGD_IMPMETA").value;
                lstRow.CGD_MES_INT = intMesIdx;
                grid.setRowData(id, lstRow);
                grid.trigger("reloadGrid");
                CancelarGTrabajo();
            }
        }
    }
}
function initMetas() {
    document.getElementById("MET_EJE").parentNode.parentNode.style.display = "none";
    document.getElementById("MET_IMP").parentNode.parentNode.style.display = "none";
    document.getElementById("MET_NVO").parentNode.parentNode.style.display = "none";
    document.getElementById("MET_BTNSAVE").parentNode.parentNode.style.display = "none";
    document.getElementById("MET_BTNEDIT").parentNode.parentNode.style.display = "";
    document.getElementById("MET_EJE").value = "";
    document.getElementById("MET_IMP").value = "";
    document.getElementById("MET_NVO").value = "";
    $("#dialogWait").dialog("open");
//   loadMetasE(); //carga ejecutivos
//   loadMetasG(); //carga grupos
    $("#dialogWait").dialog("close");
}
function editMeta() {
    var lstRow1 = "";
    var gridpro = jQuery("#GRD_META");
    var idspro = gridpro.getGridParam("selrow");
    if (idspro !== null) {
        lstRow1 = gridpro.getRowData(idspro);
        var intUs_ID = lstRow1.MET_ID;
        document.getElementById("MET_ID").value = intUs_ID;
        document.getElementById("MET_EJE").value = lstRow1.MET_EJECUTIVO;
        document.getElementById("MET_IMP").value = lstRow1.MET_IMPORTE;
        document.getElementById("MET_NVO").value = lstRow1.MET_NVOS;
        document.getElementById("MET_EJE").parentNode.parentNode.style.display = "";
        document.getElementById("MET_IMP").parentNode.parentNode.style.display = "";
        document.getElementById("MET_NVO").parentNode.parentNode.style.display = "";
        document.getElementById("MET_BTNSAVE").parentNode.parentNode.style.display = "";
        document.getElementById("MET_BTNEDIT").parentNode.parentNode.style.display = "";
    } else {
        alert("Selecciona un registro!");
    }
}
function saveMeta() {
    var intID = document.getElementById("MET_ID").value;
    var dblImporte = document.getElementById("MET_IMP").value;
    var intNvos = document.getElementById("MET_NVO").value;
    var strPost = "id=" + intID;
    strPost += "&imp=" + dblImporte;
    strPost += "&nvo=" + intNvos;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false, dataType: "xml", url: "COFIDE_GrupoTrabajo.jsp?ID=8"
    });
    initMetas();
}
function loadMetasE() {
    jQuery("#GRD_META").clearGridData();
    var strPost = "Anio=" + document.getElementById("MET_ANIO_VIEW").value;
    strPost += "&Mes=" + document.getElementById("MET_MES_VIEW").value;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_GrupoTrabajo.jsp?ID=6",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    MET_ID: objcte.getAttribute("id"),
                    MET_EJECUTIVO: objcte.getAttribute("nombre"),
                    MET_NVOS: objcte.getAttribute("nvocte"),
                    MET_IMPORTE: objcte.getAttribute("importe"),
                    MET_EX: objcte.getAttribute("expa"),
                    MET_PROS: objcte.getAttribute("pros"),
                    MET_CTE: objcte.getAttribute("totalcte"),
                    MET_ID_BASE: objcte.getAttribute("gpo")
                };
                itemIdCob++;
                jQuery("#GRD_META").addRowData(itemIdCob, datarow, "last");
            }
        }});
}
function loadMetasG() {
    var dblImporteTotal = 0;
    var intNuevosCteTotal = 0;
    var strPost = "Anio=" + document.getElementById("MET_ANIO_VIEW").value;
    strPost += "&Mes=" + document.getElementById("MET_MES_VIEW").value;
    jQuery("#GRD_METAG").clearGridData();
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_GrupoTrabajo.jsp?ID=7",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    METD_ID: objcte.getAttribute("ID"),
                    METD_ID_GPO: objcte.getAttribute("GRUPO"),
                    METD_IMP: objcte.getAttribute("IMPORTE"),
                    METD_NVO: objcte.getAttribute("NUEVO")
                };
                itemIdCob++;
                jQuery("#GRD_METAG").addRowData(itemIdCob, datarow, "last");
                dblImporteTotal += parseFloat(objcte.getAttribute("IMPORTE"));
                intNuevosCteTotal += parseInt(objcte.getAttribute("NUEVO"));
            }
         document.getElementById("METD_IMP").value = FormatNumber(dblImporteTotal, 2, true, false, true, false);
            document.getElementById("METD_NVO").value = intNuevosCteTotal;
        },
        error: function (objeto, quepaso, otroobj) {
            alert("mostramos las metas por grupo:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

function generaMetasAuto() {
    if (generaMetasAutoEval()) {
        var strPost = "mes_global=" + document.getElementById("MET_MES").value;
        strPost += "&anio_global=" + document.getElementById("MET_ANIO").value;
        strPost += "&monto_global=" + document.getElementById("MET_META_TOTAL").value;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_GrupoTrabajo.jsp?ID=9",
            success: function (datos) {
                if (trim(datos) == "OK") {
                    alert("Fueron generadas las metas");
                    //Las mostramos en la parte inferior
                    document.getElementById("MET_ANIO_VIEW").value = document.getElementById("MET_ANIO").value;
                    document.getElementById("MET_MES_VIEW").value = document.getElementById("MET_MES").value;
                    //Limpiamos lo capturado
                    document.getElementById("MET_ANIO").value = "";
                    document.getElementById("MET_MES").value = "";
                    document.getElementById("MET_META_TOTAL").value = "0.0";
                    loadMetasE(); //carga ejecutivos
                    loadMetasG(); //carga grupos
                } else {
                    alert(datos);
                }
            }
            , error: function (objeto, quepaso, otroobj) {
                alert("mostramos las metas por grupo:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });

    }
}

function generaMetasAutoEval() {
    var bolPasa = true;
    if (document.getElementById("MET_ANIO").value == "") {
        alert("Favor de capturar el anio");
        bolPasa = false;
    }
    if (document.getElementById("MET_MES").value == "") {
        alert("Favor de capturar el mes");
        bolPasa = false;
    }
    if (document.getElementById("MET_META_TOTAL").value == "" || document.getElementById("MET_META_TOTAL").value == "0.0") {
        alert("Favor de capturar un monto");
        bolPasa = false;
    }
    return bolPasa;
}

function actualizarMetas() {
    loadMetasE(); //carga ejecutivos
    loadMetasG(); //carga grupos
}