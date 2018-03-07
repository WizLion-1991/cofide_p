/*
 * Esta libreria contiene las operaciones de la pantalla de consulta de ventas
 */
function vta_recur(){//Funcion necesaria para que pueda cargarse la libreria en automatico
}
function ViewRecur(){

}
var bolAnularVta = false;
var bolSoyMain = false;
var strNomMain = false;
function InitVisR(){
   try{
      document.getElementById("btn1").style.display = "none";

   }catch(err){

   }
   //Validamossi somos el main
   strNomMain = objMap.getNomMain();
   if(strNomMain =="FAC_RE"){
      bolSoyMain = true;
   }
   // ActivaButtons(false,false,false,false,false,false,!bolSoyMain);
   //Obtenemos permisos
   $("#dialogWait").dialog("open");
   $.ajax({
      type: "POST",
      data: "keys=98",
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
            if(obj.getAttribute('id') == 98 && obj.getAttribute('enabled') == "true"){
               bolAnularVta = true;
            }
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj){
         alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Se encarga de enviar la peticion de consulta de las ventas*/
var strNomFormView = "";
var strKeyView = "";
var strNomFormatPrint = "";
var strTipoVtaView = "";
var strNomOrderView = "";
/**Ejecuta el filtro para consultar las ventas*/
function ViewDoRec(){
   var bolPasa = true;
   ValidaClean("VIEW_TIPO");
   if(document.getElementById("VIEW_TIPO").value == "" || document.getElementById("VIEW_TIPO").value == "0"){
      ValidaShow("VIEW_TIPO","NECESITA SELECCIONAR EL TIPO DE VENTA")
      bolPasa = false;
   }

   //Si pasa enviamos la peticion de la consulta
   if(bolPasa){
      //Prefijos dependiendo del tipo de venta
      var strPrefijoMaster = "PD";
      strNomFormView = "PEDIDOREC";
      strNomOrderView = "PD_ID";
      strKeyView = "PD_ID";
      strNomFormatPrint = "PEDIDO";
      strTipoVtaView = "3";
      //Armamos el filtro

      var strParams =  "&" +strPrefijoMaster + "_ANULADA=999";
      strParams +=  "&" +strPrefijoMaster + "_ESRECU=1";
      var strFecha1 = document.getElementById("VIEW_FECHA1").value;
      var strFecha2 = document.getElementById("VIEW_FECHA2").value;
      var strId = document.getElementById("VIEW_ID").value;
      //Si seleccionaron el ID filtramos por el
      if(strId != "0" && strId != ""){
         strParams +="&" + strKeyView + "=" + strId + "";
      }else{
         if(strFecha1 != "" && strFecha2 != ""){
            strParams +="&" + strPrefijoMaster + "_VENCI1=" + strFecha1 + "&" + strPrefijoMaster + "_VENCI2=" + strFecha2 + "";
         }
         if(document.getElementById("VIEW_SUCURSAL").value != "0"){
            strParams +="&SC_ID=" + document.getElementById("VIEW_SUCURSAL").value + "";
         }
         if(document.getElementById("VIEW_CLIENTE").value != "0"){
            strParams +="&CT_ID=" + document.getElementById("VIEW_CLIENTE").value + "";
         }
         if(document.getElementById("VIEW_FOLIO").value != ""){
            strParams +="&" + strPrefijoMaster + "_FOLIO=" + document.getElementById("VIEW_FOLIO").value + "";
         }
         if(document.getElementById("VIEW_EMP").value != "0"){
            strParams +="&EMP_ID=" + document.getElementById("VIEW_EMP").value + "";
         }
      }
      //Hacemos trigger en el grid
      var grid = jQuery("#VIEW_GRID1");
      grid.setGridParam({
         url:"CIP_TablaOp.jsp?ID=5&opnOpt=" + strNomFormView + "&_search=true" + strParams
      });
      grid.setGridParam({
         sortname:strNomOrderView
      }).trigger('reloadGrid');

   }
}
//Limpia el campo antes de validarlo
function ValidaClean(strNomField){
   var objDivErr = document.getElementById("err_" + strNomField);
   if(objDivErr !=null){
      objDivErr.innerHTML = "";
      objDivErr.setAttribute("class","");
      objDivErr.setAttribute("className","");
   }
}
//Muestra el error de la validacion
function ValidaShow(strNomField,strMsg){
   var objDivErr = document.getElementById("err_" + strNomField);
   objDivErr.setAttribute("class","");
   objDivErr.setAttribute("class","inError");
   objDivErr.setAttribute("className","inError");
   objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsg;
}

//Muestra la funcion de facturar
function VtaRecDo(){
   var grid = jQuery("#VIEW_GRID1");
   var arr = grid.getGridParam("selarrrow");
   if(arr.length == 0){
      alert(lstMsg[58]);
   }else{
      //Construir cadena a enviar
      var strPD_ID = "";
      for(var i= 0;i<arr.length;i++){
         var id = arr[i];
         var lstRow = grid.getRowData(id);
         strPD_ID += lstRow.TKT_ID + ",";
      }
      strPD_ID = strPD_ID.substr(0,strPD_ID.length - 1 );
      var strFiltro = "";
      if(document.getElementById("VIEW_USA1").checked){
         //Usamos la fecha
         strFiltro = "&USA_FECHAUSER=1&FAC_FECHA_US="+document.getElementById("VIEW_FECHA_FAC").value;
      }else{
         strFiltro = "&USA_FECHAUSER=0&FAC_FECHA_US=";
      }
      //Cuadro dialogo
      $("#dialogWait").dialog("open");
      //Hacemos peticion por AJAX para generar las facturas
      $.ajax({
         type: "POST",
         data: encodeURI("LST_PD_ID=" + strPD_ID + strFiltro),
         scriptCharset: "utf-8" ,
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType:"html",
         url: "ERP_FacRecu.jsp?id=1",
         success: function(dato){
            dato = trim(dato);
            if(Left(dato,3) == "OK."){
               alert(lstMsg[59] + " " + dato.replace("OK.",""));
               grid.setGridParam({
                  sortname:strNomOrderView
               }).trigger('reloadGrid');
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
}
/**
 *Reseteamos el grid
 **/
function resetGridView(){
   var grid = jQuery("#VIEW_GRID1");
   grid.clearGridData();
}
/**
 *Nos salimos de la ventana de consulta
 **/
function VtaViewSalir(){
   if(strNomMain != "VTAS_VIEW"){
      $("#dialogView").dialog("close");
   }
}
