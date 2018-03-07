
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
var objTabla = null;
var numFilas = 0;
var idT = 0;
var intContaIdGrid = 0;
var intRET_ISR = 0;
var intRET_IVA = 0;
var intRET_FLETE = 0;

function vta_notacred() {//Funcion necesaria para que pueda cargarse la libreria en automatico
}
/**Inicializa la pantalla de punto de venta*/
function InitPtoVtaNC() {
   $("#dialogWait").dialog("open");
   myLayout.close("west");
   myLayout.close("east");
   myLayout.close("south");
   myLayout.close("north");
   //Ocultamos renglon de avisos
   OcultarAvisosNC();
   //Ponemos el nombre default de la sucursal
   d.getElementById("SC_ID").value = intSucDefa;
   //Hacemos diferente el estilo del total
   FormStyleNC();
   //Obtenemos el id del cliente y el vendedor default
   d.getElementById("FCT_ID").value = intCteDefa;
   d.getElementById("NC_OPER").value = strUserName;
   d.getElementById("NC_TASASEL1").value = intIdTasaVta1;
   d.getElementById("NC_PROD").focus();
   //console.log('debbugin fase 3 ');
   ObtenNomCteNC();
   //Realizamos el menu de botones
   var strHtml = "<ul>" +
           getMenuItem("Callbtn0NC();", "Guardar Nota de Credito", "images/ptovta/CircleSave.png") +
           getMenuItem("Callbtn1NC();", "Nueva Nota de Credito", "images/ptovta/VisPlus.png") +
           getMenuItem("Callbtn2NC();", "Consultar Nota de Credito", "images/ptovta/VisMagnifier.png") +
           getMenuItem("Callbtn4NC();", "Cambio Precio", "images/ptovta/VisModi.png") +
           getMenuItem("Callbtn10NC();", "Editar Cantidad a devolver", "images/ptovta/VisQty.png") +
           getMenuItem("Callbtn8NC();", "Notas", "images/ptovta/VisNote.png") +
           getMenuItem("Callbtn7NC();", "Borrar Producto", "images/ptovta/VisClose.png") +
           getMenuItem("Callbtn9NC();", "Salir", "images/ptovta/exitBig.png") +
           "</ul>";
   //console.log('debbugin fase 4 ');
   document.getElementById("TOOLBAR").innerHTML = strHtml;
   //Obtenemos los atributos(permisos) del usuario para esta pantalla
   bolCambioFecha = false;
   $.ajax({
      type: "POST",
      data: "keys=43,44,45,85",
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
         }
         //Validamos si podemos hacer cambio de fecha
         if (bolCambioFecha) {
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
         setTimeout("d.getElementById('NC_PROD').focus();", 3000);
         //Seleciona el tipo de operacion de venta
         SelOperFactNC();
         SelRegDefaNC();
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
   //Definimos acciones para el dialogo SI/NO
   document.getElementById("btnSI").onclick = function() {
      ConfirmaSINC();
   };
   document.getElementById("btnNO").onclick = function() {
      ConfirmaNONC();
   };
}
/**Cambia los estilos de algunos controles*/
function FormStyleNC() {
   d.getElementById("NC_TOT").setAttribute("class", "ui-Total");
   d.getElementById("NC_TOT").setAttribute("className", "ui-Total");
   d.getElementById("btn1").setAttribute("class", "Oculto");
   d.getElementById("btn1").setAttribute("className", "Oculto");
}
/**Obtiene el nombre del cliente al que se le esta haciendo la venta*/
function ObtenNomCteNC(objPedido, lstdeta, strTipoVta, bolPasaPedido) {
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
            /*
             document.getElementById("NC_IMPORTE").value = objCte.getAttribute('FAC_IMPORTE');
             document.getElementById("NC_IMPUESTO1").value = objCte.getAttribute('FAC_IMPUESTO1');
             document.getElementById("NC_TOT").value = objCte.getAttribute('FAC_TOTAL');
             */


            intCT_TIPOPERS = objCte.getAttribute('CT_TIPOPERS');
            intCT_TIPOFAC = objCte.getAttribute('CT_TIPOFAC');
            strCT_USOIMBUEBLE = objCte.getAttribute('CT_USOIMBUEBLE');
         }
         //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
         if (bolPasaPedido) {
            DrawPedidoDetaenVentaNC(objPedido, lstdeta, strTipoVta);
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
/**Funcion para anadir partidas*/
function AddItemEvtNC(event, obj) {
   if (event.keyCode == 13) {
      AddItemNC();
   }
}
/**Funcion para anadir partidas, valida que el producto exista, luego obtiene el precio y lo anade al GRID*/
function AddItemNC() {
   var strCod = UCase(d.getElementById("NC_PROD").value);
   //Validamos que hallan capturado un codigo
   if (trim(strCod) != "") {
      var intDevo = d.getElementById("NC_DEVO").value;
      //Bandera para indicar si no se agrupan los items
      var bolAgrupa = d.getElementById("NC_AGRUPA1").checked;
      $("#dialogWait").dialog("open");
      var bolNvo = true;
      var idProd = 0;
      //Si esta activada la funcionalidad de agrupar validamos si existe
      if (bolAgrupa) {
         //Revisamos si existe el item en el grid
         var grid = jQuery("#NC_GRID");
         var arr = grid.getDataIDs();
         for (var i = 0; i < arr.length; i++) {
            var id = arr[i];
            var lstRowAct = grid.getRowData(id);
            if (lstRowAct.FACD_CVE == strCod ||
                    lstRowAct.FACD_CODBARRAS == strCod) {
               if (intDevo == 1) {
                  if (lstRow.FACD_ESDEVO == 1) {
                     idProd = id;
                     bolNvo = false;
                     break;
                  }
               } else {
                  idProd = id;
                  bolNvo = false;
                  break;
               }
            }
         }
      }
      //Validamos si es un producto nuevo
      if (bolNvo) {
         //Buscamos los importes ya que es un producto nuevo
         $.ajax({
            type: "POST",
            data: "PR_CODIGO=" + strCod + "&SC_ID=" + d.getElementById("SC_ID").value,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "VtasMov.do?id=5",
            success: function(datoVal) {
               var objProd = datoVal.getElementsByTagName("vta_productos")[0];
               var Pr_Id = 0;
               if (objProd != undefined) {
                  Pr_Id = objProd.getAttribute('PR_ID');
                  d.getElementById("NC_DESC").value = objProd.getAttribute('PR_DESCRIPCION');
                  //Reemplazamos el codigo del producto por el de la bd
                  if (Pr_Id != 0) {
                     strCod = objProd.getAttribute('PR_CODIGO');
                  }
               }
               var Ct_Id = d.getElementById("FCT_ID").value;
               var dblCantidad = d.getElementById("NC_CANT").value;
               //Validamos si nos regreso un ID de producto valido
               if (Pr_Id != 0) {
                  //Validamos la existencia
                  var dblExistencia = 0;
                  AddItemPrecNC(objProd, Pr_Id, Ct_Id, dblCantidad, strCod, dblExistencia, intDevo);
               } else {
                  alert(lstMsg[0]);
                  d.getElementById("NC_DEVO").value = 0;
                  document.getElementById("NC_PROD").focus();
                  $("#dialogWait").dialog("close");
               }
            },
            error: function(objeto, quepaso, otroobj) {
               alert(":pto3:" + objeto + " " + quepaso + " " + otroobj);
               $("#dialogWait").dialog("close");
            }
         });
      } else {
         //Ya existe el item
         var Cantidad = d.getElementById("NC_CANT").value;//Cantidad solicitada
         //Recuperamos los valores del producto
         var gridD = jQuery("#NC_GRID");
         var lstRow = gridD.getRowData(idProd);
         //Recalculamos la cantidad
         lstRow.FACD_DEVOLVER = parseFloat(lstRow.FACD_DEVOLVER) + parseFloat(Cantidad);
         //Recalculamos el importe y actualizamos la fila
         lstRowChangePrecioNC(lstRow, idProd, gridD);
         //Ponemos foco en el control
         document.getElementById("NC_PROD").value = "";
         document.getElementById("NC_PROD").focus();
         d.getElementById("NC_CANT").value = 1;
         d.getElementById("NC_DEVO").value = 0;
         //Sumamos todos los items
         setSumNC();
         $("#dialogWait").dialog("close");
      }
   }
}
/**Vuelva a calcular el precio para una fila del grid*/
function lstRowChangePrecioNC(lstRow, idUpdate, grid) {
   var objImportes = new _ImporteVtaNC();
   objImportes.dblCantidad = parseFloat(lstRow.FACD_DEVOLVER);
   objImportes.dblPrecio = parseFloat(lstRow.FACD_PRECIO);
   objImportes.dblPrecioReal = lstRow.FACD_PRECREAL;
   objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
   objImportes.dblPorcDesc = lstRow.FACD_PORDESC;
   objImportes.dblPrecFijo = lstRow.FACD_PRECFIJO;
   objImportes.dblExento1 = lstRow.FACD_EXENTO1;
   objImportes.dblExento2 = lstRow.FACD_EXENTO2;
   objImportes.dblExento3 = lstRow.FACD_EXENTO3;
   objImportes.intDevo = lstRow.FACD_ESDEVO;
   objImportes.intPrecioZeros = lstRow.FACD_SINPRECIO;
   objImportes.CalculaImporte();
   //Asignamos nuevos importes
   lstRow.FACD_IMPORTE_DEV = objImportes.dblImporte;
   lstRow.FACD_IMPUESTO_DEV = objImportes.dblImpuesto1;
   lstRow.FACD_PORDESC = objImportes.dblPorcAplica;
   if (parseFloat(objImportes.dblPorcAplica) > 0) {
      lstRow.FACD_DESCUENTO = parseFloat(objImportes.dblImporteReal) - parseFloat(objImportes.dblImporte);
   } else {
      lstRow.FACD_DESCUENTO = 0;
   }
   lstRow.FACD_IMPORTEREAL = objImportes.dblImporteReal;
   //Actualizamos el grid
   grid.setRowData(idUpdate, lstRow);
   //Sumamos todos los items
   setSumNC();
}
/**A??ade una nueva partida al GRID*/
function AddItemPrecNC(objProd, Pr_Id, Ct_Id, Cantidad, strCod, dblExist, intDevo) {
   //Consultamos el precio del producto
   $.ajax({
      type: "POST",
      data: "PR_ID=" + Pr_Id + "&CT_LPRECIOS=" + document.getElementById("FCT_LPRECIOS").value +
              "&CANTIDAD=" + Cantidad,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "DamePrecio.do?id=4",
      success: function(datoPrec) {
         var bolFind = false;
         //Procesamos el XML y lo anadimos al GRID
         var lstXml = datoPrec.getElementsByTagName("Precios")[0];
         var lstprecio = lstXml.getElementsByTagName("Precio");
         for (var i = 0; i < lstprecio.length; i++) {
            var obj2 = lstprecio[i];
            var objImportes = new _ImporteVtaNC();
            objImportes.dblCantidad = Cantidad;
            objImportes.dblPrecio = parseFloat(obj2.getAttribute('precio'));
            objImportes.dblPrecioReal = parseFloat(obj2.getAttribute('precio'));
            objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
            objImportes.dblExento1 = objProd.getAttribute('PR_EXENTO1');
            objImportes.dblExento2 = objProd.getAttribute('PR_EXENTO2');
            objImportes.dblExento3 = objProd.getAttribute('PR_EXENTO3');
            objImportes.intDevo = intDevo;
            objImportes.CalculaImporte();
            var dblImporte = objImportes.dblImporte;
            var datarow = {
               FACD_ID: 0,
               FACD_CANTIDAD: Cantidad,
               FACD_DEVOLVER: Cantidad,
               FACD_DESCRIPCION: objProd.getAttribute('PR_DESCRIPCION'),
               FACD_IMPORTE: dblImporte,
               FACD_CVE: strCod,
               FACD_PRECIO: obj2.getAttribute('precio'),
               FACD_TASAIVA1: dblTasa1,
               FACD_DESGLOSA1: 1,
               FACD_IMPUESTO1: objImportes.dblImpuesto1,
               FACD_PR_ID: Pr_Id,
               FACD_EXENTO1: objProd.getAttribute('PR_EXENTO1'),
               FACD_EXENTO2: objProd.getAttribute('PR_EXENTO2'),
               FACD_EXENTO3: objProd.getAttribute('PR_EXENTO3'),
               FACD_REQEXIST: objProd.getAttribute('PR_REQEXIST'),
               FACD_EXIST: dblExist,
               FACD_NOSERIE: "",
               FACD_ESREGALO: 0,
               FACD_IMPORTEREAL: dblImporte,
               FACD_PRECREAL: obj2.getAttribute('precio'),
               FACD_DESCUENTO: 0.0,
               FACD_PORDESC: objImportes.dblPorcAplica,
               FACD_PRECFIJO: 0,
               FACD_ESDEVO: intDevo,
               FACD_CODBARRAS: objProd.getAttribute('PR_CODBARRAS'),
               FACD_NOTAS: ""
            };
            //Anexamos el registro al GRID
            itemId++;
            jQuery("#NC_GRID").addRowData(itemId, datarow, "last");
            d.getElementById("NC_PRECIO").value = obj2.getAttribute('precio');
            d.getElementById("NC_PROD").value = "";
            d.getElementById("NC_PROD").focus();
            d.getElementById("NC_CANT").value = 1;
            d.getElementById("NC_DEVO").value = 0;
            bolFind = true;
            //Sumamos todos los items
            setSumNC();
            //Validamos el cambio de sucursal
            EvalSucursalNC();
         }
         //Validamos si no nos devolvieron precio es porque el CLIENTE no existe
         if (!bolFind) {
            ObtenNomCteNC();
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":pto4:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Borra el item seleccionado*/
function VtaDropNC() {
   var grid = jQuery("#NC_GRID");
   if (grid.getGridParam("selrow") != null) {
      grid.delRowData(grid.getGridParam("selrow"));
      document.getElementById("NC_PROD").focus();
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
      dblSuma += parseFloat(lstRow.FACD_IMPORTE_DEV);
      dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO_DEV);
      dblImporte += (parseFloat(lstRow.FACD_IMPORTE_DEV) - parseFloat(lstRow.FACD_IMPUESTO_DEV));

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
      var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
      tax.CalculaImpuestoMas(dblIEPS, 0, 0);
      dblImpuesto1 += tax.dblImpuesto1;
      dblSuma += dblIEPS + tax.dblImpuesto1;
   }
   d.getElementById("NC_IMPORTE_IEPS").value = FormatNumber(dblIEPS, intNumdecimal, true, false, true, false);
   d.getElementById("NC_TOT").value = FormatNumber(dblSuma, intNumdecimal, true, false, true, false);
   d.getElementById("NC_IMPUESTO1").value = FormatNumber(dblImpuesto1, intNumdecimal, true, false, true, false);
   d.getElementById("NC_IMPORTE").value = FormatNumber(dblImporte, intNumdecimal, true, false, true, false);
   //Activamos recibos de honorarios si proceden SOLO EN CASO DE FACTURAS
   /*if(parseInt(intEMP_TIPOPERS) == 2 && intCT_TIPOPERS == 1){
    var dblRetIsr = dblImporte * (dblFacRetISR/100);
    var dblRetIVA = 0;
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
function getLstItems() {

}
/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagCteNC() {
   OpnOpt('CLIENTES', 'grid', 'dialogCte', false, false);
}
/**Abre el cuadro de dialogo para buscar vendedor o dar de alta uno nuevo*/
function OpnDiagVendNC() {
   OpnOpt('VENDEDOR', 'grid', 'dialogVend', false, false);
}
/**Abre el cuadro de dialogo para buscar productos o dar de alta uno nuevo*/
function OpnDiagProdNC() {
   OpnOpt('PROD', 'grid', 'dialogProd', false, false);
}
/**Realizar la operacion de guardado de la venta mostrando primero la pantalla de pago*/
function SaveVtaNC() {
   //Validamos si el total es igual a cero
   if (parseFloat(document.getElementById("NC_TOT").value) == 0) {
      alert(lstMsg[56]);
   } else {
      if (d.getElementById("TOTALXPAGAR") != null) {
         if (parseInt(intEMP_TIPOPERS) == 2 && intCT_TIPOPERS == 1) {
            d.getElementById("TOTALXPAGAR").value = d.getElementById("NC_NETO").value;
         } else {
            d.getElementById("TOTALXPAGAR").value = d.getElementById("NC_TOT").value;
         }
      }
      SaveVtaDoNC();
   }
}
/**Guarda la venta*/
function SaveVtaDoNC() {
   $("#dialogPagos").dialog("close");
   $("#dialogWait").dialog("open");
   //Armamos el POST a enviar
   var strPOST = "";
   //Prefijos dependiendo del tipo de venta
   var strPrefijoMaster = "NC";
   var strPrefijoDeta = "NCD";
   var strKey = "NC_ID";
   var strNomFormat = "NCREDITO";
   //Master
   strPOST += "SC_ID=" + d.getElementById("SC_ID").value;
   strPOST += "&CT_ID=" + d.getElementById("FCT_ID").value;
   strPOST += "&VE_ID=" + d.getElementById("VE_ID").value;
   strPOST += "&PD_ID=" + d.getElementById("PD_ID").value;
   strPOST += "&" + strPrefijoMaster + "_ESSERV=0";
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
   strPOST += "&" + strPrefijoMaster + "_TASA1=" + dblTasaVta1;
   strPOST += "&" + strPrefijoMaster + "_TASA2=" + dblTasaVta2;
   strPOST += "&" + strPrefijoMaster + "_TASA3=" + dblTasaVta3;
   strPOST += "&" + "TI_ID=" + intIdTasaVta1;
   strPOST += "&" + "TI_ID2=" + intIdTasaVta2;
   strPOST += "&" + "TI_ID3=" + intIdTasaVta3;
   strPOST += "&" + strPrefijoMaster + "_TASAPESO=" + d.getElementById("NC_TASAPESO").value;
   strPOST += "&" + strPrefijoMaster + "_ESRECU=0";
   strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD=" + d.getElementById("NC_PERIODICIDAD").value;
   strPOST += "&" + strPrefijoMaster + "_DIAPER=" + d.getElementById("NC_DIAPER").value;
   strPOST += "&" + strPrefijoMaster + "_SC_ID2=" + d.getElementById("NC_SC_ID2").value;//SUCURSAL DESTINO
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
   if (document.getElementById("NC_ES_DEVO1") != null &&
           document.getElementById("NC_ES_DEVO1") != undefined) {
      if (document.getElementById("NC_ES_DEVO1").checked) {
         strPOST += "&" + strPrefijoMaster + "_ES_DEVO=1";
      } else {
         strPOST += "&" + strPrefijoMaster + "_ES_DEVO=0";
      }
   }
   strPOST += "&FAC_ID=" + d.getElementById("FAC_IDNC").value;
   strPOST += "&TKT_ID=" + d.getElementById("TKT_IDNC").value;
   //Validacion regimen fiscal
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
      strPOST += "&" + strPrefijoDeta + "_DEVOLVER" + intC + "=" + lstRow.FACD_DEVOLVER;
      strPOST += "&" + strPrefijoDeta + "_SERIES_DEV" + intC + "=" + lstRow.FACD_SERIES_DEV;
      strPOST += "&" + strPrefijoDeta + "_CAN_DEV" + intC + "=" + lstRow.FACD_CAN_DEV;
      strPOST += "&" + "FACD" + "_ID" + intC + "=" + lstRow.FACD_ID;
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
         if (lstRow.FACD_CAN_DEV > 0) {
            //Calculamos el impuesto
            var dblBase1 = 0;
            var dblBase2 = 0;
            var dblBase3 = 0;
            var dblImpuesto1 = 0;
            var dblImpuesto2 = 0;
            var dblImpuesto3 = 0;
            if (parseInt(lstRow.FACD_EXENTO1) == 0)
               dblBase1 = lstRow.FACD_PRECIO;
            if (parseInt(lstRow.FACD_EXENTO2) == 0)
               dblBase2 = lstRow.FACD_PRECIO;
            if (parseInt(lstRow.FACD_EXENTO3) == 0)
               dblBase3 = lstRow.FACD_PRECIO;
            var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
            tax.CalculaImpuestoMas(dblBase1, dblBase2, dblBase3);
            if (parseInt(lstRow.FACD_EXENTO1) == 0)
               dblImpuesto1 = tax.dblImpuesto1;
            if (parseInt(lstRow.FACD_EXENTO2) == 0)
               dblImpuesto2 = tax.dblImpuesto2;
            if (parseInt(lstRow.FACD_EXENTO3) == 0)
               dblImpuesto3 = tax.dblImpuesto3;
            dblPrecioConImp = (parseFloat(lstRow.FACD_PRECIO) +
                    dblImpuesto1 +
                    dblImpuesto2 +
                    dblImpuesto3);
            dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECREAL) +
                    dblImpuesto1 +
                    dblImpuesto2 +
                    dblImpuesto3);
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
      strPOST += "&" + strPrefijoDeta + "_IMPORTE" + intC + "=" + lstRow.FACD_IMPORTE_DEV;
      strPOST += "&" + strPrefijoDeta + "_TASAIVA1" + intC + "=" + lstRow.FACD_TASAIVA1;
      strPOST += "&" + strPrefijoDeta + "_TASAIVA2" + intC + "=0" + lstRow.FACD_TASAIVA2;
      strPOST += "&" + strPrefijoDeta + "_TASAIVA3" + intC + "=" + lstRow.FACD_TASAIVA3;
      strPOST += "&" + strPrefijoDeta + "_IMPUESTO1" + intC + "=" + lstRow.FACD_IMPUESTO_DEV;
      strPOST += "&" + strPrefijoDeta + "_IMPUESTO2" + intC + "=" + lstRow.FACD_IMPUESTO2;
      strPOST += "&" + strPrefijoDeta + "_IMPUESTO3" + intC + "=" + lstRow.FACD_IMPUESTO3;
      strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + lstRow.FACD_ESREGALO;
      strPOST += "&" + strPrefijoDeta + "_NOSERIE" + intC + "=" + lstRow.FACD_SERIES_DEV;
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
            if (intImprimeTicket == 1) {
               ImprimeconFolioNC(dato.replace("OK.", ""), "", 6);
            } else {
               var strHtml2 = CreaHidden(strKey, dato.replace("OK.", ""));
               openWhereverFormat("ERP_SendNC?id=" + dato.replace("OK.", ""), strNomFormat, "PDF", strHtml2);
            }
            ResetOperaActualNC();
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
function ConfirmaSINC() {
   if (d.getElementById("Operac").value == "Nva") {
      //Llamamos metodo para limpiar pantallas
      ResetOperaActualNC()
   }
   if (d.getElementById("Operac").value == "PORC_DESC") {
      //Llamamos metodo para asignar el porcentaje de descuento
      PorcDescSendNC();
   }
   if (d.getElementById("Operac").value == "CHANGE_PRICE") {
      //Llamamos metodo para cambiar el precio del articulo
      CambioPrecSendNC();
   }
   if (d.getElementById("Operac").value == "CANT_DEV") {
      //Llamamos metodo para la cantidad a devolver
      CantidadDevuelta();
   }




   d.getElementById("Operac").value = "";
   $("#SioNO").dialog("close");
}

function CantidadDevuelta() {

   var grid = jQuery("#NC_GRID");
   var id = grid.getGridParam("selrow");
   var lstRow = grid.getRowData(id);

   var dblOriginal = d.getElementById("_Original").value;//Cantidad Original
   var intCan_a_Dev = parseInt(d.getElementById("_a_Dev").value);//Cantidad  Devolver
   var intAntesDev = parseInt(d.getElementById("hd_can_dev").value);//Cantidad devolvida antes

   var dblDevuelto = intCan_a_Dev + intAntesDev;//Sumamos el total de antes con el solicitado

   if (dblDevuelto != 0) {
      if (parseInt(dblDevuelto) <= parseInt(dblOriginal)) {
         if (lstRow.FACD_USA_SERIE == 1) {
            DrawSelSerieNC(lstRow, intCan_a_Dev, id);
         } else {
            //Recalculamos la cantidad
            lstRow.FACD_CAN_DEV = parseFloat(lstRow.FACD_CAN_DEV) + parseFloat(document.getElementById("hd_can_dev").value);
            lstRow.FACD_DEVOLVER = document.getElementById("_a_Dev").value;
            grid.setRowData(id, lstRow);
            lstRowChangePrecioNC(lstRow, id, grid);
         }
      } else {
         alert(lstMsg[208]);
      }
   } else {

      alert(lstMsg[209]);
   }

}
/**Marca todos los elementos como devueltos*/
function CantidadDevueltaNCAll() {
   var grid = jQuery("#NC_GRID");
   var arr = grid.getDataIDs();
   for (var i = 0; i < arr.length; i++) {
      var id = arr[i];
      var lstRow = grid.getRowData(id);
      if (parseFloat(lstRow.FACD_CAN_DEV) + parseFloat(lstRow.FACD_CANTIDAD) <= parseFloat(lstRow.FACD_CANTIDAD)) {
         //Recalculamos la cantidad
         lstRow.FACD_CAN_DEV = parseFloat(lstRow.FACD_CAN_DEV) + parseFloat(lstRow.FACD_CANTIDAD);
         lstRow.FACD_DEVOLVER = lstRow.FACD_CANTIDAD;
         grid.setRowData(id, lstRow);
         lstRowChangePrecioNC(lstRow, id, grid);

      }
   }
   setSumNC();
}

function ConfirmaNONC() {
   $("#SioNO").dialog("close");
}
//Panel de botones
/**Guardar operacion*/
function Callbtn0NC() {
   SaveVtaNC();
}
/**Nueva operacion*/
function Callbtn1NC() {
   $("#SioNO").dialog('option', 'title', "??Confirma que desea borrar la operacion actual e iniciar una nueva?");
   d.getElementById("Operac").value = "Nva";
   document.getElementById("SioNO_inside").innerHTML = "";
   $("#SioNO").dialog("open");
}
/**Limpia la operacion actual*/
function ResetOperaActualNC(bolSelOpera) {
   if (bolSelOpera == undefined)
      bolSelOpera = true;
   if (bolSelOpera)
      $("#dialogWait").dialog("open");
   //Limpiamos los campos y ponemos al cliente default
   d.getElementById("FCT_ID").value = intCteDefa;
   d.getElementById("NC_FOLIO").value = "";
   d.getElementById("NC_NOTAS").value = "";
   d.getElementById("NC_TOT").value = "0.0";
   d.getElementById("NC_IMPUESTO1").value = "0.0";
   d.getElementById("NC_IMPUESTO2").value = "0.0";
   d.getElementById("NC_IMPUESTO3").value = "0.0";
   d.getElementById("NC_IMPORTE").value = "0.0";
   d.getElementById("NC_RETISR").value = "0.0";
   d.getElementById("NC_RETIVA").value = "0.0";
   d.getElementById("NC_NETO").value = "0.0";
   d.getElementById("NC_DESC").value = "";
   d.getElementById("NC_PRECIO").value = "0.0";
   d.getElementById("VE_ID").value = "0";
   d.getElementById("VE_NOM").value = "";
   d.getElementById("FAC_IDNC").value = "0";
   d.getElementById("NC_PROD").focus();
   d.getElementById("NC_TIPO").value = "NCREDITO";
   //Recurrentes
   d.getElementById("NC_PERIODICIDAD").value = "1";
   d.getElementById("NC_DIAPER").value = "1";
   d.getElementById("NC_NUMPEDI").value = "";
   d.getElementById("NC_FECHAPEDI").value = "";
   d.getElementById("NC_ADUANA").value = "";
   d.getElementById("FAC_IDNC").value = 0;
   d.getElementById("TKT_IDNC").value = 0;
   OcultarAvisosNC();
   if (bolSelOpera)
      ObtenNomCteNC();
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
   if (bolSelOpera)
      SelOperFactNC();
   //Validamos si la sucursal puede editarse
   EvalSucursalNC();
}
/**Abre la ventana de consulta de ventas*/
function Callbtn2NC() {
   OpnOpt('NC_VIEW', '_ed', 'dialogDevo', false, false, true);
}
/**Abrimos ventana para calcular descuento*/
function Callbtn3NC() {
   var grid = jQuery("#NC_GRID");
   var ids = grid.getGridParam("selrow");
   if (ids != null && bolPorc) {
      document.getElementById("Operac").value = "PORC_DESC";
      $("#SioNO").dialog('option', 'title', lstMsg[5]);
      var div = document.getElementById("SioNO_inside");
      if (lstPorcDesc == null) {
         $("#dialogWait").dialog("open");
         //Hacemos la peticion por POST
         $.ajax({
            type: "POST",
            data: "",
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "CIP_TablaOp.jsp?ID=2&opnOpt=PORCDESC",
            success: function(datos) {
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
            error: function(objeto, quepaso, otroobj) {
               alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
               $("#dialogWait").dialog("close");
            }
         });
      } else {
         var strHtml = CreaSelect(lstMsg[6], "MiPordcDesc", 0, lstPorcDesc, "", "center", 0, 0, "integer", "", 0);
         div.innerHTML = strHtml;
         $("#SioNO").dialog("open");
      }
   }
}
/**Aplica el porcentaje de descuento al producto*/
function PorcDescSendNC() {
   var grid = jQuery("#NC_GRID");
   var ids = grid.getGridParam("selrow");
   if (ids != null) {
      var porDesc = d.getElementById("MiPordcDesc").value;
      //Calculamos el descuento
      PorcDescDo(ids, porDesc);
   }
}
/**Asigna el nuevo porcentaje de descuento seleccionado por el usuario*/
function PorcDescDoNC(id, dblPorc) {
   var grid = jQuery("#NC_GRID");
   //Calculamos nuevo importe
   var lstRow = grid.getRowData(id);
   //Recalculamos el importe y actualizamos la fila
   lstRow.FACD_PORDESC = dblPorc;
   lstRowChangePrecio(lstRow, id, grid);
   //ponemos el foco para seguir capturando
   document.getElementById("NC_PROD").focus();
}
/**Abrimos ventana para indicar el nuevo precio del articulo*/
function Callbtn4NC() {
   var grid = jQuery("#NC_GRID");
   var ids = grid.getGridParam("selrow");
   if (ids != null && bolPrice) {
      var lstRow = grid.getRowData(ids);
      document.getElementById("Operac").value = "CHANGE_PRICE";
      $("#SioNO").dialog('option', 'title', lstMsg[7]);
      var div = document.getElementById("SioNO_inside");
      var strHtml = CreaTexto(lstMsg[8], "_NvoPrecio", lstRow.FACD_PRECIO, 10, 10, true, false, "", "left", 0, "", "", "", false, 1);
      strHtml += CreaRadio(lstMsg[9], "_NvoClean", 0, false, " ");
      div.innerHTML = strHtml;
      $("#SioNO").dialog("open");
   }
}
/**Abrimos ventana para poner la cantidad a devolver*/
function Callbtn10NC() {
   var grid = jQuery("#NC_GRID");
   var ids = grid.getGridParam("selrow");
   if (ids != null) {
      var lstRow = grid.getRowData(ids);
      var intCantOriginal = parseInt(lstRow.FACD_CANTIDAD);
      var intCantDevueltaAntes = parseInt(lstRow.FACD_CAN_DEV);
      //Revisamos si la suma de lo que devolvieron antes no revasa lo original
      if (intCantDevueltaAntes < intCantOriginal) {
         document.getElementById("Operac").value = "CANT_DEV";
         $("#SioNO").dialog('option', 'title', lstMsg[188]);
         var div = document.getElementById("SioNO_inside");
         var strHtml = CreaTexto("Cantidad Original", "_Original", lstRow.FACD_CANTIDAD, 10, 10, true, false, "", "left", 0, "", "", "", false, 1, true);
         strHtml += CreaTexto("Devuelto Anterior", "_Devuelto", lstRow.FACD_CAN_DEV, 10, 10, true, false, "", "left", 0, "", "", "", false, 1, true);
         strHtml += CreaTexto("Cantidad a Devolver", "_a_Dev", 0, 10, 10, true, false, "", "left", 0, "", "", "", false, 1);
         strHtml += CreaHidden("hd_can_dev", lstRow.FACD_CAN_DEV);
         strHtml += CreaHidden("hd_series_dev", lstRow.FACD_SERIES_DEV);
         div.innerHTML = strHtml;
         $("#SioNO").dialog("open");
      } else {
         alert("Atenci??n: Ya no hay piezas por devolver");
      }
   }
}
/**Aplica el porcentaje de descuento al producto*/
function CambioPrecSendNC() {
   var grid = jQuery("#NC_GRID");
   var ids = grid.getGridParam("selrow");
   if (ids != null) {
      var dblNvoPrec = d.getElementById("_NvoPrecio").value;
      var bolClean = false;
      if (d.getElementById("_NvoClean1").checked)
         bolClean = true;
      //Calculamos el nuevo precio
      CambioPrecDoNC(ids, dblNvoPrec, bolClean);
   }
}
/**Asigna el nuevo porcentaje de descuento seleccionado por el usuario*/
function CambioPrecDoNC(id, dblNvoPrec, bolClean) {
   var grid = jQuery("#NC_GRID");
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
      //Si el precio real es cero el nuevo precio sera el real
      if (lstRow.FACD_PRECREAL == 0) {
         lstRow.FACD_SINPRECIO = 1;
      }
   }
   lstRowChangePrecioNC(lstRow, id, grid);
   //ponemos el foco para seguir capturando
   document.getElementById("NC_PROD").focus();
}
function Callbtn5NC() {
   $("#Calculator").trigger('click');
}
/**Borramos item*/
function Callbtn7NC() {
   VtaDropNC()
}
/**Mostramos el menu*/
function Callbtn9NC() {
   myLayout.open("west");
   myLayout.open("east");
   myLayout.open("south");
   myLayout.open("north");
   document.getElementById("MainPanel").innerHTML = "";
   //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
   var objMainFacPedi = objMap.getScreen("NCREDITO");
   objMainFacPedi.bolActivo = false;
   objMainFacPedi.bolMain = false;
   objMainFacPedi.bolInit = false;
   objMainFacPedi.idOperAct = 0;
}//Borramos item
//Agregamos notas para la partida
function Callbtn8NC() {
   var grid = jQuery("#NC_GRID");
   var id = grid.getGridParam("selrow");
   if (id != null) {
      var lstRowAct = grid.getRowData(id);
      var strHTML = CreaTextArea(lstMsg[30], "NOTASMOD", lstRowAct.FACD_NOTAS, 5, 80, "", 0, 0, 3, 0);
      strHTML += CreaBoton("", "NOTASBTN", lstMsg[31], "ChangeNotesNC()", "center", false, true, 0);
      $("#dialog2").dialog('option', 'title', lstMsg[29]);
      document.getElementById("dialog2").innerHTML = strHTML;
      $("#dialog2").dialog("option", "width", 500);
      $("#dialog2").dialog("open");
      document.getElementById("NOTASMOD").focus();
   }
}
/**Guarda el cambio de las notas hechas*/
function ChangeNotesNC() {
   var grid = jQuery("#NC_GRID");
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
function SelOperFactNC() {

}

/**Carga la informacion de una operacion de REMISION FACTURA O PEDIDO*/
function getPedidoenVentaNC(intIdPedido, strTipoVta) {
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
      error: function(objeto, quepaso, otroobj) {
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**
 *Establece los parametros del pedido original
 **/
function DrawPedidoenVentaNC(objPedido, lstdeta, strTipoVta) {
   $("#dialogWait").dialog("open");
   document.getElementById("PD_ID").value = objPedido.getAttribute('PD_ID');
   if (strTipoVta == "REMISION") {
      MostrarAvisos(lstMsg[55] + objPedido.getAttribute('PD_ID'))
      document.getElementById("NC_TIPO").value = "NCREDITO";
   }
   document.getElementById("NC_FOLIO").value = objPedido.getAttribute('PD_FOLIO');
   document.getElementById("SC_ID").value = objPedido.getAttribute('SC_ID');
   document.getElementById("FCT_ID").value = objPedido.getAttribute('CT_ID');
   document.getElementById("NC_NOTAS").value = objPedido.getAttribute('PD_NOTAS');
   document.getElementById("NC_NOTASPIE").value = objPedido.getAttribute('PD_NOTASPIE');
   document.getElementById("NC_CONDPAGO").value = objPedido.getAttribute('PD_CONDPAGO');
   document.getElementById("NC_REFERENCIA").value = objPedido.getAttribute('PD_REFERENCIA');
   document.getElementById("NC_NUMPEDI").value = objPedido.getAttribute('PD_NUMPEDI');
   document.getElementById("NC_FECHAPEDI").value = objPedido.getAttribute('PD_FECHAPEDI');
   document.getElementById("NC_ADUANA").value = objPedido.getAttribute('PD_ADUANA');
   if (objPedido.getAttribute('PD_ESRECU') == 1) {
      document.getElementById("NC_ESRECU1").checked = true;
   } else {
      document.getElementById("NC_ESRECU2").checked = false;
   }
   document.getElementById("NC_PERIODICIDAD").value = objPedido.getAttribute('PD_PERIODICIDAD');
   document.getElementById("NC_DIAPER").value = objPedido.getAttribute('PD_DIAPER');
   document.getElementById("VE_ID").value = objPedido.getAttribute('VE_ID');
   ObtenNomCte(objPedido, lstdeta, strTipoVta, true);
}
/**
 *Llenamos el grid con los datos del pedido
 **/
function DrawPedidoDetaenVentaNC(objPedido, lstdeta, strTipoVta) {
   //Generamos el detalle
   for (i = 0; i < lstdeta.length; i++) {
      var obj = lstdeta[i];
      var objImportes = new _ImporteVtaNC();
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
      jQuery("#NC_GRID").addRowData(obj.getAttribute('PDD_ID'), datarow, "last");
   }
   //Realizamos la sumatoria
   setSumNC();
   $("#dialogWait").dialog("close");
}
/**Muestra el label de aviso*/
function MostrarAvisosNC(strMsg) {
   var label = document.getElementById("LABELAVISOS");
   label.innerHTML = strMsg;
   //Mostrar aviso
   label.setAttribute("class", "Mostrar");
   label.setAttribute("className", "Mostrar");
   label.setAttribute("class", "ui-Total");
   label.setAttribute("className", "ui-Total");
}
/**Oculta el label de aviso*/
function OcultarAvisosNC() {
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
   this.bolAplicDescPrec = true;
   this.bolAplicDescPto = true;
   this.bolAplicDescVNego = true;
   this.CalculaImporte = function CalculaImporte() {
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
            if (this.dblPorcDesc == this.dblPorcDescGlobal)
               this.dblPorcAplica = this.dblPorcDesc;
         } else {
            if (this.dblPorcDescGlobal > 0)
               this.dblPorcAplica = this.dblPorcDescGlobal;
            if (this.dblPorcDesc > 0)
               this.dblPorcAplica = this.dblPorcDesc;
         }
         //Calculo de descuento en MLM
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
/**Valida la sucursal al momento de cambiarla*/
function ValidaSucNC() {
   if (parseFloat(document.getElementById("SC_ID").value) == 0)
   {
      document.getElementById("SC_ID").value = intSucDefa;
      InitImpDefault();
   } else {
      InitImpSuc();
   }
}
/**Inicializa los impuestos por default*/
function InitImpDefaultNC() {
   dblTasaVta1 = dblTasa1;
   dblTasaVta2 = dblTasa2;
   dblTasaVta3 = dblTasa3;
   intSImpVta1_2 = intSImp1_2;
   intSImpVta1_3 = intSImp1_3;
   intSImpVta2_3 = intSImp2_3;
}
/**Inicializa los impuestos de la sucursal seleccionada*/
function InitImpSucNC() {
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
            dblTasaVta1 = obj.getAttribute('Tasa1');
            dblTasaVta2 = obj.getAttribute('Tasa2');
            dblTasaVta3 = obj.getAttribute('Tasa3');
            intIdTasaVta1 = obj.getAttribute('TI_ID');
            intIdTasaVta2 = obj.getAttribute('TI_ID2');
            intIdTasaVta3 = obj.getAttribute('TI_ID3');
            d.getElementById("NC_TASASEL1").value = intIdTasaVta1;
            intSImpVta1_2 = obj.getAttribute('SImp1_2');
            intSImpVta1_3 = obj.getAttribute('SImp1_3');
            intSImpVta2_3 = obj.getAttribute('SImp2_3');
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
function RefreshMonedaNC() {
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
function UpdateTasaImpNC() {
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
            dblTasaVta1 = obj.getAttribute('Tasa1');
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
function SelRegDefaNC() {
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


/**Abre el cuadro de dialogo para seleccionar factura*/
function OpnDiagFacIdNC() {
   OpnOpt('VTAS_VIEW', '_ed', 'dialogView', false, false, true);
}

/**Abre el cuadro de dialogo para seleccionar ticket*/
function OpnDiagTktIdNC() {

   OpnOpt('VTAS_VIEW', '_ed', 'dialogView', false, false, true);
}


/*Sirve para obtener en detalle de la fatura o ticket ??ra hacer la devolucion*/
function getDetaDovuluciones(doc) {
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
            DrawFacturaDev(objFactura, lstdeta, "", strPrefijo, strPrefijoDeta);
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
function DrawFacturaDev(objFactura, lstdeta, strTipoVta, strPrefijo, strPrefijoDeta) {
   $("#dialogWait").dialog("open");

   document.getElementById("SC_ID").value = objFactura.getAttribute('SC_ID');
   document.getElementById("NC_NOTAS").value = objFactura.getAttribute(strPrefijo + 'NOTAS');
   document.getElementById("NC_NOTASPIE").value = objFactura.getAttribute(strPrefijo + 'NOTASPIE');
   document.getElementById("NC_CONDPAGO").value = objFactura.getAttribute(strPrefijo + 'CONDPAGO');
   document.getElementById("NC_REFERENCIA").value = objFactura.getAttribute(strPrefijo + 'REFERENCIA');
   document.getElementById("FCT_ID").value = objFactura.getAttribute('CT_ID');
   document.getElementById("CT_NOM").value = objFactura.getAttribute(strPrefijo + 'RAZONSOCIAL');
   document.getElementById("NC_TASASEL1").value = objFactura.getAttribute('TI_ID');
   document.getElementById("FCT_DESCUENTO").value = objFactura.getAttribute(strPrefijo + 'POR_DESCUENTO');
   dblTasaVta1 = objFactura.getAttribute(strPrefijo + 'TASA1');

   DrawFacturaDetaenDev(objFactura, lstdeta, strTipoVta, strPrefijoDeta);
}


/**
 *Llenamos el grid con los datos de la factura
 **/
function DrawFacturaDetaenDev(objFactura, lstdeta, strTipoVta, strPrefijoDeta) {

   /*Limpiamos el grid*/
   jQuery("#NC_GRID").clearGridData();

   //Generamos el detalle
   for (i = 0; i < lstdeta.length; i++) {
      var obj = lstdeta[i];
      var lstSeriesNC = "";
      var lstMPDSeriesNC = "";
      
      //Validamos si usa series para obtenerlas
      if (obj.getAttribute('PR_USO_NOSERIE') == 1) {
         var arrSeries = lstdeta[i].getElementsByTagName("series");
         for (var km = 0; km < arrSeries.length; km++) {
            var obj1 = arrSeries[km];
            if (parseInt(obj1.getAttribute('MPD_SERIE_VENDIDO')) == 1) {
               var bolExiste = false;
               
               //Buscamos que este en la partida del producto actual
               var lstSerie3sAct2 = obj.getAttribute(strPrefijoDeta + 'NOSERIE').split(",");//.replace("!", "")
               for (var po1 = 0; po1 < lstSerie3sAct2.length; po1++) {
                  var strSerieACtTmp1 = lstSerie3sAct2[po1];//.replace("!", "")
                  
                  var strSerieACtTmp2 = obj1.getAttribute('PL_NUMLOTE');//.replace("!", "")
                  
                  if (strSerieACtTmp1 == strSerieACtTmp2) {
                     bolExiste = true
                     break;
                  }
               }
               //Series devueltas
               var bolExisteDev = false;
               var lstSerie3sAct3 = obj.getAttribute(strPrefijoDeta + 'SERIES_DEV').split(",");//.replace("!", "")
               for (var po1 = 0; po1 < lstSerie3sAct3.length; po1++) {
                  var strSerieACtTmp1 = lstSerie3sAct3[po1];//.replace("!", "")
                  var strSerieACtTmp2 = obj1.getAttribute('PL_NUMLOTE');//.replace("!", "")
                  
                  if (strSerieACtTmp1 == strSerieACtTmp2) {
                     bolExisteDev = true
                     break;
                  }
               }
               //Si la serie existe en la factura lo tomamos en cuenta.
               if (bolExiste && !bolExisteDev) {
                  lstSeriesNC += obj1.getAttribute('PL_NUMLOTE').replace("!", "") + ",";
                  lstMPDSeriesNC += obj1.getAttribute('MPD_ID') + ",";
               }
            }
         }
      }

      var objImportes = new _ImporteVtaNC();
      objImportes.dblCantidad = obj.getAttribute(strPrefijoDeta + 'CANTIDAD');
      if (parseInt(obj.getAttribute(strPrefijoDeta + 'EXENTO1')) == 0) {
         objImportes.dblPrecio = parseFloat(obj.getAttribute(strPrefijoDeta + 'PRECIO')) / (1 + (dblTasaVta1 / 100));
         objImportes.dblPrecioReal = parseFloat(obj.getAttribute(strPrefijoDeta + 'PRECREAL')) / (1 + (dblTasaVta1 / 100));
      } else {
         objImportes.dblPrecio = parseFloat(obj.getAttribute(strPrefijoDeta + 'PRECIO'));
         objImportes.dblPrecioReal = parseFloat(obj.getAttribute(strPrefijoDeta + 'PRECREAL'));
      }
      objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
      objImportes.dblPorcDesc = obj.getAttribute(strPrefijoDeta + 'PORDESC');
      objImportes.dblExento1 = obj.getAttribute(strPrefijoDeta + 'EXENTO1');
      objImportes.dblExento2 = obj.getAttribute(strPrefijoDeta + 'EXENTO2');
      objImportes.dblExento3 = obj.getAttribute(strPrefijoDeta + 'EXENTO3');
      objImportes.intDevo = 0;
      objImportes.dblPuntos = parseFloat(obj.getAttribute(strPrefijoDeta + 'PUNTOS'));
      objImportes.dblVNegocio = parseFloat(obj.getAttribute(strPrefijoDeta + 'VNEGOCIO'));
      //Banderas de descuento
      if (obj.getAttribute(strPrefijoDeta + 'DESC_PREC') == 0)
         objImportes.bolAplicDescPrec = false;
      if (obj.getAttribute(strPrefijoDeta + 'DESC_PUNTOS') == 0)
         objImportes.bolAplicDescPto = false;
      if (obj.getAttribute(strPrefijoDeta + 'DESC_VNEGOCIO') == 0)
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
      objImportes.CalculaImporte();
      var dblImporte = objImportes.dblImporte;
      var datarow = {
         FACD_ID: obj.getAttribute(strPrefijoDeta + 'ID'),
         FACD_CANTIDAD: objImportes.dblCantidad,
         FACD_CANTPEDIDO: obj.getAttribute(strPrefijoDeta + 'CANTIDAD'),
         FACD_DESCRIPCION: obj.getAttribute(strPrefijoDeta + 'DESCRIPCION'),
         FACD_IMPORTE: dblImporte,
         FACD_CVE: obj.getAttribute(strPrefijoDeta + 'CVE'),
         FACD_PRECIO: objImportes.dblPrecio,
         FACD_TASAIVA1: obj.getAttribute(strPrefijoDeta + 'TASAIVA1'),
         FACD_DESGLOSA1: 1,
         FACD_IMPUESTO1: objImportes.dblImpuesto1,
         FACD_PR_ID: obj.getAttribute('PR_ID'),
         FACD_EXENTO1: obj.getAttribute(strPrefijoDeta + 'EXENTO1'),
         FACD_EXENTO2: obj.getAttribute(strPrefijoDeta + 'EXENTO2'),
         FACD_EXENTO3: obj.getAttribute(strPrefijoDeta + 'EXENTO3'),
         FACD_REQEXIST: obj.getAttribute('PR_REQEXIST'),
         FACD_EXIST: obj.getAttribute('PR_EXISTENCIA'),
         FACD_NOSERIE: obj.getAttribute(strPrefijoDeta + 'NOSERIE'),
         FACD_ESREGALO: obj.getAttribute(strPrefijoDeta + 'ESREGALO'),
         FACD_IMPORTEREAL: objImportes.dblImporteReal,
         FACD_PRECREAL: objImportes.dblPrecioReal,
         FACD_DESCUENTO: obj.getAttribute(strPrefijoDeta + 'DESCUENTO'),
         FACD_PORDESC: obj.getAttribute(strPrefijoDeta + 'PORDESC'),
         FACD_PRECFIJO: obj.getAttribute(strPrefijoDeta + 'PRECFIJO'),
         FACD_ESDEVO: 0,
         FACD_CODBARRAS: obj.getAttribute('PR_CODBARRAS'),
         FACD_NOTAS: obj.getAttribute(strPrefijoDeta + 'COMENTARIO'),
         FACD_PUNTOS_U: objImportes.dblPuntos,
         FACD_NEGOCIO_U: objImportes.dblVNegocio,
         FACD_PUNTOS: objImportes.dblPuntosImporte,
         FACD_NEGOCIO: objImportes.dblVNegocioImporte,
         FACD_DESC_ORI: obj.getAttribute(strPrefijoDeta + 'DESC_ORI'),
         FACD_REGALO: obj.getAttribute(strPrefijoDeta + 'REGALO'),
         FACD_ID_PROMO: obj.getAttribute(strPrefijoDeta + 'ID_PROMO'),
         FACD_DESC_PREC: obj.getAttribute(strPrefijoDeta + 'DESC_PREC'),
         FACD_DESC_PTO: obj.getAttribute(strPrefijoDeta + 'DESC_PUNTOS'),
         FACD_DESC_VN: obj.getAttribute(strPrefijoDeta + 'DESC_VNEGOCIO'),
         FACD_DESC_LEAL: 0,
         FACD_USA_SERIE: obj.getAttribute('PR_USO_NOSERIE'),
         FACD_SERIES: lstMPDSeriesNC,
         FACD_SERIES_O: lstSeriesNC,
         FACD_CAN_DEV: obj.getAttribute(strPrefijoDeta + 'CAN_DEV'),
         FACD_SERIES_DEV: obj.getAttribute(strPrefijoDeta + 'SERIES_DEV')

      };
      //Anexamos el registro al GRID
      jQuery("#NC_GRID").addRowData(obj.getAttribute(strPrefijoDeta + 'ID'), datarow, "last");
   }
   $("#dialogWait").dialog("close");
}



/**Dibuja el cuadro de dialogo para confirmar los numeros de serie*/
function DrawSelSerieNC(lstRow, dblCantidad, idRow) {
   var strSeries = lstRow.FACD_SERIES;
   var strSeriesO = lstRow.FACD_SERIES_O;

   var lstSeries = strSeries.split(",");
   var lstSeriesO = strSeriesO.split(",");
   var strOptionSelect = "";
   var strOptionSelectDest = "";
   //Ciclo combo origen
   var intContSel1 = 0;
   for (i = 0; i < lstSeriesO.length; i++) {
      var obj = lstSeriesO[i];
      var boolExisteSerie = false;
      for (var y = 0; y < lstSeries.length; y++)
      {
         var objSerie = lstSeries[y];
         if (objSerie == obj)
         {
            boolExisteSerie = true;
            intContSel1++;
            //Evaluamos que no quitemos series que ya no se usan cuando se disminuye la cantidad
            if (boolExisteSerie && intContSel1 > dblCantidad) {
               boolExisteSerie = false;
            }

         }
      }
      if (!boolExisteSerie && obj != "")
         strOptionSelect += "<option value='" + obj + "'>" + obj + "</option>";
   }
   //Ciclo combo destino
   var intContSel = 0;
   for (i = 0; i < lstSeriesO.length; i++) {
      var obj = lstSeriesO[i];
      var boolExisteSerie = false;
      for (var y = 0; y < lstSeries.length; y++)
      {
         var objSerie = lstSeries[y];
         if (objSerie == obj)
         {
            boolExisteSerie = true;
            //  intContSel++;
         }
      }
      if (boolExisteSerie && intContSel <= dblCantidad)
         strOptionSelectDest += "<option value='" + obj - 1 + "'>" + obj - 1 + "</option>";
   }
   //Evaluamos si disminuyeron la cantidad para ajustar contadores
   if (intContSel > dblCantidad) {
      intContSel = dblCantidad;
   }
   //Abrimos un cuadro de dialogo y dibujamos en el los items
   // por capturar el codigo de barras
   $("#dialog2").dialog("open");
   $('#dialog2').dialog('option', 'title', lstMsg[107]);
   var strHTML = "<input type='hidden' id='_Pr_Id' value='" + lstRow.PDD_PR_ID + "'>";
   strHTML += "<input type='hidden' id='_Cantidad' value='" + dblCantidad + "'>";
   strHTML += "<input type='hidden' id='_idRow' value='" + idRow + "'>";
   strHTML += "<table border=0 cellpadding=0>";
   strHTML += "<tr>";
   strHTML += "<td colspan=3>" + lstMsg[110] + "</td>";
   strHTML += "</tr>";
   strHTML += "<tr>";
   strHTML += "<td nowrap>&nbsp;" + lstMsg[172] + "<input type='text' id='search_cant' value='" + dblCantidad + "' size='8' readonly disabled></td>";
   strHTML += "<td nowrap>&nbsp;</td>";
   strHTML += "<td nowrap>&nbsp;" + lstMsg[173] + "<input type='text' id='search_cant_sel' value='" + intContSel + "' size='8' readonly disabled></td>";
   strHTML += "</tr>";
   strHTML += "<tr>";
   strHTML += "<td >" + lstMsg[174] + "<br><select id='series_origen' multiple>" + strOptionSelect + "</select></td>";
   strHTML += "<td ><input type='button' id='Agregar' value='" + lstMsg[176] + "' onclick='AgregaSerieNC()'><br><input type='button' id='Quitar' value='" + lstMsg[177] + "' onClick='RemueveSerieNC()'></td>";
   strHTML += "<td >" + lstMsg[175] + "<br><select id='series_destino' multiple >" + strOptionSelectDest + "</select></td>";
   strHTML += "</tr>";

   strHTML += "<tr>";
   strHTML += "<td>" + CreaBoton("", "ConfirmNoSerie1", lstMsg[111], "ConfirmNumSerieNC();", "left", false, false) + "</td>";
   strHTML += "<td>&nbsp;</td>";
   strHTML += "<td>" + CreaBoton("", "CancelNoSerie2", lstMsg[112], "CancelNumSerieNC();", "left", false, false) + "</td>";
   strHTML += "</tr>"
   strHTML += "</table>";
   document.getElementById("dialog2_inside").innerHTML = strHTML;


}
/**Guarda los numeros de serie de los productos seleccionados*/
function SaveSelSeries() {

}

/**Agrega numeros de serie seleccionados  */
function AgregaSerieNC() {
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
function RemueveSerieNC() {
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
function ConfirmNumSerieNC() {
   var intXSurtir = parseInt(document.getElementById("search_cant").value);
   var intSurtido = parseInt(document.getElementById("search_cant_sel").value);
   if (intXSurtir == intSurtido) {
      var _idProd = document.getElementById("_idRow").value;
      var objSelDest = document.getElementById("series_destino");
      //Armamos cadena con numeros de serie
      var _strSeries = "";
      for (var x = 0; x < objSelDest.length; x++) {
         _strSeries += objSelDest[x].value + ",";
      }
      $("#dialog2").dialog("close");
      //Recuperamos los valores del producto
      var grid = jQuery("#NC_GRID");
      var lstRow = grid.getRowData(_idProd);
      //Recalculamos la cantidad
      lstRow.FACD_CAN_DEV = parseFloat(lstRow.FACD_CAN_DEV) + parseFloat(document.getElementById("hd_can_dev").value);
      lstRow.FACD_SERIES_DEV = lstRow.FACD_SERIES_DEV + _strSeries;
      lstRow.FACD_DEVOLVER = document.getElementById("_a_Dev").value;
      grid.setRowData(_idProd, lstRow);
      lstRowChangePrecioNC(lstRow, _idProd, grid);

      $("#dialogWait").dialog("close");
   } else {
      alert(lstMsg[179]);
   }
}
/**Cancela la captura de numeros de serie*/
function CancelNumSerieNC() {
   $("#dialog2").dialog("close");
   _objProdTmpz = null;
}

function  reloadTotalesIdRow(id) {
   //Obtenemos los id's del grid

   var grid = jQuery("#NC_GRID");
   var arr = grid.getDataIDs();
   var dblPu = 0;
   var tasaIva = 0;
   //recorremos cada fila del row
   for (var i = 0; i < arr.length; i++) {
      var idRow = arr[i];

      if (idRow == id) {
         //Sacamos datos de la fila
         var lstRow = grid.getRowData(idRow);
         dblPu = parseFloat(lstRow.FACD_IMPORTE) / parseFloat(lstRow.FACD_CANTIDAD);
         lstRow.FACD_IMPORTE = dblPu;
         grid.setRowData(id, lstRow);
      }
   }

   //Sacamos totales   
   regresarAll();
}


function  regresarAll() {
   //Obtenemos los id's del grid
   var grid = jQuery("#NC_GRID");
   var arr = grid.getDataIDs();
   var dblSubt = 0;
   //recorremos cada fila del row
   for (var i = 0; i < arr.length; i++) {
      var idRow = arr[i];
      //por cada fila extraemos los datos
      var lstRow = grid.getRowData(idRow);
      if (lstRow.FACD_DEVOLVER != 0.0) {
         dblSubt += parseFloat(lstRow.FACD_IMPORTE);
      }
   }

   d.getElementById("NC_IMPORTE").value = dblSubt;
   d.getElementById("NC_IMPUESTO1").value = dblSubt;
   d.getElementById("NC_TOT").value = dblSubt;
}
//Parrila de captura
function clickVentanaNC()
{
   $("#dialogPCaptura").dialog("open");
   $('#dialogPCaptura').dialog('option', 'title', "PARRILLA DE CAPTURA");
   var strHTML = "<td>Capture el modelo o clave corta:<input type='text' id = 'txtModelo'>";
   strHTML += "<td>" + CreaBoton("", "btnAgregar", "Agregar", "BuscaModeloNC();", "left", false, false);
   strHTML += "<div id='TablaP'>";
   strHTML += "</div>";
   strHTML += "Total de Piezas:<input type='text' id = 'TotalP' value='0.0' disabled>";
   strHTML += "<p><input type='hidden' id = 'TotalM' value='0.0' disabled></p>";
   strHTML += "<p><input type='hidden' id = 'Descuento' value='0.0' onBlur='CalculaValoresNC()'></p>";
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
   strHTML += "<td>" + CreaBoton("", "btnAceptar", "Aceptar", "AceptarBotonNC();", "left", false, false);
   strHTML += "<td>&nbsp;</td>";
   strHTML += "<td>" + CreaBoton("", "btnCancelar", "Cancelar", "CancelarBotonNC();", "left", false, false);
   document.getElementById("dialogPCaptura_inside").innerHTML = strHTML;



}

function BuscaModeloNC()
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
      success: function(datos) {
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
            var objControl = new Control("idModelo" + idT, "text", 10, obj.getAttribute("Modelo"), 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            objCelda.AnadeCeldaContenido(obj.getAttribute("Descripcion"));



            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idColor" + idT, "text", 10, obj.getAttribute("Color"), 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            //                var objCelda = objFila.AnadeCelda("","","","");
            //                objCelda.AnadeCeldaContenido(obj.getAttribute("Tallas"));
            //                
            //                
            //                var objCelda = objFila.AnadeCelda("","","","");
            //                var objControl = new Control("idPP"+idT,"text",10,obj.getAttribute("P.Publico"),8,"",false,true);
            //                objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idCH" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idM" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idG" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idXG" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idRN" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("id3M" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("id6M" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("id12M" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("id18M" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("id24M" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());


            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idPiezas" + idT, "text", 10, "0", 8, "RecalculoNC()", false, true);
            objCelda.AnadeCeldaControl(objControl.CreaControl());

            //                var objCelda = objFila.AnadeCelda("","","","");
            //                objCelda.AnadeCeldaContenido(obj.getAttribute("Piezas"));

            //                var objCelda = objFila.AnadeCelda("","","","");
            //                var objControl = new Control("idTOTAL"+idT,"text",10,"0.0",8,"RecalculoNC()",true,true);
            //                objCelda.AnadeCeldaControl(objControl.CreaControl());

            //Habilitamos las casillas tallas que tiene disponible en ese color
            var lstTallas = obj.getAttribute("Tallas").split(",");

            var objCelda = objFila.AnadeCelda("", "", "", "");
            var objControl = new Control("idTallas" + idT, "hidden", 10, lstTallas, 8, "RecalculoNC()", false, true);
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
      error: function(objeto, quepaso, otroobj) {
         alert(":Series pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });

}

function AceptarBotonNC()
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
      success: function(datos) {
         var lstXml = datos.getElementsByTagName("ElementosT")[0];
         var lstElementos = lstXml.getElementsByTagName("ElementoT");
         var bolFind = false;
         for (var i = 0; i < lstElementos.length; i++) {

            var obj2 = lstElementos[i];
            var objImportes = new _ImporteVtaNC();
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
            jQuery("#NC_GRID").addRowData(itemId, datarow, "last");
            d.getElementById("NC_PRECIO").value = dblPrecio;
            d.getElementById("NC_PROD").value = "";
            d.getElementById("NC_PROD").focus();
            d.getElementById("NC_CANT").value = 1;
//                d.getElementById("FAC_DEVO").value = 0;
            bolFind = true;
            //Sumamos todos los items
            //_PromocionProd(itemId);
            //Validamos el cambio de sucursal
            setSumNC();
            EvalSucursalNC();


         }
         //Validamos si no nos devolvieron precio es porque el CLIENTE no existe
         if (!bolFind) {
            //ObtenNomCte();
         }
         CancelarBotonNC();
         $("#dialogPCaptura").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":Series pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}

function CancelarBotonNC()
{
   $("#dialogPCaptura").dialog("close");
   objTabla = null;
   numFilas = 0;
   idT = 0;
}

function RecalculoNC()
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

      //        CalculaValoresNC();
      //alert(TotalPiezas + ":" +document.getElementById("idPiezas"+i).value);
   }

//alert(document.getElementById(""+id));
}

function CalculaValoresNC()
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

/**Imprime el ticket directamente a la impresora*/
function ImprimeconFolioNC(strKey, strNomFormat, intOpt) {
   strNomFormat += "1";
   $.ajax({
      type: "POST",
      data: "ID=" + strKey + "&NOM_FORMATO=" + strNomFormat,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "html",
      url: "ERP_Varios.jsp?id=" + intOpt,
      success: function(datos) {

         var miapplet = document.getElementById("PrintTickets");
         miapplet.DoImpresion(datos,
                 strCodEscape, strImpresora);
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":ImprimeFolio:" + objeto + " " + quepaso + " " + otroobj);
      }
   });

}

function CallTicketDataNC(event, obj) {
   if (event.keyCode == 13) {
      getDetaDovuluciones("_tkt");
   }
}