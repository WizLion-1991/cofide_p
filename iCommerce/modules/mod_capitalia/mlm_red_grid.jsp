<%-- 
    Document   : mlm_red_grid
    Created on : 23-abr-2013, 16:33:47
    Author     : aleph_79
--%>
<%@page import="java.sql.SQLException"%>
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
            String strRes = doXMLGrid(varSesiones.getintIdCliente(), ct_nombre, intCT_ID, intCT_UPLINE, intCT_NIVELRED,oConn);
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

<%!
 /**
    * Genera el xml para el control jqgrid tree
    *
    * @param intNodoId Es el nodo raiz a obtener
    * @param strNombre Es el nombre del cliente que se esta buscando
    * @param intCT_ID  Es el id
    * @param intCT_UPLINE  Es el id del upline
    * @param intNivelRed Es el nivel de red
    * @return Regresa el xml de la red
    */
   public String doXMLGrid(int intNodoId,String strNombre, int intCT_ID, int intCT_UPLINE, int intNivelRed,Conexion oConn) {
       String strXMLHEAD = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
      //comSIWeb.Utilerias.UtilXml utilXml = new comSIWeb.Utilerias.UtilXml();
       Fechas fecha = new Fechas();
      StringBuilder strXML = new StringBuilder("");
      strXML.append(strXMLHEAD);
      strXML.append("<rows>");
      strXML.append("<page>1</page>");
      String strFiltro  ="";
      if(!strNombre.isEmpty()){
         strFiltro  = " AND CT_RAZONSOCIAL LIKE '%" + strNombre + "%'";
      }
      if(intCT_ID != 0 ){
         strFiltro  = " AND vta_cliente.CT_ID = " + intCT_ID + " ";
      }
      if(intCT_UPLINE != 0 ){
         strFiltro  = " AND vta_cliente.CT_UPLINE = " + intCT_UPLINE + " ";
      }
      if(intNivelRed != 0 ){
         strFiltro  = " AND vta_cliente.CT_NIVELRED = " + intNivelRed + " ";
      }
      //Consultamos la descendencia de este cliente
      String strSql = "SELECT count(CT_ID) as cuantos FROM vta_cliente WHERE "
              + " CT_SPONZOR = " + intNodoId + "  " + strFiltro
              + " ORDER BY CT_ARMADONUM";
      try {
         //Calculamos cuantyos
         ResultSet rs = oConn.runQuery(strSql, true);
         int intCuantos = 0;
         while (rs.next()) {
            intCuantos = rs.getInt("cuantos");
         }
         rs.close();
         strXML.append("<records>").append(intCuantos).append("</records>");
         //Obtiene la lista de la red
         strSql = "SELECT vta_cliente.CT_ID,CT_UPLINE,CT_RAZONSOCIAL,CT_TELEFONO1,vta_cliente.SC_ID,SC_NUM,"
                 + "CT_TELEFONO2,CT_EMAIL1,CT_ARMADODEEP,CT_ARMADOINI,CT_ARMADOFIN"
                 + ",CT_PPUNTOS,CT_PNEGOCIO,CT_GPUNTOS,CT_GNEGOCIO,CT_COMISION,CT_NIVELRED "
                 + ",CT_NOMBRE,CT_APATERNO,CT_AMATERNO,CT_FECHAREG"
                 + " FROM vta_cliente,vta_sucursal WHERE "
                 + " CT_SPONZOR = " + intNodoId
                 + " AND vta_cliente.SC_ID = vta_sucursal.SC_ID " + strFiltro
                 + " ORDER BY CT_ARMADONUM";
         rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            String strIngreso = fecha.FormateaDDMMAAAA(rs.getString("CT_FECHAREG"), "/") ;
            strXML.append("<row>");
            strXML.append("<cell>").append(rs.getInt("CT_ID")).append("</cell>");
            strXML.append("<cell>").append(rs.getString("CT_RAZONSOCIAL")).append("</cell>");
            strXML.append("<cell>").append(strIngreso).append("</cell>");
            strXML.append("</row>");
         }
         rs.close();
         strXML.append("</rows> ");
      } catch (SQLException ex) {
         System.out.println("Error en la consulta de la red " + ex.getMessage() + " " + ex.getSQLState());
      }
      return strXML.toString();
   }
%>