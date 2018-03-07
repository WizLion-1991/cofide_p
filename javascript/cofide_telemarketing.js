function cofide_telemarketing() {
}
var itemIdCob = 1;
var lastselBco = 0;
var itemIdVta = 0; //historial de ventas
var intContaPendiente = 0;
var lstElemPendiente = new Array();
var timTimer;
function hideContactosTMK() {
    document.getElementById("CCO_NOMBRE").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_APPATERNO").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_APMATERNO").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_TITULO").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_NOSOCIO").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_AREA").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_ASOCIACION").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_CORREO").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_CORREO2").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_TELEFONO").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_EXTENCION").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_ALTERNO").parentNode.parentNode.style.display = "none";
    document.getElementById("CT_MAILMES2").parentNode.parentNode.style.display = "none";
    document.getElementById("CCO_NOMBRE").value = "";
    document.getElementById("CCO_APPATERNO").value = "";
    document.getElementById("CCO_APMATERNO").value = "";
    document.getElementById("CCO_TITULO").value = "";
    document.getElementById("CCO_NOSOCIO").value = "";
    document.getElementById("CCO_AREA").value = "";
    document.getElementById("CCO_ASOCIACION").value = "";
    document.getElementById("CCO_CORREO").value = "";
    document.getElementById("CCO_CORREO2").value = "";
    document.getElementById("CCO_TELEFONO").value = "";
    document.getElementById("CCO_EXTENCION").value = "";
    document.getElementById("CCO_ALTERNO").value = "";
    document.getElementById("CT_MAILMES2").value = "";
    document.getElementById("CT_FECHA").value = "";
    document.getElementById("CT_HORA").value = "";
    document.getElementById("CT_COMENTARIOS").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_ADD").parentNode.parentNode.style.display = "none";
    document.getElementById("BTN_CANCEL").parentNode.parentNode.style.display = "none";
    document.getElementById("BTN_NEW").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_DEL").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_RNEW").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_REDIT").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_RDEL").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_RCANCEL").parentNode.parentNode.style.display = "none";
    document.getElementById("BTN_RSAVE").parentNode.parentNode.style.display = "none";
    document.getElementById("CT_ADDRZN").parentNode.parentNode.style.display = "none";
}
function initTelem() {
    myLayout.close("west");
    myLayout.close("east");
    myLayout.close("south");
    myLayout.close("north");
    selectBaseCliente();
    hideContactosTMK();
    consultaVta();
    checkInBound();
    document.getElementById("CT_ESTATUS").value = "DISPONIBLE"; //inicia disponible
}
function initTelemINB() {
    myLayout.close("west");
    myLayout.close("east");
    myLayout.close("south");
    myLayout.close("north");
    hideContactosTMK();
    consultaVta();
    document.getElementById("CT_ESTATUS").value = "DISPONIBLE"; //inicia disponible
}
function HtmlBoton(bolBase, telefono, correo, isValid) {
    if (isValid) {
        if (bolBase == "false") {
            var strHtmlCall = "<table align='center'>"
                    + "<tr>"
//                    + '<td class= \'cofide_llamada\'><div id="llamar"><a href="sip:' + telefono + '" onclick="reg_llam(&quot;' + telefono + '&quot;);"><i class = "fa fa-headphones" style="font-size:40px;"></i></a></div></td>'
                    + '<td><a href="javascript:reg_llam()" class= \'cofide_llamada\'><i class = "fa fa-headphones" title="Llamar" style="font-size:40px;"></i></td>'
                    + "<td>&nbsp;</td>"
                    + "<td class= 'cofide_message'><a href=\"mailto:"
                    + correo + '?Subject=Estimado%20" target="_top"><i class = "fa fa-envelope-o" style="font-size:40px"></i></a></td>'
                    + "<td>&nbsp;</td>"
                    + "</tr>";
            "</table>";
            var strHtmlTitle = "<table border='0' width='0%' align='center'>"
                    + "<tr>"
                    + '<td><a href="javascript:OpnMotorBusqueda()" class=\'cofide_search\'><i class = "fa fa-search-plus" title="Motor de Busqueda" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:tmp_Guardar()" class=\'cofide_changei\'><i class = "fa fa-step-forward" title="Cambiar Llamada" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnDiagHCall()" class=\'cofide_histl\'><i class = "fa fa-clock-o" title="Historial de Llamadas" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnDiagNVenta()" class=\'cofide_venta\'><i class = "fa fa-cart-plus" title="Ventas" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnDiagHVenta()" class=\'cofide_histv\'><i class = "fa fa-money" title="Historial de Ventas" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnEdoCtaCte()" class=\'cofide_edo_cta\'><i class = "fa fa-usd" title="Estado de Cuenta" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnDiagCActivo()" class=\'cofide_calcurso\'><i class = "fa fa-calendar" title="Calendario de Cursos" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:SendMailContacto()" class=\'cofide_message\'><i class = "fa fa-at" title="Mail Group"style="font-size:40px; width: 110px"></i></a></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:saveDetaTMK()" class=\'cofide_guarda\'><i class = "fa fa-floppy-o" title="Guardar Cambios" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnPausarLlamada()" class=\'cofide_pausa\'><i class = "fa fa-pause" title="Pausar Llamada" style="font-size:30px; width:110px"></i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnSalirLlamada()" class=\'cofide_salida\'><i class = "fa fa-sign-out" title="Salir"  style="font-size:30px; width:110px"></i></td>'
                    + "</tr>";
            "</table>";
            document.getElementById("CT_TITLEBTN").innerHTML = strHtmlTitle;
            document.getElementById("CT_CALLBTN").innerHTML = strHtmlCall;
        } else {
            if (bolBase == "true") {
                var strHtmlCall = "<table align='center'>"
                        + "<tr>"
//                        + '<td class= \'cofide_llamada\'><div id="llamar"><a href="sip:' + telefono + '" onclick="reg_llam(&quot;' + telefono + '&quot;);"><i class = "fa fa-headphones" style="font-size:40px;"></i></a></div></td>'
                        + '<td><a href="javascript:reg_llam()" class= \'cofide_llamada\'><i class = "fa fa-headphones" title="Llamar" style="font-size:40px;"></i></td>'
                        + "<td>&nbsp;</td>"
                        + "<td class= 'cofide_message'><a href=\"mailto:" + correo + '?Subject=Estimado%20" target="_top"><i class = "fa fa-envelope-o" style="font-size:40px"></i></a></td>'
                        + "<td>&nbsp;</td>"
                        + "</tr>";
                "</table>";
                var strHtmlTitle = "<table border='0' width='0%' align='center'>"
                        + "<tr>"
                        + '<td><a href="javascript:OpnMotorBusqueda()" class=\'cofide_search\'><i class = "fa fa-search-plus" title="Motor de Busqueda" style="font-size:30px; width:110px"></i></td>'
                        + "<td>&nbsp;</td>"
                        + '<td><a href="javascript:OpnDiagNVenta()" class=\'cofide_venta\'><i class = "fa fa-cart-plus" title="Ventas" style="font-size:30px; width:110px">&nbsp; VENTAS</i></td>'
                        + "<td>&nbsp;</td>"
                        + '<td><a href="javascript:OpnDiagCActivo()" class=\'cofide_calcurso\'><i class = "fa fa-calendar" title="Calendario de Cursos" style="font-size:30px; width:110px"></i></td>'
                        + "<td>&nbsp;</td>"
                        + '<td><a href="javascript:saveDetaTMK()" class=\'cofide_guarda\'><i class = "fa fa-floppy-o" title="Guardar Cambios" style="font-size:30px; width:110px"></i></td>'
                        + "<td>&nbsp;</td>"
                        + '<td><a href="javascript:SendMailContacto()" class=\'cofide_message\'><i class = "fa fa-at" title="Mail Group"style="font-size:40px; width: 110px"></i></a></td>'
                        + "<td>&nbsp;</td>"
                        + '<td><a href="javascript:DelCteBase()" class=\'cofide_borrar\'><i class = "fa fa-recycle" style="font-size:30px; width:110px">&nbsp; BORRAR</i></td>'
                        + "<td>&nbsp;</td>"
                        + '<td><a href="javascript:OpnPausarLlamada()" class=\'cofide_pausa\'><i class = "fa fa-pause" title="Pausar Llamada"  style="font-size:30px; width:110px"></i></td>'
                        + "<td>&nbsp;</td>"
                        + '<td><a href="javascript:OpnSalirLlamada()" class=\'cofide_salida\'><i class = "fa fa-sign-out" title="Salir" style="font-size:30px; width:110px"></i></td>'
                        + "</tr>";
                "</table>";
                document.getElementById("CT_TITLEBTN").innerHTML = strHtmlTitle;
                document.getElementById("CT_CALLBTN").innerHTML = strHtmlCall;
            }
        }
    } else {
        var strHtmlCall = "";
        var strHtmlTitle = "<table border='0' width='0%' align='center'>"
                + "<tr>"
                + "<td>&nbsp;</td>"
                + "<tr>"
                + '<td><a href="javascript:OpnMotorBusqueda()" class=\'cofide_search\'><i class = "fa fa-search-plus" title="Motor de Busqueda" style="font-size:30px; width:110px"></i></td>'
                + "<td>&nbsp;</td>"
                + '<td><a href="javascript:OpnSearchCustomer()" class=\'Prospecto\'><i class = "fa fa-user" title="Buscar Prospectos" style="font-size:30px; width:30px"></i></td>'
                + "<td>&nbsp;</td>"
                + '<td><a href="javascript:OpnSearchCustomer2()" class=\'ExParticipante\'><i class = "fa fa-user" title="Buscar Ex-Participantes" style="font-size:30px; width:110px"></i></td>'
                + "<td>&nbsp;</td>"
                + "</tr>";
        "</table>";
        document.getElementById("CT_TITLEBTN").innerHTML = strHtmlTitle;
        document.getElementById("CT_CALLBTN").innerHTML = strHtmlCall;
    }
    //drawRightPanel();
    var strHtmlBTN = "<center><table border='0' width='0%' align='center'>" //botones de agregar nuevo cliente, error en base, actualizar 
            + "<tr>"
            + "<td>&nbsp;</td>"
            + "<tr>"
            + '<td><a href="javascript:OpnNewCte()" class=\'cofide_venta\'><i class = "fa fa-user-plus" title="Agregar Prospecto" style="font-size:50px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:errorbase()" class=\'cofide_err\'><i class = "fa fa-trash" title="Error en Base" style="font-size:50px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:UpDateCte()" class=\'updatecte\'><i class = "fa fa-refresh" title="Actualiza Cliente" style="font-size:50px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + "</tr>";
    "</table></center>";
    document.getElementById("btnadd").innerHTML = strHtmlBTN; //botones de marcar y mandar email
    var strHtmlBtnCall = "<table border='0' width='0%' align='center'>"
            + "<tr>"
            + '<td><a href="javascript:LlamarContacto()" class=\'cofide_llamada\'><i class = "fa fa-headphones" title="llamar" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:SendMailContacto()" class=\'cofide_message\'><i class = "fa fa-envelope-o" title="Envio" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + "</tr>";
    "</table>";
    document.getElementById("CALLBTN2").innerHTML = strHtmlBtnCall;
}
function reg_llam() {
    document.getElementById("CT_BOLCALL").value = "1";
    LlamadaOK();
    //aqui ira el metodo para mandar la llamada al PBX
}
function _resetLlamadas() {
    document.getElementById("CT_ID_CLIENTE").value = "0";
    document.getElementById("CT_CLAVEBD").value = "";
    document.getElementById("CT_BDANTERIOR").value = "0";
    document.getElementById("CT_ID").value = "0";
    document.getElementById("CT_NO_CLIENTE").value = "0";
    document.getElementById("CT_RAZONSOCIAL").value = "";
    document.getElementById("CT_RFC").value = "";
    document.getElementById("CT_CONTACTO").value = "";
    document.getElementById("CT_CONTACTO2").value = "";
    document.getElementById("CT_CONMUTADOR").value = "";
    document.getElementById("CT_CORREO").value = "";
    document.getElementById("CT_CORREO2").value = "";
    document.getElementById("CCO_NOMBRE").value = "";
    document.getElementById("CCO_APPATERNO").value = "";
    document.getElementById("CCO_APMATERNO").value = "";
    document.getElementById("CCO_TITULO").value = "";
    document.getElementById("CCO_NOSOCIO").value = "";
    document.getElementById("CCO_CORREO").value = "";
    document.getElementById("CCO_CORREO2").value = "";
    document.getElementById("CCO_TELEFONO").value = "";
    document.getElementById("CCO_EXTENCION").value = "";
    document.getElementById("CCO_ALTERNO").value = "";
    document.getElementById("CT_RAZONSOCIAL2").value = "";
    document.getElementById("CT_ID_CLIENTE2").value = "";
    document.getElementById("CT_RAZONSOCIAL3").value = "";
    document.getElementById("CT_ID_CLIENTE3").value = "";
    document.getElementById("CT_RAZONSOCIAL4").value = "";
    document.getElementById("CT_ID_CLIENTE4").value = "";
    document.getElementById("CT_RAZONSOCIAL5").value = "";
    document.getElementById("CT_ID_CLIENTE5").value = "";
    document.getElementById("CT_HORA").value = "";
    document.getElementById("CT_COMENTARIOS").value = "";
    document.getElementById("CT_COMENTARIO").value = "";
    document.getElementById("CT_RAZONSOCIAL2").value = "";
    document.getElementById("CT_BOLCALL").value = "0";
    document.getElementById("CT_SEDE").value = "";
    document.getElementById("CT_GIRO").value = "";
    document.getElementById("CT_AREA").value = "";
    document.getElementById("CCO_AREA").value = "";
    document.getElementById("CCO_ASOCIACION").value = "";
    document.getElementById("CT_FECHA").value = "";
    document.getElementById("CT_BOLBASE").value = "";
    document.getElementById("CT_COL").value = "";
    document.getElementById("CT_CALLE").value = "";
    document.getElementById("CT_EDO").value = "";
    document.getElementById("CT_MUNI").value = "";
    document.getElementById("CT_NUM").value = "";
    document.getElementById("CT_CP").value = "";
    document.getElementById("CT_LADA").value = "";
    document.getElementById("CT_MAILMES").checked = false;
    document.getElementById("CT_CONTACTO_ENTRADA").value = "";
}
function consultaVta(idCte) {
    var strRespuesta = "";
    var strMensaje = "";
    document.getElementById("CT_RESPOND").value = ""; //inicia limpia la llamada!
    $("#tabsC_TELEM").tabs("option", "active", 0);
    _resetLlamadas();
//    setTimeout("llenarColonia()", 1000);
    var strPost = "";
    if (idCte != null) {
        strPost = "cte_manual=" + idCte;
    }
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=1",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                llenarColonia();
                var objcte = lstCte[i];
                if (objcte.getAttribute("CT_ID") != 0) {
                    document.getElementById("CT_ID").value = objcte.getAttribute("CT_ID");
                    document.getElementById("CT_ID_CLIENTE").value = objcte.getAttribute("CT_ID_CLIENTE");
                    document.getElementById("CT_RAZONSOCIAL").value = objcte.getAttribute("CT_RAZONSOCIAL");
                    document.getElementById("CT_NO_CLIENTE").value = objcte.getAttribute("CT_ID");
                    document.getElementById("CT_RFC").value = objcte.getAttribute("CT_RFC");
                    document.getElementById("CT_COL").value = objcte.getAttribute("CT_COLONIA");
                    document.getElementById("CT_CONTACTO").value = objcte.getAttribute("CT_TELEFONO1");
                    document.getElementById("CT_CONTACTO2").value = objcte.getAttribute("CT_TELEFONO2");
                    document.getElementById("CT_CORREO").value = objcte.getAttribute("CT_EMAIL1");
                    document.getElementById("CT_CORREO2").value = objcte.getAttribute("CT_EMAIL2");
                    document.getElementById("CT_BOLBASE").value = objcte.getAttribute("bolBase");
                    document.getElementById("CT_HORA_INI").value = objcte.getAttribute("HoraInicial");
                    document.getElementById("CT_CP").value = objcte.getAttribute("CT_CP");
                    document.getElementById("CT_COL").value = objcte.getAttribute("CT_COL");
                    document.getElementById("CT_COLONIA_DB").value = objcte.getAttribute("CT_COL");
                    document.getElementById("CT_CALLE").value = objcte.getAttribute("CT_CALLE");
                    document.getElementById("CT_EDO").value = objcte.getAttribute("CT_EDO");
                    document.getElementById("CT_MUNI").value = objcte.getAttribute("CT_MUNI");
                    document.getElementById("CT_NUM").value = objcte.getAttribute("CT_NUMERO");
                    document.getElementById("CT_SEDE").value = objcte.getAttribute("CT_SEDE");
                    document.getElementById("CT_GIRO").value = objcte.getAttribute("CT_GIRO");
                    document.getElementById("CT_AREA").value = objcte.getAttribute("CT_AREA");
                    document.getElementById("CT_COMENTARIO").value = objcte.getAttribute("EV_ASUNTO");
                    document.getElementById("CT_ID_LLAMADA").value = objcte.getAttribute("id_llamada");
                    document.getElementById("CT_CONMUTADOR").value = objcte.getAttribute("CT_CONMUTADOR");
                    document.getElementById("CT_CONTACTO_ENTRADA").value = objcte.getAttribute("CT_CONTACTO");
                    //ex participante
                    if (objcte.getAttribute("cte_prosp") == "0") { //verde
                        document.getElementById("exp_pro").value = 0;
                        document.getElementById("CT_CTE").innerHTML = "<table>"
                                + "<tr>"
                                + '<td class=\'ExParticipante\'><i class = "fa fa-user" title="EX-Participante" style="font-size:55px;"></i></td>'
                                + "</tr>"
                                + "</table>";
                    } else { //gris
                        document.getElementById("exp_pro").value = 1;
                        document.getElementById("CT_CTE").innerHTML = "<table>"
                                + "<tr>"
                                + '<td class=\'Prospecto\'><i class = "fa fa-user" title="Prospecto" style="font-size:55px;"></i></td>'
                                + "</tr>"
                                + "</table>";
                    }
                    var bolMail = false;
                    if (objcte.getAttribute("envio_mail") == 1) {
                        bolMail = true;
                    }
                    document.getElementById("CT_MAILMES").checked = bolMail;
                    strRespuesta = objcte.getAttribute("Respuesta");
                    strMensaje = objcte.getAttribute("Mensaje");
                    HtmlBoton(objcte.getAttribute("bolBase"), objcte.getAttribute("CT_TELEFONO1"), objcte.getAttribute("CT_EMAIL1"), true);
                    LoadContacto(document.getElementById("CT_NO_CLIENTE").value);
                    var intInBound = document.getElementById("CT_CLAVE_DDBB").value;
                    var intPermisoInBound = document.getElementById("CT_PERMISO_INBOUND").value;

                    if (intPermisoInBound == 0) {
                        if (intInBound == "INBOUND" && objcte.getAttribute("CT_CLAVEDDBB") != "INBOUND") {
                            blockDatosInBound();
                            hiddeFunctionInboundSave();
                        } else {
                            UnlockDatosInBound();
                            showBtnSaveInBound();
                        }
                    } else {
                        UnlockDatosInBound();
                        showBtnSaveInBound();
                    }
                } else {
                    HtmlBoton("false", "", "", false);
                }
            }
            if (strRespuesta == "true") {
                alert(strRespuesta + ": " + strMensaje); //es el mensaje de cuando hacen la llamada OKs
                clearTimeout(timTimer);
                Timer();
            } else {
                clearTimeout(timTimer);
                Timer();
            }
        }});
    document.getElementById("BTN_ADD").parentNode.parentNode.style.display = "none";
    document.getElementById("BTN_CANCEL").parentNode.parentNode.style.display = "none";
    document.getElementById("BTN_NEW").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_DEL").parentNode.parentNode.style.display = "";
    document.getElementById("CT_COMENTARIO").value = ""; //limpia comentario despues de guardar
    drawRightPanel();
}
function limpiarTodo() {
    myLayout.open("west");
    myLayout.open("east");
    myLayout.open("south");
    myLayout.open("north");
    document.getElementById("MainPanel").innerHTML = "";
    document.getElementById("rightPanel").innerHTML = "";
    var objMainFacPedi = objMap.getScreen("C_TELEM");
    objMainFacPedi.bolActivo = false;
    objMainFacPedi.bolMain = false;
    objMainFacPedi.bolInit = false;
    objMainFacPedi.idOperAct = 0;
}
function newTelem(opc) {
    if (opc == 1) {
        document.getElementById("CCO_NOMBRE").value = "";
        document.getElementById("CCO_APPATERNO").value = "";
        document.getElementById("CCO_APMATERNO").value = "";
        document.getElementById("CCO_TITULO").value = "";
        document.getElementById("CCO_NOSOCIO").value = "";
        document.getElementById("CCO_AREA").value = "";
        document.getElementById("CCO_ASOCIACION").value = "";
        document.getElementById("CCO_CORREO").value = "";
        document.getElementById("CCO_CORREO2").value = "";
        document.getElementById("CCO_TELEFONO").value = "";
        document.getElementById("CCO_EXTENCION").value = "";
        document.getElementById("CCO_ALTERNO").value = "";
        document.getElementById("CT_MAILMES2").value = "";
        //limpia campos
        if (intRow() < 20) {
            document.getElementById("CCO_NOMBRE").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_APPATERNO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_APMATERNO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_TITULO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_NOSOCIO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_AREA").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_ASOCIACION").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_CORREO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_CORREO2").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_TELEFONO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_EXTENCION").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_ALTERNO").parentNode.parentNode.style.display = "";
            document.getElementById("BTN_ADD").parentNode.parentNode.style.display = "";
            document.getElementById("CT_MAILMES2").parentNode.parentNode.style.display = "";
            document.getElementById("CT_MAILMES2").checked = false;
            document.getElementById("BTN_CANCEL").parentNode.parentNode.style.display = "";
            document.getElementById("BTN_NEW").parentNode.parentNode.style.display = "none";
            document.getElementById("BTN_DEL").parentNode.parentNode.style.display = "none";
        } else {
            alert("Ya llegaste a los 20 contactos permitidos");
        }
    }
    if (opc == 2) {
        document.getElementById("BTN_RNEW").parentNode.parentNode.style.display = "none";
        document.getElementById("BTN_REDIT").parentNode.parentNode.style.display = "none";
        document.getElementById("BTN_RDEL").parentNode.parentNode.style.display = "none";
        document.getElementById("BTN_RCANCEL").parentNode.parentNode.style.display = "";
        document.getElementById("BTN_RSAVE").parentNode.parentNode.style.display = "";
        document.getElementById("CT_ADDRZN").parentNode.parentNode.style.display = "";
        document.getElementById("CT_ADDRZN").value = "";
    }
}
function cancelTelem(opc) {
    if (opc == 1) {
        if (document.getElementById("CCO_NOMBRE").value != "" && document.getElementById("CCO_CORREO").value != "") {
            var datarow = {
                CCO_NOMBRE: document.getElementById("CCO_NOMBRE").value,
                CCO_APPATERNO: document.getElementById("CCO_APPATERNO").value,
                CCO_APMATERNO: document.getElementById("CCO_APMATERNO").value,
                CCO_TITULO: document.getElementById("CCO_TITULO").value,
                CCO_NOSOCIO: document.getElementById("CCO_NOSOCIO").value,
                CCO_AREA: document.getElementById("CCO_AREA").value,
                CCO_ASOCIACION: document.getElementById("CCO_ASOCIACION").value,
                CCO_CORREO: document.getElementById("CCO_CORREO").value,
                CCO_CORREO2: document.getElementById("CCO_CORREO2").value,
                CCO_TELEFONO: document.getElementById("CCO_TELEFONO").value,
                CCO_EXTENCION: document.getElementById("CCO_EXTENCION").value,
                CCO_ALTERNO: document.getElementById("CCO_ALTERNO").value,
                CT_MAILMES2: document.getElementById("CT_MAILMES2").checked
            };
            jQuery("#GRIDCONTACTOS").addRowData(itemIdCob, datarow, "last");
        }
        document.getElementById("CCO_NOMBRE").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_APPATERNO").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_APMATERNO").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_TITULO").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_NOSOCIO").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_AREA").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_ASOCIACION").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_CORREO").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_CORREO2").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_TELEFONO").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_EXTENCION").parentNode.parentNode.style.display = "none";
        document.getElementById("CCO_ALTERNO").parentNode.parentNode.style.display = "none";
        document.getElementById("BTN_ADD").parentNode.parentNode.style.display = "none";
        document.getElementById("CT_MAILMES2").parentNode.parentNode.style.display = "none";
        document.getElementById("BTN_CANCEL").parentNode.parentNode.style.display = "none";
