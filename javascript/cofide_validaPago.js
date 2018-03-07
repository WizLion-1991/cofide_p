function cofide_validaPago() {

}
function initValidaPago() {
    //LlenaGridParticipante();
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
        url: "COFIDE_Edit_Curso.jsp?id=8",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("Participantes")[0]; //dato padre
            var lstCte = lstXml.getElementsByTagName("datos"); //dato detalle
            jQuery("#LCP_GRID").clearGridData();
            for (var i = 0; i < lstCte.length; i++) {
                var obj = lstCte[i];
                //recuperamos datos del jsp
                var datarow = {
                    LCP_NUMERO: i + 1,
                    LCP_NOMBRE: obj.getAttribute('CP_NOMBRE'),
                    LCP_APPAT: obj.getAttribute('CP_APPAT'),
                    LCP_APMAT: obj.getAttribute('CP_APMAT'),
                    LCP_TITULO: obj.getAttribute('CP_TITULO'),
                    LCP_NUMSOC: obj.getAttribute('CP_NOSOCIO'),
                    LCP_CORREO: obj.getAttribute('CP_CORREO'),
                    LCP_COMENT: obj.getAttribute('CP_COMENT'),
                    LCP_FOLIO: obj.getAttribute('CP_TKT_ID'),
                    LCP_ASIST: obj.getAttribute('CP_ASISTENCIA'),
                    LCP_FACT: obj.getAttribute('CP_FAC_ID'),
                    LCP_PAGO: obj.getAttribute('CP_PAGO'),
                    LCP_OBSERV: obj.getAttribute('CP_OBSERVACIONES'),
                    LCP_COMPROBANTE: obj.getAttribute('CP_OBSERVACIONES'),
                    LCP_ASOC: obj.getAttribute('CP_ASCOC')
                }; //fin del grid
                itemIdCob++;
                jQuery("#LCP_GRID").addRowData(itemIdCob, datarow, "last");
            }
            $("#dialogWait").dialog("close");
        }, //fin de la funcion que recupera los datos
        error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
        }
    }); //fin del ajax
}
function LLenaInstructor() {
    //llena los datos del instructor del curso
}
function AutorizaPago() {
    //autoriza el pago dle instructor
}