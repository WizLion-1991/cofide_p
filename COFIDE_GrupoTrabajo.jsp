<%-- 
    Document   : COFIDE_GrupoTrabajo
    Created on : Feb 9, 2016, 12:07:47 PM
    Author     : CasaJosefa
--%>

<%@page import="com.mx.siweb.erp.especiales.cofide.Cofide_LeerXLSXMeta"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Random"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="Tablas.cofide_gtrabajo"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page import="com.sun.tools.xjc.api.S2JJAXBModel"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    String strerror = "";
    String strmsg = "";
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
    strXML.append("<vta>");
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        /*Definimos parametros de la aplicacion*/
        String strid = request.getParameter("ID");
        if (strid == null) {
            strid = "0";
        }
        String strSql = "";
        ResultSet rs;
        String strRes = "";
        Fechas fec = new Fechas();
        if (strid.equals("1")) {

            UtilXml util = new UtilXml();
            String strCG_ID = request.getParameter("CG_ID");

            strRes = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strRes += "<Grupo>";

            strSql = "select *,(select ME_DESCRIPCION from vta_meses where cofide_gtrabajo.CGD_MES = vta_meses.ME_ID) as strmes "
                    + "from cofide_gtrabajo where CG_ID = " + strCG_ID + ";";

            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

                strRes += "<Grupo_deta";
                strRes += " CGD_ID= \"" + (rs.getString("CGD_ID")) + "\"  ";
                strRes += " CGD_MES= \"" + (rs.getString("strmes")) + "\"  ";
                strRes += " CGD_MES_int= \"" + (rs.getString("CGD_MES")) + "\"  ";
                strRes += " CGD_ANIO= \"" + (rs.getString("CGD_ANIO")) + "\"  ";
                strRes += " CGD_IMPVENTA= \"" + (rs.getString("CGD_IMPVENTA")) + "\"  ";
                strRes += " CGD_IMPVENTA_COBRO= \"" + (rs.getString("CGD_IMPVENTA_COBRO")) + "\"  ";
                strRes += " CGD_IMPMETA= \"" + (rs.getString("CGD_IMPMETA")) + "\"  ";
                strRes += "/>";
            }

            strRes += "</Grupo>";

            rs.close();

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
        }

        //Inserta o Edita valores del grid
        if (strid.equals("2")) {

            int intIdMaster = Integer.parseInt(request.getParameter("intIdMaster"));
            int intContador = Integer.parseInt(request.getParameter("Contador"));

            String strCGD_MES_INT = "";
            String strCGD_ANIO = "";
            double strCGD_IMPVENTA = 0;
            double strCGD_IMPVENTA_COBRO = 0.0;
            double strCGD_IMPMETA = 0.0;

            for (int i = 1; i <= intContador; i++) {
                strCGD_MES_INT = request.getParameter("CGD_MES_INT" + i);
                strCGD_ANIO = request.getParameter("CGD_ANIO" + i);
                strCGD_IMPVENTA = Double.parseDouble(request.getParameter("CGD_IMPVENTA" + i));
                strCGD_IMPVENTA_COBRO = Double.parseDouble(request.getParameter("CGD_IMPVENTA_COBRO" + i));
                strCGD_IMPMETA = Double.parseDouble(request.getParameter("CGD_IMPMETA" + i));

                //Llamamos objeto para guardar los datos de la tabla
                cofide_gtrabajo objTabla = new cofide_gtrabajo();
                objTabla.setBolGetAutonumeric(true);

                objTabla.setFieldInt("CG_ID", intIdMaster);
                objTabla.setFieldString("CGD_MES", strCGD_MES_INT);
                objTabla.setFieldString("CGD_ANIO", strCGD_ANIO);
                objTabla.setFieldDouble("CGD_IMPVENTA", strCGD_IMPVENTA);
                objTabla.setFieldDouble("CGD_IMPVENTA_COBRO", strCGD_IMPVENTA_COBRO);
                objTabla.setFieldDouble("CGD_IMPMETA", strCGD_IMPMETA);

                //Generamos una alta
                strRes = objTabla.Agrega(oConn);
            }
            if (strRes.equals("")) {
                strRes = "OK";
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
        }
        //Edita Registros  individuales del grid
        if (strid.equals("3")) {

            int strCGD_ID = Integer.parseInt(request.getParameter("CGD_ID"));
            String strCGD_MES_INT = request.getParameter("CGD_MES");
            String strCGD_ANIO = request.getParameter("CGD_ANIO");
            double strCGD_IMPVENTA = Double.parseDouble(request.getParameter("CGD_IMPVENTA"));
            double strCGD_IMPVENTA_COBRO = Double.parseDouble(request.getParameter("CGD_IMPVENTA_COBRO"));
            double strCGD_IMPMETA = Double.parseDouble(request.getParameter("CGD_IMPMETA"));

            //Llamamos objeto para guardar los datos de la tabla
            cofide_gtrabajo objTabla = new cofide_gtrabajo();
            objTabla.setBolGetAutonumeric(true);
            objTabla.ObtenDatos(strCGD_ID, oConn);

            objTabla.setFieldString("CGD_MES", strCGD_MES_INT);
            objTabla.setFieldString("CGD_ANIO", strCGD_ANIO);
            objTabla.setFieldDouble("CGD_IMPVENTA", strCGD_IMPVENTA);
            objTabla.setFieldDouble("CGD_IMPVENTA_COBRO", strCGD_IMPVENTA_COBRO);
            objTabla.setFieldDouble("CGD_IMPMETA", strCGD_IMPMETA);

            strRes = objTabla.Modifica(oConn);
            if (strRes.equals("")) {
                strRes = "OK";
            }
            oConn.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
        }

        if (strid.equals("4")) {
            String strCGD_ID = request.getParameter("idDetalle");
            strSql = "delete from where cofide_gtrabajo  where CGD_ID = " + strCGD_ID;
            oConn.runQueryLMD(strSql);
            strRes = oConn.getStrMsgError();
            if (strRes.equals("")) {
                strRes = "OK";
            }
            oConn.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado

        }
        if (strid.equals("5")) {
            String strPathBase = this.getServletContext().getRealPath("/");
            String strSeparator = System.getProperty("file.separator");
            if (strSeparator.equals("\\")) {
                strSeparator = "/";
                strPathBase = strPathBase.replace("\\", "/");
            }
            if (ServletFileUpload.isMultipartContent(request)) {
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
                        //Validamos que suban solo archivos XLS
                        if (fileName.toLowerCase().endsWith(".xls")) {
                            //Separamos el nombre del archivo                        
                            if (fileName.contains("\\") && request.getHeader("User-Agent").contains("MSIE")) {
                                fileName = fileName.substring(fileName.lastIndexOf("\\") + 1, fileName.length());
                            }
                            if (strPathBase.endsWith(strSeparator)) {
                                strPathBase = strPathBase;
                            } else {
                                strPathBase = strPathBase + strSeparator;
                            }
                            //Asignamos el nombre del archivo
                            String strPathUsado = strPathBase + "document" + strSeparator + "COFIDE" + strSeparator + fileName;

                            Cofide_LeerXLSXMeta meta = new Cofide_LeerXLSXMeta(oConn);
                            //System.out.println("ruta : " + strPathUsado);
                            meta.importaXLSXMetas(strPathUsado);

                            //Guardamos el archivo
                            File saveTo = new File(strPathUsado);
                            fileItem.write(saveTo);
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
        }
        if (strid.equals("6")) {
            //Recibimos parametros
            String strAnio = request.getParameter("Anio");
            int intMes = Integer.valueOf(request.getParameter("Mes"));
            //Ejecutamos la consulta
            strSql = "select usuarios.id_usuarios, nombre_usuario, US_GRUPO, CG_DESCRIPCION,COFIDE_CODIGO, "
                    + "(select count(*) from vta_cliente where CT_ES_PROSPECTO = 0 and CT_CLAVE_DDBB = COFIDE_CODIGO and CT_ACTIVO = 1 ) as Exparticipante, "
                    + "(select count(*) from vta_cliente where CT_ES_PROSPECTO = 1 and CT_CLAVE_DDBB = COFIDE_CODIGO and CT_ACTIVO = 1) as Prospecto, "
                    + "(select count(*) from vta_cliente where CT_CLAVE_DDBB = COFIDE_CODIGO and CT_ACTIVO = 1) as TotalCte, "
                    + "CMU_IMPORTE as Importe,"
                    + "CMU_NUEVO_CTE as NuevoCte "
                    + " from cofide_grupo_trabajo,usuarios,cofide_metas_usuario "
                    + " where cofide_metas_usuario.id_usuarios = usuarios.id_usuarios and IS_TMK = 1 "
                    + " and CG_ID = US_GRUPO "
                    + " AND CME_ANIO= '" + strAnio + "' AND CME_MES = " + intMes
                    + " order by US_GRUPO,nombre_usuario";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                int intId = rs.getInt("id_usuarios");
                String strNombre = rs.getString("nombre_usuario");
                int intIdGpo = rs.getInt("US_GRUPO");
                String strCodigoDDBB = rs.getString("COFIDE_CODIGO");
                int intExparticipante = rs.getInt("Exparticipante");
                int intProspecto = rs.getInt("Prospecto");
                int intTotalCte = rs.getInt("TotalCte");
                double dblImporte = rs.getDouble("Importe");
                int intNvoCte = rs.getInt("NuevoCte");
                String strGrupo = rs.getString("CG_DESCRIPCION");
                strXML.append("<datos");
                strXML.append(" id = \"").append(intId).append("\"");
                strXML.append(" nombre = \"").append(strNombre).append("\"");
                strXML.append(" id_gpo = \"").append(intIdGpo).append("\"");
                strXML.append(" ddbb = \"").append(strCodigoDDBB).append("\"");
                strXML.append(" expa = \"").append(intExparticipante).append("\"");
                strXML.append(" pros = \"").append(intProspecto).append("\"");
                strXML.append(" totalcte = \"").append(intTotalCte).append("\"");
                strXML.append(" importe = \"").append(dblImporte).append("\"");
                strXML.append(" nvocte = \"").append(intNvoCte).append("\"");
                strXML.append(" gpo = \"").append(strGrupo).append("\"");
                strXML.append(" />");
            }
            strXML.append("</vta>");
            strXML.toString();
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
        }
        if (strid.equals("7")) {
            //Recibimos los parametros
            String strAnio = request.getParameter("Anio");
            int intMes = Integer.valueOf(request.getParameter("Mes"));
            //Ejecutamos la consulta
            strSql = "select US_GRUPO,CG_DESCRIPCION,sum(CMU_IMPORTE) as Importe, sum(CMU_NUEVO_CTE) as NuevoCte "
                    + " from cofide_grupo_trabajo,usuarios,cofide_metas_usuario "
                    + " where cofide_metas_usuario.id_usuarios = usuarios.id_usuarios and IS_TMK = 1 "
                    + " and CG_ID = US_GRUPO"
                    + " AND CME_ANIO= '" + strAnio + "' AND CME_MES = " + intMes
                    + " group by US_GRUPO,CG_DESCRIPCION";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                int intIdGpo = rs.getInt("US_GRUPO");
                double dblImporte = rs.getDouble("Importe");
                int intNvoCte = rs.getInt("NuevoCte");
                String strGrupo = rs.getString("CG_DESCRIPCION");
                strXML.append("<datos");
                strXML.append(" ID = \"").append(intIdGpo).append("\"");
                strXML.append(" IMPORTE = \"").append(dblImporte).append("\"");
                strXML.append(" NUEVO = \"").append(intNvoCte).append("\"");
                strXML.append(" GRUPO = \"").append(strGrupo).append("\"");
                strXML.append(" />");
            }
            strXML.append("</vta>");
            strXML.toString();
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
        }
        if (strid.equals("8")) {
            String strID = request.getParameter("id");
            String strImp = request.getParameter("imp");
            String strNvo = request.getParameter("nvo");
            boolean bolExiste = false;
            String strSqlS = "select * from cofide_metas_usuario where id_usuarios = " + strID;
            rs = oConn.runQuery(strSqlS, true);
            while (rs.next()) {
                bolExiste = true;
            }
            rs.close();
            if (bolExiste) {
                strSql = "update cofide_metas_usuario set "
                        + "CMU_NUEVO_CTE = " + strNvo + ", "
                        + "CMU_IMPORTE = " + strImp + " "
                        + "where id_usuarios = " + strID;
                oConn.runQueryLMD(strSql);
            } else {
                strSql = "insert into cofide_metas_usuario "
                        + "(id_usuarios, CMU_NUEVO_CTE, CMU_IMPORTE) values "
                        + "(" + strID + "," + strImp + ", " + strNvo + ")";
                oConn.runQueryLMD(strSql);
            }
        }
        //Calculamos la metas en base al monto global objetivo por mes
        if (strid.equals("9")) {
            int intMes = Integer.valueOf(request.getParameter("mes_global"));
            String strAnio = request.getParameter("anio_global");
            double dblMontoTot = Double.valueOf(request.getParameter("monto_global"));
            //Validamos si hay metas cargadas las borramos
            boolean bolExistenMetas = false;
            String strSqlR = "select  MG_ID from cofide_meta_global where MG_ANIO = '" + strAnio + "' and MG_MES= " + intMes;
            ResultSet rsR = oConn.runQuery(strSqlR, true);
            while (rsR.next()) {
                //Ya existe
                bolExistenMetas = true;
                int intMG_ID = rsR.getInt("MG_ID");
                String strUpdate1 = "update cofide_meta_global set MG_IMPORTE = " + dblMontoTot + " where MG_ID = " + intMG_ID;
                oConn.runQueryLMD(strUpdate1);
            }
            rsR.close();
            if (!bolExistenMetas) {
                //Generamos nuevas metas
                String strInsert1 = "insert into cofide_meta_global (MG_IMPORTE,MG_ANIO,MG_MES)values(" + dblMontoTot + ",'" + strAnio + "'," + intMes + ")";
                oConn.runQueryLMD(strInsert1);

            }
            //Obtenemos el total de exparticipantes
            double dblTotExparticipantes = 0;
            strSqlR = "select count(*) as tot_num "
                    + "  from vta_cliente,usuarios where IS_TMK = 1 and CT_ES_PROSPECTO = 0 and CT_CLAVE_DDBB = COFIDE_CODIGO"
                    + " and CT_ACTIVO = 1";
            rsR = oConn.runQuery(strSqlR, true);
            while (rsR.next()) {
                dblTotExparticipantes = rsR.getDouble("tot_num");
            }
            rsR.close();
            if (dblTotExparticipantes > 0) {
                //Borramos todas las metas del periodo
                String strDelMetas = "delete from cofide_metas_usuario where CME_ANIO = '" + strAnio + "' and CME_MES = " + intMes;
                oConn.runQueryLMD(strDelMetas);
                //Obtenemos el total de exparticipantes por usuario para guardar las metas del mes
                strSqlR = "select usuarios.id_usuarios,usuarios.nombre_usuario,usuarios.COFIDE_CODIGO,count(*) as tot_num "
                        + "  from vta_cliente,usuarios where IS_TMK = 1 and CT_ES_PROSPECTO = 0 and CT_CLAVE_DDBB = COFIDE_CODIGO"
                        + " and CT_ACTIVO = 1"
                        + " group by usuarios.id_usuarios,usuarios.nombre_usuario,usuarios.COFIDE_CODIGO";
                rsR = oConn.runQuery(strSqlR, true);
                while (rsR.next()) {
                    int intIdUsuario = rsR.getInt("id_usuarios");
               //String strNomUsuario = rsR.getString("nombre_usuario");
                    //String strNomBase = rsR.getString("COFIDE_CODIGO");
                    int intNumExparticipantes = rsR.getInt("tot_num");

                    double dblPorc = (intNumExparticipantes / dblTotExparticipantes) * 100;
                    double dblMeta = (dblPorc / 100) * dblMontoTot;
                    System.out.println(intIdUsuario + " intTotExparticipantes:" + dblTotExparticipantes + " intNumExparticipantes:" + intNumExparticipantes + " dblPorc:" + dblPorc + " dblMeta:" + dblMeta);
                    String strInsert2 = "insert into cofide_metas_usuario("
                            + "id_usuarios,CMU_IMPORTE,CMU_NUEVO_CTE,CMU_FECHA,CME_ANIO,CME_MES"
                            + ")values("
                            + intIdUsuario + "," + dblMeta + ",0,'','" + strAnio + "'," + intMes
                            + ")";
                    oConn.runQueryLMD(strInsert2);
                }
                rsR.close();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println("OK");//Pintamos el resultado
        }
    }
    oConn.close();
%>
