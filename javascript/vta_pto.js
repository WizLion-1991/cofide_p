
/* 
 *Esta libreria realiza todas las operaciones del punto de venta
 */

//Variables globales
var itemId = 0;//indice para los items del grid
var lstPorcDesc = null;//Arreglo con los porcentajes de descuento
var bolPrice = false;
var bolPorc = false;
var bolCambioFecha = false;
var bolDevol = false;
var bolModiImpuesto = false;
var bolPerPedido = false;
var bolPerTicket = false;
var bolPerFactura = false;
var bolPerCotiza = false;
var bolNolMLM = false;
/*Promociones*/
var bolPromociones = false;
var intSucOfertas = intSucDefOfertas;
var bolCargaPromociones = false;
var bolDebugPtoVta = false;
var bolSaveVta = true;
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
var intRET_ISR = 0;
var intRET_IVA = 0;
var intRET_FLETE = 1;
var _objProdTmpz = null;
var objTabla = null;
var numFilas = 0;
var idT = 0;
var intContaIdGrid = 0;
var bolUsaOpnCte = false;
function vta_pto() {//Funcion necesaria para que pueda cargarse la libreria en automatico
}
/**Inicializa la pantalla de punto de venta*/
function InitPtoVta() {
    $("#dialogWait").dialog("open");
    myLayout.close("west");
    myLayout.close("east");
    myLayout.close("south");
    myLayout.close("north");
    //Ocultamos renglon de avisos
    OcultarAvisos();
    //Ponemos el nombre default de la sucursal
    d.getElementById("SC_ID").value = intSucDefa;
    //Hacemos diferente el estilo del total
    FormStyle();
    //Obtenemos el id del cliente y el vendedor default
    d.getElementById("FCT_ID").value = intCteDefa;
    d.getElementById("FAC_OPER").value = strUserName;
    d.getElementById("FAC_TASASEL1").value = intIdTasaVta1;
    //Tasa de impuesto 2
    if (d.getElementById("FAC_TASASEL2") != null) {
        d.getElementById("FAC_TASASEL2").value = intIdTasaVta2;
    }
    //Tasa de impuesto 3
    if (d.getElementById("FAC_TASASEL3") != null) {
        d.getElementById("FAC_TASASEL3").value = intIdTasaVta3;
    }
    d.getElementById("FAC_PROD").focus();
    ObtenNomCte();
    //Obtenemos los atributos(permisos) del usuario para esta pantalla
    bolCambioFecha = false;
    $.ajax({
        type: "POST",
        data: "keys=43,44,45,85,250,238,239,240,510,241",
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
                if (obj.getAttribute('id') == 43 && obj.getAttribute('enabled') == "true") {
                    bolPorc = true;
                }
                if (obj.getAttribute('id') == 44 && obj.getAttribute('enabled') == "true") {
                    bolPrice = true;
                }
                if (obj.getAttribute('id') == 45 && obj.getAttribute('enabled') == "true") {
                    bolDevol = true;
                }
                if (obj.getAttribute('id') == 85 && obj.getAttribute('enabled') == "true") {
                    bolCambioFecha = true;
                }
                if (obj.getAttribute('id') == 250 && obj.getAttribute('enabled') == "true") {
                    bolModiImpuesto = true;
                }
                //Permisos sobre opcion
                if (obj.getAttribute('id') == 240 && obj.getAttribute('enabled') == "true") {
                    bolPerPedido = true;
                }
                if (obj.getAttribute('id') == 239 && obj.getAttribute('enabled') == "true") {
                    bolPerTicket = true;
                }
                if (obj.getAttribute('id') == 238 && obj.getAttribute('enabled') == "true") {
                    bolPerFactura = true;
                }
                if (obj.getAttribute('id') == 241 && obj.getAttribute('enabled') == "true") {
                    bolPerCotiza = true;
                }
                if (obj.getAttribute('id') == 510 && obj.getAttribute('enabled') == "true") {
                    bolNolMLM = true;
                }
            }
            //Validamos si podemos hacer cambio de fecha
            if (bolCambioFecha) {
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
            //Evaluamos si podemos editar el boton de no aplica multinivel
            if (!bolNolMLM) {
                if (document.getElementById("FAC_ES_MLM1") != null && document.getElementById("FAC_ES_MLM2") != null) {
                    document.getElementById("FAC_ES_MLM1").readOnly = true;
                    document.getElementById("FAC_ES_MLM2").readOnly = true;
                    document.getElementById("FAC_ES_MLM1").disabled = true;
                    document.getElementById("FAC_ES_MLM2").disabled = true;
                }
            }
            //Validamos si podemos editar los impuestos
            if (!bolModiImpuesto) {
                var objTasaSel1 = document.getElementById("FAC_TASASEL1");
                //Si hay partidas no podremos cambiar la sucursal
                objTasaSel1.onmouseout = function () {
                    this.disabled = false;
                };
                objTasaSel1.onmouseleave = function () {
                    this.disabled = false;
                };
                objTasaSel1.onmouseover = function () {
                    this.disabled = true;
                };
                objTasaSel1.setAttribute("class", "READONLY");
                objTasaSel1.setAttribute("className", "READONLY");
                //Tasa 2
                var objTasaSel2 = document.getElementById("FAC_TASASEL2");
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
                //Tasa 3
                var objTasaSel3 = document.getElementById("FAC_TASASEL3");
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
            }
            $("#dialogWait").dialog("close");
            //Foco inicial
            setTimeout("d.getElementById('FAC_PROD').focus();", 3000);
            SelRegDefa();

            //Validamos la operacion por default a pintar
            var bolMenus = true;
            if (!bolPerTicket) {
                bolMenus = false;
                //No tiene permisos para los tickets por default buscamos en cual si
                if (bolPerPedido) {
                    d.getElementById("FAC_TIPO").value = 3;
                    bolMenus = true;
                }
                if (bolPerFactura) {
                    d.getElementById("FAC_TIPO").value = 1;
                    bolMenus = true;
                }
                if (bolPerCotiza) {
                    d.getElementById("FAC_TIPO").value = 5;
                    bolMenus = true;
                }

            }
            //Si tenemos permisos de hacer operaciones pintamos el menu
            if (bolMenus) {
                //Realizamos el menu de botones
                var strHtml = "<ul>" +
                        getMenuItem("Callbtn0();", "Guardar Venta", "images/ptovta/CircleSave.png") +
                        getMenuItem("Callbtn1();", "Nueva Venta", "images/ptovta/VisPlus.png") +
                        getMenuItem("Callbtn2();", "Consultar Venta", "images/ptovta/VisMagnifier.png") +
                        getMenuItem("Callbtn3();", "Descuento", "images/ptovta/VisSciss.png") +
                        getMenuItem("Callbtn4();", "Cambio Precio", "images/ptovta/VisModi.png") +
                        getMenuItem("Callbtn5();", lstMsg[129], "images/ptovta/VisQty.png") +
                        getMenuItem("Callbtn8();", "Notas", "images/ptovta/VisNote.png") +
                        getMenuItem("Callbtn6();", "Devolucion", "images/ptovta/VisLess.png") +
                        getMenuItem("Callbtn7();", "Borrar Producto", "images/ptovta/VisClose.png") +
                        getMenuItem("Callbtn9();", "Salir", "images/ptovta/exitBig.png") +
                        "</ul>";
                document.getElementById("TOOLBAR").innerHTML = strHtml;
                _EvalPromociones();
                //Seleciona el tipo de operacion de venta
                SelOperFact();
            } else {
                alert(lstMsg[156]);
                Callbtn9();
            }
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":vta1s:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
    //Definimos acciones para el dialogo SI/NO
    document.getElementById("btnSI").onclick = function () {
        ConfirmaSI();
    };
    document.getElementById("btnNO").onclick = function () {
        ConfirmaNO();
    };
}
/**Cambia los estilos de algunos controles*/
function FormStyle() {
    d.getElementById("FAC_TOT").setAttribute("class", "ui-Total");
    d.getElementById("FAC_TOT").setAttribute("className", "ui-Total");
    d.getElementById("btn1").setAttribute("class", "Oculto");
    d.getElementById("btn1").setAttribute("className", "Oculto");
}
/**Obtiene el nombre del cliente al que se le esta haciendo la venta*/
function ObtenNomCte(objPedido, lstdeta, strTipoVta, bolPasaPedido, bolPasaCotiza) {
    var intCte = document.getElementById("FCT_ID").value;
    if (bolPasaPedido == undefined)
        bolPasaPedido = false;
    ValidaClean("CT_NOM");
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
                document.getElementById("FCT_DIASCREDITO").value = objCte.getAttribute('CT_DIASCREDITO');
                document.getElementById("FAC_DIASCREDITO").value = objCte.getAttribute('CT_DIASCREDITO');
                document.getElementById("FCT_MONTOCRED").value = objCte.getAttribute('CT_MONTOCRED');
                document.getElementById("FAC_TTC_ID").value = objCte.getAttribute('TTC_ID');
                document.getElementById("FAC_METODOPAGO").value = objCte.getAttribute('CT_METODODEPAGO');
                document.getElementById("FAC_FORMADEPAGO").value = objCte.getAttribute('CT_FORMADEPAGO');
                document.getElementById("FAC_NUMCUENTA").value = objCte.getAttribute('CT_CTABANCO1');
                document.getElementById("VE_ID").value = objCte.getAttribute('CT_VENDEDOR');
                intCT_TIPOPERS = objCte.getAttribute('CT_TIPOPERS');
                intCT_TIPOFAC = objCte.getAttribute('CT_TIPOFAC');
                strCT_USOIMBUEBLE = objCte.getAttribute('CT_USOIMBUEBLE');
                /**
                 * recuperaremail
                 */
                if (d.getElementById("ADD_EMAIL") != undefined) {
                    if (d.getElementById("ADD_EMAIL") != null) {
                        if (d.getElementById("ADD_EMAIL").value != 0) {

                            ValEmail1(objCte.getAttribute("CT_EMAIL1"));
                            ValEmail2(objCte.getAttribute("CT_EMAIL2"));
                            ValEmail3(objCte.getAttribute("CT_EMAIL3"));
                            ValEmail4(objCte.getAttribute("CT_EMAIL4"));
                            ValEmail5(objCte.getAttribute("CT_EMAIL5"));
                            ValEmail6(objCte.getAttribute("CT_EMAIL6"));
                            ValEmail7(objCte.getAttribute("CT_EMAIL7"));
                            ValEmail8(objCte.getAttribute("CT_EMAIL8"));
                            ValEmail9(objCte.getAttribute("CT_EMAIL9"));
                            ValEmail10(objCte.getAttribute("CT_EMAIL10"));
                        }

                    }
                }
                //emial recueprado

                //Validamos iva y moneda por default unicamente si no estamos editando un pedido
                if (!bolPasaPedido) {
                    document.getElementById("FCT_DESCUENTO").value = objCte.getAttribute('CT_DESCUENTO');
                    if (parseInt(objCte.getAttribute('MON_ID')) != 0) {
                        document.getElementById("FAC_MONEDA").value = objCte.getAttribute('MON_ID');
                        RefreshMoneda();
                    }
                    if (parseInt(objCte.getAttribute('TI_ID')) != 0) {
                        document.getElementById("FAC_TASASEL1").value = objCte.getAttribute('TI_ID');
                        document.getElementById("FAC_USE_IMP1").value = 1;
                        UpdateTasaImp();
                    }
                    if (parseInt(objCte.getAttribute('TI2_ID')) != 0) {
                        if (document.getElementById("FAC_TASASEL2") != null) {
                            document.getElementById("FAC_TASASEL2").value = objCte.getAttribute('TI2_ID');
                            document.getElementById("FAC_USE_IMP2").value = 1;
                            UpdateTasaImp2();
                        }
                    }
                    if (parseInt(objCte.getAttribute('TI3_ID')) != 0) {
                        if (document.getElementById("FAC_TASASEL3") != null) {
                            document.getElementById("FAC_TASASEL3").value = objCte.getAttribute('TI3_ID');
                            document.getElementById("FAC_USE_IMP3").value = 1;
                            UpdateTasaImp2();
                        }
                    }
                    //Direcciones de envio.
                    ObtenDireciones();
                    ObtenClienteFinal();
                    //Moyor de promociones
                    _PromocionCte();
                }
            }
            //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
            if (bolPasaPedido) {
                DrawPedidoDetaenVenta(objPedido, lstdeta, strTipoVta);
            }
            if (bolPasaCotiza == null)
                bolPasaCotiza = false;
            //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
            if (bolPasaCotiza) {
                DrawCotizaDetaenVenta(objPedido, lstdeta, strTipoVta);
            }
        },
        error: function (objeto, quepaso, otroobj) {
            document.getElementById("CT_NOM").value = "***************";
            ValidaShow("CT_NOM", lstMsg[28]);
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}
//valida email, de cada cliente
function ValEmail1(ObEmail1) {
    var parentGuest = d.getElementById("FAC_EMAIL11").parentNode;
    var divMail1 = d.createElement("div");

    if (d.getElementById("divMail1") != null) {

        d.getElementById("divMail1").innerHTML = null;
        d.getElementById("divMail1").innerHTML = ObEmail1;

    } else {

        divMail1.innerHTML = ObEmail1;
        divMail1.id = "divMail1";
        parentGuest.appendChild(divMail1);
    }
}
function ValEmail2(ObEmail2) {
    var parentGuest = d.getElementById("FAC_EMAIL21").parentNode;
    var divMail2 = d.createElement("div");

    if (d.getElementById("divMail2") != null) {

        d.getElementById("divMail2").innerHTML = null;
        d.getElementById("divMail2").innerHTML = ObEmail2;

    } else {

        divMail2.innerHTML = ObEmail2;
        divMail2.id = "divMail2";
        parentGuest.appendChild(divMail2);
    }
}
function ValEmail3(ObEmail3) {
    var parentGuest = d.getElementById("FAC_EMAIL31").parentNode;
    var divMail3 = d.createElement("div");

    if (d.getElementById("divMail3") != null) {

        d.getElementById("divMail3").innerHTML = null;
        d.getElementById("divMail3").innerHTML = ObEmail3;

    } else {

        divMail3.innerHTML = ObEmail3;
        divMail3.id = "divMail3";
        parentGuest.appendChild(divMail3);
    }
}
function ValEmail4(ObEmail4) {
    var parentGuest = d.getElementById("FAC_EMAIL41").parentNode;
    var divMail4 = d.createElement("div");

    if (d.getElementById("divMail4") != null) {

        d.getElementById("divMail4").innerHTML = null;
        d.getElementById("divMail4").innerHTML = ObEmail4;

    } else {

        divMail4.innerHTML = ObEmail4;
        divMail4.id = "divMail4";
        parentGuest.appendChild(divMail4);
    }
}
function ValEmail5(ObEmail5) {
    var parentGuest = d.getElementById("FAC_EMAIL51").parentNode;
    var divMail5 = d.createElement("div");

    if (d.getElementById("divMail5") != null) {

        d.getElementById("divMail5").innerHTML = null;
        d.getElementById("divMail5").innerHTML = ObEmail5;

    } else {

        divMail5.innerHTML = ObEmail5;
        divMail5.id = "divMail5";
        parentGuest.appendChild(divMail5);
    }
}
function ValEmail6(ObEmail6) {
    var parentGuest = d.getElementById("FAC_EMAIL61").parentNode;
    var divMail6 = d.createElement("div");

    if (d.getElementById("divMail6") != null) {

        d.getElementById("divMail6").innerHTML = null;
        d.getElementById("divMail6").innerHTML = ObEmail6;

    } else {

        divMail6.innerHTML = ObEmail6;
        divMail6.id = "divMail6";
        parentGuest.appendChild(divMail6);
    }
}
function ValEmail7(ObEmail7) {
    ObEmail7;
    var parentGuest = d.getElementById("FAC_EMAIL71").parentNode;
    var divMail7 = d.createElement("div");
    if (d.getElementById("divMail7") != null) {

        d.getElementById("divMail7").innerHTML = null;
        d.getElementById("divMail7").innerHTML = ObEmail7;

    } else {

        divMail7.innerHTML = ObEmail7;
        divMail7.id = "divMail7";
        parentGuest.appendChild(divMail7);
    }
}
function ValEmail8(ObEmail8) {
    var parentGuest = d.getElementById("FAC_EMAIL81").parentNode;
    var divMail8 = d.createElement("div");

    if (d.getElementById("divMail8") != null) {

        d.getElementById("divMail8").innerHTML = null;
        d.getElementById("divMail8").innerHTML = ObEmail8;

    } else {

        divMail8.innerHTML = ObEmail8;
        divMail8.id = "divMail8";
        parentGuest.appendChild(divMail8);
    }
}
function ValEmail9(ObEmail9) {
    var parentGuest = d.getElementById("FAC_EMAIL91").parentNode;
    var divMail9 = d.createElement("div");

    if (d.getElementById("divMail9") != null) {

        d.getElementById("divMail9").innerHTML = null;
        d.getElementById("divMail9").innerHTML = ObEmail9;

    } else {

        divMail9.innerHTML = ObEmail9;
        divMail9.id = "divMail9";
        parentGuest.appendChild(divMail9);
    }
}
function ValEmail10(ObEmail10) {
    var parentGuest = d.getElementById("FAC_EMAIL101").parentNode;
    var divMail10 = d.createElement("div");

    if (d.getElementById("divMail10") != null) {

        d.getElementById("divMail10").innerHTML = null;
        d.getElementById("divMail10").innerHTML = ObEmail10;

    } else {

        divMail10.innerHTML = ObEmail10;
        divMail10.id = "divMail10";
        parentGuest.appendChild(divMail10);
    }
}
//valida email

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
/**Funcion para anadir partidas*/
function AddItemEvt(event, obj) {
    if (event.keyCode == 13) {
        AddItem();
    }
}
/**Funcion para anadir partidas, valida que el producto exista, luego obtiene el precio y lo anade al GRID*/
function AddItem() {
    var strCod = UCase(d.getElementById("FAC_PROD").value);
    //Validamos que hallan capturado un codigo
    if (trim(strCod) != "") {
        var intDevo = d.getElementById("FAC_DEVO").value;
        //Bandera para indicar si no se agrupan los items
        var bolAgrupa = d.getElementById("FAC_AGRUPA1").checked;
        $("#dialogWait").dialog("open");
        var bolNvo = true;
        var idProd = 0;
        //Si esta activada la funcionalidad de agrupar validamos si existe
        if (bolAgrupa) {
            //Revisamos si existe el item en el grid
            var grid = jQuery("#FAC_GRID");
            var arr = grid.getDataIDs();
            for (var i = 0; i < arr.length; i++) {
                var id = arr[i];
                var lstRowAct = grid.getRowData(id);
                if (trim(lstRowAct.FACD_CVE) == strCod ||
                        trim(lstRowAct.FACD_CODBARRAS) == strCod) {
                    if (intDevo == 1) {
                        if (lstRow.FACD_ESDEVO == 1) {
                            idProd = id;
                            bolNvo = false;
                            break;
                        }
                    } else {
                        //No aplica con componentes de paquetes([p])
                        if (lstRowAct.FACD_ES_COMPONENTE == 0) {
                            idProd = id;
                            bolNvo = false;
                            break;
                        }

                    }
                }
            }
        }
        //Validamos si es un producto nuevo
        if (bolNvo) {
            //Buscamos los importes ya que es un producto nuevo
            $.ajax({
                type: "POST",
                data: encodeURI("PR_CODIGO=" + strCod + "&SC_ID=" + d.getElementById("SC_ID").value),
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "VtasMov.do?id=5",
                success: function (datoVal) {
                    var objProd = datoVal.getElementsByTagName("vta_productos")[0];
                    var Pr_Id = 0;
                    if (objProd != undefined) {
                        Pr_Id = objProd.getAttribute('PR_ID');
                        d.getElementById("FAC_DESC").value = objProd.getAttribute('PR_DESCRIPCION');
                        //Reemplazamos el codigo del producto por el de la bd
                        if (Pr_Id != 0) {
                            strCod = objProd.getAttribute('PR_CODIGO');
                        }
                    }
                    var Ct_Id = d.getElementById("FCT_ID").value;
                    var dblCantidad = d.getElementById("FAC_CANT").value;
                    if (intDevo == 1) {
                        dblCantidad = d.getElementById("DEVO_CANTIDAD").value;
                    }
                    //Validamos si nos regreso un ID de producto valido
                    if (Pr_Id != 0) {
                        //Validamos la existencia
                        var dblExistencia = objProd.getAttribute('PR_EXISTENCIA');
                        if (objProd.getAttribute('PR_REQEXIST') == 1 &&
                                document.getElementById("FAC_TIPO").value != 3 && document.getElementById("FAC_TIPO").value != 5) {
                            //Obtenemos la existencia del producto
                            $.ajax({
                                type: "POST",
                                data: "PR_ID=" + Pr_Id,
                                scriptCharset: "utf-8",
                                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                                cache: false,
                                dataType: "html",
                                url: "InvMov.do?id=1",
                                success: function (datoExist) {
                                    dblExistencia = parseFloat(datoExist);
                                    //Validamos que no estemos pidiendo mas de la existencia
                                    if (parseFloat(dblCantidad) > dblExistencia) {
                                        alert(lstMsg[3] + "(" + dblCantidad + ") " + lstMsg[34] + strCod + "(" + dblExistencia + ") " + lstMsg[4]);
                                        if (parseFloat(dblExistencia) > 0) {
                                            dblCantidad = dblExistencia;
                                        } else {
                                            dblCantidad = 0;
                                        }
                                    }
                                    //Validamos si requiere numero de serie
                                    if (objProd.getAttribute('PR_USO_NOSERIE') == 1) {
                                        _drawScNoSerie(objProd, Pr_Id, Ct_Id, dblCantidad, strCod, dblExistencia, intDevo);
                                    } else {
                                        AddItemPrec(objProd, Pr_Id, Ct_Id, dblCantidad, strCod, dblExistencia, intDevo);
                                    }
                                },
                                error: function (objeto, quepaso, otroobj) {
                                    alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                                    $("#dialogWait").dialog("close");
                                }
                            });
                        } else {
                            AddItemPrec(objProd, Pr_Id, Ct_Id, dblCantidad, strCod, dblExistencia, intDevo);
                        }
                    } else {
                        alert(lstMsg[0]);
                        d.getElementById("FAC_DEVO").value = 0;
                        document.getElementById("FAC_PROD").focus();
                        $("#dialogWait").dialog("close");
                    }
                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":pto3:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
                }
            });
        } else {
            //Ya existe el item
            var Cantidad = d.getElementById("FAC_CANT").value;//Cantidad solicitada
            //Recuperamos los valores del producto
            var gridD = jQuery("#FAC_GRID");
            var lstRow = gridD.getRowData(idProd);
            //Validamos si maneja numero de serie para confirmar las cantidades
            if (lstRow.FACD_USA_SERIE == 1) {
                _drawScNoSerie(null, lstRow.FACD_PR_ID, 0, parseFloat(Cantidad), "", 0, 0, idProd, lstRow.FACD_SERIES);
            } else {
                //Recalculamos la cantidad
                lstRow.FACD_CANTIDAD = parseFloat(lstRow.FACD_CANTIDAD) + parseFloat(Cantidad);
                //Validamos existencias en caso de que aplique
                if (lstRow.FACD_REQEXIST == 1 &&
                        document.getElementById("FAC_TIPO").value != 3) {
                    if (parseFloat(lstRow.FACD_CANTIDAD) > parseFloat(lstRow.FACD_EXIST)) {
                        alert(lstMsg[3] + " " + lstRow.FACD_CVE + " " + lstMsg[4]);
                        if (parseFloat(lstRow.FACD_EXIST) > 0) {
                            lstRow.FACD_CANTIDAD = lstRow.FACD_EXIST;
                        } else {
                            lstRow.FACD_CANTIDAD = 0;
                        }
                    }
                }
                //En caso de paquete actualizamos las cantidades y validamos existencias([p])
                if (lstRow.FACD_ES_PAQUETE == 1) {
                    actualizaComponentesPaquete(gridD, idProd, Cantidad);
                }
                //Limpiamos los regalos
                if (intSucOfertas && bolCargaPromociones)
                    _LimpiaRegalosPromos(jQuery("#FAC_GRID"));
                //Recalculamos el importe y actualizamos la fila
                lstRowChangePrecio(lstRow, idProd, gridD);
                //Ponemos foco en el control
                document.getElementById("FAC_PROD").value = "";
                document.getElementById("FAC_PROD").focus();
                d.getElementById("FAC_CANT").value = 1;
                d.getElementById("FAC_DEVO").value = 0;
                //Sumamos todos los items
                //setSum();
                //_PromocionProd(idProd);
                $("#dialogWait").dialog("close");
                //Producto sin numero de serie
            }
        }
    }
}
//Actualiza la cantidad de los componentes del paquete([p])
function actualizaComponentesPaquete(grid, idPaqueteM, dblCantidad) {
    var arr = grid.getDataIDs();
    var bolEncontro = false;
    for (var y = 0; y < arr.length; y++) {
        var id = arr[y];
        //Aplica en caso de que encontremos el paquete maestro
        if (bolEncontro) {
            var lstRow = grid.getRowData(id);
            if (lstRow.FACD_ES_COMPONENTE == 0) {
                break;
            } else {
                //Actualizamos la cantidad
                lstRow.FACD_CANTIDAD = parseFloat(lstRow.FACD_CANTIDAD) + (parseFloat(dblCantidad) * lstRow.FACD_MULTIPLO);
                grid.setRowData(id, lstRow);
            }
        } else {
            if (idPaqueteM == id) {
                bolEncontro = true;
            }
        }
    }
}
/**Vuelva a calcular el precio para una fila del grid*/
function lstRowChangePrecio(lstRow, idUpdate, grid, bolSum) {
    var objImportes = new _ImporteVta();
    objImportes.dblCantidad = parseFloat(lstRow.FACD_CANTIDAD);
    objImportes.dblPrecio = parseFloat(lstRow.FACD_PRECIO);
    objImportes.dblPrecioReal = parseFloat(lstRow.FACD_PRECREAL);
    objImportes.dblPuntos = parseFloat(lstRow.FACD_PUNTOS_U);
    objImportes.dblVNegocio = parseFloat(lstRow.FACD_NEGOCIO_U);
    objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
    objImportes.dblPorcDesc = lstRow.FACD_PORDESC;
    objImportes.dblPrecFijo = lstRow.FACD_PRECFIJO;
    objImportes.dblExento1 = lstRow.FACD_EXENTO1;
    objImportes.dblExento2 = lstRow.FACD_EXENTO2;
    objImportes.dblExento3 = lstRow.FACD_EXENTO3;
    objImportes.intDevo = lstRow.FACD_ESDEVO;
    objImportes.intPrecioZeros = lstRow.FACD_SINPRECIO;
    if (lstRow.FACD_DESC_PREC == 0)
        objImportes.bolAplicDescPrec = false;
    if (lstRow.FACD_DESC_PTO == 0)
        objImportes.bolAplicDescPto = false;
    if (lstRow.FACD_DESC_VN == 0)
        objImportes.bolAplicDescVNego = false;
    //if(lstRow.FACD_DESC_LEAL == 0)objImportes.bolAplicDescPrec= false;
    //Evaluamos si aplican los puntos y valor negocio de multinivel
    var bolAplicaMLM = true;
    if (document.getElementById("FAC_ES_MLM1") != null && document.getElementById("FAC_ES_MLM2") != null) {
        if (document.getElementById("FAC_ES_MLM2").checked)
            bolAplicaMLM = false;
    }
    objImportes.bolUsoMLM = bolAplicaMLM;
    //Evaluamos si aplican los puntos y valor negocio de multinivel
    objImportes.CalculaImporte();
    //Asignamos nuevos importes
    lstRow.FACD_IMPORTE = objImportes.dblImporte;
    lstRow.FACD_IMPUESTO1 = objImportes.dblImpuesto1;
    lstRow.FACD_IMPUESTO2 = objImportes.dblImpuesto2;
    lstRow.FACD_IMPUESTO3 = objImportes.dblImpuesto3;
    //lstRow.FACD_PORDESC =objImportes.dblPorcAplica;
    lstRow.FACD_DESCUENTO = objImportes.dblImporteDescuento;
    lstRow.FACD_IMPORTEREAL = objImportes.dblImporteReal;
    lstRow.FACD_PUNTOS = objImportes.dblPuntosImporte;
    lstRow.FACD_NEGOCIO = objImportes.dblVNegocioImporte;
    if (lstRow.FACD_NEGO_ZERO == 1)
        lstRow.FACD_NEGOCIO = 0;
    //Actualizamos el grid
    grid.setRowData(idUpdate, lstRow);
    //Sumamos todos los items
    if (bolSum == null)
        bolSum = true;
    if (bolSum)
        setSum();
}
/**Añade una nueva partida al GRID*/
function AddItemPrec(objProd, Pr_Id, Ct_Id, Cantidad, strCod, dblExist, intDevo, strSeries) {
    if (strSeries == null)
        strSeries = "";
    //Consultamos el precio del producto
    $.ajax({
        type: "POST",
        data: "PR_ID=" + Pr_Id + "&CT_LPRECIOS=" + document.getElementById("FCT_LPRECIOS").value +
                "&CANTIDAD=" + Cantidad + "&FAC_MONEDA=" + document.getElementById("FAC_MONEDA").value +
                "&CT_TIPO_CAMBIO=" + document.getElementById("FAC_TTC_ID").value,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "DamePrecio.do?id=4",
        success: function (datoPrec) {
            var bolFind = false;
            //Procesamos el XML y lo anadimos al GRID
            var lstXml = datoPrec.getElementsByTagName("Precios")[0];
            var lstprecio = lstXml.getElementsByTagName("Precio");
            for (var i = 0; i < lstprecio.length; i++) {
                var obj2 = lstprecio[i];
                var objImportes = new _ImporteVta();
                objImportes.dblCantidad = Cantidad;
                //Aqui hacemos las validaciones o conversiones dependiendo de la moneda
                var dblPrecio = obj2.getAttribute('precioUsar');
                objImportes.dblPuntos = parseFloat(obj2.getAttribute('puntos'));
                objImportes.dblVNegocio = parseFloat(obj2.getAttribute('negocio'));
                objImportes.dblPrecio = parseFloat(dblPrecio);
                objImportes.dblPrecioReal = parseFloat(dblPrecio);
                objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
                objImportes.dblExento1 = objProd.getAttribute('PR_EXENTO1');
                objImportes.dblExento2 = objProd.getAttribute('PR_EXENTO2');
                objImportes.dblExento3 = objProd.getAttribute('PR_EXENTO3');
                objImportes.intDevo = intDevo;

                if (parseInt(obj2.getAttribute('descuento')) == 0)
                    objImportes.bolAplicDescPrec = false;
                if (parseInt(obj2.getAttribute('desc_pto')) == 0)
                    objImportes.bolAplicDescPto = false;
                if (parseInt(obj2.getAttribute('desc_nego')) == 0)
                    objImportes.bolAplicDescVNego = false;
                //if(lstRow.FACD_DESC_LEAL == 0)objImportes.bolAplicDescPrec= false;
                //Evaluamos si aplican los puntos y valor negocio de multinivel
                var bolAplicaMLM = true;
                if (document.getElementById("FAC_ES_MLM1") != null && document.getElementById("FAC_ES_MLM2") != null) {
                    if (document.getElementById("FAC_ES_MLM2").checked)
                        bolAplicaMLM = false;
                }
                objImportes.bolUsoMLM = bolAplicaMLM;
                //Evaluamos si aplican los puntos y valor negocio de multinivel
                objImportes.CalculaImporte();
                var dblDescuento = objImportes.dblImporteDescuento;
                var dblImporte = objImportes.dblImporte;
                var datarow = {
                    FACD_ID: 0,
                    FACD_CANTIDAD: Cantidad,
                    FACD_DESCRIPCION: objProd.getAttribute('PR_DESCRIPCION'),
                    FACD_IMPORTE: dblImporte,
                    FACD_CVE: strCod,
                    FACD_PRECIO: dblPrecio,
                    FACD_TASAIVA1: dblTasaVta1,
                    FACD_TASAIVA2: dblTasaVta2,
                    FACD_TASAIVA3: dblTasaVta3,
                    FACD_DESGLOSA1: 1,
                    FACD_IMPUESTO1: objImportes.dblImpuesto1,
                    FACD_IMPUESTO2: objImportes.dblImpuesto2,
                    FACD_IMPUESTO3: objImportes.dblImpuesto3,
                    FACD_PR_ID: Pr_Id,
                    FACD_EXENTO1: objProd.getAttribute('PR_EXENTO1'),
                    FACD_EXENTO2: objProd.getAttribute('PR_EXENTO2'),
                    FACD_EXENTO3: objProd.getAttribute('PR_EXENTO3'),
                    FACD_REQEXIST: objProd.getAttribute('PR_REQEXIST'),
                    FACD_EXIST: dblExist,
                    FACD_NOSERIE: strSeries,
                    FACD_ESREGALO: 0,
                    FACD_IMPORTEREAL: dblImporte,
                    FACD_PRECREAL: dblPrecio,
                    FACD_DESCUENTO: dblDescuento,
                    FACD_PORDESC: objImportes.dblPorcAplica,
                    FACD_PRECFIJO: 0,
                    FACD_ESDEVO: intDevo,
                    FACD_CODBARRAS: objProd.getAttribute('PR_CODBARRAS'),
                    FACD_NOTAS: "",
                    FACD_RET_ISR: intRET_ISR,
                    FACD_RET_IVA: intRET_IVA,
                    FACD_RET_FLETE: intRET_FLETE,
                    FACD_UNIDAD_MEDIDA: objProd.getAttribute('PR_UNIDADMEDIDA'),
                    FACD_PUNTOS_U: objImportes.dblPuntos,
                    FACD_NEGOCIO_U: objImportes.dblVNegocio,
                    FACD_PUNTOS: objImportes.dblPuntosImporte,
                    FACD_NEGOCIO: objImportes.dblVNegocioImporte,
                    FACD_PR_CAT1: objProd.getAttribute('PR_CAT1'),
                    FACD_PR_CAT2: objProd.getAttribute('PR_CAT2'),
                    FACD_PR_CAT3: objProd.getAttribute('PR_CAT3'),
                    FACD_PR_CAT4: objProd.getAttribute('PR_CAT4'),
                    FACD_PR_CAT5: objProd.getAttribute('PR_CAT5'),
                    FACD_PR_CAT6: objProd.getAttribute('PR_CAT6'),
                    FACD_PR_CAT7: objProd.getAttribute('PR_CAT7'),
                    FACD_PR_CAT8: objProd.getAttribute('PR_CAT8'),
                    FACD_PR_CAT9: objProd.getAttribute('PR_CAT9'),
                    FACD_PR_CAT10: objProd.getAttribute('PR_CAT10'),
                    FACD_DESC_ORI: 0,
                    FACD_REGALO: 0,
                    FACD_ID_PROMO: 0,
                    FACD_DESC_PREC: parseInt(obj2.getAttribute('descuento')),
                    FACD_DESC_PTO: parseInt(obj2.getAttribute('desc_pto')),
                    FACD_DESC_VN: parseInt(obj2.getAttribute('desc_nego')),
                    FACD_DESC_LEAL: parseInt(obj2.getAttribute('desc_nego')),
                    FACD_USA_SERIE: objProd.getAttribute('PR_USO_NOSERIE'),
                    FACD_SERIES: strSeries,
                    FACD_SERIES_MPD: "",
                    FACD_SERIES_O: "",
                    FACD_SERIES_MPD_O: "",
                    FACD_ES_PAQUETE: objProd.getAttribute('PR_ESKIT'),
                    FACD_ES_COMPONENTE: 0,
                    FACD_PR_PAQUETE: 0,
                    FACD_MULTIPLO: 0
                };
                //Anexamos el registro al GRID
                itemId++;
                jQuery("#FAC_GRID").addRowData(itemId, datarow, "last");

                //si es kit anadimos los componentes([p])
                if (objProd.getAttribute('PR_ESKIT') == 1) {
                    var lstComponente = objProd.getElementsByTagName("vta_componentes");
                    for (var f = 0; f < lstComponente.length; f++) {
                        var objComp = lstComponente[f];
                        var dblCantidadPq = parseFloat(Cantidad) * objComp.getAttribute('PAQ_CANTIDAD');
                        var datarow = {
                            FACD_ID: 0,
                            FACD_CANTIDAD: dblCantidadPq,
                            FACD_DESCRIPCION: "[p]" + objComp.getAttribute('PR_DESCRIPCION'),
                            FACD_IMPORTE: 0,
                            FACD_CVE: objComp.getAttribute('PR_CODIGO'),
                            FACD_PRECIO: 0,
                            FACD_TASAIVA1: 0,
                            FACD_TASAIVA2: 0,
                            FACD_TASAIVA3: 0,
                            FACD_DESGLOSA1: 1,
                            FACD_IMPUESTO1: 0,
                            FACD_IMPUESTO2: 0,
                            FACD_IMPUESTO3: 0,
                            FACD_PR_ID: objComp.getAttribute('PR_ID'),
                            FACD_EXENTO1: objComp.getAttribute('PR_EXENTO1'),
                            FACD_EXENTO2: objComp.getAttribute('PR_EXENTO2'),
                            FACD_EXENTO3: objComp.getAttribute('PR_EXENTO3'),
                            FACD_REQEXIST: objComp.getAttribute('PR_REQEXIST'),
                            FACD_EXIST: objComp.getAttribute('PR_EXISTENCIA'),
                            FACD_NOSERIE: "",
                            FACD_ESREGALO: 0,
                            FACD_IMPORTEREAL: 0,
                            FACD_PRECREAL: 0,
                            FACD_DESCUENTO: 0,
                            FACD_PORDESC: 0,
                            FACD_PRECFIJO: 0,
                            FACD_ESDEVO: 0,
                            FACD_CODBARRAS: objComp.getAttribute('PR_CODBARRAS'),
                            FACD_NOTAS: "",
                            FACD_RET_ISR: 0,
                            FACD_RET_IVA: 0,
                            FACD_RET_FLETE: 0,
                            FACD_UNIDAD_MEDIDA: objComp.getAttribute('PR_UNIDADMEDIDA'),
                            FACD_PUNTOS_U: 0,
                            FACD_NEGOCIO_U: 0,
                            FACD_PUNTOS: 0,
                            FACD_NEGOCIO: 0,
                            FACD_PR_CAT1: objComp.getAttribute('PR_CAT1'),
                            FACD_PR_CAT2: objComp.getAttribute('PR_CAT2'),
                            FACD_PR_CAT3: objComp.getAttribute('PR_CAT3'),
                            FACD_PR_CAT4: objComp.getAttribute('PR_CAT4'),
                            FACD_PR_CAT5: objComp.getAttribute('PR_CAT5'),
                            FACD_PR_CAT6: objComp.getAttribute('PR_CAT6'),
                            FACD_PR_CAT7: objComp.getAttribute('PR_CAT7'),
                            FACD_PR_CAT8: objComp.getAttribute('PR_CAT8'),
                            FACD_PR_CAT9: objComp.getAttribute('PR_CAT9'),
                            FACD_PR_CAT10: objComp.getAttribute('PR_CAT10'),
                            FACD_DESC_ORI: 0,
                            FACD_REGALO: 0,
                            FACD_ID_PROMO: 0,
                            FACD_DESC_PREC: 0,
                            FACD_DESC_PTO: 0,
                            FACD_DESC_VN: 0,
                            FACD_DESC_LEAL: 0,
                            FACD_USA_SERIE: objComp.getAttribute('PR_USO_NOSERIE'),
                            FACD_SERIES: "",
                            FACD_SERIES_MPD: "",
                            FACD_SERIES_O: "",
                            FACD_SERIES_MPD_O: "",
                            FACD_ES_PAQUETE: 0,
                            FACD_ES_COMPONENTE: 1,
                            FACD_PR_PAQUETE: Pr_Id,
                            FACD_MULTIPLO: objComp.getAttribute('PAQ_CANTIDAD')
                        };
                        //Anexamos el registro al GRID
                        itemId++;
                        jQuery("#FAC_GRID").addRowData(itemId, datarow, "last");
                    }
                }

                d.getElementById("FAC_PRECIO").value = dblPrecio;
                d.getElementById("FAC_PROD").value = "";
                d.getElementById("FAC_PROD").focus();
                d.getElementById("FAC_CANT").value = 1;
                d.getElementById("FAC_DEVO").value = 0;
                bolFind = true;
                if (intSucOfertas && bolCargaPromociones)
                    _LimpiaRegalosPromos(jQuery("#FAC_GRID"));
                //Sumamos todos los items
                _PromocionProd(itemId);
                //Validamos el cambio de sucursal
                EvalSucursal();
            }
            //Validamos si no nos devolvieron precio es porque el CLIENTE no existe
            if (!bolFind) {
                ObtenNomCte();
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto4:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**Borra el item seleccionado*/
function VtaDrop() {
    var grid = jQuery("#FAC_GRID");
    var _idDelVta = grid.getGridParam("selrow");
    if (_idDelVta != null) {
        var lstRow = grid.getRowData(_idDelVta);
        if (lstRow.FACD_ES_COMPONENTE == 1) {
            alert("El item no se puede borrar porque es un componente de un paquete");
        } else {
            if (lstRow.FACD_ES_PAQUETE == 1) {
                //Borramos las partidas
                borraComponentesPaquete(grid, _idDelVta);
            }
            grid.delRowData(_idDelVta);
            document.getElementById("FAC_PROD").focus();
            //Sumamos todos los items
            setSum();
            //Validamos el cambio de sucursal
            EvalSucursal();
        }
    }
}
//Actualiza la cantidad de los componentes del paquete([p])
function borraComponentesPaquete(grid, idPaqueteM) {
    var arr = grid.getDataIDs();
    var bolEncontro = false;
    for (var y = 0; y < arr.length; y++) {
        var id = arr[y];
        //Aplica en caso de que encontremos el paquete maestro
        if (bolEncontro) {
            var lstRow = grid.getRowData(id);
            if (lstRow.FACD_ES_COMPONENTE == 0) {
                break;
            } else {
                //Borramos partida
                grid.delRowData(id);
            }
        } else {
            if (idPaqueteM == id) {
                bolEncontro = true;
            }
        }
    }
}
/*Suma todos los items de la venta y nos da el total**/
function setSum(bolPromos) {
    var grid = jQuery("#FAC_GRID");
    //Limpiamos el grid de los regalos antes del calculo del nuevo 

    var arr = grid.getDataIDs();
    var dblSuma = 0;
    var dblImpuesto1 = 0;
    var dblImpuesto2 = 0;
    var dblImpuesto3 = 0;
    var dblImporte = 0;
    var dblImporteDesc = 0;
    var dblImportePto = 0;
    var dblImporteVn = 0;
    var dblImporteReal = 0;
    var dblImportePzas = 0;
    var dblImportePtoReal = 0;
    var dblImporteNegoReal = 0;
    var dblImporteCredReal = 0;
    var dblImporteImpuesto1Real = 0;
    var dblImporteImpuesto2Real = 0;
    var dblImporteImpuesto3Real = 0;
    for (var i = 0; i < arr.length; i++) {
        var id = arr[i];
        var lstRow = grid.getRowData(id);
        dblSuma += parseFloat(lstRow.FACD_IMPORTE);
        dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO1);
        dblImpuesto2 += parseFloat(lstRow.FACD_IMPUESTO2);
        dblImpuesto3 += parseFloat(lstRow.FACD_IMPUESTO3);
        dblImporte += (parseFloat(lstRow.FACD_IMPORTE) - parseFloat(lstRow.FACD_IMPUESTO1) - parseFloat(lstRow.FACD_IMPUESTO2) - parseFloat(lstRow.FACD_IMPUESTO3));
        dblImporteDesc += parseFloat(lstRow.FACD_DESCUENTO);
        dblImportePto += parseFloat(lstRow.FACD_PUNTOS);
        dblImporteVn += parseFloat(lstRow.FACD_NEGOCIO);
        //Calculo de totales adicionales utiles para las promociones
        dblImportePzas += parseFloat(lstRow.FACD_CANTIDAD);
        dblImportePtoReal += parseFloat(lstRow.FACD_CANTIDAD) * parseFloat(lstRow.FACD_PUNTOS_U);
        dblImporteNegoReal += parseFloat(lstRow.FACD_CANTIDAD) * parseFloat(lstRow.FACD_NEGOCIO_U);
        dblImporteCredReal += parseFloat(lstRow.FACD_CANTIDAD) * 1;
        //Calculo de totales reales
        var dblTotlImpReal = parseFloat(lstRow.FACD_CANTIDAD) * parseFloat(lstRow.FACD_PRECREAL);
        var dblBase1 = dblTotlImpReal;
        var dblBase2 = dblTotlImpReal;
        var dblBase3 = dblTotlImpReal;
        if (parseInt(lstRow.FACD_EXENTO1) == 1)
            dblBase1 = 0;
        if (parseInt(lstRow.FACD_EXENTO2) == 1)
            dblBase2 = 0;
        if (parseInt(lstRow.FACD_EXENTO3) == 1)
            dblBase3 = 0;
        var taxReal = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
        //Validamos si los precios incluyen impuestos
        if (intPreciosconImp == 1) {
            taxReal.CalculaImpuesto(dblBase1, dblBase2, dblBase3);
        } else {
            taxReal.CalculaImpuestoMas(dblBase1, dblBase2, dblBase3);
        }
        if (parseInt(lstRow.FACD_EXENTO1) == 0)
            dblImporteImpuesto1Real = taxReal.dblImpuesto1;
        if (parseInt(lstRow.FACD_EXENTO2) == 0)
            dblImporteImpuesto2Real = taxReal.dblImpuesto2;
        if (parseInt(lstRow.FACD_EXENTO3) == 0)
            dblImporteImpuesto3Real = taxReal.dblImpuesto3;
        if (intPreciosconImp == 1) {
            dblImporteReal += dblTotlImpReal - dblImporteImpuesto1Real - dblImporteImpuesto2Real - dblImporteImpuesto3Real;
        } else {
            dblImporteReal += dblTotlImpReal;
        }
        //Calculo de totales adicionales utiles para las promociones
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
        var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
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
    d.getElementById("FAC_DESCUENTO").value = FormatNumber(dblImporteDesc, intNumdecimal, true);
    //MLM
    d.getElementById("FAC_PUNTOS").value = FormatNumber(dblImportePto, intNumdecimal, true);
    d.getElementById("FAC_NEGOCIO").value = FormatNumber(dblImporteVn, intNumdecimal, true);
    d.getElementById("FAC_IMPORTE_REAL").value = FormatNumber(dblImporteReal, intNumdecimal, true);
    d.getElementById("FAC_PZAS").value = FormatNumber(dblImportePzas, intNumdecimal, true);
    d.getElementById("FAC_PUNTOS_REAL").value = FormatNumber(dblImportePtoReal, intNumdecimal, true);
    d.getElementById("FAC_NEGOCIO_REAL").value = FormatNumber(dblImporteNegoReal, intNumdecimal, true);
    d.getElementById("FAC_CREDITOS_REAL").value = FormatNumber(dblImporteCredReal, intNumdecimal, true);
    d.getElementById("FAC_IMPUESTO1_REAL").value = FormatNumber(dblImporteImpuesto1Real, intNumdecimal, true);
    d.getElementById("FAC_IMPUESTO2_REAL").value = FormatNumber(dblImporteImpuesto2Real, intNumdecimal, true);
    d.getElementById("FAC_IMPUESTO3_REAL").value = FormatNumber(dblImporteImpuesto3Real, intNumdecimal, true);
    //MLM
    //Activamos recibos de honorarios si proceden SOLO EN CASO DE FACTURAS
    if (parseInt(intEMP_TIPOPERS) == 2
            && parseInt(d.getElementById("FAC_TIPO").value) == 1) {
        if (intCT_TIPOPERS == 1) {
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
            document.getElementById("FAC_RETISR").value = FormatNumber(0, intNumdecimal, true);
            document.getElementById("FAC_RETIVA").value = FormatNumber(0, intNumdecimal, true);
            document.getElementById("FAC_NETO").value = FormatNumber(dblSuma, intNumdecimal, true);
        }

    } else {
        //Activamos los recibos de honorarios
        document.getElementById("FAC_RETISR").parentNode.parentNode.style.display = 'none';
        document.getElementById("FAC_RETIVA").parentNode.parentNode.style.display = 'none';
        document.getElementById("FAC_NETO").parentNode.parentNode.style.display = 'none';
    }
    if (bolPromos == null)
        bolPromos = true;
    //Promociones
    _PromocionTot(bolPromos);
}
/**Obtiene la lista de items de la factura para enviarlos al jsp de las promociones*/
function getLstItems() {

}
/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagCte() {
    bolUsaOpnCte = true;
    OpnOpt('CLIENTES', 'grid', 'dialogCte', false, false);
}
/**Abre el cuadro de dialogo para buscar vendedor o dar de alta uno nuevo*/
function OpnDiagVend() {
    OpnOpt('VENDEDOR', 'grid', 'dialogVend', false, false);
}
/**Abre el cuadro de dialogo para buscar productos o dar de alta uno nuevo*/
function OpnDiagProd() {
    OpnOpt('PROD', 'grid', 'dialogProd', false, false);
}
/**Realizar la operacion de guardado de la venta mostrando primero la pantalla de pago*/
function SaveVta() {
    var bolPasa = true;
    //Validamos si el total es igual a cero
    /*if(parseFloat(document.getElementById("FAC_TOT").value)== 0){
     alert(lstMsg[56]);
     bolPasa =false;
     }else{
     */
    if (d.getElementById("TOTALXPAGAR") != null) {
        if (parseInt(intEMP_TIPOPERS) == 2 && intCT_TIPOPERS == 1
                && parseInt(d.getElementById("FAC_TIPO").value) == 1) {
            d.getElementById("TOTALXPAGAR").value = d.getElementById("FAC_NETO").value;
        } else {
            d.getElementById("TOTALXPAGAR").value = d.getElementById("FAC_TOT").value;
        }
    }
    //Validamos ADDENDA MABE
    if (d.getElementById("ADD_MABE") != null) {
        if (d.getElementById("ADD_MABE").value != undefined) {
            if (d.getElementById("ADD_MABE").value != 0) {
                if (d.getElementById("USA_MABE1").checked) {
                    //Validamos campos
                    if (!ValidaMABE()) {
                        alert(lstMsg[63]);
                        bolPasa = false;
                    }
                }
            }
        }
    }
//    Validamos ADDENDA AMECE
    if (d.getElementById("ADD_AMECE") != null) {
        if (d.getElementById("ADD_AMECE").value != undefined) {
            if (d.getElementById("ADD_AMECE").value != 0) {
                if (d.getElementById("USA_AMECE1").checked) {
                    //Validamos campos
                    if (!ValidaAMECE()) {
                        alert(lstMsg[155]);
                        bolPasa = false;
                    }
                }
            }
        }
    }

    //Validamos ADDENDA SANOFI ORDEN DE COMPRA
    if (document.getElementById("ADD_SANOFI") != null) {
        if (document.getElementById("ADD_SANOFI").value != undefined) {
            if (document.getElementById("ADD_SANOFI").value != 0) {
                if (document.getElementById("USA_SANOFI1").checked) {
                    //Validamos campos
                    if (!ValidaSANOFI()) {//HACER MÉTODO QUE VALIDE CAMPOS SANOFI
                        alert(lstMsg[153]);
                        bolPasa = false;
                    }
                }
            }
        }
    }

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
        //Validamos el tipo de venta
        if (document.getElementById("FAC_TIPO").value != "3" && document.getElementById("FAC_TIPO").value != "5") {
            if (parseFloat(document.getElementById("FAC_TOT").value) == 0) {
                var aRespC = confirm(lstMsg[184]);
                if (aRespC)
                    SaveVtaDo();
            } else {
                //Evaluamos si los dias de credito son mayores a cero
                if (parseFloat(document.getElementById("FAC_DIASCREDITO").value) == 0) {
                    OpnOpt('FORMPAGO', '_ed', 'dialogPagos', false, false);
                    var objMainFacPedi = objMap.getScreen("FORMPAGO");
                    objMainFacPedi.bolActivo = false;
                    objMainFacPedi.bolMain = false;
                    objMainFacPedi.bolInit = false;
                    objMainFacPedi.idOperAct = 0;

                } else {
                    SaveVtaDo();
                }
            }
        } else {
            SaveVtaDo();
        }
    }
//}
}
/**Guarda la venta*/
function SaveVtaDo() {
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
    if (d.getElementById("FAC_TIPO").value == "5") {
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
    strPOST += "&COT_ID=" + d.getElementById("COT_ID").value;
    strPOST += "&" + strPrefijoMaster + "_ESSERV=0";
    strPOST += "&" + strPrefijoMaster + "_MONEDA=" + d.getElementById("FAC_MONEDA").value;
    strPOST += "&" + strPrefijoMaster + "_FECHA=" + d.getElementById("FAC_FECHA").value;
    //19/06/2013
    //Zeus Galindo


    //Obtenemos la categoria del cliente si existe

    if (d.getElementById("CC1_ID") != null) {
        strPOST += "&CC1_ID=" + d.getElementById("CC1_ID").value;
    }

    //Evaluamos si es la modificación de un pedido para mantener el folio
    if (d.getElementById("FAC_TIPO").value == "3") {
        if (parseFloat(d.getElementById("PD_ID").value) > 0) {
            strPOST += "&" + strPrefijoMaster + "_FOLIO=" + d.getElementById("FAC_FOLIO").value;
        } else {
            strPOST += "&" + strPrefijoMaster + "_FOLIO=" /*+ d.getElementById("FAC_FOLIO").value*/;
        }
    } else {
        strPOST += "&" + strPrefijoMaster + "_FOLIO=" /*+ d.getElementById("FAC_FOLIO").value*/;
    }
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
    strPOST += "&" + strPrefijoMaster + "_TASA1=" + dblTasaVta1;
    strPOST += "&" + strPrefijoMaster + "_TASA2=" + dblTasaVta2;
    strPOST += "&" + strPrefijoMaster + "_TASA3=" + dblTasaVta3;
    strPOST += "&" + "TI_ID=" + intIdTasaVta1;
    strPOST += "&" + "TI_ID2=" + intIdTasaVta2;
    strPOST += "&" + "TI_ID3=" + intIdTasaVta3;
    strPOST += "&" + strPrefijoMaster + "_TASAPESO=" + d.getElementById("FAC_TASAPESO").value;
    strPOST += "&" + strPrefijoMaster + "_DIASCREDITO=" + d.getElementById("FAC_DIASCREDITO").value;
    strPOST += "&" + strPrefijoMaster + "_POR_DESC=" + d.getElementById("FCT_DESCUENTO").value;

    //TRASPORTE Y FLETE
    strPOST += "&TR_ID=" + d.getElementById("TR_ID").value;
    strPOST += "&ME_ID=" + d.getElementById("ME_ID").value;
    strPOST += "&TF_ID=" + d.getElementById("TF_ID").value;
    if (d.getElementById("CT_DIRENTREGA") != null) {
        strPOST += "&CDE_ID=" + d.getElementById("CT_DIRENTREGA").value;
    }
    if (d.getElementById("CT_CLIENTEFINAL") != null) {
        strPOST += "&DFA_ID=" + d.getElementById("CT_CLIENTEFINAL").value;
    }
    if (d.getElementById("SYC_ID") != null) {
        strPOST += "&SYC_ID=" + d.getElementById("SYC_ID").value;
    }
    if (document.getElementById("FAC_SERIE") != null) {
        strPOST += "&" + strPrefijoMaster + "_SERIE=" + d.getElementById("FAC_SERIE").value;
    }
    strPOST += "&" + strPrefijoMaster + "_NUM_GUIA=" + d.getElementById("FAC_NUM_GUIA").value;


    //MLM
    strPOST += "&" + strPrefijoMaster + "_PUNTOS=" + d.getElementById("FAC_PUNTOS").value;
    strPOST += "&" + strPrefijoMaster + "_NEGOCIO=" + d.getElementById("FAC_NEGOCIO").value;
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
    //Validamos _CONSIGNACION
    if (document.getElementById("FAC_CONSIGNACION1") != null) {
        if (document.getElementById("FAC_CONSIGNACION1").checked) {
            strPOST += "&" + strPrefijoMaster + "_CONSIGNACION=1";
        } else {
            strPOST += "&" + strPrefijoMaster + "_CONSIGNACION=0";
        }
    } else {
        strPOST += "&" + strPrefijoMaster + "_CONSIGNACION=0";
    }
    //Agregamos campos ADDENDA MABE
    if (d.getElementById("ADD_MABE").value != undefined) {
        if (d.getElementById("ADD_MABE").value != 0) {
            if (d.getElementById("USA_MABE1").checked) {
                strPOST += "&ADD_MABE=1";
                strPOST += "&MB_CODIGOPROVEEDOR=" + d.getElementById("MB_CODIGOPROVEEDOR").value;
                strPOST += "&MB_PLANTA=" + d.getElementById("MB_PLANTA").value;
                strPOST += "&MB_CALLE=" + d.getElementById("MB_CALLE").value;
                strPOST += "&MB_NO_EXT=" + d.getElementById("MB_NO_EXT").value;
                strPOST += "&MB_NO_INT=" + d.getElementById("MB_NO_INT").value;
                strPOST += "&MB_ORDENCOMPRA=" + d.getElementById("MB_ORDENCOMPRA").value;
                strPOST += "&MB_REFERENCIA1=" + d.getElementById("MB_REFERENCIA1").value;
            }
        }
    } else {
        strPOST += "&ADD_MABE=0";
    }

    //emails
    if (d.getElementById("ADD_EMAIL") != undefined) {
        if (d.getElementById("ADD_EMAIL") != null) {
            if (d.getElementById("ADD_EMAIL").value != 0) {
                strPOST += "&ADD_EMAIL=1";
                strPOST += "&FAC_EMAIL1=" + d.getElementById("FAC_EMAIL11").checked;
                strPOST += "&FAC_EMAIL2=" + d.getElementById("FAC_EMAIL21").checked;
                strPOST += "&FAC_EMAIL3=" + d.getElementById("FAC_EMAIL31").checked;
                strPOST += "&FAC_EMAIL4=" + d.getElementById("FAC_EMAIL41").checked;
                strPOST += "&FAC_EMAIL5=" + d.getElementById("FAC_EMAIL51").checked;
                strPOST += "&FAC_EMAIL6=" + d.getElementById("FAC_EMAIL61").checked;
                strPOST += "&FAC_EMAIL7=" + d.getElementById("FAC_EMAIL71").checked;
                strPOST += "&FAC_EMAIL8=" + d.getElementById("FAC_EMAIL81").checked;
                strPOST += "&FAC_EMAIL9=" + d.getElementById("FAC_EMAIL91").checked;
                strPOST += "&FAC_EMAIL10=" + d.getElementById("FAC_EMAIL101").checked;
            }
        }
    } else {
        strPOST += "&ADD_EMAIL=0";
    }

    //emails

    //Agregamos campos ADDENDA USO FLETE
    if (d.getElementById("FAC_USO_FLETE") != undefined) {
        if (d.getElementById("FAC_USO_FLETE") != null) {
            if (d.getElementById("FAC_USO_FLETE").value != 0) {
                strPOST += "&FAC_USO_FLETE=1";
                strPOST += "&FAC_FLETE_PESO=" + d.getElementById("FAC_FLETE_PESO").value;
                strPOST += "&FAC_FLETE_VOLUMEN=" + d.getElementById("FAC_FLETE_VOLUMEN").value;
                strPOST += "&FAC_FLETE_NUM_PEDIMENTO=" + d.getElementById("FAC_FLETE_NUM_PEDIMENTO").value;
                strPOST += "&FAC_FLETE_INDEMNIZACION=" + d.getElementById("FAC_FLETE_INDEMNIZACION").value;
                strPOST += "&FAC_FLETE_REMBARCO=" + d.getElementById("FAC_FLETE_REMBARCO").value;
                strPOST += "&FAC_FLETE_FEC_PEDIMENTO=" + d.getElementById("FAC_FLETE_FEC_PEDIMENTO").value;
                strPOST += "&FAC_FLETE_REEMBARCARSE=" + d.getElementById("FAC_FLETE_REEMBARCARSE").value;
                strPOST += "&FAC_FLETE_CARTA_NUMPORTE=" + d.getElementById("FAC_FLETE_CARTA_NUMPORTE").value;
                strPOST += "&FAC_FLETE_CAMION_NUMPLACAS=" + d.getElementById("FAC_FLETE_CAMION_NUMPLACAS").value;
                strPOST += "&FAC_FLETE_CLIENTE_RETENEDOR=" + d.getElementById("FAC_FLETE_CLIENTE_RETENEDOR").value;
                strPOST += "&FAC_FLETE_DOMICILIO=" + d.getElementById("FAC_FLETE_DOMICILIO").value;
                strPOST += "&FAC_FLETE_RFC=" + d.getElementById("FAC_FLETE_RFC").value;
                strPOST += "&FAC_FLETE_ENTREGA_EN=" + d.getElementById("FAC_FLETE_ENTREGA_EN").value;
                strPOST += "&FAC_FLETE_FEC_PREV_ENTREGA=" + d.getElementById("FAC_FLETE_FEC_PREV_ENTREGA").value;
                strPOST += "&FAC_FLETE_OPERADOR=" + d.getElementById("FAC_FLETE_OPERADOR").value;
            }
        }
    } else {
        strPOST += "&ADD_USO_FLETE=0";
    }
    //USO FLETE

    //Agregamos campos ADDENDA SANOFI ORDEN DE COMPRA
    if (d.getElementById("ADD_SANOFI") != null) {
        if (d.getElementById("ADD_SANOFI").value != undefined) {
            if (d.getElementById("ADD_SANOFI").value != 0) {
                if (d.getElementById("USA_SANOFI1").checked) {
                    if (d.getElementById("SNF_ODC_SP1").checked) {
                        strPOST += "&ADD_SANOFI=1";
                        strPOST += "&USA_SANOFI1=1";
                        strPOST += "&SNF_NUM_PROV=" + d.getElementById("SNF_NUM_PROV").value;
                        strPOST += "&SNF_NUM_ODC=" + d.getElementById("SNF_NUM_ODC").value;
                        strPOST += "&SNF_NUM_SOL=" + d.getElementById("SNF_NUM_SOL").value;
                    }
                    if (d.getElementById("SNF_ODC_SP2").checked) {
                        strPOST += "&ADD_SANOFI=1";
                        strPOST += "&USA_SANOFI2=1";
                        strPOST += "&SNF_NUM_PROV=" + d.getElementById("SNF_NUM_PROV").value;
                        strPOST += "&SNF_NUM_SOL=" + d.getElementById("SNF_NUM_SOL").value;
                        strPOST += "&SNF_CUENTA_PUENTE=" + d.getElementById("SNF_CUENTA_PUENTE").value;
                    }
                }
            }
        } else {
            strPOST += "&ADD_SANOFI=0";
        }
    } else {
        strPOST += "&ADD_SANOFI=0";
    }


    //Agregamos campos ADDENDA AMECE
    if (d.getElementById("ADD_AMECE") != null) {
        if (d.getElementById("ADD_AMECE").value != undefined) {
            if (d.getElementById("ADD_AMECE").value != 0) {
                if (d.getElementById("USA_AMECE1").checked) {
                    strPOST += "&ADD_AMECE=1";
                    strPOST += "&HM_DIV=" + d.getElementById("HM_DIV").value;
                    strPOST += "&HM_SOC=" + d.getElementById("HM_SOC").value;
                    strPOST += "&HM_ON=" + d.getElementById("HM_ON").value;
                    strPOST += "&HM_REFERENCEDATE=" + d.getElementById("HM_REFERENCEDATE").value;
                    strPOST += "&HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY=" + d.getElementById("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY").value;
                    strPOST += "&HM_NAME=" + d.getElementById("HM_NAME").value;
                    strPOST += "&HM_STREET=" + d.getElementById("HM_STREET").value;
                    strPOST += "&HM_CITY=" + d.getElementById("HM_CITY").value;
                    strPOST += "&HM_POSTALCODE=" + d.getElementById("HM_POSTALCODE").value;
                }
            }
        } else {
            strPOST += "&ADD_AMECE=0";
        }
    } else {
        strPOST += "&ADD_AMECE=0";
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
    //Recurrentes
    if (d.getElementById("FAC_ESRECU1").checked) {
        strPOST += "&" + strPrefijoMaster + "_ESRECU=1";
    } else {
        strPOST += "&" + strPrefijoMaster + "_ESRECU=0";
    }
    strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD=" + d.getElementById("FAC_PERIODICIDAD").value;
    strPOST += "&" + strPrefijoMaster + "_DIAPER=" + d.getElementById("FAC_DIAPER").value;
    strPOST += "&" + strPrefijoMaster + "_NO_EVENTOS=" + d.getElementById("FAC_NO_EVENTOS").value;
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
        //MLM
        strPOST += "&" + strPrefijoDeta + "_IMP_PUNTOS" + intC + "=" + lstRow.FACD_PUNTOS;
        strPOST += "&" + strPrefijoDeta + "_IMP_VNEGOCIO" + intC + "=" + lstRow.FACD_NEGOCIO;
        strPOST += "&" + strPrefijoDeta + "_PUNTOS" + intC + "=" + lstRow.FACD_PUNTOS_U;
        strPOST += "&" + strPrefijoDeta + "_VNEGOCIO" + intC + "=" + lstRow.FACD_NEGOCIO_U;
        strPOST += "&" + strPrefijoDeta + "_DESC_PREC" + intC + "=" + lstRow.FACD_DESC_PREC;
        strPOST += "&" + strPrefijoDeta + "_DESC_PTO" + intC + "=" + lstRow.FACD_DESC_PTO;
        strPOST += "&" + strPrefijoDeta + "_DESC_VN" + intC + "=" + lstRow.FACD_DESC_VN;
        //      strPOST += "&" + strPrefijoDeta + "_DESC_LEAL" + intC + "=" + lstRow.FACD_DESC_LEAL;
        strPOST += "&" + strPrefijoDeta + "_DESC_ORI" + intC + "=" + lstRow.FACD_DESC_ORI;
        strPOST += "&" + strPrefijoDeta + "_REGALO" + intC + "=" + lstRow.FACD_REGALO;
        strPOST += "&" + strPrefijoDeta + "_ID_PROMO" + intC + "=" + lstRow.FACD_ID_PROMO;

        //MLM
        //Validamos si los precios incluyen o no impuestos para guardarlos incluyendo impuestos
        if (intPreciosconImp == 1) {
            strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + lstRow.FACD_PRECIO;
            if (lstRow.FACD_SINPRECIO == 0) {
                strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + lstRow.FACD_PRECREAL;
            } else {
                strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + 0;
            }
        } else {
            var dblPrecioConImp = 0;
            var dblPrecioRealConImp = 0;
            if (lstRow.FACD_CANTIDAD > 0) {
                //Calculamos el impuesto
                var dblBase1 = 0;
                var dblBase2 = 0;
                var dblBase3 = 0;
                var dblBaseReal1 = 0;
                var dblBaseReal2 = 0;
                var dblBaseReal3 = 0;
                var dblImpuesto1 = 0;
                var dblImpuesto2 = 0;
                var dblImpuesto3 = 0;
                var dblImpuestoReal1 = 0;
                var dblImpuestoReal2 = 0;
                var dblImpuestoReal3 = 0;
                if (parseInt(lstRow.FACD_EXENTO1) == 0)
                    dblBase1 = lstRow.FACD_PRECIO;
                if (parseInt(lstRow.FACD_EXENTO2) == 0)
                    dblBase2 = lstRow.FACD_PRECIO;
                if (parseInt(lstRow.FACD_EXENTO3) == 0)
                    dblBase3 = lstRow.FACD_PRECIO;
                if (parseInt(lstRow.FACD_EXENTO1) == 0)
                    dblBaseReal1 = lstRow.FACD_PRECREAL;
                if (parseInt(lstRow.FACD_EXENTO2) == 0)
                    dblBaseReal2 = lstRow.FACD_PRECREAL;
                if (parseInt(lstRow.FACD_EXENTO3) == 0)
                    dblBaseReal3 = lstRow.FACD_PRECREAL;
                var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
                tax.CalculaImpuestoMas(dblBase1, dblBase2, dblBase3);
                var tax2 = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
                tax2.CalculaImpuestoMas(dblBaseReal1, dblBaseReal2, dblBaseReal3);
                if (parseInt(lstRow.FACD_EXENTO1) == 0)
                    dblImpuesto1 = tax.dblImpuesto1;
                if (parseInt(lstRow.FACD_EXENTO2) == 0)
                    dblImpuesto2 = tax.dblImpuesto2;
                if (parseInt(lstRow.FACD_EXENTO3) == 0)
                    dblImpuesto3 = tax.dblImpuesto3;
                if (parseInt(lstRow.FACD_EXENTO1) == 0)
                    dblImpuestoReal1 = tax2.dblImpuesto1;
                if (parseInt(lstRow.FACD_EXENTO2) == 0)
                    dblImpuestoReal2 = tax2.dblImpuesto2;
                if (parseInt(lstRow.FACD_EXENTO3) == 0)
                    dblImpuestoReal3 = tax2.dblImpuesto3;
                dblPrecioConImp = (parseFloat(lstRow.FACD_PRECIO) +
                        dblImpuesto1 +
                        dblImpuesto2 +
                        dblImpuesto3);
                //Si se definio el precio
                if (lstRow.FACD_SINPRECIO == 0) {
                    dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECREAL) +
                            dblImpuestoReal1 +
                            dblImpuestoReal2 +
                            dblImpuestoReal3);
                } else {
                    //Se definio manualmente el precio
                    dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECIO) +
                            dblImpuesto1 +
                            dblImpuesto2 +
                            dblImpuesto3);
                    lstRow.FACD_IMPORTEREAL = dblPrecioRealConImp * lstRow.FACD_CANTIDAD;
                }
            } else {
                dblPrecioConImp = (parseFloat(lstRow.FACD_PRECIO));
                dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECREAL));
            }
            strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + dblPrecioConImp;
            if (lstRow.FACD_SINPRECIO == 0) {
                strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + dblPrecioRealConImp;
            } else {
                strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + 0;
            }
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
        strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + encodeURIComponent(lstRow.FACD_NOTAS);
        strPOST += "&" + strPrefijoDeta + "_UNIDAD_MEDIDA" + intC + "=" + lstRow.FACD_UNIDAD_MEDIDA;
        //[p] Agregamos nuevos campos para el manejo de los paquetes
        strPOST += "&" + strPrefijoDeta + "_ES_PAQUETE" + intC + "=" + lstRow.FACD_ES_PAQUETE;
        strPOST += "&" + strPrefijoDeta + "_ES_COMPONENTE" + intC + "=" + lstRow.FACD_ES_COMPONENTE;
        strPOST += "&" + strPrefijoDeta + "_PR_PAQUETE" + intC + "=" + lstRow.FACD_PR_PAQUETE;
        strPOST += "&" + strPrefijoDeta + "_MULTIPLO" + intC + "=" + lstRow.FACD_MULTIPLO;
    }
    strPOST += "&COUNT_ITEM=" + intC;
    //Pagos Mandamos las 4 formas de pago
    //Validamos el tipo de venta
    if (document.getElementById("FAC_TIPO").value != "3"
            && document.getElementById("FAC_TIPO").value != "5"
            && parseFloat(document.getElementById("FAC_TOT").value) > 0
            && parseFloat(document.getElementById("FAC_DIASCREDITO").value) == 0) {
        strPOST += "&COUNT_PAGOS=5";
        //efectivo
        strPOST += "&MCD_MONEDA1=1";
        strPOST += "&MCD_FOLIO1=";
        strPOST += "&MCD_FORMAPAGO1=EFECTIVO";
        strPOST += "&MCD_NOCHEQUE1=";
        strPOST += "&MCD_BANCO1=";
        strPOST += "&MCD_NOTARJETA1=";
        strPOST += "&MCD_TIPOTARJETA1=";
        strPOST += "&MCD_IMPORTE1=" + (parseFloat(d.getElementById("Ef_1").value) - parseFloat(d.getElementById("Ef_2").value));
        strPOST += "&MCD_TASAPESO1=1";
        strPOST += "&MCD_CAMBIO1=" + d.getElementById("Ef_2").value;
        //cheque
        strPOST += "&MCD_MONEDA2=1";
        strPOST += "&MCD_FOLIO2=";
        strPOST += "&MCD_FORMAPAGO2=CHEQUE";
        strPOST += "&MCD_NOCHEQUE2=" + d.getElementById("Bc_2").value;
        strPOST += "&MCD_BANCO2=" + d.getElementById("Bc_3").value;
        strPOST += "&MCD_NOTARJETA2=";
        strPOST += "&MCD_TIPOTARJETA2=";
        strPOST += "&MCD_IMPORTE2=" + d.getElementById("Bc_1").value;
        strPOST += "&MCD_TASAPESO2=1";
        strPOST += "&MCD_CAMBIO2=0";
        //tarjeta de credito
        strPOST += "&MCD_MONEDA3=1";
        strPOST += "&MCD_FOLIO3=";
        strPOST += "&MCD_FORMAPAGO3=TCREDITO";
        strPOST += "&MCD_NOCHEQUE3=";
        strPOST += "&MCD_BANCO3=";
        strPOST += "&MCD_NOTARJETA3=" + d.getElementById("Tj_2").value;
        strPOST += "&MCD_TIPOTARJETA3=" + d.getElementById("Tj_3").value;
        strPOST += "&MCD_IMPORTE3=" + d.getElementById("Tj_1").value;
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
        strPOST += "&MCD_IMPORTE4=" + d.getElementById("sf_1").value;
        strPOST += "&MCD_TASAPESO4=1";
        strPOST += "&MCD_CAMBIO4=0";
        var grid1 = jQuery("#GRID_ANTIV");
        var lista = grid1.getGridParam("selarrrow");
        var dblTotalPagar = parseFloat(d.getElementById("sf_1").value);
        strPOST += "&MCD_NUMANTICIPOS=" + lista.length;
        for (i = 0; i < lista.length; i++) {
            var idlast = lista[i];
            var lstRow = grid1.getRowData(idlast);
            if (parseFloat(lstRow.ANTI_ABONO) >= dblTotalPagar)
            {
                strPOST += "&MCD_CANTUSAR" + (i + 1) + "=" + dblTotalPagar;
                strPOST += "&MCD_IDANTICIPO" + (i + 1) + "=" + lstRow.ANTI_ID;
                break;
            } else {
                strPOST += "&MCD_CANTUSAR" + (i + 1) + "=" + lstRow.ANTI_ABONO;
                strPOST += "&MCD_IDANTICIPO" + (i + 1) + "=" + lstRow.ANTI_ID
                dblTotalPagar = dblTotalPagar - parseFloat(lstRow.ANTI_ABONO);
            }
            //lstRow.IMPD_MONTO_CARGO
        }
        //Transferencia
        strPOST += "&MCD_MONEDA5=1";
        strPOST += "&MCD_FOLIO5=";
        strPOST += "&MCD_FORMAPAGO5=TRANSFERENCIA BANCARIA";
        strPOST += "&MCD_NOCHEQUE5=";
        strPOST += "&MCD_BANCO5=" + d.getElementById("tf_2").value;
        strPOST += "&MCD_NOTARJETA5=" + d.getElementById("tf_3").value;
        strPOST += "&MCD_TIPOTARJETA5=";
        strPOST += "&MCD_IMPORTE5=" + d.getElementById("tf_1").value;
        strPOST += "&MCD_TASAPESO5=1";
        strPOST += "&MCD_CAMBIO5=0";

    } else {
        strPOST += "&COUNT_PAGOS=1";
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
    }
    //Ocultamos el div del menú
    document.getElementById("TOOLBAR").style.display = "none";
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
            document.getElementById("TOOLBAR").style.display = "block";
            dato = trim(dato);
            if (Left(dato, 3) == "OK.") {
                if (strNomFormat == "FACTURA") {
                    if (intImprimeTicket == 1) {
                        ImprimeconFolioTicket(dato.replace("OK.", ""));
                    } else {
                        var strHtml = CreaHidden(strKey, dato.replace("OK.", ""));
                        openWhereverFormat("ERP_SendInvoice?id=" + dato.replace("OK.", ""), strNomFormat, "PDF", strHtml);
                    }
                    ResetOperaActual();
                } else {
                    var bolImprimeDoc1 = true;
                    //Evaluamos si es un pedido recurrente para preguntar si
                    //desea generar la siguiente factura recurrente
                    if (document.getElementById("FAC_TIPO").value == 3) {
                        if (document.getElementById("FAC_ESRECU1") != null) {
                            if (document.getElementById("FAC_ESRECU1").checked) {
                                var aRec = confirm(lstMsg[182]);
                                if (aRec) {
                                    var aRec2 = confirm(lstMsg[194]);
                                    var strFechaUser = "";
                                    var intFechaUserSel = 0;
                                    if (aRec2) {
                                        var aRec3 = window.prompt(lstMsg[195], d.getElementById("FAC_FECHA").value);
                                        if (aRec3 != null && aRec3 != "") {
                                            strFechaUser = aRec3;
                                            intFechaUserSel = 1;
                                        }

                                    }
                                    var strFiltro = "&USA_FECHAUSER=" + intFechaUserSel + "&FAC_FECHA_US=" + strFechaUser;
                                    bolImprimeDoc1 = false;
                                    //Hacemos peticion por AJAX para generar las facturas
                                    $.ajax({
                                        type: "POST",
                                        data: encodeURI("LST_PD_ID=" + document.getElementById("PD_ID").value + strFiltro),
                                        scriptCharset: "utf-8",
                                        contentType: "application/x-www-form-urlencoded;charset=utf-8",
                                        cache: false,
                                        dataType: "html",
                                        url: "ERP_FacRecu.jsp?id=1",
                                        success: function (dato) {
                                            dato = trim(dato);
                                            if (Left(dato, 3) == "OK.") {
                                                alert(lstMsg[59] + " " + dato.replace("OK.", ""));
                                            } else {
                                                alert(dato);
                                            }
                                            ResetOperaActual();
                                            $("#dialogWait").dialog("close");
                                        },
                                        error: function (objeto, quepaso, otroobj) {
                                            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                                            $("#dialogWait").dialog("close");
                                        }
                                    });
                                }
                            }
                        }
                    }
                    //Si imprime el documento y reseteamos la operacion
                    if (bolImprimeDoc1) {
                        if (intImprimeTicket == 1) {
                            ImprimeconFolioTicket(dato.replace("OK.", ""));
                        } else {
                            ImprimeconFolio(strKey, dato, strNomFormat);
                        }
                        ResetOperaActual();
                    }
                }
            } else {
                alert(dato);
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":saveVta:" + objeto + " " + quepaso + " " + otroobj);
            document.getElementById("TOOLBAR").style.display = "block";
            $("#dialogWait").dialog("close");
        }
    });
}

