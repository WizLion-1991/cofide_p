<%-- 
    Document   : ERP_Varios
      Contiene varias utilerias de xml para los programas a usarse con ajax
    Created on : 19-ago-2012, 8:58:42
    Author     : aleph_79
--%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="Tablas.vta_ncredito"%>
<%@page import="Tablas.vta_facturas"%>
<%@page import="comSIWeb.Utilerias.StringofNumber"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="ERP.PolizasContables"%>
<%@page import="Tablas.vta_tickets"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.File"%>
<%@page import="ERP.ProcesoMaster"%>
<%@page import="ERP.Globalizacion"%>
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
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {

         //Regresamos los estados del pais seleccionado
         if (strid.equals("1")) {
            int intIdPais = 0;
            String strPais = request.getParameter("idPais");
            if (strPais == null) {
               strPais = "0";
            }
            try {
               intIdPais = Integer.valueOf(strPais);
            } catch (NumberFormatException ex) {
            }
            Globalizacion global = new Globalizacion();
            String strXML = global.GetStatesXml(oConn, intIdPais);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado   

         }
         //Genera un pdf de jasper y lo comprime
         if (strid.equals("2")) {
            String strResp = "";
            //Recuperamos paths base
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathBase = this.getServletContext().getRealPath("/");
            //Recuperamos paths
            String strIdTicket = request.getParameter("ID");
            String strNomFormato = request.getParameter("NOM_FORMATO");
            String strNomId = "TKT_ID";
            String strNomIdParam = "tkt_id";

            int intIdTicket = 0;

            if (strIdTicket.isEmpty()) {
               strIdTicket = "0";
            }
            try {
               intIdTicket = Integer.valueOf(strIdTicket);
            } catch (NumberFormatException ex) {
               System.out.println("ex ticket print:" + ex.getMessage());
            }
            //Recuperamos datos del ticket
            TableMaster ticket = null;
            if (strNomFormato.equals("TICKET1")) {
               ticket = new vta_tickets();
            }
            ticket.ObtenDatos(intIdTicket, oConn);

            //Clase que genera el formato
            ProcesoMaster process = new ProcesoMaster(oConn, varSesiones, null);
            process.setStrPATHBase(strPathBase);

            String[] lstParamsName = {strNomIdParam};
            String[] lstParamsValue = {ticket.getFieldString(strNomId)};

            String strNomFile = process.doGeneraFormatoJasper(0, strNomFormato, "PDF", ticket, lstParamsName, lstParamsValue, strPathXML + "ticketTmp" + ticket.getFieldString(strNomId) + ".pdf");

            try {
               File file = new File(strNomFile);
               //Abrimos el archivo y lo comprimimos
               byte[] fileByte = org.apache.commons.io.FileUtils.readFileToByteArray(file);
               String strCompBase64 = PolizasContables.compressString(fileByte);
               if (strCompBase64 != null) {
                  strResp = strCompBase64;
               }
            } catch (IOException ex) {
               System.out.println(ex.getMessage());
            }

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResp);//Pintamos el resultado   
         }
         //Genera un pdf de jasper y lo comprime
         if (strid.equals("4")) {
            String strResp = "";
            //Recuperamos paths base
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathBase = this.getServletContext().getRealPath("/");
            //Recuperamos paths
            String strIdTicket = request.getParameter("ID");
            String strNomFormato = request.getParameter("NOM_FORMATO");
            String strNomId = "TKT_ID";
            String strNomIdParam = "tkt_id";
            int intIdTicket = 0;

            if (strIdTicket.isEmpty()) {
               strIdTicket = "0";
            }
            try {
               intIdTicket = Integer.valueOf(strIdTicket);
            } catch (NumberFormatException ex) {
               System.out.println("ex ticket print:" + ex.getMessage());
            }
            //Recuperamos datos del ticket
            TableMaster ticket = null;
            if (strNomFormato.equals("TICKET1")) {
               ticket = new vta_tickets();
            }
            ticket.ObtenDatos(intIdTicket, oConn);

            //Abrimos el formato correspondiente
            //copiar
            String strEncabezado = "";
            String strCuerpo = "";
            String strCuerpoAll = "";
            String strPie = "";
            //Datos de la empresa
            String strFor = "select * from formatos_tickets where FT_ID = '1'";
            ResultSet rsI = oConn.runQuery(strFor, true);
            while (rsI.next()) {
               strEncabezado = rsI.getString("FT_TXT_ENCABEZADO");
               strCuerpo = rsI.getString("FT_TXT_CUERPO");
               strPie = rsI.getString("FT_TXT_PIE");

            }
            rsI.close();
            //Datos de la empresa
            String strEmp = "select * from vta_empresas where EMP_ID =  " + ticket.getFieldInt("EMP_ID");
            ResultSet rs = oConn.runQuery(strEmp, true);
            strEncabezado = strEncabezado.replace("{TKT_FOLIO}", ticket.getFieldString("TKT_FOLIO"));
            strEncabezado = strEncabezado.replace("{TKT_ID}", ticket.getFieldString("TKT_ID"));
            while (rs.next()) {
               strEncabezado = strEncabezado.replace("{EMP_RAZONSOCIAL}", rs.getString("EMP_RAZONSOCIAL"));
               strEncabezado = strEncabezado.replace("{EMP_CALLE}", rs.getString("EMP_CALLE"));
               strEncabezado = strEncabezado.replace("{EMP_COLONIA}", rs.getString("EMP_COLONIA"));
               strEncabezado = strEncabezado.replace("{EMP_MUNICIPIO}", rs.getString("EMP_MUNICIPIO"));
               strEncabezado = strEncabezado.replace("{EMP_ESTADO}", rs.getString("EMP_ESTADO"));
               strEncabezado = strEncabezado.replace("{EMP_TELEFONO1}", rs.getString("EMP_TELEFONO1"));

            }
            rs.close();
            //Usuario que realizo la venta
            strEmp = "select u.nombre_usuario from usuarios u where  u.id_usuarios =  " + ticket.getFieldInt("TKT_US_ALTA");
            rs = oConn.runQuery(strEmp, true);
            while (rs.next()) {
               strEncabezado = strEncabezado.replace("{TKT_VENDEDOR}", rs.getString("nombre_usuario"));

            }
            rs.close();
            //Datos del ticket 
            Fechas fecha =new Fechas();
            
            strEncabezado = strEncabezado.replace("{TKT_FOLIO}", ticket.getFieldString("TKT_FOLIO"));
            strEncabezado = strEncabezado.replace("{TKT_NOTAS}", ticket.getFieldString("TKT_NOTAS"));
            strEncabezado = strEncabezado.replace("{CT_ID}", ticket.getFieldString("CT_ID"));
            strEncabezado = strEncabezado.replace("{TKT_FECHA}",fecha.Formatea(ticket.getFieldString("TKT_FECHA"), "/"));
            strPie = strPie.replace("{TKT_TOTAL}", "$" + NumberString.FormatearDecimal(ticket.getFieldDouble("TKT_IMPORTE"), 2));
            strPie = strPie.replace("{TKT_IMPORTE}", "$" + NumberString.FormatearDecimal(ticket.getFieldDouble("TKT_TOTAL"), 2));
            strPie = strPie.replace("{TKT_IMPUESTO1}", "$" + NumberString.FormatearDecimal(ticket.getFieldDouble("TKT_IMPUESTO1"), 2));
            StringofNumber enLetras = new StringofNumber();
            strPie = strPie.replace("{TKT_TOTAL_EN_LETRA}", enLetras.getStringOfNumber(ticket.getFieldDouble("TKT_TOTAL")));

            String sqlCuerpo = "SELECT TKTD_CVE,TKTD_CANTIDAD, TKTD_DESCRIPCION,TKTD_PRECIO,TKTD_IMPORTEREAL,TKTD_IMPUESTO1,TKTD_TASAIVA1 FROM vta_ticketsdeta WHERE TKT_ID= " + ticket.getFieldInt("TKT_ID");
            ResultSet rCuerpo = oConn.runQuery(sqlCuerpo, true);
            double cantidad = 0;
            while (rCuerpo.next()) {
               String strCuerpoTemp = new String(strCuerpo);
               double importeReal = rCuerpo.getDouble("TKTD_IMPORTEREAL");
               double precioUnit = rCuerpo.getDouble("TKTD_PRECIO");
               double cant = rCuerpo.getDouble("TKTD_CANTIDAD");
               double dblTasaIVA1 = rCuerpo.getDouble("TKTD_TASAIVA1");
               precioUnit = precioUnit /( 1 + (dblTasaIVA1/100));
               importeReal = importeReal/( 1 + (dblTasaIVA1/100));
               String strDescripcion ="";
               if(rCuerpo.getString("TKTD_DESCRIPCION").length() > 30)
               {
                   strDescripcion = rCuerpo.getString("TKTD_DESCRIPCION").substring(0, 30);
               }
               else
               {
                   strDescripcion = rCuerpo.getString("TKTD_DESCRIPCION");
               }
               strCuerpoTemp = strCuerpoTemp.replace("{TKT_CODIGO} ", rCuerpo.getString("TKTD_CVE"));
               strCuerpoTemp = strCuerpoTemp.replace("{TKT_CANTIDAD} ", NumberString.FormatearDecimal(cant, 2));
               strCuerpoTemp = strCuerpoTemp.replace("{TKT_DESCRIPCION}", strDescripcion);
               strCuerpoTemp = strCuerpoTemp.replace("{TKT_PRECIO_UNIT} ", NumberString.FormatearDecimal(precioUnit, 2));
               strCuerpoTemp = strCuerpoTemp.replace("{TKT_TOTAL}", NumberString.FormatearDecimal(importeReal, 2));
               cantidad += rCuerpo.getDouble("TKTD_CANTIDAD");
               strCuerpoAll += strCuerpoTemp;
            }

            strPie = strPie.replace("{TKT_CANTIDAD}", "" + cantidad);

            String strCliente = "SELECT MCD_FORMAPAGO,MCD_IMPORTE,MCD_CAMBIO FROM vta_mov_cte_deta INNER JOIN vta_mov_cte ON vta_mov_cte_deta.MC_ID = vta_mov_cte.MC_ID WHERE TKT_ID=" + ticket.getFieldInt("TKT_ID");
            ResultSet rCliente = oConn.runQuery(strCliente, true);
            while (rCliente.next()) {
               strPie = strPie.replace("{TKT_FORMA_PAGO}", rCliente.getString("MCD_FORMAPAGO"));

               if (rCliente.getString("MCD_FORMAPAGO").equals("EFECTIVO")) {
                  double importe = rCliente.getDouble("MCD_IMPORTE");
                  double cambio = rCliente.getDouble("MCD_CAMBIO");
                  strPie = strPie.replace("{TKT_EFECTIVO}", NumberString.FormatearDecimal(importe, 2));
                  strPie = strPie.replace("{TKT_CAMBIO}", NumberString.FormatearDecimal(cambio, 2));
               } else {
                  strPie = strPie.replace("{TKT_EFECTIVO}", "0.0");
                  strPie = strPie.replace("{TKT_CAMBIO}", "0.0");
               }
               if (rCliente.getString("MCD_FORMAPAGO").equals("TCREDITO")) {
                  double importe = rCliente.getDouble("MCD_IMPORTE");
                  strPie = strPie.replace("{TKT_TARJETA}", NumberString.FormatearDecimal(importe, 2));
                  strPie = strPie.replace("{TKT_CAMBIO}", "0.0");
               } else {
                  strPie = strPie.replace("{TKT_TARJETA}", "0.0");
                  strPie = strPie.replace("{TKT_CAMBIO}", "0.0");
               }
               if (rCliente.getString("MCD_FORMAPAGO").equals("SALDOFAVOR")) {
                  double importe = rCliente.getDouble("MCD_IMPORTE");
                  strPie = strPie.replace("{TKT_VALES}", NumberString.FormatearDecimal(importe, 2));
                  strPie = strPie.replace("{TKT_CAMBIO}", "0.0");
               } else {
                  strPie = strPie.replace("{TKT_VALES}", "0.0");
                  strPie = strPie.replace("{TKT_CAMBIO}", "0.0");
               }
            }            
            String strSQL = "SELECT CONCAT(CDE_CALLE,' ',CDE_NUMERO,' ',CDE_NUMINT,' COL.',CDE_COLONIA,'. ',CDE_MUNICIPIO,', ',CDE_ESTADO,' C.P.',CDE_CP) AS DIR,CDE_NOMBRE,CDE_TELEFONO1 FROM vta_tickets Join vta_cliente_dir_entrega On vta_tickets.CDE_ID = vta_cliente_dir_entrega.CDE_ID Where TKT_ID = "+ ticket.getFieldInt("TKT_ID");
            rs = oConn.runQuery(strSQL, true);
            String strEntrega="";
            while (rs.next()) {
                strEntrega+="\nDIRECCION ENTREGA:"; 
                String strDirEnt = rs.getString("DIR");
                int intIndex= 0;
                int intLongitudRenglon=39;
                while(intIndex<strDirEnt.length())
                {
                    strEntrega+="\n"+strDirEnt.substring(intIndex, Math.min(intIndex+intLongitudRenglon,strDirEnt.length()));
                    intIndex += intLongitudRenglon;
                }
                
                if(!rs.getString("DIR").equals(""))
                {
                    strEntrega+="\nRECEPTOR:"+rs.getString("CDE_NOMBRE");
                }
                if(!rs.getString("CDE_TELEFONO1").equals(""))
                {
                    strEntrega+="\nTELEFONO:"+rs.getString("CDE_TELEFONO1");
                }
            }
            strPie = strPie.replace("{TKT_DIR_ENT}", strEntrega);
            String strRes = strEncabezado + strCuerpoAll + strPie;
            //copiar
            
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
         }
         //Genera un pdf de jasper y lo comprime
         if (strid.equals("5")) {
            String strResp = "";
            //Recuperamos paths base
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathBase = this.getServletContext().getRealPath("/");
            //Recuperamos paths
            String strIdTicket = request.getParameter("ID");
            String strNomFormato = request.getParameter("NOM_FORMATO");
            String strNomId = "FAC_ID";
            String strNomIdParam = "fac_id";
            int intIdTicket = 0;

            if (strIdTicket.isEmpty()) {
               strIdTicket = "0";
            }
            try {
               intIdTicket = Integer.valueOf(strIdTicket);
            } catch (NumberFormatException ex) {
               System.out.println("ex ticket print:" + ex.getMessage());
            }
            //Recuperamos datos del ticket
            TableMaster ticket = null;
            if (strNomFormato.equals("FACTURA1")) {
               ticket = new vta_facturas();
            }
            ticket.ObtenDatos(intIdTicket, oConn);

            //Abrimos el formato correspondiente
            //copiar
            String strEncabezado = "";
            String strCuerpo = "";
            String strCuerpoAll = "";
            String strPie = "";
            //Datos de la empresa
            String strFor = "select * from formatos_tickets where FT_ID = '2'";
            ResultSet rsI = oConn.runQuery(strFor, true);
            while (rsI.next()) {
               strEncabezado = rsI.getString("FT_TXT_ENCABEZADO");
               strCuerpo = rsI.getString("FT_TXT_CUERPO");
               strPie = rsI.getString("FT_TXT_PIE");

            }
            rsI.close();
            //Datos de la empresa
            String strEmp = "select * from vta_empresas where EMP_ID =  " + ticket.getFieldInt("EMP_ID");
            ResultSet rs = oConn.runQuery(strEmp, true);
            while (rs.next()) {
               strEncabezado = strEncabezado.replace("{EMP_RAZONSOCIAL}", rs.getString("EMP_RAZONSOCIAL"));
               strEncabezado = strEncabezado.replace("{EMP_CALLE}", rs.getString("EMP_CALLE"));
               strEncabezado = strEncabezado.replace("{EMP_COLONIA}", rs.getString("EMP_COLONIA"));
               strEncabezado = strEncabezado.replace("{EMP_MUNICIPIO}", rs.getString("EMP_MUNICIPIO"));
               strEncabezado = strEncabezado.replace("{EMP_ESTADO}", rs.getString("EMP_ESTADO"));
               strEncabezado = strEncabezado.replace("{EMP_TELEFONO1}", rs.getString("EMP_TELEFONO1"));
               strEncabezado = strEncabezado.replace("{EMP_RFC}", rs.getString("EMP_RFC"));
               strEncabezado = strEncabezado.replace("{EMP_CP}", rs.getString("EMP_CP"));

            }
            rs.close();
            //Usuario que realizo la venta
            strEmp = "select u.nombre_usuario from usuarios u where  u.id_usuarios =  " + ticket.getFieldInt("FAC_US_ALTA");
            rs = oConn.runQuery(strEmp, true);
            while (rs.next()) {
               strEncabezado = strEncabezado.replace("{FAC_VENDEDOR}", rs.getString("nombre_usuario"));

            }
            rs.close();
            //Datos del ticket 
            strEncabezado = strEncabezado.replace("{FAC_FOLIO}", ticket.getFieldString("FAC_FOLIO"));
            strEncabezado = strEncabezado.replace("{FAC_CALLE}", ticket.getFieldString("FAC_CALLE"));
            strEncabezado = strEncabezado.replace("{FAC_COLONIA}", ticket.getFieldString("FAC_COLONIA"));
            strEncabezado = strEncabezado.replace("{FAC_MUNICIPIO}", ticket.getFieldString("FAC_MUNICIPIO"));
            strEncabezado = strEncabezado.replace("{FAC_ESTADO}", ticket.getFieldString("FAC_ESTADO"));
            strEncabezado = strEncabezado.replace("{FAC_CP}", ticket.getFieldString("FAC_CP"));
            strEncabezado = strEncabezado.replace("{FAC_LOCALIDAD}", ticket.getFieldString("FAC_LOCALIDAD"));
            strEncabezado = strEncabezado.replace("{FAC_FECHA}", ticket.getFieldString("FAC_FECHA"));
            String tempS = "SELECT TCF_DESCRIPCION from vta_tipocomp where TCF_ID = " + ticket.getFieldInt("FAC_TIPOCOMP");
            ResultSet temr = oConn.runQuery(tempS, true);
            if (temr.next()) {
               strEncabezado = strEncabezado.replace("{FAC_TIPOCOMP}", temr.getString("TCF_DESCRIPCION"));
            }
            strEncabezado = strEncabezado.replace("{FAC_REGIMEN}", ticket.getFieldString("FAC_REGIMENFISCAL"));
            strEncabezado = strEncabezado.replace("{FAC_NOTAS}", ticket.getFieldString("FAC_NOTAS"));
            strEncabezado = strEncabezado.replace("{FAC_FOLIO}", ticket.getFieldString("FAC_FOLIO"));
            strEncabezado = strEncabezado.replace("{FAC_FORMAPAGO}", ticket.getFieldString("FAC_FORMADEPAGO"));
            strEncabezado = strEncabezado.replace("{FAC_METODODEPAGO}", ticket.getFieldString("FAC_METODODEPAGO"));
            
            strPie = strPie.replace("{FAC_TOTAL}", "$" + NumberString.FormatearDecimal(ticket.getFieldDouble("FAC_TOTAL"), 2));
            StringofNumber enLetras = new StringofNumber();
            strPie = strPie.replace("{FAC_TOTALLETRA}", enLetras.getStringOfNumber(ticket.getFieldDouble("FAC_TOTAL")));
            //Detalle de las facturas
            String sqlCuerpo = "SELECT FACD_CANTIDAD,FACD_CVE, FACD_DESCRIPCION,FACD_PRECIO,FACD_IMPORTEREAL,FACD_UNIDAD_MEDIDA FROM vta_facturasdeta WHERE FAC_ID= " + ticket.getFieldInt("FAC_ID");
            ResultSet rCuerpo = oConn.runQuery(sqlCuerpo, true);
            double cantidad = 0;
            while (rCuerpo.next()) {
               String strCuerpoTemp = new String(strCuerpo);
               double importeReal = rCuerpo.getDouble("FACD_IMPORTEREAL");
               double precioUnit = rCuerpo.getDouble("FACD_PRECIO");
               double cant = rCuerpo.getDouble("FACD_CANTIDAD");
               strCuerpoTemp = strCuerpoTemp.replace("{FACD_CANTIDAD} ", NumberString.FormatearDecimal(cant, 2));
               String strDescripcion ="";
               if(rCuerpo.getString("FACD_DESCRIPCION").length() > 30)
               {
                   strDescripcion = rCuerpo.getString("FACD_DESCRIPCION").substring(0, 30);
               }
               else
               {
                   strDescripcion = rCuerpo.getString("FACD_DESCRIPCION");
               }
               strCuerpoTemp = strCuerpoTemp.replace("{FACD_DESCRIPCION} ", strDescripcion);
               strCuerpoTemp = strCuerpoTemp.replace("{FACD_PRECIO}", NumberString.FormatearDecimal(precioUnit, 2));
               strCuerpoTemp = strCuerpoTemp.replace("{FACD_IMPORTE}", NumberString.FormatearDecimal(importeReal, 2));
               strCuerpoTemp = strCuerpoTemp.replace("{FACD_CODIGO} ", rCuerpo.getString("FACD_CVE"));
               strCuerpo = strCuerpo.replace("FACD_UNIDAD", rCuerpo.getString("FACD_UNIDAD_MEDIDA"));
               cantidad += rCuerpo.getDouble("FACD_CANTIDAD");
               strCuerpoAll += strCuerpoTemp;
            }
            strPie = strPie.replace("{FAC_SUBTOTAL}", "" + ticket.getFieldDouble("FAC_IMPORTE"));
            strPie = strPie.replace("{FAC_IMPUESTO}", "" + (ticket.getFieldDouble("FAC_IMPUESTO1") + ticket.getFieldDouble("FAC_IMPUESTO2") + ticket.getFieldDouble("FAC_IMPUESTO3")));

            strPie = strPie.replace("{FAC_CANTIDAD}", "" + cantidad);

            String strCliente = "SELECT MCD_FORMAPAGO,MCD_IMPORTE,MCD_CAMBIO FROM vta_mov_cte_deta INNER JOIN vta_mov_cte ON vta_mov_cte_deta.MC_ID = vta_mov_cte.MC_ID WHERE FAC_ID=" + ticket.getFieldInt("FAC_ID");
            ResultSet rCliente = oConn.runQuery(strCliente, true);
            while (rCliente.next()) {
               strPie = strPie.replace("{FAC_FORMA_PAGO}", rCliente.getString("MCD_FORMAPAGO"));

               if (rCliente.getString("MCD_FORMAPAGO").equals("EFECTIVO")) {
                  double importe = rCliente.getDouble("MCD_IMPORTE");
                  double cambio = rCliente.getDouble("MCD_CAMBIO");
                  strPie = strPie.replace("{FAC_EFECTIVO}", NumberString.FormatearDecimal(importe, 2));
                  strPie = strPie.replace("{FAC_CAMBIO}", NumberString.FormatearDecimal(cambio, 2));
               } else {
                  strPie = strPie.replace("{FAC_EFECTIVO}", "0.0");
                  strPie = strPie.replace("{FAC_CAMBIO}", "0.0");
               }
               if (rCliente.getString("MCD_FORMAPAGO").equals("TARJETA")) {
                  double importe = rCliente.getDouble("MCD_IMPORTE");
                  strPie = strPie.replace("{FAC_TARJETA}", NumberString.FormatearDecimal(importe, 2));
                  strPie = strPie.replace("{FAC_CAMBIO}", "0.0");
               } else {
                  strPie = strPie.replace("{FAC_TARJETA}", "0.0");
                  strPie = strPie.replace("{FAC_CAMBIO}", "0.0");
               }
               if (rCliente.getString("MCD_FORMAPAGO").equals("VALES")) {
                  double importe = rCliente.getDouble("MCD_IMPORTE");
                  strPie = strPie.replace("{FAC_VALES}", NumberString.FormatearDecimal(importe, 2));
                  strPie = strPie.replace("{FAC_CAMBIO}", "0.0");
               } else {
                  strPie = strPie.replace("{FAC_VALES}", "0.0");
                  strPie = strPie.replace("{FAC_CAMBIO}", "0.0");
               }
            }
            //Datos del timbrado
            String strFact = "select FAC_SELLOTIMBRE,FAC_CADENA_TIMBRE,FAC_NUMCUENTA from vta_facturas where FAC_ID = " + ticket.getFieldInt("FAC_ID");
            ResultSet rsF = oConn.runQuery(strFact, true);
            while (rsF.next()) {
               strPie = strPie.replace("{FAC_SELLOTIMBRE}", rsF.getString("FAC_SELLOTIMBRE"));
               strPie = strPie.replace("{FAC_CADENA_TIMBRE}", rsF.getString("FAC_CADENA_TIMBRE"));
               strEncabezado = strEncabezado.replace("{FAC_NUMCUENTA}", rsF.getString("FAC_NUMCUENTA"));
            }
            rsF.close();


            String strRes = strEncabezado + strCuerpoAll + strPie;
            //copiar

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
         }
         if (strid.equals("6")) {
            String strResp = "";
            //Recuperamos paths base
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathBase = this.getServletContext().getRealPath("/");
            //Recuperamos paths
            String strIdTicket = request.getParameter("ID");
            String strNomFormato = request.getParameter("NOM_FORMATO");
            String strNomId = "NC_ID";
            String strNomIdParam = "nc_id";
            int intIdTicket = 0;

            if (strIdTicket.isEmpty()) {
               strIdTicket = "0";
            }
            try {
               intIdTicket = Integer.valueOf(strIdTicket);
            } catch (NumberFormatException ex) {
               System.out.println("ex ticket print:" + ex.getMessage());
            }
            //Recuperamos datos del ticket
            TableMaster notaCred = null;
            notaCred = new vta_ncredito();
            notaCred.ObtenDatos(intIdTicket, oConn);

            String strEncabezado = "";
            String strCuerpo = "";
            String strCuerpoAll = "";
            String strPie = "";

            String strFor = "select * from formatos_tickets where FT_ID = '3'";
            ResultSet rsI = oConn.runQuery(strFor, true);
            while (rsI.next()) {
               strEncabezado = rsI.getString("FT_TXT_ENCABEZADO");
               strCuerpo = rsI.getString("FT_TXT_CUERPO");
               strPie = rsI.getString("FT_TXT_PIE");

            }
            rsI.close();

            //Cargo el guerpo
            String sqlCuerpo = "SELECT NCD_CANTIDAD,NCD_CVE,NCD_DESCRIPCION,NCD_IMPORTEREAL,NCD_PRECIO FROM vta_ncreditodeta WHERE NC_ID =" + notaCred.getFieldInt("NC_ID");
            ResultSet rCuerpo = oConn.runQuery(sqlCuerpo, true);
            double cantidad = 0;
            while (rCuerpo.next()) {
               String tempCuerpo = new String(strCuerpo);
               double cant = rCuerpo.getDouble("NCD_CANTIDAD");
               double precio = rCuerpo.getDouble("NCD_PRECIO");
               double importe = rCuerpo.getDouble("NCD_IMPORTEREAL");
               tempCuerpo = tempCuerpo.replace("{NC_CANTIDAD}", NumberString.FormatearDecimal(cant, 2));
               tempCuerpo = tempCuerpo.replace("{NCD_CODIGO} ", rCuerpo.getString("NCD_CVE"));
               String strDescripcion = "";
               if(rCuerpo.getString("NCD_DESCRIPCION").length() > 30)
               {
                   strDescripcion =rCuerpo.getString("NCD_DESCRIPCION").substring(0, 30);
               }
               else
               {
                   strDescripcion =rCuerpo.getString("NCD_DESCRIPCION");
               }
               tempCuerpo = tempCuerpo.replace("{NC_DESCRIPCION}",strDescripcion );
               tempCuerpo = tempCuerpo.replace("{NC _PRECIO}", NumberString.FormatearDecimal(precio, 2));
               tempCuerpo = tempCuerpo.replace("{NC_IMPORTE}", NumberString.FormatearDecimal(importe, 2));
               cantidad += cant;
               strCuerpoAll += tempCuerpo;
            }
            strPie = strPie.replace("{NC_IMPORTEREAL}", NumberString.FormatearDecimal(notaCred.getFieldDouble("NC_IMPORTE"), 2));
            strPie = strPie.replace("{NC_IMPUESTO1}", NumberString.FormatearDecimal(notaCred.getFieldDouble("NC_IMPUESTO1"), 2));
            strPie = strPie.replace("{NC_IMPUESTO2}", NumberString.FormatearDecimal(notaCred.getFieldDouble("NC_IMPUESTO2"), 2));
            strPie = strPie.replace("{NC_IMPUESTO3}", NumberString.FormatearDecimal(notaCred.getFieldDouble("NC_IMPUESTO3"), 2));
            strPie = strPie.replace("{NC_IMPORTE}", NumberString.FormatearDecimal(notaCred.getFieldDouble("NC_TOTAL"), 2));
            strPie = strPie.replace("{NC_TOTAL}", NumberString.FormatearDecimal(notaCred.getFieldDouble("NC_TOTAL"), 2));
            strPie = strPie.replace("{NC_CANTIDAD} ", "" + cantidad);
            strPie = strPie.replace("{NC_FOLIO}", notaCred.getFieldString("NC_FOLIO"));
            strPie = strPie.replace("{NC_FECHA}", notaCred.getFieldString("NC_FECHA"));
            strPie = strPie.replace("{NC_HORA}", notaCred.getFieldString("NC_HORA"));
            StringofNumber enLetras = new StringofNumber();
            strPie = strPie.replace("{NC_IMPORTELETRA}", enLetras.getStringOfNumber(notaCred.getFieldDouble("NC_TOTAL")));
            String strRes = strEncabezado + strCuerpoAll + strPie;

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado  
         }
      }
   } else {
   }
   oConn.close();
%>