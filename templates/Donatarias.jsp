<%-- 
    Document   : Donatarias
      Template para la donatarias
    Created on : 11-sep-2013, 14:05:27
    Author     : ZeusGalindo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Template factura donatarias</title>
        <link rel="stylesheet" type="text/css" href="../css/CIP_Main.css" />
    </head>
    <body>
    <center>

        <div class="titulo">CFDI HONORARIOS</div>
        <div class="titulosombra">1</div>
        <div id="ContenidoFactura">
            <div id="Encabezado">

            </div>
            <div id="Cuerpo">
                <table width="0%" cellpadding="1" class="table2" align="center">
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>FECHA</td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td><jsp:include page="calender.html"/></td>
                    </tr>
                    <tr>
                        <td colspan="2">NOMBRE DEL CLIENTE</td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="2"><input type="text" id="nombre" name="Nombre" value="" class="textCFDI" placeholder="NOMBRE CLIENTE"/> </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>RFC</td>
                        <td>FORMA DE PAGO</td>
                        <td>DESCRIPCION DEL SERVICIO</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><input type="text" id="rfc" name="RFC" value="" class="textRFC" placeholder="RFC"/> </td>
                        <td><input type="text" id="formadepago" name="FormadePago" value="EN UNA SOLA EXHIBICIÓN" class="textRFC" placeholder="FORMA DE PAGO"/> </td>
                        <td rowspan="4" colspan="2"><textarea id="descripcion" rows="10" name="Descripcion" placeholder="DESCRIPCIÓN" class="testDescripcion"></textarea> </td>
                    </tr>
                    <tr>
                        <td>CANTIDAD</td>
                        <td>METODO DE PAGO</td>
                    </tr>
                    <tr>
                        <td><input type="text" id="cantidad" name="Cantidad" value="" class="textPESOS" placeholder="CANTIDAD"/> </td>
                        <td><select name="metodo_pago" id="metodo" class="textMetodoPago">  
                                <option value="">Seleccione</option>
                                <option value="EFECTIVO">EFECTIVO</option>
                                <option value="CHEQUE">CHEQUE</option>
                                <option value="TARJETA DE CREDITO">TARJETA DE CREDITO</option>
                                <option value="TARJETA DE DEBITO">TARJETA DE DEBITO</option>
                                <option value="TRANSFERENCIA ELECTRONICA">TRANSFERENCIA ELECTRONICA</option>
                                <option value="NO IDENTIFICADO">NO IDENTIFICADO</option> 
                            </select>  </td>
                    </tr>
                    <tr>
                        <td>UNIDAD DE MEDIDA</td>
                        <td>NUMERO DE CUENTA</td>
                    </tr>
                    <tr>
                        <td><input type="text" id="unidadmedida" name="unidad_medida" value="" class="textPESOS" placeholder="UNIDAD DE MEDIDA"/> </td>
                        <td><input type="text" id="numcuenta" name="numero_cuenta" value="" class="textPESOS" placeholder="NUMERO DE CUENTA"/> </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>CONDICIONES DE PAGO</td>
                        <td></td>
                        <td>IMPORTE</td>
                    </tr>
                    <tr>
                        <td> </td>
                        <td><input type="text" id="condiciones" name="condiciones" value="" class="textPESOS" placeholder="CONDICIONES DE PAGO"/> </td>
                        <td><button id="bt1" name="btn1" class="textVISTA">VISTA PREVIA</button></td>
                        <td><input type="text" id="importe" name="Importe" value="" class="testImporte" placeholder="IMPORTE"/> </td>
                    </tr>
                </table><BR>
                <BR>
                <BR>
                <button id="bt2" name="btn2" onclick="Save_honoraios()">GUARDAR FACTURA</button>
            </div>
        </div>
    </center>
</body>
</html>

