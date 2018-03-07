/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function cofide_curso_cerrar() {

}
var itemIdCobCofPer = 1;
function initCof_curso_cerrar() {
    var grid = jQuery("#CL_GRIDD");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        CerrarCurso();
    }
//    if (document.getElementById("CC_CURSO_ID").value != 0 && document.getElementById("CC_CURSO_ID").value != null) {
//        //cof_llenagrid_part();
//        CerrarCurso();
//    }
}

function cof_llenagrid_part() {
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
        url: "COFIDE_Edit_Curso.jsp?id=2",
        success: function (datos) {
            var objsc = datos.getElementsByTagName("participantes")[0];
            var lstPart = objsc.getElementsByTagName("participantes_deta");
            for (var i = 0; i < lstPart.length; i++) {
                var obj = lstPart[i];
                var dataRow = {
                    LCC_NUMERO: itemIdCobCofPer,
                    LCC_NOMBRE: obj.getAttribute('CP_NOMBRE'),
                    LCC_APPAT: obj.getAttribute('CP_APPAT'),
                    LCC_APMAT: obj.getAttribute('CP_APMAT'),
                    LCC_NUMEROSOC: obj.getAttribute('CP_NOSOCIO'),
                    LCC_COMENTARIO: obj.getAttribute('CP_COMENT'),
                    LCC_FOLIO: obj.getAttribute('CP_FOLIO'),
                    LCC_ASIST: obj.getAttribute('CP_ASISTENCIA'),
                    LCC_FAC: obj.getAttribute('CP_REQFAC'),
                    LCC_PAGO: obj.getAttribute('CP_PAGO'),
                    LCC_OBSERVACIONES: obj.getAttribute('CP_OBSERVACIONES'),
                    LCC_TITULO: obj.getAttribute('CP_TITULO'),
                    LCC_ASOCIACION: obj.getAttribute('CP_ASCOC'),
                    LCC_CORREO: obj.getAttribute('CP_CORREO'),
                    LCC_ID: obj.getAttribute('CP_ID'),
                    LCC_ASOCIACION_ID: obj.getAttribute('LCC_ASOCIACION_ID'),
                    LCC_TITULO_ID: obj.getAttribute('LCC_TITULO_ID')
                };

                itemIdCobCofPer++;
                jQuery("#GRID_LCURSOSCERRAR").addRowData(itemIdCobCofPer, dataRow, "last");
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

function AddParticipante() {
    var objSecModiVta = objMap.getScreen("PART_COF");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt('PART_COF', '_ed', 'dialog', false, false, true);
}

function AddParticipantedeta() {

    var LCC_NOMBRE = document.getElementById("LCC_NOMBRE").value;
    var LCC_APPAT = document.getElementById("LCC_APPAT").value;
    var LCC_APMAT = document.getElementById("LCC_APMAT").value;
    var LCC_NUMEROSOC = document.getElementById("LCC_NUMEROSOC").value;
    var LCC_COMENTARIO = document.getElementById("LCC_COMENTARIO").value;
    var LCC_ASIST = "";
    if (document.getElementById("LCC_ASIST1").checked == true) {
        LCC_ASIST = "1";
    } else {
        LCC_ASIST = "0";
    }
    var LCC_FAC = "";
    if (document.getElementById("LCC_FAC1").checked == true) {
        LCC_FAC = "1";
    } else {
        LCC_FAC = "0";
    }
    var LCC_PAGO = "";
    if (document.getElementById("LCC_PAGO1").checked == true) {
        LCC_PAGO = "1";
    } else {
        LCC_PAGO = "0";
    }
    var LCC_OBSERVACIONES = document.getElementById("LCC_OBSERVACIONES").value;
    var LCC_TITULO = document.getElementById("LCC_TITULO").value;
    var LCC_ASOCIACION = document.getElementById("LCC_ASOCIACION").value;
    var LCC_CORREO = document.getElementById("LCC_CORREO").value;
    var IdCurso = document.getElementById("CC_CURSO_ID").value;


    var strPost = "";
    strPost += "&LCC_NOMBRE=" + LCC_NOMBRE;
    strPost += "&LCC_APPAT=" + LCC_APPAT;
    strPost += "&LCC_APMAT=" + LCC_APMAT;
    strPost += "&LCC_NUMEROSOC=" + LCC_NUMEROSOC;
    strPost += "&LCC_COMENTARIO=" + LCC_COMENTARIO;
    strPost += "&LCC_ASIST=" + LCC_ASIST;
    strPost += "&LCC_FAC=" + LCC_FAC;
    strPost += "&LCC_PAGO=" + LCC_PAGO;
    strPost += "&LCC_OBSERVACIONES=" + LCC_OBSERVACIONES;
    strPost += "&LCC_TITULO=" + LCC_TITULO;
    strPost += "&LCC_ASOCIACION=" + LCC_ASOCIACION;
    strPost += "&LCC_CORREO=" + LCC_CORREO;
    strPost += "&IdCurso=" + IdCurso;

    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Edit_Curso.jsp?id=4",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                jQuery("#GRID_LCURSOSCERRAR").clearGridData();
                itemIdCobCofPer = 0;
                cof_llenagrid_part();
                $("#dialog").dialog("close");
            } else {
                alert(datos);
                $("#dialog").dialog("close");
            }
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

function CancelParticipante() {
    $("#dialog").dialog("close");
}

function EditarParticipante() {

    var objSecModiVta = objMap.getScreen("EDPART_COF");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt('EDPART_COF', '_ed', 'dialogCte', false, false, true);
}


function InitEdit() {

    var grid = jQuery("#GRID_LCURSOSCERRAR");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var lstRow = grid.getRowData(id);
        document.getElementById("GRD_CURSO").value = document.getElementById("CC_NOMBRE_CURSO").value;
        document.getElementById("GRD_NOMBRE").value = lstRow.LCC_NOMBRE;
        document.getElementById("GRD_TITULO").value = lstRow.LCC_TITULO;
        document.getElementById("GRD_APPAT").value = lstRow.LCC_APPAT;
        document.getElementById("GRD_APMAT").value = lstRow.LCC_APMAT;
        document.getElementById("GRD_COMENTARIO").value = lstRow.LCC_OBSERVACIONES;
        document.getElementById("GRD_IDPAR").value = lstRow.LCC_ID;
    } else {
        alert("Seleccione un registro!");
        $("#dialogCte").dialog("close");
    }
}

function EditPart() {
    var grid = jQuery("#GRID_LCURSOSCERRAR");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var strPost = "";
        strPost += "&observacion=" + document.getElementById("GRD_COMENTARIO").value;
        strPost += "&titulo=" + document.getElementById("GRD_TITULO").value;
        strPost += "&nombre=" + document.getElementById("GRD_NOMBRE").value;
        strPost += "&appat=" + document.getElementById("GRD_APPAT").value;
        strPost += "&apmat=" + document.getElementById("GRD_APMAT").value;
        strPost += "&id_part=" + document.getElementById("GRD_IDPAR").value;

        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_Edit_Curso.jsp?id=5",
            success: function (datos) {
                jQuery("#GRID_LCURSOSCERRAR").clearGridData();
                itemIdCobCofPer = 0;
                CerrarCurso();
                $("#dialogCte").dialog("close");
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    } else {
        alert("Seleccione un registro!!!");
    }
}


function EditPartCanc() {
    $("#dialogCte").dialog("close");
}

function CloseCurso() {

    var strIdCurso = document.getElementById("CC_CURSO_ID").value;
    var strPost = "id_curso=" + strIdCurso;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Edit_Curso.jsp?id=6",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                alert("EL curso se encuentra cerrado");
                $("#dialog").dialog("close");
            }
            LLenaListaCurso();
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}
/**
 * llena listado de cursos
 * @returns {undefined}
 */
function LLenaListaCurso() {
    var strAnio = "";
    var strMes = "";
    var strEstatus = "";
    strAnio = document.getElementById("CL_ANIO").value;
    strMes = document.getElementById("CL_MES").value;
    if (strMes.length < 2) {
        strMes = "0" + strMes;
    }
    var strPost = "mes=" + strMes + "&anio=" + strAnio;
    var CountRow = 0;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Edit_Curso.jsp?id=8",
        success: function (datos) {
            jQuery("#CL_GRIDD").clearGridData();
            var lstXml = datos.getElementsByTagName("vta")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                if (objcte.getAttribute("estatus") == "1") {
                    strEstatus = "Abierto";
                } else {
                    strEstatus = "Cerrado";
                }
                //llenamos el grid
                var datarow = {
                    CC_CURSO_ID: objcte.getAttribute("id"),
                    CC_SEDE: objcte.getAttribute("sede"),
                    CC_FECHA_INICIAL: objcte.getAttribute("fechaini"),
                    CC_ESTATUS: strEstatus,
                    CC_NOMBRE_CURSO: objcte.getAttribute("nombre")
                }; //fin del grid
                CountRow++;
                jQuery("#CL_GRIDD").addRowData(CountRow, datarow, "last");
            }
        } //fin de la funcion que recupera los datos
    }); //fin del ajax
    $("#dialogWait").dialog("close");
}
/**
 * abrir popup cerrar cursos
 */

