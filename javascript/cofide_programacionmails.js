/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function cofide_programacionmails() {

}

function initProgramacionCofide() {
//    LlenaAreaProg();
//    LlenaGiroProg();
    LoadMailCursos();
    LoadMailCursos5();
    setDialogGiros();
}


function LlenaAreaProg() { //llena el detalle del segmento en cursos
    var intId = 0;
    var strArea = "";
    var itemIdCof = 0;
    var intCC_CURSO_ID = document.getElementById("CC_CURSO_ID").value;
    var strPost = "CC_CURSO_ID=" + intCC_CURSO_ID;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Cursos.jsp?id=10",
        success: function (datos) {
            jQuery("#CC_GRD_AREA").clearGridData();
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                //recuperamos datos del jsp
                intId = objcte.getAttribute("CCS_ID");
                strArea = objcte.getAttribute("CC_AREA");
                //llenamos el grid
                var datarow = {
                    CCS_ID: intId,
                    CC_AREA: strArea,
                    CC_CURSO_ID: intCC_CURSO_ID,
                }; //fin del grid
                itemIdCof = lstCte.length + 1;
                jQuery("#CC_GRD_AREA").addRowData(itemIdCof, datarow, "last");
            }
        } //fin de la funcion que recupera los datos
    }); //fin del ajax
}

