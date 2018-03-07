/* 
 * Realiza las operaciones y validaciones adicionales
 * En la pantalla de usuarios
 */
function users() {

}
function InactivaPerfil() {
    GetIpSucursal();
    //Si es el usuario 1 no dejamos modificar el perfil....
    if (document.getElementById("id_usuarios") !== null) {
        if (document.getElementById("id_usuarios").value == 1) {
            document.getElementById("PERF_ID").parentNode.parentNode.style.display = "none";
        }
    }
    //INACTIVAMOS BOTONES TAB 6
    document.getElementById("btn_guardar").parentNode.parentNode.style.display = "none";
    document.getElementById("btn_cancelar").parentNode.parentNode.style.display = "none";
    document.getElementById("btn_nuevo").parentNode.parentNode.style.display = "";
    document.getElementById("btn_eliminar").parentNode.parentNode.style.display = "";
    $("#tabsUSERS").tabs("option", "disabled", [6]);
}

function EditPerfil() {
    GetIpSucursal();
    //Si es el usuario 1 no dejamos modificar el perfil....
    if (document.getElementById("id_usuarios").value == 1) {
        document.getElementById("PERF_ID").parentNode.parentNode.style.display = "none";
    }
}


/*Sirve para refrescar el grid de los perfiles*/
function LoadPerfiles(idx) {
    var grid = jQuery("#GRD_PERF");
    grid.setGridParam({
        url: "CIP_TablaOp.jsp?ID=5&opnOpt=PERF_USER&_search=true&id_usuarios=" + idx
    });
    grid.trigger("reloadGrid");
}


/*Controla el flujo de los tabs*/
function tabShowUsuarios(event, ui) {
    var idx = 0;
    var index = ui.newTab.index();
    if (document.getElementById("id_usuarios") !== null) {
        idx = document.getElementById("id_usuarios").value;
    }
    if (index == 6) {
        LoadPerfiles(idx);
    }
}



/*ACTIVA BOTONES CAMPO PERFIL**/
function nuevoPerfil() {
    document.getElementById("CMB_PERF").parentNode.parentNode.style.display = "block";
    document.getElementById("CMB_SC").parentNode.parentNode.style.display = "block";

    //INACTIVAMOS BOTONES TAB 6
    document.getElementById("btn_guardar").parentNode.parentNode.style.display = "block";
    document.getElementById("btn_cancelar").parentNode.parentNode.style.display = "block";
    document.getElementById("btn_nuevo").parentNode.parentNode.style.display = "none";
    document.getElementById("btn_eliminar").parentNode.parentNode.style.display = "none";
}


/**CANCELA PERFIL**/
function cancelaPerfil() {
    document.getElementById("CMB_PERF").parentNode.parentNode.style.display = "none";
    document.getElementById("CMB_SC").parentNode.parentNode.style.display = "none";

    //INACTIVAMOS BOTONES TAB 6
    document.getElementById("btn_guardar").parentNode.parentNode.style.display = "none";
    document.getElementById("btn_cancelar").parentNode.parentNode.style.display = "none";
    document.getElementById("btn_nuevo").parentNode.parentNode.style.display = "block";
    document.getElementById("btn_eliminar").parentNode.parentNode.style.display = "block";
}


/**BORRA PERFIL**/
function borraPerfil() {


}


/**GUARDA PERFIL**/
function guardaPerfil() {
    if (document.getElementById("id_usuarios") !== null && document.getElementById("id_usuarios") !== "") {
        if (validapPerfil() !== 0) {
            var strPost = "&id_usuarios=" + document.getElementById("id_usuarios").value;
            strPost += "&PER_ID=" + document.getElementById("CMB_PERF").value;
            strPost += "&SC_ID=" + document.getElementById("CMB_SC").value;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "html",
                url: "ERP_Perfiles.jsp?ID=1",
                success: function (datos) {
                    if (datos.substring(0, 2) === "OK") {
                        LoadPerfiles(document.getElementById("id_usuarios").value);
                    }
                    else {
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":perfiles:" + objeto + " " + quepaso + " " + otroobj);
                }
            });

        }
    } else {

        alert("Atención: debes guardar primero el usuario");
    }
}


/**SIRVE PARA CONFIRMAR ELIMINAR UN USUARIO CON BODEGA**/
function confirBorrar() {
    var grid = jQuery("#GRD_PERF");
    if (grid.getGridParam("selrow") !== null) {
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var idPer = lstRow.PUS_ID;
        if (confirm("¿Confirma que desea borrar el registro seleccionado?")) {
            grid.delRowData(grid.getGridParam("selrow"));
            deletePerfilUser(idPer);
        }
    }
}


/**SIRVE PARA ELIMINAR UN USUARIO CON BODEGA**/
function deletePerfilUser(id) {
    $.ajax({
        type: "POST",
        data: "id=" + id,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "ERP_Perfiles.jsp?ID=2",
        success: function (datos) {
            if (datos.substring(0, 2) === "OK") {
                LoadPerfiles(document.getElementById("id_usuarios").value);
            }
            else {
                alert(datos);
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":perfiles:" + objeto + " " + quepaso + " " + otroobj);
        }
    });

}

/**VALIDA GUARDADO DE PERFIL**/
function validapPerfil() {
    var strPerf = document.getElementById("CMB_PERF");
    var strProv = document.getElementById("CMB_SC");

    if (strPerf.value === "0") {
        alert("Atención: Favor de seleccionar un perfil");
        strPerf.focus();
        return 0;
    }
    if (strProv.value === "0") {
        alert("Atención: Favor de seleccionar una bodega");
        strProv.focus();
        return 0;
    }
    return 1;
}
function GetIpSucursal() {
    var StrDireccionIp = document.getElementById("IP_ADDRESS").value;
    if (StrDireccionIp == "") {
        $.ajax({
            type: "POST",
            data: "",
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "ERP_Sucursales.jsp?id=8",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("Segmento")[0];
                var lstCte = lstXml.getElementsByTagName("Direccion");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    StrDireccionIp = objcte.getAttribute("segmento");
                }
                document.getElementById("IP_ADDRESS").value = StrDireccionIp;
            }});
    }
}