<script language="JavaScript" type="text/JavaScript"> 
   function Save_honoraios(){ 
       //alert("hola soy guardar"); 
    // alert("HOLA SOY GUARDAR");

    // $("#dialogPagos").dialog("close");
    $("#dialogWait").dialog("open");
    //Armamos el POST a enviar
    var strPOST = "";
    //Prefijos dependiendo del tipo de venta
    var strPrefijoMaster = "FAC";
    var strPrefijoDeta = "FACD";
    var strKey = "FAC_ID";
    var strNomFormat = "FACTURA";

    //Master
    //var insSucSave = intSucDefa;
    //var intCteSave = intCteDefa;
    //var strFechaActual = strHoyFecha;
    strPOST += "SC_ID=" + "1";
    strPOST += "&CT_ID=" + "1";
    strPOST += "&VE_ID=0";
    strPOST += "&PD_ID=1";
    strPOST += "&" + strPrefijoMaster + "_ESSERV=0";
    strPOST += "&" + strPrefijoMaster + "_MONEDA=0";
    strPOST += "&" + strPrefijoMaster + "_FECHA=" + "20131112";

    strPOST += "&" + strPrefijoMaster + "_NOTAS=" + "";
    strPOST += "&" + strPrefijoMaster + "_TOTAL=" + document.getElementById("importe").value;
    strPOST += "&" + strPrefijoMaster + "_IMPUESTO1=" + "0";
    strPOST += "&" + strPrefijoMaster + "_IMPUESTO2=" + "0";
    strPOST += "&" + strPrefijoMaster + "_IMPUESTO3=" + "0";
    strPOST += "&" + strPrefijoMaster + "_IMPORTE=" + document.getElementById("importe").value;
    strPOST += "&" + strPrefijoMaster + "_RETISR=" + "";
    strPOST += "&" + strPrefijoMaster + "_RETIVA=" + "";
    strPOST += "&" + strPrefijoMaster + "_NETO=" + "0.00";
    strPOST += "&" + strPrefijoMaster + "_NOTASPIE=" + "";
    strPOST += "&" + strPrefijoMaster + "_REFERENCIA=" + "";
    strPOST += "&" + strPrefijoMaster + "_CONDPAGO=" + document.getElementById("condiciones").value;
    strPOST += "&" + strPrefijoMaster + "_METODOPAGO=" + document.getElementById("metodo").value;
    strPOST += "&" + strPrefijoMaster + "_NUMCUENTA=" + document.getElementById("numcuenta").value;
    strPOST += "&" + strPrefijoMaster + "_FORMADEPAGO=" + document.getElementById("formadepago").value;
    strPOST += "&" + strPrefijoMaster + "_NUMPEDI=" + "";
    strPOST += "&" + strPrefijoMaster + "_FECHAPEDI=" + "";
    strPOST += "&" + strPrefijoMaster + "_ADUANA=" + "";
    strPOST += "&" + strPrefijoMaster + "_TIPOCOMP=" + "1";
    strPOST += "&TIPOVENTA=" + "";
    strPOST += "&" + strPrefijoMaster + "_TASA1=" + "0.00";
    strPOST += "&" + strPrefijoMaster + "_TASA2=" + "0.00";
    strPOST += "&" + strPrefijoMaster + "_TASA3=" + "0.00";
    strPOST += "&" + "TI_ID=" + "0";
    strPOST += "&" + "TI_ID2=" + "0";
    strPOST += "&" + "TI_ID3=" + "0";
    strPOST += "&" + strPrefijoMaster + "_TASAPESO=" + "1.0";
    strPOST += "&" + strPrefijoMaster + "_DIASCREDITO=" + "0";
    strPOST += "&" + strPrefijoMaster + "_POR_DESC=" + "";
    //TRASPORTE Y FLETE
    strPOST += "&TR_ID=" + "0";
    strPOST += "&ME_ID=" + "0";
    strPOST += "&TF_ID=" + "0";
    strPOST += "&" + strPrefijoMaster + "_NUM_GUIA=" + "";


    //MLM
    strPOST += "&" + strPrefijoMaster + "_PUNTOS=" + "";
    strPOST += "&" + strPrefijoMaster + "_NEGOCIO=" + "";

    //Validamos _CONSIGNACION
    if (document.getElementById("FAC_CONSIGNACION1") != null) {
        if (document.getElementById("FAC_CONSIGNACION1").checked) {
            strPOST += "&" + strPrefijoMaster + "_CONSIGNACION=1";
        } else {
            strPOST += "&" + strPrefijoMaster + "_CONSIGNACION=0";
        }
    } else {
        strPOST += "&" + strPrefijoMaster + "_CONSIGNACION=0";
    }
    strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD=" + "";
    strPOST += "&" + strPrefijoMaster + "_DIAPER=" + "";
    strPOST += "&" + strPrefijoMaster + "_NO_EVENTOS=" + "";
    var intC = 0;
            strPOST += "&PR_ID" + intC + "=" + "10";
        strPOST += "&" + strPrefijoDeta + "_EXENTO1" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_EXENTO2" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_EXENTO3" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_TASAIVA1" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_TASAIVA2" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_TASAIVA3" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO1" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO2" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO3" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_PORDESC" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_ESDEVO" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_PRECFIJO" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_UNIDAD_MEDIDA" + intC + "=" + document.getElementById("unidadmedida").value;
        strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_CVE" + intC + "=" + "0.0";
        strPOST += "&" + strPrefijoDeta + "_DESCRIPCION" + intC + "=" + document.getElementById("descripcion").value;
        strPOST += "&" + strPrefijoDeta + "_CANTIDAD" + intC + "=" + document.getElementById("cantidad").value;

        strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + document.getElementById("importe").value;
        strPOST += "&" + strPrefijoDeta + "_IMPORTE" + intC + "=" + document.getElementById("importe").value;
        strPOST += "&" + strPrefijoDeta + "_IMPORTEREAL" + intC + "=" + document.getElementById("importe").value;
        strPOST += "&" + strPrefijoDeta + "_DESCUENTO" + intC + "=" + "0.0";
    //Items
    /*var grid = jQuery("#list_deta");
    var arr = grid.getDataIDs();
    var intC = 0;
    for (var i = 0; i < arr.length; i++) {
        var id = arr[i];
        var lstRow = grid.getRowData(id);
        intC++;
        strPOST += "&PR_ID" + intC + "=" + lstRow.TKTD_PR_ID;
        strPOST += "&" + strPrefijoDeta + "_EXENTO1" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_EXENTO2" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_EXENTO3" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_TASAIVA1" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_TASAIVA2" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_TASAIVA3" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO1" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO2" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_IMPUESTO3" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_PORDESC" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_ESDEVO" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_PRECFIJO" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_UNIDAD_MEDIDA" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + "0";
        strPOST += "&" + strPrefijoDeta + "_CVE" + intC + "=" + lstRow.TKTD_DESCRIPCION;
        strPOST += "&" + strPrefijoDeta + "_DESCRIPCION" + intC + "=" + lstRow.TKTD_DESCRIPCION;
        strPOST += "&" + strPrefijoDeta + "_CANTIDAD" + intC + "=" + lstRow.TKTD_CANTIDAD;

        strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + lstRow.TKTD_PRECIO;
        strPOST += "&" + strPrefijoDeta + "_IMPORTE" + intC + "=" + lstRow.TKTD_IMPORTE;
        strPOST += "&" + strPrefijoDeta + "_IMPORTEREAL" + intC + "=" + lstRow.TKTD_IMPORTE;
        strPOST += "&" + strPrefijoDeta + "_DESCUENTO" + intC + "=" + lstRow.TKTD_DESCUENTO;
        
    }
strPOST += "&COUNT_ITEM=" + intC;*/
   //Pagos Mandamos las 4 formas de pago
   //Validamos el tipo de venta
  /* if (document.getElementById("FAC_TIPO").value != "") {
      strPOST += "&COUNT_PAGOS=5";
      //efectivo
      strPOST += "&MCD_MONEDA1=1";
      strPOST += "&MCD_FOLIO1=";
      strPOST += "&MCD_FORMAPAGO1=EFECTIVO";
      strPOST += "&MCD_NOCHEQUE1=";
      strPOST += "&MCD_BANCO1=";
      strPOST += "&MCD_NOTARJETA1=";
      strPOST += "&MCD_TIPOTARJETA1=";
      strPOST += "&MCD_IMPORTE1=" + (parseFloat(d.getElementById("Ef_1").value) - parseFloat(d.getElementById("Ef_2").value));
      strPOST += "&MCD_TASAPESO1=1";
      strPOST += "&MCD_CAMBIO1=" + d.getElementById("Ef_2").value;
      //cheque
      strPOST += "&MCD_MONEDA2=1";
      strPOST += "&MCD_FOLIO2=";
      strPOST += "&MCD_FORMAPAGO2=CHEQUE";
      strPOST += "&MCD_NOCHEQUE2=" + d.getElementById("Bc_2").value;
      strPOST += "&MCD_BANCO2=" + d.getElementById("Bc_3").value;
      strPOST += "&MCD_NOTARJETA2=";
      strPOST += "&MCD_TIPOTARJETA2=";
      strPOST += "&MCD_IMPORTE2=" + d.getElementById("Bc_1").value;
      strPOST += "&MCD_TASAPESO2=1";
      strPOST += "&MCD_CAMBIO2=0";
      //tarjeta de credito
      strPOST += "&MCD_MONEDA3=1";
      strPOST += "&MCD_FOLIO3=";
      strPOST += "&MCD_FORMAPAGO3=TCREDITO";
      strPOST += "&MCD_NOCHEQUE3=";
      strPOST += "&MCD_BANCO3=";
      strPOST += "&MCD_NOTARJETA3=" + d.getElementById("Tj_2").value;
      strPOST += "&MCD_TIPOTARJETA3=" + d.getElementById("Tj_3").value;
      strPOST += "&MCD_IMPORTE3=" + d.getElementById("Tj_1").value;
      strPOST += "&MCD_TASAPESO3=1";
      strPOST += "&MCD_CAMBIO3=0";
      //saldo a favor
      strPOST += "&MCD_MONEDA4=1";
      strPOST += "&MCD_FOLIO4=";
      strPOST += "&MCD_FORMAPAGO4=SALDOFAVOR";
      strPOST += "&MCD_NOCHEQUE4=";
      strPOST += "&MCD_BANCO4=";
      strPOST += "&MCD_NOTARJETA4=";
      strPOST += "&MCD_TIPOTARJETA4=";
      strPOST += "&MCD_IMPORTE4=" + d.getElementById("sf_1").value;
      strPOST += "&MCD_TASAPESO4=1";
      strPOST += "&MCD_CAMBIO4=0";
      //Transferencia
      strPOST += "&MCD_MONEDA5=1";
      strPOST += "&MCD_FOLIO5=";
      strPOST += "&MCD_FORMAPAGO5=TRANSFERENCIA BANCARIA";
      strPOST += "&MCD_NOCHEQUE5=";
      strPOST += "&MCD_BANCO5=" + d.getElementById("tf_2").value;
      strPOST += "&MCD_NOTARJETA5=" + d.getElementById("tf_3").value;
      strPOST += "&MCD_TIPOTARJETA5=";
      strPOST += "&MCD_IMPORTE5=" + d.getElementById("tf_1").value;
      strPOST += "&MCD_TASAPESO5=1";
      strPOST += "&MCD_CAMBIO5=0";
   } */
      strPOST += "&COUNT_PAGOS=1";
      //efectivo
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
   

    //Hacemos la peticion por POST
    $.ajax({
        type: "POST",
        data: encodeURI(strPOST),
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        cache: false,
        dataType: "html",
        url: "VtasMov.do?id=1",
        success: function(dato) {
            dato = trim(dato);
            if (Left(dato, 3) == "OK.") {
                if (strNomFormat == "FACTURA") {
                    var strHtml = CreaHidden(strKey, dato.replace("OK.", ""));
                    openWhereverFormat("ERP_SendInvoice?id=" + dato.replace("OK.", ""), strNomFormat, "PDF", strHtml);
                    ResetOperaActual();

                }
            } else {
                alert(dato);
            }

            $("#dialogWait").dialog("close");
        },
        error: function(objeto, quepaso, otroobj) {
            alert(":pto9:" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
        }
    });       
   } 
</script>    