<%-- 
    Document   : ERP_EstadosPais
    Created on : 29/12/2014, 11:21:23 AM
    Author     : siwebmx5
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
      //Inicializamos datos
      Fechas fecha = new Fechas();

      //Obtenemos parametros
      String strid = request.getParameter("ID");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Genera una nueva operacion de pagos en base a la transaccion que nos envian
         if (strid.equals("1")) {
             int intPA_ID = 0;             
             if (request.getParameter("PA_ID") != null) {
               intPA_ID = Integer.valueOf(request.getParameter("PA_ID"));               
             }
             String strSQL = "Select * From estadospais Where PA_ID ="+intPA_ID+ " Order by ESP_NOMBRE asc";
             ResultSet rs = oConn.runQuery(strSQL, true);
             String strNombre = "";
             int intESP_ID = 0;
             String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<Estados>";
            while (rs.next()) {
               strNombre = rs.getString("ESP_NOMBRE");
               intESP_ID = rs.getInt("ESP_ID");
               strXML += "<Estado ";
               strXML += " ESP_ID = \"" + intESP_ID + "\"  ";
               strXML += " ESP_NOMBRE = \"" + strNombre + "\"  ";
               strXML += " />";
            }
            strXML += "</Estados>";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
      }
   }
 %>