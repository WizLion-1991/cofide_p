function cofide_edlista_curso() {
}

function initEd_Curso() {
    if (document.getElementById("CC_CURSO_ID").value != 0 && document.getElementById("CC_CURSO_ID").value != null) {
        llennaParticipantesCurso();
    }
}

function OpnDiagParticipante() {
    var objSecModiVta = objMap.getScreen("LP_PART");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("LP_PART", "_ed", "dialog", false, false);
}

//Llena el Grid de los participantes de este curso
function llennaParticipantesCurso() {
    var itemIdCob = 0;
    $("#dialogWait").dialog("open");
    var intIdCurso = document.getElementById("CC_CURSO_ID").value;
    var strPOST = "&ID_CURSO=" + intIdCurso;
    $.ajax({
        type: "POST",
        data: strPOST,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Edit_Curso.jsp?id=1",
        success: function (datos) {
            jQuery("#GRID_ED_LISTACURSO").clearGridData();
            var objsc = datos.getElementsByTagName("Participantes")[0];
            var lstPart = objsc.getElementsByTagName("datos");
            for (var i = 0; i < lstPart.length; i++) {
                var obj = lstPart[i];
                var dataRow = {
                    ELC_NUM: i + 1,
                    CP_ID: obj.getAttribute('CP_ID'),
                    ELC_NOMBRE: obj.getAttribute('CP_NOMBRE'),
                    ELC_APPAT: obj.getAttribute('CP_APPAT'),
                    ELC_APMAT: obj.getAttribute('CP_APMAT'),
                    ELC_TITULO: obj.getAttribute('CP_TITULO'),
                    ELC_NUMSOC: obj.getAttribute('CP_NOSOCIO'),
                    ELC_CORREO: obj.getAttribute('CP_CORREO'),
                    ELC_COMENTARIO: obj.getAttribute('CP_COMENT'),
                    ELC_ASOC: obj.getAttribute('CP_ASCOC'),
                    ELC_FOLIO: obj.getAttribute('CP_FOLIO')
                };

                itemIdCob++;
                jQuery("#GRID_ED_LISTACURSO").addRowData(itemIdCob, dataRow, "last");
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

function changeStatusCurso() {
    document.getElementById("CC_ESTATUS").value = 3;
}


function printListadoCurso() {
    //Abrimos ventana para emitir reporte
    var idCurso = document.getElementById("CC_CURSO_ID").value;
    Abrir_Link("JasperReport?REP_ID=504&boton_1=PDF&CURSO=" + idCurso, '_reporte', 500, 600, 0, 0);
}

function printDiplomaCurso() {
    //Abrimos ventana para emitir reporte
//    MakeReportInside(505, "", "", "1");
    var idCurso = document.getElementById("CC_CURSO_ID").value;
    Abrir_Link("JasperReport?REP_ID=505&boton_1=PDF&CURSO=" + idCurso, '_reporte', 500, 600, 0, 0);

}

function initEditNombre() {
    var grid = jQuery("#GRID_ED_LISTACURSO");
    var idPart = grid.getGridParam("selrow");
    if (idPart != null) {
        OpnDiagParticipante();
    } else {
        alert("Debe seleccionar un producto");
    }
}


function EditNombre() {
    var grid = jQuery("#GRID_ED_LISTACURSO");
    var idPart = grid.getGridParam("selrow");
    if (idPart != null) {
        for (var i = 0; i < idPart.length; i++) {
            var id1 = idPart[i];
            var lstRow1 = grid.getRowData(id1);
            document.getElementById("txt_ID").value = lstRow1.CP_ID;
            document.getElementById("txt_nombre").value = lstRow1.ELC_NOMBRE;
            document.getElementById("txt_APaterno").value = lstRow1.ELC_APPAT;
            document.getElementById("txt_AMaterno").value = lstRow1.ELC_APMAT;
        }
    } else {
        alert("Debe seleccionar un producto");
    }
}

function EditNombresDo() {
    var strPost = "";
    strPost += "CP_ID=" + document.getElementById("txt_ID").value;
    strPost += "&CP_NOMBRE=" + document.getElementById("txt_nombre").value;
    strPost += "&CP_APPAT=" + document.getElementById("txt_APaterno").value;
    strPost += "&CP_APMAT=" + document.getElementById("txt_AMaterno").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Edit_Curso.jsp?id=3",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                initEd_Curso();
                $("#dialog").dialog("close");
                $("#dialogWait").dialog("close");
            } else {
                alert(datos);
                $("#dialogWait").dialog("close");
            }
        },
        error: function (objeto, quepaso, otroobj) {
            $("#dialogWait").dialog("open");
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

function doFoliosParticipantes() {
    var strPost = "";
    var grid = jQuery("#GRID_ED_LISTACURSO");
    var idArr = grid.getDataIDs();
    var blFolio = false;

    for (var i = 0; i < idArr.length; i++) {
        var id = idArr[i];
        var lstRow = grid.getRowData(id);
        if (lstRow.ELC_FOLIO != "") {
            blFolio = true;
        }
    }

    if (blFolio) {
        alert("NO SE PUEDEN GENERAR FOLIO, LOS PARTICIPANTES YA TIENEN FOLIO");
    } else {
        for (var i = 0; i < idArr.length; i++) {
            var id = idArr[i];
            var lstRow = grid.getRowData(id);
            strPost += "&CP_ID=" + lstRow.CP_ID;
        }
        strPost += "&NUM_P=" + idArr.length;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_Edit_Curso.jsp?id=9",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    initEd_Curso();
                    $("#dialogWait").dialog("close");
                } else {
                    alert(datos);
                    $("#dialogWait").dialog("close");
                }
            },
            error: function (objeto, quepaso, otroobj) {
                $("#dialogWait").dialog("open");
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    }
}