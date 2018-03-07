/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function PRO_ActividadEconomica() {

}


/**Realiza la operacion de seleccion del item ya sea para editar o copiarlo al cuadro de texto de una venta*/
function dblClickAea(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#AC");
    var lstVal = grid.getRowData(id);
    //alert("id:  " + lstVal.CT_ID + "  nombre:  " + lstVal.CT_RAZONSOCIAL);
    if (strNomMain == "AC") {
        //En caso de cliente abrimos la opcion de edicion
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "CLIENTES") {
            //alert("si entra");
            document.getElementById("AC_ID").value = lstVal.AC_ID;
            document.getElementById("AC_NOMBRE").value = lstVal.AC_NOMBRE;
        }
        $("#dialog2").dialog("close");
    }
}
