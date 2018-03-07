/* 
 * Funciones para pintar las pantallas del ecommerce
 */

/**Refresca la clasificacion correspondiente*/
function RefreshClas(obj, optClas) {
   //Si envian el id de una clasificacion refrescamos el selecxt
   if (optClas != 0) {
      $("#dialogWait").dialog("open");
      $.ajax({
         type: "POST",
         data: "Clasific=" + optClas + "&ClasValue=" + obj.value,
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "xml",
         url: "modules/mod_ecomm/ecomm_clasific.jsp",
         success: function(datos) {
            var lstXml = datos.getElementsByTagName("clasificaciones")[0];
            var lstClas = lstXml.getElementsByTagName("clas");
            //Obtenemos y limpiamos combo
            var sel = document.getElementById("clas" + optClas);
            select_clear(sel);
            select_add(sel, "SELECCIONE", 0);
            for (var i = 0; i < lstClas.length; i++) {
               var objCat = lstClas[i];
               var idCat = objCat.getAttribute('id');
               var descCat = objCat.getAttribute('desc');
               select_add(sel, descCat, idCat);
            }
            $("#dialogWait").dialog("close");
         },
         error: function(objeto, quepaso, otroobj) {
            alert("ecomm" + objeto + " " + quepaso + " " + otroobj);
            $("#dialogWait").dialog("close");
         }
      });
   }
   intUnikiD = -1;
   //Actualizamos los productos
   loMasVendido();
   loMasNuevo();
   listaProductos();
   //Mostramos los productos que coincidan con 
}
//Funcion para mostrar lo mas vendido dentro de las clasificaciones seleccionadas
function loMasVendido() {
   //Peticion por ajax
   $.ajax({
      type: "POST",
      data: "CLASIFIC1=" + document.getElementById("clas1").value +
              "&CLASIFIC2=" + document.getElementById("clas2").value +
              "&CLASIFIC3=" + document.getElementById("clas3").value +
              "&CLASIFIC4=" + document.getElementById("clas4").value +
              "&CLASIFIC5=" + document.getElementById("clas5").value +
              "&CLASIFIC6=0"
              ,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "modules/mod_ecomm/ecomm_prod.jsp?Oper=2",
      success: function(datos) {
         var lstXml = datos.getElementsByTagName("productos")[0];
         var lstProd = lstXml.getElementsByTagName("prod");
         //Variable para html
         var strHtmlW = "<div id=\"ecomm_display2\" class=\"ecomm_display1\"> ";
         var intContaDisplay = 0;
         for (var i = 0; i < lstProd.length; i++) {
            var objCat = lstProd[i];
            intContaDisplay++;
            intUnikiD++;
            var idCat = objCat.getAttribute('id');
            var descCat = objCat.getAttribute('desc');
            var codigo = objCat.getAttribute('codigo');
            var codigocorto = objCat.getAttribute('codigocorto');
            var img1 = objCat.getAttribute('img1');
            var img2 = objCat.getAttribute('img2');
            var exist = objCat.getAttribute('exist');
            var cat1 = objCat.getAttribute('cat1');
            var cat2 = objCat.getAttribute('cat2');
            var cat3 = objCat.getAttribute('cat3');
            var cat4 = objCat.getAttribute('cat4');
            var cat5 = objCat.getAttribute('cat5');
            var cat6 = objCat.getAttribute('cat6');
            var cat7 = objCat.getAttribute('cat7');
            var cat8 = objCat.getAttribute('cat8');
            var cat9 = objCat.getAttribute('cat9');
            var cat10 = objCat.getAttribute('cat10');
            var umedida = objCat.getAttribute('umedida');
            var reqexist = objCat.getAttribute('reqexist');
            var exento1 = objCat.getAttribute('exento1');
            var exento2 = objCat.getAttribute('exento2');
            var exento3 = objCat.getAttribute('exento3');
            var activo = objCat.getAttribute('activo');
            var agrupa = objCat.getAttribute('agrupa');
            //Obtenemos los precios
            var objPrec = objCat.getElementsByTagName("Precio")[0];
            var precio = objPrec.getAttribute('precioUsar');
            var precio_usd = objPrec.getAttribute('precio_usd');
            var ApDesc = objPrec.getAttribute('descuento');
            var ApDescPto = objPrec.getAttribute('desc_pto');
            var ApDescVN = objPrec.getAttribute('desc_nego');
            var puntos = objPrec.getAttribute('puntos');
            var vnegocio = objPrec.getAttribute('negocio');
            var publico = objPrec.getAttribute('publico');
            var lealtad = objPrec.getAttribute('lealtad');
            var lealtadCA = objPrec.getAttribute('lealtadCA');

            //Calculamos el impuesto
            var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
            //Validamos si los precios incluyen impuestos
            if (intPreciosconImp == 1) {
               tax.CalculaImpuesto(precio, 0, 0);
            } else {
               tax.CalculaImpuestoMas(precio, 0, 0);
            }
            var dblPrecioMasIVA = parseFloat(precio) + parseFloat(tax.dblImpuesto1);

            var strStyle1 = "prod_right2";
            strHtmlW += "<div class=\"prod_row\"> ";
            strHtmlW += "<div class=\"" + strStyle1 + "\"> ";
            strHtmlW += "<div class=\"prod_img\"> ";
            strHtmlW += "<a href=\"" + img2 + "\" id=\"link3\" title=\"\">";
            strHtmlW += "<image src=\"" + img1 + "\" border=\"0\" alt=\"\" title=\"\"> ";
            strHtmlW += "</a> ";
            strHtmlW += "</div> ";
            strHtmlW += "<div class=\"prod_txt\">" + descCat + "<br>" + strSimboloMoneda + FormatNumber(dblPrecioMasIVA, intNumdecimal, true);
            strHtmlW += "<br>Valor Puntos: " + + FormatNumber(lealtadCA, 0, true);
            strHtmlW += "</div> ";
            //Validacion para los items agrupados
            if (parseInt(agrupa) == 1) {
               //Desplegamos los combos para los colores y tallas
               strHtmlW += "<div class=\"prod_tallas_colores\"> ";
               strHtmlW += strTitulo10 + "&nbsp;<select class=\"sel_ecomm_item\" " +
                       "name=\"Selcat4" + intUnikiD + "\" id=\"Selcat4" + intUnikiD + "\" " +
                       " >";
               var objClas4P = objCat.getElementsByTagName("clasif4")[0];
               var lstClasific4 = objClas4P.getElementsByTagName("clasific4");
               for (var km = 0; km < lstClasific4.length; km++) {
                  var objClas4 = lstClasific4[km];
                  strHtmlW += "<option value=\"" + objClas4.getAttribute("id") + "\">" + objClas4.getAttribute("valor") + "</option> ";
               }
               strHtmlW += "</select><br>";
               strHtmlW += strTitulo11 + "&nbsp;<select class=\"sel_ecomm_item\" " +
                       "name=\"Selcat5" + intUnikiD + "_v\" id=\"Selcat5" + intUnikiD + "_v\" " +
                       " >";
               var objClas5P = objCat.getElementsByTagName("clasif5")[0];
               var lstClasific5 = objClas5P.getElementsByTagName("clasific5");
               for (var km = 0; km < lstClasific5.length; km++) {
                  var objClas5 = lstClasific5[km];
                  strHtmlW += "<option value=\"" + objClas5.getAttribute("id") + "\">" + objClas5.getAttribute("valor") + "</option> ";
               }
               strHtmlW += "</select>";
               strHtmlW += "</div> ";

            }
            strHtmlW += "<div class=\"prod_btn\"> ";
            //Validamos si esta activo para dejarlo pedir
            if (parseInt(activo) == 1) {
               strHtmlW += "<input type=\"text\" class=\"ecomm_txt1\" " +
                       "name=\"cant" + i + "\" id=\"cant_v" + intUnikiD + "\" " +
                       " value=\"1\" />";
               strHtmlW += "<input type=\"button\" class=\"ecomm_btn1\" " +
                       "name=\"add_v\" id=\"add_v" + i + "\" " +
                       " value=\"Agregar al carrito\" onClick=\"AddItem(" + idCat + ",this," + intUnikiD + ")\"> ";
            }
            strHtmlW += "</div> ";
            strHtmlW += "</div> ";
            strHtmlW += "</div> ";
            //Valores hidden de los productos
            strHtmlW += "<input type=hidden id=desc_v" + intUnikiD + " name=desc" + intUnikiD + " value='" + descCat + "'> ";
            strHtmlW += "<input type=hidden id=precio_v" + intUnikiD + " name=precio" + intUnikiD + " value='" + precio + "'> ";
            strHtmlW += "<input type=hidden id=precio_usd_v" + intUnikiD + " name=precio_usd" + intUnikiD + " value='" + precio_usd + "'> ";
            strHtmlW += "<input type=hidden id=codigo_v" + intUnikiD + " name=codigo" + intUnikiD + " value='" + codigo + "'> ";
            strHtmlW += "<input type=hidden id=codigocorto_v" + intUnikiD + " name=codigocorto" + intUnikiD + " value='" + codigocorto + "'> ";
            strHtmlW += "<input type=hidden id=ApDesc_v" + intUnikiD + " name=ApDesc" + intUnikiD + " value='" + ApDesc + "'> ";
            strHtmlW += "<input type=hidden id=ApDescPto_v" + intUnikiD + " name=ApDescPto" + intUnikiD + " value='" + ApDescPto + "'> ";
            strHtmlW += "<input type=hidden id=ApDescVN_v" + intUnikiD + " name=ApDescVN" + intUnikiD + " value='" + ApDescVN + "'> ";
            strHtmlW += "<input type=hidden id=puntos_v" + intUnikiD + " name=puntos" + intUnikiD + " value='" + puntos + "'> ";
            strHtmlW += "<input type=hidden id=vnegocio_v" + intUnikiD + " name=vnegocio" + intUnikiD + " value='" + vnegocio + "'> ";
            strHtmlW += "<input type=hidden id=publico_v" + intUnikiD + " name=publico" + intUnikiD + " value='" + publico + "'> ";
            strHtmlW += "<input type=hidden id=lealtad_v" + intUnikiD + " name=lealtad" + intUnikiD + " value='" + lealtad + "'> ";
            strHtmlW += "<input type=hidden id=lealtadCA_v" + intUnikiD + " name=lealtadCA" + intUnikiD + " value='" + lealtadCA + "'> ";
            strHtmlW += "<input type=hidden id=exist_v" + intUnikiD + " name=exist" + intUnikiD + " value='" + exist + "'> ";
            strHtmlW += "<input type=hidden id=cat1_v" + intUnikiD + " name=cat1" + intUnikiD + " value='" + cat1 + "'> ";
            strHtmlW += "<input type=hidden id=cat2_v" + intUnikiD + " name=cat2" + intUnikiD + " value='" + cat2 + "'> ";
            strHtmlW += "<input type=hidden id=cat3_v" + intUnikiD + " name=cat3" + intUnikiD + " value='" + cat3 + "'> ";
            strHtmlW += "<input type=hidden id=cat4_v" + intUnikiD + " name=cat4" + intUnikiD + " value='" + cat4 + "'> ";
            strHtmlW += "<input type=hidden id=cat5_v" + intUnikiD + " name=cat5" + intUnikiD + " value='" + cat5 + "'> ";
            strHtmlW += "<input type=hidden id=cat6_v" + intUnikiD + " name=cat6" + intUnikiD + " value='" + cat6 + "'> ";
            strHtmlW += "<input type=hidden id=cat7_v" + intUnikiD + " name=cat7" + intUnikiD + " value='" + cat7 + "'> ";
            strHtmlW += "<input type=hidden id=cat8_v" + intUnikiD + " name=cat8" + intUnikiD + " value='" + cat8 + "'> ";
            strHtmlW += "<input type=hidden id=cat9_v" + intUnikiD + " name=cat9" + intUnikiD + " value='" + cat9 + "'> ";
            strHtmlW += "<input type=hidden id=cat10_v" + intUnikiD + " name=cat10" + intUnikiD + " value='" + cat10 + "'> ";
            strHtmlW += "<input type=hidden id=umedida_v" + intUnikiD + " name=umedida" + intUnikiD + " value='" + umedida + "'> ";
            strHtmlW += "<input type=hidden id=reqexist_v" + intUnikiD + " name=reqexist" + intUnikiD + " value='" + reqexist + "'> ";
            strHtmlW += "<input type=hidden id=exento1_v" + intUnikiD + " name=exento1" + intUnikiD + " value='" + exento1 + "'> ";
            strHtmlW += "<input type=hidden id=exento2_v" + intUnikiD + " name=exento2" + intUnikiD + " value='" + exento2 + "'> ";
            strHtmlW += "<input type=hidden id=exento3_v" + intUnikiD + " name=exento3" + intUnikiD + " value='" + exento3 + "'> ";
            strHtmlW += "<input type=hidden id=agrupa_v" + intUnikiD + " name=agrupa" + intUnikiD + " value='" + agrupa + "'> ";

         }
         //cierre fila
         strHtmlW += "</div> ";
         //Cierre principal
         strHtmlW += "</div> ";

         //Pintamos el html
         document.getElementById("ecomm_mas_vendido_div").innerHTML = strHtmlW;
         $('#ecomm_mas_vendido_div a').lightBox();
      },
      error: function(objeto, quepaso, otroobj) {
         alert("ecomm" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
//Funcion para mostrar lo mas nuevo dentro de las clasificaciones seleccionadas
function loMasNuevo() {
   //Peticion por ajax
   $.ajax({
      type: "POST",
      data: "CLASIFIC1=" + document.getElementById("clas1").value +
              "&CLASIFIC2=" + document.getElementById("clas2").value +
              "&CLASIFIC3=" + document.getElementById("clas3").value +
              "&CLASIFIC4=" + document.getElementById("clas4").value +
              "&CLASIFIC5=" + document.getElementById("clas5").value +
              "&CLASIFIC6=0"
              ,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "modules/mod_ecomm/ecomm_prod.jsp?Oper=3",
      success: function(datos) {
         var lstXml = datos.getElementsByTagName("productos")[0];
         var lstProd = lstXml.getElementsByTagName("prod");
         //Variable para html
         var strHtmlW = "<div id=\"ecomm_display3\" class=\"ecomm_display1\"> ";
         var intContaDisplay = 0;
         for (var i = 0; i < lstProd.length; i++) {
            var objCat = lstProd[i];
            intContaDisplay++;
            intUnikiD++;
            var idCat = objCat.getAttribute('id');
            var descCat = objCat.getAttribute('desc');
            var codigo = objCat.getAttribute('codigo');
            var codigocorto = objCat.getAttribute('codigocorto');
            var img1 = objCat.getAttribute('img1');
            var img2 = objCat.getAttribute('img2');
            var exist = objCat.getAttribute('exist');
            var cat1 = objCat.getAttribute('cat1');
            var cat2 = objCat.getAttribute('cat2');
            var cat3 = objCat.getAttribute('cat3');
            var cat4 = objCat.getAttribute('cat4');
            var cat5 = objCat.getAttribute('cat5');
            var cat6 = objCat.getAttribute('cat6');
            var cat7 = objCat.getAttribute('cat7');
            var cat8 = objCat.getAttribute('cat8');
            var cat9 = objCat.getAttribute('cat9');
            var cat10 = objCat.getAttribute('cat10');
            var umedida = objCat.getAttribute('umedida');
            var reqexist = objCat.getAttribute('reqexist');
            var exento1 = objCat.getAttribute('exento1');
            var exento2 = objCat.getAttribute('exento2');
            var exento3 = objCat.getAttribute('exento3');
            var activo = objCat.getAttribute('activo');
            var agrupa = objCat.getAttribute('agrupa');
            //Obtenemos los precios
            var objPrec = objCat.getElementsByTagName("Precio")[0];
            var precio = objPrec.getAttribute('precioUsar');
            var precio_usd = objPrec.getAttribute('precio_usd');
            var ApDesc = objPrec.getAttribute('descuento');
            var ApDescPto = objPrec.getAttribute('desc_pto');
            var ApDescVN = objPrec.getAttribute('desc_nego');
            var puntos = objPrec.getAttribute('puntos');
            var vnegocio = objPrec.getAttribute('negocio');
            var publico = objPrec.getAttribute('publico');
            var lealtad = objPrec.getAttribute('lealtad');
            var lealtadCA = objPrec.getAttribute('lealtadCA');

            //Calculamos el impuesto
            var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
            //Validamos si los precios incluyen impuestos
            if (intPreciosconImp == 1) {
               tax.CalculaImpuesto(precio, 0, 0);
            } else {
               tax.CalculaImpuestoMas(precio, 0, 0);
            }
            var dblPrecioMasIVA = parseFloat(precio) + parseFloat(tax.dblImpuesto1);

            var strStyle1 = "prod_right2";
            strHtmlW += "<div class=\"prod_row\"> ";
            strHtmlW += "<div class=\"" + strStyle1 + "\"> ";
            strHtmlW += "<a href=\"" + img2 + "\" id=\"link3\" title=\"\">";
            strHtmlW += "<div class=\"prod_img\"> ";
            strHtmlW += "<image src=\"" + img1 + "\" border=\"0\" alt=\"\" title=\"\"> ";
            strHtmlW += "</a> ";
            strHtmlW += "</div> ";
            strHtmlW += "<div class=\"prod_txt\">" + descCat + "<br>" + strSimboloMoneda + FormatNumber(dblPrecioMasIVA, intNumdecimal, true);
            strHtmlW += "<br>Valor Puntos: " + + FormatNumber(lealtadCA, 0, true);
            strHtmlW += "</div> ";
            //Validacion para los items agrupados
            if (parseInt(agrupa) == 1) {
               //Desplegamos los combos para los colores y tallas
               strHtmlW += "<div class=\"prod_tallas_colores\"> ";
               strHtmlW += strTitulo10 + "&nbsp;<select class=\"sel_ecomm_item\" " +
                       "name=\"Selcat4" + intUnikiD + "_n\" id=\"Selcat4" + intUnikiD + "_n\" " +
                       " >";
               var objClas4P = objCat.getElementsByTagName("clasif4")[0];
               var lstClasific4 = objClas4P.getElementsByTagName("clasific4");
               for (var km = 0; km < lstClasific4.length; km++) {
                  var objClas4 = lstClasific4[km];
                  strHtmlW += "<option value=\"" + objClas4.getAttribute("id") + "\">" + objClas4.getAttribute("valor") + "</option> ";
               }
               strHtmlW += "</select><br>";
               strHtmlW += strTitulo11 + "&nbsp;<select class=\"sel_ecomm_item\" " +
                       "name=\"Selcat5" + intUnikiD + "_n\" id=\"Selcat5" + intUnikiD + "_n\" " +
                       " >";
               var objClas5P = objCat.getElementsByTagName("clasif5")[0];
               var lstClasific5 = objClas5P.getElementsByTagName("clasific5");
               for (var km = 0; km < lstClasific5.length; km++) {
                  var objClas5 = lstClasific5[km];
                  strHtmlW += "<option value=\"" + objClas5.getAttribute("id") + "\">" + objClas5.getAttribute("valor") + "</option> ";
               }
               strHtmlW += "</select>";
               strHtmlW += "</div> ";

            }
            strHtmlW += "<div class=\"prod_btn\"> ";
            //Validamos si esta activo para dejarlo pedir
            if (parseInt(activo) == 1) {
               strHtmlW += "<input type=\"text\" class=\"ecomm_txt1\" " +
                       "name=\"cant" + i + "\" id=\"cant_n" + intUnikiD + "\" " +
                       " value=\"1\" />";
               strHtmlW += "<input type=\"button\" class=\"ecomm_btn1\" " +
                       "name=\"add_n\" id=\"add_n" + i + "\" " +
                       " value=\"Agregar al carrito\" onClick=\"AddItem(" + idCat + ",this," + intUnikiD + ")\"> ";
            }
            strHtmlW += "</div> ";
            strHtmlW += "</div> ";
            strHtmlW += "</div> ";
            //Valores hidden de los productos
            strHtmlW += "<input type=hidden id=desc_n" + intUnikiD + " name=desc" + intUnikiD + " value='" + descCat + "'> ";
            strHtmlW += "<input type=hidden id=precio_n" + intUnikiD + " name=precio" + intUnikiD + " value='" + precio + "'> ";
            strHtmlW += "<input type=hidden id=precio_usd_n" + intUnikiD + " name=precio_usd" + intUnikiD + " value='" + precio_usd + "'> ";
            strHtmlW += "<input type=hidden id=codigo_n" + intUnikiD + " name=codigo" + intUnikiD + " value='" + codigo + "'> ";
            strHtmlW += "<input type=hidden id=codigocorto_n" + intUnikiD + " name=codigocorto" + intUnikiD + " value='" + codigocorto + "'> ";
            strHtmlW += "<input type=hidden id=ApDesc_n" + intUnikiD + " name=ApDesc" + intUnikiD + " value='" + ApDesc + "'> ";
            strHtmlW += "<input type=hidden id=ApDescPto_n" + intUnikiD + " name=ApDescPto" + intUnikiD + " value='" + ApDescPto + "'> ";
            strHtmlW += "<input type=hidden id=ApDescVN_n" + intUnikiD + " name=ApDescVN" + intUnikiD + " value='" + ApDescVN + "'> ";
            strHtmlW += "<input type=hidden id=puntos_n" + intUnikiD + " name=puntos" + intUnikiD + " value='" + puntos + "'> ";
            strHtmlW += "<input type=hidden id=vnegocio_n" + intUnikiD + " name=vnegocio" + intUnikiD + " value='" + vnegocio + "'> ";
            strHtmlW += "<input type=hidden id=publico_n" + intUnikiD + " name=publico" + intUnikiD + " value='" + publico + "'> ";
            strHtmlW += "<input type=hidden id=lealtad_n" + intUnikiD + " name=lealtad" + intUnikiD + " value='" + lealtad + "'> ";
            strHtmlW += "<input type=hidden id=lealtadCA_n" + intUnikiD + " name=lealtadCA" + intUnikiD + " value='" + lealtadCA + "'> ";
            strHtmlW += "<input type=hidden id=exist_n" + intUnikiD + " name=exist" + intUnikiD + " value='" + exist + "'> ";
            strHtmlW += "<input type=hidden id=cat1_n" + intUnikiD + " name=cat1" + intUnikiD + " value='" + cat1 + "'> ";
            strHtmlW += "<input type=hidden id=cat2_n" + intUnikiD + " name=cat2" + intUnikiD + " value='" + cat2 + "'> ";
            strHtmlW += "<input type=hidden id=cat3_n" + intUnikiD + " name=cat3" + intUnikiD + " value='" + cat3 + "'> ";
            strHtmlW += "<input type=hidden id=cat4_n" + intUnikiD + " name=cat4" + intUnikiD + " value='" + cat4 + "'> ";
            strHtmlW += "<input type=hidden id=cat5_n" + intUnikiD + " name=cat5" + intUnikiD + " value='" + cat5 + "'> ";
            strHtmlW += "<input type=hidden id=cat6_n" + intUnikiD + " name=cat6" + intUnikiD + " value='" + cat6 + "'> ";
            strHtmlW += "<input type=hidden id=cat7_n" + intUnikiD + " name=cat7" + intUnikiD + " value='" + cat7 + "'> ";
            strHtmlW += "<input type=hidden id=cat8_n" + intUnikiD + " name=cat8" + intUnikiD + " value='" + cat8 + "'> ";
            strHtmlW += "<input type=hidden id=cat9_n" + intUnikiD + " name=cat9" + intUnikiD + " value='" + cat9 + "'> ";
            strHtmlW += "<input type=hidden id=cat10_n" + intUnikiD + " name=cat10" + intUnikiD + " value='" + cat10 + "'> ";
            strHtmlW += "<input type=hidden id=umedida_n" + intUnikiD + " name=umedida" + intUnikiD + " value='" + umedida + "'> ";
            strHtmlW += "<input type=hidden id=reqexist_n" + intUnikiD + " name=reqexist" + intUnikiD + " value='" + reqexist + "'> ";
            strHtmlW += "<input type=hidden id=exento1_n" + intUnikiD + " name=exento1" + intUnikiD + " value='" + exento1 + "'> ";
            strHtmlW += "<input type=hidden id=exento2_n" + intUnikiD + " name=exento2" + intUnikiD + " value='" + exento2 + "'> ";
            strHtmlW += "<input type=hidden id=exento3_n" + intUnikiD + " name=exento3" + intUnikiD + " value='" + exento3 + "'> ";
            strHtmlW += "<input type=hidden id=agrupa_n" + intUnikiD + " name=agrupa" + intUnikiD + " value='" + agrupa + "'> ";

         }
         //cierre fila
         strHtmlW += "</div> ";
         //Cierre principal
         strHtmlW += "</div> ";
         //Pintamos el html
         document.getElementById("ecomm_mas_nuevo_div").innerHTML = strHtmlW;
         $('#ecomm_mas_nuevo_div a').lightBox();
      },
      error: function(objeto, quepaso, otroobj) {
         alert("ecomm" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}
//Funcion para mostrar los productos de acuerdo a la clasificacion o el texto de busqueda
function listaProductosSearch() {
   listaProductos(document.getElementById("_search").value);
}
//Funcion para mostrar los productos de acuerdo a la clasificacion o el texto de busqueda
function listaProductos(strSearch) {
   if (strSearch == null)
      strSearch = "";
   //Peticion por ajax
   $.ajax({
      type: "POST",
      data: "SEARCH=" + strSearch +
              "&CLASIFIC1=" + document.getElementById("clas1").value +
              "&CLASIFIC2=" + document.getElementById("clas2").value +
              "&CLASIFIC3=" + document.getElementById("clas3").value +
              "&CLASIFIC4=" + document.getElementById("clas4").value +
              "&CLASIFIC5=" + document.getElementById("clas5").value +
              "&CLASIFIC6=0"
              ,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "modules/mod_ecomm/ecomm_prod.jsp?Oper=1",
      success: function(datos) {
         var lstXml = datos.getElementsByTagName("productos")[0];
         var lstProd = lstXml.getElementsByTagName("prod");
         //Variable para html
         var strHtmlW = "<div id=\"ecomm_display1\" class=\"ecomm_display1\"> ";
         var intContaDisplay = 0;
         strHtmlW += "<div class=\"prod_row\"> ";
         for (var i = 0; i < lstProd.length; i++) {
            var objCat = lstProd[i];
            intContaDisplay++;
            intUnikiD++;
            var idCat = objCat.getAttribute('id');
            var descCat = objCat.getAttribute('desc');
            var codigo = objCat.getAttribute('codigo');
            var codigocorto = objCat.getAttribute('codigocorto');
            var img1 = objCat.getAttribute('img1');
            var img2 = objCat.getAttribute('img2');
            var exist = objCat.getAttribute('exist');
            var cat1 = objCat.getAttribute('cat1');
            var cat2 = objCat.getAttribute('cat2');
            var cat3 = objCat.getAttribute('cat3');
            var cat4 = objCat.getAttribute('cat4');
            var cat5 = objCat.getAttribute('cat5');
            var cat6 = objCat.getAttribute('cat6');
            var cat7 = objCat.getAttribute('cat7');
            var cat8 = objCat.getAttribute('cat8');
            var cat9 = objCat.getAttribute('cat9');
            var cat10 = objCat.getAttribute('cat10');
            var umedida = objCat.getAttribute('umedida');
            var reqexist = objCat.getAttribute('reqexist');
            var exento1 = objCat.getAttribute('exento1');
            var exento2 = objCat.getAttribute('exento2');
            var exento3 = objCat.getAttribute('exento3');
            var activo = objCat.getAttribute('activo');
            var agrupa = objCat.getAttribute('agrupa');
            //Obtenemos los precios
            var objPrec = objCat.getElementsByTagName("Precio")[0];
            var precio = 0;
            var precio_usd = 0;
            var ApDesc = 0;
            var ApDescPto = 0;
            var ApDescVN = 0;
            var puntos = 0;
            var vnegocio = 0;
            var publico = 0;
            var lealtad = 0;
            var lealtadCA = 0;

            if (objPrec != null) {
               precio = objPrec.getAttribute('precioUsar');
               precio_usd = objPrec.getAttribute('precio_usd');
               ApDesc = objPrec.getAttribute('descuento');
               ApDescPto = objPrec.getAttribute('desc_pto');
               ApDescVN = objPrec.getAttribute('desc_nego');
               puntos = objPrec.getAttribute('puntos');
               vnegocio = objPrec.getAttribute('negocio');
               publico = objPrec.getAttribute('publico');
               lealtad = objPrec.getAttribute('lealtad');
               lealtadCA = objPrec.getAttribute('lealtadCA');

            }
            //Estilo por aplicar en el contenedor
            var strStyle1 = "prod_left";
            if (intContaDisplay == 2)
               strStyle1 = "prod_center";
            if (intContaDisplay == 3)
               strStyle1 = "prod_right";

            //Calculamos el impuesto
            var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
            //Validamos si los precios incluyen impuestos
            if (intPreciosconImp == 1) {
               tax.CalculaImpuesto(precio, 0, 0);
            } else {
               tax.CalculaImpuestoMas(precio, 0, 0);
            }
            var dblPrecioMasIVA = parseFloat(precio) + parseFloat(tax.dblImpuesto1);

            strHtmlW += "<div class=\"" + strStyle1 + "\"> ";
            strHtmlW += "<div class=\"prod_img\"> ";
            strHtmlW += "<a href=\"" + img2 + "\" id=\"link1\" title=\"\">";
            strHtmlW += "<image src=\"" + img1 + "\" border=\"0\" alt=\"\" title=\"\"> ";
            strHtmlW += "</a> ";
            strHtmlW += "</div> ";
            strHtmlW += "<div class=\"prod_txt\">" + descCat + "<br>" + strSimboloMoneda + FormatNumber(dblPrecioMasIVA, intNumdecimal, true);
            strHtmlW += "<br>Valor Puntos: " + + FormatNumber(lealtadCA, 0, true);
            strHtmlW += "</div> ";
            //Validacion para los items agrupados
            if (parseInt(agrupa) == 1) {
               //Desplegamos los combos para los colores y tallas
               strHtmlW += "<div class=\"prod_tallas_colores\"> ";
               strHtmlW += strTitulo10 + "&nbsp;<select class=\"sel_ecomm_item\" " +
                       "name=\"Selcat4" + intUnikiD + "\" id=\"Selcat4" + intUnikiD + "\" " +
                       " >";
               var objClas4P = objCat.getElementsByTagName("clasif4")[0];
               var lstClasific4 = objClas4P.getElementsByTagName("clasific4");
               for (var km = 0; km < lstClasific4.length; km++) {
                  var objClas4 = lstClasific4[km];
                  strHtmlW += "<option value=\"" + objClas4.getAttribute("id") + "\">" + objClas4.getAttribute("valor") + "</option> ";
               }
               strHtmlW += "</select><br>";
               strHtmlW += strTitulo11 + "&nbsp;<select class=\"sel_ecomm_item\" " +
                       "name=\"Selcat5" + intUnikiD + "\" id=\"Selcat5" + intUnikiD + "\" " +
                       " >";
               var objClas5P = objCat.getElementsByTagName("clasif5")[0];
               var lstClasific5 = objClas5P.getElementsByTagName("clasific5");
               for (var km = 0; km < lstClasific5.length; km++) {
                  var objClas5 = lstClasific5[km];
                  strHtmlW += "<option value=\"" + objClas5.getAttribute("id") + "\">" + objClas5.getAttribute("valor") + "</option> ";
               }
               strHtmlW += "</select>";
               strHtmlW += "</div> ";

            }
            strHtmlW += "<div class=\"prod_btn\"> ";
            //Validamos si esta activo para dejarlo pedir
            if (parseInt(activo) == 1) {
               strHtmlW += "<input type=\"text\" class=\"ecomm_txt1\" " +
                       "name=\"cant" + i + "\" id=\"cant" + intUnikiD + "\" " +
                       " value=\"1\" />";
               strHtmlW += "<input type=\"button\" class=\"ecomm_btn1\" " +
                       "name=\"add\" id=\"add" + i + "\" " +
                       " value=\"Agregar al carrito\" onClick=\"AddItem(" + idCat + ",this," + intUnikiD + ")\"> ";
            }
            strHtmlW += "</div> ";

            //Valores hidden de los productos
            strHtmlW += "<input type=hidden id=desc" + intUnikiD + " name=desc" + intUnikiD + " value='" + descCat + "'> ";
            strHtmlW += "<input type=hidden id=precio" + intUnikiD + " name=precio" + intUnikiD + " value='" + precio + "'> ";
            strHtmlW += "<input type=hidden id=precio_usd" + intUnikiD + " name=precio_usd" + intUnikiD + " value='" + precio_usd + "'> ";
            strHtmlW += "<input type=hidden id=codigo" + intUnikiD + " name=codigo" + intUnikiD + " value='" + codigo + "'> ";
            strHtmlW += "<input type=hidden id=codigocorto" + intUnikiD + " name=codigocorto" + intUnikiD + " value='" + codigocorto + "'> ";
            strHtmlW += "<input type=hidden id=ApDesc" + intUnikiD + " name=ApDesc" + intUnikiD + " value='" + ApDesc + "'> ";
            strHtmlW += "<input type=hidden id=ApDescPto" + intUnikiD + " name=ApDescPto" + intUnikiD + " value='" + ApDescPto + "'> ";
            strHtmlW += "<input type=hidden id=ApDescVN" + intUnikiD + " name=ApDescVN" + intUnikiD + " value='" + ApDescVN + "'> ";
            strHtmlW += "<input type=hidden id=puntos" + intUnikiD + " name=puntos" + intUnikiD + " value='" + puntos + "'> ";
            strHtmlW += "<input type=hidden id=vnegocio" + intUnikiD + " name=vnegocio" + intUnikiD + " value='" + vnegocio + "'> ";
            strHtmlW += "<input type=hidden id=publico" + intUnikiD + " name=publico" + intUnikiD + " value='" + publico + "'> ";
            strHtmlW += "<input type=hidden id=lealtad" + intUnikiD + " name=lealtad" + intUnikiD + " value='" + lealtad + "'> ";
            strHtmlW += "<input type=hidden id=lealtadCA" + intUnikiD + " name=lealtadCA" + intUnikiD + " value='" + lealtadCA + "'> ";
            strHtmlW += "<input type=hidden id=exist" + intUnikiD + " name=exist" + intUnikiD + " value='" + exist + "'> ";
            strHtmlW += "<input type=hidden id=cat1" + intUnikiD + " name=cat1" + intUnikiD + " value='" + cat1 + "'> ";
            strHtmlW += "<input type=hidden id=cat2" + intUnikiD + " name=cat2" + intUnikiD + " value='" + cat2 + "'> ";
            strHtmlW += "<input type=hidden id=cat3" + intUnikiD + " name=cat3" + intUnikiD + " value='" + cat3 + "'> ";
            strHtmlW += "<input type=hidden id=cat4" + intUnikiD + " name=cat4" + intUnikiD + " value='" + cat4 + "'> ";
            strHtmlW += "<input type=hidden id=cat5" + intUnikiD + " name=cat5" + intUnikiD + " value='" + cat5 + "'> ";
            strHtmlW += "<input type=hidden id=cat6" + intUnikiD + " name=cat6" + intUnikiD + " value='" + cat6 + "'> ";
            strHtmlW += "<input type=hidden id=cat7" + intUnikiD + " name=cat7" + intUnikiD + " value='" + cat7 + "'> ";
            strHtmlW += "<input type=hidden id=cat8" + intUnikiD + " name=cat8" + intUnikiD + " value='" + cat8 + "'> ";
            strHtmlW += "<input type=hidden id=cat9" + intUnikiD + " name=cat9" + intUnikiD + " value='" + cat9 + "'> ";
            strHtmlW += "<input type=hidden id=cat10" + intUnikiD + " name=cat10" + intUnikiD + " value='" + cat10 + "'> ";
            strHtmlW += "<input type=hidden id=umedida" + intUnikiD + " name=umedida" + intUnikiD + " value='" + umedida + "'> ";
            strHtmlW += "<input type=hidden id=reqexist" + intUnikiD + " name=reqexist" + intUnikiD + " value='" + reqexist + "'> ";
            strHtmlW += "<input type=hidden id=exento1" + intUnikiD + " name=exento1" + intUnikiD + " value='" + exento1 + "'> ";
            strHtmlW += "<input type=hidden id=exento2" + intUnikiD + " name=exento2" + intUnikiD + " value='" + exento2 + "'> ";
            strHtmlW += "<input type=hidden id=exento3" + intUnikiD + " name=exento3" + intUnikiD + " value='" + exento3 + "'> ";
            strHtmlW += "<input type=hidden id=agrupa" + intUnikiD + " name=agrupa" + intUnikiD + " value='" + agrupa + "'> ";
            strHtmlW += "</div> ";
            //Evaluamos si pintamos otra fila
            if (intContaDisplay == 3) {
               intContaDisplay = 0;
               //cierre fila
               strHtmlW += "</div> ";
               strHtmlW += "<div class=\"prod_row\"> ";
            }
         }
         //cierre fila
         strHtmlW += "</div> ";
         //Cierre principal
         strHtmlW += "</div> ";
         //Pintamos el html
         document.getElementById("ecomm_content").innerHTML = strHtmlW;
         $('#ecomm_content a').lightBox();
      },
      error: function(objeto, quepaso, otroobj) {
         alert("ecomm" + objeto + " " + quepaso + " " + otroobj);
      }
   });
}

/**
 * Funcion para añadir un item al carrito de compras
 * @syntax AddItem(idProd, obj, iUid)
 * @param {String} idProd id del producto 
 * @param {String} obj representa el boton al que se le dio click
 * @param {String} iUid Es el id unico de los items del carrito
 * @returns {String} Regresa tru si todo fue exitoso
 */
function AddItem(idProd, obj, iUid) {
   //Obtenemos los valores
   var strPref = "";
   if (obj.name == "add_v") {
      strPref = "_v";
   }
   if (obj.name == "add_n") {
      strPref = "_n";
   }

   //Obtenemos la bandera de agrupar
   var intAgrupa = parseInt(document.getElementById("agrupa" + strPref + iUid).value);
   if (intAgrupa == 1 && parseFloat(idProd) == 0) {
      //Como esta agrupado buscaremos obtener el codigo SKU para proseguir con el resto del proceso
      var _selCat1 = parseInt(document.getElementById("cat1" + strPref + iUid).value);
      var _selCat2 = parseInt(document.getElementById("cat2" + strPref + iUid).value);
      var _selCat3 = parseInt(document.getElementById("cat3" + strPref + iUid).value);
      var _selCat4 = parseInt(document.getElementById("Selcat4" + strPref + iUid).value);
      var _selCat5 = parseInt(document.getElementById("Selcat5" + strPref + iUid).value);
      var _strDescrip = document.getElementById("codigocorto" + strPref + iUid).value;
      //Peticion por ajax
      $.ajax({
         type: "POST",
         data: encodeURI("Descrip=" + _strDescrip +
                 "&CLASIFIC1=" + _selCat1 +
                 "&CLASIFIC2=" + _selCat2 +
                 "&CLASIFIC3=" + _selCat3 +
                 "&CLASIFIC4=" + _selCat4 +
                 "&CLASIFIC5=" + _selCat5)
                 ,
         scriptCharset: "utf-8",
         contentType: "application/x-www-form-urlencoded;charset=utf-8",
         cache: false,
         dataType: "xml",
         url: "modules/mod_ecomm/ecomm_prod.jsp?Oper=4",
         success: function(datos) {
            var lstXml = datos.getElementsByTagName("productos")[0];
            var lstProd = lstXml.getElementsByTagName("prod");
                var lstPrecio = lstXml.getElementsByTagName("Precio");
            var idCat = 0;
            var codigoX = "";
            var codigocortoX = "";
                var precio = "";
            for (var i = 0; i < lstProd.length; i++) {
               var objCatT = lstProd[i];
               idCat = objCatT.getAttribute('id');
               codigoX = objCatT.getAttribute('codigo');
               codigocortoX = objCatT.getAttribute('codigocorto');
               break;
            }
                for (var i = 0; i < lstPrecio.length; i++) {
                    var objCatT = lstPrecio[i];
                    precio = objCatT.getAttribute('precioUsar');
                    break;
                }

            //Evaluamos si encontramos el id
            if (parseFloat(idCat) == 0) {
               alert(strTitulo12);
            } else {
               document.getElementById("codigo" + strPref + iUid).value = codigoX;
               document.getElementById("codigocorto" + strPref + iUid).value = codigocortoX;
                    document.getElementById("precio" + strPref + iUid).value = precio;
               AddItem(idCat, obj, iUid);
            }
         },
         error: function(objeto, quepaso, otroobj) {
            alert("ecomm" + objeto + " " + quepaso + " " + otroobj);
         }
      });
      return false;
   }

   var bolPasa = true;
   //Obtenemos los valores 
   var dblCant = document.getElementById("cant" + strPref + iUid).value;
   try {
      dblCant = parseFloat(dblCant);
   } catch (err) {
      bolPasa = false;
      alert("La cantidad requiere ser numerica");
   }

   //buscamos si existe el item en el listado
   for (var j = 0; j <= intContaItems; j++) {
      var objItem = lstItems[j];
      if (parseInt(objItem.pr_id) == parseInt(idProd)) {
         bolPasa = false;
         //Ya existe solo actualizamos la cantidad
         intTotPzas += dblCant;
         objItem.pr_cantidad = parseFloat(objItem.pr_cantidad) + parseFloat(dblCant);
         var objImportes = new _ImporteVta();
         objImportes.dblCantidad = parseFloat(objItem.pr_cantidad);
         objImportes.dblPrecio = parseFloat(objItem.pr_precio);
         objImportes.dblPrecioReal = parseFloat(objItem.pr_precreal);
         objImportes.dblPuntos = parseFloat(objItem.pr_puntos_u);
         objImportes.dblVNegocio = parseFloat(objItem.pr_vnegocio_u);
         objImportes.dblPorcDescGlobal = parseFloat(dblDescuento);
         objImportes.dblPorcDesc = 0;
         objImportes.dblPrecFijo = 0;
         objImportes.dblExento1 = objItem.pr_exento1;
         objImportes.dblExento2 = objItem.pr_exento2;
         objImportes.dblExento3 = objItem.pr_exento3;
         objImportes.intDevo = 0;
         objImportes.intPrecioZeros = 0;
         if (obj.pr_desc_prec == 0)
            objImportes.bolAplicDescPrec = false;
         if (obj.pr_desc_pto == 0)
            objImportes.bolAplicDescPto = false;
         if (obj.pr_desc_nego == 0)
            objImportes.bolAplicDescVNego = false;
         objImportes.CalculaImporte();
         //Asignamos nuevos importes
         objItem.pr_importe = objImportes.dblImporte;
         objItem.pr_impuesto1 = objImportes.dblImpuesto1;
         objItem.pr_descuento = objImportes.dblImporteDescuento;
         objItem.pr_importereal = objImportes.dblImporteReal;
         objItem.pr_puntos_tot = objImportes.dblPuntosImporte;
         objItem.pr_vnegocio_tot = objImportes.dblVNegocioImporte;
         _PromocionProd(objItem);
      }
   }
   //Si pasamos todas las validaciones anexamos el item
   if (bolPasa) {
      //agregamos un nuevo item al listado
      intTotPzas += dblCant;
      intContaItems++;
      //Nuevo objeto de item
      var obj = new _ClassItem();
      obj.pr_descripcion = document.getElementById("desc" + strPref + iUid).value;
      obj.pr_cantidad = dblCant;
      obj.pr_importe = 0;
      obj.pr_codigo = document.getElementById("codigo" + strPref + iUid).value;
      obj.pr_codigocorto = document.getElementById("codigocorto" + strPref + iUid).value;
      obj.pr_tasaiva1 = dblTasaVta1;
      obj.pr_tasaiva2 = dblTasaVta2;
      obj.pr_tasaiva3 = dblTasaVta3;
      obj.pr_impuesto1 = 0;
      obj.pr_id = idProd;
      obj.pr_exento1 = parseInt(document.getElementById("exento1" + strPref + iUid).value);
      obj.pr_exento2 = parseInt(document.getElementById("exento2" + strPref + iUid).value);
      obj.pr_exento3 = parseInt(document.getElementById("exento3" + strPref + iUid).value);
      obj.pr_reqexist = document.getElementById("reqexist" + strPref + iUid).value;
      obj.pr_exist = document.getElementById("exist" + strPref + iUid).value;
      obj.pr_esregalo = 0;
      obj.pr_importereal = 0.0;
      obj.pr_precio = parseFloat(document.getElementById("precio" + strPref + iUid).value);
      obj.pr_precreal = parseFloat(document.getElementById("precio" + strPref + iUid).value);
      obj.pr_descuento = 0.0;
      obj.pr_porcdesc = 0.0;
      obj.pr_unidad_medida = document.getElementById("umedida" + strPref + iUid).value;
      obj.pr_puntos_u = parseFloat(document.getElementById("puntos" + strPref + iUid).value);
      obj.pr_vnegocio_u = parseFloat(document.getElementById("vnegocio" + strPref + iUid).value);
      obj.pr_cat1 = document.getElementById("cat1" + strPref + iUid).value;
      obj.pr_cat2 = document.getElementById("cat2" + strPref + iUid).value;
      obj.pr_cat3 = document.getElementById("cat3" + strPref + iUid).value;
      obj.pr_cat4 = document.getElementById("cat4" + strPref + iUid).value;
      obj.pr_cat5 = document.getElementById("cat5" + strPref + iUid).value;
      obj.pr_cat6 = document.getElementById("cat6" + strPref + iUid).value;
      obj.pr_cat7 = document.getElementById("cat7" + strPref + iUid).value;
      obj.pr_cat8 = document.getElementById("cat8" + strPref + iUid).value;
      obj.pr_cat9 = document.getElementById("cat9" + strPref + iUid).value;
      obj.pr_cat10 = document.getElementById("cat10" + strPref + iUid).value;
      obj.pr_desc_ori = 0;
      obj.pr_regalo = 0;
      obj.pr_id_promo = 0;
      obj.pr_preciousd = parseFloat(document.getElementById("precio_usd" + strPref + iUid).value);
      obj.pr_puntos = parseFloat(document.getElementById("puntos" + strPref + iUid).value);
      obj.pr_vnegocio = parseFloat(document.getElementById("vnegocio" + strPref + iUid).value);
      obj.pr_publico = parseFloat(document.getElementById("publico" + strPref + iUid).value);
      obj.pr_desc_prec = parseInt(document.getElementById("ApDesc" + strPref + iUid).value);
      obj.pr_desc_pto = parseInt(document.getElementById("ApDescPto" + strPref + iUid).value);
      obj.pr_desc_nego = parseInt(document.getElementById("ApDescVN" + strPref + iUid).value);
      obj.pr_lealtad = parseFloat(document.getElementById("lealtad" + strPref + iUid).value);
      obj.pr_lealtadCA = document.getElementById("lealtadCA" + strPref + iUid).value;
      //Agregamos notas en caso de productos agrupados
      if (intAgrupa == 1) {
         var _objSel4 = document.getElementById("Selcat4" + strPref + iUid);
         var _objSel5 = document.getElementById("Selcat5" + strPref + iUid);
         var _selCat4 = parseInt(_objSel4.value);
         var _selCat5 = parseInt(_objSel5.value);
         var _selCatTxt4 = _objSel4.options[_objSel4.selectedIndex].text;
         var _selCatTxt5 = _objSel5.options[_objSel5.selectedIndex].text;
         obj.pr_cat4 = _selCat4;
         obj.pr_cat5 = _selCat5;
         obj.pr_notas = strTitulo10 + _selCatTxt4 + " " + strTitulo11 + _selCatTxt5;
      }
      lstItems[intContaItems] = obj;

      //nuevo objeto de importe
      var objImportes = new _ImporteVta();
      objImportes.dblCantidad = parseFloat(obj.pr_cantidad);
      objImportes.dblPrecio = parseFloat(obj.pr_precio);
      objImportes.dblPrecioReal = parseFloat(obj.pr_precreal);
      objImportes.dblPuntos = parseFloat(obj.pr_puntos_u);
      objImportes.dblVNegocio = parseFloat(obj.pr_vnegocio_u);
      objImportes.dblPorcDescGlobal = parseFloat(dblDescuento);
      objImportes.dblPorcDesc = 0;
      objImportes.dblPrecFijo = 0;
      objImportes.dblExento1 = obj.pr_exento1;
      objImportes.dblExento2 = obj.pr_exento2;
      objImportes.dblExento3 = obj.pr_exento3;
      objImportes.intDevo = 0;
      objImportes.intPrecioZeros = 0;
      if (obj.pr_desc_prec == 0)
         objImportes.bolAplicDescPrec = false;
      if (obj.pr_desc_pto == 0)
         objImportes.bolAplicDescPto = false;
      if (obj.pr_desc_nego == 0)
         objImportes.bolAplicDescVNego = false;
      //if(lstRow.FACD_DESC_LEAL == 0)objImportes.bolAplicDescPrec= false;
      objImportes.CalculaImporte();
      //Asignamos nuevos importes
      obj.pr_importe = objImportes.dblImporte;
      obj.pr_impuesto1 = objImportes.dblImpuesto1;
      obj.pr_descuento = objImportes.dblImporteDescuento;
      obj.pr_importereal = objImportes.dblImporteReal;
      obj.pr_puntos_tot = objImportes.dblPuntosImporte;
      obj.pr_vnegocio_tot = objImportes.dblVNegocioImporte;
      //Reseteamos valores
      document.getElementById("cant" + strPref + iUid).value = 1;
      //sumatoria
      setSum();
   }
   return true;
}
/**Sumatoria*/
function setSum(bolPromos) {

   var dblSuma = 0;
   var dblImpuesto1 = 0;
   var dblImporte = 0;
   var dblImporteDesc = 0;
   var dblImportePto = 0;
   var dblImporteVn = 0;
   var dblImporteReal = 0;
   var dblImportePzas = 0;
   var dblImportePtoReal = 0;
   var dblImporteNegoReal = 0;
   var dblImporteCredReal = 0;
   var dblImporteImpuesto1Real = 0;
   var dblImporteImpuesto2Real = 0;
   var dblImporteImpuesto3Real = 0;
   for (var j = 0; j <= intContaItems; j++) {
      var objItem = lstItems[j];
      dblSuma += parseFloat(objItem.pr_importe);
      dblImpuesto1 += parseFloat(objItem.pr_impuesto1);
      dblImporte += (parseFloat(objItem.pr_importe) - parseFloat(objItem.pr_impuesto1));
      dblImporteDesc += parseFloat(objItem.pr_descuento);
      dblImportePto += parseFloat(objItem.pr_puntos_tot);
      dblImporteVn += parseFloat(objItem.pr_vnegocio_tot);
      //Calculo de totales adicionales utiles para las promociones
      dblImportePzas += parseFloat(objItem.pr_cantidad);
      dblImportePtoReal += parseFloat(objItem.pr_cantidad) * parseFloat(objItem.pr_puntos_u);
      dblImporteNegoReal += parseFloat(objItem.pr_cantidad) * parseFloat(objItem.pr_vnegocio_u);
      dblImporteCredReal += parseFloat(objItem.pr_cantidad) * 1;
      //Calculo de totales reales
      var dblTotlImpReal = parseFloat(objItem.pr_cantidad) * parseFloat(objItem.pr_precreal);
      var dblBase1 = dblTotlImpReal;
      var dblBase2 = dblTotlImpReal;
      var dblBase3 = dblTotlImpReal;
      if (parseInt(objItem.pr_exento1) == 1)
         dblBase1 = 0;
      if (parseInt(objItem.pr_exento2) == 1)
         dblBase2 = 0;
      if (parseInt(objItem.pr_exento3) == 1)
         dblBase3 = 0;
      var taxReal = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
      //Validamos si los precios incluyen impuestos
      if (intPreciosconImp == 1) {
         taxReal.CalculaImpuesto(dblBase1, dblBase2, dblBase3);
      } else {
         taxReal.CalculaImpuestoMas(dblBase1, dblBase2, dblBase3);
      }
      if (parseInt(objItem.pr_exento1) == 0)
         dblImporteImpuesto1Real = taxReal.dblImpuesto1;
      if (parseInt(objItem.pr_exento2) == 0)
         dblImporteImpuesto2Real = taxReal.dblImpuesto2;
      if (parseInt(objItem.pr_exento3) == 0)
         dblImporteImpuesto3Real = taxReal.dblImpuesto3;
      if (intPreciosconImp == 1) {
         dblImporteReal += dblTotlImpReal - dblImporteImpuesto1Real - dblImporteImpuesto2Real - dblImporteImpuesto3Real;
      } else {
         dblImporteReal += dblTotlImpReal;
      }
      //Calculo de totales adicionales utiles para las promociones
   }

   document.getElementById("FAC_IMPORTE_IEPS").value = FormatNumber(0, intNumdecimal, true);
   document.getElementById("FAC_TOT").value = FormatNumber(dblSuma, intNumdecimal, true);
   document.getElementById("Total_importe").innerHTML = strSimboloMoneda + FormatNumber(dblSuma, intNumdecimal, true);
   document.getElementById("FAC_IMPUESTO1").value = FormatNumber(dblImpuesto1, intNumdecimal, true);
   document.getElementById("FAC_IMPORTE").value = FormatNumber(dblImporte, intNumdecimal, true);
   document.getElementById("FAC_DESCUENTO").value = FormatNumber(dblImporteDesc, intNumdecimal, true);
   //MLM
   document.getElementById("FAC_PUNTOS").value = FormatNumber(dblImportePto, intNumdecimal, true);
   document.getElementById("FAC_NEGOCIO").value = FormatNumber(dblImporteVn, intNumdecimal, true);
   document.getElementById("FAC_IMPORTE_REAL").value = FormatNumber(dblImporteReal, intNumdecimal, true);
   document.getElementById("FAC_PZAS").value = FormatNumber(dblImportePzas, intNumdecimal, true);
   document.getElementById("FAC_PUNTOS_REAL").value = FormatNumber(dblImportePtoReal, intNumdecimal, true);
   document.getElementById("FAC_NEGOCIO_REAL").value = FormatNumber(dblImporteNegoReal, intNumdecimal, true);
   document.getElementById("FAC_CREDITOS_REAL").value = FormatNumber(dblImporteCredReal, intNumdecimal, true);
   document.getElementById("FAC_IMPUESTO1_REAL").value = FormatNumber(dblImporteImpuesto1Real, intNumdecimal, true);
   document.getElementById("FAC_IMPUESTO2_REAL").value = FormatNumber(dblImporteImpuesto2Real, intNumdecimal, true);
   document.getElementById("FAC_IMPUESTO3_REAL").value = FormatNumber(dblImporteImpuesto3Real, intNumdecimal, true);
   //MLM
   document.getElementById("Total_cantidad").innerHTML = intTotPzas;
   if (bolPromos == null)
      bolPromos = true;
   //Promociones
   _PromocionTot(bolPromos);
}
/*Funcion para guardar compra*/
function guardarCompra() {
   document.getElementById("tabs-1").style.display = "block";
   document.getElementById("tabs-2").style.display = "none";
   document.getElementById("tabs-3").style.display = "none";
   document.getElementById("tabs-4").style.display = "none";
   //Desplegamos los items
   var strHtml = "<table border=0 cellpadding=2 cellspacing=1 id='table_checkout'>";
   strHtml += "<tr>";
   strHtml += "<th>" + tittle1 + "</th>";
   strHtml += "<th>" + tittle2 + "</th>";
   strHtml += "<th>" + tittle3 + "</th>";
   strHtml += "<th align=right>" + tittle15 + "</th>";
   strHtml += "<th align=right>" + tittle4 + "</th>";
   strHtml += "<th align=right>" + tittle5 + "</th>";
   strHtml += "<th align=right>" + tittle11 + "</th>";
   strHtml += "<th align=right>" + tittle6 + "</th>";
   strHtml += "<th align=right>" + tittle7 + "</th>";
   strHtml += "<th align=right>" + tittle8 + "</th>";
   strHtml += "<th align=right>" + tittle9 + "</th>";
   strHtml += "<th align=right>" + tittle10 + "</th>";
   strHtml += "</tr>";
   for (var j = 0; j <= intContaItems; j++) {
      var objItem = lstItems[j];

      //Calculamos el impuesto
      var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
      //Validamos si los precios incluyen impuestos
      if (intPreciosconImp == 1) {
         tax.CalculaImpuesto(objItem.pr_precio, 0, 0);
      } else {
         tax.CalculaImpuestoMas(objItem.pr_precio, 0, 0);
      }
      var dblPrecioMasIVA = parseFloat(objItem.pr_precio) + parseFloat(tax.dblImpuesto1);

      strHtml += "<tr>";
      if (codigoCampo == "1") {
         strHtml += "<td>" + objItem.pr_codigo + "</td>";
      } else {
         strHtml += "<td>" + objItem.pr_codigocorto + "</td>";
      }
      strHtml += "<td>" + objItem.pr_descripcion + "</td>";
      strHtml += "<td>" + objItem.pr_notas + "</td>";
      strHtml += "<td align='right'>" + strSimboloMoneda + FormatNumber(dblPrecioMasIVA, intNumdecimal, true) + "</td>";
      strHtml += "<td align='right'>" + strSimboloMoneda + FormatNumber(objItem.pr_precio, intNumdecimal, true) + "</td>";
      strHtml += "<td align='right'>" + objItem.pr_cantidad + "</td>";
      strHtml += "<td align='right'>" + strSimboloMoneda + FormatNumber((parseFloat(objItem.pr_importereal) - parseFloat(objItem.pr_impuestoreal)), intNumdecimal, true) + "</td>";
      strHtml += "<td align='right'>" + strSimboloMoneda + FormatNumber(objItem.pr_descuento, intNumdecimal, true) + "</td>";
      strHtml += "<td align='right'>" + FormatNumber(objItem.pr_porcdesc, intNumdecimal, true) + "%</td>";
      strHtml += "<td align='right'>" + strSimboloMoneda + FormatNumber((parseFloat(objItem.pr_importe) - parseFloat(objItem.pr_impuesto1)), intNumdecimal, true) + "</td>";
      strHtml += "<td align='right'>" + FormatNumber(objItem.pr_puntos_tot, intNumdecimal, true) + "</td>";
      strHtml += "<td align='right'>" + FormatNumber(objItem.pr_vnegocio_tot, intNumdecimal, true) + "</td>";
      strHtml += "</tr>";
   }
   strHtml += "<tr>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>" + tittle12 + "</td>";
   strHtml += "<td align='right'>" + strSimboloMoneda + document.getElementById("FAC_IMPORTE").value + "</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "</tr>";
   strHtml += "<tr>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>" + tittle13 + "</td>";
   strHtml += "<td align='right'>" + strSimboloMoneda + document.getElementById("FAC_IMPUESTO1").value + "</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "</tr>";
   strHtml += "<tr>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<td>&nbsp;</td>";
   strHtml += "<th>" + tittle14 + "</td>";
   strHtml += "<th id='ecomm_total' align='right'>" + strSimboloMoneda + document.getElementById("FAC_TOT").value + "</td>";
   strHtml += "<th id='ecomm_puntos2' align='right'>" + document.getElementById("FAC_PUNTOS").value + "</td>";
   strHtml += "<th id='ecomm_negocio2' align='right'>" + document.getElementById("FAC_NEGOCIO").value + "</td>";
   strHtml += "</tr>";
   strHtml += "</table>";
   document.getElementById("desglose").innerHTML = strHtml;
   //Abrimos cuadro de dialogo
   $("#dialogCheckOut").dialog("open");
}
/**Funcion para limpiar la compra*/
function limpiarCompra() {
   intTotPzas = 0;
   intTotal = 0.0;
   intContaItems = -1;
   document.getElementById("Total_cantidad").innerHTML = intTotPzas;
   document.getElementById("Total_importe").innerHTML = intTotal;
   document.getElementById("FAC_IMPORTE").value = 0.0;
   document.getElementById("FAC_IMPUESTO1").value = 0.0;
   document.getElementById("FAC_TOT").value = 0.0;
   document.getElementById("FAC_PUNTOS").value = 0.0;
   document.getElementById("FAC_NEGOCIO").value = 0.0;
   lstItems = Array();
   _ResetPromosAll();
}
/**############# PASOS PARA GUARDAR LA COMPRA #################*/
//Paso 1 checkout, y terminos y condiciones
function Step1() {
   if (!document.getElementById("aceptoT").checked) {
      alert("Debe aceptar los terminos y condiciones para continuar");
      return false;
   }
   if (document.getElementById("answer").value == "") {
      alert("debe escribir la respuesta");
      return false;
   }
   //Evaluamos el captcha
   $.ajax({
      type: "POST",
      data: "answer=" + document.getElementById("answer").value,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "html",
      url: "modules/mod_ecomm/ecomm_captcha.jsp",
      success: function(dato) {
         dato = trim(dato);
         if (Left(dato, 2) == "OK") {
            //Evaluamos si es un cliente logueado guardamos la venta directamente
            $.ajax({
               type: "POST",
               data: "",
               scriptCharset: "utf-8",
               contentType: "application/x-www-form-urlencoded;charset=utf-8",
               cache: false,
               dataType: "html",
               url: "modules/mod_ecomm/ecomm_islogged.jsp",
               success: function(dato) {
                  dato = trim(dato);
                  if (Left(dato, 2) == "OK") {
                     //Guardamos directamente
                     document.getElementById("tabs-1").style.display = "none";
                     document.getElementById("tabs-2a").style.display = "block";
                  } else {
                     //Solicitamos datos
                     document.getElementById("tabs-1").style.display = "none";
                     document.getElementById("tabs-2").style.display = "block";
                  }
                  $("#dialogWait").dialog("close");
               },
               error: function(objeto, quepaso, otroobj) {
                  alert("ecomm save" + objeto + " " + quepaso + " " + otroobj);
                  $("#dialogWait").dialog("close");
               }
            });
         } else {
//            var oImg = new Image();
//            oImg.onload = function() {
//               document.getElementById("Captcha").src = oImg.src
//            }
//            oImg.onerror = function() {
//               document.getElementById("Captcha").src = "../images/image_PNG.png"
//            }
//            oImg.src = "../ImageServlet";
            alert("Error:El texto de la imagen es incorrecto vuelva a intentarlo");
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert("ecomm save" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });

   return true;
}
//Paso 2 nombre, mail del comprador y direccion de envio
function Step2() {
   if (document.getElementById("Nombre").value == "") {
      alert("Debe Capturar un Nombre");
      return false;
   }
   if (document.getElementById("Email").value != "") {
      var bolExpReg = _EvalExpReg(document.getElementById("Email").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
      if (!bolExpReg) {
         alert("El formato del mail es incorrecto");
         document.getElementById("Email").focus();

         return false;
      }
   } else {
      alert("Capture un mail");
      document.getElementById("Email").focus();
      document.getElementById("Email").focus();
      return false;
   }
   if (document.getElementById("Calle_ent").value == "") {
      alert("Capture una Calle");
      document.getElementById("Calle_ent").focus();
      return false;
   }
   if (document.getElementById("Numero_ent").value == "") {
      alert("Capture un número o S/N");
      document.getElementById("Numero_ent").focus();
      return false;
   }

   if (document.getElementById("Colonia_ent").value == "") {
      alert("Capture una colonia");
      document.getElementById("Colonia_ent").focus();
      return false;
   }
   if (document.getElementById("Municipio_ent").value == "") {
      alert("Capture el municipio");
      document.getElementById("Municipio_ent").focus();
      return false;
   }

   if (document.getElementById("Estado_ent").value == "") {
      alert("Elija un estado");
      return false;
   }

   if (document.getElementById("cp_ent").value == "") {
      alert("Capture el codigo postal");
      document.getElementById("cp_ent").focus();
      return false;
   }
   //Codigo postal
   if (document.getElementById("cp_ent").value != "") {
      var bolExpReg = _EvalExpReg(document.getElementById("cp_ent").value, "^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$");
      if (!bolExpReg) {
         alert("El formato del codigo postal es incorrecto");
         document.getElementById("cp_ent").focus();
         return false;
      }
   }
   document.getElementById("tabs-2").style.display = "none";
   document.getElementById("tabs-3").style.display = "block";

}
//Paso 2 nombre, mail del comprador y direccion de envio
function Step2a() {
   var objSelChk2 = document.getElementById("UsarDirEnt");
   //Solo validamos si el objeto esta seleccionado
   if (objSelChk2.checked) {

      if (document.getElementById("Nombre_ent_n").value == "") {
         alert("Debe Capturar un Nombre");
         return false;
      }
      if (document.getElementById("Email_ent_n").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("Email_ent_n").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
         if (!bolExpReg) {
            alert("El formato del mail es incorrecto");
            document.getElementById("Email_ent_n").focus();

            return false;
         }
      }

      if (document.getElementById("Calle_ent_n").value == "") {
         alert("Capture una Calle");
         document.getElementById("Calle_ent_n").focus();
         return false;
      }
      if (document.getElementById("Numero_ent_n").value == "") {
         alert("Capture un número o S/N");
         document.getElementById("Numero_ent_n").focus();
         return false;
      }

      if (document.getElementById("Colonia_ent_n").value == "") {
         alert("Capture una colonia");
         document.getElementById("Colonia_ent_n").focus();
         return false;
      }
      if (document.getElementById("Municipio_ent_n").value == "") {
         alert("Capture el municipio");
         document.getElementById("Municipio_ent_n").focus();
         return false;
      }

      if (document.getElementById("Estado_ent_n").value == "") {
         alert("Elija un estado");
         return false;
      }

      if (document.getElementById("cp_ent_n").value == "") {
         alert("Capture el codigo postal");
         document.getElementById("cp_ent_n").focus();
         return false;
      }
      //Codigo postal
      if (document.getElementById("cp_ent_n").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("cp_ent_n").value, "^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$");
         if (!bolExpReg) {
            alert("El formato del codigo postal es incorrecto");
            document.getElementById("cp_ent_n").focus();
            return false;
         }
      }
   }

   document.getElementById("tabs-2a").style.display = "none";
   document.getElementById("tabs-4").style.display = "block";

}
//Paso 3 datos de facturacion
function Step3() {
   if (document.getElementById("siFacturo").checked == true) {
      if (document.getElementById("razonsocial").value == "") {
         document.getElementById("razonsocial").focus();
         alert("Capture Razon Social");
         return false;
      }

      if (document.getElementById("rfc").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("rfc").value, "^[a-zA-Z][a-zA-Z-_0-9.]+@[a-zA-Z-_=>0-9.]+.[a-zA-Z]{2,3}$");
         if (!bolExpReg) {
            alert("El formato del rfc es incorrecto");
            document.getElementById("rfc").focus();

            return false;
         }
      } else {
         alert("Capture su RFC");
         document.getElementById("rfc").focus();
         document.getElementById("rfc").focus();
         return false;
      }

      if (document.getElementById("Calle").value == "") {
         alert("Capture una Calle");
         document.getElementById("Calle").focus();
         return false;
      }
      if (document.getElementById("Numero").value == "") {
         alert("Capture un número o S/N");
         document.getElementById("Numero_ent").focus();
         return false;
      }

      if (document.getElementById("Colonia").value == "") {
         alert("Capture una colonia");
         document.getElementById("Colonia").focus();
         return false;
      }
      if (document.getElementById("Municipio").value == "") {
         alert("Capture el municipio");
         document.getElementById("Municipio").focus();
         return false;
      }
      if (document.getElementById("Estado").value == "") {
         alert("Elija un estado");
         return false;
      }

      if (document.getElementById("cp_fact").value == "") {
         alert("Capture el codigo postal");
         document.getElementById("cp_fact").focus();
         return false;
      }
      //Codigo postal
      if (document.getElementById("cp_fact").value != "") {
         var bolExpReg = _EvalExpReg(document.getElementById("cp_fact").value, "^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$");
         if (!bolExpReg) {
            alert("El formato del codigo postal es incorrecto");
            document.getElementById("cp_fact").focus();
            return false;
         }
      }

   }
   document.getElementById("tabs-3").style.display = "none";
   document.getElementById("tabs-4").style.display = "block";

}
function Step5() {
   SaveVtaDo();
   /*Enviamos peticion por ajax...*/
}
function StepBack2() {
   document.getElementById("tabs-1").style.display = "block";
   document.getElementById("tabs-2").style.display = "none";
}
function StepBack3() {
   document.getElementById("tabs-2").style.display = "block";
   document.getElementById("tabs-3").style.display = "none";
}
function StepBack4() {
   document.getElementById("tabs-3").style.display = "block";
   document.getElementById("tabs-4").style.display = "none";
}
//Cerramos cuadro de dialogo 
function Step6() {
   document.getElementById("tabs-5").style.display = "none";
   document.getElementById("tabs-1").style.display = "block";
   $("#dialogCheckOut").dialog("close");
}
/**Cancela el guardado*/
function Cancel() {
   document.getElementById("tabs-5").style.display = "none";
   document.getElementById("tabs-1").style.display = "block";
   $("#dialogCheckOut").dialog("close");
}
/**Deja capturar los datos de la facturacion o los quita si no desean facturar*/
function SiFacturo(obj) {
   if (obj.checked) {
      document.getElementById("razonsocial").readOnly = false;
      document.getElementById("rfc").readOnly = false;
      document.getElementById("Calle").readOnly = false;
      document.getElementById("Numero").readOnly = false;
      document.getElementById("NumeroInt").readOnly = false;
      document.getElementById("Colonia").readOnly = false;
      document.getElementById("Estado").readOnly = false;
      document.getElementById("Estado").disabled = false;
      document.getElementById("cp_fact").readOnly = false;
   } else {
      document.getElementById("razonsocial").readOnly = true;
      document.getElementById("rfc").readOnly = true;
      document.getElementById("Calle").readOnly = true;
      document.getElementById("Numero").readOnly = true;
      document.getElementById("NumeroInt").readOnly = true;
      document.getElementById("Colonia").readOnly = true;
      document.getElementById("Estado").readOnly = true;
      document.getElementById("Estado").disabled = true;
      document.getElementById("cp_fact").readOnly = true;
      document.getElementById("razonsocial").value = "";
      document.getElementById("rfc").value = "";
      document.getElementById("Calle").value = "";
      document.getElementById("Numero").value = "";
      document.getElementById("NumeroInt").value = "";
      document.getElementById("Colonia").value = "";
      document.getElementById("Estado").value = "";
      document.getElementById("cp_fact").value = "";
   }
}
/**Guarda la venta*/
function SaveVtaDo() {
   $("#dialogWait").dialog("open");
   //Armamos el POST a enviar
   var strPOST = "";
   //Prefijos dependiendo del tipo de venta
   var strPrefijoMaster = "PD";
   var strPrefijoDeta = "PDD";
   var strKey = "PD_ID";
   var strNomFormat = "PEDIDO";
   //Master
   strPOST += "SC_ID=" + intSucursal;
   strPOST += "&CT_ID=" + intCte;
   strPOST += "&VE_ID=0";
   strPOST += "&PD_ID=0";
   strPOST += "&" + strPrefijoMaster + "_ESSERV=0";
   strPOST += "&" + strPrefijoMaster + "_MONEDA=" + document.getElementById("FAC_MONEDA").value;
   strPOST += "&" + strPrefijoMaster + "_FECHA=" + document.getElementById("FAC_FECHA").value;
   strPOST += "&" + strPrefijoMaster + "_FOLIO=";
   strPOST += "&" + strPrefijoMaster + "_NOTASPIE=ecomm";
   strPOST += "&" + strPrefijoMaster + "_TOTAL=" + document.getElementById("FAC_TOT").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO1=" + document.getElementById("FAC_IMPUESTO1").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO2=" + document.getElementById("FAC_IMPUESTO2").value;
   strPOST += "&" + strPrefijoMaster + "_IMPUESTO3=" + document.getElementById("FAC_IMPUESTO3").value;
   strPOST += "&" + strPrefijoMaster + "_IMPORTE=" + document.getElementById("FAC_IMPORTE").value;
   strPOST += "&" + strPrefijoMaster + "_RETISR=" + document.getElementById("FAC_RETISR").value;
   strPOST += "&" + strPrefijoMaster + "_RETIVA=" + document.getElementById("FAC_RETIVA").value;
   strPOST += "&" + strPrefijoMaster + "_NETO=" + document.getElementById("FAC_NETO").value;
   strPOST += "&" + strPrefijoMaster + "_NOTAS=" + document.getElementById("Notas_may").value;
   strPOST += "&" + strPrefijoMaster + "_REFERENCIA=" + document.getElementById("FAC_REFERENCIA").value;
   strPOST += "&" + strPrefijoMaster + "_CONDPAGO=" + document.getElementById("FAC_CONDPAGO").value;
   strPOST += "&" + strPrefijoMaster + "_METODOPAGO=" + document.getElementById("FAC_METODOPAGO").value;
   strPOST += "&" + strPrefijoMaster + "_NUMCUENTA=" + document.getElementById("FAC_NUMCUENTA").value;
   strPOST += "&" + strPrefijoMaster + "_FORMADEPAGO=" + document.getElementById("FAC_FORMADEPAGO").value;
   strPOST += "&" + strPrefijoMaster + "_NUMPEDI=" + document.getElementById("FAC_NUMPEDI").value;
   strPOST += "&" + strPrefijoMaster + "_FECHAPEDI=" + document.getElementById("FAC_FECHAPEDI").value;
   strPOST += "&" + strPrefijoMaster + "_ADUANA=" + document.getElementById("FAC_ADUANA").value;
   strPOST += "&" + strPrefijoMaster + "_TIPOCOMP=" + document.getElementById("FAC_TIPOCOMP").value;
   strPOST += "&TIPOVENTA=3";
   strPOST += "&" + strPrefijoMaster + "_TASA1=" + dblTasaVta1;
   strPOST += "&" + strPrefijoMaster + "_TASA2=" + dblTasaVta2;
   strPOST += "&" + strPrefijoMaster + "_TASA3=" + dblTasaVta3;
   strPOST += "&" + "TI_ID=" + intIdTasaVta1;
   strPOST += "&" + "TI_ID2=" + intIdTasaVta2;
   strPOST += "&" + "TI_ID3=" + intIdTasaVta3;
   strPOST += "&" + strPrefijoMaster + "_TASAPESO=1";
   strPOST += "&" + strPrefijoMaster + "_DIASCREDITO=0";
   //MLM
   strPOST += "&" + strPrefijoMaster + "_PUNTOS=" + document.getElementById("FAC_PUNTOS").value;
   strPOST += "&" + strPrefijoMaster + "_NEGOCIO=" + document.getElementById("FAC_NEGOCIO").value;
   //Validamos IEPS
   strPOST += "&" + strPrefijoMaster + "_USO_IEPS=0";
   strPOST += "&" + strPrefijoMaster + "_TASA_IEPS=0";
   strPOST += "&" + strPrefijoMaster + "_IMPORTE_IEPS=0";
   //Validamos _CONSIGNACION
   strPOST += "&" + strPrefijoMaster + "_CONSIGNACION=0";
   //Agregamos campos ADDENDA MABE
   strPOST += "&ADD_MABE=0";
   //Agregamos campos ADDENDA AMECE
   strPOST += "&ADD_AMECE=0";
   //Recurrentes
   strPOST += "&" + strPrefijoMaster + "_ESRECU=0";
   strPOST += "&" + strPrefijoMaster + "_PERIODICIDAD=0";
   strPOST += "&" + strPrefijoMaster + "_DIAPER=1";
   //Enviamos los datos de la direccion de entrega y de facturacion
   strPOST += "&Nombre=" + document.getElementById("Nombre").value;
   strPOST += "&Email=" + document.getElementById("Email").value;
   strPOST += "&Calle_ent=" + document.getElementById("Calle_ent").value;
   strPOST += "&Numero_ent=" + document.getElementById("Numero_ent").value;
   strPOST += "&NumeroInt_ent=" + document.getElementById("NumeroInt_ent").value;
   strPOST += "&Colonia_ent=" + document.getElementById("Colonia_ent").value;
   strPOST += "&Municipio_ent=" + document.getElementById("Municipio_ent").value;
   strPOST += "&Estado_ent=" + document.getElementById("Estado_ent").value;
   strPOST += "&cp_ent=" + document.getElementById("cp_ent").value;
   //Validamos si quiere facturar
   if (document.getElementById("siFacturo").checked) {
      strPOST += "&siFacturo=1";
   } else {
      strPOST += "&siFacturo=0";
   }
   strPOST += "&razonsocial=" + document.getElementById("razonsocial").value;
   strPOST += "&rfc=" + document.getElementById("rfc").value;
   strPOST += "&Calle=" + document.getElementById("Calle").value;
   strPOST += "&Numero=" + document.getElementById("Numero").value;
   strPOST += "&NumeroInt=" + document.getElementById("NumeroInt").value;
   strPOST += "&Colonia=" + document.getElementById("Colonia").value;
   strPOST += "&Municipio=" + document.getElementById("Municipio").value;
   strPOST += "&Estado=" + document.getElementById("Estado").value;
   strPOST += "&cp_fact=" + document.getElementById("cp_fact").value;
   //direccion de entrega adicional
   var objSelChk2 = document.getElementById("UsarDirEnt");
   //Solo validamos si el objeto esta seleccionado
   if (objSelChk2.checked) {
      strPOST += "&appDirEntrega=1";
      strPOST += "&Nombre_nw=" + document.getElementById("Nombre_ent_n").value;
      strPOST += "&Email_nw=" + document.getElementById("Email_ent_n").value;
      strPOST += "&Calle_nw=" + document.getElementById("Calle_ent_n").value;
      strPOST += "&Numero_nw=" + document.getElementById("Numero_ent_n").value;
      strPOST += "&NumeroInt_nw=" + document.getElementById("NumeroInt_ent_n").value;
      strPOST += "&Colonia_nw=" + document.getElementById("Colonia_ent_n").value;
      strPOST += "&Municipio_nw=" + document.getElementById("Municipio_ent_n").value;
      strPOST += "&Estado_nw=" + document.getElementById("Estado_ent_n").value;
      strPOST += "&cp_fact_nw=" + document.getElementById("cp_ent_n").value;
   } else {
      strPOST += "&appDirEntrega=0";
   }
   //Items

   var intC = 0;
   for (var j = 0; j <= intContaItems; j++) {
      var objItem = lstItems[j];
      intC++;
      strPOST += "&PR_ID" + intC + "=" + objItem.pr_id;
      strPOST += "&" + strPrefijoDeta + "_EXENTO1" + intC + "=" + objItem.pr_exento1;
      strPOST += "&" + strPrefijoDeta + "_EXENTO2" + intC + "=" + objItem.pr_exento2;
      strPOST += "&" + strPrefijoDeta + "_EXENTO3" + intC + "=" + objItem.pr_exento3;
      strPOST += "&" + strPrefijoDeta + "_CVE" + intC + "=" + objItem.pr_codigo;
      strPOST += "&" + strPrefijoDeta + "_DESCRIPCION" + intC + "=" + objItem.pr_descripcion;
      strPOST += "&" + strPrefijoDeta + "_CANTIDAD" + intC + "=" + objItem.pr_cantidad;
      strPOST += "&" + strPrefijoDeta + "_RET_ISR" + intC + "=" + objItem.pr_ret_isr;
      strPOST += "&" + strPrefijoDeta + "_RET_IVA" + intC + "=" + objItem.pr_ret_iva;
      strPOST += "&" + strPrefijoDeta + "_RET_FLETE" + intC + "=" + objItem.pr_ret_flete;
      //MLM
      strPOST += "&" + strPrefijoDeta + "_IMP_PUNTOS" + intC + "=" + objItem.pr_puntos_tot;
      strPOST += "&" + strPrefijoDeta + "_IMP_VNEGOCIO" + intC + "=" + objItem.pr_vnegocio_tot;
      strPOST += "&" + strPrefijoDeta + "_PUNTOS" + intC + "=" + objItem.pr_puntos_u;
      strPOST += "&" + strPrefijoDeta + "_VNEGOCIO" + intC + "=" + objItem.pr_vnegocio_u;
      strPOST += "&" + strPrefijoDeta + "_DESC_PREC" + intC + "=" + objItem.pr_desc_prec;
      strPOST += "&" + strPrefijoDeta + "_DESC_PTO" + intC + "=" + objItem.pr_desc_pto;
      strPOST += "&" + strPrefijoDeta + "_DESC_VN" + intC + "=" + objItem.pr_desc_nego;
      //      strPOST += "&" + strPrefijoDeta + "_DESC_LEAL" + intC + "=" + objItem.FACD_DESC_LEAL;
      strPOST += "&" + strPrefijoDeta + "_DESC_ORI" + intC + "=" + objItem.pr_desc_ori;
      strPOST += "&" + strPrefijoDeta + "_REGALO" + intC + "=" + objItem.pr_regalo;
      strPOST += "&" + strPrefijoDeta + "_ID_PROMO" + intC + "=" + objItem.pr_id_promo;

      //MLM
      //Validamos si los precios incluyen o no impuestos para guardarlos incluyendo impuestos
      if (intPreciosconImp == 1) {
         strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + objItem.pr_precio;
         strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + objItem.pr_precreal;
      } else {
         var dblPrecioConImp = 0;
         var dblPrecioRealConImp = 0;
         if (objItem.pr_cantidad > 0) {
            //Calculamos el impuesto
            var dblBase1 = 0;
            var dblBase2 = 0;
            var dblBase3 = 0;
            var dblBaseReal1 = 0;
            var dblBaseReal2 = 0;
            var dblBaseReal3 = 0;
            var dblImpuesto1 = 0;
            var dblImpuesto2 = 0;
            var dblImpuesto3 = 0;
            var dblImpuestoReal1 = 0;
            var dblImpuestoReal2 = 0;
            var dblImpuestoReal3 = 0;
            if (parseInt(objItem.pr_exento1) == 0)
               dblBase1 = objItem.pr_precio;
            if (parseInt(objItem.pr_exento2) == 0)
               dblBase2 = objItem.pr_precio;
            if (parseInt(objItem.pr_exento3) == 0)
               dblBase3 = objItem.pr_precio;
            if (parseInt(objItem.pr_exento1) == 0)
               dblBaseReal1 = objItem.pr_precreal;
            if (parseInt(objItem.pr_exento2) == 0)
               dblBaseReal2 = objItem.pr_precreal;
            if (parseInt(objItem.pr_exento3) == 0)
               dblBaseReal3 = objItem.pr_precreal;
            var tax = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
            tax.CalculaImpuestoMas(dblBase1, dblBase2, dblBase3);
            var tax2 = new Impuestos(dblTasaVta1, dblTasaVta2, dblTasaVta3, intSImpVta1_2, intSImpVta1_3, intSImpVta2_3);//Objeto para calculo de impuestos
            tax2.CalculaImpuestoMas(dblBaseReal1, dblBaseReal2, dblBaseReal3);
            if (parseInt(objItem.pr_exento1) == 0)
               dblImpuesto1 = tax.dblImpuesto1;
            if (parseInt(objItem.pr_exento2) == 0)
               dblImpuesto2 = tax.dblImpuesto2;
            if (parseInt(objItem.pr_exento3) == 0)
               dblImpuesto3 = tax.dblImpuesto3;
            if (parseInt(objItem.pr_exento1) == 0)
               dblImpuestoReal1 = tax2.dblImpuesto1;
            if (parseInt(objItem.pr_exento2) == 0)
               dblImpuestoReal2 = tax2.dblImpuesto2;
            if (parseInt(objItem.pr_exento3) == 0)
               dblImpuestoReal3 = tax2.dblImpuesto3;
            dblPrecioConImp = (parseFloat(objItem.pr_precio) +
                    dblImpuesto1 +
                    dblImpuesto2 +
                    dblImpuesto3);
            dblPrecioRealConImp = (parseFloat(objItem.pr_precreal) +
                    dblImpuestoReal1 +
                    dblImpuestoReal2 +
                    dblImpuestoReal3);

         } else {
            dblPrecioConImp = (parseFloat(objItem.pr_precio));
            dblPrecioRealConImp = (parseFloat(objItem.pr_precreal));
         }
         strPOST += "&" + strPrefijoDeta + "_PRECIO" + intC + "=" + dblPrecioConImp;
         strPOST += "&" + strPrefijoDeta + "_PRECREAL" + intC + "=" + dblPrecioRealConImp;
      }
      strPOST += "&" + strPrefijoDeta + "_IMPORTE" + intC + "=" + objItem.pr_importe;
      strPOST += "&" + strPrefijoDeta + "_TASAIVA1" + intC + "=" + objItem.pr_tasaiva1;
      strPOST += "&" + strPrefijoDeta + "_TASAIVA2" + intC + "=0" + objItem.pr_tasaiva2;
      strPOST += "&" + strPrefijoDeta + "_TASAIVA3" + intC + "=" + objItem.pr_tasaiva3;
      strPOST += "&" + strPrefijoDeta + "_IMPUESTO1" + intC + "=" + objItem.pr_impuesto1;
      strPOST += "&" + strPrefijoDeta + "_IMPUESTO2" + intC + "=" + 0;
      strPOST += "&" + strPrefijoDeta + "_IMPUESTO3" + intC + "=" + 0;
      strPOST += "&" + strPrefijoDeta + "_ESREGALO" + intC + "=" + objItem.pr_esregalo;
      strPOST += "&" + strPrefijoDeta + "_NOSERIE" + intC + "=" + objItem.pr_noserie;
      strPOST += "&" + strPrefijoDeta + "_IMPORTEREAL" + intC + "=" + objItem.pr_importereal;
      strPOST += "&" + strPrefijoDeta + "_DESCUENTO" + intC + "=" + objItem.pr_descuento;
      strPOST += "&" + strPrefijoDeta + "_PORDESC" + intC + "=" + objItem.pr_porcdesc;
      strPOST += "&" + strPrefijoDeta + "_ESDEVO" + intC + "=" + objItem.pr_esdevo;
      strPOST += "&" + strPrefijoDeta + "_PRECFIJO" + intC + "=" + objItem.pr_precfijo;
      strPOST += "&" + strPrefijoDeta + "_NOTAS" + intC + "=" + objItem.pr_notas;
      strPOST += "&" + strPrefijoDeta + "_UNIDAD_MEDIDA" + intC + "=" + objItem.pr_unidad_medida;
   }
   strPOST += "&COUNT_ITEM=" + intC;
   //Pagos Mandamos las 4 formas de pago
   strPOST += "&COUNT_PAGOS=1";
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
      url: "modules/mod_ecomm/ecomm_save.jsp?id=1",
      success: function(dato) {
         dato = trim(dato);
         if (Left(dato, 3) == "OK.") {
            //Mostramos el numero de pedido generado
            document.getElementById("tabs-5").style.display = "block";
            document.getElementById("tabs-4").style.display = "none";
            //Imprimimos el pedido
            ImprimeconFolio(strKey, dato, strNomFormat);
            limpiarCompra();
         } else {
            alert(dato);
         }
         $("#dialogWait").dialog("close");
      },
      error: function(objeto, quepaso, otroobj) {
         alert("ecomm save" + objeto + " " + quepaso + " " + otroobj);
         $("#dialogWait").dialog("close");
      }
   });
}

/*Objeto que representa un item de compra*/
function _ClassItem() {
   this.pr_importe = 0;
   this.pr_codigo = "";
   this.pr_codigocorto = "";
   this.pr_precio = 0;
   this.pr_tasaiva1 = 0;
   this.pr_tasaiva2 = 0;
   this.pr_tasaiva3 = 0;
   this.pr_desglosa1 = 0;
   this.pr_impuesto1 = 0;
   this.pr_id = 0;
   this.pr_exento1 = 0;
   this.pr_exento2 = 0;
   this.pr_exento3 = 0;
   this.pr_reqexist = 0;
   this.pr_exist = 0;
   this.pr_noserie = "";
   this.pr_esregalo = 0;
   this.pr_importereal = 0.0;
   this.pr_impuestoreal = 0.0;
   this.pr_precreal = 0.0;
   this.pr_descuento = 0.0;
   this.pr_porcdesc = 0.0;
   this.pr_precfijo = 0;
   this.pr_esdevo = 0;
   this.pr_codbarras = "";
   this.pr_notas = "";
   this.pr_ret_isr = 0;
   this.pr_ret_iva = 0;
   this.pr_ret_flete = 0;
   this.pr_unidad_medida = "";
   this.pr_puntos_u = 0;
   this.pr_vnegocio_u = 0;
   this.pr_puntos_tot = 0;
   this.pr_vnegocio_tot = 0;
   this.pr_cat1 = 0;
   this.pr_cat2 = 0;
   this.pr_cat3 = 0;
   this.pr_cat4 = 0;
   this.pr_cat5 = 0;
   this.pr_cat6 = 0;
   this.pr_cat7 = 0;
   this.pr_cat8 = 0;
   this.pr_cat9 = 0;
   this.pr_cat10 = 0;
   this.pr_desc_ori = 0;
   this.pr_regalo = 0;
   this.pr_id_promo = 0;
   this.pr_cantidad = 0;
   this.pr_descripcion = "";
   this.pr_preciousd = 0;
   this.pr_puntos = 0;
   this.pr_vnegocio = 0;
   this.pr_publico = 0;
   this.pr_desc_prec = 0;
   this.pr_desc_pto = 0;
   this.pr_desc_nego = 0;
   this.pr_lealtad = 0;
   this.pr_lealtadCA = 0;
   this.pr_negocioZero = 0;
}
/**Imprime el pedido con el numero de folio*/
function ImprimeconFolio(strKey, dato, strNomFormat) {
   $.ajax({
      type: "POST",
      data: "KEY_ID=" + strKey,
      scriptCharset: "utf-8",
      contentType: "application/x-www-form-urlencoded;charset=utf-8",
      cache: false,
      dataType: "xml",
      url: "modules/mod_ecomm/ecomm_save.jsp?id=4",
      success: function(datos) {
         var objsc = datos.getElementsByTagName("vta_folios")[0];
         var strFolioT = objsc.getAttribute('FOLIO');
         var strHtml2 = CreaHidden(strKey, dato.replace("OK.", ""));
         document.getElementById("IdPedidoWeb").innerHTML = "<h3>" + strFolioT + "</h3>";
         openFormatEcomm("PEDIDO", "PDF", strHtml2);
      },
      error: function(objeto, quepaso, otroobj) {
         alert(":ImprimeFolio:" + objeto + " " + quepaso + " " + otroobj);
      }
   });

}
//Valida un cadena conforme una expresion regular
function _EvalExpReg(YourValue, YourExp)
{
   var Template = new RegExp(YourExp)
   return (Template.test(YourValue)) ? 1 : 0 //Compara "YourAlphaNumeric" con el formato "Template" y si coincidevuelve verdadero si no devuelve falso
}

/***OFERTAS Y PROMOCIONES**/
function _EvalPromociones() {
   if (intSucOfertas) {
      _LoadOfertasPromociones()
   }
}
/**Carga de libreria de ofertas y regalos*/
function _LoadOfertasPromociones() {
   var _countTimePromoLoadJs = 0;
   var strScript = "if(vta_promociones){return true}else{return false}";
   var strFn = new Function(strScript);
   try {
      if (strFn()) {
         _InitPromocionesEcomm();
      }
   } catch (err) {
      // not loaded yet
      if (_countTimePromoLoadJs == 0)
         importa("../javascript/vta_promociones.js");
      var delay = 1;
      setTimeout("_LoadOfertasPromociones();", delay * 1000);
   }
}
/*Si esta activo el motor de promociones carga las variables del cliente*/
function _PromocionCte() {
   if (intSucOfertas && bolCargaPromociones) {
      _CargaVarsCte();
   }
}
/*Si esta activo el motor de promociones carga las variables del producto*/
function _PromocionProd(objItem) {
   if (intSucOfertas && bolCargaPromociones) {
      //Obtenemos los valores del elemento
      var objRowItem = new _ClassRowItem();
      objRowItem.FACD_CVE = objItem.pr_codigo;
      objRowItem.FACD_PR_ID = objItem.pr_id;
      objRowItem.FACD_PR_CAT1 = objItem.pr_cat1;
      objRowItem.FACD_PR_CAT2 = objItem.pr_cat2;
      objRowItem.FACD_PR_CAT3 = objItem.pr_cat3;
      objRowItem.FACD_PR_CAT4 = objItem.pr_cat4;
      objRowItem.FACD_PR_CAT5 = objItem.pr_cat5;
      objRowItem.FACD_PR_CAT6 = objItem.pr_cat6;
      objRowItem.FACD_PR_CAT7 = objItem.pr_cat7;
      objRowItem.FACD_PR_CAT8 = objItem.pr_cat8;
      objRowItem.FACD_PR_CAT9 = objItem.pr_cat9;
      objRowItem.FACD_PR_CAT10 = objItem.pr_cat10;
      _CargaVarsProd(objRowItem);
      setSum();
   } else {
      setSum();
   }
}
/*Si esta activo el motor de promociones carga las variables de los totales*/
function _PromocionTot(bolPromosExec) {
   if (bolPromosExec) {
      //Validamos si procede
      if (intSucOfertas && bolCargaPromociones) {
         if (lstItems.length > 0) {
            //Cargamos las variables de los totales
            _CargaVarsTot("_PromocionFormulas();");
         } else {
            //Resetamos las variables de producto
            _ResetVarsProd();
         }

      }
   }

}
/*Si esta activo el motor de promociones calcula la formula*/
function _PromocionFormulas() {
   if (intSucOfertas && bolCargaPromociones) {
      _CargaCalculaFormulas(2);
   }
}
/**Imprime el log para debuguear el programa de facturacion*/
function _LogVentas1(strMsg) {
   if (navigator.userAgent.indexOf("Firefox")) {
      console.log(strMsg)
   } else {
      alert(strMsg);
   }
}
/**Limpia la aplicacion de ofertas*/
function _ResetPromosAll() {
   if (intSucOfertas && bolCargaPromociones) {
      _ResetVarsAll();
   }
}
//Libreria para importar librerias de javascript
function importa(src) {
   var scriptElem = document.createElement('script');
   scriptElem.setAttribute('src', src);
   scriptElem.setAttribute('type', 'text/javascript');
   document.getElementsByTagName('head')[0].appendChild(scriptElem);
}
/**Representa un item de producto para el motro*/
function _ClassRowItem() {
   this.FACD_CVE;
   this.FACD_PR_ID;
   this.FACD_PR_CAT1;
   this.FACD_PR_CAT2;
   this.FACD_PR_CAT3;
   this.FACD_PR_CAT4;
   this.FACD_PR_CAT5;
   this.FACD_PR_CAT6;
   this.FACD_PR_CAT7;
   this.FACD_PR_CAT8;
   this.FACD_PR_CAT9;
   this.FACD_PR_CAT10;
}
/**Aplica descuento global*/
function _iAplicaDescGlobal(intIdOferta, dblDesc, intApPrec, intApPto, intApVn, intAPLeal) {
   dblDesc = parseFloat(dblDesc);
   intApPrec = parseInt(intApPrec);
   intApPto = parseInt(intApPto);
   intApVn = parseInt(intApVn);
   intAPLeal = parseInt(intAPLeal);
   //Aplica descuento global
   for (var j = 0; j <= intContaItems; j++) {
      var objItem = lstItems[j];
      //Si tiene el porcentaje de descuento lo volvemos aplicar
      //if(parseInt(lstRow.FACD_ID_PROMO) == 0){
      //Evaluamos si el porcentaje es el mayor
      if (dblDesc >= parseFloat(objItem.pr_porcdesc)) {
         if (parseInt(objItem.pr_id_promo) == 0)
            objItem.pr_desc_ori = objItem.pr_porcdesc;
         objItem.pr_porcdesc = dblDesc;
         objItem.pr_id_promo = intIdOferta;
         if (objItem.pr_desc_prec == 1)
            objItem.pr_desc_prec = intApPrec;
         if (objItem.pr_desc_pto == 1)
            objItem.pr_desc_pto = intApPto;
         if (objItem.pr_desc_nego == 1)
            objItem.pr_desc_nego = intApVn;
         objItem.pr_lealtad = intAPLeal;
         //Recalculamos el importe
         lstRowChangePrecio(objItem, false);
      }
      //}
   }
}

/**Vuelva a calcular el precio para una fila del grid*/
function lstRowChangePrecio(objItem, bolSum) {
   var objImportes = new _ImporteVta();

   var objImportes = new _ImporteVta();
   objImportes.dblCantidad = parseFloat(objItem.pr_cantidad);
   objImportes.dblPrecio = parseFloat(objItem.pr_precio);
   objImportes.dblPrecioReal = parseFloat(objItem.pr_precreal);
   objImportes.dblPuntos = parseFloat(objItem.pr_puntos_u);
   objImportes.dblVNegocio = parseFloat(objItem.pr_vnegocio_u);
   objImportes.dblPorcDescGlobal = 0;
   objImportes.dblPorcDesc = objItem.pr_porcdesc;
   objImportes.dblPrecFijo = 0;
   objImportes.dblExento1 = objItem.pr_exento1;
   objImportes.dblExento2 = objItem.pr_exento2;
   objImportes.dblExento3 = objItem.pr_exento3;
   objImportes.intDevo = 0;
   objImportes.intPrecioZeros = 0;
   if (objItem.pr_desc_prec == 0)
      objImportes.bolAplicDescPrec = false;
   if (objItem.pr_desc_pto == 0)
      objImportes.bolAplicDescPto = false;
   if (objItem.pr_desc_nego == 0)
      objImportes.bolAplicDescVNego = false;
   objImportes.CalculaImporte();
   //Asignamos nuevos importes
   objItem.pr_importe = objImportes.dblImporte;
   objItem.pr_impuesto1 = objImportes.dblImpuesto1;
   objItem.pr_descuento = objImportes.dblImporteDescuento;
   objItem.pr_importereal = objImportes.dblImporteReal;
   objItem.pr_impuestoreal = objImportes.dblImpuestoReal1;
   objItem.pr_puntos_tot = objImportes.dblPuntosImporte;
   objItem.pr_vnegocio_tot = objImportes.dblVNegocioImporte;
   if (objItem.pr_negocioZero == 1)
      objItem.pr_vnegocio_tot = 0;
   //Sumamos todos los items
   if (bolSum == null)
      bolSum = true;
   if (bolSum)
      setSum();
}

/**
 * Funcion solo para el ecommerce
 *Aplica un porcentaje descuento a los productos que tienen cierta clasificacion
 *en las que ya halla aplicado una promocion o
 *cuyo descuento original sea superior al de la promocion
 *@intIdOferta Es el id de la oferta que esta aplicando
 *@dblDesc Porcentaje de descuento
 *@intApPrec Con 1 aplica descuento en precios
 *@intApPto Con 1 aplica descuento en puntos
 *@intApVn Con 1 aplica descuento en valor negocio
 *@intAPLeal Con 1 aplica descuento en puntos de lealtad
 *@intIdClas Es el numero de clasificacion por validar(1,2..n)
 *@intValClas Es el valor de la clasificacion que debe tener el producto
 **/
function _iAplicaDescClasific(intIdOferta, dblDesc, intApPrec, intApPto, intApVn, intAPLeal, intIdClas, intValClas) {
   if (_debugPromos)
      _LogPromos("Descuento clasificacion ecomm: " + intIdOferta + " " + dblDesc + " " + intApPrec + " " + intApPto + " " + intApVn + " " + intIdClas + " " + intValClas);
   //Recorremos todos los items
   dblDesc = parseFloat(dblDesc);
   intApPrec = parseInt(intApPrec);
   intApPto = parseInt(intApPto);
   intApVn = parseInt(intApVn);
   intAPLeal = parseInt(intAPLeal);
   //Aplica descuento global
   for (var j = 0; j <= intContaItems; j++) {
      var objItem = lstItems[j];

      //Identificamos el valor de la clasificacion por evaluar
      var intValueClas = objItem.pr_cat1;
      if (intIdClas == 2)
         intValueClas = objItem.pr_cat2;
      if (intIdClas == 3)
         intValueClas = objItem.pr_cat3;
      if (intIdClas == 4)
         intValueClas = objItem.pr_cat4;
      if (intIdClas == 5)
         intValueClas = objItem.pr_cat5;
      if (intIdClas == 6)
         intValueClas = objItem.pr_cat6;
      if (intIdClas == 7)
         intValueClas = objItem.pr_cat7;
      if (intIdClas == 8)
         intValueClas = objItem.pr_cat8;
      if (intIdClas == 9)
         intValueClas = objItem.pr_cat9;
      if (intIdClas == 10)
         intValueClas = objItem.pr_cat10;
      //Evaluamos que la clasificacion corresponda con la promocion
      if (parseInt(intValueClas) == parseInt(intValClas)) {
         //Si tiene el porcentaje de descuento lo volvemos aplicar
         //if(parseInt(lstRow.FACD_ID_PROMO) == 0){
         //Evaluamos si el porcentaje es el mayor
         if (dblDesc >= parseFloat(objItem.pr_porcdesc)) {
            if (parseInt(objItem.pr_id_promo) == 0)
               //Evaluamos si el item tiene la misma clasificacion

               objItem.pr_desc_ori = objItem.pr_porcdesc;
            objItem.pr_porcdesc = dblDesc;
            objItem.pr_id_promo = intIdOferta;
            if (objItem.pr_desc_prec == 1)
               objItem.pr_desc_prec = intApPrec;
            if (objItem.pr_desc_pto == 1)
               objItem.pr_desc_pto = intApPto;
            if (objItem.pr_desc_nego == 1)
               objItem.pr_desc_nego = intApVn;
            objItem.pr_lealtad = intAPLeal;
            //Recalculamos el importe
            lstRowChangePrecio(objItem, false);
         }
         //}
      }


   }
}

/**
 *Aplica un porcentaje descuento a los codigos del listado, excepto
 *en las que ya halla aplicado una promocion o
 *cuyo descuento original sea superior al de la promocion
 *@intIdOferta Es el id de la oferta que esta aplicando
 *@dblDesc Porcentaje de descuento
 *@intApPrec Con 1 aplica descuento en precios
 *@intApPto Con 1 aplica descuento en puntos
 *@intApVn Con 1 aplica descuento en valor negocio
 *@intAPLeal Con 1 aplica descuento en puntos de lealtad
 *@strLstCod Es el listado de codigos en donde aplicara el descuento
 *@intNegocioZero Con 1 indica que no se pondra valor negocio
 **/
function _iAplicaDescListado(intIdOferta, dblDesc, intApPrec, intApPto, intApVn, intAPLeal, strLstCod, intNegocioZero) {
   if (_debugPromos)
      _LogPromos("Descuento listado ecomm: " + dblDesc + " " + intApPrec + " " + intApPto + " " + intApVn + " " + strLstCod);
   //Recorremos todos los items
   dblDesc = parseFloat(dblDesc);
   intApPrec = parseInt(intApPrec);
   intApPto = parseInt(intApPto);
   intApVn = parseInt(intApVn);
   intAPLeal = parseInt(intAPLeal);
   var _lstCodDescProd = strLstCod.split(",");
   for (var j = 0; j <= intContaItems; j++) {
      var objItem = lstItems[j];
      for (var _iCod2 = 0; _iCod2 < _lstCodDescProd.length; _iCod2++) {
         //Evaluamos que sea un codigo del listado
         if (trim(_lstCodDescProd[_iCod2]) == trim(objItem.pr_codigo)) {
            //Si tiene el porcentaje de descuento lo volvemos aplicar
            //if(parseInt(lstRow.FACD_ID_PROMO) == 0){
            //Evaluamos si el porcentaje es el mayor
            if (dblDesc > parseFloat(objItem.pr_porcdesc)) {
               //if (parseInt(objItem.pr_id_promo) == 0)
               objItem.pr_desc_ori = objItem.pr_porcdesc;
               objItem.pr_porcdesc = dblDesc;
               objItem.pr_id_promo = intIdOferta;
               if (objItem.pr_desc_prec == 1)
                  objItem.pr_desc_prec = intApPrec;
               if (objItem.pr_desc_pto == 1)
                  objItem.pr_desc_pto = intApPto;
               if (objItem.pr_desc_nego == 1)
                  objItem.pr_desc_nego = intApVn;
               objItem.pr_lealtad = intAPLeal;
               if (intNegocioZero == 1)
                  objItem.pr_negocioZero = 1;
               //Recalculamos el importe
               lstRowChangePrecio(objItem, false);
            }
            //}
         }
      }
   }
}

/**Manda abrir un reporte*/
function openFormatEcomm(strNomForm, strTipo, strHtmlControl, strMaskFolio) {
   var strHtml = "<form action=\"../Formatos\" method=\"post\" target=\"_blank\" id=\"formSend\">";
   var strTipo = "hidden";
   var name = "NomForm";
   var value = strNomForm;
   strHtml += "<input type=\"" + strTipo + "\" name=\"" + name + "\" id=\"" + name + "\" value=\"" + value + "\" />";
   if (strMaskFolio != undefined) {
      strHtml += CreaHidden("MASK_FOLIO", strMaskFolio);
   }
   var strTipo = "hidden";
   var name = "report";
   strHtml += "<input type=\"" + strTipo + "\" name=\"" + name + "\" id=\"" + name + "\" value=\"PDF\" />";
   strHtml += strHtmlControl;
   strHtml += "</form>";
   document.getElementById("formHidden").innerHTML = strHtml;
   document.getElementById("formSend").submit();
}