/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function cat_cto(){//Funcion necesaria para que pueda cargarse la libreria en automatico
}

/**Abre el cuadro de dialogo para buscar cliente o dar de alta uno nuevo*/
function OpnDiagCte(){
    OpnOpt('CLIENTES','grid','dialogCte',false,false);
}

/**Abre el cuadro de dialogo para buscar funcionario o dar de alta uno nuevo*/
function OpnDiagFno(){
    OpnOpt('FUNCI','grid','dialogFno',false,false);
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
    //document.getElementById("CTO_BTNUP1").style.display="none";
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

/**Se encarga de subir el logo al servidor*/
function UpFileDoc(strNomFile){
    ValidaClean(strNomFile);
    if(document.getElementById(strNomFile).value == ""){
        ValidaShow(strNomFile,lstMsg[13]);
        return false;
    }
   
    var strExtencion = Right(document.getElementById(strNomFile).value.toUpperCase(), 3);
    //alert("ext "+ strExtencion);
    if(strExtencion == "XLS" || strExtencion == "TXT"){
        //Subimos los datos al servidor
        ajaxFileUploadDoc(strNomFile,document.getElementById("CTO_ID").value);
        return true;

    }else{
        ValidaShow(strNomFile,"Formato no valido solo: .txt o .xls");
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
        url:'ERP_UPFileDoc.jsp?CTO_ID=' +intCTO_ID,
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
                url: "ERP_Documento.jsp?ID=2",
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
