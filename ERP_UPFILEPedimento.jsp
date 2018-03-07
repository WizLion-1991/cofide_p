<%-- 
    Document   : ERP_UPFILEPedimento
    Created on : 23/05/2014, 05:57:55 PM
    Author     : siwebmx5
--%>
<%@page import="ERP.PedimentosDoc"%>
<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
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
        String strPathBaseShort = "document" + strSeparator + "odc";
        //Si la peticion no fue nula proseguimos
        atrJSP.atrJSP(request, response, true, false);
        out.clearBuffer();
        //Instanciamos objeto para subir archivos....
        //Validamos si la peticion se genero con enctype
        if (ServletFileUpload.isMultipartContent(request)) {
            // Parse the HTTP request...
            ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
            List fileItemsList = servletFileUpload.parseRequest(request);
            Iterator it = fileItemsList.iterator();
            //Procesamos los archivos subidos
            while (it.hasNext()) {
                FileItem fileItem = (FileItem) it.next();
                if (fileItem.isFormField()) {
                } else {                    
                    
                    String strCarpetaDest = "";
                    /* The file item contains an uploaded file */
                    /* Get the name attribute value of the <input type="file"> element. */
                    String fieldName = fileItem.getFieldName();

                    /* Get the size of the uploaded file in bytes. */
                    long fileSize = fileItem.getSize();

                    /* Get the name of the uploaded file at the client-side. Some browsers such as IE 6 include the whole path here (e.g. e:\files\myFile.txt), so you may need to extract the file name from the path. This information is provided by the client browser, which means you should be cautious since it may be a wrong value provided by a malicious user. */
                    String fileName = fileItem.getName();

                    /* Get the content type (MIME type) of the uploaded file. This information is provided by the client browser, which means you should be cautious since it may be a wrong value provided by a malicious user. */
                    String contentType = fileItem.getContentType();

                    //Validamos que suban solo archivos txt
                    if (fileName.toLowerCase().endsWith(".pdf")) {
                        //Separamos el nombre del archivo
                        //C:Documents and SettingszeusEscritorio1168591.pdf
                        if (fileName.contains("\\") && request.getHeader("User-Agent").contains("MSIE")) {
                            fileName = fileName.substring(fileName.lastIndexOf("\\") + 1, fileName.length());
                        }
                        strCarpetaDest = "Pedimentos";
                        
                        //Asignamos el nombre del archivo
                        String strPathUsado = strPathBase + "document" + strSeparator + strCarpetaDest + strSeparator + fileName;
                        /*if (fieldName.equals("CTO_IMSGEN1")) {
                        strPathUsado = strPathBase + "document" + strSeparator + fileName;
                        }*/
                        
                        //Guardamos el archivo
                        System.out.println(strPathUsado);
                        File saveTo = new File(strPathUsado);
                        if(!saveTo.exists())
                        {    
                            fileItem.write(saveTo);
                        }
                        else
                        {
                            strerror = "Ya existe ese archivo.";
                        }
                                
                        
                        if (oConn.isBolEsError() || !strerror.equals("")) {
                            if(strerror.equals(""))
                            {
                                strerror = "Hubo un error al subir el archivo" + oConn.getStrMsgError();
                            }
                        } else {
                            Fechas fecha = new Fechas();
                            //Bitacora de actividad del usuario 
                            bitacorausers logUser = new bitacorausers();
                            logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                            logUser.setFieldString("BTU_NOMMOD", "APLICACION PAGOS");
                            logUser.setFieldString("BTU_NOMACTION", "CARGA ARCHIVO");
                            logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                            logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                            logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                            logUser.Agrega(oConn);

                            
                            
                            PedimentosDoc PD = new PedimentosDoc();
                            PD.getPR().setFieldString("PRE_DESCRIPCION", fileName);
                            PD.getPR().setFieldString("PRE_PATH", strPathUsado);
                            PD.getPR().setFieldInt("PED_ID", Integer.parseInt(request.getParameter("PED_ID")));
                            PD.getPR().setFieldDouble("PRE_TAMANIO", 0.0);
                            PD.getPR().setFieldString("PRE_FECHA", fecha.getFechaActual());
                            PD.getPR().setFieldString("PRE_HORA", fecha.getHoraActual());
                            PD.getPR().setFieldInt("PRE_USUARIO",varSesiones.getIntNoUser());
                            PD.savePedimentosDoc(oConn);
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