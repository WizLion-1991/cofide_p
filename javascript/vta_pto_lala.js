
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
function vta_pto_lala(){//Funcion necesaria para que pueda cargarse la libreria en automatico
}
/**Inicializa la pantalla de punto de venta*/
function InitPtoVtalala(){
   $("#dialogWait").dialog("open");
   myLayout.close( "west");
   myLayout.close( "east");
   myLayout.close( "south");
   myLayout.close( "north");
   //Ocultamos renglon de avisos
   OcultarAvisoslala();
   //Ponemos el nombre default de la sucursal
   d.getElementById("SC_ID").value = intSucDefa;
   //Hacemos diferente el estilo del total
   FormStylelala();
   //Obtenemos el id del cliente y el vendedor default
   d.getElementById("FCT_ID").value = intCteDefa;
   d.getElementById("FAC_OPER").value = strUserName;
   d.getElementById("FAC_TASASEL1").value = intIdTasaVta1;
   d.getElementById("FAC_PROD").focus();
   ObtenNomCtelala();
   //Realizamos el menu de botones
   var strHtml = "<ul>"+
   getMenuItem("Callbtn0_lala();","Guardar Venta","images/ptovta/CircleSave.png")+
   getMenuItem("Callbtn1_lala();","Nueva Venta","images/ptovta/VisPlus.png")+
   getMenuItem("Callbtn2_lala();","Consultar Venta","images/ptovta/VisMagnifier.png")+
   getMenuItem("Callbtn3_lala();","Descuento","images/ptovta/VisSciss.png")+
   getMenuItem("Callbtn4_lala();","Cambio Precio","images/ptovta/VisModi.png")+
   getMenuItem("Callbtn8();","Notas","images/ptovta/VisNote.png")+
   getMenuItem("Callbtn6();","Devolucion","images/ptovta/VisLess.png")+
   getMenuItem("Callbtn7();","Borrar Producto","images/ptovta/VisClose.png")+
   getMenuItem("Callbtn9();","Salir","images/ptovta/exitBig.png")+
   "</ul>";
   document.getElementById("TOOLBAR").innerHTML = strHtml;
   //Obtenemos los atributos(permisos) del usuario para esta pantalla
   bolCambioFecha = false;
   $.ajax({
      type: "POST",
      data: "keys=43,44,45,85",
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "Acceso.do",
      success: function(datos){
         var objsc = datos.getElementsByTagName("Access")[0];
         var lstKeys = objsc.getElementsByTagName("key");
         for(i=0;i<lstKeys.length;i++){
            var obj = lstKeys[i];
            if(obj.getAttribute('id') == 43 && obj.getAttribute('enabled') == "true"){
               bolPorc = true;
            }
            if(obj.getAttribute('id') == 44 && obj.getAttribute('enabled') == "true"){
               bolPrice = true;
            }
            if(obj.getAttribute('id') == 45 && obj.getAttribute('enabled') == "true"){
               bolDevol = true;
            }
            if(obj.getAttribute('id') == 85 && obj.getAttribute('enabled') == "true"){
               bolCambioFecha = true;
            }
         }
         //Validamos si podemos hacer cambio de fecha
         if(bolCambioFecha){
            if($('#FAC_FECHA').datepicker("isDisabled")){
               $('#FAC_FECHA').datepicker("enable")
            }
            var objFecha = document.getElementById("FAC_FECHA");
            objFecha.setAttribute("class","outEdit");
            objFecha.setAttribute("className","outEdit");
            objFecha.readOnly = false;
         }else{
            $('#FAC_FECHA').datepicker("disable")
         }
         $("#dialogWait").dialog("close");
         //Foco inicial
         setTimeout("d.getElementById('FAC_PROD').focus();", 3000);
         //Seleciona el tipo de operacion de venta
         SelOperFactlala();
      },
      error: function(objeto, quepaso, otroobj){
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
   //Definimos acciones para el dialogo SI/NO
   document.getElementById("btnSI").onclick= function() {
      ConfirmaSIlala();
   };
   document.getElementById("btnNO").onclick= function() {
      ConfirmaNOlala();
   };
}
/**Cambia los estilos de algunos controles*/
function FormStylelala(){
   d.getElementById("FAC_TOT").setAttribute("class","ui-Total");
   d.getElementById("FAC_TOT").setAttribute("className","ui-Total");
   d.getElementById("btn1").setAttribute("class","Oculto");
   d.getElementById("btn1").setAttribute("className","Oculto");
}
/**Obtiene el nombre del cliente al que se le esta haciendo la venta*/
function ObtenNomCtelala(objPedido,lstdeta,strTipoVta,bolPasaPedido){
   var intCte = document.getElementById("FCT_ID").value;
   if(bolPasaPedido == undefined)bolPasaPedido = false;
   ValidaClean("CT_NOM");
   $.ajax({
      type: "POST",
      data: "CT_ID=" + intCte,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "VtasMov.do?id=9",
      success: function(datoVal){
         var objCte = datoVal.getElementsByTagName("vta_clientes")[0];
         if(objCte.getAttribute('CT_ID') == 0){
            document.getElementById("CT_NOM").value = "***************";
            ValidaShow("CT_NOM",lstMsg[28]);
         }else{
            document.getElementById("CT_NOM").value = objCte.getAttribute('CT_RAZONSOCIAL');
            document.getElementById("FCT_LPRECIOS").value = objCte.getAttribute('CT_LPRECIOS');
            document.getElementById("FCT_DESCUENTO").value = objCte.getAttribute('CT_DESCUENTO');
            document.getElementById("FCT_DIASCREDITO").value = objCte.getAttribute('CT_DIASCREDITO');
            document.getElementById("FCT_MONTOCRED").value = objCte.getAttribute('CT_MONTOCRED');
            intCT_TIPOPERS = objCte.getAttribute('CT_TIPOPERS');
            intCT_TIPOFAC = objCte.getAttribute('CT_TIPOFAC');
            strCT_USOIMBUEBLE = objCte.getAttribute('CT_USOIMBUEBLE');
         }
         //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
         if(bolPasaPedido){
            DrawPedidoDetaenVentalala(objPedido,lstdeta,strTipoVta);
         }
      },
      error: function(objeto, quepaso, otroobj){
         document.getElementById("CT_NOM").value = "***************";
         ValidaShow("CT_NOM",lstMsg[28]);
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Obtiene el nombre del vendedor al que se le esta haciendo la venta*/
function ObtenNomVendlala(){
   var intVend = document.getElementById("VE_ID").value;
   $.ajax({
      type: "POST",
      data: "VE_ID=" + intVend,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "CIP_TablaOp.jsp?ID=4&opnOpt=VENDEDOR",
      success: function(datoVal){
         var objVend = datoVal.getElementsByTagName("vta_vendedores")[0];
         document.getElementById("VE_NOM").value = objVend.getAttribute('VE_NOMBRE');
      },
      error: function(objeto, quepaso, otroobj){
         alert(":pto2:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Funcion para anadir partidas*/
function AddItemEvt(event,obj){
   if(event.keyCode == 13){
      AddItem();
   }
}
/**Funcion para anadir partidas, valida que el producto exista, luego obtiene el precio y lo anade al GRID*/
function AddItem(){
   var strCod = UCase(d.getElementById("FAC_PROD").value);
   //Validamos que hallan capturado un codigo
   if(trim(strCod) != ""){
      var intDevo = d.getElementById("FAC_DEVO").value;
      //Bandera para indicar si no se agrupan los items
      var bolAgrupa = d.getElementById("FAC_AGRUPA1").checked;
      $("#dialogWait").dialog("open");
      var bolNvo = true;
      var idProd = 0;
      //Si esta activada la funcionalidad de agrupar validamos si existe
      if(bolAgrupa){
         //Revisamos si existe el item en el grid
         var grid = jQuery("#FAC_GRID");
         var arr = grid.getDataIDs();
         for(var i= 0;i<arr.length;i++){
            var id = arr[i];
            var lstRowAct = grid.getRowData(id);
            if(lstRowAct.FACD_CVE == strCod ||
               lstRowAct.FACD_CODBARRAS == strCod){
               if(intDevo == 1){
                  if(lstRow.FACD_ESDEVO == 1){
                     idProd = id;
                     bolNvo = false;
                     break;
                  }
               }else{
                  idProd = id;
                  bolNvo = false;
                  break;
               }
            }
         }
      }
      //Validamos si es un producto nuevo
      if(bolNvo){
         //Buscamos los importes ya que es un producto nuevo
         $.ajax({
            type: "POST",
            data: "PR_CODIGO=" + strCod +"&SC_ID="+d.getElementById("SC_ID").value,
            scriptCharset: "utf-8" ,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType:"xml",
            url: "HM_ventas.jsp?id=5",
            success: function(datoVal){
               var objProd = datoVal.getElementsByTagName("vta_productos")[0];
               var Pr_Id = 0;
               if(objProd != undefined){
                  Pr_Id = objProd.getAttribute('PR_ID');
                  d.getElementById("FAC_DESC").value = objProd.getAttribute('PR_DESCRIPCION');
                  //Reemplazamos el codigo del producto por el de la bd
                  if(Pr_Id != 0){
                     strCod = objProd.getAttribute('PR_CODIGO');
                  }
               }
               var Ct_Id = d.getElementById("FCT_ID").value;
               var dblCantidad = d.getElementById("FAC_CANT").value;
               //Validamos si nos regreso un ID de producto valido
               if(Pr_Id != 0){
                  //Validamos la existencia
                  var dblExistencia = 0;
                  if(objProd.getAttribute('PR_REQEXIST') == 1 &&
                     document.getElementById("FAC_TIPO").value != 3){
                     //Obtenemos la existencia del producto
                     $.ajax({
                        type: "POST",
                        data: "PR_ID=" + Pr_Id,
                        scriptCharset: "utf-8" ,
                        contentType: "application/x-www-form-urlencoded;charset=utf-8",
                        cache: false,
                        dataType:"html",
                        url: "InvMov.do?id=1",
                        success: function(datoExist){
                           dblExistencia = parseFloat(datoExist);
                           //Validamos que no estemos pidiendo mas de la existencia
                           if(parseFloat(dblCantidad) > dblExistencia){
                              alert(lstMsg[3] + "(" + dblCantidad + ") " + lstMsg[34] + strCod + "(" + dblExistencia + ") " + lstMsg[4]);
                              if(parseFloat(dblExistencia) > 0){
                                 dblCantidad = dblExistencia;
                              }else{
                                 dblCantidad = 0;
                              }
                           }
                           AddItemPrec(objProd,Pr_Id,Ct_Id,dblCantidad,strCod,dblExistencia,intDevo);
                        },
                        error: function(objeto, quepaso, otroobj){
                           alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
                           $("#dialogWait").dialog("close");
                        }
                     });
                  }else{
                     AddItemPrec(objProd,Pr_Id,Ct_Id,dblCantidad,strCod,dblExistencia,intDevo);
                  }
               }else{
                  alert(lstMsg[0]);
                  d.getElementById("FAC_DEVO").value = 0;
                  document.getElementById("FAC_PROD").focus();
                  $("#dialogWait").dialog("close");
               }
            },
            error: function(objeto, quepaso, otroobj){
               alert(":pto3:" + objeto + " " + quepaso + " " + otroobj);
               $("#dialogWait").dialog("close");
            }
         });
      }else{
         //Ya existe el item
         var Cantidad = d.getElementById("FAC_CANT").value;//Cantidad solicitada
         //Recuperamos los valores del producto
         var gridD = jQuery("#FAC_GRID");
         var lstRow = gridD.getRowData(idProd);
         //Recalculamos la cantidad
         lstRow.FACD_CANTIDAD = parseFloat(lstRow.FACD_CANTIDAD) + parseFloat(Cantidad);
         //Validamos existencias en caso de que aplique
         if(lstRow.FACD_REQEXIST == 1 &&
            document.getElementById("FAC_TIPO").value != 3){
            if(parseFloat(lstRow.FACD_CANTIDAD)>parseFloat(lstRow.FACD_EXIST)){
               alert(lstMsg[3] + " " + lstRow.FACD_CVE + " " + lstMsg[4]);
               if(parseFloat(lstRow.FACD_EXIST) > 0){
                  lstRow.FACD_CANTIDAD = lstRow.FACD_EXIST;
               }else{
                  lstRow.FACD_CANTIDAD = 0;
               }
            }
         }
         //Recalculamos el importe y actualizamos la fila
         lstRowChangePreciolala(lstRow,idProd,gridD);
         //Ponemos foco en el control
         document.getElementById("FAC_PROD").value = "";
         document.getElementById("FAC_PROD").focus();
         d.getElementById("FAC_CANT").value = 1;
         d.getElementById("FAC_DEVO").value = 0;
         //Sumamos todos los items
         setSumlala();
         $("#dialogWait").dialog("close");
      }
   }
}
/**Vuelva a calcular el precio para una fila del grid*/
function lstRowChangePreciolala(lstRow,idUpdate,grid){
   var objImportes = new _ImporteVtalala();
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
   objImportes.intPrecioZeros = lstRow.FACD_SINPRECIO;
   objImportes.CalculaImportelala();
   //Asignamos nuevos importes
   lstRow.FACD_IMPORTE = objImportes.dblImporte;
   lstRow.FACD_IMPUESTO1 =objImportes.dblImpuesto1;
   lstRow.FACD_PORDESC =objImportes.dblPorcAplica;
   if(parseFloat(objImportes.dblPorcAplica) > 0){
      lstRow.FACD_DESCUENTO = parseFloat(objImportes.dblImporteReal) - parseFloat(objImportes.dblImporte);
   }else{
      lstRow.FACD_DESCUENTO = 0;
   }
   lstRow.FACD_IMPORTEREAL = objImportes.dblImporteReal;
   //Actualizamos el grid
   grid.setRowData( idUpdate, lstRow);
   //Sumamos todos los items
   setSumlala();
}
/**Añade una nueva partida al GRID*/
function AddItemPrec(objProd,Pr_Id,Ct_Id,Cantidad,strCod,dblExist,intDevo){
   //Consultamos el precio del producto
   $.ajax({
      type: "POST",
      data: "PR_ID=" + Pr_Id +"&CT_LPRECIOS=" + document.getElementById("FCT_LPRECIOS").value +
      "&CANTIDAD="+Cantidad,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "DamePrecio.do?id=4",
      success: function(datoPrec){
         var bolFind = false;
         //Procesamos el XML y lo anadimos al GRID
         var lstXml = datoPrec.getElementsByTagName("Precios")[0];
         var lstprecio = lstXml.getElementsByTagName("Precio");
         for(var i=0;i<lstprecio.length;i++){
            var obj2 = lstprecio[i];
            var objImportes = new _ImporteVtalala();
            objImportes.dblCantidad = Cantidad;
            objImportes.dblPrecio = parseFloat(obj2.getAttribute('precio'));
            objImportes.dblPrecioReal = parseFloat(obj2.getAttribute('precio'));
            objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
            objImportes.dblExento1 = objProd.getAttribute('PR_EXENTO1');
            objImportes.dblExento2 = objProd.getAttribute('PR_EXENTO2');
            objImportes.dblExento3 = objProd.getAttribute('PR_EXENTO3');
            objImportes.intDevo = intDevo;
            objImportes.CalculaImportelala();
            var dblImporte = objImportes.dblImporte;
            var datarow = {
               FACD_ID:0,
               FACD_CANTIDAD:Cantidad,
               FACD_DESCRIPCION:objProd.getAttribute('PR_DESCRIPCION'),
               FACD_IMPORTE:dblImporte,
               FACD_CVE:strCod,
               FACD_PRECIO:obj2.getAttribute('precio'),
               FACD_TASAIVA1:dblTasa1,
               FACD_DESGLOSA1:1,
               FACD_IMPUESTO1:objImportes.dblImpuesto1,
               FACD_PR_ID:Pr_Id,
               FACD_EXENTO1:objProd.getAttribute('PR_EXENTO1'),
               FACD_EXENTO2:objProd.getAttribute('PR_EXENTO2'),
               FACD_EXENTO3:objProd.getAttribute('PR_EXENTO3'),
               FACD_REQEXIST:objProd.getAttribute('PR_REQEXIST'),
               FACD_EXIST:dblExist,
               FACD_NOSERIE:"",
               FACD_ESREGALO:0,
               FACD_IMPORTEREAL:dblImporte,
               FACD_PRECREAL:obj2.getAttribute('precio'),
               FACD_DESCUENTO:0.0,
               FACD_PORDESC:objImportes.dblPorcAplica,
               FACD_PRECFIJO:0,
               FACD_ESDEVO:intDevo,
               FACD_CODBARRAS:objProd.getAttribute('PR_CODBARRAS'),
               FACD_NOTAS:""
            };
            //Anexamos el registro al GRID
            itemId++;
            jQuery("#FAC_GRID").addRowData(itemId,datarow,"last");
            d.getElementById("FAC_PRECIO").value = obj2.getAttribute('precio');
            d.getElementById("FAC_PROD").value = "";
            d.getElementById("FAC_PROD").focus();
            d.getElementById("FAC_CANT").value = 1;
            d.getElementById("FAC_DEVO").value = 0;
            bolFind = true;
            //Sumamos todos los items
            setSumlala();
            //Validamos el cambio de sucursal
            EvalSucursallala();
         }
         //Validamos si no nos devolvieron precio es porque el CLIENTE no existe
         if(!bolFind){
            ObtenNomCtelala();
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj){
         alert(":pto4:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Borra el item seleccionado*/
function VtaDroplala(){
   var grid = jQuery("#FAC_GRID");
   if(grid.getGridParam("selrow") != null){
      grid.delRowData( grid.getGridParam("selrow"));
      document.getElementById("FAC_PROD").focus();
      //Sumamos todos los items
      setSumlala();
      //Validamos el cambio de sucursal
      EvalSucursallala();
   }
}
/*Suma todos los items de la venta y nos da el total**/
function setSumlala(){
   var grid = jQuery("#FAC_GRID");
   var arr = grid.getDataIDs();
   var dblSuma = 0;
   var dblImpuesto1 = 0;
   var dblImporte = 0;
   for(var i= 0;i<arr.length;i++){
      var id = arr[i];
      var lstRow = grid.getRowData(id);
      dblSuma += parseFloat(lstRow.FACD_IMPORTE);
      dblImpuesto1 += parseFloat(lstRow.FACD_IMPUESTO1);
      dblImporte += (parseFloat(lstRow.FACD_IMPORTE) - parseFloat(lstRow.FACD_IMPUESTO1));

   }
   d.getElementById("FAC_TOT").value = FormatNumber(dblSuma,intNumdecimal,true);
   d.getElementById("FAC_IMPUESTO1").value = FormatNumber(dblImpuesto1,intNumdecimal,true);
   d.getElementById("FAC_IMPORTE").value = FormatNumber(dblImporte,intNumdecimal,true);
   //Activamos recibos de honorarios si proceden SOLO EN CASO DE FACTURAS
   if(parseInt(intEMP_TIPOPERS) == 2 && intCT_TIPOPERS == 1
      && parseInt(d.getElementById("FAC_TIPO").value) == 1){
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
      document.getElementById("FAC_RETISR").value = FormatNumber(dblRetIsr,intNumdecimal,true);
      document.getElementById("FAC_RETIVA").value = FormatNumber(dblRetIVA,intNumdecimal,true);
      document.getElementById("FAC_NETO").value = FormatNumber(dblImpNeto,intNumdecimal,true);
      //Activamos los recibos de honorarios
      document.getElementById("FAC_RETISR").parentNode.parentNode.style.display = 'block';
      document.getElementById("FAC_RETIVA").parentNode.parentNode.style.display = 'block';
      document.getElementById("FAC_NETO").parentNode.parentNode.style.display = 'block';
   }else{
      //Activamos los recibos de honorarios
      document.getElementById("FAC_RETISR").parentNode.parentNode.style.display = 'none';
      document.getElementById("FAC_RETIVA").parentNode.parentNode.style.display = 'none';
      document.getElementById("FAC_NETO").parentNode.parentNode.style.display = 'none';
   }
}
/**Obtiene la lista de items de la factura para enviarlos al jsp de las promociones*/
function getLstItems(){

}
/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagCte(){
   OpnOpt('CLIENTES','grid','dialogCte',false,false);
}
/**Abre el cuadro de dialogo para buscar vendedor o dar de alta uno nuevo*/
function OpnDiagVend(){
   OpnOpt('VENDEDOR','grid','dialogVend',false,false);
}
/**Abre el cuadro de dialogo para buscar productos o dar de alta uno nuevo*/
function OpnDiagProd(){
   OpnOpt('PROD','grid','dialogProd',false,false);
}
/**Realizar la operacion de guardado de la venta mostrando primero la pantalla de pago*/
function SaveVtalala(){
   //Validamos si el total es igual a cero
   if(parseFloat(document.getElementById("FAC_TOT").value)== 0){
      alert(lstMsg[56]);
   }else{
      if(d.getElementById("TOTALXPAGAR") != null){
         if(parseInt(intEMP_TIPOPERS) == 2 && intCT_TIPOPERS == 1
            && parseInt(d.getElementById("FAC_TIPO").value) == 1){
            d.getElementById("TOTALXPAGAR").value = d.getElementById("FAC_NETO").value;
         }else{
            d.getElementById("TOTALXPAGAR").value = d.getElementById("FAC_TOT").value;
         }
      }
      //Validamos el tipo de venta
      /*if(document.getElementById("FAC_TIPO").value != "3"){
         OpnOpt('FORMPAGO','_ed','dialogPagos',false,false);
      }else{*/
         SaveVtaDolala();
      //}
   }
}
/**Guarda la venta*/
function SaveVtaDolala(){
   $("#dialogPagos").dialog("close");
   $("#dialogWait").dialog("open");
   //Armamos el POST a enviar
   var strPOST = "";
   //Prefijos dependiendo del tipo de venta
   var strPrefijoMaster = "TKT";
   var strPrefijoDeta = "TKTD";
   var strKey = "TKT_ID";
   var strNomFormat = "TICKET";
   if(d.getElementById("FAC_TIPO").value == "1"){
      //Factura
      strPrefijoMaster = "FAC";
      strPrefijoDeta = "FACD";
      strKey = "FAC_ID";
      strNomFormat = "FACTURA";
   }
   if(d.getElementById("FAC_TIPO").value == "3"){
      //Pedido
      strPrefijoMaster = "PD";
      strPrefijoDeta = "PDD";
      strKey = "PD_ID";
      strNomFormat = "PEDIDO";
   }
   if(d.getElementById("FAC_TIPO").value == "4"){
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
   strPOST += "&" + strPrefijoMaster + "_ESSERV=0";
   strPOST += "&" + strPrefijoMaster + "_MONEDA="+d.getElementById("FAC_MONEDA").value;
   strPOST += "&" + strPrefijoMaster + "_FECHA=" + d.getElementById("FAC_FECHA").value;
   strPOST += "&" + strPrefijoMaster + "_FOLIO=" + d.getElementById("FAC_FOLIO").value;
   strPOST += "&" + strPrefijoMaster + "_NOTAS=" + d.getElementById("FAC_NOTAS").value;
   strPOST += "&" + strPrefijoMaster + "_TOTAL=" + d.getElementById("FAC_TOT").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO1=" + d.getElementById("FAC_IMPUESTO1").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO2=" + d.getElementById("FAC_IMPUESTO2").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO3=" + d.getElementById("FAC_IMPUESTO3").value;
   strPOST += "&" + strPrefijoMaster + "_IMPORTE=" + d.getElementById("FAC_IMPORTE").value;
   strPOST += "&" + strPrefijoMaster + "_RETISR=" + d.getElementById("FAC_RETISR").value;
   strPOST += "&" + strPrefijoMaster + "_RETIVA=" + d.getElementById("FAC_RETIVA").value;
   strPOST += "&" + strPrefijoMaster + "_NETO=" + d.getElementById("FAC_NETO").value;
   strPOST += "&" + strPrefijoMaster + "_NOTASPIE=" + d.getElementById("FAC_NOTASPIE").value;
   strPOST += "&" + strPrefijoMaster + "_REFERENCIA=" + d.getElementById("FAC_REFERENCIA").value;
   strPOST += "&" + strPrefijoMaster + "_CONDPAGO=" + d.getElementById("FAC_CONDPAGO").value;
   strPOST += "&" + strPrefijoMaster + "_NUMPEDI=" + d.getElementById("FAC_NUMPEDI").value;
   strPOST += "&" + strPrefijoMaster + "_FECHAPEDI=" + d.getElementById("FAC_FECHAPEDI").value;
   strPOST += "&" + strPrefijoMaster + "_ADUANA=" + d.getElementById("FAC_ADUANA").value;
   strPOST += "&" + strPrefijoMaster + "_TIPOCOMP=" + d.getElementById("FAC_TIPOCOMP").value;
   strPOST += "&TIPOVENTA=" + d.getElementById("FAC_TIPO").value;
   strPOST +="&HM_DIV=" + d.getElementById("HM_DIV").value;
   strPOST +="&HM_SOC=" + d.getElementById("HM_SOC").value;
   strPOST +="&HM_ON=" + d.getElementById("HM_ON").value;
   strPOST +="&HM_REFERENCEDATE=" + d.getElementById("HM_REFERENCEDATE").value;
   strPOST +="&HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY=" + d.getElementById("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY").value;
   strPOST += "&" + strPrefijoMaster + "_TASA1=" + dblTasaVta1;
   strPOST += "&" + strPrefijoMaster + "_TASA2=" + dblTasaVta2;
   strPOST += "&" + strPrefijoMaster + "_TASA3=" + dblTasaVta3;
   strPOST += "&" + "TI_ID=" + intIdTasaVta1;
   strPOST += "&" + "TI_ID2=" + intIdTasaVta2;
   strPOST += "&" + "TI_ID3=" + intIdTasaVta3;
   strPOST += "&" + strPrefijoMaster + "_TASAPESO="+d.getElementById("FAC_TASAPESO").value;
   //Recurrentes
   if(d.getElementById("FAC_ESRECU1").checked){
      strPOST += "&" + strPrefijoMaster + "_ESRECU=1";
   }else{
      strPOST += "&" + strPrefijoMaster + "_ESRECU=0";
   }
   strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD="+d.getElementById("FAC_PERIODICIDAD").value;
   strPOST += "&" + strPrefijoMaster + "_DIAPER="+d.getElementById("FAC_DIAPER").value;
   //Items
   var grid = jQuery("#FAC_GRID");
   var arr = grid.getDataIDs();
   var intC =0;
   for(var i= 0;i<arr.length;i++){
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
      if(intPreciosconImp == 1){
         strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + lstRow.FACD_PRECIO;
         if(lstRow.FACD_SINPRECIO == 0){
            strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + lstRow.FACD_PRECREAL;
         }else{
            strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + 0;
         }
      }else{
         var dblPrecioConImp = 0;
         var dblPrecioRealConImp = 0;
         if(lstRow.FACD_CANTIDAD > 0){
            //Calculamos el impuesto
            var dblBase1 = 0;
            var dblBase2 = 0;
            var dblBase3 = 0;
            var dblImpuesto1 = 0;
            var dblImpuesto2 = 0;
            var dblImpuesto3 = 0;
            if(parseInt(lstRow.FACD_EXENTO1) == 0)dblBase1 = lstRow.FACD_PRECIO;
            if(parseInt(lstRow.FACD_EXENTO2) == 0)dblBase2 = lstRow.FACD_PRECIO;
            if(parseInt(lstRow.FACD_EXENTO3) == 0)dblBase3 = lstRow.FACD_PRECIO;
            var tax = new Impuestos(dblTasaVta1,dblTasaVta2,dblTasaVta3,intSImpVta1_2,intSImpVta1_3,intSImpVta2_3);//Objeto para calculo de impuestos
            tax.CalculaImpuestoMas(dblBase1,dblBase2,dblBase3);
            if(parseInt(lstRow.FACD_EXENTO1) == 0)dblImpuesto1 = tax.dblImpuesto1;
            if(parseInt(lstRow.FACD_EXENTO2) == 0)dblImpuesto2 = tax.dblImpuesto2;
            if(parseInt(lstRow.FACD_EXENTO3) == 0)dblImpuesto3 = tax.dblImpuesto3;
            dblPrecioConImp = (parseFloat(lstRow.FACD_PRECIO) +
               dblImpuesto1 +
               dblImpuesto2 +
               dblImpuesto3);
            dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECREAL) +
               dblImpuesto1 +
               dblImpuesto2 +
               dblImpuesto3);
         }else{
            dblPrecioConImp = (parseFloat(lstRow.FACD_PRECIO));
            dblPrecioRealConImp = (parseFloat(lstRow.FACD_PRECREAL));
         }
         strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + dblPrecioConImp;
         if(lstRow.FACD_SINPRECIO == 0){
            strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + dblPrecioRealConImp;
         }else{
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
      strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + lstRow.FACD_ESREGALO;
      strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + lstRow.FACD_NOTAS;
   }
   strPOST += "&COUNT_ITEM=" + intC;
   //Pagos Mandamos las 4 formas de pago
   //Validamos el tipo de venta
   strPOST += "&COUNT_PAGOS=1";
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
   //Hacemos la peticion por POST
   $.ajax({
      type: "POST",
      data: encodeURI(strPOST),
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"html",
      url: "HM_ventas.jsp?id=1",
      success: function(dato){
         dato = trim(dato);
         if(Left(dato,3) == "OK."){
            if(strNomFormat == "FACTURA"){
               var strHtml = CreaHidden(strKey,dato.replace("OK.",""));
               openWhereverFormat("ERP_SendInvoice?id=" + dato.replace("OK.",""),strNomFormat,"PDF",strHtml);
            }else{
               var strHtml2 = CreaHidden(strKey,dato.replace("OK.",""));
               openFormat(strNomFormat,"PDF",strHtml2);
            }
            ResetOperaActuallala();
         }else{
            alert(dato);
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj){
         alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Funciones para el cuadro de dialogo SI/NO*/
function ConfirmaSIlala(){
   if(d.getElementById("Operac").value == "Nva"){
      //Llamamos metodo para limpiar pantallas
      ResetOperaActuallala()
   }
   if(d.getElementById("Operac").value == "PORC_DESC"){
      //Llamamos metodo para asignar el porcentaje de descuento
      PorcDescSendlala();
   }
   if(d.getElementById("Operac").value == "CHANGE_PRICE"){
      //Llamamos metodo para cambiar el precio del articulo
      CambioPrecSendlala();
   }
   d.getElementById("Operac").value = "";
   $("#SioNO").dialog("close");
}
function ConfirmaNOlala(){
   $("#SioNO").dialog("close");
}
//Panel de botones
/**Guardar operacion*/
function Callbtn0_lala(){
   SaveVtalala();
}
/**Nueva operacion*/
function Callbtn1_lala(){
   $("#SioNO").dialog('option', 'title', "¿Confirma que desea borrar la operacion actual e iniciar una nueva?");
   d.getElementById("Operac").value = "Nva";
   document.getElementById("SioNO_inside").innerHTML = "";
   $("#SioNO").dialog("open");
}
/**Limpia la operacion actual*/
function ResetOperaActuallala(bolSelOpera){
   if(bolSelOpera == undefined)bolSelOpera = true;
   if(bolSelOpera)$("#dialogWait").dialog("open");
   //Limpiamos los campos y ponemos al cliente default
   d.getElementById("FCT_ID").value = intCteDefa;
   d.getElementById("FAC_FOLIO").value = "";
   d.getElementById("FAC_NOTAS").value = "";
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
   d.getElementById("VE_NOM").value = "";
   d.getElementById("FAC_PROD").focus();
   d.getElementById("FAC_TIPO").value = "2";
   //Recurrentes
   d.getElementById("FAC_ESRECU2").checked = true;
   d.getElementById("FAC_PERIODICIDAD").value = "1";
   d.getElementById("FAC_DIAPER").value = "1";
   d.getElementById("FAC_NUMPEDI").value = "";
   d.getElementById("FAC_FECHAPEDI").value = "";
   d.getElementById("FAC_ADUANA").value = "";
   OcultarAvisoslala();
   if(bolSelOpera)ObtenNomCtelala();
   //Limpiamos el GRID
   var grid = jQuery("#FAC_GRID");
   grid.clearGridData();
   //Limpiamos PAGOS
   if(objMap.getXml("FORMPAGO")!= null &&  d.getElementById("TOTALPAGADO") != null){
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
   if(bolSelOpera)$("#dialogWait").dialog("close");
   //Seleccionamos el tipo de operacion
   if(bolSelOpera)SelOperFactlala();
   //Validamos si la sucursal puede editarse
   EvalSucursallala();
}
/**Abre la ventana de consulta de ventas*/
function Callbtn2_lala(){
   OpnOpt('VTAS_VIEW','_ed','dialogView',false,false,true);
}
/**Abrimos ventana para calcular descuento*/
function Callbtn3_lala(){
   var grid=jQuery("#FAC_GRID");
   var ids = grid.getGridParam("selrow");
   if(ids != null && bolPorc){
      document.getElementById("Operac").value = "PORC_DESC";
      $("#SioNO").dialog('option', 'title', lstMsg[5]);
      var div = document.getElementById("SioNO_inside");
      if(lstPorcDesc == null){
         $("#dialogWait").dialog("open");
         //Hacemos la peticion por POST
         $.ajax({
            type: "POST",
            data: "",
            scriptCharset: "utf-8" ,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType:"xml",
            url: "CIP_TablaOp.jsp?ID=2&opnOpt=PORCDESC",
            success: function(datos){
               var objsc = datos.getElementsByTagName("vta_porcdesc")[0];
               var porcData = objsc.getElementsByTagName("vta_porcdescs");
               lstPorcDesc = new Array();
               for(i=0;i<porcData.length;i++){
                  var obj = porcData[i];
                  var Opt2 = new Seloptions(obj.getAttribute('PCD_PORC'),obj.getAttribute('PCD_PORC'));
                  lstPorcDesc[i] = Opt2;
               }
               var strHtml = CreaSelect(lstMsg[6],"MiPordcDesc",0,lstPorcDesc,"","center",0,0,"integer","",0);
               div.innerHTML  = strHtml;
               $("#SioNO").dialog("open");
               $("#dialogWait").dialog("close");
            },
            error: function(objeto, quepaso, otroobj){
               alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
               $("#dialogWait").dialog("close");
            }
         });
      }else{
         var strHtml = CreaSelect(lstMsg[6],"MiPordcDesc",0,lstPorcDesc,"","center",0,0,"integer","",0);
         div.innerHTML  = strHtml;
         $("#SioNO").dialog("open");
      }
   }
}
/**Aplica el porcentaje de descuento al producto*/
function PorcDescSendlala(){
   var grid=jQuery("#FAC_GRID");
   var ids = grid.getGridParam("selrow");
   if(ids != null){
      var porDesc = d.getElementById("MiPordcDesc").value;
      //Calculamos el descuento
      PorcDescDolala(ids,porDesc);
   }
}
/**Asigna el nuevo porcentaje de descuento seleccionado por el usuario*/
function PorcDescDolala(id,dblPorc){
   var grid=jQuery("#FAC_GRID");
   //Calculamos nuevo importe
   var lstRow = grid.getRowData(id);
   //Recalculamos el importe y actualizamos la fila
   lstRow.FACD_PORDESC = dblPorc;
   lstRowChangePreciolala(lstRow,id,grid);
   //ponemos el foco para seguir capturando
   document.getElementById("FAC_PROD").focus();
}
/**Abrimos ventana para indicar el nuevo precio del articulo*/
function Callbtn4_lala(){
   var grid=jQuery("#FAC_GRID");
   var ids = grid.getGridParam("selrow");
   if(ids != null && bolPrice){
      var lstRow = grid.getRowData(ids);
      document.getElementById("Operac").value = "CHANGE_PRICE";
      $("#SioNO").dialog('option', 'title', lstMsg[7]);
      var div = document.getElementById("SioNO_inside");
      var strHtml = CreaTexto(lstMsg[8],"_NvoPrecio",lstRow.FACD_PRECIO,10,10,true,false,"","left",0,"","","",false,1);
      strHtml += CreaRadio(lstMsg[9],"_NvoClean",0,false," ");
      div.innerHTML  = strHtml;
      $("#SioNO").dialog("open");
   }
}
/**Aplica el porcentaje de descuento al producto*/
function CambioPrecSendlala(){
   var grid=jQuery("#FAC_GRID");
   var ids = grid.getGridParam("selrow");
   if(ids != null){
      var dblNvoPrec = d.getElementById("_NvoPrecio").value;
      var bolClean = false;
      if(d.getElementById("_NvoClean1").checked)bolClean=true;
      //Calculamos el nuevo precio
      CambioPrecDolala(ids,dblNvoPrec,bolClean);
   }
}
/**Asigna el nuevo porcentaje de descuento seleccionado por el usuario*/
function CambioPrecDolala(id,dblNvoPrec,bolClean){
   var grid=jQuery("#FAC_GRID");
   //Calculamos nuevo importe
   var lstRow = grid.getRowData(id);
   //Recalculamos el importe y actualizamos la fila
   if(bolClean){
      lstRow.FACD_PRECIO = lstRow.FACD_PRECREAL;
      lstRow.FACD_PRECFIJO = 0;
      lstRow.FACD_SINPRECIO = 0;
   }else{
      lstRow.FACD_PRECIO = dblNvoPrec;
      lstRow.FACD_PRECFIJO = 1;
      //Si el precio real es cero el nuevo precio sera el real
      if(lstRow.FACD_PRECREAL == 0){
         lstRow.FACD_SINPRECIO = 1;
      }
   }
   lstRowChangePreciolala(lstRow,id,grid);
   //ponemos el foco para seguir capturando
   document.getElementById("FAC_PROD").focus();
}
function Callbtn5_lala(){
   $("#Calculator").trigger('click');
}
/**Manda abrir la ventana de devoluciones*/
function Callbtn6(){
   if(bolDevol){
      OpnOpt('DEVO','_ed','dialogDevo',false,false);
   }
}
/**Realiza la devolucion del producto*/
function DevolProdDolala(){
   //Obtenemos los
   d.getElementById("FAC_PROD").value = d.getElementById("DEVO_ARTICULO").value;
   d.getElementById("FAC_DESC").value = d.getElementById("DEVO_DESCRIPCION").value;
   d.getElementById("FAC_DEVO").value = 1;
   $("#dialogDevo").dialog("close");
   AddItem();
}
/**Borramos item*/
function Callbtn7(){
   VtaDroplala()
}
/**Mostramos el menu*/
function Callbtn9(){
   myLayout.open( "west");
   myLayout.open( "east");
   myLayout.open( "south");
   myLayout.open( "north");
}//Borramos item
//Agregamos notas para la partida
function Callbtn8(){
   var grid=jQuery("#FAC_GRID");
   var id = grid.getGridParam("selrow");
   if(id != null){
      var lstRowAct = grid.getRowData(id);
      var strHTML = CreaTextArea(lstMsg[30],"NOTASMOD",lstRowAct.FACD_NOTAS,5,80,"",0,0,3,0);
      strHTML += CreaBoton("","NOTASBTN",lstMsg[31],"ChangeNotes()","center",false,true,0);
      $("#dialog2").dialog('option', 'title', lstMsg[29]);
      document.getElementById("dialog2").innerHTML = strHTML;
      $( "#dialog2" ).dialog( "option", "width", 500);
      $("#dialog2").dialog("open");
      document.getElementById("NOTASMOD").focus();
   }
}
/**Guarda el cambio de las notas hechas*/
function ChangeNotes(){
   var grid=jQuery("#FAC_GRID");
   var id = grid.getGridParam("selrow");
   if(id != null){
      var lstRowAct = grid.getRowData(id);
      lstRowAct.FACD_NOTAS = d.getElementById("NOTASMOD").value;
      //Actualizamos el grid
      grid.setRowData( id, lstRowAct);
   }
   $("#dialog2").dialog("close");
}

/**Abre el cuadro de dialogo para seleccionar el tipo de operacion*/
function SelOperFactlala(){
   var elements = new Array();
   elements[0] = new Seloptions("TICKET",2);
   elements[1] = new Seloptions("FACTURA",1);
   elements[2] = new Seloptions("PEDIDO",3);
   var strHTML = CreaPanelRadio("","OperFactSel",-1,elements,0," onClick=\"SelOperFactDo()\" ",false,"","",false);
   $("#dialogInv").dialog('option', 'title', lstMsg[38]);
   document.getElementById("dialogInv").innerHTML = strHTML;
   $( "#dialogInv" ).dialog( "option", "width", 500);
   $("#dialogInv").dialog("open");
}
/**Selecciona el tipo de operacion de ventas*/
function SelOperFactDo(){
   for(var i=0;i<d.getElementById("OperFactSelcount").value;i++){
      if(d.getElementById("OperFactSel" + i ).checked){
         d.getElementById("FAC_TIPO").value = d.getElementById("OperFactSel" + i ).value;
      }
   }
   d.getElementById("FAC_PROD").focus();
   $("#dialogInv").dialog("close");
}
/**Carga la informacion de una operacion de REMISION FACTURA O PEDIDO*/
function getPedidoenVenta(intIdPedido,strTipoVta){
   //Mandamos la peticion por ajax para que nos den el XML del pedido
   $.ajax({
      type: "POST",
      data: "PD_ID=" + intIdPedido,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "VtasMov.do?id=8",
      success: function(datos){
         var objPedido = datos.getElementsByTagName("vta_pedido")[0];
         var lstdeta = objPedido.getElementsByTagName("deta");
         //Validamos que sea un pedido correcto
         if(objPedido.getAttribute('PD_ANULADA')== 0){
            //No facturado
            if(objPedido.getAttribute("FAC_ID")== 0 ||
               (objPedido.getAttribute("FAC_ID")!= 0  && objPedido.getAttribute('PD_ESRECU') == 1)
               ){
               //No remisionado
               if(objPedido.getAttribute("TKT_ID")== 0 ||
               (objPedido.getAttribute("TKT_ID")!= 0  && objPedido.getAttribute('PD_ESRECU') == 1)
               ){
                  //Limpiamos la operacion actual.
                  ResetOperaActuallala(false);
                  //Llenamos la pantalla con los valores del bd
                  DrawPedidoenVentalala(objPedido,lstdeta,strTipoVta);
                  $("#dialogView").dialog("close")
               }else{
                  alert(lstMsg[53]);
               }
            }else{
               alert(lstMsg[52]);
            }
         }else{
            //No anulado
            alert(lstMsg[51]);
         }
      },
      error: function(objeto, quepaso, otroobj){
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**
 *Establece los parametros del pedido original
 **/
function DrawPedidoenVentalala(objPedido,lstdeta,strTipoVta){
   $("#dialogWait").dialog("open");
   document.getElementById("PD_ID").value = objPedido.getAttribute('PD_ID');
   if(strTipoVta == "REMISION"){
      MostrarAvisoslala(lstMsg[55] + objPedido.getAttribute('PD_ID'))
      document.getElementById("FAC_TIPO").value = 2;
   }else{
      if(strTipoVta == "FACTURA"){
         MostrarAvisoslala(lstMsg[54] + objPedido.getAttribute('PD_ID'))
         document.getElementById("FAC_TIPO").value = 1;
      }else{
         MostrarAvisoslala(lstMsg[57] + objPedido.getAttribute('PD_ID'))
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
   if(objPedido.getAttribute('PD_ESRECU') == 1){
      document.getElementById("FAC_ESRECU1").checked = true;
   }else{
      document.getElementById("FAC_ESRECU2").checked = false;
   }
   document.getElementById("FAC_PERIODICIDAD").value = objPedido.getAttribute('PD_PERIODICIDAD');
   document.getElementById("FAC_DIAPER").value = objPedido.getAttribute('PD_DIAPER');
   document.getElementById("VE_ID").value = objPedido.getAttribute('VE_ID');
   ObtenNomCtelala(objPedido,lstdeta,strTipoVta,true);
}
/**
 *Llenamos el grid con los datos del pedido
 **/
function DrawPedidoDetaenVentalala(objPedido,lstdeta,strTipoVta){
   //Generamos el detalle
   for(i=0;i<lstdeta.length;i++){
      var obj = lstdeta[i];
      var objImportes = new _ImporteVtalala();
      objImportes.dblCantidad = obj.getAttribute('PDD_CANTIDAD');
      objImportes.dblPrecio = parseFloat(obj.getAttribute('PDD_PRECIO'))/(1+(obj.getAttribute('PDD_TASAIVA1')/100));
      objImportes.dblPrecioReal = parseFloat(obj.getAttribute('PDD_PRECREAL'))/(1+(obj.getAttribute('PDD_TASAIVA1')/100));
      objImportes.dblPorcDescGlobal = document.getElementById("FCT_DESCUENTO").value;
      objImportes.dblPorcDesc = obj.getAttribute('PDD_PORDESC');
      objImportes.dblExento1 = obj.getAttribute('PDD_EXENTO1');
      objImportes.dblExento2 = obj.getAttribute('PDD_EXENTO2');
      objImportes.dblExento3 = obj.getAttribute('PDD_EXENTO3');
      objImportes.intDevo = 0;
      //Validamos existencias en caso de que aplique
      if(obj.getAttribute('PR_REQEXIST') == 1){
         if(parseFloat(objImportes.dblCantidad)>parseFloat(obj.getAttribute('PR_EXISTENCIA'))){
            alert(lstMsg[3] + " " + obj.getAttribute('PDD_CVE') + " " + lstMsg[4]);
            if(parseFloat(obj.getAttribute('PR_EXISTENCIA')) > 0){
               objImportes.dblCantidad = obj.getAttribute('PR_EXISTENCIA');
            }else{
               objImportes.dblCantidad = 0;
            }
         }
      }
      //Calculamos el importe de la venta
      objImportes.CalculaImportelala();
      var dblImporte = objImportes.dblImporte;
      var datarow = {
         FACD_ID:0,
         FACD_CANTIDAD:objImportes.dblCantidad,
         FACD_CANTPEDIDO:obj.getAttribute('PDD_CANTIDAD'),
         FACD_DESCRIPCION:obj.getAttribute('PDD_DESCRIPCION'),
         FACD_IMPORTE:dblImporte,
         FACD_CVE:obj.getAttribute('PDD_CVE'),
         FACD_PRECIO:objImportes.dblPrecio,
         FACD_TASAIVA1:obj.getAttribute('PDD_TASAIVA1'),
         FACD_DESGLOSA1:1,
         FACD_IMPUESTO1:objImportes.dblImpuesto1,
         FACD_PR_ID:obj.getAttribute('PR_ID'),
         FACD_EXENTO1:obj.getAttribute('PDD_EXENTO1'),
         FACD_EXENTO2:obj.getAttribute('PDD_EXENTO2'),
         FACD_EXENTO3:obj.getAttribute('PDD_EXENTO3'),
         FACD_REQEXIST:obj.getAttribute('PR_REQEXIST'),
         FACD_EXIST:obj.getAttribute('PR_EXISTENCIA'),
         FACD_NOSERIE:"",
         FACD_ESREGALO:obj.getAttribute('PDD_ESREGALO'),
         FACD_IMPORTEREAL:objImportes.dblImporteReal,
         FACD_PRECREAL:objImportes.dblPrecioReal,
         FACD_DESCUENTO:obj.getAttribute('PDD_DESCUENTO'),
         FACD_PORDESC:objImportes.dblPorcAplica,
         FACD_PRECFIJO:obj.getAttribute('PDD_PRECFIJO'),
         FACD_ESDEVO:0,
         FACD_CODBARRAS:obj.getAttribute('PR_CODBARRAS'),
         FACD_NOTAS:obj.getAttribute('PDD_COMENTARIO')
      };
      //Anexamos el registro al GRID
      jQuery("#FAC_GRID").addRowData(obj.getAttribute('PDD_ID'),datarow,"last");
   }
   //Realizamos la sumatoria
   setSumlala();
   $("#dialogWait").dialog("close");
}
/**Muestra el label de aviso*/
function MostrarAvisoslala(strMsg){
   var label = document.getElementById("LABELAVISOS");
   label.innerHTML = strMsg;
   //Mostrar aviso
   label.setAttribute("class","Mostrar");
   label.setAttribute("className","Mostrar");
   label.setAttribute("class","ui-Total");
   label.setAttribute("className","ui-Total");
}
/**Oculta el label de aviso*/
function OcultarAvisoslala(){
   var label = document.getElementById("LABELAVISOS");
   label.innerHTML = "";
   label.setAttribute("class","Oculto");
   label.setAttribute("className","Oculto");
}
/*
 *lista de teclas abreviadas en pantalla
 *Espacio para colocar banners de publicidad.
 ***/
/**
 *Representa un importe calculado para la venta
 *@dblImporte es el importe de venta
 **/
function _ImporteVtalala(){
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
   this.CalculaImportelala = function CalculaImportelala(){
      //Calculamos el importe
      this.dblPorcDescGlobal = parseFloat(this.dblPorcDescGlobal);
      this.dblPorcDesc = parseFloat(this.dblPorcDesc);
      var dblPrecioAplica = parseFloat(this.dblPrecio);
      if(this.dblPrecFijo == 0 || this.intPrecioZeros == 1){
         this.dblPorcAplica = 0;
         if(this.dblPorcDescGlobal> 0 && this.dblPorcDesc > 0){
            if(this.dblPorcDescGlobal> this.dblPorcDesc)this.dblPorcAplica = this.dblPorcDescGlobal;
            if(this.dblPorcDesc> this.dblPorcDescGlobal)this.dblPorcAplica = this.dblPorcDesc;
         }else{
            if(this.dblPorcDescGlobal>0)this.dblPorcAplica = this.dblPorcDescGlobal;
            if(this.dblPorcDesc>0)this.dblPorcAplica = this.dblPorcDesc;
         }
         if(this.dblPorcAplica> 0){
            dblPrecioAplica = dblPrecioAplica - (dblPrecioAplica * (this.dblPorcAplica/100));
         }
      }
      this.dblImporte = parseFloat(this.dblCantidad) * parseFloat(dblPrecioAplica);
      this.dblImporteReal =parseFloat(this.dblCantidad) * parseFloat(this.dblPrecioReal);
      //Si es una devolucion
      if(parseInt(this.intDevo) == 1){
         this.dblImporte = this.dblImporte * -1;
      }
      //Validamos si aplica o no el impuesto
      var dblBase1 = this.dblImporte;
      var dblBase2 = this.dblImporte;
      var dblBase3 = this.dblImporte;
      if(parseInt(this.dblExento1) == 1)dblBase1 = 0;
      if(parseInt(this.dblExento2) == 1)dblBase2 = 0;
      if(parseInt(this.dblExento3) == 1)dblBase3 = 0;
      //Calculamos el impuesto
      var tax = new Impuestos(dblTasaVta1,dblTasaVta2,dblTasaVta3,intSImpVta1_2,intSImpVta1_3,intSImpVta2_3);//Objeto para calculo de impuestos
      //Validamos si los precios incluyen impuestos
      if(intPreciosconImp == 1){
         tax.CalculaImpuesto(dblBase1,dblBase2,dblBase3);
      }else{
         tax.CalculaImpuestoMas(dblBase1,dblBase2,dblBase3);
      }
      if(parseInt(this.dblExento1) == 0)this.dblImpuesto1 = tax.dblImpuesto1;
      if(parseInt(this.dblExento2) == 0)this.dblImpuesto2 = tax.dblImpuesto2;
      if(parseInt(this.dblExento3) == 0)this.dblImpuesto3 = tax.dblImpuesto3;
      //Calculamos impuestos de los importes reales
      //Validamos si aplica o no el impuesto para el importe REAL
      var dblBaseReal1 = this.dblImporteReal;
      var dblBaseReal2 = this.dblImporteReal;
      var dblBaseReal3 = this.dblImporteReal;
      if(parseInt(this.dblExento1) == 1)dblBaseReal1 = 0;
      if(parseInt(this.dblExento2) == 1)dblBaseReal2 = 0;
      if(parseInt(this.dblExento3) == 1)dblBaseReal3 = 0;
      //Calculamos el impuesto
      //Validamos si los precios incluyen impuestos
      if(intPreciosconImp == 1){
         tax.CalculaImpuesto(dblBaseReal1,dblBaseReal2,dblBaseReal3);
      }else{
         tax.CalculaImpuestoMas(dblBaseReal1,dblBaseReal2,dblBaseReal3);
      }
      if(parseInt(this.dblExento1) == 0)this.dblImpuestoReal1 = tax.dblImpuesto1;
      if(parseInt(this.dblExento2) == 0)this.dblImpuestoReal2 = tax.dblImpuesto2;
      if(parseInt(this.dblExento3) == 0)this.dblImpuestoReal3 = tax.dblImpuesto3;


      if(this.intPrecioZeros == 1){
         this.dblImporteReal =parseFloat(this.dblCantidad) * parseFloat(this.dblPrecio);
      }
      if(intPreciosconImp == 0){
         this.dblImporteReal += this.dblImpuestoReal1 + this.dblImpuestoReal2 + this.dblImpuestoReal3;
         this.dblImporte += this.dblImpuesto1 + this.dblImpuesto2 + this.dblImpuesto3;
      }
   }
}
/**Valida la sucursal al momento de cambiarla*/
function ValidaSuclala(){
   if(parseFloat(document.getElementById("SC_ID").value) == 0){
      document.getElementById("SC_ID").value = intSucDefa;
      InitImpDefault();
   }else{
      InitImpSuclala();
   }
}
/**Inicializa los impuestos por default*/
function InitImpDefaultlala(){
   dblTasaVta1 = dblTasa1;
   dblTasaVta2 = dblTasa2;
   dblTasaVta3 = dblTasa3;
   intSImpVta1_2 = intSImp1_2;
   intSImpVta1_3 = intSImp1_3;
   intSImpVta2_3 = intSImp2_3;
}
/**Inicializa los impuestos de la sucursal seleccionada*/
function InitImpSuclala(){
   var objSuc = document.getElementById("SC_ID");
   $("#dialogWait").dialog("open");
   //Mandamos la peticion por ajax para que nos den el XML del pedido
   $.ajax({
      type: "POST",
      data: "SC_ID=" + objSuc.value,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "VtasMov.do?id=10",
      success: function(datos){
         var objPedido = datos.getElementsByTagName("vta_impuesto")[0];
         var lstdeta = objPedido.getElementsByTagName("vta_impuestos");
         //Validamos que sea un pedido correcto
         for(var i=0;i<lstdeta.length;i++){
            var obj = lstdeta[i];
            dblTasaVta1 = obj.getAttribute('Tasa1');
            dblTasaVta2 = obj.getAttribute('Tasa2');
            dblTasaVta3 = obj.getAttribute('Tasa3');
            intIdTasaVta1 = obj.getAttribute('TI_ID');
            intIdTasaVta2 = obj.getAttribute('TI_ID2');
            intIdTasaVta3 = obj.getAttribute('TI_ID3');
            d.getElementById("FAC_TASASEL1").value = intIdTasaVta1;
            intSImpVta1_2 = obj.getAttribute('SImp1_2');
            intSImpVta1_3 = obj.getAttribute('SImp1_3');
            intSImpVta2_3 = obj.getAttribute('SImp2_3');
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj){
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Evaluamos si podemos cambiar la sucursal*/
function EvalSucursallala(){
   var grid = jQuery("#FAC_GRID");
   var arr = grid.getDataIDs();
   var objSuc = document.getElementById("SC_ID");
   var objTasaSel = document.getElementById("FAC_TASASEL1");
   if(arr.length> 0){
      //Si hay partidas no podremos cambiar la sucursal
      objSuc.onmouseout= function() {
         this.disabled=false;
      };
      objSuc.onmouseleave= function() {
         this.disabled=false;
      };
      objSuc.onmouseover= function() {
         this.disabled=true;
      };
      objSuc.setAttribute("class","READONLY");
      objSuc.setAttribute("className","READONLY");
      objTasaSel.onmouseout= function() {
         this.disabled=false;
      };
      objTasaSel.onmouseleave= function() {
         this.disabled=false;
      };
      objTasaSel.onmouseover= function() {
         this.disabled=true;
      };
      objTasaSel.setAttribute("class","READONLY");
      objTasaSel.setAttribute("className","READONLY");
   }else{
      objSuc.disabled=false;
      //Si hay partidas no podremos cambiar la sucursal
      objSuc.onmouseout= function() {
         var g=1;
      };
      objSuc.onmouseleave= function() {
         var g=1;
      };
      objSuc.onmouseover= function() {
         var g=1;
      };
      objSuc.setAttribute("class","outEdit");
      objSuc.setAttribute("className","outEdit");
      objTasaSel.disabled=false;
      //Si hay partidas no podremos cambiar la sucursal
      objTasaSel.onmouseout= function() {
         var g=1;
      };
      objTasaSel.onmouseleave= function() {
         var g=1;
      };
      objTasaSel.onmouseover= function() {
         var g=1;
      };
      objTasaSel.setAttribute("class","outEdit");
      objTasaSel.setAttribute("className","outEdit");
   }
}
/**Activa o inactiva el campo de tipo de moneda*/
function RefreshMonedalala(){
   var objMoneda = document.getElementById("FAC_MONEDA");
   var objTipoCambio = document.getElementById("FAC_TASAPESO");
   //Si la moneda es 1(pesos) inactivamos el tipo de cambio
   if(objMoneda.value == 1){
      objTipoCambio.value = 1;
      objTipoCambio.setAttribute("class","READONLY");
      objTipoCambio.setAttribute("className","READONLY");
      objTipoCambio.readOnly = true;
   }else{
      objTipoCambio.value = 1;
      objTipoCambio.setAttribute("class","outEdit");
      objTipoCambio.setAttribute("className","outEdit");
      objTipoCambio.readOnly = false;
   }
}
/**Actualiza la tasa de acuerdo al impuesto seleccionado*/
function UpdateTasaImplala(){
   var objTasaSel = document.getElementById("FAC_TASASEL1");
   $("#dialogWait").dialog("open");
   //Mandamos la peticion por ajax para que nos den el XML del pedido
   $.ajax({
      type: "POST",
      data: "TI_ID=" + objTasaSel.value,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "VtasMov.do?id=11",
      success: function(datos){
         var objPedido = datos.getElementsByTagName("vta_impuesto")[0];
         var lstdeta = objPedido.getElementsByTagName("vta_impuestos");
         for(var i=0;i<lstdeta.length;i++){
            var obj = lstdeta[i];
            dblTasaVta1 = obj.getAttribute('Tasa1');
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj){
         alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}

