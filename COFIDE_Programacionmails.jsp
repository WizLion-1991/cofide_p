<%-- 
    Document   : COFIDE_Programacionmails
    Created on : 30-mar-2016, 0:09:30
    Author     : juliocesar
--%>

<%@page import="com.mx.siweb.erp.especiales.cofide.COFIDE_Mail_cursos"%>
<%@page import="com.mx.siweb.erp.especiales.cofide.CRM_Envio_Template"%>
<%@page import="Tablas.crm_envio_masivo_deta"%>
<%@page import="Tablas.crm_envio_masivo"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
    COFIDE_Mail_cursos mg = new COFIDE_Mail_cursos(); //enviar mail group
    CRM_Envio_Template crm_tmp = new CRM_Envio_Template();
    StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
    strXML.append("<Mail>");
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("ID");
        if (strid != null) {
            if (strid.equals("1")) { //mostrar mails sugeridos con la fecha de mail masivos del dia de hoy
                String strIdCurso = "";
                String strClave = "";
                String strFechaIni = "";
                String strTemp1 = "";
                String strTemp2 = "";
                String strTemp3 = "";
                String strArea = "";
                String strGiro = "";
                String strSede = "";
                String strNomCurso = "";
                String strFecGroup = "";
                String strConfirm = "";
                String strIdSede = "";
                String strFechaMasivo = fec.getFechaActual();
                String strFecaMasivo = "";
                String strSql = "select cc.*,"
                        + "(select CTT_DESC from cofide_tipo_template where CTT_ID = CC_TEMPLATE1)as strTemplate,"
                        + "(select group_concat(concat_ws(', ',cc_area)) from cofide_curso_segmento where cc_curso_id = cc.cc_curso_id) as cc_areas, "
                        + "(select group_concat(concat_ws(', ',cc_giro)) from cofide_curso_giro where cc_curso_id = cc.cc_curso_id) as cc_giros "
                        + "from cofide_cursos as cc where cc_masivos <= '" + strFechaMasivo + "'";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strIdCurso = rs.getString("CC_CURSO_ID");
                    strIdSede = rs.getString("CC_SEDE_ID");
                    strClave = rs.getString("CC_CLAVES");
                    
                    if(rs.getString("CC_FECHA_INICIAL") != null && rs.getString("CC_FECHA_INICIAL") != ""){
                        strFechaIni = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "/");
                    }else{
                        strFechaIni = "";
                    }
                    if(rs.getString("CC_MASIVOS") != null && !rs.getString("CC_MASIVOS").equals("")){
                        strFecaMasivo = fec.FormateaDDMMAAAA(rs.getString("CC_MASIVOS"), "/");
                    }else{
                        strFecaMasivo = "";
                    }
                    //strTemp1 = rs.getString("CC_TEMPLATE1");
                    strTemp1 = rs.getString("strTemplate");
                    strTemp2 = rs.getString("CC_TEMPLATE2");
                    strTemp3 = rs.getString("CC_TEMPLATE3");
                    strArea = rs.getString("cc_areas");
                    strGiro = rs.getString("cc_giros");
                    strSede = rs.getString("CC_SEDE");
                    strNomCurso = rs.getString("CC_NOMBRE_CURSO");
                    strFecGroup = rs.getString("CC_MAILGROUP");
                    
                    strConfirm = rs.getString("CC_CONFIRMA_MAIL");

                    strXML.append("<datos");
                    strXML.append(" id = \"").append(strIdCurso).append("\"");
                    strXML.append(" id_sede = \"").append(strIdSede).append("\"");
                    strXML.append(" clave = \"").append(strClave).append("\"");
                    strXML.append(" fecini = \"").append(strFechaIni).append("\"");
                    strXML.append(" t1 = \"").append((strTemp1 != null ? strTemp1 : "")).append("\"");
                    strXML.append(" t2 = \"").append(strTemp2).append("\"");
                    strXML.append(" t3 = \"").append(strTemp3).append("\"");
                    strXML.append(" areas = \"").append((strArea == null ? "" : strArea)).append("\"");
                    strXML.append(" giros = \"").append((strGiro == null ? "" : strGiro)).append("\"");
                    strXML.append(" sede = \"").append(util.Sustituye(strSede)).append("\"");
                    strXML.append(" nombre = \"").append(strNomCurso).append("\"");
                    strXML.append(" grupo = \"").append(strFecGroup).append("\"");
                    strXML.append(" masivo = \"").append(strFecaMasivo).append("\"");
                    strXML.append(" confirma = \"").append((strConfirm == "1" ? "SI" : "NO")).append("\"");
                    strXML.append(" />");
                }
                strXML.append("</Mail>");
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin 1

            if (strid.equals("2")) {  //confirmar plantilla 
                String strId_Curso = request.getParameter("CC_CURSO_ID");
                //filtro
                String strGiro = request.getParameter("giro");
                String strSede = request.getParameter("sede");
                String strArea = request.getParameter("area");
                String strComplete = "";
                //filtro
                //confirmar el curso
                String strConfirmaSql = "update cofide_cursos set CC_CONFIRMA_MAIL = 1 where CC_CURSO_ID = " + strId_Curso;
                oConn.runQueryLMD(strConfirmaSql);
                //datos del curso
                String strtemplate1 = "";
                String strtemplate2 = "";
                String strtemplate3 = "";
                String strtemplate1d = "";
                String strtemplate2d = "";
                String strtemplate3d = "";
                String strFechaIni = "";
                String strCT_ID = "";
                String strEmail = "";
                String strUsuario = varSesiones.getStrUser();
                String strFecha = fec.getFechaActual();
                String strHora = fec.getHoraActual();
                int intCte = 0;
                int intResultado = 0;
                String strCorreo = "";
                //obtener los datos del curso
                String strSqlDatos = "select *, "
                        + "(select CTT_DESC from cofide_tipo_template where CTT_ID = CC_TEMPLATE1) as Template1, "
                        + "(select CTT_DESC from cofide_tipo_template where CTT_ID = CC_TEMPLATE2) as Template2, "
                        + "(select CTT_DESC from cofide_tipo_template where CTT_ID = CC_TEMPLATE3) as Template3 "
                        + "from cofide_cursos where cc_curso_id = " + strId_Curso;
                ResultSet rs = oConn.runQuery(strSqlDatos, true);
                while (rs.next()) {
                    //strtemplate1 = rs.getString("CC_TEMPLATE1");
                    //strtemplate2 = rs.getString("CC_TEMPLATE2");
                    //strtemplate3 = rs.getString("CC_TEMPLATE3");
                    strtemplate1d = rs.getString("Template1");
                    //strtemplate2d = rs.getString("Template2");
                    //strtemplate3d = rs.getString("Template3");
                    strFechaIni = rs.getString("CC_MASIVOS");
                }
                rs.close();
                crm_envio_masivo crm = new crm_envio_masivo();
                crm.setFieldString("CRM_TEMPLATE", strtemplate1d);
                crm.setFieldString("CRM_FECHAFIN", strFechaIni);
                crm.setFieldString("CRM_FECHA", strFecha);
                crm.setFieldString("CRM_USUARIO", strUsuario);
                crm.setFieldString("CRM_HORA", strHora);
                crm.setFieldString("CRM_CURSO", strId_Curso);
                crm.setBolGetAutonumeric(true);
                crm.Agrega(oConn);
                String Result1 = crm.getValorKey(); //el id master que ocupare para el mail masivo deta
                intResultado = Integer.parseInt(Result1);

                if (!strGiro.equals("") && !strSede.equals("") && !strArea.equals("")) {
                    strComplete = "where CT_GIRO in (select CG_GIRO from cofide_giro where CG_ID_M in (" + strGiro + ")) "
                            + "and CT_SEDE in (select CS_SEDE from cofide_sede where CS_SEDE_ID in (" + strSede + ")) "
                            + "and CT_AREA in (select CS_AREA from cofide_segmento where CS_ID_M in (" + strArea + "))";
                } //los 3 filtros 
                if (!strGiro.equals("") && !strSede.equals("") && strArea.equals("")) {
                    strComplete = "where CT_GIRO in (select CG_GIRO from cofide_giro where CG_ID_M in (" + strGiro + ")) "
                            + "and CT_SEDE in (select CS_SEDE from cofide_sede where CS_SEDE_ID in (" + strSede + ")) ";
                } //filtro de giro y sede
                if (!strGiro.equals("") && strSede.equals("") && !strArea.equals("")) {
                    strComplete = "where CT_GIRO in (select CG_GIRO from cofide_giro where CG_ID_M in (" + strGiro + ")) "
                            + "and CT_AREA in (select CS_AREA from cofide_segmento where CS_ID_M in (" + strArea + "))";
                } //filtro de giro y area
                if (strGiro.equals("") && !strSede.equals("") && !strArea.equals("")) {
                    strComplete = "where CT_SEDE in (select CS_SEDE from cofide_sede where CS_SEDE_ID in (" + strSede + ")) "
                            + "and CT_AREA in (select CS_AREA from cofide_segmento where CS_ID_M in (" + strArea + "))";
                } //filtro de sede y area
                if (!strGiro.equals("") && strSede.equals("") && strArea.equals("")) {
                    strComplete = "where CT_GIRO in (select CG_GIRO from cofide_giro where CG_ID_M in (" + strGiro + ")) ";
                } //filtro de giro
                if (strGiro.equals("") && !strSede.equals("") && strArea.equals("")) {
                    strComplete = "where CT_SEDE in (select CS_SEDE from cofide_sede where CS_SEDE_ID in (" + strSede + ")) ";
                } //filtro de sede
                if (strGiro.equals("") && strSede.equals("") && !strArea.equals("")) {
                    strComplete = "where CT_AREA in (select CS_AREA from cofide_segmento where CS_ID_M in (" + strArea + "))";
                } //filtro de area

                String strSql = "select * from vta_cliente " + strComplete;
                ResultSet rsCte = oConn.runQuery(strSql, true);
                while (rsCte.next()) {
                    strCT_ID = rsCte.getString("CT_ID");
                    strEmail = rsCte.getString("CT_EMAIL1");
                    crm_envio_masivo_deta crmd = new crm_envio_masivo_deta();
                    crmd.setFieldString("CT_ID", strCT_ID);
                    crmd.setFieldString("CRMD_EMAIL", strEmail);
                    crmd.setFieldInt("CRM_ID", intResultado);
                    crmd.setFieldString("CRMD_ESTATUS_ENVIO", "0");
                    crmd.setFieldString("CRMD_ESTATUS", "0");
                    crmd.setBolGetAutonumeric(true);
                    crmd.Agrega(oConn);
                }
                rsCte.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println("OK");//Pintamos el resultado
            } // fin 2

            /*
             filtro por curso seleccionado
             
             if (strid.equals("2")) {  //confirmar plantilla 
             String strId_Curso = request.getParameter("CC_CURSO_ID");
             //filtro
             //confirmar el curso
             String strConfirmaSql = "update cofide_cursos set CC_CONFIRMA_MAIL = 1 where CC_CURSO_ID = " + strId_Curso;
             oConn.runQueryLMD(strConfirmaSql);
             //datos del curso
             String strtemplate1 = "";
             String strtemplate2 = "";
             String strtemplate3 = "";
             String strtemplate1d = "";
             String strtemplate2d = "";
             String strtemplate3d = "";
             String strFechaIni = "";
             String strGiro = "";
             String strArea = "";
             String strSede = "";
             String strCurso = "";
             String strCT_ID = "";
             String strEmail = "";
             String strUsuario = varSesiones.getStrUser();
             String strFecha = fec.getFechaActual();
             String strHora = fec.getHoraActual();
             int intCte = 0;
             String strCorreo = "";
             //obtener los datos del curso
             String strSqlDatos = "select *, "
             + "(select CTT_DESC from cofide_tipo_template where CTT_ID = CC_TEMPLATE1) as Template1, "
             + "(select CTT_DESC from cofide_tipo_template where CTT_ID = CC_TEMPLATE2) as Template2, "
             + "(select CTT_DESC from cofide_tipo_template where CTT_ID = CC_TEMPLATE3) as Template3 "
             + "from cofide_cursos where cc_curso_id = " + strId_Curso;
             ResultSet rs = oConn.runQuery(strSqlDatos, true);
             while (rs.next()) { //obtener el template que se va a usar
             strtemplate1d = rs.getString("Template1"); //template
             strFechaIni = rs.getString("CC_MASIVOS"); //fecha de envio de masivos
             strCurso = rs.getString("CC_NOMBRE_CURSO"); //fecha de envio de masivos
             }
             rs.close();

             crm_envio_masivo crm = new crm_envio_masivo(); //guardar registro en el master
             crm.setFieldString("CRM_TEMPLATE", strtemplate1d);
             crm.setFieldString("CRM_FECHAFIN", strFechaIni);
             crm.setFieldString("CRM_FECHA", strFecha);
             crm.setFieldString("CRM_USUARIO", strUsuario);
             crm.setFieldString("CRM_HORA", strHora);
             crm.setFieldString("CRM_CURSO", strCurso);
             crm.setBolGetAutonumeric(true);
             crm.Agrega(oConn);
             String Result1 = crm.getValorKey(); //recuperar el ID master para guardar su detalle

             //obtener los filtros del curso
             String strSQLFiltro = "select cc.CC_NOMBRE_CURSO, cc.CC_SEDE,"
             + "(select group_concat(concat_ws('',concat('\\'',cc_area,'\\''))) from cofide_curso_segmento where cc_curso_id = cc.cc_curso_id) as CC_AREA, "
             + "(select group_concat(concat_ws('',concat('\\'',cc_giro,'\\''))) from cofide_curso_giro where cc_curso_id = cc.cc_curso_id) as CC_GIRO "
             + "from cofide_cursos as cc where cc_curso_id = " + strId_Curso;
             //filtros del curso
             ResultSet rsFiltro = oConn.runQuery(strSQLFiltro, true);
             while (rsFiltro.next()) {

             strSede = rsFiltro.getString("CC_SEDE");
             strGiro = rsFiltro.getString("CC_GIRO");
             strArea = rsFiltro.getString("CC_AREA");

             }
             rsFiltro.close();

             String strSql = "select * from vta_cliente where ct_giro in (" + strGiro + ") and ct_area in (" + strArea + ") and CT_SEDE = '" + strSede + "'";
             ResultSet rsCte = oConn.runQuery(strSql, true);
             while (rsCte.next()) {
             strCT_ID = rsCte.getString("CT_ID");
             strEmail = rsCte.getString("CT_EMAIL1");
             crm_envio_masivo_deta crmd = new crm_envio_masivo_deta();
             crmd.setFieldString("CT_ID", strCT_ID);
             crmd.setFieldString("CRMD_EMAIL", strEmail);
             crmd.setFieldInt("CRM_ID", Integer.parseInt(Result1));
             crmd.setFieldString("CRMD_ESTATUS_ENVIO", "0");
             crmd.setFieldString("CRMD_ESTATUS", "0");
             crmd.setBolGetAutonumeric(true);
             crmd.Agrega(oConn);
             }
             rsCte.close();
             out.clearBuffer();//Limpiamos buffer
             atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
             out.println("OK");//Pintamos el resultado
             } // fin 2
             */
            if (strid.equals("3")) { // 
                String strFecIni = fec.FormateaBD(request.getParameter("fecini"), "/");
                String strFecFin = fec.FormateaBD(request.getParameter("fecfin"), "/");
                String strCrm_Id = "";
                String strCrm_Fecha = "";
                String strCrm_Hora = "";
                String strCrm_Usuario = "";
                String strCrm_template = "";
                String strCrm_Curso = "";
                String strSqlEmail = "select * from crm_envio_masivo where CRM_FECHA between '" + strFecIni + "' and '" + strFecFin + "' order by CRM_FECHA;";
                ResultSet rs = oConn.runQuery(strSqlEmail, true);
                while (rs.next()) {
                    strCrm_Id = rs.getString("CRM_ID");
                    if(rs.getString("CRM_FECHA") != null && !rs.getString("CRM_FECHA").equals("")){
                        strCrm_Fecha = fec.FormateaDDMMAAAA(rs.getString("CRM_FECHA"), "/");
                    }else{
                        strCrm_Fecha = "";
                    }
                    
                    strCrm_Hora = rs.getString("CRM_HORA");
                    strCrm_Usuario = rs.getString("CRM_USUARIO");
                    strCrm_template = rs.getString("CRM_TEMPLATE");
                    strCrm_Curso = rs.getString("CRM_CURSO");

                    strXML.append("<datos");
                    strXML.append(" id = \"").append(strCrm_Id).append("\"");
                    strXML.append(" fecha = \"").append(strCrm_Fecha).append("\"");
                    strXML.append(" hora = \"").append(strCrm_Hora).append("\"");
                    strXML.append(" usuario = \"").append(strCrm_Usuario).append("\"");
                    strXML.append(" template = \"").append((strCrm_template != null ? strCrm_template : "")).append("\"");
                    strXML.append(" curso = \"").append(strCrm_Curso).append("\"");
                    strXML.append(" />");
                }
                strXML.append("</Mail>");
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //3
            if (strid.equals("4")) { // 
                String strCrm_id = request.getParameter("idm");
                String strCT_ID = "";
                String strCrmd_ID = "";
                String strCrmd_Correo = "";
                String strCrmd_Procesado = "";
                String strSqlMailD = "select * from crm_envio_masivo_deta WHERE CRM_ID  = " + strCrm_id + " order by CT_ID";
                ResultSet rs = oConn.runQuery(strSqlMailD, true);
                while (rs.next()) {
                    strCT_ID = rs.getString("CT_ID");
                    strCrmd_ID = rs.getString("CRMD_ID");
                    strCrmd_Correo = rs.getString("CRMD_EMAIL");
                    strCrmd_Procesado = rs.getString("CRM_PROCESADO");

                    strXML.append("<datos");
                    strXML.append(" id_cte = \"").append(strCT_ID).append("\"");
                    strXML.append(" idm = \"").append(strCrm_id).append("\"");
                    strXML.append(" id = \"").append(strCrmd_ID).append("\"");
                    strXML.append(" mail = \"").append(strCrmd_Correo).append("\"");
                    strXML.append(" procesado = \"").append(strCrmd_Procesado).append("\"");
                    strXML.append(" />");
                }
                strXML.append("</Mail>");
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //fin4
            if (strid.equals("5")) {
                String strNumCte = request.getParameter("CT_NUM_CTE");
                //Recibir el curso ID 
                String strCurso = request.getParameter("CURSO"); //obtiene el nombre del curso
                int intId_Curso = 0;
                String strSqlId = "select CC_CURSO_ID from cofide_cursos where CC_NOMBRE_CURSO = '" + strCurso + "'"; //obtiene el ID del curso
                ResultSet rsId = oConn.runQuery(strSqlId, true);
                while (rsId.next()) {
                    intId_Curso = rsId.getInt("CC_CURSO_ID"); //guardamos el id del curso 
                }
                rsId.close();
                String strCte = "";
                String strMailCte = "";
                String strMailContacto = "";
                int intAgente = varSesiones.getIntNoUser();
                String strSqlMail1 = "select CT_RAZONSOCIAL, CT_EMAIL1 from vta_cliente where ct_id = " + strNumCte + " and CT_MAILMES = 0"; //obtenemos el correo del contacto principal
                ResultSet rsMail1 = oConn.runQuery(strSqlMail1, true);
                while (rsMail1.next()) {
                    strCte = rsMail1.getString("CT_RAZONSOCIAL");
                    strMailCte = rsMail1.getString("CT_EMAIL1");
                    mg.MailGroup(oConn, strCte, strMailCte, intId_Curso, intAgente); //manda correo al cliente
                }
                rsMail1.close();
                String strSqlMail2 = "select * from cofide_contactos where CT_MAILMES = 0 and CT_ID = " + strNumCte; //obtenemos el correo de los contactos del cliente
                ResultSet rsMail2 = oConn.runQuery(strSqlMail2, true);
                while (rsMail2.next()) {
                    strMailContacto = rsMail2.getString("CCO_CORREO");
                    mg.MailGroup(oConn, strCte, strMailContacto, intId_Curso, intAgente); //manda el correo a los contactos
                }
                rsMail2.close();
                out.clearBuffer();//Limpiamos buffer
            } //5
            if (strid.equals("6")) { //llena listado de cursos sugeridos mailgroup
                String strIdCurso = "";
                String strClave = "";
                String strFechaIni = "";
                String strTemp2 = "";
                String strArea = "";
                String strGiro = "";
                String strSede = "";
                String strNomCurso = "";
                String strFecGroup = "";
                String strConfirm = "";
                String strIdSede = "";
                String strFechaActualGroup = fec.getFechaActual();
                String strSql = "select cc.*,"
                        + "(select group_concat(concat_ws(', ',cc_area)) from cofide_curso_segmento where cc_curso_id = cc.cc_curso_id) as cc_areas, "
                        + "(select group_concat(concat_ws(', ',cc_giro)) from cofide_curso_giro where cc_curso_id = cc.cc_curso_id) as cc_giros "
                        + "from cofide_cursos as cc where CC_MAILGROUP = '" + strFechaActualGroup + "'";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strIdCurso = rs.getString("CC_CURSO_ID");
                    strIdSede = rs.getString("CC_SEDE_ID");
                    strClave = rs.getString("CC_CLAVES");
                    strFechaIni = rs.getString("CC_FECHA_INICIAL");
                    strTemp2 = rs.getString("CC_TEMPLATE2");
                    strArea = rs.getString("cc_areas");
                    strGiro = rs.getString("cc_giros");
                    strSede = rs.getString("CC_SEDE");
                    strNomCurso = rs.getString("CC_NOMBRE_CURSO");
                    strFecGroup = rs.getString("CC_MAILGROUP");
                    strConfirm = rs.getString("CC_CONFIRMA_MAIL");

                    strXML.append("<datos");
                    strXML.append(" id = \"").append(strIdCurso).append("\"");
                    strXML.append(" id_sede = \"").append(strIdSede).append("\"");
                    strXML.append(" clave = \"").append(strClave).append("\"");
                    strXML.append(" fecini = \"").append(strFechaIni).append("\"");
                    strXML.append(" t2 = \"").append(strTemp2).append("\"");
                    strXML.append(" areas = \"").append(strArea).append("\"");
                    strXML.append(" giros = \"").append(strGiro).append("\"");
                    strXML.append(" sede = \"").append(strSede).append("\"");
                    strXML.append(" nombre = \"").append(strNomCurso).append("\"");
                    strXML.append(" grupo = \"").append(strFecGroup).append("\"");
                    strXML.append(" confirma = \"").append(strConfirm).append("\"");
                    strXML.append(" />");
                }
                strXML.append("</Mail>");
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            } //6
            if (strid.equals("7")) {
                String strCC_ID_CURSO = request.getParameter("id_curso");
                String strTemplate = request.getParameter("template");
                String strTipo = request.getParameter("TipoCurso");
                String strSql = "";
                if (strTipo.equals("1")) {
                    strSql = "update cofide_cursos set CC_TEMPLATE1 = " + strTemplate + " where CC_CURSO_ID = " + strCC_ID_CURSO;
                    oConn.runQueryLMD(strSql);
                } else if (strTipo.equals("2")) {
                    strSql = "update cofide_cursos set CC_TEMPLATE2 = " + strTemplate + " where CC_CURSO_ID = " + strCC_ID_CURSO;
                    oConn.runQueryLMD(strSql);
                } else {
                    out.println("No Hay Opción");
                }
            } //7
            if (strid.equals("8")) {
                String strCorreo = request.getParameter("email");
                //String strCurso = request.getParameter("curso");
                int intCurso = Integer.parseInt(request.getParameter("curso"));
                String strRespuesta = "";
                //System.out.println("email: " + strCorreo + " curso: " + intCurso);
                int intAgente = varSesiones.getIntNoUser();
                strRespuesta = crm_tmp.MailGroup(oConn, "", strCorreo, intCurso, intAgente);
                out.println(strRespuesta);
            }
            if (strid.equals("9")) {
                String strIdCurso = request.getParameter("id_curso");
                String strSql = "update cofide_cursos set CC_CONFIRMA_MG = 1,CC_CONFIRMA_MAIL = 1  "
                        + "where CC_CURSO_ID = " + strIdCurso;
                oConn.runQueryLMD(strSql);
            }
        } //fin if strid != null
    }
    oConn.close();
%>
