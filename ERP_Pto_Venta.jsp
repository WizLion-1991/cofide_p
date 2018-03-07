<%-- 
    Document   : ERP_Pto_Venta
    Created on : 07-dic-2015, 12:56:55
    Author     : casajosefa
--%>

<%@page import="Tablas.VtaAperCajaDeta"%>
<%@page import="Tablas.VtaAperCaja"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();

    UtilXml util = new UtilXml();
    String strSql;
    ResultSet rs;
    Fechas fec = new Fechas();
    String strResult = "";

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            if (strid.equals("1")) {
                strSql = "";
                rs = null;
                //Consultamos los detalles de cada combo
                int strIdUser = varSesiones.getIntNoUser();
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Datos_User>";
                try {
                    strSql = "select id_usuarios, nombre_usuario,usuarios.SUC_DEFA, CURDATE() as APC_FECHA, "
                            + "(select MAX(APC_ID) from vta_aper_caja) as APC_ID, "
                            + "(select SM_NOMBRE from vta_sucursales_master where SM_ID = " + varSesiones.getIntSucursalMaster() + ") as SUCURSAL, "
                            + "(select SC_NOMBRE from vta_sucursal where SC_ID = " + varSesiones.getIntSucursalDefault() + ") as BODEGA "
                            + "from usuarios where id_usuarios = " + strIdUser;

                    rs = oConn.runQuery(strSql);
                    while (rs.next()) {
                        int intAPC_ID = 0;
                        if (rs.getString("APC_ID") != null) {
                            intAPC_ID = rs.getInt("APC_ID") + 1;
                        } else {
                            intAPC_ID += 1;
                        }
                        strXMLData += "<datos";
                        strXMLData += " SUCURSAL =\"" + util.Sustituye(rs.getString("SUCURSAL")) + "\"";
                        strXMLData += " APC_ID =\"" + intAPC_ID + "\"";
                        strXMLData += " BODEGA =\"" + util.Sustituye(rs.getString("BODEGA")) + "\"";
                        strXMLData += " SC_CAJA =\"" + varSesiones.getIntSucursalDefault() + "\"";
                        strXMLData += " ID_USER =\"" + rs.getString("id_usuarios") + "\"";
                        strXMLData += " NOMBRE_USER =\"" + util.Sustituye(rs.getString("nombre_usuario")) + "\"";
                        strXMLData += "/>";
                    }

                    strSql = "select * from vta_saldos_iniciales";
                    rs = oConn.runQuery(strSql);
                    while (rs.next()) {
                        strXMLData += "<aper_caja";
                        strXMLData += " SI_VALOR =\"" + util.Sustituye(rs.getString("SI_VALOR")) + "\"";
                        strXMLData += " SI_PESOS =\"" + rs.getInt("SI_PESOS") + "\"";
                        strXMLData += " SI_DOLARES =\"" + rs.getInt("SI_DOLARES") + "\"";
                        strXMLData += "/>";
                    }
                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</Datos_User>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin ID 1

            if (strid.equals("2")) {
                strSql = "";
                rs = null;
                strSql = "select * from vta_formaspago";
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Formas_Pago>";
                try {

                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strXMLData += " Descripcion =\"" + rs.getString("FP_DESCRIPCION") + "\"";
                        strXMLData += "/>";
                    }
                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</Formas_Pago>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 2

            if (strid.equals("3")) {
                strSql = "";
                rs = null;
                String strRes = "<table><tr>";
                int intContador = 0;
                strSql = "select * from vta_combo where CMB_ESTATUS = 1 and EMP_ID =  " + varSesiones.getIntIdEmpresa() + " LIMIT 10";
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        intContador = intContador + 1;
                        strRes += ""
                                + "<td id=\"box_combo\">"
                                + "<i class = \"fa fa-archive\" style=\"font-size:45px\" onclick=\"callCMB(" + rs.getInt("CMB_ID") + ");\"><br>"
                                + "<span style=\"font-size:10px\" class=\"titles_main_1\">COMBO " + intContador + "</span></i></td>"
                                + "<td>&nbsp;&nbsp;&nbsp;</td>";

                        if (intContador == 2 || intContador == 4 || intContador == 6 || intContador == 8) {
                            strRes += "</tr><tr>";
                        }
                        if (intContador == 10) {
                            strRes += "</tr>";
                        }
                    }
                    strRes += "</table>";
                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 3

            if (strid.equals("4")) {
                String strCodigo = request.getParameter("PR_CODIGO");
                String strRes = "";
                strRes = isProd(strCodigo, varSesiones, oConn);

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 4

            if (strid.equals("5")) {
                strSql = "";
                rs = null;
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Producto>";
                String strCodigo = request.getParameter("PR_CODIGO");
                String tmpQuery = isProd(strCodigo, varSesiones, oConn);

                if (tmpQuery.equals("COMBO")) {
                    strSql = "select * from vta_combo where CMB_CODIGO = '" + strCodigo + "' and EMP_ID = " + varSesiones.getIntIdEmpresa();
                    try {
                        rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            strXMLData += "<Descripcion";
                            strXMLData += " PR_CODIGO =\"" + rs.getString("CMB_CODIGO") + "\"";
                            strXMLData += " PR_DESC =\"" + util.Sustituye(rs.getString("CMB_DESCRIPCION")) + "\"";
                            strXMLData += " PR_PRECU =\"0.0\"";
                            strXMLData += " PR_EXISTENCIA =\"0\"";
                            strXMLData += " PR_TOTAL =\"" + rs.getDouble("CMB_PREC_TIENDA") + "\"";
                            strXMLData += " PR_CANTIDAD =\"1\"";
                            strXMLData += "/>";
                            strXMLData += getDetalles(rs.getInt("CMB_ID"), oConn);
                        }
                        rs.close();

                    } catch (SQLException ex) {
                        ex.fillInStackTrace();
                    }

                } else {
                    if (tmpQuery.equals("PRODUCTO")) {
                        strSql = "select * from vta_producto where PR_CODIGO = '" + strCodigo + "' and SC_ID = " + varSesiones.getIntSucursalDefault() + " and EMP_ID = " + varSesiones.getIntIdEmpresa();
                        try {
                            rs = oConn.runQuery(strSql, true);
                            while (rs.next()) {
                                strXMLData += "<Descripcion";
                                strXMLData += " PR_ID =\"" + rs.getString("PR_ID") + "\"";
                                strXMLData += " PR_CODIGO =\"" + rs.getString("PR_CODIGO") + "\"";
                                strXMLData += " PR_DESC =\"" + util.Sustituye(rs.getString("PR_DESCRIPCION")) + "\"";
                                strXMLData += " PR_PRECU =\"" + rs.getDouble("PR_COSTOCOMPRA") + "\"";
                                strXMLData += " PR_EXISTENCIA =\"" + rs.getString("PR_EXISTENCIA") + "\"";
                                strXMLData += " PR_TOTAL =\"" + rs.getDouble("PR_COSTOCOMPRA") + "\"";
                                strXMLData += " PR_CANTIDAD =\"1\"";
                                strXMLData += "/>";
                            }
                            rs.close();
                        } catch (SQLException ex) {
                            ex.fillInStackTrace();
                        }
                    }
                }

                strXMLData += "</Producto>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 5

            if (strid.equals("6")) {
                //Llena la apertura de caja
                String strHora = "";
                SimpleDateFormat hour = new SimpleDateFormat("HH:mm");
                Date now = new Date(System.currentTimeMillis());
                strHora = hour.format(now);
                String strFecha = request.getParameter("APC_FECHA");
                strFecha = fec.FormateaBD(strFecha, "/");

                String strTPesos = request.getParameter("TOTAL_PESOS");
                String strTDolares = request.getParameter("TOTAL_DOLARES");
                
                //Llamamos objeto para guardar los datos de la tabla
                VtaAperCaja aper_caja = new VtaAperCaja();

                aper_caja.setFieldString("APC_FECHA_APER", strFecha);
                aper_caja.setFieldInt("SC_ID", varSesiones.getIntSucursalDefault());
                aper_caja.setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
                aper_caja.setFieldString("APC_HORA_APER", strHora);
                aper_caja.setFieldDouble("id_usuario", varSesiones.getIntNoUser());
                aper_caja.setFieldDouble("APC_ESTATUS", 1);
                aper_caja.setFieldDouble("APC_TOTAL_PESOS", 0);
                aper_caja.setFieldDouble("APC_TOTAL_DOLARES", 0);
                //Generamos una alta
                strResult = aper_caja.Agrega(oConn);

                String strAperID = aper_caja.getValorKey();

                int idApc = 0;
                if (!strAperID.equals("") || strAperID != null) {
                    idApc = Integer.parseInt(strAperID);
                }
                String strLength = request.getParameter("LENGTH");
                int intLenght = Integer.parseInt(strLength);

                String strValor = "";
                String strValorPeso = "";
                String strValorUSD = "";
                String strEditaPeso = "";
                String strEditaDolar = "";

                if (strResult.equals("OK")) {
                    double dblMPX = 0.0;
                    double dblUSD = 0.0;
                    VtaAperCajaDeta aperDeta = new VtaAperCajaDeta();
                    for (int i = 0; i < intLenght; i++) {
                        strValor = request.getParameter("SI_VALOR_" + i);
                        if (request.getParameter("SI_VALPESOS_" + i) != null || request.getParameter("SI_VALPESOS_" + i) != "") {
                            strValorPeso = request.getParameter("SI_VALPESOS_" + i);
                        } else {
                            strValorPeso = "0.0";
                        }
                        if (request.getParameter("SI_VALUSD_" + i) != null || request.getParameter("SI_VALUSD_" + i) != "") {
                            strValorUSD = request.getParameter("SI_VALUSD_" + i);
                        } else {
                            strValorUSD = "0.0";
                        }
                        strEditaPeso = request.getParameter("EDITA_PESOS_" + i);
                        strEditaDolar = request.getParameter("EDITA_DOLARES_" + i);

                        aperDeta.setFieldDouble("APCD_VALOR", Double.parseDouble(strValor));
                        if (Integer.parseInt(strEditaPeso) == 0) {
                            aperDeta.setFieldDouble("APCD_PESOS", 0.0);
                        } else {
                            aperDeta.setFieldDouble("APCD_PESOS", Double.parseDouble(strValorPeso));
                            dblMPX = dblMPX + (Double.parseDouble(strValorPeso) * Double.parseDouble(strValor));
                        }
                        if (Integer.parseInt(strEditaDolar) == 0) {
                            aperDeta.setFieldDouble("APCD_DOLARES", 0.0);
                        } else {
                            aperDeta.setFieldDouble("APCD_DOLARES", Double.parseDouble(strValorUSD));
                            dblUSD = dblUSD + (Double.parseDouble(strValorUSD) * Double.parseDouble(strValor));
                        }
                        aperDeta.setFieldInt("APC_ID", idApc);

                        //Generamos una alta
                        strResult = aperDeta.Agrega(oConn);
                    }
                    if (strResult.equals("OK")) {
                        aper_caja.setFieldDouble("APC_TOTAL_PESOS", dblMPX);
                        aper_caja.setFieldDouble("APC_TOTAL_DOLARES", dblUSD);
                        aper_caja.Modifica(oConn);
                    }
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strResult);//Pintamos el resultado
            }//Fin ID 6

            if (strid.equals("7")) {
                strSql = "";
                rs = null;
                strSql = "select (select SM_NOMBRE from vta_sucursales_master where SM_ID = " + varSesiones.getIntSucursalMaster() + ") as SUCURSAL,"
                        + "(select SC_NOMBRE from vta_sucursal where SC_ID = " + varSesiones.getIntSucursalDefault() + ") as BODEGA ,"
                        + "(select nombre_usuario from usuarios where id_usuarios = " + varSesiones.getIntNoUser() + ") as vendedor "
                        + "from vta_sucursal inner join vta_cliente on vta_sucursal.CT_ID = vta_cliente.CT_ID where  vta_sucursal.SC_ID = " + varSesiones.getIntSucursalDefault();

                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Ventas_M>";
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strXMLData += " PTO_SUCURSAL =\"" + rs.getString("SUCURSAL") + "\"";
                        strXMLData += " PTO_BODEGA =\"" + rs.getString("BODEGA") + "\"";
                        strXMLData += " SC_ID =\"" + varSesiones.getIntSucursalDefault() + "\"";
                        strXMLData += " PTO_VENDEDOR =\"" + rs.getString("vendedor") + "\"";
                        strXMLData += " PTO_VE_ID =\"" + varSesiones.getIntNoUser() + "\"";
                        strXMLData += "/>";
                    }
                    rs.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXMLData += "</Ventas_M>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 7
            
            if (strid.equals("8")){
                strResult = "NO EXISTE";
                strSql = "select * from vta_aper_caja where id_usuario = " + varSesiones.getIntNoUser() +" and EMP_ID = " + varSesiones.getIntIdEmpresa() +""
                        + " and SC_ID = " + varSesiones.getIntSucursalDefault() +" and APC_FECHA_APER = '" + fec.getFechaActual() + "' and APC_ESTATUS = 1";
                
                rs = oConn.runQuery(strSql, true);
                while(rs.next()){
                    strResult = "EXISTE";
                }
                rs.close();
                
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strResult);//Pintamos el resultado
            }//Fin ID 8
            
            if(strid.equals("9")){                
                strSql = "";
                String strMonto = request.getParameter("MONTO");
                double dblMonto = Double.parseDouble(strMonto);
                rs = null;
                strSql = "select * from vta_saldos_iniciales where SI_ID >= 5";
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Monedas>";
                try {

                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strXMLData += " Descripcion =\"" + rs.getDouble("SI_VALOR") + "\"";
                        strXMLData += "/>";
                    }
                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</Monedas>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 9
            
            if(strid.equals("10")){
                String strCodigo = request.getParameter("PR_CODIGO");
                strSql = "select CMB_ID from vta_combo where CMB_CODIGO = '" + strCodigo + "';";
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<ID_CMB>";
                try {

                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strXMLData += " CMB_ID =\"" + rs.getInt("CMB_ID") + "\"";
                        strXMLData += "/>";
                    }
                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</ID_CMB>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }

        }//Fin ID Null
    } else {
        out.println("Sin acceso");
    }
    oConn.close();

%>

<%!
    UtilXml util = new UtilXml();

    public String isProd(String strCodigo, VariableSession varSesiones, Conexion oConn) {
        String Resultado = "";
        boolean blIsPR = false;
        boolean blIsCMB = false;
        String strSql = "select * from vta_producto where PR_CODIGO = '" + strCodigo + "' and SC_ID = " + varSesiones.getIntSucursalDefault() + " and EMP_ID = " + varSesiones.getIntIdEmpresa();
        try {
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                if (rs.getString("PR_CODIGO") != "") {
                    blIsPR = true;
                    Resultado = "PRODUCTO";
                }
            }

            if (!blIsPR) {
                strSql = "select * from vta_combo where CMB_CODIGO = '" + strCodigo + "' and EMP_ID = " + varSesiones.getIntIdEmpresa();
                rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    if (rs.getString("CMB_CODIGO") != "") {
                        blIsCMB = true;
                        Resultado = "COMBO";
                    }
                }
            }
            rs.close();
        } catch (SQLException ex) {
            ex.fillInStackTrace();
        }
        if (blIsCMB == false && blIsPR == false) {
            Resultado = "EL CODIGO INGRESADO ES ERRONEO";
        }
        return Resultado;
    }//Fin isProducto

    public String getDetalles(int intCMB_ID, Conexion oConn) {
        String strDetalles = "";
        String strSQL = "select * from vta_combo_deta where CMB_ID = " + intCMB_ID;
        try {
            ResultSet rs = oConn.runQuery(strSQL, true);
            while (rs.next()) {
                strDetalles += "<Descripcion";
                strDetalles += " PR_ID =\"" + rs.getString("CMBD_PR_ID") + "\"";
                strDetalles += " PR_CODIGO =\"" + rs.getString("CMBD_PR_CODIGO") + "\"";
                strDetalles += " PR_DESC =\"" + util.Sustituye(rs.getString("CMBD_PR_DESCRIPCION")) + "\"";
                strDetalles += " PR_PRECU =\"" + rs.getDouble("CMBD_PR_PRECIO") + "\"";
                strDetalles += " PR_TOTAL =\"0.0\"";
                strDetalles += " PR_EXISTENCIA =\"0\"";
                strDetalles += " PR_CANTIDAD =\"" + rs.getString("CMBD_PR_CANTIDAD") + "\"";
                strDetalles += "/>";
            }
            rs.close();
        } catch (SQLException ex) {
            ex.fillInStackTrace();
        }
        return strDetalles;
    }

%>