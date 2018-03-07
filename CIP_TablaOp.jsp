<%-- 
    Document   : CIP_TablaOp
    Created on : 26/04/2010, 03:14:16 PM
    Author     : zeus

 Esta pagina se encarga de procesar las peticiones con las pantallas definidas
 en la base de datos. Forma parte del proceso MODELO VISTA DATOS.
--%>
<%@page import="comSIWeb.Operaciones.CIP_TablaMSSQL"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Bitacora" %>
<%@ page import="comSIWeb.Operaciones.CIP_Tabla" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
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
      /*Definimos parametros de la aplicacion*/
      String strid = request.getParameter("ID");
      String stropnOpt = request.getParameter("opnOpt");
      if (strid == null) {
         strid = "0";
      }
      if (stropnOpt == null) {
         stropnOpt = "";
      }
      //Instanciamos el objeto para la tabla generica
      CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
      //objTabla.Init(stropnOpt, oConn);
      //Nueva Tabla generica
      if (strid.equals("1")) {
         objTabla.Init(stropnOpt, true, true, false, oConn);
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         objTabla.ObtenParams(true, true, false, false, request, oConn);
         String strResult = "";
         //Si no envian el id es una alta
         if (objTabla.getValorKey().equals("0") || objTabla.getValorKey().equals("")) {
            strResult = objTabla.Agrega(oConn);
         } else {
            strResult = objTabla.Modifica(oConn);
         }
         if (strResult.equals("OK")) {
            if (objTabla.isBolGetAutonumeric()) {
               out.println(strResult + objTabla.getValorKey());
            } else {
               out.println("OK" + objTabla.getDataHead("frm_tituloNuevo"));
            }
         } else {
            out.println(strResult);
         }
      }
      //Consulta Tabla generica
      if (strid.equals("2")) {
         objTabla.Init(stropnOpt, oConn);
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         objTabla.ObtenParams(false, false, true, false, request, oConn);
         //Obtenemos el XML
         String strXML = objTabla.Consulta(oConn);
         out.println(strXML);//Pintamos el resultado
      }
      //Borra Tabla generica
      if (strid.equals("3")) {
         objTabla.Init(stropnOpt, oConn);
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         objTabla.ObtenParams(false, false, true, false, request, oConn);
         String strResult = objTabla.Borra(oConn);
         out.println(strResult);
      }
      //Obten Datos de 1 Tabla generica
      if (strid.equals("4")) {
         objTabla.Init(stropnOpt, true, true, true, oConn);
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         objTabla.ObtenParams(false, true, false, false, request, oConn);
         objTabla.ObtenDatos(oConn);
         //Obtenemos el XML
         String strXML = objTabla.DameXml();
         out.println(strXML);//Pintamos el resultado
      }
      //Consulta Tabla generica para GRID
      if (strid.equals("5")) {

         //Obtenemos el XML para el GRID
         if (oConn.getStrDriverName().contains("MySQL")) {
            objTabla.Init(stropnOpt, oConn);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            objTabla.ObtenParams(false, false, true, true, request, oConn);
            String strXML = objTabla.ConsultaXML(oConn);
            out.println(strXML);//Pintamos el resultado

         } else //Otras opciones
         //Sql Server
         if (oConn.getStrDriverName().contains("jTDS")) {
            CIP_TablaMSSQL objTablaSqlServer = new CIP_TablaMSSQL("", "", "", "", varSesiones);
            objTablaSqlServer.Init(stropnOpt, oConn);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            objTablaSqlServer.ObtenParams(false, false, true, true, request, oConn);
            String strXML = objTablaSqlServer.ConsultaXML(oConn);
            out.println(strXML);//Pintamos el resultado
         }
      }
      //Importamos archivo de xls
      if (strid.equals("6")) {
         String strMsg = "";
         String strError = "";
         String strPathBase = this.getServletContext().getRealPath("/");
         String strSeparator = System.getProperty("file.separator");
         if (strSeparator.equals("\\")) {
            strSeparator = "/";
            strPathBase = strPathBase.replace("\\", "/");
         }
         //Validamos si enviaron datos binarios
         if (ServletFileUpload.isMultipartContent(request)) {

            //Inicializamos
            objTabla.Init(stropnOpt, oConn);
            objTabla.ObtenParams(false, false, false, false, request, oConn);
            //Objeto Servlet Request
            ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
            List fileItemsList = servletFileUpload.parseRequest(request);
            Iterator it = fileItemsList.iterator();
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
                  //Validamos que suban solo archivos xls
                  if (fileName.toLowerCase().endsWith(".xls")) {
                     //Separamos el nombre del archivo                        
                     if (fileName.contains("\\") && request.getHeader("User-Agent").contains("MSIE")) {
                        fileName = fileName.substring(fileName.lastIndexOf("\\") + 1, fileName.length());
                     }
                     //Asignamos el nombre del archivo
                     String strPathUsado = strPathBase + "document" + strSeparator + "tmpTablas" + strSeparator + fileName;
                     //Guardamos el archivo
                     File saveTo = new File(strPathUsado);
                     fileItem.write(saveTo);
                     strMsg = objTabla.ImportaXLS(oConn, saveTo);
                     if (strMsg.equals("OK")) {
                        strMsg = "Archivo importado correctamente";
                     } else {
                        strError = strMsg;
                     }
                  } else {
                     strError = "El archivo no contiene la extension necesaria.";
                  }
               }
            }

         } else {
            strError = "Falta implementar el metodo enctype";
         }
         out.clear();
         out.println("{");
         out.println("error: '" + strError + "',\n");
         out.println("msg: '" + strMsg + "'\n");
         out.println("}\n");
      }
      //Exportamos archivo de xls
      if (strid.equals("7")) {
         String strMsg = "";
         String strError = "";
         String strPathBase = this.getServletContext().getRealPath("/");
         String strSeparator = System.getProperty("file.separator");
         if (strSeparator.equals("\\")) {
            strSeparator = "/";
            strPathBase = strPathBase.replace("\\", "/");
         }
         //Asignamos el nombre del archivo
         String strPathUsado = strPathBase + strSeparator + "document" + strSeparator + "tmpTablas" + strSeparator;
         objTabla.Init(stropnOpt, oConn);
         objTabla.ObtenParams(false, false, false, false, request, oConn);
         String strRes = objTabla.exportaXLS(strPathUsado);
         if (strRes.equals("OK")) {
            strMsg = "Archivo Exportado correctamente";
         } else {
            strMsg = strRes;
         }
         out.clear();
         BufferedInputStream filein = null;
         BufferedOutputStream outputs = null;
         try {
            File file = new File(strPathUsado + strRes);//specify the file path 
            byte b[] = new byte[2048];
            int len = 0;
            filein = new BufferedInputStream(new FileInputStream(file));
            outputs = new BufferedOutputStream(response.getOutputStream());
            response.setHeader("Content-Length", "" + file.length());
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment;filename=" + strRes.replace(" ", "_"));
            response.setHeader("Content-Transfer-Encoding", "binary");
            while ((len = filein.read(b)) > 0) {
               outputs.write(b, 0, len);
               outputs.flush();
            }
         } catch (Exception e) {
            out.println(e);
         }
      }
   } else //Validamos si se acabo la sesion del usuario
    if (varSesiones.getIntNoUser() == 0) {
         String strid = request.getParameter("ID");
         if (strid == null) {
            strid = "0";
         }
         if (!strid.equals("0")) {
            out.clearBuffer();//Limpiamos buffer
            if (strid.equals("2") || strid.equals("4") || strid.equals("5")) {
               //respuesta en xml
               String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
               strXML += "<ERROR>" + "";
               strXML += "<msg>LOST_SESSION</msg>";
               strXML += "<ERROR>";
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strXML);//Pintamos el resultado
            } else {
               //respuesta en txt
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println("LOST_SESSION");//Pintamos el resultado
            }
         }
      }
   oConn.close();
%>