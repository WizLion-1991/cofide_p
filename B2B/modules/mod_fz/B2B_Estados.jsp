<%-- 
    Document   : B2B_Estados
    Created on : Sep 24, 2015, 10:45:43 AM
    Author     : CasaJosefa
--%>

<%@page import="Tablas.vta_cxpagardetalle"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="ERP.CuentasxPagar"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="ERP.ConsultaAnticiposCte"%>
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

            if (strid.equals("1")) {
                String strNomPais = request.getParameter("strNomPais");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<estados>\n");

                int intIdPais = 0;

                String strSql = "select PA_ID form paises where PA_NOM = '" + strNomPais + "' ;";
                try {
                    ResultSet rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        intIdPais = rs.getInt("PA_ID");
                    }

                } catch (SQLException ex) {
                    System.out.println(ex.getMessage());
                }

                String strSql1 = "select ESP_NOMBRE form estadospais where PA_ID = '" + intIdPais + "' ;";
                try {
                    ResultSet rs = oConn.runQuery(strSql1, true);
                    while (rs.next()) {
                        strXML.append("<estados_deta ");
                        strXML.append(" ESP_NOMBRE = \"").append(rs.getString("ESP_NOMBRE")).append("\" ");
                        strXML.append(" />\n");
                    }

                } catch (SQLException ex) {
                    System.out.println(ex.getMessage());
                }

                strXML.append("</estados>\n");

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML.toString());//Pintamos el resultado

            }

            if (strid.equals("2")) {

                Fechas fecha = new Fechas();

                String strFacId = request.getParameter("strFacId");
                String strTipoVenta = request.getParameter("strTipoVenta");
                String strCodigo = request.getParameter("strCodigo");
                String strNombre = request.getParameter("strNombre");
                String strCodigoProd = request.getParameter("strCodigoProd");

                String strRazonSocial = "";
                String strCodigoFac = "";
                String strRespuesta = "";

                if (strTipoVenta.equals("F")) {
                    String strSql = "select FAC_RAZONSOCIAL,KL_CODIGO_PROV from vta_facturas where FAC_ID = " + strFacId + " ; ";
                    try {
                        ResultSet rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            strRazonSocial = rs.getString("FAC_RAZONSOCIAL");
                            strCodigoFac = rs.getString("KL_CODIGO_PROV");

                        }
                        rs.close();
                    } catch (SQLException ex) {
                        System.out.println(ex.getMessage());
                    }

                    if (strCodigo.equals(strCodigoFac) && strNombre.equals(strRazonSocial)) {
                        String strUpdate = "update vta_facturas set KL_CODIGO_APROVADO = 1 where FAC_ID = " + strFacId;
                        oConn.runQueryLMD(strUpdate);

                        String strSql4 = "select * from vta_facturas where FAC_ID = " + strFacId + " ; ";
                        try {
                            ResultSet rs = oConn.runQuery(strSql4, true);
                            while (rs.next()) {

                                int CP_EMP_ID = rs.getInt("EMP_ID");
                                int CP_SC_ID = rs.getInt("SC_ID");

                                //Llenamos la cuenta por Pagar 
                                //Instanciamos el objeto que generara la venta
                                CuentasxPagar cuenta = new CuentasxPagar(oConn, varSesiones, request);
                                //Recibimos parametros
                                String strPrefijoMaster = "CXP";
                                String strPrefijoDeta = "CXPD";

                                String strPrefijoMaster1 = "FAC";
                                String strPrefijoDeta1 = "FACD";
                                //Validamos si tenemos un empresa seleccionada
                                if (CP_EMP_ID != 0) {
                                    //Asignamos la empresa seleccionada
                                    cuenta.setIntEMP_ID(CP_EMP_ID);
                                    cuenta.getDocument().setFieldInt("EMP_ID", CP_EMP_ID);
                                }

                                //Recibimos datos para signarlos al objeto 
                                cuenta.getDocument().setFieldInt("SC_ID", CP_SC_ID);
                                cuenta.getDocument().setFieldInt("PV_ID", varSesiones.getintIdCliente());

                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_MONEDA")));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA", rs.getString(strPrefijoMaster1 + "_FECHA"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA_CONFIRMA", rs.getString(strPrefijoMaster1 + "_FECHAAPROB"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA_PROVISION", rs.getString(strPrefijoMaster1 + "_FECHAAPROB"));

                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", rs.getString(strPrefijoMaster1 + "_FOLIO"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", rs.getString(strPrefijoMaster1 + "_NOTAS"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", rs.getString(strPrefijoMaster1 + "_REFERENCIA"));

                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPORTE")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPUESTO1")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPUESTO2")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPUESTO3")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TOTAL")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TASA1")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TASA2")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TASA3")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_RETISR", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_RETISR")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_RETIVA", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_RETIVA")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_NETO", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_NETO")));

                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_USO_IEPS")));
                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_TASA_IEPS")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPORTE_IEPS")));
                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_DIASCREDITO")));

                                cuenta.getDocument().setFieldString("PED_COD", rs.getString(strPrefijoMaster1 + "_NUMPEDI"));
                                if (rs.getString(strPrefijoMaster1 + "_NUMPEDI") != null) {
                                    try {
                                        cuenta.getDocument().setFieldInt("PED_ID", Integer.valueOf(rs.getString(strPrefijoMaster1 + "_NUMPEDI")));
                                    } catch (NumberFormatException ex) {
                                    }
                                }

                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", rs.getString(strPrefijoMaster1 + "_ADUANA"));

                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_UUID", rs.getString(strPrefijoMaster1 + "_UUID"));

                                /*
                                 String strFechaPedimento = request.getParameter(strPrefijoMaster + "_FECHAPEDI");
                                 if (strFechaPedimento.contains("/") && strFechaPedimento.length() == 10) {
                                 strFechaPedimento = fecha.FormateaBD(strFechaPedimento, "/");
                                 }
                                 cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", strFechaPedimento);*/
                                //Tarifas de IVA
                                int intTI_ID = 0;
                                int intTI_ID2 = 0;
                                int intTI_ID3 = 0;
                                try {
                                    intTI_ID = Integer.valueOf(rs.getInt("TI_ID"));
                                    intTI_ID2 = Integer.valueOf(rs.getInt("TI_ID2"));
                                    intTI_ID3 = Integer.valueOf(rs.getInt("TI_ID3"));
                                } catch (NumberFormatException ex) {
                                    System.out.println("CXPAGAR TI_ID " + ex.getMessage());
                                }
                                cuenta.getDocument().setFieldInt("TI_ID", intTI_ID);
                                cuenta.getDocument().setFieldInt("TI_ID2", intTI_ID2);
                                cuenta.getDocument().setFieldInt("TI_ID3", intTI_ID3);
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", request.getParameter(strPrefijoMaster1 + "_NOTASPIE"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster1 + "_CONDPAGO"));

                                //Recibimos datos de los items o partidas
                                String strSql2 = "select * from vta_facturasdeta where FAC_ID = " + strFacId + " ;";
                                try {
                                    ResultSet rs1 = oConn.runQuery(strSql2, true);
                                    while (rs1.next()) {

                                        String strUpdate1 = "update vta_facturasdeta set FACD_CONFIRMADO = 1 where FACD_ID = " + rs1.getInt("FACD_ID") + "' ;";
                                        oConn.runQueryLMD(strUpdate1);

                                        TableMaster deta = new vta_cxpagardetalle();
                                        deta.setFieldInt("PR_ID", Integer.valueOf(rs1.getInt("PR_ID")));
                                        deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_EXENTO1")));
                                        deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_EXENTO2")));
                                        deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_EXENTO3")));
                                        deta.setFieldString(strPrefijoDeta + "_CVE", rs1.getString(strPrefijoDeta1 + "_CVE"));
                                        deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", rs1.getString(strPrefijoDeta1 + "_DESCRIPCION"));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPORTE")));
                                        deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_CANTIDAD")));
                                        deta.setFieldDouble(strPrefijoDeta + "_TASAIVA1", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_TASAIVA1")));
                                        deta.setFieldDouble(strPrefijoDeta + "_TASAIVA2", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_TASAIVA2")));
                                        deta.setFieldDouble(strPrefijoDeta + "_TASAIVA3", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_TASAIVA3")));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO1", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPUESTO1")));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO2", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPUESTO2")));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO3", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPUESTO3")));
                                        deta.setFieldDouble(strPrefijoDeta + "_COSTO", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_COSTO")));
                                        deta.setFieldDouble(strPrefijoDeta + "_RET_ISR", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_RET_ISR")));
                                        deta.setFieldDouble(strPrefijoDeta + "_RET_IVA", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_RET_IVA")));

                                        deta.setFieldDouble("GT_ID", Integer.valueOf(0));
                                        deta.setFieldDouble("CC_ID", Integer.valueOf(0));
                                        cuenta.AddDetalle(deta);
                                    }
                                } catch (SQLException ex) {
                                    System.out.println(ex.getMessage());
                                }

                                //Inicializamos objeto
                                cuenta.Init();
                                //Pasamos los datos de los archivos
                                //cuenta.setStrXMLFileName(request.getParameter(strPrefijoMaster + "_XMLFILE"));
                                //cuenta.setStrPDFFileName(request.getParameter(strPrefijoMaster + "_PDFFILE"));
                                cuenta.setstrPathBase2(this.getServletContext().getRealPath("/"));
                                //Generamos transaccion
                                cuenta.doTrx();

                                if (cuenta.getStrResultLast().equals("OK")) {
                                    strRespuesta = "OK";
                                    //strRespuesta = "OK." + cuenta.getDocument().getValorKey();
                                    //intCXP_ID = Integer.valueOf(cuenta.getDocument().getValorKey());
                                } else {
                                    strRespuesta = cuenta.getStrResultLast();
                                    //intCXP_ID = 0;
                                }

                            }
                        } catch (SQLException ex) {
                            System.out.println(ex.getMessage());
                        }
                    } else {
                        if (!strCodigo.equals(strCodigoFac)) {
                            strRespuesta = "El codigo no coincide ";
                        }
                        if (!strNombre.equals(strRazonSocial)) {
                            strRespuesta += " El nombre no coincide";
                        }
                    }
                }

                if (strTipoVenta.equals("T")) {
                    String strSql = "select KL_CODIGO_PROV,TKT_RAZONSOCIAL from vta_tickets where TKT_ID = " + strFacId + " ; ";
                    try {
                        ResultSet rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            strRazonSocial = rs.getString("TKT_RAZONSOCIAL");
                            strCodigoFac = rs.getString("KL_CODIGO_PROV");
                        }
                    } catch (SQLException ex) {
                        System.out.println(ex.getMessage());
                    }

                    if (strCodigo.equals(strCodigoFac) && strNombre.equals(strRazonSocial)) {
                        String strUpdate = "update vta_tickets set KL_CODIGO_APROVADO = 1 where TKT_ID = " + strFacId;
                        oConn.runQueryLMD(strUpdate);

                        String strSql4 = "select * from vta_tickets where TKT_ID = " + strFacId + " ; ";
                        try {
                            ResultSet rs = oConn.runQuery(strSql4, true);
                            while (rs.next()) {

                                int CP_EMP_ID = rs.getInt("EMP_ID");
                                int CP_SC_ID = rs.getInt("SC_ID");

                                //Llenamos la cuenta por Pagar 
                                //Instanciamos el objeto que generara la venta
                                CuentasxPagar cuenta = new CuentasxPagar(oConn, varSesiones, request);
                                //Recibimos parametros
                                String strPrefijoMaster = "CXP";
                                String strPrefijoDeta = "CXPD";

                                String strPrefijoMaster1 = "TKT";
                                String strPrefijoDeta1 = "TKTD";
                                //Validamos si tenemos un empresa seleccionada
                                if (CP_EMP_ID != 0) {
                                    //Asignamos la empresa seleccionada
                                    cuenta.setIntEMP_ID(CP_EMP_ID);
                                    cuenta.getDocument().setFieldInt("EMP_ID", CP_EMP_ID);
                                }

                                //Recibimos datos para signarlos al objeto 
                                cuenta.getDocument().setFieldInt("SC_ID", CP_SC_ID);
                                cuenta.getDocument().setFieldInt("PV_ID", varSesiones.getintIdCliente());

                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_MONEDA")));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA", rs.getString(strPrefijoMaster1 + "_FECHA"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA_CONFIRMA", rs.getString(strPrefijoMaster1 + "_FECHA"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHA_PROVISION", rs.getString(strPrefijoMaster1 + "_FECHA"));

                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", rs.getString(strPrefijoMaster1 + "_FOLIO"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", rs.getString(strPrefijoMaster1 + "_NOTAS"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", rs.getString(strPrefijoMaster1 + "_REFERENCIA"));

                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPORTE")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPUESTO1")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPUESTO2")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPUESTO3")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TOTAL")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TASA1")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TASA2")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_TASA3")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_RETISR", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_RETISR")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_RETIVA", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_RETIVA")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_NETO", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_NETO")));

                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_USO_IEPS", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_USO_IEPS")));
                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_TASA_IEPS", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_TASA_IEPS")));
                                cuenta.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_IEPS", Double.valueOf(rs.getDouble(strPrefijoMaster1 + "_IMPORTE_IEPS")));
                                cuenta.getDocument().setFieldInt(strPrefijoMaster + "_DIASCREDITO", Integer.valueOf(rs.getInt(strPrefijoMaster1 + "_DIASCREDITO")));

                                cuenta.getDocument().setFieldString("PED_COD", rs.getString(strPrefijoMaster1 + "_NUMPEDI"));
                                if (rs.getString(strPrefijoMaster1 + "_NUMPEDI") != null) {
                                    try {
                                        cuenta.getDocument().setFieldInt("PED_ID", Integer.valueOf(rs.getString(strPrefijoMaster1 + "_NUMPEDI")));
                                    } catch (NumberFormatException ex) {
                                    }
                                }

                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_ADUANA", rs.getString(strPrefijoMaster1 + "_ADUANA"));

                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_UUID", "");

                                /*
                                 String strFechaPedimento = request.getParameter(strPrefijoMaster + "_FECHAPEDI");
                                 if (strFechaPedimento.contains("/") && strFechaPedimento.length() == 10) {
                                 strFechaPedimento = fecha.FormateaBD(strFechaPedimento, "/");
                                 }
                                 cuenta.getDocument().setFieldString(strPrefijoMaster + "_FECHAPEDI", strFechaPedimento);*/
                                //Tarifas de IVA
                                int intTI_ID = 0;
                                int intTI_ID2 = 0;
                                int intTI_ID3 = 0;
                                try {
                                    intTI_ID = Integer.valueOf(rs.getInt("TI_ID"));
                                    intTI_ID2 = Integer.valueOf(rs.getInt("TI_ID2"));
                                    intTI_ID3 = Integer.valueOf(rs.getInt("TI_ID3"));
                                } catch (NumberFormatException ex) {
                                    System.out.println("CXPAGAR TI_ID " + ex.getMessage());
                                }
                                cuenta.getDocument().setFieldInt("TI_ID", intTI_ID);
                                cuenta.getDocument().setFieldInt("TI_ID2", intTI_ID2);
                                cuenta.getDocument().setFieldInt("TI_ID3", intTI_ID3);
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", request.getParameter(strPrefijoMaster1 + "_NOTASPIE"));
                                cuenta.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", request.getParameter(strPrefijoMaster1 + "_CONDPAGO"));

                                //Recibimos datos de los items o partidas
                                String strSql2 = "select * from vta_ticketsdeta where TKT_ID = " + strFacId + " ;";
                                try {
                                    ResultSet rs1 = oConn.runQuery(strSql2, true);
                                    while (rs1.next()) {

                                        String strUpdate1 = "update vta_ticketsdeta set TKTD_CONFIRMADO = 1 where TKTD_ID = " + rs1.getInt("TKTD_ID") + " ;";
                                        oConn.runQueryLMD(strUpdate1);

                                        TableMaster deta = new vta_cxpagardetalle();
                                        deta.setFieldInt("PR_ID", Integer.valueOf(rs1.getInt("PR_ID")));
                                        deta.setFieldInt(strPrefijoDeta + "_EXENTO1", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_EXENTO1")));
                                        deta.setFieldInt(strPrefijoDeta + "_EXENTO2", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_EXENTO2")));
                                        deta.setFieldInt(strPrefijoDeta + "_EXENTO3", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_EXENTO3")));
                                        deta.setFieldString(strPrefijoDeta + "_CVE", rs1.getString(strPrefijoDeta1 + "_CVE"));
                                        deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", rs1.getString(strPrefijoDeta1 + "_DESCRIPCION"));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPORTE")));
                                        deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_CANTIDAD")));
                                        deta.setFieldDouble(strPrefijoDeta + "_TASAIVA1", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_TASAIVA1")));
                                        deta.setFieldDouble(strPrefijoDeta + "_TASAIVA2", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_TASAIVA2")));
                                        deta.setFieldDouble(strPrefijoDeta + "_TASAIVA3", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_TASAIVA3")));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO1", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPUESTO1")));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO2", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPUESTO2")));
                                        deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO3", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_IMPUESTO3")));
                                        deta.setFieldDouble(strPrefijoDeta + "_COSTO", Double.valueOf(rs1.getDouble(strPrefijoDeta1 + "_COSTO")));
                                        deta.setFieldDouble(strPrefijoDeta + "_RET_ISR", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_RET_ISR")));
                                        deta.setFieldDouble(strPrefijoDeta + "_RET_IVA", Integer.valueOf(rs1.getInt(strPrefijoDeta1 + "_RET_IVA")));

                                        deta.setFieldDouble("GT_ID", Integer.valueOf(0));
                                        deta.setFieldDouble("CC_ID", Integer.valueOf(0));
                                        cuenta.AddDetalle(deta);
                                    }
                                } catch (SQLException ex) {
                                    System.out.println(ex.getMessage());
                                }

                                //Inicializamos objeto
                                cuenta.Init();
                                //Pasamos los datos de los archivos
                                //cuenta.setStrXMLFileName(request.getParameter(strPrefijoMaster + "_XMLFILE"));
                                //cuenta.setStrPDFFileName(request.getParameter(strPrefijoMaster + "_PDFFILE"));
                                cuenta.setstrPathBase2(this.getServletContext().getRealPath("/"));
                                //Generamos transaccion
                                cuenta.doTrx();

                                if (cuenta.getStrResultLast().equals("OK")) {
                                    strRespuesta = "OK";
                                    //strRespuesta = "OK." + cuenta.getDocument().getValorKey();
                                    //intCXP_ID = Integer.valueOf(cuenta.getDocument().getValorKey());
                                } else {
                                    strRespuesta = cuenta.getStrResultLast();
                                    //intCXP_ID = 0;
                                }

                            }
                        } catch (SQLException ex) {
                            System.out.println(ex.getMessage());
                        }

                    } else {
                        if (!strCodigo.equals(strCodigoFac)) {
                            strRespuesta = "El codigo no coincide ";
                        }
                        if (!strNombre.equals(strRazonSocial)) {
                            strRespuesta += " El nombre no coincide";
                        }
                    }
                }

                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<CODIGO>";

                strXMLData += "<CODIGO_DETA";
                strXMLData += " strRespuesta=\'" + strRespuesta + "\'";
                strXMLData += "/>";

                strXMLData += "</CODIGO>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }

        }
    } else {
        /**
         * **************Acceso externo*******
         */
        if (seg.ValidaURL(request)) {
            String strid = request.getParameter("id");
            //Si la peticion no fue nula proseguimos
            if (strid != null) {
                //Regresa datos basicos del Cliente

                if (strid.equals("1")) {
                    String strNomPais = request.getParameter("strNomPais");
                    StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                    strXML.append("<estados>\n");

                    int intIdPais = 0;

                    String strSql = "select PA_ID form paises where PA_NOM = '" + strNomPais + "' ;";
                    try {
                        ResultSet rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            intIdPais = rs.getInt("PA_ID");
                        }

                    } catch (SQLException ex) {
                        System.out.println(ex.getMessage());
                    }

                    String strSql1 = "select ESP_NOMBRE form estadospais where PA_ID = '" + intIdPais + "' ;";
                    try {
                        ResultSet rs = oConn.runQuery(strSql1, true);
                        while (rs.next()) {
                            strXML.append("<estados_deta ");
                            strXML.append(" ESP_NOMBRE = \"").append(rs.getString("ESP_NOMBRE")).append("\" ");
                            strXML.append(" />\n");
                        }

                    } catch (SQLException ex) {
                        System.out.println(ex.getMessage());
                    }

                    strXML.append("</estados>\n");

                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println(strXML.toString());//Pintamos el resultado

                }

                if (strid.equals("2")) {

                    String strFacId = request.getParameter("strFacId");
                    String strTipoVenta = request.getParameter("strTipoVenta");
                    String strCodigo = request.getParameter("strCodigo");
                    String strNombre = request.getParameter("strNombre");

                    String strRazonSocial = "";
                    String strCodigoFac = "";

                    String strRespuesta = "";

                    if (strTipoVenta.equals("F")) {
                        String strSql = "select KL_CODIGO_PROV,FAC_RAZONSOCIAL from vta_facturas where FAC_ID = " + strFacId + " ; ";
                        try {
                            ResultSet rs = oConn.runQuery(strSql, true);
                            while (rs.next()) {
                                strRazonSocial = rs.getString("FAC_RAZONSOCIAL");
                                strCodigoFac = rs.getString("KL_CODIGO_PROV");
                            }
                        } catch (SQLException ex) {
                            System.out.println(ex.getMessage());
                        }

                        if (strCodigo.equals(strCodigoFac) && strNombre.equals(strRazonSocial)) {
                            String strUpdate = "update vta_facturas set KL_CODIGO_APROVADO = 1 where FAC_ID = " + strFacId;
                            oConn.runQueryLMD(strUpdate);
                            strRespuesta = "OK";
                        } else {
                            if (!strCodigo.equals(strCodigoFac)) {
                                strRespuesta = "El codigo no coincide ";
                            }
                            if (!strNombre.equals(strRazonSocial)) {
                                strRespuesta += " El nombre no coincide";
                            }
                        }
                    }

                    if (strTipoVenta.equals("T")) {
                        String strSql = "select KL_CODIGO_PROV,TKT_RAZONSOCIAL from vta_tickets where TKT_ID = " + strFacId + " ; ";
                        try {
                            ResultSet rs = oConn.runQuery(strSql, true);
                            while (rs.next()) {
                                strRazonSocial = rs.getString("TKT_RAZONSOCIAL");
                                strCodigoFac = rs.getString("KL_CODIGO_PROV");
                            }
                        } catch (SQLException ex) {
                            System.out.println(ex.getMessage());
                        }

                        if (strCodigo.equals(strCodigoFac) && strNombre.equals(strRazonSocial)) {
                            String strUpdate = "update vta_tickets set KL_CODIGO_APROVADO = 1 where TKT_ID = " + strFacId;
                            oConn.runQueryLMD(strUpdate);
                            strRespuesta = "OK";
                        } else {
                            if (!strCodigo.equals(strCodigoFac)) {
                                strRespuesta = "El codigo no coincide ";
                            }
                            if (!strNombre.equals(strRazonSocial)) {
                                strRespuesta += " El nombre no coincide";
                            }
                        }
                    }
                    String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                    strXMLData += "<CODIGO>";

                    strXMLData += "<CODIGO_DETA";
                    strXMLData += " strRespuesta=\'" + strRespuesta + "\'";
                    strXMLData += "/>";

                    strXMLData += "</CODIGO>";
                    String strRes = strXMLData.toString();
                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println(strRes);//Pintamos el resultado

                }
            }
        }
    }
%>