<%-- 
    Document   : ERP_Incidencias
    Created on : 30-abr-2015, 12:23:10
    Author     : siweb
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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

    Fechas fec = new Fechas();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            if (strid.equals("1")) {
                String strRes = "";
                String strRHIN_ID = request.getParameter("IdIncidencia");
                String strNumHrs = request.getParameter("Horas");
                String strFecha = request.getParameter("Fecha");
                String srtFormatFecha = fec.FormateaBD(strFecha, "/");

                //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                String strInsert = "INSERT INTO rhh_horas_extra(RHIN_ID,RHE_NUM_HORAS,RHE_FECHA)"
                        + " VALUES(" + strRHIN_ID + "," + strNumHrs + "," + srtFormatFecha + ")";

                oConn.runQueryLMD(strInsert);
                strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin IF 1

            if (strid.equals("2")) {
                String strId = request.getParameter("idInc");
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strDelete = "DELETE FROM rhh_horas_extra"
                            + " WHERE RHE_ID = " + strId;
                    oConn.runQueryLMD(strDelete);
                } catch (Exception ex) {
                    ex.fillInStackTrace();
                }
                String strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 2

            if (strid.equals("3")) {
                String strIdProm = request.getParameter("idInc");// es el id de la empresa
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<Incidencias>";
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strSelect = "select * from rhh_horas_extra where RHIN_ID = " + strIdProm;

                    ResultSet rs = oConn.runQuery(strSelect);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strXMLData += " RHE_ID=\'" + rs.getString("RHE_ID") + "\'";
                        strXMLData += " RHE_NUM_HORAS=\'" + rs.getString("RHE_NUM_HORAS") + "\'";
                        strXMLData += " RHE_FECHA=\'" + fec.FormateaDDMMAAAA(rs.getString("RHE_FECHA"), "/") + "\'";
                        strXMLData += "/>";
                    }

                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</Incidencias>";

                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin IF 3

            if (strid.equals("4")) {
                String strRes = "";
                String strRHIN_ID = request.getParameter("IdIncidencia");
                String strFecha = request.getParameter("Fecha");
                String srtFormatFecha = fec.FormateaBD(strFecha, "/");

                //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                String strInsert = "INSERT INTO rhh_prima_dominical(RHIN_ID,RHPD_FECHA)"
                        + " VALUES(" + strRHIN_ID + "," + srtFormatFecha + ")";

                oConn.runQueryLMD(strInsert);
                strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 4

            if (strid.equals("5")) {
                String strId = request.getParameter("idInc");
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strDelete = "DELETE FROM rhh_prima_dominical"
                            + " WHERE RHPD_ID = " + strId;
                    oConn.runQueryLMD(strDelete);
                } catch (Exception ex) {
                    ex.fillInStackTrace();
                }
                String strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 5

            if (strid.equals("6")) {
                String strIdProm = request.getParameter("idInc");
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<PDominical>";
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strSelectPD = "select * from rhh_prima_dominical where RHIN_ID = " + strIdProm;

                    ResultSet res = oConn.runQuery(strSelectPD);
                    while (res.next()) {
                        strXMLData += "<Domingos";
                        strXMLData += " PD_ID=\'" + res.getInt("RHPD_ID") + "\'";
                        strXMLData += " RHPD_FECHA=\'" + fec.FormateaDDMMAAAA(res.getString("RHPD_FECHA"), "/") + "\'";
                        strXMLData += "/>";
                    }

                    res.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</PDominical>";

                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin IF 6

            if (strid.equals("7")) {
                String strRes = "";
                String strRHIN_ID = request.getParameter("IdIncidencia");
                String strFecha = request.getParameter("Fecha");
                String srtFormatFecha = fec.FormateaBD(strFecha, "/");

                //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                String strInsert = "INSERT INTO rhh_dias_festivos(RHIN_ID,RHDF_FECHA)"
                        + " VALUES(" + strRHIN_ID + "," + srtFormatFecha + ")";

                oConn.runQueryLMD(strInsert);
                strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 7

            if (strid.equals("8")) {
                String strId = request.getParameter("idInc");
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strDelete = "DELETE FROM rhh_dias_festivos"
                            + " WHERE RHDF_ID = " + strId;
                    oConn.runQueryLMD(strDelete);
                } catch (Exception ex) {
                    ex.fillInStackTrace();
                }
                String strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 8

            if (strid.equals("9")) {
                String strIdProm = request.getParameter("idInc");
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<DFestivos>";
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strSelectDF = "select * from rhh_dias_festivos where RHIN_ID = " + strIdProm;

                    ResultSet res = oConn.runQuery(strSelectDF);
                    while (res.next()) {
                        strXMLData += "<datos";
                        strXMLData += " RHDF_ID=\'" + res.getInt("RHDF_ID") + "\'";
                        strXMLData += " RHDF_FECHA=\'" + res.getString("RHDF_FECHA") + "\'";
                        strXMLData += "/>";
                    }
                    res.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXMLData += "</DFestivos>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 9

            if (strid.equals("10")) {
                String strOpc = request.getParameter("opc");
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<porcentajes>";

                double dblPorcentaje = 0.0;
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strSelectDF = "select EMP_BONO_GRATIFI,EMP_PORC_PREMIO_PUNTUALIDAD,EMP_PORC_PREMIO_ASISTENCIA from vta_empresas where  emp_id =" + varSesiones.getIntIdEmpresa();

                    ResultSet res = oConn.runQuery(strSelectDF);

                    while (res.next()) {
                        if (strOpc.equals("1")) {
                            dblPorcentaje = res.getDouble("EMP_PORC_PREMIO_ASISTENCIA");
                        }
                        if (strOpc.equals("2")) {
                            dblPorcentaje = res.getDouble("EMP_PORC_PREMIO_PUNTUALIDAD");
                        }
                        if (strOpc.equals("3")) {
                            dblPorcentaje = 0.0;
                        }
                        if (strOpc.equals("4")) {
                            dblPorcentaje = res.getDouble("EMP_BONO_GRATIFI");
                        }
                    }

                    res.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }

                strXMLData += "<porcentajes_deta";
                strXMLData += " dblPorcentaje=\'" + dblPorcentaje + "\'";
                strXMLData += "/>";

                strXMLData += "</porcentajes>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 10

            if (strid.equals("11")) {
                String strIdIncid = request.getParameter("IdIncidencia");
                String strFechaFalta = request.getParameter("Fecha");
                String strTipoFalta = request.getParameter("TipoFalta");
                String strRes = "";

                String srtFormatFecha = fec.FormateaBD(strFechaFalta, "/");

                //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                String strInsert = "INSERT INTO rhh_faltas_detalle(RFD_FECHA,RTF_ID,RHIN_ID)"
                        + " VALUES('" + srtFormatFecha + "'," + strTipoFalta + ", " + strIdIncid + ")";
                String strQueryUp = "";
                if (strTipoFalta.equals("1")) {
                    strQueryUp = "update rhh_incidencias set RHIN_NUM_FALTAS = (RHIN_NUM_FALTAS + 1) where RHIN_ID = " + strIdIncid;
                }
                if (strTipoFalta.equals("2")) {
                    strQueryUp = "update rhh_incidencias set RHIN_NUM_FALTAS_INJUSTIFICADAS = (RHIN_NUM_FALTAS_INJUSTIFICADAS + 1) where RHIN_ID = " + strIdIncid;
                }
                if (strTipoFalta.equals("3")) {
                    strQueryUp = "update rhh_incidencias set RHIN_FALTAS_SANCION = (RHIN_FALTAS_SANCION + 1) where RHIN_ID = " + strIdIncid;
                }

                oConn.runQueryLMD(strInsert);
                oConn.runQueryLMD(strQueryUp);
                strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin IF 11

            if (strid.equals("12")) {
                String strIdProm = request.getParameter("idInc");
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<FaltasDeta>";
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strSelect = "select * from rhh_faltas_detalle where RHIN_ID = " + strIdProm;

                    ResultSet res = oConn.runQuery(strSelect);
                    while (res.next()) {
                        strXMLData += "<datos";
                        strXMLData += " RFD_ID=\'" + res.getInt("RFD_ID") + "\'";
                        strXMLData += " RFD_FECHA=\'" + fec.FormateaDDMMAAAA(res.getString("RFD_FECHA"), "/") + "\'";
                        strXMLData += " RTF_ID=\'" + getTipoFalta(res.getInt("RTF_ID"), oConn) + "\'";
                        strXMLData += "/>";
                    }
                    res.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXMLData += "</FaltasDeta>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 12

            if (strid.equals("13")) {
                String strId = request.getParameter("idFalta");
                String strFaltaDeta = "select RHIN_ID,RTF_ID from rhh_faltas_detalle where RFD_ID = " + strId;
                int strIncid = 0;
                String strTipoFalta = "";
                try {
                    ResultSet rs = oConn.runQuery(strFaltaDeta);
                    while (rs.next()) {
                        strIncid = rs.getInt("RHIN_ID");
                        strTipoFalta = rs.getString("RTF_ID");
                    }
                    rs.close();
                } catch (Exception ex) {
                    ex.fillInStackTrace();
                }
                String strQueryUp = "";
                if (strTipoFalta.equals("1")) {
                    strQueryUp = "update rhh_incidencias set RHIN_NUM_FALTAS = (RHIN_NUM_FALTAS - 1) where RHIN_ID = " + strIncid;
                }
                if (strTipoFalta.equals("2")) {
                    strQueryUp = "update rhh_incidencias set RHIN_NUM_FALTAS_INJUSTIFICADAS = (RHIN_NUM_FALTAS_INJUSTIFICADAS - 1) where RHIN_ID = " + strIncid;
                }
                if (strTipoFalta.equals("3")) {
                    strQueryUp = "update rhh_incidencias set RHIN_FALTAS_SANCION = (RHIN_FALTAS_SANCION - 1) where RHIN_ID = " + strIncid;
                }
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strDelete = "DELETE FROM rhh_faltas_detalle"
                            + " WHERE RFD_ID = " + strId;
                    oConn.runQueryLMD(strDelete);
                    oConn.runQueryLMD(strQueryUp);
                } catch (Exception ex) {
                    ex.fillInStackTrace();
                }
                String strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 13

            if (strid.equals("14")) {
                String strIncidencia = request.getParameter("IdIncidencia");
                String strFecha = request.getParameter("Fecha");
                String strNumDias = request.getParameter("NumDias");
                String strTDictamen = request.getParameter("TCaso");
                String strTCaso = request.getParameter("TDictamen");
                String strTRiesgo = request.getParameter("TRiesgo");
                String strTIncapacidad = request.getParameter("TIncapacidad");
                String strCertificado = request.getParameter("Certificado");
                String strRes = "";

                String srtFormatFecha = fec.FormateaBD(strFecha, "/");
                String strInsert = "insert into rhh_incapacidades_deta (RID_FECHA, RID_NUM_DIAS, RHIN_ID) values ('" + srtFormatFecha + "','" + strNumDias + "','" + strIncidencia + "')";
                oConn.runQueryLMD(strInsert);
                String strUpdate = "update rhh_incidencias set RHIN_DIAS_INCAPACIDAD = (RHIN_DIAS_INCAPACIDAD +  " + strNumDias + "),"
                        + " RHIN_CERTIFICADO_INCAPACIDAD = '" + strCertificado + "',"
                        + " RTI_ID = " + strTIncapacidad + ","
                        + " RTR_ID = " + strTRiesgo + ","
                        + " RTD_ID = " + strTDictamen + ","
                        + " RTC_ID = " + strTCaso + ""
                        + " where RHIN_ID = " + strIncidencia + ";";
                oConn.runQueryLMD(strUpdate);
                strRes = "OK";

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }//Fin strId 14

            if (strid.equals("15")) {
                String strIncidencia = request.getParameter("idInc");
                String strQuery = "select * from rhh_incapacidades_deta where RHIN_ID = " + strIncidencia;
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<IncapacidadesDeta>";
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO

                    ResultSet res = oConn.runQuery(strQuery);
                    while (res.next()) {
                        strXMLData += "<datos";
                        strXMLData += " RID_ID=\'" + res.getInt("RID_ID") + "\'";
                        strXMLData += " RID_FECHA=\'" + fec.FormateaDDMMAAAA(res.getString("RID_FECHA"), "/") + "\'";
                        strXMLData += " RID_NUM_DIAS=\'" + res.getInt("RID_NUM_DIAS") + "\'";
                        strXMLData += "/>";
                    }
                    res.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXMLData += "</IncapacidadesDeta>";
                String strRes = strXMLData.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 15

            if (strid.equals("16")) {
                String strIncapacidad = request.getParameter("idIncapacidad");
                String strDias = request.getParameter("numDias");
                String strIncid = request.getParameter("Incid");
                String strRes = "";
                try {
                    //SACAMOS LAS PÃRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strDelete = "DELETE FROM rhh_incapacidades_deta"
                            + " WHERE RID_ID = " + strIncapacidad;
                    String strUpdate = "update rhh_incidencias set "
                            + " RHIN_DIAS_INCAPACIDAD = (RHIN_DIAS_INCAPACIDAD - " + strDias + "), "
                            + " RHIN_CERTIFICADO_INCAPACIDAD = '',"
                            + " RTI_ID = 0,"
                            + " RTR_ID = 0,"
                            + " RTD_ID = 0,"
                            + " RTC_ID = 0"
                            + " where RHIN_ID = " + strIncid + ";";
                    oConn.runQueryLMD(strDelete);
                    oConn.runQueryLMD(strUpdate);
                } catch (Exception ex) {
                    ex.fillInStackTrace();
                }
                strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin id 16

        }
    } else {
    }
    oConn.close();
%>
<%!
    public String getTipoFalta(int RTF_ID, Conexion oConn) {
        String strQuery = "select RTF_DESCRIPCION from rhh_tipo_falta where RTF_ID = " + RTF_ID;
        String strTipo = "";
        try {
            //SACAMOS LAS PARTIDAS CORRESPONDIENTES
            ResultSet rs = oConn.runQuery(strQuery);
            while (rs.next()) {
                strTipo = rs.getString("RTF_DESCRIPCION");
            }
            rs.close();
        } catch (SQLException ex) {
            ex.fillInStackTrace();
        }
        return strTipo;
    }//Fin getTipoFalta
%>
