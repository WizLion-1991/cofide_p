<%-- 
    Document   : auto_aeconomica
    Created on : 10/04/2013, 06:12:54 PM
    Author     : SIWEB
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
         String strValorBuscar = request.getParameter("q");
         if(strValorBuscar == null)strValorBuscar = "";
         String strXML = "";
         if(!strValorBuscar.trim().equals("")){
            //Busca el valor en la tabla de beneficiarios....
            String strSql = "SELECT AC_ID,AC_NOMBRE " +
                    "FROM cat_actividadeconomica where " +
                    "AC_NOMBRE LIKE '" + strValorBuscar + "%'  ORDER BY AC_NOMBRE";
            ResultSet rsCombo;
            try {
               rsCombo = oConn.runQuery(strSql, true);
               while (rsCombo.next()) {
                  String strNumero = rsCombo.getString("AC_ID");
                  String strNombre = rsCombo.getString("AC_NOMBRE");
                  strXML += strNombre + "|" + strNumero + "\n";
               }
               rsCombo.close();
            } catch (SQLException ex) {
               ex.fillInStackTrace();

            }
         }
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }else{
      }
      oConn.close();
%>
