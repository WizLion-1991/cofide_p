<%-- 
    Document   : ERP_Compras
    Created on : 09-ago-2012, 13:08:31
    Author     : aleph_79
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="Tablas.vta_cxpagardetalle"%>
<%@page import="Tablas.vta_movproddeta"%>
<%@page import="Tablas.vta_movprod"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Tablas.vta_compra"%>
<%@page import="Tablas.vta_compradeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="ERP.Compras"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*
    * Obtenemos las variables de sesion
    */
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
      String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBALODC");
      if (strfolio_GLOBAL == null) {
         strfolio_GLOBAL = "SI";
      }
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Genera una nueva operacion de compras
         if (strid.equals("1")) {
            //Instanciamos el objeto que generara la venta
            Compras compra = new Compras(oConn, varSesiones, request);
            //Recibimos parametros
            String strPrefijoMaster = "COM";
            String strPrefijoDeta = "COMD";
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               compra.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            }
            //Validamos si usaremos un folio global
            if (strfolio_GLOBAL.equals("NO")) {
               compra.setBolFolioGlobal(false);
            }
            //Recibimos datos para el encabezado

            //Si llega el campo de pedido entonces estamos editando un pedido
            if (request.getParameter("COM_ID") != null) {
               compra.getDocument().setFieldInt("COM_ID", Integer.valueOf(request.getParameter("COM_ID")));
               //Validamos si la modificacion de un pedido
               if (compra.getDocument().getFieldInt("COM_ID") != 0) {
                  //Generamos transaccion
                  compra.getDocument().setValorKey(compra.getDocument().getFieldInt("COM_ID") + "");
                  compra.Init();
               }
            }

            compra.getDocument().setFieldInt("TOD_ID", Integer.valueOf(request.getParameter("COM_TIPO")));
            compra.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
            compra.getDocument().setFieldInt("PV_ID", Integer.valueOf(request.getParameter("PV_ID")));
            compra.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
            compra.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA"), "/"));
            compra.getDocument().setFieldString("PED_COD", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_PEDIMENTO"), "/"));
            compra.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", request.getParameter(strPrefijoMaster + "_NOTAS"));
            compra.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));
            compra.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", request.getParameter(strPrefijoMaster + "_NOTASPIE"));
            compra.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", request.getParameter(strPrefijoMaster + "_FORMADEPAGO"));
            compra.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));
            if (request.getParameter(strPrefijoMaster + "_METODOPAGO") != null) {
               compra.getDocument().setFieldString(strPrefijoMaster + "_METODOPAGO", request.getParameter(strPrefijoMaster + "_METODOPAGO"));
            }
            if (request.getParameter(strPrefijoMaster + "_NUMCUENTA") != null) {
               compra.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", request.getParameter(strPrefijoMaster + "_NUMCUENTA"));
            }
            if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
               compra.getDocument().setFieldInt("MON_ID", 1);
            } else {
               compra.getDocument().setFieldInt("MON_ID", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
            }
            if (request.getParameter(strPrefijoMaster + "_TASAPESO") != null) {
               if (Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")) == 0) {
                  compra.getDocument().setFieldDouble("COM_PARIDAD", 1);
               } else {
                  compra.getDocument().setFieldDouble("COM_PARIDAD", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASAPESO")));
               }
            } else {
               compra.getDocument().setFieldDouble("COM_PARIDAD", 1);
            }
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               compra.getDocument().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
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
               System.out.println("ERP_Compras TI_ID " + ex.getMessage());
            }
            //Asignamos los valores al objeto
            compra.getDocument().setFieldInt("TI_ID", intTI_ID);
            compra.getDocument().setFieldInt("TI_ID2", intTI_ID2);
            compra.getDocument().setFieldInt("TI_ID3", intTI_ID3);
            //Validamos IEPS
            if (request.getParameter(strPrefijoMaster + "_USO_IEPS") != null) {
               try {
                  compra.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_USO_IEPS")));
                  compra.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TASA_IEPS")));
                  compra.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE_IEPS").replaceAll(",", "")));
               } catch (NumberFormatException ex) {
               }
            }
            compra.getDocument().setFieldString(strPrefijoMaster + "_DIASCREDITO", request.getParameter(strPrefijoMaster + "_DIASCREDITO"));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE").replaceAll(",", "")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO1").replaceAll(",", "")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO2").replaceAll(",", "")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO3").replaceAll(",", "")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(request.getParameter(strPrefijoMaster + "_TOTAL").replaceAll(",", "")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA1")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA2")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA3")));
            compra.getDocument().setFieldDouble(strPrefijoMaster + "_PORDESCUENTO", Double.valueOf(request.getParameter(strPrefijoMaster + "_DESCUENTO")));
            try {
               compra.getDocument().setFieldInt("PED_ID", Integer.valueOf(request.getParameter("PED_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras PE_ID " + ex.getMessage());
            }

            compra.getDocument().setFieldString(strPrefijoMaster + "_METODO_ENVIO", request.getParameter(strPrefijoMaster + "_METODO_ENVIO"));
            if (request.getParameter(strPrefijoMaster + "_FECHA_PROMESA") != null) {
               if (!request.getParameter(strPrefijoMaster + "_FECHA_PROMESA").isEmpty()) {
                  compra.getDocument().setFieldString(strPrefijoMaster + "_FECHA_PROMESA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA_PROMESA"), "/"));
               }

            }
            //CAMPOS ENVIO VENTAS
            try {
               compra.getDocument().setFieldInt("TR_ID", Integer.valueOf(request.getParameter("TR_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras TR_ID " + ex.getMessage());
            }
            if (request.getParameter(strPrefijoMaster + "_NUM_GUIA") != null) {
               compra.getDocument().setFieldString(strPrefijoMaster + "_NUM_GUIA", request.getParameter(strPrefijoMaster + "_NUM_GUIA"));
            }
            if (request.getParameter(strPrefijoMaster + "_FECHA_DISP_VTA") != null) {
               if (!request.getParameter(strPrefijoMaster + "_FECHA_DISP_VTA").isEmpty()) {
                  compra.getDocument().setFieldString(strPrefijoMaster + "_FECHA_DISP_VTA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA_DISP_VTA"), "/"));
               }

            }

            try {
               compra.getDocument().setFieldInt("CDE_ID", Integer.valueOf(request.getParameter("CDE_ID")));
            } catch (NumberFormatException ex) {
               System.out.println("ERP_Compras CDE_ID " + ex.getMessage());
            }
            compra.getDocument().setFieldString(strPrefijoMaster + "_TIPOFLETE", request.getParameter(strPrefijoMaster + "_TIPOFLETE"));

            //Recibimos datos de los items o partidas
            int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
            for (int i = 1; i <= intCount; i++) {
               TableMaster deta = null;
               deta = new vta_compradeta();

               deta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
               deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO1" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO2" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO3" + i)));
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
               deta.setFieldDouble(strPrefijoDeta + "_COSTO", Double.valueOf(request.getParameter(strPrefijoDeta + "_COSTO" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_DESCUENTO", Double.valueOf(request.getParameter(strPrefijoDeta + "_DESCUENTO" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_PORDESC", Double.valueOf(request.getParameter(strPrefijoDeta + "_PORDESC" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_COSTOREAL", Double.valueOf(request.getParameter(strPrefijoDeta + "_COSTOREAL" + i)));
               deta.setFieldString(strPrefijoDeta + "_NOTAS", request.getParameter(strPrefijoDeta + "_NOTAS" + i));
               //UNIDAD DE MEDIDA UNIDAD_MEDIDA
               if (request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i) != null) {
                  deta.setFieldString(strPrefijoDeta + "_UNIDAD_MEDIDA", request.getParameter(strPrefijoDeta + "_UNIDAD_MEDIDA" + i));
               }
               if (request.getParameter(strPrefijoDeta + "_MONEDA" + i) != null) {
                  try {
                     deta.setFieldInt(strPrefijoDeta + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoDeta + "_MONEDA" + i)));
                  } catch (NumberFormatException ex) {
                     System.out.println("ERP_Compras COMD_MONEDA " + ex.getMessage());
                  }
               }
               if (request.getParameter(strPrefijoDeta + "_PARIDAD" + i) != null) {
                  try {
                     deta.setFieldDouble(strPrefijoDeta + "_PARIDAD", Double.valueOf(request.getParameter(strPrefijoDeta + "_PARIDAD" + i)));
                  } catch (NumberFormatException ex) {
                     System.out.println("ERP_Compras COMD_PARIDAD " + ex.getMessage());
                  }
               }
               compra.AddDetalle(deta);
            }

            //Inicializamos objeto
            //Validamos si es un pedido que se esta editando para solo modificar el pedido anterior
            if (compra.getDocument().getFieldInt("COM_ID") != 0) {
               compra.doTrxMod();
            } else {
               compra.Init();
               //Generamos transaccion
               compra.doTrx();
            }
            String strRes = "";
            if (compra.getStrResultLast().equals("OK")) {
               strRes = "OK." + compra.getDocument().getValorKey();
            } else {
               strRes = compra.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         // <editor-fold defaultstate="collapsed" desc="Cancela una Orden de compra">
         if (strid.equals("2")) {
            //Instanciamos el ticvet
            Compras compras = new Compras(oConn, varSesiones, request);
            //Recibimos parametros
            String strPrefijoMaster = "COM";
            //Asignamos el id de la operacion por anular
            String strIdAnul = request.getParameter("COM_ID");
            int intId = 0;
            if (strIdAnul == null) {
               strIdAnul = "0";
            }
            intId = Integer.valueOf(strIdAnul);
            compras.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
            compras.Init();
            compras.doTrxAnul();
            String strRes = compras.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         // <editor-fold defaultstate="collapsed" desc="Autorizar una Orden de compra">
         if (strid.equals("3")) {
            //Instanciamos el objeto de compras
            Compras compras = new Compras(oConn, varSesiones, request);
            //Recibimos parametros
            String strPrefijoMaster = "COM";
            //Asignamos el id de la operacion por anular
            String strIdAnul = request.getParameter("COM_ID");
            int intId = 0;
            if (strIdAnul == null) {
               strIdAnul = "0";
            }
            intId = Integer.valueOf(strIdAnul);
            compras.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
            compras.Init();
            compras.doAutoriza();
            String strRes = compras.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Carga los datos de las recepciones de compra
         if (strid.equals("8")) {
            String strXML = "";
            //Objeto de compras
            Compras compras = new Compras(oConn, varSesiones, request);
            strXML = compras.GeneraXMLConfirmacion(request.getParameter("COM_ID"),
                    request.getParameter("INV_ID"));
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Valida el pedimento
         if (strid.equals("9")) {
            UtilXml utilXML = new UtilXml();
            //Recuperamos el id del cliente
            String strPEDICOD = request.getParameter("PEDIMENTO");
            if (strPEDICOD == null) {
               strPEDICOD = "0";
            }
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_pedimento>";
            //Consultamos la info
            int intPED_ID = 0;
            int intPED_APLICADO = 0;
            String strPED_COD = "";
            String strPED_DESC = "";
            String strSql = "select * "
                    + "from vta_pedimentos where PED_COD = '" + strPEDICOD + "'  "
                     + " and EMP_ID  = " + varSesiones.getIntIdEmpresa();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intPED_ID = rs.getInt("PED_ID");
               intPED_APLICADO = rs.getInt("PED_APLICADO");
               strPED_COD = rs.getString("PED_COD");
               strPED_DESC = rs.getString("PED_DESC");
               if (!strPED_DESC.equals("")) {
                  strPED_DESC = utilXML.Sustituye(strPED_DESC);
               }
            }
            rs.close();
            //El detalle
            strXML += "<vta_pedimentos "
                    + " PED_ID = \"" + intPED_ID + "\"  "
                    + " PED_COD = \"" + strPED_COD + "\"  "
                    + " PED_DESC = \"" + strPED_DESC + "\"  "
                    + " PED_APLICADO = \"" + intPED_APLICADO + "\"  "
                    + " />";
            strXML += "</vta_pedimento>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Recepcion de una orden de compra
         if (strid.equals("10")) {
            //Recibimos datos
            String strFechaRecepcion = "";
            try {
               strFechaRecepcion = fecha.FormateaBD(request.getParameter("COM_FECHA"), "/");
            } catch (Exception ex) {
            }

            //Instanciamos el objeto de compras
            Compras compras = new Compras(oConn, varSesiones, request);
            //Recibimos parametros
            String strPrefijoMaster = "COM";
            //Asignamos el id de la operacion por anular
            String strIdRecep = request.getParameter("COM_ID");
            int intId = 0;
            if (strIdRecep == null) {
               strIdRecep = "0";
            }
            intId = Integer.valueOf(strIdRecep);
            compras.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
            //Recibimos datos de los items o partidas
            int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
            for (int i = 1; i <= intCount; i++) {
               TableMaster deta = null;

               deta = new vta_compradeta();
               deta.setFieldInt("COMD_ID", Integer.valueOf(request.getParameter("COMD_ID" + i)));
               deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
               deta.setFieldDouble("COMD_CANTIDADSURTIDA", Double.valueOf(request.getParameter("COMD_CANTIDADSURTIDA" + i)));
               deta.setFieldDouble("COMD_COSTO", Double.valueOf(request.getParameter("COMD_COSTO" + i)));
               deta.setFieldString("COMD_CVE", request.getParameter("COMD_CVE" + i));
               deta.setFieldDouble("COMD_FACTOR", Double.valueOf(request.getParameter("COMD_FACTOR" + i)));
               deta.setFieldString("COMD_USASERIE", request.getParameter("COMD_USASERIE" + i));
               deta.setFieldString("COMD_SERIES", request.getParameter("COMD_SERIES" + i));

               String strFechaCaducidad = "";
               try {
                  strFechaCaducidad = fecha.FormateaBD(request.getParameter("COMD_FECHACAD" + i), "/");
               } catch (Exception ex) {
               }

               deta.setFieldString("COMD_FECHACAD", strFechaCaducidad);

               compras.AddDetalle(deta);
            }
            compras.Init();
            compras.doRecepcion(strFechaRecepcion, "", "", "");

            String strRes = compras.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Confirmacion de una orden de compra
         if (strid.equals("11")) {
            //Recibimos datos
            String strFechaRecepcion = "";
            try {
               strFechaRecepcion = fecha.FormateaBD(request.getParameter("COM_FECHA"), "/");
            } catch (Exception ex) {
            }
            String strFechaConfirma = "";
            try {
               strFechaConfirma = fecha.FormateaBD(request.getParameter("CXP_FECHA_CONFIRMA"), "/");
            } catch (Exception ex) {
            }
            //Instanciamos el objeto de compras
            Compras compras = new Compras(oConn, varSesiones, request);
            //Recibimos parametros
            //Asignamos el id de la operacion por confirmar(Orden de compra)
            String strIdRecep = request.getParameter("COM_ID");
            //int intId = 0;
            if (strIdRecep == null) {
               strIdRecep = "0";
            }
            //intId = Integer.valueOf(strIdRecep);
            String strPedimento = request.getParameter("COM_PEDIMENTO");
            String strFolioFactura = request.getParameter("COM_FOLIOF");
            String strCXP_UUID = request.getParameter("COM_UUID");
            int intIdPedimento = 0;
            //Recibimos numericos
            try {
               intIdPedimento = Integer.valueOf(request.getParameter("PED_ID"));
            } catch (NumberFormatException ex) {
            }
            double dblImporte = 0, dblImpuesto1 = 0, dblImpuesto2 = 0, dblImpuesto3 = 0, dblTotal = 0, dblIEPS = 0, dblDescuento = 0;
            //Recibimos importes
            try {
               dblImporte = Double.valueOf(request.getParameter("COM_SUBTOT").replace(",", ""));
               dblImpuesto1 = Double.valueOf(request.getParameter("COM_IMPUESTO1").replace(",", ""));
               dblImpuesto2 = Double.valueOf(request.getParameter("COM_IMPUESTO2").replace(",", ""));
               dblImpuesto3 = Double.valueOf(request.getParameter("COM_IMPUESTO3").replace(",", ""));
               dblTotal = Double.valueOf(request.getParameter("COM_TOT").replace(",", ""));
               dblIEPS = Double.valueOf(request.getParameter("COM_IEPS").replace(",", ""));
               dblDescuento = Double.valueOf(request.getParameter("COM_DESCUENTO").replace(",", ""));
            } catch (NumberFormatException ex) {
            }
            //compras.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
            //Recibimos datos de los items o partidas
            int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
            for (int i = 1; i <= intCount; i++) {
               TableMaster deta = new vta_cxpagardetalle();
               deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
               deta.setFieldInt("CXPD_EXENTO1", Integer.valueOf(request.getParameter("COMD_EXENTO1" + i)));
               deta.setFieldInt("CXPD_EXENTO2", Integer.valueOf(request.getParameter("COMD_EXENTO2" + i)));
               deta.setFieldInt("CXPD_EXENTO3", Integer.valueOf(request.getParameter("COMD_EXENTO3" + i)));
               deta.setFieldString("CXPD_CVE", request.getParameter("COMD_CVE" + i));
               deta.setFieldString("CXPD_DESCRIPCION", request.getParameter("COMD_DESCRIPCION" + i));
               deta.setFieldDouble("CXPD_IMPORTE", Double.valueOf(request.getParameter("COMD_IMPORTE" + i)));
               deta.setFieldDouble("CXPD_DESCUENTO", Double.valueOf(request.getParameter("COMD_DESCUENTO" + i)));
               deta.setFieldDouble("CXPD_CANTIDAD", Double.valueOf(request.getParameter("COMD_CANTIDADSURTIDA" + i)));
               if (Integer.valueOf(request.getParameter("COMD_PRORRATEO" + i)) == 1) {
                  deta.setFieldDouble("CXPD_CANTIDAD", Double.valueOf(request.getParameter("COMD_CANTIDAD" + i)));
               }
               deta.setFieldDouble("CXPD_IMPUESTO1", Double.valueOf(request.getParameter("COMD_IMPUESTO1" + i)));
               deta.setFieldDouble("CXPD_IMPUESTO2", Double.valueOf(request.getParameter("COMD_IMPUESTO2" + i)));
               deta.setFieldDouble("CXPD_IMPUESTO3", Double.valueOf(request.getParameter("COMD_IMPUESTO3" + i)));
               deta.setFieldDouble("CXPD_COSTO", Double.valueOf(request.getParameter("COMD_COSTO" + i)));
               deta.setFieldDouble("CXPD_RET_ISR", 0);
               deta.setFieldDouble("CXPD_RET_IVA", 0);
               deta.setFieldInt("MPD_ID", Integer.valueOf(request.getParameter("COMD_ID" + i)));
               deta.setFieldInt("MP_ID", Integer.valueOf(request.getParameter("COMD_MP_ID" + i)));
               deta.setFieldInt("GT_ID", Integer.valueOf(request.getParameter("COMD_CGID" + i)));
               deta.setFieldInt("CXPD_PRORRATEO", Integer.valueOf(request.getParameter("COMD_PRORRATEO" + i)));
               compras.getLstMovsRecep().add(deta);
            }
            //Comenzamos el guardado
            compras.Init();
            compras.doConfirmacion(strIdRecep, strFechaRecepcion, strFechaConfirma, strPedimento, strFolioFactura,
                    intIdPedimento, dblImporte, dblImpuesto1, dblImpuesto2, dblImpuesto3, dblTotal, dblIEPS, dblDescuento, strCXP_UUID);
            String strRes = compras.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
      }
      // <editor-fold defaultstate="collapsed" desc="Cerrar una Orden de compra">
      if (strid.equals("12")) {
         //Instanciamos el objeto de compras
         Compras compras = new Compras(oConn, varSesiones, request);
         //Recibimos parametros
         String strPrefijoMaster = "COM";
         //Asignamos el id de la operacion por anular
         String strIDODC = request.getParameter("COM_ID");
         int intId = 0;
         if (strIDODC == null) {
            strIDODC = "0";
         }
         intId = Integer.valueOf(strIDODC);
         compras.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
         compras.Init();
         compras.doCerrar();
         String strRes = compras.getStrResultLast();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strRes);//Pintamos el resultado
      }
      //Carga los datos de las recepciones de compra
      if (strid.equals("13")) {
         //Objeto de compras
         Compras compras = new Compras(oConn, varSesiones, request);
         String strXML = compras.RegresaConversion(request.getParameter("lstIds"));
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
      //XML Para obtener el costo de un producto...
      if (strid.equals("14")) {
         String strCodigo = request.getParameter("codigo");
         String strBodega = request.getParameter("SC_ID");
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         String strSql = "select PR_COSTOCOMPRA from"
                 + " vta_producto where (PR_CODIGO='" + strCodigo + "' OR PR_CODIGO_CORTO='" + strCodigo + "') "
                 + " and EMP_ID  = " + varSesiones.getIntIdEmpresa() 
                 + " and SC_ID  = " + strBodega ;
         ResultSet rs = oConn.runQuery(strSql, true);
         strXML += "<Datos>";
         while (rs.next()) {
            strXML += "<costo "
                    + " PR_COSTO=\"" + rs.getDouble("PR_COSTOCOMPRA") + "\" "
                    + " />";
         }
         rs.close();
         strXML += "</Datos>";

         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
   } else {
   }
   oConn.close();
%>