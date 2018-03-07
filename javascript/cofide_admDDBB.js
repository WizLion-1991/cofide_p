function cofide_admDDBB() {

}
function initDDBB() {
    $("#dialogWait").dialog("open");
    setTimeout("loadDDBB()", 1000);
    setTimeout("intRow()", 2000);
    $("#dialogWait").dialog("close");
}
function loadDDBB() {
    var strDDBB = document.getElementById("CBC_IDD").value;
    $("#dialogWait").dialog("open");
    var CountRow = 0;
    var strPost = "ID_BASE=" + strDDBB;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Admin_base.jsp?ID=1",
        success: function (datos) {
            jQuery("#CBC_GRD").clearGridData();
            var lstXml = datos.getElementsByTagName("vta")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                //llenamos el grid
                var datarow = {
                    CB_CT_ID: objcte.getAttribute("id"),
                    CB_CT_CONT: objcte.getAttribute("contacto"),
                    CB_CT_RAZONSOCIAL: objcte.getAttribute("razon"),
                    CB_CT_TELEFONO: objcte.getAttribute("telefono"),
                    CB_CT_MAIL: objcte.getAttribute("correo")
                }; //fin del grid
                CountRow++;
                jQuery("#CBC_GRD").addRowData(CountRow, datarow, "last");
            }
        } //fin de la funcion que recupera los datos
    }); //fin del ajax
    $("#dialogWait").dialog("close");
}
function intRow() {
    var intRow;
    var grid = jQuery("#CBC_GRD");
    var idArr = grid.getDataIDs();
    intRow = idArr.length;
    document.getElementById("CBC_TOTAL").value = intRow;
}

//Subir Archivos XLS para el catalogo de presupuestos por UNIDAD
function upFileDDBB() {
    var File = document.getElementById("CBC_IMP");
    if (File.value == "") {
        alert("Requiere seleccionar un archivo");
        File.focus();
    } else {
        if (Right(File.value.toUpperCase(), 3) == "XLS") {
            $.ajaxFileUpload({
                url: "COFIDE_Admin_base.jsp?ID=2",
                secureuri: false,
                fileElementId: "CBC_IMP",
                dataType: 'json',
                success: function (data, status)
                {
                    if (typeof (data.error) != 'undefined') {
                        if (data.error != '') {
                            alert(data.error);
                        } else {
                            alert(data.msg + "Subiddó Correctamente!");
                            document.getElementById("CBC_IMP").value = "";
                        }
                    } else {
                        alert(data.msg);
                    }
                    $("#dialogWait").dialog('close');
                },
                error: function (data, status, e) {
                    alert(e);
                    $("#dialogWait").dialog('close');
                }
            }
            );
        } else {
            alert("Se aceptan archivos con extensión xls");
            File.focus();
        }
    }
    InsertFIle();
    setTimeout("loadDDBB()", 1000);
}
function InsertFIle() {
    var strFile = document.getElementById("CBC_IMP").value;
    strFile = strFile.substring(0, strFile.length - 4);
    alert(strFile);
    var strPost = "filename=" + strFile;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Admin_base.jsp?ID=3",
    }); //fin del ajax
}
function editDDBB() {
    var strDDBB = document.getElementById("CBC_IDD").value;
    var numCtes = document.getElementById("CBC_TXT").value;
    if (numCtes != "") {
        OpnADM();
        $("#dialogWait").dialog("open");
        var CountRow = 0;
        var strPost = "num_registro=" + numCtes;
        strPost += "&id_base=" + strDDBB;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Admin_base.jsp?ID=4",
            success: function (datos) {
                jQuery("#GRD_DDBB").clearGridData();
                var lstXml = datos.getElementsByTagName("vta")[0]; //dato padre
                var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    //llenamos el grid
                    var datarow = {
                        CB_CT_ID: objcte.getAttribute("id"),
                        CB_CT_CONT: objcte.getAttribute("contacto"),
                        CB_CT_RAZONSOCIAL: objcte.getAttribute("razon"),
                        CB_CT_TELEFONO: objcte.getAttribute("telefono"),
                        CB_CT_MAIL: objcte.getAttribute("correo")
                    }; //fin del grid
                    CountRow++;
                    jQuery("#GRD_DDBB").addRowData(CountRow, datarow, "last");
                }
            } //fin de la funcion que recupera los datos
        }); //fin del ajax
        $("#dialogWait").dialog("close");
    } else {
        alert("Ingresa el numeor de registros a reasignar");
    }
}
function OpnADM() {
    var objSecModiVta = objMap.getScreen("RE_DDBB");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
//    OpnOpt("TELE_CTE", "grid", "dialogCte", false, false, true);
    OpnOpt("RE_DDBB", "_ed", "dialogCte", false, false, true);
}
function AsignaBaseNueva() {
    var strPost = "";
    var grid = jQuery("#GRD_DDBB");
    var idArr = grid.getDataIDs();
    var strIDBase = document.getElementById("CBC_ID_BASE").value;
    strPost += "id_base=" + strIDBase;
    for (var i = 0; i < idArr.length; i++) {
        var id = idArr[i];
        var lstRow = grid.getRowData(id);
        strPost += "&ct_id" + i + "=" + lstRow.CB_CT_ID + "";
    }
    strPost += "&length=" + idArr.length;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Admin_base.jsp?ID=5",
    });
    jQuery("#GRD_DDBB").clearGridData();
    $("#dialogCte").dialog("close");
    initDDBB();
    document.getElementById("CBC_TXT").value = "";
}