function cofide_facCurso() {

}
function initFacCurso() {
    LlenaGridParticipante();
}
function LlenaGridParticipante() {
    var itemIdCob = 0;
    $("#dialogWait").dialog("open");
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
        url: "COFIDE_Edit_Curso.jsp?id=7",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("Participantes")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            jQuery("#GRD_LS_FAC").clearGridData();
            for (var i = 0; i < lstCte.length; i++) {
                var obj = lstCte[i];
                //recuperamos datos del jsp
                var datarow = {
                    LSF_NUMERO: i + 1,
                    LSF_NOMBRE: obj.getAttribute('CP_NOMBRE'),
                    LSF_APPAT: obj.getAttribute('CP_APPAT'),
                    LSF_APMAT: obj.getAttribute('CP_APMAT'),
                    LSF_TITULO: obj.getAttribute('CP_TITULO'),
                    LSF_NUMEROSOC: obj.getAttribute('CP_NOSOCIO'),
                    LSF_CORREO: obj.getAttribute('CP_CORREO'),
                    LSF_COMENTARIO: obj.getAttribute('CP_COMENT'),
                    LSF_FOLIO: obj.getAttribute('CP_TKT_ID'),
                    LSF_ASIST: obj.getAttribute('CP_ASISTENCIA'),
                    LSF_FAC: obj.getAttribute('CP_FAC_ID'),
                    LSF_PAGO: obj.getAttribute('CP_PAGO'),
                    LSF_OBSER: obj.getAttribute('CP_OBSERVACIONES'),
                    LSF_ASOC: obj.getAttribute('CP_ASCOC')
                }; //fin del grid
                itemIdCob++;
                jQuery("#GRD_LS_FAC").addRowData(itemIdCob, datarow, "last");
            }
            $("#dialogWait").dialog("close");
        }, //fin de la funcion que recupera los datos
        error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
        }
    }); //fin del ajax
}
function CerrarFacCurso() {
    alert("CURSO CERRADO");
    var strCC_CURSO_ID = document.getElementById("CC_CURSO_ID").value;
    var strPost = "";
    strPost += "CC_CURSO_ID=" + strCC_CURSO_ID;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Edit_Curso.jsp?id=7",
    });
    $("#dialogWait").dialog("close");
}
function EnviarFac() {
//    EnvioMasivoMail masivo = new EnvioMasivoMail(oConn, "MAIL_MASIVAXML", false, sesion);
//    masivo.envioCorreoMasivo(" WHERE CT_ID = 564");
//    masivo.envioCorreoMasivo(" WHERE CT_ES_PROSPECTO = 1 and CT_I_XML = 1 and CT_ID<= 350");
//    System.out.println("Resultado:" + masivo.getStrResultLast());
}