//    document.getElementById("CALLBTN2").parentNode.parentNode.style.display = "none"; //ocultar los botones de llamar y mensaje
        document.getElementById("BTN_NEW").parentNode.parentNode.style.display = "";
        document.getElementById("BTN_DEL").parentNode.parentNode.style.display = "";
    }
    if (opc == 2) {
        var strRzn = document.getElementById("CT_ADDRZN").value;
        if (strRzn != "") {
            var datarow = {
                RZN_ID: intRowRzn() + 1,
                RZN_NOMBRE: strRzn
            };
        }
        document.getElementById("CT_ADDRZN").value = "";
        LimpiarGrid(opc);
        hideContactosTMK();
        itemIdCob++;
        jQuery("#GRD_RZN").addRowData(itemIdCob, datarow, "last");
    }
}
function addGridTMK(opc) {
    if (opc == 1) {
        //Validamo aca correo existente
        var boolContacto = 0;
        var boolCorreo = 0;
        var boolNoSocio = 0;
        var intOK = 0;
        if (document.getElementById("CCO_NOMBRE").value != "") {
            boolContacto = 1;
        } else {
            alert("Capture el Nombre del Contacto");
        }
        if (document.getElementById("CCO_CORREO").value != "" || document.getElementById("CCO_TELEFONO").value != "") {
            boolCorreo = 1;
        } else {
            boolCorreo = 0;
            //Regresamos mensaje para decir que campo viene vacio       
            if (document.getElementById("CCO_CORREO").value == "") {
                alert("Capture el Correo del Contacto");
            } else {
                alert("Capture el Telefono del Contacto");
            }
        }
        if (document.getElementById("CCO_ASOCIACION").value == "CCPM" || document.getElementById("CCO_ASOCIACION").value == "AMCP") {
            if (document.getElementById("CCO_NOSOCIO").value.length == 4 || document.getElementById("CCO_NOSOCIO").value.length == 5) {
                if (document.getElementById("CCO_NOSOCIO").value == "0000") {
                    intOK = 0;
                } else if (document.getElementById("CCO_NOSOCIO").value == "00000") {
                    intOK = 0;
                } else {
                    intOK = 1;
                    boolNoSocio = 1;
                }
            } else {
                alert("El Numero de Socio no es Valido");
            }
        } else {
            boolNoSocio = 1;
        }
        if (boolContacto == 1 && boolCorreo == 1 && boolNoSocio == 1) {
            var strNombre = document.getElementById("CCO_NOMBRE").value;
            var strApPat = document.getElementById("CCO_APPATERNO").value;
            var strApMat = document.getElementById("CCO_APMATERNO").value;
            var strTitulo = document.getElementById("CCO_TITULO").value;
            var strSocio = document.getElementById("CCO_NOSOCIO").value;
            var strArea = document.getElementById("CCO_AREA").value;
            var strAsociacion = document.getElementById("CCO_ASOCIACION").value;
            var strCorreo = document.getElementById("CCO_CORREO").value;
            var strCorreo2 = document.getElementById("CCO_CORREO2").value;
            var strTelefono = document.getElementById("CCO_TELEFONO").value;
            var strExt = document.getElementById("CCO_EXTENCION").value;
            var strAlt = document.getElementById("CCO_ALTERNO").value;
            var bolMail = document.getElementById("CT_MAILMES2").checked;
            var intMail = 0;
            if (bolMail == true) {
                intMail = 1;
            }
//            if (intRow() < 21) {
            if (strCorreo != "") {
                var datarow = {
                    CCO_ID: intRow() + 1,
                    CCO_NOMBRE: strNombre,
                    CCO_APPATERNO: strApPat,
                    CCO_APMATERNO: strApMat,
                    CCO_TITULO: strTitulo,
                    CCO_NOSOCIO: strSocio,
                    CCO_AREA: strArea,
                    CCO_ASOCIACION: strAsociacion,
                    CCO_CORREO: strCorreo,
                    CCO_CORREO2: strCorreo2,
                    CCO_TELEFONO: strTelefono,
                    CCO_EXTENCION: strExt,
                    CCO_ALTERNO: strAlt,
                    CT_MAILMES2: intMail
                };
                beforeAddContacMail1(3, datarow);

//            LimpiarGrid(opc);
//            hideContactosTMK();
////            } else {
////                alert("El Limite son 20 Contactos");
////            }
//            itemIdCob++;
//            jQuery("#GRIDCONTACTOS").addRowData(itemIdCob, datarow, "last");
            }
        }
    }
    if (opc == 2) {
        var intCT_ID = document.getElementById("CT_ID").value;
        var strRzn = document.getElementById("CT_ADDRZN").value;
        if (strRzn != "") {
            var datarow = {
                RZN_ID: intRowRzn() + 1,
                RZN_CTE: intCT_ID,
                RZN_NOMBRE: strRzn
            };
            LimpiarGrid(opc);
            hideContactosTMK();
            itemIdCob++;
            jQuery("#GRD_RZN").addRowData(itemIdCob, datarow, "last");
        } else {
            alert("Ingresa Una razon social");
        }
    }
}
function intRow() {
    var intRow;
    var grid = jQuery("#GRIDCONTACTOS");
    var idArr = grid.getDataIDs();
    intRow = idArr.length;
    document.getElementById("GRIDCONTACTOS").value = intRow;
    return intRow;
}
function intRowRzn() {
    var intRow;
    var grid = jQuery("#GRD_RZN");
    var idArr = grid.getDataIDs();
    intRow = idArr.length;
    document.getElementById("GRD_RZN").value = intRow;
    return intRow;
}
function delGridTMK(opc) {
    var grid = "";
    if (opc == 1) {
        grid = jQuery("#GRIDCONTACTOS");
        if (grid.getGridParam("selrow") != null) {
            grid.delRowData(grid.getGridParam("selrow"));
        } else {
            alert("Selecciona un contacto");
        }
    }
    if (opc == 2) {
        grid = jQuery("#GRD_RZN");
        if (grid.getGridParam("selrow") != null) {
            grid.delRowData(grid.getGridParam("selrow"));
        } else {
            alert("Selecciona una razon social");
        }
    }
}
function LimpiarGrid(opc) {
    if (opc == 1) {
        document.getElementById("CCO_NOMBRE").value = "";
        document.getElementById("CCO_APPATERNO").value = "";
        document.getElementById("CCO_APMATERNO").value = "";
        document.getElementById("CCO_TITULO").value = "";
        document.getElementById("CCO_NOSOCIO").value = "";
        document.getElementById("CCO_AREA").value = "";
        document.getElementById("CCO_ASOCIACION").value = "";
        document.getElementById("CCO_CORREO").value = "";
        document.getElementById("CCO_CORREO2").value = "";
        document.getElementById("CCO_TELEFONO").value = "";
        document.getElementById("CCO_EXTENCION").value = "";
        document.getElementById("CCO_ALTERNO").value = "";
    }
    if (opc == 2) {
        document.getElementById("CT_ADDRZN").value = "";
    }
}
function saveDetaTMK() {
//DelContacto(document.getElementById("CT_ID").value);//
    var strFecha = document.getElementById("CT_FECHA").value;
    strFecha = trim(strFecha);
    strFecha = strFecha.substring(6, 10) + strFecha.substring(3, 5) + strFecha.substring(0, 2);
    if (document.getElementById("CT_COMENTARIOS").value != "") {
        if (document.getElementById("CT_FECHA").value != "" && document.getElementById("CT_HORA").value != "") {

            var strPost = "";
            strPost += "CT_ID=" + document.getElementById("CT_ID").value;
            strPost += "&CT_NO_CLIENTE=" + document.getElementById("CT_ID").value;
            strPost += "&CT_RAZONSOCIAL=" + encodeURIComponent(document.getElementById("CT_RAZONSOCIAL").value);
            strPost += "&CT_RFC=" + document.getElementById("CT_RFC").value;
            strPost += "&CT_SEDE=" + document.getElementById("CT_SEDE").value;
            strPost += "&CT_CONTACTO=" + document.getElementById("CT_CONTACTO").value;
            strPost += "&CT_CONTACTO2=" + document.getElementById("CT_CONTACTO2").value;
            strPost += "&CT_CORREO=" + document.getElementById("CT_CORREO").value;
            strPost += "&CT_CORREO2=" + document.getElementById("CT_CORREO2").value;
            strPost += "&CT_BOLBASE=" + document.getElementById("CT_BOLBASE").value;
            strPost += "&CT_FECHA=" + strFecha;
            strPost += "&CT_HORA=" + document.getElementById("CT_HORA").value;
            strPost += "&CT_COMENTARIOS=" + document.getElementById("CT_COMENTARIOS").value;
            strPost += "&CT_GIRO=" + document.getElementById("CT_GIRO").value;
            strPost += "&CT_AREA=" + document.getElementById("CT_AREA").value;
            strPost += "&CT_CP=" + document.getElementById("CT_CP").value;
            strPost += "&CT_CALLE=" + encodeURIComponent(document.getElementById("CT_CALLE").value);
            strPost += "&CT_COL=" + document.getElementById("CT_COL").value;
            strPost += "&CT_NUM=" + document.getElementById("CT_NUM").value;
            strPost += "&CT_NOMBRE=" + document.getElementById("CT_CONTACTO_ENTRADA").value;
            strPost += "&CT_CONMUTADOR=" + document.getElementById("CT_CONMUTADOR").value;
            var intMailMes = 0;
            if (document.getElementById("CT_MAILMES").checked == true) {
                intMailMes = 1;
            }
            strPost += "&CT_MAILMES=" + intMailMes;
            $("#dialogWait").dialog("open");
            $.ajax({
                type: "POST",
                data: encodeURI(strPost),
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "html",
                url: "COFIDE_Telemarketing.jsp?ID=4",
                success: function (dato) {
                    dato = trim(dato);
                    if (Left(dato, 2) == "OK") {
                        guardarContactos(dato.replace("OK", ""), 0); //0 es igual a proceso normal, 1 = es uddate
                        ActualizaRzn(document.getElementById("CT_ID").value);
                    } else {
                        alert(dato);
                    }
                    $("#dialogWait").dialog("close");
                }});
        } else {
            alert("Es necesario fijar una fecha y una hora");
            document.getElementById("CT_FECHA").focus();
        }
    } else {
        alert("No Olvides Dejar tu Comentario");
        document.getElementById("CT_COMENTARIOS").focus();
    }
}
function guardarContactos(idCliente, update) {
    var grid = jQuery("#GRIDCONTACTOS");
    var idArr = grid.getDataIDs();
    var strPost = "";
//    if (idArr.length == 0) {
//    if (update != 1) { //si es actualizacion = 1 no carga los contactos, es cuando hace doble llamada
//        consultaVta(); //si no hay contactos, carga nuevamente el contacto
//    }
//    } else {
    strPost += "CT_ID=" + idCliente;
    for (var i = 0; i < idArr.length; i++) {
        var id = idArr[i];
        var lstRow = grid.getRowData(id);
        strPost += "&CCO_NOMBRE" + i + "=" + lstRow.CCO_NOMBRE + "";
        strPost += "&CCO_APPATERNO" + i + "=" + lstRow.CCO_APPATERNO + "";
        strPost += "&CCO_APMATERNO" + i + "=" + lstRow.CCO_APMATERNO + "";
        strPost += "&CCO_TITULO" + i + "=" + lstRow.CCO_TITULO + "";
        strPost += "&CCO_NOSOCIO" + i + "=" + lstRow.CCO_NOSOCIO + "";
        strPost += "&CCO_AREA" + i + "=" + lstRow.CCO_AREA + "";
        strPost += "&CCO_ASOCIACION" + i + "=" + lstRow.CCO_ASOCIACION + "";
        strPost += "&CCO_CORREO" + i + "=" + lstRow.CCO_CORREO + "";
        strPost += "&CCO_CORREO2" + i + "=" + lstRow.CCO_CORREO2 + "";
        strPost += "&CCO_TELEFONO" + i + "=" + lstRow.CCO_TELEFONO + "";
        strPost += "&CCO_EXTENCION" + i + "=" + lstRow.CCO_EXTENCION + "";
        strPost += "&CCO_ALTERNO" + i + "=" + lstRow.CCO_ALTERNO + "";
        strPost += "&CT_MAILMES2" + i + "=" + lstRow.CT_MAILMES2 + "";
    }
    strPost += "&length_contactos=" + idArr.length;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Telemarketing.jsp?ID=5",
        success: function (datos) {
            datos = trim(datos);
            if (Left(datos, 2) == "OK") {
                if (update != 1) { //aqui cargara si es o no actualizacion = actualizacion = 1
                    consultaVta();
                    jQuery("#GRIDCONTACTOS").clearGridData();
                }
            } else {
                alert(datos);
            }
        }, error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }});
