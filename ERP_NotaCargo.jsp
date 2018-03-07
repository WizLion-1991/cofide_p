<%-- 
    Document   : ERP_NotaCargo
Genera las operaciones para las notas de cargo
    Created on : 12-dic-2015, 12:38:16
    Author     : ZeusSIWEB
--%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="Tablas.VtaNotasCargosDeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.mx.siweb.erp.notascargo.NotasCargo"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
      String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
      String strClienteUniversal = this.getServletContext().getInitParameter("ClienteUniversal");
      String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
      String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
      String strPathBase = this.getServletContext().getRealPath("/");
      if (strfolio_GLOBAL == null) {
         strfolio_GLOBAL = "SI";
      }
      if (strmod_Inventarios == null) {
         strmod_Inventarios = "NO";
      }
      if (strSist_Costos == null) {
         strSist_Costos = "0";
      }
      if (strClienteUniversal == null) {
         strClienteUniversal = "0";
      }
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         if (strid.equals("1")) {
            //Instanciamos el objeto que generara la venta
            NotasCargo notaCargo = new NotasCargo(oConn, varSesiones, request);
            notaCargo.setStrPATHKeys(strPathPrivateKeys);
            notaCargo.setStrPATHXml(strPathXML);
            notaCargo.setStrPATHFonts(strPathFonts);
            notaCargo.setStrPATHBase(strPathBase);
            //Desactivamos inventarios
            if (strmod_Inventarios.equals("NO")) {
               notaCargo.setBolAfectaInv(false);
            }
            //Validamos si envian la peticion con la bandera de afectar inventarios
            if (request.getParameter("INV") != null) {
               if (request.getParameter("INV").equals("0")) {
                  notaCargo.setBolAfectaInv(false);
               }
            }
            //Definimos el sistema de costos
            try {
               notaCargo.setIntSistemaCostos(Integer.valueOf(strSist_Costos));
            } catch (NumberFormatException ex) {
               System.out.println("No hay sistema de costos definido");
            }
            //Recibimos parametros
            String strPrefijoMaster = "NCA";
            String strPrefijoDeta = "NCAD";

            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               notaCargo.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            }
            //Validamos si usaremos un folio global
            if (strfolio_GLOBAL.equals("NO")) {
               notaCargo.setBolFolioGlobal(false);
            }
            notaCargo.initMyPass(this.getServletContext());

            //Edicion de pedidos
            notaCargo.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
            notaCargo.getDocument().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CT_ID")));
            if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", 1);
            } else {
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
            }

            //Categoria del cliente
            String strCCID1 = request.getParameter("CC1_ID");
            if (strCCID1 != null) {
               notaCargo.getDocument().setFieldInt("CC1_ID", Integer.valueOf(request.getParameter("CC1_ID")));
            }
            //Clave de vendedor
            int intVE_ID = 0;
            try {
               intVE_ID = Integer.valueOf(request.getParameter("VE_ID"));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Ventas VE_ID " + ex.getMessage());
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
               System.out.println("ERP_Ventas TI_ID " + ex.getMessage());
            }
            //Tipo de comprobante
            int intFAC_TIPOCOMP = 0;
            try {
               intFAC_TIPOCOMP = Integer.valueOf(request.getParameter("FAC_TIPOCOMP"));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Ventas FAC_TIPOCOMP " + ex.getMessage());
            }
            //Asignamos los valores al objeto
            notaCargo.getDocument().setFieldInt("VE_ID", intVE_ID);
            notaCargo.getDocument().setFieldInt("TI_ID", intTI_ID);
            notaCargo.getDocument().setFieldInt("TI_ID2", intTI_ID2);
            notaCargo.getDocument().setFieldInt("TI_ID3", intTI_ID3);
            notaCargo.setIntFAC_TIPOCOMP(intFAC_TIPOCOMP);
            notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_ESSERV", Integer.valueOf(request.getParameter(strPrefijoMaster + "_ESSERV")));
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA"), "/"));
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FOLIO_C", request.getParameter(strPrefijoMaster + "_FOLIO"));
            final String strNotas = URLDecoder.decode(new String(request.getParameter(strPrefijoMaster + "_NOTAS").getBytes(
               "iso-8859-1")), "UTF-8");
            final String strNotasPie = URLDecoder.decode(new String(request.getParameter(strPrefijoMaster + "_NOTASPIE").getBytes(
               "iso-8859-1")), "UTF-8");
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", strNotas);
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", strNotasPie);
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));
            if (request.getParameter(strPrefijoMaster + "_METODOPAGO") != null) {
               notaCargo.getDocument().setFieldString(strPrefijoMaster + "_METODODEPAGO", request.getParameter(strPrefijoMaster + "_METODOPAGO"));
            }
            if (request.getParameter(strPrefijoMaster + "_NUMCUENTA") != null) {
               notaCargo.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", request.getParameter(strPrefijoMaster + "_NUMCUENTA"));
            }
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", request.getParameter(strPrefijoMaster + "_FORMADEPAGO"));
            //notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", "En una sola Exhibicion");
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE")));
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO1")));
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO2")));
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO3")));
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(request.getParameter(strPrefijoMaster + "_TOTAL")));
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA1")));
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA2")));
            notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA3")));
            if (request.getParameter(strPrefijoMaster + "_TASAPESO") != null) {
               if (Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")) == 0) {
                  notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
               } else {
                  notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")));
               }
            } else {
               notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
            }
            //Validamos IEPS
            if (request.getParameter(strPrefijoMaster + "_USO_IEPS") != null) {
               try {
                  notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_USO_IEPS")));
                  notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TASA_IEPS")));
                  notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE_IEPS")));
               } catch (NumberFormatException ex) {
               }
            }
            //Validamos CONSIGNACION
            if (request.getParameter(strPrefijoMaster + "_CONSIGNACION") != null) {
               try {
                  notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_CONSIGNACION", Integer.valueOf(request.getParameter(strPrefijoMaster + "_CONSIGNACION")));
               } catch (NumberFormatException ex) {
               }
            }
            //Validamos Porcentaje de descuento global
            if (request.getParameter(strPrefijoMaster + "_POR_DESC") != null) {
               try {
                  notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_POR_DESCUENTO", Double.valueOf(request.getParameter(strPrefijoMaster + "_POR_DESC")));
               } catch (NumberFormatException ex) {
               }
            }
            //Validamos MLM
            if (request.getParameter(strPrefijoMaster + "_PUNTOS") != null) {
               try {
                  notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_PUNTOS", Double.valueOf(request.getParameter(strPrefijoMaster + "_PUNTOS")));
                  notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_NEGOCIO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NEGOCIO")));
               } catch (NumberFormatException ex) {
               }
            }

            //DATOS EXTRA PARA CLIENTES-FLETES
            if (request.getParameter("FAC_USO_FLETE") != null) {
               if (request.getParameter("FAC_USO_FLETE").equals("1")) {
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_PESO", request.getParameter("FAC_FLETE_PESO"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_VOLUMEN", request.getParameter("FAC_FLETE_VOLUMEN"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_NUM_PEDIMENTO", request.getParameter("FAC_FLETE_NUM_PEDIMENTO"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_INDEMNIZACION", request.getParameter("FAC_FLETE_INDEMNIZACION"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_REMBARCO", request.getParameter("FAC_FLETE_REMBARCO"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_FEC_PEDIMENTO", request.getParameter("FAC_FLETE_FEC_PEDIMENTO"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_REEMBARCARSE", request.getParameter("FAC_FLETE_REEMBARCARSE"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_CARTA_NUMPORTE", request.getParameter("FAC_FLETE_CARTA_NUMPORTE"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_CAMION_NUMPLACAS", request.getParameter("FAC_FLETE_CAMION_NUMPLACAS"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_CLIENTE_RETENEDOR", request.getParameter("FAC_FLETE_CLIENTE_RETENEDOR"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_DOMICILIO", request.getParameter("FAC_FLETE_DOMICILIO"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_RFC", request.getParameter("FAC_FLETE_RFC"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_ENTREGA_EN", request.getParameter("FAC_FLETE_ENTREGA_EN"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_FEC_PREV_ENTREGA", request.getParameter("FAC_FLETE_FEC_PREV_ENTREGA"));
                  notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FLETE_OPERADOR", request.getParameter("FAC_FLETE_OPERADOR"));
               }
            }
            //USO DE FLETES

            //uso email
            if (request.getParameter("ADD_EMAIL") != null) {//
               if (request.getParameter("ADD_EMAIL").equals("1")) {
                  boolean blEmail1 = false;
                  boolean blEmail2 = false;
                  boolean blEmail3 = false;
                  boolean blEmail4 = false;
                  boolean blEmail5 = false;
                  boolean blEmail6 = false;
                  boolean blEmail7 = false;
                  boolean blEmail8 = false;
                  boolean blEmail9 = false;
                  boolean blEmail10 = false;
                  if (request.getParameter("FAC_EMAIL1").equals("true")) {
                     blEmail1 = true;
                  }
                  if (request.getParameter("FAC_EMAIL2").equals("true")) {
                     blEmail2 = true;
                  }
                  if (request.getParameter("FAC_EMAIL3").equals("true")) {
                     blEmail3 = true;
                  }
                  if (request.getParameter("FAC_EMAIL4").equals("true")) {
                     blEmail4 = true;
                  }
                  if (request.getParameter("FAC_EMAIL5").equals("true")) {
                     blEmail5 = true;
                  }
                  if (request.getParameter("FAC_EMAIL6").equals("true")) {
                     blEmail6 = true;
                  }
                  if (request.getParameter("FAC_EMAIL7").equals("true")) {
                     blEmail7 = true;
                  }
                  if (request.getParameter("FAC_EMAIL8").equals("true")) {
                     blEmail8 = true;
                  }
                  if (request.getParameter("FAC_EMAIL9").equals("true")) {
                     blEmail9 = true;
                  }
                  if (request.getParameter("FAC_EMAIL10").equals("true")) {
                     blEmail10 = true;
                  }
                  notaCargo.setBlEmail1(blEmail1);
                  notaCargo.setBlEmail2(blEmail2);
                  notaCargo.setBlEmail3(blEmail3);
                  notaCargo.setBlEmail4(blEmail4);
                  notaCargo.setBlEmail5(blEmail5);
                  notaCargo.setBlEmail6(blEmail6);
                  notaCargo.setBlEmail7(blEmail7);
                  notaCargo.setBlEmail8(blEmail8);
                  notaCargo.setBlEmail9(blEmail9);
                  notaCargo.setBlEmail10(blEmail10);
               }
            }

            //uso email
            //Datos de la aduana
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_NUMPEDI", request.getParameter(strPrefijoMaster + "_NUMPEDI"));
            String strFechaPedimento = request.getParameter(strPrefijoMaster + "_FECHAPEDI");
            if (strFechaPedimento.contains("/") && strFechaPedimento.length() == 10) {
               strFechaPedimento = fecha.FormateaBD(strFechaPedimento, "/");
            }
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", strFechaPedimento);
            notaCargo.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", request.getParameter(strPrefijoMaster + "_ADUANA"));
            //Si no hay moneda seleccionada que ponga tasa 1
            if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
               notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
            }
            if (request.getParameter(strPrefijoMaster + "_DIASCREDITO") != null) {
               if (Double.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")) == 0) {
                  notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", 1);
               } else {
                  notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", Integer.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")));
               }
            }
            //Direccion de entrega
            if (request.getParameter("CDE_ID") != null) {
               try {
                  notaCargo.getDocument().setFieldInt("CDE_ID", Integer.valueOf(request.getParameter("CDE_ID")));
               } catch (NumberFormatException ex) {
                  System.out.println("Ventas CDE_ID " + ex.getMessage());
               }
            }
            //Cliente final
            if (request.getParameter("DFA_ID") != null) {
               try {
                  notaCargo.getDocument().setFieldInt("DFA_ID", Integer.valueOf(request.getParameter("DFA_ID")));
               } catch (NumberFormatException ex) {
                  System.out.println("Ventas CT_CLIENTEFINAL " + ex.getMessage());
               }
            }
            /*Campos flete, transportista , num guia VENTAS*/
            try {
               notaCargo.getDocument().setFieldInt("TR_ID", Integer.valueOf(request.getParameter("TR_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras TR_ID " + ex.getMessage());
            }
            try {
               notaCargo.getDocument().setFieldInt("ME_ID", Integer.valueOf(request.getParameter("ME_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras ME_ID " + ex.getMessage());
            }
            try {
               notaCargo.getDocument().setFieldInt("TF_ID", Integer.valueOf(request.getParameter("TF_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras TF_ID " + ex.getMessage());
            }
            if (request.getParameter(strPrefijoMaster + "_NUM_GUIA") != null) {
               notaCargo.getDocument().setFieldString(strPrefijoMaster + "_NUM_GUIA", request.getParameter(strPrefijoMaster + "_NUM_GUIA"));
            }
            //Validamos parametros para recibos de honorarios}
            if (request.getParameter(strPrefijoMaster + "_RETISR") != null) {
               notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_RETISR", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETISR")));
            }
            if (request.getParameter(strPrefijoMaster + "_RETIVA") != null) {
               notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_RETIVA", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETIVA")));
            }
            if (request.getParameter(strPrefijoMaster + "_NETO") != null) {
               notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_NETO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NETO")));
            }
            //Opciones de facturacion recurrente
            if (request.getParameter(strPrefijoMaster + "_ESRECU") != null) {
               int intEsRecu = 0;
               int intPeriodicidad = 1;
               int intDiaPer = 1;
               int intNumEventos = 0;
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
               try {
                  intNumEventos = Integer.valueOf(request.getParameter(strPrefijoMaster + "_NO_EVENTOS"));
               } catch (NumberFormatException ex) {
                  System.out.println("Ventas: Error convertir campo " + strPrefijoMaster + "_NO_EVENTOS" + " " + ex.getMessage());
               }
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_ESRECU", intEsRecu);
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_PERIODICIDAD", intPeriodicidad);
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_DIAPER", intDiaPer);
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_NO_EVENTOS", intNumEventos);
            }
            //Recibimos el regimen fiscal
            if (request.getParameter(strPrefijoMaster + "_REGIMENFISCAL") != null) {
               notaCargo.getDocument().setFieldString(strPrefijoMaster + "_REGIMENFISCAL", request.getParameter(strPrefijoMaster + "_REGIMENFISCAL"));
            }
            //Recibimos la serie por guardar...
            if (request.getParameter(strPrefijoMaster + "_SERIE") != null) {
               notaCargo.getDocument().setFieldString(strPrefijoMaster + "_SERIE", request.getParameter(strPrefijoMaster + "_SERIE"));
            }
            //Recibimos el turno de la operacion
            if (request.getParameter(strPrefijoMaster + "_TURNO") != null) {
               try {
                  notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_TURNO", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TURNO")));
               } catch (NumberFormatException ex) {
                  System.out.println("Error al convertir turno");
               }
            }
            //Periodos para los multiniveles
            Periodos periodo = new Periodos();
            notaCargo.getDocument().setFieldInt("MPE_ID", periodo.getPeriodoActual(oConn));
            //Recibimos datos de los items o partidas
            int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
            for (int i = 1; i <= intCount; i++) {
               TableMaster deta = null;

               deta = new VtaNotasCargosDeta();

               deta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
               deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO1" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO2" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO3" + i)));
               deta.setFieldInt(strPrefijoDeta + "_ESREGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESREGALO" + i)));
               deta.setFieldString(strPrefijoDeta + "_CVE", request.getParameter(strPrefijoDeta + "_CVE" + i));
               final String strDescripcion = URLDecoder.decode(new String(request.getParameter(strPrefijoDeta + "_DESCRIPCION" + i).getBytes(
                  "iso-8859-1")), "UTF-8");
               final String strNotasDeta = URLDecoder.decode(new String(request.getParameter(strPrefijoDeta + "_NOTAS" + i).getBytes(
                  "iso-8859-1")), "UTF-8");
               deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", strDescripcion);
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
               //Retencion de ISR
               if (request.getParameter(strPrefijoDeta + "_RET_ISR" + i) != null) {
                  try {
                     deta.setFieldDouble(strPrefijoDeta + "_RET_ISR", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_ISR" + i)));
                     deta.setFieldDouble(strPrefijoDeta + "_RET_IVA", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_IVA" + i)));
                     deta.setFieldDouble(strPrefijoDeta + "_RET_FLETE", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_FLETE" + i)));
                  } catch (NumberFormatException ex) {
                     System.out.println("EN ERP_Ventas falta definir retencion ISR");
                  }

               }
               deta.setFieldInt(strPrefijoDeta + "_PRECFIJO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_PRECFIJO" + i)));
               deta.setFieldInt(strPrefijoDeta + "_ESREGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESREGALO" + i)));
               deta.setFieldString(strPrefijoDeta + "_COMENTARIO", strNotasDeta);
               //UNIDAD DE MEDIDA UNIDAD_MEDIDA
               if (request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i) != null) {
                  deta.setFieldString(strPrefijoDeta + "_UNIDAD_MEDIDA", request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i));
               }
               //ID DE SERVICIO
               if (request.getParameter(strPrefijoDeta + "_CF_ID" + i) != null) {
                  deta.setFieldString("CF_ID", request.getParameter(strPrefijoDeta + "_CF_ID" + i));
               }
               //Evaluamos si envian el id del pedido
               if (request.getParameter("PDD_ID" + i) != null) {
                  deta.setFieldInt("PDD_ID", Integer.valueOf(request.getParameter("PDD_ID" + i)));
               }
               //Validamos MLM
               if (request.getParameter(strPrefijoDeta + "_PUNTOS" + i) != null) {
                  try {
                     deta.setFieldDouble(strPrefijoDeta + "_PUNTOS", Double.valueOf(request.getParameter(strPrefijoDeta + "_PUNTOS" + i)));
                     deta.setFieldDouble(strPrefijoDeta + "_VNEGOCIO", Double.valueOf(request.getParameter(strPrefijoDeta + "_VNEGOCIO" + i)));
                     deta.setFieldDouble(strPrefijoDeta + "_IMP_PUNTOS", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMP_PUNTOS" + i)));
                     deta.setFieldDouble(strPrefijoDeta + "_IMP_VNEGOCIO", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMP_VNEGOCIO" + i)));
                     deta.setFieldInt(strPrefijoDeta + "_DESC_PUNTOS", Integer.valueOf(request.getParameter(strPrefijoDeta + "_DESC_PTO" + i)));
                     deta.setFieldInt(strPrefijoDeta + "_DESC_VNEGOCIO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_DESC_VN" + i)));
                  } catch (NumberFormatException ex) {
                     System.out.println("Error al recuperar los valores de MLM " + ex.getMessage() + " " + ex.getLocalizedMessage() + " " + ex.toString());
                     ex.fillInStackTrace();
                  }
               }
               if (request.getParameter(strPrefijoDeta + "_DESC_PREC" + i) != null) {
                  try {
                     deta.setFieldDouble(strPrefijoDeta + "_DESC_ORI", Double.valueOf(request.getParameter(strPrefijoDeta + "_DESC_ORI" + i)));
                     deta.setFieldInt(strPrefijoDeta + "_DESC_PREC", Integer.valueOf(request.getParameter(strPrefijoDeta + "_DESC_PREC" + i)));
                     deta.setFieldInt(strPrefijoDeta + "_REGALO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_REGALO" + i)));
                     deta.setFieldInt(strPrefijoDeta + "_ID_PROMO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ID_PROMO" + i)));
                  } catch (NumberFormatException ex) {
                     System.out.println("Error al recuperar los valores de MLM " + ex.getMessage() + " " + ex.getLocalizedMessage() + " " + ex.toString());
                     ex.fillInStackTrace();
                  }
               }

               //Validamos si estan enviando los numeros de serie de facturas
               if (request.getParameter(strPrefijoDeta + "_SERIES_MPD" + i) != null) {
                  String[] lstSeriesMPD = request.getParameter(strPrefijoDeta + "_SERIES_MPD" + i).split(",");
                  for (int iSerM = 0; iSerM < lstSeriesMPD.length; iSerM++) {
                     int intMPD_ID = 0;
                     try {
                        intMPD_ID = Integer.valueOf(lstSeriesMPD[iSerM]);
                        notaCargo.addItemLstSeries(intMPD_ID);
                     } catch (NumberFormatException ex) {
                     }
                  }

               }
               //
               notaCargo.AddDetalle(deta);
            }
            //Obtenemos los datos de los anticipos
            //Si llega el campo de pedido entonces estamos editando un pedido
            if (request.getParameter("MCD_NUMANTICIPOS") != null) {
               int intNumAnti = Integer.parseInt(request.getParameter("MCD_NUMANTICIPOS"));
               notaCargo.setNumAnticipos(intNumAnti);
               int[] arID_ANTICIPO = new int[intNumAnti];
               double[] arTotalAntUsar = new double[intNumAnti];
               for (int i = 1; i <= intNumAnti; i++) {
                  arID_ANTICIPO[i - 1] = Integer.parseInt(request.getParameter("MCD_IDANTICIPO" + i));
                  arTotalAntUsar[i - 1] = Float.parseFloat(request.getParameter("MCD_CANTUSAR" + i));
               }
               notaCargo.setArID_Ant(arID_ANTICIPO);
               notaCargo.setArTotalAntUsar(arTotalAntUsar);
            }

            //Inicializamos objeto
            notaCargo.Init();
            //Generamos transaccion
            notaCargo.doTrx();
            String strRes = "";
            if (notaCargo.getStrResultLast().equals("OK")) {
               strRes = "OK." + notaCargo.getDocument().getValorKey();
            } else {
               strRes = notaCargo.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Termina opcion 1
         //Anula la operacion
         if (strid.equals("2")) {
            //Instanciamos la nota de cargo
            NotasCargo notaCargo = new NotasCargo(oConn, varSesiones, request);
            notaCargo.setStrPATHKeys(strPathPrivateKeys);
            notaCargo.setStrPATHXml(strPathXML);
            notaCargo.initMyPass(this.getServletContext());
            //Recibimos parametros
            String strPrefijoMaster = "NCA";
            //Asignamos el id de la operacion por anular
            String strIdAnul = request.getParameter("idAnul");
            int intId = 0;
            if (strIdAnul == null) {
               strIdAnul = "0";
            }
            intId = Integer.valueOf(strIdAnul);
            notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
            notaCargo.Init();
            notaCargo.doTrxAnul();
            String strRes = notaCargo.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }

      }
   } else {
   }
   oConn.close();
%>