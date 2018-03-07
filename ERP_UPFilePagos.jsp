<%-- 
    Document   : ERP_UPFileAcobranza
    Created on : 4/04/2013, 12:47:22 PM
    Author     : SIWEB
--%>

<%@page import="com.mx.siweb.prosefi.ProcesaPagos"%>
<%@page import="com.mx.siweb.prosefi.Cobranza"%>
<%@page import="ERP.CobranzaLayouts"%>
<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.mx.siweb.prosefi.Credito"%>
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
      String strPathBaseShort = "document" + strSeparator + "aplicacionpagos";
      //Si la peticion no fue nula proseguimos
      atrJSP.atrJSP(request, response, true, false);
      out.clearBuffer();
      //Instanciamos objeto para subir archivos....
      //Validamos si la peticion se genero con enctype
      if (ServletFileUpload.isMultipartContent(request)) {
         //Recibimos parametros de numero de poliza y tipo de archivo subido

         String intBanco = request.getParameter("BC_ID");
         String intMoneda = request.getParameter("MON_ID");
         String intArchivo = request.getParameter("CPM_ID");


         int intCPM_ID = Integer.parseInt(request.getParameter("CPM_ID"));
         
         String strFecha = request.getParameter("AP_FECHA");
         Fechas fecha = new Fechas();
         if (!strFecha.equals("")) {
            strFecha = fecha.FormateaBD(strFecha, "/");
         }




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

               //Validamos que suban solo archivos txt
               if (fileName.toLowerCase().endsWith(".xls") || fileName.toLowerCase().endsWith(".txt")) {
                  //Separamos el nombre del archivo
                  //C:Documents and SettingszeusEscritorio1168591.pdf
                  if (fileName.contains("\\") && request.getHeader("User-Agent").contains("MSIE")) {
                     fileName = fileName.substring(fileName.lastIndexOf("\\") + 1, fileName.length());
                  }
                  //Asignamos el nombre del archivo
                  String strPathUsado = strPathBase + "document" + strSeparator + "aplicacionpagos" + strSeparator + fileName;
                  /*if (fieldName.equals("CTO_IMSGEN1")) {
                  strPathUsado = strPathBase + "document" + strSeparator + fileName;
                  }*/


                  //Guardamos el archivo
                  File saveTo = new File(strPathUsado);
                  fileItem.write(saveTo);

                  String strInsert = "INSERT INTO vta_aplicacion_pagos(AP_NOMBRE,AP_PATHIMGFORM,AP_FECHA,BC_ID,MON_ID,CPM_ID)values "
                          + "('" + fileName + "', '" + strPathUsado + "','" + strFecha + "','" + intBanco + "','" + intMoneda + "','" + intArchivo + "')";
                  System.out.println(intArchivo);

                  oConn.runQueryLMD(strInsert);

                  if (oConn.isBolEsError()) {
                     strerror = "Hubo un error al subir el archivo" + oConn.getStrMsgError();
                  } else {
                     //Bitacora de actividad del usuario
                     bitacorausers logUser = new bitacorausers();
                     logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                     logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                     logUser.setFieldString("BTU_NOMMOD", "APLICACION PAGOS");
                     logUser.setFieldString("BTU_NOMACTION", "CARGA ARCHIVO");
                     logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                     logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                     logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                     logUser.Agrega(oConn);
   
                      System.out.println(strPathUsado);                      
                     //Aplicamos el archivo de cobranza
                     //Cobranza layout = new Cobranza(intCPM_ID, oConn, varSesiones);
                      ProcesaPagos layout = new ProcesaPagos(intCPM_ID, oConn, varSesiones);
                     layout.setBolLinkPedidos(true);
                     layout.Init();
                     layout.setIntBc_Id(Integer.valueOf(intBanco));
                     String strRes = layout.ProcesaLayout(strPathUsado);
                     String strResultLast = "";
                     if (!strRes.equals("OK")) {
                        strResultLast = strRes;
                     }


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