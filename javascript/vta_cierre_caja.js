/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function vta_cierre_caja(){
}

function cierreCajaSucursal(){
    var strPost = "SC_ID=" + document.getElementById("SC_ID");
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "ERP_AperCaja.jsp?id=2",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                alert("PROCESO TERMINADO");
            } else {
                alert(datos);
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}