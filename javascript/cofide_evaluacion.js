var timeTimer;
function cofide_evaluacion() {
}
function initEvCofide() {
    $('#EV_FECHA').datepicker("disable");
    HoraActual();
    continuarPaso(0);
    HtmlBtn();
    clearTimeout(timeTimer);
}
function HoraActual() {
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Evaluacion.jsp?ID=1",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_evaluacion")[0];
            var lstCBase = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCBase.length; i++) {
                var objcbase = lstCBase[i];
                document.getElementById("CE_HORAREG").value = objcbase.getAttribute("CE_HORAREG");
                document.getElementById("CE_ID_GTRABAJO").value = objcbase.getAttribute("US_GRUPO");
                document.getElementById("CE_GTRABAJO").value = objcbase.getAttribute("CG_DESCRIPCION");
                document.getElementById("EV_PENDIENTES_TMP").value = objcbase.getAttribute("CG_NUM_EVALUACION");
            }
//            setTimeout("LoadGridEjecutivo()", 1000);
            LoadGridEjecutivo();
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
    var intPregunta9 = 0;
    var intPregunta10 = 0;
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
    if (d.getElementById("CE_PREGUNTA91").checked) {
        intPregunta9 = 1;
    }
    if (d.getElementById("CE_PREGUNTA101").checked) {
        intPregunta10 = 1;
    }
    intCalificacion = intPregunta1 + intPregunta2 + intPregunta3 + intPregunta4 + intPregunta5 + intPregunta6 + intPregunta7 + intPregunta8 + intPregunta9 + intPregunta10;
    d.getElementById("CE_CALIF").value = intCalificacion;
}

