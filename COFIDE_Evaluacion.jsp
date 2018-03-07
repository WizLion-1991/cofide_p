<%-- 
    Document   : COFIDE_Telemarketing
    Created on : 8/12/2015, 04:59:36 PM
    Author     : siweb
--%>



<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    UtilXml util = new UtilXml();
    Fechas fec = new Fechas();
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("ID");
        if (strid != null) {
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<cofide_evaluacion>";
            if (strid.equals("1")) { //llenado de la hora
                UtilXml utilXML = new UtilXml();
                //Consulta la hora actual
                String strHora = fec.getHoraActual();
                int intUsr = varSesiones.getIntNoUser();
                String strGrupo = "";
                int intGrupo = 0;
                int intEvaluaciones = 0;
                String strSql = "select US_GRUPO, CG_DESCRIPCION, CG_NUM_EVALUACION from usuarios "
                        + "inner join cofide_grupo_trabajo ON CG_ID = US_GRUPO "
                        + "where id_usuarios = " + intUsr;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intGrupo = rs.getInt("US_GRUPO");
                    strGrupo = rs.getString("CG_DESCRIPCION");
                    intEvaluaciones = rs.getInt("CG_NUM_EVALUACION");
                }
                rs.close();
                //lo mandamos por xml al archivo js
                strXML += "<datos "
                        + " CE_HORAREG = \"" + strHora + "\"  "
                        + " US_GRUPO = \"" + intGrupo + "\" "
                        + " CG_DESCRIPCION = \"" + strGrupo + "\" "
                        + " CG_NUM_EVALUACION = \"" + intEvaluaciones + "\" "
                        + " />";
                strXML += "</cofide_evaluacion>";
                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin de la primera opcion

            if (strid.equals("2")) { //llena grid de ejecutivos
                String strGTrabajo = request.getParameter("CE_ID_GTRABAJO");
                int intEV = 0;
                if (request.getParameter("EV_PENDIENTES_TMP") != null) {
                    intEV = Integer.parseInt(request.getParameter("EV_PENDIENTES_TMP"));
                    }
                int intIdEjecutivo = 0;
                String strNombre = "";
                String strIP = "";
                String strExt = "";
                int intNumeroLlamadas = 0;
                int intNumEva = 0;
                String strBase = "";
                String strRegistro = "";
                String strExp = "";
                String strProsp = "";
                int intNotas = 0;
                double dblReserva = 0.0;
                double dblCobrado = 0.0;
                double dblMeta = 0.0;
                double dblFacturado = 0.0;
                String strSql = "select id_usuarios, nombre_usuario, IP_ADDRESS, NUM_EXT, COFIDE_CODIGO,"
                        + "(select  count(*) from vta_cliente where CT_ACTIVO = 1 and CT_CLAVE_DDBB = cofide_codigo) as REGISTROS,"
                        + "(select  count(*) from vta_cliente where CT_ACTIVO = 1 and CT_ES_PROSPECTO = 0 and CT_CLAVE_DDBB = cofide_codigo) as EXPARTICIPANTE,"
                        + "(select  count(*) from vta_cliente where CT_ACTIVO = 1 and CT_ES_PROSPECTO = 1 and CT_CLAVE_DDBB = cofide_codigo) as PROSPECTO,"
                        + "(select count(*) from cofide_llamada WHERE CL_USUARIO = nombre_usuario AND CL_FECHA = '20161020' and CL_COMPLETO = 1) as LLAMADA "
                        + "from usuarios where US_GRUPO = " + strGTrabajo;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intIdEjecutivo = rs.getInt("id_usuarios");
                    strNombre = rs.getString("nombre_usuario");
                    strIP = rs.getString("IP_ADDRESS");
                    strExt = rs.getString("NUM_EXT");
                    intNumeroLlamadas = rs.getInt("LLAMADA");
                    strBase = rs.getString("COFIDE_CODIGO");
                    strRegistro = rs.getString("REGISTROS");
                    strExp = rs.getString("EXPARTICIPANTE");
                    strProsp = rs.getString("PROSPECTO");
                    intNotas = getNotas(oConn, rs.getInt("id_usuarios"));
                    dblReserva = getReserva(oConn, rs.getInt("id_usuarios"));
                    dblCobrado = getCobro(oConn, rs.getInt("id_usuarios"));
                    dblMeta = getMeta(oConn, rs.getInt("id_usuarios"));
                    dblFacturado = getFacturado(oConn, rs.getInt("id_usuarios"));
                    String strSql2 = "select count(CE_ID_USER) as EVALUACIONES from cofide_evaluacion "
                            + "where CE_ID_USER = " + intIdEjecutivo + " and CE_FECHAREV = '" + fec.getFechaActual() + "'";
                    ResultSet rs2 = oConn.runQuery(strSql2, true);
                    while (rs2.next()) {
                        intNumEva = rs2.getInt("EVALUACIONES");
                    }
                    rs2.close();
                    int Evaluacion_Pen = intEV - intNumEva;
                    strXML += "<datos "
                            + " id_usuarios = \"" + intIdEjecutivo + "\"  "
                            + " nombre_usuario = \"" + strNombre + "\"  "
                            + " EVALUACIONES = \"" + Evaluacion_Pen + "\" "
                            + " IP_ADDRESS = \"" + strIP + "\" "
                            + " EXTENSION = \"" + strExt + "\" "
                            + " LLAMADA = \"" + intNumeroLlamadas + "\" "
                            + " BASE = \"" + strBase + "\" "
                            + " REGISTROS = \"" + strRegistro + "\" "
                            + " EXP = \"" + strExp + "\" "
                            + " PROS = \"" + strProsp + "\" "
                            + " NOTA = \"" + intNotas + "\" "
                            + " RESERVA = \"" + dblReserva + "\" "
                            + " COBRO = \"" + dblCobrado + "\" "
                            + " META = \"" + dblMeta + "\" "
                            + " FACTURA = \"" + dblFacturado + "\" "
                            + " />";
                }
                rs.close();
                strXML += "</cofide_evaluacion>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin de segunda opcion
            if (strid.equals("3")) { //guarda evaluacion
                String intId = request.getParameter("CE_ID_USER");
                String strUser = request.getParameter("EV_USER");
                String strFecha = fec.getFechaActual();//request.getParameter("EV_FECHA");
                String strEvPen = request.getParameter("EV_PEN");
                String strHora = fec.getHoraActual();//request.getParameter("CE_HORAREV");
                String strLlamadas = request.getParameter("CE_NUM_LLAMADA");
                String strPregunta1 = request.getParameter("CE_PREGUNTA1");
                String strPregunta2 = request.getParameter("CE_PREGUNTA2");
                String strPregunta3 = request.getParameter("CE_PREGUNTA3");
                String strPregunta4 = request.getParameter("CE_PREGUNTA4");
                String strPregunta5 = request.getParameter("CE_PREGUNTA5");
                String strPregunta6 = request.getParameter("CE_PREGUNTA6");
                String strPregunta7 = request.getParameter("CE_PREGUNTA7");
                String strPregunta8 = request.getParameter("CE_PREGUNTA8");
                String strPregunta9 = request.getParameter("CE_PREGUNTA9");
                String strPregunta10 = request.getParameter("CE_PREGUNTA10");
                String strCalif = request.getParameter("CE_CALIF");
                String strMsj = request.getParameter("CE_MSG");
                String strTMK = request.getParameter("CE_CAMP_TMK");
                String strRef = request.getParameter("CE_REF");
                String strInCompany = request.getParameter("CE_INCOMPANY");
                String strReg = request.getParameter("CE_REG_PEN");
                String strObs = request.getParameter("CE_OBSERVACION");
                String strIdGtrabajo = request.getParameter("CE_ID_GTRABAJO");
                String strGTrabajo = request.getParameter("CE_GTRABAJO");
                String srtSql = "INSERT INTO cofide_evaluacion (CE_ID_USER, CE_NOMBRE, CE_FECHAREV, CE_HORAREV, CE_NO_LLAMADAS, "
                        + "CE_PREGUNTA1, CE_PREGUNTA2, CE_PREGUNTA3, CE_PREGUNTA4, CE_PREGUNTA5, CE_PREGUNTA6, CE_PREGUNTA7, CE_PREGUNTA8, CE_PREGUNTA9, CE_PREGUNTA10,"
                        + "CE_MSGCOMPLETO, CE_CALIFICACION, CE_CAMP_TELEMARKETING, CE_REGPENDIENTE, CE_OBSERVACIONES, CE_ID_GTRABAJO, CE_GTRABAJO, CE_REF, CE_INCOMPANY) "
                        + "VALUES (" + intId + ", '" + strUser + "', '" + strFecha + "', '" + strHora + "', " + strLlamadas + ", "
                        + "" + strPregunta1 + ", " + strPregunta2 + ", " + strPregunta3 + ", " + strPregunta4 + ", " + strPregunta5 + ", " + strPregunta6 + ", " + strPregunta7 + ", " + strPregunta8 + ", " + strPregunta9 + ", " + strPregunta10 + ", "
                        + "" + strMsj + ", " + strCalif + ", " + strTMK + ", " + strReg + ", '" + strObs + "', " + strIdGtrabajo + ", '" + strGTrabajo + "', " + strRef + ", " + strInCompany + ")";
                oConn.runQueryLMD(srtSql);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println("OK");//Pintamos el resultado
            } //fin de la 3ra ocion

            if (strid.equals("4")) {
                String strId_usr = request.getParameter("EV_USER");
                int intLlamadas = 0;
                String strSql = "select count(*) as llamadas from cofide_llamada where CL_USUARIO = '" + strId_usr + "' AND CL_FECHA = '20160808' and CL_COMPLETO = 1";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intLlamadas = rs.getInt("llamadas");
                }
                strXML += "<datos "
                        + " llamadas = \"" + intLlamadas + "\"  "
                        + " fecha = \"" + fec.FormateaDDMMAAAA(fec.getFechaActual(), "/") + "\"  "
                        + " hora = \"" + fec.getHoraActual() + "\"  "
                        + " />";
                strXML += "</cofide_evaluacion>";
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
                rs.close();
            } //fin de la cuarta opcion
        } //fin if strid != null
    }
    oConn.close();