function ImprimeconFolio(strKey, dato, strNomFormat) {
    var strTipo = "1";
    if (d.getElementById("FAC_TIPO").value == "3") {
        strTipo = "2";
    }
    if (d.getElementById("FAC_TIPO").value == "4") {
        strTipo = "3";
    }
    if (d.getElementById("FAC_TIPO").value == "5") {
        strTipo = "5";
    }
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
            var strHtml2 = CreaHidden(strKey, dato.replace("OK.", ""));
            openFormat(strNomFormat, "PDF", strHtml2, strFolioT);
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ImprimeFolio:" + objeto + " " + quepaso + " " + otroobj);
        }
    });

}
/**Funciones para el cuadro de dialogo SI/NO*/
function ConfirmaSI() {
    if (d.getElementById("Operac").value == "Nva") {
        //Llamamos metodo para limpiar pantallas
        ResetOperaActual()
    }
    if (d.getElementById("Operac").value == "PORC_DESC") {
        //Llamamos metodo para asignar el porcentaje de descuento
        PorcDescSend();
    }
    if (d.getElementById("Operac").value == "CHANGE_PRICE") {
        //Llamamos metodo para cambiar el precio del articulo
        CambioPrecSend();
    }
    if (d.getElementById("Operac").value == "CHANGE_CANTPD") {
        //Llamamos metodo para cambiar el precio del articulo
        VtaModificaCantDo();
    }
    d.getElementById("Operac").value = "";
    $("#SioNO").dialog("close");
}
function ConfirmaNO() {
    $("#SioNO").dialog("close");
}
//Panel de botones
/**Guardar operacion*/
function Callbtn0() {
    if (bolSaveVta) {
        SaveVta();
    } else {
        alert(lstMsg[161]);
    }
}
/**Nueva operacion*/
function Callbtn1() {
    $("#SioNO").dialog('option', 'title', "¿Confirma que desea borrar la operacion actual e iniciar una nueva?");
    d.getElementById("Operac").value = "Nva";
    document.getElementById("SioNO_inside").innerHTML = "";
    //Inicializamos eventos para el cuadro de dialogo SI/NO sino se puede sobreescribir con el de otra pantalla
    InitSIoNoEvents();
    $("#SioNO").dialog("open");
}
/**Limpia la operacion actual*/
function ResetOperaActual(bolSelOpera) {
    if (bolSelOpera == undefined)
        bolSelOpera = true;
    if (bolSelOpera)
        $("#dialogWait").dialog("open");
    bolSaveVta = true;//Activamos el guardado
    //Limpiamos los campos y ponemos al cliente default
    d.getElementById("FCT_ID").value = intCteDefa;
    d.getElementById("FAC_FOLIO").value = "";
    d.getElementById("FAC_NOTAS").value = "";
    document.getElementById("FAC_NOTASPIE").value = "";
    d.getElementById("FAC_TOT").value = "0.0";
    d.getElementById("FAC_IMPUESTO1").value = "0.0";
    d.getElementById("FAC_IMPUESTO2").value = "0.0";
    d.getElementById("FAC_IMPUESTO3").value = "0.0";
    d.getElementById("FAC_IMPORTE").value = "0.0";
    d.getElementById("FAC_RETISR").value = "0.0";
    d.getElementById("FAC_RETIVA").value = "0.0";
    d.getElementById("FAC_NETO").value = "0.0";
    d.getElementById("FAC_DESC").value = "";
    d.getElementById("FAC_PRECIO").value = "0.0";
    d.getElementById("VE_ID").value = "0";
    d.getElementById("PD_ID").value = "0";
    d.getElementById("VE_NOM").value = "";
    d.getElementById("FAC_LPRECIOS").value = 0;
    d.getElementById("FAC_DESCUENTO").value = 0;
    intSucOfertas = intSucDefOfertas;
    d.getElementById("FAC_PROD").focus();
    if (!bolPerTicket) {
        //No tiene permisos para los tickets por default buscamos en cual si
        if (bolPerPedido) {
            d.getElementById("FAC_TIPO").value = 3;
        }
        if (bolPerFactura) {
            d.getElementById("FAC_TIPO").value = 1;
        }
        if (bolPerCotiza) {
            d.getElementById("FAC_TIPO").value = 5;
        }
    } else {
        d.getElementById("FAC_TIPO").value = "2";
    }
    //Edicion del cliente
    document.getElementById("CT_NOM").readOnly = false;
    document.getElementById("CT_NOM").setAttribute("class", "OutEdit");
    document.getElementById("CT_NOM").setAttribute("className", "OutEdit");
    document.getElementById("FCT_ID").parentNode.style.display = "block";
    //Recurrentes
    d.getElementById("FAC_ESRECU2").checked = true;
    d.getElementById("FAC_PERIODICIDAD").value = "1";
    d.getElementById("FAC_DIAPER").value = "1";
    d.getElementById("FAC_NUMPEDI").value = "";
    d.getElementById("FAC_FECHAPEDI").value = "";
    d.getElementById("FAC_ADUANA").value = "";
    d.getElementById("FAC_METODOPAGO").value = "";
    d.getElementById("FAC_NUMCUENTA").value = "";
    document.getElementById("FAC_USE_IMP1").value = 0;
    //Actualizamos impuestos
    InitImpDefault();
    d.getElementById("FAC_TASASEL1").value = intIdTasaVta1;
    if (d.getElementById("FAC_TASASEL2") != null) {
        d.getElementById("FAC_TASASEL2").value = intIdTasaVta2;
    }
    if (d.getElementById("FAC_TASASEL3") != null) {
        d.getElementById("FAC_TASASEL3").value = intIdTasaVta3;
    }
    OcultarAvisos();
    if (bolSelOpera)
        ObtenNomCte();
    //Limpiamos el GRID
    var grid = jQuery("#FAC_GRID");
    grid.clearGridData();
    //Inicializamos eventos para el cuadro de dialogo SI/NO sino se puede sobreescribir con el de otra pantalla
    InitSIoNoEvents();

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
    if (bolSelOpera)
        SelOperFact();
    //Validamos si la sucursal puede editarse
    EvalSucursal();
    //Evalua el motor de promociones
    _ResetPromosAll();
}
/**Abre la ventana de consulta de ventas*/
function Callbtn2() {
    OpnOpt('VTAS_VIEW', '_ed', 'dialogView', false, false, true);
}
/**Abrimos ventana para calcular descuento*/
function Callbtn3() {
    var grid = jQuery("#FAC_GRID");
    var ids = grid.getGridParam("selrow");
    if (ids != null && bolPorc) {
        document.getElementById("Operac").value = "PORC_DESC";
        $("#SioNO").dialog('option', 'title', lstMsg[5]);
        //Inicializamos eventos para el cuadro de dialogo SI/NO sino se puede sobreescribir con el de otra pantalla
        InitSIoNoEvents();
        var div = document.getElementById("SioNO_inside");
        var lstRow1 = grid.getRowData(ids);
        var intIdPR = lstRow1.FACD_PR_ID;
//      if (lstPorcDesc == null) {
        $("#dialogWait").dialog("open");
        //Hacemos la peticion por POST
        $.ajax({
            type: "POST",
            data: "intIdPR=" + intIdPR,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "ERP_Producto.jsp?id=21",
            success: function (datos) {
                var objsc = datos.getElementsByTagName("vta_porcdesc")[0];
                var porcData = objsc.getElementsByTagName("vta_porcdescs");
                lstPorcDesc = new Array();
                for (i = 0; i < porcData.length; i++) {
                    var obj = porcData[i];
                    var Opt2 = new Seloptions(obj.getAttribute('PCD_PORC'), obj.getAttribute('PCD_PORC'));
                    lstPorcDesc[i] = Opt2;
                }
                var strHtml = CreaSelect(lstMsg[6], "MiPordcDesc", 0, lstPorcDesc, "", "center", 0, 0, "integer", "", 0);
                div.innerHTML = strHtml;
                $("#SioNO").dialog("open");
                $("#dialogWait").dialog("close");
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":descuentos:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });
//      } else {
//         var strHtml = CreaSelect(lstMsg[6], "MiPordcDesc", 0, lstPorcDesc, "", "center", 0, 0, "integer", "", 0);
//         div.innerHTML = strHtml;
//         $("#SioNO").dialog("open");
//      }
    }
}
/**Aplica el porcentaje de descuento al producto*/
function PorcDescSend() {
    var grid = jQuery("#FAC_GRID");
    var ids = grid.getGridParam("selrow");
    if (ids != null) {
        var porDesc = d.getElementById("MiPordcDesc").value;
        //Calculamos el descuento
        PorcDescDo(ids, porDesc);
    }
}
/**Asigna el nuevo porcentaje de descuento seleccionado por el usuario*/
function PorcDescDo(id, dblPorc) {
    var grid = jQuery("#FAC_GRID");
    //Calculamos nuevo importe
    var lstRow = grid.getRowData(id);
    //Recalculamos el importe y actualizamos la fila
    lstRow.FACD_PORDESC = dblPorc;
    lstRowChangePrecio(lstRow, id, grid);
    //ponemos el foco para seguir capturando
    document.getElementById("FAC_PROD").focus();
}
/**Abrimos ventana para indicar el nuevo precio del articulo*/
function Callbtn4() {
    var grid = jQuery("#FAC_GRID");
    var ids = grid.getGridParam("selrow");
    if (ids != null && bolPrice) {
        var lstRow = grid.getRowData(ids);
        document.getElementById("Operac").value = "CHANGE_PRICE";
        $("#SioNO").dialog('option', 'title', lstMsg[7]);
        var div = document.getElementById("SioNO_inside");
        var strHtml = CreaTexto(lstMsg[8], "_NvoPrecio", lstRow.FACD_PRECIO, 10, 10, true, false, "", "left", 0, "", "", "", false, 1);
        strHtml += CreaRadio(lstMsg[9], "_NvoClean", 0, false, " ");
        div.innerHTML = strHtml;
        //Inicializamos eventos para el cuadro de dialogo SI/NO sino se puede sobreescribir con el de otra pantalla
        InitSIoNoEvents();
        $("#SioNO").dialog("open");
    }
}
/**Inicializa los eventos*/
function InitSIoNoEvents() {
    //Definimos acciones para el dialogo SI/NO
    document.getElementById("btnSI").onclick = function () {
        ConfirmaSI();
    };
    document.getElementById("btnNO").onclick = function () {
        ConfirmaNO();
    };
}
/**Modifica la cantidad*/
function Callbtn5() {
    //Inicializamos eventos para el cuadro de dialogo SI/NO sino se puede sobreescribir con el de otra pantalla
    InitSIoNoEvents();
    VtaModificaCant();
}
/**Aplica el porcentaje de descuento al producto*/
function CambioPrecSend() {
    var grid = jQuery("#FAC_GRID");
    var ids = grid.getGridParam("selrow");
    if (ids != null) {
        var dblNvoPrec = d.getElementById("_NvoPrecio").value;
        var bolClean = false;
        if (d.getElementById("_NvoClean1").checked)
            bolClean = true;
        //Calculamos el nuevo precio
        CambioPrecDo(ids, dblNvoPrec, bolClean);
    }
}
/**Asigna el nuevo porcentaje de descuento seleccionado por el usuario*/
function CambioPrecDo(id, dblNvoPrec, bolClean) {
    var grid = jQuery("#FAC_GRID");
    //Calculamos nuevo importe
    var lstRow = grid.getRowData(id);
    //Recalculamos el importe y actualizamos la fila
    if (bolClean) {
        lstRow.FACD_PRECIO = lstRow.FACD_PRECREAL;
        lstRow.FACD_PRECFIJO = 0;
        lstRow.FACD_SINPRECIO = 0;
    } else {
        lstRow.FACD_PRECIO = dblNvoPrec;
        lstRow.FACD_PRECFIJO = 1;
        //El precio real siempre sera el que capture el usuario
        lstRow.FACD_PRECREAL = lstRow.FACD_PRECIO;
        //Si el precio real es cero el nuevo precio sera el real
        if (lstRow.FACD_PRECREAL == 0) {
            lstRow.FACD_SINPRECIO = 1;
            lstRow.FACD_PRECREAL = lstRow.FACD_PRECIO;
        }
    }
    lstRowChangePrecio(lstRow, id, grid);
    //ponemos el foco para seguir capturando
    document.getElementById("FAC_PROD").focus();
}
/**Manda abrir la ventana de devoluciones*/
function Callbtn6() {
    //Inicializamos eventos para el cuadro de dialogo SI/NO sino se puede sobreescribir con el de otra pantalla
    InitSIoNoEvents();
    if (bolDevol) {
        OpnOpt('DEVO', '_ed', 'dialogDevo', false, false);
    }
}
/**Realiza la devolucion del producto*/
function DevolProdDo() {
    //Obtenemos los
    d.getElementById("FAC_PROD").value = d.getElementById("DEVO_ARTICULO").value;
    d.getElementById("FAC_DESC").value = d.getElementById("DEVO_DESCRIPCION").value;
    d.getElementById("FAC_DEVO").value = 1;
    $("#dialogDevo").dialog("close");
    AddItem();
}
/**Borramos item*/
function Callbtn7() {
    VtaDrop()
}
/**Nos salimos de la pantalla*/
function Callbtn9() {
    myLayout.open("west");
    myLayout.open("east");
    myLayout.open("south");
    myLayout.open("north");
    document.getElementById("MainPanel").innerHTML = "";
    //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
    var objMainFacPedi = objMap.getScreen("VENTAS");
    objMainFacPedi.bolActivo = false;
    objMainFacPedi.bolMain = false;
    objMainFacPedi.bolInit = false;
    objMainFacPedi.idOperAct = 0;
}//Borramos item
//Agregamos notas para la partida
function Callbtn8() {
    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        //Inicializamos eventos para el cuadro de dialogo SI/NO sino se puede sobreescribir con el de otra pantalla
        InitSIoNoEvents();
        var lstRowAct = grid.getRowData(id);
        var strHTML = CreaTextArea(lstMsg[30], "NOTASMOD", lstRowAct.FACD_NOTAS, 5, 80, "", 0, 0, 3, 0);
        strHTML += CreaBoton("", "NOTASBTN", lstMsg[31], "ChangeNotes()", "center", false, true, 0);
        $("#dialog2").dialog('option', 'title', lstMsg[29]);
        document.getElementById("dialog2").innerHTML = strHTML;
        $("#dialog2").dialog("option", "width", 500);
        $("#dialog2").dialog("open");
        document.getElementById("NOTASMOD").focus();
    }
}
/**Guarda el cambio de las notas hechas*/
function ChangeNotes() {
    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        var lstRowAct = grid.getRowData(id);
        lstRowAct.FACD_NOTAS = d.getElementById("NOTASMOD").value;
        //Actualizamos el grid
        grid.setRowData(id, lstRowAct);
    }
    $("#dialog2").dialog("close");
}

/**Abre el cuadro de dialogo para seleccionar el tipo de operacion*/
function SelOperFact() {
    //Evaluamos si es un pedido para no preguntar la operacion
    var strNomMain = objMap.getNomMain();
    if (strNomMain == "PEDIDO") {
        d.getElementById("FAC_TIPO").value = 3;
        SelOperFactDo(null);
    } else {
        var elements = new Array();
        elements[0] = new Seloptions("TICKET", 2);
        elements[1] = new Seloptions("FACTURA", 1);
        elements[2] = new Seloptions("PEDIDO", 3);
        elements[3] = new Seloptions("COTIZACION", 5);
        $("#dialogInv").dialog('option', 'title', lstMsg[38]);
        var strHTML2 = "";
        strHTML2 = "</br></br></br><div id=\"OperFactSel\">";
        if (bolPerTicket)
            strHTML2 = "<input type=\"radio\" id=\"OperFactSel1\" name=\"OperFactSel\" value=\"" + elements[0].Valor + "\" onClick=\"SelOperFactDo(this)\" /><label for=\"OperFactSel1\"><img src='images/ptovta/ico_ticket.png' border='0' id='img1' />" + elements[0].Etiqueta + "</label>";
        if (bolPerFactura)
            strHTML2 += "&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"radio\" id=\"OperFactSel2\" name=\"OperFactSel\" value=\"" + elements[1].Valor + "\"  onClick=\"SelOperFactDo(this)\" /><label for=\"OperFactSel2\"><img src='images/ptovta/ico_invoice.png' border='0' id='img1' />" + elements[1].Etiqueta + "</label>";
        if (bolPerPedido)
            strHTML2 += "&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"radio\" id=\"OperFactSel3\" name=\"OperFactSel\" value=\"" + elements[2].Valor + "\"  onClick=\"SelOperFactDo(this)\" /><label for=\"OperFactSel3\"><img src='images/ptovta/ico_order.png' border='0' id='img1' />" + elements[2].Etiqueta + "</label>";
        if (bolPerCotiza)
            strHTML2 += "&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"radio\" id=\"OperFactSel3\" name=\"OperFactSel\" value=\"" + elements[3].Valor + "\"  onClick=\"SelOperFactDo(this)\" /><label for=\"OperFactSel3\"><img src='images/ptovta/ico_quote.png' border='0' id='img1' />" + elements[3].Etiqueta + "</label>";
        strHTML2 += " </div>";
        document.getElementById("dialogInv_inside").innerHTML = strHTML2;
        $("#dialogInv").dialog("option", "width", 500);
        $("#OperFactSel").buttonset();
        $("#dialogInv").dialog("open");
    }

}
/**Selecciona el tipo de operacion de ventas*/
function SelOperFactDo(obj) {
    var strPost = "";
    if (obj != null) {
        d.getElementById("FAC_TIPO").value = obj.value;
    }
    if (document.getElementById("FAC_SERIE") == null) {
        strPost = "TYPE_ID=" + d.getElementById("FAC_TIPO").value;
    } else {
        var intSerie = document.getElementById("FAC_SERIE").value;
        strPost = "TYPE_ID=" + d.getElementById("FAC_TIPO").value + "&SERIE=" + intSerie;
    }
    //Peticion para mostrar el siguiente folios
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=14",
        success: function (datos) {
            var objsc = datos.getElementsByTagName("vta_folios")[0];
            var strFolioT = objsc.getAttribute('FOLIO');
            document.getElementById("FAC_FOLIO").value = strFolioT;
            d.getElementById("FAC_PROD").focus();
            $("#dialogInv").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Obten folio siguiente:" + objeto + " " + quepaso + " " + otroobj);
            d.getElementById("FAC_PROD").focus();
            $("#dialogInv").dialog("close");
        }
    });

}
/**Carga la informacion de una operacion de REMISION FACTURA O PEDIDO*/
function getPedidoenVenta(intIdPedido, strTipoVta) {
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
                        ResetOperaActual(false);
                        //Llenamos la pantalla con los valores del bd
                        DrawPedidoenVenta(objPedido, lstdeta, strTipoVta);
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
function DrawPedidoenVenta(objPedido, lstdeta, strTipoVta) {
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
    document.getElementById("FAC_MONEDA").value = objPedido.getAttribute('PD_MONEDA');
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
    document.getElementById("FCT_DESCUENTO").value = objPedido.getAttribute('PD_POR_DESCUENTO');
    if (objPedido.getAttribute('PD_ESRECU') == 1) {
        document.getElementById("FAC_ESRECU1").checked = true;
    } else {
        document.getElementById("FAC_ESRECU2").checked = false;
    }
    document.getElementById("FAC_PERIODICIDAD").value = objPedido.getAttribute('PD_PERIODICIDAD');
    document.getElementById("FAC_DIAPER").value = objPedido.getAttribute('PD_DIAPER');
    document.getElementById("VE_ID").value = objPedido.getAttribute('VE_ID');
    //Inactivamos la edicion del cliente
    document.getElementById("CT_NOM").readOnly = true;
    document.getElementById("CT_NOM").setAttribute("class", "READONLY");
    document.getElementById("CT_NOM").setAttribute("className", "READONLY");
    document.getElementById("FCT_ID").parentNode.style.display = "none";
    ObtenNomCte(objPedido, lstdeta, strTipoVta, true);
}
/**
 *Llenamos el grid con los datos del pedido
 **/
function DrawPedidoDetaenVenta(objPedido, lstdeta, strTipoVta) {
    //Generamos el detalle
    for (i = 0; i < lstdeta.length; i++) {
        var obj = lstdeta[i];
        var objImportes = new _ImporteVta();
        objImportes.dblCantidad = obj.getAttribute('PDD_CANTIDAD');
        if (parseInt(obj.getAttribute('PDD_EXENTO1')) == 0) {
            objImportes.dblPrecio = parseFloat(obj.getAttribute('PDD_PRECIO')) / (1 + (obj.getAttribute('PDD_TASAIVA1') / 100));
            objImportes.dblPrecioReal = parseFloat(obj.getAttribute('PDD_PRECREAL')) / (1 + (obj.getAttribute('PDD_TASAIVA1') / 100));
        } else {
            objImportes.dblPrecio = parseFloat(obj.getAttribute('PDD_PRECIO'));
            objImportes.dblPrecioReal = parseFloat(obj.getAttribute('PDD_PRECREAL'));
        }
        objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
        objImportes.dblPorcDesc = obj.getAttribute('PDD_PORDESC');
        objImportes.dblExento1 = obj.getAttribute('PDD_EXENTO1');
        objImportes.dblExento2 = obj.getAttribute('PDD_EXENTO2');
        objImportes.dblExento3 = obj.getAttribute('PDD_EXENTO3');
        objImportes.intDevo = 0;
        objImportes.dblPuntos = parseFloat(obj.getAttribute('PDD_PUNTOS'));
        objImportes.dblVNegocio = parseFloat(obj.getAttribute('PDD_VNEGOCIO'));
        //Banderas de descuento
        if (obj.getAttribute('PDD_DESC_PREC') == 0)
            objImportes.bolAplicDescPrec = false;
        if (obj.getAttribute('PDD_DESC_PUNTOS') == 0)
            objImportes.bolAplicDescPto = false;
        if (obj.getAttribute('PDD_DESC_VNEGOCIO') == 0)
            objImportes.bolAplicDescVNego = false;
        //if(lstRow.FACD_DESC_LEAL == 0)objImportes.bolAplicDescPrec= false;
        //Validamos existencias en caso de que aplique
        if (obj.getAttribute('PR_REQEXIST') == 1 &&
                (strTipoVta == "FACTURA" || strTipoVta == "REMISION")) {
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
        //Evaluamos si aplican los puntos y valor negocio de multinivel
        var bolAplicaMLM = true;
        if (document.getElementById("FAC_ES_MLM1") != null && document.getElementById("FAC_ES_MLM2") != null) {
            if (document.getElementById("FAC_ES_MLM2").checked)
                bolAplicaMLM = false;
        }
        objImportes.bolUsoMLM = bolAplicaMLM;
        //Evaluamos si aplican los puntos y valor negocio de multinivel
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
            FACD_TASAIVA2: obj.getAttribute('PDD_TASAIVA2'),
            FACD_TASAIVA3: obj.getAttribute('PDD_TASAIVA3'),
            FACD_DESGLOSA1: 1,
            FACD_IMPUESTO1: objImportes.dblImpuesto1,
            FACD_IMPUESTO2: objImportes.dblImpuesto2,
            FACD_IMPUESTO3: objImportes.dblImpuesto3,
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
            FACD_NOTAS: obj.getAttribute('PDD_COMENTARIO'),
            FACD_PUNTOS_U: objImportes.dblPuntos,
            FACD_NEGOCIO_U: objImportes.dblVNegocio,
            FACD_PUNTOS: objImportes.dblPuntosImporte,
            FACD_NEGOCIO: objImportes.dblVNegocioImporte,
            FACD_DESC_ORI: obj.getAttribute('PDD_DESC_ORI'),
            FACD_REGALO: obj.getAttribute('PDD_REGALO'),
            FACD_ID_PROMO: obj.getAttribute('PDD_ID_PROMO'),
            FACD_DESC_PREC: obj.getAttribute('PDD_DESC_PREC'),
            FACD_DESC_PTO: obj.getAttribute('PDD_DESC_PUNTOS'),
            FACD_DESC_VN: obj.getAttribute('PDD_DESC_VNEGOCIO'),
            FACD_DESC_LEAL: 0,
            FACD_ES_PAQUETE: obj.getAttribute('PDD_ES_PAQUETE'),
            FACD_ES_COMPONENTE: obj.getAttribute('PDD_ES_COMPONENTE'),
            FACD_PR_PAQUETE: obj.getAttribute('PDD_PR_PAQUETE'),
            FACD_MULTIPLO: obj.getAttribute('PDD_MULTIPLO')
        };
        //Anexamos el registro al GRID
        jQuery("#FAC_GRID").addRowData(obj.getAttribute('PDD_ID'), datarow, "last");
    }
    //Realizamos la sumatoria
    setSum();
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
function OcultarAvisos() {
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
    this.dblImporteDescuento = 0;
    //MLM
    this.dblPuntos = 0;
    this.dblVNegocio = 0;
    this.dblPuntosAplica = 0;
    this.dblVNegocioAplica = 0;
    this.dblPuntosImporte = 0;
    this.dblVNegocioImporte = 0;
    this.bolAplicDescPrec = true;
    this.bolAplicDescPto = true;
    this.bolAplicDescVNego = true;
    this.bolUsoMLM = true;
    //MLM
    this.CalculaImporte = function CalculaImporte() {
        //Calculamos el importe
        this.dblPorcDescGlobal = parseFloat(this.dblPorcDescGlobal);
        this.dblPorcDesc = parseFloat(this.dblPorcDesc);
        var dblPrecioAplica = parseFloat(this.dblPrecio);
        //MLM
        this.dblPuntosAplica = this.dblPuntos;
        this.dblVNegocioAplica = this.dblVNegocio;
        //MLM
        //if(this.dblPrecFijo == 0 || this.intPrecioZeros == 1){
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
            if (this.bolAplicDescPrec) {
                dblPrecioAplica = dblPrecioAplica - (dblPrecioAplica * (this.dblPorcAplica / 100));
            }
            //Calculo de descuento en MLM
            if (this.bolAplicDescPto) {
                this.dblPuntosAplica = this.dblPuntosAplica - (this.dblPuntosAplica * (this.dblPorcAplica / 100));
            }
            if (this.bolAplicDescVNego) {
                this.dblVNegocioAplica = this.dblVNegocioAplica - (this.dblVNegocioAplica * (this.dblPorcAplica / 100));
            }
            //Calculo de descuento en MLM
        }
        //}
        this.dblImporte = parseFloat(this.dblCantidad) * parseFloat(dblPrecioAplica);
        this.dblImporteReal = parseFloat(this.dblCantidad) * parseFloat(this.dblPrecioReal);
        //Calculamos el descuento
        if (this.dblImporteReal > 0 && (this.dblImporteReal > this.dblImporte)) {
            this.dblImporteDescuento = this.dblImporteReal - this.dblImporte;
        }
        //Si es una devolucion
        if (parseInt(this.intDevo) == 1) {
            this.dblImporte = this.dblImporte * -1;
        }
        //MLM
        if (this.bolUsoMLM) {
            this.dblPuntosImporte = parseFloat(this.dblCantidad) * parseFloat(this.dblPuntosAplica);
            this.dblVNegocioImporte = parseFloat(this.dblCantidad) * parseFloat(this.dblVNegocioAplica);
        }
        //MLM
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
        //Quitamos el impuesto al descuento
        if (intPreciosconImp == 1) {
            if (this.dblImporteReal > 0) {
                var dblTotImpuesto = tax.dblImpuesto1 + tax.dblImpuesto2 + tax.dblImpuesto3;
                var dblTotImpuestoReal = tax.dblImpuestoReal1 + tax.dblImpuestoReal2 + tax.dblImpuestoReal3;
                if (this.dblImporteReal > 0 && (this.dblImporteReal > this.dblImporte)) {
                    this.dblImporteDescuento = (this.dblImporteReal - dblTotImpuestoReal) - (this.dblImporte - dblTotImpuesto);
                }
            }
        }
    }
}
/**Valida la sucursal al momento de cambiarla*/
function ValidaSuc(bolMaster) {
    if (parseFloat(document.getElementById("SC_ID").value) == 0) {
        document.getElementById("SC_ID").value = intSucDefa;
        InitImpDefault();
    } else {
        InitImpSuc(bolMaster);
    }
}
/**Inicializa los impuestos por default*/
function InitImpDefault() {
    dblTasaVta1 = dblTasa1;
    dblTasaVta2 = dblTasa2;
    dblTasaVta3 = dblTasa3;
    intSImpVta1_2 = intSImp1_2;
    intSImpVta1_3 = intSImp1_3;
    intSImpVta2_3 = intSImp2_3;
}
/**Inicializa los impuestos de la sucursal seleccionada*/
function InitImpSuc(bolMaster) {
    var IsUseTaxUser = document.getElementById("FAC_USE_IMP1").value;
    //Solo si el cliente no tiene definido un Impuesto
    if (IsUseTaxUser == 0) {
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
                    dblTasaVta1 = obj.getAttribute('Tasa1');
                    dblTasaVta2 = obj.getAttribute('Tasa2');
                    dblTasaVta3 = obj.getAttribute('Tasa3');
                    intIdTasaVta1 = obj.getAttribute('TI_ID');
                    intIdTasaVta2 = obj.getAttribute('TI_ID2');
                    intIdTasaVta3 = obj.getAttribute('TI_ID3');
                    d.getElementById("FAC_TASASEL1").value = intIdTasaVta1;
                    if (d.getElementById("FAC_TASASEL2") != null) {
                        d.getElementById("FAC_TASASEL2").value = intIdTasaVta2;
                    }
                    if (d.getElementById("FAC_TASASEL3") != null) {
                        d.getElementById("FAC_TASASEL3").value = intIdTasaVta3;
                    }
                    intSImpVta1_2 = obj.getAttribute('SImp1_2');
                    intSImpVta1_3 = obj.getAttribute('SImp1_3');
                    intSImpVta2_3 = obj.getAttribute('SImp2_3');
                }
                $("#dialogWait").dialog("close");
                try {
                    //Solo si viene activo el parametro de filtro por maestro
                    if (bolMaster != null) {
                        if (bolMaster) {
                            var objMainProd = objMap.getScreen("PROD");
                            objMainProd.bolActivo = false;
                            objMainProd.bolMain = false;
                            objMainProd.bolInit = false;
                            objMainProd.idOperAct = 0;
                        }
                    }

                } catch (err) {

                }
            },
            error: function (objeto, quepaso, otroobj) {
                alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                $("#dialogWait").dialog("close");
            }
        });
    }
}
/**Evaluamos si podemos cambiar la sucursal*/
function EvalSucursal() {
    var grid = jQuery("#FAC_GRID");
    var arr = grid.getDataIDs();
    var objSuc = document.getElementById("SC_ID");
    var objTasaSel = document.getElementById("FAC_TASASEL1");
    var objTasaSel2 = document.getElementById("FAC_TASASEL2");
    var objTasaSel3 = document.getElementById("FAC_TASASEL3");
    var objMonedaSel = document.getElementById("FAC_MONEDA");
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
//      //Tasa de iva
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
        //Moneda
        objMonedaSel.onmouseout = function () {
            this.disabled = false;
        };
        objMonedaSel.onmouseleave = function () {
            this.disabled = false;
        };
        objMonedaSel.onmouseover = function () {
            this.disabled = true;
        };
        objMonedaSel.setAttribute("class", "READONLY");
        objMonedaSel.setAttribute("className", "READONLY");
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
        //Tasa de iva
//      objTasaSel.disabled = false;
        //Si hay partidas no podremos cambiar la sucursal
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
        //Moneda
        objMonedaSel.disabled = false;
        //Si hay partidas no podremos cambiar la sucursal
        objMonedaSel.onmouseout = function () {
            var g = 1;
        };
        objMonedaSel.onmouseleave = function () {
            var g = 1;
        };
        objMonedaSel.onmouseover = function () {
            var g = 1;
        };
        objMonedaSel.setAttribute("class", "outEdit");
        objMonedaSel.setAttribute("className", "outEdit");
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
function RefreshMoneda() {
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
    //Peticion por ajax para obtener la paridad del diario oficial
}
/**Actualiza la tasa de acuerdo al impuesto seleccionado*/
function UpdateTasaImp() {
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
                intIdTasaVta1 = objTasaSel.value;
                dblTasaVta1 = obj.getAttribute('Tasa1');
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
function UpdateTasaImp2() {
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
                intIdTasaVta2 = objTasaSel.value;
                dblTasaVta2 = obj.getAttribute('Tasa2');
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Impuestos 2:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**Actualiza la tasa de acuerdo al impuesto seleccionado*/
function UpdateTasaImp3() {
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
                intIdTasaVta3 = objTasaSel.value;
                dblTasaVta3 = obj.getAttribute('Tasa3');
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Impuestos 3:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

/**Validamos campos obligatorios MABE*/
function ValidaMABE() {
    var bolPasa = true;
    if (document.getElementById("MB_CODIGOPROVEEDOR").value == "0" ||
            document.getElementById("MB_CODIGOPROVEEDOR").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("MB_PLANTA").value == "0" ||
            document.getElementById("MB_PLANTA").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("MB_CALLE").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("MB_NO_EXT").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("MB_ORDENCOMPRA").value == "0" ||
            document.getElementById("MB_ORDENCOMPRA").value == "") {
        bolPasa = false;
    }
    return bolPasa;
}

/**Validamos campos obligatorios SANOFI*/
function ValidaSANOFI() {
    var bolPasa = true;
    if (document.getElementById("SNF_ODC_SP1").checked) {
        document.getElementById("SNF_NUM_ODC").parentNode.parentNode.style.display = "block";
        document.getElementById("SNF_NUM_SOL").parentNode.parentNode.style.display = "block";
        document.getElementById("SNF_CUENTA_PUENTE").parentNode.parentNode.style.display = "none";
        if (document.getElementById("SNF_NUM_ODC").value == "") {
            bolPasa = false;
        }
        if (document.getElementById("SNF_NUM_PROV").value == "") {
            bolPasa = false;
        }
    }
    if (document.getElementById("SNF_ODC_SP2").checked) {
        document.getElementById("SNF_NUM_SOL").parentNode.parentNode.style.display = "block";
        document.getElementById("SNF_CUENTA_PUENTE").parentNode.parentNode.style.display = "block";
        document.getElementById("SNF_NUM_ODC").parentNode.parentNode.style.display = "none";
        if (document.getElementById("SNF_NUM_SOL").value == "") {
            bolPasa = false;
        }
        if (document.getElementById("SNF_CUENTA_PUENTE").value == "") {
            bolPasa = false;
        }
        if (document.getElementById("SNF_NUM_PROV").value == "") {
            bolPasa = false;
        }
    }
    return bolPasa;
}

/**Validamos campos obligatorios AMECE*/
function ValidaAMECE() {
    var bolPasa = true;
    if (document.getElementById("HM_ON").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("HM_DIV").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("HM_SOC").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("HM_REFERENCEDATE").value == "") {
        bolPasa = false;
    }
    if (document.getElementById("HM_REFERENCEDATE").value.length != 10) {
        bolPasa = false;
    }
    return bolPasa;
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
/**Selecciona el primer regimen fiscal*/
function SelRegDefa() {
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
/**Modifica la cantidad pedida en la factura*/
function VtaModificaCant() {
    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        //Abrimos pop Up para mostrar la cantidad
        var lstRow = grid.getRowData(id);
        document.getElementById("Operac").value = "CHANGE_CANTPD";
        $("#SioNO").dialog('option', 'title', lstMsg[132]);
        var div = document.getElementById("SioNO_inside");
        var strHtml = CreaTexto(lstMsg[89], "_NvoCant", lstRow.FACD_CANTIDAD, 10, 10, true, false, "", "left", 0, "", "", "", false, 1);
        div.innerHTML = strHtml;
        $("#SioNO").dialog("open");
    }
}
/**Ejecuta la modificacion de la cantidad por recibir*/
function VtaModificaCantDo() {
    var grid = jQuery("#FAC_GRID");
    var id = grid.getGridParam("selrow");
    if (id != null) {
        //Actualiza la cantidad confirmadoa
        var lstRow = grid.getRowData(id);
        //Validamos que no pongan mas cantidad que la surtida fisicamente
        if (parseFloat(document.getElementById("_NvoCant").value) == 0) {
            alert(lstMsg[134]);
        } else {
            lstRow.FACD_CANTIDAD = document.getElementById("_NvoCant").value;
            //Validamos existencias en caso de que aplique
            if (lstRow.FACD_REQEXIST == 1 &&
                    document.getElementById("FAC_TIPO").value != 3) {
                if (parseFloat(lstRow.FACD_CANTIDAD) > parseFloat(lstRow.FACD_EXIST)) {
                    alert(lstMsg[3] + " " + lstRow.FACD_CVE + " " + lstMsg[4]);
                    if (parseFloat(lstRow.FACD_EXIST) > 0) {
                        lstRow.FACD_CANTIDAD = lstRow.FACD_EXIST;
                    } else {
                        lstRow.FACD_CANTIDAD = 0;
                    }
                }
            }
            //Actualizamos los importes
            lstRowChangePrecio(lstRow, id, grid);
        }
    }
}
/**Funcion para cambiar el descuento global*/
function CambioDescGlobal() {
    var grid = jQuery("#FAC_GRID");
    var arr = grid.getDataIDs();
    for (var i = 0; i < arr.length; i++) {
        var id = arr[i];
        var lstRowAct = grid.getRowData(id);
        //Actualizamods el importe
        lstRowChangePrecio(lstRowAct, id, grid);
    }
}

function EvalProdEvt(event, obj) {
    if (event.keyCode == 13) {
        EvalProd();
    }
}
/**Evalua si el item capturado es valido y obtiene su descripcion*/
function EvalProd() {
    var strCod = UCase(d.getElementById("FAC_PROD").value);
    //Validamos que hallan capturado un codigo
    if (trim(strCod) != "") {
        var bolNvo = true;
        var strDesc = "";
        //Revisamos si existe el item en el grid
        var grid = jQuery("#FAC_GRID");
        var arr = grid.getDataIDs();
        for (var i = 0; i < arr.length; i++) {
            var id = arr[i];
            var lstRowAct = grid.getRowData(id);
            if (lstRowAct.FACD_CVE == strCod ||
                    lstRowAct.FACD_CODBARRAS == strCod) {
                bolNvo = false;
                strDesc = lstRowAct.FACD_DESCRIPCION;
                break;
            }
        }
        //Validamos si es un producto nuevo
        if (bolNvo) {
            $("#dialogWait").dialog("open");
            $.ajax({
                type: "POST",
                data: encodeURI("PR_CODIGO=" + strCod + "&SC_ID=" + d.getElementById("SC_ID").value),
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "VtasMov.do?id=5",
                success: function (datoVal) {
                    var objProd = datoVal.getElementsByTagName("vta_productos")[0];
                    var Pr_Id = 0;
                    if (objProd != undefined) {
                        Pr_Id = objProd.getAttribute('PR_ID');
                        d.getElementById("FAC_DESC").value = objProd.getAttribute('PR_DESCRIPCION');
                        $("#dialogWait").dialog("close");
                        //Reemplazamos el codigo del producto por el de la bd
                        if (Pr_Id != 0) {
                            strCod = objProd.getAttribute('PR_CODIGO');
                        }
                    }
                    //Validamos si nos regreso un ID de producto valido
                    if (Pr_Id == 0) {
                        alert(lstMsg[0]);
                        document.getElementById("FAC_PROD").focus();
                        $("#dialogWait").dialog("close");
                    } else {
                        d.getElementById("FAC_CANT").focus();
                        d.getElementById("FAC_CANT").select();
                    }
                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":g:" + objeto + " " + quepaso + " " + otroobj);
                    $("#dialogWait").dialog("close");
                }
            });

        } else {
            d.getElementById("FAC_DESC").value = strDesc;
            d.getElementById("FAC_CANT").focus();
            d.getElementById("FAC_CANT").select();
        }
        //Fin validacion si capturaron un codigo
    }
}
/***OFERTAS Y PROMOCIONES**/
function _EvalPromociones() {
    if (intSucOfertas) {
        _LoadOfertasPromociones()
    }
}
/**Carga de libreria de ofertas y regalos*/
function _LoadOfertasPromociones() {
    var _countTimePromoLoadJs = 0;
    var strScript = "if(vta_promociones){return true}else{return false}";
    var strFn = new Function(strScript);
    try {
        if (strFn()) {
            _InitPromociones();
        }
    } catch (err) {
        // not loaded yet
        if (_countTimePromoLoadJs == 0)
            importa("javascript/vta_promociones.js");
        var delay = 1;
        setTimeout("_LoadOfertasPromociones();", delay * 1000);
    }
}
/*Si esta activo el motor de promociones carga las variables del cliente*/
function _PromocionCte() {
    if (intSucOfertas && bolCargaPromociones) {
        _CargaVarsCte();
    }
}
/*Si esta activo el motor de promociones carga las variables del producto*/
function _PromocionProd(idItem) {
    if (intSucOfertas && bolCargaPromociones) {
        //Obtenemos los valores del elemento
        var gridD = jQuery("#FAC_GRID");
        _LimpiaRegalosPromos(gridD);
        var lstRow = gridD.getRowData(idItem);
        _CargaVarsProd(lstRow);
        setSum();
    } else {
        setSum();
    }
}
/*Si esta activo el motor de promociones carga las variables de los totales*/
function _PromocionTot(bolPromosExec) {
    if (bolPromosExec) {
        //Validamos si procede
        if (intSucOfertas && bolCargaPromociones) {
            var grid = jQuery("#FAC_GRID");
            var arr = grid.getDataIDs();
            if (arr.length > 0) {
                //Cargamos las variables de los totales
                _CargaVarsTot("_PromocionFormulas();");
            } else {
                //Resetamos las variables de producto
                _ResetVarsProd();
            }

        }
    }

}
/*Si esta activo el motor de promociones calcula la formula*/
function _PromocionFormulas() {
    if (intSucOfertas && bolCargaPromociones) {
        _CargaCalculaFormulas(2);
    }
}
/**Imprime el log para debuguear el programa de facturacion*/
function _LogVentas1(strMsg) {
    if (navigator.userAgent.indexOf("Firefox")) {
        console.log(strMsg)
    } else {
        alert(strMsg);
    }
}
/**Limpia la aplicacion de ofertas*/
function _ResetPromosAll() {
    if (intSucOfertas && bolCargaPromociones) {
        _ResetVarsAll();
    }
}

/**Funcion para pintar campos para seleccionar el numero de serie*/
function _drawScNoSerie(objProd, Pr_Id, Ct_Id, intCantidad, strCod, dblExist, intDevo, idProd, strSeries) {
    _objProdTmpz = objProd;
    if (strSeries == null)
        strSeries = "";

    $.ajax({
        type: "POST",
        data: "PR_ID=" + Pr_Id,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "InvMov.do?id=21",
        success: function (datos) {
            var objCodBar = datos.getElementsByTagName("num_series")[0];
            var lstProd = objCodBar.getElementsByTagName("serie");
            var strOptionSelect = "";
            for (i = 0; i < lstProd.length; i++) {
                var obj = lstProd[i];
                strOptionSelect += "<option value='" + obj.getAttribute("NO_SERIE") + "'>" + obj.getAttribute("NO_SERIE") + "</option>";
            }
            //Abrimos un cuadro de dialogo y dibujamos en el los items
            // por capturar el codigo de barras
            $("#dialog2").dialog("open");
            $('#dialog2').dialog('option', 'title', lstMsg[107]);
            var strHTML = "<input type='hidden' id='_Pr_Id' value='" + Pr_Id + "'>";
            strHTML += "<input type='hidden' id='_Ct_Id' value='" + Ct_Id + "'>";
            strHTML += "<input type='hidden' id='_Cantidad' value='" + intCantidad + "'>";
            strHTML += "<input type='hidden' id='_strCod' value='" + strCod + "'>";
            strHTML += "<input type='hidden' id='_dblExist' value='" + dblExist + "'>";
            strHTML += "<input type='hidden' id='_intDevo' value='" + intDevo + "'>";
            strHTML += "<input type='hidden' id='_idProd' value='" + idProd + "'>";
            strHTML += "<table border=0 cellpadding=0>";

            strHTML += "<tr>";
            strHTML += "<td colspan=3>" + lstMsg[110] + "</td>";
            strHTML += "</tr>";
            strHTML += "<tr>";
            strHTML += "<td nowrap>&nbsp;" + lstMsg[172] + "<input type='text' id='search_cant' value='" + intCantidad + "' size='8' readonly disabled></td>";
            strHTML += "<td nowrap>&nbsp;</td>";
            strHTML += "<td nowrap>&nbsp;" + lstMsg[173] + "<input type='text' id='search_cant_sel' value='0' size='8' readonly disabled></td>";
            strHTML += "</tr>";
            strHTML += "<tr>";
            strHTML += "<td >" + lstMsg[174] + "<br><select id='series_origen' multiple>" + strOptionSelect + "</select></td>";
            strHTML += "<td ><input type='button' id='Agregar' value='" + lstMsg[176] + "' onclick='AgregaSerieX()'><br><input type='button' id='Quitar' value='" + lstMsg[177] + "' onClick='RemueveSerieX()'></td>";
            strHTML += "<td >" + lstMsg[175] + "<br><select id='series_destino' multiple ></select></td>";
            strHTML += "</tr>";

            strHTML += "<tr>";
            strHTML += "<td>" + CreaBoton("", "ConfirmNoSerie1", lstMsg[111], "ConfirmNumSerie();", "left", false, false) + "</td>";
            strHTML += "<td>&nbsp;</td>";
            strHTML += "<td>" + CreaBoton("", "CancelNoSerie2", lstMsg[112], "CancelNumSerie();", "left", false, false) + "</td>";
            strHTML += "</tr>"
            strHTML += "</table>";
            document.getElementById("dialog2_inside").innerHTML = strHTML;
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Series pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}
/**Agrega numeros de serie seleccionados  */
function AgregaSerieX() {
    var objSelOr = document.getElementById("series_origen");
    var objSelDest = document.getElementById("series_destino");
//   var lstSeriesXc = Array();
//   var intConta = -1;
    var intXSurtir = parseInt(document.getElementById("search_cant").value);
    var intSurtido = parseInt(document.getElementById("search_cant_sel").value);

    for (var x = 0; x < objSelOr.length; x++) {
        if (objSelOr[x].selected) {
            //Evaluamos si disponemos de espacio
            if (objSelDest.length + 1 <= intXSurtir) {
//               intConta++;
//               lstSeriesXc[intConta] = objSelOr[x].value;  
                intSurtido++;
                document.getElementById("search_cant_sel").value = intSurtido;
                select_add(objSelDest, objSelOr[x].value, objSelOr[x].value);
                objSelOr.remove(x);
            } else {
                alert(lstMsg[178]);
            }
        }
    }
}
/**Quita los elementos del listado de numeros de serie seleccionados*/
function RemueveSerieX() {
    var objSelOr = document.getElementById("series_origen");
    var objSelDest = document.getElementById("series_destino");
    var intSurtido = parseInt(document.getElementById("search_cant_sel").value);

    for (var x = 0; x < objSelDest.length; x++) {
        if (objSelDest[x].selected) {
            intSurtido--;
            document.getElementById("search_cant_sel").value = intSurtido;
            select_add(objSelOr, objSelDest[x].value, objSelDest[x].value);
            objSelDest.remove(x);

        }
    }
}
/**Confirma los numeros de serie*/
function ConfirmNumSerie() {
    var intXSurtir = parseInt(document.getElementById("search_cant").value);
    var intSurtido = parseInt(document.getElementById("search_cant_sel").value);
    if (intXSurtir == intSurtido) {
        var _Pr_Id = document.getElementById("_Pr_Id").value;
        var _Ct_Id = document.getElementById("_Ct_Id").value;
        var _Cantidad = document.getElementById("_Cantidad").value;
        var _strCod = document.getElementById("_strCod").value;
        var _dblExist = document.getElementById("_dblExist").value;
        var _intDevo = document.getElementById("_intDevo").value;
        var _idProd = document.getElementById("_idProd").value;
        var objSelDest = document.getElementById("series_destino");
        //Armamos cadena con numeros de serie
        var _strSeries = "";
        for (var x = 0; x < objSelDest.length; x++) {
            _strSeries += objSelDest[x].value + ",";
        }
        $("#dialog2").dialog("close");
        //Validamos si es modificacion o un nuevo item
        if (_objProdTmpz != null) {
            AddItemPrec(_objProdTmpz, _Pr_Id, _Ct_Id, _Cantidad, _strCod, _dblExist, _intDevo, _strSeries);
        } else {
            //Modificacion
            //Recuperamos los valores del producto
            var gridD = jQuery("#FAC_GRID");
            var lstRow = gridD.getRowData(_idProd);
            //Recalculamos la cantidad
            lstRow.FACD_CANTIDAD = parseFloat(lstRow.FACD_CANTIDAD) + parseFloat(_Cantidad);
            lstRow.FACD_NOSERIE = lstRow.FACD_NOSERIE + _strSeries;
            lstRow.FACD_SERIES = lstRow.FACD_SERIES + _strSeries;
            //Validamos existencias en caso de que aplique
            if (lstRow.FACD_REQEXIST == 1 &&
                    document.getElementById("FAC_TIPO").value != 3) {
                if (parseFloat(lstRow.FACD_CANTIDAD) > parseFloat(lstRow.FACD_EXIST)) {
                    alert(lstMsg[3] + " " + lstRow.FACD_CVE + " " + lstMsg[4]);
                    if (parseFloat(lstRow.FACD_EXIST) > 0) {
                        lstRow.FACD_CANTIDAD = lstRow.FACD_EXIST;
                    } else {
                        lstRow.FACD_CANTIDAD = 0;
                    }
                }
            }
            //Recalculamos el importe y actualizamos la fila
            lstRowChangePrecio(lstRow, _idProd, gridD);
            //Ponemos foco en el control
            document.getElementById("FAC_PROD").value = "";
            document.getElementById("FAC_PROD").focus();
            d.getElementById("FAC_CANT").value = 1;
            d.getElementById("FAC_DEVO").value = 0;
            //Sumamos todos los items
            //setSum();
            //_PromocionProd(idProd);
            $("#dialogWait").dialog("close");
            //Producto sin numero de serie
        }

    } else {
        alert(lstMsg[179]);
    }
}
/**Cancela la captura de numeros de serie*/
function CancelNumSerie() {
    $("#dialog2").dialog("close");
    _objProdTmpz = null;
}
//Parrila de captura
function clickVentana()
{
    $("#dialogPCaptura").dialog("open");
    $('#dialogPCaptura').dialog('option', 'title', "PARRILLA DE CAPTURA");
    var strHTML = "<td>Capture el modelo o clave corta:<input type='text' id = 'txtModelo'>";
    strHTML += "<td>" + CreaBoton("", "btnAgregar", "Agregar", "BuscaModelo();", "left", false, false);
    strHTML += "<div id='TablaP'>";
    strHTML += "</div>";
    strHTML += "Total de Piezas:<input type='text' id = 'TotalP' value='0.0' disabled>";
    strHTML += "<p><input type='hidden' id = 'TotalM' value='0.0' disabled></p>";
    strHTML += "<p><input type='hidden' id = 'Descuento' value='0.0' onBlur='CalculaValores()'></p>";
    strHTML += "<p><input type='hidden' id = 'TotalSinIva' value='0.0' disabled></p>";
    strHTML += "<p><input type='hidden' id = 'IVA' value='0.0' disabled></p>";
    strHTML += "<p><input type='hidden' id = 'TotalaPagar' value='0.0' disabled></p>";

    //    strHTML += "<table border='1'>";
    //    strHTML += "<tr>";
    //    strHTML += "<td>Linea</td>";
    //    strHTML += "<td>Marca</td>";
    //    strHTML += "<td>Modelo</td>";
    //    strHTML += "<td>Tallas</td>";
    //    strHTML += "<td>Precio Publico</td>";
    //    strHTML += "<td>Ch / Uni</td>";
    //    strHTML += "<td>2 / m</td>";
    //    strHTML += "</tr>";
    //    strHTML += "</table>";
    strHTML += "<td>" + CreaBoton("", "btnAceptar", "Aceptar", "AceptarBoton();", "left", false, false);
    strHTML += "<td>&nbsp;</td>";
    strHTML += "<td>" + CreaBoton("", "btnCancelar", "Cancelar", "CancelarBoton();", "left", false, false);
    document.getElementById("dialogPCaptura_inside").innerHTML = strHTML;



}

function BuscaModelo()
{

    var strPOST = "strSC_ID=" + document.getElementById("SC_ID").value;
    strPOST += "&Modelo=" + document.getElementById("txtModelo").value
    //alert("Se encuentra en Construccion");
    $.ajax({
        type: "POST",
        data: strPOST,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=24",
        success: function (datos) {
            var objCodBar = datos.getElementsByTagName("Productos")[0];
            var lstProd = objCodBar.getElementsByTagName("Producto");
            if (objTabla == null)
            {
                var divMaster = document.getElementById("TablaP");
                objTabla = new ctrlTabla(divMaster, 1, 0, 0, "", "Mitabla");
                objTabla.CreaTabla();

                var objFila = objTabla.AnadeFila("", "", "", "");
                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido("Linea");
                //            
                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido("Marca");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("Modelo");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("Descripcion");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("Color");

                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido("Tallas");
                //                
                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido("P. Publico");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("2/CH");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("4/M");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("6/G");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("8/EG");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("10/3M");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("12/6M");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("14/12M");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("16/18M");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("18/24M");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("UNI");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido("Piezas");

                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido("TOTAL");
            }




            for (var i = 0; i < lstProd.length; i++, idT++) {
                var obj = lstProd[i];
                var objFila = objTabla.AnadeFila("", "", "", "");

                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido(obj.getAttribute("Linea"));
                //                
                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido(obj.getAttribute("Marca"));

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idModelo" + idT, "text", 10, obj.getAttribute("Modelo"), 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                objCelda.AnadeCeldaContenido(obj.getAttribute("Descripcion"));



                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idColor" + idT, "text", 10, obj.getAttribute("Color"), 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido(obj.getAttribute("Tallas"));
                //                
                //                
                //                var objCelda = objFila.AnadeCelda("","","","");
                //                var objControl = new Control("idPP"+idT,"text",10,obj.getAttribute("P.Publico"),8,"",false,true);
                //                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idCH" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idM" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idG" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idXG" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idRN" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("id3M" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("id6M" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("id12M" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("id18M" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("id24M" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());


                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idPiezas" + idT, "text", 10, "0", 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                //                var objCelda = objFila.AnadeCelda("","","","");
                //                objCelda.AnadeCeldaContenido(obj.getAttribute("Piezas"));

                //                var objCelda = objFila.AnadeCelda("","","","");
                //                var objControl = new Control("idTOTAL"+idT,"text",10,"0.0",8,"Recalculo()",true,true);
                //                objCelda.AnadeCeldaControl(objControl.CreaControl());

                //Habilitamos las casillas tallas que tiene disponible en ese color
                var lstTallas = obj.getAttribute("Tallas").split(",");

                var objCelda = objFila.AnadeCelda("", "", "", "");
                var objControl = new Control("idTallas" + idT, "hidden", 10, lstTallas, 8, "Recalculo()", false, true);
                objCelda.AnadeCeldaControl(objControl.CreaControl());

                //alert(lstTallas +":"+lstTallas.length);
                for (var j = 0; j < lstTallas.length; j++)
                {
                    var strTalla = lstTallas[j].toUpperCase();
                    strTalla = strTalla.replace(" ", "");
                    switch (strTalla)
                    {
                        case "2":
                        case "CH":
                            document.getElementById("idCH" + idT).disabled = false;
                            break;
                        case "4":
                        case "M":
                            document.getElementById("idM" + idT).disabled = false;
                            break;
                        case "6":
                        case "G":
                            document.getElementById("idG" + idT).disabled = false;
                            break;
                        case "8":
                        case "EG":
                            document.getElementById("idXG" + idT).disabled = false;
                            break;
                        case "10":
                        case "3M":
                            document.getElementById("idRN" + idT).disabled = false;
                            break;
                        case "12":
                        case "6M":
                            document.getElementById("id3M" + idT).disabled = false;
                            break;
                        case "14":
                        case "12M":
                            document.getElementById("id6M" + idT).disabled = false;
                            break;
                        case "16":
                        case "18M":
                            document.getElementById("id12M" + idT).disabled = false;
                            break;
                        case "18":
                        case "24M":
                            document.getElementById("id18M" + idT).disabled = false;
                            break;
                        case "UNI":
                            document.getElementById("id24M" + idT).disabled = false;
                            break;
                    }
                }
            }
            //numFilas=Mitabla.rows.length;
            numFilas = idT;
            document.getElementById("txtModelo").value = "";
            document.getElementById("txtModelo").focus();


            //Abrimos un cuadro de dialogo y dibujamos en el los items
            // por capturar el codigo de barras

        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Series pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });

}

function AceptarBoton()
{
    var strNombreCorto = "";
    var strColor = "";
    var strTalla = "";
    var strTalla2 = "";
    var strCantidad = "";
    for (var i = 0; i < numFilas; i++)
    {
        if (document.getElementById("idCH" + i).value != 0)
        {
            //alert("Entre UNI");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("idCH" + i).value + ",";
            strTalla += "2,";
            strTalla2 += "CH,";
        }
        if (document.getElementById("idM" + i).value != 0)
        {
            //alert("Entre M");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("idM" + i).value + ",";
            strTalla += "4,";
            strTalla2 += "M,";
        }
        if (document.getElementById("idG" + i).value != 0)
        {
            //alert("Entre G");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("idG" + i).value + ",";
            strTalla += "6,";
            strTalla2 += "G,";
        }
        if (document.getElementById("idXG" + i).value != 0)
        {
            //alert("Entre EG");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("idXG" + i).value + ",";
            strTalla += "8,";
            strTalla2 += "EG,";
        }
        if (document.getElementById("idRN" + i).value != 0)
        {
            //alert("Entre RN");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("idRN" + i).value + ",";
            strTalla += "10,";
            strTalla2 += "3M,";
        }
        if (document.getElementById("id3M" + i).value != 0)
        {
            //alert("Entre 3M");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("id3M" + i).value + ",";
            strTalla += "12,";
            strTalla2 += "6M,";
        }
        if (document.getElementById("id6M" + i).value != 0)
        {
            //alert("Entre 6M");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("id6M" + i).value + ",";
            strTalla += "14,";
            strTalla2 += "12M,";
        }
        if (document.getElementById("id12M" + i).value != 0)
        {
            //alert("Entre 12M");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("id12M" + i).value + ",";
            strTalla += "16,";
            strTalla2 += "18M,";
        }
        if (document.getElementById("id18M" + i).value != 0)
        {
            //alert("Entre 18M");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("id18M" + i).value + ",";
            strTalla += "18,";
            strTalla2 += "24M,";
        }

        if (document.getElementById("id24M" + i).value != 0)
        {
            //alert("Entre 24M");
            strNombreCorto += document.getElementById("idModelo" + i).value + ",";
            strColor += document.getElementById("idColor" + i).value + ",";
            strCantidad += document.getElementById("id24M" + i).value + ",";
            strTalla += "UNI,";
            strTalla2 += "UNI,";
        }
    }
    var strListaPrecio = document.getElementById("FCT_LPRECIOS").value;
    var strAlmacen = document.getElementById("SC_ID").value;
    var strPOST = "&NombreCorto=" + strNombreCorto;
    strPOST += "&Colores=" + strColor;
    strPOST += "&Tallas=" + strTalla;
    strPOST += "&Tallas2=" + strTalla2;
    strPOST += "&Cantidad=" + strCantidad;
    strPOST += "&LPrecios=" + strListaPrecio;
    strPOST += "&SC_ID=" + strAlmacen;
    $.ajax({
        type: "POST",
        data: strPOST,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=26",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("ElementosT")[0];
            var lstElementos = lstXml.getElementsByTagName("ElementoT");
            var bolFind = false;
            for (var i = 0; i < lstElementos.length; i++) {

                var obj2 = lstElementos[i];
                var objImportes = new _ImporteVta();
                objImportes.dblCantidad = parseFloat(obj2.getAttribute('CANTIDAD'));
                //Aqui hacemos las validaciones o conversiones dependiendo de la moneda
                var dblPrecio = obj2.getAttribute('PRECIO');
                objImportes.dblPuntos = parseFloat(obj2.getAttribute('PP_PUNTOS'));
                objImportes.dblVNegocio = parseFloat(obj2.getAttribute('PP_NEGOCIO'));
                objImportes.dblPrecio = parseFloat(dblPrecio);
                objImportes.dblPrecioReal = parseFloat(dblPrecio);
                objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
                objImportes.dblExento1 = obj2.getAttribute('PR_EXENTO1');
                objImportes.dblExento2 = obj2.getAttribute('PR_EXENTO2');
                objImportes.dblExento3 = obj2.getAttribute('PR_EXENTO3');
                objImportes.intDevo = 0;

                if (parseInt(obj2.getAttribute('PP_APDESC')) == 0)
                    objImportes.bolAplicDescPrec = false;
                if (parseInt(obj2.getAttribute('PP_APDESCPTO')) == 0)
                    objImportes.bolAplicDescPto = false;
                if (parseInt(obj2.getAttribute('PP_APDESCNEGO')) == 0)
                    objImportes.bolAplicDescVNego = false;
                //if(lstRow.FACD_DESC_LEAL == 0)objImportes.bolAplicDescPrec= false;
                //Evaluamos si aplican los puntos y valor negocio de multinivel
                var bolAplicaMLM = true;
                if (document.getElementById("FAC_ES_MLM1") != null && document.getElementById("FAC_ES_MLM2") != null) {
                    if (document.getElementById("FAC_ES_MLM2").checked)
                        bolAplicaMLM = false;
                }
                objImportes.bolUsoMLM = bolAplicaMLM;
                //Evaluamos si aplican los puntos y valor negocio de multinivel
                objImportes.CalculaImporte();
                var dblDescuento = objImportes.dblImporteDescuento;
                var dblImporte = objImportes.dblImporte;
                var datarow = {
                    FACD_ID: 0,
                    FACD_CANTIDAD: parseFloat(obj2.getAttribute('CANTIDAD')),
                    FACD_DESCRIPCION: obj2.getAttribute('PR_DESCRIPCION'),
                    FACD_IMPORTE: dblImporte,
                    FACD_CVE: obj2.getAttribute('PR_CODIGO'),
                    FACD_PRECIO: dblPrecio,
                    FACD_TASAIVA1: dblTasaVta1,
                    FACD_TASAIVA2: dblTasaVta2,
                    FACD_TASAIVA3: dblTasaVta3,
                    FACD_DESGLOSA1: 1,
                    FACD_IMPUESTO1: objImportes.dblImpuesto1,
                    FACD_PR_ID: obj2.getAttribute('PR_ID'),
                    FACD_EXENTO1: obj2.getAttribute('PR_EXENTO1'),
                    FACD_EXENTO2: obj2.getAttribute('PR_EXENTO2'),
                    FACD_EXENTO3: obj2.getAttribute('PR_EXENTO3'),
                    FACD_REQEXIST: obj2.getAttribute('PR_REQEXIST'),
                    FACD_EXIST: obj2.getAttribute('PR_EXISTENCIA'),
                    FACD_NOSERIE: "",
                    FACD_ESREGALO: 0,
                    FACD_IMPORTEREAL: dblImporte,
                    FACD_PRECREAL: dblPrecio,
                    FACD_DESCUENTO: dblDescuento,
                    FACD_PORDESC: objImportes.dblPorcAplica,
                    FACD_PRECFIJO: 0,
                    FACD_ESDEVO: 0,
                    FACD_CODBARRAS: obj2.getAttribute('PR_CODBARRAS'),
                    FACD_NOTAS: "",
                    FACD_RET_ISR: intRET_ISR,
                    FACD_RET_IVA: intRET_IVA,
                    FACD_RET_FLETE: intRET_FLETE,
                    FACD_UNIDAD_MEDIDA: obj2.getAttribute('PR_UNIDADMEDIDA'),
                    FACD_PUNTOS_U: objImportes.dblPuntos,
                    FACD_NEGOCIO_U: objImportes.dblVNegocio,
                    FACD_PUNTOS: objImportes.dblPuntosImporte,
                    FACD_NEGOCIO: objImportes.dblVNegocioImporte,
                    FACD_PR_CAT1: obj2.getAttribute('PR_CATEGORIA1'),
                    FACD_PR_CAT2: obj2.getAttribute('PR_CATEGORIA2'),
                    FACD_PR_CAT3: obj2.getAttribute('PR_CATEGORIA3'),
                    FACD_PR_CAT4: obj2.getAttribute('PR_CATEGORIA4'),
                    FACD_PR_CAT5: obj2.getAttribute('PR_CATEGORIA5'),
                    FACD_PR_CAT6: obj2.getAttribute('PR_CATEGORIA6'),
                    FACD_PR_CAT7: obj2.getAttribute('PR_CATEGORIA7'),
                    FACD_PR_CAT8: obj2.getAttribute('PR_CATEGORIA8'),
                    FACD_PR_CAT9: obj2.getAttribute('PR_CATEGORIA9'),
                    FACD_PR_CAT10: obj2.getAttribute('PR_CATEGORIA10'),
                    FACD_DESC_ORI: 0,
                    FACD_REGALO: 0,
                    FACD_ID_PROMO: 0,
                    FACD_DESC_PREC: parseInt(obj2.getAttribute('PP_APDESC')),
                    FACD_DESC_PTO: parseInt(obj2.getAttribute('PP_APDESCPTO')),
                    FACD_DESC_VN: parseInt(obj2.getAttribute('PP_APDESCNEGO')),
                    FACD_DESC_LEAL: parseInt(obj2.getAttribute('PP_APDESCNEGO')),
                    FACD_USA_SERIE: obj2.getAttribute('PR_USO_NOSERIE'),
                    FACD_SERIES: "",
                    FACD_SERIES_MPD: "",
                    FACD_SERIES_O: "",
                    FACD_SERIES_MPD_O: ""
                };
                //Anexamos el registro al GRID
                itemId++;
                jQuery("#FAC_GRID").addRowData(itemId, datarow, "last");
                d.getElementById("FAC_PRECIO").value = dblPrecio;
                d.getElementById("FAC_PROD").value = "";
                d.getElementById("FAC_PROD").focus();
                d.getElementById("FAC_CANT").value = 1;
                d.getElementById("FAC_DEVO").value = 0;
                bolFind = true;
                //Sumamos todos los items
                _PromocionProd(itemId);
                //Validamos el cambio de sucursal
                EvalSucursal();


            }
            //Validamos si no nos devolvieron precio es porque el CLIENTE no existe
            if (!bolFind) {
                ObtenNomCte();
            }
            CancelarBoton();
            $("#dialogPCaptura").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Series pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

function CancelarBoton()
{
    $("#dialogPCaptura").dialog("close");
    objTabla = null;
    numFilas = 0;
    idT = 0;
}

function Recalculo()
{
    //alert("Me salir:"+numFilas);
    //    var TotalMoneda = 0.0;
    var TotalP = 0.0;
    for (var i = 0; i < numFilas; i++)
    {
        var TotalPiezas = 0.0;
        //        var TotalMonedaR = 0.0;

        TotalPiezas += parseFloat(document.getElementById("idCH" + i).value);
        TotalPiezas += parseFloat(document.getElementById("idM" + i).value);
        TotalPiezas += parseFloat(document.getElementById("idG" + i).value);
        TotalPiezas += parseFloat(document.getElementById("idXG" + i).value);
        TotalPiezas += parseFloat(document.getElementById("idRN" + i).value);
        TotalPiezas += parseFloat(document.getElementById("id3M" + i).value);
        TotalPiezas += parseFloat(document.getElementById("id6M" + i).value);
        TotalPiezas += parseFloat(document.getElementById("id12M" + i).value);
        TotalPiezas += parseFloat(document.getElementById("id18M" + i).value);
        TotalPiezas += parseFloat(document.getElementById("id24M" + i).value);
        document.getElementById("idPiezas" + i).value = parseFloat(TotalPiezas);
        TotalP += TotalPiezas;
        //        TotalMonedaR = parseFloat(TotalPiezas) * parseFloat(document.getElementById("idPP"+i).value)
        //document.getElementById("idTOTAL"+i).value = TotalMonedaR;
        //        TotalMoneda += TotalMonedaR;

        document.getElementById("TotalP").value = TotalP;
        //        document.getElementById("TotalM").value = TotalMoneda;

        //        CalculaValores();
        //alert(TotalPiezas + ":" +document.getElementById("idPiezas"+i).value);
    }

//alert(document.getElementById(""+id));
}

function CalculaValores()
{
    //Calcula el Total Sin Iva
    var TotalsinIva = 0.0;
    var Descuento = parseFloat(document.getElementById("Descuento").value);
    var Total = parseFloat(document.getElementById("TotalM").value);
    Descuento = Total * (Descuento / 100);

    TotalsinIva = Total - Descuento;
    document.getElementById("TotalSinIva").value = TotalsinIva;
    // Calcula IVA

    var IVA = TotalsinIva * (0.16);
    document.getElementById("IVA").value = IVA;

    //Calculamos el Total a Pagar
    var TotalaPagar = TotalsinIva + IVA;
    document.getElementById("TotalaPagar").value = TotalaPagar;
}



/**Abre el cuadro de dialogo para buscar las direcciones de entrega*/
function OpnDiagDir() {
    OpnOpt('DIR_ENT', null, 'dialogCte', false, false, true);
}

/**Abre el cuadro de dialogo para buscar los subClientes*/
function OpnDiagCtFac() {
    OpnOpt('CTE_FAC', null, 'dialogCte', false, false, true);
}
/**SIRVE PARA OBTENER LAS DIRECCIONES DE ENTREGA**/
function  ObtenDireciones() {
    var bolExist = false;

    //Peticion por ajax para mostrar info
    $.ajax({
        type: "POST",
        data: "ct_id=" + document.getElementById("FCT_ID").value, //id de cliente seleccionado
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "ERP_DireccionesEntrega.jsp?ID=1",
        success: function (datos) {
            var lstDirecciones = datos.getElementsByTagName("Direcciones")[0];
            var lstDireccion = lstDirecciones.getElementsByTagName("direcciones");

            var objDir = document.getElementById("CT_DIRENTREGA");
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
                select_add(objDir, '<--No existen mas Direcciones-->', 0);
            }

        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });

}

function  ObtenClienteFinal() {
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
/**Imprime el ticket directamente a la impresora*/
function ImprimeconFolioTicket(strKey) {
    var strNomFormat = "TICKET1";
    var intOp = 4;
    if (d.getElementById("FAC_TIPO").value == "1") {
        strNomFormat = "FACTURA1";
        intOp = 5;
    }
    if (d.getElementById("FAC_TIPO").value == "3") {
        strNomFormat = "PEDIDO1";
        intOp = 6;
    }

    $.ajax({
        type: "POST",
        data: "ID=" + strKey + "&NOM_FORMATO=" + strNomFormat,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "ERP_Varios.jsp?id=" + intOp,
        success: function (datos) {
            var miapplet = document.getElementById("PrintTickets");
            miapplet.DoImpresion(datos,
                    strCodEscape, strImpresora);
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":ImprimeFolio:" + objeto + " " + quepaso + " " + otroobj);
        }
    });

}



/**Carga la informacion de una operacion de REMISION FACTURA O PEDIDO*/
function getCotizaenVenta(intIdPedido, strTipoVta) {
    //Mandamos la peticion por ajax para que nos den el XML del pedido
    $.ajax({
        type: "POST",
        data: "COT_ID=" + intIdPedido,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "VtasMov.do?id=33",
        success: function (datos) {
            var objCotiza = datos.getElementsByTagName("vta_cotiza")[0];
            var lstdeta = objCotiza.getElementsByTagName("deta");
            //Validamos que sea un pedido correcto
            if (objCotiza.getAttribute('COT_ANULADA') == 0) {
                //No facturado
                if (objCotiza.getAttribute("FAC_ID") == 0 ||
                        (objCotiza.getAttribute("FAC_ID") != 0 && objCotiza.getAttribute('COT_ESRECU') == 1)
                        ) {
                    //No remisionado
                    if (objCotiza.getAttribute("TKT_ID") == 0 ||
                            (objCotiza.getAttribute("TKT_ID") != 0 && objCotiza.getAttribute('COT_ESRECU') == 1)
                            ) {
                        //No remisionado
                        if (objCotiza.getAttribute("PD_ID") == 0 ||
                                (objCotiza.getAttribute("PD_ID") != 0 && objCotiza.getAttribute('COT_ESRECU') == 1)
                                ) {
                            //Limpiamos la operacion actual.
                            ResetOperaActual(false);
                            //Llenamos la pantalla con los valores del bd
                            DrawCotizaenVenta(objCotiza, lstdeta, strTipoVta);
                            $("#dialogView").dialog("close")
                        } else {
                            alert(lstMsg[53]);
                        }

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
            alert(":open cotiza:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**
 *Establece los parametros del pedido original
 **/
function DrawCotizaenVenta(objCotiza, lstdeta, strTipoVta) {
    $("#dialogWait").dialog("open");
    document.getElementById("COT_ID").value = objCotiza.getAttribute('COT_ID');
    if (strTipoVta == "REMISION") {
        MostrarAvisos(lstMsg[242] + objCotiza.getAttribute('COT_ID'))
        document.getElementById("FAC_TIPO").value = 2;
    } else {
        if (strTipoVta == "FACTURA") {
            MostrarAvisos(lstMsg[241] + objCotiza.getAttribute('COT_ID'))
            document.getElementById("FAC_TIPO").value = 1;
        } else {
            if (strTipoVta == "PEDIDO") {
                MostrarAvisos(lstMsg[243] + objCotiza.getAttribute('COT_ID'))
                document.getElementById("FAC_TIPO").value = 3;
            } else {
                MostrarAvisos(lstMsg[244] + objCotiza.getAttribute('COT_ID'))
                document.getElementById("FAC_TIPO").value = 5;
            }
        }
    }
    document.getElementById("FAC_MONEDA").value = objCotiza.getAttribute('COT_MONEDA');
    document.getElementById("FAC_FOLIO").value = objCotiza.getAttribute('COT_FOLIO');
    document.getElementById("SC_ID").value = objCotiza.getAttribute('SC_ID');
    document.getElementById("FCT_ID").value = objCotiza.getAttribute('CT_ID');
    document.getElementById("FAC_NOTAS").value = objCotiza.getAttribute('COT_NOTAS');
    document.getElementById("FAC_NOTASPIE").value = objCotiza.getAttribute('COT_NOTASPIE');
    document.getElementById("FAC_CONDPAGO").value = objCotiza.getAttribute('COT_CONDPAGO');
    document.getElementById("FAC_REFERENCIA").value = objCotiza.getAttribute('COT_REFERENCIA');
    document.getElementById("FAC_NUMPEDI").value = objCotiza.getAttribute('COT_NUMPEDI');
    document.getElementById("FAC_FECHAPEDI").value = objCotiza.getAttribute('COT_FECHAPEDI');
    document.getElementById("FAC_ADUANA").value = objCotiza.getAttribute('COT_ADUANA');
    document.getElementById("FCT_DESCUENTO").value = objCotiza.getAttribute('COT_POR_DESCUENTO');
    if (objCotiza.getAttribute('COT_ESRECU') == 1) {
        document.getElementById("FAC_ESRECU1").checked = true;
    } else {
        document.getElementById("FAC_ESRECU2").checked = false;
    }
    document.getElementById("FAC_PERIODICIDAD").value = objCotiza.getAttribute('COT_PERIODICIDAD');
    document.getElementById("FAC_DIAPER").value = objCotiza.getAttribute('COT_DIAPER');
    document.getElementById("VE_ID").value = objCotiza.getAttribute('VE_ID');
    //Inactivamos la edicion del cliente
    document.getElementById("CT_NOM").readOnly = true;
    document.getElementById("CT_NOM").setAttribute("class", "READONLY");
    document.getElementById("CT_NOM").setAttribute("className", "READONLY");
    document.getElementById("FCT_ID").parentNode.style.display = "none";
    ObtenNomCte(objCotiza, lstdeta, strTipoVta, false, true);
}
/**
 *Llenamos el grid con los datos del pedido
 **/
function DrawCotizaDetaenVenta(objPedido, lstdeta, strTipoVta) {
    //Generamos el detalle
    for (i = 0; i < lstdeta.length; i++) {
        var obj = lstdeta[i];
        var objImportes = new _ImporteVta();
        objImportes.dblCantidad = obj.getAttribute('COTD_CANTIDAD');
        if (parseInt(obj.getAttribute('COTD_EXENTO1')) == 0) {
            objImportes.dblPrecio = parseFloat(obj.getAttribute('COTD_PRECIO')) / (1 + (obj.getAttribute('COTD_TASAIVA1') / 100));
            objImportes.dblPrecioReal = parseFloat(obj.getAttribute('COTD_PRECREAL')) / (1 + (obj.getAttribute('COTD_TASAIVA1') / 100));
        } else {
            objImportes.dblPrecio = parseFloat(obj.getAttribute('COTD_PRECIO'));
            objImportes.dblPrecioReal = parseFloat(obj.getAttribute('COTD_PRECREAL'));
        }
        objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
        objImportes.dblPorcDesc = obj.getAttribute('COTD_PORDESC');
        objImportes.dblExento1 = obj.getAttribute('COTD_EXENTO1');
        objImportes.dblExento2 = obj.getAttribute('COTD_EXENTO2');
        objImportes.dblExento3 = obj.getAttribute('COTD_EXENTO3');
        objImportes.intDevo = 0;
        objImportes.dblPuntos = parseFloat(obj.getAttribute('COTD_PUNTOS'));
        objImportes.dblVNegocio = parseFloat(obj.getAttribute('COTD_VNEGOCIO'));
        //Banderas de descuento
        if (obj.getAttribute('COTD_DESC_PREC') == 0)
            objImportes.bolAplicDescPrec = false;
        if (obj.getAttribute('COTD_DESC_PUNTOS') == 0)
            objImportes.bolAplicDescPto = false;
        if (obj.getAttribute('COTD_DESC_VNEGOCIO') == 0)
            objImportes.bolAplicDescVNego = false;
        //if(lstRow.FACD_DESC_LEAL == 0)objImportes.bolAplicDescPrec= false;
        //Validamos existencias en caso de que aplique
        if (obj.getAttribute('PR_REQEXIST') == 1 &&
                (strTipoVta == "FACTURA" || strTipoVta == "REMISION")) {
            if (parseFloat(objImportes.dblCantidad) > parseFloat(obj.getAttribute('PR_EXISTENCIA'))) {
                alert(lstMsg[3] + " " + obj.getAttribute('COTD_CVE') + " " + lstMsg[4]);
                if (parseFloat(obj.getAttribute('PR_EXISTENCIA')) > 0) {
                    objImportes.dblCantidad = obj.getAttribute('PR_EXISTENCIA');
                } else {
                    objImportes.dblCantidad = 0;
                }
            }
        }
        //Calculamos el importe de la venta
        //Evaluamos si aplican los puntos y valor negocio de multinivel
        var bolAplicaMLM = true;
        if (document.getElementById("FAC_ES_MLM1") != null && document.getElementById("FAC_ES_MLM2") != null) {
            if (document.getElementById("FAC_ES_MLM2").checked)
                bolAplicaMLM = false;
        }
        objImportes.bolUsoMLM = bolAplicaMLM;
        //Evaluamos si aplican los puntos y valor negocio de multinivel
        objImportes.CalculaImporte();
        var dblImporte = objImportes.dblImporte;
        var datarow = {
            FACD_ID: 0,
            FACD_CANTIDAD: objImportes.dblCantidad,
            FACD_CANTPEDIDO: obj.getAttribute('COTD_CANTIDAD'),
            FACD_DESCRIPCION: obj.getAttribute('COTD_DESCRIPCION'),
            FACD_IMPORTE: dblImporte,
            FACD_CVE: obj.getAttribute('COTD_CVE'),
            FACD_PRECIO: objImportes.dblPrecio,
            FACD_TASAIVA1: obj.getAttribute('COTD_TASAIVA1'),
            FACD_TASAIVA2: obj.getAttribute('COTD_TASAIVA2'),
            FACD_TASAIVA3: obj.getAttribute('COTD_TASAIVA3'),
            FACD_DESGLOSA1: 1,
            FACD_IMPUESTO1: objImportes.dblImpuesto1,
            FACD_IMPUESTO2: objImportes.dblImpuesto2,
            FACD_IMPUESTO3: objImportes.dblImpuesto3,
            FACD_PR_ID: obj.getAttribute('PR_ID'),
            FACD_EXENTO1: obj.getAttribute('COTD_EXENTO1'),
            FACD_EXENTO2: obj.getAttribute('COTD_EXENTO2'),
            FACD_EXENTO3: obj.getAttribute('COTD_EXENTO3'),
            FACD_REQEXIST: obj.getAttribute('PR_REQEXIST'),
            FACD_EXIST: obj.getAttribute('PR_EXISTENCIA'),
            FACD_NOSERIE: "",
            FACD_ESREGALO: obj.getAttribute('COTD_ESREGALO'),
            FACD_IMPORTEREAL: objImportes.dblImporteReal,
            FACD_PRECREAL: objImportes.dblPrecioReal,
            FACD_DESCUENTO: obj.getAttribute('COTD_DESCUENTO'),
            FACD_PORDESC: objImportes.dblPorcAplica,
            FACD_PRECFIJO: obj.getAttribute('COTD_PRECFIJO'),
            FACD_ESDEVO: 0,
            FACD_CODBARRAS: obj.getAttribute('PR_CODBARRAS'),
            FACD_NOTAS: obj.getAttribute('COTD_COMENTARIO'),
            FACD_PUNTOS_U: objImportes.dblPuntos,
            FACD_NEGOCIO_U: objImportes.dblVNegocio,
            FACD_PUNTOS: objImportes.dblPuntosImporte,
            FACD_NEGOCIO: objImportes.dblVNegocioImporte,
            FACD_DESC_ORI: obj.getAttribute('COTD_DESC_ORI'),
            FACD_REGALO: obj.getAttribute('COTD_REGALO'),
            FACD_ID_PROMO: obj.getAttribute('COTD_ID_PROMO'),
            FACD_DESC_PREC: obj.getAttribute('COTD_DESC_PREC'),
            FACD_DESC_PTO: obj.getAttribute('COTD_DESC_PUNTOS'),
            FACD_DESC_VN: obj.getAttribute('COTD_DESC_VNEGOCIO'),
            FACD_DESC_LEAL: 0
        };
        //Anexamos el registro al GRID
        jQuery("#FAC_GRID").addRowData(obj.getAttribute('COTD_ID'), datarow, "last");
    }
    //Realizamos la sumatoria
    setSum();
    $("#dialogWait").dialog("close");
}

function inte_carga_info_contrato() {
    var strReferencia = document.getElementById("FAC_REFERENCIA").value;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "CTOA_FOLIO=" + strReferencia,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "ERP_Especiales.jsp?id=2",
        success: function (datoVal) {
            var objCte = datoVal.getElementsByTagName("contrato")[0];
            document.getElementById("FCT_ID").value = objCte.getAttribute('Cliente');
            document.getElementById("FAC_NOTASPIE").value = objCte.getAttribute('Nota');
            ObtenNomCte();
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":Contratos:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}

function SumaImpuestosComer()
{
    var dblAntesIVA = parseFloat(document.getElementById("FAC_IMPORTE").value);
    var dblImpuesto = parseFloat(document.getElementById("FAC_IMPUESTO2").value);
    var dblImpuestoIVA = parseFloat(document.getElementById("FAC_IMPUESTO1").value);
    var dblImpuesto3 = parseFloat(document.getElementById("FAC_IMPUESTO3").value);
    var dblImpuestoIEPS = parseFloat(document.getElementById("FAC_IMPORTE_IEPS").value);
    var dblNvoTotal = dblAntesIVA + dblImpuesto + dblImpuestoIVA + dblImpuestoIEPS + dblImpuesto3;
    document.getElementById("FAC_TOT").value = FormatNumber(dblNvoTotal, intNumdecimal, true);
}