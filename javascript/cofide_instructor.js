function cofide_instructor() {

}
function init() {
    InstructorName();
    initContabilidad();
}
function dblClickInstructor(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#C_INSTRUCTORES");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "C_INSTRUCTORES") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_CURSOS") {
            document.getElementById("CC_INSTRUCTOR_ID").value = lstVal.CI_INSTRUCTOR_ID;
            document.getElementById("CC_INSTRUCTOR").value = lstVal.CI_INSTRUCTOR;
            $("#dialog2").dialog("close");
        } else {
            if (strNomMain == "E2_CURSOS") {
                document.getElementById("CC_INSTRUCTOR_ID").value = lstVal.CI_INSTRUCTOR_ID;
                document.getElementById("CC_INSTRUCTOR").value = lstVal.CI_INSTRUCTOR;
                $("#dialog2").dialog("close");
            }
        }
    }
}
function subirFoto() {
    var strFoto = document.getElementById("CI_FOTO_").value;
    if (strFoto != "") {
        if (Right(strFoto.value.toUpperCase(), 3) == "JPG" ||
                Right(strFoto.value.toUpperCase(), 3) == "PNG" ||
                Right(strFoto.value.toUpperCase(), 3) == "JPEG") {
            $.ajaxFileUpload({
                url: "COFIDE_UpMaterial.jsp?ID=3",
                secureuri: false,
                fileElementId: "CI_FOTO",
                dataType: "json",
                success: function (data, status) {
                    if (typeof (data.error) != "undefined") {
                        if (data.error != "") {
                            alert(data.error);
                        } else {
                            alert("Archivo guardado");
                            document.getElementById("CI_FOTO_").disabled = true;
                            document.getElementById("CI_FOTO").value = strFoto;
                        }
                    }
                    $("#dialogWait").dialog("close");
                }, error: function (data, status, e) {
                    alert(e);
                    $("#dialogWait").dialog("close");
                }});
        } else {
            alert("El archivo debe estar en formato PNG, JPG o JPEG");
            strFoto.focus();
        }
    } else {
        alert("Requiere seleccionar un archivo");
    }
}
function InstructorName() {
    var strNombre = document.getElementById("CI_NOMBRE").value;
    var strApellido = document.getElementById("CI_APELLIDO").value;
    document.getElementById("CI_INSTRUCTOR").value = strNombre + " " + strApellido;
}

//Muestra los cursos del Instructor
function tabShowInstructores(event, ui) {
    var index = ui.newTab.index();
    if (index === 1) {
        searchCursosInstructor();
    }
}

