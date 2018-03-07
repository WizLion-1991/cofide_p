function cofide_cursos() {

}
function OpnDiagptsSed() {
    var objSecModiVta = objMap.getScreen("H_SEDES");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("H_SEDES", "grid", "dialogCte", false, false);
}
function OpnDiagptsInts() {
    var objSecModiVta = objMap.getScreen("C_INSTRUCTORES");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("C_INSTRUCTORES", "grid", "dialogCte", false, false);
}

var itemIdCof = 0;
function validaCurso() {
    var strHoraInicio = "";
    var strHoraFin = "";
    var intHorasTotal = 0;
    var intHoraInicial = 0;
    var intHoraFinal = 0;
    var strHoraTotal = "";
    var strSeparador = " a ";
    var strSesion = "";
    strHoraInicio = d.getElementById("CC_HR_EVENTO_INI").value;
    strHoraFin = d.getElementById("CC_HR_EVENTO_FIN").value;
    if (strHoraInicio != "" && strHoraFin != "") {
        if (strHoraInicio != strHoraFin) {
        intHoraInicial = parseInt(strHoraInicio);
        intHoraFinal = parseInt(strHoraFin);

            if (intHoraInicial < intHoraFinal) {
                intHorasTotal = intHoraFinal - intHoraInicial;
                strHoraTotal = intHorasTotal.toString();
                strSesion = strHoraInicio + strSeparador + strHoraFin + " Hrs."
                document.getElementById("CC_DURACION_HRS").value = strHoraTotal;
                document.getElementById("CC_SESION").value = strSesion;
            } else {
                alert("La hora Final no puede ser menor a la Hora Inicial");
            }
        } else {
            alert("No puede ser a la misma");
        }
    } else {
        alert("Son necesarios, la hora inicial y la hora final");
    }
}
function confirmaCurso() {
    var grid = jQuery("#V_CURSOS");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intIdCC = lstRow1.CC_CURSO_ID;
        var intActivo = lstRow1.CC_ACTIVO;
        if (intActivo == "SI") {
            var strPost = "";
            strPost += "&CC_CURSO_ID=" + intIdCC;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Cursos.jsp?id=1",
                success: function (datos) {
                    jQuery("#V_CURSOS").clearGridData();
                    var objsc = datos.getElementsByTagName("Confirmar")[0];
                    var lstProds = objsc.getElementsByTagName("Confirmar_deta");
                    for (var i = 0; i < lstProds.length; i++) {
                        var obj = lstProds[i];
                        if (obj.getAttribute("respuesta") != "true") {
                            alert("Hubo un error al Confirmar");
                        } else {
                            grid.trigger("reloadGrid");
                        }
                    }
                    grid.trigger("reloadGrid");
                    alert("Confirmado");
                }, error: function () {
                    alert("No hay Datos");
                    grid.trigger("reloadGrid");
                }});
        } else {
            alert("El Curso Debe Estar Activo!");
        }
    } else {
        alert("Selecciona un elemento en el grid");
    }
}
function autorizaCurso() {
    var grid = jQuery("#V_CURSOS");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intIdCC = lstRow1.CC_CURSO_ID;
        var intConfirmado = lstRow1.CC_CONFIRMAR;
        if (intConfirmado == "SI") {
            var strPost = "";
            strPost += "&CC_CURSO_ID=" + intIdCC;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Cursos.jsp?id=2",
                success: function (datos) {
                    jQuery("#V_CURSOS").clearGridData();
                    var objsc = datos.getElementsByTagName("Autorizar")[0];
                    var lstProds = objsc.getElementsByTagName("Autorizar_deta");
                    for (var i = 0; i < lstProds.length; i++) {
                        var obj = lstProds[i];
                        if (obj.getAttribute("respuesta") != "true") {
                            alert("Hubo un error al Autorizar");
                        } else {
                            grid.trigger("reloadGrid");
                        }
                    }
                    grid.trigger("reloadGrid");
                    alert("Autorizado");
                }, error: function () {
                    alert("No hay Datos");
                    grid.trigger("reloadGrid");
                }});
        } else {
            alert("El Curso Debe Ser Confirmado Antes de Autorizar");
        }
    } else {
        alert("Selecciona un elemento en el grid");
    }
}
function CalcIvaPres() {
    var strPrecioUnitPres = d.getElementById("CC_PRECIO_PRES").value;
    var tax = new Impuestos(dblTasa1, dblTasa2, dblTasa3, intSImp1_2, intSImp1_3, intSImp2_3);
    tax.CalculaImpuestoMas(strPrecioUnitPres);
    var dblIva = parseFloat(this.dblImpuesto1 = tax.dblImpuesto1) + parseFloat(strPrecioUnitPres);
    document.getElementById("CC_IVA_PRES").value = dblIva;
}
function CalcIvaOn() {
    var strPrecioUnitOn = d.getElementById("CC_PRECIO_ON").value;
    var tax = new Impuestos(dblTasa1, dblTasa2, dblTasa3, intSImp1_2, intSImp1_3, intSImp2_3);
    tax.CalculaImpuestoMas(strPrecioUnitOn);
    var dblIva = parseFloat(this.dblImpuesto1 = tax.dblImpuesto1) + parseFloat(strPrecioUnitOn);
    document.getElementById("CC_IVA_ON").value = dblIva;
}
function CalcIvaVid() {
    var strPrecioUnitVid = d.getElementById("CC_PRECIO_VID").value;
    var tax = new Impuestos(dblTasa1, dblTasa2, dblTasa3, intSImp1_2, intSImp1_3, intSImp2_3);
    tax.CalculaImpuestoMas(strPrecioUnitVid);
    var dblIva = parseFloat(this.dblImpuesto1 = tax.dblImpuesto1) + parseFloat(strPrecioUnitVid);
    document.getElementById("CC_IVA_VID").value = dblIva;
}
function OpnDiagCursos() {
    var objSecModiVta = objMap.getScreen("CAT_CURSO");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("CAT_CURSO", "grid", "dialog", false, false, true);
}
function dblClickCurso(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#CAT_CURSO");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "CAT_CURSO") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "E2_CURSOS") {
            document.getElementById("CC_NOMBRE_CURSO").value = lstVal.CCU_CURSO;
            document.getElementById("CC_CLAVES").value = lstVal.CCU_CLAVE;
            $("#dialog").dialog("close");
        }
    }
}
function OpnDiagGiro() {
    var objSecModiVta = objMap.getScreen("CAT_GIRO");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("CAT_GIRO", "grid", "dialog2", false, false, true);
}
function dblClickGiro(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#CAT_GIRO");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "CAT_GIRO") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "V_CURSOS") {
            document.getElementById("CC_GIRO").value = lstVal.CG_GIRO;
            $("#dialog2").dialog("close");
        } else {
            if (strNomMain == "CAT_CURSO") {
                document.getElementById("CC_GIRO").value = lstVal.CG_GIRO;
                $("#dialog2").dialog("close");
            }
        }
    }
}
function OpnDiagArea() {
    var objSecModiVta = objMap.getScreen("CAT_SEG");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("CAT_SEG", "grid", "dialogTMK1", false, false, true);
}
function dblClickArea(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#CAT_SEG");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "CAT_SEG") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "V_CURSOS") {
            document.getElementById("CC_SEGM").value = lstVal.CS_AREA;
            $("#dialogTMK1").dialog("close");
        } else {
            if (strNomMain == "CAT_CURSO") {
                document.getElementById("CC_SEGM").value = lstVal.CS_AREA;
                $("#dialogTMK1").dialog("close");
            }
        }
    }
}
function cancelarCurso() {
    var grid = jQuery("#V_CURSOS");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var intIdCC = lstRow1.CC_CURSO_ID;
        var strPost = "";
        strPost += "&CC_CURSO_ID=" + intIdCC;
        $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=3", success: function (datos) {
                jQuery("#V_CURSOS").clearGridData();
                var objsc = datos.getElementsByTagName("Cancelar")[0];
                var lstProds = objsc.getElementsByTagName("Cancelar_deta");
                for (var i = 0; i < lstProds.length; i++) {
                    var obj = lstProds[i];
                    var intInscritos = parseInt(obj.getAttribute("inscritos"));
                    if (intInscritos > 0) {
                        alert("Aun hay " + intInscritos + " Participante(s) inscrito(s) en este curso ");
                    }
                    if (obj.getAttribute("respuesta") != "true") {
                        alert("Hubo un error al Cancelar");
                    } else {
                        grid.trigger("reloadGrid");
                    }
                }
                grid.trigger("reloadGrid");
                alert("Curso Cancelado");
            }, error: function () {
                alert("No hay Datos");
                grid.trigger("reloadGrid");
            }});
    } else {
        alert("Selecciona un Curso");
    }
}
function LlenaDetaCurso() {
    var intId_M = document.getElementById("CCU_ID_M").value;
    var intId = 0;
    var strCursoNew = "";
    var strCursoOld = "";
    var strFecha = "";
    var strClave = "";
    var strHora = "";
    var strUsr = "";
    var strPost = "CCU_ID_M=" + intId_M;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=4", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CUD_ID");
                strCursoNew = objcte.getAttribute("CUD_CURSO");
                strCursoOld = objcte.getAttribute("CUD_CURSO_OLD");
                strClave = objcte.getAttribute("CUD_CLAVE");
                strFecha = objcte.getAttribute("CUD_FECHA");
                strHora = objcte.getAttribute("CUD_HORA");
                strUsr = objcte.getAttribute("CUD_USUARIO");
                var datarow = {CUD_ID: intId, CUD_CURSO: strCursoNew, CUD_CURSO_OLD: strCursoOld, CUD_CLAVE: strClave, CUD_FECHA: strFecha, CUD_HORA: strHora, CUD_USUARIO: strUsr};
                itemIdCof++;
                jQuery("#CCU_GRD").addRowData(itemIdCof, datarow, "last");
            }
        }});
    LlenarDetallesCat();
}
function LlenaDetaGiro() {
    var intId_M = document.getElementById("CG_ID_M").value;
    var intId = 0;
    var strGiroNew = "";
    var strGiroOld = "";
    var strFecha = "";
    var strHora = "";
    var strUsr = "";
    var strPost = "CG_ID_M=" + intId_M;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=5", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CGD_ID");
                strGiroNew = objcte.getAttribute("CGD_GIRO");
                strGiroOld = objcte.getAttribute("CGD_GIRO_OLD");
                strFecha = objcte.getAttribute("CGD_FECHA");
                strHora = objcte.getAttribute("CGD_HORA");
                strUsr = objcte.getAttribute("CGD_USUARIO");
                var datarow = {CGD_ID: intId, CGD_GIRO: strGiroNew, CGD_GIRO_OLD: strGiroOld, CGD_FECHA: strFecha, CGD_HORA: strHora, CGD_USUARIO: strUsr};
                itemIdCof++;
                jQuery("#CG_GRD").addRowData(itemIdCof, datarow, "last");
            }
        }});
}
function LlenaDetaArea() {
    var intId_M = document.getElementById("CS_ID_M").value;
    var intId = 0;
    var strAreaNew = "";
    var strAreaOld = "";
    var strFecha = "";
    var strHora = "";
    var strUsr = "";
    var strPost = "CS_ID_M=" + intId_M;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=6", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CSD_ID");
                strAreaNew = objcte.getAttribute("CSD_AREA");
                strAreaOld = objcte.getAttribute("CSD_AREA_OLD");
                strFecha = objcte.getAttribute("CSD_FECHA");
                strHora = objcte.getAttribute("CSD_HORA");
                strUsr = objcte.getAttribute("CSD_USUARIO");
                var datarow = {CSD_ID: intId, CSD_AREA: strAreaNew, CSD_AREA_OLD: strAreaOld, CSD_FECHA: strFecha, CSD_HORA: strHora, CSD_USUARIO: strUsr};
                itemIdCof++;
                jQuery("#CS_GRD").addRowData(itemIdCof, datarow, "last");
            }
        }});
}
function AddGiro() {
    var giro = document.getElementById("CC_GIRO").value;
    if (giro != "") {
        var datarow = {CCG_ID: itemIdCof, CC_CURSO_ID: document.getElementById("CC_CURSO_ID").value, CC_GIRO: giro};
        itemIdCof++;
        jQuery("#CC_GRD_GIRO").addRowData(itemIdCof, datarow, "last");
        document.getElementById("CC_GIRO").value = "";
    } else {
        alert("Seleccione Una Opcion");
    }
}
function AddGiroCat() {
    var giro = document.getElementById("CC_GIRO").value;
    if (giro != "") {
        var datarow = {CCG_ID: itemIdCof, CC_CURSO_ID: document.getElementById("CCU_ID_M").value, CC_GIRO: giro};
        itemIdCof++;
        jQuery("#CC_GRD_GIRO").addRowData(itemIdCof, datarow, "last");
        document.getElementById("CC_GIRO").value = "";
    } else {
        alert("Seleccione Una Opcion");
    }
}
function AddArea() {
    var area = document.getElementById("CC_SEGM").value;
    if (area != "") {
        var datarow = {CCS_ID: itemIdCof, CC_CURSO_ID: document.getElementById("CC_CURSO_ID").value, CC_AREA: area};
        itemIdCof++;
        jQuery("#CC_GRD_AREA").addRowData(itemIdCof, datarow, "last");
        document.getElementById("CC_SEGM").value = "";
    } else {
        alert("Selecciona una Opcion");
    }
}
function AddAreaCat() {
    var area = document.getElementById("CC_SEGM").value;
    if (area != "") {
        var datarow = {CCS_ID: itemIdCof, CC_CURSO_ID: document.getElementById("CCU_ID_M").value, CC_AREA: area};
        itemIdCof++;
        jQuery("#CC_GRD_AREA").addRowData(itemIdCof, datarow, "last");
        document.getElementById("CC_SEGM").value = "";
    } else {
        alert("Selecciona una Opcion");
    }
}
function DelGiro() {
    var grid = jQuery("#CC_GRD_GIRO");
    if (grid.getGridParam("selrow") != null) {
        grid.delRowData(grid.getGridParam("selrow"));
    }
}
function DelArea() {
    var grid = jQuery("#CC_GRD_AREA");
    if (grid.getGridParam("selrow") != null) {
        grid.delRowData(grid.getGridParam("selrow"));
    }
}
function saveGiro() {
    var strPost = "";
    var intIdSave = 0;
    intIdSave = document.getElementById("CC_CURSO_ID").value;
    var grid = jQuery("#CC_GRD_GIRO");
    var idArr = grid.getDataIDs();
    strPost += "CC_CURSO_ID=" + intIdSave;
    for (var i = 0; i < idArr.length; i++) {
        var id = idArr[i];
        var lstRow = grid.getRowData(id);
        strPost += "&CC_GIRO" + i + "=" + lstRow.CC_GIRO + "";
    }
    strPost += "&length=" + idArr.length;
    $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "COFIDE_Cursos.jsp?id=7"});
    jQuery("#CC_GRD_GIRO").clearGridData();
}
function saveArea() {
    var strPost = "";
    var intIdSave = 0;
    intIdSave = document.getElementById("CC_CURSO_ID").value;
    var grid = jQuery("#CC_GRD_AREA");
    var idArr = grid.getDataIDs();
    strPost += "CC_CURSO_ID=" + intIdSave;
    for (var i = 0; i < idArr.length; i++) {
        var id = idArr[i];
        var lstRow = grid.getRowData(id);
        strPost += "&CC_AREA" + i + "=" + lstRow.CC_AREA + "";
    }
    strPost += "&length=" + idArr.length;
    $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "COFIDE_Cursos.jsp?id=8"});
    jQuery("#CC_GRD_AREA").clearGridData();
}
function DoSave() {
    saveArea();
    saveGiro();
    SaveModulo();
    _objSc.RestoreSave();
    _objSc = null;
}
function LlenaGiro() {
    var intId = 0;
    var strGiro = "";
    var intCC_CURSO_ID = document.getElementById("CC_CURSO_ID").value;
    var strPost = "CC_CURSO_ID=" + intCC_CURSO_ID;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=9", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CCG_ID");
                strGiro = objcte.getAttribute("CC_GIRO");
                var datarow = {CCG_ID: intId, CC_GIRO: strGiro, CC_CURSO_ID: intCC_CURSO_ID};
                itemIdCof++;
                jQuery("#CC_GRD_GIRO").addRowData(itemIdCof, datarow, "last");
            }
        }});
}
function LlenaGiroCat() {
    var intId = 0;
    var strGiro = "";
    var intCC_CURSO_ID = document.getElementById("CCU_ID_M").value;
    var strPost = "CCU_ID_M=" + intCC_CURSO_ID;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=15", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CCG_ID");
                strGiro = objcte.getAttribute("CC_GIRO");
                var datarow = {CCG_ID: intId, CC_GIRO: strGiro, CC_CURSO_ID: intCC_CURSO_ID};
                itemIdCof++;
                jQuery("#CC_GRD_GIRO").addRowData(itemIdCof, datarow, "last");
            }
        }});
}
function LlenaArea() {
    var intId = 0;
    var strArea = "";
    var intCC_CURSO_ID = document.getElementById("CC_CURSO_ID").value;
    var strPost = "CC_CURSO_ID=" + intCC_CURSO_ID;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=10", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CCS_ID");
                strArea = objcte.getAttribute("CC_AREA");
                var datarow = {CCS_ID: intId, CC_AREA: strArea, CC_CURSO_ID: intCC_CURSO_ID};
                itemIdCof++;
                jQuery("#CC_GRD_AREA").addRowData(itemIdCof, datarow, "last");
            }
        }});
}
function LlenaAreaCat() {
    var intId = 0;
    var strArea = "";
    var intCC_CURSO_ID = document.getElementById("CCU_ID_M").value;
    var strPost = "CCU_ID_M=" + intCC_CURSO_ID;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=16", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CCS_ID");
                strArea = objcte.getAttribute("CC_AREA");
                var datarow = {CCS_ID: intId, CC_AREA: strArea, CC_CURSO_ID: intCC_CURSO_ID};
                itemIdCof++;
                jQuery("#CC_GRD_AREA").addRowData(itemIdCof, datarow, "last");
            }
        }});
}
function LlenarDetalles() {
    setTimeout("LlenaArea()", 1000);
    setTimeout("LlenaGiro()", 1000);
    setTimeout("LlenaModulos()", 1000);
}
function LlenarDetallesCat() {
    setTimeout("LlenaAreaCat()", 1000);
    setTimeout("LlenaGiroCat()", 1000);
}
function OpnDiagCursosMod() {
    var objSecModiVta = objMap.getScreen("MOD_CURSO");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("MOD_CURSO", "grid", "dialogInv", false, false, true);
}
function dblClickModCurso(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#MOD_CURSO");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "MOD_CURSO") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "V_CURSOS") {
            document.getElementById("CCD_CURSO").value = lstVal.CC_NOMBRE_CURSO;
            document.getElementById("CCD_ID").value = lstVal.CC_CURSO_ID;
            $("#dialogInv").dialog("close");
        } else {
            if (strNomMain == "CAT_CURSO") {
                document.getElementById("CCD_CURSO").value = lstVal.CC_NOMBRE_CURSO;
                document.getElementById("CCD_ID").value = lstVal.CC_CURSO_ID;
                $("#dialogInv").dialog("close");
            }
        }
    }
}
function AddModulo() {
    var curso = document.getElementById("CCD_CURSO").value;
    if (curso != "") {
        var datarow = {CCD_ID: document.getElementById("CCD_ID").value, CC_CURSO_ID: document.getElementById("CC_CURSO_ID").value, CCD_CURSO: curso};
        itemIdCof++;
        jQuery("#GRD_SEMIN").addRowData(itemIdCof, datarow, "last");
        document.getElementById("CCD_CURSO").value = "";
    } else {
        alert("Selecciona una Opcion");
    }
}
function DelMod() {
    var grid = jQuery("#GRD_SEMIN");
    if (grid.getGridParam("selrow") != null) {
        grid.delRowData(grid.getGridParam("selrow"));
    }
}
function SaveModulo() {
    var strPost = "";
    var intIdSave = 0;
    intIdSave = document.getElementById("CC_CURSO_ID").value;
    var grid = jQuery("#GRD_SEMIN");
    var idArr = grid.getDataIDs();
    strPost += "CC_CURSO_ID=" + intIdSave;
    for (var i = 0; i < idArr.length; i++) {
        var id = idArr[i];
        var lstRow = grid.getRowData(id);
        strPost += "&CCD_CURSO" + i + "=" + lstRow.CCD_CURSO + "";
        strPost += "&CCD_ID" + i + "=" + lstRow.CCD_ID + "";
    }
    strPost += "&length=" + idArr.length;
    $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "COFIDE_Cursos.jsp?id=11"});
    jQuery("#GRD_SEMIN").clearGridData();
}
function LlenaModulos() {
    var intId = 0;
    var strCurso = "";
    var intCC_CURSO_ID = document.getElementById("CC_CURSO_ID").value;
    var strPost = "CC_CURSO_ID=" + intCC_CURSO_ID;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=12", success: function (datos) {
            var lstXml = datos.getElementsByTagName("cofide_cursos")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                intId = objcte.getAttribute("CM_ID");
                strCurso = objcte.getAttribute("CC_NOMBRE_CURSO");
                var datarow = {CCD_ID: intId, CCD_CURSO: strCurso, CC_CURSO_ID: intCC_CURSO_ID};
                itemIdCof++;
                jQuery("#GRD_SEMIN").addRowData(itemIdCof, datarow, "last");
            }
        }});
}
function initValCurso() {
    setTimeout("NomCurso()", 1000);
    setTimeout("Template()", 1000);
    setTimeout("LlenarDetalles()", 1000);
}
function NomCurso() {
    document.getElementById("CC_NOMBRE_CURSOV").value = document.getElementById("CC_NOMBRE_CURSO").value;
}
function ValidaDiploma() {
    if (d.getElementById("CC_IS_DIPLOMADO1").checked) {
        $("#CC_IS_SEMINARIO2").prop("checked", true);
    }
}
function ValidaSemin() {
    if (d.getElementById("CC_IS_SEMINARIO1").checked) {
        $("#CC_IS_DIPLOMADO2").prop("checked", true);
    }
}
function Template() {
    var IdCurso = document.getElementById("CC_CURSO_ID").value;
    var strFecha = document.getElementById("CC_FECHA_INICIAL").value;
    var strPost = "CC_CURSO_ID=" + IdCurso;
    strPost += "&CC_FECHA_INICIAL=" + strFecha;
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Cursos.jsp?id=14"});
}

