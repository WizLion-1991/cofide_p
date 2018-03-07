function cofide_error_base() {

}
function opnEditClass() {
    var grid = jQuery("#ERR_GRD");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var objSecModiVta = objMap.getScreen("ERR_EDIT");
        if (objSecModiVta != null) {
            objSecModiVta.bolActivo = false;
            objSecModiVta.bolMain = false;
            objSecModiVta.bolInit = false;
            objSecModiVta.idOperAct = 0;
        }
        OpnOpt('ERR_EDIT', '_ed', 'dialog', false, false, true);
    } else {
        alert("Seleccione un registro!");
    }
}
function consultaLista() {
    var itemIdCobCofPer = 0;
    var strMes = document.getElementById("ERR_MES").value;
    var strEquipo = document.getElementById("ERR_EQUIPO").value;
    var strAnio = document.getElementById("ERR_ANIO").value;
    var strPost = "";
    if (strEquipo != "0") {
        if (strAnio != "") {
            strPost = "mes=" + strMes;
            strPost += "&grupo=" + strEquipo;
            strPost += "&anio=" + strAnio;
            $("#dialogWait").dialog("open");
            jQuery("#ERR_GRD").clearGridData();
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Error_base.jsp?id=1",
                success: function (datos) {
                    var objsc = datos.getElementsByTagName("vta")[0];
                    var lstPart = objsc.getElementsByTagName("datos");
                    for (var i = 0; i < lstPart.length; i++) {
                        var obj = lstPart[i];
                        if (obj.getAttribute('listado') == "1") {
                            alert("Ya ha sido listado");
                        }
                        var dataRow = {
                            ERRD_LIS: obj.getAttribute('listado'),
                            ERRD_EDIT: obj.getAttribute('editado'),
                            ERRD_EJECUTIVO: obj.getAttribute('ejecutivo'),
                            ERRD_ID: obj.getAttribute('id_ejecutivo'),
                            ERRD_RAZON: obj.getAttribute('razon'),
                            ERRD_TELEFONO: obj.getAttribute('telefono'),
                            ERRD_CLASS: obj.getAttribute('clasifica'),
                            ERRD_OBSER: obj.getAttribute('observacion')
                        };

                        itemIdCobCofPer++;
                        jQuery("#ERR_GRD").addRowData(itemIdCobCofPer, dataRow, "last");
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
                }
            });
        } else {
            alert("Ingresa el año que se va a listar");
        }
    } else {
        alert("selecciona un equipo");
    }
}
function editRegistro() {
    var strPost = "";
    var grid = jQuery("#ERR_GRD");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var lstRow = grid.getRowData(id);
        var strIDEjecutivo = lstRow.ERRD_ID;
        var strCerrado = lstRow.ERRD_EDIT;
        if (strCerrado != "1") {
            var strComent = document.getElementById("ERRL_NOTA").value;
            var strClas = document.getElementById("CLASIFICACION").value;
            strPost = "idEjecutivo=" + strIDEjecutivo;
            strPost += "&comentario=" + strIDEjecutivo;
            strPost += "&clasificacion=" + strIDEjecutivo;

            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Error_base.jsp?id=2",
                success: function (datos) {
                    $("#dialog").dialog("close");
                    consultaLista();
                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialog").dialog("close");
                }
            });
        } else {
            alert("Captura terminada");
        }
    } else {
        alert("No se a seleccionado ningun registro");
    }
}
function ExitEdit() {
    $("#dialog").dialog("close");
}
function TerminaCap() {
    var strMes = document.getElementById("ERR_MES").value;
    var strEquipo = document.getElementById("ERR_EQUIPO").value;
    var strAnio = document.getElementById("ERR_ANIO").value;
    var strPost = "";
    if (strEquipo != "0") {
        if (strAnio != "") {
            strPost = "mes=" + strMes;
            strPost += "&grupo=" + strEquipo;
            strPost += "&anio=" + strAnio;
            $("#dialogWait").dialog("open");
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Error_base.jsp?id=3",
                success: function (datos) {
                    $("#dialogWait").dialog("close");
                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
                }
            });
        } else {
            alert("Ingresa el año que se va a listar");
        }
    } else {
        alert("selecciona un equipo");
    }
}
function printErroBase() {
    var strMes = document.getElementById("ERR_MES").value;
    var strEquipo = document.getElementById("ERR_EQUIPO").value;
    var strAnio = document.getElementById("ERR_ANIO").value;
    Abrir_Link("JasperReport?REP_ID=505&boton_1=PDF&CURSO=" + idCurso, '_reporte', 500, 600, 0, 0);
}