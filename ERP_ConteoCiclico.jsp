<%-- 
    Document   : ERP_ConteoCiclico
    Created on : 4/06/2014, 01:20:13 PM
    Author     : siweb
--%>

<%@page import="Tablas.vta_movproddeta"%>
<%@page import="ERP.Inventario"%>
<%@page import="Tablas.vta_ciclico_deta"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ERP.Conteo_Ciclico"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>

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
         //Genera una nueva operacion de pagos en base a la transaccion que nos envian
         if (strid.equals("1")) {
            //Instanciamos el objeto que nos trae los datos  
            Fechas f = new Fechas();
            String strFechaFinal = request.getParameter("FECHAFINAL");
            if (strFechaFinal != null) {
               strFechaFinal = f.FormateaBD(strFechaFinal, "/");
            }
            int intSucursal = 0;
            if (request.getParameter("SUCURSAL") != null) {
               intSucursal = Integer.valueOf(request.getParameter("SUCURSAL"));
            }
            int intEmpresa = 0;
            intEmpresa = varSesiones.getIntIdEmpresa();

            String strSql = "SELECT CC_MES AS MES  "
                    + "FROM vta_sucursal WHERE EMP_ID=" + intEmpresa + " AND SC_ID=" + intSucursal;

            ResultSet rs = oConn.runQuery(strSql, true);
            int mes = 0;
            while (rs.next()) {
               mes = rs.getInt("MES");

            }
            /*calculamos la fecha inicial*/

            String strFechaInicial = f.addFecha(strFechaFinal, 2, mes);

            //regresamos los productos al grid
            Conteo_Ciclico b = new Conteo_Ciclico(oConn, varSesiones, intSucursal, intEmpresa, strFechaInicial, strFechaFinal);
            b.setIntEmpresa(varSesiones.getIntIdEmpresa());
            b.generaProductosMasVendidos();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            String reporte = b.GeneraXml();
            //  System.out.println(reporte);
            out.println(reporte + "");//Pintamos el resultado   
         }
         /*obtenemos la cantidad de articulos*/
         if (strid.equals("2")) {

            int intSucursal = 0;

            if (request.getParameter("SUCURSAL") != null) {
               intSucursal = Integer.valueOf(request.getParameter("SUCURSAL"));
            }
            int intEmpresa = varSesiones.getIntIdEmpresa();
            // intEmpresa = varSesiones.getIntIdEmpresa();

            int intarticulo = 0;

            String strSql = "SELECT CC_REGISTRO AS CANTIDAD "
                    + "FROM vta_sucursal WHERE EMP_ID=" + intEmpresa + " AND SC_ID=" + intSucursal;

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               intarticulo = rs.getInt("CANTIDAD");

            }

            rs.close();

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(intarticulo);//Pintamos el resultado   
         }

         if (strid.equals("3")) {

            int intSucursal = 0;

            if (request.getParameter("SUCURSAL") != null) {
               intSucursal = Integer.valueOf(request.getParameter("SUCURSAL"));
            }
            int intEmpresa = varSesiones.getIntIdEmpresa();
            // intEmpresa = varSesiones.getIntIdEmpresa();

            int intbodega = 0;

            String strSql = "SELECT CS_ID "
                    + "FROM vta_ciclico_status WHERE CS_ID=1";
            //+ "" + intEmpresa + " AND SC_ID=" + intSucursal;

            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {

               intbodega = rs.getInt("CS_ID");

            }

            rs.close();

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(intbodega);//Pintamos el resultado   
         }

         if (strid.equals("4")) {

            Conteo_Ciclico cc = new Conteo_Ciclico(oConn, varSesiones);
            ArrayList<vta_ciclico_deta> lstPartidas = new ArrayList<vta_ciclico_deta>();
            //Recibimos listado de partidas
            int intNumPartidas = Integer.valueOf(request.getParameter("CONTADOR"));
            for (int i = 0; i < intNumPartidas; i++) {
               vta_ciclico_deta deta = new vta_ciclico_deta();
               try {
                  //Primera sección IMPUESTOS Y VALOR EN ADUANA
                  deta.setFieldString("PR_CODIGO", request.getParameter("PR_ID" + i));
                  deta.setFieldString("PR_DESCRIPCION", request.getParameter("PR_DESCRIPCION" + i));
                  deta.setFieldDouble("CCD_CANT_EXIST", Double.valueOf(request.getParameter("CCD_CANT_EXIST" + i)));
                  //CODIGO ANDREW

                  deta.setFieldInt("CCD_TEXTIL", Integer.valueOf(request.getParameter("CCD_TEXTIL" + i)));
                  deta.setFieldInt("CCD_ADERIBLE", Integer.valueOf(request.getParameter("CCD_ADERIBLE" + i)));
                  deta.setFieldDouble("CCD_CONTEO1", Double.valueOf(request.getParameter("CCD_CONTEO1" + i)));
                  deta.setFieldDouble("CCD_CONTEO2", Double.valueOf(request.getParameter("CCD_CONTEO2" + i)));
                  //FIN ANDREW
                  try {
                     int intCCD_ID = Integer.valueOf(request.getParameter("CCD_ID" + i));
                     deta.setFieldInt("CCD_ID", intCCD_ID);
                     int intCC_ID = Integer.valueOf(request.getParameter("CC_ID"));
                     deta.setFieldInt("CC_ID", intCC_ID);
                  } catch (NumberFormatException ex) {
                     System.out.println("Error al convertir numeros(601) " + ex.getMessage());
                  } catch (NullPointerException ex) {
                     System.out.println("Error al convertir numeros(601a) " + ex.getMessage());
                  }
                  lstPartidas.add(deta);
               } catch (Exception ex) {
                  System.out.println("Error datos nulos.. " + ex.getMessage() + " " + ex.getLocalizedMessage());
                  ex.printStackTrace();
               }
            }
            //Definimos los valores para la lista
            cc.setDeta(lstPartidas);
            //Instanciamos el objeto
            String strResMet = cc.doAltaCiclicoDeta(oConn);

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResMet);//Pintamos el resultado
         }
