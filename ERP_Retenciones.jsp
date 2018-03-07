<%-- 
    Document   : ERP_Retenciones
    Created on : 26/06/2014, 11:00:25 AM
    Author     : siweb
--%>

<%@page import="Core.FirmasElectronicas.Opalina"%>
<%@page import="Core.FirmasElectronicas.SATRetenciones"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.Retenciones"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
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
         //Timbrar los recibos de retenciones
         if (strid.equals("1")) {

         }// Fin IF id = 1

         //Cancela los recibos de nomina
         if (strid.equals("2")) {

         }//Fin IF id = 2

         //Enviar por e-mail los recibos de Retenciones
         if (strid.equals("3")) {
            String strFolIni = request.getParameter("folio_ini");
            String strFolFin = request.getParameter("folio_fin");
            int intCopia = 0;
            String strCorreo = request.getParameter("mail_envio");
            if (request.getParameter("copia") != null) {
               try {
                  intCopia = Integer.valueOf(request.getParameter("copia"));
               } catch (NumberFormatException ex) {
                  out.println("copia: " + ex.getMessage());
               }
            }
            //Recuperamos paths de web.xml
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathBase = this.getServletContext().getRealPath("/") + "/";
            //objeto de Retenciones
            Retenciones ret = new Retenciones(oConn, varSesiones, request);
            ret.setStrPATHBase(strPathBase);
            ret.doEnvioMasivo(varSesiones.getIntIdEmpresa(), strFolIni, strFolFin, strCorreo, intCopia,strPathXML);

            String strResult = ret.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado

         }//Fin IF 3

         if (strid.equals("4")) {

            int intIdRetencion = Integer.parseInt(request.getParameter("intIdRetencion"));

            String strSql = "select * from rhh_ret_cat_retenciones where ret_clave = " + intIdRetencion;

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<cat_reten>";

            String strConcepto = "";

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strConcepto = rs.getString("RET_CONCEPTO");

               if (!strConcepto.equals("")) {
                  strXML += "<cat_reten "
                          + " RET_CONCEPTO = \"" + strConcepto + "\"  "
                          + " />";
                  strXML += "</cat_reten>";
               } else {
                  strXML += "<cat_reten "
                          + " RET_CONCEPTO = \"vacio\"  "
                          + " />";
                  strXML += "</cat_reten>";
               }
            }
            rs.close();

            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

         if (strid.equals("5")) {

            int intEMP_NUM = Integer.parseInt(request.getParameter("intEMP_NUM"));
            int EMP_ID = Integer.parseInt(request.getParameter("intEMP_ID"));

            String strSql = "select * from rhh_empleados where EMP_NUM = " + intEMP_NUM + " and EMP_ID = " + EMP_ID;

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<empleado>";

            String RET_RFCRECEP = "";
            String RET_NOMDENRAZSOCR = "";
            String RET_CURPR = "";

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               RET_RFCRECEP = rs.getString("EMP_RFC");
               RET_NOMDENRAZSOCR = rs.getString("EMP_NOMBRE");
               RET_CURPR = rs.getString("EMP_CURP");

               if (!RET_RFCRECEP.equals("") && !RET_NOMDENRAZSOCR.equals("") && !RET_CURPR.equals("")) {
                  strXML += "<empleado "
                          + " RET_RFCRECEP = \"" + RET_RFCRECEP + "\"  "
                          + " RET_NOMDENRAZSOCR = \"" + RET_NOMDENRAZSOCR + "\"  "
                          + " RET_CURPR = \"" + RET_CURPR + "\"  "
                          + " />";
                  strXML += "</empleado>";
               } else {
                  strXML += "<empleado "
                          + " RET_RFCRECEP = \"vacio\"  "
                          + " RET_NOMDENRAZSOCR = \"vacio\"  "
                          + " RET_CURPR = \"vacio\"  "
                          + " />";
                  strXML += "</empleado>";
               }
            }
            rs.close();

            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Folio automatico

         if (strid.equals("6")) {
            Retenciones Ret = new Retenciones(oConn, varSesiones, request);
            String strNvoFolio = Ret.doGeneraFolioImportacion();
            out.clearBuffer();//Limpiamos buffer             
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strNvoFolio);//Pintamos el resultado
         }
         //Timbramos los recibos
         if (strid.equals("7")) {
            //Recuperamos parametros
            String strFolioIni = request.getParameter("nom_folio1");
            String strFolioFin = request.getParameter("nom_folio2");

            //Recuperamos paths de web.xml
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
            //Password
            String strPassB64 = this.getServletContext().getInitParameter("SecretWord");
            Opalina opa = new Opalina();
            String strMyPassSecret = opa.DesEncripta(strPassB64, "dWAM1YhbGAeu7CTULai4eQ==");
            String strResult = SATRetenciones.TimbradoMasivo(strFolioIni, strFolioFin,
                    varSesiones.getIntIdEmpresa(), varSesiones, strMyPassSecret,
                    strPathXML, strPathPrivateKeys,
                    strPathPrivateKeys, oConn);

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado
         }
         //Cancelar los recibos
         if (strid.equals("8")) {
            int intIdAnular = 0;
            //Recuperamos el parametro
            if (request.getParameter("RET_ID") != null) {
               try {
                  intIdAnular = Integer.valueOf(request.getParameter("RET_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Recuperamos paths de web.xml
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");

            //Password
            String strPassB64 = this.getServletContext().getInitParameter("SecretWord");
            Opalina opa = new Opalina();
            String strMyPassSecret = opa.DesEncripta(strPassB64, "dWAM1YhbGAeu7CTULai4eQ==");
            
            String strResult = SATRetenciones.CancelaComprobanteRetencion(intIdAnular, strMyPassSecret, varSesiones.getIntIdEmpresa(), 
                    strPathPrivateKeys, strPathXML, oConn,varSesiones);
            
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado

         }

      }//Fin if strId != null
      else {
         out.println("SIN ACCESO");
      }

   }//Fin If VarSesiones
   oConn.close();
%>

