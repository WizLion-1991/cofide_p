<%-- 
    Document   : upfilemulti
    Created on : 11/01/2016, 06:25:54 PM
    Author     : smarin
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="ERP.MovProveedor"%>
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
    String strUUID = "";
    double dblSubTotal = 0.0;
    double dblIVA = 0.0;
    String strRFCEmisor = "";
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strPathBase = this.getServletContext().getRealPath("/");
        String strSeparator = System.getProperty("file.separator");
        if (strSeparator.equals("\\")) {
            strSeparator = "/";
            strPathBase = strPathBase.replace("\\", "/");
        }
        
        //Buscamos si tenemos un credito
         int intIdCredito = 0;
        double dblMontoCredito = 0;
        String strSql = "select CTO_ID,(select cat_monto.MTO_MCREDITO from  cat_monto where cat_monto.MTO_ID = cat_credito.MTO_ID ) as monto from cat_credito where ct_id = " + varSesiones.getintIdCliente() + " and CTO_AUTORIZADO = 1 ";
        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            intIdCredito = rs.getInt("CTO_ID");
            dblMontoCredito = rs.getDouble("monto");
        }
        //String strPathBaseShort = "iCommerce" + strSeparator + "images" + strSeparator + "ecomm";
        //Si la peticion no fue nula proseguimos
        atrJSP.atrJSP(request, response, true, false);
        out.clearBuffer();

        Fechas fecha = new Fechas();

        //Instanciamos objeto para subir archivos....
        //Validamos si la peticion se genero con enctype
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
                    System.out.println(fileName);
                    if (fileName.toLowerCase().endsWith(".pdf")) {
                        //Separamos el nombre del archivo                        
                        if (fileName.contains("\\") && request.getHeader("User-Agent").contains("MSIE")) {
                            fileName = fileName.substring(fileName.lastIndexOf("\\") + 1, fileName.length());
                        }
                        //Asignamos el nombre del archivo
                        String strPathUsado = strPathBase + "document" + strSeparator + "credito" + strSeparator + fileName;
                        //Guardamos el archivo

                        System.out.println(strPathUsado);
                        File saveTo = new File(strPathUsado);

                        String strInsert = "INSERT INTO cat_documentacion (DMN_NOMBRE, DMN_PATHIMGFORM, CTO_ID) values ('" + fileName + "', '" + strPathUsado + "', '" + intIdCredito + "') ";
                        oConn.runQueryLMD(strInsert);

                        if (!saveTo.exists()) {
                            fileItem.write(saveTo);
                            //iNSERTAR registro en bd
                        } else {
                            strerror = "Ya existe ese archivo.";
                        }
                        strmsg = strPathUsado;

                        strmsg = "";
                        if (strmsg.equals("OK")) {
                            strmsg = "ARCHIVO CARGADO EXITOSAMENTE";
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