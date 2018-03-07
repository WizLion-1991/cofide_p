<%--
    Document   : HM_Ventas
      Realiza todas las operaciones que tienen que ver con ventas como son TICKETS FACTURAS PEDIDOS COTIZACIONES
    Created on : 21/06/2010, 06:39:31 PM
    Author     : zeus
--%>
<%@page import="Core.FirmasElectronicas.SATXmlLala"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Tablas.vta_pedidos"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="ERP.FacturaMasiva"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.CIP_Form" %>
<%@page import="Tablas.Usuarios" %>
<%@page import="Tablas.vta_ticketsdeta" %>
<%@page import="Tablas.vta_pedidosdeta" %>
<%@page import="Tablas.vta_facturadeta" %>
<%@page import="Tablas.vta_cotizadeta" %>
<%@page import="Tablas.vta_mov_cte_deta" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
<%@page import="ERP.Ticket" %>
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
         //Recuperamos paths de web.xml
         String strPathXML = this.getServletContext().getInitParameter("PathXml");
         String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
         String strmod_Inventarios = this.getServletContext().getInitParameter("mod_Inventarios");
         String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
         String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
         if (strfolio_GLOBAL == null) {
            strfolio_GLOBAL = "SI";
         }
         if (strmod_Inventarios == null) {
            strmod_Inventarios = "NO";
         }
         //Obtenemos parametros
         String strid = request.getParameter("id");
         //Si la peticion no fue nula proseguimos
         if (strid != null) {
            //Genera una nueva operacion de ventas
            if (strid.equals("1")) {
               //Instanciamos el objeto que generara la venta
               Ticket ticket = new Ticket(oConn, varSesiones, request);
               ticket.setStrPATHKeys(strPathPrivateKeys);
               ticket.setStrPATHXml(strPathXML);
               ticket.setStrPATHFonts(strPathFonts);
               //Desactivamos inventarios
               if (strmod_Inventarios.equals("NO")) {
                  ticket.setBolAfectaInv(false);
               }
               //Recibimos parametros
               String strPrefijoMaster = "TKT";
               String strPrefijoDeta = "TKTD";
               String strTipoVtaNom = Ticket.TICKET;
               //Recuperamos el tipo de venta 1:FACTURA 2:TICKET 3:PEDIDO
               String strTipoVta = request.getParameter("TIPOVENTA");
               if (strTipoVta == null) {
                  strTipoVta = "2";
               }
               if (strTipoVta.equals("1")) {
                  strPrefijoMaster = "FAC";
                  strPrefijoDeta = "FACD";
                  strTipoVtaNom = Ticket.FACTURA;
                  ticket.initMyPass(this.getServletContext());
               }
               if (strTipoVta.equals("3")) {
                  strPrefijoMaster = "PD";
                  strPrefijoDeta = "PDD";
                  strTipoVtaNom = Ticket.PEDIDO;
               }
               if (strTipoVta.equals("4")) {
                  strPrefijoMaster = "PD";
                  strPrefijoDeta = "PDD";
                  strTipoVtaNom = Ticket.COTIZACION;
               }
               ticket.setStrTipoVta(strTipoVtaNom);
               //Validamos si tenemos un empresa seleccionada
               if (varSesiones.getIntIdEmpresa() != 0) {
                  //Asignamos la empresa seleccionada
                  ticket.setIntEMP_ID(varSesiones.getIntIdEmpresa());
               }
               //Validamos si usaremos un folio global
               if (strfolio_GLOBAL.equals("NO")) {
                  ticket.setBolFolioGlobal(false);
               }
               //Recibimos datos para el encabezado
               int intPD_ID = 0;
               try {
                  intPD_ID = Integer.valueOf(request.getParameter("PD_ID"));
               } catch (NumberFormatException ex) {
                  System.out.println("HM_Ventas PD_ID " + ex.getMessage());
               }
               ticket.setIntPedidoGenero(intPD_ID);
               if (strTipoVta.equals("1") || strTipoVta.equals("2")) {
                  ticket.getDocument().setFieldInt("PD_ID", intPD_ID);
               } else {
                  //Edicion de un pedido
                  if (strTipoVta.equals("3")) {
                     //Si llega el campo de pedido entonces estamos editando un pedido
                     if (request.getParameter("PD_ID") != null) {
                        ticket.getDocument().setFieldInt("PD_ID", intPD_ID);
                        //Validamos si la modificacion de un pedido
                        if (ticket.getDocument().getFieldInt("PD_ID") != 0) {
                           //Generamos transaccion
                           ticket.getDocument().setValorKey(ticket.getDocument().getFieldInt("PD_ID") + "");
                           ticket.Init();
                        }
                     }
                  }
               }
               ticket.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
               ticket.getDocument().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CT_ID")));
               if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", 1);
               } else {
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
               }
               //Clave de vendedor
               int intVE_ID = 0;
               try {
                  intVE_ID = Integer.valueOf(request.getParameter("VE_ID"));
               } catch (NumberFormatException ex) {
                  System.out.println("HM_Ventas VE_ID " + ex.getMessage());
               }
               //Tarifas de IVA
               int intTI_ID = 0;
               int intTI_ID2 = 0;
               int intTI_ID3 = 0;
               try {
                  intTI_ID = Integer.valueOf(request.getParameter("TI_ID"));
                  intTI_ID2 = Integer.valueOf(request.getParameter("TI_ID2"));
                  intTI_ID3 = Integer.valueOf(request.getParameter("TI_ID3"));
               } catch (NumberFormatException ex) {
                  System.out.println("HM_Ventas TI_ID " + ex.getMessage());
               }
               //Tipo de comprobante
               int intFAC_TIPOCOMP = 0;
               try {
                  intFAC_TIPOCOMP = Integer.valueOf(request.getParameter("FAC_TIPOCOMP"));
               } catch (NumberFormatException ex) {
                  System.out.println("HM_Ventas FAC_TIPOCOMP " + ex.getMessage());
               }
               //Asignamos los valores al objeto
               ticket.getDocument().setFieldInt("VE_ID", intVE_ID);
               ticket.getDocument().setFieldInt("TI_ID", intTI_ID);
               ticket.getDocument().setFieldInt("TI_ID2", intTI_ID2);
               ticket.getDocument().setFieldInt("TI_ID3", intTI_ID3);
               ticket.setIntFAC_TIPOCOMP(intFAC_TIPOCOMP);
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_ESSERV", Integer.valueOf(request.getParameter(strPrefijoMaster + "_ESSERV")));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA"), "/"));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", request.getParameter(strPrefijoMaster + "_NOTAS"));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", request.getParameter(strPrefijoMaster + "_NOTASPIE"));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE")));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO1")));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO2")));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO3")));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(request.getParameter(strPrefijoMaster + "_TOTAL")));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA1")));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA2")));
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA3")));
               ticket.getDocument().setFieldString("HM_ON", request.getParameter("HM_ON"));
               ticket.getDocument().setFieldString("HM_DIV", request.getParameter("HM_DIV"));
               ticket.getDocument().setFieldString("HM_SOC", request.getParameter("HM_SOC"));
               ticket.getDocument().setFieldString("HM_REFERENCEDATE", request.getParameter("HM_REFERENCEDATE"));
               ticket.getDocument().setFieldString("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY", request.getParameter("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY"));

               if (request.getParameter(strPrefijoMaster + "_TASAPESO") != null) {
                  if (Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")) == 0) {
                     ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
                  } else {
                     ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")));
                  }
               } else {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
               }
               //Datos de la aduana
               ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMPEDI", request.getParameter(strPrefijoMaster + "_NUMPEDI"));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", request.getParameter(strPrefijoMaster + "_FECHAPEDI"));
               ticket.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", request.getParameter(strPrefijoMaster + "_ADUANA"));
               //Si no hay moneda seleccionada que ponga tasa 1
               if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
               }
               //Validamos parametros para recibos de honorarios}
               if (request.getParameter(strPrefijoMaster + "_RETISR") != null && strTipoVtaNom.equals(Ticket.FACTURA)) {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_RETISR", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETISR")));
               }
               if (request.getParameter(strPrefijoMaster + "_RETIVA") != null && strTipoVtaNom.equals(Ticket.FACTURA)) {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_RETIVA", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETIVA")));
               }
               if (request.getParameter(strPrefijoMaster + "_NETO") != null && strTipoVtaNom.equals(Ticket.FACTURA)) {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_NETO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NETO")));
               }
               //Opciones de facturacion recurrente
               if (request.getParameter(strPrefijoMaster + "_ESRECU") != null) {
                  int intEsRecu = 0;
                  int intPeriodicidad = 1;
                  int intDiaPer = 1;
                  try {
                     intEsRecu = Integer.valueOf(request.getParameter(strPrefijoMaster + "_ESRECU"));
                  } catch (NumberFormatException ex) {
                     System.out.println("Ventas: Error convertir campo " + strPrefijoMaster + "_ESRECU" + " " + ex.getMessage());
                  }
                  try {
                     intPeriodicidad = Integer.valueOf(request.getParameter(strPrefijoMaster + "_PERIODICIDAD"));
                  } catch (NumberFormatException ex) {
                     System.out.println("Ventas: Error convertir campo " + strPrefijoMaster + "_PERIODICIDAD" + " " + ex.getMessage());
                  }

                  try {
                     intDiaPer = Integer.valueOf(request.getParameter(strPrefijoMaster + "_DIAPER"));
                  } catch (NumberFormatException ex) {
                     System.out.println("Ventas: Error convertir campo " + strPrefijoMaster + "_DIAPER" + " " + ex.getMessage());
                  }
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_ESRECU", intEsRecu);
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_PERIODICIDAD", intPeriodicidad);
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_DIAPER", intDiaPer);
               }
               //Recibimos datos de los items o partidas
               int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
               for (int i = 1; i <= intCount; i++) {
                  TableMaster deta = null;
                  if (strTipoVtaNom.equals(Ticket.TICKET)) {
                     deta = new vta_ticketsdeta();
                  }
                  if (strTipoVtaNom.equals(Ticket.FACTURA)) {
                     deta = new vta_facturadeta();
                  }
                  if (strTipoVtaNom.equals(Ticket.PEDIDO)) {
                     deta = new vta_pedidosdeta();
                  }
                  if (strTipoVtaNom.equals(Ticket.COTIZACION)) {
                     deta = new vta_cotizadeta();
                  }
                  deta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                  deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
                  deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO1" + i)));
                  deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO2" + i)));
                  deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO3" + i)));
                  deta.setFieldInt(strPrefijoDeta + "_ESREGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESREGALO" + i)));
                  deta.setFieldString(strPrefijoDeta + "_CVE", request.getParameter(strPrefijoDeta + "_CVE" + i));
                  deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", request.getParameter(strPrefijoDeta + "_DESCRIPCION" + i));
                  deta.setFieldString(strPrefijoDeta + "_NOSERIE", request.getParameter(strPrefijoDeta + "_NOSERIE" + i));
                  deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPORTE" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", Double.valueOf(request.getParameter(strPrefijoDeta + "_CANTIDAD" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_TASAIVA1", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA1" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_TASAIVA2", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA2" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_TASAIVA3", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA3" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO1" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO2" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO3" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_IMPORTEREAL", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPORTEREAL" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_PRECIO", Double.valueOf(request.getParameter(strPrefijoDeta + "_PRECIO" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_DESCUENTO", Double.valueOf(request.getParameter(strPrefijoDeta + "_DESCUENTO" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_PORDESC", Double.valueOf(request.getParameter(strPrefijoDeta + "_PORDESC" + i)));
                  deta.setFieldDouble(strPrefijoDeta + "_PRECREAL", Double.valueOf(request.getParameter(strPrefijoDeta + "_PRECREAL" + i)));

                  //Solo aplica si es ticket o factura
                  if (strTipoVtaNom.equals(Ticket.TICKET) || strTipoVtaNom.equals(Ticket.FACTURA)) {
                     deta.setFieldInt(strPrefijoDeta + "_ESDEVO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESDEVO" + i)));
                  }
                  deta.setFieldInt(strPrefijoDeta + "_PRECFIJO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_PRECFIJO" + i)));
                  deta.setFieldInt(strPrefijoDeta + "_ESREGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESREGALO" + i)));
                  deta.setFieldString(strPrefijoDeta + "_COMENTARIO", request.getParameter(strPrefijoDeta + "_NOTAS" + i));
                  ticket.AddDetalle(deta);
               }
               //Recibimos los pagos
               int intCountPagos = Integer.valueOf(request.getParameter("COUNT_PAGOS"));

               for (int i = 1; i <= intCountPagos; i++) {
                  if (Double.valueOf(request.getParameter("MCD_IMPORTE" + i)) > 0) {
                     vta_mov_cte_deta detaPago = new vta_mov_cte_deta();
                     detaPago.setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CT_ID")));
                     detaPago.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
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
                     ticket.AddDetalle(detaPago);
                  }
               }
               SATXmlLala SAT = new SATXmlLala();
               ticket.setSAT(SAT);
             
               //Inicializamos objeto
               //Validamos si es un pedido que se esta editando para solo modificar el pedido anterior
               if (strTipoVta.equals("3") && ticket.getDocument().getFieldInt("PD_ID") != 0) {
                  ticket.doTrxMod();
               } else {
                  ticket.Init();
                  //Generamos transaccion
                  ticket.doTrx();
               }
               String strRes = "";
               if (ticket.getStrResultLast().equals("OK")) {
                  strRes = "OK." + ticket.getDocument().getValorKey();
               } else {
                  strRes = ticket.getStrResultLast();
               }
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println(strRes);//Pintamos el resultado
            }
            //Anula la operacion
            if (strid.equals("2")) {
               //Instanciamos el ticvet
               Ticket ticket = new Ticket(oConn, varSesiones, request);
               ticket.setStrPATHKeys(strPathPrivateKeys);
               ticket.setStrPATHXml(strPathXML);

               //Recibimos parametros
               String strPrefijoMaster = "TKT";
               String strTipoVtaNom = Ticket.TICKET;
               //Recuperamos el tipo de venta 1:FACTURA 2:TICKET 3:PEDIDO
               String strTipoVta = request.getParameter("TIPOVENTA");
               if (strTipoVta == null) {
                  strTipoVta = "2";
               }
               if (strTipoVta.equals("1")) {
                  strPrefijoMaster = "FAC";
                  strTipoVtaNom = Ticket.FACTURA;
               }
               if (strTipoVta.equals("3")) {
                  strPrefijoMaster = "PD";
                  strTipoVtaNom = Ticket.PEDIDO;
               }
               if (strTipoVta.equals("4")) {
                  strPrefijoMaster = "PD";
                  strTipoVtaNom = Ticket.COTIZACION;
               }
               ticket.setStrTipoVta(strTipoVtaNom);
               //Asignamos el id de la operacion por anular
               String strIdAnul = request.getParameter("idAnul");
               int intId = 0;
               if (strIdAnul == null) {
                  strIdAnul = "0";
               }
               intId = Integer.valueOf(strIdAnul);
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
               ticket.Init();
               ticket.doTrxAnul();
               String strRes = ticket.getStrResultLast();
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println(strRes);//Pintamos el resultado
            }
         }
         //Facturacion de tickets
         if (strid.equals("3")) {
            FacturaMasiva masiva = new FacturaMasiva(oConn, varSesiones, request);
            masiva.getMiFactura().setStrPATHKeys(strPathPrivateKeys);
            masiva.getMiFactura().setStrPATHXml(strPathXML);
            masiva.getMiFactura().setStrPATHFonts(strPathFonts);
            //Recibimos datos para el encabezado
            masiva.getMiFactura().getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
            masiva.getMiFactura().getDocument().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CT_ID")));
            masiva.getMiFactura().getDocument().setFieldString("FAC_FECHA", fecha.FormateaBD(request.getParameter("FAC_FECHA"), "/"));
            masiva.getMiFactura().getDocument().setFieldString("FAC_FOLIO", request.getParameter("FAC_FOLIO"));
            masiva.getMiFactura().getDocument().setFieldString("FAC_NOTAS", request.getParameter("FAC_NOTAS"));
            masiva.getMiFactura().getDocument().setFieldDouble("FAC_TOTAL", Double.valueOf(request.getParameter("FAC_TOTAL")));
            masiva.getMiFactura().getDocument().setFieldInt("FAC_MONEDA", 0);
            masiva.getMiFactura().getDocument().setFieldDouble("FAC_TASAPESO", 1);
            masiva.getMiFactura().initMyPass(this.getServletContext());
            //Recuperamos todas las operaciones por facturar
            String[] lstTKT_ID = request.getParameterValues("TKT_ID");
            int intValue = 0;
            for (int i = 0; i < lstTKT_ID.length; i++) {
               Ticket tkt = new Ticket(oConn, varSesiones, request);
               tkt.setStrTipoVta(Ticket.TICKET);
               try {
                  intValue = Integer.valueOf(lstTKT_ID[i]);
               } catch (NumberFormatException ex) {
                  System.out.println("FACTURA TICKET...." + ex.getMessage());
               }
               tkt.getDocument().setFieldInt("TKT_ID", intValue);
               masiva.AddDetalle(tkt);
            }
            //Buscamos datos adicionales del ticket
            String strSql = "select TKT_NOTASPIE,TKT_REFERENCIA,TKT_CONDPAGO from vta_tickets WHERE TKT_ID = " + intValue;
            ResultSet rs = oConn.runQuery(strSql);
            while (rs.next()) {
               masiva.getMiFactura().getDocument().setFieldString("FAC_NOTASPIE", rs.getString("TKT_NOTASPIE"));
               masiva.getMiFactura().getDocument().setFieldString("FAC_REFERENCIA", rs.getString("TKT_REFERENCIA"));
               masiva.getMiFactura().getDocument().setFieldString("FAC_CONDPAGO", rs.getString("TKT_CONDPAGO"));
            }
            rs.close();
            //Inicializamos objeto
            masiva.Init();
            //Generamos transaccion
            masiva.doTrx();
            String strRes = "";
            if (masiva.getStrResultLast().equals("OK")) {
               strRes = "OK." + masiva.getMiFactura().getDocument().getValorKey();
            } else {
               strRes = masiva.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Anular factura de tickets
         if (strid.equals("4")) {
            FacturaMasiva masiva = new FacturaMasiva(oConn, varSesiones, request);
            masiva.getMiFactura().setStrPATHKeys(strPathPrivateKeys);
            masiva.getMiFactura().setStrPATHXml(strPathXML);
            masiva.getMiFactura().setStrPATHFonts(strPathFonts);
            masiva.getMiFactura().initMyPass(this.getServletContext());
            //Asignamos el id de la operacion por anular
            String strIdAnul = request.getParameter("idAnul");
            int intId = 0;
            if (strIdAnul == null) {
               strIdAnul = "0";
            }
            intId = Integer.valueOf(strIdAnul);
            masiva.getMiFactura().getDocument().setFieldInt("FAC_ID", intId);
            masiva.Init();
            masiva.doTrxAnul();
            String strRes = masiva.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Regresa los datos basico de un producto
         if (strid.equals("5")) {
            UtilXml utilXML = new UtilXml();
            String strPR_CODIGO = request.getParameter("PR_CODIGO");
            String strSC_ID = request.getParameter("SC_ID");
            String strSC_ID2 = request.getParameter("SC_ID2");
            if (strSC_ID2 == null) {
               strSC_ID2 = "";
            }
            //Valores a regresar del producto
            int intPR_ID = 0;
            int intPR_ID2 = 0;
            int intPR_REQEXIST = 0;
            String strPR_DESCRIPCION = "";
            String strPR_CODBARRAS = "";
            int intPR_EXENTO1 = 0;
            int intPR_EXENTO2 = 0;
            int intPR_EXENTO3 = 0;
            double dblCosto = 0;
            String strPR_CODIGOBD = "";
            //Buscamos el producto en la bd
            String strSql = "SELECT PR_ID,PR_CODIGO,PR_CODBARRAS,PR_DESCRIPCION,"
                    + "PR_REQEXIST,PR_EXENTO1,PR_EXENTO2,PR_EXENTO3,PR_COSTOUEPS "
                    + " FROM vta_producto "
                    + " where (PR_CODIGO = '" + strPR_CODIGO + "' "
                    + " OR PR_CODBARRAS = '" + strPR_CODIGO + "') "
                    + " AND SC_ID = '" + strSC_ID + "'";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intPR_ID = rs.getInt("PR_ID");
               strPR_CODIGOBD = rs.getString("PR_CODIGO");
               strPR_CODBARRAS = rs.getString("PR_CODBARRAS");
               strPR_DESCRIPCION = rs.getString("PR_DESCRIPCION");
               intPR_REQEXIST = rs.getInt("PR_REQEXIST");
               intPR_EXENTO1 = rs.getInt("PR_EXENTO1");
               intPR_EXENTO2 = rs.getInt("PR_EXENTO2");
               intPR_EXENTO3 = rs.getInt("PR_EXENTO3");
               dblCosto = rs.getDouble("PR_COSTOUEPS");
            }
            rs.close();
            //Validamos el almacen secundario en caso que proceda
            if (!strSC_ID2.equals("")) {
               strSql = "SELECT PR_ID "
                       + " FROM vta_producto "
                       + " where (PR_CODIGO = '" + strPR_CODIGO + "' "
                       + " OR PR_CODBARRAS = '" + strPR_CODIGO + "') "
                       + " AND SC_ID = '" + strSC_ID2 + "'";
               rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  intPR_ID2 = rs.getInt("PR_ID");
               }
               rs.close();
            }
            //Xml de respuesta
            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strRes += "<vta_producto>";
            strRes += "<vta_productos "
                    + " PR_ID = \"" + intPR_ID + "\"  "
                    + " PR_ID2 = \"" + intPR_ID2 + "\"  "
                    + " PR_CODIGO = \"" + strPR_CODIGOBD + "\"  "
                    + " PR_CODBARRAS = \"" + strPR_CODBARRAS + "\"  "
                    + " PR_DESCRIPCION = \"" + utilXML.Sustituye(strPR_DESCRIPCION) + "\"  "
                    + " PR_REQEXIST = \"" + intPR_REQEXIST + "\"  "
                    + " PR_EXENTO1 = \"" + intPR_EXENTO1 + "\"  "
                    + " PR_EXENTO2 = \"" + intPR_EXENTO2 + "\"  "
                    + " PR_EXENTO3 = \"" + intPR_EXENTO3 + "\"  "
                    + " PR_COSTOPROM = \"" + dblCosto + "\"  "
                    + " />";
            strRes += "</vta_producto>";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Regresa los datos de un pedido para venderlo
         if (strid.equals("8")) {
            String strPD_ID = request.getParameter("PD_ID");
            if (strPD_ID == null) {
               strPD_ID = "0";
            }
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_pedido ";
            //Recuperamos info de pedidos
            vta_pedidos pedido = new vta_pedidos();
            pedido.ObtenDatos(Integer.valueOf(strPD_ID), oConn);
            String strValorPar = pedido.getFieldPar();
            strXML += strValorPar + " > ";
            //Obtenemos el detalle
            vta_pedidosdeta deta = new vta_pedidosdeta();
            ArrayList<TableMaster> lstDeta = deta.ObtenDatosVarios(" PD_ID = " + pedido.getFieldInt("PD_ID"), oConn);
            Iterator<TableMaster> it = lstDeta.iterator();
            ResultSet rs = null;
            String strSql;
            while (it.hasNext()) {
               TableMaster tbn = it.next();
               int intPR_REQEXIST = 0;
               double dblExistencia = 0;
               String strPR_CODBARRAS = "";
               //Consultamos la existencia y si requiera de existencia para su venta
               strSql = "select PR_REQEXIST,PR_EXISTENCIA,PR_CODBARRAS from vta_producto where PR_ID = " + tbn.getFieldInt("PR_ID");
               rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  intPR_REQEXIST = rs.getInt("PR_REQEXIST");
                  dblExistencia = rs.getDouble("PR_EXISTENCIA");
                  strPR_CODBARRAS = rs.getString("PR_CODBARRAS");
               }
               rs.close();
               strXML += "<deta ";
               strXML += tbn.getFieldPar() + " PR_REQEXIST = \"" + intPR_REQEXIST + "\" "
                       + " PR_EXISTENCIA=\"" + dblExistencia + "\" PR_CODBARRAS=\"" + strPR_CODBARRAS + "\"";
               strXML += "/>";
            }
            strXML += "</vta_pedido>";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Nos regresa el nombre del cliente y la lista de precios asignada
         if (strid.equals("9")) {
            UtilXml utilXML = new UtilXml();
            //Recuperamos el id del cliente
            String strCteId = request.getParameter("CT_ID");
            if (strCteId == null) {
               strCteId = "0";
            }
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_cliente>";
            //Consultamos la info
            int intCT_ID = 0;
            int intCT_LPRECIOS = 0;
            double dblCT_DESCUENTO = 0;
            int intCT_DIASCREDITO = 0;
            int intCT_TIPOPERS = 0;
            int intCT_TIPOFAC = 0;
            String strCT_USOIMBUEBLE = "";
            double dblCT_MONTOCRED = 0;
            String strCT_RAZONSOCIAL = "";
            String strSql = "select CT_ID,CT_RAZONSOCIAL,CT_LPRECIOS,"
                    + "CT_DESCUENTO,CT_DIASCREDITO,CT_MONTOCRED,CT_TIPOPERS,"
                    + "CT_USOIMBUEBLE,CT_TIPOFAC "
                    + "from vta_cliente where CT_ID = " + strCteId;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intCT_ID = rs.getInt("CT_ID");
               intCT_LPRECIOS = rs.getInt("CT_LPRECIOS");
               dblCT_DESCUENTO = rs.getDouble("CT_DESCUENTO");
               intCT_DIASCREDITO = rs.getInt("CT_DIASCREDITO");
               dblCT_MONTOCRED = rs.getDouble("CT_MONTOCRED");
               strCT_RAZONSOCIAL = rs.getString("CT_RAZONSOCIAL");
               intCT_TIPOPERS = rs.getInt("CT_TIPOPERS");
               intCT_TIPOFAC = rs.getInt("CT_TIPOFAC");
               strCT_USOIMBUEBLE = rs.getString("CT_USOIMBUEBLE");
               if (!strCT_RAZONSOCIAL.equals("")) {
                  strCT_RAZONSOCIAL = utilXML.Sustituye(strCT_RAZONSOCIAL);
               }
            }
            rs.close();
            //El detalle
            strXML += "<vta_clientes "
                    + " CT_ID = \"" + intCT_ID + "\"  "
                    + " CT_RAZONSOCIAL = \"" + strCT_RAZONSOCIAL + "\"  "
                    + " CT_LPRECIOS = \"" + intCT_LPRECIOS + "\"  "
                    + " CT_DESCUENTO = \"" + dblCT_DESCUENTO + "\"  "
                    + " CT_DIASCREDITO = \"" + intCT_DIASCREDITO + "\"  "
                    + " CT_MONTOCRED = \"" + dblCT_MONTOCRED + "\"  "
                    + " CT_TIPOPERS = \"" + intCT_TIPOPERS + "\"  "
                    + " CT_TIPOFAC = \"" + intCT_TIPOFAC + "\"  "
                    + " CT_USOIMBUEBLE = \"" + strCT_USOIMBUEBLE + "\"  "
                    + " />";
            strXML += "</vta_cliente>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Nos regresa los impuestos correspondientes a la sucursal seleccionada
         if (strid.equals("10")) {
            //Recuperamos el id del cliente
            String strSucId = request.getParameter("SC_ID");
            if (strSucId == null) {
               strSucId = "0";
            }
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_impuesto>";
            //Consultamos la info
            double dblTasa1 = 0;
            double dblTasa2 = 0;
            double dblTasa3 = 0;
            int intIdTasa1 = 0;
            int intIdTasa2 = 0;
            int intIdTasa3 = 0;
            int intSImp1_2 = 0;
            int intSImp1_3 = 0;
            int intSImp2_3 = 0;
            int intMoneda = 0;
            String strSql = "select SC_CLAVE,SC_NOMBRE,CT_ID,"
                    + "SC_TASA1,SC_TASA2,SC_TASA3,SC_SOBRIMP1_2,SC_SOBRIMP1_3,SC_SOBRIMP2_3,SC_DIVISA, "
                    + "TI_ID,TI_ID2,TI_ID3 "
                    + "from vta_sucursal where SC_ID = " + strSucId;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               dblTasa1 = rs.getDouble("SC_TASA1");
               dblTasa2 = rs.getDouble("SC_TASA2");
               dblTasa3 = rs.getDouble("SC_TASA3");
               intSImp1_2 = rs.getInt("SC_SOBRIMP1_2");
               intSImp1_3 = rs.getInt("SC_SOBRIMP1_3");
               intSImp2_3 = rs.getInt("SC_SOBRIMP2_3");
               intMoneda = rs.getInt("SC_DIVISA");
               intIdTasa1 = rs.getInt("TI_ID");
               intIdTasa2 = rs.getInt("TI_ID2");
               intIdTasa3 = rs.getInt("TI_ID3");
            }
            rs.close();
            //El detalle
            strXML += "<vta_impuestos "
                    + " SC_ID = \"" + strSucId + "\"  "
                    + " Tasa1 = \"" + dblTasa1 + "\"  "
                    + " Tasa2 = \"" + dblTasa2 + "\"  "
                    + " Tasa3 = \"" + dblTasa3 + "\"  "
                    + " TI_ID = \"" + intIdTasa1 + "\"  "
                    + " TI_ID2 = \"" + intIdTasa2 + "\"  "
                    + " TI_ID3 = \"" + intIdTasa3 + "\"  "
                    + " SImp1_2 = \"" + intSImp1_2 + "\"  "
                    + " SImp1_3 = \"" + intSImp1_3 + "\"  "
                    + " SImp2_3 = \"" + intSImp2_3 + "\"  "
                    + " Moneda = \"" + intMoneda + "\"  "
                    + " />";
            strXML += "</vta_impuesto>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Nos regresa la tasa de impuestos correspondientes a la tasa seleccionada
         if (strid.equals("11")) {
            //Recuperamos el id del cliente
            String strTI_ID = request.getParameter("TI_ID");
            if (strTI_ID == null) {
               strTI_ID = "0";
            }
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_impuesto>";
            //Consultamos la info
            double dblTasa1 = 0;
            String strSql = "select TI_TASA "
                    + "from vta_tasaiva where TI_ID = " + strTI_ID;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               dblTasa1 = rs.getDouble("TI_TASA");
            }
            rs.close();
            //El detalle
            strXML += "<vta_impuestos "
                    + " Tasa1 = \"" + dblTasa1 + "\"  "
                    + " />";
            strXML += "</vta_impuesto>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
      } else {
      }
      oConn.close();
%>