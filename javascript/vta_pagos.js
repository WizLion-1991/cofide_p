/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function vta_pagos(){
    
} 

/*
function saveDatos(strNomFile){
    if(validaDatos()!=0){
        if(UpFilePag(strNomFile)!=true){
        
            alert("ERROR: NO SE PUDO SUBIR EL ARCHIVO");
        }else{
            var strPost = "&fecha=" + document.getElementById("AP_FECHA").value;
            strPost += "&bc_id=" + document.getElementById("BC_ID").value;
            strPost += "&url=" + document.getElementById("AP_IMSGEN1").value;
            strPost += "&archivo=" + document.getElementById("COM_ID").value;
            strPost += "&moneda=" + document.getElementById("MON_ID").value;
            $.ajax({
                type: "POST",     
                data: strPost,
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "ERP_UPFilePagos.jsp?ID=1",
                success: function(datos){
                    
                    //alert("Aplicación de Pagos Exitosa!!");
                    alert("res"+datos);
                   
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });
        }
    }
}
*/

function validaDatos(){
    
    var bc_id = document.getElementById("BC_ID").value;
    if(bc_id==0){
        
        alert("ELIGE UN BANCO");
        return 0;
    }
    
    var mon_id = document.getElementById("MON_ID").value;
    if(mon_id==0){
        alert("ELIGE UNA MONEDA");
        return 0;
    }
    
    var arc_id = document.getElementById("COM_ID").value;
    if(arc_id==0){
        alert("ELIGE UN ARCHIVO DE COBRANZA");
        return 0;
    } 
    
    return 1;
}



/**Se encarga de subir el logo al servidor*/
function UpFilePag(strNomFile){
    if(validaDatos()!=0){
    ValidaClean(strNomFile);
    if(document.getElementById(strNomFile).value == ""){
        ValidaShow(strNomFile,lstMsg[13]);
        return false;
    }
   
    var strExtencion = Right(document.getElementById(strNomFile).value.toUpperCase(), 3);
    //alert("ext "+ strExtencion);
    if(strExtencion == "XLS" || strExtencion == "TXT"){
        //Subimos los datos al servidor
        //ajaxFileUploadPag(strNomFile);
        
        ajaxFileUploadPag(strNomFile,document.getElementById("BC_ID").value,
        document.getElementById("MON_ID").value,document.getElementById("COM_ID").value,
        document.getElementById("AP_FECHA").value);
        return true;

    }else{
        ValidaShow(strNomFile,"Formato no valido solo: .txt o .xls");
        return false;     
    }
    }
   
}
/*Sube el archivo de la importacion de cuentas al servidor*/
function ajaxFileUploadPag(strNomFile, intBC_ID, intMON_ID, intCPM_ID, strFecha)
{
    $("#dialogWait").dialog('open');
    //Subimos el archivo con ajaxUpload
    $.ajaxFileUpload
    (
    {

        url:'ERP_UPFilePagos.jsp?BC_ID=' +intBC_ID+ '&MON_ID=' +intMON_ID+ '&CPM_ID=' +intCPM_ID+ '&AP_FECHA=' +strFecha,
        //url:'ERP_UPFileDoc.jsp?CTO_ID=' +intCTO_ID,
        //url: "P_ParametrosArchivo.jsp?ID=1",        
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
        //var grid2 = jQuery("#DOCUMENTACION");
        //grid2.trigger("reloadGrid");   
        alert("Aplicación de Pagos Exitosa!!");
        },
        error: function (data, status, e){
            alert(e);
            $("#dialogWait").dialog('close');    
            
        }
    }
    )

    return false;
}