function cofide_evaluacion() {
}
function initEvCofide() {
    HoraActual();
    setTimeout("LoadGridEjecutivo()", 1000);
    continuarPaso(0);
    HtmlBtn();
}
function HoraActual() {
    $("#dialogWait").dialog("open");
    $.ajax({type: "POST", data: "", scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Evaluacion.jsp?ID=1", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_evaluacion")[0];
            var lstCBase = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCBase.length; i++) {
                var objcbase = lstCBase[i];
                document.getElementById("CE_HORAREG").value = objcbase.getAttribute("CE_HORAREG");
                document.getElementById("CE_ID_GTRABAJO").value = objcbase.getAttribute("US_GRUPO");
                document.getElementById("CE_GTRABAJO").value = objcbase.getAttribute("CG_DESCRIPCION");
                document.getElementById("EV_PENDIENTES_TMP").value = objcbase.getAttribute("CG_NUM_EVALUACION");
            }
        }});
}
function EvaluacionCursos() {
    var intPregunta1 = 0;
    var intPregunta2 = 0;
    var intPregunta3 = 0;
    var intPregunta4 = 0;
    var intPregunta5 = 0;
    var intPregunta6 = 0;
    var intPregunta7 = 0;
    var intPregunta8 = 0;
    var intCalificacion = 0;
    if (d.getElementById("CE_PREGUNTA11").checked) {
        intPregunta1 = 1;
    }
    if (d.getElementById("CE_PREGUNTA21").checked) {
        intPregunta2 = 1;
    }
    if (d.getElementById("CE_PREGUNTA31").checked) {
        intPregunta3 = 1;
    }
    if (d.getElementById("CE_PREGUNTA41").checked) {
        intPregunta4 = 1;
    }
    if (d.getElementById("CE_PREGUNTA51").checked) {
        intPregunta5 = 1;
    }
    if (d.getElementById("CE_PREGUNTA52").checked) {
        intPregunta5 = 2;
    }
    if (d.getElementById("CE_PREGUNTA61").checked) {
        intPregunta6 = 1;
    }
    if (d.getElementById("CE_PREGUNTA62").checked) {
        intPregunta6 = 2;
    }
    if (d.getElementById("CE_PREGUNTA71").checked) {
        intPregunta7 = 1;
    }
    if (d.getElementById("CE_PREGUNTA81").checked) {
        intPregunta8 = 1;
    }
    intCalificacion = intPregunta1 + intPregunta2 + intPregunta3 + intPregunta4 + intPregunta5 + intPregunta6 + intPregunta7 + intPregunta8;
    d.getElementById("CE_CALIF").value = intCalificacion;
}