function LoadGridEjecutivo() {

    var strId_Ejecutivo = "";
    var strEjecutivo = "";
    var intEvalua = "";
    var strIP = "";
    var strExt = "0";
    var intNLlamada = "";
    var strBase = "";
    var strRegistro = "";
    var strExp = "";
    var strPros = "";
    var strNota = "";
    var strReserva = "";
    var strCobro = "";
    var strMeta = "";
    var strFac = "";
    var intGTrabajo = document.getElementById("CE_ID_GTRABAJO").value;
    var intEvPendiente = document.getElementById("EV_PENDIENTES_TMP").value;
    var strPost = "";
    strPost += "CE_ID_GTRABAJO=" + intGTrabajo;
    strPost += "&EV_PENDIENTES_TMP=" + intEvPendiente;
    //tabla
    var strHtmlTabla = "";
    var strStyle = "<style>"
            + "body{font-family: verdana 16px;}"
            + ".fondoTabla{background-color: #E6E6E6;}"
            + ".table1{width: 70%;border: black 1px solid;margin: auto; border-collapse: collapse;  background-color: #E6E6E6;}"
            + ".tr1{border: black 1px solid;border-collapse: collapse; }"
            + ".td1{border: black 1px solid;border-collapse: collapse; }"
            + ".ejecutivo{font-size: 25px;color: #FF8000;}"
            + ".CenterText{text-align: center;}"
            + ".able{color: #00D827;}"
            + ".disable{color: gray;}"
            + ".oks{font-size: 11px;color: #FF8000;}"
            + ".wait{font-size: 11px;color: #00D827;}"
            + ".divTable{width: 1200px;}"
            + "</style>";
    var strTabla = "<div class='divTable'>"
            + "<table class='table1 CenterText'>";
    var strContenido = "";
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Evaluacion.jsp?ID=2",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_evaluacion")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                strId_Ejecutivo = objcte.getAttribute("id_usuarios");
                strEjecutivo = objcte.getAttribute("nombre_usuario");
                intEvalua = objcte.getAttribute("EVALUACIONES");
                strIP = objcte.getAttribute("IP_ADDRESS");
                strExt = objcte.getAttribute("EXTENSION");
                intNLlamada = objcte.getAttribute("LLAMADA");
                strBase = objcte.getAttribute("BASE");
                strRegistro = objcte.getAttribute("REGISTRO");
                strExp = objcte.getAttribute("EXP");
                strPros = objcte.getAttribute("PROS");
                strNota = objcte.getAttribute("NOTA");
                strReserva = objcte.getAttribute("RESERVA");
                strCobro = objcte.getAttribute("COBRO");
                strMeta = objcte.getAttribute("META");
                strFac = objcte.getAttribute("FACTURA");

                strContenido += "<tr class='tr1'>"
                        + "<td class=' td1 ejecutivo CenterText'>"
                        + "<div class='ejecutivo' title='Elige un ejecutivo' onclick='DatosMonitoreo(" + strExt + "," + intEvalua + ",\"" + strIP + "\",\"" + strEjecutivo + "\"," + strId_Ejecutivo + ")'>"
                        + strEjecutivo + "</div>"
                        + "</td>"
                        + "<td class='td1'>"
                        + "<table class='CenterText'>"
                        + "<tr><td colspan='2'>" + strBase + "</td></tr>"
                        + "<tr><td colspan='2'>Total Reg.: " + strRegistro + "</td></tr>"
                        + "<tr>"
                        + "<td><i class='fa fa-user able'></i> " + strExp + " </td>"
                        + "<td><i class='fa fa-user disable'></i> " + strPros + "</td>"
                        + "</tr>"
                        + "</table>"
                        + "</td>"
                        + "<td class='td1' style='width: 80px'>"
                        + "<table class='CenterText'>"
                        + "<tr>"
                        + "<td><i class='fa fa-phone'></i> " + intNLlamada + "</td>"
                        + "</tr>"
                        + "<tr>"
                        + "<td><i class='fa fa-commenting-o'></i> " + strNota + "</td>"
                        + "</tr>"
                        + "</table>"
                        + "</td>"
                        + "<td class='td1'><div class='wait'>importe vendido</div>"
                        + "<br>"
                        + "<i class='fa fa-shopping-cart able'></i> " + strReserva + ""
                        + "</td>"
                        + "<td class='td1'><div class='oks'>importe facturado</div>"
                        + "<br>"
                        + "<i class='fa fa-file-text-o disable'></i> " + strFac + ""
                        + "</td>"
                        + "<td class='td1'><div class='oks'>importe cobrado </div>"
                        + "<br>"
                        + "<i class='fa fa-usd able'></i> " + strCobro + ""
                        + "</td>"
                        + "<td class='td1'><div class='wait'>importe meta</div>"
                        + "<br>"
                        + "<i class='fa fa-star-o disable'></i> " + strMeta + ""
                        + "</td>"
                        + "</tr>";
            }
            var strTablaFin = "</table>"
            "</div>";
            strHtmlTabla = strStyle + strTabla + strContenido + strTablaFin;
            document.getElementById("CE_TABLE").innerHTML = strHtmlTabla;
        }});
    $("#dialogWait").dialog("close");
    timeTimer = setTimeout('LoadGridEjecutivo()', 1800000);
}
function SelEvaluacion(numPaso) {
    ResetEvaluacion();
    var strId = document.getElementById("CE_ID_EJECUTIVO").value;
    var strNombre = document.getElementById("CE_NOMBRE").value;
    var intEvaluaciones = document.getElementById("CE_EVALUACIONES").value;

    if (strId != "") {

        var intResEv = parseInt(intEvaluaciones);
        if (intResEv > 0) {
            continuarPaso(numPaso);
            document.getElementById("CE_ID_USER").value = strId;
            document.getElementById("EV_USER").value = strNombre;
            document.getElementById("EV_PEN").value = intEvaluaciones;
        } else {
            alert("Ya No Tiene Mas Evaluaciones Disponibles");
        }
    } else {
        alert("Selecciona un Ejecutivo a Evaluar");
    }
}
function ManualEvaluacion() {
    var intCalificacion = document.getElementById("CE_CALIF");
    intCalificacion.value = "";
    var bolManual = document.getElementById("EV_MANUAL").checked;
    if (bolManual) {
        intCalificacion.readOnly = false;
        intCalificacion.style["background"] = "none";
        intCalificacion.style["color"] = "#000000";
        intCalificacion.focus();
        $("#CE_PREGUNTA10").prop("checked", true);
        $("#CE_PREGUNTA20").prop("checked", true);
        $("#CE_PREGUNTA30").prop("checked", true);
        $("#CE_PREGUNTA40").prop("checked", true);
        $("#CE_PREGUNTA50").prop("checked", true);
        $("#CE_PREGUNTA60").prop("checked", true);
        $("#CE_PREGUNTA70").prop("checked", true);
        $("#CE_PREGUNTA80").prop("checked", true);
        $("#CE_PREGUNTA90").prop("checked", true);
        $("#CE_PREGUNTA100").prop("checked", true);
    } else {
        intCalificacion.style["background"] = "#e0f8e6";
        intCalificacion.readOnly = true;
        intCalificacion.value = "";
    }
}
function saveEval(numPaso) {
    document.getElementById("CE_REG_PEN").value = 0;
    document.getElementById("CE_CALIF").value = 0;
    var bolManual = document.getElementById("EV_MANUAL").checked;
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
    var intPregunta9 = 0;
    var intPregunta10 = 0;
    var intMsj = 0;
    var intTMK = 0;
    var intRef = 0;
    var intInCompany = 0;
    var intCalificacion = 0;
    if (!bolManual) { //si es false, dara a todos en cero y pondra activo el de calificacion para darlo manual
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
        if (d.getElementById("CE_PREGUNTA91").checked) {
            intPregunta9 = 1;
        }
        if (d.getElementById("CE_PREGUNTA101").checked) {
            intPregunta10 = 1;
        }
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
    strPost += "&CE_PREGUNTA9= " + intPregunta9;
    strPost += "&CE_PREGUNTA10= " + intPregunta10;
    strPost += "&CE_CALIF= " + intCalif;
    strPost += "&CE_MSG= " + intMsj;
    strPost += "&CE_CAMP_TMK= " + intTMK;
    strPost += "&CE_REF= " + intRef;
    strPost += "&CE_INCOMPANY= " + intInCompany;
    strPost += "&CE_REG_PEN= " + intReg;
    strPost += "&CE_OBSERVACION= " + strObs;
    strPost += "&CE_ID_GTRABAJO= " + intGtrabajo;
    strPost += "&CE_GTRABAJO= " + strGTrabajo;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Evaluacion.jsp?ID=3"
    });
    continuarPaso(numPaso);
