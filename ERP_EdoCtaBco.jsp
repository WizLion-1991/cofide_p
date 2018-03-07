<%-- 
    Document   : ERP_EdoCtaBco
Genera las operaciones para alimentar la pantalla de estado de cuenta de bancos
    Created on : 12-dic-2013, 12:33:57
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.EstadoCuentaBanco"%>
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
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         EstadoCuentaBanco edo = new EstadoCuentaBanco(oConn);
         //Regresa los periodos
         if (strid.equals("1")) {
            String strXML = edo.getPeriodos();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresa la informacion general de un cliente
         if (strid.equals("2")) {
            int intIdBco = 0;
            if (request.getParameter("BC_ID") != null) {
               try {
                  intIdBco = Integer.valueOf(request.getParameter("BC_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            String strXML = edo.getInfoGral(intIdBco);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresa los saldos globales de un periodo
         if (strid.equals("3")) {
            String strPeriodo = request.getParameter("Periodo");
            int intIdBco = 0;
            int intMoneda = 0;
            if (request.getParameter("BC_ID") != null) {
               try {
                  intIdBco = Integer.valueOf(request.getParameter("BC_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("MON_ID") != null) {
               try {
                  intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
               } catch (NumberFormatException ex) {
               }
            }

            String strXML = edo.getInfoSaldos(intIdBco, intMoneda, strPeriodo);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresa los documentos de un periodo
         if (strid.equals("4")) {
            String strPeriodo = request.getParameter("Periodo");
            int intIdBco = 0;
            int intMoneda = 0;
            if (request.getParameter("BC_ID") != null) {
               try {
                  intIdBco = Integer.valueOf(request.getParameter("BC_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("MON_ID") != null) {
               try {
                  intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            String strXML = edo.getSaldosPeriodos(intIdBco, intMoneda, strPeriodo);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   

         }
         /*
         //Regresa el historial de movimiento de una factura
         if (strid.equals("5")) {
            int intIdBco = 0;
            int intMoneda = 0;
            int intIdFactura = 0;
            if (request.getParameter("BC_ID") != null) {
               try {
                  intIdBco = Integer.valueOf(request.getParameter("BC_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("MON_ID") != null) {
               try {
                  intMoneda = Integer.valueOf(request.getParameter("MON_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            if (request.getParameter("FAC_ID") != null) {
               try {
                  intIdFactura = Integer.valueOf(request.getParameter("FAC_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            String strXML = edo.getHistorialMovimiento(intIdBco, intMoneda, intIdFactura);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   

         }*/
      }
   } else {
   }
   oConn.close();
%>