function LlenaGiroProg() { //llena el detalle del giro en cursos
    var intId = 0;
    var itemIdCof = 0;
    var strGiro = "";
    var intCC_CURSO_ID = document.getElementById("CC_CURSO_ID").value;
    var strPost = "CC_CURSO_ID=" + intCC_CURSO_ID;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Cursos.jsp?id=9",
        success: function (datos) {
            jQuery("#CC_GRD_GIRO").clearGridData();
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                //recuperamos datos del jsp
                intId = objcte.getAttribute("CCG_ID");
                strGiro = objcte.getAttribute("CC_GIRO");
                //llenamos el grid
                var datarow = {
                    CCG_ID: intId,
                    CC_GIRO: strGiro,
                    CC_CURSO_ID: intCC_CURSO_ID,
                }; //fin del grid
                itemIdCof = lstCte.length + 1;
                jQuery("#CC_GRD_GIRO").addRowData(itemIdCof, datarow, "last");
            }
        } //fin de la funcion que recupera los datos
    }); //fin del ajax
}
function LoadMailCursos() { //llena la sugerencia de mail de cursos masivos
    var CountRow = 0;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Programacionmails.jsp?ID=1",
        success: function (datos) {
            jQuery("#GRID_MAIL").clearGridData();
            var lstXml = datos.getElementsByTagName("Mail")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                //llenamos el grid
                var datarow = {
                    CC_CURSO_ID: objcte.getAttribute("id"),
                    CC_SEDE_ID: objcte.getAttribute("id_sede"),
                    CC_CLAVES: objcte.getAttribute("clave"),
                    CC_FECHA_INICIAL: objcte.getAttribute("fecini"),
                    CC_TEMPLATE1: objcte.getAttribute("t1"),
                    CC_TEMPLATE2: objcte.getAttribute("t2"),
                    CC_TEMPLATE3: objcte.getAttribute("t3"),
                    CC_AREAS: objcte.getAttribute("areas"),
                    CC_GIROS: objcte.getAttribute("giros"),
                    CC_SEDE: objcte.getAttribute("sede"),
                    CC_NOMBRE_CURSO: objcte.getAttribute("nombre"),
                    CC_MASIVOS: objcte.getAttribute("masivo"),
                    CC_MAILGROUP: objcte.getAttribute("grupo"),
                    CC_CONFIRMA_MAIL: objcte.getAttribute("confirma")
                }; //fin del grid
                CountRow++;
                jQuery("#GRID_MAIL").addRowData(CountRow, datarow, "last");
            }
        } //fin de la funcion que recupera los datos
    }); //fin del ajax
    $("#dialogWait").dialog("close");
} //fin clase
function TemplatePreview() {
    var grid = jQuery("#GRID_MAIL");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intIdCC = lstRow1.CC_CURSO_ID;
        var intTemp1 = lstRow1.CC_TEMPLATE1;
//        var intTemp2 = lstRow1.CC_TEMPLATE2;
//        var intTemp3 = lstRow1.CC_TEMPLATE3;
        if (intTemp1 != "0") { //|| intTemp2 != "0" || intTemp3 != "0") {
            OpnTemplatePreview();
            var strPost = "id_curso=" + intIdCC;
            strPost += "&Template1=" + intTemp1;
//            strPost += "&Template2=" + intTemp2;
//            strPost += "&Template3=" + intTemp3;
            $.ajax({
                type: "POST",
                data: strPost,
                url: "COFIDE_Correo.jsp",
                dataType: "html",
                scriptCharset: "utf-8",
                cache: false,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                success: function (datos) {
                    document.getElementById("TEMPLATE").innerHTML = datos;
                }
            });
        } else {
            alert("No hay ninguna plantilla seleccionada para este Curso");
        }
    } else {
        alert("Selecciona Alguna Plantilla para Previsualizar");
    }
}
function TemplateConfirm() {

    var strGiro = getNumerosGiro();
    var strSede = getNumerosSede();
    var strArea = getNumerosSegmentos();
    strGiro = strGiro.substring(0, strGiro.length - 1);
    strSede = strSede.substring(0, strSede.length - 1);
    strArea = strArea.substring(0, strArea.length - 1);

    if (strGiro != "" || strSede != "" || strArea != "") {
        var grid = jQuery("#GRID_MAIL");
        var ids = grid.getGridParam("selrow");
        if (ids !== null) {
            var lstRow1 = grid.getRowData(ids);
            var intIdCC = lstRow1.CC_CURSO_ID;
            var strPost = "CC_CURSO_ID=" + intIdCC;
            strPost += "&giro=" + strGiro;
            strPost += "&sede=" + strSede;
            strPost += "&area=" + strArea;
            $("#dialogWait").dialog("open");
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Programacionmails.jsp?ID=2",
            });
            LoadMailCursos();
            alert("Plantilla Confirmada!");
            $("#dialogWait").dialog("close");
        } else {
            alert("Selecciona Alguna Plantilla para Confirmar");
        }
    } else {
        alert("Selecciona Un filtro para los destinatarios");
    }
}
function TemplateConfirm2() {

    var grid = jQuery("#GRID_MAIL5");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intIdCC = lstRow1.CC_CURSO_ID;
        var strPost = "id_curso=" + intIdCC;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Programacionmails.jsp?ID=9",
        });
        LoadMailCursos5();
        alert("Plantilla Confirmada!");
        $("#dialogWait").dialog("close");
    } else {
        alert("Selecciona un curso para Confirmar");
    }
}
//abre la vista previa de la plantilla
function OpnTemplatePreview() {
    var objSecModiVta = objMap.getScreen("TEMP_PREVIEW");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("TEMP_PREVIEW", "_ed", "dialogCte", false, false, true);
}
function CerrarTemplate() {
    $("#dialogCte").dialog("close");
}

//function DestEmail() { //manda los filtros para mandar los masivos
//    var strGiro = new Array();
//    var strSede = new Array();
//    var strArea = new Array();
////recorremos todos los checkbox seleccionados con .each
//    $('input[name="MAIL_GIROS"]:checked').each(function () {
////$(this).val() es el valor del checkbox correspondiente
//        strGiro.push($(this).val());
//    });
//
//    $('input[name="MAIL_SEGMENTO"]:checked').each(function () {
//        strArea.push($(this).val());
//    });
//
//    $('input[name="MAIL_SEDE"]:checked').each(function () {
//        strSede.push($(this).val());
//    });
//
//    var strPost = "giro=" + strGiro;
//    strPost += "&sede=" + strSede;
//    strPost += "&area=" + strArea;
//    $.ajax({
//        type: "POST",
//        data: strPost,
//        scriptCharset: "UTF-8",
//        contentType: "application/x-www-form-urlencoded;charset=utf-8",
//        cache: false,
//        dataType: "xml",
//        url: "COFIDE_Programacionmails.jsp?ID=3",
//    });
//}

