<%-- 
    Document   : ERP_UpFileActivos
    Created on : 12-jun-2015, 15:21:41
    Author     : siweb
--%>

<%@page import="com.mx.siweb.mlm.compensacion.wenow.CobrosMasivosXLS"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   String strMsg = "";
   String strError = "";
   String strUUID = "";

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
                  String strPathUsado = strPathBase + "tmp" + strSeparator + fileName;
                  //Guardamos el archivo
                  System.out.println(strPathUsado);
                  File saveTo = new File(strPathUsado);
                  fileItem.write(saveTo);
                  strMsg = "";
                  //Procesamos el archivo
                  CobrosMasivosXLS masivos = new CobrosMasivosXLS();
                  masivos.setStrPathExcel(strPathUsado);
                  masivos.setVarSesiones(varSesiones);
                  masivos.setoConn(oConn);
                  masivos.setIntUplineInicial(10001);
                  masivos.setIntUplineTemporal(3);
                  String strRespuesta = masivos.processXLS();
                  if (strRespuesta.equals("OK")) {
                     strMsg = "XML CARGADO EXITOSAMENTE";
                  } else {
                     strError = strRespuesta;
                  }
               }
            }
         }//Fin while   
      }
   } else {
   }
   out.clear();
   out.println("{");
   out.println("error: '" + strError + "',\n");
   out.println("msg: '" + strMsg + "'\n");
   out.println("}\n");
   oConn.close();%>
