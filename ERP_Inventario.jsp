<%-- 
    Document   : ERP_Inventario
         Realiza todas las peticiones que tienen que ver con el inventario
    Created on : 20/06/2010, 07:37:18 AM
    Author     : zeus
--%>
<%@page import="java.net.URLDecoder"%>
<%@page import="ERP.InventarioCosteo"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="Tablas.vta_movproddeta"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Operaciones.CIP_Form" %>
<%@page import="Tablas.Usuarios" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="ERP.Producto" %>
<%@page import="ERP.Inventario" %>
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
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Nos regresa la existencia de un producto
         if (strid.equals("1")) {
            String strPr_Id = request.getParameter("PR_ID");
            if (strPr_Id == null) {
               strPr_Id = "0";
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Producto prod = new Producto();
            double dblExistencia = prod.RegresaExistencia(strPr_Id, oConn);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(dblExistencia + "");//Pintamos el resultado
         }
         //Procesa el guardado de un movimiento de almacen
         if (strid.equals("2")) {
            String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
            if (strSist_Costos == null) {
               strSist_Costos = "0";
            }
            String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL_INV");
            if (strfolio_GLOBAL == null) {
               strfolio_GLOBAL = "NO";
            }
            Fechas fecha = new Fechas();
            Inventario inv = new Inventario(oConn, varSesiones, request);
            inv.setBolControlEstrictoInv(true);
            //Recuperamos parametros
            int intTipoMov = Integer.valueOf(request.getParameter("INV_TIPO"));
            inv.getMovProd().setFieldInt("TIN_ID", intTipoMov);
            inv.getMovProd().setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
            inv.getMovProd().setFieldInt("SC_ID2", Integer.valueOf(request.getParameter("SC_ID2")));
            inv.getMovProd().setFieldString("MP_FECHA", fecha.FormateaBD(request.getParameter("INV_FECHA"), "/"));
            inv.getMovProd().setFieldString("MP_FOLIO", request.getParameter("INV_FOLIO"));
            inv.getMovProd().setFieldString("MP_NOTAS", request.getParameter("INV_NOTAS"));
            inv.getMovProd().setFieldInt("MP_IDORIGEN", Integer.valueOf(request.getParameter("INV_TRASORIGEN")));
            inv.setIntNumIdTraspasoSalida(Integer.valueOf(request.getParameter("INV_TRASORIGEN")));
            inv.setIntTipoOperacion(intTipoMov);
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               inv.setIntEMP_ID(varSesiones.getIntIdEmpresa());
            }
            //Validamo
            //Validamos si usaremos un folio global
            if (strfolio_GLOBAL.equals("SI")) {
               inv.setBolFolioGlobal(true);
            }
            //Definimos el sistema de costos
            try {
               inv.setIntTipoCosteo(Integer.valueOf(strSist_Costos));
            } catch (NumberFormatException ex) {
               System.out.println("No hay sistema de costos definido");
            }
            //Recibimos el turno de la operacion
            if (request.getParameter("INV_TURNO") != null) {
               try {
                  inv.getMovProd().setFieldInt("MP_TURNO", Integer.valueOf(request.getParameter("INV_TURNO")));
               } catch (NumberFormatException ex) {
                  System.out.println("Error al convertir turno");
               }
            }
            //Recibimos el tipo de movimiento de inventario
            if (request.getParameter("TMP_ID") != null) {
               try {
                  inv.getMovProd().setFieldInt("TMP_ID", Integer.valueOf(request.getParameter("TMP_ID")));
               } catch (NumberFormatException ex) {
                  System.out.println("Error al convertir el tipo de movimiento");
               }
            }
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               inv.getMovProd().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
            }
            //Obtenemos el detalle
            int intCount = Integer.valueOf(request.getParameter("COUNT_ITEM"));
            for (int i = 1; i <= intCount; i++) {
               String series = request.getParameter("MOVD_NOSERIE" + i);
               if (!series.equals("")) {
                  String[] lstSeries = series.split(",");
                  for (int c = 0; c < lstSeries.length; c++) {
                     vta_movproddeta movDeta = new vta_movproddeta();
                     movDeta.setBolUsaSeries(true);
                     movDeta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("MOVD_PR_ID" + i)));
                     movDeta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                     movDeta.setFieldInt("MPD_IDORIGEN", Integer.valueOf(request.getParameter("INV_TRASORIGEN")));
                     movDeta.setFieldString("MPD_FECHA", fecha.FormateaBD(request.getParameter("INV_FECHA"), "/"));
                     movDeta.setFieldDouble("MPD_COSTO", Double.valueOf(request.getParameter("MOVD_COSTO" + i)));
                     movDeta.setFieldString("PR_CODIGO", request.getParameter("MOVD_CVE" + i));
                     movDeta.setFieldString("MPD_NOTAS", request.getParameter("MOVD_NOTAS" + i));
                     movDeta.setFieldInt("ID_USUARIOS", varSesiones.getIntNoUser());
                     movDeta.setFieldString("PL_NUMLOTE", lstSeries[c]);
                     //Si el tipo de movimiento en ENTRADA
                     if (intTipoMov == Inventario.ENTRADA || intTipoMov == Inventario.TRASPASO_ENTRADA) {
                        movDeta.setFieldDouble("MPD_ENTRADAS", 1);
                        //Agregamos los campos para la fecha de caducidad y lote
                        if (request.getParameter("MOVD_FECHA_CAD" + i) != null) {
                           if (!request.getParameter("MOVD_FECHA_CAD" + i).isEmpty()) {
                              movDeta.setFieldString("MPD_CADFECHA", fecha.FormateaBD(request.getParameter("MOVD_FECHA_CAD" + i), "/"));
                           }
                        }

                     } else {
                        movDeta.setFieldDouble("MPD_SALIDAS", 1);
                     }
                     inv.AddDetalle(movDeta);
                  }
               } else {
                  vta_movproddeta movDeta = new vta_movproddeta();

                  movDeta.setFieldInt("PR_ID", Integer.valueOf(request.getParameter("MOVD_PR_ID" + i)));
                  movDeta.setFieldInt("SC_ID", Integer.valueOf(request.getParameter("SC_ID")));
                  movDeta.setFieldInt("MPD_IDORIGEN", Integer.valueOf(request.getParameter("INV_TRASORIGEN")));
                  movDeta.setFieldString("MPD_FECHA", fecha.FormateaBD(request.getParameter("INV_FECHA"), "/"));
                  movDeta.setFieldDouble("MPD_COSTO", Double.valueOf(request.getParameter("MOVD_COSTO" + i)));
                  movDeta.setFieldString("PR_CODIGO", request.getParameter("MOVD_CVE" + i));
                  movDeta.setFieldString("MPD_NOTAS", request.getParameter("MOVD_NOTAS" + i));
                  movDeta.setFieldInt("ID_USUARIOS", varSesiones.getIntNoUser());
                  double dblCantidad = Double.valueOf(request.getParameter("MOVD_CANTIDAD" + i));

                  //Si el tipo de movimiento en ENTRADA
                  if (intTipoMov == Inventario.ENTRADA || intTipoMov == Inventario.TRASPASO_ENTRADA) {
                     movDeta.setFieldDouble("MPD_ENTRADAS", dblCantidad);
                     //Agregamos los campos para la fecha de caducidad y lote
                     if (request.getParameter("MOVD_FECHA_CAD" + i) != null) {
                        if (!request.getParameter("MOVD_FECHA_CAD" + i).isEmpty()) {
                           movDeta.setFieldString("MPD_CADFECHA", fecha.FormateaBD(request.getParameter("MOVD_FECHA_CAD" + i), "/"));
                        }
                     }
                     movDeta.setFieldString("PL_NUMLOTE", request.getParameter("MOVD_LOTE" + i));
                  } else {
                     movDeta.setFieldDouble("MPD_SALIDAS", dblCantidad);
                  }
                  inv.AddDetalle(movDeta);
               }

            }
            //Inicializamos objeto
            inv.Init();
            //Almacenamos la operacion
            inv.doTrx();
            String strRes = "";
            if (inv.getStrResultLast().equals("OK")) {
               strRes = "OK." + inv.getMovProd().getValorKey();
            } else {
               strRes = inv.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Procesa la cancelacion de un movmiento de almacen
         if (strid.equals("3")) {
            //Asignamos el id de la operacion por anular
            String strIdAnul = request.getParameter("idAnul");
            if (strIdAnul == null) {
               strIdAnul = "0";
            }
            int intId = Integer.valueOf(strIdAnul);
            Inventario inv = new Inventario(oConn, varSesiones, request);
            inv.getMovProd().setFieldInt("MP_ID", intId);
            inv.Init();
            inv.doTrxAnul();
            String strRes = inv.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Regresa las categorias de los productos
         if (strid.equals("10")) {
            UtilXml utilXml = new UtilXml();
            //Xml de respuesta
            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strRes += "<prodCat>";
            //Buscamos la categoria 1
            String strSql = "SELECT PC_ID,PC_DESCRIPCION "
                    + " FROM vta_prodcat1 "
                    + " ORDER BY PC_DESCRIPCION ";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat1 "
                       + " id = \"" + rs.getInt("PC_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 2
            strSql = "SELECT PC2_ID,PC2_DESCRIPCION "
                    + " FROM vta_prodcat2 "
                    + " ORDER BY PC2_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat2 "
                       + " id = \"" + rs.getInt("PC2_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC2_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 3
            strSql = "SELECT PC3_ID,PC3_DESCRIPCION "
                    + " FROM vta_prodcat3 "
                    + " ORDER BY PC3_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat3 "
                       + " id = \"" + rs.getInt("PC3_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC3_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 4
            strSql = "SELECT PC4_ID,PC4_DESCRIPCION "
                    + " FROM vta_prodcat4 "
                    + " ORDER BY PC4_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat4 "
                       + " id = \"" + rs.getInt("PC4_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC4_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 5
            strSql = "SELECT PC5_ID,PC5_DESCRIPCION "
                    + " FROM vta_prodcat5 "
                    + " ORDER BY PC5_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat5 "
                       + " id = \"" + rs.getInt("PC5_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC5_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 6
            strSql = "SELECT PC6_ID,PC6_DESCRIPCION "
                    + " FROM vta_prodcat6 "
                    + " ORDER BY PC6_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat6 "
                       + " id = \"" + rs.getInt("PC6_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC6_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 7
            strSql = "SELECT PC7_ID,PC7_DESCRIPCION "
                    + " FROM vta_prodcat7 "
                    + " ORDER BY PC7_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat7 "
                       + " id = \"" + rs.getInt("PC7_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC7_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 8
            strSql = "SELECT PC8_ID,PC8_DESCRIPCION "
                    + " FROM vta_prodcat8 "
                    + " ORDER BY PC8_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat8 "
                       + " id = \"" + rs.getInt("PC8_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC8_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            //Buscamos la categoria 9
            strSql = "SELECT PC9_ID,PC9_DESCRIPCION "
                    + " FROM vta_prodcat9 "
                    + " ORDER BY PC9_DESCRIPCION ";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes += "<Cat9 "
                       + " id = \"" + rs.getInt("PC9_ID") + "\"  "
                       + " desc = \"" + utilXml.Sustituye(rs.getString("PC9_DESCRIPCION")) + "\"  "
                       + " />";
            }
            rs.close();
            strRes += "</prodCat>";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Valida de el id de transaccion de traspaso de salida es valido
         if (strid.equals("11")) {
            String strId_Tras = request.getParameter("Id_Tras");
            if (strId_Tras == null) {
               strId_Tras = "0";
            }
            String strSc_Id2 = "";
            String strSql = "SELECT MP_ID,SC_ID,SC_ID2 "
                    + " FROM vta_movprod "
                    + " WHERE TIN_ID = " + Inventario.TRASPASO_SALIDA + " AND MP_RECIBIDO = 0 "
                    + " AND MP_ANULADO = 0 AND MP_ID =  " + strId_Tras;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strSc_Id2 = rs.getString("SC_ID2");
            }
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strSc_Id2 + "");//Pintamos el resultado
         }
         //Regresamos las clasificaciones numero 10
         if (strid.equals("12")) {
            String strPC9_ID = request.getParameter("idItem");
            if (strPC9_ID == null) {
               strPC9_ID = "0";
            }
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_clasific> ";

            //Consultamos la existencia y si requiera de existencia para su venta
            String strSql = "select * from vta_prodcat10 where PC9_ID = " + strPC9_ID;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML += "<clas ";
               strXML += " id = \"" + rs.getInt("PC10_ID") + "\" "
                       + " desc=\"" + rs.getString("PC10_DESCRIPCION") + "\" ";
               strXML += "/>";
            }
            //strPC9_ID
            rs.close();
            strXML += "</vta_clasific>";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado   

         }
         //Busca el prodcuto para armar los kits
         if (strid.equals("13")) {
            String strCod = request.getParameter("cod");
            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strRes += "<productos>";
            String strSql = "SELECT vta_producto.*,"
                    + " (select MON_DESCRIPCION from vta_monedas where vta_monedas.MON_ID = vta_producto.PR_MONEDA_COSTO) as moneda1 "
                    + " FROM vta_producto "
                    + " WHERE PR_CODIGO='" + strCod + "'";
            ResultSet rs = oConn.runQuery(strSql);
            while (rs.next()) {

               strRes += "<producto";
               strRes += " PR_ID = \"" + rs.getInt("PR_ID") + "\"  ";
               strRes += " PR_CODIGO = \'" + rs.getString("PR_CODIGO") + "\'";
               strRes += " PR_DESCRIPCION = \'" + rs.getString("PR_DESCRIPCION") + "\'";
               strRes += " PR_COSTOREPOSICION = \'" + rs.getString("PR_COSTOREPOSICION") + "\'";
               strRes += " PR_FACTORSOBRECOSTO = \'" + rs.getString("PR_FACTORSOBRECOSTO") + "\'";
               strRes += " PR_MONEDA_COSTO = \'" + rs.getString("PR_MONEDA_COSTO") + "\'";
               strRes += " moneda1 = \'" + rs.getString("moneda1") + "\'";
               strRes += "/>";
            }
            strRes += "</productos>";
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }

         //Busca el prodcuto para armar los kits
         if (strid.equals("14")) {
            String strCod = request.getParameter("PRODUCTO");
            String strRes = "";
            int intIdPr = 0;
            //BORRAMOS LOS EXITENTES
            if (request.getParameter("IDPR").equals("0")) {
               String strSql = "SELECT MAX(PR_ID)AS ID"
                       + " FROM vta_producto "
                       + " WHERE PR_CODIGO='" + strCod + "'";

               ResultSet rs = oConn.runQuery(strSql);
               while (rs.next()) {
                  intIdPr = rs.getInt("ID");
               }
               rs.close();

               int intNumPartidas = Integer.valueOf(request.getParameter("CONTADOR"));
               for (int i = 1; i <= intNumPartidas; i++) {
                  final String strCod1 = URLDecoder.decode(new String(request.getParameter("TXTCODTBL" + i).getBytes(
                          "iso-8859-1")), "UTF-8");
                  String strSqlDat = "SELECT PR_ID,PR_CODIGO,PR_DESCRIPCION,PR_COSTOCOMPRA "
                          + " FROM vta_producto "
                          + " WHERE PR_CODIGO='" + strCod1 + "'";
                  rs = oConn.runQuery(strSqlDat);
                  while (rs.next()) {

                     String strSqlInsert = "INSERT INTO vta_paquetes(PR_ID,PR_ID2,PAQ_COD,"
                             + "PAQ_DESCRIPCION,PAQ_CANTIDAD,PAQ_COSTO,PAQ_FACSOBR,PAQ_COSTREP,PAQ_MONEDAORIGI,PAQ_TOTALES,PAQ_PRECIOORIGI,PAQ_PRECIOCONV)VALUES('" + intIdPr
                             + "','" + rs.getString("PR_ID") + "','" + rs.getString("PR_CODIGO") + "','" + rs.getString("PR_DESCRIPCION") + "','" + request.getParameter("TXTCANTBL" + i) + "','" + rs.getString("PR_COSTOCOMPRA") + "'"
                             + ", '" + request.getParameter("TXTFACSOBRTBL" + i) + "', '" + request.getParameter("TXTCOSTREPTBL" + i) + "', '" + request.getParameter("TXTMONEDAORIGI" + i) + "', '" + request.getParameter("TXTTOTALESTBL" + i) + "', '" + request.getParameter("TXTPRECIOORIGI" + i) + "', '" + request.getParameter("TXTPRECIOCONV" + i) + "');";

                     oConn.runQueryLMD(strSqlInsert);

                  }

               }

            } else {
               String strSqlDel = "DELETE  "
                       + " FROM vta_paquetes "
                       + " WHERE PR_ID='" + request.getParameter("IDPR") + "'";
               oConn.runQueryLMD(strSqlDel);

               int intNumPartidas = Integer.valueOf(request.getParameter("CONTADOR"));
               for (int i = 1; i <= intNumPartidas; i++) {
                  final String strCod1 = URLDecoder.decode(new String(request.getParameter("TXTCODTBL" + i).getBytes(
                          "iso-8859-1")), "UTF-8");
                  final String strDes1 = URLDecoder.decode(new String(request.getParameter("TXTCVETBL" + i).getBytes(
                          "iso-8859-1")), "UTF-8");
                  String strSqlInsert = "INSERT INTO vta_paquetes(PR_ID,PR_ID2,PAQ_COD,"
                          + "PAQ_DESCRIPCION,PAQ_CANTIDAD,PAQ_COSTO,PAQ_FACSOBR,PAQ_COSTREP,PAQ_MONEDAORIGI,PAQ_TOTALES,PAQ_PRECIOORIGI,PAQ_PRECIOCONV)VALUES('" + request.getParameter("IDPR")
                          + "','" + request.getParameter("HDDPRID" + i) + "','" + strCod1 + "','" + strDes1 + "','" + request.getParameter("TXTCANTBL" + i) + "','" + request.getParameter("IDPR") + "'"
                          + ", '" + request.getParameter("TXTFACSOBRTBL" + i) + "', '" + request.getParameter("TXTCOSTREPTBL" + i) + "', '" + request.getParameter("TXTMONEDAORIGI" + i) + "', '" + request.getParameter("TXTTOTALESTBL" + i) + "', '" + request.getParameter("TXTPRECIOORIGI" + i) + "', '" + request.getParameter("TXTPRECIOCONV" + i) + "');";

                  oConn.runQueryLMD(strSqlInsert);

               }

            }
            strRes = "OK";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Recupera los productos de los kits
         if (strid.equals("15")) {
            UtilXml util = new UtilXml();
            String strIdPr = request.getParameter("idPr");

            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

            strRes += "<productos>";
            String strSql = "SELECT * "
                    + " FROM vta_paquetes "
                    + " WHERE PR_ID='" + strIdPr + "'";
            ResultSet rs = oConn.runQuery(strSql);
            while (rs.next()) {

               strRes += "<producto";
               strRes += " PAQ_ID = \"" + rs.getInt("PAQ_ID") + "\"  ";
               strRes += " PR_ID = \"" + rs.getInt("PR_ID") + "\"  ";
               strRes += " PR_ID2 = \"" + rs.getInt("PR_ID2") + "\"  ";
               strRes += " PAQ_DESCRIPCION = \"" + util.Sustituye(rs.getString("PAQ_DESCRIPCION")) + "\"  ";
               strRes += " PAQ_COD = \"" + util.Sustituye(rs.getString("PAQ_COD")) + "\"  ";
               strRes += " PAQ_CANTIDAD = \"" + rs.getDouble("PAQ_CANTIDAD") + "\"  ";
               strRes += " PAQ_COSTO = \"" + rs.getDouble("PAQ_COSTO") + "\"  ";

               strRes += " PAQ_FACSOBR = \"" + rs.getDouble("PAQ_FACSOBR") + "\"  ";
               strRes += " PAQ_COSTREP = \"" + rs.getDouble("PAQ_COSTREP") + "\"  ";
               strRes += " PAQ_MONEDAORIGI = \"" + rs.getString("PAQ_MONEDAORIGI") + "\"  ";
               strRes += " PAQ_TOTALES = \"" + rs.getDouble("PAQ_TOTALES") + "\"  ";
               strRes += " PAQ_PRECIOORIGI = \"" + rs.getDouble("PAQ_PRECIOORIGI") + "\"  ";
               strRes += " PAQ_PRECIOCONV = \"" + rs.getDouble("PAQ_PRECIOCONV") + "\"  ";
               strRes += "/>";
            }
            strRes += "</productos>";

            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Borra los productos de los kits
         if (strid.equals("16")) {
            String strIdPr = request.getParameter("idPr");
            String strRes = "";

            String strSql = "DELETE * "
                    + " FROM vta_paquetes "
                    + " WHERE PR_ID='" + strIdPr + "'";
            oConn.runQueryLMD(strSql);

            strRes = "OK";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Obtiene la lista de productos que se controlan numero de serie
         if (strid.equals("18")) {
            Inventario inv = new Inventario(oConn, varSesiones, request);
            String strlstIds = request.getParameter("lstIds");
            if (strlstIds == null) {
               strlstIds = "0";
            }
            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><codigo_barras/>";
            if (!strlstIds.isEmpty()) {
               strRes = inv.ObtenProductoConSerie(strlstIds);
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Nos dice si es valido un numero de serie para una entrada
         if (strid.equals("19")) {
            Inventario inv = new Inventario(oConn, varSesiones, request);
            String strSeries = request.getParameter("SERIE");
            int intPR_ID = 0;
            if (request.getParameter("PR_ID") != null) {
               intPR_ID = Integer.valueOf(request.getParameter("PR_ID"));
            }
            String strRes = "OK";
            if (!inv.EsValidaSerieEntrada(intPR_ID, strSeries)) {
               strRes = inv.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Nos dice si es valido un numero de serie para una salida
         if (strid.equals("20")) {
            Inventario inv = new Inventario(oConn, varSesiones, request);
            String strSeries = request.getParameter("SERIE");
            int intPR_ID = 0;
            if (request.getParameter("PR_ID") != null) {
               intPR_ID = Integer.valueOf(request.getParameter("PR_ID"));
            }
            String strRes = "OK";
            if (!inv.EsValidaSerieSalida(intPR_ID, strSeries)) {
               strRes = "ERROR:" + inv.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Nos regresa todos los numeros de serie de un producto
         if (strid.equals("21")) {
            Inventario inv = new Inventario(oConn, varSesiones, request);
            int intPR_ID = 0;
            if (request.getParameter("PR_ID") != null) {
               intPR_ID = Integer.valueOf(request.getParameter("PR_ID"));
            }
            String strRes = inv.RegresaNoSeries(intPR_ID);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado            
         }
         //Nos regresa todos los numeros de serie de un surtido de una factura
         if (strid.equals("22")) {
            Inventario inv = new Inventario(oConn, varSesiones, request);
            int intPR_ID = 0;
            if (request.getParameter("PR_ID") != null) {
               intPR_ID = Integer.valueOf(request.getParameter("PR_ID"));
            }
            int intPDD_ID = 0;
            if (request.getParameter("PDD_ID") != null) {
               intPDD_ID = Integer.valueOf(request.getParameter("PDD_ID"));
            }
            String strRes = inv.RegresaNoSeriesPedidos(intPR_ID, intPDD_ID);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado            
         }
         //Calcula el retroactivo de los costos
         if (strid.equals("24")) {
            Fechas fecha = new Fechas();
            InventarioCosteo costeos = new InventarioCosteo(oConn);
            int intSC_ID = 0;
            if (request.getParameter("SC_ID") != null) {
               intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
            }
            String strFecha = "";
            if (request.getParameter("FECHA") != null) {
               strFecha = fecha.FormateaBD(request.getParameter("FECHA"), "/");
            }
            String strRes = costeos.doRecalculoCalculoPromedio(intSC_ID, strFecha);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado            
         }

      }
   } else {
   }
   oConn.close();
%>