function HistorialMails() {
    var CountRow = 0;
    var strFecIni = document.getElementById("MAIL_FECINI").value;
    var strFecFin = document.getElementById("MAIL_FECFIN").value;
    if (strFecIni != "" && strFecFin != "") {
        var strPost = "fecini=" + strFecIni + "&fecfin=" + strFecFin;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Programacionmails.jsp?ID=3",
            success: function (datos) {
                jQuery("#GRID_HMAIL").clearGridData();
                var lstXml = datos.getElementsByTagName("Mail")[0]; //dato padre
                var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    //llenamos el grid
                    var datarow = {
                        CRM_ID: objcte.getAttribute("id"),
                        CRM_FECHA: objcte.getAttribute("fecha"),
                        CRM_HORA: objcte.getAttribute("hora"),
                        CRM_USUARIO: objcte.getAttribute("usuario"),
                        CRM_TEMPLATE: objcte.getAttribute("template"),
                        CRM_CURSO: objcte.getAttribute("curso")
                    }; //fin del grid
                    CountRow++;
                    jQuery("#GRID_HMAIL").addRowData(CountRow, datarow, "last");
                }
            } //fin de la funcion que recupera los datos
        }); //fin del ajax
        $("#dialogWait").dialog("close");
    } else {
        alert("Elije un rango de fechas para el historial!");
    }
}
function ShowDetaMail() {
    var CountRow = 0;
    var grid = jQuery("#GRID_HMAIL");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intId = lstRow1.CRM_ID;
        var strPost = "idm=" + intId;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Programacionmails.jsp?ID=4",
            success: function (datos) {
                jQuery("#GRID_MAILD").clearGridData();
                var lstXml = datos.getElementsByTagName("Mail")[0]; //dato padre
                var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    var datarow = {
                        CRMD_ID: objcte.getAttribute("id"),
                        CRM_ID: objcte.getAttribute("idm"),
                        CT_ID: objcte.getAttribute("id_cte"),
                        CRMD_EMAIL: objcte.getAttribute("mail"),
                        CRM_PROCESADO: objcte.getAttribute("procesado")
                    }; //fin del grid
                    CountRow++;
                    jQuery("#GRID_MAILD").addRowData(CountRow, datarow, "last");
                }
            } //fin de la funcion que recupera los datos
        }); //fin del ajax
        $("#dialogWait").dialog("close");
    } else {
        alert("Selecciona Alguna Plantilla para ver detalles");
    }
}
function ExportDetaMail() { //crear xls
    var grid = jQuery("#GRID_HMAIL");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intId = lstRow1.CRM_ID;
        $("#dialogWait").dialog("open");
        alert(intId);
        Abrir_Link("JasperReport?REP_ID=511&boton_1=XLS&CRM_ID=" + intId, '_reporte', 500, 600, 0, 0);
        $("#dialogWait").dialog("close");
    } else {
        alert("Selecciona Alguna Plantilla para Exportar detalles");
    }
}
//function BuscarCurso() {
//    var strCurso = document.getElementById("MAIL_CURSO").value;
//    var strPost = strCurso;
//    $(function () {
//        $("#MAIL_CURSO").autocomplete({//campo de texto que tendra el autocmplete
//            source: "COFIDE_Telemarketing.jsp?ID=12&" + strPost,
//            minLength: 2
//        });
//    });
//}
//function AddPromoMail() {
//    var itemIdCob = 0;
//    var strCurso = document.getElementById("MAIL_CURSO").value;
//    var strTemplate = document.getElementById("MAIL_TEMPLATE").value;
//    if (strCurso != "" && strTemplate != "") {
//        var datarow = {
//            PROM_CURSO: strCurso,
//            PROM_TEMPLATE: strTemplate,
//            PROM_CONFIRMADO: 0
//        };
//        itemIdCob++;
//        jQuery("#GRID_PROMO").addRowData(itemIdCob, datarow, "last");
//        document.getElementById("MAIL_CURSO").value = "";
//        document.getElementById("MAIL_TEMPLATE").value = "";
//    } else {
//        alert("Elegir el Curso y Template a Enviar");
//    }
//}

