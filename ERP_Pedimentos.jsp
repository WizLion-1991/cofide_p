<%-- 
    Document   : ERP_Pedimentos
Este jsp realiza las operaciones de los pedimentos
    Created on : 09-oct-2012, 13:57:05
    Author     : aleph_79
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.Pedimentos"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Agrega una cuenta por pagar al pedimento
         if (strid.equals("1")) {
            String strCXP_ID = request.getParameter("CXP_ID");
            String strPED_ID = request.getParameter("PED_ID");
            String strPED_COD = request.getParameter("PED_COD");
            String strTIPO = request.getParameter("TIPO");
            if (strCXP_ID == null) {
               strCXP_ID = "0";
            }
            if (strPED_ID == null) {
               strPED_ID = "0";
            }
            if (strTIPO == null) {
               strTIPO = "1";
            }
            if (strPED_COD == null) {
               strPED_COD = "";
            }
            int intCXP_ID = 0;
            int intPED_ID = 0;
            int intTipoCXP = 0;
            //Conversion
            try {
               intCXP_ID = Integer.valueOf(strCXP_ID);
               intPED_ID = Integer.valueOf(strPED_ID);
               intTipoCXP = Integer.valueOf(strTIPO);
            } catch (NumberFormatException ex) {
            }
            //Mandamos a llamar al objeto de pedimentos
            Pedimentos pedimento = new Pedimentos(oConn, varSesiones);
            pedimento.Init();
            pedimento.setIntPED_ID(intPED_ID);
            pedimento.setStrPedimentoCod(strPED_COD);
            pedimento.setIntCXP_ID(intCXP_ID);
            pedimento.setIntTipoCXP(intTipoCXP);
            pedimento.doTrx();
            String strRes = pedimento.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Borra una cuenta por pagar del pedimento
         if (strid.equals("2")) {
            String strCXP_ID = request.getParameter("CXP_ID");
            if (strCXP_ID == null) {
               strCXP_ID = "0";
            }
            int intCXP_ID = 0;
            //Conversion
            try {
               intCXP_ID = Integer.valueOf(strCXP_ID);
            } catch (NumberFormatException ex) {
            }
            //Mandamos a llamar al objeto de pedimentos
            Pedimentos pedimento = new Pedimentos(oConn, varSesiones);
            pedimento.Init();
            pedimento.setIntCXP_ID(intCXP_ID);
            pedimento.doTrxAnul();
            String strRes = pedimento.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Genera el calculo de la simulación del prorrateo
         if (strid.equals("3")) {
         }
         //Genera el calculo del prorrateo
         if (strid.equals("4")) {
            String strPED_ID = request.getParameter("PED_ID");
            if (strPED_ID == null) {
               strPED_ID = "0";
            }
            int intPED_ID = 0;
            //Conversion
            try {
               intPED_ID = Integer.valueOf(strPED_ID);
            } catch (NumberFormatException ex) {
            }
            //Mandamos a llamar al objeto de pedimentos
            Pedimentos pedimento = new Pedimentos(oConn, varSesiones);
            pedimento.Init();
            pedimento.setIntPED_ID(intPED_ID);
            pedimento.doGeneraProrrateo();
            String strRes = pedimento.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
         }
         //Cancela el calculo del prorrateo
         if (strid.equals("5")) {
            String strPED_ID = request.getParameter("PED_ID");
            if (strPED_ID == null) {
               strPED_ID = "0";
            }
            int intPED_ID = 0;
            //Conversion
            try {
               intPED_ID = Integer.valueOf(strPED_ID);
            } catch (NumberFormatException ex) {
            }
            //Mandamos a llamar al objeto de pedimentos
            Pedimentos pedimento = new Pedimentos(oConn, varSesiones);
            pedimento.Init();
            pedimento.setIntPED_ID(intPED_ID);
            pedimento.doCancelaProrrateo();
            String strRes = pedimento.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
         }
         //Regresa los datos de las cuentas por pagar
         if (strid.equals("6")) {
            String strPED_ID = request.getParameter("PED_ID");
            if (strPED_ID == null) {
               strPED_ID = "0";
            }
            int intPED_ID = 0;
            //Conversion
            try {
               intPED_ID = Integer.valueOf(strPED_ID);
            } catch (NumberFormatException ex) {
            }
            //Mandamos a llamar al objeto de pedimentos
            Pedimentos pedimento = new Pedimentos(oConn, varSesiones);
            pedimento.Init();
            pedimento.setIntPED_ID(intPED_ID);
            String strRes = pedimento.doGeneraListaXMLCXPagar();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }

      }
   }



   oConn.close();
%>