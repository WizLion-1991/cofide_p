<%-- 
    Document   : pedidos_mak_procs
    Created on : Dec 14, 2015, 12:15:56 PM
    Author     : CasaJosefa
--%>

<%@page import="java.util.StringTokenizer"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.SQLException"%>
<%@page import="ERP.ClienteFacturacion"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>



<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   Fechas fecha = new Fechas();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      //Evaluamos el turno

//Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Genera una nueva operacion de pagos en base a la transaccion que nos envian
         if (strid.equals("1")) {

            UtilXml util = new UtilXml();
            String intIdCT = request.getParameter("intIdCT");
            String intTipo = request.getParameter("intTipo");
            String intIdSc = request.getParameter("intIdSc");
            String strSql = "";

            if (intIdCT.equals("0")) {
            }

            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strRes += "<cliente>";

            strSql = "select  CT_ID,CT_RAZONSOCIAL,CT_RFC,CT_TELEFONO1,CT_ACTIVO,CT_FORMADEPAGO,CT_CONTACTO1,CT_EMAIL1,CT_CONTACTO2,CT_EMAIL2,MON_ID,CT_VENDEDOR,CT_LPRECIOS,CT_DESCUENTO,SC_ID,"
               + "TTC_ID,"
               + " (CONCAT('Calle: ',vta_cliente.CT_CALLE,' Numero: ',vta_cliente.CT_NUMERO,' Num Int: ', vta_cliente.CT_NUMINT,' Colonia: '"
               + ", CT_COLONIA,'Pais: ', (select paises.PA_NOMBRE from paises where PA_ID = vta_cliente.PA_ID),' Estado: ',' Ciudad: ',"
               + " vta_cliente.CT_CIUDAD, ' Municipio: ',vta_cliente.CT_MUNICIPIO,'CP: ',vta_cliente.CT_CP))as direccion, "
               + " (select SC_NOMBRE from vta_sucursal where  vta_sucursal.SC_ID = vta_cliente.SC_ID ) as sucursal, "
               + "  (select VE_NOMBRE from vta_vendedor where vta_vendedor.VE_ID = vta_cliente.CT_VENDEDOR) as vendedorNom "
               + "  from vta_cliente "
               + " where  CT_RAZONSOCIAL like '%" + intIdCT + "%' "
               // + " and  CT_CATEGORIA1 =  " + intTipo + " " 
               // + " and  SC_ID =  " + intIdSc + " " 
               + " and EMP_ID = " + varSesiones.getIntIdEmpresa() + " "
               + " order by CT_RAZONSOCIAL;";

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes += "<cliente_deta";
               strRes += " CT_ID= \"" + (rs.getString("CT_ID")) + "\"  ";
               strRes += " CT_RAZONSOCIAL= \"" + (rs.getString("CT_RAZONSOCIAL")) + "\"  ";
               strRes += " CT_RFC= \"" + (rs.getString("CT_RFC")) + "\"  ";
               strRes += " CT_TELEFONO1= \"" + (rs.getString("CT_TELEFONO1")) + "\"  ";
               strRes += " CT_ACTIVO= \"" + (rs.getString("CT_ACTIVO")) + "\"  ";
               strRes += " CT_FORMADEPAGO= \"" + (rs.getString("CT_FORMADEPAGO")) + "\"  ";
               strRes += " CT_CONTACTO1= \"" + (rs.getString("CT_CONTACTO1")) + "\"  ";
               strRes += " CT_EMAIL1= \"" + (rs.getString("CT_EMAIL1")) + "\"  ";
               strRes += " CT_VENDEDOR= \"" + (rs.getString("CT_VENDEDOR")) + "\"  ";
               strRes += " CT_LPRECIOS= \"" + (rs.getString("CT_LPRECIOS")) + "\"  ";
               strRes += " direccion= \"" + (rs.getString("direccion")) + "\"  ";
               strRes += " sucursal= \"" + (rs.getString("sucursal")) + "\"  ";
               strRes += " vendedorNom= \"" + rs.getString("vendedorNom") + "\"  ";
               strRes += " MON_ID= \"" + rs.getString("MON_ID") + "\"  ";
               strRes += " TTC_ID= \"" + rs.getString("TTC_ID") + "\"  ";
               strRes += " CT_DESCUENTO= \"" + rs.getString("CT_DESCUENTO") + "\"  ";
               strRes += " SC_ID= \"" + rs.getString("SC_ID") + "\"  ";
               strRes += "/>";
            }

            strRes += "</cliente>";
            rs.getStatement().close();
            rs.close();

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
         }
         if (strid.equals("2")) {

            String strXMLHEAD = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            StringBuilder strXML = new StringBuilder(strXMLHEAD);

            strXML.append("<rows>");
            strXML.append("<page>").append(0).append("</page>");
            strXML.append("<total>").append(0).append("</total>");
            strXML.append("<records>").append(0).append("</records>");

            strXML.append("<row>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");
            strXML.append("<cell>").append("").append("</cell>");

            strXML.append("</row>");

            strXML.append("</rows>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            //Obtenemos el XML para el GRID
            out.println(strXML);//Pintamos el resultado
         }

         if (strid.equals("3")) {

            ClienteFacturacion dir = new ClienteFacturacion(varSesiones);
            int intId = 0;

            dir.getCF().setFieldString("DFA_CALLE", request.getParameter("DFA_CALLE"));
            dir.getCF().setFieldString("DFA_COLONIA", request.getParameter("DFA_COLONIA"));
            dir.getCF().setFieldString("DFA_LOCALIDAD", request.getParameter("DFA_LOCALIDAD"));
            dir.getCF().setFieldString("DFA_MUNICIPIO", request.getParameter("DFA_MUNICIPIO"));
            dir.getCF().setFieldString("DFA_ESTADO", request.getParameter("DFA_ESTADO"));
            dir.getCF().setFieldString("DFA_CP", request.getParameter("DFA_CP"));
            dir.getCF().setFieldString("DFA_NUMERO", request.getParameter("DFA_NUMERO"));
            dir.getCF().setFieldString("DFA_NUMINT", request.getParameter("DFA_NUMINT"));
            dir.getCF().setFieldString("DFA_TELEFONO", request.getParameter("DFA_TELEFONO"));
            dir.getCF().setFieldString("DFA_RAZONSOCIAL", request.getParameter("DFA_RAZONSOCIAL"));
            dir.getCF().setFieldString("DFA_RFC", request.getParameter("DFA_RFC"));
            dir.getCF().setFieldString("DFA_EMAIL", request.getParameter("DFA_EMAIL"));
            dir.getCF().setFieldString("DFA_PAIS", request.getParameter("DFA_PAIS"));
            dir.getCF().setFieldInt("DFA_VISIBLE", Integer.parseInt(request.getParameter("DFA_VISIBLE")));
            dir.getCF().setFieldString("DFA_CIUDAD", request.getParameter("DFA_CIUDAD"));

            if (request.getParameter("CT_ID") != null) {
               try {
                  intId = Integer.parseInt(request.getParameter("CT_ID"));
               } catch (NumberFormatException e) {
                  e.getMessage();
               }
            }
            dir.getCF().setFieldInt("CT_ID", intId);

            String strRespXML = dir.saveClienteFacturacionPed(oConn);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRespXML);//Mandamos a pantalla el resultado

         }

         if (strid.equals("4")) {
            ClienteFacturacion dir = new ClienteFacturacion(varSesiones);
            int intId = 0;
            if (request.getParameter("dir_id") != null) {
               intId = Integer.parseInt(request.getParameter("dir_id"));
               dir.getCF().setFieldInt("CDE_ID", intId);
            }
            String strResp = dir.delClienteFacturacion(oConn);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResp);//Mandamos a pantalla el resultado
         }

         if (strid.equals("5")) {
            int intIdDir = 0;
            ResultSet rs;
            String strResp = "";
            if (request.getParameter("id_dir") != null) {
               intIdDir = Integer.parseInt(request.getParameter("id_dir"));
            }
            try {
               String strSelect = "SELECT count(DFA_ID) as NUM FROM vta_facturas WHERE DFA_ID =" + intIdDir;
               rs = oConn.runQuery(strSelect);
               while (rs.next()) {
                  strResp = "OK";
               }
               rs.getStatement().close();
               rs.close();
            } catch (SQLException Ex) {
               strResp = Ex.getMessage();
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResp);//Mandamos a pantalla el resultado
         }

         if (strid.equals("6")) {

            String stridCte = request.getParameter("idCte");

            String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            //Armamos el xml
            try {

               String strConsulta = " SELECT * FROM vta_cliente_facturacion  where ct_id =" + stridCte + "  or DFA_VISIBLE = 1";

               ResultSet rs = oConn.runQuery(strConsulta);

               strXMLData += "<Subcliente>";
               while (rs.next()) {
                  strXMLData += "<Subcliente_deta";
                  strXMLData += " DFA_ID=\'" + rs.getString("DFA_ID") + "\'";
                  strXMLData += " DFA_RAZONSOCIAL=\'" + rs.getString("DFA_RAZONSOCIAL") + "\'";
                  strXMLData += " DFA_RFC=\'" + rs.getString("DFA_RFC") + "\'";
                  strXMLData += " DFA_CALLE=\'" + rs.getString("DFA_CALLE") + "\'";
                  strXMLData += " DFA_NUMERO=\'" + rs.getString("DFA_NUMERO") + "\'";
                  strXMLData += " DFA_NUMINT=\'" + rs.getString("DFA_NUMINT") + "\'";
                  strXMLData += " DFA_COLONIA=\'" + rs.getString("DFA_COLONIA") + "\'";
                  strXMLData += " DFA_LOCALIDAD=\'" + rs.getString("DFA_LOCALIDAD") + "\'";
                  strXMLData += " DFA_MUNICIPIO=\'" + rs.getString("DFA_MUNICIPIO") + "\'";
                  strXMLData += " DFA_ESTADO=\'" + rs.getString("DFA_ESTADO") + "\'";
                  strXMLData += " DFA_CP=\'" + rs.getString("DFA_CP") + "\'";
                  strXMLData += " CT_ID=\'" + rs.getString("CT_ID") + "\'";
                  strXMLData += " DFA_TELEFONO=\'" + rs.getString("DFA_TELEFONO") + "\'";
                  strXMLData += " DFA_EMAIL=\'" + rs.getString("DFA_EMAIL") + "\'";
                  strXMLData += " DFA_PAIS=\'" + rs.getString("DFA_PAIS") + "\'";
                  strXMLData += " DFA_VISIBLE=\'" + rs.getString("DFA_VISIBLE") + "\'";
                  strXMLData += " DFA_CIUDAD=\'" + rs.getString("DFA_CIUDAD") + "\'";
                  strXMLData += "/>";
               }
               rs.getStatement().close();
               rs.close();
               strXMLData += "</Subcliente>";
            } catch (SQLException ex) {
               ex.fillInStackTrace();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXMLData);//Mandamos a pantalla el resultado
         }

         if (strid.equals("7")) {
            String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            boolean boolCoincideElCodigo = false;
            String strCodigoProducto = request.getParameter("idCte");
            try {
               String strSelect = "select * from vta_producto where PR_CODIGO = '" + strCodigoProducto + "' and sc_id = " + varSesiones.getIntSucursalMaster();
               ResultSet rs = oConn.runQuery(strSelect);
               strXMLData += "<producto>";
               while (rs.next()) {
                  boolCoincideElCodigo = true;
                  strXMLData += "<producto_deta";
                  strXMLData += " DFA_ID=\'" + rs.getString("DFA_ID") + "\'";
                  strXMLData += " DFA_RAZONSOCIAL=\'" + rs.getString("DFA_RAZONSOCIAL") + "\'";
                  strXMLData += " DFA_RFC=\'" + rs.getString("DFA_RFC") + "\'";
                  strXMLData += " DFA_CALLE=\'" + rs.getString("DFA_CALLE") + "\'";
                  strXMLData += " DFA_NUMERO=\'" + rs.getString("DFA_NUMERO") + "\'";
                  strXMLData += " DFA_NUMINT=\'" + rs.getString("DFA_NUMINT") + "\'";
                  strXMLData += " DFA_COLONIA=\'" + rs.getString("DFA_COLONIA") + "\'";
                  strXMLData += " DFA_LOCALIDAD=\'" + rs.getString("DFA_LOCALIDAD") + "\'";
                  strXMLData += " DFA_MUNICIPIO=\'" + rs.getString("DFA_MUNICIPIO") + "\'";
                  strXMLData += " DFA_ESTADO=\'" + rs.getString("DFA_ESTADO") + "\'";
                  strXMLData += " DFA_CP=\'" + rs.getString("DFA_CP") + "\'";
                  strXMLData += " CT_ID=\'" + rs.getString("CT_ID") + "\'";
                  strXMLData += " DFA_TELEFONO=\'" + rs.getString("DFA_TELEFONO") + "\'";
                  strXMLData += " DFA_EMAIL=\'" + rs.getString("DFA_EMAIL") + "\'";
                  strXMLData += " DFA_PAIS=\'" + rs.getString("DFA_PAIS") + "\'";
                  strXMLData += " DFA_VISIBLE=\'" + rs.getString("DFA_VISIBLE") + "\'";
                  strXMLData += "/>";
               }
               rs.getStatement().close();
               rs.close();

               strXMLData += "</producto>";
            } catch (SQLException Ex) {
               System.out.println(Ex.getMessage());
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXMLData);//Mandamos a pantalla el resultado
         }

         if (strid.equals("8")) {
            //int intFechaActual = Integer.parseInt(fecha.FormateaBD(fecha.getFechaActualDDMMAAAADiagonal(), "/"));
            String intFechaSurtido = fecha.addFecha(fecha.FormateaBD(fecha.getFechaActualDDMMAAAADiagonal(), "/"), 5, 1);
            String intFechaEntrega = fecha.addFecha(fecha.FormateaBD(fecha.getFechaActualDDMMAAAADiagonal(), "/"), 5, 2);
            String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXMLData += "<fecha>";
            strXMLData += "<fecha_deta";
            strXMLData += " fecha_pedido=\'" + fecha.getFechaActualDDMMAAAADiagonal() + "\'";
            strXMLData += " fecha_entrega=\'" + fecha.FormateaDDMMAAAA(intFechaEntrega, "/") + "\'";
            strXMLData += " fecha_surtido=\'" + fecha.FormateaDDMMAAAA(intFechaSurtido, "/") + "\'";
            strXMLData += "/>";
            strXMLData += "</fecha>";

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXMLData);//Mandamos a pantalla el resultado
         }

         if (strid.equals("9")) {

            int strFechaPedido = Integer.parseInt(fecha.FormateaBD(request.getParameter("FechaPedido"), "/"));
            int strFechaSurtido = Integer.parseInt(fecha.FormateaBD(request.getParameter("FechaSurtido"), "/"));
            int strFechaEntrega = Integer.parseInt(fecha.FormateaBD(request.getParameter("FechaEntrega"), "/"));
            int boolBandera = Integer.parseInt(request.getParameter("boolBandera"));

            int strFechaPedido1 = Integer.parseInt(fecha.addFecha(fecha.FormateaBD(request.getParameter("FechaPedido"), "/"), 5, 1));
            int strFechaPedido2 = Integer.parseInt(fecha.addFecha(fecha.FormateaBD(request.getParameter("FechaPedido"), "/"), 5, 2));

            String fecharegreso = "";
            String strResp = "";

            if (boolBandera == 1) {
               if (strFechaPedido1 <= strFechaSurtido) {
                  strResp = "OK";
               } else {
                  strResp = "La fecha surtido debe ser mayor a 24 hrs de la fecha pedido";
                  fecharegreso = fecha.addFecha(fecha.FormateaBD(request.getParameter("FechaPedido"), "/"), 5, 1);
               }
            }

            if (boolBandera == 2) {
               if (strFechaPedido2 <= strFechaEntrega) {
                  strResp = "OK";
               } else {
                  strResp = "La fecha de entrega debe ser mayor a 48 hrs de la fecha pedido";
                  fecharegreso = fecha.addFecha(fecha.FormateaBD(request.getParameter("FechaPedido"), "/"), 5, 2);
               }
            }

            //System.out.println(fecha.FormateaDDMMAAAA(fecharegreso, "/"));
            String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXMLData += "<fecha>";
            strXMLData += "<fecha_deta";
            strXMLData += " respuesta=\'" + strResp + "\'";
            if (strResp.equals("OK")) {
               strXMLData += " fecha=\'" + fecharegreso + "\'";
            } else {
               strXMLData += " fecha=\'" + fecha.FormateaDDMMAAAA(fecharegreso, "/") + "\'";
            }
            strXMLData += "/>";
            strXMLData += "</fecha>";

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXMLData);//Mandamos a pantalla el resultado
         }

         if (strid.equals("10")) {
            UtilXml utilXML = new UtilXml();
            String strPR_CODIGO = request.getParameter("PR_CODIGO");
            String strSC_ID = request.getParameter("SC_ID");
            String strSC_ID2 = request.getParameter("SC_ID2");
            String strEMP_ID = request.getParameter("EMP_ID");
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
            double dblDisponible = 0;
            //Buscamos el producto en la bd
            String strSql = "SELECT PR_ID,PR_CODIGO,PR_CODBARRAS,PR_DESCRIPCION,"
               + "PR_DESCRIPCIONCORTA,PR_DESCRIPCIONCOMPRA,"
               + "PR_REQEXIST,PR_EXENTO1,PR_EXENTO2,PR_EXENTO3,"
               + "PR_COSTOPROM,PR_COSTOCOMPRA,PR_COSTOREPOSICION,PR_UNIDADMEDIDA,MON_ID,PR_EXISTENCIA "
               + ",PR_CATEGORIA1,PR_CATEGORIA2,PR_CATEGORIA3,PR_CATEGORIA4,PR_CATEGORIA5,"
               + "PR_CATEGORIA6,PR_CATEGORIA7,PR_CATEGORIA8,PR_CATEGORIA9,PR_CATEGORIA10"
               + ",PR_USO_NOSERIE,GT_ID,PR_TASA_IVA,PR_INVENTARIO,"
               + " getTExistenciaCodigo(vta_producto.PR_CODIGO,vta_producto.SC_ID)   - getTApartadosCodigo(vta_producto.PR_CODIGO,vta_producto.SC_ID) AS DISPONIBILIDAD "
               + " FROM vta_producto "
               + " where (PR_CODIGO = '" + strPR_CODIGO + "' "
               + " OR PR_CODBARRAS = '" + strPR_CODIGO + "') "
               + " AND SC_ID = '" + strSC_ID + "'"
               + " AND EMP_ID = " + strEMP_ID;
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
               dblDisponible = rs.getDouble("DISPONIBILIDAD");
            }
            rs.getStatement().close();
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
               rs.getStatement().close();
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
               rs.getStatement().close();
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
               rs.getStatement().close();
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
               rs.getStatement().close();
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
               + " PR_DISPONIBLE = \"" + dblDisponible + "\"  "
               + " />");
            strRes.append("</vta_producto>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("11")) {
            UtilXml utilXML = new UtilXml();
            String strPR_CODIGO = request.getParameter("PR_CODIGO");
            String strSC_ID = request.getParameter("SC_ID");
            String strSC_ID2 = request.getParameter("SC_ID2");
            String strEMP_ID = request.getParameter("EMP_ID");
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

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_producto_mas>");

            //Buscamos el producto en la bd
            String strSql = "SELECT PR_ID,PR_CODIGO,PR_CODBARRAS,PR_DESCRIPCION,"
               + "PR_DESCRIPCIONCORTA,PR_DESCRIPCIONCOMPRA,"
               + "PR_REQEXIST,PR_EXENTO1,PR_EXENTO2,PR_EXENTO3,"
               + "PR_COSTOPROM,PR_COSTOCOMPRA,PR_COSTOREPOSICION,PR_UNIDADMEDIDA,MON_ID,PR_EXISTENCIA "
               + ",PR_CATEGORIA1,PR_CATEGORIA2,PR_CATEGORIA3,PR_CATEGORIA4,PR_CATEGORIA5,"
               + "PR_CATEGORIA6,PR_CATEGORIA7,PR_CATEGORIA8,PR_CATEGORIA9,PR_CATEGORIA10"
               + ",PR_USO_NOSERIE,GT_ID,PR_TASA_IVA,PR_INVENTARIO "
               + " FROM vta_producto "
               + " where (PR_CODIGO like '%" + strPR_CODIGO + "%' "
               + " OR PR_CODBARRAS like '%" + strPR_CODIGO + "%') "
               + " AND SC_ID = '" + strSC_ID + "'"
               + " AND EMP_ID = " + strEMP_ID;
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

               //Validamos el almacen secundario en caso que proceda
               if (!strSC_ID2.equals("")) {
                  String strSql1 = "SELECT PR_ID "
                     + " FROM vta_producto "
                     + " where (PR_CODIGO = '" + strPR_CODIGO + "' "
                     + " OR PR_CODBARRAS = '" + strPR_CODIGO + "') "
                     + " AND SC_ID = '" + strSC_ID2 + "'";
                  ResultSet rs1 = oConn.runQuery(strSql1, true);
                  while (rs1.next()) {
                     intPR_ID2 = rs1.getInt("PR_ID");
                  }
                  rs1.getStatement().close();
                  rs1.close();
               }
               //Si tiene unidad de medida sacamos el concepto
               if (intPR_UNIDADMEDIDA != 0) {
                  String strSql2 = "SELECT ME_DESCRIPCION "
                     + " FROM vta_unidadmedida "
                     + " where ME_ID = '" + intPR_UNIDADMEDIDA + "'";
                  ResultSet rs2 = oConn.runQuery(strSql2, true);
                  while (rs2.next()) {
                     strUnidadMedida = rs2.getString("ME_DESCRIPCION");
                  }
                  rs2.getStatement().close();
                  rs2.close();
               }
               //Si tiene categoría 1 buscamos
               String strCategoria1 = "";
               if (intPR_CATEGORIA1 != 0) {
                  String strSql3 = "SELECT PC_DESCRIPCION "
                     + " FROM vta_prodcat1 "
                     + " where PC_ID = '" + intPR_CATEGORIA1 + "'";
                  ResultSet rs3 = oConn.runQuery(strSql3, true);
                  while (rs3.next()) {
                     strCategoria1 = rs3.getString("PC_DESCRIPCION");
                  }
                  rs3.getStatement().close();
                  rs3.close();
               }
               //Si tiene asignada una tasa de iva diferente buscamos el factor
               if (intPR_TASA_IVA != 0) {
                  String strSql4 = "SELECT TI_TASA "
                     + " FROM vta_tasaiva "
                     + " where TI_ID = '" + intPR_TASA_IVA + "'";
                  ResultSet rs4 = oConn.runQuery(strSql4, true);
                  while (rs4.next()) {
                     dblTasaIVAAplica = rs4.getDouble("TI_TASA");
                  }
                  rs4.getStatement().close();
                  rs4.close();
               }

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

            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_producto_mas>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }
         if (strid.equals("12")) {
            UtilXml utilXML = new UtilXml();

            String strPR_CODIGO = request.getParameter("intPrId");

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_producto_suc>");

            //Buscamos el producto en la bd
            String strSql = "SELECT vta_sucursales_master.SM_CODIGO,vta_sucursal.SC_NOMBRE,vta_producto.PR_DESCRIPCION "
               + " ,vta_producto.PR_CODIGO"
               + " , (select ME_DESCRIPCION from vta_unidadmedida where vta_unidadmedida.ME_ID = vta_producto.PR_UNIDADMEDIDA)AS UNIDADMEDIDA"
               + " ,PR_NOMIMG1,PR_GPO_MODI_PREC"
               + " ,getTExistenciaCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID)  AS EXISTENCIA "
               + " ,getTApartadosCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID) AS APARTADOS "
               + " ,getTExistenciaCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID)   - getTApartadosCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID) AS DISPONIBILIDAD "
               + " FROM vta_sucursales_master JOIN vta_sucursal_master_as ON vta_sucursales_master.SM_ID = vta_sucursal_master_as.SM_ID  JOIN vta_sucursal "
               + " ON vta_sucursal_master_as.SC_ID = vta_sucursal.SC_ID  JOIN vta_producto ON vta_producto.SC_ID = vta_sucursal.SC_ID where PR_CODIGO = '" + strPR_CODIGO + "' AND vta_sucursales_master.EMP_ID = " + varSesiones.getIntIdEmpresa() + "  "
               + " group by vta_sucursales_master.SM_CODIGO,  vta_sucursal.SC_NOMBRE,vta_producto.PR_DESCRIPCION,vta_producto.PR_CODIGO,vta_producto.PR_UNIDADMEDIDA,PR_NOMIMG1"
               + " ,vta_producto.PR_GPO_MODI_PREC,vta_sucursal.SC_ID; ";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes.append("<vta_productos "
                  + " sucursal = \"" + rs.getString("SC_NOMBRE") + "\"  "
                  + " existencia = \"" + rs.getString("EXISTENCIA") + "\"  "
                  + " asignado = \"" + rs.getString("APARTADOS") + "\"  "
                  + " disponible = \"" + rs.getString("DISPONIBILIDAD") + "\"  "
                  + " observaciones = \"" + rs.getString("PR_DESCRIPCION") + "\"  "
                  + " PR_CODIGO = \"" + rs.getString("PR_CODIGO") + "\"  "
                  + " PR_UNIDADMEDIDA = \"" + rs.getString("UNIDADMEDIDA") + "\"  "
                  + " imagen = \"" + rs.getString("PR_NOMIMG1") + "\"  "
                  + " codprec = \"" + rs.getString("PR_GPO_MODI_PREC") + "\"  "
                  + " />");
            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_producto_suc>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("13")) {

            String strArea = request.getParameter("strArea");
            String strNota = request.getParameter("strNota");
            String strIdPedido = request.getParameter("strIdPedido");
            String strNomUsuario = "";
            String strNomArea = "";

            String strSql = "select nombre_usuario from usuarios where id_usuarios = " + varSesiones.getIntNoUser();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strNomUsuario = rs.getString("nombre_usuario");
            }
            rs.getStatement().close();
            rs.close();

            String strSql1 = "select AR_DESCRIPCION from vta_areas where AR_ID = " + strArea;
            ResultSet rs1 = oConn.runQuery(strSql1, true);
            while (rs1.next()) {
               strNomArea = rs1.getString("AR_DESCRIPCION");
            }
            rs1.getStatement().close();
            rs1.close();

            /*String strSql1 = "insert into vta_pedidos_mensajes (MSJ_ID_PD,MSJ_ID_USUARIO,MSJ_USUARIO,MSJ_EMP_ID,MSJ_SC_ID,MSJ_AREA,MSJ_NOTA,MSJ_FECHA,MSJ_HORA) "
                 + "values (" + strIdPedido + "," + varSesiones.getIntNoUser() + ",'" + strNomUsuario + "'," + varSesiones.getIntIdEmpresa() + "," + varSesiones.getIntSucursalDefault() + "," + strArea + ",'" + strNota + "','" + fecha.getFechaActual() + "','" + fecha.getHoraActual() + "');";
                 oConn.runQueryLMD(strSql1);
             */
            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_mensajes>");

            strRes.append("<vta_mensajes_deta "
               + " MSJG_ID_PD = \"" + strIdPedido + "\"  "
               + " MSJG_ID_USUARIO = \"" + varSesiones.getIntNoUser() + "\"  "
               + " MSJG_USUARIO = \"" + strNomUsuario + "\"  "
               + " MSJG_EMP_ID = \"" + varSesiones.getIntIdEmpresa() + "\"  "
               + " MSJG_SC_ID = \"" + varSesiones.getIntSucursalDefault() + "\"  "
               + " MSJG_AREA = \"" + strArea + "\"  "
               + " MSJG_NOTA = \"" + strNota + "\"  "
               + " MSJG_FECHA = \"" + fecha.getFechaActual() + "\"  "
               + " MSJG_HORA = \"" + fecha.getHoraActual() + "\"  "
               + " MSJG_AREA_NOMBRE = \"" + strNomArea + "\"  "
               + " />");

            strRes.append("</vta_mensajes>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("14")) {

            String IdPedido = request.getParameter("IdPedido");
            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_mensajes>");
            String strSql = "select *,(select vta_areas.AR_DESCRIPCION from vta_areas where vta_areas.AR_ID = vta_pedidos_mensajes.MSJ_AREA) as nomArea from vta_pedidos_mensajes where MSJ_ID_PD = " + IdPedido + " order by MSJ_ID,MSJ_AREA;";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes.append("<vta_mensajes_deta "
                  + " MSJ_ID = \"" + rs.getString("MSJ_ID") + "\"  "
                  + " MSJ_ID_PD = \"" + rs.getString("MSJ_ID_PD") + "\"  "
                  + " MSJ_ID_USUARIO = \"" + rs.getString("MSJ_ID_USUARIO") + "\"  "
                  + " MSJ_USUARIO = \"" + rs.getString("MSJ_USUARIO") + "\"  "
                  + " MSJ_EMP_ID = \"" + rs.getString("MSJ_EMP_ID") + "\"  "
                  + " MSJ_SC_ID = \"" + rs.getString("MSJ_SC_ID") + "\"  "
                  + " MSJ_AREA = \"" + rs.getString("nomArea") + "\"  "
                  + " MSJ_NOTA = \"" + rs.getString("MSJ_NOTA") + "\"  "
                  + " MSJ_FECHA = \"" + fecha.FormateaDDMMAAAA(rs.getString("MSJ_FECHA"), "/") + "\"  "
                  + " MSJ_HORA = \"" + rs.getString("MSJ_HORA") + "\"  "
                  + " />");

            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_mensajes>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }
         if (strid.equals("15")) {

            String IdCte = request.getParameter("IdCte");
            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<cliente>");
            String strSql = "select *"
               + "from vta_cliente where CT_ID = " + IdCte + " ;";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strRes.append("<cliente_deta"
                  + " CT_ID = \"" + rs.getString("CT_ID") + "\"  "
                  + " CT_RAZONSOCIAL = \"" + rs.getString("CT_RAZONSOCIAL") + "\"  "
                  + " CT_FIADOR = \"" + rs.getString("CT_FIADOR") + "\"  "
                  + " CT_RFC = \"" + rs.getString("CT_RFC") + "\"  "
                  + " CT_RAZONCOMERCIAL = \"" + rs.getString("CT_RAZONCOMERCIAL") + "\"  "
                  + " CT_CALLE = \"" + rs.getString("CT_CALLE") + "\"  "
                  + " CT_ES_PROSPECTO = \"" + rs.getString("CT_ES_PROSPECTO") + "\"  "
                  + " SC_ID = \"" + rs.getString("SC_ID") + "\"  "
                  + " CT_F1IFE = \"" + rs.getString("CT_F1IFE") + "\"  "
                  + " CT_FIADOR2 = \"" + rs.getString("CT_FIADOR2") + "\"  "
                  + " CT_FECHA_CONTACTO = \"" + rs.getString("CT_FECHA_CONTACTO") + "\"  "
                  + " CT_NUMERO = \"" + rs.getString("CT_NUMERO") + "\"  "
                  + " CT_F2DIRECCION = \"" + rs.getString("CT_F2DIRECCION") + "\"  "
                  + " CT_NUMINT = \"" + rs.getString("CT_NUMINT") + "\"  "
                  + " CT_F2IFE = \"" + rs.getString("CT_F2IFE") + "\"  "
                  + " CAT_MED_CONT_ID = \"" + rs.getString("CAT_MED_CONT_ID") + "\"  "
                  + " CT_FIADOR3 = \"" + rs.getString("CT_FIADOR3") + "\"  "
                  + " CT_COLONIA = \"" + rs.getString("CT_COLONIA") + "\"  "
                  + " CT_F3DIRECCION = \"" + rs.getString("CT_F3DIRECCION") + "\"  "
                  + " CT_UBICACION_GOOGLE = \"" + rs.getString("CT_UBICACION_GOOGLE") + "\"  "
                  + " CT_F3IFE = \"" + rs.getString("CT_F3IFE") + "\"  "
                  + " CT_FACEBOOK = \"" + rs.getString("CT_FACEBOOK") + "\"  "
                  + " CT_MUNICIPIO = \"" + rs.getString("CT_MUNICIPIO") + "\"  "
                  + " CT_PAGINA_WEB = \"" + rs.getString("CT_PAGINA_WEB") + "\"  "
                  + " CT_LOCALIDAD = \"" + rs.getString("CT_LOCALIDAD") + "\"  "
                  + " PA_ID = \"" + rs.getString("PA_ID") + "\"  "
                  + " CT_POR_CIERRE = \"" + rs.getString("CT_POR_CIERRE") + "\"  "
                  + " CT_ESTADO = \"" + rs.getString("CT_ESTADO") + "\"  "
                  + " CT_CP = \"" + rs.getString("CT_CP") + "\"  "
                  + " EP_ID = \"" + rs.getString("EP_ID") + "\"  "
                  + " CT_TELEFONO1 = \"" + rs.getString("CT_TELEFONO1") + "\"  "
                  + " CAM_ID = \"" + rs.getString("CAM_ID") + "\"  "
                  + " CT_TELEFONO2 = \"" + rs.getString("CT_TELEFONO2") + "\"  "
                  + " CT_CONTACTO1 = \"" + rs.getString("CT_CONTACTO1") + "\"  "
                  + " CT_CONTACTO2 = \"" + rs.getString("CT_CONTACTO2") + "\"  "
                  + " CT_EMAIL1 = \"" + rs.getString("CT_EMAIL1") + "\"  "
                  + " CT_EMAIL2 = \"" + rs.getString("CT_EMAIL2") + "\"  "
                  + " CT_LPRECIOS = \"" + rs.getString("CT_LPRECIOS") + "\"  "
                  + " CT_DESCUENTO = \"" + rs.getString("CT_DESCUENTO") + "\"  "
                  + " CT_CTABANCO1 = \"" + rs.getString("CT_CTABANCO1") + "\"  "
                  + " CT_CTABANCO2 = \"" + rs.getString("CT_CTABANCO2") + "\"  "
                  + " CT_DIASCREDITO = \"" + rs.getString("CT_DIASCREDITO") + "\"  "
                  + " CT_MONTOCRED = \"" + rs.getString("CT_MONTOCRED") + "\"  "
                  + " CT_CTATARJETA = \"" + rs.getString("CT_CTATARJETA") + "\"  "
                  + " CT_CONTAVTA = \"" + rs.getString("CT_CONTAVTA") + "\"  "
                  + " CT_CONTACTE = \"" + rs.getString("CT_CONTACTE") + "\"  "
                  + " CT_CONTAPAG = \"" + rs.getString("CT_CONTAPAG") + "\"  "
                  + " CT_CTA_ANTICIPO = \"" + rs.getString("CT_CTA_ANTICIPO") + "\"  "
                  + " CT_CONTACTE_COMPL = \"" + rs.getString("CT_CONTACTE_COMPL") + "\"  "
                  + " CT_CTACTE_COMPL_ANTI = \"" + rs.getString("CT_CTACTE_COMPL_ANTI") + "\"  "
                  + " CT_CONTA_RET_ISR = \"" + rs.getString("CT_CONTA_RET_ISR") + "\"  "
                  + " CT_CONTA_RET_IVA = \"" + rs.getString("CT_CONTA_RET_IVA") + "\"  "
                  + " MON_ID = \"" + rs.getString("MON_ID") + "\"  "
                  + " TI_ID = \"" + rs.getString("TI_ID") + "\"  "
                  + " TTC_ID = \"" + rs.getString("TTC_ID") + "\"  "
                  + " CT_PASSWORD = \"" + rs.getString("CT_PASSWORD") + "\"  "
                  + " CT_VENDEDOR = \"" + rs.getString("CT_VENDEDOR") + "\"  "
                  + " CT_IDIOMA = \"" + rs.getString("CT_IDIOMA") + "\"  "
                  + " CT_FECHAREG = \"" + rs.getString("CT_FECHAREG") + "\"  "
                  + " CT_NOTAS = \"" + rs.getString("CT_NOTAS") + "\"  "
                  + " CT_TIPOPERS = \"" + rs.getString("CT_TIPOPERS") + "\"  "
                  + " CT_ACTIVO = \"" + rs.getString("CT_ACTIVO") + "\"  "
                  + " CT_METODODEPAGO = \"" + rs.getString("CT_METODODEPAGO") + "\"  "
                  + " CT_FORMADEPAGO = \"" + rs.getString("CT_FORMADEPAGO") + "\"  "
                  + " CT_TIPOFAC = \"" + rs.getString("CT_TIPOFAC") + "\"  "
                  + " CT_RLEGAL = \"" + rs.getString("CT_RLEGAL") + "\"  "
                  + " CT_CATEGORIA1 = \"" + rs.getString("CT_CATEGORIA1") + "\"  "
                  + " CT_CATEGORIA2 = \"" + rs.getString("CT_CATEGORIA2") + "\"  "
                  + " CT_CATEGORIA3 = \"" + rs.getString("CT_CATEGORIA3") + "\"  "
                  + " CT_CATEGORIA4 = \"" + rs.getString("CT_CATEGORIA4") + "\"  "
                  + " CT_CATEGORIA5 = \"" + rs.getString("CT_CATEGORIA5") + "\"  "
                  + " CT_CATEGORIA6 = \"" + rs.getString("CT_CATEGORIA6") + "\"  "
                  + " CT_BANCO1 = \"" + rs.getString("CT_BANCO1") + "\"  "
                  + " CT_CATEGORIA7 = \"" + rs.getString("CT_CATEGORIA7") + "\"  "
                  + " CT_RBANCARIA1 = \"" + rs.getString("CT_RBANCARIA1") + "\"  "
                  + " CT_CATEGORIA8 = \"" + rs.getString("CT_CATEGORIA8") + "\"  "
                  + " CT_BANCO2 = \"" + rs.getString("CT_BANCO2") + "\"  "
                  + " CT_CATEGORIA9 = \"" + rs.getString("CT_CATEGORIA9") + "\"  "
                  + " CT_RBANCARIA2 = \"" + rs.getString("CT_RBANCARIA2") + "\"  "
                  + " CT_CATEGORIA10 = \"" + rs.getString("CT_CATEGORIA10") + "\"  "
                  + " CT_BANCO3 = \"" + rs.getString("CT_BANCO3") + "\"  "
                  + " CT_RBANCARIA3 = \"" + rs.getString("CT_RBANCARIA3") + "\"  "
                  + " CT_NUMPREDIAL = \"" + rs.getString("CT_NUMPREDIAL") + "\"  "
                  + " CT_ENVIO_FACTURA = \"" + rs.getString("CT_ENVIO_FACTURA") + "\"  "
                  + " EMP_ID = \"" + rs.getString("EMP_ID") + "\"  "
                  + " />");

            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</cliente>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }
         if (strid.equals("16")) {
            String Indice = request.getParameter("indice");

            StringBuilder strRes = new StringBuilder();
            if (Indice.equals("1")) {
               ResultSet rs;
               String strSql1 = "update   formularios  set frm_multikey = 1 where frm_abrv = 'GRID_PRODMAK' ;";
               oConn.runQueryLMD(strSql1);

               strRes.append("<vta_mensajes>");
               strRes.append("<vta_mensajes_deta "
                  + " respuesta = \"" + "OK" + "\"  "
                  + " />");

               strRes.append("</vta_mensajes>");
            }
            if (Indice.equals("2")) {
               ResultSet rs;
               String strSql1 = "update   formularios  set frm_multikey = 0 where frm_abrv = 'GRID_PRODMAK' ;";
               oConn.runQueryLMD(strSql1);
               strRes.append("<vta_mensajes>");
               strRes.append("<vta_mensajes_deta "
                  + " respuesta = \"" + "OK" + "\"  "
                  + " />");

               strRes.append("</vta_mensajes>");
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado                

         }

         if (strid.equals("17")) {
            UtilXml utilXML = new UtilXml();
            String strPR_CODIGO = request.getParameter("PR_CODIGO");
            String strSC_ID = request.getParameter("SC_ID");
            String strSC_ID2 = request.getParameter("SC_ID2");
            String strEMP_ID = request.getParameter("EMP_ID");
            if (strSC_ID2 == null) {
               strSC_ID2 = "";
            }

            String intCodigo = request.getParameter("intCodigo");
            String intDescripcion = request.getParameter("intDescripcion");
            String intTalla = request.getParameter("intTalla");
            String intColor = request.getParameter("intColor");
            String intMarca = request.getParameter("intMarca");
            String intGrupo = request.getParameter("intGrupo");

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

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_producto_mas>");

            //Buscamos el producto en la bd
            String strSql = "SELECT PR_ID,PR_CODIGO,PR_CODBARRAS,PR_DESCRIPCION,"
               + "PR_DESCRIPCIONCORTA,PR_DESCRIPCIONCOMPRA,"
               + "PR_REQEXIST,PR_EXENTO1,PR_EXENTO2,PR_EXENTO3,"
               + "PR_COSTOPROM,PR_COSTOCOMPRA,PR_COSTOREPOSICION,PR_UNIDADMEDIDA,MON_ID,PR_EXISTENCIA "
               + ",PR_CATEGORIA1,PR_CATEGORIA2,PR_CATEGORIA3,PR_CATEGORIA4,PR_CATEGORIA5,"
               + "PR_CATEGORIA6,PR_CATEGORIA7,PR_CATEGORIA8,PR_CATEGORIA9,PR_CATEGORIA10"
               + ",PR_USO_NOSERIE,GT_ID,PR_TASA_IVA,PR_INVENTARIO "
               + " FROM vta_producto "
               + " where "
               + " SC_ID = '" + strSC_ID + "'"
               + " AND EMP_ID = " + strEMP_ID;

            if (!intCodigo.equals("") && !intCodigo.equals("0")) {
               strSql += " AND PR_CODIGO like '%" + intCodigo + "%' ";
            }
            if (!intDescripcion.equals("") && !intDescripcion.equals("0")) {
               strSql += " AND PR_DESCRIPCION like '%" + intDescripcion + "%' ";
            }
            if (!intTalla.equals("") && !intTalla.equals("0")) {
               strSql += " AND PR_CATEGORIA4 = " + intTalla + " ";
            }
            if (!intColor.equals("") && !intColor.equals("0")) {
               strSql += " AND PR_CATEGORIA3 = " + intColor + " ";
            }
            if (!intMarca.equals("") && !intMarca.equals("0")) {
               strSql += " AND PR_CATEGORIA1 = " + intMarca + " ";
            }
            if (!intGrupo.equals("") && !intGrupo.equals("0")) {
               strSql += " AND PR_CATEGORIA9 = " + intGrupo + " ";
            }

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

               //Validamos el almacen secundario en caso que proceda
               if (!strSC_ID2.equals("")) {
                  String strSql1 = "SELECT PR_ID "
                     + " FROM vta_producto "
                     + " where (PR_CODIGO = '" + strPR_CODIGO + "' "
                     + " OR PR_CODBARRAS = '" + strPR_CODIGO + "') "
                     + " AND SC_ID = '" + strSC_ID2 + "'";
                  ResultSet rs1 = oConn.runQuery(strSql1, true);
                  while (rs1.next()) {
                     intPR_ID2 = rs1.getInt("PR_ID");
                  }
                  rs1.getStatement().close();
                  rs1.close();
               }
               //Si tiene unidad de medida sacamos el concepto
               if (intPR_UNIDADMEDIDA != 0) {
                  String strSql2 = "SELECT ME_DESCRIPCION "
                     + " FROM vta_unidadmedida "
                     + " where ME_ID = '" + intPR_UNIDADMEDIDA + "'";
                  ResultSet rs2 = oConn.runQuery(strSql2, true);
                  while (rs2.next()) {
                     strUnidadMedida = rs2.getString("ME_DESCRIPCION");
                  }
                  rs2.getStatement().close();
                  rs2.close();
               }
               //Si tiene categoría 1 buscamos
               String strCategoria1 = "";
               if (intPR_CATEGORIA1 != 0) {
                  String strSql3 = "SELECT PC_DESCRIPCION "
                     + " FROM vta_prodcat1 "
                     + " where PC_ID = '" + intPR_CATEGORIA1 + "'";
                  ResultSet rs3 = oConn.runQuery(strSql3, true);
                  while (rs3.next()) {
                     strCategoria1 = rs3.getString("PC_DESCRIPCION");
                  }
                  rs3.getStatement().close();
                  rs3.close();
               }
               //Si tiene asignada una tasa de iva diferente buscamos el factor
               if (intPR_TASA_IVA != 0) {
                  String strSql4 = "SELECT TI_TASA "
                     + " FROM vta_tasaiva "
                     + " where TI_ID = '" + intPR_TASA_IVA + "'";
                  ResultSet rs4 = oConn.runQuery(strSql4, true);
                  while (rs4.next()) {
                     dblTasaIVAAplica = rs4.getDouble("TI_TASA");
                  }
                  rs4.getStatement().close();
                  rs4.close();
               }

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

            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_producto_mas>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }
         if (strid.equals("18")) {
            UtilXml utilXML = new UtilXml();

            String strPR_CODIGO = request.getParameter("intPrId");

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_producto_suc>");

            //Buscamos el producto en la bd
            String strSql = "SELECT vta_sucursales_master.SM_CODIGO,vta_sucursales_master.SM_ID,vta_sucursales_master.SM_NOMBRE,vta_producto.PR_DESCRIPCION,"
               + "SUM(vta_producto.PR_EXISTENCIA) as existencia  "
               + ",getTApartadosCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID) AS apartados "
               + ",getTExistenciaCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID)   - getTApartadosCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID) AS DISPONIBILIDAD"
               + ",vta_producto.PR_CODIGO,vta_producto.PR_UNIDADMEDIDA,vta_sucursal.SC_NOMBRE,vta_sucursal.SC_ID "
               + " FROM vta_sucursales_master JOIN vta_sucursal_master_as ON vta_sucursales_master.SM_ID = vta_sucursal_master_as.SM_ID  JOIN vta_sucursal  ON vta_sucursal_master_as.SC_ID = vta_sucursal.SC_ID  JOIN vta_producto ON vta_producto.SC_ID = vta_sucursal.SC_ID  "
               + "  where PR_CODIGO = '" + strPR_CODIGO + "' AND vta_sucursales_master.EMP_ID = " + varSesiones.getIntIdEmpresa() + " and vta_producto.SC_ID <> " + varSesiones.getIntSucursalDefault() + " group by vta_sucursales_master.SM_CODIGO,vta_sucursales_master.SM_ID,vta_sucursales_master.SM_NOMBRE,vta_producto.PR_DESCRIPCION ,vta_producto.PR_CODIGO,vta_producto.PR_UNIDADMEDIDA"
               + ",vta_sucursal.SC_NOMBRE,vta_sucursal.SC_ID ;  ";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes.append("<vta_productos "
                  + " sucursal = \"" + rs.getString("SM_NOMBRE") + "\"  "
                  + " sucursal_ID = \"" + rs.getString("SM_ID") + "\"  "
                  + " existencia = \"" + rs.getString("existencia") + "\"  "
                  + " asignado = \"" + rs.getString("apartados") + "\"  "
                  + " disponible = \"" + rs.getString("DISPONIBILIDAD") + "\"  "
                  + " observaciones = \"" + rs.getString("PR_DESCRIPCION") + "\"  "
                  + " PR_CODIGO = \"" + rs.getString("PR_CODIGO") + "\"  "
                  + " PR_UNIDADMEDIDA = \"" + rs.getString("PR_UNIDADMEDIDA") + "\"  "
                  + " SC_NOMBRE = \"" + rs.getString("SC_NOMBRE") + "\"  "
                  + " SC_NOMBRE_ID = \"" + rs.getString("SC_ID") + "\"  "
                  + " />");
            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_producto_suc>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("19")) {
            UtilXml utilXML = new UtilXml();

            String strPR_CODIGO = request.getParameter("intPrId");

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_producto_suc>");

            //Buscamos el producto en la bd
            String strSql = "select PR_CODIGO from vta_producto where PR_CODIGO = '" + strPR_CODIGO + "'  ;";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes.append("<vta_productos "
                  + " PR_CODIGO = \"" + rs.getString("PR_CODIGO") + "\"  "
                  + " />");
            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_producto_suc>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("20")) {
            UtilXml utilXML = new UtilXml();

            String strPR_CODIGO = request.getParameter("intPrId");

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_producto_suc>");

            //Buscamos el producto en la bd
            String strSql = "SELECT vta_producto.PR_CODIGO,vta_sucursal.SC_NOMBRE,getTExistenciaCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID)  AS EXISTENCIA"
               + " ,getTApartadosCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID) AS APARTADOS   "
               + " ,getTExistenciaCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID)   - getTApartadosCodigo(vta_producto.PR_CODIGO,vta_sucursal.SC_ID) AS DISPONIBILIDAD , vta_producto.PR_DESCRIPCION"
               + " FROM vta_sucursales_master JOIN vta_sucursal_master_as ON vta_sucursales_master.SM_ID = vta_sucursal_master_as.SM_ID     "
               + " JOIN vta_sucursal  ON vta_sucursal_master_as.SC_ID = vta_sucursal.SC_ID  JOIN vta_producto ON vta_producto.SC_ID = vta_sucursal.SC_ID  "
               + " where vta_producto.PR_CODIGO = '" + strPR_CODIGO + "' AND vta_sucursal.EMP_ID = " + varSesiones.getIntIdEmpresa() + " "
               + " group by vta_producto.PR_CODIGO,vta_sucursal.SC_NOMBRE,vta_producto.PR_DESCRIPCION,vta_sucursal.SC_ID ; ";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes.append("<vta_productos "
                  + " sucursal = \"" + rs.getString("SC_NOMBRE") + "\"  "
                  + " existencia = \"" + rs.getString("EXISTENCIA") + "\"  "
                  + " asignado = \"" + rs.getString("APARTADOS") + "\"  "
                  + " disponible = \"" + rs.getString("DISPONIBILIDAD") + "\"  "
                  + " observaciones = \"" + rs.getString("PR_DESCRIPCION") + "\"  "
                  + " PR_CODIGO = \"" + rs.getString("PR_CODIGO") + "\"  "
                  + " />");
            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_producto_suc>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("21")) {

            String strBackOrder = request.getParameter("strBackOrder");
            StringTokenizer st = new StringTokenizer(strBackOrder, "|");
            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<backorder>");
            while (st.hasMoreTokens()) {
               String strCadGeneral = st.nextToken();
               strRes.append("<backorder_deta ");
               StringTokenizer st2 = new StringTokenizer(strCadGeneral, "|");
               while (st2.hasMoreTokens()) {

                  String strDato = st2.nextToken();
                  String[] lstDatos = strDato.split("-");
                  if (lstDatos.length >= 2) {
                     String strBodega = lstDatos[1];
                     String strCantidad = lstDatos[2];
                     String strSql = "select SC_NOMBRE from vta_sucursal where SC_ID =" + strBodega;
                     ResultSet rs = oConn.runQuery(strSql, true);
                     while (rs.next()) {
                        strRes.append(" sucursal = \"" + rs.getString("SC_NOMBRE") + "\"  ");
                         strRes.append(" cantidad = \"" + strCantidad + "\"  ");
                     }
                     rs.close();
                  }
               }
               strRes.append(" />");
            }

            strRes.append("</backorder>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("22")) {

            String strPR_ID = request.getParameter("PR_ID");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println("");//Pintamos el resultado
         }

         if (strid.equals("24")) {

            int intContador = Integer.parseInt(request.getParameter("contador"));
            for (int i = 0; i < intContador; i++) {
               String MSJ_ID_PD = request.getParameter("MSJ_ID_PD" + i);
               String MSJ_ID_USUARIO = request.getParameter("MSJ_ID_USUARIO" + i);
               String MSJ_USUARIO = request.getParameter("MSJ_USUARIO" + i);
               String MSJ_EMP_ID = request.getParameter("MSJ_EMP_ID" + i);
               String MSJ_SC_ID = request.getParameter("MSJ_SC_ID" + i);
               String MSJ_AREA = request.getParameter("MSJ_AREA" + i);
               String MSJ_NOTA = request.getParameter("MSJ_NOTA" + i);
               String MSJ_FECHA = request.getParameter("MSJ_FECHA" + i);
               String MSJ_HORA = request.getParameter("MSJ_HORA" + i);

               String strSql1 = "insert into vta_pedidos_mensajes (MSJ_ID_PD,MSJ_ID_USUARIO,MSJ_USUARIO,MSJ_EMP_ID,MSJ_SC_ID,MSJ_AREA,MSJ_NOTA,MSJ_FECHA,MSJ_HORA) "
                  + "values (" + MSJ_ID_PD + "," + MSJ_ID_USUARIO + ",'" + MSJ_USUARIO + "'," + MSJ_EMP_ID + "," + MSJ_SC_ID + "," + MSJ_AREA + ",'" + MSJ_NOTA + "','" + MSJ_FECHA + "','" + MSJ_HORA + "');";
               oConn.runQueryLMD(strSql1);
            }
            StringBuilder strRes = new StringBuilder();

            strRes.append("<vta_mensajes>");
            strRes.append("<vta_mensajes_deta "
               + " respuesta = \"" + "OK" + "\"  "
               + " />");

            strRes.append("</vta_mensajes>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }

         if (strid.equals("25")) {

            int intIdMovimiento = Integer.parseInt(request.getParameter("strIdMovimiento"));
            String strPD_ID = request.getParameter("strPD_ID");
            String strMovimiento = "";
            String strDescripcion = "";
            String strNomUsuario = "";

            String strValorAnterior = "";
            if (request.getParameter("strValorAnterior") != null) {
               strValorAnterior = request.getParameter("strValorAnterior");
            }

            String strValorNuevo = "";
            if (request.getParameter("strValorNuevo") != null) {
               strValorNuevo = request.getParameter("strValorNuevo");
            }
            String strIdProducto = "";
            if (request.getParameter("strIdProducto") != null) {
               strIdProducto = request.getParameter("strIdProducto");
            }

            if (intIdMovimiento == 1) {
               strMovimiento = "Nuevo Pedido";
               strDescripcion = "Nuevo Pedido";
            }
            if (intIdMovimiento == 2) {
               strMovimiento = "Cambio Cantidad";
               strDescripcion = "La cantidad Anterior es : " + strValorAnterior + " la cantidad actual es: " + strValorNuevo + " clave del producto: " + strIdProducto;
            }
            if (intIdMovimiento == 3) {
               strMovimiento = "Cambio Precio";
               strDescripcion = "El precio Anterior es: " + strValorAnterior + " el precio Actual es: " + strValorNuevo + " clave del producto: " + strIdProducto;
            }

            String strSql = "select nombre_usuario from usuarios where id_usuarios = " + varSesiones.getIntNoUser();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strNomUsuario = rs.getString("nombre_usuario");
            }
            rs.getStatement().close();
            rs.close();

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_historial>");

            strRes.append("<vta_historial_deta "
               + " PEHIS_IDUSUARIO = \"" + varSesiones.getIntNoUser() + "\"  "
               + " PEHIS_NOMBRE = \"" + strNomUsuario + "\"  "
               + " PEHIS_MOVIMIENTO = \"" + strMovimiento + "\"  "
               + " PEHIS_DESCRIPCION = \"" + strDescripcion + "\"  "
               + " SC_ID = \"" + varSesiones.getIntSucursalDefault() + "\"  "
               + " EMP_ID = \"" + varSesiones.getIntIdEmpresa() + "\"  "
               + " PD_ID = \"" + strPD_ID + "\"  "
               + " />");

            strRes.append("</vta_historial>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }

         if (strid.equals("26")) {
            UtilXml utilXML = new UtilXml();

            String strPR_CODIGO = request.getParameter("intPrId");

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_producto_suc>");

            //Buscamos el producto en la bd
            String strSql = "select  (select nombre_usuario from usuarios where usuarios.id_usuarios = p.PD_US_ALTA) as usuario,sum(d.PDD_CANTIDAD - d.PDD_CANTIDADSURTIDA)  AS asignados,p.PD_ID,(select SC_NOMBRE from vta_sucursal where vta_sucursal.SC_ID = p.SC_ID) as Bodega"
               + " from vta_pedidos p , vta_pedidosdeta d where p.PD_ID = d.PD_ID   "
               + " and p.PD_ANULADA = 0  "
               + "  AND d.PDD_CANTIDAD - d.PDD_CANTIDADSURTIDA >0    "
               + " and p.PD_STATUS not in(4,5,6)  "
               + " and d.PDD_CVE = '" + strPR_CODIGO + "' "
               + "group by p.PD_ID,d.PDD_CANTIDAD,d.PDD_CANTIDADSURTIDA,p.SC_ID; ";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes.append("<vta_productos "
                  + " documento = \"" + "PEDIDO" + "\"  "
                  + " movimiento = \"" + rs.getString("PD_ID") + "\"  "
                  + " bodega = \"" + rs.getString("Bodega") + "\"  "
                  + " cantidad = \"" + rs.getString("asignados") + "\"  "
                  + " usuario = \"" + rs.getString("usuario") + "\"  "
                  + " />");
            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_producto_suc>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }
         if (strid.equals("27")) {
            UtilXml utilXML = new UtilXml();

            String strPR_CODIGO = request.getParameter("intPrId");

            StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strRes.append("<vta_pedidos>");

            //Buscamos el producto en la bd
            String strSql = ";";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes.append("<vta_pedidos_deta "
                  + " sucursal = \"" + rs.getString("SM_NOMBRE") + "\"  "
                  + " existencia = \"" + rs.getString("EXISTENCIA") + "\"  "
                  + " asignado = \"" + rs.getString("APARTADOS") + "\"  "
                  + " disponible = \"" + rs.getString("DISPONIBILIDAD") + "\"  "
                  + " observaciones = \"" + rs.getString("PR_DESCRIPCION") + "\"  "
                  + " PR_CODIGO = \"" + rs.getString("PR_CODIGO") + "\"  "
                  + " PR_UNIDADMEDIDA = \"" + rs.getString("UNIDADMEDIDA") + "\"  "
                  + " imagen = \"" + rs.getString("PR_NOMIMG1") + "\"  "
                  + " codprec = \"" + rs.getString("PR_GPO_MODI_PREC") + "\"  "
                  + " />");
            }
            rs.getStatement().close();
            rs.close();
            strRes.append("</vta_pedidos>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes.toString());//Pintamos el resultado
         }
      }
      if (strid.equals("28")) {

         String strTexto = request.getParameter("strTexto");

         StringBuilder strRes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         strRes.append("<busqueda>");
         String strCodigo = "";
         String strDescripcion = "";
         String strGrupo = "";
         String strMarca = "";
         String strColor = "";
         String strTalla = "";

         String strPais = "";

         String strComposicion = "";

         int intcont = 0;

         if (strTexto.contains("#") == true) {
            strTexto = strTexto.replace("#", " ");

            StringTokenizer st = new StringTokenizer(strTexto);
            while (st.hasMoreTokens()) {
               if (intcont == 0) {
                  strCodigo = st.nextToken();
               }
               if (intcont == 1) {
                  strDescripcion = st.nextToken();
               }
               if (intcont == 2) {

                  strGrupo = st.nextToken();
               }
               if (intcont == 3) {

                  strMarca = st.nextToken();
               }
               if (intcont == 4) {
                  strColor = st.nextToken();
               }
               if (intcont == 5) {
                  strTalla = st.nextToken();
               }

               intcont++;
            }
         } else {
            strCodigo = strTexto;
         }

         strRes.append("<busqueda_deta ");
         strRes.append(" strCodigo = \"" + strCodigo + "\"  ");
         strRes.append(" strDescripcion = \"" + strDescripcion + "\"  ");

         strRes.append(" />");

         strRes.append("</busqueda>");
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strRes.toString());//Pintamos el resultado
      }

   } else {
   }
   oConn.close();

%>
