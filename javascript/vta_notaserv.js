
/*
 *Esta libreria realiza todas las operaciones de las notas de credito de servicio
 */
//Variables globales
var itemIdSv = 0;//indice para los items del grid
var bolCambioFechaServ = false;
//Inicializamos impuestos con sucursal default
var dblTasaVtaSv1 = dblTasa1;
var dblTasaVtaSv2 = dblTasa2;
var dblTasaVtaSv3 = dblTasa3;
var intIdTasaVtaSv1 = intIdTasa1;
var intIdTasaVtaSv2 = intIdTasa2;
var intIdTasaVtaSv3 = intIdTasa3;
var intSImpVta1_2Sv = intSImp1_2;
var intSImpVta1_3Sv = intSImp1_3;
var intSImpVta2_3Sv = intSImp2_3;
var intCT_TIPOPERSSv = 0;
var intCT_TIPOFACSv = 0;
var strCT_USOIMBUEBLESv = "";
function vta_notaserv() {//Funcion necesaria para que pueda cargarse la libreria en automatico
}
/**Inicializa la pantalla de punto de venta*/
function InitServNC() {
   $("#dialogWait").dialog("open");
   myLayout.close("west");
   myLayout.close("east");
   myLayout.close("south");
   myLayout.close("north");
   //Ocultamos renglon de avisos
   OcultarAvisosServNC();
   //Ponemos el nombre default de la sucursal
   d.getElementById("SC_ID").value = intSucDefa;
   //Hacemos diferente el estilo del total
   FormStyleServNC();
   //Obtenemos el id del cliente y el vendedor default
   d.getElementById("FCT_ID").value = intCteDefa;
   d.getElementById("NC_OPER").value = strUserName;
   d.getElementById("NC_TASASEL1").value = intIdTasaVtaSv1;
   d.getElementById("NC_DESC").focus();
   ObtenNomCteServNC();
   //Realizamos el menu de botones
   var strHtml = "<ul>" +
           getMenuItem("CallbtnNCServ0();", "Guardar Venta", "images/ptovta/CircleSave.png") +
           getMenuItem("CallbtnNCServ1();", "Nueva Venta", "images/ptovta/VisPlus.png") +
           getMenuItem("CallbtnNCServ2();", "Consultar Venta", "images/ptovta/VisMagnifier.png") +
           getMenuItem("CallbtnNCServ7();", "Borrar Concepto", "images/ptovta/VisClose.png") +
           getMenuItem("CallbtnNCServ9();", "Salir", "images/ptovta/exitBig.png") +
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
      success: function(datos) {
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
            if ($('#NC_FECHA').datepicker("isDisabled")) {
               $('#NC_FECHA').datepicker("enable")
            }
            var objFecha = document.getElementById("NC_FECHA");
            objFecha.setAttribute("class", "outEdit");
            objFecha.setAttribute("className", "outEdit");
            objFecha.readOnly = false;
         } else {
            $('#NC_FECHA').datepicker("disable")
         }
         $("#dialogWait").dialog("close");
         //Foco inicial
         setTimeout("d.getElementById('NC_DESC').focus();", 3000);
         SelRegDefaNCServ();
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
   //Definimos acciones para el dialogo SI/NO
   document.getElementById("btnSI").onclick = function() {
      ConfirmaSINCServ();
   };
   document.getElementById("btnNO").onclick = function() {
      ConfirmaNONCServ();
   };
}
/**Cambia los estilos de algunos controles*/
function FormStyleServNC() {
   d.getElementById("NC_TOT").setAttribute("class", "ui-Total");
   d.getElementById("NC_TOT").setAttribute("className", "ui-Total");
   d.getElementById("btn1").setAttribute("class", "Oculto");
   d.getElementById("btn1").setAttribute("className", "Oculto");
}
/**Obtiene el nombre del cliente al que se le esta haciendo la venta*/
function ObtenNomCteServNC(objPedido, lstdeta, strTipoVta, bolPasaPedido) {
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
      success: function(datoVal) {
         var objCte = datoVal.getElementsByTagName("vta_clientes")[0];
         if (objCte.getAttribute('CT_ID') == 0) {
            document.getElementById("CT_NOM").value = "***************";
            ValidaShow("CT_NOM", lstMsg[28]);
         } else {
            document.getElementById("CT_NOM").value = objCte.getAttribute('CT_RAZONSOCIAL');
            document.getElementById("FCT_LPRECIOS").value = objCte.getAttribute('CT_LPRECIOS');
            document.getElementById("FCT_DESCUENTO").value = objCte.getAttribute('CT_DESCUENTO');
            document.getElementById("FCT_DIASCREDITO").value = objCte.getAttribute('CT_DIASCREDITO');
            document.getElementById("FCT_MONTOCRED").value = objCte.getAttribute('CT_MONTOCRED');
            intCT_TIPOPERSSv = objCte.getAttribute('CT_TIPOPERS');
            intCT_TIPOFACSv = objCte.getAttribute('CT_TIPOFAC');
            strCT_USOIMBUEBLESv = objCte.getAttribute('CT_USOIMBUEBLE');
         }
         //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
         if (bolPasaPedido) {
            DrawPedidoDetaenVentaSrv(objPedido, lstdeta, strTipoVta);
         }
      },
      error: function(objeto, quepaso, otroobj) {
         document.getElementById("CT_NOM").value = "***************";
         ValidaShow("CT_NOM", lstMsg[28]);
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Obtiene el nombre del vendedor al que se le esta haciendo la venta*/
function ObtenNomVendNC() {
   var intVend = document.getElementById("VE_ID").value;
   $.ajax({
      type: "POST",
      data: "VE_ID=" + intVend,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "CIP_TablaOp.jsp?ID=4&opnOpt=VENDEDOR",
      success: function(datoVal) {
         var objVend = datoVal.getElementsByTagName("vta_vendedores")[0];
         document.getElementById("VE_NOM").value = objVend.getAttribute('VE_NOMBRE');
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":pto2:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Funcion para anadir partidas, valida que el producto exista, luego obtiene el precio y lo anade al GRID*/
function AddItemNC() {
   var strConc = UCase(d.getElementById("NC_DESC").value);
   //Validamos que hallan capturado una descripcion
   if (trim(strConc) != "") {
      $("#dialogWait").dialog("open");
      var Ct_Id = d.getElementById("NC_ID").value;
      var strCod = d.getElementById("NC_PROD").value;
      var dblCantidad = d.getElementById("NC_CANT").value;
      var dblExistencia = 0;
      AddItemPrec(null, Ct_Id, dblCantidad, strCod, dblExistencia, 0);
   }
}
/**Vuelva a calcular el precio para una fila del grid*/
function lstRowChangePrecioNC(lstRow, idUpdate, grid) {
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
   setSum();
}
/**Añade una nueva partida al GRID*/
function AddItemPrec(objProd, Ct_Id, Cantidad, strCod, dblExist, intDevo) {
   var dblImporteC = document.getElementById("NC_PRECIO").value;
   var strDesc = document.getElementById("NC_DESC").value;
   var objImportes = new _ImporteVtaNC();
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
      FACD_DESCRIPCION: 'Servicio',
      FACD_IMPORTE: dblImporte,
      FACD_CVE: strCod,
      FACD_PRECIO: dblImporteC,
      FACD_TASAIVA1: dblTasa1,
      FACD_DESGLOSA1: 1,
      FACD_IMPUESTO1: objImportes.dblImpuesto1,
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
      FACD_NOTAS: strDesc
   };
   //Anexamos el registro al GRID
   itemIdSv++;
   jQuery("#NC_GRID").addRowData(itemIdSv, datarow, "last");
   d.getElementById("NC_PROD").value = "";
   d.getElementById("NC_DESC").value = "";
   d.getElementById("NC_PRECIO").value = "0.0";
   d.getElementById("NC_DESC").focus();
   d.getElementById("NC_CANT").value = 1;
   bolFind = true;
   //Sumamos todos los items
   setSumNC();
   //Validamos el cambio de sucursal
   EvalSucursalNC();
   $("#dialogWait").dialog("close");
}
/**Borra el item seleccionado*/
function VtaDropNC() {
   var grid = jQuery("#NC_GRID");
   if (grid.getGridParam("selrow") != null) {
      grid.delRowData(grid.getGridParam("selrow"));
      document.getElementById("NC_DESC").focus();
      //Sumamos todos los items
      setSumNC();
      //Validamos el cambio de sucursal
      EvalSucursalNC();
   }
}
/*Suma todos los items de la venta y nos da el total**/
function setSumNC() {
   var grid = jQuery("#NC_GRID");
   var arr = grid.getDataIDs();
   var dblSuma = 0;
   var dblImpuesto1 = 0;
   var dblImporte = 0;
   for (var i = 0; i < arr.length; i++) {
      var id = arr[i];
      var lstRow = grid.getRowData(id);
      dblSuma += parseFloat(lstRow.FACD_IMPORTE);
      if (parseInt(intCT_TIPOFACSv) == 1) {
         if (strCT_USOIMBUEBLESv == "HABITACIONAL") {
            //
            dblSuma -= parseFloat(lstRow.FACD_IMPUESTO1);
         } else {
            dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO1);
         }
      } else {
         dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO1);
      }
      dblImporte += (parseFloat(lstRow.FACD_IMPORTE) - parseFloat(lstRow.FACD_IMPUESTO1));
   }
   //Anadimos IEPS
   var dblIEPS = 0;
   if (document.getElementById("NC_USO_IEPS1").checked) {
      if (parseFloat(document.getElementById("NC_TASA_IEPS").value) != 0) {
         try {
            dblIEPS = dblImporte * (parseFloat(document.getElementById("NC_TASA_IEPS").value) / 100);
         } catch (err) {
         }
      } else {
         alert(lstMsg[62]);
         document.getElementById("NC_TASA_IEPS").focus();
      }
      //Aumentamos el IVA
      var tax = new Impuestos(dblTasaVtaSv1, dblTasaVtaSv2, dblTasaVtaSv3, intSImpVta1_2Sv, intSImpVta1_3Sv, intSImpVta2_3Sv);//Objeto para calculo de impuestos
      tax.CalculaImpuestoMas(dblIEPS, 0, 0);
      dblImpuesto1 += tax.dblImpuesto1;
      dblSuma += dblIEPS + tax.dblImpuesto1;
   }
   d.getElementById("NC_IMPORTE_IEPS").value = FormatNumber(dblIEPS, intNumdecimal, true);
   d.getElementById("NC_TOT").value = FormatNumber(dblSuma, intNumdecimal, true);
   d.getElementById("NC_IMPUESTO1").value = FormatNumber(dblImpuesto1, intNumdecimal, true);
   d.getElementById("NC_IMPORTE").value = FormatNumber(dblImporte, intNumdecimal, true);
   //Activamos recibos de honorarios si proceden
   /*if(parseInt(intEMP_TIPOPERS) == 2){
    var dblRetIsr = 0;
    var dblRetIVA = 0;
    if(intCT_TIPOPERSSv == 1){
    dblRetIsr = dblImporte * (dblFacRetISR/100);
    dblRetIVA = 0;
    if(dblImpuesto1 > 0){
    dblRetIVA = (dblImpuesto1 / 3) * 2;
    }
    //Exento retencion ISR
    if(parseInt(intEMP_NO_ISR) == 1){
    dblRetIsr = 0;
    }
    //Exento retencion IVA
    if(parseInt(intEMP_NO_IVA) == 1){
    dblRetIVA = 0;
    }
    }
    var dblImpNeto = dblSuma - dblRetIsr - dblRetIVA;
    document.getElementById("NC_RETISR").value = FormatNumber(dblRetIsr,intNumdecimal,true);
    document.getElementById("NC_RETIVA").value = FormatNumber(dblRetIVA,intNumdecimal,true);
    document.getElementById("NC_NETO").value = FormatNumber(dblImpNeto,intNumdecimal,true);
    //Activamos los recibos de honorarios
    document.getElementById("NC_RETISR").parentNode.parentNode.style.display = 'block';
    document.getElementById("NC_RETIVA").parentNode.parentNode.style.display = 'block';
    document.getElementById("NC_NETO").parentNode.parentNode.style.display = 'block';
    }else{*/
   //Activamos los recibos de honorarios
   document.getElementById("NC_RETISR").parentNode.parentNode.style.display = 'none';
   document.getElementById("NC_RETIVA").parentNode.parentNode.style.display = 'none';
   document.getElementById("NC_NETO").parentNode.parentNode.style.display = 'none';
   //}
}
/**Obtiene la lista de items de la factura para enviarlos al jsp de las promociones*/
function getLstItemsNC() {

}
/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagCteNC() {
   OpnOpt('CLIENTES', 'grid', 'dialogCte', false, false);
}
/**Abre el cuadro de dialogo para buscar vendedor o dar de alta uno nuevo*/
function OpnDiagVendNC() {
   OpnOpt('VENDEDOR', 'grid', 'dialogVend', false, false);
}
/**Realizar la operacion de guardado de la venta mostrando primero la pantalla de pago*/
function SaveVtaSvNC() {
   //Validamos si el total es igual a cero
   if (parseFloat(document.getElementById("NC_TOT").value) == 0) {
      alert(lstMsg[56]);
   } else {
      if (d.getElementById("TOTALXPAGAR") != null)
         d.getElementById("TOTALXPAGAR").value = d.getElementById("NC_TOT").value;
      SaveVtaSvDoNC();
   }
}
/**Guarda la venta*/
function SaveVtaSvDoNC() {
   $("#dialogPagos").dialog("close");
   $("#dialogWait").dialog("open");
   //Armamos el POST a enviar
   var strPOST = "";
   //Prefijos dependiendo del tipo de venta
   var strPrefijoMaster = "NC";
   var strPrefijoDeta = "NCD";
   var strKey = "NC_ID";
   var strNomFormat = "NCREDITOSV";
   //Master
   strPOST += "SC_ID=" + d.getElementById("SC_ID").value;
   strPOST += "&CT_ID=" + d.getElementById("FCT_ID").value;
   strPOST += "&VE_ID=" + d.getElementById("VE_ID").value;
   strPOST += "&PD_ID=" + d.getElementById("PD_ID").value;
   strPOST += "&" + strPrefijoMaster + "_ESSERV=1";
   strPOST += "&" + strPrefijoMaster + "_MONEDA=" + d.getElementById("NC_MONEDA").value;
   strPOST += "&" + strPrefijoMaster + "_FECHA=" + d.getElementById("NC_FECHA").value;
   strPOST += "&" + strPrefijoMaster + "_FOLIO=" + d.getElementById("NC_FOLIO").value;
   strPOST += "&" + strPrefijoMaster + "_NOTAS=" + d.getElementById("NC_NOTAS").value;
   strPOST += "&" + strPrefijoMaster + "_TOTAL=" + d.getElementById("NC_TOT").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO1=" + d.getElementById("NC_IMPUESTO1").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO2=" + d.getElementById("NC_IMPUESTO2").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO3=" + d.getElementById("NC_IMPUESTO3").value;
   strPOST += "&" + strPrefijoMaster + "_IMPORTE=" + d.getElementById("NC_IMPORTE").value;
   strPOST += "&" + strPrefijoMaster + "_RETISR=" + d.getElementById("NC_RETISR").value;
   strPOST += "&" + strPrefijoMaster + "_RETIVA=" + d.getElementById("NC_RETIVA").value;
   strPOST += "&" + strPrefijoMaster + "_NETO=" + d.getElementById("NC_NETO").value;
   strPOST += "&" + strPrefijoMaster + "_NOTASPIE=" + d.getElementById("NC_NOTASPIE").value;
   strPOST += "&" + strPrefijoMaster + "_REFERENCIA=" + d.getElementById("NC_REFERENCIA").value;
   strPOST += "&" + strPrefijoMaster + "_CONDPAGO=" + d.getElementById("NC_CONDPAGO").value;
   strPOST += "&" + strPrefijoMaster + "_NUMPEDI=" + d.getElementById("NC_NUMPEDI").value;
   strPOST += "&" + strPrefijoMaster + "_FECHAPEDI=" + d.getElementById("NC_FECHAPEDI").value;
   strPOST += "&" + strPrefijoMaster + "_ADUANA=" + d.getElementById("NC_ADUANA").value;
   strPOST += "&" + strPrefijoMaster + "_TIPOCOMP=" + d.getElementById("NC_TIPOCOMP").value;
   strPOST += "&" + strPrefijoMaster + "_METODOPAGO=" + d.getElementById("NC_METODOPAGO").value;
   strPOST += "&" + strPrefijoMaster + "_NUMCUENTA=" + d.getElementById("NC_NUMCUENTA").value;
   strPOST += "&" + strPrefijoMaster + "_TASA1=" + dblTasaVtaSv1;
   strPOST += "&" + strPrefijoMaster + "_TASA2=" + dblTasaVtaSv2;
   strPOST += "&" + strPrefijoMaster + "_TASA3=" + dblTasaVtaSv3;
   strPOST += "&" + "TI_ID=" + intIdTasaVtaSv1;
   strPOST += "&" + "TI_ID2=" + intIdTasaVtaSv2;
   strPOST += "&" + "TI_ID3=" + intIdTasaVtaSv3;
   strPOST += "&" + strPrefijoMaster + "_TASAPESO=" + d.getElementById("NC_TASAPESO").value;
   //Validamos IEPS
   if (document.getElementById("NC_USO_IEPS1").checked) {
      strPOST += "&" + strPrefijoMaster + "_USO_IEPS=1";
      strPOST += "&" + strPrefijoMaster + "_TASA_IEPS=" + d.getElementById("NC_TASA_IEPS").value;
      strPOST += "&" + strPrefijoMaster + "_IMPORTE_IEPS=" + d.getElementById("NC_IMPORTE_IEPS").value;
   } else {
      strPOST += "&" + strPrefijoMaster + "_USO_IEPS=0";
      strPOST += "&" + strPrefijoMaster + "_TASA_IEPS=0";
      strPOST += "&" + strPrefijoMaster + "_IMPORTE_IEPS=0";
   }
   strPOST += "&FAC_ID=" + d.getElementById("FAC_IDNC").value;
   strPOST += "&TKT_ID=" + d.getElementById("TKT_IDNC").value;
   //Recurrentes
   strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD=" + d.getElementById("NC_PERIODICIDAD").value;
   strPOST += "&" + strPrefijoMaster + "_DIAPER=" + d.getElementById("NC_DIAPER").value;
   if (document.getElementById("NC_REGIMENFISCALcount") != null &&
           document.getElementById("NC_REGIMENFISCALcount") != undefined) {
      var intCuantosReg = document.getElementById("NC_REGIMENFISCALcount").value;
      if (intCuantosReg > 0) {
         //Obtenemos el valor seleccionado
         for (var iRegim = 0; iRegim < intCuantosReg; iRegim++) {
            if (d.getElementById("NC_REGIMENFISCAL" + iRegim).checked) {
               strPOST += "&" + strPrefijoMaster + "_REGIMENFISCAL=" + d.getElementById("NC_REGIMENFISCAL" + iRegim).value;
            }
         }
      }
   }
   //Items
   var grid = jQuery("#NC_GRID");
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
      strPOST += "&" + strPrefijoDeta + "_DESCRIPCION" + intC + "=" + lstRow.FACD_DESCRIPCION;
      strPOST += "&" + strPrefijoDeta + "_CANTIDAD" + intC + "=" + lstRow.FACD_CANTIDAD;
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
      strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + lstRow.FACD_NOTAS;
   }
   strPOST += "&COUNT_ITEM=" + intC;

   //Hacemos la peticion por POST
   $.ajax({
      type: "POST",
      data: encodeURI(strPOST),
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "html",
      url: "NCMov.do?id=1",
      success: function(dato) {
         dato = trim(dato);
         if (Left(dato, 3) == "OK.") {
            var strHtml2 = CreaHidden(strKey, dato.replace("OK.", ""));
            openWhereverFormat("ERP_SendNC?id=" + dato.replace("OK.", ""), strNomFormat, "PDF", strHtml2);
            ResetOperaActualSvNC();
         } else {
            alert(dato);
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Funciones para el cuadro de dialogo SI/NO*/
function ConfirmaSINCServ() {
   if (d.getElementById("Operac").value == "Nva") {
      //Llamamos metodo para limpiar pantallas
      ResetOperaActualSvNC()
   }
   d.getElementById("Operac").value = "";
   $("#SioNO").dialog("close");
}
function ConfirmaNONCServ() {
   $("#SioNO").dialog("close");
}
//Panel de botones
/**Guardar operacion*/
function CallbtnNCServ0() {
   SaveVtaSvNC();
}
/**Nueva operacion*/
function CallbtnNCServ1() {
   $("#SioNO").dialog('option', 'title', "¿Confirma que desea borrar la operacion actual e iniciar una nueva?");
   d.getElementById("Operac").value = "Nva";
   document.getElementById("SioNO_inside").innerHTML = "";
   $("#SioNO").dialog("open");
}
/**Limpia la operacion actual*/
function ResetOperaActualSvNC(bolSelOpera) {
   if (bolSelOpera == undefined)
      bolSelOpera = true;
   if (bolSelOpera)
      $("#dialogWait").dialog("open");
   //Limpiamos los campos y ponemos al cliente default
   d.getElementById("FCT_ID").value = intCteDefa;
   d.getElementById("NC_FOLIO").value = "";
   d.getElementById("NC_NOTAS").value = "";
   d.getElementById("NC_TOT").value = "0.0";
   d.getElementById("NC_RETISR").value = "0.0";
   d.getElementById("NC_RETIVA").value = "0.0";
   d.getElementById("NC_NETO").value = "0.0";
   d.getElementById("NC_IMPUESTO1").value = "0.0";
   d.getElementById("NC_IMPUESTO2").value = "0.0";
   d.getElementById("NC_IMPUESTO3").value = "0.0";
   d.getElementById("NC_IMPORTE").value = "0.0";
   d.getElementById("NC_DESC").value = "";
   d.getElementById("NC_PRECIO").value = "0.0";
   d.getElementById("VE_ID").value = "0";
   d.getElementById("VE_NOM").value = "";
   d.getElementById("FAC_IDNC").value = "0";
   d.getElementById("NC_DESC").focus();
   //Recurrentes
   //d.getElementById("NC_ESRECU2").checked = true;
   d.getElementById("NC_PERIODICIDAD").value = "1";
   d.getElementById("NC_DIAPER").value = "1";
   d.getElementById("FAC_IDNC").value = 0;
   d.getElementById("TKT_IDNC").value = 0;
   OcultarAvisosServNC();
   if (bolSelOpera)
      ObtenNomCteServNC();
   //Limpiamos el GRID
   var grid = jQuery("#NC_GRID");
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
   EvalSucursalNC();
}
/**Abre la ventana de consulta de ventas*/
function CallbtnNCServ2() {
   OpnOpt('NC_VIEW', '_ed', 'dialogDevo', false, false, true);
}
/**Borramos item*/
function CallbtnNCServ7() {
   VtaDropNC()
}
/**Mostramos el menu*/
function CallbtnNCServ9() {
   myLayout.open("west");
   myLayout.open("east");
   myLayout.open("south");
   myLayout.open("north");
   document.getElementById("MainPanel").innerHTML = "";
   //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
   var objMainFacPedi = objMap.getScreen("NOTA_SRV");
   objMainFacPedi.bolActivo = false;
   objMainFacPedi.bolMain = false;
   objMainFacPedi.bolInit = false;
   objMainFacPedi.idOperAct = 0;
}//Borramos item

/**Abre el cuadro de dialogo para seleccionar el tipo de operacion*/
function SelOperFactServNC() {
}
/**Selecciona el tipo de operacion de ventas*/
function SelOperFactServDoNC() {
}
/**Carga la informacion de una operacion de REMISION o VENTA*/
function getPedidoenVentaSrvNC(intIdPedido, strTipoVta) {
   //Mandamos la peticion por ajax para que nos den el XML del pedido
   $.ajax({
      type: "POST",
      data: "PD_ID=" + intIdPedido,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "VtasMov.do?id=8",
      success: function(datos) {
         var objPedido = datos.getElementsByTagName("vta_pedido")[0];
         var lstdeta = objPedido.getElementsByTagName("deta");
         //Validamos que sea un pedido correcto
         if (objPedido.getAttribute('PD_ANULADA') == 0) {
            //No facturado
            if (objPedido.getAttribute("NC_ID") == 0 ||
                    (objPedido.getAttribute("NC_ID") != 0 && objPedido.getAttribute('PD_ESRECU') == 1)
                    ) {
               //No remisionado
               if (objPedido.getAttribute("TKT_ID") == 0 ||
                       (objPedido.getAttribute("TKT_ID") != 0 && objPedido.getAttribute('PD_ESRECU') == 1)) {
                  //Limpiamos la operacion actual.
                  ResetOperaActualSvNC(false);
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
      error: function(objeto, quepaso, otroobj) {
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**
 *Establece los parametros del pedido original
 **/
function DrawPedidoenVentaSrvNC(objPedido, lstdeta, strTipoVta) {

}
/**
 *Llenamos el grid con los datos del pedido
 **/
function DrawPedidoDetaenVentaSrvNC(objPedido, lstdeta, strTipoVta) {

}
/**Muestra el label de aviso*/
function MostrarAvisosNc(strMsg) {
   var label = document.getElementById("LABELAVISOS");
   label.innerHTML = strMsg;
   //Mostrar aviso
   label.setAttribute("class", "Mostrar");
   label.setAttribute("className", "Mostrar");
   label.setAttribute("class", "ui-Total");
   label.setAttribute("className", "ui-Total");
}
/**Oculta el label de aviso*/
function OcultarAvisosServNC() {
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
function _ImporteVtaNC() {
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
         this.dblImporteReal += this.dblImpuesto1 + this.dblImpuesto2 + this.dblImpuesto3;
         this.dblImporte += this.dblImpuesto1 + this.dblImpuesto2 + this.dblImpuesto3;
      }
   }
}
/**Valida la sucursal al momento de cambiarla*/
function ValidaSucNC() {
   if (parseFloat(document.getElementById("SC_ID").value) == 0) {
      document.getElementById("SC_ID").value = intSucDefa;
      InitImpDefault();
   } else {
      InitImpSuc();
   }
}
/**Inicializa los impuestos por default*/
function InitImpDefaultNC() {
   dblTasaVtaSv1 = dblTasa1;
   dblTasaVtaSv2 = dblTasa2;
   dblTasaVtaSv3 = dblTasa3;
   intSImpVta1_2Sv = intSImp1_2;
   intSImpVta1_3Sv = intSImp1_3;
   intSImpVta2_3Sv = intSImp2_3;
}
/**Inicializa los impuestos de la sucursal seleccionada*/
function InitImpSucNc() {
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
      success: function(datos) {
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
            d.getElementById("NC_TASASEL1").value = intIdTasaVtaSv1;
            intSImpVta1_2Sv = obj.getAttribute('SImp1_2');
            intSImpVta1_3Sv = obj.getAttribute('SImp1_3');
            intSImpVta2_3Sv = obj.getAttribute('SImp2_3');
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Evaluamos si podemos cambiar la sucursal*/
function EvalSucursalNC() {
   var grid = jQuery("#NC_GRID");
   var arr = grid.getDataIDs();
   var objSuc = document.getElementById("SC_ID");
   var objTasaSel = document.getElementById("NC_TASASEL1");
   if (arr.length > 0) {
      //Si hay partidas no podremos cambiar la sucursal
      objSuc.onmouseout = function() {
         this.disabled = false;
      };
      objSuc.onmouseleave = function() {
         this.disabled = false;
      };
      objSuc.onmouseover = function() {
         this.disabled = true;
      };
      objSuc.setAttribute("class", "READONLY");
      objSuc.setAttribute("className", "READONLY");
      objTasaSel.onmouseout = function() {
         this.disabled = false;
      };
      objTasaSel.onmouseleave = function() {
         this.disabled = false;
      };
      objTasaSel.onmouseover = function() {
         this.disabled = true;
      };
      objTasaSel.setAttribute("class", "READONLY");
      objTasaSel.setAttribute("className", "READONLY");
   } else {
      objSuc.disabled = false;
      //Si hay partidas no podremos cambiar la sucursal
      objSuc.onmouseout = function() {
         var g = 1;
      };
      objSuc.onmouseleave = function() {
         var g = 1;
      };
      objSuc.onmouseover = function() {
         var g = 1;
      };
      objSuc.setAttribute("class", "outEdit");
      objSuc.setAttribute("className", "outEdit");
      objTasaSel.disabled = false;
      //Si hay partidas no podremos cambiar la sucursal
      objTasaSel.onmouseout = function() {
         var g = 1;
      };
      objTasaSel.onmouseleave = function() {
         var g = 1;
      };
      objTasaSel.onmouseover = function() {
         var g = 1;
      };
      objTasaSel.setAttribute("class", "outEdit");
      objTasaSel.setAttribute("className", "outEdit");
   }
}
/**Activa o inactiva el campo de tipo de moneda*/
function RefreshMonedaSrvNC() {
   var objMoneda = document.getElementById("NC_MONEDA");
   var objTipoCambio = document.getElementById("NC_TASAPESO");
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
function UpdateTasaImpSrvNC() {
   var objTasaSel = document.getElementById("NC_TASASEL1");
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
      success: function(datos) {
         var objPedido = datos.getElementsByTagName("vta_impuesto")[0];
         var lstdeta = objPedido.getElementsByTagName("vta_impuestos");
         for (var i = 0; i < lstdeta.length; i++) {
            var obj = lstdeta[i];
            dblTasaVtaSv1 = obj.getAttribute('Tasa1');
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Selecciona el primer regimen fiscal*/
function SelRegDefaNCServ() {
   if (document.getElementById("NC_REGIMENFISCALcount") != null &&
           document.getElementById("NC_REGIMENFISCALcount") != undefined) {
      var intCuantosReg = document.getElementById("NC_REGIMENFISCALcount").value;
      if (intCuantosReg > 0) {
         //Obtenemos el valor seleccionado
         for (var iRegim = 0; iRegim < intCuantosReg; iRegim++) {
            d.getElementById("NC_REGIMENFISCAL" + iRegim).checked = true;
            break;
         }
      }
   }
}
/*Obtiene la factura capturada*/
function ObtenFacIdNS() {


}
/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagFacIdNS() {
   OpnOpt('VTAS_VIEW', '_ed', 'dialogView', false, false);
}
/*Sirve para obtener en detalle de la fatura o ticket ??ra hacer la devolucion*/
function getDetaDevolucionesServ(doc) {
   var intIdoPER = 0;
   var strTipoDoc = "";
   var intIdDoc = 0;
   var strPrefijo = "FAC_";
   var strPrefijoDeta = "FACD_";
   if (doc == "_fac") {
      intIdoPER = 5;
      strTipoDoc = "FAC_ID";
      intIdDoc = d.getElementById("FAC_IDNC").value;
   }
   if (doc == "_tkt") {
      intIdoPER = 6;
      strTipoDoc = "TKT_ID";
      strPrefijo = "TKT_";
      strPrefijoDeta = "TKTD_";
      intIdDoc = d.getElementById("TKT_IDNC").value;
   }

   $("#dialogWait").dialog("open");
   //Buscamos los importes ya que es un producto nuevo
   $.ajax({
      type: "POST",
      data: strTipoDoc + "=" + intIdDoc,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "NCMov.do?id=" + intIdoPER,
      success: function(datoVal) {

         var objFactura = datoVal.getElementsByTagName("vta_factura")[0];
         var lstdeta = objFactura.getElementsByTagName("deta");
         //Validamos que sea un pedido correcto
         if (objFactura.getAttribute(strPrefijo + 'ANULADA') == 0) {
            //Llenamos la pantalla con los valores del bd
            DrawFacturaDevServ(objFactura, lstdeta, "", strPrefijo, strPrefijoDeta);
            $("#dialogView").dialog("close")

         } else {

            /*El documento esta anulado y ponemos en 0 el campo*/
            alert(lstMsg[187]);
            document.getElementById("FAC_IDNC").value = "0";
            document.getElementById("TKT_IDNC").value = "0";
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":Devolucion:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}

/**
 *Establece los parametros del pedido original
 **/
function DrawFacturaDevServ(objFactura, lstdeta, strTipoVta, strPrefijo) {
   $("#dialogWait").dialog("open");

   document.getElementById("SC_ID").value = objFactura.getAttribute('SC_ID');
   document.getElementById("NC_NOTAS").value = objFactura.getAttribute(strPrefijo + '_NOTAS');
   document.getElementById("NC_NOTASPIE").value = objFactura.getAttribute(strPrefijo + '_NOTASPIE');
   document.getElementById("NC_CONDPAGO").value = objFactura.getAttribute(strPrefijo + 'CONDPAGO');
   document.getElementById("NC_REFERENCIA").value = objFactura.getAttribute(strPrefijo + 'REFERENCIA');
   document.getElementById("FCT_ID").value = objFactura.getAttribute('CT_ID');
   document.getElementById("CT_NOM").value = objFactura.getAttribute(strPrefijo + 'RAZONSOCIAL');
   document.getElementById("NC_TASASEL1").value = objFactura.getAttribute('TI_ID');
   document.getElementById("FCT_DESCUENTO").value = objFactura.getAttribute(strPrefijo + 'POR_DESCUENTO');
   dblTasaVta1 = objFactura.getAttribute(strPrefijo + 'TASA1');

}

/**Abre el cuadro de dialogo para seleccionar ticket*/
function OpnDiagTktIdNC() {

   OpnOpt('VTAS_VIEW', '_ed', 'dialogView', false, false, true);
}

