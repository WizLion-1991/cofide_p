<%-- 
    Document   : ERP_SubirArchivoXLS
    Created on : 05-ene-2015, 16:59:44
    Author     : siweb
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.mx.siweb.erp.especiales.siweb.CargarXLSPAC"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.io.IOException"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
    String strUUID ="";
    
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
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
                System.out.println("JSP2");
                FileItem fileItem = (FileItem) it.next();
                if (fileItem.isFormField()) {
                } else {

                    /* The file item contains an uploaded file */
                    /* Get the name attribute value of the <input type="file"> element. */
                    String fieldName = fileItem.getFieldName();
                    //System.out.println(fieldName);
                    /* Get the size of the uploaded file in bytes. */
                    long fileSize = fileItem.getSize();
                    //System.out.println(fileSize);
                    /* Get the name of the uploaded file at the client-side. Some browsers such as IE 6 include the whole path here (e.g. e:\files\myFile.txt), so you may need to extract the file name from the path. This information is provided by the client browser, which means you should be cautious since it may be a wrong value provided by a malicious user. */
                    String fileName = fileItem.getName();
                    //System.out.println(fileName);
                    /* Get the content type (MIME type) of the uploaded file. This information is provided by the client browser, which means you should be cautious since it may be a wrong value provided by a malicious user. */
                    String contentType = fileItem.getContentType();
                    //System.out.println(contentType);
                    //Validamos que suban solo archivos pdf
                    if (fileName.toLowerCase().endsWith(".xls")) {
                        //Separamos el nombre del archivo                        
                        if (fileName.contains("\\") && request.getHeader("User-Agent").contains("MSIE")) {
                            fileName = fileName.substring(fileName.lastIndexOf("\\") + 1, fileName.length());
                        }
                        //Asignamos el nombre del archivo
                        String strPathUsado = strPathBase + "document" + strSeparator + "XLSPAC" + strSeparator + fileName;
                        //Guardamos el archivo
                        File saveTo = new File(strPathUsado);

                        
                            fileItem.write(saveTo);
                            CargarXLSPAC XLSPac = new CargarXLSPAC();
                            XLSPac.AbrirXLS(oConn, strPathUsado, varSesiones);
                            ArrayList<String> rfcNoEncontrados = new ArrayList<String>();
                            ArrayList<String> rfcYaRegistrados = new ArrayList<String>();
                            ArrayList<String> rfcDiferentes = new ArrayList<String>();
                            ArrayList<String> rfcCorrectos = new ArrayList<String>();
                            
                            rfcNoEncontrados = XLSPac.getNoEncontrados();
                            rfcYaRegistrados = XLSPac.getYaRegistrados();
                            rfcDiferentes = XLSPac.getConDiferencia();
                            rfcCorrectos = XLSPac.getCorrectos();
                            
                            
                            String noCompletos = "";
                            String registados = "";
                            String Diferentes = "";
                            String Correctos = "";
                            for(String RFCne: rfcNoEncontrados){
                                noCompletos = "<font color=\"red\">" + RFCne + "</br>" + "</font>";
                                System.out.println(noCompletos);
                                strUUID = strUUID + noCompletos;
                            }
                            
                            for(String rfcEnc: rfcYaRegistrados){
                                registados = "<font color=\"Navy\">" + rfcEnc + "</br>" + "</font>";
                                strUUID = strUUID + registados;
                            }
                            
                            for(String RFCDif: rfcDiferentes){
                                
                                Diferentes = "<font color=\"Black\">" + RFCDif + "</br>" + "</font>";
                                strUUID = strUUID + Diferentes;
                            }
                            
                            for(String RFCok: rfcCorrectos){
                                
                                Correctos = "<font color=\"Green\">" + RFCok + "</br>" + "</font>";
                                strUUID = strUUID + Correctos;
                                System.out.println(Correctos);
                            }


                        strmsg = "";
                        if (strmsg.equals("OK")) {
                            strmsg = "XML CARGADO EXITOSAMENTE";
                        }
                    }
                }
            }


        } else {
            strerror = "La petición no viene de  manera enctype";
        }
        
    }else {
    }

    out.clear();
    out.println("{");
    out.println("error: '" + strerror + "',\n");
    out.println("strUUID: '" + strUUID + "',\n");
    out.println("msg: '" + strmsg + "'\n");
    out.println("}\n");
    oConn.close();

%>