//    jQuery("#GRID_USRTMK").clearGridData();
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
    document.getElementById("CE_ID_USER").value = "";
    document.getElementById("EV_USER").value = "";
    document.getElementById("EV_FECHA").value = "";
    document.getElementById("CE_HORAREG").value = "";
    document.getElementById("CE_NUM_LLAMADA").value = "";
    document.getElementById("CE_CALIF").value = "";
    document.getElementById("CE_REG_PEN").value = "";
    document.getElementById("CE_GTRABAJO").value = "";
    document.getElementById("CE_OBSERVACION").value = "";
    document.getElementById("EV_MANUAL").checked = false;
    $("#CE_PREGUNTA10").prop("checked", true);
    $("#CE_PREGUNTA20").prop("checked", true);
    $("#CE_PREGUNTA30").prop("checked", true);
    $("#CE_PREGUNTA40").prop("checked", true);
    $("#CE_PREGUNTA50").prop("checked", true);
    $("#CE_PREGUNTA60").prop("checked", true);
    $("#CE_PREGUNTA70").prop("checked", true);
    $("#CE_PREGUNTA80").prop("checked", true);
    $("#CE_PREGUNTA90").prop("checked", true);
    $("#CE_PREGUNTA100").prop("checked", true);
    $("#CE_MSG2").prop("checked", true);
    $("#CE_CAMP_TMK2").prop("checked", true);
    $("#CE_REF2").prop("checked", true);
    $("#CE_INCOMPANY2").prop("checked", true);
}
//function ViewUsr() {
//    var grid = jQuery("#GRID_USRTMK");
//    var ids = grid.getGridParam("selrow");
//    if (ids !== null) {
//        var lstRow1 = grid.getRowData(ids);
//        var strIP = lstRow1.DEV_IP;
//        if (strIP != "") {
//            ExtAgente();
//            var strPost = "direccion_ip=" + strIP;
//            $("#dialogWait").dialog("open");
//            Abrir_Link("COFIDE_ver_tmk_cam.jsp?ID=1&direccion_ip=" + strIP, "_blank", 400, 300, 0, 0);
//            $("#dialogWait").dialog("close");
//        } else {
//            alert("Este agente no tiene una Direccion Ip configurada!");
//        }
//    } else {
//        alert("Selecciona Alguna Plantilla para Confirmar");
//    }
//}
function ViewUsr() {
    var strId = document.getElementById("CE_ID_EJECUTIVO").value;
    var strIP = document.getElementById("CE_IP").value;
    if (strId !== null) {
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

    var strHtmlBtnEv = "<table border='0' width='0%' style='padding-left: 60%'>"
            + "<tr>"
            + '<td align="center"><a href="javascript:ViewUsr()" class=\'cofide_evaluacion\'><i class = "fa fa-video-camera" title="Monitoreo" style="font-size:60px; width:110px"></i></td>'
            + '<td align="center"><a href="javascript:SelEvaluacion(1)" class=\'cofide_evaluacion\'><i class = "fa fa-check-circle" title="Evaluación" style="font-size:60px; width:110px"></i></td>'
            + '<td align="center"><div class=\'cofide_evaluacion\'><i class = "fa fa-volume-up" title="Llamada" style="font-size:60px; width:110px"></i></td>'
            + "</tr>";
    "</table>";
    document.getElementById("EV_EVALUARBTN").innerHTML = strHtmlBtnEv;
}
function ExtAgente() {
    var strExt = document.getElementById("CE_EXT").value;
    if (strExt != "") {
        var strHtmlBtnCall = "<table border='0' width='0%' align='center'>" + "<tr>" + '<td align="center"><a href="sip:*9' + strExt + '" class=\'cofide_evaluacion\'><i class = "fa fa-volume-up" title="Llamada" style="font-size:60px; width:110px"></i></td>' + "</tr>";
        "</table>";
        document.getElementById("EV_REVBTN").innerHTML = strHtmlBtnCall;
    } else {
        alert("No se Encuentra la Extensión");
    }
    document.getElementById("CE_EXT").value = "";
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
                document.getElementById("CE_NUM_LLAMADA").value = objcte.getAttribute("llamadas");
                document.getElementById("EV_FECHA").value = objcte.getAttribute("fecha");
                document.getElementById("CE_HORAREG").value = objcte.getAttribute("hora");
            }
        } //fin de la funcion que recupera los datos
    });
}
function canelEv(numPaso) {
    continuarPaso(numPaso);
    ResetEvaluacion();
}
function DatosMonitoreo(strExt, intEvaluacion, strIp, strNombre, intId) {
    document.getElementById("CE_ID_EJECUTIVO").value = intId;
    document.getElementById("CE_NOMBRE").value = strNombre;
    document.getElementById("CE_EVALUACIONES").value = intEvaluacion;
    document.getElementById("CE_EXT").value = strExt;
    document.getElementById("CE_IP").value = strIp;
}