/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function cofide_repo_comisiones(){
    
}

function initRepoComisiones(){
    getComisiones();
}

function getComisiones(){
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
        url: "COFIDE_RepoComisiones.jsp?id=1",
        success: function (datos) {
            jQuery("#GR_REPO_COM").clearGridData();
            var lstXml = datos.getElementsByTagName("ReporteComision")[0];
            var lstCom = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCom.length; i++) {
                var obj = lstCom[i];
                var tmpTotal = 0;
                var tmpTotalNvo = 0;
                var tmpTotalExp = 0;
                var tmpComNvo = 0;
                var tmoComHasta = 0;
                var tmpComisionMas = 0;
                var tmpTotalComision = 0;
                
                if(obj.getAttribute("TOTAL_VENDIDO") != null){
                    tmpTotal = obj.getAttribute("TOTAL_VENDIDO");
                }
                if(obj.getAttribute("TOTAL_VENDIDO_NVO") != null){
                    tmpTotalNvo = obj.getAttribute("TOTAL_VENDIDO_NVO");
                }
                if(obj.getAttribute("TOTAL_VENDIDO_EXP") != null){
                    tmpTotalExp = obj.getAttribute("TOTAL_VENDIDO_EXP");
                }
                if(strBaseCt == 'INBOUND'){
                    tmpComNvo = ((tmpTotalNvo/100) * 10);
                }else{
                    if(obj.getAttribute("TOTAL_VENDIDO_EXP") == 0){
                        tmpComNvo = ((tmpTotalNvo/100) * 4);
                    }
                }
                
                if(tmpTotal <= 60000){
                    tmoComHasta = ((tmpTotalNvo/100) * 4);
                    tmpComisionMas = 0;
                }else{
                    tmoComHasta = 0;
                    tmpComisionMas = ((tmpTotalNvo/100) * 5);
                }
                
                tmpTotalComision = tmpComNvo + tmoComHasta + tmpComisionMas;
                
                var rowComision = {
                    RC_CONTADOR: getMaxGridRepoComision("#GR_REPO_COM"),
                    COD_AGENTE: obj.getAttribute("CT_BASE"),
                    RC_AGENTE: obj.getAttribute("US_NOMBRE"),
                    TOTAL_VENTA: tmpTotal,
                    TOTAL_NUEVOS: tmpTotalNvo,
                    TOTAL_EXP: tmpTotalExp,
                    TOTAL_COM_NUEVOS: tmpComNvo,
                    TOTAL_COM_HASTA: tmoComHasta,
                    TOTAL_COM_MAS: tmpComisionMas,
                    TOTAL_COMISION: tmpTotalComision
                };
                jQuery("#GR_REPO_COM").addRowData(getMaxGridRepoComision("#GR_REPO_COM"), rowComision, "last");
            }//Fin FOR
            sumaRepoComisiones();
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

function getMaxGridRepoComision(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridCursosMaterial

/*Realiza la suma de el reporte de comisiones*/
function sumaRepoComisiones() {
   var grid = jQuery("#GR_REPO_COM");
   var dblTotalVta = 0;
   var dblTotalNvo = 0;
   var dblTotalExp = 0;
   var dblComNvo = 0;
   var dblTotalHasta = 0;
   var dblComMas = 0;
   var dblTotalComision = 0;
   var arr = grid.getDataIDs();
   if (arr != null) {
      for (var i = 0; i < arr.length; i++) {
         var id = arr[i];
         var lstVal = grid.getRowData(id);
         dblTotalVta = dblTotalVta + parseFloat(lstVal.TOTAL_VENTA);
         dblTotalNvo = dblTotalNvo + parseFloat(lstVal.TOTAL_NUEVOS);
         dblTotalExp = dblTotalExp + parseFloat(lstVal.TOTAL_EXP);
         dblComNvo = dblComNvo + parseFloat(lstVal.TOTAL_COM_NUEVOS);
         dblTotalHasta = dblTotalHasta + parseFloat(lstVal.TOTAL_COM_HASTA);
         dblComMas = dblComMas + parseFloat(lstVal.TOTAL_COM_MAS);
         dblTotalComision = dblTotalComision + parseFloat(lstVal.TOTAL_COMISION);
      }
   }
   /*Ponemos el total en el pie de las columnas*/
   grid.footerData('set', {
       RC_AGENTE: "TOTAL:", 
       TOTAL_VENTA: dblTotalVta, 
       TOTAL_NUEVOS: dblTotalNvo, 
       TOTAL_EXP: dblTotalExp, 
       TOTAL_COM_NUEVOS: dblComNvo, 
       TOTAL_COM_HASTA: dblTotalHasta, 
       TOTAL_COM_MAS: dblComMas, 
       TOTAL_COMISION : dblTotalComision});
}//Fin sumaRepoCobranza