//    }
}
function OpnDiagHCall() {
    var strCte = document.getElementById("CT_NO_CLIENTE").value;
    Abrir_Link("COFIDE_Historial_llamadas.jsp?CT_ID= " + strCte, "_blank", 800, 600, 0, 0);
}
function OpnDiagHVenta() {
    var objSecModiVta = objMap.getScreen("HVENTA");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("HVENTA", "_ed", "dialogCte", false, false, true);
}
function OpnDiagNVenta() {
    //limpia los campos para la nueva venta
    document.getElementById("CT_ID_FACTKT").value = ""; // se guarda el id en un hidden           
    document.getElementById("CT_TIPODOC").value = ""; // se guarda el id en un hidden  
    var objSecModiVta = objMap.getScreen("NVENTA");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("NVENTA", "_ed", "dialog", false, false, true);
}
function OpnDiagPLlamada() {
    var objSecModiVta = objMap.getScreen("P_LLAMADA");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("P_LLAMADA", "_ed", "dialogTMK1", false, false, true);
}
function OpnDiagCActivo() {
//    Abrir_Link("COFIDE_Calendario_cursos.jsp", "_blank", 800, 600, 0, 0);
    window.open("COFIDE_Calendario_cursos.jsp", '_blank');
}
function DelCteBase() {
    var strCT_ID = document.getElementById("CT_ID").value;
    if (strCT_ID != 0) {
        var strPost = "";
        strPost += "&CT_ID=" + strCT_ID;
        $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Telemarketing.jsp?ID=6"});
        consultaVta();
    } else {
        alert("No Hay Registro Para Descartar");
    }
}
function ValidaHora() {
    var strHora = document.getElementById("CT_HORA").value;
    strHora = trim(strHora);
    if (Left(strHora, 2) > 25) {
        alert("Solo son 24 hrs");
        document.getElementById("CT_HORA").value = "";
    }
    if (Right(strHora, 2) > 60) {
        alert("el rango es de 0 a 60 minutos");
        document.getElementById("CT_HORA").value = "";
    }
}
function LlamadaOK() {
    document.getElementById("CT_RESPOND").value = ""; //vuelve a marcar y regresa la respuesta en "" y activa el timer para leerlo de nuevo
    var intNo_CTE = document.getElementById("CT_ID").value;
    var bolBase = 0;
    if (document.getElementById("CT_BOLBASE").value == "true") {
        bolBase = 1;
    }
    var strComentario = document.getElementById("CT_COMENTARIOS").value;
    var strContacto = document.getElementById("CT_CONTACTO").value;
    var strCall = document.getElementById("CT_BOLCALL").value;
    var strExito = 0;
    var strDesc = 0;
    if (strCall == "1") {
        strExito = 1;
    } else {
        strDesc = 1;
    }
    var strPost = "";
    if (intNo_CTE == "") {
        intNo_CTE = 0;
    }
    strPost += "CT_ID=" + intNo_CTE;
    strPost += "&CT_BOLBASE=" + bolBase;
    strPost += "&CT_COMENTARIOS=" + strComentario;
    strPost += "&CT_CONTACTO=" + strContacto;
    strPost += "&exito=" + strExito;
    strPost += "&descartado=" + strDesc;
    strPost += "&HoraIni=" + document.getElementById("CT_HORA_INI").value;
    if (strContacto != "") {
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=3",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    document.getElementById("CT_ID_LLAMADA").value = objcte.getAttribute("id_llamada"); //recupera el ID de la llamada nueva
                }
                clearTimeout(timTimer);
                Timer(); //valida la llamda actual si ya termino
            }
        });
    } else {
        alert("Asigna un numero de contacto...");
    }
}
function mostrarHrs() {
    var strFecha = document.getElementById("CT_FECHA").value;
    var strPost = "CT_FECHA=" + strFecha;
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=7",
        success: function (datos) {
            var objHoraCombo = document.getElementById("CT_HORA");
            select_clear(objHoraCombo);
            var lstXml = datos.getElementsByTagName("horas")[0];
            var lstCte = lstXml.getElementsByTagName("hora");
            for (var i = 0; i < lstCte.length; i++) {
                var objHora = lstCte[i];
                select_add(objHoraCombo, objHora.getAttribute("valor"), objHora.getAttribute("valor"));
            }
            $("#dialogWait").dialog("close");
        }});
}
function OpnSearchCustomer() {
    var objSecModiVta = objMap.getScreen("TELE_CTE");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("TELE_CTE", "grid", "dialogCte", false, false, true);
}
function OpnSearchCustomer2() {
    var objSecModiVta = objMap.getScreen("EXCTE_TMK");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("EXCTE_TMK", "grid", "dialogCte", false, false, true);
}
function OpnChangeCall() {
    if (document.getElementById("CT_NO_CLIENTE").value != "0") {
        intContaPendiente++;
        var objCte = new CtePendiente(
                document.getElementById("CT_NO_CLIENTE").value,
                document.getElementById("CT_RAZONSOCIAL").value,
                document.getElementById("CT_RFC").value,
                document.getElementById("CT_SEDE").value,
                document.getElementById("CT_GIRO").value,
                document.getElementById("CT_CONTACTO").value,
                document.getElementById("CT_AREA").value,
                document.getElementById("CT_CONMUTADOR").value,
                document.getElementById("CT_CORREO").value,
                document.getElementById("CT_CORREO2").value
                );
        lstElemPendiente[intContaPendiente] = objCte;
        document.getElementById("CT_NO_CLIENTE").value = "0";
        document.getElementById("CT_RAZONSOCIAL").value = "";
        document.getElementById("CT_RFC").value = "";
        document.getElementById("CT_SEDE").value = "";
        document.getElementById("CT_GIRO").value = "";
        document.getElementById("CT_CONTACTO").value = "";
        document.getElementById("CT_AREA").value = "";
        document.getElementById("CT_CONMUTADOR").value = "";
        document.getElementById("CT_CORREO").value = "";
        document.getElementById("CT_CORREO2").value = "";
        _drawPendientes();
    }
}
function _drawPendientes() {
    var strRazonSocial = document.getElementById("CT_RAZONSOCIAL").value;
    var strHtml = "<table>";
    strHtml += "<tr>";
    strHtml += "<td><a href=\"javascript:OpnCtePendiente()\">" + strRazonSocial + "</a></td>";
    strHtml += "</tr>";
    strHtml += "</table>";
    document.getElementById("seccion_pendiente").innerHTML = strHtml;
}
function CtePendiente(id, nombre, rfc, sede, giro, contacto, area, conmutador, correo, correo2) {
    this.id = id;
    this.nombre = nombre;
    this.rfc = rfc;
    this.sede = sede;
    this.giro = giro;
    this.contacto = contacto;
    this.area = area;
    this.conmutador = conmutador;
    this.correo = correo;
    this.correo2 = correo2;
}
function drawRightPanel() {
    var divRightPanel = document.getElementById("rightPanel");
    var strHTML = "<table border='0' class='cofide_dashboard' align='center'>";
    strHTML += "<tr>";
    strHTML += '<td valign="top" style="font-size:14px; width:240px">';
    strHTML += "Llamadas realizadas:";
    strHTML += "<div id='conteo_llamadas' align='center'>0</div>";
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:240px">';
    strHTML += "Sesiones pendientes:";
    strHTML += "<div id='seccion_pendiente' style='font-size: 22px; padding-left: 5px;'><a href=\"javascript:OpnCtePendiente()\">Ninguna</a></div>";
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:160px">';
    strHTML += "Meta nuevos:";
    strHTML += "<div id='seccion_nvos_meta'>0</div>"; //meta nuevos registros
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:110px">';
    strHTML += "Nuevos:";
    strHTML += "<div id='seccion_nvos'>0</div>"; //nuevos registros
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:13px; width:230px">';
    strHTML += "<i class='fa fa-star-o'></i>";
    strHTML += "<div id='seccion_monto_vtas_meta'>0.0</div>"; //monto meta venta
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:200px">';
    strHTML += "<i class='fa fa-shopping-cart'></i>";
    strHTML += "<div id='seccion_monto_vtas'>0.0</div>"; //monto de venta
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:180px">';
    strHTML += "<i class='fa fa-usd'></i>";
    strHTML += "<div id='seccion_monto_cobrado'>0.0</div>"; //monto cobrado
    strHTML += "</td>";
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:180px">';
    strHTML += "<i class='fa fa-file-text-o '></i>";
    strHTML += "<div id='seccion_monto_facturado'>0.0</div>"; //monto cobrado
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:200px">';
    strHTML += "Usuario actual:";
    strHTML += "<div id='seccion_user_actual'>" + strUserName + "</div>";
    strHTML += "</td>";
    strHTML += '<td valign="top" style="font-size:14px; width:180px">';
    strHTML += "Fecha actual:";
    strHTML += "<div id='seccion_fecha_actual'>" + strHoyFecha + "</div>";
    strHTML += "</td>";
    strHTML += "</tr>";
    strHTML += "</table>";
    divRightPanel.innerHTML = strHTML;
    getIndicadores();
}
function getIndicadores() {
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=8",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("indicadores")[0];
            var lstCte = lstXml.getElementsByTagName("Indicador");
            for (var i = 0; i < lstCte.length; i++) {
                var objIndicador = lstCte[i];
                /**
                 * seccion_nvos = seccion de cuantos registros nuevos
                 * seccion_monto_vtas = cantidad $ de ventas que se llevan al momento
                 * seccion_monto_cobrado = cantidad $ cobrado
                 * seccion_monto_facturado = cantidad facturado
                 * seccion_nvos_meta = nueva meta de nuevos registros
                 * seccion_monto_vtas_meta = meta de ventas actual
                 * seccion_pendiente = registros pendientes que mandaron a pausa
                 */
                document.getElementById("seccion_pendiente").innerHTML = '<a href=\"javascript:OpnCtePendiente()\">' + objIndicador.getAttribute("pendiente") + '</a>'
                document.getElementById("conteo_llamadas").innerHTML = objIndicador.getAttribute("llamadas");
                document.getElementById("seccion_nvos").innerHTML = objIndicador.getAttribute("nuevo");
                document.getElementById("seccion_monto_vtas").innerHTML = "$ " + FormatNumber(objIndicador.getAttribute("monto"), 2, true, false, true);
                document.getElementById("seccion_monto_cobrado").innerHTML = "$ " + FormatNumber(objIndicador.getAttribute("cobrado"), 2, true, false, true);
                document.getElementById("seccion_monto_facturado").innerHTML = "$ " + FormatNumber(objIndicador.getAttribute("monto_factura"), 2, true, false, true);
                document.getElementById("seccion_nvos_meta").innerHTML = objIndicador.getAttribute("nuevo_meta");
                document.getElementById("seccion_monto_vtas_meta").innerHTML = "$ " + FormatNumber(objIndicador.getAttribute("monto_meta"), 2, true, false, true);
            }
            $("#dialogWait").dialog("close");
        }});
}
function OpnPausarLlamada() {
    document.getElementById("CT_ID_PAUSA").value = "";
    var strHtml = "<table border= 0>";
    strHtml += "<tr>";
    strHtml += "<td colspan='5'>¿Especifique el motivo de la pausa?";
    strHtml += "</td>";
    strHtml += "</tr>";
    strHtml += "<tr>";
    strHtml += "<td><input type='radio' name='tipo_paus' value ='1' id='tipo_pausa1' checked>Capacitación</td>";
    strHtml += "<td><input type='radio' name='tipo_paus' value ='2' id='tipo_pausa2'>admin</td>";
    strHtml += "<td><input type='radio' name='tipo_paus' value ='3' id='tipo_pausa3'>sanitario</td>";
    strHtml += "<td><input type='radio' name='tipo_paus' value ='4' id='tipo_pausa4'>comida</td>";
    strHtml += "</tr>";
    strHtml += "<tr>";
    strHtml += "<td colspan='2'><input type=button name='pausar_llamada' id='pausar_llamada' onclick='comienzaPausaLlamada()' value='Comenzar'>";
    strHtml += "<td colspan='2'><input type=button name='termina_pausar_llamada' id='termina_pausar_llamada' onclick='terminaPausaLlamada()' value='Terminar'>";
    strHtml += "</td>";
    strHtml += "</tr>";
    strHtml += "</table>";
    document.getElementById("dialog2_inside").innerHTML = strHtml;
    $("#dialog2").dialog("option", "title", "Pausa");
    $("#dialog2").dialog("open");
}
function comienzaPausaLlamada() {
    document.getElementById("pausar_llamada").style.display = "none";
    document.getElementById("CT_ESTATUS").value = "PAUSA";
    TiempoPausa("PAUSA");
}
function terminaPausaLlamada() {
    alert("Termina la pausa");
    document.getElementById("CT_ESTATUS").value = "DISPONIBLE";
    TiempoPausa("DISPONIBLE");
    $("#dialog2").dialog("close");
}
function OpnEdoCtaCte() {
    var objSecModiVta = objMap.getScreen("VTAS_VIEW");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("VTAS_VIEW", "_ed", "dialogCte", false, false, true);
}
function OpnSalirLlamada() {
    limpiarTodo();
}
function OpnNewCte() {
    IsInBound();
    var objSecModiVta = objMap.getScreen("N_PROSP");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("N_PROSP", "_ed", "dialogCte", false, false, true);
}
function NewProspecto() {
    var strPost = "";
    var strRazon = document.getElementById("NCT_RAZONSOCIAL").value;
    var strEmail = document.getElementById("NCT_EMAIL1").value;
    var strNumero = document.getElementById("NCT_NUMERO").value;
    var strMedio = document.getElementById("NCT_MEDIO").value;
    if (strRazon != "" && (strEmail != "" || strNumero != "")) {
        strPost += "NCT_RAZONSOCIAL=" + strRazon;
        strPost += "&NCT_EMAIL1=" + strEmail;
        strPost += "&NCT_NUMERO=" + strNumero;
        strPost += "&NCT_MEDIO=" + strMedio;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=11",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    document.getElementById("NCT_ID").value = objcte.getAttribute("NCT_ID");
                }
                var intId = document.getElementById("NCT_ID").value;
                document.getElementById("CT_NO_CLIENTE").value = intId;
                document.getElementById("CT_RAZONSOCIAL").value = strRazon;
                document.getElementById("CT_CONTACTO").value = strNumero;
                document.getElementById("CT_CORREO").value = strEmail;
                consultaVta(intId);
                $("#dialogCte").dialog("close");
            }});
    } else {
        alert("Ingresa la razon social con un correo o telefono");
    }
}
function Validafecha() {
    var strFecha = document.getElementById("CT_FECHA").value;
    var strPost = "FECHA=" + strFecha;
    var resp = "";
    var FechaActual = "";
    $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Telemarketing.jsp?ID=13", success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                resp = objcte.getAttribute("ok");
                FechaActual = objcte.getAttribute("FechaDiagonal");
                if (resp == "ok") {
                    mostrarHrs();
                } else {
                    alert("La Fecha debe de ser posterior al día de hoy");
                    document.getElementById("CT_FECHA").value = FechaActual;
                }
            }
        }});
}
function llenarColonia() {
    var strCp = document.getElementById("CT_CP").value;
    var objColoniaCombo = document.getElementById("CT_COL");
    if (strCp != "") {
        var strPost = "CT_CP=" + strCp;
//        $("#dialogWait").dialog("open");
        $.ajax({type: "POST", data: strPost, scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Telemarketing.jsp?ID=14", success: function (datos) {
                select_clear(objColoniaCombo);
                var lstXml = datos.getElementsByTagName("General")[0];
                var lstCte = datos.getElementsByTagName("Colonia");
                for (var i = 0; i < lstCte.length; i++) {
                    var objColonia = lstCte[i];
                    select_add(objColoniaCombo, objColonia.getAttribute("CMX_COLONIA"), objColonia.getAttribute("CMX_COLONIA"));
                }
                if (objColonia != document.getElementById("CT_COLONIA_DB").value) {
                    select_add(objColoniaCombo, document.getElementById("CT_COLONIA_DB").value, document.getElementById("CT_COLONIA_DB").value);
                }
                document.getElementById("CT_EDO").value = lstXml.getAttribute("CMX_ESTADO");
                document.getElementById("CT_MUNI").value = lstXml.getAttribute("CMX_MUNICIPIO");
//                $("#dialogWait").dialog("close");
            }});
    } else {
        select_clear(objColoniaCombo);
    }
}
function RevizaFinLlamada() {
//    alert("vamo a revizar el fin de la llamada");
    var bolAlert = false;
    var strStat = document.getElementById("CT_ESTATUS").value;
    if (strStat == "DISPONIBLE") {
        var intIdLlamada = document.getElementById("CT_ID_LLAMADA").value;
        var strRespuesta = "";
        if (intIdLlamada != "") {
            var strPost = "id_llamada=" + intIdLlamada;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Telemarketing.jsp?ID=15",
                success: function (datos) {
                    var lstXml = datos.getElementsByTagName("vta")[0];
                    var lstCte = lstXml.getElementsByTagName("datos");
                    for (var i = 0; i < lstCte.length; i++) {
                        var objcte = lstCte[i];
                        strRespuesta = objcte.getAttribute("idpbx");
                        if (strRespuesta != "") {
                            document.getElementById("CT_RESPOND").value = "OK";
                            alert("Terminó llamada");
                            Timer();
                        } else {
                            Timer();
                        }
                    }
                },
                error: function (objeto, quepaso, otroobj) {
                    alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
                }
            });
        }
    } else {
        Timer();
    }
}
/**
 * 
 * @returns {none}
 * lee si, ya colgo o no la llamada CT_RESPOND
 * lee si, esta disponible el ejecutivo CT_ESTATUS
 * si esta el CT_ESTATUS en DISPONIBLE, y el CT_RESPOND en OK, manda el aviso al supervisor, si no, vuelve a revizar el estatus de la llamada
 * 
 */
