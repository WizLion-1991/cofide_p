<%-- 
    Document   : ERP_UPFileEmp
    Este jsp se encarga de subir los logos y los CBB de la pantalla
de configuracion de empresas
    Created on : 3/03/2011, 12:14:24 AM
    Author     : zeus
--%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.io.File"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    String strmsg = "";
    String strerror = "";
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Inicializamos parametros
        String strPathBase = this.getServletContext().getRealPath("/");
        String strSeparator = System.getProperty("file.separator");
        if (strSeparator.equals("\\")) {
            strSeparator = "/";
            strPathBase = strPathBase.replace("\\", "/");
        }
        String strPathBaseShort = "images" + strSeparator + "ptovta";
        //Si la peticion no fue nula proseguimos
        atrJSP.atrJSP(request, response, true, false);
        out.clearBuffer();
        //Instanciamos objeto para subir archivos....
        //Validamos si la peticion se genero con enctype
        if (ServletFileUpload.isMultipartContent(request)) {
            //Recibimos parametros de numero de poliza y tipo de archivo subido
            String intEMP_ID = request.getParameter("EMP_ID");
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
                        if (fieldName.equals("EMP_UP_IMG1")) {
                            strPathUsado = strPathBase + "images" + strSeparator + fileName;
                        }
                        strPathBaseShort = strPathBaseShort + strSeparator + fileName;
                        if (fieldName.equals("EMP_UP_IMG2")) {
                            strPathUsado = strPathBase + "images" + strSeparator + "codBar" + intEMP_ID + ".png";
                            strPathBaseShort = "images" + strSeparator + "codBar" + intEMP_ID + ".png";
                        }
                        if (fieldName.equals("EMP_UP_IMG3")) {
                             strPathBaseShort ="images"+ strSeparator + fileName;
                            strPathUsado = strPathBase + "images" + strSeparator + fileName;
                        }
                        if (fieldName.equals("EMP_UP_IMG4")) {
                           strPathBaseShort ="images"+ strSeparator + fileName;
                            strPathUsado = strPathBase + "images" + strSeparator + fileName;
                        }
                        if (fieldName.equals("EMP_UP_IMG5")) {
                            strPathBaseShort ="images"+ strSeparator + fileName;
                            strPathUsado = strPathBase + "images" + strSeparator + fileName;
                        }
                        if (fieldName.equals("EMP_UP_IMG6")) {
                            strPathBaseShort ="images"+ strSeparator + fileName;
                            strPathUsado = strPathBase + "images" + strSeparator + fileName;
                        }

                        //Guardamos el archivo
                        File saveTo = new File(strPathUsado);
                        fileItem.write(saveTo);
                        //Guardamos el path en la base de datos
                        String strUpdate = "";
                        if (fieldName.equals("EMP_UP_IMG1")) {
                            strUpdate = "UPDATE vta_empresas set ";
                            strUpdate += " EMP_PATHIMGFORM= '" + strPathUsado + "'";
                            strUpdate += " ,EMP_PATHIMG= '" + strPathBaseShort + "'";
                            strUpdate += " WHERE EMP_ID = " + intEMP_ID;
                            
                        }
                        if (fieldName.equals("EMP_UP_IMG2")) {
                            strUpdate = "UPDATE vta_empresas set ";
                            strUpdate += " EMP_PATHIMGCODBAR= '" + strPathUsado + "'";
                            strUpdate += " ,PATHIMAGE2= '" + strPathBaseShort + "'";
                            strUpdate += " WHERE EMP_ID = " + intEMP_ID;
                        }
                        if (fieldName.equals("EMP_UP_IMG3")) {
                            strUpdate = "UPDATE vta_empresas set ";
                            strUpdate += " EMP_IMGCUERPO= '" + strPathBaseShort + "'";
                            strUpdate += " ,PATHIMAGE3= '" + strPathBaseShort + "'";
                            strUpdate += " WHERE EMP_ID = " + intEMP_ID;
                        }
                        if (fieldName.equals("EMP_UP_IMG4")) {
                            strUpdate = "UPDATE vta_empresas set ";
                            strUpdate += " EMP_IMGCUERPO2= '" + strPathBaseShort + "'";
                             strUpdate += " ,PATHIMAGE4= '" + strPathBaseShort + "'";
                            strUpdate += " WHERE EMP_ID = " + intEMP_ID;
                        }
                        if (fieldName.equals("EMP_UP_IMG5")) {
                            strUpdate = "UPDATE vta_empresas set ";
                            strUpdate += " EMP_IMGCUERPO3= '" + strPathBaseShort + "'";
                             strUpdate += " ,PATHIMAGE5= '" + strPathBaseShort + "'";
                            strUpdate += " WHERE EMP_ID = " + intEMP_ID;
                        }
                        if (fieldName.equals("EMP_UP_IMG6")) {
                            strUpdate = "UPDATE vta_empresas set ";
                            strUpdate += " EMP_IMGCUERPO4= '" + strPathBaseShort + "'";
                             strUpdate += " ,PATHIMAGE6= '" + strPathBaseShort + "'";
                            strUpdate += " WHERE EMP_ID = " + intEMP_ID;
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
    } else {
    }
    out.clear();
    out.println("{");
    out.println("error: '" + strerror + "',\n");
    out.println("msg: '" + strmsg + "'\n");
    out.println("}\n");
    oConn.close();
%>