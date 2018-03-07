/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function PRO_Credito(){//Funcion necesaria para que pueda cargarse la libreria en automatico
}

/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagCte(){
    OpnOpt('CLIENTES','grid','dialogCte',false,false);
}

/**Abre el cuadro de dialogo para buscar funcionario o dar de alta uno nuevo*/
function OpnDiagFno(){
    OpnOpt('FUNCI','grid','dialog2',false,false);
}

function OpnDiagObo(){
    OpnOpt('OBLIGADO','grid','dialog2',false,false);
}

function cargaseleccion(){
    //var tcseleccion = setTimeout(cargaseleccion, 2000);
    //alert("entro");
    CTO_ID = document.getElementById("CTO_ID").value; 
    var grid = jQuery("#DOCUMENTACION");
    //alert(CTO_ID);
    grid.setGridParam({
        url:"CIP_TablaOp.jsp?ID=5&opnOpt=GRID_DOC&_search=true&CTO_ID=" + CTO_ID
    });
    grid.trigger('reloadGrid');
    

}

function InitDoc(){
    //document.getElementById("PrintCREDITO").style.display="none";
    if(document.getElementById("CT_NOM").value !=""){
        document.getElementById("CTO_BTNUP1").style.display = "block";
        //document.getElementById("BTN_NEWDOC").style.display = "block";
        document.getElementById("BTN_DELDOC").style.display = "block"; 
        //mandamos llamar la función
        var tcseleccion = setTimeout(cargaseleccion, 2000);
    }else{
        document.getElementById("CTO_BTNUP1").style.display = "none";
        //document.getElementById("BTN_NEWDOC").style.display = "none";
        document.getElementById("BTN_DELDOC").style.display = "none";          
    }        
    
}


