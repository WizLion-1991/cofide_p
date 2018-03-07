<%-- 
<%-- 
  
 
<%-- 
    Document   : gs_IngresosRL
    Created on : 15/04/2011, 01:26:59 PM
    Author     : zeus
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>

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
        Fechas fecha = new Fechas();
        //Si la peticion no fue nula proseguimos
        if (strid != null) {

            //Genera una nueva operacion de pagos en base a la transaccion que nos envian
            if (strid.equals("1")) {
                int identificador = Integer.valueOf(request.getParameter("identificador"));
                if (identificador == 1) {
                    //Obtenemos parametros
                    String strRFC = request.getParameter("strRFC");
                    String strRazonSocial = request.getParameter("strRazonSocial");

                    int intIdContratos = Integer.valueOf(request.getParameter("intIdContratos"));
                    int intIdCliente = Integer.valueOf(request.getParameter("intIdCliente"));

                    String strSql = "INSERT INTO vta_rfc_contratados (RFC_CONT_RFC,RFC_CONT_RAZONSOCIAL,CTOA_ID,CTE_ID) values"
                            + " ('" + strRFC + "','" + strRazonSocial + "','" + intIdContratos + "'," + intIdCliente + ")";

                    oConn.runQueryLMD(strSql);

                    String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                    strXML += "<vta_rfc_contratados>";
                    //Consultamos la info

                    strRFC = "";
                    strRazonSocial = "";
                    int intRFC_CONT_ID = 0;
                    String strSql1 = "SELECT * FROM vta_rfc_contratados ORDER BY RFC_CONT_ID DESC LIMIT 1";
                    ResultSet rs1 = oConn.runQuery(strSql1, true);

                    while (rs1.next()) {
                        strRFC = rs1.getString("RFC_CONT_RFC");
                        strRazonSocial = rs1.getString("RFC_CONT_RAZONSOCIAL");
                        intRFC_CONT_ID = rs1.getInt("RFC_CONT_ID");
                        strXML += "<vta_rfc_contratados1 "
                                + " RFC_CONT_RFC = \"" + strRFC + "\"  "
                                + " RFC_CONT_RAZONSOCIAL = \"" + strRazonSocial + "\"  "
                                + " RFC_CONT_ID = \"" + intRFC_CONT_ID + "\"  "
                                + " />";
                    }
                    rs1.close();
                    //El detalle
                    strXML += "</vta_rfc_contratados>";
                    //Mostramos el resultado
                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println(strXML);//Pintamos el resultado
                }

                if (identificador == 2) {
                    //Obtenemos parametros
                    int IdGridDelete = Integer.valueOf(request.getParameter("IdGridDelete"));

                    String strSql = "delete from vta_rfc_contratados where RFC_CONT_ID =" + IdGridDelete;
                    oConn.runQueryLMD(strSql);

                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println("OK");//Mandamos a pantalla el resultado

                }

                if (identificador == 3) {

                    int intIdContratos = Integer.valueOf(request.getParameter("intIdContratos"));

                    String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                    strXML += "<vta_rfc_contratados>";
                    //Consultamos la info

                    String strRFC = "";
                    String strRazonSocial = "";
                    int intRFC_CONT_ID = 0;

                    String strSql = "select * from vta_rfc_contratados where CTOA_ID =" + intIdContratos;
                    ResultSet rs = oConn.runQuery(strSql, true);

                    while (rs.next()) {
                        strRFC = rs.getString("RFC_CONT_RFC");
                        strRazonSocial = rs.getString("RFC_CONT_RAZONSOCIAL");
                        intRFC_CONT_ID = rs.getInt("RFC_CONT_ID");

                        strXML += "<vta_rfc_contratados1 "
                                + " RFC_CONT_RFC = \"" + strRFC + "\"  "
                                + " RFC_CONT_RAZONSOCIAL = \"" + strRazonSocial + "\"  "
                                + " RFC_CONT_ID = \"" + intRFC_CONT_ID + "\"  "
                                + " />";
                    }
                    rs.close();
                    //El detalle
                    strXML += "</vta_rfc_contratados>";
                    //Mostramos el resultado
                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println(strXML);//Pintamos el resultado

                }
            }

            //Genera una nueva operacion de pagos en base a la transaccion que nos envian
            if (strid.equals("2")) {
                int identificador = Integer.valueOf(request.getParameter("identificador"));
                if (identificador == 1) {
                    //Obtenemos parametros

                    String strFecha = fecha.FormateaBD(request.getParameter("intFecha"), "/");
                    String strVigencia = fecha.FormateaBD(request.getParameter("intVigencia"), "/");
                    int intFolios = Integer.valueOf(request.getParameter("intFolios"));

                    int intIdContratos = Integer.valueOf(request.getParameter("intIdContratos"));
                    int intIdCliente = Integer.valueOf(request.getParameter("intIdCliente"));

                    String strSql = "INSERT INTO vta_timbres_fiscales (TIMBFISC_FECHA,TIMBFISC_VIGENCIA,TIMBFISC_NUM_FOLIOS,CTOA_ID,CTE_ID) values"
                            + " (" + strFecha + "," + strVigencia + "," + intFolios + "," + intIdContratos + "," + intIdCliente + ")";

                    oConn.runQueryLMD(strSql);

                    String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                    strXML += "<vta_timbres_fiscales>";
                    //Consultamos la info

                    int intTIMBFISC_ID = 0;
                    strFecha = "";
                    strVigencia = "";
                    intFolios = 0;

                    String strSql1 = "select * from vta_timbres_fiscales ORDER BY TIMBFISC_ID DESC LIMIT 1";
                    ResultSet rs1 = oConn.runQuery(strSql1, true);

                    while (rs1.next()) {

                        intTIMBFISC_ID = rs1.getInt("TIMBFISC_ID");
                        strFecha = fecha.Formatea(rs1.getString("TIMBFISC_FECHA"), "/");
                        strVigencia = fecha.Formatea(rs1.getString("TIMBFISC_VIGENCIA"), "/");
                        intFolios = rs1.getInt("TIMBFISC_NUM_FOLIOS");

                        strXML += "<vta_timbres_fiscales1 "
                                + " TIMBFISC_ID = \"" + intTIMBFISC_ID + "\"  "
                                + " TIMBFISC_FECHA = \"" + strFecha + "\"  "
                                + " TIMBFISC_VIGENCIA = \"" + strVigencia + "\"  "
                                + " TIMBFISC_NUM_FOLIOS = \"" + intFolios + "\"  "
                                + " />";
                    }
                    rs1.close();
                    strXML += "</vta_timbres_fiscales>";
                    //Mostramos el resultado
                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println(strXML);//Pintamos el resultado
                }
                if (identificador == 2) {
                    //Obtenemos parametros
                    int IdGridDelete = Integer.valueOf(request.getParameter("IdGridDelete"));

                    String strSql = "delete from vta_timbres_fiscales where TIMBFISC_ID = " + IdGridDelete;
                    oConn.runQueryLMD(strSql);

                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println("OK");//Mandamos a pantalla el resultado

                }
                if (identificador == 3) {

                    int intIdContratos = Integer.valueOf(request.getParameter("intIdContratos"));

                    String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                    strXML += "<vta_timbres_fiscales>";
                    //Consultamos la info

                    int intTIMBFISC_ID = 0;
                    String strFecha = "";
                    String strVigencia = "";
                    int intFolios = 0;

                    String strSql = "select * from vta_timbres_fiscales where CTOA_ID =" + intIdContratos;
                    ResultSet rs = oConn.runQuery(strSql, true);

                    while (rs.next()) {
                        intTIMBFISC_ID = rs.getInt("TIMBFISC_ID");
                        strFecha = fecha.Formatea(rs.getString("TIMBFISC_FECHA"), "/");
                        strVigencia = fecha.Formatea(rs.getString("TIMBFISC_VIGENCIA"), "/");
                        intFolios = rs.getInt("TIMBFISC_NUM_FOLIOS");

                        strXML += "<vta_timbres_fiscales1 "
                                + " TIMBFISC_ID = \"" + intTIMBFISC_ID + "\"  "
                                + " TIMBFISC_FECHA = \"" + strFecha + "\"  "
                                + " TIMBFISC_VIGENCIA = \"" + strVigencia + "\"  "
                                + " TIMBFISC_NUM_FOLIOS = \"" + intFolios + "\"  "
                                + " />";
                    }
                    rs.close();
                    strXML += "</vta_timbres_fiscales>";
                    //Mostramos el resultado
                    out.clearBuffer();//Limpiamos buffer
                    atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                    out.println(strXML);//Pintamos el resultado

                }
            }

        }
    } else {
    }
    oConn.close();
%>
