function cofide_curso_activo() {

}
function initCActivo() {
//document.getElementById("btn1").parentNode.parentNode.style.display = "none";
    myLayout.close("west");
    myLayout.close("east");
    myLayout.close("south");
    myLayout.close("north");
    loadTodoScreen();
    llenaSelectMes();
}
function loadTodoScreen() { //TODO
    $.ajax({
        url: "COFIDE_curso_activo.jsp",
        dataType: "html",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        success: function (datos) {
            document.getElementById("CACT_TODO1").innerHTML = datos;
        }
    });
}
function loadMesScreen(strMesNum) { //MES
    var strMes = "";//document.getElementById("CACT_MES2").value;
    if (strMesNum.length == 1) {
        strMes = "0" + strMesNum;
    } else {
        strMes = strMesNum;
    }
    if (strMes != "Selecciona una Opción...") {
        var strPost = "CACT_MES2=" + strMes;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_CursoMes.jsp",
//            url: "COFIDE_curso_mes.jsp",
            success: function (datos) {
                document.getElementById("CACT_MES1").innerHTML = datos;
            }});
    } else {
        alert("Elige una opción");
    }
}
function llenaSelectMes() {

//    var strMes = document.getElementById("CACT_MES2");
//    select_clear(strMes);
//    select_add(strMes, "ENERO", "01");
//    select_add(strMes, "FEBRERO", "02");
//    select_add(strMes, "MARZO", "03");
//    select_add(strMes, "ABRIL", "04");
//    select_add(strMes, "MAYO", "05");
//    select_add(strMes, "JUNIO", "06");
//    select_add(strMes, "JULIO", "07");
//    select_add(strMes, "AGOSTO", "08");
//    select_add(strMes, "SEPTIEMBRE", "09");
//    select_add(strMes, "OCTUBRE", "10");
//    select_add(strMes, "NOVIEMBRE", "11");
//    select_add(strMes, "DICIEMBRE", "12");

    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Cursos.jsp?id=13",
        success: function (datos) {
            var objMesCombo = document.getElementById("CACT_MES2");
            select_clear(objMesCombo);
            var lstXml = datos.getElementsByTagName("meses")[0];
            var lstCte = lstXml.getElementsByTagName("mes");
            for (var i = 0; i < lstCte.length; i++) {
                var objMes = lstCte[i];
                select_add(objMesCombo, objMes.getAttribute("valor1"), objMes.getAttribute("valor2"));
            }
        }
    });
}
function loadSedeScreen(strSede) { //SEDE
    //var strSede = document.getElementById("CACT_SEDE2").value;
    if (strSede != "Selecciona una Opción...") {
        var strPost = "CACT_SEDE2=" + strSede;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_CursoSede.jsp",
//            url: "COFIDE_curso_sede.jsp",
            success: function (datos) {
                document.getElementById("CACT_SEDE1").innerHTML = datos;
            }});
    } else {
        alert("Elige una opción");
    }
}
function loadTipoScreen(strTipoCurso) {
//    var strTipo = document.getElementById("CACT_TIPO2").value;
//    if (strTipo != "Selecciona Una Opción...") {
    var strPost = "CACT_TIPO2=" + strTipoCurso;
//        var strPost = "CACT_TIPO2=" + strTipo;
    $.ajax({
        type: "POST",
        data: strPost,
        url: "COFIDE_CursoTipo.jsp",
//            url: "COFIDE_curso_tipo.jsp",
        dataType: "html",
        scriptCharset: "utf-8",
        cache: false,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        success: function (datos) {
            document.getElementById("CACT_TIPO1").innerHTML = datos;
        }
    });
//    } else {
//        alert("Selecciona una opción");
//    }
}
function llenaSelectTipo() {
    var strMes = document.getElementById("CACT_TIPO2");
    select_clear(strMes);
    select_add(strMes, "PRESENCIAL", " CC_IS_PRESENCIAL = 1");
    select_add(strMes, "ONLINE", " CC_IS_ONLINE = 1");
    select_add(strMes, "VIDEO", " CC_IS_VIDEO = 1");
    loadTipoScreen();
}
function loadDiplomadoScreen() { //diplomados
    $.ajax({
        url: "COFIDE_Curso_diplomado.jsp",
        dataType: "html",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        success: function (datos) {
            document.getElementById("CACT_DIPLO1").innerHTML = datos;
        }
    });
}
function loadSeminarioScreen() { //seminario
    $.ajax({
        url: "COFIDE_Curso_seminario.jsp",
        dataType: "html",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        success: function (datos) {
            document.getElementById("CACT_SEMI1").innerHTML = datos;
        }
    });
}
//Controla el flujo de los tabs
function tabShowRepo(event, ui) {
//    var idx = document.getElementById("EMP_ID").value;
    if (ui.newTab.index() == 3) {
        llenaSelectTipo();
    }
    if (ui.newTab.index() == 4) {
        loadSeminarioScreen();
    }
    if (ui.newTab.index() == 5) {
        loadDiplomadoScreen();
    }
}
function BuscarCurso() {
    var strCurso = document.getElementById("Buscar").value;
//    var strPost = strCurso;
    var strPost2 = "CURSO=" + strCurso;
//    $(function () {
//        $("#Buscar").autocomplete({//campo de texto que tendra el autocmplete
//            source: "COFIDE_Telemarketing.jsp?ID=12&" + strPost,
//            minLength: 2
//        });
//    });
    if (strCurso != "") {
        $.ajax({
            type: "POST",
            data: strPost2,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_CursoFind.jsp",
            success: function (datos) {
                document.getElementById("CACT_CURSOS").innerHTML = datos;
            }});
    } else {
        alert("Ingresa tu busqueda");
    }
}
//pinta la grafica con los parametros cursos activos
function DrawGraphic(idCurso, intEquipoA, intEquipoB, intEquipoC) {
    $(function () {
// Create the chart
        $('#cofide_grafica' + idCurso).highcharts({
            chart: {type: 'pie'},
            title: {text: 'curso'},
            series: [{
                    name: 'Ventas',
                    data: [
                        {name: 'Equipo A', y: intEquipoA, },
                        {name: 'Equipo B', y: intEquipoB, },
                        {name: 'Equipo C', y: intEquipoC, }
                    ]
                }],
        });
    });
}
//pinta la grafica con los parametros cursos mes
function DrawGraphicMes(idCurso, intVen, intDisp) {
    $(function () {
        $(document).ready(function () {
// Build the chart
            $('#cofide_grafica_mes' + idCurso).highcharts({
                chart: {type: 'pie'},
                series: [{
                        data: [{
                                name: 'Vendidos',
                                y: intVen,
//                                y: 40,
                            }, {
                                name: 'DIsponibles',
                                y: intDisp
//                                y: 10
                            }]
                    }]
            });
        });
    });
}
function DrawGraphicSede(idCurso, intVen, intDisp) {
    $(function () {
        $(document).ready(function () {
// Build the chart
            $('#cofide_grafica_sede' + idCurso).highcharts({
                chart: {type: 'pie'},
                series: [{
                        data: [{
                                name: 'Vendidos',
                                y: intVen,
//                                y: 40,
                            }, {
                                name: 'DIsponibles',
                                y: intDisp
//                                y: 10
                            }]
                    }]
            });
        });
    });
}
function DrawGraphicTipo(idCurso, intVen, intDisp) {
    $(function () {
        $(document).ready(function () {
// Build the chart
            $('#cofide_grafica_tipo' + idCurso).highcharts({
                chart: {type: 'pie'},
                series: [{
                        data: [{
                                name: 'Vendidos',
                                y: intVen,
//                                y: 40,
                            }, {
                                name: 'DIsponibles',
                                y: intDisp
//                                y: 10
                            }]
                    }]
    });
        });
    });
}
function OpnDetalleCurso(strIdCurso) {
    open('COFIDE_CursoPopUp.jsp?id=' + strIdCurso, '', 'top=50,left=200,width=1300,height=800');
}
function openRepCurso(intIdCurso){
    Abrir_Link("JasperReport?REP_ID=512&boton_1=PDF&ID_CURSO=" + intIdCurso, '_reporte', 500, 600, 0, 0);
}