function SubirMaterial() {
    var File = document.getElementById("CC_MATERIAL_");
    if (File.value == "") {
        alert("Requiere seleccionar un archivo");
        File.focus();
    } else {
        if (Right(File.value.toUpperCase(), 3) == "PDF") {
            $.ajaxFileUpload({
                url: "COFIDE_UpMaterial.jsp?ID=1",
                secureuri: false,
                fileElementId: "CC_MATERIAL",
                dataType: "json",
                success: function (data, status) {
                    if (typeof (data.error) != "undefined") {
                        if (data.error != "") {
                            alert(data.error);
                        } else {
                            alert("Archivo guardado");
                            document.getElementById("CC_MATERIAL_").disabled = true;
                            document.getElementById("CC_MATERIAL").value = document.getElementById("CC_MATERIAL_").value;
                        }
                    }
                    $("#dialogWait").dialog("close");
                }, error: function (data, status, e) {
                    alert(e);
                    $("#dialogWait").dialog("close");
                }});
        } else {
            alert("El material del curso debe ser en formato PDF");
            File.focus();
        }
    }
}
/**
 * Al elegir una sede, se llena el alias de la sede
 * @returns {undefined}
 */
function fillAlias() {
    var intIdSede = document.getElementById("CC_SEDE_ID").value;
    var strAlias = "";
    if (intIdSede != "") {
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: "id_sede=" + intIdSede,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Cursos.jsp?id=17",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("datos")[0];
                var lstprecio = lstXml.getElementsByTagName("cte");
                for (var i = 0; i < lstprecio.length; i++) {
                    var obj = lstprecio[i];
                    strAlias = obj.getAttribute("alias");
                }
                document.getElementById("CC_ALIAS").value = strAlias;
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });
        $("#dialogWait").dialog("close");
    }
}
function FillHrAlimento() {
    var intAlimento = document.getElementById("CC_TIPO_ALIMENTO").value;
    var strHorarioAlimento = "";
    if (intAlimento != "") {
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: "id_alimento=" + intAlimento,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Cursos.jsp?id=18",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("datos")[0];
                var lstprecio = lstXml.getElementsByTagName("cte");
                for (var i = 0; i < lstprecio.length; i++) {
                    var obj = lstprecio[i];
                    strHorarioAlimento = obj.getAttribute("horario");
                }
                document.getElementById("CC_ALIMENTO").value = strHorarioAlimento;
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });
        $("#dialogWait").dialog("close");
    }
}
function validaDispSede() {
    var intIdSede = document.getElementById("CC_SEDE_ID").value;
    if (intIdSede != "") {
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: "id_sede=" + intIdSede,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Cursos.jsp?id=19",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("datos")[0];
                var lstprecio = lstXml.getElementsByTagName("cte");
                for (var i = 0; i < lstprecio.length; i++) {
                    var obj = lstprecio[i];
                    if(obj.getAttribute("disponible") == true ){
                        alert("Esta sede ya tiene ocupado este horario");
                    }
                }
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });
        $("#dialogWait").dialog("close");
    }
}