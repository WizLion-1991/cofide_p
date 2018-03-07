/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function cofide_repo_diplomadoseminario(){
    
}

function initRepoDipSem(){
    getSeminarios();
}

function getSeminarios(){
    var strAnio = document.getElementById("DS_ANIO").value;
    var strMes = document.getElementById("DS_MES").value;
    var strBaseCt = document.getElementById("US_BASE").value;
    
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "strMes=" + strMes + "&strAnio=" + strAnio + "&CtBase=" + strBaseCt,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_DiplomadoSeminario.jsp?id=1",
        success: function (datos) {
            jQuery("#GR_REPO_DS").clearGridData();
            var lstXml = datos.getElementsByTagName("DiplomadoSeminario")[0];
            var lstCom = lstXml.getElementsByTagName("datos");

            for (var i = 0; i < lstCom.length; i++) {
                var obj = lstCom[i];
                var rowDS = {
                    DP_CONTADOR: getMaxGridDipSem("#GR_REPO_DS"),
                    FAC_FOLIO_C: obj.getAttribute("FAC_FOLIO_C"),
                    FAC_ESTATUS: obj.getAttribute("FAC_COFIDE_PAGADO"),
                    DS_SUPERVISOR: obj.getAttribute("US_SUPERVISOR"),
                    DS_AGENTE: obj.getAttribute("US_NOMBRE"),
                    FAC_FECHAPAGO: obj.getAttribute("FAC_FECHA_PAGO"),
                    FAC_IMPORTE: obj.getAttribute("FAC_TOTAL"),
                    FAC_BONO: obj.getAttribute("FAC_BONO"),
                    FAC_VALIDO: obj.getAttribute("FAC_COFIDE_VALIDA"),
                    FAC_ID: obj.getAttribute("FAC_ID")
                };
                
                jQuery("#GR_REPO_DS").addRowData(getMaxGridDipSem("#GR_REPO_DS"), rowDS, "last");
            }//Fin FOR
            sumaRepoValidaFacturas();
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin getSeminarios

function getMaxGridDipSem(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridCursosMaterial

/*Realiza la suma de el reporte de Facturas Cursos Diplomados Seminarios*/
function sumaRepoValidaFacturas() {
    var grid = jQuery("#GR_REPO_DS");
    var dblTotalBono = 0;
    var dblTotal = 0;
    var arr = grid.getDataIDs();
    if (arr != null) {
        for (var i = 0; i < arr.length; i++) {
            var id = arr[i];
            var lstVal = grid.getRowData(id);
            dblTotalBono = dblTotalBono + parseFloat(lstVal.FAC_BONO);
            dblTotal = dblTotal + parseFloat(lstVal.FAC_IMPORTE);
        }
    }
    /*Ponemos el total en el pie de las columnas*/
    grid.footerData('set', {FAC_FECHAPAGO: "TOTAL", FAC_IMPORTE: dblTotal, FAC_BONO: dblTotalBono});
}//Fin sumaRepoValidaFacturas