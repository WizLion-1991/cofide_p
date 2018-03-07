function cofide_listado_cursos_ev(){
    
}
function init_ListCurso_ev(){
    
}
function OpnDiagCursosEv() {
    var objSecModiVta = objMap.getScreen("EV_C");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("EV_C", "_ed", "dialog", false, false, true);
}
