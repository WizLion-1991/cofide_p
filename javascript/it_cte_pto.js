var strNomTabBD = "CLIEPROS";//Nombre de los tabs
var strOptEdit = "";//Indica en que operacion esta en nuevo o en editar
var strOptSc = "";//Indica en que operacion esta en nuevo o en editar
var strOptCon = "";//Indica en que operacion esta en nuevo o en editar
var itemIdSv = 0;//indice para los items del grido
var intIdCte=0; //alamacena el id del proyecto
var d="document";


var intTabAct = 0;
var bolHuboCambios = false;

function it_cte_pto(){
}

/**Inicia la pantalla de cliente prospecto*/
function InitCtePto(){


    $(document).ready(function(){
        $("input").focus(function(){
            $("input").css("background-color","#FFFFCC");
        });
    });
    $("#dialogWait").dialog("open");
    //ocultamos menus
    myLayout.close( "east");
    myLayout.close( "north");
    //Abrimos filtro del grid
    var grid=jQuery("#GRIDDATOS");
    grid.jqGrid('filterToolbar',{
        autosearch:true
    });
    TabsMapBD("0",true);
    $("#tabs"+strNomTabBD).tabs( "option","active", 0 );
    TabsMapBD("1",false);
    TabsMapBD("2",false);
    TabsMapBD("3",false);
    TabsMapBD("4",false);
    TabsMapBD("5",false);
    //BOTONES DE PROYECTOS
    document.getElementById("btn1").style.display = 'none';
    document.getElementById("BOTON_SAVE").style.display = 'none';
    document.getElementById("BOTTONCALCEL_PRY").style.display = 'none';
    document.getElementById("CT_NOMBRE").style.display = 'none';
    //BOTONES DE SUCURSALES
    document.getElementById("BOTON_SAVE_SC").style.display = 'none';
    document.getElementById("CALCEL_SC").style.display = 'none';
    //BOTONES DE OCNTACTOS
    document.getElementById("BOTON_SAVE_CON").style.display = 'none';
    document.getElementById("CALCEL_CON").style.display = 'none';

    $("#dialogWait").dialog("close");        
}


/*Nos cambia a la pantalla de datos generales para poder dar de alta**/
function NuevoCtePto(){
    strOptEdit = "_new";
    TabsMapBD("1",true);
    $("#tabs"+strNomTabBD).tabs( "option","active",  1);
    TabsMapBD("0",false);
    TabsMapBD("2",false);
    TabsMapBD("3",false);
    TabsMapBD("4",false);
    TabsMapBD("5",false);
    $("#dialogWait").dialog("open");
    document.getElementById("btn1").style.display = "none";
    document.getElementById("BOTONGUARDA").style.display = "none";
    document.getElementById("CT_ALTA").value=FechaActual();
    ActivaNuevoEdicion(true);
    $("#dialogWait").dialog("close");
}
/**
 *Activa o inactiva las pestanas que le mandamos como parametros
 */
function TabsMapBD(lstTabs,bolActivar){
    var arrTabs = lstTabs.split(",");
    for(var i=0;i<arrTabs.length;i++){
        if(bolActivar){
            $("#tabs"+strNomTabBD).tabs( 'enable' , parseInt(arrTabs[i]));
        }else{
            $("#tabs"+strNomTabBD).tabs( 'disable' , parseInt(arrTabs[i]));
        }
    }
}

/**Activa la ventana de edicion dependiendo si es Edición o Alta*/
function ActivaNuevoEdicion(bolActiva){
//Activamos los controles

}

/*
 *Valida si estan llenos los campos
 */
function valCtePto(){
    var strRaz=document.getElementById("CT_RAZONSOCIAL");
    var strRfc=document.getElementById("CT_RFC");
    var strCalle=document.getElementById("CT_CALLE");
    var strSuc=document.getElementById("SC_ID");
    var strCol=document.getElementById("CT_COLONIA");
    var strMun=document.getElementById("CT_MUNICIPIO");
    var strEst=document.getElementById("CT_ESTADO");
    var strCp=document.getElementById("CT_CP");
    var strNum=document.getElementById("CT_NUMERO");

    if(strRaz.value==""){
        alert("Favor de capturar la Razon Social.");
        strRaz.focus();
        return 0;
    }
    if(strRfc.value==""){
        alert("Favor de capturar el RFC.");
        strRfc.focus();
        return 0;
    }
    if(strCalle.value==""){
        alert("Favor de capturar la Calle.");
        strCalle.focus();
        return 0;
    }
    if(strSuc.value==""){
        alert("Favor de elegir un a sucursal.");
        strSuc.focus();
        return 0;
    }
    if(strCol.value==""){
        alert("Favor de capturar una colonia.");
        strCol.focus();
        return 0;
    }
    if(strMun.value==""){
        alert("Favor de capturar el municipio.");
        strMun.focus();
        return 0;
    }
    if(strEst.value==""){
        alert("Favor de elegir un estado.");
        strEst.focus();
        return 0;
    }
    if(strCp.value==""){
        alert("Favor de capturar el Codigo Postal.");
        strCp.focus();
        return 0;
    }
    if(strNum.value==""){
        alert("Favor de proporcionar un Numero.");
        strNum.focus();
        return 0;
    }
    return 1;
}



/*
 *Sirve para dara de alata un nuevo cliente prospecto
 */
