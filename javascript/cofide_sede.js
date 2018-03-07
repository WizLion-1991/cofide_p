function cofide_sede() {

}
function dblClickSede(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#C_SEDES");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "C_SEDES") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_CURSOS") {
            document.getElementById("CC_SEDE_ID").value = lstVal.CS_SEDE_ID;
            document.getElementById("CC_SEDE").value = lstVal.CS_SEDE;
            document.getElementById("CC_ESTADOS").value = lstVal.CS_ESTADOS;
            $("#dialogCte").dialog("close");
        } else {
            if (strNomMain == "E1_CURSOS") {
                document.getElementById("CC_SEDE_ID").value = lstVal.CS_SEDE_ID;
                document.getElementById("CC_SEDE").value = lstVal.CS_SEDE;
                document.getElementById("CC_ESTADOS").value = lstVal.CS_ESTADOS;
                $("#dialogCte").dialog("close");
            } else {
                if (strNomMain == "E2_CURSOS") {
                    document.getElementById("CC_SEDE_ID").value = lstVal.CS_SEDE_ID;
                    document.getElementById("CC_SEDE").value = lstVal.CS_SEDE;
                    document.getElementById("CC_ESTADOS").value = lstVal.CS_ESTADOS;
                    $("#dialogCte").dialog("close");
                }
            }
        }
    }
}
function dblClickSedeH(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#H_SEDES");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "H_SEDES") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_CURSOS") {
            document.getElementById("CC_SEDE_ID").value = lstVal.CSH_ID;
            document.getElementById("CC_SEDE").value = lstVal.CSH_SEDE;
            document.getElementById("CC_ESTADOS").value = lstVal.CSH_ESTADOS;
            $("#dialogCte").dialog("close");
        }
    }
}