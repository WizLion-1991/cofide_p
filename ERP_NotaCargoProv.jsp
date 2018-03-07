<%-- 
    Document   : ERP_NotaCargoProv
Genera las operaciones para las notas de cargo de proveedor
    Created on : 23-dic-2015, 6:57:51
    Author     : ZeusSIWEB
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="Tablas.VtaNotasCargosProvDeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.mx.siweb.erp.notascargo.NotasCargoProveedor"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
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
      String strClienteUniversal = this.getServletContext().getInitParameter("ClienteUniversal");
      String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
      String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
      String strPathBase = this.getServletContext().getRealPath("/");
      if (strfolio_GLOBAL == null) {
         strfolio_GLOBAL = "SI";
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
            NotasCargoProveedor notaCargo = new NotasCargoProveedor(oConn, varSesiones, request);
            notaCargo.setStrPATHKeys(strPathPrivateKeys);
            notaCargo.setStrPATHXml(strPathXML);
            notaCargo.setStrPATHFonts(strPathFonts);
            notaCargo.setStrPATHBase(strPathBase);

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
            notaCargo.getDocument().setFieldInt("PV_ID", Integer.valueOf(request.getParameter("PV_ID")));
            notaCargo.getDocument().setFieldInt("CXP_ID", Integer.valueOf(request.getParameter("CXP_ID")));
            if (Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")) == 0) {
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", 1);
            } else {
               notaCargo.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
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
            //Asignamos los valores al objeto
            notaCargo.getDocument().setFieldInt("TI_ID", intTI_ID);
            notaCargo.getDocument().setFieldInt("TI_ID2", intTI_ID2);
            notaCargo.getDocument().setFieldInt("TI_ID3", intTI_ID3);
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
            //Validamos Porcentaje de descuento global
            if (request.getParameter(strPrefijoMaster + "_POR_DESC") != null) {
               try {
                  notaCargo.getDocument().setFieldDouble(strPrefijoMaster + "_POR_DESCUENTO", Double.valueOf(request.getParameter(strPrefijoMaster + "_POR_DESC")));
               } catch (NumberFormatException ex) {
               }
            }
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
            //Recibimos la serie por guardar...
            if (request.getParameter(strPrefijoMaster + "_SERIE") != null) {
               notaCargo.getDocument().setFieldString(strPrefijoMaster + "_SERIE", request.getParameter(strPrefijoMaster + "_SERIE"));
            }
            //Recibimos datos de los items o partidas
            int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
            for (int i = 1; i <= intCount; i++) {
               TableMaster deta = null;

               deta = new VtaNotasCargosProvDeta();

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
               notaCargo.AddDetalle(deta);
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
            NotasCargoProveedor notaCargo = new NotasCargoProveedor(oConn, varSesiones, request);
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
         //Consulta xml para aplicar nota de cargo
         if (strid.equals("3")) {
            String strPvId = request.getParameter("PV_ID");
            String strFechaIni = request.getParameter("FechaIni");
            String strFechaFin = request.getParameter("FechaFin");
            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<cuentas>");
            //Consultamos las cxp
            String strSql = "SELECT CXP_ID,CXP_FOLIO,DATE_FORMAT(STR_TO_DATE(CXP_FECHA,'%Y%m%d'),'%d/%m/%Y') as fecha,CXP_TOTAL,CXP_SALDO "
               + " from vta_cxpagar "
               + " where PV_ID = '" + strPvId + "' AND CXP_ANULADO = 0 AND CXP_SALDO>0.99";
            if(strFechaIni != null && strFechaFin != null ){
               if(!strFechaIni.isEmpty() && !strFechaFin.isEmpty()){
                  strSql += " and CXP_FECHA >='" + fecha.FormateaBD(strFechaIni, "/") + "'  and CXP_FECHA<='" + fecha.FormateaBD(strFechaFin, "/") + "'";
               }
            }
            strSql += " order by CXP_FECHA,CXP_FOLIO";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes.append("<cuenta "
                  + " CXP_ID = \"" + rs.getInt("CXP_ID") + "\"  "
                  + " CXP_FOLIO = \"" + rs.getString("CXP_FOLIO") + "\"  "
                  + " CXP_FECHA = \"" + rs.getString("fecha") + "\"  "
                  + " CXP_SALDO = \"" + rs.getDouble("CXP_SALDO") + "\"  "
                  + " CXP_TOTAL = \"" + rs.getDouble("CXP_TOTAL") + "\"  "
                  + " />");
            }
            rs.close();
             if(rs.getStatement() != null )rs.getStatement().close(); rs.close();
            strRes.append("</cuentas>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }
      }
   } else {
   }
   oConn.close();
%>