function Timer() {
//    alert("se activó el timer");
    var strResp = document.getElementById("CT_RESPOND").value;
    var strStat = document.getElementById("CT_ESTATUS").value;
    if (strResp == "OK" && strStat == "DISPONIBLE") {
//        EnvioCorreoSuper();
        timTimer = setTimeout("EnvioCorreoSuper()", 60000);
    } else {
//        RevizaFinLlamada();
        timTimer = setTimeout('RevizaFinLlamada()', 10000);
    }
}
function EnvioCorreoSuper() {
//    alert("entro en el envio de notificacion");
    var strResp = document.getElementById("CT_RESPOND").value;
    var strStat = document.getElementById("CT_ESTATUS").value;
    if (strResp == "OK" && strStat == "DISPONIBLE") {
        alert("No Olvides Guardar Tu Registro");
        $.ajax({
            type: "POST",
            data: "",
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=16",
            success: function (datos) {
//                datos = trim(datos);
//                if (Left(datos, 2) == "OK") {
                Timer();
//                } else {
//                    alert(datos);
//                }
            }, error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }
        });
    } else {
        Timer();
    }
}
function MonitorioAgentes() {
    var strRespuesta = "";
    var strAgentes = "";
    var intSupervisor = "";
    $.ajax({type: "POST", data: "", scriptCharset: "UTF-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: "COFIDE_Telemarketing.jsp?ID=17", success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                strRespuesta = objcte.getAttribute("libres");
                strAgentes = objcte.getAttribute("agente");
                intSupervisor = objcte.getAttribute("supervisor");
                if (strRespuesta == "OK") {
                    if (intSupervisor == 1) { //unicamente si es supervisor
                        setTimeout("MonitorioAgentes()", 30000);
                    }
                    if (strAgentes != "") {
                        alert("Alerta!! ejecutivo sin llamada! \n" + strAgentes);
                    }
                } else {
                }
            }
        }});
}
function LoadContacto(intIdCte) {
    jQuery("#GRIDCONTACTOS").clearGridData();
    if (intIdCte > 0) {
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
                        CCO_AREA: objcte.getAttribute("CCO_AREA"),
                        CCO_ASOCIACION: objcte.getAttribute("CCO_ASOCIACION"),
                        CCO_CORREO: objcte.getAttribute("CCO_CORREO"),
                        CCO_CORREO2: objcte.getAttribute("CCO_CORREO2"),
                        CCO_TELEFONO: objcte.getAttribute("CCO_TELEFONO"),
                        CCO_EXTENCION: objcte.getAttribute("CCO_EXTENCION"),
                        CCO_ALTERNO: objcte.getAttribute("CCO_ALTERNO")};
                    itemIdCob++;
                    jQuery("#GRIDCONTACTOS").addRowData(itemIdCob, datarow, "last");
                }
                HistorialVtaCte(intIdCte); //historial de vta por cte
                loadRazonSocial(intIdCte); //razones socuales
            }});
    }
}
function SelectCtePro(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#TELE_CTE");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "TELE_CTE") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_TELEM") {
            consultaVta(lstVal.CT_ID);
            $("#dialogCte").dialog("close");
            $("#dialogInv").dialog("close"); //cierra la ventana principal del motor
        }
    }
}
function SelectCteEx(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#EXCTE_TMK");
    var lstVal = grid.getRowData(id);
    if (strNomMain == "EXCTE_TMK") {
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_TELEM") {
            consultaVta(lstVal.CT_ID);
            $("#dialogCte").dialog("close");
            $("#dialogInv").dialog("close"); //cierra la ventana principal del motor
        }
    }
}
function LlamarContacto() {
    document.getElementById("CT_RESPOND").value = ""; //vuelve a marcar y regresa la respuesta en "" y activa el timer para leerlo de nuevo
    var intCT_ID = document.getElementById("CT_NO_CLIENTE").value;
    var grid = jQuery("#GRIDCONTACTOS");
    var ids = grid.getGridParam("selrow");
    if (ids !== null) {
        var lstRow1 = grid.getRowData(ids);
        var strPhone = lstRow1.CCO_TELEFONO;
        if (strPhone != "undefined" || strPhone != "") {
            var strPost = "";
            strPost += "CT_TELEFONO=" + strPhone;
            strPost += "&CT_ID=" + intCT_ID;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Telemarketing.jsp?ID=20",
                success: function (datos) {
                    var lstXml = datos.getElementsByTagName("vta")[0];
                    var lstCte = lstXml.getElementsByTagName("datos");
                    for (var i = 0; i < lstCte.length; i++) {
                        var objcte = lstCte[i];
                        document.getElementById("CT_ID_LLAMADA").value = objcte.getAttribute("id_llamada"); //recupera el ID de la llamada nueva
                    }
                    clearTimeout(timTimer);
                    Timer(); //valida la llamda actual si ya termino
                }
            });
        } else {
            alert("el Contacto no existe!");
        }
    } else {
        alert("Selecciona un contacto!");
    }
}
function editContacto(opc) {
    if (opc == 1) {
        var grid = jQuery("#GRIDCONTACTOS");
        if (grid.getGridParam("selrow") != null) {
//            newTelem(opc);
            /**
             * limpia y muestra los campos
             */
            document.getElementById("CCO_NOMBRE").value = "";
            document.getElementById("CCO_APPATERNO").value = "";
            document.getElementById("CCO_APMATERNO").value = "";
            document.getElementById("CCO_TITULO").value = "";
            document.getElementById("CCO_NOSOCIO").value = "";
            document.getElementById("CCO_AREA").value = "";
            document.getElementById("CCO_ASOCIACION").value = "";
            document.getElementById("CCO_CORREO").value = "";
            document.getElementById("CCO_CORREO2").value = "";
            document.getElementById("CCO_TELEFONO").value = "";
            document.getElementById("CCO_EXTENCION").value = "";
            document.getElementById("CCO_ALTERNO").value = "";
            document.getElementById("CT_MAILMES2").value = "";
            //limpia campos
            document.getElementById("CCO_NOMBRE").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_APPATERNO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_APMATERNO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_TITULO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_NOSOCIO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_AREA").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_ASOCIACION").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_CORREO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_CORREO2").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_TELEFONO").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_EXTENCION").parentNode.parentNode.style.display = "";
            document.getElementById("CCO_ALTERNO").parentNode.parentNode.style.display = "";
            document.getElementById("BTN_ADD").parentNode.parentNode.style.display = "";
            document.getElementById("CT_MAILMES2").parentNode.parentNode.style.display = "";
            document.getElementById("CT_MAILMES2").checked = false;
            document.getElementById("BTN_CANCEL").parentNode.parentNode.style.display = "";
            document.getElementById("BTN_NEW").parentNode.parentNode.style.display = "none";
            document.getElementById("BTN_DEL").parentNode.parentNode.style.display = "none";
            /**
             * limpia y muestra los campos
             */
            var lstRow = grid.getRowData(grid.getGridParam("selrow"));
            document.getElementById("CCO_TITULO").value = lstRow.CCO_TITULO;
            document.getElementById("CCO_NOMBRE").value = lstRow.CCO_NOMBRE;
            document.getElementById("CCO_APPATERNO").value = lstRow.CCO_APPATERNO;
            document.getElementById("CCO_APMATERNO").value = lstRow.CCO_APMATERNO;
            document.getElementById("CCO_ASOCIACION").value = lstRow.CCO_ASOCIACION;
            document.getElementById("CCO_NOSOCIO").value = lstRow.CCO_NOSOCIO;
            document.getElementById("CCO_CORREO").value = lstRow.CCO_CORREO;
            document.getElementById("CCO_CORREO2").value = lstRow.CCO_CORREO2;
            document.getElementById("CCO_AREA").value = lstRow.CCO_AREA;
            document.getElementById("CCO_TELEFONO").value = lstRow.CCO_TELEFONO;
            document.getElementById("CCO_EXTENCION").value = lstRow.CCO_EXTENCION;
            document.getElementById("CCO_ALTERNO").value = lstRow.CCO_ALTERNO;
            delGridTMK(opc);
            itemIdCob++;
        }
    }
    if (opc == 2) {
        var grid = jQuery("#GRD_RZN");
        if (grid.getGridParam("selrow") != null) {
            newTelem(opc);
            var lstRow = grid.getRowData(grid.getGridParam("selrow"));
            document.getElementById("CT_ADDRZN").value = lstRow.RZN_NOMBRE;
            delGridTMK(opc);
            itemIdCob++;
        }
    }
}
function SendMailContacto() {
//    var strHtmlBtnMail = "";
    var strPost = "";
    var strCurso = document.getElementById("CC_CURSO_NOMBRE").value;
    if (strCurso != "") {
        $("#dialogWait").dialog("open");
        var grid = jQuery("#GRIDCONTACTOS");
        var ids = grid.getGridParam("selrow");
        if (ids !== null) {
            var lstRow1 = grid.getRowData(ids);
            var strCorreo = lstRow1.CCO_CORREO;
            var strNombre = lstRow1.CCO_NOMBRE;
            if (strCorreo != "") {
                strPost = "curso=" + strCurso.split(" /", 1) + "&email=" + strCorreo;
                $.ajax({
                    type: "POST",
                    data: strPost,
                    scriptCharset: "UTF-8",
                    contentType: "application/x-www-form-urlencoded;charset=utf-8",
                    cache: false,
                    dataType: "xml",
                    url: "COFIDE_Programacionmails.jsp?ID=8"
                });
                setTimeout('alert("Mensaje Enviado")', 3000);
                $("#dialogWait").dialog("close");
//                document.location.href = "mailto:" + strCorreo + "?subject=" + encodeURIComponent("Estimado: " + strNombre) + "&body=" + encodeURIComponent("yourMessage");
            } else {
                alert("el Contacto no tiene un correo");
                $("#dialogWait").dialog("close");
            }
        } else {
            $("#dialogWait").dialog("close");
            alert("Selecciona un contacto!");
        }
    } else {
        alert("Elije un curso");
        $("#dialogWait").dialog("close");
    }
}
function loadRazonSocial(intIdCte) {
    jQuery("#GRD_RZN").clearGridData();
    var strPost = "CT_ID=" + intIdCte;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=21",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    RZN_ID: objcte.getAttribute("RZN_ID"),
                    RZN_CTE: objcte.getAttribute("RZN_CTE"),
                    RZN_NOMBRE: objcte.getAttribute("RZN_NOMBRE")
                };
                itemIdCob++;
                jQuery("#GRD_RZN").addRowData(itemIdCob, datarow, "last");
            }
        }});
}
function IsInBound() {
    var strNomMain = objMap.getNomMain();
    var bolInBound = false;
    if (strNomMain == "TELEM_INB") {
        bolInBound = true;
    } else {
        setTimeout('document.getElementById("NCT_MEDIO").parentNode.parentNode.style.display = "none"', 1000);
    }
    return bolInBound;
}
function EnvioMailGroup() {
    var intNumCte = document.getElementById("CT_NO_CLIENTE").value; //toma el numero del cliente
    var strCurso = document.getElementById("CC_CURSO_NOMBRE").value; //toma el curso seleccionado
    if (strCurso != "") {
        if (intNumCte != "0") { // si es diferente a 0, tomar el numero del cliente
            var strPost = "CT_NUM_CTE=" + intNumCte;
            strPost += "&CURSO=" + strCurso; //envia el numero y el curso
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Programacionmails.jsp?ID=5"
            });
            setTimeout('alert("Mail Group Enviadó")', 5000);
        } else {
            alert("elije el curso que se enviara!");
        }
    } else {
        alert("No Hay Destinatarios Disponibles");
    }
}
function errorbase() {
    var ct_id = document.getElementById("CT_ID").value;
    if (ct_id != "0") {
        document.getElementById("SioNO_inside").innerHTML = "¿Estas seguro de desechar este registro?";
        $("#SioNO").dialog("open");
        document.getElementById("btnSI").onclick = function () {
            $("#SioNO").dialog("close");
            var strPost = "ct_id=" + ct_id;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "utf-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "html",
                url: "COFIDE_Telemarketing.jsp?ID=22",
                success: function (datos) {
                    consultaVta();
                }});
        };
        document.getElementById("btnNO").onclick = function () {
            $("#SioNO").dialog("close");
        };
    } else {
        alert("No Hay Ningun Cliente a Remover");
    }
}
function UpDateCte() {
    if (document.getElementById("CT_NO_CLIENTE").value != "0") {
//DelContacto(document.getElementById("CT_NO_CLIENTE").value);
        var strPost = "";
        strPost += "CT_ID=" + document.getElementById("CT_ID").value;
        strPost += "&CT_RAZONSOCIAL=" + encodeURIComponent(document.getElementById("CT_RAZONSOCIAL").value);
        strPost += "&CT_RFC=" + document.getElementById("CT_RFC").value;
        strPost += "&CT_SEDE=" + document.getElementById("CT_SEDE").value;
        strPost += "&CT_CONTACTO=" + document.getElementById("CT_CONTACTO").value;
        strPost += "&CT_CONTACTO2=" + document.getElementById("CT_CONTACTO2").value;
        strPost += "&CT_CORREO=" + document.getElementById("CT_CORREO").value;
        strPost += "&CT_CORREO2=" + document.getElementById("CT_CORREO2").value;
        strPost += "&CT_COMENTARIOS=" + document.getElementById("CT_COMENTARIOS").value;
        strPost += "&CT_GIRO=" + document.getElementById("CT_GIRO").value;
        strPost += "&CT_AREA=" + document.getElementById("CT_AREA").value;
        strPost += "&CT_CP=" + document.getElementById("CT_CP").value;
        strPost += "&CT_CALLE=" + document.getElementById("CT_CALLE").value;
        strPost += "&CT_COL=" + document.getElementById("CT_COL").value;
        strPost += "&CT_NUM=" + document.getElementById("CT_NUM").value;
        strPost += "&CT_NOMBRE=" + document.getElementById("CT_CONTACTO_ENTRADA").value;
        strPost += "&CT_CONMUTADOR=" + document.getElementById("CT_CONMUTADOR").value;
        var intMailMes = 0;
        if (document.getElementById("CT_MAILMES").checked == true) {
            intMailMes = 1;
        }
        strPost += "&CT_MAILMES=" + intMailMes;
        ActualizaRzn(document.getElementById("CT_ID").value); //guardarazonsocial
        guardarContactos(document.getElementById("CT_NO_CLIENTE").value, 1); //1 = actualizacion , 0 = proceso normal
        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: encodeURI(strPost),
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_Telemarketing.jsp?ID=23"});
        $("#dialogWait").dialog("close");
        //laert(document.getElementById("CT_NO_CLIENTE").value + " actualizacion OK"); //prueba
        setTimeout("consultaVta(document.getElementById(\"CT_NO_CLIENTE\").value)", 1000);
    } else {
        alert("Revisa bien los datos a actualizar!");
    }
}
function ValidaMailLN(opc) {
    var intIDCte = "0";
    var strCorreo = "";
    var strCorreoValue = "";
    if (opc == 1) {
        strCorreo = document.getElementById("CT_CORREO").value;
        strCorreoValue = "CT_CORREO";
        intIDCte = document.getElementById("CT_NO_CLIENTE").value;
    }
    if (opc == 2) {
        strCorreo = document.getElementById("CT_CORREO2").value;
        strCorreoValue = "CT_CORREO2";
        intIDCte = document.getElementById("CT_NO_CLIENTE").value;
    }
    if (opc == 3) {
        if (!validaCorreo()) {
            strCorreo = document.getElementById("CCO_CORREO").value;
            strCorreoValue = "CCO_CORREO";
            intIDCte = document.getElementById("CT_NO_CLIENTE").value;
        } else {
            alert("Este correo ya existe en este cliente");
        }
    }
    if (opc == 4) {
        if (!validaCorreo()) {
            strCorreo = document.getElementById("CCO_CORREO2").value;
            strCorreoValue = "CCO_CORREO2";
            intIDCte = document.getElementById("CT_NO_CLIENTE").value;
        } else {
            alert("Este correo ya existe en este cliente");
        }
    }
    if (opc == 5) {
        strCorreo = document.getElementById("NCT_EMAIL1").value;
        strCorreoValue = "NCT_EMAIL1";
        intIDCte = "0";
    }
    if (strCorreo != "") {
        var strPost = "correo=" + strCorreo;
        strPost += "&idcte=" + intIDCte;
        var strRespuestaLN = "";
        var strRespuestaDup = "";
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=24",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    strRespuestaLN = objcte.getAttribute("listanegra");
                    strRespuestaDup = objcte.getAttribute("duplicado");
                    if (strRespuestaDup == "1") {
                        alert("El Correo esta Duplicado");
                        document.getElementById(strCorreoValue).value = "";
                    }
                    if (strRespuestaLN == "1") {
                        alert("El Correo esta en la lista negra");
                        document.getElementById(strCorreoValue).value = "";
                    }
                }
            }});
    }
}