function OpnCerrarCurso() {
    var grid = jQuery("#CL_GRIDD");
    var id = grid.getGridParam("selrow");
    if (id != null) {
    var objSecModiVta = objMap.getScreen("LC_CERRAR");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt('LC_CERRAR', '_ed', 'dialog', false, false, true);
    } else {
        alert("Seleccione un curso");
}
}
/**
 * cierra el curso
 * @returns {undefined}
 */
function CerrarCurso() {
    var CountRow = 0;
    var intIdCurso = "";
    var strNombre = "";
    var strStatus = "Pendiente";
    var strPost = "";
    var grid = jQuery("#CL_GRIDD");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var lstRow = grid.getRowData(id);
        intIdCurso = lstRow.CC_CURSO_ID;
        strNombre = lstRow.CC_NOMBRE_CURSO;
        strPost = "id_curso=" + intIdCurso;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Edit_Curso.jsp?id=9",
            success: function (datos) {
                jQuery("#GRID_LCURSOSCERRAR").clearGridData();
                var lstXml = datos.getElementsByTagName("vta")[0]; //dato padre
                var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    if (objcte.getAttribute("estatus") == "1") {
                        strStatus = "Pagado";
                    }
                    //llenamos el grid
                    var datarow = {
                        LCC_ID: objcte.getAttribute("cp_id"), //id del participante
                        LCC_TITULO: objcte.getAttribute("titulo"),
                        LCC_NOMBRE: objcte.getAttribute("nombre"),
                        LCC_APPAT: objcte.getAttribute("appat"),
                        LCC_APMAT: objcte.getAttribute("apmat"),
                        LCC_NOMBRECOMPLETO: objcte.getAttribute("nomcompleto"),
                        LCC_CLAVEDDBB: objcte.getAttribute("clave"),
                        LCC_RAZONSOCIAL: objcte.getAttribute("razonsocial"),
                        LCC_ESTATUS: strStatus,
                        LCC_AGENTE: objcte.getAttribute("agente"),
                        LCC_NFAC: objcte.getAttribute("nfac"),
                        LCC_COMENTARIO: objcte.getAttribute("comentario"),
                        LCC_ASOCIACION: objcte.getAttribute("asociacion"),
                        LCC_NUMEROSOC: objcte.getAttribute("numero_socio"),
                        LCC_FOLIO: objcte.getAttribute("folio"),
                        LCC_OBSERVACIONES: objcte.getAttribute("observaciones")
                    }; //fin del grid
                    CountRow++;
                    jQuery("#GRID_LCURSOSCERRAR").addRowData(CountRow, datarow, "last");
                }
                document.getElementById("CC_NOMBRE_CURSO").value = strNombre;
                document.getElementById("CC_CURSO_ID").value = intIdCurso;
            } //fin de la funcion que recupera los datos
        }); //fin del ajax
    } else {
        alert("Seleccione un curso");
    }
}

