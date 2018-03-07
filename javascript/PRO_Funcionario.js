/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function PRO_Funcionario(){
    
}


/**Realiza la operacion de seleccion del item ya sea para editar o copiarlo al cuadro de texto de una venta*/
function dblClickFno(id){
    var strNomMain = objMap.getNomMain();
    var grid=jQuery("#FUNCI");
    var lstVal = grid.getRowData(id);
    if(strNomMain == "FUNCI"){
        //En caso de cliente abrimos la opcion de edicion
        OpnEdit(document.getElementById("Ed" + strNomMain ));
    }else{
        if(strNomMain == "CREDITO"){
            document.getElementById("F_ID").value = lstVal.F_ID;
            document.getElementById("F_NOM").value = lstVal.F_NOMBRE +" "+ lstVal.F_APATERNO +" "+ lstVal.F_AMATERNO;
        } 
        $("#dialog2").dialog("close");
    }
}