//////////Codigo Andrew
         if (strid.equals("5")) {

            Conteo_Ciclico cc = new Conteo_Ciclico(oConn, varSesiones);
            int intcc_id = 0;

            if (request.getParameter("CC_ID") != null) {
               intcc_id = Integer.valueOf(request.getParameter("CC_ID"));
            }
            //Instanciamos el objeto
            String strResMet = cc.getDataCiclico(intcc_id, oConn);

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strResMet);//Pintamos el resultado
         }
         if(strid.equals("6")){
            Conteo_Ciclico cc=new Conteo_Ciclico(oConn, varSesiones);
            int intcc_id = 0;
            if (request.getParameter("CC_ID") != null) {
               intcc_id = Integer.valueOf(request.getParameter("CC_ID"));
               String result=cc.actualizarStatus(intcc_id,4,oConn);
               String salida=cc.compararExistencia(oConn, intcc_id);
               System.out.println(salida);
               out.println(result);
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
            }
         }
         if(strid.equals("7")){
            Conteo_Ciclico cc=new Conteo_Ciclico(oConn, varSesiones);
            int intcc_id = 0;             
            if (request.getParameter("CC_ID") != null) {
               intcc_id = Integer.valueOf(request.getParameter("CC_ID"));
               String result=cc.actualizarStatus(intcc_id,5,oConn);
               String respuesta=">>>>>>>>>>>>>>>>>>>"+cc.calcularDiferencia(oConn, intcc_id)+"<<<<<<<<<<<<<<<<<<<<";
               System.out.println(respuesta);
               System.out.println(result);
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
            }            
         }
         
         if(strid.equals("8")){
            Conteo_Ciclico cc=new Conteo_Ciclico(oConn, varSesiones);
            int intcc_id = 0;            
            if (request.getParameter("CC_ID") != null) {
               intcc_id = Integer.valueOf(request.getParameter("CC_ID"));
               String result=cc.actualizarStatus(intcc_id,6,oConn);
               out.println(result);
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
            }
         }
         
         if(strid.equals("9")){
            String strSist_Costos = this.getServletContext().getInitParameter("SistemaCostos");
            if (strSist_Costos == null) {
               strSist_Costos = "0";
            }
            String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL_INV");
            if (strfolio_GLOBAL == null) {
               strfolio_GLOBAL = "NO";
            }
            Conteo_Ciclico cc=new Conteo_Ciclico(oConn, varSesiones);
            int intcc_id = 0;
            if (request.getParameter("CC_ID") != null) {
               intcc_id = Integer.valueOf(request.getParameter("CC_ID"));
               String result=cc.actualizarStatus(intcc_id,3,oConn);
               String salida= cc.aplicarInventario(oConn,intcc_id,strfolio_GLOBAL,strSist_Costos);
               System.out.println(">>>>>>>>>>>>>>>>>>>>>>>"+salida);
               out.println(result); 
               out.clearBuffer();
               atrJSP.atrJSP(request, response, true, true);
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            //out.println(strRes);//Pintamos el resultado
         }
/////////// Codigo Andrew doAltaCiclicoDeta
      }
   }

   oConn.close();
%>