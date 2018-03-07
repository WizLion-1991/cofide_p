<%-- 
    Document   : ERP_Contabilidad
Este jsp se encarga de hacer la conexion al programa contable y recuperar información de el
    Created on : 12-oct-2013, 18:58:25
    Author     : ZeusGalindo
--%>

<%@page import="java.util.Iterator"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="ERP.ContabilidadUtil"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.ContabilidadRestfulClient"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.MalformedURLException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
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
      if (strid == null) {
         strid = "";
      }
      //Caso 1 recuperar polizas
      if (strid.equals("1")) {
         //Inicializamos los parametros
         Fechas fecha = new Fechas();

         String strPeriodo = request.getParameter("periodo");
         if (strPeriodo == null) {
            strPeriodo = fecha.getFechaActual().substring(0, 6);
         }
         //Consultamos id de empresa
         int intIdEmpresa = 0;
         String strSql = "select EMP_CONTA_ID_EMPRESA "
                 + " from vta_empresas "
                 + " where EMP_ID = " + varSesiones.getIntIdEmpresa();
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            intIdEmpresa = rs.getInt("EMP_CONTA_ID_EMPRESA");
         }
         rs.close();
         //Objeto que consume Restful service de contabilidad
         ContabilidadRestfulClient client = new ContabilidadRestfulClient();
         client.setIntEmpresa(varSesiones.getIntIdEmpresa());
         client.setoConn(oConn);
         String strCodigo = Sesiones.gerVarSession(request, "SESSION_CP");
         if (strCodigo == null) {
            strCodigo = client.logIn();
            Sesiones.SetSession(request, "SESSION_CP", strCodigo);
         } else {
            if (strCodigo.isEmpty() || strCodigo.equals("0")) {
               strCodigo = client.logIn();
               Sesiones.SetSession(request, "SESSION_CP", strCodigo);
            } else {
               client.setStrCodigoSesion(strCodigo);
            }
         }
         String strXml = client.getPolizas(intIdEmpresa, strPeriodo, 10000);
         client.logOut();
         //client.logOut();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         out.println(strXml);//Pintamos el resultado
      }
      //Caso 2 obtener id de sesion
      if (strid.equals("2")) {

         //Objeto que consume Restful service de contabilidad
         ContabilidadRestfulClient client = new ContabilidadRestfulClient();
         client.setIntEmpresa(varSesiones.getIntIdEmpresa());
         client.setoConn(oConn);
         String strCodigo = Sesiones.gerVarSession(request, "SESSION_CP");
         if (strCodigo == null) {
            strCodigo = client.logIn();
            Sesiones.SetSession(request, "SESSION_CP", strCodigo);
         } else {
            if (strCodigo.isEmpty() || strCodigo.equals("0")) {
               strCodigo = client.logIn();
               Sesiones.SetSession(request, "SESSION_CP", strCodigo);
            } else {
               client.setStrCodigoSesion(strCodigo);
            }
         }
         //client.logOut();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         out.println(strCodigo);//Pintamos el resultado
      }
      //Caso 3 Migracion masiva
      if (strid.equals("3")) {
         String strPeriodo = request.getParameter("Periodo");
         if (strPeriodo == null) {
            strPeriodo = "";
         }
         String strPathBase = this.getServletContext().getRealPath("/");
         String strSeparator = System.getProperty("file.separator");
         if (strSeparator.equals("\\")) {
            strSeparator = "/";
            strPathBase = strPathBase.replace("\\", "/");
         }
         String strCarpetaDest = "CuentasXPagar";
         //Asignamos el nombre del archivo
         String strPathUsado = strPathBase + "document" + strSeparator + strCarpetaDest + strSeparator;
         //Objeto para migrar contabilidad
         ContabilidadUtil contabilidad = new ContabilidadUtil(oConn, varSesiones);
         contabilidad.setStrPathBaseXML(strPathUsado);

         //Limpiamos la informacion
         contabilidad.doCleanPolizaAuto(varSesiones.getIntIdEmpresa(), strPeriodo);
         //Generamos la contabilidad masiva
         contabilidad.GeneraConta(varSesiones.getIntIdEmpresa(), strPeriodo);

         //client.logOut();
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML

         //Pintamos resultados
         String strSeparador = "<br>";
         StringBuilder strResultado = new StringBuilder("Migración masiva contable resultados:" + strSeparador);

         strResultado.append("FACTURAS:").append(strSeparador);
         strResultado.append("Exitosos ").append(contabilidad.getIntSucessFacturas()).append(strSeparador);
         strResultado.append("Fallidos ").append(contabilidad.getIntFailFacturas()).append(strSeparador);
         Iterator<String> it = contabilidad.getLstFailsFacturas().iterator();
         while (it.hasNext()) {
            String strError = it.next();
            strResultado.append(strError).append(strSeparador);
         }

         strResultado.append("Cuentas por PAGAR:").append(strSeparador);
         strResultado.append("Exitosos ").append(contabilidad.getIntSucessCXP()).append(strSeparador);
         strResultado.append("Fallidos ").append(contabilidad.getIntFailCXP()).append(strSeparador);
         it = contabilidad.getLstFailsCXP().iterator();
         while (it.hasNext()) {
            String strError = it.next();
            strResultado.append(strError).append(strSeparador);
         }

         strResultado.append("Cobros a clientes:").append(strSeparador);
         strResultado.append("Exitosos ").append(contabilidad.getIntSucessCobros()).append(strSeparador);
         strResultado.append("Fallidos ").append(contabilidad.getIntFailCobros()).append(strSeparador);
         it = contabilidad.getLstFailsCobros().iterator();
         while (it.hasNext()) {
            String strError = it.next();
            strResultado.append(strError).append(strSeparador);
         }

         strResultado.append("Pagos a proveedor:").append(strSeparador);
         strResultado.append("Exitosos ").append(contabilidad.getIntSucessPagos()).append(strSeparador);
         strResultado.append("Fallidos ").append(contabilidad.getIntFailPagos()).append(strSeparador);
         it = contabilidad.getLstFailsPagos().iterator();
         while (it.hasNext()) {
            String strError = it.next();
            strResultado.append(strError).append(strSeparador);
         }

         strResultado.append("Bancos:").append(strSeparador);
         strResultado.append("Exitosos ").append(contabilidad.getIntSucessBcos()).append(strSeparador);
         strResultado.append("Fallidos ").append(contabilidad.getIntFailBcos()).append(strSeparador);
         it = contabilidad.getLstFailsBancos().iterator();
         while (it.hasNext()) {
            String strError = it.next();
            strResultado.append(strError).append(strSeparador);
         }
         strResultado.append("Nóminas:").append(strSeparador);
         strResultado.append("Exitosos ").append(contabilidad.getIntSucessNominas()).append(strSeparador);
         strResultado.append("Fallidos ").append(contabilidad.getIntFailNominas()).append(strSeparador);
         it = contabilidad.getLstFailsNominas().iterator();
         while (it.hasNext()) {
            String strError = it.next();
            strResultado.append(strError).append(strSeparador);
         }
         System.out.println(strResultado.toString());
         out.println(strResultado.toString());//Pintamos el resultado
      }
   }
   oConn.close();
%>