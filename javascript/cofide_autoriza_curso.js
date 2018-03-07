/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var strCursoEdita = 0;
var strCursoClave = 0;
var strCursoDescripcion = 0;
var strMesConsulta = 0;
var strAnioConsulta = 0;

function cofide_autoriza_curso() {

}

function initAutorizaCurso() {
    getCursosConfirm();
}//Fin initAutorizaCurso

//Llnea grid de cursos por confirmar
function getCursosConfirm() {
    var strAnio = document.getElementById("CI_ANIO").value;
    var strMes = document.getElementById("CI_MES").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "strMes=" + strMes + "&strAnio=" + strAnio,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_AutorizaCurso.jsp?id=1",
        success: function (datos) {
            jQuery("#CNFC_GR").clearGridData();
            var lstXml = datos.getElementsByTagName("CursosConfirmar")[0];
            var lstCI = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCI.length; i++) {
                var obj = lstCI[i];
                var rowCursos = {
                    CC_CONTADOR: getMaxGridCursosConfirmar("#CNFC_GR"),
                    CC_NOMBRE_CURSO: obj.getAttribute("CC_NOMBRE_CURSO"),
                    CC_SEDE: obj.getAttribute("CC_SEDE"),
                    CC_FECHA_INICIAL: obj.getAttribute("CC_FECHA_INICIAL"),
                    CC_FICHA_TECNICA: obj.getAttribute("CC_FICHA_TECNICA"),
                    CC_CONFIRM_INSTR: obj.getAttribute("CC_CONFIRM_INSTR"),
                    CC_PUBLICADO: obj.getAttribute("CC_PUBLICADO"),
                    CC_CURSO_ID: obj.getAttribute("CC_CURSO_ID"),
                    CC_CLAVES: obj.getAttribute("CC_CLAVES")
                };
                jQuery("#CNFC_GR").addRowData(getMaxGridCursosConfirmar("#CNFC_GR"), rowCursos, "last");
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin getCursosConfirm

function getMaxGridCursosConfirmar(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridFletePedido

function OpnProgramCursoEdit() {
    if (document.getElementById("CI_MES").value > 0 || document.getElementById("CI_MES").value != "0") {
        var grid = jQuery("#CNFC_GR");
        if (grid.getGridParam("selrow")) {
            var id = grid.getGridParam("selrow");
            var lstVal = grid.getRowData(id);
            strCursoDescripcion = lstVal.CC_NOMBRE_CURSO;
            strCursoClave = lstVal.CC_CLAVES;
            strCursoEdita = lstVal.CC_CURSO_ID;
            strMesConsulta = document.getElementById("CI_MES").value;
            strAnioConsulta = document.getElementById("CI_ANIO").value;
            myLayout.open("west");
            myLayout.open("east");
            myLayout.open("south");
            myLayout.open("north");
            document.getElementById("MainPanel").innerHTML = "";
            //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
            var objMainFacPedi = objMap.getScreen("CONFIRM_CURSO");
            objMainFacPedi.bolActivo = false;
            objMainFacPedi.bolMain = false;
            objMainFacPedi.bolInit = false;
            objMainFacPedi.idOperAct = 0;
            javascript:OpnOpt('PROG_CURSO', '_ed', null, true, true, true);
        } else {
            alert("Selecciona una fila en el tab Detalles");
        }
    } else {
        alert("Selecciona un Mes");
    }
}//Fin OpnProgramCursoEdit

function confirmInstructor() {
    var grid = jQuery("#CNFC_GR");
    if (grid.getGridParam("selrow")) {
        var id = grid.getGridParam("selrow");
        var lstVal = grid.getRowData(id);
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: "IdCurso=" + lstVal.CC_CURSO_ID,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_AutorizaCurso.jsp?id=2",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    getCursosConfirm();
                    $("#dialogWait").dialog("close");
                } else {
                    $("#dialogWait").dialog("close");
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
    } else {
        alert("Selecciona un curso por confirmar.");
    }
}//Fin confirmInstructor


function publicaCurso() {
    var grid = jQuery("#CNFC_GR");
    if (grid.getGridParam("selrow")) {
        var id = grid.getGridParam("selrow");
        var lstVal = grid.getRowData(id);
        var cmfInst = lstVal.CC_CONFIRM_INSTR;
        var FichaTec = lstVal.CC_FICHA_TECNICA;
        if (cmfInst == 1 && FichaTec == 1) {
            $("#dialogWait").dialog("open");
            $.ajax({
                type: "POST",
                data: "&CC_CURSO_ID=" + lstVal.CC_CURSO_ID,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Cursos.jsp?id=2",
                success: function (datos) {
                    var objsc = datos.getElementsByTagName("Autorizar")[0];
                    var lstProds = objsc.getElementsByTagName("Autorizar_deta");
                    for (var i = 0; i < lstProds.length; i++) {
                        var obj = lstProds[i];
                        if (obj.getAttribute("respuesta") != "true") {
                            alert("Hubo un error al Autorizar");
                        } else {
                            getCursosConfirm();
                            $("#dialogWait").dialog("close");
                        }
                    }
                    $("#dialogWait").dialog("close");
                }
            }); //fin del ajax
        } else {
            alert("El curso debe estar confirmado por el instructor y con Estastus \"SI\" en el valor Ficha tecnica para poder ser publicado.");
        }
    } else {
        alert("Selecciona un curso por confirmar.");
    }
}//Fin confirmInstructor