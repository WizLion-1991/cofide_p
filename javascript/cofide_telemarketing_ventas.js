function cofide_telemarketing_ventas() {

}
var itemIdCob = 0;
var itemIdFactDat = 0;
var strOoperFac = "";
function initTVentas() {
    //campos de venta a detalle
    var strIDFAC = document.getElementById("CT_ID_FACTKT").value;
    var strTipoDoc = document.getElementById("CT_TIPODOC").value;
    //campos de venta a detalle
    cancelTVenta();
    listarCursos();
    hideDatFact();
    $("#tabsNVENTA").tabs("option", "active", 0);
    TabsMapFactCofide("1,2,3,4", false, "NVENTA");
    document.getElementById("CEV_BTNGUARDAR").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_DOFAC").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_DOFAC_CTE").parentNode.parentNode.style.display = "none";
    if (strIDFAC == "" && strTipoDoc == "") { //si no hay datos en esos campos, es una venta nueva
        loadDatosFact();
        LoadParticipantes();
    } else {
        // detalle de venta
        if (strTipoDoc == "FAC") {
            document.getElementById("CEV_BTNGUARDAR").parentNode.parentNode.style.display = "none";
            BloqCampos();
        }
        Vta_Deta();
        if (document.getElementById("CT_GRID").value == "0") { //venta cliente
            document.getElementById("CEV_DOFAC_CTE").parentNode.parentNode.style.display = "";
        } else { //vta general
            document.getElementById("CEV_DOFAC").parentNode.parentNode.style.display = "";
        }
    }
    isUnBound();
}