function BuscaCursoEmail() {
    var strCurso = document.getElementById("CC_CURSO_NOMBRE").value;
    var strPost = "CURSO=" + strCurso;
    $(function () {
        $("#CC_CURSO_NOMBRE").autocomplete({//campo de texto que tendra el autocmplete
            source: "COFIDE_Telemarketing.jsp?ID=40&" + strPost,
            minLength: 2
        });
    });
}
function ActualizaRzn(intIdCte) {
    var strPost = "";
    var gridRzn = jQuery("#GRD_RZN");
    var idArrRzn = gridRzn.getDataIDs();
    strPost += "CT_ID=" + intIdCte;
    for (var ii = 0; ii < idArrRzn.length; ii++) {
        var idRzn = idArrRzn[ii];
        var lstRowRzn = gridRzn.getRowData(idRzn);
        strPost += "&RAZONSOCIAL" + ii + "=" + lstRowRzn.RZN_NOMBRE;
    }
    strPost += "&length=" + idArrRzn.length;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Telemarketing.jsp?ID=25",
    });
}

function validaTelefono(opc) { //1 telefono / 2 celular valida los digitos
    var campoTelefono = document.getElementById("CT_CONTACTO");
    var strTelefono = document.getElementById("CT_CONTACTO").value;
    var campoCelular = document.getElementById("CT_CONTACTO2");
    var strCelular = document.getElementById("CT_CONTACTO2").value;
    var strNumLocal_Metro = document.getElementById("MET_LOCAL").checked;
    if (strTelefono != "") {
        if (opc == 1) {
            if (strNumLocal_Metro == true) {
                if (strTelefono.length < 10) {
                    campoTelefono.style["background"] = "#F5A9A9";
                    alert("verifica el codigo local");
                } else {
                    campoTelefono.style["background"] = "#ffffff";
                }
            } else {
                if (strTelefono.length < 12) {
                    campoTelefono.style["background"] = "#F5A9A9";
                    alert("verifica el codigo y la lada");
                } else {
                    campoTelefono.style["background"] = "#ffffff";
                }
            }
        } // fin 1
    }
    if (strCelular != "") {
        if (opc == 2) {
            if (strCelular.length < 13) {
                campoCelular.style["background"] = "#F5A9A9";
                alert("verifica el codigo y la lada");
            } else {
                campoCelular.style["background"] = "#ffffff"
            }
        }
    }
}
function ValidaNumTelefono(opc) {

    var intCT_ID = "0";
    var strTelefono = "";
    var campoTelefono = "";
    if (opc == 1) {
        strTelefono = document.getElementById("NCT_NUMERO").value;
        campoTelefono = "NCT_NUMERO";
        intCT_ID = "0";
    }
    if (opc == 2) {
        strTelefono = document.getElementById("CCO_TELEFONO").value;
        campoTelefono = "CCO_TELEFONO";
        intCT_ID = document.getElementById("CT_ID").value;
    }
    if (opc == 3) {
        strTelefono = document.getElementById("CCO_ALTERNO").value;
        campoTelefono = "CCO_ALTERNO";
        intCT_ID = document.getElementById("CT_ID").value;
    }
    if (strTelefono != "") {
        var strPost = "telefono=" + strTelefono;
        strPost += "&idcte=" + intCT_ID;
        var strRespuestaDup = "";
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=26",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    strRespuestaDup = objcte.getAttribute("duplicado");
                    if (strRespuestaDup == "1") {
                        alert("El Telefono esta Duplicado");
                        document.getElementById(campoTelefono).value = "";
                    }
                }
            }});
    }
}

