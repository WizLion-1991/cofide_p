<%-- 
    Document   : ERP_UPPrivateKey
    Created on : 23/07/2010, 10:48:14 PM
    Author     : zeus
--%>
<%@page import="Core.FirmasElectronicas.SATUpFilePass"%>
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
      if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
         //Inicializamos parametros
         String strmsg = "";
         //Si la peticion no fue nula proseguimos
         atrJSP.atrJSP(request, response, true, false);
         out.clearBuffer();
         //Instanciamos objeto para subir archivos....
         SATUpFilePass UpFile = new SATUpFilePass();
         try{
            String strResp = UpFile.savePrivateKey(request, this.getServletContext(), oConn);
            if(strResp.equals("OK")){
               strmsg = "El archivo de Firma electronica ha sido almacenado en el servidor.";
            }else{
               strmsg = strResp;
            }
         }catch(Exception ex){
            System.out.println("error " + ex.getMessage());
         }
         out.println("<script> alert(\"" + strmsg + "\");</script>");

      } else {
      }
      oConn.close();
%>