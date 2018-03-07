/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var itemQtz = 0;
function quartz() {

}
function initQuartz() {
    agregarItem('MAIL_MASIVO', '');
}

function agregarItem(nombre, estatus) {
    var dataRow1 = {
        QTZ_DESC: nombre,
        QTZ_ACTIVO: estatus
    };
    //Anexamos el registro al GRID
    itemQtz++;
    jQuery("#QUARTZ").addRowData(itemQtz, dataRow1, "last");

}

/**Activa la tarea seleccionada*/
function activarTarea() {
    borrarTarea(true);//inicio de la tarea, y si ya esta activa se reinicia
    var grid = jQuery("#QUARTZ");
    if (grid.getGridParam("selrow") != null) {
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var strPost = "nameJob=" + lstRow.QTZ_DESC;
        strPost += "&nameTrigger=trigg_" + lstRow.QTZ_DESC;
        // cron = *(0-59) *(0-23) *(1-31) *(1-12 or Jan-Dec) *(0-6 or Sun-Sat)
        //         Minute   HR      DAY         MONTH               DAY WEEK
        strPost += "&cron=10 * * * * ?"; //cada media hora de lunes, miercoles y viernes
//        strPost += "&cron=0 * * * * ?";
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

/**Borra la tarea seleccionada*/
function borrarTarea(bolReStart) {
    var grid = jQuery("#QUARTZ");
    if (grid.getGridParam("selrow") != null) {
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var strPost = "nameJob=" + lstRow.QTZ_DESC;
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
                    if (!bolReStart) {
                        alert("Tarea detenida...");
                    }
                }
                $("#dialogWait").dialog("close");
            }, error: function (data) {
                $("#dialogWait").dialog("close");
                alert(data);
            }
        });
    }
}