//Permiso para saber si puede escoger el medio de publicidad al hacer una venta.z
function isUnBound() {
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "keys=758",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "Acceso.do",
        success: function (datos) {
            var objsc = datos.getElementsByTagName("Access")[0];
            var lstKeys = objsc.getElementsByTagName("key");
            for (i = 0; i < lstKeys.length; i++) {
                var obj = lstKeys[i];
                if (obj.getAttribute('id') == 758 && obj.getAttribute('enabled') == "true") {
                    document.getElementById("CEV_MPUBLICIDAD").parentNode.parentNode.style.display = 'block';
                    document.getElementById("CT_PERMISO_INBOUND").value = 1;                    
                } else {
                    document.getElementById("CT_PERMISO_INBOUND").value = 0;
                    document.getElementById("CEV_MPUBLICIDAD").parentNode.parentNode.style.display = 'none';
                }
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}//Fin isUnBound


function newTVenta() {
    document.getElementById("CEV_TITULO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_NOMBRE").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_APPATERNO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_APMATERNO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_ASOCIACION").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_NUMERO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_CORREO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_ADDBTN").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_EDITBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_DELBTN").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_CANCELBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_SAVEBTN").parentNode.parentNode.style.display = "";
}
function cancelTVenta() {
    document.getElementById("CEV_TITULO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_NOMBRE").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_APPATERNO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_APMATERNO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_ASOCIACION").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_NUMERO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_CORREO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_ADDBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_EDITBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_DELBTN").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_CANCELBTN").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_SAVEBTN").parentNode.parentNode.style.display = "none";
}
function addGridCola() {
    var boolBand = 0;
    var intRow = 0;
    if (document.getElementById("CEV_NOMBRE").value != "") {
        boolBand = 1;
    } else {
        boolBand = 0;
        alert("Capture el Nombre");
    }
    if (boolBand == 1) {
        var strTitulo = document.getElementById("CEV_TITULO").value;
        var strNombre = document.getElementById("CEV_NOMBRE").value;
        var strApPat = document.getElementById("CEV_APPATERNO").value;
        var strApMat = document.getElementById("CEV_APMATERNO").value;
        var strAsoc = document.getElementById("CEV_ASOCIACION").value;
        var strNum = document.getElementById("CEV_NUMERO").value;
        var strCorreo = document.getElementById("CEV_CORREO").value;
        if (ValidaNumSoc()) {
            var datarow = {CCO_NOMBRE: strNombre, CCO_APPATERNO: strApPat, CCO_APMATERNO: strApMat, CCO_TITULO: strTitulo, CCO_NOSOCIO: strNum, CCO_CORREO: strCorreo, CCO_ASOCIACION: strAsoc};
            LimpiarGridParticipante();
            itemIdCob++;
            jQuery("#GRIDPARTICIPA").addRowData(itemIdCob, datarow, "last");
            cancelTVenta();
        } else {
            alert("El Numero de Socio no es Valido!");
        }
    }
}
function LimpiarGridParticipante() {
    document.getElementById("CEV_TITULO").value = "";
    document.getElementById("CEV_NOMBRE").value = "";
    document.getElementById("CEV_APPATERNO").value = "";
    document.getElementById("CEV_APMATERNO").value = "";
    document.getElementById("CEV_ASOCIACION").value = "";
    document.getElementById("CEV_NUMERO").value = "";
    document.getElementById("CEV_CORREO").value = "";
}
function consultaCurso() {
    var strIDFAC = document.getElementById("CT_ID_FACTKT").value;
    if (strIDFAC == "") { // si no hay datos ahi, sera una venta nueva

        var strCurso = document.getElementById("CEV_NOMCURSO").value;
        if (strCurso != "") {
            var strPost = "";
            strPost += "CEV_NOMCURSO=" + strCurso.split(" /", 1);
            var strCurso1 = document.getElementById("CEV_TIPO_CURSO0").checked;
            var strCurso2 = document.getElementById("CEV_TIPO_CURSO1").checked;
            var strCurso3 = document.getElementById("CEV_TIPO_CURSO2").checked;
            if (strCurso1) {
                strPost += "&Clasifica=1";
            }
            if (strCurso2) {
                strPost += "&Clasifica=2";
            }
            if (strCurso3) {
                strPost += "&Clasifica=3";
            }
            $.ajax({
                type: "POST", 
                data: strPost, 
                scriptCharset: "UTF-8", 
                contentType: "application/x-www-form-urlencoded;charset=utf-8", 
                cache: false, 
                dataType: "xml", 
                url: "COFIDE_Telemarketing_vta.jsp?ID=1", 
                success: function (datos) {
                    var lstXml = datos.getElementsByTagName("vta")[0];
                    var lstCte = lstXml.getElementsByTagName("datos");
                    for (var i = 0; i < lstCte.length; i++) {
                        var objcte = lstCte[i];
                        var intOcupado = parseInt(objcte.getAttribute("CEV_OCUPADO"));
                        var intLimite = parseInt(objcte.getAttribute("CEV_LIMITE"));
                        var strFecha = objcte.getAttribute("CEV_FECINICIO");
                        if (intOcupado < intLimite) {
                            document.getElementById("CEV_LIMITE").value = objcte.getAttribute("CEV_LIMITE");
                            document.getElementById("CEV_OCUPADO").value = objcte.getAttribute("CEV_OCUPADO");
                            document.getElementById("CEV_PRECIO_UNIT").value = objcte.getAttribute("CEV_PRECIO_UNIT");
                            document.getElementById("CEV_FECINICIO").value = objcte.getAttribute("CEV_FECINICIO");
                            document.getElementById("CEV_FECHA").value = strFecha;
                            document.getElementById("CEV_IDCURSO").value = objcte.getAttribute("CEV_IDCURSO");
                        } else {
                            document.getElementById("CEV_NOMCURSO").value = "";
                            alert("El curso ya no tiene lugares disponibles");
                        }
                    }
                }});
        }
    }
}
function listarCursos() {
    document.getElementById("CEV_NOMCURSO").value = "";
    document.getElementById("CEV_LIMITE").value = "";
    document.getElementById("CEV_OCUPADO").value = "";
    var strCurso1 = document.getElementById("CEV_TIPO_CURSO0").checked;
    var strCurso2 = document.getElementById("CEV_TIPO_CURSO1").checked;
    var strCurso3 = document.getElementById("CEV_TIPO_CURSO2").checked;
    var strNomCurso = document.getElementById("CEV_NOMCURSO").value;
    var strPost = "";
    if (strCurso1) {
        strPost += "Clasifica=1";
    }
    if (strCurso2) {
        strPost += "Clasifica=2";
    }
    if (strCurso3) {
        strPost += "Clasifica=3";
    }
    $(function () {
        $("#CEV_NOMCURSO").autocomplete({source: "COFIDE_Telemarketing.jsp?ID=12&" + strPost, minLength: 2});
    });
}
function intRowD() {
    var intRow;
    var grid = jQuery("#GRIDPARTICIPA");
    var idArr = grid.getDataIDs();
    intRow = idArr.length;
    document.getElementById("CEV_PARTICIPANTE").value = intRow;
    return intRow;
}
function operaciones() {
    intRowD();
    var PrecioUnit = parseFloat(document.getElementById("CEV_PRECIO_UNIT").value);
    var Participantes = parseInt(document.getElementById("CEV_PARTICIPANTE").value);
    var tax = new Impuestos(dblTasa1, dblTasa2, dblTasa3, intSImp1_2, intSImp1_3, intSImp2_3);
    tax.CalculaImpuestoMas(PrecioUnit);
    var dblIva = parseFloat(this.dblImpuesto1 = tax.dblImpuesto1);
    var SubTotal = PrecioUnit * Participantes;
    var Total = dblIva + SubTotal;
    document.getElementById("CEV_SUB1").value = SubTotal;
    document.getElementById("CEV_SUB3").value = Total;
    document.getElementById("CEV_SUB2").value = dblIva;
}
function delGridCola() {
    var grid = jQuery("#GRIDPARTICIPA");
    if (grid.getGridParam("selrow") != null) {
        grid.delRowData(grid.getGridParam("selrow"));
        itemIdCob = -1;
    }
}
function cerrarVtaCofide() {
    var objSecModiVta = objMap.getScreen("NVENTA");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    $("#dialog").dialog("close");
    document.getElementById("CT_ID_FACTKT").value = ""; // se guarda el id en un hidden           
    document.getElementById("CT_TIPODOC").value = ""; // se guarda el id en un hidden 
}
function agregaDatosFact() {
    showDatFact();
    strOoperFac = "N";
}
function editDatosFact() {
    var grid = jQuery("#CEV_GRID");
    if (grid.getGridParam("selrow") != null) {
        showDatFact();
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        document.getElementById("CEV_RAZONSOCIAL").value = lstRow.CEV_RAZONSOCIAL;
        document.getElementById("CEV_NUMERO_FACT").value = lstRow.CEV_NUMERO;
        document.getElementById("CEV_RFC").value = lstRow.CEV_RFC;
        document.getElementById("CEV_CALLE").value = lstRow.CEV_CALLE;
        document.getElementById("CEV_COLONIA").value = lstRow.CEV_COLONIA;
        document.getElementById("CEV_MUNICIPIO").value = lstRow.CEV_MUNICIPIO;
        document.getElementById("CEV_ESTADO").value = lstRow.CEV_ESTADO;
        document.getElementById("CEV_CP").value = lstRow.CEV_CP;
        document.getElementById("CEV_TELEFONO").value = lstRow.CEV_TELEFONO;
        document.getElementById("CEV_EMAIL1").value = lstRow.CEV_EMAIL1;
        document.getElementById("CEV_EMAIL2").value = lstRow.CEV_EMAIL2;
        strOoperFac = "C";
    }
}
function loadDatosFact() {
    var intIdCte = document.getElementById("CT_NO_CLIENTE").value;
    var strPost = "";
    strPost += "CT_NO_CLIENTE=" + intIdCte;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing_vta.jsp?ID=2",
        success: function (datos) {
            jQuery("#CEV_GRID").clearGridData();
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    CEV_ID_FAC: objcte.getAttribute("CEV_ID"),
                    CEV_RAZONSOCIAL: objcte.getAttribute("CEV_NOMBRE"),
                    CEV_NUMERO: objcte.getAttribute("CEV_NUMERO"),
                    CEV_RFC: objcte.getAttribute("CEV_RFC"),
                    CEV_CALLE: objcte.getAttribute("CEV_CALLE"),
                    CEV_COLONIA: objcte.getAttribute("CEV_COLONIA"),
                    CEV_MUNICIPIO: objcte.getAttribute("CEV_MUNICIPIO"),
                    CEV_ESTADO: objcte.getAttribute("CEV_ESTADO"),
                    CEV_CP: objcte.getAttribute("CEV_CP"),
                    CEV_EMAIL1: objcte.getAttribute("CEV_EMAIL1"),
                    CEV_EMAIL2: objcte.getAttribute("CEV_EMAIL2"),
                    CEV_TELEFONO: objcte.getAttribute("CEV_TELEFONO")};
                itemIdFactDat++;
                jQuery("#CEV_GRID").addRowData(itemIdFactDat, datarow, "last");
            }
        }});
}
function showDatFact() {
    document.getElementById("CEV_RAZONSOCIAL").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_NUMERO_FACT").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_NUMERO_INT").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_RFC").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_CALLE").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_COLONIA").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_MUNICIPIO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_ESTADO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_CP").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_TELEFONO").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_EMAIL1").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_EMAIL2").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_RAZONSOCIAL").value = "";
    document.getElementById("CEV_NUMERO_FACT").value = "";
    document.getElementById("CEV_NUMERO_INT").value = "";
    document.getElementById("CEV_RFC").value = "";
    document.getElementById("CEV_CALLE").value = "";
    document.getElementById("CEV_COLONIA").value = "";
    document.getElementById("CEV_MUNICIPIO").value = "";
    document.getElementById("CEV_ESTADO").value = "";
    document.getElementById("CEV_CP").value = "";
    document.getElementById("CEV_TELEFONO").value = "";
    document.getElementById("CEV_EMAIL1").value = "";
    document.getElementById("CEV_EMAIL2").value = "";
    document.getElementById("CEV_BTNSAVE1").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_BTNCANCEL1").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_BTNADD").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_BTNEDIT").parentNode.parentNode.style.display = "none";
}
function hideDatFact() {
    document.getElementById("CEV_RAZONSOCIAL").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_NUMERO_FACT").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_NUMERO_INT").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_RFC").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_CALLE").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_COLONIA").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_MUNICIPIO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_ESTADO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_CP").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_TELEFONO").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_EMAIL1").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_EMAIL2").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_BTNSAVE1").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_BTNCANCEL1").parentNode.parentNode.style.display = "none";
    document.getElementById("CEV_BTNADD").parentNode.parentNode.style.display = "";
    document.getElementById("CEV_BTNEDIT").parentNode.parentNode.style.display = "";
}
function saveDatosFact() {
    if (validateDatosFact()) {
        if (strOoperFac == "N") {
            var datarow = {
                CEV_ID_FAC: 0,
                CEV_RAZONSOCIAL: document.getElementById("CEV_RAZONSOCIAL").value,
                CEV_NUMERO: document.getElementById("CEV_NUMERO_FACT").value,
                CEV_NUMINT: document.getElementById("CEV_NUMERO_INT").value,
                CEV_RFC: document.getElementById("CEV_RFC").value,
                CEV_CALLE: document.getElementById("CEV_CALLE").value,
                CEV_COLONIA: document.getElementById("CEV_COLONIA").value,
                CEV_MUNICIPIO: document.getElementById("CEV_MUNICIPIO").value,
                CEV_ESTADO: document.getElementById("CEV_ESTADO").value,
                CEV_CP: document.getElementById("CEV_CP").value,
                CEV_TELEFONO: document.getElementById("CEV_TELEFONO").value,
                CEV_EMAIL1: document.getElementById("CEV_EMAIL1").value,
                CEV_EMAIL2: document.getElementById("CEV_EMAIL2").value
            };
            itemIdFactDat++;
            jQuery("#CEV_GRID").addRowData(itemIdFactDat, datarow, "last");
            hideDatFact();
        } else {
            var grid = jQuery("#CEV_GRID");
            if (grid.getGridParam("selrow") != null) {
                var lstRow = grid.getRowData(grid.getGridParam("selrow"));
                lstRow.CEV_RAZONSOCIAL = document.getElementById("CEV_RAZONSOCIAL").value;
                lstRow.CEV_NUMERO = document.getElementById("CEV_NUMERO_FACT").value;
                lstRow.CEV_NUMINT = document.getElementById("CEV_NUMERO_INT").value;
                lstRow.CEV_RFC = document.getElementById("CEV_RFC").value;
                lstRow.CEV_CALLE = document.getElementById("CEV_CALLE").value;
                lstRow.CEV_COLONIA = document.getElementById("CEV_COLONIA").value;
                lstRow.CEV_MUNICIPIO = document.getElementById("CEV_MUNICIPIO").value;
                lstRow.CEV_ESTADO = document.getElementById("CEV_ESTADO").value;
                lstRow.CEV_CP = document.getElementById("CEV_CP").value;
                lstRow.CEV_TELEFONO = document.getElementById("CEV_TELEFONO").value;
                lstRow.CEV_EMAIL1 = document.getElementById("CEV_EMAIL1").value;
                lstRow.CEV_EMAIL2 = document.getElementById("CEV_EMAIL2").value;
                grid.setRowData(grid.getGridParam("selrow"), lstRow);
            }
            hideDatFact();
        }
        strOoperFac = "";
    }
}
function validateDatosFact() {
    var bolValido = true;
    if (document.getElementById("CEV_RAZONSOCIAL").value == "") {
        alert("Se requiere la razon social");
        return false;
    }
    if (document.getElementById("CEV_RFC").value == "") {
        alert("Se requiere el rfc");
        return false;
    } else {
//        var bolExpReg = _EvalExpRegCOFIDE1(document.getElementById("CEV_RFC").value, "^[A-Z,Ñ,&]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,0-9]?[A-Z,0-9]?[0-9,A-Z]?$");
        var bolExpReg = _EvalExpRegCOFIDE1(document.getElementById("CEV_RFC").value, "^[A-Z,Ñ,&,a-z,ñ]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,Ñ,&,0-9,a-z]{3}");
        if (!bolExpReg) {
            alert("El formato del registro federal de contribuyentes es incorrecto");
            document.getElementById("CEV_RFC").focus();
            return false;
        }
    }
    if (document.getElementById("CEV_CALLE").value == "") {
        alert("Se requiere la calle");
        return false;
    }
    if (document.getElementById("CEV_NUMERO_FACT").value == "") {
        alert("Se requiere el numero de exterior");
        return false;
    }
    if (document.getElementById("CEV_NUMERO_INT").value == "") {
        alert("Se requiere el numero de interior");
        return false;
    }
    if (document.getElementById("CEV_COLONIA").value == "") {
        alert("Se requiere la colonia");
        return false;
    }
    if (document.getElementById("CEV_MUNICIPIO").value == "") {
        alert("Se requiere el municipio");
        return false;
    }
    if (document.getElementById("CEV_ESTADO").value == "") {
        alert("Se requiere el estado");
        return false;
    }
    if (document.getElementById("CEV_CP").value == "") {
        alert("Se requiere el codigo postal");
        return false;
    }
    if (document.getElementById("CEV_EMAIL1").value != "") {
        var bolExpReg = _EvalExpRegCOFIDE1(document.getElementById("CEV_EMAIL1").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
        if (!bolExpReg) {
            alert("El formato del mail es incorrecto");
            document.getElementById("CEV_EMAIL1").focus();
            return false;
        }
    }
    if (document.getElementById("CEV_EMAIL2").value != "") {
        var bolExpReg = _EvalExpRegCOFIDE1(document.getElementById("CEV_EMAIL2").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
        if (!bolExpReg) {
            alert("El formato del mail es incorrecto");
            document.getElementById("CEV_EMAIL2").focus();
            return false;
        }
    }
    if (document.getElementById("CEV_CP").value != "") {
        var bolExpReg = _EvalExpRegCOFIDE1(document.getElementById("CEV_CP").value, "^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$");
        if (!bolExpReg) {
            alert("El formato del codigo postal es incorrecto");
            document.getElementById("CEV_CP").focus();
            return false;
        }
    }
    return bolValido;
}
function cancelDatosFact() {
    hideDatFact();
    strOoperFac = "";
}
function TabsMapFactCofide(lstTabs, bolActivar, strNomTab) {
    var arrTabs = lstTabs.split(",");
    for (var i = 0; i < arrTabs.length; i++) {
        if (bolActivar) {
            $("#tabs" + strNomTab).tabs("enable", parseInt(arrTabs[i]));
        } else {
            $("#tabs" + strNomTab).tabs("disable", parseInt(arrTabs[i]));
        }
    }
}
function continuarPaso(numPaso) {
    document.getElementById("CEV_BTNGUARDAR").parentNode.parentNode.style.display = "none";
    var strCurso = document.getElementById("CEV_NOMCURSO").value;
    if (numPaso == 0) {
        TabsMapFactCofide("0", true, "NVENTA");
        $("#tabsNVENTA").tabs("option", "active", 0);
        TabsMapFactCofide("1,2,3,4", false, "NVENTA");
    }
    if (numPaso == 1) {
        if (strCurso != "") {
            TabsMapFactCofide("1", true, "NVENTA");
            $("#tabsNVENTA").tabs("option", "active", 1);
            TabsMapFactCofide("0,1,3,4", false, "NVENTA");
        } else {
            alert("Es Necesario Elegir un Curso!");
        }
    }
    if (numPaso == 2) {
        var strAsoc = document.getElementById("CEV_ASOCIACION").value;
        var strTipoAsoc = document.getElementById("CEV_NUMERO").value;
        var strNombre = document.getElementById("CEV_NOMBRE").value;
        if (intRowD() == 0) {
            if (strAsoc != 0 && strNombre != "") {
                if (strAsoc == "NINGUNA") {
                    TabsMapFactCofide("2", true, "NVENTA");
                    $("#tabsNVENTA").tabs("option", "active", 2);
                    TabsMapFactCofide("0,1,3,4", false, "NVENTA");
                    operaciones();
                } else {
                    if (strTipoAsoc != "0") {
                        TabsMapFactCofide("2", true, "NVENTA");
                        $("#tabsNVENTA").tabs("option", "active", 2);
                        TabsMapFactCofide("0,1,3,4", false, "NVENTA");
                        operaciones();
                    } else {
                        alert("Es Necesario el Numero de Socio");
                        document.getElementById("CEV_NUMERO").focus();
                    }
                }
            } else {
                alert("selecciona una asociacion");
            }
        } else {
            TabsMapFactCofide("2", true, "NVENTA");
            $("#tabsNVENTA").tabs("option", "active", 2);
            TabsMapFactCofide("0,1,3,4", false, "NVENTA");
            operaciones();
        }
    }
    if (numPaso == 3) {
        //LoadDatosFiscales();
        TabsMapFactCofide("3", true, "NVENTA");
        $("#tabsNVENTA").tabs("option", "active", 3);
        TabsMapFactCofide("0,1,2,4", false, "NVENTA");
    }
    if (numPaso == 4) {
        TabsMapFactCofide("4", true, "NVENTA");
        $("#tabsNVENTA").tabs("option", "active", 4);
        TabsMapFactCofide("0,1,2,3", false, "NVENTA");
        document.getElementById("CEV_BTNGUARDAR").parentNode.parentNode.style.display = "";
    }
}
function subirComprobantePago() {
    var File = document.getElementById("CEV_COMPROBANTE");
    if (File.value == "") {
        alert("Requiere seleccionar un archivo");
        File.focus();
    } else {
        if (Right(File.value.toUpperCase(), 3) == "PDF" || Right(File.value.toUpperCase(), 3) == "PNG" || Right(File.value.toUpperCase(), 3) == "JPG") {
            $("#dialogWait").dialog("open");
            $.ajaxFileUpload({
                url: "COFIDE_UpComprobante.jsp",
                secureuri: false,
                fileElementId: "CEV_COMPROBANTE",
                dataType: "json",
                success: function (data, status) {
                    if (typeof (data.error) != "undefined") {
                        if (data.error != "") {
                            alert(data.error);
                        } else {
                            alert("Archivo guardado");
//                            document.getElementById("CEV_NOM_FILE").value = data.msg;
                            document.getElementById("CEV_NOM_FILE").value = document.getElementById("CEV_COMPROBANTE").value;
                        }
                    }
                    $("#dialogWait").dialog("close");
                }, error: function (data, status, e) {
                    alert(e);
                    $("#dialogWait").dialog("close");
                }});
        } else {
            alert("Se aceptan archivos con extension pdf, png y jpg");
            File.focus();
        }
    }
}
function _EvalExpRegCOFIDE1(YourValue, YourExp) {
    var Template = new RegExp(YourExp);
    return(Template.test(YourValue)) ? 1 : 0;
}
function saveVtaCofide() {
    if (confirm("¿Desea guardar la venta?")) {
        var strIDFAC = document.getElementById("CT_ID_FACTKT").value;
        var strTipoDoc = document.getElementById("CT_TIPODOC").value;

        var strRazonSocial = "";
        var strCorreo = "";
        var strCorreo2 = "";
        var strRFC = "";

        if (strIDFAC == "" && strTipoDoc == "") { //si no hay datos en esos campos, es una venta nueva
            var strComent = document.getElementById("CEV_COMENT").value;
            if (saveVtaCofideValida()) {
                $("#dialogWait").dialog("open");
                var strPOST = "";
                var strPrefijoMaster = "TKT";
                var strPrefijoDeta = "TKTD";
                var strKey = "TKT_ID";
                var strNomFormat = "TICKET";
                var strCurso = document.getElementById("CEV_NOMCURSO").value;
                //limpiamos el curso
                var temp = "";
                var temp2 = "";
                temp = strCurso.split(" / ", 1);
                temp = strCurso.replace(temp + " / ", "");
                temp2 = temp.split(" / ", 1);
                temp2 = temp.replace(temp2 + " / ", "");
                strCurso = temp2;

                if (document.getElementById("CEV_FACT_IN").checked) {
                    strPrefijoMaster = "FAC";
                    strPrefijoDeta = "FACD";
                    strKey = "FAC_ID";
                    strNomFormat = "FACTURA";
                }
                strPOST += "SC_ID=" + intSucDefa;
                strPOST += "&CT_ID=" + d.getElementById("CT_NO_CLIENTE").value;
                strPOST += "&CEV_MPUBLICIDAD=" + d.getElementById("CEV_MPUBLICIDAD").value;
                strPOST += "&VE_ID=0";
                strPOST += "&PD_ID=0";
                strPOST += "&" + strPrefijoMaster + "_ESSERV=1";
                strPOST += "&" + strPrefijoMaster + "_MONEDA=1";
                strPOST += "&" + strPrefijoMaster + "_FOLIO=";
//        strPOST += "&" + strPrefijoMaster + "_NOTAS=" + encodeURIComponent(document.getElementById("CEV_NOMCURSO").value);
                strPOST += "&" + strPrefijoMaster + "_NOTAS=" + document.getElementById("CEV_COMENTARIO").value;
                ;
//        strPOST += "&" + strPrefijoMaster + "_NOTAS=" + encodeURIComponent(strCurso);
                strPOST += "&" + strPrefijoMaster + "_IMPUESTO1=" + d.getElementById("CEV_SUB2").value;
                strPOST += "&" + strPrefijoMaster + "_IMPUESTO2=" + 0;
                strPOST += "&" + strPrefijoMaster + "_IMPUESTO3=" + 0;
                strPOST += "&" + strPrefijoMaster + "_IMPORTE=" + d.getElementById("CEV_SUB1").value;
                strPOST += "&" + strPrefijoMaster + "_RETISR=0";
                strPOST += "&" + strPrefijoMaster + "_RETIVA=0";
                strPOST += "&" + strPrefijoMaster + "_NETO=0";
                strPOST += "&" + strPrefijoMaster + "_NOTASPIE=" + strComent; //comentarios del ejecutivo
                strPOST += "&" + strPrefijoMaster + "_REFERENCIA=";
                strPOST += "&" + strPrefijoMaster + "_CONDPAGO=";
                strPOST += "&" + strPrefijoMaster + "_METODOPAGO=" + d.getElementById("CEV_DESCRIPCION").value;
                strPOST += "&" + strPrefijoMaster + "_NUMCUENTA=";
                strPOST += "&" + strPrefijoMaster + "_FORMADEPAGO=EN UNA SOLA EXHIBICION";
                strPOST += "&" + strPrefijoMaster + "_NUMPEDI=";
                strPOST += "&" + strPrefijoMaster + "_FECHAPEDI=";
                strPOST += "&" + strPrefijoMaster + "_ADUANA=";
                strPOST += "&" + strPrefijoMaster + "_TIPOCOMP=";
                if (document.getElementById("CEV_FACT_IN").checked) {
                    strPOST += "&TIPOVENTA=" + 1;
                } else {
                    strPOST += "&TIPOVENTA=" + 2;
                }
                strPOST += "&" + strPrefijoMaster + "_TASA1=" + 16;
                strPOST += "&" + strPrefijoMaster + "_TASA2=" + 0;
                strPOST += "&" + strPrefijoMaster + "_TASA3=" + 0;
                strPOST += "&" + "TI_ID=" + 1;
                strPOST += "&" + "TI_ID2=" + 0;
                strPOST += "&" + "TI_ID3=" + 0;
                strPOST += "&" + strPrefijoMaster + "_TASAPESO=1";
                strPOST += "&" + strPrefijoMaster + "_DIASCREDITO=1";
                strPOST += "&" + strPrefijoMaster + "_USO_IEPS=0";
                strPOST += "&" + strPrefijoMaster + "_TASA_IEPS=0";
                strPOST += "&" + strPrefijoMaster + "_IMPORTE_IEPS=0";
                strPOST += "&" + strPrefijoMaster + "_ESRECU=0";
                strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD=0";
                strPOST += "&" + strPrefijoMaster + "_DIAPER=0";
//                if (document.getElementById("CEV_FACT_IN").checked) {
                var grid = jQuery("#CEV_GRID");
                if (grid.getGridParam("selrow") != null) {
                    var lstRow = grid.getRowData(grid.getGridParam("selrow"));
                    if (document.getElementById("CEV_FACT_IN").checked) {
                        strPOST += "&DFA_ID=0";
                        strPOST += "&CEV_RAZONSOCIAL=" + lstRow.CEV_RAZONSOCIAL;
                        strPOST += "&CEV_RFC=" + lstRow.CEV_RFC;
                        strRFC = lstRow.CEV_RFC;
                        strPOST += "&CEV_NUMERO_FACT=" + lstRow.CEV_NUMERO;
                        strPOST += "&CEV_CALLE=" + lstRow.CEV_CALLE;
                        strPOST += "&CEV_COLONIA=" + lstRow.CEV_COLONIA;
                        strPOST += "&CEV_MUNICIPIO=" + lstRow.CEV_MUNICIPIO;
                        strPOST += "&CEV_RAZONSOCIAL=" + lstRow.CEV_RAZONSOCIAL;
                        strRazonSocial = lstRow.CEV_RAZONSOCIAL;
                        strPOST += "&CEV_ESTADO=" + lstRow.CEV_ESTADO;
                        strPOST += "&CEV_CP=" + lstRow.CEV_CP;
                        strPOST += "&CEV_TELEFONO=" + lstRow.CEV_TELEFONO;
                        strPOST += "&CEV_EMAIL1=" + lstRow.CEV_EMAIL1;
                        strPOST += "&CEV_EMAIL2=" + lstRow.CEV_EMAIL2;
                    } //fin si es if fac
                    strCorreo = lstRow.CEV_EMAIL1;
                    strCorreo2 = lstRow.CEV_EMAIL2;
                }
//                } // fin if si es fac
                strPOST += "&ADD_FEMSA=0";
//        var txtNomCurso = d.getElementById("CEV_NOMCURSO").value;
                var txtNomCurso = strCurso;
                var intC = 1;
                strPOST += "&PR_ID" + intC + "=" + document.getElementById("CEV_IDCURSO").value;
                strPOST += "&" + strPrefijoDeta + "_EXENTO1" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_EXENTO2" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_EXENTO3" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_CVE" + intC + "=" + "...";
                strPOST += "&" + strPrefijoDeta + "_DESCRIPCION" + intC + "=" + encodeURIComponent(strCurso);
//        strPOST += "&" + strPrefijoDeta + "_DESCRIPCION" + intC + "= SERVICIO"; // se concatenaba junto con el nombre del curso al facturar como servicio
                strPOST += "&" + strPrefijoDeta + "_CANTIDAD" + intC + "=" + document.getElementById("CEV_PARTICIPANTE").value;
                strPOST += "&" + strPrefijoDeta + "_RET_ISR" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_RET_IVA" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_RET_FLETE" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_CF_ID" + intC + "=" + 0;
                if (intPreciosconImp == 1) {
                    strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + document.getElementById("CEV_PRECIO_UNIT").value;
                    strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + document.getElementById("CEV_PRECIO_UNIT").value;
                } else {
                    var dblPrecioConImp = 0;
                    var dblPrecioRealConImp = 0;
                    if (parseFloat(document.getElementById("CEV_PARTICIPANTE").value) > 0) {
                        dblPrecioConImp = (parseFloat(document.getElementById("CEV_PRECIO_UNIT").value) + parseFloat(parseFloat(document.getElementById("CEV_SUB2").value) / parseFloat(document.getElementById("CEV_PARTICIPANTE").value)) + parseFloat(0) + parseFloat(0));
                        dblPrecioRealConImp = (parseFloat(document.getElementById("CEV_PRECIO_UNIT").value) + parseFloat(parseFloat(document.getElementById("CEV_SUB2").value) / parseFloat(document.getElementById("CEV_PARTICIPANTE").value)) + parseFloat(0) + parseFloat(0));
                    } else {
                        dblPrecioConImp = (parseFloat(document.getElementById("CEV_PRECIO_UNIT").value));
                        dblPrecioRealConImp = (parseFloat(document.getElementById("CEV_PRECIO_UNIT").value));
                    }
                    strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + dblPrecioConImp;
                    strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + dblPrecioRealConImp;
                }
                var dblImporte = parseFloat(document.getElementById("CEV_SUB1").value) + parseFloat(document.getElementById("CEV_SUB2").value);
                var dblDescuento = (parseFloat(document.getElementById("CEV_DESC").value) / 100) * dblImporte;
                var dblPorcDescuento = parseFloat(document.getElementById("CEV_DESC").value);
                var dblTotal = parseFloat(document.getElementById("CEV_SUB3").value) - parseFloat(dblDescuento);
                strPOST += "&" + strPrefijoMaster + "_TOTAL=" + dblTotal;
                strPOST += "&" + strPrefijoDeta + "_IMPORTE" + intC + "=" + dblImporte;
                strPOST += "&" + strPrefijoDeta + "_TASAIVA1" + intC + "=" + 16;
                strPOST += "&" + strPrefijoDeta + "_TASAIVA2" + intC + "=0" + 0;
                strPOST += "&" + strPrefijoDeta + "_TASAIVA3" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_IMPUESTO1" + intC + "=" + parseFloat(document.getElementById("CEV_SUB2").value);
                strPOST += "&" + strPrefijoDeta + "_IMPUESTO2" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_IMPUESTO3" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_NOSERIE" + intC + "=";
                strPOST += "&" + strPrefijoDeta + "_IMPORTEREAL" + intC + "=" + dblImporte;
                strPOST += "&" + strPrefijoDeta + "_DESCUENTO" + intC + "=" + dblDescuento;
                strPOST += "&" + strPrefijoDeta + "_PORDESC" + intC + "=" + dblPorcDescuento;
                strPOST += "&" + strPrefijoDeta + "_ESDEVO" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_PRECFIJO" + intC + "=" + 0;
                strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + 0;
//        strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + encodeURIComponent(document.getElementById("CEV_NOMCURSO").value);
                strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + document.getElementById("CEV_COMENTARIO").value;
                ;
//        strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + encodeURIComponent(strCurso);
                strPOST += "&" + strPrefijoDeta + "_UNIDAD_MEDIDA" + intC + "=" + "curso";
                strPOST += "&COUNT_ITEM=" + intC;
                strPOST += "&COUNT_PAGOS=0";
                strPOST += "&MCD_MONEDA1=1";
                strPOST += "&MCD_FOLIO1=";
                strPOST += "&MCD_FORMAPAGO1=EFECTIVO";
                strPOST += "&MCD_NOCHEQUE1=";
                strPOST += "&MCD_BANCO1=";
                strPOST += "&MCD_NOTARJETA1=";
                strPOST += "&MCD_TIPOTARJETA1=";
                strPOST += "&MCD_IMPORTE1=0.0";
                strPOST += "&MCD_TASAPESO1=1";
                strPOST += "&MCD_CAMBIO1=0.0";
                if (document.getElementById("CEV_MIMP1").checked) {
                    strPOST += "&CEV_MIMP=1";
                } else {
                    strPOST += "&CEV_MIMP=0";
                }
                if (document.getElementById("CEV_FAC1").checked) {
                    strPOST += "&CEV_FAC=1";
                } else {
                    strPOST += "&CEV_FAC=0";
                }
                if (document.getElementById("CEV_TIPO_CURSO0").checked) {
                    strPOST += "&CEV_TIPO_CURSO=1";
                }
                if (document.getElementById("CEV_TIPO_CURSO1").checked) {
                    strPOST += "&CEV_TIPO_CURSO=2";
                }
                if (document.getElementById("CEV_TIPO_CURSO2").checked) {
                    strPOST += "&CEV_TIPO_CURSO=3";
                }
                strPOST += "&CEV_IDCURSO=" + document.getElementById("CEV_IDCURSO").value;
                strPOST += "&CEV_NOM_FILE=" + document.getElementById("CEV_NOM_FILE").value;
                strPOST += "&CEV_FECHAPAGO=" + document.getElementById("CEV_FECHAPAGO").value;
                strPOST += "&CEV_FECINICIO=" + document.getElementById("CEV_FECINICIO").value;
                strPOST += "&CEV_DIGITO=" + document.getElementById("CEV_DIGITO").value;
                strPOST += "&CT_NO_CLIENTE=" + document.getElementById("CT_ID").value;
                strPOST += "&CT_RAZONSOCIAL=" + document.getElementById("CT_RAZONSOCIAL").value; //razon social del cliente principal
//            strPOST += "&CT_RAZONSOCIAL=" + strRazonSocial; //razon social del que se facturo
                strPOST += "&CT_RFC=" + document.getElementById("CT_RFC").value;
//            strPOST += "&CT_RFC=" + strRFC; //rfc del cliente principal
                strPOST += "&CT_SEDE=" + document.getElementById("CT_SEDE").value;
                strPOST += "&CT_GIRO=" + document.getElementById("CT_GIRO").value;
                strPOST += "&CT_AREA=" + document.getElementById("CT_AREA").value;
                strPOST += "&CT_CONTACTO=" + document.getElementById("CT_CONTACTO").value;
                strPOST += "&CT_CONTACTO2=" + document.getElementById("CT_CONTACTO2").value;
                strPOST += "&CT_CORREO=" + document.getElementById("CT_CORREO").value; //correo principal
                strPOST += "&CT_CORREO2=" + document.getElementById("CT_CORREO2").value;
                strPOST += "&CT_BOLBASE=" + document.getElementById("CT_BOLBASE").value;
                strPOST += "&CT_CP=" + document.getElementById("CT_CP").value;
                strPOST += "&CT_COL=" + document.getElementById("CT_COL").value;
                strPOST += "&CT_NUM=" + document.getElementById("CT_NUM").value;
                strPOST += "&CT_CALLE=" + document.getElementById("CT_CALLE").value;
                strPOST += "&CT_NOMBRE=" + document.getElementById("CT_CONTACTO_ENTRADA").value;
                strPOST += "&CT_CONMUTADOR=" + document.getElementById("CT_CONMUTADOR").value;
                strPOST += "&CEV_COMENTARIO=" + encodeURIComponent(strCurso); //comentario
//        strPOST += "&CEV_COMENTARIO=" + document.getElementById("CEV_COMENTARIO").value; //comentario
                strPOST += "&FAC_SERIE=C";

                strPOST += "&CEV_CORREO=" + strCorreo; //correo principal
                strPOST += "&CEV_CORREO2=" + strCorreo2;

                var grid = jQuery("#GRIDPARTICIPA");
                var arr = grid.getDataIDs();
                for (var i = 0; i < arr.length; i++) {
                    var id = arr[i];
                    var lstRow = grid.getRowData(id);
                    strPOST += "&CCO_TITULO" + i + "=" + lstRow.CCO_TITULO;
                    strPOST += "&CCO_NOMBRE" + i + "=" + lstRow.CCO_NOMBRE;
                    strPOST += "&CCO_APPATERNO" + i + "=" + lstRow.CCO_APPATERNO;
                    strPOST += "&CCO_APMATERNO" + i + "=" + lstRow.CCO_APMATERNO;
                    strPOST += "&CCO_NOSOCIO" + i + "=" + lstRow.CCO_NOSOCIO;
                    strPOST += "&CCO_ASOCIACION" + i + "=" + lstRow.CCO_ASOCIACION;
                    strPOST += "&CCO_CORREO" + i + "=" + lstRow.CCO_CORREO;
                }
                strPOST += "&length_participa=" + arr.length;
                var grid = jQuery("#GRIDCONTACTOS");
                var idArr = grid.getDataIDs();
                for (var i = 0; i < idArr.length; i++) {
                    var id = idArr[i];
                    var lstRow = grid.getRowData(id);
                    strPOST += "&CCO_NOMBRE" + i + "=" + lstRow.CCO_NOMBRE + "";
                    strPOST += "&CCO_APPATERNO" + i + "=" + lstRow.CCO_APPATERNO + "";
                    strPOST += "&CCO_APMATERNO" + i + "=" + lstRow.CCO_APMATERNO + "";
                    strPOST += "&CCO_TITULO" + i + "=" + lstRow.CCO_TITULO + "";
                    strPOST += "&CCO_NOSOCIO" + i + "=" + lstRow.CCO_NOSOCIO + "";
                    strPOST += "&CCO_AREA" + i + "=" + lstRow.CCO_AREA + "";
                    strPOST += "&CCO_ASOCIACION" + i + "=" + lstRow.CCO_ASOCIACION + "";
                    strPOST += "&CCO_CORREO" + i + "=" + lstRow.CCO_CORREO + "";
                    strPOST += "&CCO_TELEFONO" + i + "=" + lstRow.CCO_TELEFONO + "";
                    strPOST += "&CCO_EXTENCION" + i + "=" + lstRow.CCO_EXTENCION + "";
                    strPOST += "&CCO_ALTERNO" + i + "=" + lstRow.CCO_ALTERNO + "";
                }
                strPOST += "&length_contactos=" + idArr.length;
                $.ajax({
                    type: "POST",
                    data: encodeURI(strPOST),
                    scriptCharset: "utf-8",
                    contentType: "application/x-www-form-urlencoded;charset=utf-8",
                    cache: false,
                    dataType: "html",
                    url: "COFIDE_Telemarketing_vta.jsp?ID=5",
                    success: function (dato) {
                        dato = trim(dato);
                        var strIDFAC_TKT = ""; //id de la factura o el ticket
                        var strExt = ""; //tipo de documento
                        if (Left(dato, 3) == "OK.") {
                            if (strNomFormat == "FACTURA") {
                                var strHtml = CreaHidden(strKey, dato.replace("OK.", ""));
                                openWhereverFormat("ERP_SendInvoice?id=" + dato.replace("OK.", ""), strNomFormat, "PDF", strHtml);
                                strIDFAC_TKT = dato.replace("OK.", ""); //esto es el ID fac
                                strExt = "FAC";
                            } else {
                                var strHtml2 = CreaHidden(strKey, dato.replace("OK.", ""));
                                openFormat(strNomFormat, "PDF", strHtml2);
                                strIDFAC_TKT = dato.replace("OK.", ""); //esto es el ID tkt
                                strExt = "TKT";
                            }
                            var strIdCurso = document.getElementById("CEV_IDCURSO").value;
                            var intIdCte = document.getElementById("CT_ID").value;
                            vtaReservar(strIdCurso, intIdCte, strIDFAC_TKT, strExt); //envia el correo de reservacion
                            cerrarVtaCofide();
                            consultaVta();
                            jQuery("#GRIDCONTACTOS").clearGridData();
                        } else {
                            alert(dato);
                        }
                        $("#dialogWait").dialog("close");
                    }, error: function (objeto, quepaso, otroobj) {
                        alert(":Cofide tmk:" + objeto + " " + quepaso + " " + otroobj);
                        $("#dialogWait").dialog("close");
                    }});
            }
        } else {
            //pago de ticket
        }
    }
}
function saveVtaCofideValida() {
    var bolValido = true;
    if (document.getElementById("CEV_PARTICIPANTE").value == "0") {
        alert("Debe capturar por lo menos un participante");
        return false;
    }
    if (document.getElementById("CEV_NOMCURSO").value == "0") {
        alert("Debe seleccionar por lo menos un curso");
        return false;
    }
    if (document.getElementById("CEV_FACT_IN").checked) {
        var grid = jQuery("#CEV_GRID");
        if (grid.getGridParam("selrow") == null) {
            alert("Debe seleccionar por lo menos una razon social para facturar");
            return false;
        }
    }
    return bolValido;
}
function llenarColoniaFac() {
    var strCp = document.getElementById("CEV_CP").value;
    var objColoniaCombo = document.getElementById("CEV_COLONIA");
    if (strCp != "") {
        var strPost = "CEV_CP=" + strCp;
        $("#dialogWait").dialog("open");
        $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Telemarketing_vta.jsp?ID=3", success: function (datos) {
                select_clear(objColoniaCombo);
                var lstXml = datos.getElementsByTagName("General")[0];
                var lstCte = datos.getElementsByTagName("Colonia");
                for (var i = 0; i < lstCte.length; i++) {
                    var objColonia = lstCte[i];
                    select_add(objColoniaCombo, objColonia.getAttribute("CMX_COLONIA"), objColonia.getAttribute("CMX_COLONIA"));
                }
                document.getElementById("CEV_ESTADO").value = lstXml.getAttribute("CMX_ESTADO");
                document.getElementById("CEV_MUNICIPIO").value = lstXml.getAttribute("CMX_MUNICIPIO");
                $("#dialogWait").dialog("close");
            }});
    } else {
        select_clear(objColoniaCombo);
    }
}

