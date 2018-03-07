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

function cofide_cursos_impartir() {
}

function initCursosImp() {
    getCatalogoCursosImp();
}

function getCatalogoCursosImp() {
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
        url: "COFIDE_CursosImpartir.jsp?id=1",
        success: function (datos) {
            var intDisponibles = 0;
            jQuery("#CI_GR").clearGridData();
            var lstXml = datos.getElementsByTagName("CursosImpartir")[0];
            var lstCI = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCI.length; i++) {
                var obj = lstCI[i];
                var rowCursos = {
                    CI_CONTADOR: getMaxGridCursosImpartir("#CI_GR"),
                    CCU_ID_M: obj.getAttribute("CCU_ID_M"),
                    CCU_CURSO: obj.getAttribute("CCU_CURSO"),
                    SEDE_ASIGNADA: obj.getAttribute("SEDE_ASIGNADA"),
                    FECHA_ASIGNADA: obj.getAttribute("FECHA_ASIGNADA")
                };
                jQuery("#CI_GR").addRowData(getMaxGridCursosImpartir("#CI_GR"), rowCursos, "last");
                if (obj.getAttribute("SEDE_ASIGNADA") == "") {
                    intDisponibles++;
                }
            }
            document.getElementById("CI_SEDES_DISP").value = intDisponibles;
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

function getMaxGridCursosImpartir(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridFletePedido

function OpnSeleccionaInstructor() {
    var strMes = document.getElementById("CI_MES").value;
    if (strMes > 0) {
//        var grid = jQuery("#CI_GR");
//        if (grid.getGridParam("selrow")) {
//            var id = grid.getGridParam("selrow");
//            var lstVal = grid.getRowData(id);
//            if (lstVal.SEDE_ASIGNADA == "") {
//                alert("No se ha asignado sede al curso");
//            } else {
        var objSecModiVta = objMap.getScreen("SEL_INSTRUCTOR");
        if (objSecModiVta != null) {
            objSecModiVta.bolActivo = false;
            objSecModiVta.bolMain = false;
            objSecModiVta.bolInit = false;
            objSecModiVta.idOperAct = 0;
        }
        OpnOpt("SEL_INSTRUCTOR", "_ed", "dialog", false, false, true);
//            }
//        } else {
//            alert("Selecciona una fila en el tab Detalles");
//        }
    } else {
        alert("Selecciona un Mes.");
    }
}

function OpnProgramCurso() {
    if (document.getElementById("CI_MES").value > 0 || document.getElementById("CI_MES").value != "0") {
        var grid = jQuery("#CI_GR");
        if (grid.getGridParam("selrow")) {
            var id = grid.getGridParam("selrow");
            var lstVal = grid.getRowData(grid.getGridParam("selrow"));
            strCursoDescripcion = lstVal.CCU_CURSO;
            strCursoClave = lstVal.CCU_ID_M;
            strMesConsulta = document.getElementById("CI_MES").value;
            strAnioConsulta = document.getElementById("CI_ANIO").value;
            myLayout.open("west");
            myLayout.open("east");
            myLayout.open("south");
            myLayout.open("north");
            document.getElementById("MainPanel").innerHTML = "";
            //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
            var objMainFacPedi = objMap.getScreen("CRS_IMPARTIR");
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
}


function initProgramarCurso() {
    var strOptionSelect = "<option value='0'>Seleccione</option>";
    var strHTML = "<table cellpadding=\"4\" cellspacing=\"1\" border=\"0\" >SEDE/FECHA DISPONIBLE: ";
    strHTML += " <td><select id=\"bodegasSelect\" name=\"bodegasSelect\"  class=\"outEdit\" onblur=\"QuitaFoco(this)\" onfocus=\"PonFoco(this)\" 0=\"\" > " + strOptionSelect + " < /select></td>";
    strHTML += "  </table>";
    document.getElementById("PRC_SEDE_FEC_DISP").innerHTML = strHTML;
    setCursoEditar();
    setSedeDisponible();
}//Fin initProgramarCurso

function setCursoEditar() {
    document.getElementById("CURSO_DESCRIPCION").value = strCursoDescripcion;
    document.getElementById("CURSO_CLAVE").value = strCursoClave;
    document.getElementById("MES_CONSULTA").value = strMesConsulta;
    document.getElementById("ANIO_CONSULTA").value = strAnioConsulta;
    getCursoMesesanteriores();
}//Fin setCursoEditar

function setSedeDisponible() {
    var strAnio = document.getElementById("ANIO_CONSULTA").value;
    var strMes = document.getElementById("MES_CONSULTA").value;
    var strOptionSelect = "<option value='0'>Seleccione</option>";
    var strHTML = "<table cellpadding=\"4\" cellspacing=\"1\" border=\"0\" >SEDE/FECHA DISPONIBLE: <br>";
    $.ajax({
        type: "POST",
        data: "strMes=" + strMes + "&strAnio=" + strAnio + "&CursoEditar=" + strCursoEdita,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_CursosImpartir.jsp?id=2",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("SedeDisponible")[0];
            var lstprecio = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstprecio.length; i++) {
                var obj = lstprecio[i];
                if (strCursoEdita != null) {
                    if (strCursoEdita == obj.getAttribute("CC_CURSO_ID")) {
                        strOptionSelect += "<option value='" + obj.getAttribute("CC_CURSO_ID") + "' selected>" + obj.getAttribute("CCU_CURSO") + "</option>";
                    } else {
                        strOptionSelect += "<option value='" + obj.getAttribute("CC_CURSO_ID") + "' >" + obj.getAttribute("CCU_CURSO") + "</option>";
                    }
                } else {
                    strOptionSelect += "<option value='" + obj.getAttribute("CC_CURSO_ID") + "' >" + obj.getAttribute("CCU_CURSO") + "</option>";
                }
            }
            strHTML += " <select id=\"SedeSelect\" name=\"SedeSelect\"  class=\"outEdit\" onblur=\"QuitaFoco(this)\" onfocus=\"PonFoco(this)\" 0=\"\" > " + strOptionSelect + " < /select>";
            strHTML += "  </table>";
            document.getElementById("PRC_SEDE_FEC_DISP").innerHTML = strHTML;

            if (strCursoEdita != "0" || strCursoEdita != 0) {
                var lstXmlEdit = datos.getElementsByTagName("CursoEdit")[0];
                var lstCEdit = lstXmlEdit.getElementsByTagName("datos");
                for (var i = 0; i < lstCEdit.length; i++) {
                    var obj = lstCEdit[i];

                    if (obj.getAttribute("CC_PROGRAMAR") == 1) {
                        document.getElementById("PRC_PROGRAMAR1").checked = true;
                    } else {
                        document.getElementById("PRC_PROGRAMAR2").checked = true;
                    }
                    if (obj.getAttribute("CC_IS_PRESENCIAL") == 1) {
                        document.getElementById("PRC_PRESENCIAL1").checked = true;
                    } else {
                        document.getElementById("PRC_PRESENCIAL2").checked = true;
                    }
                    if (obj.getAttribute("CC_IS_ONLINE") == 1) {
                        document.getElementById("PRC_ONLINE1").checked = true;
                    } else {
                        document.getElementById("PRC_ONLINE2").checked = true;
                    }
                    document.getElementById("PRC_INSTRUCTOR_ID").value = obj.getAttribute("CC_INSTRUCTOR_ID");
                }
            }
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin setSedeDisponible

function getCursoMesesanteriores() {
    var strAnio = document.getElementById("ANIO_CONSULTA").value;
    var strMes = document.getElementById("MES_CONSULTA").value;
    var strClave = document.getElementById("CURSO_CLAVE").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "strMes=" + strMes + "&strAnio=" + strAnio + "&Clave=" + strClave,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_CursosImpartir.jsp?id=3",
        success: function (datos) {
            jQuery("#GR_CURSO").clearGridData();
            var lstXml = datos.getElementsByTagName("MesesAnteriores")[0];
            var lstCI = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCI.length; i++) {
                var obj = lstCI[i];

                var rowCursosImp = {
                    CCU_CONTADOR: getMaxGridCursosImpartir("#GR_CURSO"),
                    CCU_CURSO: strCursoDescripcion,
                    CCU_MES1: obj.getAttribute("CCU_MES1"),
                    CCU_MES2: obj.getAttribute("CCU_MES2"),
                    CCU_MES3: obj.getAttribute("CCU_MES3"),
                    CCU_MES4: obj.getAttribute("CCU_MES4"),
                    CCU_MES5: obj.getAttribute("CCU_MES5"),
                    CCU_MES6: obj.getAttribute("CCU_MES6"),
                    CCU_MES7: obj.getAttribute("CCU_MES7"),
                    CCU_MES8: obj.getAttribute("CCU_MES8"),
                    CCU_MES9: obj.getAttribute("CCU_MES9"),
                    CCU_MES10: obj.getAttribute("CCU_MES10"),
                    CCU_MES11: obj.getAttribute("CCU_MES11"),
                    CCU_MES12: obj.getAttribute("CCU_MES12")
                };
                jQuery("#GR_CURSO").addRowData(getMaxGridCursosImpartir("#GR_CURSO"), rowCursosImp, "last");
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin getCursoMesesanteriores

function saveCursoProgramacion() {
    var intSedeSelect = document.getElementById("SedeSelect").value;
    var intInstructor = document.getElementById("PRC_INSTRUCTOR_ID").value;
    var intCursoClave = document.getElementById("CURSO_CLAVE").value;
    var intCursoDesc = document.getElementById("CURSO_DESCRIPCION").value;
    var textSelect = d.getElementById("PRC_INSTRUCTOR_ID").options[intInstructor].text;
    if (intSedeSelect > 0) {
        if (intInstructor > 0) {
            $("#dialogWait").dialog("open");
            var strPost = "SEDE=" + intSedeSelect;
            strPost += "&INSTRUCTOR=" + intInstructor;
            strPost += "&INSTRUCTOR_NOMBRE=" + textSelect;
            strPost += "&CursoClave=" + intCursoClave;
            strPost += "&CursoDesc=" + intCursoDesc;
            if (document.getElementById("PRC_PROGRAMAR1").checked) {
                strPost += "&SePrograma=1";
            } else {
                strPost += "&SePrograma=0";
            }
            if (document.getElementById("PRC_PRESENCIAL1").checked) {
                strPost += "&Presencial=1";
            } else {
                strPost += "&Presencial=0";
            }
            if (document.getElementById("PRC_ONLINE1").checked) {
                strPost += "&Online=1";
            } else {
                strPost += "&Online=0";
            }

            $.ajax({
                type: "POST",
                data: encodeURI(strPost),
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "html",
                url: "COFIDE_CursosImpartir.jsp?id=4",
                success: function (datos) {
                    if (datos.substring(0, 2) == "OK") {
                        callExitProgramCurso();
                        $("#dialogWait").dialog("close");
                    } else {
                        $("#dialogWait").dialog("close");
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                }
            }); //fin del ajax
        } else {
            alert("Selecciona Instructor!");
        }
    } else {
        alert("Selecciona Sede!");
    }
}//Fin saveCursoProgramacion

function callExitProgramCurso() {
    myLayout.open("west");
    myLayout.open("east");
    myLayout.open("south");
    myLayout.open("north");
    document.getElementById("MainPanel").innerHTML = "";
    //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
    var objMainFacPedi = objMap.getScreen("PROG_CURSO");
    objMainFacPedi.bolActivo = false;
    objMainFacPedi.bolMain = false;
    objMainFacPedi.bolInit = false;
    objMainFacPedi.idOperAct = 0;
    javascript:OpnOpt('CRS_IMPARTIR', '_ed', null, true, true, true);
}//Fin callExitProgramCurso

function sendMailInstructor() {
    var strAnio = document.getElementById("CI_ANIO").value;
    var strMes = document.getElementById("CI_MES").value;
    var intInstructor = document.getElementById("INSTRUCTOR_ID").value;
    if (intInstructor > 0) {
        $("#dialogWait").dialog("open");
        var strPost = "IdInstructor=" + intInstructor;
        strPost += "&Anio=" + strAnio;
        strPost += "&Mes=" + strMes;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_CursosImpartir.jsp?id=5",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    $("#dialogWait").dialog("close");
                    $("#dialog").dialog("close");
                } else {
                    $("#dialogWait").dialog("close");
                    $("#dialog").dialog("close");
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
    } else {
        alert("Selecciona Instructor!");
    }
}//Fin sendMailInstructor


function OpnEvaluacionInstructor() {
    var intInstructor = document.getElementById("PRC_INSTRUCTOR_ID").value
    if (intInstructor > 0) {
        var objSecModiVta = objMap.getScreen("CALIF_INSTR");
        if (objSecModiVta != null) {
            objSecModiVta.bolActivo = false;
            objSecModiVta.bolMain = false;
            objSecModiVta.bolInit = false;
            objSecModiVta.idOperAct = 0;
        }
        OpnOpt("CALIF_INSTR", "_ed", "dialog", false, false, true);
    } else {
        alert("Selecciona una Instructor");
        document.getElementById("PRC_INSTRUCTOR_ID").focus();
    }
}//Fin OpnEvaluacionInstructor

function initEvalInstructor() {
    getInfoInstructor();
}//Fin initEvalInstructor

function getInfoInstructor() {
    var strAnio = document.getElementById("INSTR_ANIO").value;
    var strMes = document.getElementById("INSTR_MES").value;
    var strInstructor = document.getElementById("PRC_INSTRUCTOR_ID").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "strMes=" + strMes + "&strAnio=" + strAnio + "&Instructor=" + strInstructor,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_CursosImpartir.jsp?id=6",
        success: function (datos) {
            var idSelect = d.getElementById("PRC_INSTRUCTOR_ID").selectedIndex;
            var textSelect = d.getElementById("PRC_INSTRUCTOR_ID").options[idSelect].text;
            jQuery("#GR_INSTRUCTOR").clearGridData();
            var lstXml = datos.getElementsByTagName("EvaluacionIns")[0];
            var lstCI = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCI.length; i++) {
                var obj = lstCI[i];
                var rowCursos = {
                    GR_CONTADOR: getMaxGridCursosImpartir("#GR_INSTRUCTOR"),
                    GR_CURSODESC: obj.getAttribute("GR_CURSODESC"),
                    GR_CURSODPROM: obj.getAttribute("GR_CURSODPROM"),
                    GR_CURSOFECHA: obj.getAttribute("GR_CURSOFECHA")
                };
                jQuery("#GR_INSTRUCTOR").addRowData(getMaxGridCursosImpartir("#GR_INSTRUCTOR"), rowCursos, "last");
            }
            document.getElementById("INSTR_NOMBRE").value = textSelect;
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin getInfoInstructor

function closeEvalInstructor() {
    $("#dialog").dialog("close");
}