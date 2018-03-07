/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function vta_etiqueta_imp()
{
    
}

function etiqueta_imp_init()
{
    d.getElementById("btn1").setAttribute("class", "Oculto");
    d.getElementById("btn1").setAttribute("className", "Oculto");
}

function imp_etq()
{
    var strCODIGO = document.getElementById("CODIGO_PROD").value;
    var intEtiqueta= document.getElementById("SEL_ETQ").value;
    var intCantidad= document.getElementById("ETQ_IMP_CANTIDAD").value;
    $("#dialogWait").dialog("open");
    var strPOST = "&PR_CODIGO="+strCODIGO;
        strPOST+="&ET_ID="+intEtiqueta;
        strPOST+="&Cantidad="+intCantidad;
        
    Abrir_Link("ERP_com_recep.jsp?id=3"+strPOST, "_new", 200, 200, 0, 0);
    $("#dialogWait").dialog("close");
}
function OpnDialogProd()
{
    OpnOpt('PROD', 'grid', 'dialogProd', false, false);
}

function ImpEtiquetaPDF(){
    var strPost = "idEtiqueta=" + document.getElementById("SEL_ETQ").value
    
    $.ajax({
        type: "POST",
       data: strPost,
       scriptCharset: "utf-8",
       contentType: "application/x-www-form-urlencoded;charset=utf-8",
       cache: false,
       dataType: "html",
       url: "ERP_com_recep.jsp?id=7",
       success:function(data){
           console.log(data);
           Abrir_Link("JasperReport?REP_ID=" + data + "&boton_1=PDF&EMP_ID=" + document.getElementById("EMP_ID").value
            + "&SC_ID=" + document.getElementById("SC_ID").value
            + "&PR_CODIGO=" + document.getElementById("CODIGO_PROD").value
            + "&NUM_COPIAS=" + document.getElementById("ETQ_IMP_CANTIDAD").value, '_reporte', 500, 600, 0, 0);
       },
       error:function(){
           
       }
    });
}