function editParticipante() {
    var grid = jQuery("#GRIDPARTICIPA");
    if (grid.getGridParam("selrow") != null) {
        newTVenta();
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        document.getElementById("CEV_TITULO").value = lstRow.CCO_TITULO;
        document.getElementById("CEV_NOMBRE").value = lstRow.CCO_NOMBRE;
        document.getElementById("CEV_APPATERNO").value = lstRow.CCO_APPATERNO;
        document.getElementById("CEV_APMATERNO").value = lstRow.CCO_APMATERNO;
        document.getElementById("CEV_ASOCIACION").value = lstRow.CCO_NOSOCIO;
        document.getElementById("CEV_NUMERO").value = lstRow.CCO_ASOCIACION;
        document.getElementById("CEV_CORREO").value = lstRow.CCO_CORREO;
        delGridCola();
        itemIdCob++;
    } else {
        alert("Elige un participante");
    }
}
function ValidaNumSoc() {
    var ok = false;
    if (document.getElementById("CEV_ASOCIACION").value == "NINGUNA") {
        ok = true;
    } else {
        if (document.getElementById("CEV_NUMERO").value.length == 4 && document.getElementById("CEV_NUMERO").value != "0000") {
            ok = true;
        } else {
            if (document.getElementById("CEV_NUMERO").value.length == 5 && document.getElementById("CEV_NUMERO").value != "00000") {
                ok = true;
            }
        }
    }
    return ok;
}
function ValidaDescuento() {
    var strFechaActual = "";
    var strDesc = document.getElementById("CEV_DESC").value;
    var strFechaIni = document.getElementById("CEV_FECINICIO").value;
    $.ajax({type: "POST", data: "", scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Telemarketing_vta.jsp?ID=7", success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                strFechaActual = objcte.getAttribute("fecha");
            }
            if (strFechaActual != strFechaIni) {
                if (strDesc >= 15) {
                    alert("ingresa contraseña");
                    OpnDiagSupr();
                }
            } else {
                alert("No se puede aplicar descuento el mismo dia del evento");
                document.getElementById("CEV_DESC").value = "";
            }
        }});
}
function OpnDiagSupr() {
    var objSecModiVta = objMap.getScreen("AUT_SUP");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("AUT_SUP", "_ed", "dialogCte", false, false, true);
}
function ValSupr() {
    var sup = document.getElementById("SC_NOMBRE").value;
    var strPassword = document.getElementById("SC_PASSWORD").value;
    var strPass = "";
    var strPost = "SC_NOMBRE=" + sup;
    if (sup != "") {
        $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Telemarketing_vta.jsp?ID=6", success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    strPass = objcte.getAttribute("SC_PASSWORD");
                }
                if (strPassword == strPass) {
                    alert("Autorizado!");
                    $("#dialogCte").dialog("close");
                } else {
                    alert("Contraseña Ivalida, no se Autorizo el descuento");
                    document.getElementById("CEV_DESC").value = "";
                }
            }});
    } else {
        alert("Selecciona a un Supervisor");
    }
}
function LoadParticipantes() {
    var intIdCte = document.getElementById("CT_NO_CLIENTE").value;
    jQuery("#GRIDPARTICIPA").clearGridData();
    var strPost = "CT_ID=" + intIdCte;
    $.ajax({
        type: "POST", 
        data: strPost, 
        scriptCharset: "UTF-8", 
        contentType: "application/x-www-form-urlencoded;charset=utf-8", 
        cache: false, 
        dataType: "xml", 
        url: "COFIDE_Telemarketing.jsp?ID=18", 
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    CCO_ID: objcte.getAttribute("CCO_ID"), 
                    CCO_NOMBRE: objcte.getAttribute("CCO_NOMBRE"), 
                    CCO_APPATERNO: objcte.getAttribute("CCO_APPATERNO"), 
                    CCO_APMATERNO: objcte.getAttribute("CCO_APMATERNO"), 
                    CCO_TITULO: objcte.getAttribute("CCO_TITULO"), 
                    CCO_NOSOCIO: objcte.getAttribute("CCO_NOSOCIO"), 
                    CCO_ASOCIACION: objcte.getAttribute("CCO_ASOCIACION"), 
                    CCO_CORREO: objcte.getAttribute("CCO_CORREO")};
                itemIdCob++;
                document.getElementById("CEV_PARTICIPANTE").value = itemIdCob;
                jQuery("#GRIDPARTICIPA").addRowData(itemIdCob, datarow, "last");
            }
        }});
}
function vtaReservar(strIdCurso, intIdCte, strIDFAC_TKT, strExt) {
    var strPost = "id_curso=" + strIdCurso + "&id_cte=" + intIdCte + "&fac_id=" + strIDFAC_TKT + "&extension=" + strExt;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing_vta.jsp?ID=8",
    });
}
function BloqCampos() { //si es una factura, no se podra editar ningun campo
    document.getElementById("CEV_NOMCURSO").style["background"] = "#e0f8e6";
    document.getElementById("CEV_NOMCURSO").readOnly = true;
    $("#CEV_TIPO_CURSO0").attr("disabled", "");
    $("#CEV_TIPO_CURSO1").attr("disabled", "");
    $("#CEV_TIPO_CURSO2").attr("disabled", "");
    document.getElementById("CEV_ADDBTN").disabled = true;
    document.getElementById("CEV_DELBTN").disabled = true;
    document.getElementById("CEV_EDITBTN").disabled = true;
    document.getElementById("CEV_DESCRIPCION").disabled = true;
    document.getElementById("CEV_DESC").disabled = true;
    document.getElementById("CEV_FECHAPAGO").disabled = true;
    document.getElementById("CEV_FECINICIO").disabled = true;
    document.getElementById("CEV_COMENT").disabled = true;
    document.getElementById("btn_up_ficha_deposito").disabled = true;
    $("#CEV_MIMP1").attr("disabled", "");
    $("#CEV_MIMP2").attr("disabled", "");
    document.getElementById("CEV_COMPROBANTE").style["background"] = "#e0f8e6";
    document.getElementById("CEV_COMPROBANTE").readOnly = true;
    document.getElementById("CEV_BTNADD").disabled = true;
    document.getElementById("CEV_BTNEDIT").disabled = true;
    $("#CEV_FACT_IN").attr("disabled", "");
    document.getElementById("CEV_COMENTARIO").disabled = true;
}
function Vta_Deta() { //consulta la venta seleccionada
    var strIDFAC = document.getElementById("CT_ID_FACTKT").value;
    var strTipoDoc = document.getElementById("CT_TIPODOC").value;
    var PorDesc = "";
    var strPost = "";
    strPost = "strFac_Tkt=" + strIDFAC;
    strPost += "&strTipoDoc=" + strTipoDoc;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Historial.jsp?ID=4",
        success: function (datos) {
            //jQuery("#GRDIHVENTA").clearGridData();
            var objsc = datos.getElementsByTagName("Ventas")[0];
            var lstVtas = objsc.getElementsByTagName("datos");
            for (var i = 0; i < lstVtas.length; i++) {
                var obj = lstVtas[i];
                PorDesc = obj.getAttribute("PORDESC");
                PorDesc = PorDesc.replace(".00", "");
                document.getElementById("CEV_NOMCURSO").value = obj.getAttribute("CURSO");
                document.getElementById("CEV_IDCURSO").value = obj.getAttribute("CURSO_ID");
                document.getElementById("CEV_FECHA").value = obj.getAttribute("CURSO_FECHA");
                document.getElementById("CEV_LIMITE").value = obj.getAttribute("LIMITE");
                document.getElementById("CEV_OCUPADO").value = obj.getAttribute("OCUPADOS");
                document.getElementById("CEV_PRECIO_UNIT").value = obj.getAttribute("COSTO_UNIT");
                document.getElementById("CEV_SUB1").value = obj.getAttribute("COSTO_SUB");
                document.getElementById("CEV_SUB3").value = obj.getAttribute("COSTO_TOT");
                document.getElementById("CEV_SUB2").value = obj.getAttribute("IVA");
                document.getElementById("CEV_DESC").value = PorDesc;
                document.getElementById("CEV_DESCRIPCION").value = obj.getAttribute("METPAGO");
                document.getElementById("CEV_FECHAPAGO").value = obj.getAttribute("FECHA_PAGO");
                if (obj.getAttribute("MAT_IMP") == 1) {
                    $("#CEV_MIMP1").prop("checked", true);
                } else {
                    $("#CEV_MIMP2").prop("checked", true);
                }
                document.getElementById("CEV_COMENT").value = obj.getAttribute("COMENTARIO");
                document.getElementById("CEV_FECINICIO").value = obj.getAttribute("CURSO_FECHA");
            }
            $("#dialogWait").dialog("close");
            Vta_Participantes(strPost);
            Vta_RazonSocial(strPost);
        }, error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }});
}
function Vta_Participantes(strPost) {
    jQuery("#GRIDPARTICIPA").clearGridData();
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Historial.jsp?ID=5",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    CCO_ID: objcte.getAttribute("CCO_ID"),
                    CCO_NOMBRE: objcte.getAttribute("CCO_NOMBRE"),
                    CCO_APPATERNO: objcte.getAttribute("CCO_APPATERNO"),
                    CCO_APMATERNO: objcte.getAttribute("CCO_APMATERNO"),
                    CCO_TITULO: objcte.getAttribute("CCO_TITULO"),
                    CCO_NOSOCIO: objcte.getAttribute("CCO_NOSOCIO"),
                    CCO_ASOCIACION: objcte.getAttribute("CCO_ASOCIACION"),
                    CCO_CORREO: objcte.getAttribute("CCO_CORREO")
                };
                itemIdCob++;
                jQuery("#GRIDPARTICIPA").addRowData(itemIdCob, datarow, "last");
            }
        }});
}

