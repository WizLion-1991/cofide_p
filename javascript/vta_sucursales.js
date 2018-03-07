/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function vta_sucursales()
{
}

function OpnDiagProvBod()
{
    //alert("Di Clic");
    OpnOpt('SUC', 'grid', 'dialogProv', false, false);
}

function initSucursales()
{
    //alert(document.getElementById("SM_ID").value);
    if (document.getElementById("SM_ID").value == 0)
    {
        $("#tabsvta_sucurs").tabs('disable', 1);
    }
    else
    {
        $("#tabsvta_sucurs").tabs('enable', 1);
    }
    CargaBodegas();
}

function AgregarSuc()
{
    var intBodegaAgregar = document.getElementById("SC_ID").value;
    var strBOD_ID = document.getElementById("SC_ID").value;

    var boolSeEncuentra = false;
    var grid = jQuery('#GRID_BODEGAS');
    var arr = grid.getDataIDs();

    if (intBodegaAgregar == "" || intBodegaAgregar < 0)
    {
        alert("Debe seleccionar una Bodega valida");
    }
    else
    {
        for (var i = 0; i < arr.length; i++) {
            var idRow = arr[i];
            var lstRow = grid.getRowData(idRow);
            if (lstRow.SC_ID == intBodegaAgregar)
            {
                alert("Ya habia sido agregada");
                boolSeEncuentra = true;
                break;
            }
        }
        if (!boolSeEncuentra)
        {
            var strPOST = "SC_ID=" + strBOD_ID;

            $.ajax({
                type: "POST",
                data: strPOST,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "html",
                url: "ERP_Sucursales.jsp?id=4",
                success: function(datos) {
                    if (datos.substring(0, 2) == "OK")
                    {

                        var strPOST = "SC_ID=" + strBOD_ID;
                        strPOST += "&SM_ID=" + document.getElementById("SM_ID").value;
                        $.ajax({
                            type: "POST",
                            data: strPOST,
                            scriptCharset: "utf-8",
                            contentType: "application/x-www-form-urlencoded;charset=utf-8",
                            cache: false,
                            dataType: "html",
                            url: "ERP_Sucursales.jsp?id=1",
                            success: function(datos) {
                                if (datos.substring(0, 2) == "OK")
                                {
                                    alert("Se a Agregado Correctamente");
                                    var grid2 = jQuery("#GRID_BODEGAS");
                                    grid2.trigger("reloadGrid");
                                    CargaBodegas();
                                }
                            },
                            error: function(objeto, quepaso, otroobj) {
                                alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                                $("#dialogWait").dialog("close");
                                //$("#dialogWait").dialog("close");
                            }
                        });
                    }
                    else
                    {
                        alert("Esa Bodega ya esta siendo usada por la sucursal:" + datos);
                    }
                },
                error: function(objeto, quepaso, otroobj) {
                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
//$("#dialogWait").dialog("close");
                }
            });

        }
    }
}

function QuitaSuc()
{
    var grid = jQuery("#GRID_BODEGAS");
    if (grid.getGridParam("selrow") != null) {

        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var intSMA_ID = lstRow.SMA_ID;


        var strPOST = "SMA_ID=" + intSMA_ID;
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPOST,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "ERP_Sucursales.jsp?id=2",
            success: function(datos) {
                if (datos.substring(0, 2) == "OK")
                {
                    //alert("Se a quitado Correctamente");
                    var grid2 = jQuery("#GRID_BODEGAS");
                    grid2.trigger("reloadGrid");
                    $("#dialogWait").dialog("close");
                    CargaBodegas();
                }
            },
            error: function(objeto, quepaso, otroobj) {
                alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
                //$("#dialogWait").dialog("close");
            }
        });
    }
    else
    {
        alert("Debe seleccionar una Bodega");
    }
}

function CargaBodegas()
{
    $("#dialogWait").dialog("open");
    var intSM_ID = document.getElementById("SM_ID").value;

    var strPOST = "SM_ID=" + intSM_ID;
    $.ajax({
        type: "POST",
        data: strPOST,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "ERP_Sucursales.jsp?id=3",
        success: function(datos) {
            var objsc = datos.getElementsByTagName("Bodegas")[0];
            var lstBodegas = objsc.getElementsByTagName("Bodega");
            $("#GRID_BODEGAS").empty();
            for (i = 0; i < lstBodegas.length; i++) {
                var obj = lstBodegas[i];
                var datarow = {
                    SMA_ID: obj.getAttribute('SMA_ID'),
                    SM_ID: obj.getAttribute('SM_ID'),
                    SC_ID: obj.getAttribute('SC_ID'),
                    SC_NOMBRE:obj.getAttribute('SC_NOMBRE'),
                };
                //Anexamos el registro al GRID                            
                jQuery("#GRID_BODEGAS").addRowData(i, datarow, "last");
            }
            $("#dialogWait").dialog("close");
        },
        error: function(objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
//$("#dialogWait").dialog("close");
        }
    });
}

function ValidaUsoBodega()
{

}

function EliminaSucursal()
{
    
}