%>

<%!
    Fechas fec = new Fechas();

    public double getReserva(Conexion oConn, int intIdUser) {
        double dblReserva = 0.0;
        String strSql = "";
        ResultSet rs;
        //Cuantas ventas tickets
        strSql = "select SUM(TKT_IMPORTE) AS TOT, sum(if(TKT_SALDO = 0,TKT_IMPORTE,0)) as cobrado from vta_tickets "
                + " where TKT_ANULADA = 0 AND left(TKT_FECHA,6) = '" + fec.getFechaActual().substring(0, 6) + "' "
                + " AND TKT_US_ALTA = " + intIdUser + " AND vta_tickets.FAC_ID = 0";
        try {
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                dblReserva = rs.getDouble("TOT");
            }
            rs.close();
            //Cuantas ventas facturas
            strSql = "select SUM(FAC_IMPORTE) AS TOT, sum(if(FAC_SALDO = 0,FAC_IMPORTE,0)) as cobrado from vta_facturas "
                    + " where FAC_ANULADA = 0 AND left(FAC_FECHA,6) = '" + fec.getFechaActual().substring(0, 6) + "' "
                    + " AND FAC_US_ALTA = " + intIdUser;
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                dblReserva += rs.getDouble("TOT");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println("Error: " + ex);
        }
        return dblReserva;
    }

    public double getCobro(Conexion oConn, int intIdUser) {
        double dblCobro = 0;
        String strSql = "";
        ResultSet rs;
        try {
            //Cuantos Cobrado
            strSql = "select SUM(MC_ABONO) as COBRADO from vta_mov_cte where ID_USUARIOS = " + intIdUser
                    + " and MC_ANULADO = 0 and MC_ESPAGO = 1 and left(MC_FECHACREATE,6) = '" + fec.getFechaActual().substring(0, 6) + "'";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                dblCobro = rs.getDouble("COBRADO");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println("Error: " + ex);
        }
        return dblCobro;
    }

    public double getMeta(Conexion oConn, int intIdUser) {
        double dblMeta = 0;
        String strSql = "";
        ResultSet rs;
        try {
            //meta montos, nuevos participantes
            strSql = "select CMU_IMPORTE from cofide_metas_usuario where id_usuarios = " + intIdUser;
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                dblMeta = rs.getDouble("CMU_IMPORTE");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println("Error: " + ex);
        }
        return dblMeta;
    }

    public double getFacturado(Conexion oConn, int intIdUser) {
        double dblFactura = 0;
        String strSql = "";
        ResultSet rs;
        try {
            strSql = "select SUM(FAC_IMPORTE) AS TOT from vta_facturas  "
                    + "where FAC_ANULADA = 0 AND left(FAC_FECHA,6) = '" + fec.getFechaActual() + "'  "
                    + "AND FAC_US_ALTA = " + intIdUser;
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                dblFactura = rs.getDouble("TOT");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println("Error: " + ex);
        }
        return dblFactura;
    }

    public int getNotas(Conexion oConn, int intIdUser) {
        int intNotas = 0;
        String strSql = "select count(*) as Notas from crm_eventos where ev_estado = 1 and ev_fecha_inicio < " + fec.getFechaActual() + " and ev_asignado_a = " + intIdUser;
        try {
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                intNotas = rs.getInt("Notas");
            }
            rs.close();
        } catch (SQLException ex) {
            System.out.println("Error: " + ex);
        }
        return intNotas;
    }
%>