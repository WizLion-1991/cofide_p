/* 
 *Esta libreria realiza todas las operaciones del punto de venta
 */

//Variables globales
var itemIdSv = 0;//indice para los items del grid
var bolCambioFechaServ = false;
//Inicializamos impuestos con sucursal default
var dblTasaVtaSv1 = dblTasa1;
var dblTasaVtaSv2 = dblTasa2;
var dblTasaVtaSv3 = dblTasa3;
var bolRetieneImpuesto2 = false;
var intIdTasaVtaSv1 = intIdTasa1;
var intIdTasaVtaSv2 = intIdTasa2;
var intIdTasaVtaSv3 = intIdTasa3;
var intSImpVta1_2Sv = intSImp1_2;
var intSImpVta1_3Sv = intSImp1_3;
var intSImpVta2_3Sv = intSImp2_3;
var intCT_TIPOPERSSv = 0;
var intCT_TIPOFACSv = 0;
var strCT_USOIMBUEBLESv = "";
var intCF_ID = "";
//Inicializamos las retneciones 
var intRET_ISR = 0;
var intRET_IVA = 0;
var intRET_FLETE = 1;
var bolUsaOpnCte = false;
function vta_serv() {//Funcion necesaria para que pueda cargarse la libreria en automatico
}
/**Inicializa la pantalla de punto de venta*/
function InitServ() {
    $("#dialogWait").dialog("open");
    myLayout.close("west");
    myLayout.close("east");
    myLayout.close("south");
    myLayout.close("north");
    //Ocultamos renglon de avisos
    OcultarAvisosServ();
    //Ponemos el nombre default de la sucursal
    d.getElementById("SC_ID").value = intSucDefa;
    //Hacemos diferente el estilo del total
    FormStyleServ();
    //Obtenemos el id del cliente y el vendedor default
    d.getElementById("FCT_ID").value = intCteDefa;
    d.getElementById("FAC_OPER").value = strUserName;
    d.getElementById("FAC_TASASEL1").value = intIdTasaVtaSv1;
    //Tasa de impuesto 2
    if (d.getElementById("FAC_TASASEL2") != null) {
        d.getElementById("FAC_TASASEL2").value = intIdTasaVtaSv2;
    }
    //Tasa de impuesto 3
    if (d.getElementById("FAC_TASASEL3") != null) {
        d.getElementById("FAC_TASASEL3").value = intIdTasaVtaSv3;
    }

    d.getElementById("FAC_CF_ID").value = 0;
    d.getElementById("FAC_DESC").focus();
    ObtenNomCteServ();
    //Realizamos el menu de botones
    var strHtml = "<ul>" +
            getMenuItem("CallbtnSv0();", "Guardar Venta", "images/ptovta/CircleSave.png") +
            getMenuItem("CallbtnSv1();", "Nueva Venta", "images/ptovta/VisPlus.png") +
            getMenuItem("CallbtnSv2();", "Consultar Venta", "images/ptovta/VisMagnifier.png") +
            getMenuItem("CallbtnSv7();", "Borrar Concepto", "images/ptovta/VisClose.png") +
            getMenuItem("CallbtnSv9();", "Salir", "images/ptovta/exitBig.png") +
            "</ul>";
    document.getElementById("TOOLBAR").innerHTML = strHtml;

    //Obtenemos los atributos(permisos) del usuario para esta pantalla
    bolCambioFechaServ = false;
    $.ajax({
        type: "POST",
        data: "keys=85",
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
                if (obj.getAttribute('id') == 85 && obj.getAttribute('enabled') == "true") {
                    bolCambioFechaServ = true;
                }
            }
            //Validamos si podemos hacer cambio de fecha
            if (bolCambioFechaServ) {
                if ($('#FAC_FECHA').datepicker("isDisabled")) {
                    $('#FAC_FECHA').datepicker("enable")
                }
                var objFecha = document.getElementById("FAC_FECHA");
                objFecha.setAttribute("class", "outEdit");
                objFecha.setAttribute("className", "outEdit");
                objFecha.readOnly = false;
            } else {
                $('#FAC_FECHA').datepicker("disable")
            }
            $("#dialogWait").dialog("close");
            //Foco inicial
            setTimeout("d.getElementById('FAC_DESC').focus();", 3000);
            SelRegDefaSrv();
            //Seleciona el tipo de operacion de venta
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
    //Definimos acciones para el dialogo SI/NO
    document.getElementById("btnSI").onclick = function () {
        ConfirmaSISv();
    };
    document.getElementById("btnNO").onclick = function () {
        ConfirmaNOSv();
    };
}
/**Cambia los estilos de algunos controles*/
function FormStyleServ() {
    d.getElementById("FAC_TOT").setAttribute("class", "ui-Total");
    d.getElementById("FAC_TOT").setAttribute("className", "ui-Total");
    d.getElementById("btn1").setAttribute("class", "Oculto");
    d.getElementById("btn1").setAttribute("className", "Oculto");
}
/**Obtiene el nombre del cliente al que se le esta haciendo la venta*/
function ObtenNomCteServ(objPedido, lstdeta, strTipoVta, bolPasaPedido) {
    var intCte = document.getElementById("FCT_ID").value;
    $("#dialogWait").dialog("open");
    if (bolPasaPedido == undefined)
        bolPasaPedido = false;
    ValidaClean("CT_NOM");
    ObtenClienteFinalServ();
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
                ValidaShow("CT_NOM", lstMsg[28]);
            } else {
                document.getElementById("CT_NOM").value = objCte.getAttribute('CT_RAZONSOCIAL');
                document.getElementById("FCT_LPRECIOS").value = objCte.getAttribute('CT_LPRECIOS');
                document.getElementById("FCT_DESCUENTO").value = objCte.getAttribute('CT_DESCUENTO');
                document.getElementById("FAC_DIASCREDITO").value = objCte.getAttribute('CT_DIASCREDITO');
                document.getElementById("FCT_MONTOCRED").value = objCte.getAttribute('CT_MONTOCRED');
                document.getElementById("FAC_METODOPAGO").value = objCte.getAttribute('CT_METODODEPAGO');
                document.getElementById("FAC_FORMADEPAGO").value = objCte.getAttribute('CT_FORMADEPAGO');
                document.getElementById("FAC_NUMCUENTA").value = objCte.getAttribute('CT_CTABANCO1');
                document.getElementById("VE_ID").value = objCte.getAttribute('CT_VENDEDOR');
                intCT_TIPOPERSSv = objCte.getAttribute('CT_TIPOPERS');
                intCT_TIPOFACSv = objCte.getAttribute('CT_TIPOFAC');
                strCT_USOIMBUEBLESv = objCte.getAttribute('CT_USOIMBUEBLE');
                //Validamos iva y moneda por default unicamente si no estamos editando un pedido
                if (!bolPasaPedido) {
                    if (parseInt(objCte.getAttribute('MON_ID')) != 0) {
                        document.getElementById("FAC_MONEDA").value = objCte.getAttribute('MON_ID');
                        RefreshMonedaSrv();
                    }
                    if (parseInt(objCte.getAttribute('TI_ID')) != 0) {
                        document.getElementById("FAC_TASASEL1").value = objCte.getAttribute('TI_ID');
//                        document.getElementById("FAC_USE_IMP1").value = 1;
                        UpdateTasaImpSrv();
                    }
                    if (parseInt(objCte.getAttribute('TI2_ID')) != 0) {
                        if (document.getElementById("FAC_TASASEL2") != null) {
                            document.getElementById("FAC_TASASEL2").value = objCte.getAttribute('TI2_ID');
//                            document.getElementById("FAC_USE_IMP2").value = 1;
                            UpdateTasaImpSrv2();
                        }
                    }
                    if (parseInt(objCte.getAttribute('TI3_ID')) != 0) {
                        if (document.getElementById("FAC_TASASEL3") != null) {
                            document.getElementById("FAC_TASASEL3").value = objCte.getAttribute('TI3_ID');
//                            document.getElementById("FAC_USE_IMP3").value = 1;
                            UpdateTasaImpSrv3();
                        }
                    }
                }
                //Validamos iva y moneda por default unicamente si no estamos editando un pedido
            }
            $("#dialogWait").dialog("close");
            //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
            if (bolPasaPedido) {
                DrawPedidoDetaenVentaSrv(objPedido, lstdeta, strTipoVta);
            }
        },
        error: function (objeto, quepaso, otroobj) {
            document.getElementById("CT_NOM").value = "***************";
            ValidaShow("CT_NOM", lstMsg[28]);
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**Obtiene el nombre del vendedor al que se le esta haciendo la venta*/
function ObtenNomVend() {
    var intVend = document.getElementById("VE_ID").value;
    $.ajax({
        type: "POST",
        data: "VE_ID=" + intVend,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "CIP_TablaOp.jsp?ID=4&opnOpt=VENDEDOR",
        success: function (datoVal) {
            var objVend = datoVal.getElementsByTagName("vta_vendedores")[0];
            document.getElementById("VE_NOM").value = objVend.getAttribute('VE_NOMBRE');
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto2:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}
function AddNomConcepto(id) {
    //var intCon = document.getElementById("CF_ID").value;
    $.ajax({
        type: "POST",
        data: "CF_ID=" + id,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "CIP_TablaOp.jsp?ID=4&opnOpt=CON",
        success: function (datoVal) {
            var objCon = datoVal.getElementsByTagName("vta_conceptosss")[0];
            document.getElementById("FAC_DESC").value = "";
            document.getElementById("FAC_DESC").value = objCon.getAttribute('CF_CONCEPTO');
            document.getElementById("FAC_CF_ID").value = objCon.getAttribute('CF_ID');
            /*document.getElementById("FC_CF").value="";        
             */
            intRET_ISR = objCon.getAttribute('CF_EXENTO_RET_ISR');
            intRET_IVA = objCon.getAttribute('CF_EXENTO_RET_IVA');
            intRET_FLETE = objCon.getAttribute('CF_EXT_RET_FLETE');
            $("#dialogCon").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":conceptos:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogCon").dialog("close");
        }
    });
}
/**Funcion para anadir partidas, valida que el producto exista, luego obtiene el precio y lo anade al GRID*/
function AddItemSv() {
    var strConc = UCase(d.getElementById("FAC_DESC").value);
    //Validamos que hallan capturado una descripcion
    if (trim(strConc) != "") {
        $("#dialogWait").dialog("open");
        var Ct_Id = d.getElementById("FCT_ID").value;
        var strCod = d.getElementById("FAC_PROD").value;
        var dblCantidad = d.getElementById("FAC_CANT").value;
        var dblExistencia = 0;
        AddItemSvPrec(null, Ct_Id, dblCantidad, strCod, dblExistencia, 0);
    }
}
/**Vuelva a calcular el precio para una fila del grid*/
function lstRowChangePrecioSv(lstRow, idUpdate, grid) {
    var objImportes = new _ImporteVta();
    objImportes.dblCantidad = parseFloat(lstRow.FACD_CANTIDAD);
    objImportes.dblPrecio = parseFloat(lstRow.FACD_PRECIO);
    objImportes.dblPrecioReal = lstRow.FACD_PRECREAL;
    objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
    objImportes.dblPorcDesc = lstRow.FACD_PORDESC;
    objImportes.dblPrecFijo = lstRow.FACD_PRECFIJO;
    objImportes.dblExento1 = lstRow.FACD_EXENTO1;
    objImportes.dblExento2 = lstRow.FACD_EXENTO2;
    objImportes.dblExento3 = lstRow.FACD_EXENTO3;
    objImportes.intDevo = lstRow.FACD_ESDEVO;
    objImportes.CalculaImporte();
    //Asignamos nuevos importes
    lstRow.FACD_IMPORTE = objImportes.dblImporte;
    lstRow.FACD_IMPUESTO1 = objImportes.dblImpuesto1;
    lstRow.FACD_PORDESC = objImportes.dblPorcAplica;
    //Actualizamos el grid
    grid.setRowData(idUpdate, lstRow);
    //Sumamos todos los items
    setSumSv();
}
/**Añade una nueva partida al GRID*/
function AddItemSvPrec(objProd, Ct_Id, Cantidad, strCod, dblExist, intDevo) {
    var dblImporteC = document.getElementById("FAC_PRECIO").value;
    var strDesc = document.getElementById("FAC_DESC").value;
    var intCF_ID = document.getElementById("FAC_CF_ID").value;
    var satrUniMedida = "";
    if (document.getElementById("FAC_UNIDADMEDIDA") != null) {
        var intCostosIdx = d.getElementById("FAC_UNIDADMEDIDA").selectedIndex;
        satrUniMedida = d.getElementById("FAC_UNIDADMEDIDA").options[intCostosIdx].text;
    }
    var objImportes = new _ImporteVta();
    objImportes.dblCantidad = Cantidad;
    objImportes.dblPrecio = parseFloat(dblImporteC);
    objImportes.dblPrecioReal = parseFloat(dblImporteC);
    objImportes.dblPorcDescGlobal = 0;
    objImportes.dblExento1 = 0;
    objImportes.dblExento2 = 0;
    objImportes.dblExento3 = 0;
    objImportes.intDevo = intDevo;
    objImportes.CalculaImporte();
    var dblImporte = objImportes.dblImporte;
    var datarow = {
        FACD_ID: 0,
        FACD_CANTIDAD: Cantidad,
        FACD_DESCRIPCION: lstMsg[180],
        FACD_IMPORTE: dblImporte,
        FACD_CVE: strCod,
        FACD_PRECIO: dblImporteC,
        FACD_TASAIVA1: dblTasaVtaSv1,
        FACD_TASAIVA2: dblTasaVtaSv2,
        FACD_TASAIVA3: dblTasaVtaSv3,
        FACD_DESGLOSA1: 1,
        FACD_IMPUESTO1: objImportes.dblImpuesto1,
        FACD_IMPUESTO2: objImportes.dblImpuesto2,
        FACD_IMPUESTO3: objImportes.dblImpuesto3,
        FACD_PR_ID: 0,
        FACD_EXENTO1: 0,
        FACD_EXENTO2: 0,
        FACD_EXENTO3: 0,
        FACD_REQEXIST: 0,
        FACD_EXIST: 0,
        FACD_NOSERIE: "",
        FACD_ESREGALO: 0,
        FACD_IMPORTEREAL: dblImporte,
        FACD_PRECREAL: dblImporteC,
        FACD_DESCUENTO: 0.0,
        FACD_PORDESC: objImportes.dblPorcAplica,
        FACD_PRECFIJO: 0,
        FACD_ESDEVO: intDevo,
        FACD_CODBARRAS: "",
        FACD_NOTAS: strDesc,
        FACD_RET_ISR: intRET_ISR,
        FACD_RET_IVA: intRET_IVA,
        FACD_RET_FLETE: intRET_FLETE,
        FACD_CF_ID: intCF_ID,
        FACD_UNIDADMEDIDA: satrUniMedida
    };
    //Anexamos el registro al GRID
    itemIdSv++;
    jQuery("#FAC_GRID").addRowData(itemIdSv, datarow, "last");
    d.getElementById("FAC_PROD").value = "";
    d.getElementById("FAC_DESC").value = "";
    d.getElementById("FAC_PRECIO").value = "0.0";
    d.getElementById("FAC_DESC").focus();
    d.getElementById("FAC_CANT").value = 1;
    d.getElementById("FAC_CF_ID").value = 0;
    //Limpiamos variables
    intRET_ISR = 0;
    intRET_IVA = 0
    intRET_FLETE = 1;

    bolFind = true;
    //Sumamos todos los items
    setSumSv();
    //Validamos el cambio de sucursal
    EvalSucursalSv();
    $("#dialogWait").dialog("close");
}
/**Borra el item seleccionado*/
function VtaDropSv() {
    var grid = jQuery("#FAC_GRID");
    if (grid.getGridParam("selrow") != null) {
        grid.delRowData(grid.getGridParam("selrow"));
        document.getElementById("FAC_DESC").focus();
        //Sumamos todos los items
        setSumSv();
        //Validamos el cambio de sucursal
        EvalSucursalSv();
    }
}
/*Suma todos los items de la venta y nos da el total**/
function setSumSv() {
    var grid = jQuery("#FAC_GRID");
    var arr = grid.getDataIDs();
    var dblSuma = 0;
    var dblImpuesto1 = 0;
    var dblImpuesto2 = 0;
    var dblImpuesto3 = 0;
    var dblImporte = 0;
    var dblImporteRetISR = 0;
    var dblImporteRetIVA = 0;
    var dblImporteRetIVAFlete = 0;
    for (var i = 0; i < arr.length; i++) {
        var id = arr[i];
        var lstRow = grid.getRowData(id);
        dblSuma += parseFloat(lstRow.FACD_IMPORTE);
        if (parseInt(intCT_TIPOFACSv) == 1) {
            if (strCT_USOIMBUEBLESv == "HABITACIONAL") {
                dblSuma -= parseFloat(lstRow.FACD_IMPUESTO1);
            } else {
                dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO1);
            }
        } else {
            dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO1);
        }
        dblImpuesto2 += parseFloat(lstRow.FACD_IMPUESTO2);
        dblImpuesto3 += parseFloat(lstRow.FACD_IMPUESTO3);
        dblImporte += (parseFloat(lstRow.FACD_IMPORTE) - parseFloat(lstRow.FACD_IMPUESTO1) - parseFloat(lstRow.FACD_IMPUESTO2) - parseFloat(lstRow.FACD_IMPUESTO3));
        /*aQUI EDITE*/
        //Acumulado para el ISR
        if (lstRow.FACD_RET_ISR == 0) {
            dblImporteRetISR += (parseFloat(lstRow.FACD_IMPORTE) - parseFloat(lstRow.FACD_IMPUESTO1) - parseFloat(lstRow.FACD_IMPUESTO2) - parseFloat(lstRow.FACD_IMPUESTO3));
        }
        //Acumulado para IVA
        if (lstRow.FACD_RET_IVA == 0) {
            if (parseInt(intCT_TIPOFACSv) == 1) {
                if (strCT_USOIMBUEBLESv == "HABITACIONAL") {
                    dblImporteRetIVA -= parseFloat(lstRow.FACD_IMPUESTO1);
                } else {
                    dblImporteRetIVA += parseFloat(lstRow.FACD_IMPUESTO1);
                }
            } else {
                dblImporteRetIVA += parseFloat(lstRow.FACD_IMPUESTO1);
            }
        }
        if (lstRow.FACD_RET_FLETE == 0) {
            dblImporteRetIVAFlete += (parseFloat(lstRow.FACD_IMPORTE) - parseFloat(lstRow.FACD_IMPUESTO1));
        }

        /*aQUI EDITE*/
    }
    //Anadimos IEPS
    var dblIEPS = 0;
    if (document.getElementById("FAC_USO_IEPS1").checked) {
        if (parseFloat(document.getElementById("FAC_TASA_IEPS").value) != 0) {
            try {
                dblIEPS = dblImporte * (parseFloat(document.getElementById("FAC_TASA_IEPS").value) / 100);
            } catch (err) {
            }
        } else {
            alert(lstMsg[62]);
            document.getElementById("FAC_TASA_IEPS").focus();
        }
        //Aumentamos el IVA
        var tax = new Impuestos(dblTasaVtaSv1, dblTasaVtaSv2, dblTasaVtaSv3, intSImpVta1_2Sv, intSImpVta1_3Sv, intSImpVta2_3Sv);//Objeto para calculo de impuestos
        tax.CalculaImpuestoMas(dblIEPS, 0, 0);
        dblImpuesto1 += tax.dblImpuesto1;
        dblSuma += dblIEPS + tax.dblImpuesto1;
    }
    d.getElementById("FAC_IMPORTE_IEPS").value = FormatNumber(dblIEPS, intNumdecimal, true);
    d.getElementById("FAC_TOT").value = FormatNumber(dblSuma, intNumdecimal, true);
    d.getElementById("FAC_IMPUESTO1").value = FormatNumber(dblImpuesto1, intNumdecimal, true);
    d.getElementById("FAC_IMPUESTO2").value = FormatNumber(dblImpuesto2, intNumdecimal, true);
    d.getElementById("FAC_IMPUESTO3").value = FormatNumber(dblImpuesto3, intNumdecimal, true);
    d.getElementById("FAC_IMPORTE").value = FormatNumber(dblImporte, intNumdecimal, true);
    //Activamos recibos de honorarios si proceden
    if (parseInt(intEMP_TIPOPERS) == 2) {
        var dblRetIsr = 0;
        var dblRetIVA = 0;
        if (intCT_TIPOPERSSv == 1) {
            /*aQUI EDITE*/
            dblRetIsr = dblImporteRetISR * (dblFacRetISR / 100);
            dblRetIVA = 0;
            //alert("dblImporteRetIVA" + dblImporteRetIVA);
            if (dblImporteRetIVA > 0) {
                dblRetIVA = (dblImporteRetIVA / 3) * 2;
                //sOLO PARA BARREIRO
                //dblRetIVA = (dblImporteRetIVA ) * (10.6667/100);
            }
            if (dblImporteRetIVAFlete > 0) {

                dblRetIVA += (dblImporteRetIVAFlete / 50) * 2;
            }
            //Exento retencion ISR
            if (parseInt(intEMP_NO_ISR) == 1) {
                dblRetIsr = 0;
            }
            //Exento retencion IVA
            if (parseInt(intEMP_NO_IVA) == 1) {
                dblRetIVA = 0;
            }
            /*aQUI EDITE*/
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
            document.getElementById("FAC_RETISR").value = FormatNumber(0, intNumdecimal, true);
            document.getElementById("FAC_RETIVA").value = FormatNumber(0, intNumdecimal, true);
            document.getElementById("FAC_NETO").value = FormatNumber(dblSuma, intNumdecimal, true);
        }
    }
}
/**Obtiene la lista de items de la factura para enviarlos al jsp de las promociones*/
function getLstItems() {

}
/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagCteSv() {
    bolUsaOpnCte = true;
    OpnOpt('CLIENTES', 'grid', 'dialogCte', false, false);
}
/**Abre el cuadro de dialogo para buscar vendedor o dar de alta uno nuevo*/
function OpnDiagVendSv() {
    OpnOpt('VENDEDOR', 'grid', 'dialogVend', false, false);
}
/**Realizar la operacion de guardado de la venta mostrando primero la pantalla de pago*/
function SaveVtaSv() {
    //Validamos si el total es igual a cero
    //if(parseFloat(document.getElementById("FAC_TOT").value)== 0){
    //   alert(lstMsg[56]);
    //}else{
    var bolPasa = true;
    //Validamos ADDENDA FEMSA
    if (d.getElementById("ADD_FEMSA") != null) {
        if (d.getElementById("ADD_FEMSA").value != undefined) {
            if (d.getElementById("ADD_FEMSA").value != 0) {
                if (d.getElementById("USA_FEMSA1").checked) {
                    //Validamos campos
                    if (!ValidaFEMSA()) {
                        alert(lstMsg[155]);
                        bolPasa = false;
                    }
                }
            }
        }
    }
    //Si pasa
    if (bolPasa) {
        if (d.getElementById("TOTALXPAGAR") != null)
            d.getElementById("TOTALXPAGAR").value = d.getElementById("FAC_TOT").value;
        SaveVtaSvDo();
    }
    //}
}
/**Guarda la venta*/
function SaveVtaSvDo() {
    $("#dialogPagos").dialog("close");
    $("#dialogWait").dialog("open");
    //Armamos el POST a enviar
    var strPOST = "";
    //Prefijos dependiendo del tipo de venta
    var strPrefijoMaster = "TKT";
    var strPrefijoDeta = "TKTD";
    var strKey = "TKT_ID";
    var strNomFormat = "TICKET";
    if (d.getElementById("FAC_TIPO").value == "1") {
        //Factura
        strPrefijoMaster = "FAC";
        strPrefijoDeta = "FACD";
        strKey = "FAC_ID";
        strNomFormat = "FACTURA";
    }
    if (d.getElementById("FAC_TIPO").value == "3") {
        //Pedido
        strPrefijoMaster = "PD";
        strPrefijoDeta = "PDD";
        strKey = "PD_ID";
        strNomFormat = "PEDIDO";
    }
    if (d.getElementById("FAC_TIPO").value == "4") {
        //Cotizacion
        strPrefijoMaster = "COT";
        strPrefijoDeta = "COTD";
        strKey = "COT_ID";
        strNomFormat = "COTIZA";
    }
    //Master
    strPOST += "SC_ID=" + d.getElementById("SC_ID").value;
    strPOST += "&CT_ID=" + d.getElementById("FCT_ID").value;
    strPOST += "&VE_ID=" + d.getElementById("VE_ID").value;
    strPOST += "&PD_ID=" + d.getElementById("PD_ID").value;
    strPOST += "&" + strPrefijoMaster + "_ESSERV=1";
    strPOST += "&" + strPrefijoMaster + "_MONEDA=" + d.getElementById("FAC_MONEDA").value;
    strPOST += "&" + strPrefijoMaster + "_FECHA=" + d.getElementById("FAC_FECHA").value;
    strPOST += "&" + strPrefijoMaster + "_FOLIO=" + d.getElementById("FAC_FOLIO").value;
    strPOST += "&" + strPrefijoMaster + "_NOTAS=" + encodeURIComponent(d.getElementById("FAC_NOTAS").value);
    strPOST += "&" + strPrefijoMaster + "_TOTAL=" + d.getElementById("FAC_TOT").value;
    strPOST += "&" + strPrefijoMaster + "_IMPUESTO1=" + d.getElementById("FAC_IMPUESTO1").value;
    strPOST += "&" + strPrefijoMaster + "_IMPUESTO2=" + d.getElementById("FAC_IMPUESTO2").value;
    strPOST += "&" + strPrefijoMaster + "_IMPUESTO3=" + d.getElementById("FAC_IMPUESTO3").value;
    strPOST += "&" + strPrefijoMaster + "_IMPORTE=" + d.getElementById("FAC_IMPORTE").value;
    strPOST += "&" + strPrefijoMaster + "_RETISR=" + d.getElementById("FAC_RETISR").value;
    strPOST += "&" + strPrefijoMaster + "_RETIVA=" + d.getElementById("FAC_RETIVA").value;
    strPOST += "&" + strPrefijoMaster + "_NETO=" + d.getElementById("FAC_NETO").value;
    strPOST += "&" + strPrefijoMaster + "_NOTASPIE=" + encodeURIComponent(d.getElementById("FAC_NOTASPIE").value);
    strPOST += "&" + strPrefijoMaster + "_REFERENCIA=" + d.getElementById("FAC_REFERENCIA").value;
    strPOST += "&" + strPrefijoMaster + "_CONDPAGO=" + d.getElementById("FAC_CONDPAGO").value;
    strPOST += "&" + strPrefijoMaster + "_METODOPAGO=" + d.getElementById("FAC_METODOPAGO").value;
    strPOST += "&" + strPrefijoMaster + "_NUMCUENTA=" + d.getElementById("FAC_NUMCUENTA").value;
    strPOST += "&" + strPrefijoMaster + "_FORMADEPAGO=" + d.getElementById("FAC_FORMADEPAGO").value;
    strPOST += "&" + strPrefijoMaster + "_NUMPEDI=" + d.getElementById("FAC_NUMPEDI").value;
    strPOST += "&" + strPrefijoMaster + "_FECHAPEDI=" + d.getElementById("FAC_FECHAPEDI").value;
    strPOST += "&" + strPrefijoMaster + "_ADUANA=" + d.getElementById("FAC_ADUANA").value;
    strPOST += "&" + strPrefijoMaster + "_TIPOCOMP=" + d.getElementById("FAC_TIPOCOMP").value;
    strPOST += "&TIPOVENTA=" + d.getElementById("FAC_TIPO").value;
    strPOST += "&" + strPrefijoMaster + "_TASA1=" + dblTasaVtaSv1;
    strPOST += "&" + strPrefijoMaster + "_TASA2=" + dblTasaVtaSv2;
    strPOST += "&" + strPrefijoMaster + "_TASA3=" + dblTasaVtaSv3;
    strPOST += "&" + "TI_ID=" + intIdTasaVtaSv1;
    strPOST += "&" + "TI_ID2=" + intIdTasaVtaSv2;
    strPOST += "&" + "TI_ID3=" + intIdTasaVtaSv3;
    strPOST += "&" + strPrefijoMaster + "_TASAPESO=" + d.getElementById("FAC_TASAPESO").value;
    strPOST += "&" + strPrefijoMaster + "_DIASCREDITO=" + d.getElementById("FAC_DIASCREDITO").value;
    //Validamos IEPS
    if (document.getElementById("FAC_USO_IEPS1").checked) {
        strPOST += "&" + strPrefijoMaster + "_USO_IEPS=1";
        strPOST += "&" + strPrefijoMaster + "_TASA_IEPS=" + d.getElementById("FAC_TASA_IEPS").value;
        strPOST += "&" + strPrefijoMaster + "_IMPORTE_IEPS=" + d.getElementById("FAC_IMPORTE_IEPS").value;
    } else {
        strPOST += "&" + strPrefijoMaster + "_USO_IEPS=0";
        strPOST += "&" + strPrefijoMaster + "_TASA_IEPS=0";
        strPOST += "&" + strPrefijoMaster + "_IMPORTE_IEPS=0";
    }
    //Recurrentes
    if (d.getElementById("FAC_ESRECU1").checked) {
        strPOST += "&" + strPrefijoMaster + "_ESRECU=1";
    } else {
        strPOST += "&" + strPrefijoMaster + "_ESRECU=0";
    }
    strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD=" + d.getElementById("FAC_PERIODICIDAD").value;
    strPOST += "&" + strPrefijoMaster + "_DIAPER=" + d.getElementById("FAC_DIAPER").value;
    //Validacion regimen fiscal
    if (document.getElementById("FAC_REGIMENFISCALcount") != null &&
            document.getElementById("FAC_REGIMENFISCALcount") != undefined) {
        var intCuantosReg = document.getElementById("FAC_REGIMENFISCALcount").value;
        if (intCuantosReg > 0) {
            //Obtenemos el valor seleccionado
            for (var iRegim = 0; iRegim < intCuantosReg; iRegim++) {
                if (d.getElementById("FAC_REGIMENFISCAL" + iRegim).checked) {
                    strPOST += "&" + strPrefijoMaster + "_REGIMENFISCAL=" + d.getElementById("FAC_REGIMENFISCAL" + iRegim).value;
                }
            }
        }
    }
    //Id de cliente final
    if (d.getElementById("CT_CLIENTEFINAL") != null) {
        strPOST += "&DFA_ID=" + d.getElementById("CT_CLIENTEFINAL").value;
    }
    if (document.getElementById("FAC_SERIE") != null) {
        strPOST += "&" + strPrefijoMaster + "_SERIE=" + d.getElementById("FAC_SERIE").value;
    }
    //Agregamos campos ADDENDA FEMSA
    if (d.getElementById("ADD_FEMSA") != null) {
        if (d.getElementById("ADD_FEMSA").value != undefined) {
            if (d.getElementById("ADD_FEMSA").value != 0) {
                if (d.getElementById("USA_FEMSA1").checked) {
                    strPOST += "&ADD_FEMSA=1";
                    strPOST += "&FEM_TIPO=" + d.getElementById("FEM_TIPO").value;
                    strPOST += "&FEM_SOC=" + d.getElementById("FEM_SOC").value;
                    strPOST += "&FEM_NUM_PROV=" + d.getElementById("FEM_NUM_PROV").value;
                    strPOST += "&FEM_NUM_PED=" + d.getElementById("FEM_NUM_PED").value;
                    strPOST += "&FEM_MONEDA=" + d.getElementById("FEM_MONEDA").value;
                    strPOST += "&FEM_NUM_ENTR_SAP=" + d.getElementById("FEM_NUM_ENTR_SAP").value;
                    strPOST += "&FEM_NUM_REMI=" + d.getElementById("FEM_NUM_REMI").value;
                    strPOST += "&FEM_RET=" + d.getElementById("FEM_RET").value;
                    strPOST += "&FEM_CORREO=" + d.getElementById("FEM_CORREO").value;
                }
            }
        } else {
            strPOST += "&ADD_FEMSA=0";
        }
    } else {
        strPOST += "&ADD_FEMSA=0";
    }
    //Items
    var grid = jQuery("#FAC_GRID");
    var arr = grid.getDataIDs();
    var intC = 0;
    for (var i = 0; i < arr.length; i++) {
        var id = arr[i];
        var lstRow = grid.getRowData(id);
        intC++;
        strPOST += "&PR_ID" + intC + "=" + lstRow.FACD_PR_ID;
        strPOST += "&" + strPrefijoDeta + "_EXENTO1" + intC + "=" + lstRow.FACD_EXENTO1;
        strPOST += "&" + strPrefijoDeta + "_EXENTO2" + intC + "=" + lstRow.FACD_EXENTO2;
        strPOST += "&" + strPrefijoDeta + "_EXENTO3" + intC + "=" + lstRow.FACD_EXENTO3;
        strPOST += "&" + strPrefijoDeta + "_CVE" + intC + "=" + lstRow.FACD_CVE;
        strPOST += "&" + strPrefijoDeta + "_DESCRIPCION" + intC + "=" + encodeURIComponent(lstRow.FACD_DESCRIPCION);
        strPOST += "&" + strPrefijoDeta + "_CANTIDAD" + intC + "=" + lstRow.FACD_CANTIDAD;
        strPOST += "&" + strPrefijoDeta + "_RET_ISR" + intC + "=" + lstRow.FACD_RET_ISR;
        strPOST += "&" + strPrefijoDeta + "_RET_IVA" + intC + "=" + lstRow.FACD_RET_IVA;
        strPOST += "&" + strPrefijoDeta + "_RET_FLETE" + intC + "=" + lstRow.FACD_RET_FLETE;
        strPOST += "&" + strPrefijoDeta + "_CF_ID" + intC + "=" + lstRow.FACD_CF_ID;
        //Validamos si los precios incluyen o no impuestos para guardarlos incluyendo impuestos
        if (intPreciosconImp == 1) {
            strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + lstRow.FACD_PRECIO;
            strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + lstRow.FACD_PRECREAL;
        } else {
            var dblPrecioConImp = 0;
            var dblPrecioRealConImp = 0;
            if (lstRow.FACD_CANTIDAD > 0) {
                dblPrecioConImp = (parseFloat(lstRow.FACD_PRECIO) +
                        parseFloat(lstRow.FACD_IMPUESTO1 / lstRow.FACD_CANTIDAD) +
                        parseFloat(lstRow.FACD_IMPUESTO2 / lstRow.FACD_CANTIDAD) +
                        parseFloat(lstRow.FACD_IMPUESTO3 / lstRow.FACD_CANTIDAD));
                dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECREAL) +
                        parseFloat(lstRow.FACD_IMPUESTO1 / lstRow.FACD_CANTIDAD) +
                        parseFloat(lstRow.FACD_IMPUESTO2 / lstRow.FACD_CANTIDAD) +
                        parseFloat(lstRow.FACD_IMPUESTO3 / lstRow.FACD_CANTIDAD));
            } else {
                dblPrecioConImp = (parseFloat(lstRow.FACD_PRECIO));
                dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECREAL));
            }
            strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + dblPrecioConImp;
            strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + dblPrecioRealConImp;
        }
        strPOST += "&" + strPrefijoDeta + "_IMPORTE" + intC + "=" + lstRow.FACD_IMPORTE;
        strPOST += "&" + strPrefijoDeta + "_TASAIVA1" + intC + "=" + lstRow.FACD_TASAIVA1;
        strPOST += "&" + strPrefijoDeta + "_TASAIVA2" + intC + "=0" + lstRow.FACD_TASAIVA2;
        strPOST += "&" + strPrefijoDeta + "_TASAIVA3" + intC + "=" + lstRow.FACD_TASAIVA3;
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO1" + intC + "=" + lstRow.FACD_IMPUESTO1;
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO2" + intC + "=" + lstRow.FACD_IMPUESTO2;
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO3" + intC + "=" + lstRow.FACD_IMPUESTO3;
        strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + lstRow.FACD_ESREGALO;
        strPOST += "&" + strPrefijoDeta + "_NOSERIE" + intC + "=" + lstRow.FACD_NOSERIE;
        strPOST += "&" + strPrefijoDeta + "_IMPORTEREAL" + intC + "=" + lstRow.FACD_IMPORTEREAL;
        strPOST += "&" + strPrefijoDeta + "_DESCUENTO" + intC + "=" + lstRow.FACD_DESCUENTO;
        strPOST += "&" + strPrefijoDeta + "_PORDESC" + intC + "=" + lstRow.FACD_PORDESC;
        strPOST += "&" + strPrefijoDeta + "_ESDEVO" + intC + "=" + lstRow.FACD_ESDEVO;
        strPOST += "&" + strPrefijoDeta + "_PRECFIJO" + intC + "=" + lstRow.FACD_PRECFIJO;
        strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + lstRow.FACD_ESREGALO;
        strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + encodeURIComponent(lstRow.FACD_NOTAS);
        strPOST += "&" + strPrefijoDeta + "_UNIDAD_MEDIDA" + intC + "=" + encodeURIComponent(lstRow.FACD_UNIDADMEDIDA);
    }
    strPOST += "&COUNT_ITEM=" + intC;
    strPOST += "&COUNT_PAGOS=4";
    //Pagos Mandamos las 4 formas de pago
    //efectivo
    strPOST += "&MCD_MONEDA1=1";
    strPOST += "&MCD_FOLIO1=";
    strPOST += "&MCD_FORMAPAGO1=EFECTIVO";
    strPOST += "&MCD_NOCHEQUE1=";
    strPOST += "&MCD_BANCO1=";
    strPOST += "&MCD_NOTARJETA1=";
    strPOST += "&MCD_TIPOTARJETA1=";
    strPOST += "&MCD_IMPORTE1=0.0";
    strPOST += "&MCD_TASAPESO1=1";
    strPOST += "&MCD_CAMBIO1=0.0";
    //cheque
    strPOST += "&MCD_MONEDA2=1";
    strPOST += "&MCD_FOLIO2=";
    strPOST += "&MCD_FORMAPAGO2=CHEQUE";
    strPOST += "&MCD_NOCHEQUE2=";
    strPOST += "&MCD_BANCO2=";
    strPOST += "&MCD_NOTARJETA2=";
    strPOST += "&MCD_TIPOTARJETA2=";
    strPOST += "&MCD_IMPORTE2=0.0";
    strPOST += "&MCD_TASAPESO2=1";
    strPOST += "&MCD_CAMBIO2=0";
    //tarjeta de credito
    strPOST += "&MCD_MONEDA3=1";
    strPOST += "&MCD_FOLIO3=";
    strPOST += "&MCD_FORMAPAGO3=TCREDITO";
    strPOST += "&MCD_NOCHEQUE3=";
    strPOST += "&MCD_BANCO3=";
    strPOST += "&MCD_NOTARJETA3=";
    strPOST += "&MCD_TIPOTARJETA3=";
    strPOST += "&MCD_IMPORTE3=0.0";
    strPOST += "&MCD_TASAPESO3=1";
    strPOST += "&MCD_CAMBIO3=0";
    //saldo a favor
    strPOST += "&MCD_MONEDA4=1";
    strPOST += "&MCD_FOLIO4=";
    strPOST += "&MCD_FORMAPAGO4=SALDOFAVOR";
    strPOST += "&MCD_NOCHEQUE4=";
    strPOST += "&MCD_BANCO4=";
    strPOST += "&MCD_NOTARJETA4=";
    strPOST += "&MCD_TIPOTARJETA4=";
    strPOST += "&MCD_IMPORTE4=0.0";
    strPOST += "&MCD_TASAPESO4=1";
    strPOST += "&MCD_CAMBIO4=0";
    //Hacemos la peticion por POST
    $.ajax({
        type: "POST",
        data: encodeURI(strPOST),
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "VtasMov.do?id=1",
        success: function (dato) {
            dato = trim(dato);
            if (Left(dato, 3) == "OK.") {
                if (strNomFormat == "FACTURA") {
                    var strHtml = CreaHidden(strKey, dato.replace("OK.", ""));
                    openWhereverFormat("ERP_SendInvoice?id=" + dato.replace("OK.", ""), strNomFormat, "PDF", strHtml);
                } else {
                    var strHtml2 = CreaHidden(strKey, dato.replace("OK.", ""));
                    openFormat(strNomFormat, "PDF", strHtml2);
                }
                ResetOperaActualSv();
            } else {
                alert(dato);
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**Funciones para el cuadro de dialogo SI/NO*/
function ConfirmaSISv() {
    if (d.getElementById("Operac").value == "Nva") {
        //Llamamos metodo para limpiar pantallas
        ResetOperaActualSv()
    }
    d.getElementById("Operac").value = "";
    $("#SioNO").dialog("close");
}
function ConfirmaNOSv() {
    $("#SioNO").dialog("close");
}
//Panel de botones
/**Guardar operacion*/
function CallbtnSv0() {
    SaveVtaSv();
}
/**Nueva operacion*/
function CallbtnSv1() {
    $("#SioNO").dialog('option', 'title', "¿Confirma que desea borrar la operacion actual e iniciar una nueva?");
    d.getElementById("Operac").value = "Nva";
    document.getElementById("SioNO_inside").innerHTML = "";
    $("#SioNO").dialog("open");
}
/**Limpia la operacion actual*/
function ResetOperaActualSv(bolSelOpera) {
    if (bolSelOpera == undefined)
        bolSelOpera = true;
    if (bolSelOpera)
        $("#dialogWait").dialog("open");
    //Limpiamos los campos y ponemos al cliente default
    d.getElementById("FCT_ID").value = intCteDefa;
    d.getElementById("FAC_FOLIO").value = "";
    d.getElementById("FAC_NOTAS").value = "";
    document.getElementById("FAC_NOTASPIE").value = "";
    d.getElementById("FAC_TOT").value = "0.0";
    d.getElementById("FAC_RETISR").value = "0.0";
    d.getElementById("FAC_RETIVA").value = "0.0";
    d.getElementById("FAC_NETO").value = "0.0";
    d.getElementById("FAC_IMPUESTO1").value = "0.0";
    d.getElementById("FAC_IMPUESTO2").value = "0.0";
    d.getElementById("FAC_IMPUESTO3").value = "0.0";
    d.getElementById("FAC_IMPORTE").value = "0.0";
    d.getElementById("FAC_DESC").value = "";
    d.getElementById("FAC_PRECIO").value = "0.0";
    d.getElementById("VE_ID").value = "0";
    d.getElementById("VE_NOM").value = "";
    d.getElementById("FAC_DESC").focus();
    d.getElementById("FAC_TIPO").value = "1";
    //Recurrentes
    d.getElementById("FAC_ESRECU2").checked = true;
    d.getElementById("FAC_PERIODICIDAD").value = "1";
    d.getElementById("FAC_DIAPER").value = "1";
    d.getElementById("FAC_METODOPAGO").value = "";
    d.getElementById("FAC_NUMCUENTA").value = "";
    OcultarAvisosServ();
    if (bolSelOpera)
        ObtenNomCteServ();
    //Limpiamos el GRID
    var grid = jQuery("#FAC_GRID");
    grid.clearGridData();
    //Limpiamos PAGOS
    if (objMap.getXml("FORMPAGO") != null && d.getElementById("TOTALPAGADO") != null) {
        d.getElementById("TOTALPAGADO").value = 0;
        d.getElementById("FPago1").value = 0;
        d.getElementById("FPago2").value = 0;
        d.getElementById("FPago3").value = 0;
        d.getElementById("FPago4").value = 0;
        d.getElementById("Ef_1").value = "0.0";
        d.getElementById("Ef_2").value = "0.0";
        d.getElementById("Bc_2").value = "";
        d.getElementById("Bc_3").value = "";
        d.getElementById("Bc_1").value = "0.0";
        d.getElementById("Tj_2").value = "";
        d.getElementById("Tj_3").value = "";
        d.getElementById("Tj_1").value = "0.0";
        d.getElementById("sf_1").value = "0.0";
    }
    if (bolSelOpera)
        $("#dialogWait").dialog("close");
    //Seleccionamos el tipo de operacion
    //if(bolSelOpera)SelOperFactServ();
    //Validamos si la sucursal puede editarse
    EvalSucursalSv();
}
/**Abre la ventana de consulta de ventas*/
function CallbtnSv2() {
    OpnOpt('VTAS_VIEW', '_ed', 'dialogView', false, false, true);
}
/**Borramos item*/
function CallbtnSv7() {
    VtaDropSv()
}
/**Mostramos el menu*/
function CallbtnSv9() {
    myLayout.open("west");
    myLayout.open("east");
    myLayout.open("south");
    myLayout.open("north");
    document.getElementById("MainPanel").innerHTML = "";
    //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
    var objMainFacPedi = objMap.getScreen("SERVICIOS");
    objMainFacPedi.bolActivo = false;
    objMainFacPedi.bolMain = false;
    objMainFacPedi.bolInit = false;
    objMainFacPedi.idOperAct = 0;
}//Borramos item

/**Abre el cuadro de dialogo para seleccionar el tipo de operacion*/
function SelOperFactServ() {
    var elements = new Array();
    elements[0] = new Seloptions("FACTURA", 1);
    var strHTML = CreaPanelRadio("", "OperFactSel", 1, elements, 0, " onClick=\"SelOperFactServDo()\" ", false, "", "", false);
    $("#dialogInv").dialog('option', 'title', lstMsg[38]);
    document.getElementById("dialogInv").innerHTML = strHTML;
    $("#dialogInv").dialog("option", "width", 500);
    $("#dialogInv").dialog("open");
}
/**Selecciona el tipo de operacion de ventas*/
function SelOperFactServDo() {
    for (var i = 0; i < d.getElementById("OperFactSelcount").value; i++) {
        if (d.getElementById("OperFactSel" + i).checked) {
            d.getElementById("FAC_TIPO").value = d.getElementById("OperFactSel" + i).value;
        }
    }
    d.getElementById("FAC_DESC").focus();
    $("#dialogInv").dialog("close");
}
/**Carga la informacion de una operacion de REMISION o VENTA*/
function getPedidoenVentaSrv(intIdPedido, strTipoVta) {
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
                            (objPedido.getAttribute("TKT_ID") != 0 && objPedido.getAttribute('PD_ESRECU') == 1)) {
                        //Limpiamos la operacion actual.
                        ResetOperaActualSv(false);
                        //Llenamos la pantalla con los valores del bd
                        DrawPedidoenVentaSrv(objPedido, lstdeta, strTipoVta);
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
function DrawPedidoenVentaSrv(objPedido, lstdeta, strTipoVta) {
    $("#dialogWait").dialog("open");
    document.getElementById("PD_ID").value = objPedido.getAttribute('PD_ID');
    if (strTipoVta == "REMISION") {
        MostrarAvisos(lstMsg[55] + objPedido.getAttribute('PD_ID'))
        document.getElementById("FAC_TIPO").value = 2;
    } else {
        if (strTipoVta == "FACTURA") {
            MostrarAvisos(lstMsg[54] + objPedido.getAttribute('PD_ID'))
            document.getElementById("FAC_TIPO").value = 1;
        } else {
            MostrarAvisos(lstMsg[57] + objPedido.getAttribute('PD_ID'))
            document.getElementById("FAC_TIPO").value = 3;
        }
    }
    document.getElementById("FAC_FOLIO").value = objPedido.getAttribute('PD_FOLIO');
    document.getElementById("SC_ID").value = objPedido.getAttribute('SC_ID');
    document.getElementById("FCT_ID").value = objPedido.getAttribute('CT_ID');
    document.getElementById("FAC_NOTAS").value = objPedido.getAttribute('FAC_NOTAS');
    if (objPedido.getAttribute('PD_ESRECU') == 1) {
        document.getElementById("FAC_ESRECU1").checked = true;
    } else {
        document.getElementById("FAC_ESRECU2").checked = false;
    }
    document.getElementById("FAC_PERIODICIDAD").value = objPedido.getAttribute('PD_PERIODICIDAD');
    document.getElementById("FAC_DIAPER").value = objPedido.getAttribute('PD_DIAPER');
    document.getElementById("VE_ID").value = objPedido.getAttribute('VE_ID');
    ObtenNomCteServ(objPedido, lstdeta, strTipoVta, true);
}
/**
 *Llenamos el grid con los datos del pedido
 **/
function DrawPedidoDetaenVentaSrv(objPedido, lstdeta, strTipoVta) {
    //Generamos el detalle
    for (i = 0; i < lstdeta.length; i++) {
        var obj = lstdeta[i];
        var objImportes = new _ImporteVta();
        objImportes.dblCantidad = obj.getAttribute('PDD_CANTIDAD');
        objImportes.dblPrecio = parseFloat(obj.getAttribute('PDD_PRECIO')) / (1 + (obj.getAttribute('PDD_TASAIVA1') / 100));
        objImportes.dblPrecioReal = parseFloat(obj.getAttribute('PDD_PRECREAL')) / (1 + (obj.getAttribute('PDD_TASAIVA1') / 100));
        objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
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
        objImportes.CalculaImporte();
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
            FACD_IMPORTEREAL: dblImporte,
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
    setSumSv();
    $("#dialogWait").dialog("close");
}
/**Muestra el label de aviso*/
function MostrarAvisos(strMsg) {
    var label = document.getElementById("LABELAVISOS");
    label.innerHTML = strMsg;
    //Mostrar aviso
    label.setAttribute("class", "Mostrar");
    label.setAttribute("className", "Mostrar");
    label.setAttribute("class", "ui-Total");
    label.setAttribute("className", "ui-Total");
}
/**Oculta el label de aviso*/
function OcultarAvisosServ() {
    var label = document.getElementById("LABELAVISOS");
    label.innerHTML = "";
    label.setAttribute("class", "Oculto");
    label.setAttribute("className", "Oculto");
}
/*
 *lista de teclas abreviadas en pantalla
 *Espacio para colocar banners de publicidad.
 ***/
/**
 *Representa un importe calculado para la venta
 *@dblImporte es el importe de venta
 **/
function _ImporteVta() {
    this.dblImporte = 0;
    this.dblImpuesto1 = 0;
    this.dblImpuesto2 = 0;
    this.dblImpuesto3 = 0;
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
    this.dblImporteDescuento = 0;
    this.CalculaImporte = function CalculaImporte() {
        //Calculamos el importe
        this.dblPorcDescGlobal = parseFloat(this.dblPorcDescGlobal);
        this.dblPorcDesc = parseFloat(this.dblPorcDesc);
        var dblPrecioAplica = parseFloat(this.dblPrecio);
        if (this.dblPrecFijo == 0) {
            this.dblPorcAplica = 0;
            if (this.dblPorcDescGlobal > 0 && this.dblPorcDesc > 0) {
                if (this.dblPorcDescGlobal > this.dblPorcDesc)
                    this.dblPorcAplica = this.dblPorcDescGlobal;
                if (this.dblPorcDesc > this.dblPorcDescGlobal)
                    this.dblPorcAplica = this.dblPorcDesc;
                if (this.dblPorcDesc == this.dblPorcDescGlobal)
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
        if (parseInt(intCT_TIPOFACSv) == 1) {
            if (strCT_USOIMBUEBLESv == "HABITACIONAL") {
                dblBase1 = 0;
            }
        }
        //Calculamos el impuesto
        var tax = new Impuestos(dblTasaVtaSv1, dblTasaVtaSv2, dblTasaVtaSv3, intSImpVta1_2Sv, intSImpVta1_3Sv, intSImpVta2_3Sv);//Objeto para calculo de impuestos
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
        if (parseInt(intCT_TIPOFACSv) == 1) {
            if (strCT_USOIMBUEBLESv == "HABITACIONAL") {
                this.dblImpuesto1 = 0;
            }
        }
        this.dblImporteReal = parseFloat(this.dblCantidad) * parseFloat(this.dblPrecioReal);
        if (intPreciosconImp == 0) {
            if (bolRetieneImpuesto2) {
                this.dblImporteReal += this.dblImpuesto1 - this.dblImpuesto2 + this.dblImpuesto3;
                this.dblImporte += this.dblImpuesto1 - this.dblImpuesto2 + this.dblImpuesto3;
            } else {
                this.dblImporteReal += this.dblImpuesto1 + this.dblImpuesto2 + this.dblImpuesto3;
                this.dblImporte += this.dblImpuesto1 + this.dblImpuesto2 + this.dblImpuesto3;
            }
        }
    }
}
/**Valida la sucursal al momento de cambiarla*/
function ValidaSuc() {
    if (parseFloat(document.getElementById("SC_ID").value) == 0) {
        document.getElementById("SC_ID").value = intSucDefa;
        InitImpDefault();
    } else {
        InitImpSuc();
    }
}
/**Inicializa los impuestos por default*/
function InitImpDefault() {
    dblTasaVtaSv1 = dblTasa1;
    dblTasaVtaSv2 = dblTasa2;
    dblTasaVtaSv3 = dblTasa3;
    intSImpVta1_2Sv = intSImp1_2;
    intSImpVta1_3Sv = intSImp1_3;
    intSImpVta2_3Sv = intSImp2_3;
}
/**Inicializa los impuestos de la sucursal seleccionada*/
function InitImpSuc() {
    var objSuc = document.getElementById("SC_ID");
    $("#dialogWait").dialog("open");
    //Mandamos la peticion por ajax para que nos den el XML del pedido
    $.ajax({
        type: "POST",
        data: "SC_ID=" + objSuc.value,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=10",
        success: function (datos) {
            var objPedido = datos.getElementsByTagName("vta_impuesto")[0];
            var lstdeta = objPedido.getElementsByTagName("vta_impuestos");
            //Validamos que sea un pedido correcto
            for (var i = 0; i < lstdeta.length; i++) {
                var obj = lstdeta[i];
                dblTasaVtaSv1 = obj.getAttribute('Tasa1');
                dblTasaVtaSv2 = obj.getAttribute('Tasa2');
                dblTasaVtaSv3 = obj.getAttribute('Tasa3');
                intIdTasaVtaSv1 = obj.getAttribute('TI_ID');
                intIdTasaVtaSv2 = obj.getAttribute('TI_ID2');
                intIdTasaVtaSv3 = obj.getAttribute('TI_ID3');
                d.getElementById("FAC_TASASEL1").value = intIdTasaVtaSv1;
                if (d.getElementById("FAC_TASASEL2") != null) {
                    d.getElementById("FAC_TASASEL2").value = intIdTasaVtaSv2;
                }
                if (d.getElementById("FAC_TASASEL3") != null) {
                    d.getElementById("FAC_TASASEL3").value = intIdTasaVtaSv3;
                }
                intSImpVta1_2Sv = obj.getAttribute('SImp1_2');
                intSImpVta1_3Sv = obj.getAttribute('SImp1_3');
                intSImpVta2_3Sv = obj.getAttribute('SImp2_3');
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**Evaluamos si podemos cambiar la sucursal*/
function EvalSucursalSv() {
    var grid = jQuery("#FAC_GRID");
    var arr = grid.getDataIDs();
    var objSuc = document.getElementById("SC_ID");
    var objTasaSel = document.getElementById("FAC_TASASEL1");
    var objTasaSel2 = document.getElementById("FAC_TASASEL2");
    var objTasaSel3 = document.getElementById("FAC_TASASEL3");
    if (arr.length > 0) {
        //Si hay partidas no podremos cambiar la sucursal
        objSuc.onmouseout = function () {
            this.disabled = false;
        };
        objSuc.onmouseleave = function () {
            this.disabled = false;
        };
        objSuc.onmouseover = function () {
            this.disabled = true;
        };
        objSuc.setAttribute("class", "READONLY");
        objSuc.setAttribute("className", "READONLY");
//      objTasaSel.onmouseout = function() {
//         this.disabled = false;
//      };
//      objTasaSel.onmouseleave = function() {
//         this.disabled = false;
//      };
//      objTasaSel.onmouseover = function() {
//         this.disabled = true;
//      };
//      objTasaSel.setAttribute("class", "READONLY");
//      objTasaSel.setAttribute("className", "READONLY");
        if (objTasaSel2 != null) {
            objTasaSel2.onmouseout = function () {
                this.disabled = false;
            };
            objTasaSel2.onmouseleave = function () {
                this.disabled = false;
            };
            objTasaSel2.onmouseover = function () {
                this.disabled = true;
            };
            objTasaSel2.setAttribute("class", "READONLY");
            objTasaSel2.setAttribute("className", "READONLY");
        }
        if (objTasaSel3 != null) {
            objTasaSel3.onmouseout = function () {
                this.disabled = false;
            };
            objTasaSel3.onmouseleave = function () {
                this.disabled = false;
            };
            objTasaSel3.onmouseover = function () {
                this.disabled = true;
            };
            objTasaSel3.setAttribute("class", "READONLY");
            objTasaSel3.setAttribute("className", "READONLY");
        }
    } else {
        objSuc.disabled = false;
        //Si hay partidas no podremos cambiar la sucursal
        objSuc.onmouseout = function () {
            var g = 1;
        };
        objSuc.onmouseleave = function () {
            var g = 1;
        };
        objSuc.onmouseover = function () {
            var g = 1;
        };
        objSuc.setAttribute("class", "outEdit");
        objSuc.setAttribute("className", "outEdit");
//      objTasaSel.disabled = false;
//      //Si hay partidas no podremos cambiar la sucursal
//      objTasaSel.onmouseout = function() {
//         var g = 1;
//      };
//      objTasaSel.onmouseleave = function() {
//         var g = 1;
//      };
//      objTasaSel.onmouseover = function() {
//         var g = 1;
//      };
//      objTasaSel.setAttribute("class", "outEdit");
//      objTasaSel.setAttribute("className", "outEdit");
        if (objTasaSel2 != null) {
            objTasaSel2.disabled = false;
            //Si hay partidas no podremos cambiar la sucursal
            objTasaSel2.onmouseout = function () {
                var g = 1;
            };
            objTasaSel2.onmouseleave = function () {
                var g = 1;
            };
            objTasaSel2.onmouseover = function () {
                var g = 1;
            };
            objTasaSel2.setAttribute("class", "outEdit");
            objTasaSel2.setAttribute("className", "outEdit");
        }
        if (objTasaSel3 != null) {
            objTasaSel3.disabled = false;
            //Si hay partidas no podremos cambiar la sucursal
            objTasaSel3.onmouseout = function () {
                var g = 1;
            };
            objTasaSel3.onmouseleave = function () {
                var g = 1;
            };
            objTasaSel3.onmouseover = function () {
                var g = 1;
            };
            objTasaSel3.setAttribute("class", "outEdit");
            objTasaSel3.setAttribute("className", "outEdit");
        }
    }
}
/**Activa o inactiva el campo de tipo de moneda*/
function RefreshMonedaSrv() {
    var objMoneda = document.getElementById("FAC_MONEDA");
    var objTipoCambio = document.getElementById("FAC_TASAPESO");
    //Si la moneda es 1(pesos) inactivamos el tipo de cambio
    if (objMoneda.value == 1) {
        objTipoCambio.value = 1;
        objTipoCambio.setAttribute("class", "READONLY");
        objTipoCambio.setAttribute("className", "READONLY");
        objTipoCambio.readOnly = true;
    } else {
        objTipoCambio.value = 1;
        objTipoCambio.setAttribute("class", "outEdit");
        objTipoCambio.setAttribute("className", "outEdit");
        objTipoCambio.readOnly = false;
    }
}
/**Actualiza la tasa de acuerdo al impuesto seleccionado*/
function UpdateTasaImpSrv() {
    var objTasaSel = document.getElementById("FAC_TASASEL1");
    $("#dialogWait").dialog("open");
    //Mandamos la peticion por ajax para que nos den el XML del pedido
    $.ajax({
        type: "POST",
        data: "TI_ID=" + objTasaSel.value,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=11",
        success: function (datos) {
            var objPedido = datos.getElementsByTagName("vta_impuesto")[0];
            var lstdeta = objPedido.getElementsByTagName("vta_impuestos");
            for (var i = 0; i < lstdeta.length; i++) {
                var obj = lstdeta[i];
                dblTasaVtaSv1 = obj.getAttribute('Tasa1');
                intIdTasaVtaSv1 = objTasaSel.value;
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**Actualiza la tasa de acuerdo al impuesto seleccionado*/
function UpdateTasaImpSrv2() {
    var objTasaSel = document.getElementById("FAC_TASASEL2");
    $("#dialogWait").dialog("open");
    //Mandamos la peticion por ajax para que nos den el XML del pedido
    $.ajax({
        type: "POST",
        data: "TI2_ID=" + objTasaSel.value,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=17",
        success: function (datos) {
            var objPedido = datos.getElementsByTagName("vta_impuesto")[0];
            var lstdeta = objPedido.getElementsByTagName("vta_impuestos");
            for (var i = 0; i < lstdeta.length; i++) {
                var obj = lstdeta[i];
                dblTasaVtaSv2 = obj.getAttribute('Tasa2');
                intIdTasaVtaSv2 = objTasaSel.value;
                if (parseInt(obj.getAttribute('Retiene')) == 1) {
                    bolRetieneImpuesto2 = true;
                } else {
                    bolRetieneImpuesto2 = false;
                }
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Impuesto 2:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**Actualiza la tasa de acuerdo al impuesto seleccionado*/
function UpdateTasaImpSrv3() {
    var objTasaSel = document.getElementById("FAC_TASASEL3");
    $("#dialogWait").dialog("open");
    //Mandamos la peticion por ajax para que nos den el XML del pedido
    $.ajax({
        type: "POST",
        data: "TI3_ID=" + objTasaSel.value,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=18",
        success: function (datos) {
            var objPedido = datos.getElementsByTagName("vta_impuesto")[0];
            var lstdeta = objPedido.getElementsByTagName("vta_impuestos");
            for (var i = 0; i < lstdeta.length; i++) {
                var obj = lstdeta[i];
                dblTasaVtaSv3 = obj.getAttribute('Tasa2');
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Impuesto 3:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
function OpnDiagCon() {
    OpnOpt('CON', 'grid', 'dialogCon', false, false);
}
/**Selecciona el primer regimen fiscal*/
function SelRegDefaSrv() {
    if (document.getElementById("FAC_REGIMENFISCALcount") != null &&
            document.getElementById("FAC_REGIMENFISCALcount") != undefined) {
        var intCuantosReg = document.getElementById("FAC_REGIMENFISCALcount").value;
        if (intCuantosReg > 0) {
            //Obtenemos el valor seleccionado
            for (var iRegim = 0; iRegim < intCuantosReg; iRegim++) {
                d.getElementById("FAC_REGIMENFISCAL" + iRegim).checked = true;
                break;
            }
        }
    }
}

/**Validamos campos obligatorios FEMSA*/
function ValidaFEMSA() {
    var bolPasa = true;
    if (document.getElementById("FEM_TIPO").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("FEM_SOC").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("FEM_NUM_PROV").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("FEM_NUM_PED").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("FEM_MONEDA").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("FEM_NUM_ENTR_SAP").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("FEM_NUM_REMI").value == "") {
        bolPasa = false;
    }
    return bolPasa;
}

function  ObtenClienteFinalServ() {
    var bolExist = false;

    //Peticion por ajax para mostrar info
    $.ajax({
        type: "POST",
        data: "ct_id=" + document.getElementById("FCT_ID").value, //id de cliente seleccionado
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "ERP_ClienteFacturacion.jsp?ID=5",
        success: function (datos) {
            var lstDirecciones = datos.getElementsByTagName("Direcciones")[0];
            var lstDireccion = lstDirecciones.getElementsByTagName("direcciones");

            var objDir = document.getElementById("CT_CLIENTEFINAL");
            select_clear(objDir);

            for (j = 0; j < lstDireccion.length; j++) {
                bolExist = true;
                var objP = lstDireccion[j];
                if (j == 0) {
                    select_add(objDir, "<-Seleccione->", 0);
                }
                select_add(objDir, objP.getAttribute('dir_cliente'), objP.getAttribute('id_dir'));
            }
            if (bolExist == false) {
                select_add(objDir, '<--No existen mas Clientes-->', 0);
            }

        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });

}

function SumaImpuestosServicio()
{
    var dblAntesIVA = parseFloat(document.getElementById("FAC_IMPORTE").value);
    var dblImpuesto = parseFloat(document.getElementById("FAC_IMPUESTO2").value);
    var dblImpuestoIVA = parseFloat(document.getElementById("FAC_IMPUESTO1").value);
    var dblImpuestoIEPS = parseFloat(document.getElementById("FAC_IMPORTE_IEPS").value);
    document.getElementById("FAC_TOT").value = dblAntesIVA + dblImpuesto + dblImpuestoIVA + dblImpuestoIEPS;
}