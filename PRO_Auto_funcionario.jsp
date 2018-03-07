<%-- 
    Document   : auto_funcionario
    Created on : 2/04/2013, 12:10:46 PM
    Author     : SIWEB
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
            String strSql = "SELECT F_ID,F_NOMBRE, F_APATERNO, F_AMATERNO " +
                    "FROM cat_funcionario where " +
                    "F_NOMBRE LIKE '" + strValorBuscar + "%'  ORDER BY F_NOMBRE";
            ResultSet rsCombo;
            try {
               rsCombo = oConn.runQuery(strSql, true);
               while (rsCombo.next()) {
                  String strNumero = rsCombo.getString("F_ID");
                  String strNombre = rsCombo.getString("F_NOMBRE") + rsCombo.getString("F_APATERNO") + rsCombo.getString("F_AMATERNO");
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
