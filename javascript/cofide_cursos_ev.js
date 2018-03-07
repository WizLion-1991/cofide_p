function cofide_cursos_ev() {

}
function dblClickCurso(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#CURSOS_EV");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "CURSOS_EV") {
        //En caso de cliente abrimos la opcion de edicion
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "EV_CURSOS") {
            document.getElementById("CEC_ID_CURSO").value = lstVal.CC_CURSO_ID;
            document.getElementById("CEC_CURSO").value = lstVal.CC_NOMBRE_CURSO;
            document.getElementById("CEC_FECHA").value = lstVal.CC_FECHA_INICIAL;
            document.getElementById("CEC_NOM_INSTRUCTOR").value = lstVal.CC_INSTRUCTOR;
            document.getElementById("CEC_CLAVE").value = lstVal.CC_CLAVES;
            document.getElementById("CEC_SEDE").value = lstVal.CC_SEDE;
            document.getElementById("CEC_PRECIO").value = lstVal.CC_PRECIO_UNIT;
            $("#dialog").dialog("close");
        }
    }
}