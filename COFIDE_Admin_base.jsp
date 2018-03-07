<%-- 
    Document   : COFIDE_Admin_base
    Created on : 29-may-2016, 2:43:15
    Author     : juliomondragon
--%>

<%@page import="com.mx.siweb.erp.especiales.cofide.COFIDE_LeerXlsDDBB"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Random"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    VariableSession varSesiones = new VariableSession(request);
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    varSesiones.getVars();
    Fechas fec = new Fechas();
    UtilXml util = new UtilXml();
    Seguridad seg = new Seguridad();
    oConn.open();
    StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
    strXML.append("<vta>");
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("ID");
        if (!strid.equals(null)) {

            if (strid.equals("1")) {
                String ID_BASE = request.getParameter("ID_BASE");
                String strCT_ID = "";
                String strContacto = "";
                String strRazonSOcial = "";
                String strTelefono = "";
                String strMail = "";
                String strSql = "select * from vta_cliente where CT_CLAVE_DDBB = '" + ID_BASE + "'";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strCT_ID = rs.getString("CT_ID");
                    strContacto = rs.getString("CT_CONTACTO1");
                    strRazonSOcial = rs.getString("CT_RAZONSOCIAL");
                    strTelefono = rs.getString("CT_TELEFONO1");
                    strMail = rs.getString("CT_EMAIL1");

                    strXML.append("<datos");
                    strXML.append(" id = \"").append(strCT_ID).append("\"");
                    strXML.append(" contacto = \"").append(strContacto).append("\"");
                    strXML.append(" razon = \"").append(strRazonSOcial).append("\"");
                    strXML.append(" telefono = \"").append(strTelefono).append("\"");
                    strXML.append(" correo = \"").append(strMail).append("\"");
                    strXML.append(" />");
                }
                strXML.append("</vta>");
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //primer caso

            if (strid.equals("2")) {
                String strerror = "";
                String strmsg = "";
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
                                /*
                                COFIDE_LeerXlsDDBB vta = new COFIDE_LeerXlsDDBB(oConn);
                                System.out.println("ruta : " + strPathUsado);
                                vta.importaXLS(strPathUsado);
                                 */

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
            } // segundo caso
            if (strid.equals("3")) {
                String strFile = request.getParameter("filename");
                COFIDE_LeerXlsDDBB vta = new COFIDE_LeerXlsDDBB(oConn);
                vta.importaXLS("/Users/juliomondragon/Documents/COFIDE/siweb/COFIDE/build/web/document/COFIDE/" + strFile + ".xls");
            } //insert

            if (strid.equals("4")) {
                String strNumeroReg = request.getParameter("num_registro");
                String strId_Base = request.getParameter("id_base");
                String strCT_ID = "";
                String strContacto = "";
                String strRazonSOcial = "";
                String strTelefono = "";
                String strMail = "";
                String strSql = "select * from vta_cliente where CT_CLAVE_DDBB = '" + strId_Base + "' limit " + strNumeroReg + "";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strCT_ID = rs.getString("CT_ID");
                    strContacto = rs.getString("CT_CONTACTO1");
                    strRazonSOcial = rs.getString("CT_RAZONSOCIAL");
                    strTelefono = rs.getString("CT_TELEFONO1");
                    strMail = rs.getString("CT_EMAIL1");

                    strXML.append("<datos");
                    strXML.append(" id = \"").append(strCT_ID).append("\"");
                    strXML.append(" contacto = \"").append(strContacto).append("\"");
                    strXML.append(" razon = \"").append(strRazonSOcial).append("\"");
                    strXML.append(" telefono = \"").append(strTelefono).append("\"");
                    strXML.append(" correo = \"").append(strMail).append("\"");
                    strXML.append(" />");
                }
                strXML.append("</vta>");
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //caso 4
            if (strid.equals("5")) {
                int intlength = Integer.parseInt(request.getParameter("length"));
                String strIdBase = request.getParameter("id_base");
                for (int i = 0; i < intlength; i++) {
                    String strCT_ID = request.getParameter("ct_id" + i);
                    String strUpdate = "update vta_cliente set CT_CLAVE_DDBB = '" + strIdBase + "' where CT_ID = " + strCT_ID;
                    oConn.runQueryLMD(strUpdate);
                }
            } //caso 5
        } // inicial, valida si es vacio el ID
    } else { //revisa la sesion
        out.println("Sin acceso");
    }
    oConn.close();

%>
