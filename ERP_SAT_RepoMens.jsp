<%-- 
    Document   : ERP_SAT_RepoMens
    Emite el reporte mensual para enviar al SAT
    Created on : 17/09/2010, 12:37:19 PM
    Author     : zeus
--%>
<%@ page import="comSIWeb.Utilerias.NumberString"%>
<%@ page import="comSIWeb.Utilerias.Fechas"%>
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
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      /*Definimos parametros de la aplicacion*/
      String strMes = request.getParameter("Mes");
      if (strMes == null) {
         strMes = "";
      }
      String strAnio = request.getParameter("Anio");
      if (strAnio == null) {
         strAnio = "";
      }
      int intIdEmpresa = 0;
      if (request.getParameter("Empresa") != null) {
         intIdEmpresa = Integer.valueOf(request.getParameter("Empresa"));
      }
      //Libreria para las fechas
      Fechas fecha = new Fechas();
      //Nombre del archivo a enviar
      String strNomFile = "";
      String strRFC = "";
      //Obtenemos datos de la empresa
      String strSql = "SELECT EMP_RFC,EMP_RAZONSOCIAL "
              + "FROM vta_empresas where "
              + "EMP_ID = '" + intIdEmpresa + "'  ";
      ResultSet rsCombo;
      try {
         rsCombo = oConn.runQuery(strSql, true);
         while (rsCombo.next()) {
            strRFC = rsCombo.getString("EMP_RFC");
         }
         rsCombo.close();
      } catch (SQLException ex) {
         ex.fillInStackTrace();

      }
      /*
      El nombre del archivo del informe mensual se compone de:
       * número del esquema 1
       * RFC del emisor. XXXX010101000
       * Mes y Año a ser reportado. mmyyyy
       */
      strNomFile = "1" + strRFC + strMes + strAnio;

      //Contenido del reporte para enviar al SAT
      String strTXT = "";
      boolean bolExistenVentas = false;
      //Obtenemos informacion de las ventas de esta empresa
      strSql = "SELECT FAC_RFC,FAC_FOLIO,FAC_FECHA,FAC_HORA,FAC_IMPORTE,"
              + "FAC_IMPUESTO1,FAC_ANULADA,FAC_FECHAANUL,FAC_SERIE,"
              + "FAC_NOAPROB,FAC_FECHAAPROB,FAC_TASAPESO,"
              + "FAC_NUMPEDI,FAC_FECHAPEDI,FAC_ADUANA"
              + " FROM vta_facturas "
              + " WHERE vta_facturas.EMP_ID = " + intIdEmpresa
              + " AND (LEFT(FAC_FECHA,6) = '" + strAnio + strMes + "' OR "
              + " LEFT(FAC_FECHAANUL,6) = '" + strAnio + strMes + "')"
              + " AND FAC_NOAPROB<>'';";
      try {
         rsCombo = oConn.runQuery(strSql, true);

         //Contamos las filas
         int intFilasReal = 0;
         while (rsCombo.next()) {
            intFilasReal++;
         }
         rsCombo.beforeFirst();
         //Generamos el archivo
         int intFilas = 0;
         while (rsCombo.next()) {
            String strFila = "|";
            intFilas++;
            bolExistenVentas = true;
            /*
            Layout de las ventas
             * 1 RFC del cliente
             * 2 Serie
             * 3 Folio del Comprobante Fiscal
             * 4 Número de Aprobación yyyy + número
             * 5 Fecha y hora de expedición dd/mm/yyyy hh:mm:ss
             * 6 Monto de la operación
             *       13 caracteres sin formato. 10 números, un punto decimal y
            2 números a la derecha que indican la fracción.
             * 7 Monto del Impuesto
             * 8 Estado del comprobante
             * 9 Efecto de Comprobante
             * 10 Pedimento
             * 11 Fecha de Pedimento
             * 12 Aduana
             */
            int intFolio = Integer.valueOf(rsCombo.getString("FAC_FOLIO"));
            strFila += rsCombo.getString("FAC_RFC") + "|";
            strFila += rsCombo.getString("FAC_SERIE") + "|";
            strFila += intFolio + "|";
            strFila += rsCombo.getString("FAC_FECHAAPROB").substring(0, 4) + rsCombo.getString("FAC_NOAPROB") + "|";
            strFila += fecha.FormateaDDMMAAAA(rsCombo.getString("FAC_FECHA"), "/") + " " + rsCombo.getString("FAC_HORA") + "|";
            strFila += NumberString.FormatearDecimal(rsCombo.getDouble("FAC_IMPORTE") * rsCombo.getDouble("FAC_TASAPESO"), 2).replace(",", "") + "|";
            strFila += NumberString.FormatearDecimal(rsCombo.getDouble("FAC_IMPUESTO1") * rsCombo.getDouble("FAC_TASAPESO"), 2).replace(",", "") + "|";
            if (rsCombo.getInt("FAC_ANULADA") == 0) {
               strFila += "1|";
            } else {
               strFila += "0|";
            }
            strFila += "I|";//9
            strFila += rsCombo.getString("FAC_NUMPEDI") + "|";//10
            if (rsCombo.getString("FAC_FECHAPEDI").isEmpty()) {
               strFila += rsCombo.getString("FAC_FECHAPEDI") + "|";
            } else {
               if(rsCombo.getString("FAC_FECHAPEDI").length() ==8){
                  strFila += fecha.FormateaDDMMAAAA(rsCombo.getString("FAC_FECHAPEDI"), "/") + "|";
               }else{
                  strFila += rsCombo.getString("FAC_FECHAPEDI") + "|";
               }
            }
            if (intFilas < intFilasReal) {
               strFila += rsCombo.getString("FAC_ADUANA") + "|" + "\n";//12
            } else {
               strFila += rsCombo.getString("FAC_ADUANA") + "|" + "";//12
            }
            strTXT += strFila;
         }
         rsCombo.close();
      } catch (SQLException ex) {
         ex.fillInStackTrace();

      }
      //Obtenemos la informacion de las notas de credito de la empresa
      strSql = "SELECT NC_RFC,NC_FOLIO,NC_FECHA,NC_HORA,NC_IMPORTE,"
              + "NC_IMPUESTO1,NC_ANULADA,NC_FECHAANUL,NC_SERIE,NC_NOAPROB,NC_FECHAAPROB,NC_TASAPESO"
              + " FROM vta_ncredito "
              + " WHERE vta_ncredito.EMP_ID = " + intIdEmpresa
              + " AND (LEFT(NC_FECHA,6) = '" + strAnio + strMes + "' OR "
              + " LEFT(NC_FECHAANUL,6) = '" + strAnio + strMes + "');";
      try {
         rsCombo = oConn.runQuery(strSql);
         //Contamos las filas
         int intFilasReal = 0;
         while (rsCombo.next()) {
            intFilasReal++;
         }
         rsCombo.beforeFirst();
         //Generamos el archivo
         int intFilas = 0;
         while (rsCombo.next()) {
            String strFila = "|";
            if (bolExistenVentas && intFilas == 0) {
               strFila = "\n|";
            }
            intFilas++;
            /*
            Layout de las ventas
             * 1 RFC del cliente
             * 2 Serie
             * 3 Folio del Comprobante Fiscal
             * 4 Número de Aprobación yyyy + número
             * 5 Fecha y hora de expedición dd/mm/yyyy hh:mm:ss
             * 6 Monto de la operación
             *       13 caracteres sin formato. 10 números, un punto decimal y
            2 números a la derecha que indican la fracción.
             * 7 Monto del Impuesto
             * 8 Estado del comprobante
             * 9 Efecto de Comprobante
             * 10 Pedimento
             * 11 Fecha de Pedimento
             * 12 Aduana
             */
            int intFolio = Integer.valueOf(rsCombo.getString("NC_FOLIO"));
            strFila += rsCombo.getString("NC_RFC") + "|";
            strFila += rsCombo.getString("NC_SERIE") + "|";
            strFila += intFolio + "|";
            strFila += rsCombo.getString("NC_FECHAAPROB").substring(0, 4) + rsCombo.getString("NC_NOAPROB") + "|";
            strFila += fecha.FormateaDDMMAAAA(rsCombo.getString("NC_FECHA"), "/") + " " + rsCombo.getString("NC_HORA") + "|";
            strFila += NumberString.FormatearDecimal(rsCombo.getDouble("NC_IMPORTE") * rsCombo.getDouble("NC_TASAPESO"), 2).replace(",", "") + "|";
            strFila += NumberString.FormatearDecimal(rsCombo.getDouble("NC_IMPUESTO1") * rsCombo.getDouble("NC_TASAPESO"), 2).replace(",", "") + "|";
            if (rsCombo.getInt("NC_ANULADA") == 0) {
               strFila += "1|";
            } else {
               strFila += "0|";
            }
            strFila += "E|";//9
            strFila += "|";//10
            strFila += "|";//11
            if (intFilas < intFilasReal) {
               strFila += "|" + "\n";//12
            } else {
               strFila += "|" + "";//12
            }
            strTXT += strFila;
         }
         rsCombo.close();
      } catch (SQLException ex) {
         ex.fillInStackTrace();
         System.out.println(" strFila " + ex);
      }
      
      out.clearBuffer();//Limpiamos buffer
      response.setContentType("text/plain");
      response.setHeader("content-disposition", "attachment; filename=" + strNomFile + ".txt");
      response.setHeader("cache-control", "no-cache");
      //text/plain
      out.println(strTXT);//Pintamos el resultado
   } else {
   }
   oConn.close();
%>