
function cofide_evaluacion_cursos() {

}
function initEvCurso() {
    LlenaDetaCalif();
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
function EvCurso() {
    var strIdCurso = document.getElementById("CC_CURSO_ID").value;
    var strAsp1 = document.getElementById("CEC_ASP1").value;
    var strAsp2 = document.getElementById("CEC_ASP2").value;
    var strAsp3 = document.getElementById("CEC_ASP3").value;
    var strAsp4 = document.getElementById("CEC_ASP4").value;
    var strPromAsp = document.getElementById("CEC_PROM_ASPECTOS").value;

    var strIns1 = document.getElementById("CEC_INS1").value;
    var strIns2 = document.getElementById("CEC_INS2").value;
    var strIns3 = document.getElementById("CEC_INS3").value;
    var strIns4 = document.getElementById("CEC_INS4").value;
    var strIns5 = document.getElementById("CEC_INS5").value;
    var strPromIns = document.getElementById("CEC_PROM_INSTRUCTOR").value;

    var strIn1 = document.getElementById("CEC_IN1").value;
    var strIn2 = document.getElementById("CEC_IN2").value;
    var strIn3 = document.getElementById("CEC_IN3").value;
    var strIn4 = document.getElementById("CEC_IN4").value;
    var strIn5 = document.getElementById("CEC_IN5").value;
    var strPromIn = document.getElementById("CEC_PROM_INSTALACION").value;

    var strCurso1 = document.getElementById("CEC_CURSO1").value;
    var strCurso2 = document.getElementById("CEC_CURSO2").value;
    if (strAsp1 != '') {
        var strPost = "";
        strPost += "CC_CURSO_ID=" + strIdCurso;
        strPost += "&CEC_ASP1=" + strAsp1;
        strPost += "&CEC_ASP2=" + strAsp2;
        strPost += "&CEC_ASP3=" + strAsp3;
        strPost += "&CEC_ASP4=" + strAsp4;
        strPost += "&CEC_PROM_ASPECTOS=" + strPromAsp;
        strPost += "&CEC_INS1=" + strIns1;
        strPost += "&CEC_INS2=" + strIns2;
        strPost += "&CEC_INS3=" + strIns3;
        strPost += "&CEC_INS4=" + strIns4;
        strPost += "&CEC_INS5=" + strIns5;
        strPost += "&CEC_PROM_INSTRUCTOR=" + strPromIns;
        strPost += "&CEC_IN1=" + strIn1;
        strPost += "&CEC_IN2=" + strIn2;
        strPost += "&CEC_IN3=" + strIn3;
        strPost += "&CEC_IN4=" + strIn4;
        strPost += "&CEC_IN5=" + strIn5;
        strPost += "&CEC_PROM_INSTALACION=" + strPromIn;
        strPost += "&CEC_CURSO1=" + strCurso1;
        strPost += "&CEC_CURSO2=" + strCurso2;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Auto_curso.jsp?ID=3",
        });
        $("#dialog").dialog("close");
    } else {
        alert("Necesitas Evaluar El Curso!")
    }
}
function Calif() {
    var dblAsp1 = 0;
    var dblAsp2 = 0;
    var dblAsp3 = 0;
    var dblAsp4 = 0;
    var dblInst1 = 0;
    var dblInst2 = 0;
    var dblInst3 = 0;
    var dblInst4 = 0;
    var dblInst5 = 0;
    var dblIn1 = 0;
    var dblIn2 = 0;
    var dblIn3 = 0;
    var dblIn4 = 0;
    var dblIn5 = 0;
//aspectos generales
    if (document.getElementById("CEC_ASP_Q10").checked) {
        dblAsp1 = 0;
    }
    if (document.getElementById("CEC_ASP_Q11").checked) {
        dblAsp1 = 2.5;
    }
    if (document.getElementById("CEC_ASP_Q12").checked) {
        dblAsp1 = 5;
    }
    if (document.getElementById("CEC_ASP_Q13").checked) {
        dblAsp1 = 8;
    }
    if (document.getElementById("CEC_ASP_Q14").checked) {
        dblAsp1 = 10;
    }
    document.getElementById("CEC_ASP1").value = dblAsp1;

    if (document.getElementById("CEC_ASP_Q20").checked) {
        dblAsp2 = 0;
    }
    if (document.getElementById("CEC_ASP_Q21").checked) {
        dblAsp2 = 2.5;
    }
    if (document.getElementById("CEC_ASP_Q22").checked) {
        dblAsp2 = 5;
    }
    if (document.getElementById("CEC_ASP_Q23").checked) {
        dblAsp2 = 8;
    }
    if (document.getElementById("CEC_ASP_Q24").checked) {
        dblAsp2 = 10;
    }
    document.getElementById("CEC_ASP2").value = dblAsp2;

    if (document.getElementById("CEC_ASP_Q30").checked) {
        dblAsp3 = 0;
    }
    if (document.getElementById("CEC_ASP_Q31").checked) {
        dblAsp3 = 2.5;
    }
    if (document.getElementById("CEC_ASP_Q32").checked) {
        dblAsp3 = 5;
    }
    if (document.getElementById("CEC_ASP_Q33").checked) {
        dblAsp3 = 8;
    }
    if (document.getElementById("CEC_ASP_Q34").checked) {
        dblAsp3 = 10;
    }
    document.getElementById("CEC_ASP3").value = dblAsp3;

    if (document.getElementById("CEC_ASP_Q40").checked) {
        dblAsp4 = 0;
    }
    if (document.getElementById("CEC_ASP_Q41").checked) {
        dblAsp4 = 2.5;
    }
    if (document.getElementById("CEC_ASP_Q42").checked) {
        dblAsp4 = 5;
    }
    if (document.getElementById("CEC_ASP_Q43").checked) {
        dblAsp4 = 8;
    }
    if (document.getElementById("CEC_ASP_Q44").checked) {
        dblAsp4 = 10;
    }
    document.getElementById("CEC_ASP4").value = dblAsp4;

//instructor
    if (document.getElementById("CEC_INS_Q10").checked) {
        dblInst1 = 0;
    }
    if (document.getElementById("CEC_INS_Q11").checked) {
        dblInst1 = 2.5;
    }
    if (document.getElementById("CEC_INS_Q12").checked) {
        dblInst1 = 5;
    }
    if (document.getElementById("CEC_INS_Q13").checked) {
        dblInst1 = 8;
    }
    if (document.getElementById("CEC_INS_Q14").checked) {
        dblInst1 = 10;
    }
    document.getElementById("CEC_INS1").value = dblInst1;

    if (document.getElementById("CEC_INS_Q20").checked) {
        dblInst2 = 0;
    }
    if (document.getElementById("CEC_INS_Q21").checked) {
        dblInst2 = 2.5;
    }
    if (document.getElementById("CEC_INS_Q22").checked) {
        dblInst2 = 5;
    }
    if (document.getElementById("CEC_INS_Q23").checked) {
        dblInst2 = 8;
    }
    if (document.getElementById("CEC_INS_Q24").checked) {
        dblInst2 = 10;
    }
    document.getElementById("CEC_INS2").value = dblInst2;

    if (document.getElementById("CEC_INS_Q30").checked) {
        dblInst3 = 0;
    }
    if (document.getElementById("CEC_INS_Q31").checked) {
        dblInst3 = 2.5;
    }
    if (document.getElementById("CEC_INS_Q32").checked) {
        dblInst3 = 5;
    }
    if (document.getElementById("CEC_INS_Q33").checked) {
        dblInst3 = 8;
    }
    if (document.getElementById("CEC_INS_Q34").checked) {
        dblInst3 = 10;
    }
    document.getElementById("CEC_INS3").value = dblInst3;

    if (document.getElementById("CEC_INS_Q40").checked) {
        dblInst4 = 0;
    }
    if (document.getElementById("CEC_INS_Q41").checked) {
        dblInst4 = 2.5;
    }
    if (document.getElementById("CEC_INS_Q42").checked) {
        dblInst4 = 5;
    }
    if (document.getElementById("CEC_INS_Q43").checked) {
        dblInst4 = 8;
    }
    if (document.getElementById("CEC_INS_Q44").checked) {
        dblInst4 = 10;
    }
    document.getElementById("CEC_INS4").value = dblInst4;

    if (document.getElementById("CEC_INS_Q50").checked) {
        dblInst5 = 0;
    }
    if (document.getElementById("CEC_INS_Q51").checked) {
        dblInst5 = 2.5;
    }
    if (document.getElementById("CEC_INS_Q52").checked) {
        dblInst5 = 5;
    }
    if (document.getElementById("CEC_INS_Q53").checked) {
        dblInst5 = 8;
    }
    if (document.getElementById("CEC_INS_Q54").checked) {
        dblInst5 = 10;
    }
    document.getElementById("CEC_INS5").value = dblInst5;
    //Institucion
    if (document.getElementById("CEC_IN_Q10").checked) {
        dblIn1 = 0;
    }
    if (document.getElementById("CEC_IN_Q11").checked) {
        dblIn1 = 2.5;
    }
    if (document.getElementById("CEC_IN_Q12").checked) {
        dblIn1 = 5;
    }
    if (document.getElementById("CEC_IN_Q13").checked) {
        dblIn1 = 8;
    }
    if (document.getElementById("CEC_IN_Q14").checked) {
        dblIn1 = 10;
    }
    document.getElementById("CEC_IN1").value = dblIn1;

    if (document.getElementById("CEC_IN_Q20").checked) {
        dblIn2 = 0;
    }
    if (document.getElementById("CEC_IN_Q21").checked) {
        dblIn2 = 2.5;
    }
    if (document.getElementById("CEC_IN_Q22").checked) {
        dblIn2 = 5;
    }
    if (document.getElementById("CEC_IN_Q23").checked) {
        dblIn2 = 8;
    }
    if (document.getElementById("CEC_IN_Q24").checked) {
        dblIn2 = 10;
    }
    document.getElementById("CEC_IN2").value = dblIn2;

    if (document.getElementById("CEC_IN_Q30").checked) {
        dblIn3 = 0;
    }
    if (document.getElementById("CEC_IN_Q31").checked) {
        dblIn3 = 2.5;
    }
    if (document.getElementById("CEC_IN_Q32").checked) {
        dblIn3 = 5;
    }
    if (document.getElementById("CEC_IN_Q33").checked) {
        dblIn3 = 8;
    }
    if (document.getElementById("CEC_IN_Q34").checked) {
        dblIn3 = 10;
    }
    document.getElementById("CEC_IN3").value = dblIn3;

    if (document.getElementById("CEC_IN_Q40").checked) {
        dblIn4 = 0;
    }
    if (document.getElementById("CEC_IN_Q41").checked) {
        dblIn4 = 2.5;
    }
    if (document.getElementById("CEC_IN_Q42").checked) {
        dblIn4 = 5;
    }
    if (document.getElementById("CEC_IN_Q43").checked) {
        dblIn4 = 8;
    }
    if (document.getElementById("CEC_IN_Q44").checked) {
        dblIn4 = 10;
    }
    document.getElementById("CEC_IN4").value = dblIn4;

    if (document.getElementById("CEC_IN_Q50").checked) {
        dblIn5 = 0;
    }
    if (document.getElementById("CEC_IN_Q51").checked) {
        dblIn5 = 2.5;
    }
    if (document.getElementById("CEC_IN_Q52").checked) {
        dblIn5 = 5;
    }
    if (document.getElementById("CEC_IN_Q53").checked) {
        dblIn5 = 8;
    }
    if (document.getElementById("CEC_IN_Q54").checked) {
        dblIn5 = 10;
    }
    document.getElementById("CEC_IN5").value = dblIn5;

    Promedio();
}
function Promedio() {
    var dblAsp1 = parseFloat(document.getElementById("CEC_ASP1").value);
    var dblAsp2 = parseFloat(document.getElementById("CEC_ASP2").value);
    var dblAsp3 = parseFloat(document.getElementById("CEC_ASP3").value);
    var dblAsp4 = parseFloat(document.getElementById("CEC_ASP4").value);
    var dblPromAsp = (dblAsp1 + dblAsp2 + dblAsp3 + dblAsp4) / 4;
    document.getElementById("CEC_PROM_ASPECTOS").value = dblPromAsp;

    var dblInst1 = parseFloat(document.getElementById("CEC_INS1").value);
    var dblInst2 = parseFloat(document.getElementById("CEC_INS2").value);
    var dblInst3 = parseFloat(document.getElementById("CEC_INS3").value);
    var dblInst4 = parseFloat(document.getElementById("CEC_INS4").value);
    var dblInst5 = parseFloat(document.getElementById("CEC_INS5").value);
    var dblPromInst = (dblInst1 + dblInst2 + dblInst3 + dblInst4 + dblInst5) / 5;
    document.getElementById("CEC_PROM_INSTRUCTOR").value = dblPromInst;

    var dblIn1 = parseFloat(document.getElementById("CEC_IN1").value);
    var dblIn2 = parseFloat(document.getElementById("CEC_IN2").value);
    var dblIn3 = parseFloat(document.getElementById("CEC_IN3").value);
    var dblIn4 = parseFloat(document.getElementById("CEC_IN4").value);
    var dblIn5 = parseFloat(document.getElementById("CEC_IN5").value);
    var dblPromIn = (dblIn1 + dblIn2 + dblIn3 + dblIn4 + dblIn5) / 5;
    document.getElementById("CEC_PROM_INSTALACION").value = dblPromIn;

    var dblPromGral = (dblPromAsp + dblPromInst + dblPromIn) / 3;
    document.getElementById("LEV_PROM").value = FormatNumber(dblPromGral, 2, true, false, true, false);
}
function LlenaDetaCalif() {
    var itemIdCob = 0;
    var strAsp1 = "";
    var strAsp2 = "";
    var strAsp3 = "";
    var strAsp4 = "";
    var strInst1 = "";
    var strInst2 = "";
    var strInst3 = "";
    var strInst4 = "";
    var strInst5 = "";
    var strIn1 = "";
    var strIn2 = "";
    var strIn3 = "";
    var strIn4 = "";
    var strIn5 = "";
    var strPromAsp = "";
    var strPromIns = "";
    var strPromIn = "";
    var strCurso1 = "";
    var strCurso2 = "";
    var strCC_CURSO_ID = document.getElementById("CC_CURSO_ID").value;
    var strPost = "";
    strPost += "CC_CURSO_ID=" + strCC_CURSO_ID;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: 'UTF-8',
        contentType: 'application/x-www-form-urlencoded;charset=utf-8',
        cache: false,
        dataType: 'xml',
        url: "COFIDE_Auto_curso.jsp?ID=4",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            jQuery("#GRID_CURSOEVALUAR").clearGridData();
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                //recuperamos datos del jsp
                strAsp1 = objcte.getAttribute("CEC_ASP_Q1");
                strAsp2 = objcte.getAttribute("CEC_ASP_Q2");
                strAsp3 = objcte.getAttribute("CEC_ASP_Q3");
                strAsp4 = objcte.getAttribute("CEC_ASP_Q4");
                strInst1 = objcte.getAttribute("CEC_INS_Q1");
                strInst2 = objcte.getAttribute("CEC_INS_Q2");
                strInst3 = objcte.getAttribute("CEC_INS_Q3");
                strInst4 = objcte.getAttribute("CEC_INS_Q4");
                strInst5 = objcte.getAttribute("CEC_INS_Q5");
                strIn1 = objcte.getAttribute("CEC_IN_Q1");
                strIn2 = objcte.getAttribute("CEC_IN_Q2");
                strIn3 = objcte.getAttribute("CEC_IN_Q3");
                strIn4 = objcte.getAttribute("CEC_IN_Q4");
                strIn5 = objcte.getAttribute("CEC_IN_Q5");
                strPromAsp = objcte.getAttribute("CEC_PROM_ASPECTOS");
                strPromIns = objcte.getAttribute("CEC_PROM_INSTRUCTOR");
                strPromIn = objcte.getAttribute("CEC_PROM_INSTALACION");
                strCurso1 = objcte.getAttribute("CEC_CURSO1");
                strCurso2 = objcte.getAttribute("CEC_CURSO2");
                //llenamos el grid
                var datarow = {
                    LEV_ASP1: strAsp1,
                    LEV_ASP2: strAsp2,
                    LEV_ASP3: strAsp3,
                    LEV_ASP4: strAsp4,
                    LEV_INS1: strInst1,
                    LEV_INS2: strInst2,
                    LEV_INS3: strInst3,
                    LEV_INS4: strInst4,
                    LEV_INS5: strInst5,
                    LEV_IN1: strIn1,
                    LEV_IN2: strIn2,
                    LEV_IN3: strIn3,
                    LEV_IN4: strIn4,
                    LEV_IN5: strIn5,
                    LEV_P1: strPromAsp,
                    LEV_P2: strPromIns,
                    LEV_P3: strPromIn,
                    LEV_CURSOS1: strCurso1,
                    LEV_CURSOS2: strCurso2
                }; //fin del grid
                itemIdCob++;
                jQuery("#GRID_CURSOEVALUAR").addRowData(itemIdCob, datarow, "last");

            }
        } //fin de la funcion que recupera los datos
    }); //fin del ajax
} //fin clase
function EditCalif() {
    var strPost = "";
    strPost += "CC_CURSO_ID=" + document.getElementById("CC_CURSO_ID").value;
    strPost += "&LEV_P1=" + document.getElementById("LEV_P1").value;
    strPost += "&LEV_P2=" + document.getElementById("LEV_P2").value;
    strPost += "&LEV_P3=" + document.getElementById("LEV_P3").value;
    strPost += "&LEV_ASP1=" + document.getElementById("LEV_ASP1").value;
    strPost += "&LEV_ASP2=" + document.getElementById("LEV_ASP2").value;
    strPost += "&LEV_ASP3=" + document.getElementById("LEV_ASP3").value;
    strPost += "&LEV_ASP4=" + document.getElementById("LEV_ASP4").value;
    strPost += "&LEV_INS1=" + document.getElementById("LEV_INS1").value;
    strPost += "&LEV_INS2=" + document.getElementById("LEV_INS2").value;
    strPost += "&LEV_INS3=" + document.getElementById("LEV_INS3").value;
    strPost += "&LEV_INS4=" + document.getElementById("LEV_INS4").value;
    strPost += "&LEV_INS5=" + document.getElementById("LEV_INS5").value;
    strPost += "&LEV_IN1=" + document.getElementById("LEV_IN1").value;
    strPost += "&LEV_IN2=" + document.getElementById("LEV_IN2").value;
    strPost += "&LEV_IN3=" + document.getElementById("LEV_IN3").value;
    strPost += "&LEV_IN4=" + document.getElementById("LEV_IN4").value;
    strPost += "&LEV_IN5=" + document.getElementById("LEV_IN5").value;
    strPost += "&LEV_CURSOS1=" + document.getElementById("LEV_CURSOS1").value;
    strPost += "&LEV_CURSOS2=" + document.getElementById("LEV_CURSOS2").value;
    $("#dialogWait").dialog("open");
    //alert(strPost);
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Auto_curso.jsp?ID=5",
    });
    setTimeout('$("#dialogWait").dialog("close")',1000);
    $("#dialog").dialog("close");
}
function OpnDiagGridCalif() {
    var objSecModiVta = objMap.getScreen("_LC_EV");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("GR_LC_EV", "_ed", "dialog", false, false, true);
}
function initEditCal() {
    var grid = jQuery("#GRID_CURSOEVALUAR");
    var idPart = grid.getGridParam("selrow");
    if (idPart != null) {
        OpnDiagGridCalif();
    } else {
        alert("Debe seleccionar una Evaluación");
    }
}
function initGrCalificacion() {
    var grid = jQuery("#GRID_CURSOEVALUAR");
    var idPart = grid.getGridParam("selrow");
    if (idPart != null) {
        for (var i = 0; i < idPart.length; i++) {
            var id1 = idPart[i];
            var lstRow1 = grid.getRowData(id1);
            document.getElementById("LEV_P1").value = lstRow1.LEV_P1;
            document.getElementById("LEV_P2").value = lstRow1.LEV_P2;
            document.getElementById("LEV_P3").value = lstRow1.LEV_P3;
            document.getElementById("LEV_ASP1").value = lstRow1.LEV_ASP1;
            document.getElementById("LEV_ASP2").value = lstRow1.LEV_ASP2;
            document.getElementById("LEV_ASP3").value = lstRow1.LEV_ASP3;
            document.getElementById("LEV_ASP4").value = lstRow1.LEV_ASP4;
            document.getElementById("LEV_INS1").value = lstRow1.LEV_INS1;
            document.getElementById("LEV_INS2").value = lstRow1.LEV_INS2;
            document.getElementById("LEV_INS3").value = lstRow1.LEV_INS3;
            document.getElementById("LEV_INS4").value = lstRow1.LEV_INS4;
            document.getElementById("LEV_INS5").value = lstRow1.LEV_INS5;
            document.getElementById("LEV_IN1").value = lstRow1.LEV_IN1;
            document.getElementById("LEV_IN2").value = lstRow1.LEV_IN2;
            document.getElementById("LEV_IN3").value = lstRow1.LEV_IN3;
            document.getElementById("LEV_IN4").value = lstRow1.LEV_IN4;
            document.getElementById("LEV_IN5").value = lstRow1.LEV_IN5;
            document.getElementById("LEV_CURSOS1").value = lstRow1.LEV_CURSOS1;
            document.getElementById("LEV_CURSOS2").value = lstRow1.LEV_CURSOS2;
        }
    } else {
        alert("Debe seleccionar un producto");
    }
}
