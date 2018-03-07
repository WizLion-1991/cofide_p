<%-- 
    Document   : CIP_DamePantalla
    Created on : 16/02/2010, 06:02:51 PM
    Author     : zeus
--%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.apache.struts.util.*" %>
<%@ page import="com.SIWeb.struts.SelEmpresaAction" %>
<%
      /*Obtenemos las variables de sesion*/
      VariableSession varSesiones = new VariableSession(request);
      varSesiones.getVars();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(),this.getServletContext());
      oConn.open();
      //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
      Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
      if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
         /*Definimos parametros de la aplicacion*/
         String strOpt = request.getParameter("Opt");
         String strAtr = request.getParameter("atr");
         if (strOpt == null) {
            strOpt = "";
         }
         if (strAtr == null) {
            strAtr = "";
         }
         /*Vemos si es la pantalla de admin de la cuenta*/
         String strParams = "";
         if (strOpt.equals("CUENTA")) {
            String strSql = "Select ctam_id FROM usuarios WHERE id_usuarios = '" + varSesiones.getIntNoUser() + "' and UsuarioActivo = 1 ";
            ResultSet rs;
            try {
               rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  strParams = rs.getString("ctam_id");
               }
               rs.close();
            } catch (SQLException ex) {
               ex.fillInStackTrace();
            }
         }
         /*Generamos el objeto formulario para nos de el XML de la pantalla*/
         CIP_Form form = new CIP_Form();
         form.setRequest(request);
         String strXML = form.DameCamposSc(strOpt, strParams, oConn, varSesiones);
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }else{
      }
      oConn.close();
%>