function searchCursosInstructor() {
    var intInstructor = document.getElementById("CI_INSTRUCTOR_ID").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "ID_INSTRC=" + intInstructor,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=35",
        success: function (datos) {
            jQuery("#GR_CURSOS").clearGridData();
            var lstXml = datos.getElementsByTagName("Cursos")[0];
            var lstODCD = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstODCD.length; i++) {
                var obj = lstODCD[i];
                var rowCursos = {
                    CE_CONTADOR: getMaxGridCursos(),
                    CCD_ID: obj.getAttribute("CCD_ID"),
                    CURSO_DESC: obj.getAttribute("CURSO_DESC")
                };
                jQuery("#GR_CURSOS").addRowData(getMaxGridCursos(), rowCursos, "last");
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

function getMaxGridCursos() {
    var intLenght = jQuery("#GR_CURSOS").getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridFletePedido

function EliminaCursoInstrc() {
    var grid = jQuery("#GR_CURSOS");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow = grid.getRowData(ids);
        var intId = lstRow.CCD_ID;
        $("#dialogWait").dialog("open");
        var strPost = "ID_REGISTRO=" + intId;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_Telemarketing.jsp?ID=37",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    searchCursosInstructor();
                    $("#dialogWait").dialog("close");
                } else {
                    $("#dialogWait").dialog("close");
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
    } else {
        alert("Selecciona Algun Registro!");
    }
}

function AddCursoInstrc() {
    var intIdCurso = document.getElementById("SEL_CURSO").value;
    if (intIdCurso != 0) {
        $.ajax({
            type: "POST",
            data: "ID_CURSO=" + intIdCurso + "&ID_INSTRC=" + document.getElementById("CI_INSTRUCTOR_ID").value,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_Telemarketing.jsp?ID=36",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    searchCursosInstructor();
                    $("#dialogWait").dialog("close");
                } else {
                    $("#dialogWait").dialog("close");
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
    } else {
        alert("Seleccione un Curso;");
    }
}
function initContabilidad() {
    $("#dialogWait").dialog("open");
    var bolContabilidad = "";
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Telemarketing.jsp?ID=41",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                datos = trim(datos);
                bolContabilidad = datos.replace("OK.", "");
                if (bolContabilidad == "false") {
                    BlockContabilidad();
                }
                $("#dialogWait").dialog("close");
            } else {
                $("#dialogWait").dialog("close");
                alert(datos);
            }
            $("#dialogWait").dialog("close");
        }
    }); //fin del ajax
}
function BlockContabilidad() {

    var strRA1 = document.getElementById("CI_RANGOA_1");
    var strRB1 = document.getElementById("CI_RANGOB_1");
    var strHr1 = document.getElementById("CI_COSTO_HR1");
    var strHrF1 = document.getElementById("CI_COSTO_FORANEO1");

    var strRA2 = document.getElementById("CI_RANGOA_2");
    var strRB2 = document.getElementById("CI_RANGOB_2");
    var strHr2 = document.getElementById("CI_COSTO_HR2");
    var strHrF2 = document.getElementById("CI_COSTO_FORANEO2");

    var strRA3 = document.getElementById("CI_RANGOA_3");
    var strRB3 = document.getElementById("CI_RANGOB_3");
    var strHr3 = document.getElementById("CI_COSTO_HR3");
    var strHrF3 = document.getElementById("CI_COSTO_FORANEO3");

    var strRA4 = document.getElementById("CI_RANGOA_4");
    var strRB4 = document.getElementById("CI_RANGOB_4");
    var strHr4 = document.getElementById("CI_COSTO_HR4");
    var strHrF4 = document.getElementById("CI_COSTO_FORANEO4");

    strRA1.disabled = true;
    strRA2.disabled = true;
    strRA3.disabled = true;
    strRA4.disabled = true;
    strRA1.style["background"] = "#e0f8e6";
    strRA2.style["background"] = "#e0f8e6";
    strRA3.style["background"] = "#e0f8e6";
    strRA4.style["background"] = "#e0f8e6";

    strRB1.disabled = true;
    strRB2.disabled = true;
    strRB3.disabled = true;
    strRB4.disabled = true;
    strRB1.style["background"] = "#e0f8e6";
    strRB2.style["background"] = "#e0f8e6";
    strRB3.style["background"] = "#e0f8e6";
    strRB4.style["background"] = "#e0f8e6";

    strHr1.disabled = true;
    strHr2.disabled = true;
    strHr3.disabled = true;
    strHr4.disabled = true;
    strHr1.style["background"] = "#e0f8e6";
    strHr2.style["background"] = "#e0f8e6";
    strHr3.style["background"] = "#e0f8e6";
    strHr4.style["background"] = "#e0f8e6";

    strHrF1.disabled = true;
    strHrF2.disabled = true;
    strHrF3.disabled = true;
    strHrF4.disabled = true;
    strHrF1.style["background"] = "#e0f8e6";
    strHrF2.style["background"] = "#e0f8e6";
    strHrF3.style["background"] = "#e0f8e6";
    strHrF4.style["background"] = "#e0f8e6";
}
function AddInstructor(opc) {
    var intIdExp = "";
    var strPost = "";
    if (opc == 1) { //nuevo
        intIdExp = "0";
    }
    if (opc == 2) { //update
        intIdExp = document.getElementById("CI_INSTRUCTOR_ID").value;
    }
    strPost = "opc=" + opc;
    strPost += "id_exp=" + intIdExp;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Telemarketing.jsp?ID=42",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                $("#dialogWait").dialog("close");
            } else {
                $("#dialogWait").dialog("close");
                alert(datos);
            }
        }
    }); //fin del ajax
}
