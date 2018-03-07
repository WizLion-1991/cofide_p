/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var itemQtz = 0;
function qtz_tareas() {

}


function initQuartz() {
    agregarItem('LeerFtp', '...');
    agregarItem('ArchivosEntrada', '...');
    agregarItem('SincronizarXLS', '');
    agregarItem('Demanda', '');
    setTimeout(actualizarTareas(), 3000);
}

function agregarItem(nombre, estatus) {
    var dataRow1 = {
        t_nombre: nombre,
        t_estatus: estatus
    };
    //Anexamos el registro al GRID
    itemQtz++;
    jQuery("#gridtask").addRowData(itemQtz, dataRow1, "last");

}

function actualizarTareas() {
    //peticion por ajax para reconocer que jobs estan prendidos
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "ERP_Quartz.jsp?id=4",
        success: function (datos) {
            //Asignamos valores recuperamos
            alert(datos);
            $("#dialogWait").dialog("close");
        }, error: function (data) {
            $("#dialogWait").dialog("close");
            alert(data);
        }
    });
}
/**Borra la tarea seleccionada*/
function borrarTarea() {
    var grid = jQuery("#gridtask");
    if (grid.getGridParam("selrow") != null) {
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var strPost = "nameJob=" + lstRow.t_nombre;
        //peticion por ajax para inicializar un job
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "ERP_Quartz.jsp?id=2",
            success: function (datos) {
                //Asignamos valores recuperamos
                if (trim(datos) == "OK") {
                    alert("Tarea detenida...");
                }
                $("#dialogWait").dialog("close");
            }, error: function (data) {
                $("#dialogWait").dialog("close");
                alert(data);
            }
        });
    }
}
/**Activa la tarea seleccionada*/
function activarTarea() {
    var grid = jQuery("#gridtask");
    if (grid.getGridParam("selrow") != null) {
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var strPost = "nameJob=" + lstRow.t_nombre;
        strPost += "&nameTrigger=trigg_" + lstRow.t_nombre;
        strPost += "&cron=" + "0 * * * * ?";
        //peticion por ajax para inicializar un job
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "ERP_Quartz.jsp?id=1",
            success: function (datos) {
                //Asignamos valores recuperamos
                if (trim(datos) == "OK") {
                    alert("Tarea inicializada...");
                }
                $("#dialogWait").dialog("close");
            }, error: function (data) {
                $("#dialogWait").dialog("close");
                alert(data);
            }
        });
    }
}