<%-- 
    Document   : evalPermisos
         Este jsp recibe una lista de permisos y regresa un xml donde indica cuales son validos y cuales no
         <Access>
            <key id="1" enabled="true" />
            <key id="2" enabled="false" />
         </Access>
    Created on : 26/06/2010, 10:40:48 AM
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
         String strlstKey = request.getParameter("keys");
         if(strlstKey == null)strlstKey = "";
         String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
         strXML += "<Access>";
         if(!strlstKey.trim().equals("")){
            String[] lstKey = strlstKey.split(",");
            boolean[] lstKeyAcces = new boolean[lstKey.length];
            for(int i=0;i<lstKeyAcces.length;i++)lstKeyAcces[i]=false;
            //Busca el valor en la tabla de beneficiarios....
            String strSql = "SELECT PS_ID " +
                    "FROM perfiles_permisos where " +
                    " PS_ID in (" + strlstKey + ") AND  PF_ID = " + varSesiones.getIntIdPerfil() + " ";
            ResultSet rsCombo;
            try {
               rsCombo = oConn.runQuery(strSql, true);
               while (rsCombo.next()) {
                  String strIdPermiso = rsCombo.getString("PS_ID");
                  for(int i=0;i<lstKeyAcces.length;i++){
                     if(strIdPermiso.equals(lstKey[i])){
                        lstKeyAcces[i] = true;
                     }
                  }
               }
               rsCombo.close();
               //Armamos el xml a detalle
               for(int i=0;i<lstKeyAcces.length;i++){
                  if(lstKeyAcces[i]){
                     strXML += "<key id=\"" + lstKey[i] + "\" enabled=\"true\" />\n";
                  }else{
                     strXML += "<key id=\"" + lstKey[i] + "\" enabled=\"false\" />\n";
                  }
               }
            } catch (SQLException ex) {
               ex.fillInStackTrace();

            }
         }
         strXML += "</Access>";
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXML);//Pintamos el resultado
      }else{
      }
      oConn.close();
%>