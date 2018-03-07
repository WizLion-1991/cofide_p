function cofide_capital_humano() {

}
function initCapH() {
    document.getElementById("CH_ES_CURSO1").checked = true;
    document.getElementById("CH_CURSO_").value = "";
    document.getElementById("CH_CURSO_").disabled = true;
    document.getElementById("CH_CURSO_").style.backgroundColor = '#e0f8e6';
    document.getElementById("CH_CURSO").disabled = false;
}
/**
 * guarda los datos de capital humano sobre los cursos que han tomado los colaboradores
 * @returns 
 */
function Save() {
    var strEsCurso = document.getElementById("CH_ES_CURSO1").checked;
    var stridCurso = document.getElementById("CH_CURSO").value;
    var strNomCurso = document.getElementById("CH_CURSO_").value;
    var strIdColaborador = document.getElementById("CH_COLABORADOR").value;
    var strIdTitulo = document.getElementById("CH_TITULO").value;
    var strEmpresa = document.getElementById("CH_EMPRESA").value;
    var strFecha = document.getElementById("CH_FECHA").value;
    var strCosto = document.getElementById("CH_COSTO").value;
    var strPost = "";
    if (EsCursoCFD()) { //si es verdadero el curso cofide, manda el id del curso y el nombre del curso vacio
        strPost += "es_cofide=1";
        strPost += "&id_curso=" + stridCurso;
        strPost += "&nombre_curso=";
    } else { // si es falso, manda el nombre del curso y el id del curso en 0
        strPost += "es_cofide=0";
        strPost += "&id_curso=0";
        strPost += "&nombre_curso=" + strNomCurso;
    }
    strPost += "&colaborador=" + strIdColaborador;
    strPost += "&titulo=" + strIdTitulo;
    strPost += "&empresa=" + strEmpresa;
    strPost += "&fecha=" + strFecha;
    strPost += "&costo=" + strCosto;
    console.log(strPost);
    if (validaCampos()) {
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Capital_humano.jsp?id=1",
            success: function (datos) {
                $("#dialogWait").dialog("close");
                ResetPantallaCapH();
            }, error: function (objeto, quepaso, otroobj) {
                alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }});
    } else {
        alert("Selecciona a un colaborador");
    }
}
/**
 * valida si es un curso de cofide o externo
 * @returns {undefined}
 */
function EsCursoCFD() {
    var bolCofide = false;
    var bolEsCursoCFD = document.getElementById("CH_ES_CURSO1").checked;
    if (bolEsCursoCFD) {
        document.getElementById("CH_CURSO_").value = "";
        document.getElementById("CH_CURSO_").disabled = true;
        document.getElementById("CH_CURSO_").style.backgroundColor = '#e0f8e6';
        document.getElementById("CH_CURSO").disabled = false;
        bolCofide = true;
    } else {
        document.getElementById("CH_CURSO_").disabled = false;
        document.getElementById("CH_CURSO_").style.backgroundColor = '#ffffff';
        document.getElementById("CH_CURSO").disabled = true;
        document.getElementById("CH_CURSO").value = "";
    }
    return bolCofide;
}
/**
 * limpiar campos
 */
function ResetPantallaCapH() {
    document.getElementById("CH_CURSO").value = "";
    document.getElementById("CH_CURSO_").value = "";
    document.getElementById("CH_COLABORADOR").value = "";
    document.getElementById("CH_TITULO").value = "";
    document.getElementById("CH_EMPRESA").value = "";
    document.getElementById("CH_FECHA").value = "";
    document.getElementById("CH_COSTO").value = "";
}
function validaCampos() {
    var bolOk = false;
    if (document.getElementById("CH_FECHA").value != "" || document.getElementById("CH_COLABORADOR").value != "0") {
        bolOk = true;
    }
    console.log(bolOk);
    return bolOk;
}