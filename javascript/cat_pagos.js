 /* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function cat_pagos(){
    
} 

/**Se encarga de subir el logo al servidor*/
function UpFilePag(strNomFile){
    ValidaClean(strNomFile);
    if(document.getElementById(strNomFile).value == ""){
        ValidaShow(strNomFile,lstMsg[13]);
        return false;
    }
   
    var strExtencion = Right(document.getElementById(strNomFile).value.toUpperCase(), 3);
    //alert("ext "+ strExtencion);
    if(strExtencion == "XLS" || strExtencion == "TXT"){
        //Subimos los datos al servidor
        ajaxFileUploadPag(strNomFile);
        return true;

    }else{
        ValidaShow(strNomFile,"Formato no valido solo: .txt o .xls");
        return false;     
    }
   
}
/*Sube el archivo de la importacion de cuentas al servidor*/
function ajaxFileUploadPag(strNomFile)
{
    $("#dialogWait").dialog('open');
    //Subimos el archivo con ajaxUpload
    $.ajaxFileUpload
    (
    {
        url:"ERP_UPFilePagos.jsp?ID=1",
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
            alert("Aplicación de Pagos Fallida!!");
        }
    }
    )

    return false;
}