function ValidaFinesSemana() {
    var strFecha = document.getElementById("CT_FECHA").value;
    var strDia = "";
    var strPost = "dia=" + strFecha;
    if (strFecha != "") {
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=27",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    strDia = objcte.getAttribute("dia");
                    if (strDia == "6" || strDia == "7") {
                        alert("No se puede agendar en fin de semana");
                        document.getElementById("CT_FECHA").value = "";
                        document.getElementById("CT_HORA").value = "";
                    } else {
                        Validafecha();
                    }
                }
            }});
    }
}
function OpnMotorBusqueda() {
    var objSecModiVta = objMap.getScreen("MOTOR_CTE");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("MOTOR_CTE", "_ed", "dialogInv", false, false, true);
}
function MotorBusqueda() {
    jQuery("#MB_GRD").clearGridData();
    var strBuscar = document.getElementById("MB_BUSQUEDA").value;
    var strFiltro = document.getElementById("MB_COMBO").value;
    var strBaseUser = document.getElementById("CT_CLAVE_DDBB").value;
    var strPost = "buscar=" + strBuscar;
    strPost += "&filtro=" + strFiltro;
    strPost += "&BaseUser=" + strBaseUser;
    if (strBuscar != "") {
        if (strFiltro != 0) {
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Telemarketing.jsp?ID=28",
                success: function (datos) {
                    var lstXml = datos.getElementsByTagName("vta")[0];
                    var lstCte = lstXml.getElementsByTagName("datos");
                    for (var i = 0; i < lstCte.length; i++) {
                        var objcte = lstCte[i];
                        var exp_prosp = "";
                        if (objcte.getAttribute("CT_ES_PROSPECTO") == "1") {
                            exp_prosp = "PROSPECTO"
                        } else {
                            exp_prosp = "EXPARTICIPANTE";
                        }
                        var datarow = {
                            CT_ID: objcte.getAttribute("CT_ID"),
                            CT_RAZONSOCIAL: objcte.getAttribute("CT_RAZONSOCIAL"),
                            CT_CLAVE_DDBB: objcte.getAttribute("CT_CLAVE_DDBB"),
                            nombre_usuario: objcte.getAttribute("nombre_usuario"),
                            CT_ES_PROSPECTO: exp_prosp
                        };
                        itemIdCob++;
                        jQuery("#MB_GRD").addRowData(itemIdCob, datarow, "last");
                    }
                }});
        } else {
            alert("Elige el filtro de busqueda");
        }
    } else {
        alert("Ingresa el valor que deseas buscar");
    }
}
function dblClickCTE(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#MB_GRD"); //nombre del grid detalle
    var lstVal = grid.getRowData(id);
    if (strNomMain == "MOTOR_CTE") { //pantalla que lo contiene
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_TELEM") { //pantalla principal
            var strCte = lstVal.CT_ID;
            consultaVta(strCte);
            $("#dialogInv").dialog("close");
        }
    }
}
function TiempoPausa(strStatus) {
    var strTipoPausa = "";
    if (document.getElementById("tipo_pausa1").checked) {
        strTipoPausa = "CAPACITACION";
    }
    if (document.getElementById("tipo_pausa2").checked) {
        strTipoPausa = "ADMINISTRACION";
    }
    if (document.getElementById("tipo_pausa3").checked) {
        strTipoPausa = "SANITARIO";
    }
    if (document.getElementById("tipo_pausa4").checked) {
        strTipoPausa = "COMIDA";
    }
    var strPost = "";
    var strIDPausa = "";
    if (strStatus == "DISPONIBLE") {
        strIDPausa = document.getElementById("CT_ID_PAUSA").value;
        if (strIDPausa != "") {
            strPost = "estatus=1" + "&idpausa=" + strIDPausa;
            $.ajax({
                type: "POST",
                data: strPost,
                scriptCharset: "UTF-8",
                contentType: "application/x-www-form-urlencoded;charset=utf-8",
                cache: false,
                dataType: "xml",
                url: "COFIDE_Telemarketing.jsp?ID=29",
            });
        }
    } else {
        strPost = "estatus=0" + "&tipopausa=" + strTipoPausa;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=29",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    strIDPausa = objcte.getAttribute("idpausa");
                }
                document.getElementById("CT_ID_PAUSA").value = strIDPausa;
            }});
    }
}

function tmp_Guardar() {
    clearTimeout(timTimer);
    if (document.getElementById("CT_NO_CLIENTE").value != 0) {
        _drawPendientes();
        var intMailMes = 0;
        if (document.getElementById("CT_MAILMES").checked == true) {
            intMailMes = 1;
        }
        var strPost = "";
        strPost += "CT_ID=" + document.getElementById("CT_ID").value; // hidden
        strPost += "&CT_NO_CLIENTE=" + document.getElementById("CT_ID").value; // numero del cliente
        strPost += "&CT_RAZONSOCIAL=" + encodeURIComponent(document.getElementById("CT_RAZONSOCIAL").value);
        strPost += "&CT_RFC=" + document.getElementById("CT_RFC").value;
        strPost += "&CT_GIRO=" + document.getElementById("CT_GIRO").value;
        strPost += "&CT_SEDE=" + document.getElementById("CT_SEDE").value;
        strPost += "&CT_NOMBRE=" + document.getElementById("CT_CONTACTO_ENTRADA").value;
        strPost += "&CT_CONTACTO=" + document.getElementById("CT_CONTACTO").value;
        strPost += "&CT_CONTACTO2=" + document.getElementById("CT_CONTACTO2").value;
        strPost += "&CT_AREA=" + document.getElementById("CT_AREA").value;
        strPost += "&CT_CORREO=" + document.getElementById("CT_CORREO").value;
        strPost += "&CT_CORREO2=" + document.getElementById("CT_CORREO2").value;
        strPost += "&CT_CONMUTADOR=" + document.getElementById("CT_CONMUTADOR").value;
        strPost += "&CT_FECHA=" + document.getElementById("CT_FECHA").value;
        strPost += "&CT_HORA=" + document.getElementById("CT_HORA").value;
        strPost += "&CT_COMENTARIOS=" + document.getElementById("CT_COMENTARIOS").value;
        strPost += "&CT_COMENTARIO=" + document.getElementById("CT_COMENTARIO").value;
        strPost += "&CT_MAILMES=" + intMailMes;
        strPost += "&CT_CP=" + document.getElementById("CT_CP").value;
        strPost += "&CT_CALLE=" + encodeURIComponent(document.getElementById("CT_CALLE").value);
        strPost += "&CT_COL=" + document.getElementById("CT_COL").value;
        strPost += "&CT_MUNI=" + document.getElementById("CT_MUNI").value;
        strPost += "&CT_EDO=" + document.getElementById("CT_EDO").value;
        strPost += "&CT_NUM=" + document.getElementById("CT_NUM").value;
        strPost += "&exp_pro=" + document.getElementById("exp_pro").value;
        strPost += "&coment=" + document.getElementById("CT_COMENTARIOS").value;
        strPost += "&fecha=" + document.getElementById("CT_FECHA").value;
        strPost += "&hora=" + document.getElementById("CT_HORA").value;
        var grid = jQuery("#GRIDCONTACTOS");
        var idArrC = grid.getDataIDs();
        for (var i = 0; i < idArrC.length; i++) {
            var id = idArrC[i];
            var lstRow = grid.getRowData(id);
            strPost += "&CCO_TITULO" + i + "=" + lstRow.CCO_TITULO + "";
            strPost += "&CCO_NOMBRE" + i + "=" + lstRow.CCO_NOMBRE + "";
            strPost += "&CCO_APPATERNO" + i + "=" + lstRow.CCO_APPATERNO + "";
            strPost += "&CCO_APMATERNO" + i + "=" + lstRow.CCO_APMATERNO + "";
            strPost += "&CCO_NOSOCIO" + i + "=" + lstRow.CCO_NOSOCIO + "";
            strPost += "&CCO_AREA" + i + "=" + lstRow.CCO_AREA + "";
            strPost += "&CCO_ASOCIACION" + i + "=" + lstRow.CCO_ASOCIACION + "";
            strPost += "&CCO_CORREO" + i + "=" + lstRow.CCO_CORREO + "";
            strPost += "&CCO_CORREO2" + i + "=" + lstRow.CCO_CORREO2 + "";
            strPost += "&CT_MAILMES2" + i + "=" + lstRow.MAILMES2 + "";
            strPost += "&CCO_TELEFONO" + i + "=" + lstRow.CCO_TELEFONO + "";
            strPost += "&CCO_EXTENCION" + i + "=" + lstRow.CCO_EXTENCION + "";
            strPost += "&CCO_ALTERNO" + i + "=" + lstRow.CCO_ALTERNO + "";
        }
        strPost += "&length_contactos=" + idArrC.length;
        var grid = jQuery("#GRD_RZN");
        var idArrR = grid.getDataIDs();
        for (var i = 0; i < idArrR.length; i++) {
            var id = idArrR[i];
            var lstRow = grid.getRowData(id);
            strPost += "&RZN_NOMBRE" + i + "=" + lstRow.RZN_NOMBRE + "";
        }
        strPost += "&length_razon=" + idArrR.length;

        $("#dialogWait").dialog("open");
        $.ajax({
            type: "POST",
            data: encodeURI(strPost),
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "COFIDE_Telemarketing.jsp?ID=30",
            success: function (dato) {
                dato = trim(dato);
                if (dato == "OK") {
                    tmp_Limpiar();
                } else {
                    alert(dato);
                }
                $("#dialogWait").dialog("close");
            }});
    } else {
        alert("Ya tienes un registro pendiente");
    }
}

function tmp_Mostrar(strID_CTE) {
    var strPost = "";
    strPost = "cte_manual=" + strID_CTE;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=31",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                if (objcte.getAttribute("CT_ID") != 0) {
                    document.getElementById("CT_ID").value = objcte.getAttribute("CT_ID");
                    document.getElementById("CT_ID_CLIENTE").value = objcte.getAttribute("CT_ID_CLIENTE");
                    document.getElementById("CT_RAZONSOCIAL").value = objcte.getAttribute("CT_RAZONSOCIAL");
                    document.getElementById("CT_NO_CLIENTE").value = objcte.getAttribute("CT_ID");
                    document.getElementById("CT_RFC").value = objcte.getAttribute("CT_RFC");
                    document.getElementById("CT_COL").value = objcte.getAttribute("CT_COLONIA");
                    document.getElementById("CT_CONTACTO").value = objcte.getAttribute("CT_TELEFONO1");
                    document.getElementById("CT_CONTACTO2").value = objcte.getAttribute("CT_TELEFONO2");
                    document.getElementById("CT_CORREO").value = objcte.getAttribute("CT_EMAIL1");
                    document.getElementById("CT_CORREO2").value = objcte.getAttribute("CT_EMAIL2");
                    document.getElementById("CT_CP").value = objcte.getAttribute("CT_CP");
                    document.getElementById("CT_COL").value = objcte.getAttribute("CT_COL");
                    document.getElementById("CT_COLONIA_DB").value = objcte.getAttribute("CT_COL");
                    document.getElementById("CT_CALLE").value = objcte.getAttribute("CT_CALLE");
                    document.getElementById("CT_EDO").value = objcte.getAttribute("CT_EDO");
                    document.getElementById("CT_MUNI").value = objcte.getAttribute("CT_MUNI");
                    document.getElementById("CT_NUM").value = objcte.getAttribute("CT_NUMERO");
                    document.getElementById("CT_SEDE").value = objcte.getAttribute("CT_SEDE");
                    document.getElementById("CT_GIRO").value = objcte.getAttribute("CT_GIRO");
                    document.getElementById("CT_AREA").value = objcte.getAttribute("CT_AREA");
                    document.getElementById("CT_COMENTARIO").value = objcte.getAttribute("EV_ASUNTO");
                    document.getElementById("CT_CONMUTADOR").value = objcte.getAttribute("CT_CONMUTADOR");
                    document.getElementById("CT_CONTACTO_ENTRADA").value = objcte.getAttribute("CT_CONTACTO");
                    document.getElementById("CT_COMENTARIOS").value = objcte.getAttribute("CT_COMENTARIOS");
                    document.getElementById("CT_FECHA").value = objcte.getAttribute("CT_FECHA");
                    document.getElementById("CT_HORA").value = objcte.getAttribute("CT_HORA");
                    //ex participante
                    if (objcte.getAttribute("cte_prosp") == "0") { //verde
                        document.getElementById("exp_pro").value = 0;
                        document.getElementById("CT_CTE").innerHTML = "<table>"
                                + "<tr>"
                                + '<td class=\'ExParticipante\'><i class = "fa fa-user" title="EX-Participante" style="font-size:55px;"></i></td>'
                                + "</tr>"
                                + "</table>";
                    } else { //gris
                        document.getElementById("exp_pro").value = 1;
                        document.getElementById("CT_CTE").innerHTML = "<table>"
                                + "<tr>"
                                + '<td class=\'Prospecto\'><i class = "fa fa-user" title="Prospecto" style="font-size:55px;"></i></td>'
                                + "</tr>"
                                + "</table>";
                    }
                    var bolMail = false;
                    if (objcte.getAttribute("envio_mail") == 1) {
                        bolMail = true;
                    }
                    document.getElementById("CT_MAILMES").checked = bolMail;


                    HtmlBoton(objcte.getAttribute("bolBase"), objcte.getAttribute("CT_TELEFONO1"), objcte.getAttribute("CT_EMAIL1"), true);
                    LoadContactosTmp(strID_CTE);
                } else {
                    HtmlBoton("false", "", "", false);
                }
            }
        }, error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }});
    document.getElementById("BTN_ADD").parentNode.parentNode.style.display = "none";
    document.getElementById("BTN_CANCEL").parentNode.parentNode.style.display = "none";
    document.getElementById("BTN_NEW").parentNode.parentNode.style.display = "";
    document.getElementById("BTN_DEL").parentNode.parentNode.style.display = "";
    document.getElementById("CT_COMENTARIO").value = ""; //limpia comentario despues de guardar
}