function LoadMailCursos5() { //mail de 5 dias mailgroup 
    var CountRow = 0;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Programacionmails.jsp?ID=6",
        success: function (datos) {
            jQuery("#GRID_MAIL5").clearGridData();
            var lstXml = datos.getElementsByTagName("Mail")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                //llenamos el grid
                var datarow = {
                    CC_CURSO_ID: objcte.getAttribute("id"),
                    CC_SEDE_ID: objcte.getAttribute("id_sede"),
                    CC_CLAVES: objcte.getAttribute("clave"),
                    CC_FECHA_INICIAL: objcte.getAttribute("fecini"),
                    CC_TEMPLATE2: objcte.getAttribute("t2"),
                    CC_AREAS: objcte.getAttribute("areas"),
                    CC_GIROS: objcte.getAttribute("giros"),
                    CC_SEDE: objcte.getAttribute("sede"),
                    CC_NOMBRE_CURSO: objcte.getAttribute("nombre"),
                    CC_MAILGROUP: objcte.getAttribute("grupo"),
                    CC_CONFIRMA_MAIL: objcte.getAttribute("confirma")
                }; //fin del grid
                CountRow++;
                jQuery("#GRID_MAIL5").addRowData(CountRow, datarow, "last");
            }
        } //fin de la funcion que recupera los datos
    }); //fin del ajax
    $("#dialogWait").dialog("close");
}
function AsignaTemplate10() {
    var strTemp = document.getElementById("MAIL_TEMPLATE10").value;
    if (strTemp != "0") {
        var grid = jQuery("#GRID_MAIL");
        var ids = grid.getGridParam("selrow");
        if (ids !== null) {
            var lstRow1 = grid.getRowData(ids);
            var intIdCC = lstRow1.CC_CURSO_ID;
            var strPost = "id_curso=" + intIdCC;
            strPost += "&template=" + strTemp;
            strPost += "&TipoCurso=1";
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Programacionmails.jsp?ID=7",
            });
//            initProgramacionCofide();
            LoadMailCursos();
        } else {
            alert("Es necesario elegir un curso para asigrnar una plantilla");
        }
    } else {
        alert("Selecciona una Plantilla");
    }
}
function AsignaTemplate5() {
    var strTemp = document.getElementById("MAIL_TEMPLATE5").value;
    if (strTemp != "0") {
        var grid = jQuery("#GRID_MAIL5");
        var ids = grid.getGridParam("selrow");
        if (ids !== null) {
            var lstRow1 = grid.getRowData(ids);
            var intIdCC = lstRow1.CC_CURSO_ID;
            var strPost = "id_curso=" + intIdCC;
            strPost += "&template=" + strTemp;
            strPost += "&TipoCurso=2";
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Programacionmails.jsp?ID=7",
            });
//            initProgramacionCofide();
            LoadMailCursos5();
        } else {
            alert("Es necesario elegir un curso para asigrnar una plantilla");
        }
    } else {
        alert("Selecciona una Plantilla");
    }
}

