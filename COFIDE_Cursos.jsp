<%-- 
    Document   : COFIDE_Cursos.jsp
    Created on : 30/11/2015, 01:15:08 PM
    Author     : siweb
--%>
<%@page import="com.mx.siweb.erp.especiales.cofide.SincronizarPaginaWeb"%>
<%@page import="Tablas.cofide_modulo_curso"%>
<%@page import="Tablas.cofide_curso_segmento"%>
<%@page import="Tablas.cofide_curso_giro"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    Fechas fec = new Fechas();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad(); //Valida que la peticion se halla hecho desde el mismo sitio
    Fechas fecha = new Fechas();
    UtilXml util = new UtilXml();

    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Obtenemos parametros
        String strid = request.getParameter("id");
        if (!strid.equals(null)) {
            //confirmar
            if (strid.equals("1")) {
                String strSQL;
                String id = request.getParameter("CC_CURSO_ID");
                strSQL = "update cofide_cursos set CC_CONFIRMAR = 1 where CC_CURSO_ID = " + id;
                String strResultLast;
                boolean bolSucess;
                oConn.runQueryLMD(strSQL);
                strResultLast = oConn.getStrMsgError();

                if (strResultLast != "") {
                    bolSucess = false;
                } else {
                    bolSucess = true;
                }
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<Confirmar>");
                strXML.append(" <Confirmar_deta");
                strXML.append(" respuesta= \"").append(bolSucess).append("\" ");
                strXML.append("/>");
                strXML.append("</Confirmar>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//fin confirmar

            //autorizar
            if (strid.equals("2")) {
                String strSQL;
                String id = request.getParameter("CC_CURSO_ID");
                strSQL = "update cofide_cursos set CC_AUTORIZAR = 1 where CC_CURSO_ID = " + id;
                String strResultLast;
                System.out.println("Se agrega el curso a la web, a sido autorizado!");
                /*guardar el curso en la base de cofide web*/
                SincronizarPaginaWeb sincroniza = new SincronizarPaginaWeb(oConn);
                sincroniza.actualizaPaginaWeb(Integer.parseInt(id));
                /*guardar el curso en la base de cofide web*/
                boolean bolSucess;
                oConn.runQueryLMD(strSQL);
                strResultLast = oConn.getStrMsgError();
                if (strResultLast != "") {
                    bolSucess = false;
                } else {
                    bolSucess = true;
                }
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<Autorizar>");
                strXML.append(" <Autorizar_deta");
                strXML.append(" respuesta= \"").append(bolSucess).append("\" ");
                strXML.append("/>");
                strXML.append("</Autorizar>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//fin autorizar
            //Cancelar
            if (strid.equals("3")) {
                String strSQL;
                String strInscritos = "";
                String id = request.getParameter("CC_CURSO_ID");
                strSQL = "update cofide_cursos set CC_ACTIVO = 0 where CC_CURSO_ID = " + id;
                String strResultLast;
                String strSqlSelect = "select CC_INSCRITOS from cofide_cursos where CC_CURSO_ID = " + id;
                ResultSet rs = oConn.runQuery(strSqlSelect, true);
                while (rs.next()) {
                    strInscritos = rs.getString("CC_INSCRITOS");
                }
                boolean bolSucess;
                oConn.runQueryLMD(strSQL);
                strResultLast = oConn.getStrMsgError();
                if (strResultLast != "") {
                    bolSucess = false;
                } else {
                    bolSucess = true;
                }
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<Cancelar>");
                strXML.append(" <Cancelar_deta");
                strXML.append(" respuesta= \"").append(bolSucess).append("\" ");
                strXML.append(" inscritos= \"").append(strInscritos).append("\" ");
                strXML.append("/>");
                strXML.append("</Cancelar>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//fin Cancelar
            if (strid.equals("4")) { //llena cursos deta
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_M = request.getParameter("CCU_ID_M");
                int intId = 0;
                String strNomNew = "";
                String strNomOld = "";
                String strclave = "";
                String strFecha = "";
                String strHora = "";
                String struser = "";
                String strSql = "select * from cofide_catalogo_curso_deta where ccu_id_m = " + strID_M + " order by cud_id";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CUD_ID");
                    strNomNew = rs.getString("CUD_CURSO");
                    strNomOld = rs.getString("CUD_CURSO_OLD");
                    strclave = rs.getString("CUD_CLAVE");
                    strFecha = rs.getString("CUD_FECHA");
                    strHora = rs.getString("CUD_HORA");
                    struser = rs.getString("CUD_USUARIO");
                    strXML += "<datos "
                            + " CUD_ID = \"" + intId + "\"  "
                            + " CUD_CURSO = \"" + strNomNew + "\" "
                            + " CUD_CURSO_OLD = \"" + strNomOld + "\" "
                            + " CUD_CLAVE = \"" + strclave + "\" "
                            + " CUD_FECHA = \"" + strFecha + "\" "
                            + " CUD_HORA = \"" + strHora + "\" "
                            + " CUD_USUARIO = \"" + struser + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 4
            if (strid.equals("5")) { //llena giro
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_M = request.getParameter("CG_ID_M");
                int intId = 0;
                String strNomNew = "";
                String strNomOld = "";
                String strFecha = "";
                String strHora = "";
                String struser = "";
                String strSql = "select * from cofide_giro_deta where cg_id_m = " + strID_M + " order by cgd_id";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CGD_ID");
                    strNomNew = rs.getString("CGD_GIRO");
                    strNomOld = rs.getString("CGD_GIRO_OLD");
                    strFecha = rs.getString("CGD_FECHA");
                    strHora = rs.getString("CGD_HORA");
                    struser = rs.getString("CGD_USUARIO");
                    strXML += "<datos "
                            + " CGD_ID = \"" + intId + "\"  "
                            + " CGD_GIRO = \"" + strNomNew + "\" "
                            + " CGD_GIRO_OLD = \"" + strNomOld + "\" "
                            + " CGD_FECHA = \"" + strFecha + "\" "
                            + " CGD_HORA = \"" + strHora + "\" "
                            + " CGD_USUARIO = \"" + struser + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 5
            if (strid.equals("6")) { //llena area
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_M = request.getParameter("CS_ID_M");
                int intId = 0;
                String strNomNew = "";
                String strNomOld = "";
                String strFecha = "";
                String strHora = "";
                String struser = "";
                String strSql = "select * from cofide_segmento_deta where cs_id_m = " + strID_M + " order by csd_id";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CSD_ID");
                    strNomNew = rs.getString("CSD_AREA");
                    strNomOld = rs.getString("CSD_AREA_OLD");
                    strFecha = rs.getString("CSD_FECHA");
                    strHora = rs.getString("CSD_HORA");
                    struser = rs.getString("CSD_USUARIO");
                    strXML += "<datos "
                            + " CSD_ID = \"" + intId + "\"  "
                            + " CSD_AREA = \"" + strNomNew + "\" "
                            + " CSD_AREA_OLD = \"" + strNomOld + "\" "
                            + " CSD_FECHA = \"" + strFecha + "\" "
                            + " CSD_HORA = \"" + strHora + "\" "
                            + " CSD_USUARIO = \"" + struser + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } // fin 6
            if (strid.equals("7")) { //guarda giro_deta
                cofide_curso_giro ccg = new cofide_curso_giro();
                int intlength = Integer.parseInt(request.getParameter("length"));
                String strCC_CURSO_ID = request.getParameter("CC_CURSO_ID");
                //limpiar registros detalle del curso para renovarlos
                String strDel = "delete from cofide_curso_giro where CC_CURSO_ID = " + strCC_CURSO_ID;
                oConn.runQueryLMD(strDel);
                //limpio registros
                int intcc_curso_id = Integer.parseInt(strCC_CURSO_ID);
                for (int i = 0; i < intlength; i++) {
                    String strGiro = request.getParameter("CC_GIRO" + i);
                    ccg.setFieldString("CC_GIRO", strGiro);
                    ccg.setFieldInt("CC_CURSO_ID", intcc_curso_id);
                    String strResCCG = ccg.Agrega(oConn);
                    String strCCG_Id = ccg.getValorKey();
                    int intCCG_Id = 0;
                    if (!strCCG_Id.equals("") || strCCG_Id != null) {
                        intCCG_Id = Integer.parseInt(strCCG_Id);
                    }
                }
            } //fin 7
            if (strid.equals("8")) { //guarda area_deta
                cofide_curso_segmento ccs = new cofide_curso_segmento();
                int intlength = Integer.parseInt(request.getParameter("length"));
                String strCC_CURSO_ID = request.getParameter("CC_CURSO_ID");
                //limpiar registros detalle del curso para el nuevo guardado
                String strDel = "delete from cofide_curso_segmento where CC_CURSO_ID = " + strCC_CURSO_ID;
                oConn.runQueryLMD(strDel); //para renovar los registros
                int intcc_curso_id = Integer.parseInt(strCC_CURSO_ID);
                for (int i = 0; i < intlength; i++) {
                    String strArea = request.getParameter("CC_AREA" + i);
                    ccs.setFieldString("CC_AREA", strArea);
                    ccs.setFieldInt("CC_CURSO_ID", intcc_curso_id);
                    String strResCCS = ccs.Agrega(oConn);
                    String strCCS_Id = ccs.getValorKey();
                    int intCCS_Id = 0;
                    if (!strCCS_Id.equals("") || strCCS_Id != null) {
                        intCCS_Id = Integer.parseInt(strCCS_Id);
                    }
                }
            } //fin 8
            if (strid.equals("9")) { //llena el detalle del giro del curso
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_CURSO = request.getParameter("CC_CURSO_ID");
                int intId = 0;
                String strGiro = "";
                String strSql = "select * from cofide_curso_giro where CC_CURSO_ID = " + strID_CURSO;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CCG_ID");
                    strGiro = rs.getString("CC_GIRO");
                    strXML += "<datos "
                            + " CCG_ID = \"" + intId + "\"  "
                            + " CC_GIRO = \"" + strGiro + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 9
            if (strid.equals("10")) { //llena el detalle del area del curso
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_CURSO = request.getParameter("CC_CURSO_ID");
                int intId = 0;
                String strGiro = "";
                String strSql = "select * from cofide_curso_segmento where CC_CURSO_ID = " + strID_CURSO;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CCS_ID");
                    strGiro = rs.getString("CC_AREA");
                    strXML += "<datos "
                            + " CCS_ID = \"" + intId + "\"  "
                            + " CC_AREA = \"" + strGiro + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 10
            if (strid.equals("11")) { //guardar modulos del curso
                cofide_modulo_curso cmc = new cofide_modulo_curso();
                int intlength = Integer.parseInt(request.getParameter("length"));
                String strCC_CURSO_ID = request.getParameter("CC_CURSO_ID"); //nombre curso
                int intcc_curso_id = Integer.parseInt(strCC_CURSO_ID); //id curso detalle 
                //actualizar detalles
                String strDel = "delete from cofide_modulo_curso where CC_CURSO_ID = " + strCC_CURSO_ID;
                oConn.runQueryLMD(strDel);
                //actualizo detalles
                for (int i = 0; i < intlength; i++) {
                    String strCurso = request.getParameter("CCD_CURSO" + i);
                    int intCC_idM = Integer.parseInt(request.getParameter("CCD_ID" + i)); //id master
                    cmc.setFieldInt("CC_CURSO_ID", intCC_idM); //curso id mater
                    cmc.setFieldString("CC_NOMBRE_CURSO", strCurso);
                    cmc.setFieldInt("CC_CURSO_IDD", intcc_curso_id); //curso id detalle
                    String strResCM = cmc.Agrega(oConn);
                    String strCCS_Id = cmc.getValorKey();
                    int intCCS_Id = 0;
                    if (!strCCS_Id.equals("") || strCCS_Id != null) {
                        intCCS_Id = Integer.parseInt(strCCS_Id);
                    }
                }
            } //fin 11
            if (strid.equals("12")) { //llena modulos del curso
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_CURSO = request.getParameter("CC_CURSO_ID");
                int intId = 0;
                String strGiro = "";
                String strSql = "select * from cofide_modulo_curso where CC_CURSO_ID = " + strID_CURSO;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CM_ID");
                    strGiro = rs.getString("CC_NOMBRE_CURSO");
                    strXML += "<datos "
                            + " CM_ID = \"" + intId + "\"  "
                            + " CC_NOMBRE_CURSO = \"" + strGiro + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } // fin 12
            if (strid.equals("13")) { //llenar meses
                StringBuilder strXmlMes = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
                strXmlMes.append("<meses>");
                String strFechaActual = fec.getFechaActual();
                String strMesActual = strFechaActual.substring(4, 6); //mes actual
                int intMes = 0;
                intMes = Integer.parseInt(strMesActual); //pasar a entero el mes actual
                for (int i = intMes; i <= 12; i++) {
                    String strNombreMes = "";
                    if (i == 1) {
                        strNombreMes = "Enero";
                    }
                    if (i == 2) {
                        strNombreMes = "Febrero";
                    }
                    if (i == 3) {
                        strNombreMes = "Marzo";
                    }
                    if (i == 4) {
                        strNombreMes = "Abril";
                    }
                    if (i == 5) {
                        strNombreMes = "Mayo";
                    }
                    if (i == 6) {
                        strNombreMes = "Junio";
                    }
                    if (i == 7) {
                        strNombreMes = "Julio";
                    }
                    if (i == 8) {
                        strNombreMes = "Agosto";
                    }
                    if (i == 9) {
                        strNombreMes = "Septiembre";
                    }
                    if (i == 10) {
                        strNombreMes = "Octubre";
                    }
                    if (i == 11) {
                        strNombreMes = "Noviembre";
                    }
                    if (i == 12) {
                        strNombreMes = "Diciembre";
                    }
                    strXmlMes.append("<mes ");
                    strXmlMes.append("valor1=\"" + strNombreMes + "\" ");
                    if (i >= 10) {
                        strXmlMes.append("valor2=\"" + i + "\" ");
                    } else {
                        strXmlMes.append("valor2=\"0" + i + "\" ");
                    }
                    strXmlMes.append(" />");
                }
                strXmlMes.append("</meses>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXmlMes.toString());//Pintamos el resultado
            } //fin 13
            if (strid.equals("14")) { //llenar informacion de mail masivo
                String strIdCurso = request.getParameter("CC_CURSO_ID");
                String strFecha = request.getParameter("CC_FECHA_INICIAL");
                strFecha = fec.FormateaBD(strFecha, "/");
                String strFechaMasivos = "";
                String strFechaGroup = "";
                strFechaMasivos = fec.addFecha(strFecha, 5, -10);
                strFechaGroup = fec.addFecha(strFecha, 5, -5);
                String strUpSql = "update cofide_cursos set cc_masivos = '" + strFechaMasivos + "', cc_mailgroup = '" + strFechaGroup + "' where cc_curso_id = " + strIdCurso;
                oConn.runQueryLMD(strUpSql);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println("OK");//Pintamos el resultado
            } //fin 14
            if (strid.equals("15")) { //llena el detalle del giro del curso
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_CURSO = request.getParameter("CCU_ID_M");
                int intId = 0;
                String strGiro = "";
                String strSql = "select * from cofide_catalogo_curso_dgiro where CCU_ID_M = " + strID_CURSO;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CCUG_ID");
                    strGiro = rs.getString("CCUG_GIRO");
                    strXML += "<datos "
                            + " CCG_ID = \"" + intId + "\"  "
                            + " CC_GIRO = \"" + strGiro + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 15
            if (strid.equals("16")) { //llena el detalle del area del curso
                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<cofide_cursos>";
                UtilXml utilXML = new UtilXml();
                String strID_CURSO = request.getParameter("CCU_ID_M");
                int intId = 0;
                String strGiro = "";
                String strSql = "select * from cofide_catalogo_curso_darea where CCU_ID_M = " + strID_CURSO;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intId = rs.getInt("CCUA_ID");
                    strGiro = rs.getString("CCUA_AREA");
                    strXML += "<datos "
                            + " CCS_ID = \"" + intId + "\"  "
                            + " CC_AREA = \"" + strGiro + "\" "
                            + " />";
                }
                strXML += "</cofide_cursos>";
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 16
            if (strid.equals("17")) {
                String strIdSede = request.getParameter("id_sede");
                String strAlias = "";
                String strSql = "select csh_alias from cofide_sede_hotel where csh_id = " + strIdSede;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strAlias = rs.getString("CSH_ALIAS");
        }
                rs.close();
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<datos>");
                strXML.append("<cte");
                strXML.append(" alias = \"").append(strAlias).append("\"");
                strXML.append(" />");
                strXML.append("</datos>");
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado 
            } //fin17
            if (strid.equals("18")) {
                String strIdAlimento = request.getParameter("id_alimento");
                String strHoraAlimento = "";
                String strSql = "select CA_HORA from cofide_alimento where CA_ID =" + strIdAlimento;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strHoraAlimento = rs.getString("CA_HORA");
                }
                rs.close();
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<datos>");
                strXML.append("<cte");
                strXML.append(" horario = \"").append(strHoraAlimento).append("\"");
                strXML.append(" />");
                strXML.append("</datos>");
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado 
            } //fin 18
        }
    } else {
        out.println("Sin acceso");
    }
    oConn.close();

%>