<%-- 
    Document   : mlm_red_grid
    Created on : 23-abr-2013, 16:33:47
    Author     : aleph_79
--%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mx.siweb.mlm.utilerias.VistaRed"%>
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
            //Cargamso parametros
            String ct_nombre = request.getParameter("ct_nombre");
            String ct_id = request.getParameter("ct_id");
            String ct_upline = request.getParameter("ct_upline");
            String ct_nivelred = request.getParameter("ct_nivelred");
            if (ct_nombre == null) {
               ct_nombre = "";
            }
            if (ct_id == null) {
               ct_id = "0";
            }
            if (ct_upline == null) {
               ct_upline = "0";
            }
            int intCT_ID = 0;
            int intCT_UPLINE = 0;
            int intCT_NIVELRED = 0;
            try {
               intCT_ID = Integer.valueOf(ct_id);
               intCT_UPLINE = Integer.valueOf(ct_upline);
               intCT_NIVELRED = Integer.valueOf(ct_nivelred);
            } catch (NumberFormatException ex) {
            }
            //clase para obtener el xml del grid
            VistaRed red = new VistaRed(oConn);
            String strRes = red.doXMLGrid(varSesiones.getintIdCliente(), ct_nombre, intCT_ID, intCT_UPLINE, intCT_NIVELRED);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         if (strid.equals("2")) {
            //Cargamso parametros
            String ct_id = request.getParameter("ct_id");
            if (ct_id == null) {
               ct_id = "0";
            }
            //Validamos que el nodo pertenezca a su red
            /*boolean bolValido = Redes.esPartedelaRed(oConn, "vta_cliente", "CT_UPLINE", "CT_ID", varSesiones.getintIdCliente(), intNodoHijo);
             if (bolValido) {*/
            int intCT_ID = 0;
            try {
               intCT_ID = Integer.valueOf(ct_id);
            } catch (NumberFormatException ex) {
            }
            //Obtenemos los datos del cliente
            StringBuilder strXML = new StringBuilder();
            String strSql = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS,CT_PNEGOCIO,"
                    + " CT_GPUNTOS,CT_GNEGOCIO,CT_COMISION,CT_NIVELRED from vta_cliente where CT_UPLINE = " + intCT_ID;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML.append("<div>P.Personales:" + NumberString.FormatearDecimal(rs.getDouble("CT_PPUNTOS"), 2)  + "</div>");
               strXML.append("<div>VN.Personal:" + NumberString.FormatearDecimal(rs.getDouble("CT_PNEGOCIO"), 2) + "</div>");
               strXML.append("<div>P.Grupal:" + NumberString.FormatearDecimal(rs.getDouble("CT_GPUNTOS"), 2) + "</div>");
               strXML.append("<div>VN.Grupal:" + NumberString.FormatearDecimal(rs.getDouble("CT_GNEGOCIO"), 2) + "</div>");
               strXML.append("<div>Comision:" + NumberString.FormatearDecimal(rs.getDouble("CT_COMISION"), 2) + "</div>");
               strXML.append("<div>Nivel de Red:" + rs.getInt("CT_NIVELRED") + "</div>");
               
            }
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
      }
   }
%>