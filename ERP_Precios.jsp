<%-- 
    Document   : ERP_Precios
    Nos trae los precios de diferentes maneras
    Created on : 6/06/2010, 01:08:36 AM
    Author     : zeus
--%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="ERP.Precios" %>
<%@ page import="ERP.Producto" %>
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
         //Recuperar todos los precios de un producto
         if (strid.equals("1")) {
            String strPr_Id = request.getParameter("PR_ID");
            if (strPr_Id == null) {
               strPr_Id = "0";
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Precios prec = new Precios();
            String strXML = prec.getXML(strPr_Id, oConn, false, 0);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Guardamos todos los precios de un producto
         if (strid.equals("2")) {
            String strPrCodigo = request.getParameter("PR_CODIGO");
            if (strPrCodigo != null) {
               String[] strLstSuc = request.getParameter("LstSuc").split(",");
               String[] strLstNum = request.getParameter("LstNum").split(",");
               String[] strLstPrec = request.getParameter("LstPrec").split(",");
               String[] strLstDesc = request.getParameter("LstDesc").split(",");
               String[] strLstPtos = request.getParameter("LstPtos").split(",");
               String[] strLstPtosC = request.getParameter("LstPtosC").split(",");
               String[] strLstPrecUSD = request.getParameter("LstPrecUSD").split(",");
               String[] strLstPto = request.getParameter("LstPto").split(",");
               String[] strLstNego = request.getParameter("LstNego").split(",");
               String[] strLstPub = request.getParameter("LstPub").split(",");
               String[] strLstApDPto = request.getParameter("LstApDPto").split(",");
               String[] strLstApDNego = request.getParameter("LstApDNego").split(",");
               String[] strLstPUtilidad = request.getParameter("LstPUtilidad").split(",");
               Producto prod = new Producto();
               String strRes = prod.GuardaPrecios(oConn, strPrCodigo, strLstSuc, strLstNum, strLstPrec, strLstDesc,
                       strLstPtos, strLstPtosC, strLstPrecUSD, strLstPto, strLstNego, strLstPub, strLstApDPto, strLstApDNego, strLstPUtilidad);
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println(strRes);//Pintamos el resultado
            } else {
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println("ERROR:Falta el id del producto");//Pintamos el resultado
            }
         }
         //Recuperamos el precio de un producto para un cliente en particular
         if (strid.equals("3")) {
            String strPr_Id = request.getParameter("PR_ID");
            String strCt_Id = request.getParameter("CT_ID");
            if (strPr_Id == null) {
               strPr_Id = "0";
            }
            if (strCt_Id == null) {
               strCt_Id = "0";
            }
            double dblCantidad = 0;
            if (request.getParameter("CANTIDAD") != null) {
               dblCantidad = Double.valueOf(request.getParameter("CANTIDAD"));
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Precios prec = new Precios();
            String strXML = prec.getXML(strPr_Id, oConn, true, dblCantidad, strCt_Id);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Recuperamos el precio de un producto para una lista de precios en particular
         if (strid.equals("4")) {
            String strPr_Id = request.getParameter("PR_ID");
            String strCT_LPRECIOS = request.getParameter("CT_LPRECIOS");
            String strFAC_MONEDA = request.getParameter("FAC_MONEDA");
            String strCT_TIPO_CAMBIO = request.getParameter("CT_TIPO_CAMBIO");
            int intCT_LPRECIOS = 0;
            int intFAC_MONEDA = 0;
            int intCT_TIPO_CAMBIO = 0;
            if (strPr_Id == null) {
               strPr_Id = "0";
            }
            if (strCT_LPRECIOS == null) {
               strCT_LPRECIOS = "0";
            }
            if (strFAC_MONEDA == null) {
               strFAC_MONEDA = "0";
            }
            if (strCT_TIPO_CAMBIO == null) {
               strCT_TIPO_CAMBIO = "0";
            }
            try {
               intFAC_MONEDA = Integer.valueOf(strFAC_MONEDA);
               intCT_TIPO_CAMBIO = Integer.valueOf(strCT_TIPO_CAMBIO);
               intCT_LPRECIOS = Integer.valueOf(strCT_LPRECIOS);
            } catch (NumberFormatException ex) {
               System.out.println("Error conversión precios: " + ex.getMessage());
            }
            double dblCantidad = 0;
            if (request.getParameter("CANTIDAD") != null) {
               dblCantidad = Double.valueOf(request.getParameter("CANTIDAD"));
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Precios prec = new Precios();
            String strXML = prec.getXML(strPr_Id, oConn, true, dblCantidad, intCT_LPRECIOS, intFAC_MONEDA, intCT_TIPO_CAMBIO);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //Cambio de precios
         if (strid.equals("5")) {
            String strCodigo = request.getParameter("Codigo");
            if (strCodigo == null) {
               strCodigo = "";
            }
            int intGpoPrec = 0;
            int intSC_ID = 0;
            int intEMP_ID = 0;
            int intPR_ID = 0;
            boolean bolCambiarPorcUtilidad = false;
            double dblPorUtilidad = 0;
            try {
               if (request.getParameter("GpoPrec") != null) {
                  intGpoPrec = Integer.valueOf(request.getParameter("GpoPrec"));
               }
               if (request.getParameter("SC_ID") != null) {
                  intSC_ID = Integer.valueOf(request.getParameter("SC_ID"));
               }
               if (request.getParameter("EMP_ID") != null) {
                  intEMP_ID = Integer.valueOf(request.getParameter("EMP_ID"));
               }
               if (request.getParameter("PR_ID") != null) {
                  intPR_ID = Integer.valueOf(request.getParameter("PR_ID"));
               }
               if (request.getParameter("PorUtilidad") != null) {
                  dblPorUtilidad = Double.valueOf(request.getParameter("PorUtilidad"));
               }

            } catch (NumberFormatException ex) {
               System.out.println(" error al convertir numero " + ex.getMessage());
            }
            if (request.getParameter("CambiarPorcUtilidad") != null) {
               if (request.getParameter("CambiarPorcUtilidad").equals("1")) {
                  bolCambiarPorcUtilidad = true;
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Precios prec = new Precios();
            String strXML = prec.CambioPreciosMasivo(oConn, strCodigo, intGpoPrec,
                    bolCambiarPorcUtilidad, dblPorUtilidad, intSC_ID, intEMP_ID, intPR_ID);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado

         }
         //Regresa las formulas para cada lista de precios
         if (strid.equals("6")) {
            //Instanciamos el objeto que nos trae las listas de precios
            Precios prec = new Precios();
            String strXML = prec.RegresaFormulas(oConn);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
      }
   } else {
   }
   oConn.close();
%>