function tmp_Limpiar() {
    document.getElementById("CT_MAILMES").checked == false;
    document.getElementById("CT_ID").value = 0
    document.getElementById("CT_NO_CLIENTE").value = 0
    document.getElementById("CT_RAZONSOCIAL").value = "";
    document.getElementById("CT_RFC").value = "";
    document.getElementById("CT_GIRO").value = "";
    document.getElementById("CT_SEDE").value = "";
    document.getElementById("CT_CONTACTO_ENTRADA").value = "";
    document.getElementById("CT_CONTACTO").value = "";
    document.getElementById("CT_CONTACTO2").value = "";
    document.getElementById("CT_AREA").value = "";
    document.getElementById("CT_CORREO").value = "";
    document.getElementById("CT_CORREO2").value = "";
    document.getElementById("CT_CONMUTADOR").value = "";
    document.getElementById("CT_FECHA").value = "";
    document.getElementById("CT_HORA").value = "";
    document.getElementById("CT_COMENTARIOS").value = "";
    document.getElementById("CT_COMENTARIO").value = "";
    document.getElementById("CT_CP").value = "";
    document.getElementById("CT_CALLE").value = "";
    document.getElementById("CT_COL").value = "";
    document.getElementById("CT_MUNI").value = "";
    document.getElementById("CT_EDO").value = "";
    document.getElementById("CT_NUM").value = "";
    jQuery("#GRIDCONTACTOS").clearGridData();
    jQuery("#GRD_RZN").clearGridData();
}
function OpnCtePendiente() {
    var objSecModiVta = objMap.getScreen("CTE_PENDIENTE");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("CTE_PENDIENTE", "grid", "dialogCte", false, false, true);
}
function dblClickCteTmp(id) {
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#CTE_PENDIENTE"); //grid o pantalla
    var lstVal = grid.getRowData(id);
    if (strNomMain == "CTE_PENDIENTE") { //pantalla
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_TELEM") {
            var strCte = lstVal.CT_ID;
            tmp_Mostrar(strCte);
            getIndicadores();
            $("#dialogCte").dialog("close");
        }
    }
}

function LoadContactosTmp(strCT_ID) {
    jQuery("#GRIDCONTACTOS").clearGridData();
    if (strCT_ID != "") {
        var strPost = "CT_ID=" + strCT_ID;
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=32",
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
                        CCO_AREA: objcte.getAttribute("CCO_AREA"),
                        CCO_ASOCIACION: objcte.getAttribute("CCO_ASOCIACION"),
                        CCO_CORREO: objcte.getAttribute("CCO_CORREO"),
                        CCO_CORREO2: objcte.getAttribute("CCO_CORREO2"),
                        CCO_TELEFONO: objcte.getAttribute("CCO_TELEFONO"),
                        CCO_EXTENCION: objcte.getAttribute("CCO_EXTENCION"),
                        CCO_ALTERNO: objcte.getAttribute("CCO_ALTERNO")};
                    itemIdCob++;
                    jQuery("#GRIDCONTACTOS").addRowData(itemIdCob, datarow, "last");
                }
                LoadRazonTmp(strCT_ID);
            }, error: function (objeto, quepaso, otroobj) {
                alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
            }});
    }
}

function LoadRazonTmp(strCT_ID) {
    jQuery("#GRD_RZN").clearGridData();
    var strPost = "CT_ID=" + strCT_ID;
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=33",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("vta")[0];
            var lstCte = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstCte.length; i++) {
                var objcte = lstCte[i];
                var datarow = {
                    RZN_ID: objcte.getAttribute("RZN_ID"),
                    RZN_CTE: objcte.getAttribute("RZN_CTE"),
                    RZN_NOMBRE: objcte.getAttribute("RZN_NOMBRE")
                };
                itemIdCob++;
                jQuery("#GRD_RZN").addRowData(itemIdCob, datarow, "last");
            }
        }, error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }});
}
//historial de ventas
function dblClickVTA_cte(id) { //abre la venta con doble click
    var strID_FAC_TKT = "";
    var strTipoDoc = "";
    var strNomMain = objMap.getNomMain();
    var grid = jQuery("#H_VENTA_CTE"); //grid detalle
    var lstVal = grid.getRowData(id);
    if (strNomMain == "H_VENTA_CTE") { //pantalla que lo contiene
        OpnEdit(document.getElementById("Ed" + strNomMain));
    } else {
        if (strNomMain == "C_TELEM") { //pantalla base
            var strID_FAC_TKT = lstVal.PD_ID; //id fac o tkt
            var strTipoDoc = lstVal.DOC_TIPO; // tipo de documento
            //funcion
            document.getElementById("CT_ID_FACTKT").value = strID_FAC_TKT; // se guarda el id en un hidden           
            document.getElementById("CT_TIPODOC").value = strTipoDoc; // se guarda el id en un hidden           
            document.getElementById("CT_GRID").value = "0"; //cte
            //Vta_Deta(strID_FAC_TKT, strTipoDoc);
            OpnDiagVentaD();
        }
    }
}
function HistorialVtaCte(strCT_ID) { //carga el historial de venta
    var strPagado = "";
    var strStatus = "";
    var strTipoDoc = "";
    $("#dialogWait").dialog("open");
    var strPOST = "&intCTE=" + strCT_ID;
    $.ajax({
        type: "POST",
        data: strPOST,
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Historial.jsp?ID=3",
        success: function (datos) {
            jQuery("#H_VENTA_CTE").clearGridData();
            var objsc = datos.getElementsByTagName("Ventas")[0];
            var lstVtas = objsc.getElementsByTagName("datos");
            for (var i = 0; i < lstVtas.length; i++) {
                var obj = lstVtas[i];
                if (obj.getAttribute("FAC_PAGADO") == 1) {
                    strPagado = "Pagado";
                } else {
                    strPagado = "Pendiente";
                }
                if (obj.getAttribute("FAC_ANULADA") == 1) {
                    strStatus = "Cancelada";
                } else {
                    strStatus = "Activa";
                }
                if (obj.getAttribute("DOC_TIPO") == "1") {
                    strTipoDoc = "FAC";
                } else {
                    strTipoDoc = "TKT";
                }
                var Row = {
                    HV_CONTADOR: obj.getAttribute("CONTADOR"),
                    PD_ID: obj.getAttribute("FAC_ID"),
                    PD_FECHA: obj.getAttribute("FAC_FECHA"),
                    PD_HORA: obj.getAttribute("FAC_HORA"),
                    PD_RAZONSOCIAL: obj.getAttribute("RAZONSOCIAL"),
                    EMP_ID: obj.getAttribute("AGENTE"),
                    FAC_TOTAL: obj.getAttribute("FAC_TOTAL"),
                    PD_FOLIO: obj.getAttribute("FAC_FOLIO"),
                    FAC_METODODEPAGO: obj.getAttribute("FAC_METODODEPAGO"),
                    PD_TOTAL: obj.getAttribute("FAC_TOTAL"),
                    DOC_TIPO: strTipoDoc,
                    FAC_PAGADO: strPagado,
                    FAC_STATUS: strStatus,
                    CT_ID: obj.getAttribute("CT_ID"),
                    SC_ID: obj.getAttribute("SC_ID")
                };
                itemIdVta++;
                jQuery("#H_VENTA_CTE").addRowData(itemIdVta, Row, "last");
            }
            $("#dialogWait").dialog("close");
        }, error: function (objeto, quepaso, otroobj) {
            alert(":ptoExist:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }});
}

function OpnDiagVentaD() { //abre el detalle de la venta
    var objSecModiVta = objMap.getScreen("NVENTA");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt("NVENTA", "_ed", "dialog", false, false, true);
}
function CancelMovCte() {
    var strFAC_ID = 0;
    var strTipoDoc = "";
    var strStat = "";
    var strTKT_ID = 0;
    var strPost = "";
    var grid = jQuery("#H_VENTA_CTE");
    if (grid.getGridParam("selrow") != null) {
        var lstRow = grid.getRowData(grid.getGridParam("selrow"));
        strFAC_ID = lstRow.PD_ID;
        strTipoDoc = lstRow.DOC_TIPO;
        strStat = lstRow.FAC_STATUS;
        $("#dialogWait").dialog("open");
        if (strStat == "Activa") {
            if (lstRow.FAC_PAGADO == "Pendiente") {
                //inicio de si o no
                document.getElementById("SioNO_inside").innerHTML = "¿Estas seguro de cancelar este documento!?";
                $("#SioNO").dialog("open");
                document.getElementById("btnSI").onclick = function () {
                    $("#SioNO").dialog("close");

                    strPost = "fac_id=" + strFAC_ID;
                    strPost += "&tipo_doc=" + strTipoDoc;
                    $.ajax({
                        type: "POST",
                        data: strPost,
                        scriptCharset: "utf-8",
                        contentType: "application/x-www-form-urlencoded;charset=utf-8",
                        cache: false,
                        dataType: "xml",
                        url: "COFIDE_Telemarketing_vta.jsp?ID=10",
                    });
                    HistorialVtaCte(document.getElementById("CT_ID").value); //historial de vta por cte
                    drawRightPanel(); //actualiza el monto de ventas
                }; //fin de si o no SI
                document.getElementById("btnNO").onclick = function () {
                    $("#SioNO").dialog("close");
                }; //sin de si o no NO
            } else {
                alert("Este Documento ya ha sido pagado");
            }
            $("#dialogWait").dialog("close");
        } else {
            alert("Este documento ya ha sido cancelado");
            $("#dialogWait").dialog("close");
        }
    } else {
        alert("Debe seleccionar una partida en la tabla \"HISTORIAL DE VENTAS\"");
    }
}
//historial de ventas


function checkInBound() {
    $("#dialogWait").dialog("open");
    var strPost = "";
    $.ajax({
        type: "POST",
        data: strPost,
        scriptCharset: "UTF-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "COFIDE_Telemarketing_vta.jsp?ID=11",
        success: function (datos) {
            if (datos.substring(0, 2) == "OK") {
                document.getElementById("CT_CLAVE_DDBB").value = datos.replace("OK", "").trim();
                $("#dialogWait").dialog("close");
            } else {
                alert("GetBaseUsuario: " + datos);
                $("#dialogWait").dialog("close");
            }
            $("#dialogWait").dialog("close");
        }
    }); //fin del ajax
}//Fin isUnBound

function blockDatosInBound() {
    document.getElementById("CT_ID").readOnly = true;
    document.getElementById("CT_ID_CLIENTE").readOnly = true;
    document.getElementById("CT_RAZONSOCIAL").readOnly = true;
    document.getElementById("CT_NO_CLIENTE").readOnly = true;
    document.getElementById("CT_RFC").readOnly = true;
    document.getElementById("CT_COL").readOnly = true;
    document.getElementById("CT_CONTACTO").readOnly = true;
    document.getElementById("CT_CONTACTO2").readOnly = true;
    document.getElementById("CT_CORREO").readOnly = true;
    document.getElementById("CT_CORREO2").readOnly = true;
    document.getElementById("CT_BOLBASE").readOnly = true;
    document.getElementById("CT_HORA_INI").readOnly = true;
    document.getElementById("CT_CP").readOnly = true;
    document.getElementById("CT_COL").disabled = true;
    document.getElementById("CT_COLONIA_DB").readOnly = true;
    document.getElementById("CT_CALLE").readOnly = true;
    document.getElementById("CT_EDO").readOnly = true;
    document.getElementById("CT_MUNI").readOnly = true;
    document.getElementById("CT_NUM").readOnly = true;
    document.getElementById("CT_SEDE").disabled = true;
    document.getElementById("CT_GIRO").disabled = true;
    document.getElementById("CT_AREA").disabled = true;
    document.getElementById("CT_COMENTARIO").readOnly = true;
    document.getElementById("CT_ID_LLAMADA").readOnly = true;
    document.getElementById("CT_CONMUTADOR").readOnly = true;
    document.getElementById("CT_CONTACTO_ENTRADA").readOnly = true;
    document.getElementById("BTN_NEW").style.display = 'none';
    document.getElementById("BTN_EDIT").style.display = 'none';
    document.getElementById("BTN_DEL").style.display = 'none';
    document.getElementById("BTN_ADD").style.display = 'none';
    document.getElementById("BTN_CANCEL").style.display = 'none';
    document.getElementById("BTN_RNEW").style.display = 'none';
    document.getElementById("BTN_REDIT").style.display = 'none';
    document.getElementById("BTN_RDEL").style.display = 'none';
    document.getElementById("BTN_RSAVE").style.display = 'none';
    document.getElementById("BTN_RCANCEL").style.display = 'none';
}//Fin blockDatosInBound

function UnlockDatosInBound() {
    document.getElementById("CT_ID").readOnly = false;
    document.getElementById("CT_ID_CLIENTE").readOnly = false;
    document.getElementById("CT_RAZONSOCIAL").readOnly = false;
    document.getElementById("CT_NO_CLIENTE").readOnly = false;
    document.getElementById("CT_RFC").readOnly = false;
    document.getElementById("CT_COL").readOnly = false;
    document.getElementById("CT_CONTACTO").readOnly = false;
    document.getElementById("CT_CONTACTO2").readOnly = false;
    document.getElementById("CT_CORREO").readOnly = false;
    document.getElementById("CT_CORREO2").readOnly = false;
    document.getElementById("CT_BOLBASE").readOnly = false;
    document.getElementById("CT_HORA_INI").readOnly = false;
    document.getElementById("CT_CP").readOnly = false;
    document.getElementById("CT_COL").disabled = false;
    document.getElementById("CT_COLONIA_DB").readOnly = false;
    document.getElementById("CT_CALLE").readOnly = false;
    document.getElementById("CT_EDO").readOnly = false;
    document.getElementById("CT_MUNI").readOnly = false;
    document.getElementById("CT_NUM").readOnly = false;
    document.getElementById("CT_SEDE").disabled = false;
    document.getElementById("CT_GIRO").disabled = false;
    document.getElementById("CT_AREA").disabled = false;
    document.getElementById("CT_COMENTARIO").readOnly = false;
    document.getElementById("CT_ID_LLAMADA").readOnly = false;
    document.getElementById("CT_CONMUTADOR").readOnly = false;
    document.getElementById("CT_CONTACTO_ENTRADA").readOnly = false;
    document.getElementById("BTN_NEW").style.display = 'block';
    document.getElementById("BTN_EDIT").style.display = 'block';
    document.getElementById("BTN_DEL").style.display = 'block';
    document.getElementById("BTN_ADD").style.display = 'block';
    document.getElementById("BTN_CANCEL").style.display = 'block';
    document.getElementById("BTN_RNEW").style.display = 'block';
    document.getElementById("BTN_REDIT").style.display = 'block';
    document.getElementById("BTN_RDEL").style.display = 'block';
    document.getElementById("BTN_RSAVE").style.display = 'block';
    document.getElementById("BTN_RCANCEL").style.display = 'block';
}//Fin blockDatosInBound

function hiddeFunctionInboundSave() {
    //drawRightPanel();
    var strHtmlBTN = "<center><table border='0' width='0%' align='center'>" //botones de agregar nuevo cliente, error en base, actualizar 
            + "<tr>"
            + "<td>&nbsp;</td>"
            + "<tr>"
            + '<td><a href="javascript:OpnNewCte()" class=\'cofide_venta\'><i class = "fa fa-user-plus" title="Agregar Prospecto" style="font-size:50px; width:110px"></i></td>'
            + "</tr>";
    "</table></center>";
    document.getElementById("btnadd").innerHTML = strHtmlBTN; //botones de marcar y mandar email

    var strHtmlTitle = "<table border='0' width='0%' align='center'>"
            + "<tr>"
            + '<td><a href="javascript:OpnMotorBusqueda()" class=\'cofide_search\'><i class = "fa fa-search-plus" title="Motor de Busqueda" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:tmp_Guardar()" class=\'cofide_changei\'><i class = "fa fa-step-forward" title="Cambiar Llamada" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnDiagHCall()" class=\'cofide_histl\'><i class = "fa fa-clock-o" title="Historial de Llamadas" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnDiagHVenta()" class=\'cofide_histv\'><i class = "fa fa-money" title="Historial de Ventas" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnEdoCtaCte()" class=\'cofide_edo_cta\'><i class = "fa fa-usd" title="Estado de Cuenta" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnDiagCActivo()" class=\'cofide_calcurso\'><i class = "fa fa-calendar" title="Calendario de Cursos" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:SendMailContacto()" class=\'cofide_message\'><i class = "fa fa-at" title="Mail Group"style="font-size:40px; width: 110px"></i></a></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnPausarLlamada()" class=\'cofide_pausa\'><i class = "fa fa-pause" title="Pausar Llamada" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnSalirLlamada()" class=\'cofide_salida\'><i class = "fa fa-sign-out" title="Salir"  style="font-size:30px; width:110px"></i></td>'
            + "</tr>";
    "</table>";
    document.getElementById("CT_TITLEBTN").innerHTML = strHtmlTitle;
}

function showBtnSaveInBound() {
    var strHtmlBTN = "<center><table border='0' width='0%' align='center'>" //botones de agregar nuevo cliente, error en base, actualizar 
            + "<tr>"
            + "<td>&nbsp;</td>"
            + "<tr>"
            + '<td><a href="javascript:OpnNewCte()" class=\'cofide_venta\'><i class = "fa fa-user-plus" title="Agregar Prospecto" style="font-size:50px; width:110px"></i></td>'
            + "<td>&nbsp;</td>";
    if (document.getElementById("exp_pro").value == 1) {
        strHtmlBTN += '<td><a href="javascript:errorbase()" class=\'cofide_err\'><i class = "fa fa-trash" title="Error en Base" style="font-size:50px; width:110px"></i></td>'
                + "<td>&nbsp;</td>";
    }

    strHtmlBTN += '<td><a href="javascript:UpDateCte()" class=\'updatecte\'><i class = "fa fa-refresh" title="Actualiza Cliente" style="font-size:50px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + "</tr>";
    "</table></center>";
    document.getElementById("btnadd").innerHTML = strHtmlBTN; //botones de marcar y mandar email
    var strHtmlTitle = "<table border='0' width='0%' align='center'>"
            + "<tr>"
            + '<td><a href="javascript:OpnMotorBusqueda()" class=\'cofide_search\'><i class = "fa fa-search-plus" title="Motor de Busqueda" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:tmp_Guardar()" class=\'cofide_changei\'><i class = "fa fa-step-forward" title="Cambiar Llamada" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnDiagHCall()" class=\'cofide_histl\'><i class = "fa fa-clock-o" title="Historial de Llamadas" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnDiagNVenta()" class=\'cofide_venta\'><i class = "fa fa-cart-plus" title="Ventas" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnDiagHVenta()" class=\'cofide_histv\'><i class = "fa fa-money" title="Historial de Ventas" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnEdoCtaCte()" class=\'cofide_edo_cta\'><i class = "fa fa-usd" title="Estado de Cuenta" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnDiagCActivo()" class=\'cofide_calcurso\'><i class = "fa fa-calendar" title="Calendario de Cursos" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:SendMailContacto()" class=\'cofide_message\'><i class = "fa fa-at" title="Mail Group"style="font-size:40px; width: 110px"></i></a></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:saveDetaTMK()" class=\'cofide_guarda\'><i class = "fa fa-floppy-o" title="Guardar Cambios" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnPausarLlamada()" class=\'cofide_pausa\'><i class = "fa fa-pause" title="Pausar Llamada" style="font-size:30px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:OpnSalirLlamada()" class=\'cofide_salida\'><i class = "fa fa-sign-out" title="Salir"  style="font-size:30px; width:110px"></i></td>'
            + "</tr>";
    "</table>";
    document.getElementById("CT_TITLEBTN").innerHTML = strHtmlTitle;
}

function selectBaseCliente() {
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
                    opnShowBasesClientes();
                    document.getElementById("CT_PERMISO_INBOUND").value = 1;
                } else {
                    document.getElementById("CT_PERMISO_INBOUND").value = 0;
                }
            }
            $("#dialogWait").dialog("close");
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto:" + objeto + " " + quepaso + " " + otroobj);
        }
    });
}//Fin selectBaseCliente

