/*
 * Esta libreria contiene las operaciones de la pantalla de consulta de ventas
 */
function vta_mmailsNC(){//Funcion necesaria para que pueda cargarse la libreria en automatico
}

var bolAnularVta = false;
var strNomMainMM = false;

function InitVisMMailsNC(){
   try{
      document.getElementById("btn1").style.display = "none";

   }catch(err){

   }
   //Validamossi somos el main
   strNomMainMM = objMap.getNomMain();
}
/**Se encarga de enviar la peticion de consulta de las ventas*/
var strNomFormView = "";
var strKeyView = "";
var strNomFormatPrint = "";
var strTipoVtaView = "";
var strNomOrderView = "";
/**Ejecuta el filtro para consultar las ventas*/
function ViewMMailsNC(){
   var bolPasa = true;
   //Si pasa enviamos la peticion de la consulta
   if(bolPasa){
      //Prefijos dependiendo del tipo de venta
      var strPrefijoMaster = "NC";
      strNomFormView = "NCVIEW_PRI";
      strNomOrderView = "NC_ID";
      strKeyView = "NC_ID";
      //Armamos el filtro

      var strParams =  "&" +strPrefijoMaster + "_ANULADA=999";
      var strFecha1 = document.getElementById("VIEW_FECHA1").value;
      var strFecha2 = document.getElementById("VIEW_FECHA2").value;
      var strId = document.getElementById("VIEW_ID").value;
      //Si seleccionaron el ID filtramos por el
      if(strId != "0" && strId != ""){
         strParams +="&" + strKeyView + "=" + strId + "";
      }else{
         if(strFecha1 != "" && strFecha2 != ""){
            strParams +="&" + strPrefijoMaster + "_FECHA1=" + strFecha1 + "&" + strPrefijoMaster + "_FECHA2=" + strFecha2 + "";
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
function ValidaCleanMMNC(strNomField){
   var objDivErr = document.getElementById("err_" + strNomField);
   if(objDivErr !=null){
      objDivErr.innerHTML = "";
      objDivErr.setAttribute("class","");
      objDivErr.setAttribute("className","");
   }
}
//Muestra el error de la validacion
function ValidaShowMMNC(strNomField,strMsg){
   var objDivErr = document.getElementById("err_" + strNomField);
   objDivErr.setAttribute("class","");
   objDivErr.setAttribute("class","inError");
   objDivErr.setAttribute("className","inError");
   objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsg;
}

//Muestra la funcion de facturar
function MMSendMailNC(){
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
      //Cuadro dialogo
      $("#dialogWait").dialog("open");
      var intVIEW_CC = 0;
      if(document.getElementById("VIEW_CC1").checked){
         intVIEW_CC = 1;
      }
      //Hacemos peticion por AJAX para generar las facturas
      $.ajax({
         type: "POST",
         data: encodeURI("LST_NC_ID=" + strPD_ID +
            "&VIEW_COPIA="+ document.getElementById("VIEW_COPIA").value
            +"&VIEW_ASUNTO="+ document.getElementById("VIEW_ASUNTO").value
            +"&VIEW_MAIL="+ document.getElementById("VIEW_MAIL").value
            +"&VIEW_CC="+ intVIEW_CC)
         ,
         scriptCharset: "utf-8" ,
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType:"xml",
         url: "ERP_MailMasivo.jsp",
         success: function(datos){
            //Parsemos el xml
            var objsc = datos.getElementsByTagName("vta_mails")[0];
            var vta_mail = objsc.getElementsByTagName("vta_mail");
            for(i=0;i<vta_mail.length;i++){
               var obj = vta_mail[i];
               //Si no se pudo enviar el mail lanzamos un mensaje
               if(obj.getAttribute('res') != "OK"){
                  alert(obj.getAttribute('id') + " " +  obj.getAttribute('res'));
               }
            }
            alert("Mails Enviados....");
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
function resetGridView1NC(){
   var grid = jQuery("#VIEW_GRID1");
   grid.clearGridData();
}
