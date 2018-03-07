<%-- 
    Document   : ERP_Producto
    Este jsp realiza operaciones con los productos
    Created on : 05-ago-2012, 13:27:20
    Author     : aleph_79
--%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="ERP.Producto"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.io.File"%>

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
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Regresamos las clasificaciones numero 10
         if (strid.equals("10")) {
            String strPC9_ID = request.getParameter("idItem");
            if (strPC9_ID == null) {
               strPC9_ID = "0";
            }
            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strXML.append("<vta_clasific> ");

            //Consultamos la existencia y si requiera de existencia para su venta
            String strSql = "select * from vta_prodcat10 where PC9_ID = " + strPC9_ID;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML.append("<clas ");
               strXML.append(" id = \" " + rs.getInt("PC10_ID") + "\" "
                       + " desc=\"" + rs.getString("PC10_DESCRIPCION") + "\" ");
               strXML.append("/>");
            }
            //strPC9_ID
            rs.close();
            strXML.append("</vta_clasific>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   

         }
         //Calculamos el codigo de barras de EAN13
         if (strid.equals("11")) {
            String strPR_ID = request.getParameter("PR_ID");
            if (strPR_ID == null) {
               strPR_ID = "0";
            }
            Producto prod = new Producto();
            String strRes = prod.GeneraCodigoEAN13(strPR_ID, oConn);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado   
         }
         //Subimos las imagenes para el ecomm
         if (strid.equals("12")) {
            String strmsg = "";
            String strerror = "";
            //Inicializamos parametros
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            if (strSeparator.equals("\\")) {
               strSeparator = "/";
               strPathBase = strPathBase.replace("\\", "/");
            }
            String strPathBaseShort = "iCommerce" + strSeparator + "images" + strSeparator + "ecomm";
            //Si la peticion no fue nula proseguimos
            atrJSP.atrJSP(request, response, true, false);
            out.clearBuffer();
            //Instanciamos objeto para subir archivos....
            //Validamos si la peticion se genero con enctype
            if (ServletFileUpload.isMultipartContent(request)) {
               //Recibimos parametros de numero de poliza y tipo de archivo subido
               String intPR_ID = request.getParameter("PR_ID");
               //System.out.println("strOpt: " + strOpt);
               // Parse the HTTP request...
               ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
               List fileItemsList = servletFileUpload.parseRequest(request);
               Iterator it = fileItemsList.iterator();
               //Procesamos los archivos subidos
               while (it.hasNext()) {
                  FileItem fileItem = (FileItem) it.next();
                  if (fileItem.isFormField()) {
                  } else {
                     /* The file item contains an uploaded file */
                     /* Get the name attribute value of the <input type="file"> element. */
                     String fieldName = fileItem.getFieldName();

                     /* Get the size of the uploaded file in bytes. */
                     long fileSize = fileItem.getSize();

                     /* Get the name of the uploaded file at the client-side. Some browsers such as IE 6 include the whole path here (e.g. e:\files\myFile.txt), so you may need to extract the file name from the path. This information is provided by the client browser, which means you should be cautious since it may be a wrong value provided by a malicious user. */
                     String fileName = fileItem.getName();

                     /* Get the content type (MIME type) of the uploaded file. This information is provided by the client browser, which means you should be cautious since it may be a wrong value provided by a malicious user. */
                     String contentType = fileItem.getContentType();

                     //Validamos que suban solo archivos pdf
                     if (fileName.toLowerCase().endsWith(".png")) {
                        //Separamos el nombre del archivo
                        //C:Documents and SettingszeusEscritorio1168591.pdf
                        if (fileName.contains("\\") && request.getHeader("User-Agent").contains("MSIE")) {
                           fileName = fileName.substring(fileName.lastIndexOf("\\") + 1, fileName.length());
                        }
                        //Asignamos el nombre del archivo
                        String strPathUsado = strPathBase + "images" + strSeparator + "ptovta" + strSeparator + fileName;
                        if (fieldName.equals("EMP_UP_IMG2")) {
                           strPathUsado = strPathBase + "images" + strSeparator + fileName;
                        }
                        strPathBaseShort = strPathBaseShort + strSeparator + fileName;
                        if (fieldName.equals("EMP_UP_IMG2")) {
                           strPathUsado = strPathBase + "images" + strSeparator + "codBar" + intPR_ID + ".png";
                        }
                        //Guardamos el archivo
                        File saveTo = new File(strPathUsado);
                        fileItem.write(saveTo);
                        //Guardamos el path en la base de datos
                        String strUpdate = "UPDATE vta_empresas set ";
                        strUpdate += " EMP_PATHIMGFORM= '" + strPathUsado + "'";
                        strUpdate += " ,EMP_PATHIMG= '" + strPathBaseShort + "'";
                        strUpdate += " WHERE EMP_ID = " + intPR_ID;
                        if (fieldName.equals("EMP_UP_IMG2")) {
                           strUpdate = "UPDATE vta_empresas set ";
                           strUpdate += " EMP_PATHIMGCODBAR= '" + strPathUsado + "'";
                           strUpdate += " WHERE EMP_ID = " + intPR_ID;
                        }
                        oConn.runQueryLMD(strUpdate);
                        if (oConn.isBolEsError()) {
                           strerror = "Hubo un error al subir el archivo" + oConn.getStrMsgError();
                        } else {
                           strmsg = "Archivo guardado correctamente";
                        }
                     }
                  }
               }

            } else {
               strerror = "La petición no viene de  manera enctype";
            }
            out.clear();
            out.println("{");
            out.println("error: '" + strerror + "',\n");
            out.println("msg: '" + strmsg + "'\n");
            out.println("}\n");
            oConn.close();
            //Termina opcion de subir archivo
         }
         /**
          * Regresa el listado de productos para el cambio de precios masivo
          */
         if (strid.equals("14")) {
            //Inicializamos objetos
            UtilXml utilXML = new UtilXml();
            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strXML.append("<precios> ");
            //Recibimos parametros
            String strEMP_ID = request.getParameter("EMP_ID");
            String strSC_ID = request.getParameter("SC_ID");
            String strCodigo = request.getParameter("Codigo");
            String strGpoPrec = request.getParameter("GpoPrec");

            //Armamos el filtro
            StringBuilder strFiltro = new StringBuilder(" EMP_ID = " + strEMP_ID);
            strFiltro.append(" and SC_ID = " + strSC_ID);
            if (!strCodigo.isEmpty()) {
               strFiltro.append(" and p.PR_CODIGO like '%" + strCodigo + "%'");
            }
            if (!strGpoPrec.isEmpty()) {
               strFiltro.append(" and p.PR_GPO_MODI_PREC like '%" + strGpoPrec + "%'\n");
            }

            //Armamos la consulta
            StringBuilder strSqlB = new StringBuilder("");
            strSqlB.append("SELECT p.PR_ID,p.PR_CODIGO,p.PR_DESCRIPCION,p.PR_DESCRIPCIONCORTA,p.PR_GPO_MODI_PREC  as grupo_prec \n"
                    + " ,(select r.PP_PRECIO from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 1 ) as p_tienda\n"
                    + " ,(select r.PP_PRECIO_USD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 1 ) as p_tienda_usd\n"
                    + " ,(select r.PP_PRECIO from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 3 ) as p_publico\n"
                    + " ,(select r.PP_PRECIO_USD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 3 ) as p_publico_usd\n"
                    + " ,(select r.PP_PRECIO from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 4 ) as p_mayoreo\n"
                    + " ,(select r.PP_PRECIO_USD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 4 ) as p_mayoreo_usd\n"
                    + " ,(select r.PP_PRECIO from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 5 ) as p_distribucion\n"
                    + " ,(select r.PP_PRECIO_USD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 5 ) as p_distribucion_usd\n"
                    + " ,(select r.PP_PUTILIDAD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 1 ) as p_tienda_util\n"
                    + " ,(select r.PP_PUTILIDAD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 3 ) as p_publico_util\n"
                    + " ,(select r.PP_PUTILIDAD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 4 ) as p_mayoreo_util\n"
                    + " ,(select r.PP_PUTILIDAD from vta_prodprecios r where p.PR_ID = r.PR_ID and r.LP_ID = 5 ) as p_distribucion_util\n"
                    + " FROM vta_producto p where \n");
            strSqlB.append(strFiltro);
            ResultSet rs = oConn.runQuery(strSqlB.toString(), true);
            while (rs.next()) {
               strXML.append("<prec  ");
               strXML.append(" id=\"" + rs.getInt("PR_ID") + "\" ");
               strXML.append(" cod=\"" + utilXML.Sustituye(rs.getString("PR_CODIGO")) + "\" ");
               strXML.append(" desc=\"" + utilXML.Sustituye(rs.getString("PR_DESCRIPCIONCORTA")) + "\" ");
               if (rs.getString("grupo_prec") != null) {
                  strXML.append(" grupo_prec=\"" + utilXML.Sustituye(rs.getString("grupo_prec")) + "\" ");
               } else {
                  strXML.append(" grupo_prec=\"\" ");
               }
               strXML.append(" p_tienda=\"" + rs.getDouble("p_tienda") + "\" ");
               strXML.append(" p_tienda_uds=\"" + rs.getDouble("p_tienda_usd") + "\" ");
               strXML.append(" p_publico=\"" + rs.getDouble("p_publico") + "\" ");
               strXML.append(" p_publico_usd=\"" + rs.getDouble("p_publico_usd") + "\" ");
               strXML.append(" p_mayoreo=\"" + rs.getDouble("p_mayoreo") + "\" ");
               strXML.append(" p_mayoreo_usd=\"" + rs.getDouble("p_mayoreo_usd") + "\" ");
               strXML.append(" p_distribucion=\"" + rs.getDouble("p_distribucion") + "\" ");
               strXML.append(" p_distribucion_usd=\"" + rs.getDouble("p_distribucion_usd") + "\" ");
               strXML.append(" p_tienda_util=\"" + rs.getDouble("p_tienda_util") + "\" ");
               strXML.append(" p_publico_util=\"" + rs.getDouble("p_publico_util") + "\" ");
               strXML.append(" p_mayoreo_util=\"" + rs.getDouble("p_mayoreo_util") + "\" ");
               strXML.append(" p_distribucion_util=\"" + rs.getDouble("p_distribucion_util") + "\" ");
               strXML.append(" />");
            }
            rs.close();

            strXML.append("</precios> ");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         /**
          * Regresa los datos del producto para el cambio de precios
          */
         if (strid.equals("15")) {
            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strXML.append("<pcambio> ");

            String strPr_id = request.getParameter("PR_ID");
            if (strPr_id == null) {
               strPr_id = "0";
            }
            String strSql = "select "
                    + " (select m.MON_DESCRIPCION from vta_monedas m where m.MON_ID = PR_MONEDA_VTA ) as NOM_MONEDA,"
                    + " PR_MONEDA_VTA,PR_COSTOREPOSICION,PR_FLETE,"
                    + " PR_VALORES,PR_DTA,PR_MADUANAL,PR_DPROVEEDOR,"
                    + "PR_TCAMBIO_PROV,PR_TCAMBIO_TDA from vta_producto where pr_id = " + strPr_id;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML.append("<pc  ");
               strXML.append(" NOM_MONEDA=\"" + rs.getString("NOM_MONEDA") + "\" ");
               strXML.append(" PR_MONEDA_VTA=\"" + rs.getInt("PR_MONEDA_VTA") + "\" ");
               strXML.append(" PR_COSTOREPOSICION=\"" + rs.getDouble("PR_COSTOREPOSICION") + "\" ");
               strXML.append(" PR_FLETE=\"" + rs.getDouble("PR_FLETE") + "\" ");
               strXML.append(" PR_VALORES=\"" + rs.getDouble("PR_VALORES") + "\" ");
               strXML.append(" PR_DTA=\"" + rs.getDouble("PR_DTA") + "\" ");
               strXML.append(" PR_MADUANAL=\"" + rs.getDouble("PR_MADUANAL") + "\" ");
               strXML.append(" PR_DPROVEEDOR=\"" + rs.getDouble("PR_DPROVEEDOR") + "\" ");
               strXML.append(" PR_TCAMBIO_PROV=\"" + rs.getDouble("PR_TCAMBIO_PROV") + "\" ");
               strXML.append(" PR_TCAMBIO_TDA=\"" + rs.getDouble("PR_TCAMBIO_TDA") + "\" ");
               strXML.append(" />");
            }
            rs.close();
            strXML.append("</pcambio> ");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Guarda la información de las listas de precios
         if (strid.equals("16")) {
            int intContador = 0;
            if (request.getParameter("contador") != null) {
               try {
                  intContador = Integer.valueOf(request.getParameter("contador"));
               } catch (NumberFormatException ex) {
                  System.out.println(" " + ex.getMessage());
               }
            }
            String strRes = "OK";
            //Solo si fue mayor a cero el contador
            if (intContador > 0) {
               //Recorremos item por item
               for (int i = 1; i <= intContador; i++) {
                  String strPrId = request.getParameter("PR_ID" + i);
                  double dblPrecio1 = Double.valueOf(request.getParameter("P1" + i));
                  double dblPrecioUsd1 = Double.valueOf(request.getParameter("PUSD1" + i));
                  double dblPrecio2 = Double.valueOf(request.getParameter("P2" + i));
                  double dblPrecioUsd2 = Double.valueOf(request.getParameter("PUSD2" + i));
                  double dblPrecio3 = Double.valueOf(request.getParameter("P3" + i));
                  double dblPrecioUsd3 = Double.valueOf(request.getParameter("PUSD3" + i));
                  double dblPrecio4 = Double.valueOf(request.getParameter("P4" + i));
                  double dblPrecioUsd4 = Double.valueOf(request.getParameter("PUSD4" + i));
                  double dblCostoRepo = Double.valueOf(request.getParameter("PCOSTO_REPO" + i));

                  double dblFlete = Double.valueOf(request.getParameter("PFLETE" + i));
                  double dblAddValores = Double.valueOf(request.getParameter("PVALORES" + i));
                  double dblDTA = Double.valueOf(request.getParameter("PDTA" + i));
                  double dblMAduanal = Double.valueOf(request.getParameter("PMADUANAL" + i));
                  double dblDescProveedor = Double.valueOf(request.getParameter("PDPROVEEDOR" + i));
                  double dblTCambioTda = Double.valueOf(request.getParameter("DTCAMBIO_TDA" + i));
                  double dblTCambioProv = Double.valueOf(request.getParameter("TCAMBIO_PROV" + i));
                  //Actualizamos los precios
                  //Lista de precios 1
                  String strUpdate = "Update vta_prodprecios set "
                          + " PP_PRECIO = " + dblPrecio1
                          + " ,PP_PRECIO_USD = " + dblPrecioUsd1
                          + " where PR_ID = " + strPrId + " and LP_ID = 1";
                  oConn.runQueryLMD(strUpdate);
                  //Lista de precios 2
                  strUpdate = "Update vta_prodprecios set "
                          + " PP_PRECIO = " + dblPrecio2
                          + " ,PP_PRECIO_USD = " + dblPrecioUsd2
                          + " where PR_ID = " + strPrId + " and LP_ID = 3";
                  oConn.runQueryLMD(strUpdate);
                  //Lista de precios 3
                  strUpdate = "Update vta_prodprecios set "
                          + " PP_PRECIO = " + dblPrecio3
                          + " ,PP_PRECIO_USD = " + dblPrecioUsd3
                          + " where PR_ID = " + strPrId + " and LP_ID = 4";
                  oConn.runQueryLMD(strUpdate);
                  //Lista de precios 4
                  strUpdate = "Update vta_prodprecios set "
                          + " PP_PRECIO = " + dblPrecio4
                          + " ,PP_PRECIO_USD = " + dblPrecioUsd4
                          + " where PR_ID = " + strPrId + " and LP_ID = 5";
                  oConn.runQueryLMD(strUpdate);
                  //Lista de precios 4
                  strUpdate = "Update vta_producto set "
                          + " PR_COSTOREPOSICION = " + dblCostoRepo
                          + " ,PR_FLETE = " + dblFlete
                          + " ,PR_VALORES = " + dblAddValores
                          + " ,PR_DTA = " + dblDTA
                          + " ,PR_MADUANAL = " + dblMAduanal
                          + " ,PR_DPROVEEDOR = " + dblDescProveedor
                          + " ,PR_TCAMBIO_TDA = " + dblTCambioTda
                          + " ,PR_TCAMBIO_PROV = " + dblTCambioProv
                          + " where PR_ID = " + strPrId + " ";
                  oConn.runQueryLMD(strUpdate);
               }
            } else {
               strRes = "ERROR:Debe enviar por lo menos un producto";
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado   
         }
         //Copia de productos entre sucursales
         if (strid.equals("17")) {
            int intSucOrigen = 0;
            int intSucDestino = 0;
            //Recibimos parametros
            String strSucOrigen = request.getParameter("suc_origen");
            String strSucDestino = request.getParameter("suc_destino");
            if (strSucOrigen == null) {
               strSucOrigen = "0";
            }
            if (strSucDestino == null) {
               strSucOrigen = "0";
            }
            try {
               intSucOrigen = Integer.valueOf(strSucOrigen);
            } catch (NumberFormatException ex) {
            }
            try {
               intSucDestino = Integer.valueOf(strSucDestino);
            } catch (NumberFormatException ex) {
            }

            String strResTot = "";
            //Copiamos la info
            Producto producto = new Producto();
            strResTot = producto.CopiaProductosSucursal(oConn, intSucOrigen, intSucDestino);
            if (strResTot.equals("OK")) {
               strResTot = "Proceso terminado....";
            }

            //Enviamos respuesta
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResTot);//Pintamos el resultado   

         }
         //recupera la descripcion del centro de gastos 
         if (strid.equals("20")) {
            String intCGastosProd = request.getParameter("GT_ID");

            String strCgasto = "";

            String strSql = "select GT_DESCRIPCION  "
                    + "  from vta_cgastos"
                    + " where GT_ID=" + intCGastosProd;

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strCgasto = rs.getString("GT_DESCRIPCION");
            }
            rs.close();

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strCgasto);//Pintamos el resultado   
         }
         //Recupera los Descuentos 
         if (strid.equals("21")) {

            String intIdPR = request.getParameter("intIdPR");

            double dblPorcentajeMax = 0.0;
            String strSql = "Select PR_PORCENTAJE_MAX  "
                    + "  from vta_producto"
                    + " where PR_ID =" + intIdPR;

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               dblPorcentajeMax = rs.getDouble("PR_PORCENTAJE_MAX");
            }
            rs.close();

            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strRes += "<vta_porcdesc>";
            String strSql1 = "select * from vta_porcdesc order by PCD_PORC  ";

            double dblPorcentaje = 0.0;
            ResultSet rs1 = oConn.runQuery(strSql1, true);
            while (rs1.next()) {
               dblPorcentaje = rs1.getDouble("PCD_PORC");

               if (dblPorcentajeMax >= dblPorcentaje) {

                  strRes += "<vta_porcdescs";
                  strRes += " PCD_PORC= \"" + rs1.getDouble("PCD_PORC") + "\"  ";
                  strRes += "/>";
               }
            }
            strRes += "</vta_porcdesc>";
            rs.close();

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado   
         }

         if (strid.equals("22")) {

            String intIdPR = request.getParameter("intIdPR");
            String intIdSc = request.getParameter("intIdSc");

            String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strRes += "<Pr_Desc>";

            String strSql = "Select PR_DESCRIPCION  "
                    + "  from vta_producto"
                    + " where PR_CODIGO ='" + intIdPR + "' and SC_ID = " + intIdSc;

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               strRes += "<Pr_Desc_deta";
               strRes += " intIdPR= \"" + rs.getString("PR_DESCRIPCION") + "\"  ";
               strRes += "/>";
            }

            strRes += "</Pr_Desc>";
            rs.close();

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado   
         }

         //Termina validacion de acciones
      }

      if (strid.equals("23")) {

         String intIdPR = request.getParameter("intIdPR");
         String intIdSc = request.getParameter("intIdSc");

         String strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strRes += "<Pr_Cod>";

         String strSql = "Select PR_CODIGO  "
                 + "  from vta_producto"
                 + " where PR_DESCRIPCION ='" + intIdPR + "' and SC_ID = " + intIdSc;

         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {

            strRes += "<Pr_Cod_deta";
            strRes += " intIdPR= \"" + rs.getString("PR_CODIGO") + "\"  ";
            strRes += "/>";
         }

         strRes += "</Pr_Cod>";
         rs.close();

         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strRes);//Pintamos el resultado   
      }

         //Termina validacion de acciones
   } else {
   }

   oConn.close();
%>