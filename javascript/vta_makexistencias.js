/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function vta_makexistencias() {
}

function initmakexistencias() {
    var strNomMainpr = objMap.getNomMain();
    if (strNomMainpr == "PEDIDOS_MAK") {
        setTimeout("LoadDatosExMak();", 1000);
    }
}

function LoadDatosExMak() {
    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    var lstRow = grid.getRowData(id);
    if (grid.getGridParam("selrow") != null) {
        var itemIdCob = 0;
        jQuery("#GRD_SXB").clearGridData();
        $.ajax({
            type: "POST",
            data: "intPrId=" + lstRow.FACD_CVE,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "XML",
            url: "ERP_PedidosMakProcs.jsp?id=20",
            success: function (datos) {
                var objsc = datos.getElementsByTagName("vta_producto_suc")[0];
                var lstProds = objsc.getElementsByTagName("vta_productos");
                for (var i = 0; i < lstProds.length; i++) {
                    var obj = lstProds[i];
                    var datarow = {
                        SAXBD_CODIGO: obj.getAttribute("PR_CODIGO"),
                        SAXBD_NOMBODEGA: obj.getAttribute("sucursal"),
                        SAXBD_EXISTENCIA: FormatNumber(obj.getAttribute("existencia"), 2, true, false, true, false),
                        SAXBD_ASIGNADO: FormatNumber(obj.getAttribute("asignado"), 2, true, false, true, false),
                        SAXBD_DISPONIBLE: FormatNumber(obj.getAttribute("disponible"), 2, true, false, true, false),
                        SAXBD_OSERVACIONES: obj.getAttribute("observaciones")

                    };

                    itemIdCob++;
                    jQuery("#GRD_SXB").addRowData(itemIdCob, datarow, "last");
                }
                $("#dialogWait").dialog("close");
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });


        var itemIdCob1 = 0;
        jQuery("#GRD_AY").clearGridData();
        $.ajax({
            type: "POST",
            data: "intPrId=" + lstRow.FACD_CVE,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "XML",
            url: "ERP_PedidosMakProcs.jsp?id=26",
            success: function (datos) {
                var objsc = datos.getElementsByTagName("vta_producto_suc")[0];
                var lstProds = objsc.getElementsByTagName("vta_productos");
                for (var i = 0; i < lstProds.length; i++) {
                    var obj = lstProds[i];
                    var datarow1 = {
                        AYODC_DOCUMENTO: obj.getAttribute("documento"),
                        AYODC_MOVIMIENTO: obj.getAttribute("movimiento"),
                        AYODC_BODEGA: obj.getAttribute("bodega"),
                        AYODC_CANTIDAD: FormatNumber(obj.getAttribute("cantidad"), 2, true, false, true, false),
                        AYODC_USUARIO:obj.getAttribute("usuario")
                    };

                    itemIdCob1++;
                    jQuery("#GRD_AY").addRowData(itemIdCob1, datarow1, "last");
                }
                $("#dialogWait").dialog("close");
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });


        //limpiamos el grid
        var grid2 = jQuery("#GRD_DATOS");
        var itemId = 0;
        grid2.clearGridData();
        //consultamos datos
        $("#dialogWait").dialog('open');
        $.ajax({
            type: "POST",
            data: "codigo=" + lstRow.FACD_CVE, //Anadimos parametro PRSINT para mostrar items internos
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "vta_productosOrden.jsp?ID=1",
            success: function (datos) {
                var lstFolios = datos.getElementsByTagName("folios")[0];
                var objFolio = lstFolios.getElementsByTagName("folio")[0];
                var lstdatos = objFolio.getElementsByTagName("datos");

                //LLENAMOS EL GRID DE LOS SEGUIMIENTOS
                for (j = 0; j < lstdatos.length; j++) {
                    var objSeg = lstdatos[j];
                    //Recuperamos el detalle
                    var datarowSeg = {
                        PR_CODIGO: objSeg.getAttribute('PR_CODIGO'),
                        PR_DESCRIPCION: objSeg.getAttribute('PR_DESCRIPCION'),
                        PR_ORDEN: objSeg.getAttribute('COM_ID'),
                        HDD_COM_ID: objSeg.getAttribute('COM_ID_HIDDEN'),
                        PR_FECHA_PROMESA: objSeg.getAttribute('PR_FECHA_PROMESA'),
                        PR_CANTIDAD: objSeg.getAttribute('COMD_CANTIDAD'),
                        PR_FECHAEST: objSeg.getAttribute('COM_FECHA_DISP_VTA'),
                        PR_DIAS: objSeg.getAttribute('COM_DIAS'),
                        tipoodc:objSeg.getAttribute('tipoodc')

                    };
                    //Anexamos el registro al GRID
                    itemId++;
                    jQuery("#GRD_DATOS").addRowData(itemId, datarowSeg, "last");
                }
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":tarifas:" + objeto + " " + quepaso + " " + otroobj);
            }

        });
        $("#dialogWait").dialog('close');


    } else {
        alert("Selecciona un producto en la tabla");
        $("#dialog2").dialog("close");
        $("#dialog").dialog("close");
        $("#dialogWait").dialog("close");
    }
}

function CierraExistenciaMak() {
    $("#dlgMakExist").dialog("close");
}

function ImprimeFormaExistMak() {
    $("#SioNO1").dialog("open");
    $("#SioNO1").dialog('option', 'title', "¿Desea Imprimir Formato con Imagenes?");
    document.getElementById("btnSI1").onclick = function () {
        var grid = jQuery("#GRD_AY");
        var id = grid.getGridParam("selrow");
        if (id != null) {
            var lstRow = grid.getRowData(id);
            ImprimeconFolioImagenesExistMak(lstRow.AYODC_MOVIMIENTO);
        } else {
            alert("Selecciona una fila");
        }
        $("#SioNO1").dialog("close");
    };
    document.getElementById("btnNO1").onclick = function () {
        var grid = jQuery("#GRD_AY");
        var id = grid.getGridParam("selrow");
        if (id != null) {
            var lstRow = grid.getRowData(id);
            ImprimeconFolioExistMak(lstRow.AYODC_MOVIMIENTO );
        } else {
            alert("Selecciona una fila");
        }
        $("#SioNO1").dialog("close");
    };
}

function ImprimeconFolioImagenesExistMak(strKey) {
    Abrir_Link("JasperReport?REP_ID=89&boton_1=PDF&PD_ID=" + strKey, '_reporte', 500, 600, 0, 0);
}

function ImprimeconFolioExistMak(strKey) {
    var strTipo = "2";
    $.ajax({
        type: "POST",
        data: "KEY_ID=" + strKey + "&TYPE_ID=" + strTipo,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=12",
        success: function (datos) {
            var objsc = datos.getElementsByTagName("vta_folios")[0];
            var strFolioT = objsc.getAttribute('FOLIO');
            var strHtml2 = CreaHidden("PD_ID", strKey);
            openFormat("PEDIDO", "PDF", strHtml2, strFolioT);
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ImprimeFolio:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}