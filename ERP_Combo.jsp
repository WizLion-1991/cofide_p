<%-- 
    Document   : ERP_Combo
    Created on : 03-dic-2015, 12:53:32
    Author     : casajosefa
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="ERP.Monedas"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
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
    Fechas fec = new Fechas();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            if (strid.equals("1")) {
                //Consultamos los detalles de cada combo
                String strIdCbm = request.getParameter("IdCmb");// es el id de la empresa
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Combo_deta>";
                try {
                    String strSelect = "select *,(select CMB_CODIGO from vta_combo where vta_combo.CMB_ID = vta_combo_deta.CMB_ID) as codigo"
                            + " from vta_combo_deta where CMB_ID =  " + strIdCbm;

                    ResultSet rs = oConn.runQuery(strSelect);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strXMLData += " CMBD_ID=\'" + rs.getString("CMBD_ID") + "\'";
                        strXMLData += " CMBD_PR_ID=\'" + rs.getString("CMBD_PR_ID") + "\'";
                        strXMLData += " CMBD_PR_CODIGO=\'" + rs.getString("CMBD_PR_CODIGO") + "\'";
                        strXMLData += " CMBD_PR_DESCRIPCION=\'" + rs.getString("CMBD_PR_DESCRIPCION") + "\'";
                        strXMLData += " CMBD_PR_CANTIDAD=\'" + rs.getDouble("CMBD_PR_CANTIDAD") + "\'";
                        strXMLData += " CMBD_CONTADOR=\'" + rs.getDouble("CMBD_CONTADOR") + "\'";
                        strXMLData += " CMBD_PR_NUM=\'" + rs.getString("CMBD_PR_NUM") + "\'";
                        strXMLData += " CMBD_PR_PRECIO=\'" + rs.getString("CMBD_PR_PRECIO") + "\'";
                        strXMLData += " CMB_CODIGO=\'" + rs.getString("codigo") + "\'";
                        strXMLData += "/>";
                    }
                    rs.getStatement().close();
                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</Combo_deta>";

                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin ID 1

            if (strid.equals("2")) {
                String strBlAlta = request.getParameter("blAlta");
                int intIdMaster = Integer.parseInt(request.getParameter("intIdMaster"));
                int idArr1 = Integer.parseInt(request.getParameter("intlenghtArr1"));
                int idArr2 = Integer.parseInt(request.getParameter("intlenghtArr2"));
                int idArr3 = Integer.parseInt(request.getParameter("intlenghtArr3"));
                int idArr4 = Integer.parseInt(request.getParameter("intlenghtArr4"));
                int idArr5 = Integer.parseInt(request.getParameter("intlenghtArr5"));
                int idArr6 = Integer.parseInt(request.getParameter("intlenghtArr6"));

                if (strBlAlta.equals("false")) {
                    String strDelete = "delete from vta_combo_deta where CMB_ID = " + intIdMaster;
                    oConn.runQueryLMD(strDelete);
                }

                String strPR_ID = "";
                String strCodigoPR = "";
                String strDescPR = "";
                String strCantidadPR = "";
                String strPrecioPR = "";
                String strResult = "";

                for (int i = 0; i < idArr1; i++) {
                    strPR_ID = request.getParameter("PR_ID1_" + i);
                    strCodigoPR = request.getParameter("PR_CODIGO1_" + i);
                    strDescPR = request.getParameter("PR_DESCRIPCION1_" + i);
                    strCantidadPR = request.getParameter("PR_CANTIDAD1_" + i);
                    strPrecioPR = request.getParameter("PR_PRECIO1_" + i);

                    //Llamamos objeto para guardar los datos de la tabla
                    CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
                    objTabla.Init("combo_deta", true, true, false, oConn);
                    objTabla.setBolGetAutonumeric(true);

                    objTabla.setFieldInt("CMB_ID", intIdMaster);
                    objTabla.setFieldString("CMBD_PR_ID", strPR_ID);
                    objTabla.setFieldString("CMBD_PR_CODIGO", strCodigoPR);
                    objTabla.setFieldString("CMBD_PR_DESCRIPCION", strDescPR);
                    objTabla.setFieldDouble("CMBD_PR_CANTIDAD", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_CONTADOR", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_PR_PRECIO", Double.parseDouble(strPrecioPR));
                    objTabla.setFieldInt("CMBD_PR_NUM", 1);

                    //Generamos una alta
                    strResult = objTabla.Agrega(oConn);
                }

                for (int i = 0; i < idArr2; i++) {
                    strPR_ID = request.getParameter("PR_ID2_" + i);
                    strCodigoPR = request.getParameter("PR_CODIGO2_" + i);
                    strDescPR = request.getParameter("PR_DESCRIPCION2_" + i);
                    strCantidadPR = request.getParameter("PR_CANTIDAD2_" + i);
                    strPrecioPR = request.getParameter("PR_PRECIO2_" + i);

                    //Llamamos objeto para guardar los datos de la tabla
                    CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
                    objTabla.Init("combo_deta", true, true, false, oConn);
                    objTabla.setBolGetAutonumeric(true);

                    objTabla.setFieldInt("CMB_ID", intIdMaster);
                    objTabla.setFieldString("CMBD_PR_ID", strPR_ID);
                    objTabla.setFieldString("CMBD_PR_CODIGO", strCodigoPR);
                    objTabla.setFieldString("CMBD_PR_DESCRIPCION", strDescPR);
                    objTabla.setFieldDouble("CMBD_PR_CANTIDAD", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_CONTADOR", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_PR_PRECIO", Double.parseDouble(strPrecioPR));
                    objTabla.setFieldInt("CMBD_PR_NUM", 2);

                    //Generamos una alta
                    strResult = objTabla.Agrega(oConn);
                }

                for (int i = 0; i < idArr3; i++) {
                    strPR_ID = request.getParameter("PR_ID3_" + i);
                    strCodigoPR = request.getParameter("PR_CODIGO3_" + i);
                    strDescPR = request.getParameter("PR_DESCRIPCION3_" + i);
                    strCantidadPR = request.getParameter("PR_CANTIDAD3_" + i);
                    strPrecioPR = request.getParameter("PR_PRECIO3_" + i);

                    //Llamamos objeto para guardar los datos de la tabla
                    CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
                    objTabla.Init("combo_deta", true, true, false, oConn);
                    objTabla.setBolGetAutonumeric(true);

                    objTabla.setFieldInt("CMB_ID", intIdMaster);
                    objTabla.setFieldString("CMBD_PR_ID", strPR_ID);
                    objTabla.setFieldString("CMBD_PR_CODIGO", strCodigoPR);
                    objTabla.setFieldString("CMBD_PR_DESCRIPCION", strDescPR);
                    objTabla.setFieldDouble("CMBD_PR_CANTIDAD", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_CONTADOR", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_PR_PRECIO", Double.parseDouble(strPrecioPR));
                    objTabla.setFieldInt("CMBD_PR_NUM", 3);

                    //Generamos una alta
                    strResult = objTabla.Agrega(oConn);
                }

                for (int i = 0; i < idArr4; i++) {
                    strPR_ID = request.getParameter("PR_ID4_" + i);
                    strCodigoPR = request.getParameter("PR_CODIGO4_" + i);
                    strDescPR = request.getParameter("PR_DESCRIPCION4_" + i);
                    strCantidadPR = request.getParameter("PR_CANTIDAD4_" + i);
                    strPrecioPR = request.getParameter("PR_PRECIO4_" + i);

                    //Llamamos objeto para guardar los datos de la tabla
                    CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
                    objTabla.Init("combo_deta", true, true, false, oConn);
                    objTabla.setBolGetAutonumeric(true);

                    objTabla.setFieldInt("CMB_ID", intIdMaster);
                    objTabla.setFieldString("CMBD_PR_ID", strPR_ID);
                    objTabla.setFieldString("CMBD_PR_CODIGO", strCodigoPR);
                    objTabla.setFieldString("CMBD_PR_DESCRIPCION", strDescPR);
                    objTabla.setFieldDouble("CMBD_PR_CANTIDAD", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_CONTADOR", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_PR_PRECIO", Double.parseDouble(strPrecioPR));
                    objTabla.setFieldInt("CMBD_PR_NUM", 4);

                    //Generamos una alta
                    strResult = objTabla.Agrega(oConn);
                }

                for (int i = 0; i < idArr5; i++) {
                    strPR_ID = request.getParameter("PR_ID5_" + i);
                    strCodigoPR = request.getParameter("PR_CODIGO5_" + i);
                    strDescPR = request.getParameter("PR_DESCRIPCION5_" + i);
                    strCantidadPR = request.getParameter("PR_CANTIDAD5_" + i);
                    strPrecioPR = request.getParameter("PR_PRECIO5_" + i);

                    //Llamamos objeto para guardar los datos de la tabla
                    CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
                    objTabla.Init("combo_deta", true, true, false, oConn);
                    objTabla.setBolGetAutonumeric(true);

                    objTabla.setFieldInt("CMB_ID", intIdMaster);
                    objTabla.setFieldString("CMBD_PR_ID", strPR_ID);
                    objTabla.setFieldString("CMBD_PR_CODIGO", strCodigoPR);
                    objTabla.setFieldString("CMBD_PR_DESCRIPCION", strDescPR);
                    objTabla.setFieldDouble("CMBD_PR_CANTIDAD", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_CONTADOR", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_PR_PRECIO", Double.parseDouble(strPrecioPR));
                    objTabla.setFieldInt("CMBD_PR_NUM", 5);

                    //Generamos una alta
                    strResult = objTabla.Agrega(oConn);
                }

                for (int i = 0; i < idArr6; i++) {
                    strPR_ID = request.getParameter("PR_ID6_" + i);
                    strCodigoPR = request.getParameter("PR_CODIGO6_" + i);
                    strDescPR = request.getParameter("PR_DESCRIPCION6_" + i);
                    strCantidadPR = request.getParameter("PR_CANTIDAD6_" + i);
                    strPrecioPR = request.getParameter("PR_PRECIO6_" + i);

                    //Llamamos objeto para guardar los datos de la tabla
                    CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
                    objTabla.Init("combo_deta", true, true, false, oConn);
                    objTabla.setBolGetAutonumeric(true);

                    objTabla.setFieldInt("CMB_ID", intIdMaster);
                    objTabla.setFieldString("CMBD_PR_ID", strPR_ID);
                    objTabla.setFieldString("CMBD_PR_CODIGO", strCodigoPR);
                    objTabla.setFieldString("CMBD_PR_DESCRIPCION", strDescPR);
                    objTabla.setFieldDouble("CMBD_PR_CANTIDAD", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_CONTADOR", Double.parseDouble(strCantidadPR));
                    objTabla.setFieldDouble("CMBD_PR_PRECIO", Double.parseDouble(strPrecioPR));
                    objTabla.setFieldInt("CMBD_PR_NUM", 6);

                    //Generamos una alta
                    strResult = objTabla.Agrega(oConn);
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strResult);//Pintamos el resultado

            }//Fin ID 2

            if (strid.equals("3")) {
                String strMonedaBanco = request.getParameter("Moneda_1");
                String strMonedaSeleccionada = request.getParameter("Moneda_2");
                if (strMonedaSeleccionada == null) {
                    strMonedaSeleccionada = "";
                }
                if (strMonedaSeleccionada.equals("undefined")) {
                    strMonedaSeleccionada = "0";
                }
                String strFecha = fec.getFechaActual();

                strMonedaBanco = strMonedaBanco.trim();
                if (strMonedaBanco.equals("0")) {
                    strMonedaBanco = "1";
                }
                if (strMonedaSeleccionada.equals("0")) {
                    strMonedaSeleccionada = "1";
                }
                strMonedaSeleccionada = strMonedaSeleccionada.trim();
                double dblTasaUSD = 0.0;
                double dblTasaEUR = 0.0;
                double dblTasaCAN = 0.0;
                double dblTasaLSD = 0.0;
                Monedas MiTasaCambio = new Monedas(oConn);
                MiTasaCambio.setBoolConversionAutomatica(false);

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<TasaCambio>";
                strXML += "<TasaCambios";
                dblTasaUSD = MiTasaCambio.GetFactorConversion(strFecha, 4, Integer.parseInt(strMonedaBanco), 2);
                dblTasaEUR = MiTasaCambio.GetFactorConversion(strFecha, 4, Integer.parseInt(strMonedaBanco), 3);
                dblTasaCAN = MiTasaCambio.GetFactorConversion(strFecha, 4, Integer.parseInt(strMonedaBanco), 4);
                dblTasaLSD = MiTasaCambio.GetFactorConversion(strFecha, 4, Integer.parseInt(strMonedaBanco), 5);
                if (dblTasaUSD == 0) {
                    dblTasaUSD = 1;
                }
                if (dblTasaEUR == 0) {
                    dblTasaEUR = 1;
                }
                if (dblTasaCAN == 0) {
                    dblTasaCAN = 1;
                }
                if (dblTasaLSD == 0) {
                    dblTasaLSD = 1;
                }
                strXML += " USD= \"" + dblTasaUSD + "\"  ";
                strXML += " EUR= \"" + dblTasaEUR + "\"  ";
                strXML += " CAN= \"" + dblTasaCAN + "\"  ";
                strXML += " LSD= \"" + dblTasaLSD + "\"  ";
                strXML += " />";
                strXML += "</TasaCambio>";

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado

            }//Fin ID 3

        }//Fin ID Null
    } else {
        out.println("Sin acceso");
    }
    oConn.close();
%>