function setDialogGiros() {
    var strOptionGiro = "";
    var strOptionSede = "";
    var strOptionSegmento = "";
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=38",
        success: function (datos) {
            var lstXmlGiro = datos.getElementsByTagName("C_GIROS")[0];
            var lstGiros = lstXmlGiro.getElementsByTagName("datosGiro");
            for (var i = 0; i < lstGiros.length; i++) {
                var obj = lstGiros[i];
                strOptionGiro += "<option value='" + obj.getAttribute("CG_ID_M") + "'>" + obj.getAttribute("CG_GIRO") + "</option>";
            }

            var lstXmlSegMento = datos.getElementsByTagName("C_SEGMENTOS")[0];
            var lstSegmento = lstXmlSegMento.getElementsByTagName("datosSeg");
            for (var i = 0; i < lstSegmento.length; i++) {
                var obj = lstSegmento[i];
                strOptionSegmento += "<option value='" + obj.getAttribute("CS_ID_M") + "'>" + obj.getAttribute("CS_AREA") + "</option>";
            }

            var lstXmlSede = datos.getElementsByTagName("C_SEDE")[0];
            var lstSede = lstXmlSede.getElementsByTagName("datosSede");
            for (var i = 0; i < lstSede.length; i++) {
                var obj = lstSede[i];
                strOptionSede += "<option value='" + obj.getAttribute("CS_SEDE_ID") + "'>" + obj.getAttribute("CS_SEDE") + "</option>";
            }

            var strHTMLGiro = "";
            strHTMLGiro += "<table border=0 cellpadding=0>";
            strHTMLGiro += "<tr>";
            strHTMLGiro += "<td colspan=3>" + "SELECCIONAR GIROS" + "</td>";
            strHTMLGiro += "</tr>";
            strHTMLGiro += "<tr>";
            strHTMLGiro += "<td >" + "" + "<br><select id='origen_giro' multiple>" + strOptionGiro + "</select></td>";
            strHTMLGiro += "<td ><input type='button' id='Agregar' value='" + lstMsg[176] + "' onclick='AgregaGiroX()'><br><input type='button' id='Quitar' value='" + lstMsg[177] + "' onClick='deleteGiroNum()'></td>";
            strHTMLGiro += "<td >" + "" + "<br><select id='destino_giro' multiple ></select></td>";
            strHTMLGiro += "</tr>";
            strHTMLGiro += "</table>";
            document.getElementById("DIV_GIROS").innerHTML = strHTMLGiro;

            var strHTMLSegmento = "";
            strHTMLSegmento += "<table border=0 cellpadding=0>";
            strHTMLSegmento += "<tr>";
            strHTMLSegmento += "<td colspan=3>" + "SELECCIONAR SEGMENTOS" + "</td>";
            strHTMLSegmento += "</tr>";
            strHTMLSegmento += "<tr>";
            strHTMLSegmento += "<td >" + "" + "<br><select id='origen_segmento' multiple>" + strOptionSegmento + "</select></td>";
            strHTMLSegmento += "<td ><input type='button' id='Agregar' value='" + lstMsg[176] + "' onclick='AgregaSegmentoX()'><br><input type='button' id='Quitar' value='" + lstMsg[177] + "' onClick='deleteSegmentoNum()'></td>";
            strHTMLSegmento += "<td >" + "" + "<br><select id='destino_segmento' multiple ></select></td>";
            strHTMLSegmento += "</tr>";
            strHTMLSegmento += "</table>";
            document.getElementById("DIV_SEGMENTOS").innerHTML = strHTMLSegmento;

            var strHTMLSede = "";
            strHTMLSede += "<table border=0 cellpadding=0>";
            strHTMLSede += "<tr>";
            strHTMLSede += "<td colspan=3>" + "SELECCIONAR SEDES" + "</td>";
            strHTMLSede += "</tr>";
            strHTMLSede += "<tr>";
            strHTMLSede += "<td >" + "" + "<br><select id='origen_sede' multiple>" + strOptionSede + "</select></td>";
            strHTMLSede += "<td ><input type='button' id='Agregar' value='" + lstMsg[176] + "' onclick='AgregaSedeX()'><br><input type='button' id='Quitar' value='" + lstMsg[177] + "' onClick='deleteSedeNum()'></td>";
            strHTMLSede += "<td >" + "" + "<br><select id='destino_sede' multiple ></select></td>";
            strHTMLSede += "</tr>";
            strHTMLSede += "</table>";
            document.getElementById("DIV_SEDE").innerHTML = strHTMLSede;
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin setDialogGiros

/**Agrega GIROS seleccionados  */
function AgregaGiroX() {
    var objSelOr = document.getElementById("origen_giro");
    var objSelDest = document.getElementById("destino_giro");
    var intGiroIdx = d.getElementById("origen_giro").selectedIndex;
    var txtGiro = d.getElementById("origen_giro").options[intGiroIdx].text;
    for (var x = 0; x < objSelOr.length; x++) {
        if (objSelOr[x].selected) {
            select_add(objSelDest, txtGiro, objSelOr[x].value);
            objSelOr.remove(x);
        }
    }
}//Fin AgregaGiroX

/**Agrega SEGMENTOS seleccionados  */
function AgregaSegmentoX() {
    var objSelOr = document.getElementById("origen_segmento");
    var objSelDest = document.getElementById("destino_segmento");
    var intGiroIdx = d.getElementById("origen_segmento").selectedIndex;
    var txtGiro = d.getElementById("origen_segmento").options[intGiroIdx].text;
    for (var x = 0; x < objSelOr.length; x++) {
        if (objSelOr[x].selected) {
            select_add(objSelDest, txtGiro, objSelOr[x].value);
            objSelOr.remove(x);
        }
    }
}//Fin AgregaSegmentoX

/**Agrega SEDE seleccionados  */
function AgregaSedeX() {
    var objSelOr = document.getElementById("origen_sede");
    var objSelDest = document.getElementById("destino_sede");
    var intGiroIdx = d.getElementById("origen_sede").selectedIndex;
    var txtGiro = d.getElementById("origen_sede").options[intGiroIdx].text;
    for (var x = 0; x < objSelOr.length; x++) {
        if (objSelOr[x].selected) {
            select_add(objSelDest, txtGiro, objSelOr[x].value);
            objSelOr.remove(x);
        }
    }
}//Fin AgregaSedeX

//Elimina Giro de la lista Seleccionada
function deleteGiroNum() {
    var objSelDest = document.getElementById("destino_giro");
    for (var x = 0; x < objSelDest.length; x++) {
        if (objSelDest[x].selected) {
//            var intGiroIdx = objSelDest.selectedIndex;
//            var txtGiro = objSelDest.options[intGiroIdx].text;
//            select_add(objSelDest, txtGiro, objSelDest[x].value);
            objSelDest.remove(x);
        }
    }
}//Fin deleteGiroNum

//Elimina Segmento de la lista Seleccionada
function deleteSegmentoNum() {
    var objSelDest = document.getElementById("destino_segmento");
    for (var x = 0; x < objSelDest.length; x++) {
        if (objSelDest[x].selected) {
//            var intGiroIdx = objSelDest.selectedIndex;
//            var txtGiro = objSelDest.options[intGiroIdx].text;
//            select_add(objSelDest, txtGiro, objSelDest[x].value);
            objSelDest.remove(x);
        }
    }
}//Fin deleteSegmentoNum

//Elimina Sede de la lista Seleccionada
function deleteSedeNum() {
    var objSelDest = document.getElementById("destino_sede");
    for (var x = 0; x < objSelDest.length; x++) {
        if (objSelDest[x].selected) {
//            var intGiroIdx = objSelDest.selectedIndex;
//            var txtGiro = objSelDest.options[intGiroIdx].text;
//            select_add(objSelDest, txtGiro, objSelDest[x].value);
            objSelDest.remove(x);
        }
    }
}//Fin deleteSedeNum

//Obtiene numeros de GIROS seleccionados
function getNumerosGiro() {
    var _strSeries = "";
    var objSelDest = document.getElementById("destino_giro");
    for (var x = 0; x < objSelDest.length; x++) {
        _strSeries += objSelDest[x].value + ",";
    }
    return _strSeries;
}

//Obtiene numeros de Segmentos seleccionados
function getNumerosSegmentos() {
    var _strSeries = "";
    var objSelDest = document.getElementById("destino_segmento");
    for (var x = 0; x < objSelDest.length; x++) {
        _strSeries += objSelDest[x].value + ",";
    }
    return _strSeries;
}

//Obtiene numeros de Sede seleccionados
function getNumerosSede() {
    var _strSeries = "";
    var objSelDest = document.getElementById("destino_sede");
    for (var x = 0; x < objSelDest.length; x++) {
        _strSeries += objSelDest[x].value + ",";
    }
    return _strSeries;
}