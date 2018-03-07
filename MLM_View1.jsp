<%-- 
    Document   : MLM_View1
    Generar objetos json para visualizar la red desde el backoffice
    Created on : 06-sep-2015, 14:47:59
    Author     : ZeusGalindo
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
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
      String strid = request.getParameter("Opt");
      if (strid == null) {
         strid = "0";
      }
      // <editor-fold defaultstate="collapsed" desc="Mostrar JSon de red">
      if (strid.equals("1")) {
         String strIdNodo = request.getParameter("id");
         //Nodos por mostrar
         JSONArray listNodos = new JSONArray();
         if (strIdNodo.equals("#")) {
            //Colocamos los nodos iniciales
            String strSql = "select CT_ID,CT_RAZONSOCIAL,(select count(b.CT_ID) from vta_cliente as b where b.CT_UPLINE = vta_cliente.CT_ID ) as cuantos from vta_cliente where CT_UPLINE = 1 ";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               JSONObject objJsonNodo1 = new JSONObject();
               objJsonNodo1.put("id", rs.getString("CT_ID"));
               objJsonNodo1.put("text", rs.getString("CT_RAZONSOCIAL") + "(" + rs.getString("CT_ID") + ")");
               if (rs.getDouble("cuantos") > 0) {
                  objJsonNodo1.put("children", true);
               } else {
                  objJsonNodo1.put("children", false);
               }
               listNodos.put(objJsonNodo1);
            }
            rs.close();
         } else {
            //Regresamos los nodos del cliente seleccionado
            String strSql = "select CT_ID,CT_RAZONSOCIAL,(select count(b.CT_ID) from vta_cliente as b where b.CT_UPLINE = vta_cliente.CT_ID ) as cuantos from vta_cliente where CT_UPLINE =  " + strIdNodo;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               JSONObject objJsonNodo1 = new JSONObject();
               objJsonNodo1.put("id", rs.getString("CT_ID"));
               objJsonNodo1.put("text", rs.getString("CT_RAZONSOCIAL") + "(" + rs.getString("CT_ID") + ")");
               if (rs.getDouble("cuantos") > 0) {
                  objJsonNodo1.put("children", true);
               } else {
                  objJsonNodo1.put("children", false);
               }
               listNodos.put(objJsonNodo1);
            }
            rs.close();
         }
         //Limpiamos
         out.clearBuffer();
         atrJSP.atrJSP(request, response, true, false, true);//Definimos atributos para el XML
         out.println(listNodos.toString());
      }
   } else {
      //Validamos si se acabo la sesion del usuario
      if (varSesiones.getIntNoUser() == 0) {
         String strid = request.getParameter("Opt");
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
   }
   oConn.close();
%>