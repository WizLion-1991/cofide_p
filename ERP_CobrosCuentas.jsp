<%-- 
    Document   : ERP_CobrosCuentas
    Created on : 17/07/2012, 08:25:15 AM
    Author     : 
--%>

<%@page import="java.net.URLDecoder"%>
<%@page import="ERP.Monedas" %>%>
<%@page import="ERP.PagosMasivosCtas"%>
<%@page import="Tablas.vta_mov_prov_deta"%>
<%@page import="ERP.MovProveedor"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
<%@page import="Tablas.vta_mov_cte_deta" %>
<%@page import="ERP.movCliente" %>
<%@page import="ERP.PagosMasivos"%>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      //Inicializamos datos
      Fechas fecha = new Fechas();

      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Genera una nueva operacion de pagos en base a la transaccion que nos envian
         if (strid.equals("1")) {
            //Recuperamos el valor si es Anticipo
            int intEsAnticipo = 0;
            if (request.getParameter("intAnticipo") != null) {
               intEsAnticipo = Integer.valueOf(request.getParameter("intAnticipo"));
            }
            //Recuperamos el id de la transaccion
            int intIdTrx = 0;
            if (request.getParameter("idTrx") != null) {
               intIdTrx = Integer.valueOf(request.getParameter("idTrx"));
            }

            //Recuperamos el tipo de transaccion
            int intTipoDoc = 0;
            if (request.getParameter("TipoDoc") != null) {
               intTipoDoc = Integer.valueOf(request.getParameter("TipoDoc"));
            }

            //Recuperamos el numero de banco
            int intBc_Id = 0;
            if (request.getParameter("BC_ID") != null) {
               intBc_Id = Integer.valueOf(request.getParameter("BC_ID"));
            }
            //Recuperamos la moneda del pago
            int intMONEDAAPAGAR = 0;
            if (request.getParameter("MONEDAAPAGAR") != null) {
               intMONEDAAPAGAR = Integer.valueOf(request.getParameter("MONEDAAPAGAR"));
            } else {
               intMONEDAAPAGAR = Integer.valueOf(request.getParameter("MONEDA"));
               if (intMONEDAAPAGAR == 0) {
                  //Es posible que sea un ajuste

                  intMONEDAAPAGAR = Integer.valueOf(request.getParameter("MONENDAORIGINAL"));
               }
            }
            //Recuperamos el monto del pago
            double dblMontoPago = 0;
            if (request.getParameter("MONTOPAGO") != null) {
               dblMontoPago = Double.valueOf(request.getParameter("MONTOPAGO"));
            }
            //Recuperamos el monto del pago
            double dblAnticipoUsado = 0;
            if (request.getParameter("ANTICIPOAUSAR") != null) {
               dblAnticipoUsado = Double.valueOf(request.getParameter("ANTICIPOAUSAR"));
            }

            int intUsaAnticipo = 0;
            if (request.getParameter("USA_ANTI") != null) {
               intUsaAnticipo = Integer.valueOf(request.getParameter("USA_ANTI"));
            }

            int intIDAnticipo = 0;
            if (request.getParameter("ANTI_ID") != null) {
               intIDAnticipo = Integer.valueOf(request.getParameter("ANTI_ID"));
            }

            String strNoCheque = "";
            if (request.getParameter("MCB_NOCHEQUE") != null) {
               strNoCheque = request.getParameter("MCB_NOCHEQUE");
            }

            String strBancoTrans = "";
            if (request.getParameter("MPD_BCO_TRANS") != null) {
               strBancoTrans = request.getParameter("MPD_BCO_TRANS");
            }
            String strCtaTrans = "";
            if (request.getParameter("MPD_CTA_TRANS") != null) {
               strBancoTrans = request.getParameter("MPD_CTA_TRANS");
            }

            String strRFCterceros = "";
            if (request.getParameter("MPD_RFC_TERCEROS") != null) {
               strRFCterceros = request.getParameter("MPD_RFC_TERCEROS");
            }

            //Recuperamos el monto del pago
            double dblTCAnticipoUsado = 1.0;
            if (request.getParameter("TCANTIUSAR") != null) {
               dblTCAnticipoUsado = Double.valueOf(request.getParameter("TCANTIUSAR"));
            }

            //Recuperamos el monto del pago
            double dblComision = 0.0;
            if (request.getParameter("COMISION") != null) {
               dblComision = Double.valueOf(request.getParameter("COMISION"));
            }

            int intEsReembolso = 0;
            //Recuperamos si es reembolso
            if (request.getParameter("EsReembolso") != null) {
               try {
                  intEsReembolso = Integer.valueOf(request.getParameter("EsReembolso"));
               } catch (NumberFormatException ex) {
               }
            }

            //Tasa de Cambio Original del anticipo
            double dblTC_OriginalAnticipo = 1.0;
            if (request.getParameter("TC_ORI_ANTI") != null) {
               dblTC_OriginalAnticipo = Double.valueOf(request.getParameter("TC_ORI_ANTI"));
            }
            //Instanciamos el objeto que nos trae las listas de preciosvta
            MovProveedor movProv = new MovProveedor(oConn, varSesiones, request);
            //Inicializamos objeto

            movProv.Init();
            movProv.setDblComision(dblComision);

            if (intBc_Id != 0) {
               movProv.setIntBc_Id(intBc_Id);
            } else {
               movProv.setBolCaja(true);
            }

            movProv.setStrNoCheque(strNoCheque);
            //Checamos si es Anticipo
            if (intEsAnticipo != 0) {
               movProv.setBolEsAnticipo(true);
               movProv.getCta_prov().setFieldInt("PV_ID", Integer.valueOf(request.getParameter("IdProv")));
               movProv.getCta_prov().setFieldInt("MP_ANTICIPO", 1);
               movProv.getCta_prov().setFieldInt("MP_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
               movProv.getCta_prov().setFieldDouble("MP_TASAPESO", Double.valueOf(request.getParameter("TASAPROV")));
            } else {
               movProv.getCta_prov().setFieldInt("MP_MONEDA", intMONEDAAPAGAR);
               movProv.getCta_prov().setFieldDouble("MP_TASAPESO", Double.valueOf(request.getParameter("TASAPESO")));
            }

            //Recibimos datos Para saber si es reembolso
            movProv.getCta_prov().setFieldInt("MP_ES_REEMBOLSO", intEsReembolso);

            //Recibimos datos para el encabezado
            movProv.getCta_prov().setFieldString("MP_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));

            final String strNotas = URLDecoder.decode(new String(request.getParameter("NOTAS").getBytes(
                    "iso-8859-1")), "UTF-8");
            movProv.getCta_prov().setFieldString("MP_NOTAS", strNotas);
            movProv.getCta_prov().setFieldInt("CXP_ID", intIdTrx);
            movProv.getCta_prov().setFieldInt("MP_ESPAGO", 1);
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               movProv.getCta_prov().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
            }
            //Asignamos la sucursal de operacion
            if (varSesiones.getIntSucursalDefault() != 0) {
               movProv.getCta_prov().setFieldInt("SC_ID", varSesiones.getIntSucursalDefault());
            }
            movProv.getCta_prov().setFieldDouble("MP_ABONO", dblMontoPago);
            movProv.getCta_prov().setFieldInt("MP_USA_ANTICIPO", intUsaAnticipo);
            movProv.setDblTasaCambioAnticipoUsar(dblTC_OriginalAnticipo);

            if (intUsaAnticipo == 1) {

               movProv.getCta_prov().setFieldInt("MP_ANTI_ID", intIDAnticipo);
            }
            movProv.setDblSaldoFavorUsado(dblAnticipoUsado);

            //Recibimos los pagos
            int intCountPagos = Integer.valueOf(request.getParameter("COUNT_PAGOS"));
            for (int i = 1; i <= intCountPagos; i++) {
               if (Double.valueOf(request.getParameter("MPD_IMPORTE" + i)) > 0) {
                  vta_mov_prov_deta detaPago = new vta_mov_prov_deta();
                  detaPago.setFieldInt("PV_ID", 0);
                  detaPago.setFieldInt("SC_ID", 0);
                  detaPago.setFieldInt("MPD_MONEDA", Integer.valueOf(request.getParameter("MPD_MONEDA" + i)));
                  detaPago.setFieldString("MPD_FOLIO", request.getParameter("MPD_FOLIO" + i));
                  detaPago.setFieldString("MPD_FORMAPAGO", request.getParameter("MPD_FORMAPAGO" + i));
                  detaPago.setFieldString("MPD_NOCHEQUE", request.getParameter("MPD_NOCHEQUE" + i));
                  detaPago.setFieldString("MPD_BANCO", request.getParameter("MPD_BANCO" + i));
                  detaPago.setFieldString("MPD_NOTARJETA", request.getParameter("MPD_NOTARJETA" + i));
                  detaPago.setFieldString("MPD_TIPOTARJETA", request.getParameter("MPD_TIPOTARJETA" + i));
                  detaPago.setFieldDouble("MPD_IMPORTE", Double.valueOf(request.getParameter("MPD_IMPORTE" + i)));
                  detaPago.setFieldDouble("MPD_TASAPESO", Double.valueOf(request.getParameter("MPD_TASAPESO" + i)));
                  detaPago.setFieldDouble("MPD_CAMBIO", Double.valueOf(request.getParameter("MPD_CAMBIO" + i)));

                  detaPago.setFieldString("MPD_BANCO_DEST", request.getParameter("COB_BCO_TRANS"));
                  detaPago.setFieldString("MPD_CUENTA_DEST", request.getParameter("COB_CTA_TRANS"));
                  detaPago.setFieldString("MPD_RFC_TERCEROS", strRFCterceros);

                  movProv.AddDetalle(detaPago);
               }
            }

            //Generamos transaccion
            //String strRes = "";
            movProv.doTrx();
            String strRes = "";
            if (movProv.getStrResultLast().equals("OK")) {
               strRes = "OK." + movProv.getCta_prov().getValorKey();
            } else {
               strRes = movProv.getStrResultLast();
            }

            if (strRes.contains("OK.")) {

               movProv = new MovProveedor(oConn, varSesiones, request);
               movProv.Init();
               if (intBc_Id != 0) {
                  movProv.setIntBc_Id(intBc_Id);
               } else {
                  movProv.setBolCaja(true);
               }
               //Recuperamos el monto del pago
               dblMontoPago = 0;
               if (request.getParameter("PROV_ANTICIPO") != null) {
                  dblMontoPago = Double.valueOf(request.getParameter("PROV_ANTICIPO"));
               }
               movProv.setBolEsAnticipo(true);
               if (dblMontoPago > 0) {
                  movProv.setStrNoCheque("");
                  movProv.getCta_prov().setFieldInt("PV_ID", Integer.valueOf(request.getParameter("PROV_ID")));
                  movProv.getCta_prov().setFieldInt("MP_ANTICIPO", 1);
                  //movProv.getCta_prov().setFieldInt("MP_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
                  if (intEsAnticipo != 0) {
                     movProv.getCta_prov().setFieldInt("MP_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
                  } else {
                     movProv.getCta_prov().setFieldInt("MP_MONEDA", intMONEDAAPAGAR);
                  }
                  movProv.getCta_prov().setFieldDouble("MP_TASAPESO", Double.valueOf(request.getParameter("TASA_ANTI")));

                  movProv.getCta_prov().setFieldString("MP_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));
                  movProv.getCta_prov().setFieldString("MP_NOTAS", " ");
                  movProv.getCta_prov().setFieldInt("CXP_ID", 0);
                  movProv.getCta_prov().setFieldInt("MP_ESPAGO", 1);
                  movProv.getCta_prov().setFieldDouble("MP_ABONO", dblMontoPago);

                  movProv.doTrx();
                  if (movProv.getStrResultLast().equals("OK")) {
                     //strRes = "OK." + movProv.getCta_prov().getValorKey();
                  } else {
                     //strRes = movProv.getStrResultLast();
                  }
               }
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.print(strRes);//Pintamos el resultado
         }
         //Anula la operacion de pago o nota de cargo
         if (strid.equals("2")) {
            int intMP_ID = 0;
            //Recibimos el id del pago por cancelar
            if (request.getParameter("MP_ID") != null) {
               try {
                  intMP_ID = Integer.valueOf(request.getParameter("MP_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            MovProveedor movProv = new MovProveedor(oConn, varSesiones, request);
            movProv.getCta_prov().setFieldInt("MP_ID", intMP_ID);
            //Inicializamos objeto
            movProv.Init();
            movProv.doTrxAnul();
            String strRes = "";
            if (movProv.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = movProv.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }

         //Realiza un pago masivo
         if (strid.equals("3")) {
            //Recuperamos la moneda del pago
            int intMONEDAAPAGAR = 0;
            if (request.getParameter("MONEDAAPAGAR") != null) {
               intMONEDAAPAGAR = Integer.valueOf(request.getParameter("MONEDAAPAGAR"));
            } else {
               intMONEDAAPAGAR = Integer.valueOf(request.getParameter("MONEDA"));
            }
            double dblMontoPagoTot = 0;
            if (request.getParameter("MONTOPAGOTOTAL") != null) {
               dblMontoPagoTot = Double.valueOf(request.getParameter("MONTOPAGOTOTAL"));
            }
            //Recuperamos el numero de banco
            int intBc_Id = 0;
            if (request.getParameter("BC_ID") != null) {
               intBc_Id = Integer.valueOf(request.getParameter("BC_ID"));
            }
            //Recuperamos el monto del pago
            double dblAnticipoUsado = 0;
            if (request.getParameter("ANTICIPOAUSAR") != null) {
               dblAnticipoUsado = Double.valueOf(request.getParameter("ANTICIPOAUSAR"));
            }
            //Instanciamos objeto de pagos masivos
            int intUsaAnticipo = 0;
            if (request.getParameter("USA_ANTI") != null) {
               intUsaAnticipo = Integer.valueOf(request.getParameter("USA_ANTI"));
            }

            int intIDAnticipo = 0;
            if (request.getParameter("ANTI_ID") != null) {
               intIDAnticipo = Integer.valueOf(request.getParameter("ANTI_ID"));
            }

            String strNoCheque = "";
            if (request.getParameter("MCB_NOCHEQUE") != null) {
               strNoCheque = request.getParameter("MCB_NOCHEQUE");
            }

            String strBancoTrans = "";
            if (request.getParameter("COB_BCO_TRANS") != null) {
               strBancoTrans = request.getParameter("COB_BCO_TRANS");
            }
            String strCtaTrans = "";
            if (request.getParameter("COB_CTA_TRANS") != null) {
               strCtaTrans = request.getParameter("COB_CTA_TRANS");
            }

            int intEsReembolso = 0;
            //Recuperamos si es reembolso
            if (request.getParameter("EsReembolso") != null) {
               try {
                  intEsReembolso = Integer.valueOf(request.getParameter("EsReembolso"));
               } catch (NumberFormatException ex) {
               }
            }

            String strRFCterceros = "";
            if (request.getParameter("MPD_RFC_TERCEROS") != null) {
               strRFCterceros = request.getParameter("MPD_RFC_TERCEROS");
            }

            double dblTCAnticipoUsado = 1.0;
            if (request.getParameter("TCANTIUSAR") != null) {
               dblTCAnticipoUsado = Double.valueOf(request.getParameter("TCANTIUSAR"));
            }
            double dblComision = 0.0;
            if (request.getParameter("COMISION") != null) {
               dblComision = Double.valueOf(request.getParameter("COMISION"));
            }

            String strConcepto = "";
            if (request.getParameter("MCB_CONCEPTO") != null) {
               strConcepto = request.getParameter("MCB_CONCEPTO");
            }

            String strRFCBeneficiario = "";
            if (request.getParameter("MCB_RFCBENEFICIARIO") != null) {
               strRFCBeneficiario = request.getParameter("MCB_RFCBENEFICIARIO");
            }

            PagosMasivosCtas masivo = new PagosMasivosCtas(oConn, varSesiones, request);
            //Inicializamos objeto
            masivo.Init();
            masivo.setDblComision(dblComision);
            masivo.getMasivo().setFieldString("MPM_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));
            masivo.setIntMoneda(Integer.parseInt(request.getParameter("MONEDA")));
            masivo.setDblParidad(Double.parseDouble(request.getParameter("TASAPESO")));
            masivo.setDblMontoPagado(Double.parseDouble(request.getParameter("MONTOPAGOTOTALAMONEDA")));
            masivo.setDblSaldoFavorUsado(dblAnticipoUsado);
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            }
            if (varSesiones.getIntSucursalDefault() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntSC_ID(varSesiones.getIntSucursalDefault());
            }
            //double dblTasaCambio = Double.parseDouble(request.getParameter("TASAPESO"));
            masivo.setStrNoCheque(strNoCheque);
            masivo.setStrConcepto(strConcepto);
            masivo.setStrRFCBeneficiario(strRFCBeneficiario);

            //Recuperamos los pagos que se van a guardar
            String[] lstTrx = request.getParameterValues("idTrx");
            String[] lstTipoDoc = request.getParameterValues("TipoDoc");
            String[] lstMontoPay = request.getParameterValues("MONTOPAGO");
            String[] lstMontoPagoAMoneda = request.getParameterValues("MONTOPAGOAMONEDA");
            String[] lstMONEDAS = request.getParameterValues("MONENDAORIGINAL");
            for (int i = 0; i < lstTrx.length; i++) {
               //Recuperamos el id de la transaccion
               int intIdTrx = Integer.valueOf(lstTrx[i]);
               //Recuperamos el tipo de transaccion
               int intTipoDoc = Integer.valueOf(lstTipoDoc[i]);
               //Recuperamos el monto del pago
               double dblMontoPago = Double.valueOf(lstMontoPay[i]);
               //Recuperamos el monto del pago ya con la tasa de cambio
               double dblMontoPagoAMoneda = Double.valueOf(lstMontoPagoAMoneda[i]);
               //Instanciamos el objeto que nos trae las listas de precios
               MovProveedor movProv = new MovProveedor(oConn, varSesiones, request);

               movProv.setStrNoCheque(strNoCheque);

               //Inicializamos objeto
               movProv.Init();
               if (intBc_Id != 0) {
                  movProv.setIntBc_Id(intBc_Id);
               } else {
                  movProv.setBolCaja(true);
               }
               //Evaluamos si llego la moneda, en anticipo llega en cero
               if (intMONEDAAPAGAR == 0) {
                  //Es posible que sea un ajuste
                  intMONEDAAPAGAR = Integer.valueOf(lstMONEDAS[i]);
               }
               //Recibimos datos para el encabezado

               movProv.getCta_prov().setFieldString("MP_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));

               final String strNotas2 = URLDecoder.decode(new String(request.getParameter("NOTAS").getBytes(
                       "iso-8859-1")), "UTF-8");
               movProv.getCta_prov().setFieldString("MP_NOTAS", strNotas2);

               movProv.getCta_prov().setFieldInt("MP_MONEDA", intMONEDAAPAGAR);
               movProv.getCta_prov().setFieldDouble("MP_TASAPESO", Double.valueOf(request.getParameter("TASAPESO")));
               movProv.getCta_prov().setFieldInt("CXP_ID", intIdTrx);
               movProv.getCta_prov().setFieldInt("MP_ESPAGO", 1);
               movProv.getCta_prov().setFieldDouble("MP_ABONO", dblMontoPago);
               movProv.getCta_prov().setFieldInt("MP_USA_ANTICIPO", intUsaAnticipo);

               //Recibimos datos Para saber si es reembolso
               movProv.getCta_prov().setFieldInt("MP_ES_REEMBOLSO", intEsReembolso);

               movProv.setDblTasaCambioAnticipoUsar(dblTCAnticipoUsado);
               //Validamos si tenemos un empresa seleccionada
               if (varSesiones.getIntIdEmpresa() != 0) {
                  //Asignamos la empresa seleccionada
                  movProv.getCta_prov().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
               }
               //Asignamos la sucursal de operacion
               if (varSesiones.getIntSucursalDefault() != 0) {
                  movProv.getCta_prov().setFieldInt("SC_ID", varSesiones.getIntSucursalDefault());
               }
               if (intUsaAnticipo == 1) {
                  movProv.getCta_prov().setFieldInt("MP_ANTI_ID", intIDAnticipo);
                  masivo.setBolUsaAnticipo(true);
               }
               //Calculamos el factor de proporcion
               double dblFactor = (dblMontoPago / dblMontoPagoTot);
               //Recibimos los pagos
               int intCountPagos = Integer.valueOf(request.getParameter("COUNT_PAGOS"));
               for (int j = 1; j <= intCountPagos; j++) {
                  if (Double.valueOf(request.getParameter("MPD_IMPORTE" + j)) > 0) {
                     vta_mov_prov_deta detaPago = new vta_mov_prov_deta();
                     double dblImporte = Double.valueOf(request.getParameter("MPD_IMPORTE" + j));
                     double dblCambio = Double.valueOf(request.getParameter("MPD_CAMBIO" + j));
                     double dblImporteTrx = dblImporte * dblFactor;
                     double dblImporteCambio = dblCambio * dblFactor;
                     //Calculamos proporcion de la forma de pago
                     detaPago.setFieldInt("PV_ID", 0);
                     detaPago.setFieldInt("SC_ID", 0);
                     detaPago.setFieldInt("MPD_MONEDA", Integer.valueOf(request.getParameter("MPD_MONEDA" + j)));
                     detaPago.setFieldString("MPD_FOLIO", request.getParameter("MPD_FOLIO" + j));
                     detaPago.setFieldString("MPD_FORMAPAGO", request.getParameter("MPD_FORMAPAGO" + j));
                     detaPago.setFieldString("MPD_NOCHEQUE", request.getParameter("MPD_NOCHEQUE" + j));
                     detaPago.setFieldString("MPD_BANCO", request.getParameter("MPD_BANCO" + j));
                     detaPago.setFieldString("MPD_NOTARJETA", request.getParameter("MPD_NOTARJETA" + j));
                     detaPago.setFieldString("MPD_TIPOTARJETA", request.getParameter("MPD_TIPOTARJETA" + j));
                     detaPago.setFieldDouble("MPD_IMPORTE", dblImporteTrx);
                     detaPago.setFieldDouble("MPD_TASAPESO", Double.valueOf(request.getParameter("MPD_TASAPESO" + j)));
                     detaPago.setFieldDouble("MPD_CAMBIO", dblImporteCambio);
                     detaPago.setFieldString("MPD_BANCO_DEST", strBancoTrans);
                     detaPago.setFieldString("MPD_CUENTA_DEST", strCtaTrans);
                     detaPago.setFieldString("MPD_RFC_TERCEROS", strRFCterceros);
                     movProv.AddDetalle(detaPago);
                  }
               }
               //Anadimos el pago
               masivo.AddDetalle(movProv);
            }

            //Generamos transaccion
            masivo.doTrx();
            String strRes = "";
            if (masivo.getStrResultLast().equals("OK")) {
               strRes = "OK." + masivo.getMasivo().getValorKey();
            } else {
               strRes = masivo.getStrResultLast();
            }

            if (strRes.contains("OK.")) {
               MovProveedor movProv = new MovProveedor(oConn, varSesiones, request);
               movProv.Init();
               if (intBc_Id != 0) {
                  movProv.setIntBc_Id(intBc_Id);
               } else {
                  movProv.setBolCaja(true);
               }
               //Recuperamos el monto del pago
               double dblMontoPago = 0;
               if (request.getParameter("PROV_ANTICIPO") != null) {
                  dblMontoPago = Double.valueOf(request.getParameter("PROV_ANTICIPO"));
               }
               movProv.setBolEsAnticipo(true);
               if (dblMontoPago > 0) {
                  movProv.setStrNoCheque("");
                  movProv.getCta_prov().setFieldInt("PV_ID", Integer.valueOf(request.getParameter("PROV_ID")));
                  movProv.getCta_prov().setFieldInt("MP_ANTICIPO", 1);
                  movProv.getCta_prov().setFieldInt("MP_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
                  movProv.getCta_prov().setFieldDouble("MP_TASAPESO", Double.valueOf(request.getParameter("TASA_ANTI")));

                  movProv.getCta_prov().setFieldString("MP_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));
                  movProv.getCta_prov().setFieldString("MP_NOTAS", " ");
                  movProv.getCta_prov().setFieldInt("CXP_ID", 0);
                  movProv.getCta_prov().setFieldInt("MP_ESPAGO", 1);
                  movProv.getCta_prov().setFieldDouble("MP_ABONO", dblMontoPago);

                  movProv.doTrx();
                  if (movProv.getStrResultLast().equals("OK")) {
                     
                  } else {
                     //strRes = movProv.getStrResultLast();
                  }
               }
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.print(strRes);//Pintamos el resultado
         }

         //Cancela un pago masivo
         if (strid.equals("4")) {
            int intMPM_ID = 0;
            //Recibimos el id del pago por cancelar
            if (request.getParameter("MPM_ID") != null) {
               try {
                  intMPM_ID = Integer.valueOf(request.getParameter("MPM_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos objeto de pagos masivos
            PagosMasivosCtas masivo = new PagosMasivosCtas(oConn, varSesiones, request);
            masivo.getMasivo().setFieldInt("MPM_ID", intMPM_ID);
            //Inicializamos objeto
            masivo.Init();
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            }
            if (varSesiones.getIntSucursalDefault() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntSC_ID(varSesiones.getIntSucursalDefault());
            }
            masivo.doTrxAnul();
            String strRes = "";
            if (masivo.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = masivo.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //regreso los valores de la cuenta por pagar 
         if (strid.equals("5")) {
            UtilXml utilXML = new UtilXml();
            String strMoneda = request.getParameter("COB_MONEDA");
            //Recuperamos el id del cliente
            String intCXP_ID = request.getParameter("intCXP_ID");
            if (intCXP_ID == null) {
               intCXP_ID = "0";
            }

            int intGlobal = Integer.valueOf(request.getParameter("intGlobal"));
            String strSql = "";
            if (intGlobal == 0) {
               strSql = "select *  "
                       + "from vta_cxpagar where CXP_ID = " + intCXP_ID;

            } else {
               String intPV_ID = request.getParameter("PV_ID");
               if (intPV_ID == null) {
                  intPV_ID = "0";
               }

               String strfecha1 = request.getParameter("CXP_FECHA1");

               if (strfecha1 == null) {
                  strfecha1 = "0";
               } else {
                  strfecha1 = fecha.FormateaBD(strfecha1, "/");
               }
               String strfecha2 = fecha.FormateaBD(request.getParameter("CXP_FECHA2"), "/");
               if (strfecha2 == null) {
                  strfecha2 = "0";
               }

               strSql = "select * from vta_cxpagar where PV_ID = "
                       + intPV_ID + " AND CXP_FECHA>='" + strfecha1 + "' AND CXP_FECHA<='" + strfecha2 + "' AND CXP_ANULADO=0 AND  CXP_MONEDA='" + strMoneda + "' AND CXP_SALDO >= 1;";
            }

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_cuenta>";
            //Consultamos la info
            int intPV_ID = 0;
            int intCXP_ANULADO = 0;
            double dblCXP_TOTAL = 0;
            double dblCXP_SALDO = 0;
            String strCXP_FOLIO = "";
            int intCXP = 0;
            int intCXP_MONEDA = 0;
            String strCXP_FECHA = "";
            String strPV_RAZONSOCIAL = "";
            String strFac_id = "";

            //FECHA: 12/07/2013
            //NOMBRE: ABRAHAM GONZALEZ HERNANDEZ
            //DESCRIPCION: Agregamos el campo CXP_MONEDA a la informacion que se regresa
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intCXP = rs.getInt("CXP_ID");
               intPV_ID = rs.getInt("PV_ID");
               intCXP_ANULADO = rs.getInt("CXP_ANULADO");
               dblCXP_TOTAL = rs.getDouble("CXP_TOTAL");
               dblCXP_SALDO = rs.getDouble("CXP_SALDO");
               strCXP_FECHA = rs.getString("CXP_FECHA");
               strCXP_FOLIO = rs.getString("CXP_FOLIO");
               intCXP_MONEDA = rs.getInt("CXP_MONEDA");
               strPV_RAZONSOCIAL = utilXML.Sustituye(rs.getString("CXP_RAZONSOCIAL"));
               strFac_id = rs.getString("CXP_FOLIO");

               strXML += "<vta_cuentas "
                       + " intCXP = \"" + intCXP + "\"  "
                       + " intPV_ID = \"" + intPV_ID + "\"  "
                       + " intCXP_ANULADO = \"" + intCXP_ANULADO + "\"  "
                       + " dblCXP_TOTAL = \"" + dblCXP_TOTAL + "\"  "
                       + " dblCXP_SALDO = \"" + dblCXP_SALDO + "\"  "
                       + " strCXP_FECHA = \"" + strCXP_FECHA + "\"  "
                       + " intCXP_FOLIO = \"" + strCXP_FOLIO + "\"  "
                       + " intCXP_MONEDA = \"" + intCXP_MONEDA + "\"  "
                       + " strPV_RAZONSOCIAL = \"" + strPV_RAZONSOCIAL + "\"  "
                       + " intFac_id = \"" + strFac_id + "\"  "
                       + " />";


            }
            rs.close();
            //El detalle
            strXML += "</vta_cuenta>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //obtenemos la moneda de un banco
         if (strid.equals("7")) {
            String strMoneda = request.getParameter("BC_ID");
            String strSql = "Select * From vta_bcos Where BC_ID = " + strMoneda;
            int intMoneda = 0;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intMoneda = rs.getInt("BC_MONEDA");
            }
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.print(intMoneda);//Pintamos el resultado
         }
         //obtenemos El tipo de cambio
         if (strid.equals("9")) {
            String strMonedaBanco = request.getParameter("Moneda_1");
            String strMonedaSeleccionada = request.getParameter("Moneda_2");
            if (strMonedaSeleccionada == null) {
               strMonedaSeleccionada = "";
            }
            if (strMonedaSeleccionada.equals("undefined")) {
               strMonedaSeleccionada = "0";
            }
            String strFecha = request.getParameter("fecha");
            Fechas FECHAS = new Fechas();

            strMonedaBanco = strMonedaBanco.trim();
            if (strMonedaBanco.equals("0")) {
               strMonedaBanco = "1";
            }
            if (strMonedaSeleccionada.equals("0")) {
               strMonedaSeleccionada = "1";
            }
            strMonedaSeleccionada = strMonedaSeleccionada.trim();
            double dblTasaCambio = 0.0;
            Monedas MiTasaCambio = new Monedas(oConn);
            MiTasaCambio.setBoolConversionAutomatica(false);

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<TasaCambio>";
            strXML += "<TasaCambios";
            if (strMonedaBanco.equals(strMonedaSeleccionada)) {
               dblTasaCambio = 1;
               strXML += " TC= \"" + dblTasaCambio + "\"  ";
               strXML += " Operacion= \"M\" ";
            } else {
               dblTasaCambio = MiTasaCambio.GetFactorConversion(FECHAS.FormateaBD(strFecha, "/"), 4, Integer.parseInt(strMonedaBanco), Integer.parseInt(strMonedaSeleccionada));
               strXML += " TC= \"" + dblTasaCambio + "\"  ";
               if (MiTasaCambio.getIntMonedaBase() == Integer.parseInt(strMonedaBanco)) {
                  strXML += " Operacion= \"M\" ";
               } else {
                  strXML += " Operacion= \"D\" ";
               }
            }
            strXML += " />";
            strXML += "</TasaCambio>";

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

         //obtenemos El nombre del proveedor
         if (strid.equals("11")) {
            String strPV_ID = request.getParameter("PV_ID");
            String strNombre = "";

            String strSQL = "Select PV_RAZONSOCIAL,MON_ID,PV_ANTICIPOS_MON_ORIGEN From vta_proveedor Where PV_ID = " + strPV_ID;
            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
               strNombre = rs.getString("PV_RAZONSOCIAL");
               strNombre += "|" + rs.getInt("MON_ID");
               strNombre += "|" + rs.getInt("PV_ANTICIPOS_MON_ORIGEN");
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.print(strNombre);//Pintamos el resultado
         }

         //Obtenemos la cantidad total de Anticipos a ese Proveedor
         if (strid.equals("13")) {
            String strCTE = request.getParameter("PV_ID");
            String strMonedaBanco = request.getParameter("MONEDAPAGO");
            double dblAnticipoTotal = 0.0;
            String strSQL = "Select Sum(MP_ABONO) as Anticipo, MP_MONEDA From vta_mov_prov "
                    + "Where PV_ID =" + strCTE + " and MP_ABONO > 0 and MP_ANTICIPO = 1 group by MP_MONEDA";

            ResultSet rs = oConn.runQuery(strSQL, true);

            double dblTasaCambio = 1.0;
            Monedas MiTasaCambio = new Monedas(oConn);

            while (rs.next()) {
               if (rs.getInt("MP_MONEDA") != Integer.parseInt(strMonedaBanco)) {
                  dblTasaCambio = MiTasaCambio.GetFactorConversion(4, rs.getInt("MP_MONEDA"), Integer.parseInt(strMonedaBanco));
               } else {
                  dblTasaCambio = 1.0;
               }
               dblAnticipoTotal += rs.getDouble("Anticipo") * dblTasaCambio;

            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.print(dblAnticipoTotal);//Pintamos el resultado
         }

         if (strid.equals("14")) {
            String strPROV = request.getParameter("PV_ID");
            int intUsaMonedaOriginal = 0;
            String strSQL = "Select * From vta_mov_prov Where PV_ID = " + strPROV + " and MP_ANTICIPO = 1 and MP_ANULADO=0  AND MP_SALDO_ANTICIPO >=1";
            String strSQLProv = "Select * From vta_proveedor Where PV_ID = " + strPROV;//MON_ID
            ResultSet rsProv = oConn.runQuery(strSQLProv, true);
            int intMonProv = 1;
            while (rsProv.next()) {
               intMonProv = rsProv.getInt("MON_ID");
               intUsaMonedaOriginal = rsProv.getInt("PV_ANTICIPOS_MON_ORIGEN");
            }
            ResultSet rs = oConn.runQuery(strSQL, true);
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<Anticipos>";
            ERP.Monedas mnTasaCambios = new ERP.Monedas(oConn);
            double dblTasaCambio = 1.0;
            int intMP_ID = 0;
            String strMP_FECHA = "";
            double dblMP_SALDO_ANTICIPO = 0.0;
            String strMP_FOLIO = "";
            int intMP_MONEDA = 0;
            double dblMP_TASAPESO = 1.0;
            double dblMP_ANTICIPO_ORIGINAL = 0.0;

            while (rs.next()) {
               dblTasaCambio = 1.0;
               intMP_ID = rs.getInt("MP_ID");
               strMP_FECHA = rs.getString("MP_FECHA");
               dblMP_SALDO_ANTICIPO = rs.getDouble("MP_SALDO_ANTICIPO");
               strMP_FOLIO = rs.getString("MP_FOLIO");
               intMP_MONEDA = rs.getInt("MP_MONEDA");
               dblMP_TASAPESO = rs.getDouble("MP_TASAPESO");
               dblTasaCambio = dblMP_TASAPESO;
               dblMP_ANTICIPO_ORIGINAL = rs.getDouble("MP_ANTICIPO_ORIGINAL");

               if (intUsaMonedaOriginal == 1) {
                  if (intMP_MONEDA != intMonProv) {
                     if ((intMP_MONEDA == 1 && intMonProv == 2) || (intMP_MONEDA == 1 && intMonProv == 3) || (intMP_MONEDA == 1 && intMonProv == 4) || (intMP_MONEDA == 2 && intMonProv == 3) || (intMP_MONEDA == 4 && intMonProv == 3)) {
                        dblTasaCambio = 1 / dblTasaCambio;
                     } else {
                        dblTasaCambio = dblTasaCambio;
                     }
                  } else {
                     dblTasaCambio = 1.0;
                  }
               } else {
                  dblTasaCambio = 1.0;
               }

               strXML += "<Anticipo "
                       + " MP_ID = \"" + intMP_ID + "\"  "
                       + " MP_FECHA = \"" + strMP_FECHA + "\"  "
                       + " MP_SALDO_ANTICIPO = \"" + (dblMP_SALDO_ANTICIPO * dblTasaCambio) + "\"  "
                       + " MP_FOLIO = \"" + strMP_FOLIO + "\"  "
                       + " MP_MONEDA = \"" + intMP_MONEDA + "\"  "
                       + " MP_TASAPESO = \"" + (dblMP_TASAPESO) + "\"  "
                       + " dblMP_ANTICIPO_ORIGINAL = \"" + (dblMP_ANTICIPO_ORIGINAL * dblTasaCambio) + "\"  "
                       + " UsaMonedaOriginal = \"" + (intUsaMonedaOriginal) + "\"  "
                       + " />";
            }
            strXML += "</Anticipos>";

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

         if (strid.equals("15")) {
            int intPV_ID = 0;
            String strPROV_ID = request.getParameter("PROV_ID");
            String strSQL = "Select MON_ID from vta_proveedor Where PV_ID = " + strPROV_ID;

            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
               intPV_ID = rs.getInt("MON_ID");
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.print(intPV_ID);//Pintamos el resultado

         }
      }
   } else {
   }
   oConn.close();
%>