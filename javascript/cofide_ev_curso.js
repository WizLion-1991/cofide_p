function cofide_ev_curso() {
}
function initEvCurso() {
    valCalificacion();
}
function evaluaCurso() {
    var strfecha = document.getElementById("CEC_FECHA").value;
    var strInstructor = document.getElementById("CEC_NOM_INSTRUCTOR").value;
    var dblInstructor = parseFloat(document.getElementById("CEC_INSTRUCTOR").value);
    var dblExpCurso = parseFloat(document.getElementById("CEC_EXP_CURSO").value);
    var dblAtencion = parseFloat(document.getElementById("CEC_ATN_TEL").value);
    var dblEdecan = parseFloat(document.getElementById("CEC_EDECAN").value);
    var strResponsable = document.getElementById("CEC_RESPONSABLE").value;
    var dblDuracion = parseFloat(document.getElementById("CEC_DURACION").value);
    var dblAula = parseFloat(document.getElementById("CEC_AULA").value);
    var dblAudio = parseFloat(document.getElementById("CEC_PROYECCION_AUDIO").value);
    var dblAreas = parseFloat(document.getElementById("CEC_AREAS_COMUNES").value);
    var dblrestaurant = parseFloat(document.getElementById("CEC_RESTAURANT").value);
    var dblValet = parseFloat(document.getElementById("CEC_PARKING").value);
    var intAsistente = parseFloat(document.getElementById("CEC_ASISTENTES").value);
    var dblEvaluacion = 0;
    dblEvaluacion = dblInstructor + dblExpCurso + dblAtencion + dblEdecan +
            dblDuracion + dblAula + dblAudio + dblAreas + dblrestaurant +
            dblValet;
    dblEvaluacion = dblEvaluacion / 10;
    document.getElementById("CEC_EVALUACION").value = dblEvaluacion;
}
function OpnDiagEvCurso() {
    var objSecModiVta = objMap.getScreen("CURSOS_EV");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("CURSOS_EV", "grid", "dialog", false, false, true);
}
function bloqModiCurso() {
    //quita el icono para seleccionar un curso
    document.getElementById("img_CEC_CURSO").style.display = 'none';
}