function UpCtePto(){

    //Empezamos a generar el post recuperando los datos para dar de alta
    var strPost = "&CT_RAZONSOCIAL=" + encode(document.getElementById("CT_RAZONSOCIAL").value);
    strPost += "&CT_RFC=" + encode( document.getElementById("CT_RFC").value);
    strPost += "&SC_ID=" +  encode(document.getElementById("SC_ID").value);
    strPost += "&CT_CALLE=" +  encode(document.getElementById("CT_CALLE").value);
    strPost += "&CT_NUMERO=" +  encode(document.getElementById("CT_NUMERO").value);
    strPost += "&CT_NUMINT=" +  encode(document.getElementById("CT_NUMINT").value);
    strPost += "&CT_COLONIA=" +  encode(document.getElementById("CT_COLONIA").value);
    strPost += "&CT_MUNICIPIO=" +  encode(document.getElementById("CT_MUNICIPIO").value);
    strPost += "&CT_ESTADO=" +  encode(document.getElementById("CT_ESTADO").value);
    strPost += "&CT_CP=" +  encode(document.getElementById("CT_CP").value);
    strPost += "&CT_TELEFONO1=" +  encode(document.getElementById("CT_TELEFONO1").value);
    strPost += "&CT_TELEFONO2=" +  encode(document.getElementById("CT_TELEFONO2").value);
    strPost += "&CT_CONTACTO1=" +  encode(document.getElementById("CT_CONTACTO1").value);
    strPost += "&CT_CONTACTO2=" +  encode(document.getElementById("CT_CONTACTO2").value);
    strPost += "&CT_EMAIL1=" +  encode(document.getElementById("CT_EMAIL1").value);
    strPost += "&CT_EMAIL2=" +  encode(document.getElementById("CT_EMAIL2").value);
    strPost += "&CT_NOTAS=" +  encode(document.getElementById("CT_NOTAS").value);
    strPost += "&CT_CATEGORIA2=" +  encode(document.getElementById("CT_CATEGORIA2").value);
    strPost += "&CT_CATEGORIA1=" +  encode(document.getElementById("CT_CATEGORIA1").value);
    strPost += "&CT_DIASCREDITO=" +  encode(document.getElementById("CT_DIASCREDITO").value);
    strPost += "&CT_MONTOCRED=" +  encode(document.getElementById("CT_MONTOCRED").value);
    strPost += "&CT_ALTA=" +  encode(document.getElementById("CT_ALTA").value);
    strPost += "&CT_MODIFICADO=" +  encode(document.getElementById("CT_MODIFICADO").value);
    strPost += "&CT_CATEGORIA3=" +  encode(document.getElementById("CT_CATEGORIA3").value);
    strPost += "&CT_CATEGORIA4=" +  encode(document.getElementById("CT_CATEGORIA4").value);
    strPost += "&CT_CATEGORIA5=" +  encode(document.getElementById("CT_CATEGORIA5").value);
    if(valCtePto()!=0){
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "utf-8" ,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType:"html",
            url: "it_cte_pto.jsp?ID=1",
            success: function(datos){
                if(datos.substring(0,2)=="OK"){
                    TabsMapBD("5",true);
                    $("#tabs"+strNomTabBD).tabs( "option","active",  5);
                    TabsMapBD("4",true);
                    $("#tabs"+strNomTabBD).tabs( "option","active",  4);
                    TabsMapBD("3",true);
                    $("#tabs"+strNomTabBD).tabs( "option","active",  3);                    
                    TabsMapBD("1",true);
                    $("#tabs"+strNomTabBD).tabs( "option","active",  1);
                    TabsMapBD("2",true);
                    $("#tabs"+strNomTabBD).tabs( "option","active",  2);
                    TabsMapBD("0",false);
                    //Guardamos el id del ultimo registro para  ligar los otros datos
                    document.getElementById("CT_ID").value=datos.substring(2);
                    alert("CLIENTE GUARDADO CORRECTAMENTE!!!");

                }else{
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            },
            error: function(objeto, quepaso, otroobj){
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    }
}
/**
 *Funcion para sacar la fecha actual
 ***/
function FechaActual(){
    var fechaActual = new Date();
    dia = fechaActual.getDate();
    mes = fechaActual.getMonth() +1;
    anno = fechaActual.getYear();
    if (dia <10) dia = "0" + dia;
    if (mes <10) mes = "0" + mes;
    if (anno < 1000) anno+=1900;
    fechaHoy = dia + "/" + mes + "/" + anno;
    return fechaHoy;
}

/**
 *Funcion para poder editar al cliente prospecto con boble click 
 **/    
function _dbl_clickLoadWindowCTEPTO(id){

    $("#dialogWait").dialog("open");
    //Peticion por ajax para mostrar info
 
    TabsMapBD("5",true);
    $("#tabs"+strNomTabBD).tabs( "option","active",  5);
    TabsMapBD("4",true);
    $("#tabs"+strNomTabBD).tabs( "option","active",  4);
    TabsMapBD("3",true);
    $("#tabs"+strNomTabBD).tabs( "option","active",  3);
    TabsMapBD("2",true);
    $("#tabs"+strNomTabBD).tabs( "option","active",  2);
    TabsMapBD("1",true);
    $("#tabs"+strNomTabBD).tabs( "option","active",  1);

    TabsMapBD("0",false);

    document.getElementById("BOTON_ADD").style.display = "none";
    $.ajax({
        type: "POST",
        data: "id_cte_pto=" +id,//Anadimos parametro PRSINT para mostrar items internos
        scriptCharset: "utf-8" ,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType:"xml",
        url: "it_cte_pto.jsp?ID=2",
        success: function(datos){
            var lstFolios = datos.getElementsByTagName("folios")[0];
            var objFolio = lstFolios.getElementsByTagName("folio")[0];
            var lstItems = objFolio.getElementsByTagName("proyectos");
            var lstItemsSuc = objFolio.getElementsByTagName("sucursales");
            var lstItemsCon = objFolio.getElementsByTagName("contactos");
            var lstItemsSeg = objFolio.getElementsByTagName("seguimientos");

            document.getElementById("CT_RAZONSOCIAL").value=objFolio.getAttribute('CT_RAZONSOCIAL');
            document.getElementById("CT_RFC").value=objFolio.getAttribute('CT_RFC');
            document.getElementById("SC_ID").value=objFolio.getAttribute('SC_ID');
            document.getElementById("CT_CALLE").value=objFolio.getAttribute('CT_CALLE');
            document.getElementById("CT_NUMERO").value=objFolio.getAttribute('CT_NUMERO');
            document.getElementById("CT_NUMINT").value=objFolio.getAttribute('CT_NUMINT');
            document.getElementById("CT_COLONIA").value=objFolio.getAttribute('CT_COLONIA');
            document.getElementById("CT_MUNICIPIO").value=objFolio.getAttribute('CT_MUNICIPIO');
            document.getElementById("CT_ESTADO").value=objFolio.getAttribute('CT_ESTADO');
            document.getElementById("CT_CP").value=objFolio.getAttribute('CT_CP');
            document.getElementById("CT_TELEFONO1").value=objFolio.getAttribute('CT_TELEFONO1');
            document.getElementById("CT_TELEFONO2").value=objFolio.getAttribute('CT_TELEFONO2');
            document.getElementById("CT_CONTACTO1").value=objFolio.getAttribute('CT_CONTACTO1');
            document.getElementById("CT_CONTACTO2").value=objFolio.getAttribute('CT_CONTACTO2');
            document.getElementById("CT_EMAIL1").value=objFolio.getAttribute('CT_EMAIL1');
            document.getElementById("CT_EMAIL2").value=objFolio.getAttribute('CT_EMAIL2');
            document.getElementById("CT_NOTAS").value=objFolio.getAttribute('CT_NOTAS');
            document.getElementById("CT_CATEGORIA2").value=objFolio.getAttribute('CT_CATEGORIA2');
            document.getElementById("CT_CATEGORIA1").value=objFolio.getAttribute('CT_CATEGORIA1');
            document.getElementById("CT_DIASCREDITO").value=objFolio.getAttribute('CT_DIASCREDITO');
            document.getElementById("CT_MONTOCRED").value=objFolio.getAttribute('CT_MONTOCRED');
            document.getElementById("CT_ALTA").value=objFolio.getAttribute('CT_ALTA');
            document.getElementById("CT_MODIFICADO").value=objFolio.getAttribute('CT_MODIFICADO');
            document.getElementById("CT_CATEGORIA3").value=objFolio.getAttribute('CT_CATEGORIA3');
            document.getElementById("CT_CATEGORIA4").value=objFolio.getAttribute('CT_CATEGORIA4');
            document.getElementById("CT_CATEGORIA5").value=objFolio.getAttribute('CT_CATEGORIA5');
            document.getElementById("CT_ID").value=objFolio.getAttribute('CT_ID');
            document.getElementById("CT_NOMBRE").style.display = '';
            document.getElementById("CT_NOMBRE").value = objFolio.getAttribute('CT_RAZONSOCIAL');
            ActivaNuevoEdicion(false);
            strOptEdit = "_ed";
            document.getElementById("btn1").style.display = 'none';
            $("#dialogWait").dialog("close");
            //Llenamos el grid DE PROYECTOS
            var grid2 = jQuery("#GRIDPROY");
            grid2.clearGridData();
            for(i=0;i<lstItems.length;i++){
                var obj = lstItems[i];
                //Recuperamos el detalle
                var datarow = {
                    PRY_ID:obj.getAttribute('PRY_ID'),
                    PRY_NOMBRE:obj.getAttribute('PRY_NOMBRE'),
                    CT_ID:obj.getAttribute('CT_ID')
                };
                //Anexamos el registro al GRID
                itemIdSv++;
                jQuery("#GRIDPROY").addRowData(itemIdSv,datarow,"last");
            }
            //Llenamos el grid DE SUSCURSALES
            var grid3 = jQuery("#GRIDSUC");
            grid3.clearGridData();
            for(i=0;i<lstItemsSuc.length;i++){
                var obj1 = lstItemsSuc[i];
                //Recuperamos el detalle
                var datarow1 = {
                    PRY_ID:obj1.getAttribute('PRY_ID'),
                    ID:obj1.getAttribute('SUC_ID'),
                    SUC_NOMBRE:obj1.getAttribute('SUC_NOMBRE'),
                    SUC_MUNICIPIO:obj1.getAttribute('SUC_MUNICIPIO'),
                    SUC_ESTADO:obj1.getAttribute('SUC_ESTADO'),
                    SUC_TELEFONO:obj1.getAttribute('SUC_TELEFONO')
                };
                //Anexamos el registro al GRID
                itemIdSv++;
                jQuery("#GRIDSUC").addRowData(itemIdSv,datarow1,"last");
            }
            //Llenamos el grid de contactos
            var grid4 = jQuery("#GRIDCONT");
            grid4.clearGridData();
            for(i=0;i<lstItemsCon.length;i++){
                var obj2 = lstItemsCon[i];
                //Recuperamos el detalle
                var datarow2 = {
                    CONT_ID:obj2.getAttribute('CONT_ID'),
                    PRY_ID:obj2.getAttribute('PRY_ID'),
                    SUCURSAL:obj2.getAttribute('SUC_ID'),
                    CONT_NOMBRE:obj2.getAttribute('CONT_NOMBRE'),
                    CONT_A_PATERNO:obj2.getAttribute('CONT_A_PATERNO'),
                    CONT_A_MATERNO:obj2.getAttribute('CONT_A_MATERNO'),
                    CONT_FUNCION:obj2.getAttribute('CONT_FUNCION'),
                    CONT_PUESTO:obj2.getAttribute('CONT_PUESTO'),
                    CONT_EMAIL:obj2.getAttribute('CONT_EMAIL'),
                    CONT_TELEFONO:obj2.getAttribute('CONT_TELEFONO'),
                    CONT_EXTENSIONES:obj2.getAttribute('CONT_EXTENSIONES')
                };
                //Anexamos el registro al GRID
                itemIdSv++;
                jQuery("#GRIDCONT").addRowData(itemIdSv,datarow2,"last");
            }
            
            //Llenamos el grid de contactos
            var grid5 = jQuery("#GRIDSEGUI");
            grid5.clearGridData();
            for(i=0;i<lstItemsSeg.length;i++){
                var obj3 = lstItemsSeg[i];
                //Recuperamos el detalle
                var datarow3 = {
                    SEG_ID:obj3.getAttribute('SEG_ID'),
                    SEG_CONTACTO:obj3.getAttribute('SEG_CONTACTO'),
                    SEG_PROXIMO:obj3.getAttribute('SEG_PROXIMO'),
                    SEG_NOTAS:obj3.getAttribute('SEG_NOTAS'),
                    SEG_CREADA:obj3.getAttribute('SEG_CREADA')
                };
                //Anexamos el registro al GRID
                itemIdSv++;
                jQuery("#GRIDSEGUI").addRowData(itemIdSv,datarow3,"last");
            }

            
//            //CARGAMOS LOS DATOS EN LOS SELECT CORRESPOPNDIENTES
//            var objSuc = document.getElementById("SC_ID");
//            select_clear(objSuc);
//            for(i=0;i<lstItemsSuc.length;i++){
//                var objS = lstItemsSuc[i];
//                select_add(objSuc,objS.getAttribute('SUC_NOMBRE'),objS.getAttribute('SUC_ID'));
//            }

            var objPry = document.getElementById("PRY_ID");
            select_clear(objPry);
            for(j=0;j<lstItems.length;j++){
                var objP = lstItems[j];
                select_add(objPry,objP.getAttribute('PRY_NOMBRE'),objP.getAttribute('PRY_ID'));
            }

            var objPry2 = document.getElementById("PRY_ID2");
            select_clear(objPry2);
            for(m=0;m<lstItems.length;m++){
                var objP1 = lstItems[m];
                select_add(objPry2,objP1.getAttribute('PRY_NOMBRE'),objP1.getAttribute('PRY_ID'));
            }

            var objSuc1 = document.getElementById("SUC_IDP");
            select_clear(objSuc1);
            for(k=0;k<lstItemsSuc.length;k++){
                var objSu = lstItemsSuc[k];
                select_add(objSuc1,objSu.getAttribute('SUC_NOMBRE'),objSu.getAttribute('SUC_ID'));
            }

            var objCon = document.getElementById("SEG_CONTACTO");
            select_clear(objCon);
            for(l=0;l<lstItemsCon.length;l++){
                var objCo = lstItemsCon[l];
                select_add(objCon,objCo.getAttribute('CONT_NOMBRE'),objCo.getAttribute('CONT_ID'));
            }

        },
        error: function(objeto, quepaso, otroobj){
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

/*
 * Sirve para hacer la modificacion de los datos generales del cliente prospecto
 */
function mod_CtePto(){
    //Empezamos a generar el post recuperando los datos para dar de alta
    var strPost = "&CT_RAZONSOCIAL=" + encode(document.getElementById("CT_RAZONSOCIAL").value);
    strPost += "&CT_RFC=" + encode(document.getElementById("CT_RFC").value);
    strPost += "&SC_ID=" +  document.getElementById("SC_ID").value;
    strPost += "&CT_CALLE=" +  encode(document.getElementById("CT_CALLE").value);
    strPost += "&CT_NUMERO=" +  encode(document.getElementById("CT_NUMERO").value);
    strPost += "&CT_NUMINT=" +  encode(document.getElementById("CT_NUMINT").value);
    strPost += "&CT_COLONIA=" +  encode(document.getElementById("CT_COLONIA").value);
    strPost += "&CT_MUNICIPIO=" +  encode(document.getElementById("CT_MUNICIPIO").value);
    strPost += "&CT_ESTADO=" +  encode(document.getElementById("CT_ESTADO").value);
    strPost += "&CT_CP=" +  encode(document.getElementById("CT_CP").value);
    strPost += "&CT_TELEFONO1=" +  encode(document.getElementById("CT_TELEFONO1").value);
    strPost += "&CT_TELEFONO2=" +  encode(document.getElementById("CT_TELEFONO2").value);
    strPost += "&CT_CONTACTO1=" +  encode(document.getElementById("CT_CONTACTO1").value);
    strPost += "&CT_CONTACTO2=" +  encode(document.getElementById("CT_CONTACTO2").value);
    strPost += "&CT_EMAIL1=" +  encode(document.getElementById("CT_EMAIL1").value);
    strPost += "&CT_EMAIL2=" +  encode(document.getElementById("CT_EMAIL2").value);
    strPost += "&CT_NOTAS=" +  encode(document.getElementById("CT_NOTAS").value);
    strPost += "&CT_CATEGORIA2=" +  encode(document.getElementById("CT_CATEGORIA2").value);
    strPost += "&CT_CATEGORIA1=" +  encode(document.getElementById("CT_CATEGORIA1").value);
    strPost += "&CT_DIASCREDITO=" +  encode(document.getElementById("CT_DIASCREDITO").value);
    strPost += "&CT_MONTOCRED=" + document.getElementById("CT_MONTOCRED").value;
    strPost += "&CT_ALTA=" +  document.getElementById("CT_ALTA").value;
    strPost += "&CT_MODIFICADO=" +  document.getElementById("CT_MODIFICADO").value;
    strPost += "&CT_CATEGORIA3=" +  encode(document.getElementById("CT_CATEGORIA3").value);
    strPost += "&CT_CATEGORIA4=" +  encode(document.getElementById("CT_CATEGORIA4").value);
    strPost += "&CT_CATEGORIA5=" +  encode(document.getElementById("CT_CATEGORIA5").value);
    strPost += "&CT_ID=" +  document.getElementById("CT_ID").value;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8" ,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType:"html",
        url: "it_cte_pto.jsp?ID=3",
        success: function(datos){
            if(datos.substring(0,2)=="OK"){

                TabsMapBD("0",true);
                $("#tabs"+strNomTabBD).tabs( "option","active",  0);
                TabsMapBD("1",false);
                TabsMapBD("2",false);
                TabsMapBD("3",false);
                TabsMapBD("4",false);
                TabsMapBD("5",false);
                cleanDat();
                var grid2 = jQuery("#GRIDDATOS");
                grid2.trigger("reloadGrid");
                document.getElementById("BOTON_ADD").style.display = "";
            }
            else{
                alert(datos);
            }
            $("#dialogWait").dialog("close");
        },
        error: function(objeto, quepaso, otroobj){
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

/*
 * Cancela la operacion y nos regresa al grid de consulta
 */     
function cancelOper(){
    strOptEdit = "";
    //limpiamos todos los campos
    cleanDat();

    document.getElementById("BOTONGUARDA").style.display = "";
    document.getElementById("BOTON_ADD").style.display = "";
    document.getElementById("CT_NOMBRE").style.display = 'none';
    document.getElementById("CT_NOMBRE").value = "";
    TabsMapBD("0",true);
    $("#tabs"+strNomTabBD).tabs( "option","active",  0);
    TabsMapBD("1",false);
    TabsMapBD("2",false);
    TabsMapBD("3",false);
    TabsMapBD("4",false);
    TabsMapBD("5",false);
    
}

/*
 *limpia los campos
 */
function cleanDat(){
    document.getElementById("CT_ID").value="";
    document.getElementById("CT_RAZONSOCIAL").value="";
    document.getElementById("CT_RFC").value="";
    document.getElementById("SC_ID").value="";
    document.getElementById("CT_CALLE").value="";
    document.getElementById("CT_NUMERO").value="";
    document.getElementById("CT_NUMINT").value="";
    document.getElementById("CT_COLONIA").value="";
    document.getElementById("CT_MUNICIPIO").value="";
    document.getElementById("CT_ESTADO").value="";
    document.getElementById("CT_CP").value="";
    document.getElementById("CT_TELEFONO1").value="";
    document.getElementById("CT_TELEFONO2").value="";
    document.getElementById("CT_CONTACTO1").value="";
    document.getElementById("CT_CONTACTO2").value="";
    document.getElementById("CT_EMAIL1").value="";
    document.getElementById("CT_EMAIL2").value="";
    document.getElementById("CT_NOTAS").value="";
    document.getElementById("CT_CATEGORIA2").value="";
    document.getElementById("CT_CATEGORIA1").value="";
    document.getElementById("CT_DIASCREDITO").value=0;
    document.getElementById("CT_MONTOCRED").value=0;
    document.getElementById("CT_ALTA").value="";
    document.getElementById("CT_MODIFICADO").value="";
    document.getElementById("CT_CATEGORIA3").value="";
    document.getElementById("CT_CATEGORIA4").value="";
    document.getElementById("CT_CATEGORIA5").value="";

}
/**
 *Funcion para poder editar al cliente prospecto con boble click
 **/
function _dbl_clickPry(){

    $("#dialogWait").dialog("open");
    //Peticion por ajax para mostrar info
    var grid = jQuery("#GRIDPROY ");
    var id = grid.getGridParam("selrow");
    var lstRow = grid.getRowData(id);
    var IdRen=lstRow.PRY_ID;
    $.ajax({
        type: "POST",
        data: "id_pry=" +IdRen,//Anadimos parametro id_pry para consultar los datos
        scriptCharset: "utf-8" ,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType:"xml",
        url: "it_cte_pto.jsp?ID=6",
        success: function(datos){
            var lstFolios = datos.getElementsByTagName("proyectos")[0];
            var objFolio = lstFolios.getElementsByTagName("proyecto")[0];
            document.getElementById("PRY_NOMBRE").value=objFolio.getAttribute('PRY_NOMBRE');
            document.getElementById("BOTON_SAVE").style.display = '';
            document.getElementById("BOTON_NEW_PRY").style.display = 'none';
            document.getElementById("BOTTONCALCEL_PRY").style.display = '';
            document.getElementById("BOTON_DELETE").style.display = 'none';
            document.getElementById("PRY_ID").value=objFolio.getAttribute('PRY_ID');
            document.getElementById("CT_ID").value=objFolio.getAttribute('CT_ID');
            strOptEdit = "_ed";
            $("#dialogWait").dialog("close");
        },
        error: function(objeto, quepaso, otroobj){
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}

function valPry(){
    var strPry=document.getElementById("PRY_NOMBRE").value;
    if(strPry==""){
        alert("Para agregar un nuevo proyecto debe campurar el nombre.");
        return 0;
    }
    return 1;
}
/**
 * Funcion para dar de lata un proyecto
 */
function upProyecto(){
    //Empezamos a generar el post recuperando los datos para dar de alta
    var strPost = "&PRY_NOMBRE=" + encode(document.getElementById("PRY_NOMBRE").value);
    strPost += "&CT_ID=" +  document.getElementById("CT_ID").value;    
    if(strOptEdit == "_new"){
        if(valPry()!=0){
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "it_cte_pto.jsp?ID=4",
                success: function(datos){
                    if(datos.substring(0,2)=="OK"){
                        alert("Proyecto"+" "+document.getElementById("PRY_NOMBRE").value+" "+"guardado correctamente!!");
                        document.getElementById("PRY_NOMBRE").value="";
                        var grid2 = jQuery("#GRIDPROY");
                        grid2.trigger("reloadGrid");
                        document.getElementById("BOTON_NEW_PRY").style.display = '';
                        document.getElementById("BOTON_SAVE").style.display = 'none';
                        document.getElementById("BOTON_DELETE").style.display = '';
                        document.getElementById("BOTTONCALCEL_PRY").style.display = 'none';
                        strOptEdit = "";
                    }
                    else{
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });
        }
    }else{
        var strPostEdit = "&PRY_NOMBRE=" + document.getElementById("PRY_NOMBRE").value;
        strPostEdit +="&PRY_ID=" +  document.getElementById("PRY_ID").value;
        strPostEdit +="&CT_ID=" + document.getElementById("CT_ID").value;
        $.ajax({
            type: "POST",
            data: strPostEdit,
            scriptCharset: "utf-8" ,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType:"html",
            url: "it_cte_pto.jsp?ID=7",
            success: function(datos){
                //si actualizo correctamente
                if(datos.substring(0,2)=="OK"){
                    alert("Modificación Exitosa!!");
                    document.getElementById("BOTON_NEW_PRY").style.display = '';
                    document.getElementById("BOTON_SAVE").style.display = 'none';
                    document.getElementById("PRY_NOMBRE").value="";
                    document.getElementById("PRY_ID").value="";

                    var grid2 = jQuery("#GRIDPROY");
                    grid2.trigger("reloadGrid");
                }
                else{
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            },
            error: function(objeto, quepaso, otroobj){
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });


    }

   
}

/**Borra el item seleccionado*/
function DropPry(){
    var grid = jQuery("#GRIDPROY ");
    if(grid.getGridParam("selrow") != null){
        if(confirm('¿Confirma que desea borrar este proyecto!!')){
            var id = grid.getGridParam("selrow");
            var lstRow = grid.getRowData(id);
            var IdRen=lstRow.PRY_ID;
            grid.delRowData(grid.getGridParam("selrow"));
            $.ajax({
                type: "POST",
                data: "id_cte_pto=" + IdRen,//Anadimos parametro PRSINT para mostrar items internos
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "it_cte_pto.jsp?ID=5",
                success: function(datos){
                    if(datos.substring(0,2)=="OK"){
                        alert("Proyecto dado de baja Correctamente!!");
                        var grid2 = jQuery("#GRIDPROY");
                        grid2.trigger("reloadGrid");
                    }
                    else{
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });

        }
    }
}

/**Oculata el boton de nuevo y nos muestra el de guardars**/
function newProject(){
    strOptEdit = "_new";
    document.getElementById("BOTON_SAVE").style.display = '';
    document.getElementById("BOTON_NEW_PRY").style.display = 'none';
    document.getElementById("BOTTONCALCEL_PRY").style.display = '';
    document.getElementById("BOTON_DELETE").style.display = 'none';

}

/**Oculata el boton de nuevo y nos muestra el de guardars**/
function cancelProject(){
    strOptEdit = "";
    document.getElementById("PRY_NOMBRE").value="";
    document.getElementById("PRY_ID").value="";
    document.getElementById("BOTON_SAVE").style.display = 'none';
    document.getElementById("BOTON_NEW_PRY").style.display = '';
    document.getElementById("BOTTONCALCEL_PRY").style.display = 'none';
    document.getElementById("BOTON_DELETE").style.display = '';
    intIdPry=0;//ponemos en 0 el alamcenador de id de proyectos

}

/**Codifica el valor antes de enviarlo por POST*/
function encode(strValor){
    return encodeURIComponent(strValor);
}
/**Llena combo**/
function LlenarCombo(c,a,b){
    for(i=0;i<a.length;i++){
        select_add(c,a[i],b[i])
    }
}
/**limpia combo**/
function select_clear(a){
    var b=a.length;
    for(i=0;i<b;i++){
        a.remove(0)
    }
}

function select_add(e,a,c){
    var d=document.createElement("option");
    d.text=a;
    d.value=c;
    try{
        e.add(d,null)
    }catch(b){
        e.add(d)
    }
}


//funcion para ablitar los campos para una nueva sucursal
function newSuc(){
    //mostramos
    strOptSc = "_new";
    cleanDataSc();
    document.getElementById("BOTON_SAVE_SC").style.display = '';
    document.getElementById("CALCEL_SC").style.display = '';
    //ocultamos
    document.getElementById("BOTON_DELETE_SC").style.display = 'none';    
    document.getElementById("BOTON_NEW_SC").style.display = 'none';
}

/**cancela la operacion de sucursales**/
function cancleSc(){
    strOptSc = "";
    cleanDataSc();
    //ocultamos
    document.getElementById("BOTON_SAVE_SC").style.display = 'none';
    document.getElementById("CALCEL_SC").style.display = 'none';
    //mostramos
    document.getElementById("BOTON_DELETE_SC").style.display = '';
    document.getElementById("BOTON_NEW_SC").style.display = '';

}

/**limpia los campos de suscuirsales**/
function cleanDataSc(){
    document.getElementById("SUC_NOMBRE").value="";
    document.getElementById("SUC_CALLE").value="";
    document.getElementById("SUC_NO_INT").value="";
    document.getElementById("SUC_NO_EXT").value="";
    document.getElementById("SUC_COLONIA").value="";
    document.getElementById("SUC_MUNICIPIO").value="";
    document.getElementById("SUC_ESTADO").value="";
    document.getElementById("SUC_CP").value="";
    document.getElementById("SUC_TELEFONO").value="";
    document.getElementById("SUC_FAX").value="";
    document.getElementById("SUC_OBSERVACIONES").value="";
    document.getElementById("PRY_ID2").value="";

}


/**Borra el item seleccionado*/
function delSc(){
    var grid = jQuery("#GRIDSUC");
    if(grid.getGridParam("selrow") != null){
        if(confirm('¿Confirma que desea borrar esta sucursal!!')){
            var id = grid.getGridParam("selrow");
            var lstRow = grid.getRowData(id);
            var IdRen=lstRow.ID;
            grid.delRowData(grid.getGridParam("selrow"));
            $.ajax({
                type: "POST",
                data: "id=" + IdRen,//Anadimos parametro PRSINT para mostrar items internos
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "it_cte_pto.jsp?ID=8",
                success: function(datos){
                    if(datos.substring(0,2)=="OK"){
                        alert("Sucursal dada de baja Correctamente!!");
                        var grid2 = jQuery("#GRIDSUC");
                        grid2.trigger("reloadGrid");
                        document.getElementById("BOTON_SAVE_SC").style.display = 'none';
                        document.getElementById("CALCEL_SC").style.display = 'none';
                        //mostramos
                        document.getElementById("BOTON_DELETE_SC").style.display = '';    
                        document.getElementById("BOTON_NEW_SC").style.display = '';
                        //reseteamos la variable
                        strOptSc = "";
                    }
                    else{
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });

        }
    }
}
//funcion para validar la sucursal
function valSc(){
    //recuperamos valores
    var strName=document.getElementById("SUC_NOMBRE");
    var strCalle=document.getElementById("SUC_CALLE");
    var strNoExt=document.getElementById("SUC_NO_EXT");
    var strCol=document.getElementById("SUC_COLONIA");
    var strEst=document.getElementById("SUC_ESTADO");
    var strCp=document.getElementById("SUC_CP");
    if(strName.value==""){
        alert("Favor de capturar un nombre.");
        strName.focus();
        return 0;
    }
    if(strCalle.value==""){
        alert("Favor de capturar una calle.");
        strCalle.focus();
        return 0;
    }
    if(strNoExt.value==""){
        alert("Favor de capturar un No. Exterior.");
        strNoExt.focus();
        return 0;
    }
    if(strCol.value==""){
        alert("Favor de capturar una colonia.");
        strCol.focus();
        return 0;
    }

    if(strEst.value==""){
        alert("Favor de capturar un estado.");
        strEst.focus();
        return 0;
    }
    if(strCp.value==""){
        alert("Favor de capturar un Codigo Postal.");
        strCp.focus();
        return 0;
    }
    return 1;
}

/**
 * Funcion para dar de alta una sucursal
 */
function upSc(){
    //Empezamos a generar el post recuperando los datos para dar de alta
    var strPost = "&SUC_NOMBRE=" + encode(document.getElementById("SUC_NOMBRE").value);
    strPost += "&PRY_ID=" + document.getElementById("PRY_ID2").value;
    strPost += "&SUC_CALLE=" +  encode(document.getElementById("SUC_CALLE").value);
    strPost += "&SUC_NO_INT=" +  document.getElementById("SUC_NO_INT").value;
    strPost += "&SUC_NO_EXT=" +  document.getElementById("SUC_NO_EXT").value;
    strPost += "&SUC_COLONIA=" + encode( document.getElementById("SUC_COLONIA").value);
    strPost += "&SUC_MUNICIPIO=" + encode( document.getElementById("SUC_MUNICIPIO").value);
    strPost += "&SUC_ESTADO=" + encode( document.getElementById("SUC_ESTADO").value);
    strPost += "&SUC_CP=" +  document.getElementById("SUC_CP").value;
    strPost += "&SUC_TELEFONO=" +  document.getElementById("SUC_TELEFONO").value;
    strPost += "&SUC_FAX=" +  document.getElementById("SUC_FAX").value;
    strPost += "&SUC_OBSERVACIONES=" + encode( document.getElementById("SUC_OBSERVACIONES").value);
    strPost += "&CT_ID=" +  document.getElementById("CT_ID").value;
    if(strOptSc== "_new"){
        if(valSc()!=0){
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "it_cte_pto.jsp?ID=9",
                success: function(datos){
                    if(datos.substring(0,2)=="OK"){
                        alert("Sucursal"+" "+document.getElementById("SUC_NOMBRE").value+" "+"guardado correctamente!!");
                        //LIMPIAMOS LOS CAMPOS
                        cleanDataSc();
                        document.getElementById("BOTON_SAVE_SC").style.display = 'none';
                        document.getElementById("CALCEL_SC").style.display = 'none';
                        //mostramos
                        document.getElementById("BOTON_DELETE_SC").style.display = '';
                        document.getElementById("BOTON_NEW_SC").style.display = '';
                        //RESETEAMOS VALORES
                        document.getElementById("CT_ID_SUC").value="";
                        document.getElementById("SUC_ID").value="";
                        document.getElementById("PRY_ID").value="";
                        var grid2 = jQuery("#GRIDSUC");
                        grid2.trigger("reloadGrid");

                        strOptSc = "";
                    }
                    else{
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });
        }
    }else{
        //para actualizar una sucursal falta por modificar funcion
        var strPostEdit = "&SUC_NOMBRE=" + encode(document.getElementById("SUC_NOMBRE").value);
        strPostEdit += "&SUC_CALLE=" + encode(document.getElementById("SUC_CALLE").value);
        strPostEdit += "&SUC_NO_INT=" + document.getElementById("SUC_NO_INT").value;
        strPostEdit += "&SUC_NO_EXT=" + document.getElementById("SUC_NO_EXT").value;
        strPostEdit += "&SUC_COLONIA=" + encode(document.getElementById("SUC_COLONIA").value);
        strPostEdit += "&SUC_MUNICIPIO=" + encode(document.getElementById("SUC_MUNICIPIO").value);
        strPostEdit += "&SUC_ESTADO=" + encode(document.getElementById("SUC_ESTADO").value);
        strPostEdit += "&SUC_CP=" + document.getElementById("SUC_CP").value;
        strPostEdit += "&SUC_TELEFONO=" + document.getElementById("SUC_TELEFONO").value;
        strPostEdit += "&SUC_FAX=" + document.getElementById("SUC_FAX").value;
        strPostEdit += "&SUC_OBSERVACIONES=" + encode(document.getElementById("SUC_OBSERVACIONES").value);
        strPostEdit += "&CT_ID_SUC=" + document.getElementById("CT_ID_SUC").value;
        strPostEdit += "&SUC_ID=" + document.getElementById("SUC_ID").value;
        strPostEdit += "&PRY_ID=" + document.getElementById("PRY_ID2").value;
        $.ajax({
            type: "POST",
            data: strPostEdit,
            scriptCharset: "utf-8" ,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType:"html",
            url: "it_cte_pto.jsp?ID=11",
            success: function(datos){
                //si actualizo correctamente
                if(datos.substring(0,2)=="OK"){
                    alert("Modificación Exitosa!!");
                    cleanDataSc();
                    //ocultamos
                    document.getElementById("BOTON_SAVE_SC").style.display = 'none';
                    document.getElementById("CALCEL_SC").style.display = 'none';
                    //mostramos
                    document.getElementById("BOTON_DELETE_SC").style.display = '';
                    document.getElementById("BOTON_NEW_SC").style.display = '';
                    //RESETEAMOS VALORES
                    document.getElementById("CT_ID_SUC").value="";
                    document.getElementById("SUC_ID").value="";
                    document.getElementById("PRY_ID").value="";
                    strOptSc = "";
                    var grid2 = jQuery("#GRIDSUC");
                    grid2.trigger("reloadGrid");
                }
                else{
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            },
            error: function(objeto, quepaso, otroobj){
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });


    }


}


/**
 *Funcion para poder editar una sucursal (obtener datos)
 **/
function _dbl_clickSc(){

    $("#dialogWait").dialog("open");
    //Peticion por ajax para mostrar info
    var grid = jQuery("#GRIDSUC");
    var id = grid.getGridParam("selrow");
    var lstRow = grid.getRowData(id);
    var IdRen=lstRow.ID;
    $.ajax({
        type: "POST",
        data: "id=" +IdRen,//Anadimos parametro id_pry para consultar los datos
        scriptCharset: "utf-8" ,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType:"xml",
        url: "it_cte_pto.jsp?ID=10",
        success: function(datos){
            var lstFolios = datos.getElementsByTagName("sucursales")[0];
            var objFolio = lstFolios.getElementsByTagName("sucursal")[0];
            document.getElementById("SUC_NOMBRE").value=objFolio.getAttribute('SUC_NOMBRE');
            document.getElementById("SUC_CALLE").value=objFolio.getAttribute('SUC_CALLE');
            document.getElementById("SUC_NO_INT").value=objFolio.getAttribute('SUC_NO_INT');
            document.getElementById("SUC_NO_EXT").value=objFolio.getAttribute('SUC_NO_EXT');
            document.getElementById("SUC_COLONIA").value=objFolio.getAttribute('SUC_COLONIA');
            document.getElementById("SUC_MUNICIPIO").value=objFolio.getAttribute('SUC_MUNICIPIO');
            document.getElementById("SUC_ESTADO").value=objFolio.getAttribute('SUC_ESTADO');
            document.getElementById("SUC_CP").value=objFolio.getAttribute('SUC_CP');
            document.getElementById("SUC_TELEFONO").value=objFolio.getAttribute('SUC_TELEFONO');
            document.getElementById("SUC_FAX").value=objFolio.getAttribute('SUC_FAX');
            document.getElementById("SUC_OBSERVACIONES").value=objFolio.getAttribute('SUC_OBSERVACIONES');
            document.getElementById("CT_ID_SUC").value=objFolio.getAttribute('CT_ID');
            document.getElementById("SUC_ID").value=objFolio.getAttribute('SUC_ID');
            document.getElementById("PRY_ID2").value=objFolio.getAttribute('PRY_ID');
            //ocultamos
            document.getElementById("BOTON_SAVE_SC").style.display = '';
            document.getElementById("CALCEL_SC").style.display = '';
            //mostramos
            document.getElementById("BOTON_DELETE_SC").style.display = 'none';
            document.getElementById("BOTON_NEW_SC").style.display = 'none';
            strOptSc = "_ed";
            $("#dialogWait").dialog("close");
        },
        error: function(objeto, quepaso, otroobj){
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}


/**para dar de alta un contacto**/
function newCont(){
    cleanDataCont();
    strOptCon="_new";
    document.getElementById("BOTON_SAVE_CON").style.display='';
    document.getElementById("CALCEL_CON").style.display='';
    document.getElementById("BOTON_NEW_CON").style.display='none';
    document.getElementById("BOTON_DELETE_CON").style.display='none';
}
/**cancela la operacion del contacto**/
function cancelCont(){
    cleanDataCont();
    strOptCon="";
    document.getElementById("BOTON_SAVE_CON").style.display='none';
    document.getElementById("CALCEL_CON").style.display='none';
    document.getElementById("BOTON_NEW_CON").style.display='';
    document.getElementById("BOTON_DELETE_CON").style.display='';
}

/**limpia los campos de la pantalla de ocntactos**/
function cleanDataCont(){

    document.getElementById("CONT_NOMBRE").value="";
    document.getElementById("CONT_A_PATERNO").value="";
    document.getElementById("CONT_A_MATERNO").value="";
    document.getElementById("CONT_FUNCION").value="";
    document.getElementById("CONT_PUESTO").value="";
    document.getElementById("CONT_TITULO").value="";
    document.getElementById("CONT_EMAIL").value="";
    document.getElementById("CONT_EMAIL2").value="";
    document.getElementById("CONT_TELEFONO").value="";
    document.getElementById("CONT_EXTENSIONES").value="";
    document.getElementById("CONT_MOVIL").value="";
    document.getElementById("CONT_DIANACE").value="";
    document.getElementById("CONT_MESNACE").value="";
    document.getElementById("CONT_ANIONACE").value="";
    document.getElementById("PRY_ID").value="";
    document.getElementById("SUC_IDP").value="";
    document.getElementById("CONT_OBSERVACIONES").value="";


}


/**funcion para eliminar un contacto**/
function delCont(){
    var grid = jQuery("#GRIDCONT");
    if(grid.getGridParam("selrow") != null){
        if(confirm('¿Confirma que desea borrar este contacto!!')){
            var id = grid.getGridParam("selrow");
            var lstRow = grid.getRowData(id);
            var IdRen=lstRow.CONT_ID;
            grid.delRowData(grid.getGridParam("selrow"));
            $.ajax({
                type: "POST",
                data: "id=" + IdRen,//Anadimos parametro PRSINT para mostrar items internos
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "it_cte_pto.jsp?ID=12",
                success: function(datos){
                    if(datos.substring(0,2)=="OK"){
                        alert("Contacto dado de baja Correctamente!!");
                        var grid2 = jQuery("#GRIDCONT");
                        grid2.trigger("reloadGrid");

                        document.detElementById("BOTON_SAVE_CON").style.display='';
                        document.detElementById("CALCEL_CON").style.display='';
                        document.detElementById("BOTON_NEW_CON").style.display='none';
                        document.detElementById("BOTON_DELETE_CON").style.display='none';
                        //reseteamos la variable
                        strOptCon="";
                    }
                    else{
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });

        }
    }

}
//VALIDA EL LLENADO DE CAMPOS DEW CONTACTOS
function valCon(){
    //RECUPERAMOS VALORES
    var strName = document.getElementById("CONT_NOMBRE");
    var strApPat = document.getElementById("CONT_A_PATERNO");
    var strApMat = document.getElementById("CONT_A_MATERNO");
    var strTit = document.getElementById("CONT_TITULO");
    var strEm = document.getElementById("CONT_EMAIL");
    var strTel = document.getElementById("CONT_TELEFONO");
    var strExt = document.getElementById("CONT_EXTENSIONES");
    var intPry = document.getElementById("PRY_ID");
    var intSuc = document.getElementById("SUC_IDP");
    //VALIDAMOS SI LOS LLENARON
    if(strName.value==""){
        alert("FAVOR DE CAPTURAR EL NOMBRE.");
        strName.focus();
        return 0;
    }
    if(strApPat.value==""){
        alert("FAVOR DE CAPTURAR EL APELLIDO PATERNO");
        strApPat.focus();
        return 0;
    }

    if(strApMat.value==""){
        alert("FAVOR DE CAPTURAR EL APELLIDO MATERNO");
        strApMat.focus()
        return 0;
    }

    if(strTit.value==""){
        alert("FAVOR DE CAPTURAR UN TITULO");
        strTit.focus()
        return 0;
    }

    if(strEm.value==""){
        alert("FAVOR DE PROPORCIONAR UN E-MAIL");
        strEm.focus()
        return 0;
    }

    if(strTel.value==""){
        alert("FAVOR DE PROPORCIONAR UN NUMERO TELEFONICO");
        strTel.focus()
        return 0;
    }

    if(strExt.value==""){
        alert("FAVOR DE CAPTURAR UNA EXTENCION");
        strExt.focus()
        return 0;
    }

    if(intPry.value==""){
        alert("ELIJE UN PROYECTO");
        intPry.focus()
        return 0;
    }

    if(intSuc.value==""){
        alert("ELIJE UNA SUCURSAL");
        intSuc.focus()
        return 0;
    }

    return 1;
    
}

/**
 * Funcion para dar de alta un contacto
 */
function upCont(){
    //Empezamos a generar el post recuperando los datos para dar de alta
    var strPost = "&CONT_NOMBRE=" + encode(document.getElementById("CONT_NOMBRE").value);
    strPost += "&CONT_A_PATERNO=" + document.getElementById("CONT_A_PATERNO").value;
    strPost += "&CONT_A_MATERNO=" +  encode(document.getElementById("CONT_A_MATERNO").value);
    strPost += "&CONT_FUNCION=" +  encode(document.getElementById("CONT_FUNCION").value);
    strPost += "&CONT_PUESTO=" +  document.getElementById("CONT_PUESTO").value;
    strPost += "&CONT_TITULO=" +  document.getElementById("CONT_TITULO").value;
    strPost += "&CONT_EMAIL=" + encode( document.getElementById("CONT_EMAIL").value);
    strPost += "&CONT_EMAIL2=" + encode(document.getElementById("CONT_EMAIL2").value);
    strPost += "&CONT_TELEFONO=" + document.getElementById("CONT_TELEFONO").value;
    strPost += "&CONT_EXTENSIONES=" +  document.getElementById("CONT_EXTENSIONES").value;
    strPost += "&CONT_MOVIL=" +  document.getElementById("CONT_MOVIL").value;
    strPost += "&CONT_DIANACE=" +  document.getElementById("CONT_DIANACE").value;
    strPost += "&CONT_MESNACE=" +  document.getElementById("CONT_MESNACE").value;
    strPost += "&CONT_ANIONACE=" + document.getElementById("CONT_ANIONACE").value;
    strPost += "&PRY_ID=" +   document.getElementById("PRY_ID").value;
    strPost += "&SUC_IDP=" +   document.getElementById("SUC_IDP").value;
    strPost += "&CONT_OBSERVACIONES=" +   encode(document.getElementById("CONT_OBSERVACIONES").value);
    strPost += "&CT_ID=" +   document.getElementById("CT_ID").value;
    
    if(strOptCon== "_new"){
        if(valCon()!=0){
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "it_cte_pto.jsp?ID=13",
                success: function(datos){
                    if(datos.substring(0,2)=="OK"){
                        alert("Sucursal"+" "+document.getElementById("CONT_NOMBRE").value+" "+"guardado correctamente!!");
                        document.getElementById("BOTON_SAVE_CON").style.display='none';
                        document.getElementById("CALCEL_CON").style.display='none';
                        document.getElementById("BOTON_NEW_CON").style.display='';
                        document.getElementById("BOTON_DELETE_CON").style.display='';
                        //LIMPIAMOS LOS CAMPOS
                        cleanDataCont();
                        var grid2 = jQuery("#GRIDCONT");
                        grid2.trigger("reloadGrid");

                        strOptCon = "";
                    }
                    else{
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });
        }
    }else{
        //Empezamos a generar el post recuperando los datos para dar de alta
        var strPostEdit = "&CONT_NOMBRE=" + encode(document.getElementById("CONT_NOMBRE").value);
        strPostEdit += "&CONT_A_PATERNO=" + document.getElementById("CONT_A_PATERNO").value;
        strPostEdit += "&CONT_A_MATERNO=" +  encode(document.getElementById("CONT_A_MATERNO").value);
        strPostEdit += "&CONT_FUNCION=" +  encode(document.getElementById("CONT_FUNCION").value);
        strPostEdit += "&CONT_PUESTO=" +  document.getElementById("CONT_PUESTO").value;
        strPostEdit += "&CONT_TITULO=" +  document.getElementById("CONT_TITULO").value;
        strPostEdit += "&CONT_EMAIL=" + encode( document.getElementById("CONT_EMAIL").value);
        strPostEdit += "&CONT_EMAIL2=" + encode(document.getElementById("CONT_EMAIL2").value);
        strPostEdit += "&CONT_TELEFONO=" + document.getElementById("CONT_TELEFONO").value;
        strPostEdit += "&CONT_EXTENSIONES=" +  document.getElementById("CONT_EXTENSIONES").value;
        strPostEdit += "&CONT_MOVIL=" +  document.getElementById("CONT_MOVIL").value;
        strPostEdit += "&CONT_DIANACE=" +  document.getElementById("CONT_DIANACE").value;
        strPostEdit += "&CONT_MESNACE=" +  document.getElementById("CONT_MESNACE").value;
        strPostEdit += "&CONT_ANIONACE=" + document.getElementById("CONT_ANIONACE").value;
        strPostEdit += "&PRY_ID=" +   document.getElementById("PRY_ID").value;
        strPostEdit += "&SUC_IDP=" +   document.getElementById("SUC_IDP").value;
        strPostEdit += "&CONT_OBSERVACIONES=" +   encode(document.getElementById("CONT_OBSERVACIONES").value);
        strPostEdit += "&CT_ID=" +   document.getElementById("CT_ID").value;
        strPostEdit += "&CONT_ID=" +   document.getElementById("CONT_ID").value;
        $.ajax({
            type: "POST",
            data: strPostEdit,
            scriptCharset: "utf-8" ,
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType:"html",
            url: "it_cte_pto.jsp?ID=15",
            success: function(datos){
                //si actualizo correctamente
                if(datos.substring(0,2)=="OK"){
                    alert("Modificación Exitosa!!");
                    cleanDataCont();
                    document.getElementById("BOTON_SAVE_CON").style.display='none';
                    document.getElementById("CALCEL_CON").style.display='none';
                    document.getElementById("BOTON_NEW_CON").style.display='';
                    document.getElementById("BOTON_DELETE_CON").style.display=''
                    strOptCon="";
                    var grid2 = jQuery("#GRIDCONT");
                    grid2.trigger("reloadGrid");
                }
                else{
                    alert(datos);
                }
                $("#dialogWait").dialog("close");
            },
            error: function(objeto, quepaso, otroobj){
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });


    }


}

/**
 *Funcion para poder editar al cliente prospecto con boble click
 **/
function _dbl_clickCont(){

    $("#dialogWait").dialog("open");
    //Peticion por ajax para mostrar info
    var grid = jQuery("#GRIDCONT");
    var id = grid.getGridParam("selrow");
    var lstRow = grid.getRowData(id);
    var IdRen=lstRow.CONT_ID;
    $.ajax({
        type: "POST",
        data: "id=" +IdRen,//Anadimos parametro id_pry para consultar los datos
        scriptCharset: "utf-8" ,
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType:"xml",
        url: "it_cte_pto.jsp?ID=14",
        success: function(datos){
            var lstFolios = datos.getElementsByTagName("contactos")[0];
            var objFolio = lstFolios.getElementsByTagName("contacto")[0];
            document.getElementById("CONT_NOMBRE").value=objFolio.getAttribute('CONT_NOMBRE');
            document.getElementById("CONT_A_PATERNO").value=objFolio.getAttribute('CONT_A_PATERNO');
            document.getElementById("CONT_A_MATERNO").value=objFolio.getAttribute('CONT_A_MATERNO');
            document.getElementById("CONT_FUNCION").value=objFolio.getAttribute('CONT_FUNCION');
            document.getElementById("CONT_PUESTO").value=objFolio.getAttribute('CONT_PUESTO');
            document.getElementById("CONT_TITULO").value=objFolio.getAttribute('CONT_TITULO');
            document.getElementById("CONT_EMAIL").value=objFolio.getAttribute('CONT_EMAIL');
            document.getElementById("CONT_EMAIL2").value=objFolio.getAttribute('CONT_EMAIL2');
            document.getElementById("CONT_TELEFONO").value=objFolio.getAttribute('CONT_TELEFONO');
            document.getElementById("CONT_EXTENSIONES").value=objFolio.getAttribute('CONT_EXTENSIONES');
            document.getElementById("CONT_MOVIL").value=objFolio.getAttribute('CONT_MOVIL');
            document.getElementById("CONT_DIANACE").value=objFolio.getAttribute('CONT_DIANACE');
            document.getElementById("CONT_MESNACE").value=objFolio.getAttribute('CONT_DIANACE');
            document.getElementById("CONT_ANIONACE").value=objFolio.getAttribute('CONT_ANIONACE');
            document.getElementById("PRY_ID").value=objFolio.getAttribute('PRY_ID');
            document.getElementById("SUC_IDP").value=objFolio.getAttribute('SUC_ID');
            document.getElementById("CONT_OBSERVACIONES").value=objFolio.getAttribute('CONT_OBSERVACIONES');          
            document.getElementById("CONT_ID").value=objFolio.getAttribute('CONT_ID');
            document.getElementById("CT_ID").value=objFolio.getAttribute('CT_ID');

            document.getElementById("BOTON_SAVE_CON").style.display='';
            document.getElementById("CALCEL_CON").style.display='';
            document.getElementById("BOTON_NEW_CON").style.display='none';
            document.getElementById("BOTON_DELETE_CON").style.display='none'
            strOptCon="_edit";
            $("#dialogWait").dialog("close");
        },
        error: function(objeto, quepaso, otroobj){
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}




/**funcion para eliminar un contacto**/
function delSeg(){
    var grid = jQuery("#GRIDSEGUI");
    if(grid.getGridParam("selrow") != null){
        if(confirm('¿Confirma que desea borrar este contacto!!')){
            var id = grid.getGridParam("selrow");
            var lstRow = grid.getRowData(id);
            var IdRen=lstRow.SEG_ID;
            grid.delRowData(grid.getGridParam("selrow"));
            $.ajax({
                type: "POST",
                data: "id=" + IdRen,//Anadimos parametro PRSINT para mostrar items internos
                scriptCharset: "utf-8" ,
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType:"html",
                url: "it_cte_pto.jsp?ID=16",
                success: function(datos){
                    if(datos.substring(0,2)=="OK"){
                        alert("Seguimiento dado de baja Correctamente!!");
                        var grid2 = jQuery("#GRIDSEGUI");
                        grid2.trigger("reloadGrid");



                        //reseteamos la variable
                        strOptCon="";
                    }
                    else{
                        alert(datos);
                    }
                    $("#dialogWait").dialog("close");
                },
                error: function(objeto, quepaso, otroobj){
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });

        }
    }

}





//Controla el flujo de los tabs
function tabShow(event,ui){

    tabShowSwitch(ui.newTab.index(),true);

    var idx = d.getElementById("CT_ID").value;
    if(ui.newTab.index()==1){
        LoadProyectos(idx);
    }
}



function LoadProyectos(idx){
    var grid = jQuery("#GRIDPROY");
    grid.setGridParam({
        url:"CIP_TablaOp.jsp?ID=5&opnOpt=PROYE&_search=true&PRY_ID=" +idx
    });
    grid.trigger("reloadGrid");
}

function LoadSucursales(idx){
    var grid = jQuery("#GRIDPROY");
    grid.setGridParam({
        url:"CIP_TablaOp.jsp?ID=5&opnOpt=PROYE&_search=true&PRY_ID=" +idx
    });
    grid.trigger("reloadGrid");
}


function LoadContactos(idx){
    var grid = jQuery("#GRIDPROY");
    grid.setGridParam({
        url:"CIP_TablaOp.jsp?ID=5&opnOpt=PROYE&_search=true&PRY_ID=" +idx
    });
    grid.trigger("reloadGrid");
}