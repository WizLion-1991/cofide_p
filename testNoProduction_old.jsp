<%-- 
    Document   : testNoProduction
      Este jsp esta prohibido usarlo en produccion, aqui podremos ejecutar clases que solucionen o corrijan datos
    Created on : 13-jul-2013, 16:24:29
    Author     : ZeusGalindo
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="javax.crypto.BadPaddingException"%>
<%@page import="javax.crypto.IllegalBlockSizeException"%>
<%@page import="java.security.InvalidKeyException"%>
<%@page import="javax.crypto.NoSuchPaddingException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="Core.FirmasElectronicas.Opalina"%>
<%@page import="ERP.Ticket"%>
<%@page import="Core.FirmasElectronicas.SATXml3_0"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteVentasDetalle"%>
<%@page import="ERP.ProductosLoteRepair"%>
<%@page import="ERP.GeneraFolios"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.mx.siweb.prosefi.Credito"%>
<%@page import="comSIWeb.Utilerias.DigitoVerificador"%>
<%@page import="com.mx.siweb.mlm.utilerias.Redes"%>
<%@page import="ERP.Importar"%>
<%@page import="ERP.Pedimentos"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="ERP.Paridades"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();

   /**
    * ******test de conexion de ssl*****
    */
   /*
         
         
    // default url:

    String urlString = "https://ventas.siwebmx.com:1005/ContabilidadPlusMMorelos/MySIWEBConta?wsdl";

    // if any url specified, use that instead:


    out.println("<br>Connecting to " + urlString + "...");
       
    try {
    // convert user string to URL object
    out.println("<br>convert user string to URL object");
    URL url = new URL(urlString);

    // connect!
    out.println("<br>connect");
    URLConnection cnx = url.openConnection();
    cnx.connect();

    // read the page returned
    out.println("<br>read the page returned");

    InputStream ins = cnx.getInputStream();
    BufferedReader in = new BufferedReader(new InputStreamReader(ins));
    String curline;
    while( (curline = in.readLine()) != null ) {
    out.println("<br>" + curline);
    }

    // close the connection

    ins.close();
    }
    catch(Throwable t) {
    out.println("<br>error " + t.getMessage());
    t.printStackTrace();
    }*/
   //ProductosLoteRepair lotesRepa = new ProductosLoteRepair();
   //lotesRepa.doAjuste(oConn);
   /*
    //Generamos los folios.
    String strSql = "select EMP_ID from vta_empresas ";
    ResultSet rs = oConn.runQuery(strSql, true);
    while (rs.next()) {
    int intEmpresa = rs.getInt("EMP_ID");
    GeneraFolios folio = new GeneraFolios();
    folio.setoConn(oConn);
    folio.UpdateFolio(intEmpresa);
    out.println("PROCESO TERMINADO con empresa " + intEmpresa);
    }
    rs.close();
    /*

    //Actualizar la tasa de paridad
    /*Paridades paridad = new Paridades();
    paridad.CorrigeVentas("20120101", "20130731", oConn, 2, true);
    paridad.CorrigeCXPagar("20120101", "20130731", oConn, 2, true);
    */
   //Buscamos los pedimentos aplicados...para cancelarlos
   /*
    String strSql = "select PED_ID from vta_pedimentos where PED_APLICADO = 1 order by PED_FECHA_APLIC";
    ResultSet rs = oConn.runQuery(strSql, true);
    while(rs.next()){
    Pedimentos pedimento = new Pedimentos( oConn,  varSesiones);
    pedimento.setIntPED_ID(rs.getInt("PED_ID"));
    pedimento.doCancelaProrrateo();
    out.println("Pedimento con id " + rs.getInt("PED_ID") + "estatus:" + pedimento.getStrResultLast());
            
    //Aplicamos los pedimentos
    pedimento.doGeneraProrrateo();
    out.println("Pedimento con id " + rs.getInt("PED_ID") + " despues de aplicar el prorrateo " + pedimento.getStrResultLast());
    }
    rs.close();
    * */
   //Buscamos aplicar los pagos
   /*
    Importar importa = new Importar();
    importa.setIntEMP_ID(2);
    importa.setIntSC_ID(2);
    importa.SaldosInicialesProv(oConn, "/Users/ZeusGalindo/Desktop/Cxpagar_layoutmak.xls", varSesiones);
    */
   //Redes red  = new Redes();
   //boolean bolArmado = red.armarArbol("vta_cgastos", "GT_ID", "GT_UPLINE", 1, "GT_", "", " ORDER BY GT_DESCRIPCION", false, true, oConn);
   /*DigitoVerificador digito = new DigitoVerificador();
out.println("Comenzamos.......");
   String strSql = "select * from vta_cliente ";//
   ResultSet rs = oConn.runQuery(strSql, true);
   while (rs.next()) {
      int intIdCliente = rs.getInt("CT_ID");

      //int strDigito = digito.CalculaModulo97("7004", "1706471", intIdCliente + "");
      int intDigito = DigitoVerificador.CalculaModulo10(intIdCliente + "", false);

      String strReferencia1 = intIdCliente + "" + intDigito;

      String strUpdate = "update vta_cliente set CT_RBANCARIA1=" + strReferencia1 + ",CT_BANCO1 = 5 where CT_ID = " + intIdCliente;
      oConn.runQueryLMD(strUpdate);
      //out.println("strUpdate:" + strUpdate);
   }
   rs.close();
out.println("Ya terminamos...");*/
   //Autorizar creditos prosefi
   /*
    Fechas fecha = new Fechas();
    String strRes = "";
    ResultSet rs2 = oConn.runQuery("select * from cat_credito");

    while (rs2.next()) {
    String strIdCredito = rs2.getString("CTO_ID");

    String autorizado = "UPDATE cat_credito SET CTO_AUTORIZADO = '1', CTO_FECHA_AUTORIZADO = " + fecha.getFechaActual() + ", "
    + "ID_USUARIO_AUTORIZO = " + varSesiones.getIntNoUser() + " WHERE CTO_ID = " + strIdCredito;
    oConn.runQueryLMD(autorizado);

    String strAutoriza = "SELECT * FROM cat_credito a, cat_monto b, cat_amortizacion_master c, cat_amortizacion_deta d "
    + "where b.MTO_ID = a.MTO_ID AND c.MTO_ID = b.MTO_ID "
    + "AND d.AMT_ID = c.AMT_ID AND a.CTO_ID = " + strIdCredito;
    //String strConsulta = "SELECT * FROM cat_credito c, cat_obligado o where c.CTO_ID = o.CTO_ID AND o.CTO_ID = " + strId;          
    ResultSet rs = oConn.runQuery(strAutoriza);

    Credito objCredito = new Credito();
    while (rs.next()) {

    objCredito.getObjVencimiento().setFieldString("V_VENCIMIENTO", rs.getString("CT0_FVENCIMIENTO"));
    objCredito.getObjVencimiento().setFieldInt("V_MOVIMIENTO", 1);
    objCredito.getObjVencimiento().setFieldInt("CT_ID", rs.getInt("CT_ID"));
    objCredito.getObjVencimiento().setFieldInt("CTO_ID", rs.getInt("CTO_ID"));
    objCredito.getObjVencimiento().setFieldDouble("V_IMPORTE", rs.getFloat("AMTD_SALDO"));
    objCredito.getObjVencimiento().setFieldDouble("V_IVA", rs.getFloat("AMTD_IVAINTERESES"));
    objCredito.getObjVencimiento().setFieldDouble("V_SALDO", rs.getDouble("MTO_PAGOS"));

    objCredito.getObjVencimiento().setFieldDouble("V_VALOR_NEGOCIO", rs.getDouble("MTO_PAGOS"));
    objCredito.getObjVencimiento().setFieldDouble("V_PUNTOS", rs.getDouble("MTO_PAGOS"));

    objCredito.getObjVencimiento().setFieldDouble("V_CAPITAL", rs.getFloat("AMTD_AMORTCAPITAL"));
    objCredito.getObjVencimiento().setFieldDouble("V_INTERES", rs.getFloat("AMTD_INTERESES"));
    String strRes2 = objCredito.autorizado(oConn);
    if(!strRes2.equals("OK")){
    strRes = strRes2 + "<BR>";
    }
    }
    rs.close();
    }
    rs2.close();
    out.println("Resultados:<br>" + strRes);
    */
//         String strSql = "select PED_ID from vta_pedimentos where PED_APLICADO = 1  order by PED_FECHA_APLIC";//
//         ResultSet rs = oConn.runQuery(strSql, true);
//         while(rs.next()){
//            Pedimentos pedimento = new Pedimentos( oConn,  sesion);
//            pedimento.setIntPED_ID(rs.getInt("PED_ID"));
//            pedimento.doCancelaProrrateo();
//            System.out.println("Pedimento con id " + rs.getInt("PED_ID") + "estatus:" + pedimento.getStrResultLast());
//            
//            //Aplicamos los pedimentos
////            pedimento.doGeneraProrrateo();
////            System.out.println("Pedimento con id " + rs.getInt("PED_ID") + " despues de aplicar el prorrateo " + pedimento.getStrResultLast());
//         }
//         rs.close();
   oConn.close();
%>