function Vta_RazonSocial(strPost) {
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Historial.jsp?ID=6",
        success: function (datos) {
            jQuery("#CEV_GRID").clearGridData();
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    CEV_ID_FAC: objcte.getAttribute("CEV_ID"),
                    CEV_RAZONSOCIAL: objcte.getAttribute("CEV_NOMBRE"),
                    CEV_NUMERO: objcte.getAttribute("CEV_NUMERO"),
                    CEV_RFC: objcte.getAttribute("CEV_RFC"),
                    CEV_CALLE: objcte.getAttribute("CEV_CALLE"),
                    CEV_COLONIA: objcte.getAttribute("CEV_COLONIA"),
                    CEV_MUNICIPIO: objcte.getAttribute("CEV_MUNICIPIO"),
                    CEV_ESTADO: objcte.getAttribute("CEV_ESTADO"),
                    CEV_CP: objcte.getAttribute("CEV_CP"),
                    CEV_EMAIL1: objcte.getAttribute("CEV_EMAIL1"),
                    CEV_EMAIL2: objcte.getAttribute("CEV_EMAIL2"),
                    CEV_TELEFONO: objcte.getAttribute("CEV_TELEFONO")};
                itemIdFactDat++;
                jQuery("#CEV_GRID").addRowData(itemIdFactDat, datarow, "last");
            }
        }});
}
function doFacturaHistoricoVtas() {
    if (confirm("¿Desea guardar la venta?")) {
        var strPost = "";
        var grid = jQuery("#GRDIHVENTA");
        if (grid.getGridParam("selrow") != null) {
            var id = grid.getGridParam("selrow");
            var lstRow = grid.getRowData(id);
            strPost += "&SC_ID=" + lstRow.SC_ID + "";
            strPost += "&CT_ID=" + lstRow.CT_ID + "";
            strPost += "&FAC_FECHA=" + lstRow.PD_FECHA + "";
            strPost += "&FAC_FOLIO=" + lstRow.PD_FOLIO + "";
            strPost += "&FAC_TOTAL=" + lstRow.PD_TOTAL + "";
            strPost += "&FAC_NOTAS=";
            strPost += "&TKT_ID=" + lstRow.PD_ID + "";
            strPost += "&FAC_METODODEPAGO=" + lstRow.FAC_METODODEPAGO + "";
            strPost += "&FAC_NUMCUENTA=";
            strPost += "&FAC_FORMADEPAGO=NO IDENTIFICADO";
            if (lstRow.PD_FOLIO == 0) {
                alert("NO SE PUEDE RE-FACTURAR UNA FACTURA. SELECCIONE UN TICKET");
            } else {
                $.ajax({
                    type: "POST",
                    data: strPost,
                    scriptCharset: "utf-8",
                    contentType: "application/x-www-form-urlencoded;charset=utf-8",
                    cache: false,
                    dataType: "html",
                    url: "VtasMov.do?id=3",
                    success: function (dato) {
                        dato = trim(dato);
                        if (Left(dato, 3) == "OK.") {
                            var strHtml = CreaHidden("FAC_ID", dato.replace("OK.", ""));
                            openWhereverFormat("ERP_SendInvoice?id=" + dato.replace("OK.", ""), "FACTURA", "PDF", strHtml);
                        } else {
                            alert(dato);
                        }
                        $("#dialogWait").dialog("close");
                    }, error: function (objeto, quepaso, otroobj) {
                        alert(":ptotFact:" + objeto + " " + quepaso + " " + otroobj);
                        $("#dialogWait").dialog("close");
                    }});
            }
        } else {
            alert("Debe seleccionar un ticket");
        }
    }
}
function doFacturaHistoricoVtasCte() {
    if (confirm("¿Desea guardar la venta?")) {
        var strPost = "";
        var grid = jQuery("#H_VENTA_CTE");
        if (grid.getGridParam("selrow") != null) {
            var id = grid.getGridParam("selrow");
            var lstRow = grid.getRowData(id);
            if (lstRow.FAC_STATUS == "Cancelada") {
                alert("Este documento no se puede pagar, ya ha sido cancelado!");
            } else {
                strPost += "SC_ID=" + lstRow.SC_ID + "";
                strPost += "&CT_ID=" + lstRow.CT_ID + "";
                strPost += "&FAC_FECHA=" + lstRow.PD_FECHA + "";
                strPost += "&TKT_ID=" + lstRow.PD_ID + "";
                if (lstRow.DOC_TIPO == "FAC") { //tipo de documento para la validacion
                    alert("NO SE PUEDE RE-FACTURAR UNA FACTURA. SELECCIONE UN TICKET");
                } else {
                    strPost += "&FAC_TOTAL=" + document.getElementById("CEV_SUB3").value;
                    strPost += "&FAC_NOTAS=" + document.getElementById("CEV_COMENTARIO").value;
                    strPost += "&FAC_METODODEPAGO=" + document.getElementById("CEV_DESCRIPCION").value;
                    $.ajax({
                        type: "POST",
                        data: strPost,
                        scriptCharset: "utf-8",
                        contentType: "application/x-www-form-urlencoded;charset=utf-8",
                        cache: false,
                        dataType: "html",
                        url: "VtasMov.do?id=3",
                        success: function (dato) {
                            dato = trim(dato);
                            if (Left(dato, 3) == "OK.") {
                                var strHtml = CreaHidden("FAC_ID", dato.replace("OK.", ""));
                                openWhereverFormat("ERP_SendInvoice?id=" + dato.replace("OK.", ""), "FACTURA", "PDF", strHtml);
                            } else {
                                alert(dato);
                            }
                            $("#dialogWait").dialog("close");
//                            vtaPagarCurso(); //pagar curso y mandar material de descarga, si aplica
                        }, error: function (objeto, quepaso, otroobj) {
                            alert(":ptotFact:" + objeto + " " + quepaso + " " + otroobj);
                            $("#dialogWait").dialog("close");
                        }});
                }
            }
        } else {
            alert("Debe seleccionar un ticket");
        }
    }
}
function ValidaRFC() {
    var strRFC = document.getElementById("CEV_RFC").value;
    if (strRFC != "") {
        var bolExpReg = _EvalExpRegCOFIDE1(strRFC, "^[A-Z,Ñ,&,a-z,ñ]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,Ñ,&,0-9,a-z]{3}");
        if (!bolExpReg) {
            alert("El formato del registro federal de contribuyentes es incorrecto");
            document.getElementById("CEV_RFC").focus();
        }
    }
}
function vtaPagarCurso() { //pagar curso al momento de facturarlo
    if (document.getElementById("CT_NO_CLIENTE").value != "0" && document.getElementById("CT_NO_CLIENTE").value != "") {
        var grid = jQuery("#GRDIHVENTA");
        if (grid.getGridParam("selrow") != null) {
            var lstRow = grid.getRowData(grid.getGridParam("selrow"));
            var strFAC_ID = 0;
            var strTKT_ID = 0;
            var DOC_TOTAL = 0;
            var TIPO_DOC = "";
            var strFechaDoc = "";
            var ID_tkt_fac = "";
            if (lstRow.FAC_STATUS == "Activa") {
                if (lstRow.FAC_PAGADO == "Pendiente") {
                    DOC_TOTAL = lstRow.PD_TOTAL;
                    TIPO_DOC = lstRow.DOC_TIPO;
                    strFAC_ID = lstRow.FAC_ID;
                    strTKT_ID = lstRow.PD_FOLIO;
                    strFechaDoc = lstRow.PD_FECHA;
                    $("#dialogPagos").dialog("open");
                    var idCliente = document.getElementById("CT_NO_CLIENTE").value;
                    var dblAnticipo = DOC_TOTAL;
                    var intMonedaBanco = 1; //document.getElementById("BCO_MONEDA").value;
                    var dblTasaCambio = 1; //document.getElementById("PARIDAD").value;
                    var intBancoID = 1; //document.getElementById("BC_ID").value;
                    if (TIPO_DOC == 1) { //0=ticket & 1= factura
                        ID_tkt_fac = strFAC_ID;
                    } else {
                        ID_tkt_fac = strTKT_ID;
                    }
//                var strPOST = "&idTrx=" + strFAC_ID;
                    var strPOST = "&idTrx=" + ID_tkt_fac;
                    strPOST += "&COUNT_PAGOS=" + 0;
                    strPOST += "&TipoDoc=" + TIPO_DOC;
                    strPOST += "&FECHA=" + strFechaDoc;
                    strPOST += "&NOTAS=" + "";
                    strPOST += "&MONEDA=" + intMonedaBanco;
                    strPOST += "&TASAPESO=" + dblTasaCambio;
                    strPOST += "&MONTOPAGO=" + dblAnticipo;
                    strPOST += "&BC_ID=" + intBancoID;
                    strPOST += "&IdCte=" + idCliente;
                    strPOST += "&intAnticipo=" + 1;
                    $.ajax({
                        type: "POST",
                        data: encodeURI(strPOST),
                        scriptCharset: "utf-8",
                        contentType: "application/x-www-form-urlencoded;charset=utf-8",
                        cache: false,
                        dataType: "html",
                        url: "ERP_Cobros.jsp?id=1",
                        success: function (dato) {
                            if (Left(dato, 3) == "OK.") {
                                //envio de mail
                                $.ajax({
                                    type: "POST",
                                    data: "fac_id=" + ID_tkt_fac + "&tipo_doc=" + TIPO_DOC,
                                    scriptCharset: "utf-8",
                                    contentType: "application/x-www-form-urlencoded;charset=utf-8",
                                    cache: false,
                                    dataType: "xml",
                                    url: "COFIDE_Telemarketing_vta.jsp?ID=9",
                                });
                                //envio de mail
                                consultaHistoricoVtas(); //recarga pantalla
                                $("#dialogPagos").dialog("close");
                            } else {
                                alert(dato);
                            }
                            $("#dialogWait").dialog("close");
                        },
                        error: function (objeto, quepaso, otroobj) {
                            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
                            $("#dialogWait").dialog("close");
                        }
                    });
                } else {
                    alert("Este Documento ya ha sido pagado");
                }
            } else {
                alert("Este Documento No se puede pagar, porque a sido cancelado");
            }
        } else {
            alert("Debe seleccionar una partida en la tabla \"HISTORIAL DE VENTAS\"");
        }
    } else {
        alert("Debe seleccionar un Cliente");
    }
}