<%-- 
    Document   : ERP_com_recep
    Created on : 7/10/2013, 12:05:04 PM
    Author     : siwebmx5
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.Etiquetas"%>
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

      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Revisa Si la Orden de compra es correcta para imprimir etiquetas
         if (strid.equals("1")) {
            String strCOM_ID = request.getParameter("COM_ID");
            String strRES = "";
            Etiquetas etEtiqueta = new Etiquetas();
            if (etEtiqueta.ValidaODC(Integer.valueOf(strCOM_ID), oConn)) {
               strRES = "OK";
            } else {
               strRES = "ERROR";
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.print(strRES);//Pintamos el resultado
         }
         /*Regresamos los Tickets que se va a imprimir*/
         if (strid.equals("2")) {
            String strCOM_ID = request.getParameter("COM_ID");
            String strEtiqueta = request.getParameter("ET_ID");
            String strRES = "";
            Etiquetas etEtiqueta = new Etiquetas();
            strRES = etEtiqueta.doEtiquetaCompra(Integer.valueOf(strCOM_ID), Integer.valueOf(strEtiqueta), oConn);

            System.out.println("Etiqueta:" + strRES);

            out.clearBuffer();//Limpiamos buffer
            response.setContentType("text/plain");
            response.setHeader("content-disposition", "attachment; filename=" + "Etiquetas" + ".txt");
            response.setHeader("cache-control", "no-cache");
            //text/plain
            out.println(strRES);//Pintamos el resultado
         }

         /*Imprime una etiqueda con su Codigo */
         if (strid.equals("3")) {
            String strPR_CODIGO = request.getParameter("PR_CODIGO");
            String strEtiqueta = request.getParameter("ET_ID");
            String strCantidad = request.getParameter("Cantidad");
            String strRES = "";
            Etiquetas etEtiqueta = new Etiquetas();

            strRES = etEtiqueta.doEtiquetaProducto(strPR_CODIGO, Integer.valueOf(strCantidad), Integer.valueOf(strEtiqueta), oConn);

            System.out.println("Etiqueta:" + strRES);
            out.clearBuffer();//Limpiamos buffer
            response.setContentType("text/plain");
            response.setHeader("content-disposition", "attachment; filename=" + "Etiqueta" + ".txt");
            response.setHeader("cache-control", "no-cache");
            //text/plain
            out.println(strRES);//Pintamos el resultado
         }
         /*Imprime las etiqeutas de una Orden de Compra*/
         if (strid.equals("4")) {
            String strCOM_ID = request.getParameter("COM_ID");
            String strEtiqueta = request.getParameter("ET_ID");
            String strRES = "";
            Etiquetas etEtiqueta = new Etiquetas();

            strRES = etEtiqueta.doEtiquetaCompra(Integer.valueOf(strCOM_ID), Integer.valueOf(strEtiqueta), oConn);

            System.out.println("Etiqueta:" + strRES);
            out.clearBuffer();//Limpiamos buffer
            response.setContentType("text/plain");
            response.setHeader("content-disposition", "attachment; filename=" + "Etiqueta" + ".txt");
            response.setHeader("cache-control", "no-cache");
            //text/plain
            out.println(strRES);//Pintamos el resultado
         }
         /*Consulta los movimientos del producto*/
         if (strid.equals("5")) {

            int intIdOC = Integer.parseInt(request.getParameter("intIdOC"));

            String strSql = "SELECT MP_ID,MP_FECHA,PROV_ID,MP_FOLIO,OC_ID FROM VTA_MOVPROD WHERE OC_ID =" + intIdOC;

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<recep1>";

            String strMP_ID = "";
            String strMP_FECHA = "";
            String strPROV_ID = "";
            String strMP_FOLIO = "";
            String strOC_ID = "";

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strMP_ID = String.valueOf(rs.getInt("MP_ID"));
               strMP_FECHA = String.valueOf(rs.getInt("MP_FECHA"));
               strPROV_ID = String.valueOf(rs.getInt("PROV_ID"));
               strMP_FOLIO = String.valueOf(rs.getInt("MP_FOLIO"));
               strOC_ID = String.valueOf(rs.getInt("OC_ID"));

               strXML += "<recep "
                       + " MP_ID = \"" + strMP_ID + "\"  "
                       + " MP_FECHA = \"" + strMP_FECHA + "\"  "
                       + " PROV_ID = \"" + strPROV_ID + "\"  "
                       + " MP_FOLIO = \"" + strMP_FOLIO + "\"  "
                       + " OC_ID = \"" + strOC_ID + "\"  "
                       + " />";

            }
            strXML += "</recep1>";

            rs.close();
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado

         }

         if (strid.equals("6")) {
            //    String strPR_CODIGO = request.getParameter("PR_CODIGO");
            String strEtiqueta = request.getParameter("ET_ID");
            //    String strCantidad = request.getParameter("Cantidad");
            String strIdEmpresa = request.getParameter("EMP_ID");
            String strIdSucursal = request.getParameter("SC_ID");
            String strNumRecepcion = request.getParameter("MP_ID");

            String strRES = "";
            Etiquetas etEtiqueta = new Etiquetas();

            // strRES = etEtiqueta.doEtiquetaODC(strPR_CODIGO, Integer.valueOf(strCantidad), Integer.valueOf(strEtiqueta), oConn);
            strRES = etEtiqueta.doEtiquetaODC(Integer.valueOf(strEtiqueta), Integer.valueOf(strIdEmpresa), Integer.valueOf(strIdSucursal), Integer.valueOf(strNumRecepcion), oConn);

            System.out.println("Etiqueta:" + strRES);
            out.clearBuffer();//Limpiamos buffer
            response.setContentType("text/plain");
            response.setHeader("content-disposition", "attachment; filename=" + "Etiqueta" + ".txt");
            response.setHeader("cache-control", "no-cache");
            //text/plain
            out.println(strRES);//Pintamos el resultado
         }
         //Obtiene el ID del reporte que va a cnosultar
         if (strid.equals("7")) {
            int idReporte = 0;
            String strIdEtiqueta = request.getParameter("idEtiqueta");
            String strQuery = "select REP_ID from vta_etiquetas where ET_ID = " + strIdEtiqueta;
            ResultSet rs = oConn.runQuery(strQuery, true);
            while (rs.next()) {
               idReporte = rs.getInt("REP_ID");
            }
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            out.println(idReporte);
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         }
         //Obtiene el ID del reporte que va a cnosultar
         if (strid.equals("8")) {

            int intEMP_ID = Integer.valueOf(request.getParameter("intEMP_ID"));
            int intSC_ID = Integer.valueOf(request.getParameter("intSC_ID"));
            int intMP_ID = Integer.valueOf(request.getParameter("intMP_ID"));

            String strQuery = "Select DISTINCT vta_producto.PR_CATEGORIA7 "
                    + " From vta_movprod,vta_movproddeta, vta_producto , vta_empresas, vta_tmp_series "
                    + " Where vta_movprod.MP_ID = vta_movproddeta.MP_ID AND vta_movproddeta.PR_ID = vta_producto.PR_ID AND vta_producto.EMP_ID = vta_empresas.EMP_ID  "
                    + " AND vta_producto.EMP_ID = " + intEMP_ID + "  and vta_movprod.SC_ID = " + intSC_ID + " and vta_tmp_series.ID_SERIE <= 1 "
                    + " AND vta_movprod.MP_ID = " + intMP_ID + " ;";

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<etiquetas>";

            String strIdEtiqueta = "";
            String strET_ID = "";
            String strET_REP_ODC = "";

            ResultSet rs = oConn.runQuery(strQuery, true);
            while (rs.next()) {

               strIdEtiqueta += rs.getInt("PR_CATEGORIA7") + ",";
      }
            rs.close();

            String strIdEtiqueta1 = strIdEtiqueta.substring(0, strIdEtiqueta.length() - 1);

            String strQuery1 = "select ET_ID,ET_REP_ODC from vta_etiquetas where ET_CLASIFICACION_PROD in (" + strIdEtiqueta1 + ")";

            ResultSet rs1 = oConn.runQuery(strQuery1, true);
            while (rs1.next()) {

               strET_ID = rs1.getString("ET_ID");
               strET_REP_ODC = rs1.getString("ET_REP_ODC");
               strXML += "<etiquetas_deta "
                       + " ET_ID = \"" + strET_ID + "\"  "
                       + " ET_REP_ODC = \"" + strET_REP_ODC + "\"  "
                       + " />";

   }
            strXML += "</etiquetas>";
            rs1.close();

            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

      }
   }

%>