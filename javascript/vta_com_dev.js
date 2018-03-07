/* 
 * Realiza las operaciones de recepción de orden de compra
 */
var bolSoyMainOdc = false;
var strNomMainOdc = false;
var strNomFormViewOdc = "";
var strKeyViewOdc = "";
var strTipoVtaViewOdc = "";
var strNomOrderViewOdc = "";
var bolCompRecepdeMas = false;
var bolCambioFechaInvRecep = false;
function vta_com_dev(){
   
}
function InitRecepDEV(){
   //ocultar el boton de almacenar
   document.getElementById("btn1").parentNode.setAttribute("class","Oculto");   
   //Validamossi somos el main
   strNomMainOdc = objMap.getNomMain();
   if(strNomMainOdc =="COMP_RECEP"){
      bolSoyMainOdc = true;
   }
      
   //ocultar el frame
   if(bolSoyMainOdc){
      myLayout.close( "west");
      myLayout.close( "east");
      myLayout.close( "south");
      myLayout.close( "north");  
   }
   document.getElementById("VIEW_SURTIDA2").checked = true;

   //Realizamos el menu de botones para agregar la cuenta por pagar
   var strHtml = "<ul>"+
   getMenuItem("CallbtnCompRecep1();","Guardar Recepcion","images/ptovta/CircleSave.png")+
   getMenuItem("CallbtnCompRecep2();","Salir","images/ptovta/exitBig.png")+
   "</ul>";
   document.getElementById("TOOLBARCOM").innerHTML = strHtml;   
   
   ActivaButtonsRecepOdc(false,false);
   //Inactivamos el primer tab
   $("#tabsCOMP_RECEP").tabs( 'disable' , 1);
   $("#dialogWait").dialog("open");
   //Obtenemos permisos
   $.ajax({
      type: "POST",
      data: "keys=168",
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
            if(obj.getAttribute('id') == 168 && obj.getAttribute('enabled') == "true"){
               bolCompRecepdeMas = true;
            }
            if(obj.getAttribute('id') == 69 && obj.getAttribute('enabled') == "true"){
               bolCambioFechaInvRecep = true;
            }
         }
         //Validamos si podemos hacer cambio de fecha
         if(bolCambioFechaInvRecep){
            if($('#COM_FECHA').datepicker("isDisabled")){
               $('#COM_FECHA').datepicker("enable")
            }
            var objFecha = document.getElementById("COM_FECHA");
            objFecha.setAttribute("class","outEdit");
            objFecha.setAttribute("className","outEdit");
            objFecha.readOnly = false;
         }else{
            $('#COM_FECHA').datepicker("disable")
         }
         $("#dialogWait").dialog("close");
         //Foco inicial
         setTimeout("d.getElementById('COM_PROD').focus();", 3000);
      },
      error: function(objeto, quepaso, otroobj){
         alert(":Compras recepcion:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
   

}
//abre cuadro de dialogo de proveedores
function OpnDiagProvCompReg(){
   OpnOpt('PROVEEDOR','grid','dialogProv',false,false);
}
/**Ejecuta el filtro para consultar las ventas*/
function ViewDoOdcRecep(){
   //Validamossi somos el main
   bolSoyMainOdc = false;
   strNomMainOdc = objMap.getNomMain();
   if(strNomMainOdc =="COMP_RECEP"){
      bolSoyMainOdc = true;
   }
   var bolPasa = true;

   //Si pasa enviamos la peticion de la consulta
   if(bolPasa){
      //Inicializamos todos los botones
      ActivaButtonsRecepOdc(true,true);
      //Prefijos dependiendo del tipo de venta
      var strPrefijoMasterOdc = "COM";
      strNomOrderViewOdc = "COM_ID";
      strNomFormViewOdc = "COMRECEPDO";//NOMBRE DEL FORMULARIO
      strKeyViewOdc = "COM_ID";
        
      //Armamos el filtro
      var strParams =  "&" +strPrefijoMasterOdc + "_ANULADO=999";
      strParams +=  "&" +strPrefijoMasterOdc + "_ESRECU=999";
      var strFecha1 = document.getElementById("VIEWC_FECHA1").value;
      var strFecha2 = document.getElementById("VIEWC_FECHA2").value;
      var strId = document.getElementById("VIEWC_ID").value;
      //Si seleccionaron el ID filtramos por el
      if(strId != "0" && strId != ""){// ES ID DE LA COMPRA
         strParams +="&" + strKeyViewOdc + "=" + strId + "";
      }else{
         if(strFecha1 != "" && strFecha2 != ""){
            strParams +="&" + strPrefijoMasterOdc + "_FECHA1=" + strFecha1 + "&" + strPrefijoMasterOdc + "_FECHA2=" + strFecha2 + "";
         }
         if(document.getElementById("VIEWC_SUCURSAL").value != "0"){
            strParams +="&SC_ID=" + document.getElementById("VIEWC_SUCURSAL").value + "";
         }
         if(document.getElementById("VIEWC_PV_ID").value != "0"){
            strParams +="&PV_ID=" + document.getElementById("VIEWC_PV_ID").value + "";
         }
         if(document.getElementById("VIEWC_FOLIO").value != ""){
            strParams +="&" + strPrefijoMasterOdc + "_FOLIO=" + document.getElementById("VIEWC_FOLIO").value + "";
         }
            
         if(document.getElementById("VIEWC_EMP").value != "0"){
            strParams +="&EMP_ID=" + document.getElementById("VIEWC_EMP").value + "";
         }
         if(document.getElementById("VIEW_SURTIDA1").checked){
            strParams +="&COM_SURTIDA=1";
         }else{
            strParams +="&COM_SURTIDA=0";
         }
            
      }

      //Hacemos trigger en el grid
      var grid = jQuery("#VIEWC_GRID1");
      grid.setGridParam({
         url:"CIP_TablaOp.jsp?ID=5&opnOpt=" + strNomFormViewOdc + "&_search=true" + strParams
      });
      grid.setGridParam({
         sortname:strNomOrderViewOdc
      }).trigger('reloadGrid');

   }
}
/**
 *Reseteamos el grid
 **/
function resetGridViewRecepOdc(){
   var grid = jQuery("#VIEW_GRID1");
   grid.clearGridData();
}
/**
 *Se encarga de activar o inactivar botones de acuerdo al tipo de documento
 **/
function ActivaButtonsRecepOdc(bolRecep,bolPrint){

   //vv_btnCancel
   if(bolRecep){
      document.getElementById("bt_RepODCV1").style.display = "none";
   }else{
      document.getElementById("bt_RepODCV1").style.display = "none";
   }
   //vv_btnPrint
   if(bolPrint){
      document.getElementById("bt_RepODCV2").style.display = "block";
   }else{
      document.getElementById("bt_RepODCV2").style.display = "none";
   }

}
/**Imprime el documento seleccionado*/
function RecepOdcPrint(){
   var grid = jQuery("#VIEWC_GRID1");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      var strHtml = CreaHidden("COM_ID",lstRow.COM_ID);
      openFormat("COMRECEPDO","PDF",strHtml);   
   }
}
/**Inicializa la recepcion de ordenes de compra*/
function RecepOdc(){
   var grid = jQuery("#VIEWC_GRID1");
   if(grid.getGridParam("selrow") != null){
      //Limpiamos el GRID
      var grid2 = jQuery("#COM_GRID");
      grid2.clearGridData();
      //Peiticion para cargar datos
      //Mandamos la peticion por ajax para que nos den el XML del pedido
      $.ajax({
         type: "POST",
         data: "COM_ID=" + grid.getGridParam("selrow"),
         scriptCharset: "utf-8" ,
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType:"xml",
         url: "ODCMov.do?id=8",
         success: function(datos){
            var objCompra = datos.getElementsByTagName("vta_compra")[0];
            var lstdeta = objCompra.getElementsByTagName("deta");
            //Validamos que no este anulado
            if(objCompra.getAttribute('COM_ANULADA')== 0){
               //Que no ese autorizado
               if(objCompra.getAttribute("COM_AUTORIZA")== 1){
                  $("#tabsCOMP_RECEP").tabs( 'enable' , 1);
                  $("#tabsCOMP_RECEP").tabs( "option","active",  1);
                  //Limpiamos la operacion actual.
                  //ResetOperaActualODC(false);
                  //Llenamos la pantalla con los valores del bd
                  DrawODCRecep(objCompra,lstdeta);
                  $("#dialogView").dialog("close")

               }else{
                  alert(lstMsg[69]);
               }
            }else{
               //No anulado
               alert(lstMsg[70]);
            }
         },
         error: function(objeto, quepaso, otroobj){
            alert(":com recep1:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
   
}
/**
 *Carga los datos del cabezero de la orden de compra
 **/
function DrawODCRecep(objCompra,lstdeta){
   $("#dialogWait").dialog("open");
   //MostrarAvisosODC(lstMsg[67] + objCompra.getAttribute('COM_ID'))
   //Cargamos los datos
   document.getElementById("COM_ID").value = objCompra.getAttribute('COM_ID');
   document.getElementById("COM_FOLIO").value = objCompra.getAttribute('TOD_ID');
   document.getElementById("SC_ID").value = objCompra.getAttribute('SC_ID');
   document.getElementById("COM_FOLIO").value = objCompra.getAttribute('COM_FOLIO');
   document.getElementById("COM_OPER").value = strUserName;
   //Obtenemos el nombre del proveedor
   ObtenNomProvODCRecep(objCompra,lstdeta,true);
}
/*Represa el campo de nombre de proveedor y obtenemos sus datos*/
function ObtenNomProvODCRecep(objODC,lstdeta,bolPasaODC){
   var intPv = objODC.getAttribute('PV_ID');
   if(bolPasaODC == undefined)bolPasaODC = false;
   ValidaClean("COM_PROV");
   $.ajax({
      type: "POST",
      data: "PV_ID=" + intPv,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "CXPMov.do?id=9",
      success: function(datoVal){
         var objPov = datoVal.getElementsByTagName("vta_proveedores")[0];
         if(objPov.getAttribute('PV_ID') == 0){
            document.getElementById("COM_PROV").value = "***************";
            alert("EL proveedor no existe")   
         }else{
            document.getElementById("COM_PROV").value = objPov.getAttribute('PV_RAZONSOCIAL');
         }
         //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
         if(bolPasaODC){
            DrawODCDetaRecep(objODC,lstdeta);
         }         
      },
      error: function(objeto, quepaso, otroobj){
         document.getElementById("PV_NOM").value = "***************";
         alert("ODC prov1:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**
 *Llenamos el grid con los datos del detalle de la compra
 **/
function DrawODCDetaRecep(objPedido,lstdeta){
   //Generamos el detalle
   for(i=0;i<lstdeta.length;i++){
      var obj = lstdeta[i];
      var dblCantidadXSurtir = obj.getAttribute('COMD_CANTIDAD') - obj.getAttribute('COMD_CANTIDADSURTIDA');
      if(dblCantidadXSurtir < 0)dblCantidadXSurtir = 0;
      //Validamos la cantidad a mostrar
      if(dblCantidadXSurtir > 0){
         //Anadimos la partida
         var datarow = {
            COMD_ID:obj.getAttribute('COMD_ID'),
            COMD_CVE:obj.getAttribute('COMD_CVE'),
            COMD_DESCRIPCION:obj.getAttribute('COMD_DESCRIPCION'),
            COMD_CANTIDAD:dblCantidadXSurtir,
            COMD_RECIBIDO:0.0,
            COMD_COSTO:obj.getAttribute('COMD_COSTO'),
            COMD_NOTAS:obj.getAttribute('COMD_NOTAS'),
            COMD_PR_ID:obj.getAttribute('PR_ID')
         };
         //Anexamos el registro al GRID
         jQuery("#COM_GRID").addRowData(obj.getAttribute('COMD_ID'),datarow,"last");  
      }
   }
   //Realizamos la sumatoria
   //setSumODC();
   $("#dialogWait").dialog("close");
}
/**Guarda la recepcion*/
function CallbtnCompRecep1(){
   SaveODCRecep();
}
/**Se sale de la recepcion*/
function CallbtnCompRecep2(){
   $("#tabsCOMP_RECEP").tabs( "option","active",  0);
   $("#tabsCOMP_RECEP").tabs( 'disable' , 1);
}
/**Anade un item con un enter del usuario o de la pistola*/
function AddItemEvtODCRecep(event,obj){
   if(event.keyCode == 13){
      AddItemODCRecep();
   }
}
/**Actualiza la cantidad recibida*/
function AddItemODCRecep(){
   var strCod = UCase(d.getElementById("COM_PROD").value);
   var strCant = UCase(d.getElementById("COM_CANT").value);
   var intCant =0;
   var grid = jQuery("#COM_GRID");
   try{
      intCant =parseFloat(strCant);
   }catch(err){
      
   }
   //Validamos que hallan capturado un codigo
   if(trim(strCod) != ""){
      $("#dialogWait").dialog("open");
      var bolEncontro = false;
      var idProd = 0;
      var idProdLast = 0;
      //Si esta activada la funcionalidad de agrupar validamos si existe
      //Revisamos si existe el item en el grid
      var arr = grid.getDataIDs();
      for(var i= 0;i<arr.length;i++){
         var id = arr[i];
         var lstRowAct = grid.getRowData(id);
         if(lstRowAct.COMD_CVE == strCod /*||
            lstRowAct.COMD_CODBARRAS == strCod*/){
            //Validamos si aun hay pendientes por surtir
            var dblDiff = lstRowAct.COMD_CANTIDAD - lstRowAct.COMD_RECIBIDO;
            bolEncontro = true;
            idProdLast = id;
            if(dblDiff >0){
               //Validamos si no excedemos la cantidad
               if((lstRowAct.COMD_CANTIDAD - (lstRowAct.COMD_RECIBIDO + intCant)) >= 0){
                  idProd = id;
                  break;                  
               }
            }     
         }
      }
      //Solo si encontro el producto
      if(bolEncontro){
         var idUpdate = 0;
         if(idProd == 0){
            alert(lstMsg[83] );
            //Solo si tenemos acceso
            if(bolCompRecepdeMas){
               var boolResp = confirm(lstMsg[84]);
               if(boolResp){
                  idUpdate = idProdLast;
               }
            }
            
         }else{
            idUpdate = idProd;
         }
         //Solo si procede la recepcion
         if(idUpdate != 0){
            //Actualizamos la cantidad
            var lstRowUpdate = grid.getRowData(idUpdate);
            lstRowUpdate.COMD_RECIBIDO = parseFloat(lstRowUpdate.COMD_RECIBIDO) + intCant;
            grid.setRowData( idUpdate, lstRowUpdate);
            d.getElementById("COM_PROD").value = "";
            d.getElementById("COM_CANT").value = "1";
            SetSumODCRecep();
            d.getElementById("COM_PROD").focus();
         }
      }else{
         alert(lstMsg[81] );
         d.getElementById("COM_PROD").focus();
      }
      $("#dialogWait").dialog("close");
   }else{
      alert(lstMsg[82] );
      d.getElementById("COM_PROD").focus();
   }
}
/**Suma las piezas recibidas*/
function SetSumODCRecep(){
   var grid = jQuery("#COM_GRID");
   var arr = grid.getDataIDs();
   var dblSuma = 0;
   for(var i= 0;i<arr.length;i++){
      var id = arr[i];
      var lstRow = grid.getRowData(id);
      dblSuma += parseFloat(lstRow.COMD_RECIBIDO);      
   }
   d.getElementById("COM_TOT").value = dblSuma;
}
/**Funcion para abrir con doble click la recepcion*/
function dblClickODCRecep(id){
   RecepOdc();
}
/**Funcion para validar antes de guardar*/
function SaveODCRecep(){
   var dblTot = parseFloat(d.getElementById("COM_TOT").value);
   if(dblTot > 0){
      SaveODCRecepDo();
   }else{
      alert(lstMsg[85]);
   }
}
/**Guarda la recepcion en la base de datos*/
function SaveODCRecepDo(){
   $("#dialogWait").dialog("open");
   //Armamos el POST a enviar
   var strPOST = "";
   strPOST += "COM_ID=" + d.getElementById("COM_ID").value;
   strPOST += "&COM_FECHA=" + d.getElementById("COM_FECHA").value;
   //Items
   var grid = jQuery("#COM_GRID");
   var arr = grid.getDataIDs();
   var intC =0;
   for(var i= 0;i<arr.length;i++){
      var id = arr[i];
      var lstRow = grid.getRowData(id);
      intC++;
      strPOST += "&COMD_ID" + intC + "=" + lstRow.COMD_ID;
      strPOST += "&PR_ID" + intC + "=" + lstRow.COMD_PR_ID;
      strPOST += "&COMD_CVE" + intC + "=" + lstRow.COMD_CVE;
      strPOST += "&COMD_CANTIDADSURTIDA" + intC + "=" + lstRow.COMD_RECIBIDO;
      
   }
   strPOST += "&COUNT_ITEM=" + intC;
   //Hacemos la peticion por POST
   $.ajax({
      type: "POST",
      data: encodeURI(strPOST),
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"html",
      url: "ODCMov.do?id=10",
      success: function(dato){
         dato = trim(dato);
         if(Left(dato,3) == "OK."){
            var strHtml2 = CreaHidden("MP_ID",dato.replace("OK.",""));
            openFormat("COMRECEPDO","PDF",strHtml2);
            CallbtnCompRecep2();
         }else{
            alert(dato);
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj){
         alert(":ODC Recep Save:" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}
/**Nos salimos del menu de recepcion*/
function RecepOdcExit(){
   myLayout.open( "west");
   myLayout.open( "east");
   myLayout.open( "south");
   myLayout.open( "north");
   document.getElementById("MainPanel").innerHTML = "";  
}