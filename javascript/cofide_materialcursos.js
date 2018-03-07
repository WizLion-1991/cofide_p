/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function cofide_materialcursos() {

}

function initMaterialCursos() {
    GetCursosMaterial();
}

function GetCursosMaterial() {
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
        url: "COFIDE_MaterialCursos.jsp?id=1",
        success: function (datos) {
            jQuery("#GR_MATERIAL").clearGridData();
            var lstXml = datos.getElementsByTagName("CursosMaterial")[0];
            var lstCI = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCI.length; i++) {
                var obj = lstCI[i];
                var rowCursos = {
                    CC_CONTADOR: getMaxGridCursosMaterial("#GR_MATERIAL"),
                    CC_NOMBRE_CURSO: obj.getAttribute("CC_NOMBRE_CURSO"),
                    CC_SEDE: obj.getAttribute("CC_SEDE"),
                    CC_FECHA_INICIAL: obj.getAttribute("CC_FECHA_INICIAL"),
                    CC_MATERIAL: obj.getAttribute("CC_MATERIAL"),
                    CC_CURSO_ID: obj.getAttribute("CC_CURSO_ID")
                };
                jQuery("#GR_MATERIAL").addRowData(getMaxGridCursosMaterial("#GR_MATERIAL"), rowCursos, "last");
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin GetCursosMaterial

function getMaxGridCursosMaterial(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridCursosMaterial

function opnSeleccionaMaterial() {
    var grid = jQuery("#GR_MATERIAL");
    if (grid.getGridParam("selrow")) {
        var objSecModiVta = objMap.getScreen("SET_MAT_CURSO");
        if (objSecModiVta != null) {
            objSecModiVta.bolActivo = false;
            objSecModiVta.bolMain = false;
            objSecModiVta.bolInit = false;
            objSecModiVta.idOperAct = 0;
        }
        OpnOpt("SET_MAT_CURSO", "_ed", "dialog", false, false, true);
    } else {
        alert("Selecciona una curso");
    }
}//Fin opnSeleccionaMaterial

function closeSaveMaterial() {
    $("#dialog").dialog("close");
}

function initEditaMateriales() {
    var grid = jQuery("#GR_MATERIAL");
    if (grid.getGridParam("selrow")) {
        var id = grid.getGridParam("selrow");
        var lstVal = grid.getRowData(id);
        $("#dialogWait").dialog("open");
        document.getElementById("CC_CURSO_ID").value = lstVal.CC_CURSO_ID;
        document.getElementById("CC_NOMBRE_CURSO").value = lstVal.CC_NOMBRE_CURSO;
        getFilesDirectorio();
        $("#dialogWait").dialog("close");
    } else {
        alert("Selecciona un curso por confirmar.");
    }
}

function getFilesDirectorio() {
    var strOptionSelect = "<option value='0'>Seleccione</option>";
    var strHTML = "<table cellpadding=\"4\" cellspacing=\"1\" border=\"0\" >MATERIAL DISPONIBLE: ";
    strHTML += " <td><select id=\"materialSelect\" name=\"materialSelect\"  class=\"outEdit\" onblur=\"QuitaFoco(this)\" onfocus=\"PonFoco(this)\" 0=\"\" > " + strOptionSelect + " < /select></td>";
    strHTML += "  </table>";
    document.getElementById("MC_NOM_MATERIAL").innerHTML = strHTML;

    var strOptionSelect = "<option value='0'>Seleccione</option>";
    var strHTML = "<table cellpadding=\"4\" cellspacing=\"1\" border=\"0\" >MATERIAL DISPONIBLE: <br>";
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_MaterialCursos.jsp?id=2",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("materialSelect")[0];
            var lstprecio = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstprecio.length; i++) {
                var obj = lstprecio[i];
                strOptionSelect += "<option value='" + obj.getAttribute("MC_NOMBRE_MATERIAL") + "' >" + obj.getAttribute("MC_NOMBRE_MATERIAL") + "</option>";
            }
            strHTML += " <select id=\"materialSelect\" name=\"materialSelect\" style=\"font-size:15pt\"  class=\"outEdit\" onblur=\"QuitaFoco(this)\" onfocus=\"PonFoco(this)\" 0=\"\" > " + strOptionSelect + " < /select>";
            strHTML += "  </table>";
            document.getElementById("MC_NOM_MATERIAL").innerHTML = strHTML;
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin getFilesDirectorio

function saveInfoMaterialCurso() {
    var strPost = "IdCurso=" + document.getElementById("CC_CURSO_ID").value;
    strPost += "&NombreCurso=" + document.getElementById("CC_NOMBRE_CURSO").value;
    strPost += "&FechaDesde=" + document.getElementById("MC_FECHA_DESFE").value;
    strPost += "&FechaHasta=" + document.getElementById("MC_FECHA_HASTA").value;
    strPost += "&NombreMaterial=" + document.getElementById("materialSelect").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: encodeURI(strPost),
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_MaterialCursos.jsp?id=3",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                GetCursosMaterial();
                closeSaveMaterial();
                $("#dialogWait").dialog("close");
            } else {
                $("#dialogWait").dialog("close");
                alert(datos);
            }
            $("#dialogWait").dialog("close");
        }
    }); //fin del ajax
}//Fin saveInfoMaterialCurso