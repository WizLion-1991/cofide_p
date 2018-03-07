<%-- 
    Document   : ERP_Cobros
    Este jsp procesa todas las peticiones de cobranza como pagos y cancelacion de pagos
    Created on : 8/07/2010, 02:13:49 PM
    Author     : zeus
--%>
<%@page import="java.net.URLDecoder"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="Tablas.vta_mov_cta_bcos_deta"%>
<%@page import="ERP.Bancos"%>
<%@page import="ERP.Monedas"%>
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
            //Recuperamos si usa anticipo
            int intUsaAnticipo = 0;
            if (request.getParameter("USA_ANTI") != null) {
               intUsaAnticipo = Integer.valueOf(request.getParameter("USA_ANTI"));
            }
            System.out.println("USA_ANTI:" + intUsaAnticipo);
            //Recuperamos el ID del Anticipo
            int intIDAnticipo = 0;
            if (request.getParameter("ANTI_ID") != null) {
               intIDAnticipo = Integer.valueOf(request.getParameter("ANTI_ID"));
            }

            //Recuperamos el monto
            double dblAnticipoUsado = 0.0;
            if (request.getParameter("CANTIDAD_ANTI") != null) {
               dblAnticipoUsado = Float.valueOf(request.getParameter("CANTIDAD_ANTI"));
            }



            //Recuperamos el monto del pago
            double dblMontoPago = 0;
            if (request.getParameter("MONTOPAGO") != null) {
               dblMontoPago = Double.valueOf(request.getParameter("MONTOPAGO"));
               if (request.getParameter("MONTOPAGOTOTAL") != null) {
                  try {
                     if (Double.valueOf(request.getParameter("MONTOPAGO")) > 0) {
                        dblMontoPago = Double.valueOf(request.getParameter("MONTOPAGOTOTAL"));
                     }
                  } catch (NumberFormatException ex) {
                     System.out.println("error al obtener: MONTOPAGO " + ex.getLocalizedMessage());
                  }
               }
            }
            int intIdFact = 0;
            int intIdTicket = 0;
            if (intTipoDoc == 1) {
               //FACTURA
               intIdFact = intIdTrx;
            } else {
               //TICKET
               intIdTicket = intIdTrx;
            }
            //Instanciamos el objeto que nos trae las listas de precios
            movCliente movCte = new movCliente(oConn, varSesiones, request);
            //Inicializamos objeto
            movCte.Init();
            if (intBc_Id != 0) {
               movCte.setIntBc_Id(intBc_Id);
            } else {
               movCte.setBolCaja(true);
            }

            if (intEsAnticipo != 0) {
               movCte.setBolEsAnticipo(true);
               movCte.getCta_clie().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("IdCte")));
               movCte.getCta_clie().setFieldInt("MC_ANTICIPO", 1);

            }
            //Recibimos datos para el encabezado
            movCte.getCta_clie().setFieldString("MC_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));

            final String strNotas = URLDecoder.decode(new String(request.getParameter("NOTAS").getBytes(
                    "iso-8859-1")), "UTF-8");
            movCte.getCta_clie().setFieldString("MC_NOTAS", strNotas);
            movCte.getCta_clie().setFieldInt("MC_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
            movCte.getCta_clie().setFieldDouble("MC_TASAPESO", Double.valueOf(request.getParameter("TASAPESO")));
            movCte.getCta_clie().setFieldInt("FAC_ID", intIdFact);
            movCte.getCta_clie().setFieldInt("TKT_ID", intIdTicket);
            movCte.getCta_clie().setFieldInt("MC_ESPAGO", 1);
            movCte.getCta_clie().setFieldDouble("MC_ABONO", dblMontoPago);
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               movCte.getCta_clie().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
            }
            //Asignamos la sucursal de operacion
            if (varSesiones.getIntSucursalDefault() != 0) {
               movCte.getCta_clie().setFieldInt("SC_ID", varSesiones.getIntSucursalDefault());
            }
            if (intUsaAnticipo == 1) {
               movCte.getCta_clie().setFieldInt("MC_USA_ANTICIPO", 1);
               movCte.getCta_clie().setFieldInt("MC_ANTI_ID", intIDAnticipo);
            }
            movCte.setDblSaldoFavorUsado(dblAnticipoUsado);

            //Recibimos los pagos
            int intCountPagos = Integer.valueOf(request.getParameter("COUNT_PAGOS"));
            for (int i = 1; i <= intCountPagos; i++) {
               if (Double.valueOf(request.getParameter("MCD_IMPORTE" + i)) > 0) {
                  vta_mov_cte_deta detaPago = new vta_mov_cte_deta();
                  detaPago.setFieldInt("CT_ID", 0);
                  detaPago.setFieldInt("SC_ID", 0);
                  detaPago.setFieldInt("MCD_MONEDA", Integer.valueOf(request.getParameter("MCD_MONEDA" + i)));
                  detaPago.setFieldString("MCD_FOLIO", request.getParameter("MCD_FOLIO" + i));
                  detaPago.setFieldString("MCD_FORMAPAGO", request.getParameter("MCD_FORMAPAGO" + i));
                  detaPago.setFieldString("MCD_NOCHEQUE", request.getParameter("MCD_NOCHEQUE" + i));
                  detaPago.setFieldString("MCD_BANCO", request.getParameter("MCD_BANCO" + i));
                  detaPago.setFieldString("MCD_NOTARJETA", request.getParameter("MCD_NOTARJETA" + i));
                  detaPago.setFieldString("MCD_TIPOTARJETA", request.getParameter("MCD_TIPOTARJETA" + i));
                  detaPago.setFieldDouble("MCD_IMPORTE", Double.valueOf(request.getParameter("MCD_IMPORTE" + i)));
                  detaPago.setFieldDouble("MCD_TASAPESO", Double.valueOf(request.getParameter("MCD_TASAPESO" + i)));
                  detaPago.setFieldDouble("MCD_CAMBIO", Double.valueOf(request.getParameter("MCD_CAMBIO" + i)));
                  movCte.AddDetalle(detaPago);
               }
            }
            //Generamos transaccion

            String strRes = "";
            movCte.doTrx();
            if (movCte.getStrResultLast().equals("OK")) {
               strRes = "OK." + movCte.getCta_clie().getValorKey();
            } else {
               strRes = movCte.getStrResultLast();
            }

            if (strRes.contains("OK.")) {
               movCte = new movCliente(oConn, varSesiones, request);
               movCte.Init();
               if (intBc_Id != 0) {
                  movCte.setIntBc_Id(intBc_Id);
               } else {
                  movCte.setBolCaja(true);
               }
               //Recuperamos el monto del pago
               dblMontoPago = 0;
               if (request.getParameter("CTE_ANTICIPO") != null) {
                  dblMontoPago = Double.valueOf(request.getParameter("CTE_ANTICIPO"));
               }



               movCte.setBolEsAnticipo(true);
               if (dblMontoPago > 0) {
                  movCte.setBolEsAnticipo(true);
                  movCte.getCta_clie().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CTE_ID")));
                  movCte.getCta_clie().setFieldInt("MC_ANTICIPO", 1);

                  movCte.getCta_clie().setFieldString("MC_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));

                  final String strNotas2 = URLDecoder.decode(new String(request.getParameter("NOTAS").getBytes(
                          "iso-8859-1")), "UTF-8");
                  movCte.getCta_clie().setFieldString("MC_NOTAS", strNotas2);

                  movCte.getCta_clie().setFieldInt("MC_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
                  movCte.getCta_clie().setFieldDouble("MC_TASAPESO", 1.0);
                  movCte.getCta_clie().setFieldInt("FAC_ID", 0);
                  movCte.getCta_clie().setFieldInt("TKT_ID", 0);
                  movCte.getCta_clie().setFieldInt("MC_ESPAGO", 1);
                  movCte.getCta_clie().setFieldDouble("MC_ABONO", dblMontoPago);

                  movCte.doTrx();
                  if (movCte.getStrResultLast().equals("OK")) {
                     //strRes = "OK." + movCte.getCta_clie().getValorKey();
                  } else {
                     strRes = movCte.getStrResultLast();
                  }
               }
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Anula la operacion de pago o nota de cargo
         if (strid.equals("2")) {
            int intMC_ID = 0;
            //Recibimos el id del pago por cancelar
            if (request.getParameter("MC_ID") != null) {
               try {
                  intMC_ID = Integer.valueOf(request.getParameter("MC_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            movCliente movCte = new movCliente(oConn, varSesiones, request);
            movCte.getCta_clie().setFieldInt("MC_ID", intMC_ID);
            //Inicializamos objeto
            movCte.Init();
            movCte.doTrxAnul();
            String strRes = "";
            if (movCte.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = movCte.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }

         //FECHA: 12/07/2013
         //NOMBRE: ABRAHAM GONZALEZ HERNANDEZ
         //DESCRIPCION: Se cambiaron algunos datos de entrada
         //Realiza un pago masivo
         if (strid.equals("3")) {


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
            double dblMontoUsarAnticipo = 0;
            if (request.getParameter("ANTICIPOAUSAR") != null) {
               dblMontoUsarAnticipo = Double.valueOf(request.getParameter("ANTICIPOAUSAR"));
            }

            int intUsaAnticipo = 0;
            if (request.getParameter("USA_ANTI") != null) {
               intUsaAnticipo = Integer.valueOf(request.getParameter("USA_ANTI"));
            }
            //Recuperamos el ID del Anticipo
            int intIDAnticipo = 0;
            if (request.getParameter("ANTI_ID") != null) {
               intIDAnticipo = Integer.valueOf(request.getParameter("ANTI_ID"));
            }

            //Recuperamos el monto
            double dblAnticipoUsado = 0.0;
            if (request.getParameter("CANTIDAD_ANTI") != null) {
               dblAnticipoUsado = Float.valueOf(request.getParameter("CANTIDAD_ANTI"));
            }
            //Instanciamos objeto de pagos masivos
            PagosMasivos masivo = new PagosMasivos(oConn, varSesiones, request);
            masivo.setIntBanco(intBc_Id);
            //Inicializamos objeto
            masivo.Init();
            masivo.getMasivo().setFieldString("MCM_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));
            masivo.setDblSaldoFavorUsado(dblMontoUsarAnticipo);
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            }
            if (varSesiones.getIntSucursalDefault() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntSC_ID(varSesiones.getIntSucursalDefault());
            }
            //Recuperamos los pagos que se van a guardar
            String[] lstTrx = request.getParameterValues("idTrx");
            String[] lstTipoDoc = request.getParameterValues("TipoDoc");
            String[] lstMontoPay = request.getParameterValues("MONTOPAGO");
            String[] lstMONEDAS = request.getParameterValues("MONENDAORIGINAL");
            for (int i = 0; i < lstTrx.length; i++) {
               //Recuperamos el id de la transaccion
               int intIdTrx = Integer.valueOf(lstTrx[i]);
               //Recuperamos el tipo de transaccion
               int intTipoDoc = Integer.valueOf(lstTipoDoc[i]);
               //Recuperamos el monto del pago
               double dblMontoPago = Double.valueOf(lstMontoPay[i]);
               int intIdFact = 0;
               int intIdTicket = 0;
               if (intTipoDoc == 1) {
                  //FACTURA
                  intIdFact = intIdTrx;
               } else {
                  //TICKET
                  intIdTicket = intIdTrx;
               }
               //Instanciamos el objeto que nos trae las listas de precios
               movCliente movCte = new movCliente(oConn, varSesiones, request);
               //Inicializamos objeto
               movCte.Init();
               if (intBc_Id != 0) {
                  movCte.setIntBc_Id(intBc_Id);
               } else {
                  movCte.setBolCaja(true);
               }
               //Evaluamos si llego la moneda, en anticipo llega en cero
               if (intMONEDAAPAGAR == 0) {
                  //Es posible que sea un ajuste
                  intMONEDAAPAGAR = Integer.valueOf(lstMONEDAS[i]);
               }
               //Recibimos datos para el encabezado
               movCte.getCta_clie().setFieldString("MC_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));
               final String strNotas1 = URLDecoder.decode(new String(request.getParameter("NOTAS").getBytes(
                       "iso-8859-1")), "UTF-8");
               movCte.getCta_clie().setFieldString("MC_NOTAS", strNotas1);
               movCte.getCta_clie().setFieldInt("MC_MONEDA", intMONEDAAPAGAR);
               movCte.getCta_clie().setFieldDouble("MC_TASAPESO", Double.valueOf(request.getParameter("TASAPESO")));
               movCte.getCta_clie().setFieldInt("FAC_ID", intIdFact);
               movCte.getCta_clie().setFieldInt("TKT_ID", intIdTicket);
               movCte.getCta_clie().setFieldInt("MC_ESPAGO", 1);
               //Validamos si tenemos un empresa seleccionada
               if (varSesiones.getIntIdEmpresa() != 0) {
                  //Asignamos la empresa seleccionada
                  movCte.getCta_clie().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
               }
               //Asignamos la sucursal de operacion
               if (varSesiones.getIntSucursalDefault() != 0) {
                  movCte.getCta_clie().setFieldInt("SC_ID", varSesiones.getIntSucursalDefault());
               }
               movCte.getCta_clie().setFieldDouble("MC_ABONO", dblMontoPago);
               movCte.getCta_clie().setFieldInt("MC_USA_ANTICIPO", intUsaAnticipo);
               if (intUsaAnticipo == 1) {
                  movCte.getCta_clie().setFieldInt("MC_USA_ANTICIPO", 1);
                  movCte.getCta_clie().setFieldInt("MC_ANTI_ID", intIDAnticipo);
                  masivo.setBolUsaAnticipo(true);
               }
               movCte.setDblSaldoFavorUsado(dblAnticipoUsado);
               //Calculamos el factor de proporcion
               double dblFactor = (dblMontoPago / dblMontoPagoTot);
               //Recibimos los pagos
               int intCountPagos = Integer.valueOf(request.getParameter("COUNT_PAGOS"));
               for (int j = 1; j <= intCountPagos; j++) {
                  if (Double.valueOf(request.getParameter("MCD_IMPORTE" + j)) > 0) {
                     vta_mov_cte_deta detaPago = new vta_mov_cte_deta();
                     double dblImporte = Double.valueOf(request.getParameter("MCD_IMPORTE" + j));
                     double dblCambio = Double.valueOf(request.getParameter("MCD_CAMBIO" + j));
                     double dblImporteTrx = dblImporte * dblFactor;
                     double dblImporteCambio = dblCambio * dblFactor;
                     //Calculamos proporcion de la forma de pago
                     detaPago.setFieldInt("CT_ID", 0);
                     detaPago.setFieldInt("SC_ID", 0);
                     detaPago.setFieldInt("MCD_MONEDA", Integer.valueOf(request.getParameter("MCD_MONEDA" + j)));
                     detaPago.setFieldString("MCD_FOLIO", request.getParameter("MCD_FOLIO" + j));
                     detaPago.setFieldString("MCD_FORMAPAGO", request.getParameter("MCD_FORMAPAGO" + j));
                     detaPago.setFieldString("MCD_NOCHEQUE", request.getParameter("MCD_NOCHEQUE" + j));
                     detaPago.setFieldString("MCD_BANCO", request.getParameter("MCD_BANCO" + j));
                     detaPago.setFieldString("MCD_NOTARJETA", request.getParameter("MCD_NOTARJETA" + j));
                     detaPago.setFieldString("MCD_TIPOTARJETA", request.getParameter("MCD_TIPOTARJETA" + j));
                     detaPago.setFieldDouble("MCD_IMPORTE", dblImporteTrx);
                     detaPago.setFieldDouble("MCD_TASAPESO", Double.valueOf(request.getParameter("MCD_TASAPESO" + j)));
                     detaPago.setFieldDouble("MCD_CAMBIO", dblImporteCambio);
                     movCte.AddDetalle(detaPago);
                  }
               }
               //Anadimos el pago
               masivo.AddDetalle(movCte);
            }

            //Generamos transaccion

            String strRes = "";
            masivo.doTrx();
            if (masivo.getStrResultLast().equals("OK")) {
               strRes = "OK." + masivo.getMasivo().getValorKey();
            } else {
               strRes = masivo.getStrResultLast();
            }



            if (strRes.contains("OK.")) {
               movCliente movCte = new movCliente(oConn, varSesiones, request);
               movCte.Init();
               if (intBc_Id != 0) {
                  movCte.setIntBc_Id(intBc_Id);
               } else {
                  movCte.setBolCaja(true);
               }
               //Recuperamos el monto del pago
               double dblMontoPago = 0;
               if (request.getParameter("CTE_ANTICIPO") != null) {
                  dblMontoPago = Double.valueOf(request.getParameter("CTE_ANTICIPO"));
               }



               movCte.setBolEsAnticipo(true);
               if (dblMontoPago > 0) {
                  movCte.setBolEsAnticipo(true);
                  movCte.getCta_clie().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CTE_ID")));
                  movCte.getCta_clie().setFieldInt("MC_ANTICIPO", 1);

                  movCte.getCta_clie().setFieldString("MC_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));
                  final String strNotas2 = URLDecoder.decode(new String(request.getParameter("NOTAS").getBytes(
                          "iso-8859-1")), "UTF-8");
                  movCte.getCta_clie().setFieldString("MC_NOTAS", strNotas2);

                  movCte.getCta_clie().setFieldInt("MC_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
                  movCte.getCta_clie().setFieldDouble("MC_TASAPESO", 1.0);
                  movCte.getCta_clie().setFieldInt("FAC_ID", 0);
                  movCte.getCta_clie().setFieldInt("TKT_ID", 0);
                  movCte.getCta_clie().setFieldInt("MC_ESPAGO", 1);
                  movCte.getCta_clie().setFieldDouble("MC_ABONO", dblMontoPago);

                  movCte.doTrx();
                  if (movCte.getStrResultLast().equals("OK")) {
                     //strRes = "OK." + movCte.getCta_clie().getValorKey();
                  } else {
                     strRes = movCte.getStrResultLast();
                  }
               }
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Cancela un pago masivo
         if (strid.equals("4")) {
            int intMCM_ID = 0;
            //Recibimos el id del pago por cancelar
            if (request.getParameter("MCM_ID") != null) {
               try {
                  intMCM_ID = Integer.valueOf(request.getParameter("MCM_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos objeto de pagos masivos
            PagosMasivos masivo = new PagosMasivos(oConn, varSesiones, request);
            masivo.getMasivo().setFieldInt("MCM_ID", intMCM_ID);
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            }
            if (varSesiones.getIntSucursalDefault() != 0) {
               //Asignamos la empresa seleccionada
               masivo.setIntSC_ID(varSesiones.getIntSucursalDefault());
            }
            //Inicializamos objeto
            masivo.Init();
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

         //obtenemos El nombre del cliente
         if (strid.equals("6")) {
            String strCTE_ID = request.getParameter("CTE_ID");
            String strNombre = "";

            String strSQL = "Select CT_RAZONSOCIAL,MON_ID From vta_cliente Where CT_ID = " + strCTE_ID;
            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
               strNombre = rs.getString("CT_RAZONSOCIAL");
               strNombre += "|" + rs.getInt("MON_ID");
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.print(strNombre);//Pintamos el resultado
         }

         //obtenemos la moneda de un banco
         if (strid.equals("7")) {
            String strMoneda = request.getParameter("BC_ID");
            String strSql = "Select * From vta_bcos Where BC_ID = " + strMoneda;
            int intMoneda = 0;
            //System.out.println("Miquery:" + strSql);
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
            String strFecha = request.getParameter("fecha");
            Fechas FECHAS = new Fechas();

            strMonedaBanco = strMonedaBanco.trim();
            strMonedaSeleccionada = strMonedaSeleccionada.trim();
            double dblTasaCambio = 0.0;
            Monedas MiTasaCambio = new Monedas(oConn);
            MiTasaCambio.setBoolConversionAutomatica(false);
            if(strMonedaBanco.equals("0"))strMonedaBanco = "1";
            if(strMonedaSeleccionada.equals("0"))strMonedaSeleccionada = "1";


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

         //Obtenemos la cantidad total de Anticipos a ese Cliente
         if (strid.equals("11")) {
            String strCTE = request.getParameter("CTE_ID");
            double dblAnticipoTotal = 0.0;
            String strSQL = "Select Sum(MC_ABONO) as Anticipo From vta_mov_cte "
                    + "Where CT_ID =" + strCTE + " and MC_ABONO > 0 and MC_ANTICIPO = 1";

            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
               dblAnticipoTotal = rs.getInt("Anticipo");
            }
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.print(dblAnticipoTotal);//Pintamos el resultado
         }
         //Obtenemos la cantidad total de Anticipos a ese Cliente
         if (strid.equals("12")) {

            //Recuperamos el numero de banco
            int intBc_Id = 0;
            if (request.getParameter("BC_ID") != null) {
               intBc_Id = Integer.valueOf(request.getParameter("BC_ID"));
            }
            //Recuperamos el id del cliente
            int intCt_Id = 0;
            if (request.getParameter("CT_ID") != null) {
               intCt_Id = Integer.valueOf(request.getParameter("CT_ID"));
            }
            //Obtenemos la sucursal del cliente
            int intSc_Id = 0;
            String strRazonSocial = "";
            String strSQL = "Select SC_ID,CT_RAZONSOCIAL From vta_cliente "
                    + "Where CT_ID =" + intCt_Id + " ";

            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
               intSc_Id = rs.getInt("SC_ID");
               strRazonSocial = rs.getString("CT_RAZONSOCIAL");
            }
            rs.close();
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

            //Instanciamos el objeto que nos trae las listas de precios
            movCliente movCte = new movCliente(oConn, varSesiones, request);
            //Inicializamos objeto
            movCte.Init();
            if (intBc_Id != 0) {
               movCte.setIntBc_Id(intBc_Id);
            } else {
               movCte.setBolCaja(true);
            }

            //Recibimos datos para el encabezado
            movCte.getCta_clie().setFieldString("MC_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));

            final String strNotas3 = URLDecoder.decode(new String(request.getParameter("NOTAS").getBytes(
                    "iso-8859-1")), "UTF-8");
            movCte.getCta_clie().setFieldString("MC_NOTAS", strNotas3);
            movCte.getCta_clie().setFieldInt("MC_MONEDA", Integer.valueOf(request.getParameter("MONEDA")));
            movCte.getCta_clie().setFieldDouble("MC_TASAPESO", Double.valueOf(request.getParameter("TASAPESO")));
            movCte.getCta_clie().setFieldInt("FAC_ID", 0);
            movCte.getCta_clie().setFieldInt("TKT_ID", 0);
            movCte.getCta_clie().setFieldInt("MC_ESPAGO", 0);
            movCte.getCta_clie().setFieldDouble("MC_CARGO", dblMontoPago);
            movCte.getCta_clie().setFieldInt("CT_ID", intCt_Id);
            movCte.getCta_clie().setFieldInt("SC_ID", intSc_Id);
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               movCte.getCta_clie().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
            }
            //Generamos transaccion

            String strRes = "";
            movCte.doTrx();
            if (movCte.getStrResultLast().equals("OK")) {
               strRes = "OK." + movCte.getCta_clie().getValorKey();

               //Instanciamos el objeto de bancos para aplicar el retiro
               Bancos banco = new Bancos(oConn, varSesiones, request);
               banco.getCta_bcos().setFieldInt("MCB_ID", 0);
               banco.getCta_bcos().setFieldInt("BC_ID", intBc_Id);
               banco.getCta_bcos().setFieldInt("SC_ID", intSc_Id);
               banco.getCta_bcos().setFieldInt("MCB_CONCILIADO", 1);
               banco.getCta_bcos().setFieldInt("MCB_TIPO1", 0);
               banco.getCta_bcos().setFieldInt("MCB_TIPO2", 0);
               banco.getCta_bcos().setFieldInt("MCB_TIPO3", 0);
               banco.getCta_bcos().setFieldString("MCB_FECHA", fecha.FormateaBD(request.getParameter("FECHA"), "/"));
               banco.getCta_bcos().setFieldDouble("MCB_DEPOSITO", 0);
               banco.getCta_bcos().setFieldDouble("MCB_RETIRO", dblMontoPago);
               banco.getCta_bcos().setFieldString("MCB_CONCEPTO", request.getParameter("NOTAS"));
               banco.getCta_bcos().setFieldString("MCB_BENEFICIARIO", strRazonSocial);
               banco.getCta_bcos().setFieldString("MCB_NOCHEQUE", request.getParameter("CHEQUE"));
               //Anexamos el detalle
               vta_mov_cta_bcos_deta movdeta = new vta_mov_cta_bcos_deta();
               movdeta.setFieldInt("GT_ID", 0);
               movdeta.setFieldInt("CC_ID", 0);
               movdeta.setFieldDouble("MCBD_IMPORTE", dblMontoPago);
               movdeta.setFieldString("MCBD_CONCEPTO", request.getParameter("NOTAS"));
               banco.AddDetalle(movdeta);
               banco.doTrx();
               if (!banco.getStrResultLast().equals("OK")) {
                  strRes = banco.getStrResultLast();
               }

            } else {
               strRes = movCte.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.print(strRes);//Pintamos el resultado
         }

         if (strid.equals("13")) {
            String strCTE = request.getParameter("CT_ID");
            String strSQL = "Select * From vta_mov_cte Where CT_ID = " + strCTE + " and MC_ANTICIPO = 1 and MC_ANULADO = 0  AND MC_SALDO_ANTICIPO >1";
            ResultSet rs = oConn.runQuery(strSQL, true);
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<Anticipos>";

            int intMC_ID = 0;
            String strMC_FECHA = "";
            double dblMC_SALDO_ANTICIPO = 0.0;
            String strMC_FOLIO = "";
            int intMC_MONEDA = 0;
            double dblMC_TASAPESO = 0.0;
            double dblMC_ANTICIPO_ORIGINAL = 0.0;
            while (rs.next()) {
               intMC_ID = rs.getInt("MC_ID");
               strMC_FECHA = rs.getString("MC_FECHA");
               dblMC_SALDO_ANTICIPO = rs.getDouble("MC_SALDO_ANTICIPO");
               strMC_FOLIO = rs.getString("MC_FOLIO");
               intMC_MONEDA = rs.getInt("MC_MONEDA");
               dblMC_TASAPESO = rs.getDouble("MC_TASAPESO");
               dblMC_ANTICIPO_ORIGINAL = rs.getDouble("MC_ANTICIPO_ORIGINAL");

               strXML += "<Anticipo "
                       + " MC_ID = \"" + intMC_ID + "\"  "
                       + " MC_FECHA = \"" + strMC_FECHA + "\"  "
                       + " MC_SALDO_ANTICIPO = \"" + dblMC_SALDO_ANTICIPO + "\"  "
                       + " MC_FOLIO = \"" + strMC_FOLIO + "\"  "
                       + " MC_MONEDA = \"" + intMC_MONEDA + "\"  "
                       + " MC_TASAPESO = \"" + dblMC_TASAPESO + "\"  "
                       + " MC_ANTICIPO_ORIGINAL = \"" + dblMC_ANTICIPO_ORIGINAL + "\"  "
                       + " />";
            }
            strXML += "</Anticipos>";

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultadoCTE
         }

         //Obtenemos el tipo de moneda que usa el Cliente
         if (strid.equals("14")) {
            int intCT_ID = 0;
            String strCT_ID = request.getParameter("CT_ID");
            String strSQL = "Select MON_ID from vta_cliente Where CT_ID = " + strCT_ID;

            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
               intCT_ID = rs.getInt("MON_ID");
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.print(intCT_ID);//Pintamos el resultado
         }

         //regreso los valores de la cobranza
         if (strid.equals("15")) {
            UtilXml utilXML = new UtilXml();
            String strMoneda = request.getParameter("COB_MONEDA");
            //Recuperamos el id del cliente
            String intCXC_ID = request.getParameter("intCXC_ID");
            if (intCXC_ID == null) {
               intCXC_ID = "0";
            }

            //int intGlobal = Integer.valueOf(request.getParameter("intGlobal"));
            String strSql = "";

            String intCT_ID = request.getParameter("CT_ID");
            if (intCT_ID == null) {
               intCT_ID = "0";
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
                    + intCT_ID + " AND CXP_FECHA>='" + strfecha1 + "' AND CXP_FECHA<='" + strfecha2 + "' AND CXP_ANULADO=0 AND  CXP_MONEDA='" + strMoneda + "' AND CXP_SALDO > 1;";


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
         //regreso los valores de la cobranza
         if (strid.equals("16")) {
            String strMoneda = request.getParameter("TKT_MONEDA");
            //Recuperamos el id del cliente
            String intCT_ID = request.getParameter("CT_ID");
            if (intCT_ID == null) {
               intCT_ID = "0";
            }

            String strfecha1 = request.getParameter("TKT_FECHA1");

            if (strfecha1 == null) {
               strfecha1 = "";
            } else {
               strfecha1 = fecha.FormateaBD(strfecha1, "/");
            }
            String strfecha2 = fecha.FormateaBD(request.getParameter("TKT_FECHA2"), "/");
            if (strfecha2 == null) {
               strfecha2 = "";
            }

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_movs>";
            //Tickets
            strXML += "<tickets>";
            String strSql = "select TKT_ID,TKT_FOLIO,TKT_FECHA,TKT_TOTAL,TKT_SALDO from vta_tickets where CT_ID = "
                    + intCT_ID + " AND TKT_FECHA>='" + strfecha1 + "' AND TKT_FECHA<='" + strfecha2 + "' "
                    + " AND TKT_ANULADA=0 AND  TKT_MONEDA='" + strMoneda + "' AND TKT_SALDO >= 1 ORDER BY TKT_FECHA,TKT_FOLIO";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               int intTKT_ID = rs.getInt("TKT_ID");
               double dblTKT_TOTAL = rs.getDouble("TKT_TOTAL");
               double dblTKT_SALDO = rs.getDouble("TKT_SALDO");
               String strTKT_FECHA = rs.getString("TKT_FECHA");
               String strTKT_FOLIO = rs.getString("TKT_FOLIO");

               strXML += "<ticket "
                       + " TKT_ID = \"" + intTKT_ID + "\"  "
                       + " TKT_TOTAL = \"" + dblTKT_TOTAL + "\"  "
                       + " TKT_SALDO = \"" + dblTKT_SALDO + "\"  "
                       + " TKT_FECHA = \"" + strTKT_FECHA + "\"  "
                       + " TKT_FOLIO = \"" + strTKT_FOLIO + "\"  "
                       + " />";
            }
            rs.close();
            strXML += "</tickets>";
            //Facturas
            strXML += "<facturas>";
            String strSql2 = "select FAC_ID,FAC_FOLIO_C,FAC_FECHA,FAC_TOTAL,FAC_SALDO from vta_facturas where CT_ID = "
                    + intCT_ID + " AND FAC_FECHA>='" + strfecha1 + "' AND FAC_FECHA<='" + strfecha2 + "' "
                    + " AND FAC_ANULADA=0 AND  FAC_MONEDA='" + strMoneda + "' AND FAC_SALDO >= 1 ORDER BY FAC_FECHA,FAC_FOLIO_C";
            rs = oConn.runQuery(strSql2, true);
            while (rs.next()) {
               int intFAC_ID = rs.getInt("FAC_ID");
               double dblFAC_TOTAL = rs.getDouble("FAC_TOTAL");
               double dblFAC_SALDO = rs.getDouble("FAC_SALDO");
               String strFAC_FECHA = rs.getString("FAC_FECHA");
               String strFAC_FOLIO = rs.getString("FAC_FOLIO_C");

               strXML += "<factura "
                       + " FAC_ID = \"" + intFAC_ID + "\"  "
                       + " FAC_TOTAL = \"" + dblFAC_TOTAL + "\"  "
                       + " FAC_SALDO = \"" + dblFAC_SALDO + "\"  "
                       + " FAC_FECHA = \"" + strFAC_FECHA + "\"  "
                       + " FAC_FOLIO = \"" + strFAC_FOLIO + "\"  "
                       + " />";
            }
            rs.close();
            strXML += "</facturas>";
            
            //El detalle
            strXML += "</vta_movs>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
      }
   } else {
   }
   oConn.close();
%>