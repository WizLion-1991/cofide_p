<%-- 
    Document   : ecomm_prod
    Este jsp se encarga de generar los xml para las diferentes peticiones de productos del ecommerce
    Created on : 26-abr-2013, 12:42:32
    Author     : aleph_79
--%>

<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="ERP.Precios"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   /*Inicializamos las variables de sesion limpias*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Obtenemos parametros generales de la pagina a mostrar
   Site webBase = new Site(oConn);
   //Parseo de caracteres no validos en el XML
   UtilXml utilXML = new UtilXml();
   //precios
   Precios prec = new Precios();

   //Lista de precios y moneda default
   int intMON_ID = webBase.getIntMON_ID();
   int intCT_LPRECIOS = webBase.getIntLPrecios();

   String strOper = request.getParameter("Oper");
   if (strOper == null) {
      strOper = "0";
   }

   //Caso 1 productos
   if (strOper.equals("1")) {


      String strSearch = request.getParameter("SEARCH");
      String strClas1 = request.getParameter("CLASIFIC1");
      String strClas2 = request.getParameter("CLASIFIC2");
      String strClas3 = request.getParameter("CLASIFIC3");
      String strClas4 = request.getParameter("CLASIFIC4");
      String strClas5 = request.getParameter("CLASIFIC5");
      String strClas6 = request.getParameter("CLASIFIC6");
      int intPaginaActual = 0;

      if (strSearch == null) {
         strSearch = "";
      }
      if (strClas1 == null) {
         strClas1 = "0";
      }
      if (strClas2 == null) {
         strClas2 = "0";
      }
      if (strClas3 == null) {
         strClas3 = "0";
      }
      if (strClas4 == null) {
         strClas4 = "0";
      }
      if (strClas5 == null) {
         strClas5 = "0";
      }
      if (strClas6 == null) {
         strClas6 = "0";
      }
      if (request.getParameter("PaginaActual") != null) {
         try {
            intPaginaActual = Integer.valueOf("PaginaActual");
         } catch (NumberFormatException ex) {
         }
      }


      StringBuilder strFiltro = new StringBuilder(" EMP_ID = " + webBase.getIntEMP_ID());
     strFiltro.append(" AND SC_ID = 1 ");
      strFiltro.append(" AND PR_ECOMM = 1 ");
      if (!strSearch.isEmpty()) {
         strFiltro.append(" AND (PR_DESCRIPCION like '%" + strSearch + "%' or PR_CODIGO like '%" + strSearch + "%' or PR_CODIGO_CORTO  like '%" + strSearch + "%')");
      } else {
         if (!strClas1.equals("0")) {
            strFiltro.append(" AND PR_CATEGORIA1 = " + strClas1 + " ");
         }
         if (!strClas2.equals("0")) {
            strFiltro.append(" AND PR_CATEGORIA2 = " + strClas2 + " ");
         }
         if (!strClas3.equals("0")) {
            strFiltro.append(" AND PR_CATEGORIA3 = " + strClas3 + " ");
         }
         if (!strClas4.equals("0")) {
            strFiltro.append(" AND PR_CATEGORIA4 = " + strClas4 + " ");
         }
         if (!strClas5.equals("0")) {
            strFiltro.append(" AND PR_CATEGORIA5 = " + strClas5 + " ");
         }
         if (!strClas6.equals("0")) {
            strFiltro.append(" AND PR_CATEGORIA6 = " + strClas6 + " ");
         }
      }
      //Consulta de productos
      String strSql = "select PR_ID,PR_CODIGO,PR_CODIGO_CORTO,PR_DESCRIPCION,PR_NOMIMG1,PR_NOMIMG2"
              + ",PR_EXISTENCIA "
              + ",PR_CATEGORIA1 "
              + ",PR_CATEGORIA2 "
              + ",PR_CATEGORIA3 "
              + ",PR_CATEGORIA4 "
              + ",PR_CATEGORIA5 "
              + ",PR_CATEGORIA6 "
              + ",PR_CATEGORIA7 "
              + ",PR_CATEGORIA8 "
              + ",PR_CATEGORIA9 "
              + ",PR_CATEGORIA10 "
              + ",PR_UNIDADMEDIDA "
              + ",PR_REQEXIST "
              + ",PR_EXENTO1 "
              + ",PR_EXENTO2 "
              + ",PR_EXENTO3 "
              + ",PR_ACTIVO "
              + "from vta_producto "
              + " where " + strFiltro.toString() + " and PR_AGRUPA_ECOMM = 0 ";
      String strSql2 = "select PR_CODIGO_CORTO,PR_DESCRIPCION,PR_NOMIMG1,PR_NOMIMG2"
              + ",sum(PR_EXISTENCIA) as TEXIS "
              + ",PR_CATEGORIA1 "
              + ",PR_CATEGORIA2 "
              + ",PR_CATEGORIA3 "
              + ",PR_UNIDADMEDIDA "
              + ",PR_REQEXIST "
              + ",PR_EXENTO1 "
              + ",PR_EXENTO2 "
              + ",PR_EXENTO3 "
              + ",PR_ACTIVO "
              + "from vta_producto "
              + " where " + strFiltro.toString()
              + " and PR_AGRUPA_ECOMM = 1 "
              + " group by PR_CODIGO_CORTO,PR_DESCRIPCION,PR_AGRUPA_ECOMM,"
              + " PR_CATEGORIA1 ,PR_CATEGORIA2 ,PR_CATEGORIA3,"
              + " PR_UNIDADMEDIDA ,PR_REQEXIST ,PR_EXENTO1 ,PR_EXENTO2 ,PR_EXENTO3 ";
      /**
       * ***********************PAGINACION**************
       */
      //if this is the first query - get total number of records in the query result
      String strSqlCount = "";
      double dblCount = 0;
      int rows = 1000;
      long inttotal_pages = 0;
      int pageC = 0;
      if (rows == 0) {
         rows = 1;
      }
      strSqlCount = "Select count(*) as cnt from (" + strSql + ") as tbl";
      ResultSet rs;
      try {
         rs = oConn.runQuery(strSqlCount, true);
         while (rs.next()) {
            dblCount = rs.getDouble("cnt");
         }
         rs.close();
      } catch (SQLException ex) {
         System.out.println("EcommProd:" + ex.getMessage());
      }
      if (dblCount > 0) {
         BigDecimal bd = new BigDecimal(Double.toString(dblCount / rows));
         bd = bd.setScale(0, BigDecimal.ROUND_CEILING);
         inttotal_pages = (long) bd.doubleValue();
      } else {
         inttotal_pages = 0;
      }
      /*if for some reasons the requested page is greater than the total
       set the requested page to total page*/
      if (intPaginaActual > inttotal_pages) {
         pageC = (int) inttotal_pages;
      }
      //Calculate the starting position of the rows
      int start = rows * intPaginaActual - rows;
      /*if for some reasons start position is negative set it to 0
       'typical case is that the user type 0 for the requested page*/
      if (start < 0) {
         start = 0;
      }
      if (pageC == 0) {
         pageC = 1;
      }
      //Anadimos el orde
      strSql += " ORDER BY PR_DESCRIPCION";
      //add limits to query to get only rows necessary for output
      strSql += " LIMIT " + start + "," + rows;
      /**
       * ***********************PAGINACION**************
       */
      //Cadena con el XML
      StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
      strXML.append("<productos>");
      strXML.append("<page>").append(pageC).append("</page>");
      strXML.append("<total>").append(inttotal_pages).append("</total>");
      strXML.append("<records>").append((int) dblCount).append("</records>");
      try{
      //Ejecutamos la consulta
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         //Generamos el texto del XML
         strXML.append("<prod "
                 + " id=\"" + rs.getString("PR_ID") + "\" "
                 + " desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCION")) + "\" "
                 + " codigo=\"" + rs.getString("PR_CODIGO") + "\" "
                 + " codigocorto=\"" + rs.getString("PR_CODIGO_CORTO") + "\" "
                 + " img1=\"" + "/Sistema" +rs.getString("PR_NOMIMG1") + "\" "
                 + " img2=\"" + "/Sistema" +rs.getString("PR_NOMIMG2") + "\" "
                 + " exist=\"" + rs.getDouble("PR_EXISTENCIA") + "\" "
                 + " cat1=\"" + rs.getInt("PR_CATEGORIA1") + "\" "
                 + " cat2=\"" + rs.getInt("PR_CATEGORIA2") + "\" "
                 + " cat3=\"" + rs.getInt("PR_CATEGORIA3") + "\" "
                 + " cat4=\"" + rs.getInt("PR_CATEGORIA4") + "\" "
                 + " cat5=\"" + rs.getInt("PR_CATEGORIA5") + "\" "
                 + " cat6=\"" + rs.getInt("PR_CATEGORIA6") + "\" "
                 + " cat7=\"" + rs.getInt("PR_CATEGORIA7") + "\" "
                 + " cat8=\"" + rs.getInt("PR_CATEGORIA8") + "\" "
                 + " cat9=\"" + rs.getInt("PR_CATEGORIA9") + "\" "
                 + " cat10=\"" + rs.getInt("PR_CATEGORIA10") + "\" "
                 + " umedida=\"" + rs.getInt("PR_UNIDADMEDIDA") + "\" "
                 + " reqexist=\"" + rs.getInt("PR_REQEXIST") + "\" "
                 + " exento1=\"" + rs.getInt("PR_EXENTO1") + "\" "
                 + " exento2=\"" + rs.getInt("PR_EXENTO2") + "\" "
                 + " exento3=\"" + rs.getInt("PR_EXENTO3") + "\" "
                 + " activo=\"" + rs.getInt("PR_ACTIVO") + "\" "
                 + " agrupa=\"0\" "
                 + " >");
         //anadimos los precios
         strXML.append(prec.getXMLPrec(rs.getString("PR_ID"), oConn, true, 0, intCT_LPRECIOS, intMON_ID, 0));
         strXML.append("</prod>");
      }
      rs.close();
      //Mostramos los productos agrupados
      rs = oConn.runQuery(strSql2, true);
      while (rs.next()) {
         //Generamos el texto del XML
         strXML.append("<prod "
                 + " id=\"0\" "
                 + " desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCION")) + "\" "
                 + " codigo=\"XAXAXAXAXAXA\" "
                 + " codigocorto=\"" + utilXML.Sustituye(rs.getString("PR_CODIGO_CORTO")) + "\" "
                 + " img1=\"" + "/Sistema" +rs.getString("PR_NOMIMG1") + "\" "
                 + " img2=\"" + "/Sistema" +rs.getString("PR_NOMIMG2") + "\" "
                 + " exist=\"" + rs.getDouble("TEXIS") + "\" "
                 + " cat1=\"" + rs.getInt("PR_CATEGORIA1") + "\" "
                 + " cat2=\"" + rs.getInt("PR_CATEGORIA2") + "\" "
                 + " cat3=\"" + rs.getInt("PR_CATEGORIA3") + "\" "
                 + " cat4=\"0\" "
                 + " cat5=\"0\" "
                 + " cat6=\"0\" "
                 + " cat7=\"0\" "
                 + " cat8=\"0\" "
                 + " cat9=\"0\" "
                 + " cat10=\"0\" "
                 + " umedida=\"" + rs.getInt("PR_UNIDADMEDIDA") + "\" "
                 + " reqexist=\"" + rs.getInt("PR_REQEXIST") + "\" "
                 + " exento1=\"" + rs.getInt("PR_EXENTO1") + "\" "
                 + " exento2=\"" + rs.getInt("PR_EXENTO2") + "\" "
                 + " exento3=\"" + rs.getInt("PR_EXENTO3") + "\" "
                 + " activo=\"" + rs.getInt("PR_ACTIVO") + "\" "
                 + " agrupa=\"1\" "
                 + " >");
         //anadimos los precios
         String strSql3 = "select PR_ID,PR_DESCRIPCION from vta_producto  "
                 + " where EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                 + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                 + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                 + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                 + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                 + " LIMIT 0,1";
         ResultSet rs3 = oConn.runQuery(strSql3, true);
         while (rs3.next()) {
            strXML.append(prec.getXMLPrec(rs3.getString("PR_ID"), oConn, true, 0, intCT_LPRECIOS, intMON_ID, 0));
         }
         rs3.close();
         //Anadimos las opciones para la clasificacion 4
         strXML.append("<clasif4>");
         strSql3 = "select PR_CATEGORIA4,vta_prodcat4.PC4_DESCRIPCION from vta_producto, vta_prodcat4     "
                 + " where vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID and EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                 + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                 + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                 + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                 + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                 + " GROUP BY PR_CATEGORIA4,vta_prodcat4.PC4_DESCRIPCION ORDER BY PC4_ORDEN";
         rs3 = oConn.runQuery(strSql3, true);
         while (rs3.next()) {
            strXML.append("<clasific4"
                    + " id=\"" + rs3.getString("PR_CATEGORIA4") + "\" "
                    + " valor=\"" + utilXML.Sustituye(rs3.getString("PC4_DESCRIPCION")) + "\" "
                    + " />");
         }
         rs3.close();
         strXML.append("</clasif4>");
         //Anadimos las opciones para la clasificacion 5
         strXML.append("<clasif5>");
         strSql3 = "select PR_CATEGORIA5,vta_prodcat5.PC5_DESCRIPCION from vta_producto, vta_prodcat5  "
                 + " where  vta_producto.PR_CATEGORIA5 = vta_prodcat5.PC5_ID and EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                 + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                 + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                 + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                 + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                 + " GROUP BY PR_CATEGORIA5,vta_prodcat5.PC5_DESCRIPCION  ORDER BY PC5_ORDEN";
         rs3 = oConn.runQuery(strSql3, true);
         while (rs3.next()) {
            strXML.append("<clasific5 "
                    + " id=\"" + rs3.getString("PR_CATEGORIA5") + "\" "
                    + " valor=\"" + utilXML.Sustituye(rs3.getString("PC5_DESCRIPCION")) + "\" "
                    + " />");
         }
         rs3.close();
         strXML.append("</clasif5>");
         strXML.append("</prod>");
      }
      rs.close();
      }catch(Exception ex){
         System.out.println("EcommProd(Error):" + ex.getMessage());
      }
      strXML.append("</productos>");
      //Pintamos el XML
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
      out.println(strXML.toString());//Pintamos el resultado   
   }
   //Caso 2 productos mas vendidos
   if (strOper.equals("2")) {
      String strClas1 = request.getParameter("CLASIFIC1");
      String strClas2 = request.getParameter("CLASIFIC2");
      String strClas3 = request.getParameter("CLASIFIC3");
      String strClas4 = request.getParameter("CLASIFIC4");
      String strClas5 = request.getParameter("CLASIFIC5");
      String strClas6 = request.getParameter("CLASIFIC6");


      if (strClas1 == null) {
         strClas1 = "0";
      }
      if (strClas2 == null) {
         strClas2 = "0";
      }
      if (strClas3 == null) {
         strClas3 = "0";
      }
      if (strClas4 == null) {
         strClas4 = "0";
      }
      if (strClas5 == null) {
         strClas5 = "0";
      }
      if (strClas6 == null) {
         strClas6 = "0";
      }


      StringBuilder strFiltro = new StringBuilder(" EMP_ID = " + webBase.getIntEMP_ID());
      strFiltro.append(" AND PR_ECOMM = 1 ");

      if (!strClas1.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA1 = " + strClas1 + " ");
      }
      if (!strClas2.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA2 = " + strClas2 + " ");
      }
      if (!strClas3.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA3 = " + strClas3 + " ");
      }
      if (!strClas4.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA4 = " + strClas4 + " ");
      }
      if (!strClas5.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA5 = " + strClas5 + " ");
      }
      if (!strClas6.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA6 = " + strClas6 + " ");
      }
      //Consulta de productos
      int intMaxItems = 3;
      int intContaItems = 0;
      String strSql = "select PR_ID,PR_CODIGO,PR_CODIGO_CORTO,PR_DESCRIPCION,"
              + "PR_EXISTENCIA,PR_NOMIMG1,PR_NOMIMG2 "
              + ",PR_EXISTENCIA "
              + ",PR_CATEGORIA1 "
              + ",PR_CATEGORIA2 "
              + ",PR_CATEGORIA3 "
              + ",PR_CATEGORIA4 "
              + ",PR_CATEGORIA5 "
              + ",PR_CATEGORIA6 "
              + ",PR_CATEGORIA7 "
              + ",PR_CATEGORIA8 "
              + ",PR_CATEGORIA9 "
              + ",PR_CATEGORIA10 "
              + ",PR_UNIDADMEDIDA "
              + ",PR_REQEXIST "
              + ",PR_EXENTO1 "
              + ",PR_EXENTO2 "
              + ",PR_EXENTO3 "
              + ",PR_ACTIVO "
              + ",(select sum(FACD_CANTIDAD) from vta_facturasdeta where vta_facturasdeta.PR_ID =  vta_producto.PR_ID)  as ventasF"
              + ",(select sum(TKTD_CANTIDAD) from vta_ticketsdeta where vta_ticketsdeta.PR_ID =  vta_producto.PR_ID)  as ventasR "
              + ",(select PV_FAC_CONV_PUNTOS from vta_proveedor where vta_producto.PV_ID = vta_proveedor.PV_ID) as FactorPuntos "
              + " from vta_producto "
              + " where " + strFiltro.toString() + " and PR_AGRUPA_ECOMM = 0 ";
      String strSql2 = "select PR_CODIGO_CORTO,PR_DESCRIPCION,PR_NOMIMG1,PR_NOMIMG2"
              + ",sum(PR_EXISTENCIA) as TEXIS "
              + ",PR_CATEGORIA1 "
              + ",PR_CATEGORIA2 "
              + ",PR_CATEGORIA3 "
              + ",PR_UNIDADMEDIDA "
              + ",PR_REQEXIST "
              + ",PR_EXENTO1 "
              + ",PR_EXENTO2 "
              + ",PR_EXENTO3 "
              + ",PR_ACTIVO "
              + ",(select sum(FACD_CANTIDAD) from vta_facturasdeta where vta_facturasdeta.PR_ID =  vta_producto.PR_ID)  as ventasF"
              + ",(select sum(TKTD_CANTIDAD) from vta_ticketsdeta where vta_ticketsdeta.PR_ID =  vta_producto.PR_ID)  as ventasR "
              + ",(select PV_FAC_CONV_PUNTOS from vta_proveedor where vta_producto.PV_ID = vta_proveedor.PV_ID) as FactorPuntos "
              + "from vta_producto "
              + " where " + strFiltro.toString()
              + " and PR_AGRUPA_ECOMM = 1 "
              + " group by PR_CODIGO_CORTO,PR_DESCRIPCION,PR_AGRUPA_ECOMM,"
              + " PR_CATEGORIA1 ,PR_CATEGORIA2 ,PR_CATEGORIA3,"
              + " PR_UNIDADMEDIDA ,PR_REQEXIST ,PR_EXENTO1 ,PR_EXENTO2 ,PR_EXENTO3 ";
      //Anadimos el orde
      strSql += "  ORDER BY ventasF + ventasR desc ";/*Having  ventasF + ventasR is not null */
      //add limits to query to get only rows necessary for output
      strSql += " LIMIT 0,2";
      /**
       * ***********************PAGINACION**************
       */
      //Cadena con el XML
      StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
      strXML.append("<productos>");


      //Ejecutamos la consulta
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         intContaItems++;
         //Generamos el texto del XML
         strXML.append("<prod "
                 + " id=\"" + rs.getString("PR_ID") + "\" "
                 + " desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCION")) + "\" "
                 + " codigo=\"" + rs.getString("PR_CODIGO") + "\" "
                 + " codigocorto=\"" + rs.getString("PR_CODIGO_CORTO") + "\" "
                 + " img1=\"" + "/Sistema" +rs.getString("PR_NOMIMG1") + "\" "
                 + " img2=\"" + "/Sistema" +rs.getString("PR_NOMIMG2") + "\" "
                 + " exist=\"" + rs.getDouble("PR_EXISTENCIA") + "\" "
                 + " cat1=\"" + rs.getInt("PR_CATEGORIA1") + "\" "
                 + " cat2=\"" + rs.getInt("PR_CATEGORIA2") + "\" "
                 + " cat3=\"" + rs.getInt("PR_CATEGORIA3") + "\" "
                 + " cat4=\"" + rs.getInt("PR_CATEGORIA4") + "\" "
                 + " cat5=\"" + rs.getInt("PR_CATEGORIA5") + "\" "
                 + " cat6=\"" + rs.getInt("PR_CATEGORIA6") + "\" "
                 + " cat7=\"" + rs.getInt("PR_CATEGORIA7") + "\" "
                 + " cat8=\"" + rs.getInt("PR_CATEGORIA8") + "\" "
                 + " cat9=\"" + rs.getInt("PR_CATEGORIA9") + "\" "
                 + " cat10=\"" + rs.getInt("PR_CATEGORIA10") + "\" "
                 + " umedida=\"" + rs.getInt("PR_UNIDADMEDIDA") + "\" "
                 + " reqexist=\"" + rs.getInt("PR_REQEXIST") + "\" "
                 + " exento1=\"" + rs.getInt("PR_EXENTO1") + "\" "
                 + " exento2=\"" + rs.getInt("PR_EXENTO2") + "\" "
                 + " exento3=\"" + rs.getInt("PR_EXENTO3") + "\" "
                 + " activo=\"" + rs.getInt("PR_ACTIVO") + "\" "
                 + " agrupa=\"0\" "
                 + " FactorPuntos=\"" + rs.getDouble("FactorPuntos") + "\" "
                 + " >");
         
         
         //anadimos los precios
         strXML.append(prec.getXMLPrec(rs.getString("PR_ID"), oConn, true, 0, intCT_LPRECIOS, intMON_ID, 0));
         strXML.append("</prod>");
      }
      rs.close();

      //Mostramos los productos agrupados
      if (intContaItems < intMaxItems) {
         int intRestan = intMaxItems - intContaItems;
         //Anadimos el orde
         strSql2 += "  ORDER BY ventasF + ventasR desc ";/*Having  ventasF + ventasR is not null */
         //add limits to query to get only rows necessary for output
         strSql2 += " LIMIT 0," + intRestan;
         rs = oConn.runQuery(strSql2, true);
         while (rs.next()) {
            //Generamos el texto del XML
            strXML.append("<prod "
                    + " id=\"0\" "
                    + " desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCION")) + "\" "
                    + " codigo=\"XAXAXAXAXAXA\" "
                    + " codigocorto=\"" + utilXML.Sustituye(rs.getString("PR_CODIGO_CORTO")) + "\" "
                    + " img1=\"" + "/Sistema" +rs.getString("PR_NOMIMG1") + "\" "
                    + " img2=\"" + "/Sistema" +rs.getString("PR_NOMIMG2") + "\" "
                    + " exist=\"" + rs.getDouble("TEXIS") + "\" "
                    + " cat1=\"" + rs.getInt("PR_CATEGORIA1") + "\" "
                    + " cat2=\"" + rs.getInt("PR_CATEGORIA2") + "\" "
                    + " cat3=\"" + rs.getInt("PR_CATEGORIA3") + "\" "
                    + " cat4=\"0\" "
                    + " cat5=\"0\" "
                    + " cat6=\"0\" "
                    + " cat7=\"0\" "
                    + " cat8=\"0\" "
                    + " cat9=\"0\" "
                    + " cat10=\"0\" "
                    + " umedida=\"" + rs.getInt("PR_UNIDADMEDIDA") + "\" "
                    + " reqexist=\"" + rs.getInt("PR_REQEXIST") + "\" "
                    + " exento1=\"" + rs.getInt("PR_EXENTO1") + "\" "
                    + " exento2=\"" + rs.getInt("PR_EXENTO2") + "\" "
                    + " exento3=\"" + rs.getInt("PR_EXENTO3") + "\" "
                    + " activo=\"" + rs.getInt("PR_ACTIVO") + "\" "
                    + " agrupa=\"1\" "
                    + " FactorPuntos=\"" + rs.getDouble("FactorPuntos") + "\" "
                    + " >");
            //anadimos los precios
            String strSql3 = "select PR_ID,PR_DESCRIPCION from vta_producto  "
                    + " where EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                    + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                    + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                    + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                    + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                    + " LIMIT 0,1";
            ResultSet rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               strXML.append(prec.getXMLPrec(rs3.getString("PR_ID"), oConn, true, 0, intCT_LPRECIOS, intMON_ID, 0));
            }
            rs3.close();
            //Anadimos las opciones para la clasificacion 4
            strXML.append("<clasif4>");
            strSql3 = "select PR_CATEGORIA4,vta_prodcat4.PC4_DESCRIPCION from vta_producto, vta_prodcat4     "
                    + " where  vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID and EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                    + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                    + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                    + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                    + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                    + " GROUP BY PR_CATEGORIA4,vta_prodcat4.PC4_DESCRIPCION";
            rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               strXML.append("<clasific4 "
                       + " id=\"" + rs3.getString("PR_CATEGORIA4") + "\" "
                       + " valor=\"" + utilXML.Sustituye(rs3.getString("PC4_DESCRIPCION")) + "\" "
                       + " />");
            }
            rs3.close();
            strXML.append("</clasif4>");
            //Anadimos las opciones para la clasificacion 5
            strXML.append("<clasif5>");
            strSql3 = "select PR_CATEGORIA5,vta_prodcat5.PC5_DESCRIPCION from vta_producto, vta_prodcat5  "
                    + " where  vta_producto.PR_CATEGORIA5 = vta_prodcat5.PC5_ID and EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                    + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                    + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                    + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                    + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                    + " GROUP BY PR_CATEGORIA5,vta_prodcat5.PC5_DESCRIPCION";
            rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               strXML.append("<clasific5 "
                       + " id=\"" + rs3.getString("PR_CATEGORIA5") + "\" "
                       + " valor=\"" + utilXML.Sustituye(rs3.getString("PC5_DESCRIPCION")) + "\" "
                       + " />");
            }
            rs3.close();
            strXML.append("</clasif5>");
            strXML.append("</prod>");
         }
         rs.close();
      }

      strXML.append("</productos>");
      //Pintamos el XML
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
      out.println(strXML.toString());//Pintamos el resultado   
   }
   //Caso 3 productos mas nuevos
   if (strOper.equals("3")) {
      String strClas1 = request.getParameter("CLASIFIC1");
      String strClas2 = request.getParameter("CLASIFIC2");
      String strClas3 = request.getParameter("CLASIFIC3");
      String strClas4 = request.getParameter("CLASIFIC4");
      String strClas5 = request.getParameter("CLASIFIC5");
      String strClas6 = request.getParameter("CLASIFIC6");


      if (strClas1 == null) {
         strClas1 = "0";
      }
      if (strClas2 == null) {
         strClas2 = "0";
      }
      if (strClas3 == null) {
         strClas3 = "0";
      }
      if (strClas4 == null) {
         strClas4 = "0";
      }
      if (strClas5 == null) {
         strClas5 = "0";
      }
      if (strClas6 == null) {
         strClas6 = "0";
      }


      StringBuilder strFiltro = new StringBuilder(" EMP_ID = " + webBase.getIntEMP_ID());
      strFiltro.append(" AND PR_ECOMM = 1 ");

      if (!strClas1.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA1 = " + strClas1 + " ");
      }
      if (!strClas2.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA2 = " + strClas2 + " ");
      }
      if (!strClas3.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA3 = " + strClas3 + " ");
      }
      if (!strClas4.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA4 = " + strClas4 + " ");
      }
      if (!strClas5.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA5 = " + strClas5 + " ");
      }
      if (!strClas6.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA6 = " + strClas6 + " ");
      }
      //Consulta de productos
      int intContaItems = 0;
      int intMaxItems = 3;
      String strSql = "select PR_ID,PR_CODIGO,PR_CODIGO_CORTO,PR_DESCRIPCION"
              + ",PR_NOMIMG1,PR_NOMIMG2 "
              + ",PR_EXISTENCIA "
              + ",PR_CATEGORIA1 "
              + ",PR_CATEGORIA2 "
              + ",PR_CATEGORIA3 "
              + ",PR_CATEGORIA4 "
              + ",PR_CATEGORIA5 "
              + ",PR_CATEGORIA6 "
              + ",PR_CATEGORIA7 "
              + ",PR_CATEGORIA8 "
              + ",PR_CATEGORIA9 "
              + ",PR_CATEGORIA10 "
              + ",PR_UNIDADMEDIDA "
              + ",PR_REQEXIST "
              + ",PR_EXENTO1 "
              + ",PR_EXENTO2 "
              + ",PR_EXENTO3 "
              + ",PR_ACTIVO "
              + ",(select PV_FAC_CONV_PUNTOS from vta_proveedor where vta_producto.PV_ID = vta_proveedor.PV_ID) as FactorPuntos "
              + " from vta_producto "
              + " where " + strFiltro.toString() + " and PR_AGRUPA_ECOMM = 0 ";
      String strSql2 = "select PR_CODIGO_CORTO,PR_DESCRIPCION,PR_NOMIMG1,PR_NOMIMG2"
              + ",sum(PR_EXISTENCIA) as TEXIS "
              + ",PR_CATEGORIA1 "
              + ",PR_CATEGORIA2 "
              + ",PR_CATEGORIA3 "
              + ",PR_UNIDADMEDIDA "
              + ",PR_REQEXIST "
              + ",PR_EXENTO1 "
              + ",PR_EXENTO2 "
              + ",PR_EXENTO3 "
              + ",PR_ACTIVO "
              + ",(select PV_FAC_CONV_PUNTOS from vta_proveedor where vta_producto.PV_ID = vta_proveedor.PV_ID) as FactorPuntos "
              + "from vta_producto "
              + " where " + strFiltro.toString()
              + " and PR_AGRUPA_ECOMM = 1 "
              + " group by PR_CODIGO_CORTO,PR_DESCRIPCION,PR_AGRUPA_ECOMM,"
              + " PR_CATEGORIA1 ,PR_CATEGORIA2 ,PR_CATEGORIA3,"
              + " PR_UNIDADMEDIDA ,PR_REQEXIST ,PR_EXENTO1 ,PR_EXENTO2 ,PR_EXENTO3 ";
      //Anadimos el orde
      strSql += "  ORDER BY PR_ID DESC ";/*Having  ventasF + ventasR is not null */
      //add limits to query to get only rows necessary for output
      strSql += " LIMIT 0,2";
      //Cadena con el XML
      StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
      strXML.append("<productos>");


      //Ejecutamos la consulta
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         intContaItems++;
         //Generamos el texto del XML
         strXML.append("<prod "
                 + " id=\"" + rs.getString("PR_ID") + "\" "
                 + " desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCION")) + "\" "
                 + " codigo=\"" + rs.getString("PR_CODIGO") + "\" "
                 + " codigocorto=\"" + rs.getString("PR_CODIGO_CORTO") + "\" "
                 + " img1=\"" + "/Sistema" +rs.getString("PR_NOMIMG1") + "\" "
                 + " img2=\"" + "/Sistema" +rs.getString("PR_NOMIMG2") + "\" "
                 + " exist=\"" + rs.getDouble("PR_EXISTENCIA") + "\" "
                 + " cat1=\"" + rs.getInt("PR_CATEGORIA1") + "\" "
                 + " cat2=\"" + rs.getInt("PR_CATEGORIA2") + "\" "
                 + " cat3=\"" + rs.getInt("PR_CATEGORIA3") + "\" "
                 + " cat4=\"" + rs.getInt("PR_CATEGORIA4") + "\" "
                 + " cat5=\"" + rs.getInt("PR_CATEGORIA5") + "\" "
                 + " cat6=\"" + rs.getInt("PR_CATEGORIA6") + "\" "
                 + " cat7=\"" + rs.getInt("PR_CATEGORIA7") + "\" "
                 + " cat8=\"" + rs.getInt("PR_CATEGORIA8") + "\" "
                 + " cat9=\"" + rs.getInt("PR_CATEGORIA9") + "\" "
                 + " cat10=\"" + rs.getInt("PR_CATEGORIA10") + "\" "
                 + " umedida=\"" + rs.getInt("PR_UNIDADMEDIDA") + "\" "
                 + " reqexist=\"" + rs.getInt("PR_REQEXIST") + "\" "
                 + " exento1=\"" + rs.getInt("PR_EXENTO1") + "\" "
                 + " exento2=\"" + rs.getInt("PR_EXENTO2") + "\" "
                 + " exento3=\"" + rs.getInt("PR_EXENTO3") + "\" "
                 + " activo=\"" + rs.getInt("PR_ACTIVO") + "\" "
                 + " agrupa=\"0\" "
                 + " FactorPuntos=\"" + rs.getDouble("FactorPuntos") + "\" "
                 + " >");
         //anadimos los precios
         strXML.append(prec.getXMLPrec(rs.getString("PR_ID"), oConn, true, 0, intCT_LPRECIOS, intMON_ID, 0));
         strXML.append("</prod>");
      }
      rs.close();

      //Mostramos los productos agrupados
      if (intContaItems < intMaxItems) {
         int intRestan = intMaxItems - intContaItems;
         //Anadimos el orde
         strSql2 += "  ORDER BY PR_ID DESC  ";/*Having  ventasF + ventasR is not null */
         //add limits to query to get only rows necessary for output
         strSql2 += " LIMIT 0," + intRestan;
         rs = oConn.runQuery(strSql2, true);
         while (rs.next()) {
            //Generamos el texto del XML
            strXML.append("<prod "
                    + " id=\"0\" "
                    + " desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCION")) + "\" "
                    + " codigo=\"XAXAXAXAXAXA\" "
                    + " codigocorto=\"" + utilXML.Sustituye(rs.getString("PR_CODIGO_CORTO")) + "\" "
                    + " img1=\"" + "/Sistema" +rs.getString("PR_NOMIMG1") + "\" "
                    + " img2=\"" + "/Sistema" +rs.getString("PR_NOMIMG2") + "\" "
                    + " exist=\"" + rs.getDouble("TEXIS") + "\" "
                    + " cat1=\"" + rs.getInt("PR_CATEGORIA1") + "\" "
                    + " cat2=\"" + rs.getInt("PR_CATEGORIA2") + "\" "
                    + " cat3=\"" + rs.getInt("PR_CATEGORIA3") + "\" "
                    + " cat4=\"0\" "
                    + " cat5=\"0\" "
                    + " cat6=\"0\" "
                    + " cat7=\"0\" "
                    + " cat8=\"0\" "
                    + " cat9=\"0\" "
                    + " cat10=\"0\" "
                    + " umedida=\"" + rs.getInt("PR_UNIDADMEDIDA") + "\" "
                    + " reqexist=\"" + rs.getInt("PR_REQEXIST") + "\" "
                    + " exento1=\"" + rs.getInt("PR_EXENTO1") + "\" "
                    + " exento2=\"" + rs.getInt("PR_EXENTO2") + "\" "
                    + " exento3=\"" + rs.getInt("PR_EXENTO3") + "\" "
                    + " activo=\"" + rs.getInt("PR_ACTIVO") + "\" "
                    + " agrupa=\"1\" "
                    + " FactorPuntos=\"" + rs.getDouble("FactorPuntos") + "\" "
                    + " >");
            //anadimos los precios
            String strSql3 = "select PR_ID,PR_DESCRIPCION from vta_producto  "
                    + " where EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                    + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                    + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                    + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                    + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                    + " LIMIT 0,1";
            ResultSet rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               strXML.append(prec.getXMLPrec(rs3.getString("PR_ID"), oConn, true, 0, intCT_LPRECIOS, intMON_ID, 0));
            }
            rs3.close();
            //Anadimos las opciones para la clasificacion 4
            strXML.append("<clasif4>");
            strSql3 = "select PR_CATEGORIA4,vta_prodcat4.PC4_DESCRIPCION from vta_producto, vta_prodcat4     "
                    + " where  vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID and EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                    + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                    + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                    + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                    + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                    + " GROUP BY PR_CATEGORIA4,vta_prodcat4.PC4_DESCRIPCION";
            rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               strXML.append("<clasific4 "
                       + " id=\"" + rs3.getString("PR_CATEGORIA4") + "\" "
                       + " valor=\"" + utilXML.Sustituye(rs3.getString("PC4_DESCRIPCION")) + "\" "
                       + " />");
            }
            rs3.close();
            strXML.append("</clasif4>");
            //Anadimos las opciones para la clasificacion 5
            strXML.append("<clasif5>");
            strSql3 = "select PR_CATEGORIA5,vta_prodcat5.PC5_DESCRIPCION from vta_producto, vta_prodcat5     "
                    + " where  vta_producto.PR_CATEGORIA5 = vta_prodcat5.PC5_ID and EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                    + " AND PR_CATEGORIA1 = " + rs.getInt("PR_CATEGORIA1") + "   "
                    + " AND PR_CATEGORIA2 = " + rs.getInt("PR_CATEGORIA2") + " "
                    + (rs.getInt("PR_CATEGORIA3") == 0 ? "" : " AND PR_CATEGORIA3 = " + rs.getInt("PR_CATEGORIA3") + " ")
                    + " AND PR_CODIGO_CORTO = '" + rs.getString("PR_CODIGO_CORTO") + "' "
                    + " GROUP BY PR_CATEGORIA5,vta_prodcat5.PC5_DESCRIPCION";
            rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               strXML.append("<clasific5 "
                       + " id=\"" + rs3.getString("PR_CATEGORIA5") + "\" "
                       + " valor=\"" + utilXML.Sustituye(rs3.getString("PC5_DESCRIPCION")) + "\" "
                       + " />");
            }
            rs3.close();
            strXML.append("</clasif5>");
            strXML.append("</prod>");
         }
         rs.close();
      }

      strXML.append("</productos>");
      //Pintamos el XML
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
      out.println(strXML.toString());//Pintamos el resultado   
   }

   //Caso 4 obtener pr_id
   if (strOper.equals("4")) {
      String strDescrip = request.getParameter("Descrip");
      String strClas1 = request.getParameter("CLASIFIC1");
      String strClas2 = request.getParameter("CLASIFIC2");
      String strClas3 = request.getParameter("CLASIFIC3");
      String strClas4 = request.getParameter("CLASIFIC4");
      String strClas5 = request.getParameter("CLASIFIC5");

      if (strDescrip == null) {
         strDescrip = "";
      }
      if (strClas1 == null) {
         strClas1 = "0";
      }
      if (strClas2 == null) {
         strClas2 = "0";
      }
      if (strClas3 == null) {
         strClas3 = "0";
      }
      if (strClas4 == null) {
         strClas4 = "0";
      }
      if (strClas5 == null) {
         strClas5 = "0";
      }

      StringBuilder strFiltro = new StringBuilder(" EMP_ID = " + webBase.getIntEMP_ID());
      strFiltro.append(" AND PR_ECOMM = 1 ");

      if (!strClas1.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA1 = " + strClas1 + " ");
      }
      if (!strClas2.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA2 = " + strClas2 + " ");
      }
      if (!strClas3.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA3 = " + strClas3 + " ");
      }
      if (!strClas4.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA4 = " + strClas4 + " ");
      }
      if (!strClas5.equals("0")) {
         strFiltro.append(" AND PR_CATEGORIA5 = " + strClas5 + " ");
      }
      if (!strDescrip.equals("")) {
         strFiltro.append(" AND PR_CODIGO_CORTO = '" + strDescrip + "' ");
      }

      //Consulta de productos

      String strSql = "select PR_ID,PR_CODIGO,PR_CODIGO_CORTO "
              + " from vta_producto "
              + " where " + strFiltro.toString() + " and PR_AGRUPA_ECOMM = 1 ";

      //Anadimos el orde
      strSql += "  ORDER BY PR_ID DESC ";/*Having  ventasF + ventasR is not null */
      //add limits to query to get only rows necessary for output
      strSql += " LIMIT 0,1";
      //Cadena con el XML
      StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
      strXML.append("<productos>");


      //Ejecutamos la consulta
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         //Generamos el texto del XML
         strXML.append("<prod "
                 + " id=\"" + rs.getString("PR_ID") + "\" "
                 + " codigo=\"" + rs.getString("PR_CODIGO") + "\" "
                 + " codigocorto=\"" + rs.getString("PR_CODIGO_CORTO") + "\" ");
                 strXML.append(" >");
                                 //anadimos los precios
            String strSql3 = "select PR_ID,PR_DESCRIPCION from vta_producto  "
                    + " where EMP_ID = " + webBase.getIntEMP_ID() + " AND PR_ECOMM = 1 "
                    + " AND PR_ID =  " + rs.getString("PR_ID")
                    + " LIMIT 0,1";
            ResultSet rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               strXML.append(prec.getXMLPrec(rs.getString("PR_ID"), oConn, true, 0, intCT_LPRECIOS, intMON_ID, 0));
            }
            rs3.close();
         strXML.append("</prod>");
      }
      rs.close();

      strXML.append("</productos>");
      //Pintamos el XML
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
      out.println(strXML.toString());//Pintamos el resultado   
   }
   //Caso 5 agrega al carrito
   if (strOper.equals("5")) {
      boolean bolUsaFlete = true;
      String strCodigoFlete = "ENVIO";
      String strproduct_id = request.getParameter("product_id");
      String strquantity = request.getParameter("quantity");
      String strColor = request.getParameter("option[273]");
      String strTalla = request.getParameter("option[274]");
      boolean bolError = false;
      boolean bolErrorColor = false;
      boolean bolErrorTalla = false;
      boolean bolErrorCantidad = false;
      int intProductId = 0;
      int intCantidad = 0;
      int intTotCantidad = 0;
      int intModeloId = 0;
      double dblTotal = 0;
      //Validaciones de parametros
      if (strproduct_id == null) {
         bolError = true;
      }
      if (strColor == null) {
         bolError = true;
         bolErrorColor = true;
      }
      if (strTalla == null) {
         bolError = true;
         bolErrorTalla = true;
      }
      try {
         intCantidad = Integer.valueOf(strquantity);
      } catch (NumberFormatException ex) {
         bolError = true;
         bolErrorCantidad = true;
      }
      try {
         intModeloId = Integer.valueOf(strproduct_id);
      } catch (NumberFormatException ex) {
         bolError = true;

      }
      //Obtenemos la tasa de impuesto default
      double dblFactorImpuesto = 0;
      String strSqlI = "select * from vta_tasaiva where TI_ID = 1";
      ResultSet rsI = oConn.runQuery(strSqlI);
      while (rsI.next()) {
         dblFactorImpuesto = rsI.getDouble("TI_TASA");
         dblFactorImpuesto = 0;
      }
      rsI.close();

      //Objeto nuevo
      JSONObject objJsonItemNew = new JSONObject();
      //Buscamos datos del nuevo item
      double dblPrecioItem = 0;
      String strModeloItem = "";
      String strCodigoItem = "";
      String strColorItem = "";
      String strTallaItem = "";
      String strDescripcionProd = "";

      if (!bolError) {
         String strSql = "select vta_producto.PR_ID,vta_producto.PR_CODIGO,vta_prodcat2.PC2_ID,vta_prodcat2.PC2_DESCRIPCION, vta_prodcat2.PC2_ORDEN,PR_DESCRIPCIONCORTA, "
                 + " PR_NOMIMG1,PR_NOMIMG2 "
                 + "from vta_prodcat2 INNER JOIN vta_producto ON vta_prodcat2.PC2_ID = vta_producto.PR_CATEGORIA2"
                 + " where PC2_ID = " + strproduct_id + " "
                 + " and PR_CATEGORIA3=" + strTalla + " "
                 + " and PR_CATEGORIA4=" + strColor + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1"
                 + " ";
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            strCodigoItem = rs.getString("PR_CODIGO");
            strModeloItem = rs.getString("PC2_DESCRIPCION");
            intProductId = rs.getInt("PR_ID");
            strDescripcionProd = rs.getString("PR_DESCRIPCIONCORTA");
            //Precio
            if (varSesiones.getIntNoUser() != 0) {
               strSql = "select PP_PRECIO "
                       + "from vta_prodprecios where PR_ID = " + rs.getInt("PR_ID") + " AND LP_ID = 1";
            } else {
               strSql = "select PP_PRECIO "
                       + "from vta_prodprecios where PR_ID = " + rs.getInt("PR_ID") + " AND LP_ID = 2";
            }
            ResultSet rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               dblPrecioItem = rs2.getDouble("PP_PRECIO");
            }
            rs2.close();
            //Agregamos el impuesto
            double dblImpuesto = dblPrecioItem * (dblFactorImpuesto / 100);
            dblPrecioItem += dblImpuesto;
            strSql = "select PC3_DESCRIPCION "
                    + "from vta_prodcat3 where PC3_ID = " + strTalla + " ";

            rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               strTallaItem = rs2.getString("PC3_DESCRIPCION");
            }
            rs2.close();
            strSql = "select PC4_DESCRIPCION "
                    + "from vta_prodcat4 where PC4_ID = " + strColor + " ";

            rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               strTallaItem = rs2.getString("PC4_DESCRIPCION");
            }
            rs2.close();
         }
         rs.close();
      }
      //Si no hay error agregamos al carrito
      if (!bolError) {
         //Recuperamos la variable de sesion
         String strLst = Sesiones.gerVarSession(request, "CarSell");
         JSONObject objJsonCarrito = new JSONObject();
         JSONArray jsonChild = null;
         if (strLst.equals("0")) {

            //Nuevo item
            jsonChild = new JSONArray();
            objJsonItemNew.put("ProducId", intProductId);
            objJsonItemNew.put("ModeloId", intModeloId);
            objJsonItemNew.put("Cantidad", intCantidad);
            objJsonItemNew.put("Precio", dblPrecioItem);
            objJsonItemNew.put("Modelo", strModeloItem);
            objJsonItemNew.put("Codigo", strCodigoItem);
            objJsonItemNew.put("Color", strColorItem);
            objJsonItemNew.put("Talla", strTallaItem);
            objJsonItemNew.put("ColorId", strTalla);
            objJsonItemNew.put("TallaId", strColor);
            objJsonItemNew.put("Descripcion", strDescripcionProd);
            jsonChild.put(objJsonItemNew);
            objJsonCarrito.put("carritoCompras", jsonChild);
         } else {

            //Parseamos el objeto json
            objJsonCarrito = new JSONObject(strLst);
            jsonChild = objJsonCarrito.getJSONArray("carritoCompras");
            //Nuevo item
            objJsonItemNew.put("ProducId", intProductId);
            objJsonItemNew.put("ModeloId", intModeloId);
            objJsonItemNew.put("Cantidad", intCantidad);
            objJsonItemNew.put("Precio", dblPrecioItem);
            objJsonItemNew.put("Modelo", strModeloItem);
            objJsonItemNew.put("Codigo", strCodigoItem);
            objJsonItemNew.put("Color", strColorItem);
            objJsonItemNew.put("Talla", strTallaItem);
            objJsonItemNew.put("ColorId", strTalla);
            objJsonItemNew.put("TallaId", strColor);
            objJsonItemNew.put("Descripcion", strDescripcionProd);
            jsonChild.put(objJsonItemNew);
         }
         //System.out.println(objJsonCarrito.toString());
         //Actualizamos el carrito
         Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());

         //Flete

         if (bolUsaFlete) {
            strLst = Sesiones.gerVarSession(request, "CarSell");

            //Buscamos si ya tenemos el item del flete
            boolean bolExisteFlete = false;
            int intIdxFlete = 0;
            for (int i = 0; i < jsonChild.length(); i++) {
               JSONObject row = jsonChild.getJSONObject(i);
               if (row.getString("Codigo").equals(strCodigoFlete)) {
                  bolExisteFlete = true;
                  intIdxFlete = i;
               }
            }
            //Quitamos el flete para recalcularlo y agregarlo al final
            if (bolExisteFlete) {
               //Solo aplica si ya tienen algo...
               if (!strLst.equals("0")) {
                  //Parseamos el objeto json
                  objJsonCarrito = new JSONObject(strLst);
                  jsonChild = objJsonCarrito.getJSONArray("carritoCompras");
                  jsonChild.remove(intIdxFlete);
                  Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());
                  bolExisteFlete = false;
                  strLst = Sesiones.gerVarSession(request, "CarSell");
               }
               
               
            }
            //Nuevo flete
            if (!bolExisteFlete) {
               //buscamos el id del producto de flete
               String strSql = "select vta_producto.PR_ID,vta_producto.PR_CODIGO,PR_DESCRIPCIONCORTA, "
                       + " PR_NOMIMG1,PR_NOMIMG2 "
                       + " from  vta_producto "
                       + " where vta_producto.PR_CODIGO = '" + strCodigoFlete + "' "
                       + " AND SC_ID = " + webBase.getIntSC_ID()
                       + " ";
               ResultSet rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  String strCodigoItemFlete = rs.getString("PR_CODIGO");
                  String strModeloItemFlete = rs.getString("PR_DESCRIPCIONCORTA");
                  int intProductIdFlete = rs.getInt("PR_ID");
                  String strDescripcionProdFlete = rs.getString("PR_DESCRIPCIONCORTA");

                  //Precio
                  double dblPrecioItemFlete = 0;
                  if (varSesiones.getIntNoUser() != 0) {
                     strSql = "select PP_PRECIO "
                             + "from vta_prodprecios where PR_ID = " + intProductIdFlete + " AND LP_ID = 1";
                  } else {
                     strSql = "select PP_PRECIO "
                             + "from vta_prodprecios where PR_ID = " + intProductIdFlete + " AND LP_ID = 2";
                  }
                  ResultSet rs2 = oConn.runQuery(strSql, true);
                  while (rs2.next()) {
                     dblPrecioItemFlete = rs2.getDouble("PP_PRECIO");
                  }
                  rs2.close();
                  //Agregamos el impuesto
                  double dblImpuesto = dblPrecioItemFlete * (dblFactorImpuesto / 100);
                  dblPrecioItemFlete += dblImpuesto;

                  //Agregamos el flete
                  JSONObject objJsonItemNewFlete = new JSONObject();
                  objJsonItemNewFlete.put("ProducId", intProductIdFlete);
                  objJsonItemNewFlete.put("ModeloId", 0);
                  objJsonItemNewFlete.put("Cantidad", 1);
                  objJsonItemNewFlete.put("Precio", dblPrecioItemFlete);
                  objJsonItemNewFlete.put("Modelo", strModeloItemFlete);
                  objJsonItemNewFlete.put("Codigo", strCodigoItemFlete);
                  objJsonItemNewFlete.put("Color", "");
                  objJsonItemNewFlete.put("Talla", "");
                  objJsonItemNewFlete.put("ColorId", 0);
                  objJsonItemNewFlete.put("TallaId", 0);
                  objJsonItemNewFlete.put("Descripcion", strDescripcionProdFlete);
                  //Solo aplica si ya tienen algo...
                  if (!strLst.equals("0")) {
                     //Parseamos el objeto json
                     objJsonCarrito = new JSONObject(strLst);
                     jsonChild = objJsonCarrito.getJSONArray("carritoCompras");
                     jsonChild.put(objJsonItemNewFlete);
                     Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());
                  }

               }
               rs.close();
            }
         }


         //Obtenemos el resumen del carrito
         for (int i = 0; i < jsonChild.length(); i++) {
            JSONObject row = jsonChild.getJSONObject(i);
            intTotCantidad += row.getInt("Cantidad");
            dblTotal += row.getDouble("Precio") * row.getInt("Cantidad");
            //System.out.println(row.getInt("Cantidad"));

         }
      }
      //Respuesta
      JSONObject objJsonCte = new JSONObject();

      if (!bolError) {
         objJsonCte.put("success", "Exito has agregado el producto:" + strModeloItem);
         objJsonCte.put("total", intTotCantidad + " item(s) - MX $" + NumberString.FormatearDecimal(dblTotal, 2));//5512-4591-20
      } else {
         //Respuesta de error
         JSONObject objJsonCte3 = new JSONObject();
         if (bolErrorColor) {
            objJsonCte3.put("273", "Colores obligatorio!");
         }
         if (bolErrorTalla) {
            objJsonCte3.put("274", "Tallas obligatorio!");

         }
         if (bolErrorCantidad) {
            objJsonCte3.put("500", "Error en la cantidad");
         }
         JSONObject objJsonCteArray = new JSONObject();
         objJsonCteArray.put("option", objJsonCte3);
         objJsonCte.put("error", objJsonCteArray);
         objJsonCte.put("redirect", "");//
      }

      //objJsonCte.put("error", rs.getString("PR_DESCRIPCION"));
      //Pintamos el XML
      out.clearBuffer();//Limpiamos buffer
      atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
      out.println(objJsonCte.toString());
   }


//Cerramos conexion
   oConn.close();
%>