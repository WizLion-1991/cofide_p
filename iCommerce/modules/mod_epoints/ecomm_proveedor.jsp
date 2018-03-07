<%-- 
    Document   : ecomm_proveedor
    Created on : Oct 15, 2015, 5:29:44 PM
    Author     : CasaJosefa
--%>

<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.SQLException"%>
<%@page import="ERP.Precios"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
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

        String strXMLHEAD = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
        StringBuilder strXML = new StringBuilder(strXMLHEAD);

        strXML.append("<proveedor>");

        String strSql = "Select vta_proveedor.PV_ID,PV_RESTRICCIONES,PV_RAZONSOCIAL,PV_PAGINAWEB,PV_FACEBOOK,PV_CONTACTO1,PV_TELEFONO1,PV_IMG1"
                + " From vta_producto,vta_proveedor "
                + " Where  vta_producto.PV_ID = vta_proveedor.PV_ID and "
                + "PR_CATEGORIA1 = " + strClas1 + " group by PV_RAZONSOCIAL,PV_PAGINAWEB,PV_FACEBOOK,PV_CONTACTO1,PV_TELEFONO1,PV_IMG1;";
        ResultSet rs = oConn.runQuery(strSql);

        try {
            while (rs.next()) {

                strXML.append("<prov");
                strXML.append(" PV_ID=\"").append(rs.getString("PV_ID")).append("\" ");
                strXML.append(" PV_RAZONSOCIAL=\"").append(rs.getString("PV_RAZONSOCIAL")).append("\" ");
                strXML.append(" PV_PAGINAWEB=\"").append(rs.getString("PV_PAGINAWEB")).append("\" ");
                strXML.append(" PV_FACEBOOK=\"").append(rs.getString("PV_FACEBOOK")).append("\" ");
                strXML.append(" PV_CONTACTO1=\"").append(rs.getString("PV_CONTACTO1")).append("\" ");
                strXML.append(" PV_TELEFONO1=\"").append(rs.getString("PV_TELEFONO1")).append("\" ");
                strXML.append(" PV_IMG1=\"").append(rs.getString("PV_IMG1")).append("\" ");
                strXML.append(" PV_RESTRICCIONES=\"").append(rs.getString("PV_RESTRICCIONES")).append("\" ");
                strXML.append("/>");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println(" " + ex.getMessage());
        }
        strXML.append("</proveedor>");

        //Pintamos el XML
        out.clearBuffer();//Limpiamos buffer
        atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
        out.println(strXML.toString());//Pintamos el resultado   
    }

    if (strOper.equals("2")) {

        String PV_ID = request.getParameter("PV_ID");
        String strClas1 = request.getParameter("CLASIFIC1");
        String strClas2 = request.getParameter("CLASIFIC2");
        String strClas3 = request.getParameter("CLASIFIC3");
        String strClas4 = request.getParameter("CLASIFIC4");
        String strClas5 = request.getParameter("CLASIFIC5");
        String strClas6 = request.getParameter("CLASIFIC6");

        int intPaginaActual = 0;

        if (PV_ID == null) {
            PV_ID = "";
        }

        String strRestriccion = "";
        String strSqlq = "Select PV_RESTRICCIONES "
                + " From vta_proveedor "
                + " Where  PV_ID = " + PV_ID;
        ResultSet rsq = oConn.runQuery(strSqlq);
        try {
            while (rsq.next()) {
                strRestriccion = rsq.getString("PV_RESTRICCIONES");
            }
            rsq.close();
        } catch (SQLException ex) {
            System.out.println(" " + ex.getMessage());
        }

        StringBuilder strFiltro = new StringBuilder(" EMP_ID = " + webBase.getIntEMP_ID());
        strFiltro.append(" AND SC_ID = 1 ");
        strFiltro.append(" AND PR_ECOMM = 1 ");
        strFiltro.append(" AND PV_ID = " + PV_ID + " ");
        strFiltro.append(" AND PR_CATEGORIA1 = " + strClas1 + " ");

        //Consulta de productos
        String strSql = "select PR_ID,PR_RESTRICCIONES,PR_CODIGO,PR_CODIGO_CORTO,PR_DESCRIPCION,PR_NOMIMG1,PR_NOMIMG2"
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
                + ",(select PV_FAC_CONV_PUNTOS from vta_proveedor where vta_producto.PV_ID = vta_proveedor.PV_ID) as FactorPuntos "
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
        try {
            //Ejecutamos la consulta
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

                String strRestriccion2 = "";
                if (rs.getString("PR_RESTRICCIONES").equals("")) {
                    strRestriccion2 = strRestriccion;
                } else {
                    strRestriccion2 = rs.getString("PR_RESTRICCIONES");
                }
                //Generamos el texto del XML
                strXML.append("<prod "
                        + " id=\"" + rs.getString("PR_ID") + "\" "
                        + " desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCION")) + "\" "
                        + " codigo=\"" + rs.getString("PR_CODIGO") + "\" "
                        + " codigocorto=\"" + rs.getString("PR_CODIGO_CORTO") + "\" "
                        + " img1=\"" + "/Sistema" + rs.getString("PR_NOMIMG1") + "\" "
                        + " img2=\"" + "/Sistema" + rs.getString("PR_NOMIMG2") + "\" "
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
                        + " restriccion=\"" + strRestriccion2 + "\" "
                        + " agrupa=\"0\" "
                        + " FactorPuntos=\"" + rs.getDouble("FactorPuntos") + "\" "
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
                        + " img1=\"" + "/Sistema" + rs.getString("PR_NOMIMG1") + "\" "
                        + " img2=\"" + "/Sistema" + rs.getString("PR_NOMIMG2") + "\" "
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
        } catch (Exception ex) {
            System.out.println("EcommProd(Error):" + ex.getMessage());
        }
        strXML.append("</productos>");
        //Pintamos el XML
        out.clearBuffer();//Limpiamos buffer
        atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
        out.println(strXML.toString());//Pintamos el resultado   
    }

//Cerramos conexion
    oConn.close();
%>