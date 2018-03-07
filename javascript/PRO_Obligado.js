/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function PRO_Obligado() {

}


/**Realiza la operacion de seleccion del item ya sea para editar o copiarlo al cuadro de texto de una venta*/
function dblClickObo(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#OBLIGADO");
    var lstVal = grid.getRowData(id);
    //alert("id:  " + lstVal.CT_ID + "  nombre:  " + lstVal.CT_RAZONSOCIAL);
    if (strNomMain == "OBLIGADO") {
        //En caso de cliente abrimos la opcion de edicion
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "CREDITO") {
            document.getElementById("OB_ID").value = lstVal.CT_ID;
            document.getElementById("OB_NOMBRE").value = lstVal.CT_NOMBRE + " " + lstVal.CT_APATERNO + " " + lstVal.CT_AMATERNO; 
        }
        $("#dialog2").dialog("close");
    }
}