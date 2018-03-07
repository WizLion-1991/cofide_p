/* 
 * Realiza las operaciones de la pantalla de clientes de universo consciente
 */
var strNomTab = "UNI1";
var strOperPersona = "";
var isDetalle =false;
function mlm_clientes(){
}
/**
 *Con esta función inicializamos la pantalla
 */
function InitPP(){
   myLayout.close( "west");
   myLayout.close( "east");
   myLayout.close( "south");
   myLayout.close( "north");
   $("#dialogWait").dialog("open");
   TabsMap("1,2",false);//Inactivamos todo
   document.getElementById("vvEditc").style.display = "none";
   document.getElementById("vvRedc").style.display = "none";
   document.getElementById("vvAddSonc").style.display = "none";
   $("#dialogWait").dialog("close");
}
/**Busca los clientes*/
function BuscarPP(){
   //Hacemos trigger en el grid
   var grid = jQuery("#gridBuscar");
   grid.setGridParam({
      url:"CIP_TablaOp.jsp?ID=5&opnOpt=UNI2&_search=true&CT_RAZONSOCIAL=" + encode(document.getElementById("txtNomBuscar").value)
   }).trigger('reloadGrid');     
}
/**
 *Evalua si hay resultados
 **/
function ValGrid(){
   //Desactivamos los botones
   document.getElementById("vvEditc").style.display = "none";
   document.getElementById("vvRedc").style.display = "none";
   document.getElementById("vvAddSonc").style.display = "none";
   var grid = jQuery("#gridBuscar");
   var lstIds = grid.getDataIDs();
   if(lstIds.length == 0){
      var bolResp = confirm("No se encontraron resultados¿Desea dar de alta una nueva persona ?");
      if(bolResp){
         document.getElementById("CT_RAZONSOCIAL").value = document.getElementById("txtNomBuscar").value;
         //Abrimos pantalla de nuevo
         NuevaPersona(null);
      }
   }
}
/**Ocurre al seleccionar una fila*/
function SelGridPP(rowid, status){
   //Activamos botones
   document.getElementById("vvEditc").style.display = "block";
   document.getElementById("vvRedc").style.display = "block";
   document.getElementById("vvAddSonc").style.display = "block";
   
}
/**Abre la pantalla de nueva persona*/
function NuevaPersona(intIdPadre){
   strOperPersona = "_new";
   TabsMap("1",true);
   $("#tabs"+strNomTab).tabs( "option","active",  1);
   TabsMap("0",false);
   document.getElementById("idt").innerHTML = "Nueva Persona";
   document.getElementById("CT_ID").value = "0";
   if(intIdPadre != null)
      isDetalle =true 
   else 
      isDetalle =false;
   //Asignamos el upline automaticamente o lo dejamos manual
   var objUp = document.getElementById("CT_UPLINE");
   if(intIdPadre != null){
      objUp.value = intIdPadre;
      objUp.readOnly = true;
      objUp.setAttribute("class","READONLY");
      objUp.setAttribute("className","READONLY");
   }else{
      objUp.value = 0;
      objUp.readOnly = false;
      objUp.setAttribute("class","outEdit");
      objUp.setAttribute("className","outEdit");
   }
}
/**Edita los datos de la persona con el id*/
function EditaPersona(id){
   strOperPersona = "_edit";
   TabsMap("1",true);
   $("#tabs"+strNomTab).tabs( "option","active",  1);
   TabsMap("0",false);
   document.getElementById("idt").innerHTML = "Editando los datos de la persona con número " + id;   
   LoadDatoPP(id);
}
/**Cargamos la información del nodo por editar*/
function LoadDatoPP(id){
   $("#dialogWait").dialog('open');
   $.ajax({
      type: "POST",
      data: "CT_ID=" + id,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"xml",
      url: "CIP_TablaOp.jsp?ID=4&opnOpt=MLMCTE1",
      success: function(datos){
         var objsc = datos.getElementsByTagName("vta_clientesss")[0];
         var objLisAtt = objsc.getElementsByTagName("vta_cliente");
         for(i=0;i<objLisAtt.length;i++){
            var obj = objLisAtt[i];
            document.getElementById("CT_ID").value                   = id;
            document.getElementById("CT_RAZONSOCIAL").value          = obj.getAttribute('CT_RAZONSOCIAL');
            document.getElementById("CT_RFC").value                  = obj.getAttribute('CT_RFC');
            document.getElementById("SC_ID").value                   = obj.getAttribute('SC_ID');
            document.getElementById("CT_CALLE").value                = obj.getAttribute('CT_CALLE');
            document.getElementById("CT_NUMERO").value               = obj.getAttribute('CT_NUMERO');
            document.getElementById("CT_NUMINT").value               = obj.getAttribute('CT_NUMINT');
            document.getElementById("CT_COLONIA").value              = obj.getAttribute('CT_COLONIA');
            document.getElementById("CT_MUNICIPIO").value            = obj.getAttribute('CT_MUNICIPIO');
            document.getElementById("CT_ESTADO").value               = obj.getAttribute('CT_ESTADO');
            document.getElementById("CT_CP").value                   = obj.getAttribute('CT_CP');
            document.getElementById("CT_TELEFONO1").value            = obj.getAttribute('CT_TELEFONO1');
            document.getElementById("CT_TELEFONO2").value            = obj.getAttribute('CT_TELEFONO2');
            document.getElementById("CT_CONTACTO1").value            = obj.getAttribute('CT_CONTACTO1');
            document.getElementById("CT_CONTACTO2").value            = obj.getAttribute('CT_CONTACTO2');
            document.getElementById("CT_EMAIL1").value               = obj.getAttribute('CT_EMAIL1');
            document.getElementById("CT_EMAIL2").value               = obj.getAttribute('CT_EMAIL2');
            document.getElementById("CT_LOCALIDAD").value            = obj.getAttribute('CT_LOCALIDAD');
            document.getElementById("CT_UPLINE").value               = obj.getAttribute('CT_UPLINE');
            document.getElementById("CT_CONTACTO").value             = obj.getAttribute('CT_CONTACTO');
            document.getElementById("CT_NOTAS").value                = obj.getAttribute('CT_NOTAS');
            document.getElementById("CT_CATEGORIA1").value           = obj.getAttribute('CT_CATEGORIA1');
            document.getElementById("CT_CATEGORIA2").value           = obj.getAttribute('CT_CATEGORIA2');
            document.getElementById("CT_CATEGORIA3").value           = obj.getAttribute('CT_CATEGORIA3');
            document.getElementById("CT_CATEGORIA4").value           = obj.getAttribute('CT_CATEGORIA4');
            document.getElementById("CT_CATEGORIA5").value           = obj.getAttribute('CT_CATEGORIA5');
         }
         $("#dialogWait").dialog('close');
      },
      error: function(objeto, quepaso, otroobj){
         alert("Error: Al cargar datos persona:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Editar el cliente seleccionado en el detalle*/
function EditarDeta(id){
   isDetalle =true;
   EditaPersona(id);
}
/**Edita la información del nodo seleccionado*/
function uniEditar(){
   var grid=jQuery("#gridBuscar");
   var id = grid.getGridParam("selrow");
   if(id != null){
      EditaPersona(id);
   }
}
/**Muestra la red del nodo seleccionado*/
function uniRed(intNodoHijo){
   //Obtenemos fila seleccionada
   var grid=jQuery("#gridBuscar");
   var id = grid.getGridParam("selrow");
   if(id != null){
      var intNodoRaiz = id;
      if(intNodoHijo == null) intNodoHijo = id;
      //Nos movemos a la pestana
      TabsMap("2",true);
      $("#tabs"+strNomTab).tabs( "option","active",  2);
      TabsMap("0",false);
      //Cargamos la pagina
      $("#dialogWait").dialog('open');
      $.ajax({
         type: "POST",
         data: "IdCliente=" + intNodoHijo + "&IdClienteRaiz=" + intNodoRaiz,
         scriptCharset: "utf-8" ,
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType:"html",
         url: "uni_personared.jsp",
         success: function(datos){
            document.getElementById("head3").innerHTML = datos;
            $("#dialogWait").dialog('close');
         },
         error: function(objeto, quepaso, otroobj){
            alert(":Uni:" + objeto + " " + quepaso + " " + otroobj);
         }
      });
   }   
}
/**Agrega un hijo del nodo seleccionado*/
function uniAgregaHijo(){
   var grid=jQuery("#gridBuscar");
   var id = grid.getGridParam("selrow");
   if(id != null){
      NuevaPersona(id);
   }
}
/**Borra un nodo hijo*/
function BorraHijo(idBorra,idPadre){
   var b = confirm("Desea borrar la persona con número:" + idBorra);
   if(b){
      $("#dialogWait").dialog('open');
      $.ajax({
         type: "POST",
         data: "CT_ID=" + idBorra,
         scriptCharset: "utf-8" ,
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType:"html",
         url: "CIP_TablaOp.jsp?ID=3&opnOpt=MLMCTE1",
         success: function(datos){
            //Validamos si regreso algun dato
            if(Left(trim(datos),2) == "OK"){
               $("#dialogWait").dialog('close');
               alert("Socio borrado de la red");
               uniRed(idPadre);
            }else{
               alert(datos);
               $("#dialogWait").dialog('close');
            }
         },
         error: function(objeto, quepaso, otroobj){
            alert(":error al guardar el cliente:" + objeto + " " + quepaso + " " + otroobj);
         }
      });      
   }
}
/**Guarda los datos de la persona*/
function SaveData(){
   var strPost = "";
   strPost += "CT_ID=" + document.getElementById("CT_ID").value;
   strPost += "&CT_RAZONSOCIAL=" + encode(document.getElementById("CT_RAZONSOCIAL").value);
   strPost += "&CT_RFC=" + encode(document.getElementById("CT_RFC").value);
   strPost += "&SC_ID=" + encode(document.getElementById("SC_ID").value);
   strPost += "&CT_CALLE=" + encode(document.getElementById("CT_CALLE").value);
   strPost += "&CT_NUMERO=" + encode(document.getElementById("CT_NUMERO").value);
   strPost += "&CT_NUMINT=" + encode(document.getElementById("CT_NUMINT").value);
   strPost += "&CT_COLONIA=" + encode(document.getElementById("CT_COLONIA").value);
   strPost += "&CT_MUNICIPIO=" + encode(document.getElementById("CT_MUNICIPIO").value);
   strPost += "&CT_ESTADO=" + encode(document.getElementById("CT_ESTADO").value);
   strPost += "&CT_CP=" + encode(document.getElementById("CT_CP").value);
   strPost += "&CT_TELEFONO1=" + encode(document.getElementById("CT_TELEFONO1").value);
   strPost += "&CT_TELEFONO2=" + encode(document.getElementById("CT_TELEFONO2").value);
   strPost += "&CT_CONTACTO1=" + encode(document.getElementById("CT_CONTACTO1").value);
   strPost += "&CT_CONTACTO2=" + encode(document.getElementById("CT_CONTACTO2").value);
   strPost += "&CT_EMAIL1=" + encode(document.getElementById("CT_EMAIL1").value);
   strPost += "&CT_EMAIL2=" + encode(document.getElementById("CT_EMAIL2").value);
   strPost += "&CT_LOCALIDAD=" + encode(document.getElementById("CT_LOCALIDAD").value);
   strPost += "&CT_UPLINE=" + encode(document.getElementById("CT_UPLINE").value);
   strPost += "&CT_CONTACTO=" + encode(document.getElementById("CT_CONTACTO").value);
   strPost += "&CT_FECHAULTIMOCONTACTO=" + encode(document.getElementById("CT_FECHAULTIMOCONTACTO").value);
   strPost += "&CT_NOTAS=" + encode(document.getElementById("CT_NOTAS").value);
   strPost += "&CT_CATEGORIA1=" + encode(document.getElementById("CT_CATEGORIA1").value);
   strPost += "&CT_CATEGORIA2=" + encode(document.getElementById("CT_CATEGORIA2").value);
   strPost += "&CT_CATEGORIA3=" + encode(document.getElementById("CT_CATEGORIA3").value);
   strPost += "&CT_CATEGORIA4=" + encode(document.getElementById("CT_CATEGORIA4").value);
   strPost += "&CT_CATEGORIA5=" + encode(document.getElementById("CT_CATEGORIA5").value);
   //Enviamos la petición de guardado
   $("#dialogWait").dialog('open');
   $.ajax({
      type: "POST",
      data: strPost,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType:"html",
      url: "CIP_TablaOp.jsp?ID=1&opnOpt=MLMCTE1",
      success: function(datos){
         //Validamos si regreso algun dato
         if(Left(trim(datos),2) == "OK"){
            $("#dialogWait").dialog('close');
            //Validamos si es nuevo o una edicion
            if(strOperPersona == "_new"){
               strOperPersona = "";
               alert("Socio nuevo dado de alta");
               uniRed(trim(datos).replace("OK",""))
            }else{
               strOperPersona = "";
               CancelSave();
            }
            isDetalle =false;
         }else{
            alert(datos);
            $("#dialogWait").dialog('close');
         }
      },
      error: function(objeto, quepaso, otroobj){
         alert(":error al guardar el cliente:" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
/**Cancela la edicion de datos*/
function CancelSave(){
   document.getElementById("idt").innerHTML = "...";
   if(!isDetalle){
      TabsMap("0",true);
      $("#tabs"+strNomTab).tabs( "option","active",  0);
      TabsMap("1",false);  
   }else{
      $("#tabs"+strNomTab).tabs( "option","active",  2);
      TabsMap("1",false);  
   }
   isDetalle =false;
   strOperPersona = "";
   ResetCte();
}
/**Limpia los campos de captura de cliente*/
function ResetCte(){
   document.getElementById("CT_RAZONSOCIAL").value = "";
   document.getElementById("CT_RFC").value = "";
   document.getElementById("SC_ID").value = "1";
   document.getElementById("CT_CALLE").value = "";
   document.getElementById("CT_NUMERO").value = "";
   document.getElementById("CT_NUMINT").value = "";
   document.getElementById("CT_COLONIA").value = "";
   document.getElementById("CT_MUNICIPIO").value = "";
   document.getElementById("CT_ESTADO").value = "";
   document.getElementById("CT_CP").value = "";
   document.getElementById("CT_TELEFONO1").value = "";
   document.getElementById("CT_TELEFONO2").value = "";
   document.getElementById("CT_CONTACTO1").value = "";
   document.getElementById("CT_CONTACTO2").value = "";
   document.getElementById("CT_EMAIL1").value = "";
   document.getElementById("CT_EMAIL2").value = "";
   document.getElementById("CT_LOCALIDAD").value = "";
   document.getElementById("CT_UPLINE").value = "0";
   document.getElementById("CT_CONTACTO").value = "";
   document.getElementById("CT_FECHAULTIMOCONTACTO").value = "";
   document.getElementById("CT_NOTAS").value = "";
   document.getElementById("CT_CATEGORIA1").value = "0";
   document.getElementById("CT_CATEGORIA2").value = "0";
   document.getElementById("CT_CATEGORIA3").value = "0";
   document.getElementById("CT_CATEGORIA4").value = "0";
   document.getElementById("CT_CATEGORIA5").value = "0";
}
/**
 *Activa o inactiva las pestanas que le mandamos como parametros
 */
function TabsMap(lstTabs,bolActivar){
   var arrTabs = lstTabs.split(",");
   for(var i=0;i<arrTabs.length;i++){
      if(bolActivar){
         $("#tabs"+strNomTab).tabs( 'enable' , parseInt(arrTabs[i]));
      }else{
         $("#tabs"+strNomTab).tabs( 'disable' , parseInt(arrTabs[i]));
      }
   }
}
/**Codifica el valor antes de enviarlo por POST*/
function encode(strValor){
   return encodeURIComponent(strValor);
}