function opnShowBasesClientes() {
    var objSecModiVta = objMap.getScreen("SELECT_BASE");
    if (objSecModiVta != null) {
        objSecModiVta.bolActivo = false;
        objSecModiVta.bolMain = false;
        objSecModiVta.bolInit = false;
        objSecModiVta.idOperAct = 0;
    }
    OpnOpt('SELECT_BASE', '_ed', 'dialogCte', false, false, true);
}//Fin opnShowBasesClientes

function initSelectBaseCt() {
    var strHtmlBTN = "<center><table border='0' width='0%' align='center'>" //botones de agregar nuevo cliente, error en base, actualizar 
            + "<tr>"
            + "<td>&nbsp;</td>"
            + "<tr>"
            + '<td><a href="javascript:setBaseUsuario()" class=\'cofide_venta\'><i class = "fa fa-check" title="Confirmar" style="font-size:50px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + '<td><a href="javascript:exitSelectBaseCt()" class=\'cofide_err\'><i class = "fa fa-sign-out" title="Salir" style="font-size:50px; width:110px"></i></td>'
            + "<td>&nbsp;</td>"
            + "</tr>";
    "</table></center>";
    document.getElementById("DIV_BASE_USER").innerHTML = strHtmlBTN;
    SeleccionaBaseUsuarioInbound();
}//Fin initSelectBaseCt

function setBaseUsuario() {
    if (document.getElementById("BaseUserSelect").value != "0" && document.getElementById("BaseUserSelect").value != 0) {
        document.getElementById("CT_CLAVE_DDBB").value = document.getElementById("BaseUserSelect").value;
        $("#dialogCte").dialog("close");
    } else {
        alert("Seleccione una Base")
    }
}//Fin setBaseUsuario

function exitSelectBaseCt() {
    $("#dialogCte").dialog("close");
    myLayout.open("west");
    myLayout.open("east");
    myLayout.open("south");
    myLayout.open("north");
    document.getElementById("MainPanel").innerHTML = "";
    //Limpiamos el objeto en el framework para que nos deje cargarlo enseguida
    var objMainFacPedi = objMap.getScreen("C_TELEM");
    objMainFacPedi.bolActivo = false;
    objMainFacPedi.bolMain = false;
    objMainFacPedi.bolInit = false;
    objMainFacPedi.idOperAct = 0;
}//Fin exitSelectBaseCt

function SeleccionaBaseUsuarioInbound() {

    var strOptionSelect = "<option value='0'>Seleccione</option>";
    var strHTML = "<table cellpadding=\"4\" cellspacing=\"1\" border=\"0\" >BODEGA: ";
    strHTML += " <td><select style=\"font-size:15pt\" id=\"BaseUserSelect\" name=\"BaseUserSelect\"  class=\"outEdit\" onblur=\"QuitaFoco(this)\" onfocus=\"PonFoco(this)\" 0=\"\" > " + strOptionSelect + " < /select></td>";
    strHTML += "  </table>";
    document.getElementById("SELECT_BASE_USER").innerHTML = strHTML;

    var strOptionSelect = "<option value='0'>Seleccione</option>";
    var strHTML = "<table style=\"font-size:15pt\" cellpadding=\"4\" cellspacing=\"1\" border=\"0\" >BASE CLIENTES: <br>";
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=34",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("BasesCt")[0];
            var lstprecio = lstXml.getElementsByTagName("datos");
            for (var i = 0; i < lstprecio.length; i++) {
                var obj = lstprecio[i];

                strOptionSelect += "<option value='" + obj.getAttribute("COFIDE_CODIGO") + "'>" + obj.getAttribute("COFIDE_CODIGO") + "</option>";
            }
            strHTML += " <select style=\"font-size:15pt\" id=\"BaseUserSelect\" name=\"BaseUserSelect\"  class=\"outEdit\" onblur=\"QuitaFoco(this)\" onfocus=\"PonFoco(this)\" 0=\"\" > " + strOptionSelect + " < /select>";
            strHTML += "  </table>";
            document.getElementById("SELECT_BASE_USER").innerHTML = strHTML;
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}//Fin SeleccionaBaseUsuarioInbound
function HtmlButtonCte() {
    var strCtes = "0";
    var strProsp = "0";
    $("#dialogWait").dialog("open");
    $.ajax({
        type: "POST",
        data: "",
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "xml",
        url: "COFIDE_Telemarketing.jsp?ID=39",
        success: function (datos) {
            var lstXml = datos.getElementsByTagName("datos")[0];
            var lstprecio = lstXml.getElementsByTagName("cte");
            for (var i = 0; i < lstprecio.length; i++) {
                var obj = lstprecio[i];
                strCtes = obj.getAttribute("cliente");
                strProsp = obj.getAttribute("prospecto");
            }
            var strHTMLcte = "<table border='0' width='0%' align='center'>"
                    + "<tr>"
                    + '<td><a href="javascript:OpnSearchCustomer()" style=\'color: gray\'><i class = "fa fa-user" title="Buscar Prospectos" style="font-size:30px; width:110px">' + strProsp + '</i></td>'
                    + "<td>&nbsp;</td>"
                    + '<td><a href="javascript:OpnSearchCustomer2()" style=\'color: green\'><i class = "fa fa-user" title="Buscar Ex-Participantes" style="font-size:30px; width:110px"> ' + strCtes + '</i></td>'
                    + "<td>&nbsp;</td>"
                    + "</tr>";
            "</table>";
            $("#dialogWait").dialog("close");
            document.getElementById("MB_CTE").innerHTML = strHTMLcte;
        },
        error: function (objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });
}
/**
 * valida los correos que estan 
 * dentro del grid de contactos 
 * para no duplicarlos dentro de 
 * un mismo cliente
 * @returns {Boolean}
 */
function validaCorreo() {
    var bolDuplicado = false;
    var strCorreo = document.getElementById("CCO_CORREO").value;
    var strCorreo2 = document.getElementById("CCO_CORREO2").value;
    var grid = jQuery("#GRIDCONTACTOS");
    var idArr = grid.getDataIDs();
    for (var i = 0; i < idArr.length; i++) {
        var id = idArr[i];
        var lstRow = grid.getRowData(id);
        if (strCorreo != "") {
            if (lstRow.CCO_CORREO == strCorreo) {
                bolDuplicado = true;
                document.getElementById("CCO_CORREO").value = "";
            }
            if (lstRow.CCO_CORREO2 == strCorreo) {
                bolDuplicado = true;
                document.getElementById("CCO_CORREO").value = "";
            }
        }
        if (strCorreo2 != "") {
            if (lstRow.CCO_CORREO == strCorreo2) {
                bolDuplicado = true;
                document.getElementById("CCO_CORREO2").value = "";
            }
            if (lstRow.CCO_CORREO2 == strCorreo2) {
                bolDuplicado = true;
                document.getElementById("CCO_CORREO2").value = "";
            }
        }
    }
    return bolDuplicado;
}

function beforeAddContacMail1(opc, row) {
    var intIDCte = "0";
    var strCorreo = "";
    if (opc == 3) {
        if (!validaCorreo()) {
            strCorreo = document.getElementById("CCO_CORREO").value;
            intIDCte = document.getElementById("CT_NO_CLIENTE").value;
        } else {
            alert("Este correo ya existe en este cliente");
        }
    }
    if (opc == 4) {
        if (!validaCorreo()) {
            strCorreo = document.getElementById("CCO_CORREO2").value;
            intIDCte = document.getElementById("CT_NO_CLIENTE").value;
        } else {
            alert("Este correo ya existe en este cliente");
        }
    }
    if (strCorreo != "") {
        var strPost = "correo=" + strCorreo;
        strPost += "&idcte=" + intIDCte;
        var strRespuestaLN = "";
        var strRespuestaDup = "";
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=24",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    strRespuestaLN = objcte.getAttribute("listanegra");
                    strRespuestaDup = objcte.getAttribute("duplicado");
                    if (strRespuestaLN == "0" && strRespuestaDup == "0") {
                        beforeAddContacMailAlt(opc, row);
                    } else {
                        if (strRespuestaDup == "1") {
                            alert("El Correo esta Duplicado");
                        }
                        if (strRespuestaLN == "1") {
                            alert("El Correo esta en la lista negra");
                        }
                    }
                }
            }});
    }
}

function beforeAddContacMailAlt(opc, row) {
    var intIDCte = "0";
    var strCorreo = "";
    if (opc == 3) {
        if (!validaCorreo()) {
            strCorreo = document.getElementById("CCO_CORREO").value;
            intIDCte = document.getElementById("CT_NO_CLIENTE").value;
        } else {
            alert("Este correo ya existe en este cliente");
        }
    }
    if (opc == 4) {
        if (!validaCorreo()) {
            strCorreo = document.getElementById("CCO_CORREO2").value;
            intIDCte = document.getElementById("CT_NO_CLIENTE").value;
        } else {
            alert("Este correo ya existe en este cliente");
        }
    }
    if (strCorreo != "") {
        var strPost = "correo=" + strCorreo;
        strPost += "&idcte=" + intIDCte;
        var strRespuestaLN = "";
        var strRespuestaDup = "";
        $.ajax({
            type: "POST",
            data: strPost,
            scriptCharset: "UTF-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "xml",
            url: "COFIDE_Telemarketing.jsp?ID=24",
            success: function (datos) {
                var lstXml = datos.getElementsByTagName("vta")[0];
                var lstCte = lstXml.getElementsByTagName("datos");
                for (var i = 0; i < lstCte.length; i++) {
                    var objcte = lstCte[i];
                    strRespuestaLN = objcte.getAttribute("listanegra");
                    strRespuestaDup = objcte.getAttribute("duplicado");
                    if (strRespuestaLN == "0" && strRespuestaDup == "0") {
                        ///RESULTADObeforeAddContacMailAlt(opc, row);
                        LimpiarGrid(1);
                        hideContactosTMK();
                        jQuery("#GRIDCONTACTOS").addRowData(getMaxGridContactos("#GRIDCONTACTOS"), row, "last");
                    } else {
                        if (strRespuestaDup == "1") {
                            alert("El Correo esta Duplicado");
                        }
                        if (strRespuestaLN == "1") {
                            alert("El Correo esta en la lista negra");
                        }
                    }
                }
            }});
    }
}


function getMaxGridContactos(strNomGr) {
    var intLenght = jQuery(strNomGr).getDataIDs().length + 1;
    return intLenght;
}//Fin getMaxGridCursosMaterial