function LoadGridEjecutivo() {
    var itemIdCob = 0;
    var strId_Ejecutivo = "";
    var strEjecutivo = "";
    var intEvalua = "";
    var strIP = "";
    var strExt = "";
    var intGTrabajo = document.getElementById("CE_ID_GTRABAJO").value;
    var intEvPendiente = document.getElementById("EV_PENDIENTES_TMP").value;
    var strPost = "";
    strPost += "CE_ID_GTRABAJO=" + intGTrabajo;
    strPost += "&EV_PENDIENTES_TMP=" + intEvPendiente;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Evaluacion.jsp?ID=2", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_evaluacion")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                strId_Ejecutivo = objcte.getAttribute("id_usuarios");
                strEjecutivo = objcte.getAttribute("nombre_usuario");
                intEvalua = objcte.getAttribute("EVALUACIONES");
                strIP = objcte.getAttribute("IP_ADDRESS");
                strExt = objcte.getAttribute("EXTENSION");
                var datarow = {DEV_ID: strId_Ejecutivo, DEV_NOMBRE: strEjecutivo, DEV_EVALUACION: intEvalua, DEV_IP: strIP, DEV_EXT: strExt};
                itemIdCob++;
                jQuery("#GRID_USRTMK").addRowData(itemIdCob, datarow, "last");
            }
        }});
    $("#dialogWait").dialog("close");
}
function SelEvaluacion(numPaso) {
    var grid = jQuery("#GRID_USRTMK");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intIdCC = lstRow1.DEV_ID;
        var strNombre = lstRow1.DEV_NOMBRE;
        var intEvaluacion = lstRow1.DEV_EVALUACION;
        var intResEv = parseInt(intEvaluacion);
        if (intResEv > 0) {
            continuarPaso(numPaso);
            document.getElementById("CE_ID_USER").value = intIdCC;
            document.getElementById("EV_USER").value = strNombre;
            document.getElementById("EV_PEN").value = intEvaluacion;
        } else {
            alert("Ya No Tiene Mas Evaluaciones Disponibles");
        }
    } else {
        alert("Selecciona un Ejecutivo a Evaluar");
    }
}
function saveEval(numPaso) {
    var intId = document.getElementById("CE_ID_USER").value;
    var struser = document.getElementById("EV_USER").value;
    var strFecha = document.getElementById("EV_FECHA").value;
    var intEvPen = document.getElementById("EV_PEN").value;
    var strHora = document.getElementById("CE_HORAREG").value;
    var intLlamadas = document.getElementById("CE_NUM_LLAMADA").value;
    var intPregunta1 = 0;
    var intPregunta2 = 0;
    var intPregunta3 = 0;
    var intPregunta4 = 0;
    var intPregunta5 = 0;
    var intPregunta6 = 0;
    var intPregunta7 = 0;
    var intPregunta8 = 0;
    var intMsj = 0;
    var intTMK = 0;
    var intRef = 0;
    var intInCompany = 0;
    var intCalificacion = 0;
    if (d.getElementById("CE_PREGUNTA11").checked) {
        intPregunta1 = 1;
    }
    if (d.getElementById("CE_PREGUNTA21").checked) {
        intPregunta2 = 1;
    }
    if (d.getElementById("CE_PREGUNTA31").checked) {
        intPregunta3 = 1;
    }
    if (d.getElementById("CE_PREGUNTA41").checked) {
        intPregunta4 = 1;
    }
    if (d.getElementById("CE_PREGUNTA51").checked) {
        intPregunta5 = 2;
    }
    if (d.getElementById("CE_PREGUNTA61").checked) {
        intPregunta6 = 2;
    }
    if (d.getElementById("CE_PREGUNTA71").checked) {
        intPregunta7 = 1;
    }
    if (d.getElementById("CE_PREGUNTA81").checked) {
        intPregunta8 = 1;
    }
    var intCalif = document.getElementById("CE_CALIF").value;
    if (d.getElementById("CE_MSG1").checked) {
        intMsj = 1;
    }
    if (d.getElementById("CE_CAMP_TMK1").checked) {
        intTMK = 1;
    }
    if (d.getElementById("CE_REF1").checked) {
        intRef = 1;
    }
    if (d.getElementById("CE_INCOMPANY1").checked) {
        intInCompany = 1;
    }
    var intReg = document.getElementById("CE_REG_PEN").value;
    var strObs = document.getElementById("CE_OBSERVACION").value;
    var intGtrabajo = document.getElementById("CE_ID_GTRABAJO").value;
    var strGTrabajo = document.getElementById("CE_GTRABAJO").value;
    var strPost = "";
    strPost += "CE_ID_USER=" + intId;
    strPost += "&EV_USER= " + struser;
    strPost += "&EV_FECHA= " + strFecha;
    strPost += "&EV_PEN= " + intEvPen;
    strPost += "&CE_HORAREV= " + strHora;
    strPost += "&CE_NUM_LLAMADA= " + intLlamadas;
    strPost += "&CE_PREGUNTA1= " + intPregunta1;
    strPost += "&CE_PREGUNTA2= " + intPregunta2;
    strPost += "&CE_PREGUNTA3= " + intPregunta3;
    strPost += "&CE_PREGUNTA4= " + intPregunta4;
    strPost += "&CE_PREGUNTA5= " + intPregunta5;
    strPost += "&CE_PREGUNTA6= " + intPregunta6;
    strPost += "&CE_PREGUNTA7= " + intPregunta7;
    strPost += "&CE_PREGUNTA8= " + intPregunta8;
    strPost += "&CE_CALIF= " + intCalif;
    strPost += "&CE_MSG= " + intMsj;
    strPost += "&CE_CAMP_TMK= " + intTMK;
    strPost += "&CE_REF= " + intRef;
    strPost += "&CE_INCOMPANY= " + intInCompany;
    strPost += "&CE_REG_PEN= " + intReg;
    strPost += "&CE_OBSERVACION= " + strObs;
    strPost += "&CE_ID_GTRABAJO= " + intGtrabajo;
    strPost += "&CE_GTRABAJO= " + strGTrabajo;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Evaluacion.jsp?ID=3"});
    continuarPaso(numPaso);
    jQuery("#GRID_USRTMK").clearGridData();
    LoadGridEjecutivo();
    ResetEvaluacion();
}
/**Avanza al siguiente paso*/
function continuarPaso(numPaso) {
    if (numPaso == 0) {
        TabsMapFactCofide("0", true, "TMK_USR");
        $("#tabsTMK_USR").tabs("option", "active", 0);
        TabsMapFactCofide("1", false, "TMK_USR");
    }
    if (numPaso == 1) {
        TabsMapFactCofide("1", true, "TMK_USR");
        $("#tabsTMK_USR").tabs("option", "active", 1);
        TabsMapFactCofide("0", false, "TMK_USR");
        setTimeout("CuentaLlamada()", 1000);
    }
}
function TabsMapFactCofide(lstTabs, bolActivar, strNomTab) {
    var arrTabs = lstTabs.split(",");
    for (var i = 0; i < arrTabs.length; i++) {
        if (bolActivar) {
            $("#tabs" + strNomTab).tabs("enable", parseInt(arrTabs[i]));
        } else {
            $("#tabs" + strNomTab).tabs("disable", parseInt(arrTabs[i]));
        }
    }
}
function ResetEvaluacion() {
    document.getElementById("CE_NUM_LLAMADA").value = "";
    document.getElementById("CE_CALIF").value = "";
    document.getElementById("CE_REG_PEN").value = "";
    document.getElementById("CE_OBSERVACION").value = "";
    $("#CE_PREGUNTA12").prop("checked", true);
    $("#CE_PREGUNTA22").prop("checked", true);
    $("#CE_PREGUNTA32").prop("checked", true);
    $("#CE_PREGUNTA42").prop("checked", true);
    $("#CE_PREGUNTA52").prop("checked", true);
    $("#CE_PREGUNTA62").prop("checked", true);
    $("#CE_PREGUNTA72").prop("checked", true);
    $("#CE_PREGUNTA82").prop("checked", true);
    $("#CE_MSG2").prop("checked", true);
    $("#CE_CAMP_TMK2").prop("checked", true);
    $("#CE_REF2").prop("checked", true);
    $("#CE_INCOMPANY2").prop("checked", true);
}
function ViewUsr() {
    var grid = jQuery("#GRID_USRTMK");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var strIP = lstRow1.DEV_IP;
        if (strIP != "") {
            ExtAgente();
            var strPost = "direccion_ip=" + strIP;
            $("#dialogWait").dialog("open");
            Abrir_Link("COFIDE_ver_tmk_cam.jsp?ID=1&direccion_ip=" + strIP, "_blank", 400, 300, 0, 0);
            $("#dialogWait").dialog("close");
        } else {
            alert("Este agente no tiene una Direccion Ip configurada!");
        }
    } else {
        alert("Selecciona Alguna Plantilla para Confirmar");
    }
}
function HtmlBtn() {
    var strHtmlBtnMon = "<table border='0' width='0%' align='center'>" + "<tr>" + '<td align="center"><a href="javascript:ViewUsr()" class=\'cofide_evaluacion\'><i class = "fa fa-video-camera" title="Monitoreo" style="font-size:60px; width:110px"></i></td>' + "</tr>";
    "</table>";
    var strHtmlBtnEv = "<table border='0' width='0%' align='center'>" + "<tr>" + '<td align="center"><a href="javascript:SelEvaluacion(1)" class=\'cofide_evaluacion\'><i class = "fa fa-check-circle" title="Evaluación" style="font-size:60px; width:110px"></i></td>' + "</tr>";
    "</table>";
    document.getElementById("EV_SUPBTN").innerHTML = strHtmlBtnMon;
    document.getElementById("EV_EVALUARBTN").innerHTML = strHtmlBtnEv;
}
function ExtAgente() {
    var grid = jQuery("#GRID_USRTMK");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intIdCC = lstRow1.DEV_ID;
        var intExt = lstRow1.DEV_EXT;
        if (intExt != "") {
            var strHtmlBtnCall = "<table border='0' width='0%' align='center'>" + "<tr>" + '<td align="center"><a href="sip:*9' + intExt + '" class=\'cofide_evaluacion\'><i class = "fa fa-volume-up" title="Llamada" style="font-size:60px; width:110px"></i></td>' + "</tr>";
            "</table>";
            document.getElementById("EV_REVBTN").innerHTML = strHtmlBtnCall;
        } else {
            alert("No se Encuentra la Extensión");
        }
    } else {
    }
}
function CuentaLlamada() {
    var intId_Usr = document.getElementById("EV_USER").value;
    var strLlamada = "";
    var strPost = "EV_USER=" + intId_Usr;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Evaluacion.jsp?ID=4",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_evaluacion")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                //recuperamos datos del jsp
                strLlamada = objcte.getAttribute("llamadas");
            }
            document.getElementById("CE_NUM_LLAMADA").value = strLlamada;
        } //fin de la funcion que recupera los datos
    });
}