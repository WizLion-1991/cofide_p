/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function vta_cteconsultamak() {
}

function initcteconsultamak() {
    var strNomMain = objMap.getNomMain();
    if (strNomMain == "PEDIDOS_MAK") {
        var itemIdCob = 0;
        var strPost = "IdCte=" + document.getElementById("FCT_ID").value;



        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "XML",
            url: "ERP_PedidosMakProcs.jsp?id=15",
            success: function (datos) {
                var objsc = datos.getElementsByTagName("cliente")[0];
                var lstProds = objsc.getElementsByTagName("cliente_deta");
                for (var i = 0; i < lstProds.length; i++) {
                    var obj = lstProds[i];

//                    document.getElementById("CT_ID").value = obj.getAttribute("CT_ID");
                    document.getElementById("CT_RAZONSOCIAL").value = obj.getAttribute("CT_RAZONSOCIAL");
                    document.getElementById("CT_FIADOR").value = obj.getAttribute("CT_FIADOR");
                    document.getElementById("CT_RFC").value = obj.getAttribute("CT_RFC");
                    document.getElementById("CT_RAZONCOMERCIAL").value = obj.getAttribute("CT_RAZONCOMERCIAL");
                    document.getElementById("CT_CALLE").value = obj.getAttribute("CT_CALLE");
                    if (obj.getAttribute("CT_ES_PROSPECTO") == "1") {
                        document.getElementById("CT_ES_PROSPECTO1").checked = 1;
                    } else {
                        document.getElementById("CT_ES_PROSPECTO2").checked = 1;
                    }
                    document.getElementById("SC_ID").value = obj.getAttribute("SC_ID");
                    document.getElementById("CT_F1IFE").value = obj.getAttribute("CT_F1IFE");
                    document.getElementById("CT_CALLE").value = obj.getAttribute("CT_CALLE");
                    document.getElementById("CT_FIADOR2").value = obj.getAttribute("CT_FIADOR2");
                    document.getElementById("CT_FECHA_CONTACTO").value = obj.getAttribute("CT_FECHA_CONTACTO");
                    document.getElementById("CT_NUMERO").value = obj.getAttribute("CT_NUMERO");
                    document.getElementById("CT_F2DIRECCION").value = obj.getAttribute("CT_F2DIRECCION");
                    document.getElementById("CT_NUMINT").value = obj.getAttribute("CT_NUMINT");
                    document.getElementById("CT_F2IFE").value = obj.getAttribute("CT_F2IFE");
                    document.getElementById("CAT_MED_CONT_ID").value = obj.getAttribute("CAT_MED_CONT_ID");
                    document.getElementById("CT_FIADOR3").value = obj.getAttribute("CT_FIADOR3");
                    document.getElementById("CT_COLONIA").value = obj.getAttribute("CT_COLONIA");
                    document.getElementById("CT_F3DIRECCION").value = obj.getAttribute("CT_F3DIRECCION");
                    document.getElementById("CT_UBICACION_GOOGLE").value = obj.getAttribute("CT_UBICACION_GOOGLE");
                    document.getElementById("CT_F3IFE").value = obj.getAttribute("CT_F3IFE");
                    document.getElementById("CT_FACEBOOK").value = obj.getAttribute("CT_FACEBOOK");
                    document.getElementById("CT_MUNICIPIO").value = obj.getAttribute("CT_MUNICIPIO");
                    document.getElementById("CT_PAGINA_WEB").value = obj.getAttribute("CT_PAGINA_WEB");
                    document.getElementById("CT_LOCALIDAD").value = obj.getAttribute("CT_LOCALIDAD");
                    document.getElementById("PA_ID").value = obj.getAttribute("PA_ID");
                    document.getElementById("CT_POR_CIERRE").value = obj.getAttribute("CT_POR_CIERRE");
                    document.getElementById("CT_ESTADO").value = obj.getAttribute("CT_ESTADO");
                    document.getElementById("CT_CP").value = obj.getAttribute("CT_CP");
                    document.getElementById("EP_ID").value = obj.getAttribute("EP_ID");
                    document.getElementById("CT_TELEFONO1").value = obj.getAttribute("CT_TELEFONO1");
                    document.getElementById("CAM_ID").value = obj.getAttribute("CAM_ID");
                    document.getElementById("CT_TELEFONO2").value = obj.getAttribute("CT_TELEFONO2");
                    document.getElementById("CT_CONTACTO1").value = obj.getAttribute("CT_CONTACTO1");
                    document.getElementById("CT_CONTACTO2").value = obj.getAttribute("CT_CONTACTO2");
                    document.getElementById("CT_EMAIL1").value = obj.getAttribute("CT_EMAIL1");
                    document.getElementById("CT_EMAIL2").value = obj.getAttribute("CT_EMAIL2");
                    document.getElementById("CT_LPRECIOS").value = obj.getAttribute("CT_LPRECIOS");
                    document.getElementById("CT_DESCUENTO").value = obj.getAttribute("CT_DESCUENTO");
                    document.getElementById("CT_CTABANCO1").value = obj.getAttribute("CT_CTABANCO1");
                    document.getElementById("CT_CTABANCO2").value = obj.getAttribute("CT_CTABANCO2");
                    document.getElementById("CT_DIASCREDITO").value = obj.getAttribute("CT_DIASCREDITO");
                    document.getElementById("CT_MONTOCRED").value = obj.getAttribute("CT_MONTOCRED");
                    document.getElementById("CT_CTATARJETA").value = obj.getAttribute("CT_CTATARJETA");
                    document.getElementById("CT_CONTAVTA").value = obj.getAttribute("CT_CONTAVTA");
                    document.getElementById("CT_CONTACTE").value = obj.getAttribute("CT_CONTACTE");
                    document.getElementById("CT_CONTAPAG").value = obj.getAttribute("CT_CONTAPAG");
                    document.getElementById("CT_CTA_ANTICIPO").value = obj.getAttribute("CT_CTA_ANTICIPO");
                    document.getElementById("CT_CONTACTE_COMPL").value = obj.getAttribute("CT_CONTACTE_COMPL");
                    document.getElementById("CT_CTACTE_COMPL_ANTI").value = obj.getAttribute("CT_CTACTE_COMPL_ANTI");
                    document.getElementById("CT_CONTA_RET_ISR").value = obj.getAttribute("CT_CONTA_RET_ISR");
                    document.getElementById("CT_CONTA_RET_IVA").value = obj.getAttribute("CT_CONTA_RET_IVA");
                    document.getElementById("MON_ID").value = obj.getAttribute("MON_ID");
                    document.getElementById("TI_ID").value = obj.getAttribute("TI_ID");
                    document.getElementById("TTC_ID").value = obj.getAttribute("TTC_ID");
                    document.getElementById("CT_PASSWORD").value = obj.getAttribute("CT_PASSWORD");
                    document.getElementById("CT_VENDEDOR").value = obj.getAttribute("CT_VENDEDOR");
//                    document.getElementById("CT_IDIOMA").value = obj.getAttribute("CT_IDIOMA");
                    document.getElementById("CT_FECHAREG").value = obj.getAttribute("CT_FECHAREG");
                    document.getElementById("CT_NOTAS").value = obj.getAttribute("CT_NOTAS");
//                    document.getElementById("CT_TIPOPERS").value = obj.getAttribute("CT_TIPOPERS");
                    if (obj.getAttribute("CT_ACTIVO") == "1") {
                        document.getElementById("CT_ACTIVO1").checked = 1;
                    } else {
                        document.getElementById("CT_ACTIVO2").checked = 1;
                    }
                    document.getElementById("CT_METODODEPAGO").value = obj.getAttribute("CT_METODODEPAGO");
                    document.getElementById("CT_FORMADEPAGO").value = obj.getAttribute("CT_FORMADEPAGO");
//                    document.getElementById("CT_TIPOFAC").value = obj.getAttribute("CT_TIPOFAC");
                    document.getElementById("CT_RLEGAL").value = obj.getAttribute("CT_RLEGAL");
                    document.getElementById("CT_CATEGORIA1").value = obj.getAttribute("CT_CATEGORIA1");
                    document.getElementById("CT_CATEGORIA2").value = obj.getAttribute("CT_CATEGORIA2");
                    document.getElementById("CT_CATEGORIA3").value = obj.getAttribute("CT_CATEGORIA3");
                    document.getElementById("CT_CATEGORIA4").value = obj.getAttribute("CT_CATEGORIA4");
                    document.getElementById("CT_CATEGORIA5").value = obj.getAttribute("CT_CATEGORIA5");
                    document.getElementById("CT_CATEGORIA6").value = obj.getAttribute("CT_CATEGORIA6");
                    document.getElementById("CT_BANCO1").value = obj.getAttribute("CT_BANCO1");
                    document.getElementById("CT_CATEGORIA7").value = obj.getAttribute("CT_CATEGORIA7");
                    document.getElementById("CT_RBANCARIA1").value = obj.getAttribute("CT_RBANCARIA1");
                    document.getElementById("CT_CATEGORIA8").value = obj.getAttribute("CT_CATEGORIA8");
                    document.getElementById("CT_CATEGORIA9").value = obj.getAttribute("CT_CATEGORIA9");
                    document.getElementById("CT_RBANCARIA2").value = obj.getAttribute("CT_RBANCARIA2");
                    document.getElementById("CT_CATEGORIA10").value = obj.getAttribute("CT_CATEGORIA10");
                    document.getElementById("CT_BANCO3").value = obj.getAttribute("CT_BANCO3");
                    document.getElementById("CT_RBANCARIA3").value = obj.getAttribute("CT_RBANCARIA3");
                    document.getElementById("CT_NUMPREDIAL").value = obj.getAttribute("CT_NUMPREDIAL");
                    if (obj.getAttribute("CT_ENVIO_FACTURA") == "1") {
                        document.getElementById("CT_ENVIO_FACTURA1").checked = 1;
                    } else {
                        document.getElementById("CT_ENVIO_FACTURA2").checked = 1;
                    }
                    document.getElementById("EMP_ID").value = obj.getAttribute("EMP_ID");
                }

                $("#dialogWait").dialog("close");
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    }
}

function salirConsultaCte() {

    $("#dialog2").dialog("close");
}