function OpnDiploma() {
    var objSecModiVta = objMap.getScreen("DIPLOMA");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt('DIPLOMA', '_ed', 'dialogCte', false, false, true);
}
function initDiploma() {
    document.getElementById("DIP_NOM_CURSO").value = document.getElementById("CC_NOMBRE_CURSO").value;
    document.getElementById("DIP_CURSO_ID").value = document.getElementById("CC_CURSO_ID").value;
    setNextFolioDiploma();
}
function printDiplomaCurso() {
    var idCurso = document.getElementById("DIP_CURSO_ID").value;
    Abrir_Link("JasperReport?REP_ID=505&boton_1=PDF&CURSO=" + idCurso, '_reporte', 500, 600, 0, 0);
}
function doFoliosParticipantes() {
        $("#dialogWait").dialog("open");
        var strPost = "CursoId=" + document.getElementById("DIP_CURSO_ID").value;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_Edit_Curso.jsp?id=12",
            success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    printDiplomaCurso();
                    $("#dialogWait").dialog("close");
                } else {
                    $("#dialogWait").dialog("close");
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            }
        }); //fin del ajax
}//Fin doFoliosParticipantes

function OpnIncidencia() {
    var objSecModiVta = objMap.getScreen("INCIDENCIA");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt('INCIDENCIA', '_ed', 'dialogCte', false, false, true);
}
function initIncidencia() {
    var grid = jQuery("#GRID_LCURSOSCERRAR");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        OpnIncidencia();
    } else {
        alert("Seleccione un registro!!!");
    }
}
function initIncidenciadeta() {
    document.getElementById("IN_NOMBRE_CURSO").value = document.getElementById("CC_NOMBRE_CURSO").value;
    document.getElementById("IN_CURSO_ID").value = document.getElementById("CC_CURSO_ID").value;
    var grid = jQuery("#GRID_LCURSOSCERRAR");
    var id = grid.getGridParam("selrow");
    var lstRow = grid.getRowData(id);
    document.getElementById("IN_ASISTENTE").value = lstRow.LCC_NOMBRECOMPLETO;
    document.getElementById("IN_OBSERVACION").value = lstRow.LCC_OBSERVACIONES;
    document.getElementById("IN_PARTI").value = lstRow.LCC_ID;
    if (lstRow.LCC_ESTATUS == "Pagado") {
        document.getElementById("IN_PAGO").checked = true;
        document.getElementById("IN_ASISTE").checked = true;
    } else {
        document.getElementById("IN_PAGO").checked = false;
        document.getElementById("IN_ASISTE").checked = false;
    }
}
function SaveIncidencia() {
    var intPago = "0";
    var strObservaciones = document.getElementById("IN_OBSERVACION").value;
    var intIdParticipante = document.getElementById("IN_PARTI").value;
    var strAsiste = "0";
    if (document.getElementById("IN_PAGO").checked) {
        intPago = 1;
    }
    if (document.getElementById("IN_ASISTE").checked) {
        strAsiste = 1;
    }
    var strPost = "";
    strPost += "id_participante=" + intIdParticipante;
    strPost += "&pagado=" + intPago;
    strPost += "&observacion=" + strObservaciones;
    strPost += "&asiste=" + strAsiste;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Edit_Curso.jsp?id=10"
    }); //fin del ajax
    EditPartCanc();
    CerrarCurso();
}

function setNextFolioDiploma() {
    var strPost = "";
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Edit_Curso.jsp?id=11",
        success: function (datos) {
            document.getElementById("DIP_FOLIO").value = datos;
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    }); //fin del ajax
}