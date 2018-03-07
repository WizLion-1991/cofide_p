<%-- 
    Document   : ERP_Ventas
      Realiza todas las operaciones que tienen que ver con ventas como son TICKETS FACTURAS PEDIDOS COTIZACIONES
    Created on : 21/06/2010, 06:39:31 PM
    Author     : zeus
--%>

<%@page import="org.apache.struts.Globals"%>
<%@page import="org.apache.struts.util.PropertyMessageResources"%>
<%@page import="org.apache.struts.chain.contexts.ActionContext"%>
<%@page import="ERP.FacturaMasivaPedidos"%>
<%@page import="comSIWeb.Operaciones.Bitacora"%>
<%@page import="Core.FirmasElectronicas.Addendas.SATAddendaSanofi"%>
<%@page import="Tablas.vta_cotiza"%>
<%@page import="org.apache.struts.util.MessageResources"%>
<%@page import="com.SIWeb.struts.SelEmpresaAction"%>
<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="ERP.FacturaContratos"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="Core.FirmasElectronicas.Addendas.SATAddendaFemsa"%>
<%@page import="Core.FirmasElectronicas.SATXml3_0"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="Tablas.vta_pedidos_cajas_master"%>
<%@page import="Tablas.vta_pedidos_cajas"%>
<%@page import="ERP.Folios"%>
<%@page import="Core.FirmasElectronicas.SATXmlLala"%>
<%@page import="Core.FirmasElectronicas.Addendas.SATAddendaMabe"%>
<%@page import="Core.FirmasElectronicas.SATXml"%>
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
      String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
      String strClienteUniversal = this.getServletContext().getInitParameter("ClienteUniversal");
      String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
      String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
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
         // <editor-fold defaultstate="collapsed" desc="Genera una nueva operacion de ventas">
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
            //Validamos si envian la peticion con la bandera de afectar inventarios
            if (request.getParameter("INV") != null) {
               if (request.getParameter("INV").equals("0")) {
                  ticket.setBolAfectaInv(false);
               }
            }
            //Definimos el sistema de costos
            try {
               ticket.setIntSistemaCostos(Integer.valueOf(strSist_Costos));
            } catch (NumberFormatException ex) {
               System.out.println("No hay sistema de costos definido");
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
            if (strTipoVta.equals("5")) {
               strPrefijoMaster = "COT";
               strPrefijoDeta = "COTD";
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
            if (request.getParameter("PD_ID") != null) {
               //Validamos si recibimos una lista de pedidos
               if (request.getParameter("FAC_PEDI") != null) {
                  if (request.getParameter("FAC_PEDI").contains("1")) {
                     ticket.getListPedidos(request.getParameter("PD_ID"));
                  }
               } else {
                  try {
                     intPD_ID = Integer.valueOf(request.getParameter("PD_ID"));
                  } catch (NumberFormatException ex) {
                     System.out.println("ERP_Ventas PD_ID " + ex.getMessage());
                  }
               }

            }
            ticket.setIntPedidoGenero(intPD_ID);
            if (strTipoVta.equals("1") || strTipoVta.equals("2")) {
               ticket.getDocument().setFieldInt("PD_ID", intPD_ID);
            } else //Edicion de un pedido
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
            //Edicion de pedidos
            //Edición de cotizacion
            int intCOT_ID = 0;
            if (request.getParameter("COT_ID") != null) {

               try {
                  intCOT_ID = Integer.valueOf(request.getParameter("COT_ID"));
               } catch (NumberFormatException ex) {
                  System.out.println("ERP_Ventas COT_ID " + ex.getMessage());
               }

               if (strTipoVta.equals("1") || strTipoVta.equals("2") || strTipoVta.equals("3")) {
                  ticket.getDocument().setFieldInt("COT_ID", intCOT_ID);
               } else //Edicion de una cotizacion
                if (strTipoVta.equals("5")) {
                     //Si llega el campo de pedido entonces estamos editando un pedido
                     if (request.getParameter("COT_ID") != null) {
                        ticket.getDocument().setFieldInt("COT_ID", intCOT_ID);
                        //Validamos si la modificacion de una cotizacion
                        if (ticket.getDocument().getFieldInt("COT_ID") != 0) {
                           //Generamos transaccion
                           ticket.getDocument().setValorKey(ticket.getDocument().getFieldInt("COT_ID") + "");
                           ticket.Init();
                        }
                     }
                  }
            }

            //Edicion de pedidos
            ticket.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
            ticket.getDocument().setFieldInt("CT_ID", Integer.valueOf(request.getParameter("CT_ID")));
            if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", 1);
            } else {
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
            }

            //Categoria del cliente
            String strCCID1 = request.getParameter("CC1_ID");
            if (strCCID1 != null) {
               ticket.getDocument().setFieldInt("CC1_ID", Integer.valueOf(request.getParameter("CC1_ID")));
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
            ticket.getDocument().setFieldInt("VE_ID", intVE_ID);
            ticket.getDocument().setFieldInt("TI_ID", intTI_ID);
            ticket.getDocument().setFieldInt("TI_ID2", intTI_ID2);
            ticket.getDocument().setFieldInt("TI_ID3", intTI_ID3);
            ticket.setIntFAC_TIPOCOMP(intFAC_TIPOCOMP);
            ticket.getDocument().setFieldInt(strPrefijoMaster + "_ESSERV", Integer.valueOf(request.getParameter(strPrefijoMaster + "_ESSERV")));
            ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA"), "/"));
            ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
            ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO_C", request.getParameter(strPrefijoMaster + "_FOLIO"));
            final String strNotas = URLDecoder.decode(new String(request.getParameter(strPrefijoMaster + "_NOTAS").getBytes(
               "iso-8859-1")), "UTF-8");
            final String strNotasPie = URLDecoder.decode(new String(request.getParameter(strPrefijoMaster + "_NOTASPIE").getBytes(
               "iso-8859-1")), "UTF-8");
            ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", strNotas);
            ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", strNotasPie);
            ticket.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));
            ticket.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));
            if (request.getParameter(strPrefijoMaster + "_METODOPAGO") != null) {
               ticket.getDocument().setFieldString(strPrefijoMaster + "_METODODEPAGO", request.getParameter(strPrefijoMaster + "_METODOPAGO"));
            }
            if (request.getParameter(strPrefijoMaster + "_NUMCUENTA") != null) {
               ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", request.getParameter(strPrefijoMaster + "_NUMCUENTA"));
            }
            ticket.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", request.getParameter(strPrefijoMaster + "_FORMADEPAGO"));
            //ticket.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", "En una sola Exhibicion");
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE")));
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO1")));
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO2")));
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO3")));
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(request.getParameter(strPrefijoMaster + "_TOTAL")));
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA1")));
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA2")));
            ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA3")));
            if (request.getParameter(strPrefijoMaster + "_TASAPESO") != null) {
               if (Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")) == 0) {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
               } else {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")));
               }
            } else {
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
            }
            //Validamos IEPS
            if (request.getParameter(strPrefijoMaster + "_USO_IEPS") != null) {
               try {
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_USO_IEPS")));
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TASA_IEPS")));
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE_IEPS")));
               } catch (NumberFormatException ex) {
               }
            }
            //Validamos CONSIGNACION
            if (request.getParameter(strPrefijoMaster + "_CONSIGNACION") != null) {
               try {
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_CONSIGNACION", Integer.valueOf(request.getParameter(strPrefijoMaster + "_CONSIGNACION")));
               } catch (NumberFormatException ex) {
               }
            }
            //Validamos Porcentaje de descuento global
            if (request.getParameter(strPrefijoMaster + "_POR_DESC") != null) {
               try {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_POR_DESCUENTO", Double.valueOf(request.getParameter(strPrefijoMaster + "_POR_DESC")));
               } catch (NumberFormatException ex) {
               }
            }
            //Validamos MLM
            if (request.getParameter(strPrefijoMaster + "_PUNTOS") != null) {
               try {
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_PUNTOS", Double.valueOf(request.getParameter(strPrefijoMaster + "_PUNTOS")));
                  ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_NEGOCIO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NEGOCIO")));
               } catch (NumberFormatException ex) {
               }
            }
            //CRM Y COTIZACIONES
            if (strTipoVtaNom.equals(Ticket.COTIZACION)) {
               if (request.getParameter("SYC_ID") != null) {
                  try {
                     ticket.getDocument().setFieldInt("SYC_ID", Integer.valueOf(request.getParameter("SYC_ID")));
                  } catch (NumberFormatException ex) {
                  }
               }
            }
            //Addenda MABE
            if (request.getParameter("ADD_MABE") != null) {
               if (request.getParameter("ADD_MABE").equals("1")) {
                  ticket.getDocument().setFieldString("MB_CODIGOPROVEEDOR", request.getParameter("MB_CODIGOPROVEEDOR"));
                  ticket.getDocument().setFieldString("MB_PLANTA", request.getParameter("MB_PLANTA"));
                  ticket.getDocument().setFieldString("MB_CALLE", request.getParameter("MB_CALLE"));
                  ticket.getDocument().setFieldString("MB_NO_EXT", request.getParameter("MB_NO_EXT"));
                  ticket.getDocument().setFieldString("MB_NO_INT", request.getParameter("MB_NO_INT"));
                  ticket.getDocument().setFieldString("MB_ORDENCOMPRA", request.getParameter("MB_ORDENCOMPRA"));
                  if (request.getParameter("MB_REFERENCIA1") != null) {
                     ticket.getDocument().setFieldString("MB_REFERENCIA1", request.getParameter("MB_REFERENCIA1"));
                  }
                  if (request.getParameter("MB_REFERENCIA2") != null) {
                     ticket.getDocument().setFieldString("MB_REFERENCIA2", request.getParameter("MB_REFERENCIA2"));
                  }

                  //Agregamos objetos para la addenda
                  SATXml3_0 satXml3 = new SATXml3_0();
                  satXml3.setStrPathConfigPAC(strPathPrivateKeys);
                  SATAddendaMabe mabe = new SATAddendaMabe();
                  satXml3.setSatAddenda(mabe, null);
                  ticket.setSAT(satXml3);

               }
            }
            //Adenda AMECE
            if (request.getParameter("ADD_AMECE") != null) {
               if (request.getParameter("ADD_AMECE").equals("1")) {
                  ticket.getDocument().setFieldString("HM_ON", request.getParameter("HM_ON"));
                  ticket.getDocument().setFieldString("HM_DIV", request.getParameter("HM_DIV"));
                  ticket.getDocument().setFieldString("HM_SOC", request.getParameter("HM_SOC"));
                  ticket.getDocument().setFieldString("HM_REFERENCEDATE", request.getParameter("HM_REFERENCEDATE"));
                  ticket.getDocument().setFieldString("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY", request.getParameter("HM_SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY"));
                  ticket.getDocument().setFieldString("HM_NAME", request.getParameter("HM_NAME"));
                  ticket.getDocument().setFieldString("HM_STREET", request.getParameter("HM_STREET"));
                  ticket.getDocument().setFieldString("HM_CITY", request.getParameter("HM_CITY"));
                  ticket.getDocument().setFieldString("HM_POSTALCODE", request.getParameter("HM_POSTALCODE"));
                  //Agregamos objetos para la addenda
                  SATXmlLala satGen = new SATXmlLala();
                  satGen.setStrPathConfigPAC(strPathPrivateKeys);
                  ticket.setSAT(satGen);
               }
            }
            //Adenda FEMSA
            if (request.getParameter("ADD_FEMSA") != null) {
               if (request.getParameter("ADD_FEMSA").equals("1")) {
                  ticket.getDocument().setFieldString("FEM_VER", "01");
                  ticket.getDocument().setFieldString("FEM_TIPO", request.getParameter("FEM_TIPO"));
                  ticket.getDocument().setFieldString("FEM_SOC", request.getParameter("FEM_SOC"));
                  ticket.getDocument().setFieldString("FEM_NUM_PROV", request.getParameter("FEM_NUM_PROV"));
                  ticket.getDocument().setFieldString("FEM_NUM_PED", request.getParameter("FEM_NUM_PED"));
                  ticket.getDocument().setFieldString("FEM_MONEDA", request.getParameter("FEM_MONEDA"));
                  ticket.getDocument().setFieldString("FEM_NUM_ENTR_SAP", request.getParameter("FEM_NUM_ENTR_SAP"));
                  ticket.getDocument().setFieldString("FEM_NUM_REMI", request.getParameter("FEM_NUM_REMI"));
                  if (request.getParameter("REM_RET") != null) {
                     ticket.getDocument().setFieldString("FEM_RET", request.getParameter("REM_RET"));
                  }
                  ticket.getDocument().setFieldString("FEM_CORREO", request.getParameter("FEM_CORREO"));
                  //Agregamos objetos para la addenda
                  SATXml3_0 satXml3 = new SATXml3_0();
                  satXml3.setStrPathConfigPAC(strPathPrivateKeys);
                  SATAddendaFemsa femsa = new SATAddendaFemsa();
                  satXml3.setSatAddenda(femsa, null);
                  ticket.setSAT(satXml3);
               }
            }

            //ADDENDA SANODI
            if (request.getParameter("ADD_SANOFI") != null) {
               if (request.getParameter("ADD_SANOFI").equals("1")) {
                  if (request.getParameter("USA_SANOFI1") != null) {
                     ticket.getDocument().setFieldInt("USA_SANOFI", 1);
                     ticket.getDocument().setFieldString("SNF_NUM_PROV", request.getParameter("SNF_NUM_PROV"));
                     ticket.getDocument().setFieldString("SNF_NUM_ODC", request.getParameter("SNF_NUM_ODC"));
                     ticket.getDocument().setFieldString("SNF_NUM_SOL", request.getParameter("SNF_NUM_SOL"));
                  }
                  if (request.getParameter("USA_SANOFI2") != null) {
                     ticket.getDocument().setFieldInt("USA_SANOFI", 1);
                     ticket.getDocument().setFieldString("SNF_NUM_PROV", request.getParameter("SNF_NUM_PROV"));
                     ticket.getDocument().setFieldString("SNF_NUM_SOL", request.getParameter("SNF_NUM_SOL"));
                     ticket.getDocument().setFieldString("SNF_CUENTA_PUENTE", request.getParameter("SNF_CUENTA_PUENTE"));
                  }
                  //Agregamos objetos para la addenda
                  SATXml3_0 satXml3 = new SATXml3_0();
                  satXml3.setStrPathConfigPAC(strPathPrivateKeys);
                  SATAddendaSanofi sanofi = new SATAddendaSanofi();
                  satXml3.setSatAddenda(sanofi, null);
                  ticket.setSAT(satXml3);
               }
            }
            //DATOS EXTRA PARA CLIENTES-FLETES
            if (request.getParameter("FAC_USO_FLETE") != null) {
               if (request.getParameter("FAC_USO_FLETE").equals("1")) {
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_PESO", request.getParameter("FAC_FLETE_PESO"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_VOLUMEN", request.getParameter("FAC_FLETE_VOLUMEN"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_NUM_PEDIMENTO", request.getParameter("FAC_FLETE_NUM_PEDIMENTO"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_INDEMNIZACION", request.getParameter("FAC_FLETE_INDEMNIZACION"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_REMBARCO", request.getParameter("FAC_FLETE_REMBARCO"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_FEC_PEDIMENTO", request.getParameter("FAC_FLETE_FEC_PEDIMENTO"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_REEMBARCARSE", request.getParameter("FAC_FLETE_REEMBARCARSE"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_CARTA_NUMPORTE", request.getParameter("FAC_FLETE_CARTA_NUMPORTE"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_CAMION_NUMPLACAS", request.getParameter("FAC_FLETE_CAMION_NUMPLACAS"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_CLIENTE_RETENEDOR", request.getParameter("FAC_FLETE_CLIENTE_RETENEDOR"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_DOMICILIO", request.getParameter("FAC_FLETE_DOMICILIO"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_RFC", request.getParameter("FAC_FLETE_RFC"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_ENTREGA_EN", request.getParameter("FAC_FLETE_ENTREGA_EN"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_FEC_PREV_ENTREGA", request.getParameter("FAC_FLETE_FEC_PREV_ENTREGA"));
                  ticket.getDocument().setFieldString(strPrefijoMaster + "_FLETE_OPERADOR", request.getParameter("FAC_FLETE_OPERADOR"));
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
                  ticket.setBlEmail1(blEmail1);
                  ticket.setBlEmail2(blEmail2);
                  ticket.setBlEmail3(blEmail3);
                  ticket.setBlEmail4(blEmail4);
                  ticket.setBlEmail5(blEmail5);
                  ticket.setBlEmail6(blEmail6);
                  ticket.setBlEmail7(blEmail7);
                  ticket.setBlEmail8(blEmail8);
                  ticket.setBlEmail9(blEmail9);
                  ticket.setBlEmail10(blEmail10);
               }
            }

            //uso email
            //Datos de la aduana
            ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMPEDI", request.getParameter(strPrefijoMaster + "_NUMPEDI"));
            String strFechaPedimento = request.getParameter(strPrefijoMaster + "_FECHAPEDI");
            if (strFechaPedimento.contains("/") && strFechaPedimento.length() == 10) {
               strFechaPedimento = fecha.FormateaBD(strFechaPedimento, "/");
            }
            ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", strFechaPedimento);
            ticket.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", request.getParameter(strPrefijoMaster + "_ADUANA"));
            //Si no hay moneda seleccionada que ponga tasa 1
            if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
               ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
            }
            if (request.getParameter(strPrefijoMaster + "_DIASCREDITO") != null) {
               if (Double.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")) == 0) {
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", 1);
               } else {
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", Integer.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")));
               }
            }
            //Direccion de entrega
            if (request.getParameter("CDE_ID") != null) {
               try {
                  ticket.getDocument().setFieldInt("CDE_ID", Integer.valueOf(request.getParameter("CDE_ID")));
               } catch (NumberFormatException ex) {
                  System.out.println("Ventas CDE_ID " + ex.getMessage());
               }
            }
            //Cliente final
            if (request.getParameter("DFA_ID") != null) {
               try {
                  ticket.getDocument().setFieldInt("DFA_ID", Integer.valueOf(request.getParameter("DFA_ID")));
               } catch (NumberFormatException ex) {
                  System.out.println("Ventas CT_CLIENTEFINAL " + ex.getMessage());
               }
            }
            /*Campos flete, transportista , num guia VENTAS*/
            try {
               ticket.getDocument().setFieldInt("TR_ID", Integer.valueOf(request.getParameter("TR_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras TR_ID " + ex.getMessage());
            }
            try {
               ticket.getDocument().setFieldInt("ME_ID", Integer.valueOf(request.getParameter("ME_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras ME_ID " + ex.getMessage());
            }
            try {
               ticket.getDocument().setFieldInt("TF_ID", Integer.valueOf(request.getParameter("TF_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras TF_ID " + ex.getMessage());
            }
            if (request.getParameter(strPrefijoMaster + "_NUM_GUIA") != null) {
               ticket.getDocument().setFieldString(strPrefijoMaster + "_NUM_GUIA", request.getParameter(strPrefijoMaster + "_NUM_GUIA"));
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
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_ESRECU", intEsRecu);
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_PERIODICIDAD", intPeriodicidad);
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_DIAPER", intDiaPer);
               ticket.getDocument().setFieldInt(strPrefijoMaster + "_NO_EVENTOS", intNumEventos);
            }
            //Recibimos el regimen fiscal
            if (request.getParameter(strPrefijoMaster + "_REGIMENFISCAL") != null) {
               ticket.getDocument().setFieldString(strPrefijoMaster + "_REGIMENFISCAL", request.getParameter(strPrefijoMaster + "_REGIMENFISCAL"));
            }
            //Recibimos la serie por guardar...
            if (request.getParameter(strPrefijoMaster + "_SERIE") != null) {
               ticket.getDocument().setFieldString(strPrefijoMaster + "_SERIE", request.getParameter(strPrefijoMaster + "_SERIE"));
            }
            //Recibimos el turno de la operacion
            if (request.getParameter(strPrefijoMaster + "_TURNO") != null) {
               try {
                  ticket.getDocument().setFieldInt(strPrefijoMaster + "_TURNO", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TURNO")));
               } catch (NumberFormatException ex) {
                  System.out.println("Error al convertir turno");
               }
            }
            //Periodos para los multiniveles
            Periodos periodo = new Periodos();
            ticket.getDocument().setFieldInt("MPE_ID", periodo.getPeriodoActual(oConn));
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
               //Solo aplica si es ticket o factura
               if (strTipoVtaNom.equals(Ticket.TICKET) || strTipoVtaNom.equals(Ticket.FACTURA)) {
                  deta.setFieldInt(strPrefijoDeta + "_ESDEVO", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ESDEVO" + i)));
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
                        ticket.addItemLstSeries(intMPD_ID);
                     } catch (NumberFormatException ex) {
                     }
                  }

               }
               //
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
                  //Validamos si tenemos un empresa seleccionada
                  if (varSesiones.getIntIdEmpresa() != 0) {
                     //Asignamos la empresa seleccionada
                     detaPago.setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
                  }
                  ticket.AddDetalle(detaPago);
               }
            }
            //Obtenemos los datos de los anticipos
            //Si llega el campo de pedido entonces estamos editando un pedido
            if (request.getParameter("MCD_NUMANTICIPOS") != null) {
               int intNumAnti = Integer.parseInt(request.getParameter("MCD_NUMANTICIPOS"));
               ticket.setNumAnticipos(intNumAnti);
               int[] arID_ANTICIPO = new int[intNumAnti];
               double[] arTotalAntUsar = new double[intNumAnti];
               for (int i = 1; i <= intNumAnti; i++) {
                  arID_ANTICIPO[i - 1] = Integer.parseInt(request.getParameter("MCD_IDANTICIPO" + i));
                  arTotalAntUsar[i - 1] = Float.parseFloat(request.getParameter("MCD_CANTUSAR" + i));
               }
               ticket.setArID_Ant(arID_ANTICIPO);
               ticket.setArTotalAntUsar(arTotalAntUsar);
            }

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
               //Solo aplica en pedidos, tickets y cotizaciones
               if (strTipoVta.equals("2") || strTipoVta.equals("3") || strTipoVta.equals("4")) {
                  //Enviamos por correo el formato en caso de ser diferente de factura
                  String strTipoDoc = "";
                  if (strTipoVta.equals("2")) {
                     strTipoDoc = "TICKET";
                  }
                  if (strTipoVta.equals("3")) {
                     strTipoDoc = "PEDIDO";
                  }
                  if (strTipoVta.equals("5")) {
                     strTipoDoc = "COTIZA";
                  }
                  try {
                     System.out.println("Envio de mail de formato..." + strTipoDoc);
                     ticket.generaMail(oConn, Integer.valueOf(ticket.getDocument().getValorKey()), strTipoDoc, strPathXML, strPathFonts);
                  } catch (NumberFormatException ex) {
                  }
               }

               if (strTipoVta.equals("1") || strTipoVta.equals("2")) {
                  ticket.getMailProv(oConn, varSesiones, Integer.valueOf(ticket.getDocument().getValorKey()), strTipoVta);
               }
               //Generar bak order o pedidos internos
               
               //Generar requisiciones de compra
                
            } else {
               strRes = ticket.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         // </editor-fold>
         //Anula la operacion
         if (strid.equals("2")) {
            //Instanciamos el ticvet
            Ticket ticket = new Ticket(oConn, varSesiones, request);
            ticket.setStrPATHKeys(strPathPrivateKeys);
            ticket.setStrPATHXml(strPathXML);
            ticket.initMyPass(this.getServletContext());
            //Desactivamos inventarios
            if (strmod_Inventarios.equals("NO")) {
               ticket.setBolAfectaInv(false);
            }
            //Validamos si envian la peticion con la bandera de afectar inventarios
            if (request.getParameter("INV") != null) {
               if (request.getParameter("INV").equals("0")) {
                  ticket.setBolAfectaInv(false);
               }
            }
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
            if (strTipoVta.equals("5")) {
               strPrefijoMaster = "COT";
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
         masiva.getMiFactura().getDocument().setFieldInt("FAC_MONEDA", 1);
         masiva.getMiFactura().getDocument().setFieldDouble("FAC_TASAPESO", 1);
         masiva.getMiFactura().getDocument().setFieldString("FAC_METODODEPAGO", request.getParameter("FAC_METODOPAGO"));
         masiva.getMiFactura().getDocument().setFieldString("FAC_NUMCUENTA", request.getParameter("FAC_NUMCUENTA"));
         masiva.getMiFactura().getDocument().setFieldString("FAC_FORMADEPAGO", request.getParameter("FAC_FORMADEPAGO"));
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
         String strPR_DESCRIPCION_CORTA = "";
         String strPR_DESCRIPCION_COMPRAS = "";
         String strPR_CODBARRAS = "";
         int intPR_EXENTO1 = 0;
         int intPR_EXENTO2 = 0;
         int intPR_EXENTO3 = 0;
         int intPR_UNIDADMEDIDA = 0;
         int intMON_ID = 0;
         int intPR_CATEGORIA1 = 0;
         int intPR_CATEGORIA2 = 0;
         int intPR_CATEGORIA3 = 0;
         int intPR_CATEGORIA4 = 0;
         int intPR_CATEGORIA5 = 0;
         int intPR_CATEGORIA6 = 0;
         int intPR_CATEGORIA7 = 0;
         int intPR_CATEGORIA8 = 0;
         int intPR_CATEGORIA9 = 0;
         int intPR_CATEGORIA10 = 0;
         int intPR_USO_NOSERIE = 0;
         int intPR_INVENTARIO = 0;
         double dblCosto = 0;
         double dblCostoCompra = 0;
         double dblExist = 0;
         String strPR_CODIGOBD = "";
         String strUnidadMedida = "";
         int intGT_ID = 0;
         int intPR_TASA_IVA = 0;
         double dblTasaIVAAplica = 0;
         //Buscamos el producto en la bd
         String strSql = "SELECT PR_ID,PR_CODIGO,PR_CODBARRAS,PR_DESCRIPCION,"
            + "PR_DESCRIPCIONCORTA,PR_DESCRIPCIONCOMPRA,"
            + "PR_REQEXIST,PR_EXENTO1,PR_EXENTO2,PR_EXENTO3,"
            + "PR_COSTOPROM,PR_COSTOCOMPRA,PR_COSTOREPOSICION,PR_UNIDADMEDIDA,MON_ID,PR_EXISTENCIA "
            + ",PR_CATEGORIA1,PR_CATEGORIA2,PR_CATEGORIA3,PR_CATEGORIA4,PR_CATEGORIA5,"
            + "PR_CATEGORIA6,PR_CATEGORIA7,PR_CATEGORIA8,PR_CATEGORIA9,PR_CATEGORIA10"
            + ",PR_USO_NOSERIE,GT_ID,PR_TASA_IVA,PR_INVENTARIO "
            + " FROM vta_producto "
            + " where (PR_CODIGO = '" + strPR_CODIGO + "' "
            + " OR PR_CODBARRAS = '" + strPR_CODIGO + "') "
            + " AND SC_ID = '" + strSC_ID + "'"
            + " AND EMP_ID = " + varSesiones.getIntIdEmpresa();
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            intPR_ID = rs.getInt("PR_ID");
            strPR_CODIGOBD = rs.getString("PR_CODIGO");
            strPR_CODBARRAS = rs.getString("PR_CODBARRAS");
            strPR_DESCRIPCION = rs.getString("PR_DESCRIPCION");
            strPR_DESCRIPCION_CORTA = rs.getString("PR_DESCRIPCIONCORTA");
            strPR_DESCRIPCION_COMPRAS = rs.getString("PR_DESCRIPCIONCOMPRA");
            intPR_REQEXIST = rs.getInt("PR_REQEXIST");
            intPR_EXENTO1 = rs.getInt("PR_EXENTO1");
            intPR_EXENTO2 = rs.getInt("PR_EXENTO2");
            intPR_EXENTO3 = rs.getInt("PR_EXENTO3");
            intPR_UNIDADMEDIDA = rs.getInt("PR_UNIDADMEDIDA");
            dblCosto = rs.getDouble("PR_COSTOPROM");
            dblCostoCompra = rs.getDouble("PR_COSTOREPOSICION");
            dblExist = rs.getDouble("PR_EXISTENCIA");
            intMON_ID = rs.getInt("MON_ID");
            intPR_CATEGORIA1 = rs.getInt("PR_CATEGORIA1");
            intPR_CATEGORIA2 = rs.getInt("PR_CATEGORIA2");
            intPR_CATEGORIA3 = rs.getInt("PR_CATEGORIA3");
            intPR_CATEGORIA4 = rs.getInt("PR_CATEGORIA4");
            intPR_CATEGORIA5 = rs.getInt("PR_CATEGORIA5");
            intPR_CATEGORIA6 = rs.getInt("PR_CATEGORIA6");
            intPR_CATEGORIA7 = rs.getInt("PR_CATEGORIA7");
            intPR_CATEGORIA8 = rs.getInt("PR_CATEGORIA8");
            intPR_CATEGORIA9 = rs.getInt("PR_CATEGORIA9");
            intPR_CATEGORIA10 = rs.getInt("PR_CATEGORIA10");
            intPR_USO_NOSERIE = rs.getInt("PR_USO_NOSERIE");
            intGT_ID = rs.getInt("GT_ID");
            intPR_TASA_IVA = rs.getInt("PR_TASA_IVA");
            intPR_INVENTARIO = rs.getInt("PR_INVENTARIO");
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
         //Si tiene unidad de medida sacamos el concepto
         if (intPR_UNIDADMEDIDA != 0) {
            strSql = "SELECT ME_DESCRIPCION "
               + " FROM vta_unidadmedida "
               + " where ME_ID = '" + intPR_UNIDADMEDIDA + "'";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strUnidadMedida = rs.getString("ME_DESCRIPCION");
            }
            rs.close();
         }
         //Si tiene categoría 1 buscamos
         String strCategoria1 = "";
         if (intPR_CATEGORIA1 != 0) {
            strSql = "SELECT PC_DESCRIPCION "
               + " FROM vta_prodcat1 "
               + " where PC_ID = '" + intPR_CATEGORIA1 + "'";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strCategoria1 = rs.getString("PC_DESCRIPCION");
            }
            rs.close();
         }
         //Si tiene asignada una tasa de iva diferente buscamos el factor
         if (intPR_TASA_IVA != 0) {
            strSql = "SELECT TI_TASA "
               + " FROM vta_tasaiva "
               + " where TI_ID = '" + intPR_TASA_IVA + "'";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               dblTasaIVAAplica = rs.getDouble("TI_TASA");
            }
            rs.close();
         }
         //Xml de respuesta
         StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         strRes.append("<vta_producto>");
         strRes.append("<vta_productos "
            + " PR_ID = \"" + intPR_ID + "\"  "
            + " PR_ID2 = \"" + intPR_ID2 + "\"  "
            + " MON_ID = \"" + intMON_ID + "\"  "
            + " PR_CODIGO = \"" + utilXML.Sustituye(strPR_CODIGOBD) + "\"  "
            + " PR_CODBARRAS = \"" + utilXML.Sustituye(strPR_CODBARRAS) + "\"  "
            + " PR_DESCRIPCION = \"" + utilXML.Sustituye(strPR_DESCRIPCION) + "\"  "
            + " PR_DESCRIPCION_CORTA = \"" + utilXML.Sustituye(strPR_DESCRIPCION_CORTA) + "\"  "
            + " PR_DESCRIPCIONCOMPRA = \"" + utilXML.Sustituye(strPR_DESCRIPCION_COMPRAS) + "\"  "
            + " PR_REQEXIST = \"" + intPR_REQEXIST + "\"  "
            + " PR_EXISTENCIA = \"" + dblExist + "\"  "
            + " PR_EXENTO1 = \"" + intPR_EXENTO1 + "\"  "
            + " PR_EXENTO2 = \"" + intPR_EXENTO2 + "\"  "
            + " PR_EXENTO3 = \"" + intPR_EXENTO3 + "\"  "
            + " PR_COSTOPROM = \"" + dblCosto + "\"  "
            + " PR_COSTOCOMPRA = \"" + dblCostoCompra + "\"  "
            + " PR_UNIDADMEDIDA = \"" + strUnidadMedida + "\"  "
            + " PR_CAT1 = \"" + intPR_CATEGORIA1 + "\"  "
            + " PR_CAT2 = \"" + intPR_CATEGORIA2 + "\"  "
            + " PR_CAT3 = \"" + intPR_CATEGORIA3 + "\"  "
            + " PR_CAT4 = \"" + intPR_CATEGORIA4 + "\"  "
            + " PR_CAT5 = \"" + intPR_CATEGORIA5 + "\"  "
            + " PR_CAT6 = \"" + intPR_CATEGORIA6 + "\"  "
            + " PR_CAT7 = \"" + intPR_CATEGORIA7 + "\"  "
            + " PR_CAT8 = \"" + intPR_CATEGORIA8 + "\"  "
            + " PR_CAT9 = \"" + intPR_CATEGORIA9 + "\"  "
            + " PR_CAT10 = \"" + intPR_CATEGORIA10 + "\"  "
            + " PR_USO_NOSERIE = \"" + intPR_USO_NOSERIE + "\"  "
            + " PR_INVENTARIO = \"" + intPR_INVENTARIO + "\"  "
            + " GT_ID = \"" + intGT_ID + "\"  "
            + " PR_TASA_IVA = \"" + intPR_TASA_IVA + "\"  "
            + " PR_TASA_IVA_M = \"" + dblTasaIVAAplica + "\"  "
            + " CATEGO1 = \"" + strCategoria1 + "\"  "
            + " />");
         strRes.append("</vta_producto>");
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strRes.toString());//Pintamos el resultado
      }
      //Regresa los datos de un pedido para venderlo
      if (strid.equals("8")) {
         String strPD_ID = request.getParameter("PD_ID");
         if (strPD_ID == null) {
            strPD_ID = "0";
         }
         StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         String[] lstPedidos = strPD_ID.split(",");
         if (lstPedidos.length > 1) {
            strXML.append("<vta_pedidos> ");
         }
         for (int iPed = 0; iPed < lstPedidos.length; iPed++) {
            strXML.append("<vta_pedido ");
            //Recuperamos info de pedidos
            vta_pedidos pedido = new vta_pedidos();
            pedido.ObtenDatos(Integer.valueOf(lstPedidos[iPed]), oConn);
            String strValorPar = pedido.getFieldPar();
            strXML.append(strValorPar + " > ");
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
               int intPR_USO_NOSERIE = 0;
               int intPR_CATEGORIA1 = 0;
               int intPR_CATEGORIA2 = 0;
               int intPR_CATEGORIA3 = 0;
               int intPR_CATEGORIA4 = 0;
               int intPR_CATEGORIA5 = 0;
               int intPR_CATEGORIA6 = 0;
               int intPR_CATEGORIA7 = 0;
               int intPR_CATEGORIA8 = 0;
               int intPR_CATEGORIA9 = 0;
               int intPR_CATEGORIA10 = 0;
               //Consultamos la existencia y si requiera de existencia para su venta
               strSql = "select PR_REQEXIST,PR_EXISTENCIA,PR_CODBARRAS,PR_USO_NOSERIE "
                  + ",PR_CATEGORIA1,PR_CATEGORIA2,PR_CATEGORIA3,PR_CATEGORIA4,PR_CATEGORIA5,"
                  + "PR_CATEGORIA6,PR_CATEGORIA7,PR_CATEGORIA8,PR_CATEGORIA9,PR_CATEGORIA10 "
                  + " from vta_producto where PR_ID = " + tbn.getFieldInt("PR_ID");
               rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  intPR_REQEXIST = rs.getInt("PR_REQEXIST");
                  dblExistencia = rs.getDouble("PR_EXISTENCIA");
                  strPR_CODBARRAS = rs.getString("PR_CODBARRAS");
                  intPR_USO_NOSERIE = rs.getInt("PR_USO_NOSERIE");
                  intPR_CATEGORIA1 = rs.getInt("PR_CATEGORIA1");
                  intPR_CATEGORIA2 = rs.getInt("PR_CATEGORIA2");
                  intPR_CATEGORIA3 = rs.getInt("PR_CATEGORIA3");
                  intPR_CATEGORIA4 = rs.getInt("PR_CATEGORIA4");
                  intPR_CATEGORIA5 = rs.getInt("PR_CATEGORIA5");
                  intPR_CATEGORIA6 = rs.getInt("PR_CATEGORIA6");
                  intPR_CATEGORIA7 = rs.getInt("PR_CATEGORIA7");
                  intPR_CATEGORIA8 = rs.getInt("PR_CATEGORIA8");
                  intPR_CATEGORIA9 = rs.getInt("PR_CATEGORIA9");
                  intPR_CATEGORIA10 = rs.getInt("PR_CATEGORIA10");
               }
               rs.close();
               strXML.append("<deta ");
               strXML.append(tbn.getFieldPar() + " PR_REQEXIST = \"" + intPR_REQEXIST + "\" PR_USO_NOSERIE=\"" + intPR_USO_NOSERIE + "\" "
                  + " PR_EXISTENCIA=\"" + dblExistencia + "\" PR_CODBARRAS=\"" + strPR_CODBARRAS + "\""
                  + " PR_CAT1 = \"" + intPR_CATEGORIA1 + "\"  "
                  + " PR_CAT2 = \"" + intPR_CATEGORIA2 + "\"  "
                  + " PR_CAT3 = \"" + intPR_CATEGORIA3 + "\"  "
                  + " PR_CAT4 = \"" + intPR_CATEGORIA4 + "\"  "
                  + " PR_CAT5 = \"" + intPR_CATEGORIA5 + "\"  "
                  + " PR_CAT6 = \"" + intPR_CATEGORIA6 + "\"  "
                  + " PR_CAT7 = \"" + intPR_CATEGORIA7 + "\"  "
                  + " PR_CAT8 = \"" + intPR_CATEGORIA8 + "\"  "
                  + " PR_CAT9 = \"" + intPR_CATEGORIA9 + "\"  "
                  + " PR_CAT10 = \"" + intPR_CATEGORIA10 + "\"  ");
               //Si usa numeros de serie buscamos los numeros de serie vinculados al surtimiento de este pedido(en caso de aplicar)
               if (intPR_USO_NOSERIE == 1) {
                  strXML.append(">");
                  //Consulta de movimientos de producto ligados a este pedido
                  String strSqlProd = "SELECT MPD_ID,PL_NUMLOTE,MPD_SERIE_VENDIDO FROM vta_movproddeta "
                     + "WHERE MPD_IDORIGEN = " + tbn.getFieldInt("PDD_ID") + " AND MPD_SALIDAS > 0";
                  rs = oConn.runQuery(strSqlProd, true);
                  while (rs.next()) {
                     int intMPD_ID = rs.getInt("MPD_ID");
                     String strPL_NUMLOTE = rs.getString("PL_NUMLOTE");
                     int intMPD_SERIE_VENDIDO = rs.getInt("MPD_SERIE_VENDIDO");
                     strXML.append("<series MPD_ID=\"" + intMPD_ID + "\" PL_NUMLOTE=\"" + strPL_NUMLOTE + "\" MPD_SERIE_VENDIDO=\"" + intMPD_SERIE_VENDIDO + "\" "
                        + "/>");
                  }
                  rs.close();
                  strXML.append("</deta>");
               } else {
                  strXML.append("/>");
               }

            }
            strXML.append("</vta_pedido>");
         }
         if (lstPedidos.length > 1) {
            strXML.append("</vta_pedidos> ");
         }
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML.toString());//Pintamos el resultado
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
         String strCT_RFC = "";
         String strCT_METODODEPAGO = "";
         String strCT_FORMADEPAGO = "";
         String strCT_CTABANCO1 = "";
         String strCT_VENDEDOR = "";
         String strDireccion = "";
         int intMON_ID = 0;
         int intTI_ID = 0;
         int intTI2_ID = 0;
         int intTI3_ID = 0;
         int intTTC_ID = 0;
         String strCT_EMAIL1 = "";
         String strCT_EMAIL2 = "";
         String strCT_EMAIL3 = "";
         String strCT_EMAIL4 = "";
         String strCT_EMAIL5 = "";
         String strCT_EMAIL6 = "";
         String strCT_EMAIL7 = "";
         String strCT_EMAIL8 = "";
         String strCT_EMAIL9 = "";
         String strCT_EMAIL10 = "";

         String strSql = "select CT_ID,CT_RAZONSOCIAL,CT_RFC,CT_LPRECIOS,"
            + "CT_DESCUENTO,CT_DIASCREDITO,CT_MONTOCRED,CT_TIPOPERS,"
            + "CT_USOIMBUEBLE,CT_TIPOFAC,MON_ID,TI_ID,TI2_ID,TI3_ID,TTC_ID,CT_METODODEPAGO,"
            + "CT_FORMADEPAGO,CT_CTABANCO1,CT_VENDEDOR,CT_EMAIL1,CT_EMAIL2,CT_EMAIL3,"
            + "CT_EMAIL4,CT_EMAIL5,CT_EMAIL6,CT_EMAIL7,CT_EMAIL8,CT_EMAIL9,CT_EMAIL10,"
            + "concat(\"Calle: \", vta_cliente.CT_CALLE, \" Numero: \",vta_cliente.CT_NUMERO, \" Num Int:\", vta_cliente.CT_NUMINT,\" Colonia: \", CT_COLONIA,\" Pais: \","
            + " (select paises.PA_NOMBRE from paises where PA_ID = vta_cliente.PA_ID), \" Estado: \",vta_cliente.CT_ESTADO,\" Ciudad: \", "
            + "vta_cliente.CT_CIUDAD, \" Municipio: \", vta_cliente.CT_MUNICIPIO,\"CP: \",vta_cliente.CT_CP) as direccion "
            + " from vta_cliente where CT_ID = " + strCteId + " ";
         if (strClienteUniversal.equals("0")) {
            strSql += " AND EMP_ID = " + varSesiones.getIntIdEmpresa();
         }
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            intCT_ID = rs.getInt("CT_ID");
            intCT_LPRECIOS = rs.getInt("CT_LPRECIOS");
            dblCT_DESCUENTO = rs.getDouble("CT_DESCUENTO");
            intCT_DIASCREDITO = rs.getInt("CT_DIASCREDITO");
            dblCT_MONTOCRED = rs.getDouble("CT_MONTOCRED");
            strCT_RAZONSOCIAL = rs.getString("CT_RAZONSOCIAL");
            strCT_RFC = rs.getString("CT_RFC");
            intCT_TIPOPERS = rs.getInt("CT_TIPOPERS");
            intCT_TIPOFAC = rs.getInt("CT_TIPOFAC");
            strCT_USOIMBUEBLE = rs.getString("CT_USOIMBUEBLE");
            strDireccion = rs.getString("direccion");
            strCT_EMAIL1 = rs.getString("CT_EMAIL1");
            strCT_EMAIL2 = rs.getString("CT_EMAIL2");
            strCT_EMAIL3 = rs.getString("CT_EMAIL3");
            strCT_EMAIL4 = rs.getString("CT_EMAIL4");
            strCT_EMAIL5 = rs.getString("CT_EMAIL5");
            strCT_EMAIL6 = rs.getString("CT_EMAIL6");
            strCT_EMAIL7 = rs.getString("CT_EMAIL7");
            strCT_EMAIL8 = rs.getString("CT_EMAIL8");
            strCT_EMAIL9 = rs.getString("CT_EMAIL9");
            strCT_EMAIL10 = rs.getString("CT_EMAIL10");
            if (!strCT_RAZONSOCIAL.equals("")) {
               strCT_RAZONSOCIAL = utilXML.Sustituye(strCT_RAZONSOCIAL);
            }
            intMON_ID = rs.getInt("MON_ID");
            intTI_ID = rs.getInt("TI_ID");
            intTI2_ID = rs.getInt("TI2_ID");
            intTI3_ID = rs.getInt("TI3_ID");
            intTTC_ID = rs.getInt("TTC_ID");
            strCT_METODODEPAGO = rs.getString("CT_METODODEPAGO");
            strCT_FORMADEPAGO = rs.getString("CT_FORMADEPAGO");
            strCT_CTABANCO1 = rs.getString("CT_CTABANCO1");
            strCT_VENDEDOR = rs.getString("CT_VENDEDOR");
         }
         rs.close();
         //El detalle
         strXML += "<vta_clientes "
            + " CT_ID = \"" + intCT_ID + "\"  "
            + " CT_RAZONSOCIAL = \"" + strCT_RAZONSOCIAL + "\"  "
            + " CT_RFC = \"" + strCT_RFC + "\"  "
            + " CT_LPRECIOS = \"" + intCT_LPRECIOS + "\"  "
            + " CT_DESCUENTO = \"" + dblCT_DESCUENTO + "\"  "
            + " CT_DIASCREDITO = \"" + intCT_DIASCREDITO + "\"  "
            + " CT_MONTOCRED = \"" + dblCT_MONTOCRED + "\"  "
            + " CT_TIPOPERS = \"" + intCT_TIPOPERS + "\"  "
            + " CT_TIPOFAC = \"" + intCT_TIPOFAC + "\"  "
            + " CT_USOIMBUEBLE = \"" + strCT_USOIMBUEBLE + "\"  "
            + " MON_ID = \"" + intMON_ID + "\"  "
            + " TI_ID = \"" + intTI_ID + "\"  "
            + " TI2_ID = \"" + intTI2_ID + "\"  "
            + " TI3_ID = \"" + intTI3_ID + "\"  "
            + " TTC_ID = \"" + intTTC_ID + "\"  "
            + " CT_METODODEPAGO = \"" + strCT_METODODEPAGO + "\"  "
            + " CT_FORMADEPAGO = \"" + strCT_FORMADEPAGO + "\"  "
            + " CT_CTABANCO1 = \"" + strCT_CTABANCO1 + "\"  "
            + " CT_VENDEDOR = \"" + strCT_VENDEDOR + "\"  "
            + " CT_DIRECCION = \"" + strDireccion + "\"  "
            + " CT_EMAIL1 = \"" + strCT_EMAIL1 + "\" "
            + " CT_EMAIL2 = \"" + strCT_EMAIL2 + "\" "
            + " CT_EMAIL3 = \"" + strCT_EMAIL3 + "\" "
            + " CT_EMAIL4 = \"" + strCT_EMAIL4 + "\" "
            + " CT_EMAIL5 = \"" + strCT_EMAIL5 + "\" "
            + " CT_EMAIL6 = \"" + strCT_EMAIL6 + "\" "
            + " CT_EMAIL7 = \"" + strCT_EMAIL7 + "\" "
            + " CT_EMAIL8 = \"" + strCT_EMAIL8 + "\" "
            + " CT_EMAIL9 = \"" + strCT_EMAIL9 + "\" "
            + " CT_EMAIL10 = \"" + strCT_EMAIL10 + "\" "
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
         //Validamos si envian un valor vacio
         if (strTI_ID.isEmpty()) {
            strTI_ID = "0";
         }
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<vta_impuesto>";
         //Consultamos la info
         double dblTasa1 = 0;
         String strSql = "select TI_TASA "
            + "from vta_tasaiva where TI_ID = " + strTI_ID;
         try {
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               dblTasa1 = rs.getDouble("TI_TASA");
            }
            rs.close();
         } catch (Exception ex) {
            System.out.println("Error al recuperar la tasa de IVA " + ex.getMessage() + " " + strSql);
         }
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
      //Nos regresa el folio del ticket pedido o cotizacion
      if (strid.equals("12")) {
         //Recuperamos el id del cliente
         String strKEY_ID = request.getParameter("KEY_ID");
         if (strKEY_ID == null) {
            strKEY_ID = "0";
         }
         String strTYPE_ID = request.getParameter("TYPE_ID");
         if (strTYPE_ID == null) {
            strTYPE_ID = "0";
         }
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<vta_folio>";
         //Consultamos la info
         String strFolio = "";
         //TICKETS
         if (strTYPE_ID.equals("1")) {
            String strSql = "select TKT_FOLIO "
               + "from vta_tickets where TKT_ID = " + strKEY_ID;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strFolio = rs.getString("TKT_FOLIO");
            }
            rs.close();
         }
         //PEDIDOS
         if (strTYPE_ID.equals("2")) {
            String strSql = "select PD_FOLIO "
               + "from vta_pedidos where PD_ID = " + strKEY_ID;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strFolio = rs.getString("PD_FOLIO");
            }
            rs.close();
         }
         //COTIZACIONES
         if (strTYPE_ID.equals("5")) {
            String strSql = "select COT_FOLIO "
               + "from vta_cotiza where COT_ID = " + strKEY_ID;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strFolio = rs.getString("COT_FOLIO");
            }
            rs.close();
         }

         //El detalle
         strXML += "<vta_folios "
            + " FOLIO = \"" + strFolio + "\"  "
            + " />";
         strXML += "</vta_folio>";
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
      //Nos regresa el siguiente folio del ticket, factura, pedido o cotizacion
      if (strid.equals("14")) {
         Folios folio = new Folios();
         int intTipo = 0;
         //Recuperamos el tipo de la operacion
         String strTYPE_ID = request.getParameter("TYPE_ID");
         String strSerie = request.getParameter("SERIE");
         if (strSerie == null) {
            strSerie = "";
         }
         if (strTYPE_ID == null) {
            strTYPE_ID = "0";
         }
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<vta_folio>";
         //Consultamos la info
         String strFolio = "";
         //FACTURAS
         if (strTYPE_ID.equals("1")) {
            intTipo = Folios.FACTURA;
         }
         //TICKETS
         if (strTYPE_ID.equals("2")) {
            intTipo = Folios.TICKET;
         }
         //PEDIDOS
         if (strTYPE_ID.equals("3")) {
            intTipo = Folios.PEDIDOS;
         }
         //COTIZACIONES
         if (strTYPE_ID.equals("5")) {
            intTipo = Folios.COTIZACIONES;
         }
         //COMPRAS
         if (strTYPE_ID.equals("6")) {
            intTipo = Folios.OCOMPRA;
         }
         //Validamos folios globales
         boolean bolFolioGlobal = false;
         if (strfolio_GLOBAL == null) {
            bolFolioGlobal = true;
         } else if (strfolio_GLOBAL.equals("1")) {
            bolFolioGlobal = true;
         }
         //Validamos si tenemos un empresa seleccionada
         int intEmpresaDefa = 0;
         if (varSesiones.getIntIdEmpresa() != 0) {
            //Asignamos la empresa seleccionada
            intEmpresaDefa = varSesiones.getIntIdEmpresa();
         }
         //Obtenemos el numero de folio que sigue
         folio.setStrSerie(strSerie);
         strFolio = folio.getNextFolio(oConn, intTipo, bolFolioGlobal, intEmpresaDefa);
         strXML += "<vta_folios "
            + " FOLIO = \"" + strFolio + "\"  "
            + " />";
         strXML += "</vta_folio>";
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
      //Guardamos el surtido de un pedido
      if (strid.equals("20")) {
         //Recibimos datos
         String strFechaRecepcion = "";
         try {
            strFechaRecepcion = fecha.FormateaBD(request.getParameter("PD_FECHA"), "/");
         } catch (Exception ex) {
         }
         //Instanciamos el objeto de ventas
         Ticket ticket = new Ticket(oConn, varSesiones, request);
         ticket.setStrTipoVta(Ticket.PEDIDO);
         //Recibimos parametros
         String strPrefijoMaster = "PD";
         //Asignamos el id de la operacion por anular
         String strIdRecep = request.getParameter("PD_ID");
         int intId = 0;
         if (strIdRecep == null) {
            strIdRecep = "0";
         }
         //Bandera para indicar
         String strEsRecepCons = request.getParameter("ES_RECEP_CONS");
         if (strEsRecepCons == null) {
            strEsRecepCons = "0";
         }

         intId = Integer.valueOf(strIdRecep);
         ticket.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
         //Recibimos datos de los items o partidas
         int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
         for (int i = 1; i <= intCount; i++) {
            TableMaster deta = null;

            deta = new vta_pedidosdeta();
            deta.setFieldInt("PDD_ID", Integer.valueOf(request.getParameter("PDD_ID" + i)));
            deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
            deta.setFieldDouble("PDD_CANTIDADSURTIDA", Double.valueOf(request.getParameter("PDD_CANTIDADSURTIDA" + i)));
            deta.setFieldDouble("PDD_COSTO", Double.valueOf(request.getParameter("PDD_COSTO" + i)));
            deta.setFieldString("PDD_CVE", request.getParameter("PDD_CVE" + i));
            deta.setFieldDouble("PDD_FACTOR", Double.valueOf(request.getParameter("PDD_FACTOR" + i)));
            deta.setFieldString("PDD_USASERIE", request.getParameter("PDD_USASERIE" + i));
            deta.setFieldString("PDD_SERIES", request.getParameter("PDD_SERIES" + i));
            ticket.AddDetalle(deta);
         }
         ticket.Init();

         //Guardamos la operacion
         if (strEsRecepCons.equals("1")) {
            ticket.doRecepcionPedidoConsignacion(strFechaRecepcion, "", "", "");
         } else {
            ArrayList<vta_pedidos_cajas> lstContenido = new ArrayList<vta_pedidos_cajas>();
            ArrayList<vta_pedidos_cajas_master> lstCajas = new ArrayList<vta_pedidos_cajas_master>();
            //Agregamos las cajas
            int intPDD_CONTA_CAJAS = 0;
            try {
               intPDD_CONTA_CAJAS = Integer.valueOf(request.getParameter("mPDD_CONTA_CAJAS"));
            } catch (NumberFormatException ex) {
               System.out.println(" " + ex.getMessage());
            }
            //Hay cajas las agregamos
            if (intPDD_CONTA_CAJAS > 0) {
               for (int h = 0; h < intPDD_CONTA_CAJAS; h++) {
                  vta_pedidos_cajas_master master = new vta_pedidos_cajas_master();
                  master.setFieldInt("PD_ID", intId);
                  master.setFieldInt("CAJM_NUMCAJA", Integer.valueOf(request.getParameter("mNUMERO" + h)));
                  master.setFieldInt("CAJM_ALTO", Integer.valueOf(request.getParameter("mALTO" + h)));
                  master.setFieldInt("CAJM_ANCHO", Integer.valueOf(request.getParameter("mANCHO" + h)));
                  master.setFieldInt("CAJM_LARGO", Integer.valueOf(request.getParameter("mLARGO" + h)));
                  master.setFieldInt("CAJM_PESO", Integer.valueOf(request.getParameter("mPESO" + h)));
                  master.setFieldInt("MP_ID", 0);
                  lstCajas.add(master);
               }
            }
            //Agregamos el detalle de las cajas
            int intPDD_CONTA_CAJAS2 = 0;
            try {
               intPDD_CONTA_CAJAS2 = Integer.valueOf(request.getParameter("cPDD_CONTA_CAJAS"));
            } catch (NumberFormatException ex) {
               System.out.println(" " + ex.getMessage());
            }
            //Hay cajas las agregamos
            if (intPDD_CONTA_CAJAS2 > 0) {
               for (int h = 0; h < intPDD_CONTA_CAJAS2; h++) {
                  if (request.getParameter("cPDD_SERIES" + h).isEmpty()) {
                     //No lleva numeros de serie
                     vta_pedidos_cajas caja = new vta_pedidos_cajas();
                     caja.setFieldInt("PD_ID", intId);
                     caja.setFieldInt("PDD_ID", Integer.valueOf(request.getParameter("cPDD_ID" + h)));
                     caja.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("cPDD_PR_ID" + h)));
                     caja.setFieldInt("CAJ_NUMERO", Integer.valueOf(request.getParameter("cPDD_CAJA" + h)));
                     caja.setFieldDouble("CAJ_CANTIDAD", Double.valueOf(request.getParameter("cPDD_CANTIDAD" + h)));
                     caja.setFieldString("CAJM_SERIE", "");
                     caja.setFieldInt("MP_ID", 0);
                     lstContenido.add(caja);
                  } else {
                     //Contiene numeros de serie
                     String[] lstSeries = request.getParameter("cPDD_SERIES" + h).split(",");
                     for (int m = 0; m < lstSeries.length; m++) {
                        vta_pedidos_cajas caja = new vta_pedidos_cajas();
                        caja.setFieldInt("PD_ID", intId);
                        caja.setFieldInt("PDD_ID", Integer.valueOf(request.getParameter("cPDD_ID" + h)));
                        caja.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("cPDD_PR_ID" + h)));
                        caja.setFieldInt("CAJ_NUMERO", Integer.valueOf(request.getParameter("cPDD_CAJA" + h)));
                        caja.setFieldInt("CAJ_CANTIDAD", Integer.valueOf(request.getParameter("cPDD_CANTIDAD" + h)));
                        caja.setFieldString("CAJM_SERIE", lstSeries[m]);
                        caja.setFieldInt("MP_ID", 0);
                        lstContenido.add(caja);
                     }
                  }

               }
            }
            ticket.doSurtidoPedido(strFechaRecepcion, "", "", "", lstContenido, lstCajas);
         }
         String strRes = ticket.getStrResultLast();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strRes);//Pintamos el resultado
      }
      //XML para listar los tickets por facturar
      if (strid.equals("22")) {
         String strSC_ID = request.getParameter("SC_ID");
         String strTKT_FECHA1 = request.getParameter("TKT_FECHA1");
         String strTKT_FECHA2 = request.getParameter("TKT_FECHA2");
         String strCT_ID = request.getParameter("CT_ID");

         if (strCT_ID == null) {
            strCT_ID = "0";
         }
         if (strSC_ID == null) {
            strSC_ID = "0";
         }
         if (strTKT_FECHA1 == null) {
            strTKT_FECHA1 = "";
         } else {
            strTKT_FECHA1 = fecha.FormateaBD(strTKT_FECHA1, "/");
         }
         if (strTKT_FECHA2 == null) {
            strTKT_FECHA2 = "";
         } else {
            strTKT_FECHA2 = fecha.FormateaBD(strTKT_FECHA2, "/");
         }

         StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         strXML.append("<vta_tickets>");
         //Consultamos la info
         String strFiltroCTE = "";
         if (strCT_ID.equals("0")) {
            strFiltroCTE = "";
         } else {
            strFiltroCTE = " AND CT_ID = " + strCT_ID;
         }

         String strSql = "select TKT_ID,TKT_FOLIO,TKT_RAZONSOCIAL,TKT_FECHA,TKT_TOTAL,TKT_SALDO "
            + " from vta_tickets where FAC_ID = 0  AND TKT_ANULADA = 0 "
            + " AND TKT_FECHA >= '" + strTKT_FECHA1 + "' AND TKT_FECHA <= '" + strTKT_FECHA2 + "' "
            + " AND SC_ID = " + strSC_ID
            + strFiltroCTE;

         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            //El detalle
            strXML.append("<vta_ticketss "
               + " TKT_ID=\"" + rs.getInt("TKT_ID") + "\" TKT_RAZONSOCIAL=\"" + rs.getString("TKT_RAZONSOCIAL") + "\" "
               + " TKT_FOLIO=\"" + rs.getString("TKT_FOLIO") + "\" TKT_FECHA=\"" + rs.getString("TKT_FECHA") + "\" "
               + " TKT_TOTAL=\"" + rs.getDouble("TKT_TOTAL") + "\" TKT_SALDO=\"" + rs.getDouble("TKT_SALDO") + "\" "
               + " />");
         }
         rs.close();
         strXML.append("</vta_tickets>");
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
//XML para listar los modelos
      if (strid.equals("24")) {
         StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         String strModelo = request.getParameter("Modelo");
         String strSC_ID = request.getParameter("strSC_ID");
         String strSql = "SELECT "
            + "vta_producto.PR_CODIGO_CORTO as Modelo,vta_producto.PR_DESCRIPCION as Descripcion,"
            + "vta_prodcat3.PC3_DESCRIPCION as color,"
            + "(GROUP_CONCAT(DISTINCT vta_prodcat4.PC4_DESCRIPCION SEPARATOR ',') ) AS tallas "
            + "FROM  vta_producto,vta_prodcat3, vta_prodcat4 "
            + "where PR_CODIGO_CORTO = '" + strModelo + "' AND vta_producto.PR_CATEGORIA3 = vta_prodcat3.PC3_ID "
            + "AND vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID AND vta_producto.SC_ID=" + strSC_ID
            + " group by "
            + "vta_producto.PR_CODIGO_CORTO,vta_producto.PR_DESCRIPCION,vta_prodcat3.PC3_DESCRIPCION "
            + "order by vta_producto.PR_CODIGO_CORTO";
         ResultSet rs = oConn.runQuery(strSql, true);
         strXML.append("<Productos>");
         while (rs.next()) {
            strXML.append("<Producto "
               + " Modelo=\"" + rs.getString("Modelo") + "\" "
               + " Descripcion=\"" + rs.getString("Descripcion") + "\" "
               + " Tallas=\"" + rs.getString("tallas") + "\" "
               + " Color=\"" + rs.getString("color") + "\" "
               + " />");
         }
         rs.close();
         strXML.append("</Productos>");

         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }

      //XML Para Mostrar en la tabla...
      if (strid.equals("26")) {
         String strNombreCorto = request.getParameter("NombreCorto");
         String strColores = request.getParameter("Colores");
         String strTallas = request.getParameter("Tallas");
         String strTallas2 = request.getParameter("Tallas2");
         String strCantidad = request.getParameter("Cantidad");
         String strLPrecios = request.getParameter("LPrecios");
         if (strLPrecios == null) {
            strLPrecios = "1";
         }
         String strSC_ID = request.getParameter("SC_ID");
         if (strSC_ID == null) {
            strSC_ID = "1";
         }
         String[] lstNombreCorto = strNombreCorto.split(",");
         String[] lstColores = strColores.split(",");
         String[] lstTallas = strTallas.split(",");
         String[] lstTallas2 = strTallas2.split(",");
         String[] lstCantidad = strCantidad.split(",");
         StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         int i;
         strXML.append("<ElementosT>");
         for (i = 0; i < lstNombreCorto.length; i++) {
            String strSql = "Select "
               + "vta_producto.*,"
               + "vta_prodprecios.PP_PRECIO as PRECIO,"
               + "vta_prodprecios.PP_APDESC,"
               + "vta_prodprecios.PP_APDESCPTO,"
               + "vta_prodprecios.PP_APDESCNEGO,"
               + "vta_prodprecios.PP_NEGOCIO,"
               + "vta_prodprecios.PP_PUNTOS  "
               + "From vta_producto,vta_prodcat3,vta_prodcat4,vta_prodprecios "
               + "WHERE vta_producto.PR_CATEGORIA3 = vta_prodcat3.PC3_ID "
               + "AND vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID "
               + "AND vta_producto.PR_ID = vta_prodprecios.PR_ID "
               + "AND PC3_DESCRIPCION = '" + lstColores[i].trim() + "' "
               + "AND PC4_DESCRIPCION IN ('" + lstTallas[i].trim() + "','" + lstTallas2[i].trim() + "') "
               + "AND  vta_producto.PR_CODIGO_CORTO = '" + lstNombreCorto[i].trim() + "' "
               + "AND  vta_prodprecios.LP_ID = '" + strLPrecios + "' "
               + "AND  vta_producto.SC_ID = '" + strSC_ID + "' "
               + "Group by vta_producto.PR_CODIGO";
            ResultSet rs = oConn.runQuery(strSql, true);

            while (rs.next()) {
               strXML.append("<ElementoT "
                  + " PR_ID=\"" + rs.getString("PR_ID") + "\" "
                  + " PR_CODIGO=\"" + rs.getString("PR_CODIGO") + "\" "
                  + " PR_DESCRIPCION=\"" + rs.getString("PR_DESCRIPCION") + "\" "
                  + " PRECIO=\"" + rs.getString("PRECIO") + "\" "
                  + " CANTIDAD=\"" + lstCantidad[i] + "\" "
                  + " PR_EXISTENCIA=\"" + rs.getString("PR_EXISTENCIA") + "\" "
                  + " PR_REQEXIST=\"" + rs.getString("PR_REQEXIST") + "\" "
                  + " PR_EXENTO1=\"" + rs.getString("PR_EXENTO1") + "\" "
                  + " PR_EXENTO2=\"" + rs.getString("PR_EXENTO2") + "\" "
                  + " PR_EXENTO3=\"" + rs.getString("PR_EXENTO3") + "\" "
                  + " PP_APDESC=\"" + rs.getString("PP_APDESC") + "\" "
                  + " PP_APDESCPTO=\"" + rs.getString("PP_APDESCPTO") + "\" "
                  + " PP_APDESCNEGO=\"" + rs.getString("PP_APDESCNEGO") + "\" "
                  + " PR_USO_NOSERIE=\"" + rs.getString("PR_USO_NOSERIE") + "\" "
                  + " PR_UNIDADMEDIDA=\"" + rs.getString("PR_UNIDADMEDIDA") + "\" "
                  + " PR_CODBARRAS=\"" + rs.getString("PR_CODBARRAS") + "\" "
                  + " PR_CATEGORIA1=\"" + rs.getString("PR_CATEGORIA1") + "\" "
                  + " PR_CATEGORIA2=\"" + rs.getString("PR_CATEGORIA2") + "\" "
                  + " PR_CATEGORIA3=\"" + rs.getString("PR_CATEGORIA3") + "\" "
                  + " PR_CATEGORIA4=\"" + rs.getString("PR_CATEGORIA4") + "\" "
                  + " PR_CATEGORIA5=\"" + rs.getString("PR_CATEGORIA5") + "\" "
                  + " PR_CATEGORIA6=\"" + rs.getString("PR_CATEGORIA6") + "\" "
                  + " PR_CATEGORIA7=\"" + rs.getString("PR_CATEGORIA7") + "\" "
                  + " PR_CATEGORIA8=\"" + rs.getString("PR_CATEGORIA8") + "\" "
                  + " PR_CATEGORIA9=\"" + rs.getString("PR_CATEGORIA9") + "\" "
                  + " PR_CATEGORIA10=\"" + rs.getString("PR_CATEGORIA10") + "\" "
                  + " PP_NEGOCIO=\"" + rs.getString("PP_NEGOCIO") + "\" "
                  + " PP_PUNTOS=\"" + rs.getString("PP_PUNTOS") + "\" "
                  + " PR_COSTOCOMPRA=\"" + rs.getString("PR_COSTOCOMPRA") + "\" "
                  + " />");
            }
            rs.close();
         }
         strXML.append("</ElementosT>");
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
//XML Para rergesar datos de una factura
      if (strid.equals("28")) {
         String strFAC_ID = request.getParameter("FAC_ID");
         String opDocumento = request.getParameter("Documento");
         int intDocumento = Integer.valueOf(opDocumento);
         String strSQL = "";
         switch (intDocumento) {
            case 3:
               strSQL = "Select "
                  + "PD_ID,"
                  + "PD_REFERENCIA,"
                  + "PD_NOTAS,"
                  + "PD_NUM_GUIA,"
                  + "PD_NOTASPIE,"
                  + "PD_MONEDA,"
                  + "MPE_ID,"
                  + "PD_TIPOCOMP,"
                  + "TKT_DIASCREDITO,"
                  + "PD_FECHA_COBRO "
                  + "From vta_pedidos Where PD_ID = " + strFAC_ID;
               break;
            case 2:
               strSQL = "Select "
                  + "TKT_ID,"
                  + "TKT_REFERENCIA,"
                  + "TKT_NOTAS,"
                  + "TKT_NUM_GUIA,"
                  + "TKT_NOTASPIE,"
                  + "TKT_MONEDA,"
                  + "MPE_ID,"
                  + "TKT_TIPOCOMP,"
                  + "TKT_DIASCREDITO,"
                  + "TKT_FECHA_COBRO "
                  + "From vta_tickets Where TKT_ID = " + strFAC_ID;
               break;
            case 1:
               strSQL = "Select "
                  + "FAC_ID,"
                  + "FAC_REFERENCIA,"
                  + "FAC_NOTAS,"
                  + "FAC_NUM_GUIA,"
                  + "FAC_NOTASPIE,"
                  + "FAC_MONEDA,"
                  + "MPE_ID,"
                  + "FAC_TIPOCOMP,"
                  + "FAC_DIASCREDITO,"
                  + "FAC_FECHA_COBRO "
                  + "From vta_facturas Where FAC_ID = " + strFAC_ID;
               break;
            case 5:
               strSQL = "Select "
                  + "COT_ID,"
                  + "COT_REFERENCIA,"
                  + "COT_NOTAS,"
                  + "COT_NUM_GUIA,"
                  + "COT_NOTASPIE,"
                  + "COT_MONEDA,"
                  + "MPE_ID,"
                  + "COT_TIPOCOMP,"
                  + "COT_DIASCREDITO,"
                  + "COE_ID,"
                  + "COT_FECHA_COBRO "
                  + "From vta_cotiza Where COT_ID = " + strFAC_ID;
               break;
            case 4:
               strSQL = "";
               break;
            default:
         }

         if (!strSQL.equals("")) {

            ResultSet rs = oConn.runQuery(strSQL, true);

            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            String strFecha = "";
            strXML.append("<Facturas>");
            while (rs.next()) {
               switch (intDocumento) {
                  case 1:
                     strXML.append("<Factura ");
                     strXML.append("FAC_ID=\"").append(rs.getString("FAC_ID")).append("\" ");
                     strXML.append("FAC_REFERENCIA=\"").append(rs.getString("FAC_REFERENCIA")).append("\" ");
                     strXML.append("FAC_NOTAS=\"").append(rs.getString("FAC_NOTAS")).append("\" ");
                     strXML.append("FAC_MONEDA=\"").append(rs.getString("FAC_MONEDA")).append("\" ");
                     strFecha = rs.getString("FAC_FECHA_COBRO");
                     if (!strFecha.equals("")) {
                        strFecha = fecha.FormateaDDMMAAAA(strFecha, "/");
                     }
                     strXML.append("FAC_FECHA_COBRO=\"").append(strFecha).append("\" ");
                     strXML.append("FAC_NOTASPIE=\"").append(rs.getString("FAC_NOTASPIE")).append("\" ");
                     strXML.append("FAC_NUM_GUIA=\"").append(rs.getString("FAC_NUM_GUIA")).append("\" ");
                     strXML.append("MPE_ID=\"").append(rs.getString("MPE_ID")).append("\" ");
                     strXML.append("FAC_TIPOCOMP=\"").append(rs.getString("FAC_TIPOCOMP")).append("\" ");
                     strXML.append("FAC_DIAS_CREDITO=\"").append(rs.getString("FAC_DIASCREDITO")).append("\" ");
                     strXML.append(" />");
                     break;
                  case 2:
                     strXML.append("<Factura ");
                     strXML.append("FAC_ID=\"").append(rs.getString("TKT_ID")).append("\" ");
                     strXML.append("FAC_REFERENCIA=\"").append(rs.getString("TKT_REFERENCIA")).append("\" ");
                     strXML.append("FAC_NOTAS=\"").append(rs.getString("TKT_NOTAS")).append("\" ");
                     strXML.append("FAC_MONEDA=\"").append(rs.getString("TKT_MONEDA")).append("\" ");
                     strFecha = rs.getString("TKT_FECHA_COBRO");
                     if (!strFecha.equals("")) {
                        strFecha = fecha.FormateaDDMMAAAA(strFecha, "/");
                     }
                     strXML.append("FAC_FECHA_COBRO=\"").append(strFecha).append("\" ");
                     strXML.append("FAC_NOTASPIE=\"").append(rs.getString("TKT_NOTASPIE")).append("\" ");
                     strXML.append("FAC_NUM_GUIA=\"").append(rs.getString("TKT_NUM_GUIA")).append("\" ");
                     strXML.append("MPE_ID=\"").append(rs.getString("MPE_ID")).append("\" ");
                     strXML.append("FAC_TIPOCOMP=\"").append(rs.getString("TKT_TIPOCOMP")).append("\" ");
                     strXML.append("FAC_DIAS_CREDITO=\"").append(rs.getString("TKT_DIASCREDITO")).append("\" ");
                     strXML.append(" />");
                     break;
                  case 3:
                     strXML.append("<Factura ");
                     strXML.append("FAC_ID=\"").append(rs.getString("PD_ID")).append("\" ");
                     strXML.append("FAC_REFERENCIA=\"").append(rs.getString("PD_REFERENCIA")).append("\" ");
                     strXML.append("FAC_NOTAS=\"").append(rs.getString("PD_NOTAS")).append("\" ");
                     strXML.append("FAC_MONEDA=\"").append(rs.getString("PD_MONEDA")).append("\" ");
                     strXML.append("FAC_DIAS_CREDITO=\"").append(rs.getString("PD_DIASCREDITO")).append("\" ");
                     strFecha = rs.getString("PD_FECHA_COBRO");
                     if (!strFecha.equals("")) {
                        strFecha = fecha.FormateaDDMMAAAA(strFecha, "/");
                     }
                     strXML.append("FAC_FECHA_COBRO=\"").append(strFecha).append("\" ");
                     strXML.append("FAC_NOTASPIE=\"").append(rs.getString("PD_NOTASPIE")).append("\" ");
                     strXML.append("FAC_NUM_GUIA=\"").append(rs.getString("PD_NUM_GUIA")).append("\" ");
                     strXML.append("MPE_ID=\"").append(rs.getString("MPE_ID")).append("\" ");
                     strXML.append("FAC_TIPOCOMP=\"").append(rs.getString("PD_TIPOCOMP")).append("\" ");
                     strXML.append(" />");
                     break;
                  case 5:
                     strXML.append("<Factura ");
                     strXML.append("FAC_ID=\"").append(rs.getString("COT_ID")).append("\" ");
                     strXML.append("FAC_REFERENCIA=\"").append(rs.getString("COT_REFERENCIA")).append("\" ");
                     strXML.append("FAC_NOTAS=\"").append(rs.getString("COT_NOTAS")).append("\" ");
                     strXML.append("FAC_MONEDA=\"").append(rs.getString("COT_MONEDA")).append("\" ");
                     strXML.append("FAC_DIAS_CREDITO=\"").append(rs.getString("COT_DIASCREDITO")).append("\" ");
                     strFecha = rs.getString("COT_FECHA_COBRO");
                     if (!strFecha.equals("")) {
                        strFecha = fecha.FormateaDDMMAAAA(strFecha, "/");
                     }
                     strXML.append("FAC_FECHA_COBRO=\"").append(strFecha).append("\" ");
                     strXML.append("FAC_NOTASPIE=\"").append(rs.getString("COT_NOTASPIE")).append("\" ");
                     strXML.append("FAC_NUM_GUIA=\"").append(rs.getString("COT_NUM_GUIA")).append("\" ");
                     strXML.append("MPE_ID=\"").append(rs.getString("MPE_ID")).append("\" ");
                     strXML.append("FAC_TIPOCOMP=\"").append(rs.getString("COT_TIPOCOMP")).append("\" ");
                     strXML.append("COE_ID=\"").append(rs.getString("COE_ID")).append("\" ");
                     strXML.append(" />");
                     break;
                  default:
               }
            }
            strXML.append("</Facturas>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
      }
      /*Guarda los cambios de una factura*/
      if (strid.equals("29")) {
         String strFAC_ID = request.getParameter("FAC_ID");
         String strFAC_REFERENCIA = request.getParameter("FAC_REFERENCIA");
         String strFAC_NOTAS = request.getParameter("FAC_NOTAS");
         String strFAC_FECHA_COBRO = fecha.FormateaBD(request.getParameter("FAC_FECHA_COBRO"), "/");
         String strFAC_NOTASPIE = request.getParameter("FAC_NOTASPIE");
         String strFAC_NUM_GUIA = request.getParameter("FAC_NUM_GUIA");
         String strFAC_MONEDA = request.getParameter("FAC_MONEDA");
         String strPeriodo = request.getParameter("MPE_ID");
         String strComprobante = request.getParameter("FAC_TIPOCOMP");
         String strDiasCredito = request.getParameter("FAC_DIASCREDITO");
         String opDocumento = request.getParameter("Documento");
         int intDocumento = Integer.valueOf(opDocumento);
         String strSQL = "";
         String strAccion = "";
         switch (intDocumento) {
            case 1:
               strSQL = "Update vta_facturas "
                  + "Set "
                  + "FAC_REFERENCIA = '" + strFAC_REFERENCIA + "',"
                  + "FAC_NOTAS='" + strFAC_NOTAS + "',"
                  + "FAC_FECHA_COBRO = '" + strFAC_FECHA_COBRO + "',"
                  + "FAC_NUM_GUIA = '" + strFAC_NUM_GUIA + "',"
                  + "FAC_MONEDA = " + strFAC_MONEDA + ","
                  + "MPE_ID = " + strPeriodo + ","
                  + "FAC_TIPOCOMP = " + strComprobante + ","
                  + "FAC_DIASCREDITO = " + strDiasCredito + ","
                  + "FAC_NOTASPIE= '" + strFAC_NOTASPIE + "' "
                  + "Where FAC_ID = " + strFAC_ID;
               strAccion = "FACTURAS";
               break;
            case 2:
               strSQL = "Update vta_tickets "
                  + "Set "
                  + "TKT_REFERENCIA = '" + strFAC_REFERENCIA + "',"
                  + "TKT_NOTAS='" + strFAC_NOTAS + "',"
                  + "TKT_FECHA_COBRO = '" + strFAC_FECHA_COBRO + "',"
                  + "TKT_NUM_GUIA = '" + strFAC_NUM_GUIA + "',"
                  + "TKT_MONEDA = " + strFAC_MONEDA + ","
                  + "MPE_ID = " + strPeriodo + ","
                  + "TKT_TIPOCOMP = " + strComprobante + ","
                  + "TKT_NOTASPIE= '" + strFAC_NOTASPIE + "' "
                  + "Where TKT_ID = " + strFAC_ID;
               strAccion = "TICKETS";
               break;
            case 3:
               strSQL = "Update vta_pedidos "
                  + "Set "
                  + "PD_REFERENCIA = '" + strFAC_REFERENCIA + "',"
                  + "PD_NOTAS='" + strFAC_NOTAS + "',"
                  + "PD_FECHA_COBRO = '" + strFAC_FECHA_COBRO + "',"
                  + "PD_NUM_GUIA = '" + strFAC_NUM_GUIA + "',"
                  + "PD_MONEDA = " + strFAC_MONEDA + ","
                  + "MPE_ID = " + strPeriodo + ","
                  + "PD_TIPOCOMP = " + strComprobante + ","
                  + "PD_NOTASPIE= '" + strFAC_NOTASPIE + "' "
                  + "Where PD_ID = " + strFAC_ID;
               strAccion = "PEDIDOS";
               break;
            case 5:
               strSQL = "Update vta_cotiza "
                  + "Set "
                  + "COT_REFERENCIA = '" + strFAC_REFERENCIA + "',"
                  + "COT_NOTAS='" + strFAC_NOTAS + "',"
                  + "COT_FECHA_COBRO = '" + strFAC_FECHA_COBRO + "',"
                  + "COT_NUM_GUIA = '" + strFAC_NUM_GUIA + "',"
                  + "COT_MONEDA = " + strFAC_MONEDA + ","
                  + "MPE_ID = " + strPeriodo + ","
                  + "COT_TIPOCOMP = " + strComprobante + ","
                  + "COT_NOTASPIE= '" + strFAC_NOTASPIE + "' "
                  + "Where COT_ID = " + strFAC_ID;
               strAccion = "COTIZACION";
               break;
            default:
         }
         if (!strSQL.equals("")) {
            oConn.runQueryLMD(strSQL);
            //Bitacora de querys
            Bitacora bitacora = new Bitacora();
            bitacora.GeneraBitacora(strSQL, varSesiones.getStrUser(), strAccion, oConn);
            //Bitacora
            bitacorausers logUser = new bitacorausers();
            logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
            logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
            logUser.setFieldString("BTU_NOMMOD", strAccion);
            logUser.setFieldString("BTU_NOMACTION", "EDICION");
            logUser.setFieldInt("BTU_IDOPER", Integer.valueOf(strFAC_ID));
            logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
            logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
            logUser.Agrega(oConn);

            String strRes = "OK";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.print(strRes);//Pintamos el resultado
         }
      }
      //Cancela el surtido de un pedido
      if (strid.equals("30")) {
         //Recibimos datos
         String strMP_ID = "";
         try {
            strMP_ID = request.getParameter("MP_ID");
         } catch (Exception ex) {
         }
         //Instanciamos el objeto de ventas
         Ticket ticket = new Ticket(oConn, varSesiones, request);
         ticket.setStrTipoVta(Ticket.PEDIDO);
         //Recibimos parametros
         ticket.doSurtidoPedidoCancel(Integer.valueOf(strMP_ID));
         String strRes = ticket.getStrResultLast();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strRes);//Pintamos el resultado
      }
      //Factura de contratos
      if (strid.equals("31")) {

         //Recibimos datos
         int intSC_ID = 0;
         try {
            intSC_ID = Integer.valueOf(request.getParameter("FC_SUC"));
         } catch (Exception ex) {
         }

         int intCTE_ID = 0;
         try {
            intCTE_ID = Integer.valueOf(request.getParameter("FC_CLI"));
         } catch (Exception ex) {
         }
         //Obtenemos mensajes de struts
         SelEmpresaAction sel = new SelEmpresaAction();
         MessageResources msgRes = sel.getmessageResources(request);
         if (msgRes == null) {
            System.out.println("Error el recuerso no llega " + msgRes);

         }
         FacturaContratos fContrato = new FacturaContratos(oConn, varSesiones);
         fContrato.setContext(this.getServletContext());
         fContrato.setIntEMP_ID(varSesiones.getIntIdEmpresa());
         fContrato.setIntCTE_ID(intCTE_ID);
         fContrato.setIntSC_ID(intSC_ID);
         fContrato.setBolAplica(true);
         fContrato.setMsgRes(msgRes);
         fContrato.setStrFechaFactura(fecha.FormateaBD(request.getParameter("F_FAC"), "/"));
         fContrato.setStrFechaInicio(fecha.FormateaBD(request.getParameter("F_INI"), "/"));
         fContrato.setStrFechaFinal(fecha.FormateaBD(request.getParameter("F_FIN"), "/"));
         fContrato.setStrPATHBase(strPathXML);
         fContrato.setStrPathPrivateKeys(strPathPrivateKeys);
         fContrato.setStrPathXML(strPathXML);
         fContrato.setStrPathFonts(strPathFonts);
         fContrato.setStrSerie(request.getParameter("F_SERIE"));
         fContrato.doTrx();

         String strRes = fContrato.getStrResultLast();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strRes);//Pintamos el resultado
      }
      if (strid.equals("16")) {
         //Instanciamos el objeto de ticket
         Ticket pedido = new Ticket(oConn, varSesiones, request);
         pedido.setStrTipoVta(Ticket.PEDIDO);
         //Recibimos parametros
         String strPrefijoMaster = "PD";
         //Asignamos el id de la operacion por anular
         String strIDODC = request.getParameter("PD_ID");
         int intId = 0;
         if (strIDODC == null) {
            strIDODC = "0";
         }
         intId = Integer.valueOf(strIDODC);
         pedido.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
         pedido.Init();
         pedido.doCerrar();
         String strRes = pedido.getStrResultLast();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strRes);//Pintamos el resultado
      }
      //Nos regresa la tasa de impuestos 2 correspondientes a la tasa seleccionada
      if (strid.equals("17")) {
         //Recuperamos el id del cliente
         String strTI_ID = request.getParameter("TI2_ID");
         if (strTI_ID == null) {
            strTI_ID = "0";
         }
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<vta_impuesto>";
         //Consultamos la info
         double dblTasa1 = 0;
         int intT2_RETIENE = 0;
         String strSql = "select TI2_TASA,T2_RETIENE "
            + "from vta_tasa_impuesto2 where TI2_ID = " + strTI_ID;
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            dblTasa1 = rs.getDouble("TI2_TASA");
            intT2_RETIENE = rs.getInt("T2_RETIENE");
         }
         rs.close();
         //El detalle
         strXML += "<vta_impuestos "
            + " Tasa2 = \"" + dblTasa1 + "\"  "
            + " Retiene = \"" + intT2_RETIENE + "\"  "
            + " />";
         strXML += "</vta_impuesto>";
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
      //Nos regresa la tasa de impuestos 3 correspondientes a la tasa seleccionada
      if (strid.equals("18")) {
         //Recuperamos el id del cliente
         String strTI_ID = request.getParameter("TI3_ID");
         if (strTI_ID == null) {
            strTI_ID = "0";
         }
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<vta_impuesto>";
         //Consultamos la info
         double dblTasa1 = 0;
         String strSql = "select TI3_TASA "
            + "from vta_tasa_impuesto3 where TI3_ID = " + strTI_ID;
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            dblTasa1 = rs.getDouble("TI3_TASA");
         }
         rs.close();
         //El detalle
         strXML += "<vta_impuestos "
            + " Tasa3 = \"" + dblTasa1 + "\"  "
            + " />";
         strXML += "</vta_impuesto>";
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
      //Nos regresa el nombre del cliente y la lista de precios asignada
      if (strid.equals("32")) {
         UtilXml utilXML = new UtilXml();
         //Recuperamos el id del cliente
         String strPvId = request.getParameter("PV_ID");
         if (strPvId == null) {
            strPvId = "0";
         }
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<vta_proveedores>";
         //Consultamos la info
         int intPV_ID = 0;
         int intPV_LPRECIOS = 0;
         double dblPV_DESCUENTO = 0;
         int intPV_DIASCREDITO = 0;
         int intPV_TIPOPERS = 0;
         //int intCT_TIPOFAC = 0;
         // String strCT_USOIMBUEBLE = "";
         double dblPV_MONTOCRED = 0;
         String strPV_RAZONSOCIAL = "";

         int intMON_ID = 0;
         int intTI_ID = 0;
         int intTTC_ID = 0;
         String strSql = "select PV_ID,PV_RAZONSOCIAL,PV_LPRECIOS,"
            + "PV_DESCUENTO,PV_DIASCREDITO,PV_MONTOCRED,PV_TIPOPERS,"
            + "MON_ID,TI_ID "
            + "from vta_proveedor where PV_ID = " + strPvId;
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            intPV_ID = rs.getInt("PV_ID");
            intPV_LPRECIOS = rs.getInt("PV_LPRECIOS");
            dblPV_DESCUENTO = rs.getDouble("PV_DESCUENTO");
            intPV_DIASCREDITO = rs.getInt("PV_DIASCREDITO");
            dblPV_MONTOCRED = rs.getDouble("PV_MONTOCRED");
            strPV_RAZONSOCIAL = rs.getString("PV_RAZONSOCIAL");
            intPV_TIPOPERS = rs.getInt("PV_TIPOPERS");
            //  intCT_TIPOFAC = rs.getInt("CT_TIPOFAC");
            //strCT_USOIMBUEBLE = rs.getString("CT_USOIMBUEBLE");
            if (!strPV_RAZONSOCIAL.equals("")) {
               strPV_RAZONSOCIAL = utilXML.Sustituye(strPV_RAZONSOCIAL);
            }
            intMON_ID = rs.getInt("MON_ID");
            intTI_ID = rs.getInt("TI_ID");

         }
         rs.close();
         //El detalle
         strXML += "<vta_proveedores "
            + " PV_ID = \"" + intPV_ID + "\"  "
            + " PV_RAZONSOCIAL = \"" + strPV_RAZONSOCIAL + "\"  "
            + " PV_LPRECIOS = \"" + intPV_LPRECIOS + "\"  "
            + " PV_DESCUENTO = \"" + dblPV_DESCUENTO + "\"  "
            + " PV_DIASCREDITO = \"" + intPV_DIASCREDITO + "\"  "
            + " PV_MONTOCRED = \"" + dblPV_MONTOCRED + "\"  "
            + " PV_TIPOPERS = \"" + intPV_TIPOPERS + "\"  "
            + " MON_ID = \"" + intMON_ID + "\"  "
            + " TI_ID = \"" + intTI_ID + "\"  "
            + " />";
         strXML += "</vta_proveedores>";
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
      //Regresa los datos de una cotización para venderlo
      if (strid.equals("33")) {
         String strCOT_ID = request.getParameter("COT_ID");
         if (strCOT_ID == null) {
            strCOT_ID = "0";
         }
         StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         String[] lstCotiza = strCOT_ID.split(",");
         if (lstCotiza.length > 1) {
            strXML.append("<vta_cotizaciones> ");
         }
         for (int iPed = 0; iPed < lstCotiza.length; iPed++) {
            strXML.append("<vta_cotiza ");
            //Recuperamos info de pedidos
            vta_cotiza cotiza = new vta_cotiza();
            cotiza.ObtenDatos(Integer.valueOf(lstCotiza[iPed]), oConn);
            String strValorPar = cotiza.getFieldPar();
            strXML.append(strValorPar + " > ");
            //Obtenemos el detalle
            vta_cotizadeta deta = new vta_cotizadeta();
            ArrayList<TableMaster> lstDeta = deta.ObtenDatosVarios(" COT_ID = " + cotiza.getFieldInt("COT_ID"), oConn);
            Iterator<TableMaster> it = lstDeta.iterator();
            ResultSet rs = null;
            String strSql;
            while (it.hasNext()) {
               TableMaster tbn = it.next();
               int intPR_REQEXIST = 0;
               double dblExistencia = 0;
               String strPR_CODBARRAS = "";
               int intPR_USO_NOSERIE = 0;
               int intPR_CATEGORIA1 = 0;
               int intPR_CATEGORIA2 = 0;
               int intPR_CATEGORIA3 = 0;
               int intPR_CATEGORIA4 = 0;
               int intPR_CATEGORIA5 = 0;
               int intPR_CATEGORIA6 = 0;
               int intPR_CATEGORIA7 = 0;
               int intPR_CATEGORIA8 = 0;
               int intPR_CATEGORIA9 = 0;
               int intPR_CATEGORIA10 = 0;
               //Consultamos la existencia y si requiera de existencia para su venta
               strSql = "select PR_REQEXIST,PR_EXISTENCIA,PR_CODBARRAS,PR_USO_NOSERIE "
                  + ",PR_CATEGORIA1,PR_CATEGORIA2,PR_CATEGORIA3,PR_CATEGORIA4,PR_CATEGORIA5,"
                  + "PR_CATEGORIA6,PR_CATEGORIA7,PR_CATEGORIA8,PR_CATEGORIA9,PR_CATEGORIA10 "
                  + " from vta_producto where PR_ID = " + tbn.getFieldInt("PR_ID");
               rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  intPR_REQEXIST = rs.getInt("PR_REQEXIST");
                  dblExistencia = rs.getDouble("PR_EXISTENCIA");
                  strPR_CODBARRAS = rs.getString("PR_CODBARRAS");
                  intPR_USO_NOSERIE = rs.getInt("PR_USO_NOSERIE");
                  intPR_CATEGORIA1 = rs.getInt("PR_CATEGORIA1");
                  intPR_CATEGORIA2 = rs.getInt("PR_CATEGORIA2");
                  intPR_CATEGORIA3 = rs.getInt("PR_CATEGORIA3");
                  intPR_CATEGORIA4 = rs.getInt("PR_CATEGORIA4");
                  intPR_CATEGORIA5 = rs.getInt("PR_CATEGORIA5");
                  intPR_CATEGORIA6 = rs.getInt("PR_CATEGORIA6");
                  intPR_CATEGORIA7 = rs.getInt("PR_CATEGORIA7");
                  intPR_CATEGORIA8 = rs.getInt("PR_CATEGORIA8");
                  intPR_CATEGORIA9 = rs.getInt("PR_CATEGORIA9");
                  intPR_CATEGORIA10 = rs.getInt("PR_CATEGORIA10");
               }
               rs.close();
               strXML.append("<deta ");
               strXML.append(tbn.getFieldPar() + " PR_REQEXIST = \"" + intPR_REQEXIST + "\" PR_USO_NOSERIE=\"" + intPR_USO_NOSERIE + "\" "
                  + " PR_EXISTENCIA=\"" + dblExistencia + "\" PR_CODBARRAS=\"" + strPR_CODBARRAS + "\""
                  + " PR_CAT1 = \"" + intPR_CATEGORIA1 + "\"  "
                  + " PR_CAT2 = \"" + intPR_CATEGORIA2 + "\"  "
                  + " PR_CAT3 = \"" + intPR_CATEGORIA3 + "\"  "
                  + " PR_CAT4 = \"" + intPR_CATEGORIA4 + "\"  "
                  + " PR_CAT5 = \"" + intPR_CATEGORIA5 + "\"  "
                  + " PR_CAT6 = \"" + intPR_CATEGORIA6 + "\"  "
                  + " PR_CAT7 = \"" + intPR_CATEGORIA7 + "\"  "
                  + " PR_CAT8 = \"" + intPR_CATEGORIA8 + "\"  "
                  + " PR_CAT9 = \"" + intPR_CATEGORIA9 + "\"  "
                  + " PR_CAT10 = \"" + intPR_CATEGORIA10 + "\"  ");
               //Si usa numeros de serie buscamos los numeros de serie vinculados al surtimiento de este cotiza(en caso de aplicar)
               if (intPR_USO_NOSERIE == 1) {
                  strXML.append(">");
                  //Consulta de movimientos de producto ligados a este cotiza
                  String strSqlProd = "SELECT MPD_ID,PL_NUMLOTE,MPD_SERIE_VENDIDO FROM vta_movproddeta "
                     + "WHERE MPD_IDORIGEN = " + tbn.getFieldInt("PDD_ID") + " AND MPD_SALIDAS > 0";
                  rs = oConn.runQuery(strSqlProd, true);
                  while (rs.next()) {
                     int intMPD_ID = rs.getInt("MPD_ID");
                     String strPL_NUMLOTE = rs.getString("PL_NUMLOTE");
                     int intMPD_SERIE_VENDIDO = rs.getInt("MPD_SERIE_VENDIDO");
                     strXML.append("<series MPD_ID=\"" + intMPD_ID + "\" PL_NUMLOTE=\"" + strPL_NUMLOTE + "\" MPD_SERIE_VENDIDO=\"" + intMPD_SERIE_VENDIDO + "\" "
                        + "/>");
                  }
                  rs.close();
                  strXML.append("</deta>");
               } else {
                  strXML.append("/>");
               }

            }
            strXML.append("</vta_cotiza>");
         }
         if (lstCotiza.length > 1) {
            strXML.append("</vta_cotizaciones> ");
         }
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML.toString());//Pintamos el resultado
      }
      /*Guarda los cambios del estatus*/
      if (strid.equals("34")) {
         String strFAC_ID = request.getParameter("FAC_ID");
         String strCOE_ID = request.getParameter("COE_ID");

         String opDocumento = request.getParameter("Documento");
         int intDocumento = Integer.valueOf(opDocumento);
         String strSQL = "";
         switch (intDocumento) {
            case 1:
               strSQL = "Update vta_facturas "
                  + "Set "
                  + "FACE_ID = '" + strCOE_ID + "' "
                  + "Where FAC_ID = " + strFAC_ID;

               break;
            case 2:
               strSQL = "Update vta_tickets "
                  + "Set "
                  + "TKTE_ID = '" + strCOE_ID + "' "
                  + "Where TKT_ID = " + strFAC_ID;
               break;
            case 3:
               strSQL = "Update vta_pedidos "
                  + "Set "
                  + "PDE_ID = '" + strCOE_ID + "' "
                  + "Where PD_ID = " + strFAC_ID;
               break;
            case 5:
               strSQL = "Update vta_cotiza "
                  + "Set "
                  + "COE_ID = '" + strCOE_ID + "' "
                  + "Where COT_ID = " + strFAC_ID;
               break;
            default:
         }
         if (!strSQL.equals("")) {
            oConn.runQueryLMD(strSQL);
            //Bitacora
            bitacorausers logUser = new bitacorausers();
            logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
            logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
            logUser.setFieldString("BTU_NOMMOD", "VENTAS");
            logUser.setFieldString("BTU_NOMACTION", "ESTATUS");
            logUser.setFieldInt("BTU_IDOPER", Integer.valueOf(strFAC_ID));
            logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
            logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
            logUser.Agrega(oConn);

            String strRes = "OK";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.print(strRes);//Pintamos el resultado
         }
      }
      /*Guarda los cambios del estatus*/
      if (strid.equals("40")) {
         String strMAS_CTEID = request.getParameter("MAS_CTEID");
         String strEMP_ID = request.getParameter("EMP_ID");
         String strSC_ID = request.getParameter("SC_ID");
         String strMAS_PAGADOS = request.getParameter("MAS_PAGADOS");
         String strMAS_SALDO = request.getParameter("MAS_SALDO");
         String strMAS_TIPODOCUMENTO = request.getParameter("MAS_TIPODOCUMENTO");
         int intCliente = Integer.valueOf(strMAS_CTEID);
         int intEMP_ID = 0;
         if (varSesiones.getIntIdEmpresa() != 0) {
            intEMP_ID = varSesiones.getIntIdEmpresa();
         } else {
            intEMP_ID = Integer.valueOf(strEMP_ID);
         }
         int intSC_ID = Integer.valueOf(strSC_ID);
         int intPedidosPagados = Integer.valueOf(strMAS_PAGADOS);
         double dblClientesSaldoMenor = Double.valueOf(strMAS_SALDO);
         String strFechaFactura = request.getParameter("MAS_FECHAFACTURA");
         if (!strFechaFactura.isEmpty()) {
            strFechaFactura = fecha.FormateaBD(strFechaFactura, "/");
         }
         String strFechaIni = request.getParameter("MAS_FECINI");
         String strFechaFin = request.getParameter("MAS_FECFIN");
         String strFiltro = "";
         //Filtro EMPRESA
         if (intEMP_ID > 0) {
            strFiltro += " AND EMP_ID = " + intEMP_ID;
         }
         //Filtro BODEGA
         if (intSC_ID > 0) {
            strFiltro += " AND SC_ID = " + intSC_ID;
         }
         //Filtro cliente
         if (intCliente > 0) {
            strFiltro += " AND CT_ID = " + intCliente;
         }

         //Filtro Fecha inicial y final
         if (!strFechaIni.isEmpty() && !strFechaFin.isEmpty()) {
            strFiltro = " AND PD_FECHA >= '" + strFechaIni + "' AND PD_FECHA <= '" + strFechaFin + "' ";
         }
         /*
          System.out.println("intEMP_ID:" + intEMP_ID);
          System.out.println("strFiltro:" + strFiltro);
          System.out.println("strMAS_TIPODOCUMENTO:" + strMAS_TIPODOCUMENTO);
          System.out.println("intPedidosPagados:" + intPedidosPagados);
          System.out.println("dblClientesSaldoMenor:" + dblClientesSaldoMenor);*/
         FacturaMasivaPedidos facturaPedidos = new FacturaMasivaPedidos(oConn, varSesiones, request);
         facturaPedidos.setStrFiltro(strFiltro);
         facturaPedidos.setIntPedidosPagados(intPedidosPagados);
         facturaPedidos.setDblClientesSaldoMenor(dblClientesSaldoMenor);
         facturaPedidos.setStrFechaFactura(strFechaFactura);
         facturaPedidos.setStrTipoVta(Ticket.TICKET);
         if (strMAS_TIPODOCUMENTO.equals("1")) {
            facturaPedidos.setStrTipoVta(Ticket.FACTURA);
         }
         facturaPedidos.Init();
         facturaPedidos.doTrx();
         String strResp = facturaPedidos.getStrResultLast().replace("\n", "<br>");
         if (strResp.equals("OK")) {
            strResp = "PROCESO TERMINADO EXITOSAMENTE";
            strResp += "<br>Exitosos: " + facturaPedidos.getIntContadorExitosos();
            strResp += "<br>Fallidos: " + facturaPedidos.getIntContadorFallidos();
         } else {
            strResp += "<br>Exitosos: " + facturaPedidos.getIntContadorExitosos();
            strResp += "<br>Fallidos: " + facturaPedidos.getIntContadorFallidos();
         }
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.print(strResp);//Pintamos el resultado
      }
   } else {
      out.print("Sin Acceso");
   }
   oConn.close();
%>