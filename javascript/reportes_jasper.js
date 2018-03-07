var itemIdCont = 0;
function reportes_jasper() {
}
var _OperParams = "";
var Ventana = "";
function DesactivaPopUp() {
    var objMainFacPedi = objMap.getScreen(Ventana);
    objMainFacPedi.bolActivo = false;
    objMainFacPedi.bolMain = false;
    objMainFacPedi.bolInit = false;
    objMainFacPedi.idOperAct = 0;
}
function UpFileReport(strNomFile) {
    ValidaClean(strNomFile);
    if (document.getElementById(strNomFile).value == "") {
        ValidaShow(strNomFile, lstMsg[13]);
        return false;
    }
    var strExtencion = Right(document.getElementById(strNomFile).value.toUpperCase(), 5);
    if (strExtencion == "jrxml" || strExtencion == "JRXML") {
        ajaxImageUploadReport(strNomFile);
        return true;
    } else {
        ValidaShow(strNomFile, "Formato no valido solo: *.jrxml");
        return false;
    }
    return true;
}
function ajaxImageUploadReport(strNomFile) {
    $("#dialogWait").dialog("open");
    $.ajaxFileUpload({url: "ERP_UPJReport.jsp", secureuri: false, fileElementId: strNomFile, dataType: "json", success: function (data, status) {
            if (typeof (data.error) != "undefined") {
                if (data.error != "") {
                    alert(data.error);
                }
            }
            $("#dialogWait").dialog("close");
            alert("Imagen guardada Correctamente!");
            var pieces = document.getElementById(strNomFile).value.split("\\");
            var filename = pieces[pieces.length - 1];
            document.getElementById("REP_JRXML").value = filename;
        }, error: function (data, status, e) {
            alert(e);
            $("#dialogWait").dialog("close");
        }});
    return false;
}
function InitParams() {
    setTimeout("LoadGridParams();", 2 * 1000);
    if (document.getElementById("REP_ID").value == "0") {
        document.getElementById("REP_ADD_PAR").style.display = "none";
        document.getElementById("REP_MOD_PAR").style.display = "none";
        document.getElementById("REP_DEL_PAR").style.display = "none";
    } else {
        document.getElementById("REP_ADD_PAR").style.display = "block";
        document.getElementById("REP_MOD_PAR").style.display = "block";
        document.getElementById("REP_DEL_PAR").style.display = "block";
    }
}
function LoadGridParams() {
    var grid = jQuery("#GRD_PARAM");
    grid.setGridParam({url: "ReportesJasper.jsp?id=4&IdRepo=" + document.getElementById("REP_ID").value});
    grid.setGridParam({sortname: "IdRepo"}).trigger("reloadGrid");
}
function AddParams() {
    _OperParams = "_new";
    if (document.getElementById("_REP_ID") != null) {
        IniCaptura();
        $("#dialog").dialog("open");
    } else {
        OpnOpt("PARAM_ADD", null, "dialog", false, false);
    }
}
function AddParamsSave() {
    var ID_REPP = document.getElementById("_REPP_ID").value;
    var ID_REP = document.getElementById("REP_ID").value;
    var Nombre = document.getElementById("_REPP_NOMBRE").value;
    var Variable = document.getElementById("_REPP_VARIABLE").value;
    var Tipo = document.getElementById("_REPP_TIPO").value;
    var Dato = document.getElementById("_REPP_DATO").value;
    var Tabla = document.getElementById("_REPP_TABLAEXT").value;
    var Envio = document.getElementById("_REPP_ENVIO").value;
    var Mostrar = document.getElementById("_REPP_MOSTRAR").value;
    var Post = document.getElementById("_REPP_POST").value;
    var Pre = d.getElementById("_REPP_PRE").value;
    var Default = d.getElementById("_REPP_DEFAULT").value;
    var strPOST = "&REPP_ID=" + ID_REPP;
    strPOST += "&REP_ID=" + ID_REP;
    strPOST += "&REPP_NOMBRE=" + Nombre;
    strPOST += "&REPP_VARIABLE=" + Variable;
    strPOST += "&REPP_TIPO=" + Tipo;
    strPOST += "&REPP_DATO=" + Dato;
    strPOST += "&REPP_TABLAEXT=" + Tabla;
    strPOST += "&REPP_ENVIO=" + Envio;
    strPOST += "&REPP_MOSTRAR=" + Mostrar;
    strPOST += "&REPP_POST=" + Post;
    strPOST += "&REPP_PRE=" + Pre;
    strPOST += "&REPP_DEFAULT=" + Default;
    if (_OperParams == "_new") {
        $.ajax({type: "POST", data: strPOST, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "ReportesJasper.jsp?id=1", success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    alert("Se ha guardado correctamente.");
                    $("#dialog").dialog("close");
                    var grid2 = jQuery("#GRD_PARAM");
                    grid2.trigger("reloadGrid");
                } else {
                    alert(datos.substring(0, 2));
                }
            }, error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }});
    } else {
        $.ajax({type: "POST", data: strPOST, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "ReportesJasper.jsp?id=2", success: function (datos) {
                if (datos.substring(0, 2) == "OK") {
                    alert("Se ha guardado correctamente.");
                    $("#dialog").dialog("close");
                    var grid2 = jQuery("#GRD_PARAM");
                    grid2.trigger("reloadGrid");
                } else {
                    alert(datos.substring(0, 2));
                }
            }, error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }});
    }
}
function EvalTipoEdit() {
}
function ModParams() {
    _OperParams = "_mod";
    var grid = jQuery("#GRD_PARAM");
    if (grid.getGridParam("selrow") != null) {
        if (document.getElementById("_REP_ID") != null) {
            IniCaptura();
            $("#dialog").dialog("open");
        } else {
            OpnOpt("PARAM_ADD", null, "dialog", false, false);
        }
    } else {
        alert("Seleccione un Parametro");
    }
}
function DelParams() {
    var grid = jQuery("#GRD_PARAM");
    if (grid.getGridParam("selrow") != null) {
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var strDes = lstRow.REPP_ID;
        if (confirm("¿Confirma que desea borrar la aprtida de" + " " + strDes)) {
            var strPost = "&REPP_ID=" + strDes;
            $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "ReportesJasper.jsp?id=3", success: function (datos) {
                    if (datos.substring(0, 2) == "OK") {
                        alert("Se ha eliminado correctamente.");
                        var grid2 = jQuery("#GRD_PARAM");
                        grid2.trigger("reloadGrid");
                    }
                }, error: function (objeto, quepaso, otroobj) {
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }});
        }
    } else {
        alert("Seleccione un Parametro");
    }
}
function MakeReport() {
    var grid = jQuery("#REPO");
    if (grid.getGridParam("selrow") != null) {
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        $("#dialogWait").dialog("open");
        var strPOST = "IdRepo=" + lstRow.REP_ID;
        $.ajax({type: "POST", data: encodeURI(strPOST), scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "ReportesView.jsp?java=false", success: function (dato) {
                $("#dialogWait").dialog("close");
                $("#dialogRepo").dialog("option", "title", "Emision de reportes iReport");
                document.getElementById("dialogRepo_inside").innerHTML = dato;
                $("#dialogRepo").dialog("open");
                InitJSRepo_View();
            }, error: function (objeto, quepaso, otroobj) {
                alert(":Repo Make:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }});
    }
}
function InitJSRepo_View() {
    var strListDates = document.getElementById("list_dates").value;
    var lstDates = strListDates.split(",");
    for (var i = 0; i < lstDates.length; i++) {
        if (lstDates[i] != "") {
            $("#" + lstDates[i]).datepicker({changeMonth: true, changeYear: true});
        }
    }
}
function jReportHtml() {
    var grid = jQuery("#REPO");
    if (grid.getGridParam("selrow") != null) {
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        $("#dialogWait").dialog("open");
        var strPOST = "REP_ID=" + lstRow.REP_ID + "&boton_1=HTML";
        var strListVars = document.getElementById("list_vars").value;
        var strListTypes = document.getElementById("list_types").value;
        var lstVars = strListVars.split(",");
        var lstTypes = strListTypes.split(",");
        for (var i = 0; i < lstVars.length; i++) {
            if (lstVars[i] != "") {
                if (lstTypes[i] == "PanelCheck") {
                    var intContaPanel = document.getElementById("conta_" + lstVars[i]).value;
                    var strValues = "";
                    var intContaElems_ = 0;
                    for (var U = 1; U <= intContaPanel; U++) {
                        var elem = document.getElementById(U + "_" + lstVars[i]);
                        if (elem.checked) {
                            intContaElems_++;
                            if (intContaElems_ == 1) {
                                strValues += elem.value;
                            } else {
                                strValues += "," + elem.value;
                            }
                        }
                    }
                    if (strValues == "") {
                        strValues = "0";
                    }
                    strPOST += "&" + lstVars[i] + "=" + strValues;
                } else {
                    if (lstTypes[i] == "radio") {
                        if (document.getElementById(lstVars[i] + "_1").checked) {
                            strPOST += "&" + lstVars[i] + "=1";
                        } else {
                            strPOST += "&" + lstVars[i] + "=0";
                        }
                    } else {
                        strPOST += "&" + lstVars[i] + "=" + document.getElementById(lstVars[i]).value;
                    }
                }
            }
        }
        $.ajax({type: "POST", data: encodeURI(strPOST), scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "JasperReport", success: function (dato) {
                $("#dialogWait").dialog("close");
                document.getElementById("content_html").innerHTML = dato;
            }, error: function (objeto, quepaso, otroobj) {
                alert(":Repo Html:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }});
    }
}
function IniCaptura() {
    document.getElementById("_REP_ID").value = document.getElementById("REP_ID").value;
    if (_OperParams == "_new") {
        document.getElementById("_REPP_ID").value = "";
        document.getElementById("_REP_ID").value = "";
        document.getElementById("_REPP_NOMBRE").value = "";
        document.getElementById("_REPP_VARIABLE").value = "";
        document.getElementById("_REPP_TIPO").value = "";
        document.getElementById("_REPP_DATO").value = "";
        document.getElementById("_REPP_TABLAEXT").value = "";
        document.getElementById("_REPP_ENVIO").value = "";
        document.getElementById("_REPP_MOSTRAR").value = "";
        document.getElementById("_REPP_POST").value = "";
        document.getElementById("_REPP_PRE").value = "";
        document.getElementById("_REPP_DEFAULT").value = "";
    } else {
        var grid = jQuery("#GRD_PARAM");
        if (grid.getGridParam("selrow") != null) {
            var id = grid.getGridParam("selrow");
            var lstRow = grid.getRowData(id);
            var REPP_ID = lstRow.REPP_ID;
            var REP_ID = lstRow.REP_ID;
            var REPP_NOMBRE = lstRow.REPP_NOMBRE;
            var REPP_VARIABLE = lstRow.REPP_VARIABLE;
            var REPP_TIPO = lstRow.REPP_TIPO;
            var REPP_DATO = lstRow.REPP_DATO;
            var REPP_TABLAEXT = lstRow.REPP_TABLAEXT;
            var REPP_ENVIO = lstRow.REPP_ENVIO;
            var REPP_MOSTRAR = lstRow.REPP_MOSTRAR;
            var REPP_POST = lstRow.REPP_POST;
            var REPP_PRE = lstRow.REPP_PRE;
            var REPP_DEFAULT = lstRow.REPP_DEFAULT;
            document.getElementById("_REPP_ID").value = REPP_ID;
            document.getElementById("_REP_ID").value = REP_ID;
            document.getElementById("_REPP_NOMBRE").value = REPP_NOMBRE;
            document.getElementById("_REPP_VARIABLE").value = REPP_VARIABLE;
            document.getElementById("_REPP_TIPO").value = REPP_TIPO;
            document.getElementById("_REPP_DATO").value = REPP_DATO;
            document.getElementById("_REPP_TABLAEXT").value = REPP_TABLAEXT;
            document.getElementById("_REPP_ENVIO").value = REPP_ENVIO;
            document.getElementById("_REPP_MOSTRAR").value = REPP_MOSTRAR;
            document.getElementById("_REPP_POST").value = REPP_POST;
            document.getElementById("_REPP_PRE").value = REPP_PRE;
            document.getElementById("_REPP_DEFAULT").value = REPP_DEFAULT;
        } else {
            alert("Seleccione un Parametro");
        }
    }
}
function MakeReportInside(idRepo, strParams, strParamsValues, strParamReadOnly) {
    $("#dialogWait").dialog("open");
    var strPOST = "InsideRepo=1&IdRepo=" + idRepo + "&ParamName=" + strParams + "&ParamValue=" + strParamsValues + "&ParamReadOnly=" + strParamReadOnly;
    $.ajax({type: "POST", data: encodeURI(strPOST), scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "ReportesView.jsp?java=false", success: function (dato) {
            $("#dialogWait").dialog("close");
            $("#dialogRepo").dialog("option", "title", "Emision de reportes iReport");
            document.getElementById("dialogRepo_inside").innerHTML = dato;
            $("#dialogRepo").dialog("open");
            InitJSRepo_View();
        }, error: function (objeto, quepaso, otroobj) {
            alert(":Repo Make:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }});
}
function jReportHtmlInside(idRepo) {
    $("#dialogWait").dialog("open");
    var strPOST = "REP_ID=" + idRepo + "&boton_1=HTML";
    var strListVars = document.getElementById("list_vars").value;
    var strListTypes = document.getElementById("list_types").value;
    var lstVars = strListVars.split(",");
    var lstTypes = strListTypes.split(",");
    for (var i = 0; i < lstVars.length; i++) {
        if (lstVars[i] != "") {
            if (lstTypes[i] == "PanelCheck") {
                var intContaPanel = document.getElementById("conta_" + lstVars[i]).value;
                var strValues = "";
                var intContaElems_ = 0;
                for (var U = 1; U <= intContaPanel; U++) {
                    var elem = document.getElementById(U + "_" + lstVars[i]);
                    if (elem.checked) {
                        intContaElems_++;
                        if (intContaElems_ == 1) {
                            strValues += elem.value;
                        } else {
                            strValues += "," + elem.value;
                        }
                    }
                }
                if (strValues == "") {
                    strValues = "0";
                }
                strPOST += "&" + lstVars[i] + "=" + strValues;
            } else {
                if (lstTypes[i] == "radio") {
                    if (document.getElementById(lstVars[i] + "_1").checked) {
                        strPOST += "&" + lstVars[i] + "=1";
                    } else {
                        strPOST += "&" + lstVars[i] + "=0";
                    }
                } else {
                    strPOST += "&" + lstVars[i] + "=" + document.getElementById(lstVars[i]).value;
                }
            }
        }
    }
    $.ajax({type: "POST", data: encodeURI(strPOST), scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "JasperReport", success: function (dato) {
            $("#dialogWait").dialog("close");
            document.getElementById("content_html").innerHTML = dato;
        }, error: function (objeto, quepaso, otroobj) {
            alert(":Repo Html:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }});
}
function _Jdrill_drop(IdRepo, strParams) {
    alert("Nuevo reporte..." + strParams);
    Abrir_Link("JasperReport?REP_ID=" + IdRepo + "&boton_1=PDF&" + strParams, "_reporte", 500, 600, 0, 0);
}
/**
 * abir calendario de cursos
 * @returns {undefined}
 */
function OpnCalendarioCurso() {
    window.open("COFIDE_Calendario_cursos.jsp", '_blank');
}