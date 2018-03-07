/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function cofide_repo_cobranza(){
    
}

function initRepoCobranza(){
    getVentasCobranza();
}

function getVentasCobranza(){
    var strAnio = document.getElementById("RC_ANIO").value;
    var strMes = document.getElementById("RC_MES").value;
    var strBaseCt = document.getElementById("US_BASE").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "strMes=" + strMes + "&strAnio=" + strAnio + "&CtBase=" + strBaseCt,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_RepoCobranza.jsp?id=1",
        success: function (datos) {
            jQuery("#GR_REPO_COBRANZA").clearGridData();
            var lstXml = datos.getElementsByTagName("ReporteCobranza")[0];
            var lstCom = lstXml.getElementsByTagName("datos");
            
            for (var i = 0; i < lstCom.length; i++) {
                var obj = lstCom[i];
                var rowCobranza = {
                    RC_CONTADOR: getMaxGridRepoCobranza("#GR_REPO_COBRANZA"),
                    FAC_FECHA: obj.getAttribute("FAC_FECHA"),
                    FAC_FOLIO_C: obj.getAttribute("FAC_FOLIO_C"),
                    FAC_RAZONSOCIAL: obj.getAttribute("FAC_RAZONSOCIAL"),
                    FAC_SERIE: obj.getAttribute("FAC_SERIE"),
                    RC_DESCRIPCION: obj.getAttribute("RC_DESCRIPCION"),
                    FAC_IMPORTE: obj.getAttribute("FAC_IMPORTE"),
                    FAC_IMPUESTO1: obj.getAttribute("FAC_IMPUESTO1"),
                    FAC_TOTAL: obj.getAttribute("FAC_TOTAL")
                };
                jQuery("#GR_REPO_COBRANZA").addRowData(getMaxGridRepoCobranza("#GR_REPO_COBRANZA"), rowCobranza, "last");
            }//Fin FOR
            sumaRepoCobranza();
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin getVentasCobranza

function getMaxGridRepoCobranza(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridCursosMaterial

/*Realiza la suma de el reporte de cobranza*/
function sumaRepoCobranza() {
   var grid = jQuery("#GR_REPO_COBRANZA");
   var dblTotalImporte = 0;
   var dblTotalIva = 0;
   var dblTotal = 0;
   var arr = grid.getDataIDs();
   if (arr != null) {
      for (var i = 0; i < arr.length; i++) {
         var id = arr[i];
         var lstVal = grid.getRowData(id);
         dblTotalImporte = dblTotalImporte + parseFloat(lstVal.FAC_IMPORTE);
         dblTotalIva = dblTotalIva + parseFloat(lstVal.FAC_IMPUESTO1);
         dblTotal = dblTotal + parseFloat(lstVal.FAC_TOTAL);
      }
   }
   /*Ponemos el total en el pie de las columnas*/
   grid.footerData('set', {RC_DESCRIPCION: "TOTAL", FAC_IMPORTE: dblTotalImporte, FAC_IMPUESTO1: dblTotalIva, FAC_TOTAL : dblTotal});
}//Fin sumaRepoCobranza