/**Obtiene el nombre del cliente al que se le esta haciendo la venta*/
function ObtenNomCteCredito(objPedido,lstdeta,strTipoVta,bolPasaPedido){
    var intCte = document.getElementById("CT_ID").value;
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
            }
            //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
            if(bolPasaPedido){
                DrawPedidoDetaenVenta(objPedido,lstdeta,strTipoVta);
            }
        },
        error: function(objeto, quepaso, otroobj){
            document.getElementById("CT_NOM").value = "***************";
            ValidaShow("CT_NOM",lstMsg[28]);
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

/**Obtiene el nombre del cliente*/
function ObtenNomFnoCredito(){
    var intFno= document.getElementById("F_ID").value;
    //ValidaClean("F_NOM");
    $.ajax({
        type: "POST",
        data: "F_ID=" + intFno,
        scriptCharset: "utf-8" ,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType:"xml",
        url: "CIP_TablaOp.jsp?ID=4&opnOpt=FUNCI",
        success: function(datoVal){
            //alert("aqui es donde salta el error");
            var objFno = datoVal.getElementsByTagName("cat_funcionariooo")[0];
            if(objFno.getAttribute('F_ID') == 0){
                document.getElementById("F_NOM").value = "***************";
                ValidaShow("F_NOM",lstMsg[28]);
            }else{
                document.getElementById("F_NOM").value = objFno.getAttribute('F_NOMBRE') + objFno.getAttribute('F_APATERNO') + objFno.getAttribute('F_AMATERNO'); 
            }
        },
        error: function(objeto, quepaso, otroobj){
            document.getElementById("F_NOM").value = "***************";
            ValidaShow("F_NOM",lstMsg[28]);
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

/**Obtiene el nombre del cliente al que se le esta haciendo la venta*/
function ObtenNomOboCredito(objPedido,lstdeta,strTipoVta,bolPasaPedido){
    var intCte = document.getElementById("OB_ID").value;
    if(bolPasaPedido == undefined)bolPasaPedido = false;
    ValidaClean("OB_NOMBRE");
    $.ajax({
        type: "POST",
        data: "CT_ID=" + intCte,
        scriptCharset: "utf-8" ,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType:"xml",
        url: "VtasMov.do?id=9",
        success: function(datoVal){
            var objObo = datoVal.getElementsByTagName("vta_clientes")[0];
            if(objObo.getAttribute('CT_ID') == 0){
                document.getElementById("OB_NOMBRE").value = "***************";
                ValidaShow("OB_NOMBRE",lstMsg[28]);
            }else{
                document.getElementById("OB_NOMBRE").value = objObo.getAttribute('CT_RAZONSOCIAL');
            }
            //Si esta activa la bandera nos manda a la funcion para mostrar el detalle
            if(bolPasaPedido){
                DrawPedidoDetaenVenta(objPedido,lstdeta,strTipoVta);
            }
        },
        error: function(objeto, quepaso, otroobj){
            document.getElementById("OB_NOMBRE").value = "***************";
            ValidaShow("CT_NOM",lstMsg[28]);
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

/**Se encarga de subir la documentacion al servidor*/
function UpFileDoc(strNomFile){
    ValidaClean(strNomFile);
    if(document.getElementById(strNomFile).value == ""){
        ValidaShow(strNomFile,lstMsg[13]);
        return false;
    }
   
    var strExtencion = Right(document.getElementById(strNomFile).value.toUpperCase(), 3);
    //alert("ext "+ strExtencion);
    if(strExtencion == "XLS" || strExtencion == "TXT" || strExtencion == "PDF" || strExtencion == "pdf"){
        //Subimos los datos al servidor
        ajaxFileUploadDoc(strNomFile,document.getElementById("CTO_ID").value);
        return true;

    }else{
        ValidaShow(strNomFile,"Formato no valido solo: .txt o .xls o .pdf");
        document.getElementById(strNomFile).value="";
        return false;     
    }
   
}
/*Sube el archivo de la importacion de cuentas al servidor*/
function ajaxFileUploadDoc(strNomFile,intCTO_ID)
{
    $("#dialogWait").dialog('open');
    //Subimos el archivo con ajaxUpload
    $.ajaxFileUpload
    (
    {
        url:'PRO_UPFileDoc.jsp?CTO_ID=' +intCTO_ID,
        secureuri:false,
        fileElementId:strNomFile,
        dataType: 'json',
        success: function (data, status)
        {
            if(typeof(data.error) != 'undefined'){
                if(data.error != ''){
                    alert(data.error);             
                }
            }
            $("#dialogWait").dialog('close');
            var grid2 = jQuery("#DOCUMENTACION");
            //alert("Archivo subido con exito!!");
            document.getElementById(strNomFile).value="";            
            grid2.trigger("reloadGrid");            
        },
        error: function (data, status, e){
            alert(e);
            $("#dialogWait").dialog('close');           
        }
    }
    )

    return false;
}


function delDocumento()
{
    var grid = jQuery("#DOCUMENTACION"); 
    if(grid.getGridParam("selrow") != null ){
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var ID =lstRow.DMN_ID;
        
        var op = confirm("¿Realmente desea borrar el registro?: ");
        //OperaMetas="_borrar";
        if(op)
        {
            var strPost="&DMN_ID="+ID;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "PRO_Documento.jsp?ID=2",
                success: function(datos)
                {
                    if(datos.substring(0,2)=="OK")
                    {
                        alert("Registro Eliminado");
                        var grid2 = jQuery("#DOCUMENTACION");
                        grid2.trigger("reloadGrid");                         
                    }
                },
                error: function(objeto, quepaso, otroobj)
                {
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });
        }
        
    }else{
        alert("FAVOR DE SELECCIONAR UN DOCUMENTO");
    }
    
}


function ImprimirCredito(){
   //alert("hola");
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      var strHtml = CreaHidden("CTO_ID",lstRow.CTO_ID);
      //openFormat("CARCRE","PDF",strHtml);   
      openFormat("CONCRE","PDF",strHtml); 
      //openFormat("CONPAG","PDF",strHtml);
      
   }   
}

function Autorizar(){
var grid = jQuery("#CREDITO"); 
    if(grid.getGridParam("selrow") != null ){
        var id = grid.getGridParam("selrow");
        var lstRow = grid.getRowData(id);
        var ID =lstRow.CTO_ID;
        
        var op = confirm("¿Desea autorizar el credito?: " +ID);
        //OperaMetas="_borrar";       
        
        if(op)
        {
            var strPost="&CTO_ID="+ID;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "PRO_Autorizar.jsp?ID=2",
                success: function(datos)
                {
                    if(datos.substring(0,2)=="OK")
                    {
                        alert("Autorizado");
                        //document.getElementById("CTO_AUTORIZAR").style.display = "none";
                        document.getElementById('CTO_AUTORIZAR').disabled = true;
                        var grid2 = jQuery("#CREDITO");
                        //grid2.trigger("reloadGrid");                         
                    }
                    else{
                        alert("EL CREDITO YA ESTA AUTORIZADO");
                    }
                },
                error: function(objeto, quepaso, otroobj)
                {
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });
        }
        
    }else{
      //  alert("FAVOR DE SELECCIONAR UN DOCUMENTO");
    }



}
﻿/**Abre un archivo*/
function ProOpnFile() {
    var grid = jQuery("#DOCUMENTACION");
    var idRow = grid.getGridParam("selrow");
    if (idRow != null) {
        ProAbreDocumento(idRow);
    }
}
﻿/**Regresa el documento digital para su apertura*/
function ProAbreDocumento(id) {
    $("#dialogWait").dialog('open');
    $.ajax({
        url: 'PRO_Documento.jsp?ID=4&DMN_ID=' + id,
        dataType: "html",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        success: function(datos) {
            Abrir_Link(datos, "_new", 200, 200, 0, 0);
            $("#dialogWait").dialog('close');
        },
        error: function(objeto, quepaso, otroobj) {
            alert("Estas viendo esto por que fallo");
            alert("Paso siguiente: " + quepaso);
        }
    });
}

/**Manda abrir un reporte*//*
function openFormatContrato(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=1\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}
*/


/**Manda abrir un reporte*/
function openFormatContrato1(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=2\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}

/**Manda abrir un reporte*/
function openFormatPagare(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=3\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}

/**Manda abrir un reporte*/
function openFormatSolicitud1(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=4\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}


/**Manda abrir un reporte*/
function openFormatSolicitud2(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=5\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}


/**Manda abrir un reporte*/
function openFormatAnexoa(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=6\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}


/**Manda abrir un reporte*/
function openFormatFirmas(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=7\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}


/**Manda abrir un reporte*/
function openFormatCroquis(strNomForm,strTipo,strHtmlControl,strMaskFolio){
   var strHtml = "<form action=\"PRO_Contrato.jsp?ID=8\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   strHtml += CreaHidden("NomForm",strNomForm);
   if(strMaskFolio != undefined){
     strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
   }
   strHtml += CreaHidden("report",strTipo);
   strHtml+= strHtmlControl;
   var grid = jQuery("#CREDITO");
   if(grid.getGridParam("selrow") != null){
      var lstRow = grid.getRowData(grid.getGridParam("selrow"));
      strHtml += CreaHidden("CTO_ID",lstRow.CTO_ID);
   }
   strHtml+= "</form>";
   document.getElementById("formHidden").innerHTML  = strHtml;
   document.getElementById("formSend").submit();

}

function Clausulas(){

   Abrir_Link("images/CLAUSULAS.pdf" ,'_reporte',500,600,0,0);
      
   }   