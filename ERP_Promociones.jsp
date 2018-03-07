<%-- 
    Document   : ERP_Promociones
    Este jsp se encarga de las operaciones con las promociones
    Created on : 23-mar-2013, 12:42:35
    Author     : aleph_79
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.promociones.PromocionesGenerator"%>
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
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         // Obtiene el listado de promociones activas 
         if (strid.equals("1")) {
            PromocionesGenerator promociones = new PromocionesGenerator(oConn);
            promociones.cargaPromociones();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(promociones.getXml());//Pintamos el resultado
         }
         // Calcula las variables del cliente
         if (strid.equals("2")) {
            //Recuperamos parametros
            String strCT_ID = request.getParameter("CT_ID");
            String strSC_ID = request.getParameter("SC_ID");
            String strVARS_ID = request.getParameter("VARS_ID");
            String strVARS_VAR = request.getParameter("VARS_VAR");
            String strVARS_PROM = request.getParameter("VARS_PROM");
            //Validamos nulos
            if (strCT_ID == null) {
               strCT_ID = "0";
            }
            if (strSC_ID == null) {
               strSC_ID = "0";
            }
            if (strVARS_ID == null) {
               strVARS_ID = "";
            }
            if (strVARS_VAR == null) {
               strVARS_VAR = "";
            }
            if (strVARS_PROM == null) {
               strVARS_PROM = "";
            }
            PromocionesGenerator promociones = new PromocionesGenerator(oConn);
            String strXML = promociones.calculaVarsCte(strCT_ID, strSC_ID, strVARS_ID, strVARS_VAR, strVARS_PROM);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         // Calcula las variables del producto
         if (strid.equals("3")) {
            //Recuperamos parametros
            String strCT_ID = request.getParameter("CT_ID");
            String strSC_ID = request.getParameter("SC_ID");
            String strPR_ID = request.getParameter("PR_ID");
            String strVARS_ID = request.getParameter("VARS_ID");
            String strVARS_VAR = request.getParameter("VARS_VAR");
            String strVARS_PROM = request.getParameter("VARS_PROM");
            //Validamos nulos
            if (strCT_ID == null) {
               strCT_ID = "0";
            }
            if (strSC_ID == null) {
               strSC_ID = "0";
            }
            if (strPR_ID == null) {
               strPR_ID = "0";
            }
            if (strVARS_ID == null) {
               strVARS_ID = "";
            }
            if (strVARS_VAR == null) {
               strVARS_VAR = "";
            }
            if (strVARS_PROM == null) {
               strVARS_PROM = "";
            }
            PromocionesGenerator promociones = new PromocionesGenerator(oConn);
            String strXML = promociones.calculaVarsCte(strCT_ID, strSC_ID, strVARS_ID, strVARS_VAR, strVARS_PROM);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

         if (strid.equals("4")) {
            String strRes = "";
            String strId = request.getParameter("idOferta");
            String strPromId = request.getParameter("PROM_ID");
            boolean bolExist = false;
            try {
               //buscamos si ya existe el regimen para la empresa
               String strSelect = "select * from vta_promo_link_consecuente where PROM_ID = " + strPromId
                       + " and PCO_ID=" + strId;

               ResultSet rs = oConn.runQuery(strSelect);
               while (rs.next()) {
                  bolExist = true;//si existe ponemos verdadero
                  strRes = "NO";
               }
               rs.close();
               if (bolExist == false) {
                  //SACAMOS LAS PÀRTIDAS CORRESPONDIENTES AL PEDIDO
                  String strInsert = "INSERT INTO vta_promo_link_consecuente(PROM_ID,PCO_ID)"
                          + " VALUES(" + strPromId + "," + strId + ")";

                  oConn.runQueryLMD(strInsert);
                  strRes = "OK";
               }
            } catch (Exception ex) {
               ex.fillInStackTrace();

            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado

         }//Fin IF 4

         if (strid.equals("5")) {
            String strIdProm = request.getParameter("PROM_ID");// es el id de la empresa
            int intCon = 0;
            String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXMLData += "<promociones>";
            try {
               //SACAMOS LAS PÀRTIDAS CORRESPONDIENTES AL PEDIDO
               String strSelect = "select vta_promo_link_consecuente.PROML_ID,vta_promo_link_consecuente.PROM_ID,vta_promo_link_consecuente.PCO_ID, "
                       + " vta_promo_consecuente.PCO_ID,vta_promo_consecuente.PCO_DESCRIPCION "
                       + " from vta_promo_link_consecuente join vta_promo_consecuente "
                       + " on vta_promo_link_consecuente.PCO_ID = vta_promo_consecuente.PCO_ID "
                       + " where vta_promo_link_consecuente.PROM_ID =" + strIdProm;

               ResultSet rs = oConn.runQuery(strSelect);
               while (rs.next()) {
                  strXMLData += "<datos";
                  strXMLData += " PROML_ID=\'" + rs.getString("PROML_ID") + "\'";
                  strXMLData += " PCO_DESCRIPCION=\'" + rs.getString("PCO_DESCRIPCION") + "\'";
                  strXMLData += "/>";
               }

               rs.close();

            } catch (SQLException ex) {
               ex.fillInStackTrace();

            }
            strXMLData += "</promociones>";

            String strRes = strXMLData.toString();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado

         }//Fin IF 5

         if (strid.equals("6")) {
            String strId = request.getParameter("idOfrt");
            try {
               //SACAMOS LAS PÀRTIDAS CORRESPONDIENTES AL PEDIDO
               String strDelete = "DELETE FROM vta_promo_link_consecuente"
                       + " WHERE PROML_ID=" + strId;

               oConn.runQueryLMD(strDelete);

            } catch (Exception ex) {
               ex.fillInStackTrace();

            }
            String strRes = "OK";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }//Fin IF 6
      }
   } else {
   }
   oConn.close();
%>