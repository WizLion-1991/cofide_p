/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function vta_listfolios() {
}

function VisualizarImagen() {
   var grid = jQuery('#LIS_FOLIO');
   var id = grid.getGridParam("selrow");
   var lstRow = grid.getRowData(id);

   if (grid.getGridParam("selrow") != null) {

     var strNomArchivo  = lstRow.LIS_NOMARCHIVO;
     
Abrir_Link("document/credito/" + strNomArchivo, "_new", 200, 200, 0, 0);

      $("#dialogCte").dialog("close");


   } else {
      alert("Selecciona una fila");
   }
   
}



