function cofide_monitor_agente(){
    
}
function initMAgente(){
    myLayout.close("west");
    myLayout.close("east");
    myLayout.close("south");
    myLayout.close("north");
    document.getElementById("btn1").style.display = 'none';
    loadScreen();
}
function loadScreen() {
    $.ajax({
        url: "COFIDE_monitor_agente.jsp",
        dataType: "html",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        success: function (datos) {
            document.getElementById("MainPanel").innerHTML = datos;
        }
    });
}
