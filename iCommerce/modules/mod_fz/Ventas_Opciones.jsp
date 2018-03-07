<%@page import="com.mx.siweb.ui.web.ventas.Vta_Tickets"%>
<%@page import="com.mx.siweb.ui.web.ventas.Vta_Facturas"%>
<%@page import="com.mx.siweb.ui.web.ventas.Vta_Pedidos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
      String strid = request.getParameter("ID");
      if (strid != null) {
         if (strid.equals("1")) {

            Fechas Fecha = new Fechas();
            String FOLIO = request.getParameter("FAC_FOLIO");
            String FECHA_INI = request.getParameter("FECHA_INICIAL");
            String FECHA_FIN = request.getParameter("FECHA_FINAL");
            String RADIO = request.getParameter("RADIO");
            String ID = request.getParameter("ID_C");
            String strRes = "";

            if (FECHA_INI != null && FECHA_FIN != null) {
               FECHA_INI = Fecha.FormateaBD(FECHA_INI, "-");
               FECHA_FIN = Fecha.FormateaBD(FECHA_FIN, "-");

               if (RADIO.equals("1")) {
                  Vta_Pedidos PD = new Vta_Pedidos(varSesiones);
                  strRes = PD.getDataPedidos(oConn, FOLIO, FECHA_INI, FECHA_FIN, ID);
               }
               if (RADIO.equals("2")) {
                  Vta_Facturas FAC = new Vta_Facturas(varSesiones);
                  strRes = FAC.getDataFacturas(oConn, FOLIO, FECHA_INI, FECHA_FIN, ID);
               }
               if (RADIO.equals("3")) {
                  Vta_Tickets TCK = new Vta_Tickets(varSesiones);
                  strRes = TCK.getDataTickets(oConn, FOLIO, FECHA_INI, FECHA_FIN, ID);
               }
            }


            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
      }
   }
%>