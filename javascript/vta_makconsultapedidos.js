/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function vta_makconsultapedidos() {
}
var bolAnularVta = false;
var bolSoyMain = false;
var strNomMain = false;
//Variables globales
var itemId = 0;//indice para los items del grid
var lstPorcDesc = null;//Arreglo con los porcentajes de descuento
var bolPrice = false;
var bolPorc = false;
var bolCambioFecha = false;
var bolDevol = false;
//Inicializamos impuestos con sucursal default
var dblTasaVta1 = dblTasa1;
var dblTasaVta2 = dblTasa2;
var dblTasaVta3 = dblTasa3;
var intIdTasaVta1 = intIdTasa1;
var intIdTasaVta2 = intIdTasa2;
var intIdTasaVta3 = intIdTasa3;
var intSImpVta1_2 = intSImp1_2;
var intSImpVta1_3 = intSImp1_3;
var intSImpVta2_3 = intSImp2_3;
var intCT_TIPOPERS = 0;
var intCT_TIPOFAC = 0;
var strCT_USOIMBUEBLE = "";

function Initmakconsultapedidos() {
    try {
        document.getElementById("btn1").style.display = "none";

    } catch (err) {

    }

    ActivaButtonsCPMAk(false, false, false, false, false, false, !bolSoyMain, false, false, false);
    //Obtenemos permisos
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "keys=98",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "Acceso.do",
        success: function (datos) {
            var objsc = datos.getElementsByTagName("Access")[0];
            var lstKeys = objsc.getElementsByTagName("key");
            for (i = 0; i < lstKeys.length; i++) {
                var obj = lstKeys[i];
                if (obj.getAttribute('id') == 98 && obj.getAttribute('enabled') == "true") {
                    bolAnularVta = true;
                }
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

function ViewOperaCPMAk() {

}


/**Ejecuta el filtro para consultar las ventas*/
function ViewDoCPMAk() {
    //Validamossi somos el main
    bolSoyMain = false;
    strNomMain = objMap.getNomMain();
    if (strNomMain == "VTAS_VIEW") {
        bolSoyMain = true;
    }
    var bolPasa = true;
    ValidaCleanCPMAk("VIEW_TIPO");
    if (document.getElementById("VIEW_TIPO").value == "" || document.getElementById("VIEW_TIPO").value == "0") {
        ValidaShowCPMAk("VIEW_TIPO", "NECESITA SELECCIONAR EL TIPO DE VENTA")
        bolPasa = false;
    }

    //Si pasa enviamos la peticion de la consulta
    if (bolPasa) {
        //Inicializamos todos los botones
        ActivaButtonsCPMAk(bolAnularVta, true, false, false, false, false, !bolSoyMain, true, false, false);
        //Prefijos dependiendo del tipo de venta
        var strPrefijoMaster = "TKT";
        strNomOrderView = "TKT_FECHA";
        strNomFormView = "TICKETVIEW";
        strKeyView = "TKT_ID";
        strNomFormatPrint = "TICKET";
        strTipoVtaView = "2";

        if (document.getElementById("VIEW_TIPO").value == "3") {
            //Pedido
            strPrefijoMaster = "PD";
            strNomFormView = "PEDIDOVIEW";
            strNomOrderView = "PD_ID";
            strKeyView = "PD_ID";
            strNomFormatPrint = "PEDIDO";
            strTipoVtaView = "3";
            if (bolSoyMain) {
                ActivaButtonsCPMAk(bolAnularVta, true, false, false, false, false, !bolSoyMain, true, false, false);
            } else {
                ActivaButtonsCPMAk(bolAnularVta, true, false, false, false, false, !bolSoyMain, true, false, false);
            }
        }

        //Armamos el filtro
        var strParams = "&" + strPrefijoMaster + "_ANULADA=999";
        strParams += "&" + strPrefijoMaster + "_ESRECU=999";
        var strFecha1 = document.getElementById("VIEW_FECHA1").value;
        var strFecha2 = document.getElementById("VIEW_FECHA2").value;
        var strId = document.getElementById("VIEW_ID").value;
        //Si seleccionaron el ID filtramos por el
        if (strId != "0" && strId != "") {
            strParams += "&" + strKeyView + "=" + strId + "";
        } else {
            if (strFecha1 != "" && strFecha2 != "") {
                strParams += "&" + strPrefijoMaster + "_FECHA1=" + strFecha1 + "&" + strPrefijoMaster + "_FECHA2=" + strFecha2 + "";
            }
            if (document.getElementById("VIEW_SUCURSAL").value != "0") {
                strParams += "&SC_ID=" + document.getElementById("VIEW_SUCURSAL").value + "";
            }
            if (document.getElementById("VIEW_CLIENTE").value != "0") {
                strParams += "&CT_ID=" + document.getElementById("VIEW_CLIENTE").value + "";
            }
            if (document.getElementById("VIEW_TIPO").value == "1") {
                if (document.getElementById("VIEW_FOLIO").value != "") {
                    strParams += "&" + strPrefijoMaster + "_FOLIO_C=" + document.getElementById("VIEW_FOLIO").value + "";
                }

            } else {
                if (document.getElementById("VIEW_FOLIO").value != "") {
                    strParams += "&" + strPrefijoMaster + "_FOLIO=" + document.getElementById("VIEW_FOLIO").value + "";
                }
            }
            if (document.getElementById("VIEW_EMP").value != "0") {
                strParams += "&EMP_ID=" + document.getElementById("VIEW_EMP").value + "";
            }
        }
        //Hacemos trigger en el grid
        var grid = jQuery("#VIEW_GRID1");
        grid.setGridParam({
            url: "CIP_TablaOp.jsp?ID=5&opnOpt=" + strNomFormView + "&_search=true" + strParams
        });
        grid.setGridParam({
            sortname: strNomOrderView
        }).trigger('reloadGrid');

    }
}

//Limpia el campo antes de validarlo
function ValidaCleanCPMAk(strNomField) {
    var objDivErr = document.getElementById("err_" + strNomField);
    if (objDivErr != null) {
        objDivErr.innerHTML = "";
        objDivErr.setAttribute("class", "");
        objDivErr.setAttribute("className", "");
    }
}

//Muestra el error de la validacion
function ValidaShowCPMAk(strNomField, strMsg) {
    var objDivErr = document.getElementById("err_" + strNomField);
    objDivErr.setAttribute("class", "");
    objDivErr.setAttribute("class", "inError");
    objDivErr.setAttribute("className", "inError");
    objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsg;
}


/**
 *Se encarga de activar o inactivar botones de acuerdo al tipo de documento
 **/
function ActivaButtonsCPMAk(bolAnular, bolPrint, bolXML, bolRemiPedi, bolFactPedi, bolRecurr,
        bolExit, bolEditaDato, bolCerrar, bolFactCoti, bolRemiCoti, bolPediCoti, bolEstatusCoti) {

    bolAnular = false;
    bolPrint = false;
    bolXML = false;
    bolRemiPedi = false;
    bolFactPedi = false;
    bolRecurr = false;
    bolExit = false;
    bolEditaDato = false;
    bolCerrar = false;
    bolFactCoti = false;
    bolRemiCoti = false;
    bolPediCoti = false;
    bolEstatusCoti = false;



    //vv_btnCancel
    if (bolAnular) {
        document.getElementById("vv_btnCancel").style.display = "block";
    } else {
        document.getElementById("vv_btnCancel").style.display = "none";
    }
    if (bolCerrar) {
        document.getElementById("bt_Cerrar").style.display = "block";
    } else {
        document.getElementById("bt_Cerrar").style.display = "none";
    }

    //vv_btnPrint
    if (bolPrint) {
        document.getElementById("vv_btnPrint").style.display = "block";
    } else {
        document.getElementById("vv_btnPrint").style.display = "none";
    }
    //vv_btnXML
    if (bolXML) {
        document.getElementById("vv_btnXML").style.display = "block";
    } else {
        document.getElementById("vv_btnXML").style.display = "none";
    }
    //vv_btnOrders
    if (bolRemiPedi) {
        document.getElementById("vv_btnOrders").style.display = "block";
    } else {
        document.getElementById("vv_btnOrders").style.display = "none";
    }
    //vv_btnProccess
    if (bolFactPedi) {
        document.getElementById("vv_btnProccess").style.display = "block";
    } else {
        document.getElementById("vv_btnProccess").style.display = "none";
    }
    //vv_btnrecycle
    if (bolRecurr) {
        document.getElementById("vv_btnrecycle").style.display = "block";
    } else {
        document.getElementById("vv_btnrecycle").style.display = "none";
    }
    //vv_btnExit
    if (bolExit) {
        document.getElementById("vv_btnExit").style.display = "block";
    } else {
        document.getElementById("vv_btnExit").style.display = "none";
    }
    if (bolEditaDato) {
        document.getElementById("vv_btnEdita").style.display = "block";
    } else {
        document.getElementById("vv_btnEdita").style.display = "none";
    }

    if (bolFactCoti == null)
        bolFactCoti = false;
    if (bolFactCoti) {
        document.getElementById("btCt_2").style.display = "block";
    } else {
        document.getElementById("btCt_2").style.display = "none";
    }
    if (bolRemiCoti == null)
        bolRemiCoti = false;
    if (bolRemiCoti) {
        document.getElementById("btCt_3").style.display = "block";
    } else {
        document.getElementById("btCt_3").style.display = "none";
    }
    if (bolPediCoti == null)
        bolPediCoti = false;
    if (bolPediCoti) {
        document.getElementById("btCt_1").style.display = "block";
    } else {
        document.getElementById("btCt_1").style.display = "none";
    }
    if (bolEstatusCoti == null)
        bolEstatusCoti = false;
    if (bolEstatusCoti) {
        document.getElementById("btCt_4").style.display = "block";
    } else {
        document.getElementById("btCt_4").style.display = "none";
    }

}

function ShowPedidoCPMAk() {
    var grid = jQuery("#VIEW_GRID1");
    if (grid.getGridParam("selrow") != null) {
        if (document.getElementById("VIEW_TIPO").value == "3") {
            getPedidoenVentaCPMAk(grid.getGridParam("selrow"), "PEDIDO");
        }
    }
    $("#dialogWait").dialog("close");
    $("#dialogView").dialog("close");
}

/**Carga la informacion de una operacion de REMISION FACTURA O PEDIDO*/
function getPedidoenVentaCPMAk(intIdPedido, strTipoVta) {
    //Mandamos la peticion por ajax para que nos den el XML del pedido
    $.ajax({
        type: "POST",
        data: "PD_ID=" + intIdPedido,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=8",
        success: function (datos) {
            var objPedido = datos.getElementsByTagName("vta_pedido")[0];
            var lstdeta = objPedido.getElementsByTagName("deta");
            //Validamos que sea un pedido correcto
            if (objPedido.getAttribute('PD_ANULADA') == 0) {
                //No facturado
                if (objPedido.getAttribute("FAC_ID") == 0 ||
                        (objPedido.getAttribute("FAC_ID") != 0 && objPedido.getAttribute('PD_ESRECU') == 1)
                        ) {
                    //No remisionado
                    if (objPedido.getAttribute("TKT_ID") == 0 ||
                            (objPedido.getAttribute("TKT_ID") != 0 && objPedido.getAttribute('PD_ESRECU') == 1)
                            ) {
                        //Limpiamos la operacion actual.
//                        ResetOperaActuallala(false);
                        //Llenamos la pantalla con los valores del bd
                        DrawPedidoenVentaCPMAk(objPedido, lstdeta, strTipoVta);
                        $("#dialogView").dialog("close")
                    } else {
                        alert(lstMsg[53]);
                    }
                } else {
                    alert(lstMsg[52]);
                }
            } else {
                //No anulado
                alert(lstMsg[51]);
            }
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}



/**
 *Establece los parametros del pedido original
 **/
function DrawPedidoenVentaCPMAk(objPedido, lstdeta, strTipoVta) {
    $("#dialogWait").dialog("open");
    document.getElementById("PD_ID").value = objPedido.getAttribute('PD_ID');
    if (strTipoVta == "REMISION") {
        MostrarAvisosCPMAk(lstMsg[55] + objPedido.getAttribute('PD_ID'))
        document.getElementById("FAC_TIPO").value = 2;
    } else {
        if (strTipoVta == "FACTURA") {
            MostrarAvisosCPMAk(lstMsg[54] + objPedido.getAttribute('PD_ID'))
            document.getElementById("FAC_TIPO").value = 1;
        } else {
            MostrarAvisosCPMAk(lstMsg[57] + objPedido.getAttribute('PD_ID'))
            document.getElementById("FAC_TIPO").value = 3;
        }
    }
    document.getElementById("FAC_FOLIO").value = objPedido.getAttribute('PD_FOLIO');
    document.getElementById("SC_ID").value = objPedido.getAttribute('SC_ID');
    document.getElementById("FCT_ID").value = objPedido.getAttribute('CT_ID');
    document.getElementById("FAC_NOTAS").value = objPedido.getAttribute('PD_NOTAS');
    document.getElementById("FAC_NOTASPIE").value = objPedido.getAttribute('PD_NOTASPIE');
    document.getElementById("FAC_CONDPAGO").value = objPedido.getAttribute('PD_CONDPAGO');
    document.getElementById("FAC_REFERENCIA").value = objPedido.getAttribute('PD_REFERENCIA');
    document.getElementById("FAC_NUMPEDI").value = objPedido.getAttribute('PD_NUMPEDI');
    document.getElementById("FAC_FECHAPEDI").value = objPedido.getAttribute('PD_FECHAPEDI');
    document.getElementById("FAC_ADUANA").value = objPedido.getAttribute('PD_ADUANA');
    if (objPedido.getAttribute('PD_ESRECU') == 1) {
        document.getElementById("FAC_ESRECU1").checked = true;
    } else {
        document.getElementById("FAC_ESRECU2").checked = false;
    }
    document.getElementById("FAC_PERIODICIDAD").value = objPedido.getAttribute('PD_PERIODICIDAD');
    document.getElementById("FAC_DIAPER").value = objPedido.getAttribute('PD_DIAPER');
    document.getElementById("VE_ID").value = objPedido.getAttribute('VE_ID');
    ObtenNomCteCPMAk(objPedido, lstdeta, strTipoVta, true);
}


function ObtenNomCteCPMAk(objPedido, lstdeta, strTipoVta, bolPasaPedido) {
    var intCte = document.getElementById("FCT_ID").value;
    if (bolPasaPedido == undefined)
        bolPasaPedido = false;
    ValidaCleanCPMAk("CT_NOM");
    $.ajax({
        type: "POST",
        data: "CT_ID=" + intCte,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=9",
        success: function (datoVal) {
            var objCte = datoVal.getElementsByTagName("vta_clientes")[0];
            if (objCte.getAttribute('CT_ID') == 0) {
                document.getElementById("CT_NOM").value = "***************";
                ValidaShowCPMAk("CT_NOM", lstMsg[28]);
            } else {
                document.getElementById("CT_NOM").value = objCte.getAttribute('CT_RAZONSOCIAL');
                document.getElementById("FCT_LPRECIOS").value = objCte.getAttribute('CT_LPRECIOS');
                document.getElementById("FCT_DESCUENTO").value = objCte.getAttribute('CT_DESCUENTO');
//                document.getElementById("FCT_DIASCREDITO").value = objCte.getAttribute('CT_DIASCREDITO');
                document.getElementById("FCT_MONTOCRED").value = objCte.getAttribute('CT_MONTOCRED');
                intCT_TIPOPERS = objCte.getAttribute('CT_TIPOPERS');
                intCT_TIPOFAC = objCte.getAttribute('CT_TIPOFAC');
                strCT_USOIMBUEBLE = objCte.getAttribute('CT_USOIMBUEBLE');
            }
            //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
            if (bolPasaPedido) {
                DrawPedidoDetaenVentaCPMAk(objPedido, lstdeta, strTipoVta);
            }
        },
        error: function (objeto, quepaso, otroobj) {
            document.getElementById("CT_NOM").value = "***************";
            ValidaShow("CT_NOM", lstMsg[28]);
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

/**
 *Llenamos el grid con los datos del pedido
 **/
function DrawPedidoDetaenVentaCPMAk(objPedido, lstdeta, strTipoVta) {
    //Generamos el detalle
    for (i = 0; i < lstdeta.length; i++) {
        var obj = lstdeta[i];
        var objImportes = new _ImporteCPMAk();
        objImportes.dblCantidad = obj.getAttribute('PDD_CANTIDAD');
        objImportes.dblPrecio = parseFloat(obj.getAttribute('PDD_PRECIO')) / (1 + (obj.getAttribute('PDD_TASAIVA1') / 100));
        objImportes.dblPrecioReal = parseFloat(obj.getAttribute('PDD_PRECREAL')) / (1 + (obj.getAttribute('PDD_TASAIVA1') / 100));
        objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
        objImportes.dblPorcDesc = obj.getAttribute('PDD_PORDESC');
        objImportes.dblExento1 = obj.getAttribute('PDD_EXENTO1');
        objImportes.dblExento2 = obj.getAttribute('PDD_EXENTO2');
        objImportes.dblExento3 = obj.getAttribute('PDD_EXENTO3');
        objImportes.intDevo = 0;
        //Validamos existencias en caso de que aplique
        if (obj.getAttribute('PR_REQEXIST') == 1) {
            if (parseFloat(objImportes.dblCantidad) > parseFloat(obj.getAttribute('PR_EXISTENCIA'))) {
                alert(lstMsg[3] + " " + obj.getAttribute('PDD_CVE') + " " + lstMsg[4]);
                if (parseFloat(obj.getAttribute('PR_EXISTENCIA')) > 0) {
                    objImportes.dblCantidad = obj.getAttribute('PR_EXISTENCIA');
                } else {
                    objImportes.dblCantidad = 0;
                }
            }
        }
        //Calculamos el importe de la venta
        objImportes.CalculaImporteCPMAk();
        var dblImporte = objImportes.dblImporte;
        var datarow = {
            FACD_ID: 0,
            FACD_CANTIDAD: objImportes.dblCantidad,
            FACD_CANTPEDIDO: obj.getAttribute('PDD_CANTIDAD'),
            FACD_DESCRIPCION: obj.getAttribute('PDD_DESCRIPCION'),
            FACD_IMPORTE: dblImporte,
            FACD_CVE: obj.getAttribute('PDD_CVE'),
            FACD_PRECIO: objImportes.dblPrecio,
            FACD_TASAIVA1: obj.getAttribute('PDD_TASAIVA1'),
            FACD_DESGLOSA1: 1,
            FACD_IMPUESTO1: objImportes.dblImpuesto1,
            FACD_PR_ID: obj.getAttribute('PR_ID'),
            FACD_EXENTO1: obj.getAttribute('PDD_EXENTO1'),
            FACD_EXENTO2: obj.getAttribute('PDD_EXENTO2'),
            FACD_EXENTO3: obj.getAttribute('PDD_EXENTO3'),
            FACD_REQEXIST: obj.getAttribute('PR_REQEXIST'),
            FACD_EXIST: obj.getAttribute('PR_EXISTENCIA'),
            FACD_NOSERIE: "",
            FACD_ESREGALO: obj.getAttribute('PDD_ESREGALO'),
            FACD_IMPORTEREAL: objImportes.dblImporteReal,
            FACD_PRECREAL: objImportes.dblPrecioReal,
            FACD_DESCUENTO: obj.getAttribute('PDD_DESCUENTO'),
            FACD_PORDESC: objImportes.dblPorcAplica,
            FACD_PRECFIJO: obj.getAttribute('PDD_PRECFIJO'),
            FACD_ESDEVO: 0,
            FACD_CODBARRAS: obj.getAttribute('PR_CODBARRAS'),
            FACD_NOTAS: obj.getAttribute('PDD_COMENTARIO')
        };
        //Anexamos el registro al GRID
        jQuery("#FAC_GRID").addRowData(obj.getAttribute('PDD_ID'), datarow, "last");
    }
    //Realizamos la sumatoria
    setSumCPMAk();
    $("#dialogWait").dialog("close");
}



function _ImporteCPMAk() {
    this.dblImporte = 0;
    this.dblImpuesto1 = 0;
    this.dblImpuesto2 = 0;
    this.dblImpuesto3 = 0;
    this.dblImpuestoReal1 = 0;
    this.dblImpuestoReal2 = 0;
    this.dblImpuestoReal3 = 0;
    this.dblCantidad = 0;
    this.dblPrecio = 0;
    this.dblPorcDesc = 0;
    this.dblPorcDescGlobal = 0;
    this.dblPrecFijo = 0;
    this.dblExento1 = 0;
    this.dblExento2 = 0;
    this.dblExento3 = 0;
    this.dblImporteReal = 0;
    this.dblPrecioReal = 0;
    this.intDevo = 0;
    this.dblPorcAplica = 0;
    this.intPrecioZeros = 0;
    this.CalculaImporteCPMAk = function CalculaImporteCPMAk() {
        //Calculamos el importe
        this.dblPorcDescGlobal = parseFloat(this.dblPorcDescGlobal);
        this.dblPorcDesc = parseFloat(this.dblPorcDesc);
        var dblPrecioAplica = parseFloat(this.dblPrecio);
        if (this.dblPrecFijo == 0 || this.intPrecioZeros == 1) {
            this.dblPorcAplica = 0;
            if (this.dblPorcDescGlobal > 0 && this.dblPorcDesc > 0) {
                if (this.dblPorcDescGlobal > this.dblPorcDesc)
                    this.dblPorcAplica = this.dblPorcDescGlobal;
                if (this.dblPorcDesc > this.dblPorcDescGlobal)
                    this.dblPorcAplica = this.dblPorcDesc;
            } else {
                if (this.dblPorcDescGlobal > 0)
                    this.dblPorcAplica = this.dblPorcDescGlobal;
                if (this.dblPorcDesc > 0)
                    this.dblPorcAplica = this.dblPorcDesc;
            }
            if (this.dblPorcAplica > 0) {
                dblPrecioAplica = dblPrecioAplica - (dblPrecioAplica * (this.dblPorcAplica / 100));
            }
        }
        this.dblImporte = parseFloat(this.dblCantidad) * parseFloat(dblPrecioAplica);
        this.dblImporteReal = parseFloat(this.dblCantidad) * parseFloat(this.dblPrecioReal);
        //Si es una devolucion
        if (parseInt(this.intDevo) == 1) {
            this.dblImporte = this.dblImporte * -1;
        }
        //Validamos si aplica o no el impuesto
        var dblBase1 = this.dblImporte;
        var dblBase2 = this.dblImporte;
        var dblBase3 = this.dblImporte;
        if (parseInt(this.dblExento1) == 1)
            dblBase1 = 0;
        if (parseInt(this.dblExento2) == 1)
            dblBase2 = 0;
        if (parseInt(this.dblExento3) == 1)
            dblBase3 = 0;
        //Calculamos el impuesto
        var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
        //Validamos si los precios incluyen impuestos
        if (intPreciosconImp == 1) {
            tax.CalculaImpuesto(dblBase1, dblBase2, dblBase3);
        } else {
            tax.CalculaImpuestoMas(dblBase1, dblBase2, dblBase3);
        }
        if (parseInt(this.dblExento1) == 0)
            this.dblImpuesto1 = tax.dblImpuesto1;
        if (parseInt(this.dblExento2) == 0)
            this.dblImpuesto2 = tax.dblImpuesto2;
        if (parseInt(this.dblExento3) == 0)
            this.dblImpuesto3 = tax.dblImpuesto3;
        //Calculamos impuestos de los importes reales
        //Validamos si aplica o no el impuesto para el importe REAL
        var dblBaseReal1 = this.dblImporteReal;
        var dblBaseReal2 = this.dblImporteReal;
        var dblBaseReal3 = this.dblImporteReal;
        if (parseInt(this.dblExento1) == 1)
            dblBaseReal1 = 0;
        if (parseInt(this.dblExento2) == 1)
            dblBaseReal2 = 0;
        if (parseInt(this.dblExento3) == 1)
            dblBaseReal3 = 0;
        //Calculamos el impuesto
        //Validamos si los precios incluyen impuestos
        if (intPreciosconImp == 1) {
            tax.CalculaImpuesto(dblBaseReal1, dblBaseReal2, dblBaseReal3);
        } else {
            tax.CalculaImpuestoMas(dblBaseReal1, dblBaseReal2, dblBaseReal3);
        }
        if (parseInt(this.dblExento1) == 0)
            this.dblImpuestoReal1 = tax.dblImpuesto1;
        if (parseInt(this.dblExento2) == 0)
            this.dblImpuestoReal2 = tax.dblImpuesto2;
        if (parseInt(this.dblExento3) == 0)
            this.dblImpuestoReal3 = tax.dblImpuesto3;


        if (this.intPrecioZeros == 1) {
            this.dblImporteReal = parseFloat(this.dblCantidad) * parseFloat(this.dblPrecio);
        }
        if (intPreciosconImp == 0) {
            this.dblImporteReal += this.dblImpuestoReal1 + this.dblImpuestoReal2 + this.dblImpuestoReal3;
            this.dblImporte += this.dblImpuesto1 + this.dblImpuesto2 + this.dblImpuesto3;
        }
    }
}

/*Suma todos los items de la venta y nos da el total**/
function setSumCPMAk() {
    var grid = jQuery("#FAC_GRID");
    var arr = grid.getDataIDs();
    var dblSuma = 0;
    var dblImpuesto1 = 0;
    var dblImporte = 0;
    for (var i = 0; i < arr.length; i++) {
        var id = arr[i];
        var lstRow = grid.getRowData(id);
        dblSuma += parseFloat(lstRow.FACD_IMPORTE);
        dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO1);
        dblImporte += (parseFloat(lstRow.FACD_IMPORTE) - parseFloat(lstRow.FACD_IMPUESTO1));

    }
    d.getElementById("FAC_TOT").value = FormatNumber(dblSuma, intNumdecimal, true);
    d.getElementById("FAC_IMPUESTO1").value = FormatNumber(dblImpuesto1, intNumdecimal, true);
    d.getElementById("FAC_IMPORTE").value = FormatNumber(dblImporte, intNumdecimal, true);
    //Activamos recibos de honorarios si proceden SOLO EN CASO DE FACTURAS
    if (parseInt(intEMP_TIPOPERS) == 2 && intCT_TIPOPERS == 1
            && parseInt(d.getElementById("FAC_TIPO").value) == 1) {
        var dblRetIsr = dblImporte * (dblFacRetISR / 100);
        var dblRetIVA = 0;
        if (dblImpuesto1 > 0) {
            dblRetIVA = (dblImpuesto1 / 3) * 2;
        }
        //Exento retencion ISR
        if (parseInt(intEMP_NO_ISR) == 1) {
            dblRetIsr = 0;
        }
        //Exento retencion IVA
        if (parseInt(intEMP_NO_IVA) == 1) {
            dblRetIVA = 0;
        }
        var dblImpNeto = dblSuma - dblRetIsr - dblRetIVA;
        document.getElementById("FAC_RETISR").value = FormatNumber(dblRetIsr, intNumdecimal, true);
        document.getElementById("FAC_RETIVA").value = FormatNumber(dblRetIVA, intNumdecimal, true);
        document.getElementById("FAC_NETO").value = FormatNumber(dblImpNeto, intNumdecimal, true);
        //Activamos los recibos de honorarios
        document.getElementById("FAC_RETISR").parentNode.parentNode.style.display = 'block';
        document.getElementById("FAC_RETIVA").parentNode.parentNode.style.display = 'block';
        document.getElementById("FAC_NETO").parentNode.parentNode.style.display = 'block';
    } else {
        //Activamos los recibos de honorarios
        document.getElementById("FAC_RETISR").parentNode.parentNode.style.display = 'none';
        document.getElementById("FAC_RETIVA").parentNode.parentNode.style.display = 'none';
        document.getElementById("FAC_NETO").parentNode.parentNode.style.display = 'none';
    }
}

/**Muestra el label de aviso*/
function MostrarAvisosCPMAk(strMsg) {
//    var label = document.getElementById("LABELAVISOS");
//    label.innerHTML = strMsg;
//    //Mostrar aviso
//    label.setAttribute("class", "Mostrar");
//    label.setAttribute("className", "Mostrar");
//    label.setAttribute("class", "ui-Total");
//    label.setAttribute("className", "ui-Total");
}


function selgridconpdmak(rowid, status) {

    var grid1 = jQuery("#VIEW_GRID1");
    var id = rowid;
    var lstRow = grid1.getRowData(id);
    var intPdId = lstRow.PR_CODIGO;
    jQuery("#VIEW_GRID2").clearGridData();
    var itemIdCob = 0;

    $.ajax({
        type: "POST",
        data: "intPdId=" + intPdId,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "XML",
        url: "ERP_PedidosMakProcs.jsp?id=27",
        success: function (datos) {
            var objsc = datos.getElementsByTagName("vta_pedidos")[0];
            var lstProds = objsc.getElementsByTagName("vta_pedidos_deta");
            for (var i = 0; i < lstProds.length; i++) {
                var obj = lstProds[i];
                var datarow = {
                    SUC_SUCURSAL: obj.getAttribute("sucursal"),
                    SUC_EXISTENCIA: obj.getAttribute("existencia"),
                    SUC_ASIGNADO: obj.getAttribute("asignado"),
                    SUC_DISPONIBLE: obj.getAttribute("disponible"),
                    SUC_OBSERVACIONES: obj.getAttribute("observaciones")
                };

                jQuery("#PR_GRIDSUCPR").addRowData(itemIdCob, datarow, "last");
                d.getElementById("PR_CODIGO").value = obj.getAttribute("PR_CODIGO");
                d.getElementById("PR_NOMBRE").value = obj.getAttribute("observaciones");
                d.getElementById("PR_UM").value = obj.getAttribute("PR_UNIDADMEDIDA");
                d.getElementById("PR_UBICACION").value = "";
                d.getElementById("PR_IMAGEN").value = obj.getAttribute("imagen");
                d.getElementById("PR_CODPREC").value = obj.getAttribute("codprec");
                ImgLoadPrMak(document.getElementById("PR_IMAGEN").value, "PR_IMAGEN");

//Obtenemos el precio de el producto
                $.ajax({
                    type: "POST",
                    data: "PR_ID=" + lstRow.PR_ID + "&CT_LPRECIOS=1&CANTIDAD=1&FAC_MONEDA=" + document.getElementById("FAC_MONEDA").value +
                            "&CT_TIPO_CAMBIO=1",
                    scriptCharset: "utf-8",
                    contentType: "application/x-www-form-urlencoded;charset=utf-8",
                    cache: false,
                    dataType: "xml",
                    url: "DamePrecio.do?id=4",
                    success: function (datoPrec) {
                        var lstXml = datoPrec.getElementsByTagName("Precios")[0];
                        var lstprecio = lstXml.getElementsByTagName("Precio");
                        for (var i = 0; i < lstprecio.length; i++) {
                            var obj2 = lstprecio[i];
                            d.getElementById("PR_SINIMPUESTOS").value = obj2.getAttribute('precioUsar');
                            //Obtenemos el iva de el producto    
                            var taxReal = new Impuestos(dblTasaVta11, dblTasaVta22, dblTasaVta33, intSImpVta1_22, intSImpVta1_33, intSImpVta2_33);//Objeto para calculo de impuestos
                            taxReal.CalculaImpuesto(d.getElementById("PR_SINIMPUESTOS").value, 0, 0);
                            d.getElementById("PR_IMPUESTOS").value = FormatNumber(taxReal.dblImpuesto1, 2, true, false, true, false);

                            d.getElementById("PR_PRECTOTAL").value = FormatNumber(parseFloat(d.getElementById("PR_SINIMPUESTOS").value.replace(",", "")) + parseFloat(d.getElementById("PR_IMPUESTOS").value.replace(",", "")), 2, true, false, true, false);

                        }
                    },
                    error: function (objeto, quepaso, otroobj) {
                        alert(":pto4:" + objeto + " " + quepaso + " " + otroobj);
                        $("#dialogWait").dialog("close");
                    }
                });
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}