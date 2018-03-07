<%-- 
    Document   : ERP_CxPagar
      Realiza todas las operaciones que tienen que ver con las Cuentas por Pagar
    Created on : 21/06/2010, 06:39:31 PM
    Author     : zeus
--%>
<%@page import="ERP.CuentasXPagarDoc"%>
<%@page import="java.io.File"%>
<%@page import="Tablas.vta_cxpagar"%>
<%@page import="Tablas.vta_cxpagardetalle"%>
<%@page import="ERP.CuentasxPagar"%>
<%@page import="Core.FirmasElectronicas.Addendas.SATAddendaMabe"%>
<%@page import="Core.FirmasElectronicas.SATXml"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.CIP_Form" %>
<%@page import="Tablas.Usuarios" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
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
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         // <editor-fold defaultstate="collapsed" desc="Genera una nueva operacion de cuentas por pagar">
         if (strid.equals("1")) {

            //Instanciamos el objeto que generara la venta
            CuentasxPagar cuenta = new CuentasxPagar(oConn, varSesiones, request);
            //Recibimos parametros
            String strPrefijoMaster = "CXP";
            String strPrefijoDeta = "CXPD";

            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               cuenta.setIntEMP_ID(varSesiones.getIntIdEmpresa());
               cuenta.getDocument().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
            }
            //Recibimos datos para el encabezado
            int intCXP_ID = 0;
            try {
               intCXP_ID = Integer.valueOf(request.getParameter("CXP_ID"));
            } catch (NumberFormatException ex) {
               System.out.println("CXP_ID " + ex.getMessage());
            }

            //Si llega el campo de pedido entonces estamos editando un pedido
            if (request.getParameter("CXP_ID") != null) {
               cuenta.getDocument().setFieldInt("CXP_ID", intCXP_ID);
               //Validamos si la modificacion de un pedido
               if (cuenta.getDocument().getFieldInt("CXP_ID") != 0) {
                  //Generamos transaccion
                  cuenta.getDocument().setValorKey(cuenta.getDocument().getFieldInt("CXP_ID") + "");
                  cuenta.Init();
               }
            }
            //Recibimos datos para signarlos al objeto 
            cuenta.getDocument().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
            cuenta.getDocument().setFieldInt("PV_ID", Integer.valueOf(request.getParameter("PV_ID")));

            cuenta.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(request.getParameter(strPrefijoMaster + "_MONEDA")));
            cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA"), "/"));
            if (request.getParameter(strPrefijoMaster + "_FECHA_CONFIRMA") != null) {
               cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA_CONFIRMA", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA_CONFIRMA"), "/"));
            }
            if (request.getParameter(strPrefijoMaster + "_FECHA_PROVISION") != null) {
               cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA_PROVISION", fecha.FormateaBD(request.getParameter(strPrefijoMaster + "_FECHA_PROVISION"), "/"));
            }
            cuenta.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", request.getParameter(strPrefijoMaster + "_FOLIO"));
            cuenta.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", request.getParameter(strPrefijoMaster + "_NOTAS"));
            cuenta.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", request.getParameter(strPrefijoMaster + "_REFERENCIA"));

            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO1")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO2")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPUESTO3")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(request.getParameter(strPrefijoMaster + "_TOTAL")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA1")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA2")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(request.getParameter(strPrefijoMaster + "_TASA3")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_RETISR", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETISR")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_RETIVA", Double.valueOf(request.getParameter(strPrefijoMaster + "_RETIVA")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_NETO", Double.valueOf(request.getParameter(strPrefijoMaster + "_NETO")));

            cuenta.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_USO_IEPS")));
            cuenta.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(request.getParameter(strPrefijoMaster + "_TASA_IEPS")));
            cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(request.getParameter(strPrefijoMaster + "_IMPORTE_IEPS")));
            cuenta.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", Integer.valueOf(request.getParameter(strPrefijoMaster + "_DIASCREDITO")));

            cuenta.getDocument().setFieldString("PED_COD", request.getParameter(strPrefijoMaster + "_NUMPEDI"));
            if (request.getParameter(strPrefijoMaster + "_PED_ID") != null) {
               try {
                  cuenta.getDocument().setFieldInt("PED_ID", Integer.valueOf(request.getParameter(strPrefijoMaster + "_PED_ID")));
               } catch (NumberFormatException ex) {
               }
            }

            cuenta.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", request.getParameter(strPrefijoMaster + "_ADUANA"));

            cuenta.getDocument().setFieldString(strPrefijoMaster + "_UUID", request.getParameter(strPrefijoMaster + "_UUID"));

            /*
             String strFechaPedimento = request.getParameter(strPrefijoMaster + "_FECHAPEDI");
             if (strFechaPedimento.contains("/") && strFechaPedimento.length() == 10) {
             strFechaPedimento = fecha.FormateaBD(strFechaPedimento, "/");
             }
             cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", strFechaPedimento);*/
            //Tarifas de IVA
            int intTI_ID = 0;
            int intTI_ID2 = 0;
            int intTI_ID3 = 0;
            try {
               intTI_ID = Integer.valueOf(request.getParameter("TI_ID"));
               intTI_ID2 = Integer.valueOf(request.getParameter("TI_ID2"));
               intTI_ID3 = Integer.valueOf(request.getParameter("TI_ID3"));
            } catch (NumberFormatException ex) {
               System.out.println("CXPAGAR TI_ID " + ex.getMessage());
            }
            cuenta.getDocument().setFieldInt("TI_ID", intTI_ID);
            cuenta.getDocument().setFieldInt("TI_ID2", intTI_ID2);
            cuenta.getDocument().setFieldInt("TI_ID3", intTI_ID3);
            cuenta.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", request.getParameter(strPrefijoMaster + "_NOTASPIE"));
            cuenta.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster + "_CONDPAGO"));


            //Recibimos datos de los items o partidas
            int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
            for (int i = 1; i <= intCount; i++) {
               TableMaster deta = new vta_cxpagardetalle();
               deta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("PR_ID" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO1" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO2" + i)));
               deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(request.getParameter(strPrefijoDeta + "_EXENTO3" + i)));
               deta.setFieldString(strPrefijoDeta + "_CVE", request.getParameter(strPrefijoDeta + "_CVE" + i));
               deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", request.getParameter(strPrefijoDeta + "_DESCRIPCION" + i));
               deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPORTE" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", Double.valueOf(request.getParameter(strPrefijoDeta + "_CANTIDAD" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_TASAIVA1", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA1" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_TASAIVA2", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA2" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_TASAIVA3", Double.valueOf(request.getParameter(strPrefijoDeta + "_TASAIVA3" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO1", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO1" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO2", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO2" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO3", Double.valueOf(request.getParameter(strPrefijoDeta + "_IMPUESTO3" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_COSTO", Double.valueOf(request.getParameter(strPrefijoDeta + "_COSTO" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_RET_ISR", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_ISR" + i)));
               deta.setFieldDouble(strPrefijoDeta + "_RET_IVA", Integer.valueOf(request.getParameter(strPrefijoDeta + "_RET_IVA" + i)));
               if (request.getParameter(strPrefijoDeta + "_ADD_IVA" + i) != null) {
                  try {
                     deta.setFieldDouble(strPrefijoDeta + "_ADD_IVA", Integer.valueOf(request.getParameter(strPrefijoDeta + "_ADD_IVA" + i)));
                  } catch (NumberFormatException ex) {
                     System.out.println("Error _ADD_IVA: " + ex.getMessage());
                  }
               }
               if (request.getParameter(strPrefijoDeta + "_MINUS_IVA" + i) != null) {
                  try {
                     deta.setFieldDouble(strPrefijoDeta + "_MINUS_IVA", Integer.valueOf(request.getParameter(strPrefijoDeta + "_MINUS_IVA" + i)));
                  } catch (NumberFormatException ex) {
                     System.out.println("Error _MINUS_IVA " + ex.getMessage());
                  }
               }
               deta.setFieldDouble("GT_ID", Integer.valueOf(request.getParameter(strPrefijoDeta + "_GASTOID" + i)));
               deta.setFieldDouble("CC_ID", Integer.valueOf(request.getParameter(strPrefijoDeta + "_COSTOSID" + i)));
               cuenta.AddDetalle(deta);
            }
            //Validamos si es una modificacion
            if (cuenta.getDocument().getFieldInt("CXP_ID") != 0) {
               //Pasamos los datos de los archivos
               cuenta.setStrXMLFileName(request.getParameter(strPrefijoMaster + "_XMLFILE"));
               cuenta.setStrPDFFileName(request.getParameter(strPrefijoMaster + "_PDFFILE"));
               cuenta.setstrPathBase2(this.getServletContext().getRealPath("/"));
               cuenta.doTrxMod();
            } else {
               //Inicializamos objeto
               cuenta.Init();
               //Pasamos los datos de los archivos
               cuenta.setStrXMLFileName(request.getParameter(strPrefijoMaster + "_XMLFILE"));
               cuenta.setStrPDFFileName(request.getParameter(strPrefijoMaster + "_PDFFILE"));
               cuenta.setstrPathBase2(this.getServletContext().getRealPath("/"));
               //Generamos transaccion
               cuenta.doTrx();

            }



            String strRes = "";
            if (cuenta.getStrResultLast().equals("OK")) {
               strRes = "OK." + cuenta.getDocument().getValorKey();
               intCXP_ID = Integer.valueOf(cuenta.getDocument().getValorKey());
            } else {
               strRes = cuenta.getStrResultLast();
               intCXP_ID = 0;
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }

      }
      // <editor-fold defaultstate="collapsed" desc="Cancela una cuenta por pagar">
      if (strid.equals("2")) {
         //Instanciamos el ticvet
         CuentasxPagar cuentaXP = new CuentasxPagar(oConn, varSesiones, request);
         //Recibimos parametros
         String strPrefijoMaster = "CXP";
         //Asignamos el id de la operacion por anular
         String strIdAnul = request.getParameter("CXP_ID");
         int intId = 0;
         if (strIdAnul == null) {
            strIdAnul = "0";
         }
         intId = Integer.valueOf(strIdAnul);
         cuentaXP.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
         cuentaXP.Init();
         cuentaXP.doTrxAnul();
         String strRes = cuentaXP.getStrResultLast();
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
      
      //Regresa los datos de un cuenta para venderlo
      if (strid.equals("8")) {
         String strCXP_ID = request.getParameter("CXP_ID");
         if (strCXP_ID == null) {
            strCXP_ID = "0";
         }
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<vta_cxpagar ";
         //Recuperamos info de cuentas
         vta_cxpagar cuenta = new vta_cxpagar();
         cuenta.ObtenDatos(Integer.valueOf(strCXP_ID), oConn);
         String strValorPar = cuenta.getFieldPar();
         strXML += strValorPar + " > ";
         //Obtenemos el detalle
         vta_cxpagardetalle deta = new vta_cxpagardetalle();
         ArrayList<TableMaster> lstDeta = deta.ObtenDatosVarios(" CXP_ID = " + cuenta.getFieldInt("CXP_ID"), oConn);
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
            //Consultamos el nombre del gasto
            String strNomGasto = "";
            strSql = "select GT_DESCRIPCION from vta_cgastos where GT_ID = " + tbn.getFieldInt("GT_ID");
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strNomGasto = rs.getString("GT_DESCRIPCION");
            }
            rs.close();

            String strNomCostos = "";
            strSql = "select CC_DESCRIPCION from vta_ccostos where CC_ID = " + tbn.getFieldInt("CC_ID");
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strNomCostos = rs.getString("CC_DESCRIPCION");
            }
            rs.close();

            strXML += "<deta ";
            strXML += tbn.getFieldPar() + " PR_REQEXIST = \"" + intPR_REQEXIST + "\" "
                    + " PR_EXISTENCIA=\"" + dblExistencia + "\" PR_CODBARRAS=\"" + strPR_CODBARRAS + "\" GT_NOM=\"" + strNomGasto + "\" CC_NOMBRE=\"" + strNomCostos + "\"";
            strXML += "/>";
         }

         strXML += "</vta_cxpagar>";


         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }
      //Nos regresa el nombre del proveedor y la lista de precios asignada
      if (strid.equals("9")) {
         UtilXml utilXML = new UtilXml();
         //Recuperamos el id del cliente
         String strProvId = request.getParameter("PV_ID");
         if (strProvId == null) {
            strProvId = "0";
         }
         String strScId = request.getParameter("SC_ID");
         if (strScId == null) {
            strScId = "0";
         }
         StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         strXML.append("<vta_proveedor>");
         //Consultamos la info
         int intPV_ID = 0;
         int intPV_LPRECIOS = 0;
         double dblPV_DESCUENTO = 0;
         int intPV_DIASCREDITO = 0;
         int intPV_TIPOPERS = 0;
         int intPV_TIPOFAC = 0;
         int intMON_ID = 0;
         int intTI_ID = 0;
         String strPV_USOIMBUEBLE = "";
         double dblPV_MONTOCRED = 0;
         String strPV_RAZONSOCIAL = "";

         String strPV_CONDPAGO = "";
         String strPV_METODO_ENVIO = "";
         int intPV_DIAS_TRANSITO = 0;
         int intPV_DIAS_PROD = 0;
         int intPV_DIAS_INGRESO = 0;
         //int intPV_DIAS_PROD = 0;
         String strSql = "select PV_ID,PV_RAZONSOCIAL,PV_LPRECIOS,"
                 + "PV_DESCUENTO,PV_DIASCREDITO,PV_MONTOCRED,PV_TIPOPERS,TI_ID"
                 + ",PV_CONDPAGO ,PV_METODO_ENVIO,MON_ID,PV_DIAS_TRANSITO,PV_DIAS_PROD "
                 + " from vta_proveedor where PV_ID = " + strProvId;
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            intPV_ID = rs.getInt("PV_ID");
            intPV_LPRECIOS = rs.getInt("PV_LPRECIOS");
            dblPV_DESCUENTO = rs.getDouble("PV_DESCUENTO");
            intPV_DIASCREDITO = rs.getInt("PV_DIASCREDITO");
            dblPV_MONTOCRED = rs.getDouble("PV_MONTOCRED");
            strPV_RAZONSOCIAL = rs.getString("PV_RAZONSOCIAL");
            intPV_TIPOPERS = rs.getInt("PV_TIPOPERS");
            intMON_ID = rs.getInt("MON_ID");
            intTI_ID = rs.getInt("TI_ID");
            strPV_CONDPAGO = rs.getString("PV_CONDPAGO");
            strPV_METODO_ENVIO = rs.getString("PV_METODO_ENVIO");
            if (!strPV_RAZONSOCIAL.equals("")) {
               strPV_RAZONSOCIAL = utilXML.Sustituye(strPV_RAZONSOCIAL);
            }
            intPV_DIAS_TRANSITO = rs.getInt("PV_DIAS_TRANSITO");
            intPV_DIAS_PROD = rs.getInt("PV_DIAS_PROD");
         }
         rs.close();
         strSql = "select SC_DIAS_INGRESAR "
                 + " from vta_sucursal where SC_ID = " + strScId;
         rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            intPV_DIAS_INGRESO = rs.getInt("SC_DIAS_INGRESAR");
         }
         rs.close();
         //El detalle
         strXML.append("<vta_proveedores "
                 + " PV_ID = \"" + intPV_ID + "\"  "
                 + " PV_RAZONSOCIAL = \"" + strPV_RAZONSOCIAL + "\"  "
                 + " PV_LPRECIOS = \"" + intPV_LPRECIOS + "\"  "
                 + " PV_DESCUENTO = \"" + dblPV_DESCUENTO + "\"  "
                 + " PV_DIASCREDITO = \"" + intPV_DIASCREDITO + "\"  "
                 + " PV_MONTOCRED = \"" + dblPV_MONTOCRED + "\"  "
                 + " PV_TIPOPERS = \"" + intPV_TIPOPERS + "\"  "
                 + " PV_TIPOFAC = \"" + intPV_TIPOFAC + "\"  "
                 + " PV_USOIMBUEBLE = \"" + strPV_USOIMBUEBLE + "\"  "
                 + " PV_CONDPAGO = \"" + strPV_CONDPAGO + "\"  "
                 + " MON_ID = \"" + intMON_ID + "\"  "
                 + " TI_ID = \"" + intTI_ID + "\"  "
                 + " PV_METODO_ENVIO = \"" + strPV_METODO_ENVIO + "\"  "
                 + " PV_DIAS_TRANSITO = \"" + intPV_DIAS_TRANSITO + "\"  "
                 + " PV_DIAS_PROD = \"" + intPV_DIAS_PROD + "\"  "
                 + " PV_DIAS_INGRESO = \"" + intPV_DIAS_INGRESO + "\"  "
                 + " />");
         strXML.append("</vta_proveedor>");
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML.toString());//Pintamos el resultado
      }
      //Nos regresa el centro de gastos de acuerdo al tipo
      if (strid.equals("10")) {
         String strTipoGasto = request.getParameter("CXP_TIPO");
         if (strTipoGasto == null) {
            strTipoGasto = "0";
         }
         UtilXml utilXML = new UtilXml();
         //Armamos string con la respuesta
         StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         strXML.append("<cgastos>");

         String strSql = "select GT_ID,GT_DESCRIPCION,GT_CUENTA_CONTABLE from vta_cgastos WHERE TCX_ID = " + strTipoGasto + ""
                 + " and EMP_ID = " + varSesiones.getIntIdEmpresa() + " ORDER BY GT_ARMADONUM";
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            int intCuantos_hijos = 0;
            strSql = "select count(*) as cuantos_hijos from vta_cgastos d where d.GT_UPLINE = " + rs.getInt("GT_ID");
            ResultSet rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               intCuantos_hijos = rs2.getInt("cuantos_hijos");
            }
            rs2.close();
            strXML.append("<cgasto "
                    + " id=\"" + rs.getInt("GT_ID") + "\""
                    + " desc=\"" + utilXML.Sustituye(rs.getString("GT_CUENTA_CONTABLE") + " " + rs.getString("GT_DESCRIPCION")) + "\" "
                    + " hijos=\""+ intCuantos_hijos + "\" "
                    + "/>");
         }
         rs.close();
         strXML.append("</cgastos>");
         //Mostramos el resultado
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML.toString());//Pintamos el resultado
      }
      //Autorizar una cuenta por pagar
      if (strid.equals("11")) {
         //Instanciamos el objeto de compras
         CuentasxPagar cuentas = new CuentasxPagar(oConn, varSesiones, request);
         //Recibimos parametros
         String strPrefijoMaster = "CXP";
         //Asignamos el id de la operacion por anular
         String strIdAnul = request.getParameter("CXP_ID");
         int intId = 0;
         if (strIdAnul == null) {
            strIdAnul = "0";
         }
         intId = Integer.valueOf(strIdAnul);
         cuentas.getDocument().setFieldInt(strPrefijoMaster + "_ID", intId);
         cuentas.Init();
         cuentas.doAutoriza();
         String strRes = cuentas.getStrResultLast();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strRes);//Pintamos el resultado
      }
      
      //Nos regresa los impuestos correspondientes a la sucursal seleccionada
      if (strid.equals("12")) {
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
      if (strid.equals("13")) {
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
         System.out.println("NombreCorto: " + strNombreCorto);
         System.out.println("Colores: " + strColores);
         System.out.println("Tallas: " + strTallas);
         System.out.println("Tallas2: " + strTallas2);
         System.out.println("Cantidad: " + strCantidad);
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
   } else {
   }
   oConn.close();
%>