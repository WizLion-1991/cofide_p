<%-- 
    Document   : COFIDE_CursosImpartir
    Created on : 25-oct-2016, 9:45:09
    Author     : casajosefa
--%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
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
    UtilXml util = new UtilXml();
    Fechas fec = new Fechas();
    String strRes = "";
    String strSql = "";
    ResultSet rs = null;

    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("id");
        if (strid != null) {
            //Consulta el Catalogo de Cursos Asignados
            if (strid.equals("1")) {
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<CursosImpartir>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "select *,"
                        + "(select GROUP_CONCAT(concat_ws(', ',CC_SEDE)) from cofide_cursos where cofide_cursos.CC_CLAVES = cofide_catalogo_curso.CCU_ID_M and SUBSTR(cofide_cursos.CC_FECHA_INICIAL,1,6) = '" + strAnio + strMes + "') as SEDE_ASIGNADA,"
                        + "(select GROUP_CONCAT(concat_ws(', ',CC_FECHA_INICIAL)) from cofide_cursos where cofide_cursos.CC_CLAVES = cofide_catalogo_curso.CCU_ID_M and SUBSTR(cofide_cursos.CC_FECHA_INICIAL,1,6) = '" + strAnio + strMes + "') as FECHA_ASIGNADA "
                        + "from cofide_catalogo_curso";
                try {
                    int intDisponibles = 0;
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        String strSedeAsig = "";
                        String strFechaAsig = "";
                        if (rs.getString("SEDE_ASIGNADA") != null) {
                            strSedeAsig = util.Sustituye(rs.getString("SEDE_ASIGNADA"));
                        }
                        if (rs.getString("FECHA_ASIGNADA") != null) {
                            strFechaAsig = fec.FormateaDDMMAAAA(rs.getString("FECHA_ASIGNADA"), "/");
                        }
                        strXML.append("<datos");
                        strXML.append(" CCU_ID_M = \"").append(rs.getInt("CCU_ID_M")).append("\"");
                        strXML.append(" CCU_CURSO = \"").append(util.Sustituye(rs.getString("CCU_CURSO"))).append("\"");
                        strXML.append(" SEDE_ASIGNADA = \"").append(strSedeAsig).append("\"");
                        strXML.append(" FECHA_ASIGNADA = \"").append(strFechaAsig).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</CursosImpartir>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta COFIDE CATALOGO: " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 1

            //Regresa las SEDES Disponibles del mes
            if (strid.equals("2")) {
                String strFiltro = "";
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                String strCursoEd = request.getParameter("CursoEditar");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<SedeDisponible>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                if (!strCursoEd.equals("0")) {
                    strFiltro = " OR CC_CURSO_ID = " + strCursoEd;
                }

                strSql = "select CC_CURSO_ID,CC_SEDE,CC_FECHA_INICIAL,CC_HR_EVENTO_INI,CC_HR_EVENTO_FIN from cofide_cursos "
                        + "where SUBSTR(cofide_cursos.CC_FECHA_INICIAL,1,6) = '" + strAnio + strMes + "' and CC_CLAVES = ''"
                        + strFiltro;
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        String strSedeAsig = "";
                        String strFechaAsig = "";
                        String strHoraAsig = "";
                        String strHoraAsigFin = "";
                        if (rs.getString("CC_SEDE") != null) {
                            strSedeAsig = rs.getString("CC_SEDE");
                        }
                        if (rs.getString("CC_FECHA_INICIAL") != null) {
                            strFechaAsig = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "/");
                        }
                        if (rs.getString("CC_HR_EVENTO_INI") != null) {
                            strHoraAsig = rs.getString("CC_HR_EVENTO_INI");
                        }
                        if (rs.getString("CC_HR_EVENTO_FIN") != null) {
                            strHoraAsigFin = rs.getString("CC_HR_EVENTO_FIN");
                        }
                        strXML.append("<datos");
                        strXML.append(" CC_CURSO_ID = \"").append(rs.getInt("CC_CURSO_ID")).append("\"");
                        strXML.append(" CCU_CURSO = \"").append(util.Sustituye(rs.getString("CC_SEDE")) + " " + strFechaAsig + " " + strHoraAsig + " A " + strHoraAsigFin).append("\"");
                        strXML.append(" SEDE_ASIGNADA = \"").append(strSedeAsig).append("\"");
                        strXML.append(" FECHA_ASIGNADA = \"").append(strFechaAsig).append("\"");
                        strXML.append(" HORA_ASIGNADA = \"").append(strHoraAsig).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();

                    if (!strCursoEd.equals("0")) {
                        strXML.append("<CursoEdit>");
                        strSql = "select CC_PROGRAMAR, CC_IS_PRESENCIAL, CC_IS_ONLINE, CC_INSTRUCTOR_ID from cofide_cursos where CC_CURSO_ID = " + strCursoEd;
                        try {
                            rs = oConn.runQuery(strSql, true);
                            while (rs.next()) {
                                strXML.append("<datos");
                                strXML.append(" CC_PROGRAMAR = \"").append(rs.getInt("CC_PROGRAMAR")).append("\"");
                                strXML.append(" CC_IS_PRESENCIAL = \"").append(rs.getInt("CC_IS_PRESENCIAL")).append("\"");
                                strXML.append(" CC_IS_ONLINE = \"").append(rs.getInt("CC_IS_ONLINE")).append("\"");
                                strXML.append(" CC_INSTRUCTOR_ID = \"").append(rs.getInt("CC_INSTRUCTOR_ID")).append("\"");
                                strXML.append(" />");
                            }
                            rs.close();
                            strXML.append("</CursoEdit>");
                        } catch (SQLException ex) {
                            System.out.println("Error GetConsulta COFIDE CURSO _edit " + ex.getLocalizedMessage());
                        }
                    }
                    strXML.append("</SedeDisponible>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta COFIDE CATALOGO: " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 2

            //Regresa las SEDES usadas en los 12 meses anteriores
            if (strid.equals("3")) {
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                String strClave = request.getParameter("Clave");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<MesesAnteriores>");

                strXML.append("<datos");
                strXML.append(getCursosMesAnterior(oConn, strAnio, strMes, strClave));
                strXML.append(" />");
                strXML.append("</MesesAnteriores>");

                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 3

            //Actualiza Informacion del Curso
            if (strid.equals("4")) {
                strRes = "";
                String strSede = request.getParameter("SEDE");
                String strInstructor = request.getParameter("INSTRUCTOR");
                String strInstructorNom = request.getParameter("INSTRUCTOR_NOMBRE");
                String strCursoClave = request.getParameter("CursoClave");
                String strCursoDesc = request.getParameter("CursoDesc");
                String strProgramar = request.getParameter("SePrograma");
                String strPresencial = request.getParameter("Presencial");
                String strOnline = request.getParameter("Online");

                strSql = "update cofide_cursos set "
                        + "CC_CLAVES = " + strCursoClave
                        + ",CC_NOMBRE_CURSO = '" + strCursoDesc + "' "
                        + ",CC_INSTRUCTOR_ID = " + strInstructor
                        + ",CC_INSTRUCTOR = '" + strInstructorNom + "' "
                        + ",CC_IS_PRESENCIAL = " + strPresencial
                        + ",CC_IS_ONLINE = " + strOnline
                        + ",CC_PROGRAMAR = " + strProgramar
                        + " where CC_CURSO_ID = " + strSede;

                oConn.runQueryLMD(strSql);

                if (oConn.getStrMsgError().equals("")) {
                    strRes = "OK";
                } else {
                    strRes = oConn.getStrMsgError();
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 4

            //Envia correo al instructor sobre el nuevo curso a impartir
            if (strid.equals("5")) {
                strRes = "";
                String strMail = "";
                String strNomInstructor = "";
                String strInstructor = request.getParameter("IdInstructor");
                String strMes = request.getParameter("Mes");
                String strAnio = request.getParameter("Anio");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "select CI_EMAIL,CI_INSTRUCTOR from cofide_instructor where CI_INSTRUCTOR_ID = " + strInstructor;

                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        strMail = rs.getString("CI_EMAIL");
                        strNomInstructor = util.Sustituye(rs.getString("CI_INSTRUCTOR"));
                    }
                    rs.close();
                } catch (SQLException ex) {
                    System.out.println("ErrorMail Instructor: " + ex.getLocalizedMessage());
                }

                if (strMail.equals("")) {
                    strRes = "El Instructor no tiene configurado un Email.";
                } else {

                    Mail mail = new Mail();

                    if (mail.isEmail(strMail)) {
                        String strMailHTML = getMailInstructor(oConn, strInstructor, strAnio + strMes, strNomInstructor);
                        //Intentamos mandar el mail
                        mail.setBolDepuracion(false);
                        mail.getTemplate("CURSO_INSTR", oConn);
                        String strMessage = mail.getMensaje().replace("%strHTML%", strMailHTML);
                        mail.setMensaje(strMessage);

                        mail.setDestino(strMail);
                        boolean bol = mail.sendMail();
                        if (bol) {
                            strRes = "OK";
                            //strResp = "MAIL ENVIADO.";
                        } else {
                            strRes = "no se envio...";
                            //strResp = "FALLO EL ENVIO DEL MAIL.";
                        }
                    } else {
                        strRes = "El Email del instructor no es un Email valido.";
                    }
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 5

            //Envia correo al instructor sobre el nuevo curso a impartir
            if (strid.equals("6")) {
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                String strInstructor = request.getParameter("Instructor");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<EvaluacionIns>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "select cofide_cursos.CC_CURSO_ID,cofide_cursos.CC_NOMBRE_CURSO,cofide_cursos.CC_FECHA_INICIAL,"
                        + "(select CI_INSTRUCTOR from cofide_instructor where CI_INSTRUCTOR_ID = 1)as Instructor,"
                        + "avg(cofide_evaluacion_curso.CEC_EVALUACION) as PROMEDIO from `cofide_evaluacion_curso`, cofide_cursos "
                        + "where cofide_evaluacion_curso.CEC_ID_CURSO =  cofide_cursos.CC_CURSO_ID "
                        + "and cofide_cursos.CC_INSTRUCTOR_ID = " + strInstructor
                        + "  and SUBSTR(CC_FECHA_INICIAL,1,6) = '" + strAnio + strMes + "' "
                        + "group by cofide_cursos.CC_CURSO_ID,cofide_cursos.CC_NOMBRE_CURSO,cofide_cursos.CC_FECHA_INICIAL;";
                try {
                    int intDisponibles = 0;
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        String strSedeAsig = "";
                        String strFechaAsig = "";
                        if (rs.getString("CC_FECHA_INICIAL") != null) {
                            strFechaAsig = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "/");
                        }
                        strXML.append("<datos");
                        strXML.append(" GR_CURSODESC = \"").append(util.Sustituye(rs.getString("CC_NOMBRE_CURSO"))).append("\"");
                        strXML.append(" GR_CURSODPROM = \"").append(rs.getDouble("PROMEDIO")).append("\"");
                        strXML.append(" GR_CURSOFECHA = \"").append(strFechaAsig).append("\"");
                        strXML.append(" Instructor = \"").append(rs.getString("Instructor")).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</EvaluacionIns>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta Evaluacion Cursos Instructor: " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 6

        } else {
            out.print("SIN CONEXION.");
        }
        oConn.close();
    }
%>
<%!
    Fechas fec = new Fechas();
    String strRes = "";
    String strSql = "";
    ResultSet rs = null;
    UtilXml util = new UtilXml();

    public String getCursosMesAnterior(Conexion oConn, String strAnio, String strMes, String strClave) {
        StringBuilder strXML = new StringBuilder("");
        Fechas fec = new Fechas();
        String strFechaActual = fec.getFechaActual();
        int intAnioActual = Integer.parseInt(strAnio);
        int intMesActual = Integer.parseInt(strMes);
        boolean blAnioPas = false;
        for (int i = 1; i <= 12; i++) {
            int tmpMes = 0;
            int tmpAnio = 0;

            tmpMes = intMesActual - 1;

            if (tmpMes == 0) {
                tmpAnio = intAnioActual - 1;
                tmpMes = 12;
                blAnioPas = true;
            } else {
                if (!blAnioPas) {
                    tmpAnio = intAnioActual;
                } else {
                    tmpAnio = intAnioActual - 1;
                }
            }
            String strTmpMes = "" + tmpMes;
            if (strTmpMes.length() == 1) {
                strTmpMes = "0" + strTmpMes;
            }
            strSql = "select *,"
                    + "(select GROUP_CONCAT(concat_ws(', ',CC_SEDE)) from cofide_cursos where cofide_cursos.CC_CLAVES = cofide_catalogo_curso.CCU_ID_M and SUBSTR(cofide_cursos.CC_FECHA_INICIAL,1,6) = '" + tmpAnio + strTmpMes + "') as SEDE_ASIGNADA,"
                    + "(select GROUP_CONCAT(concat_ws(', ',CC_FECHA_INICIAL)) from cofide_cursos where cofide_cursos.CC_CLAVES = cofide_catalogo_curso.CCU_ID_M and SUBSTR(cofide_cursos.CC_FECHA_INICIAL,1,6) = '" + tmpAnio + strTmpMes + "') as FECHA_ASIGNADA "
                    + "from cofide_catalogo_curso where CCU_ID_M = " + strClave;

            try {
                rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    String strSedeAsig = "";
                    String strFechaAsig = "";
                    if (rs.getString("SEDE_ASIGNADA") != null) {
                        strSedeAsig = rs.getString("SEDE_ASIGNADA");
                        strSedeAsig = util.Sustituye(strSedeAsig);
                    }
                    if (rs.getString("FECHA_ASIGNADA") != null) {
                        strFechaAsig = fec.FormateaDDMMAAAA(rs.getString("FECHA_ASIGNADA"), "/");
                    }
                    if (strFechaAsig.equals("")) {
                        strXML.append(" CCU_MES" + i + " = \"").append("NO SE IMPARTIO").append("\"");
                    } else {
                        strXML.append(" CCU_MES" + i + " = \"").append(strSedeAsig + " - " + strFechaAsig).append("\"");
                    }
                }
                rs.close();
            } catch (SQLException ex) {
                System.out.println("GET Meses Anteriores: " + ex.getLocalizedMessage());
            }
            intMesActual = tmpMes;
        }
        return strXML.toString();
    }//Fin getCursosMesAnterior

    public String getMailInstructor(Conexion oConn, String strInstructor, String strFecha, String strNomInstructor) {
        String strSql = "SELECT CC_FECHA_INICIAL,CC_SEDE,CC_SESION,CC_DURACION_HRS,CC_NOMBRE_CURSO,CC_INSTRUCTOR,CC_IS_PRESENCIAL "
                + "FROM cofide_cursos where CC_INSTRUCTOR_ID = " + strInstructor + " and CC_FECHA_INICIAL like '%" + strFecha + "%' and CC_CLAVES <> '' "
                + "order by CC_FECHA_INICIAL";
        StringBuilder strXML = new StringBuilder();
        Fechas fec = new Fechas();
        UtilXml util = new UtilXml();
        String strPieCorreo = "<br><br><br>"
                + "De no ser recibida respuesta alguna en los siguientes 4 días hábiles consideraremos que no le es posible apoyarnos en esta programación."
                + "<br><br><br>"
                + "Saludos.<br><br>"
                + "Departamento de Academia<br><br>"
                + "<b>CORPORATIVO FISCAL DÉCADA S.C.</b>";
        strXML.append("<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<style>"
                + "table {"
                + "    font-family: arial, sans-serif;"
                + "    border-collapse: collapse;"
                + "    width: 100%;"
                + "}"
                + "td, th {"
                + "    border: 1px solid #dddddd;"
                + "    text-align: left;"
                + "    padding: 8px;"
                + "}"
                + "tr:nth-child(even) {"
                + "    background-color: #dddddd;"
                + "}"
                + "</style>"
                + "<br>Estimado: " + replaceCharMail(strNomInstructor)
                + "<br><br>"
                + "<br> Favor de revisar su agenda y confirmar fechas y horarios de los siguientes cursos:"
                + "<br><br>"
                + "</head>");
        strXML.append("<table>"
                + "<tr>"
                + "    <th>FECHA DEL EVENTO</th>"
                + "    <th>SEDE</th>"
                + "    <th>TIPO DE EVENTO</th>"
                + "    <th>SESI&Oacute;N</th>"
                + "    <th>DURACI&Oacute;N EN HORAS</th>"
                + "    <th>NOMBRE DEL CURSO</th>"
                + "</tr>");

        try {
            //CC_FECHA_INICIAL,CC_SEDE,CC_SESION,CC_DURACION_HRS,CC_NOMBRE_CURSO,CC_INSTRUCTOR
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                String stFecha = "";
                if (rs.getString("CC_FECHA_INICIAL") != null) {
                    strFecha = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "/");
                }
                strXML.append("<tr>");
                strXML.append("<td style=\"text-align:center\">").append(strFecha).append("</td>");
                strXML.append("<td>").append(replaceCharMail(rs.getString("CC_SEDE"))).append("</td>");
                if (rs.getInt("CC_IS_PRESENCIAL") == 1) {
                    strXML.append("<td>").append("PRESENCIAL").append("</td>");
                } else {
                    strXML.append("<td>").append("LINEA").append("</td>");
                }
                strXML.append("<td>").append(rs.getString("CC_SESION")).append("</td>");
                strXML.append("<td style=\"text-align:center\">").append(rs.getString("CC_DURACION_HRS")).append("</td>");
                strXML.append("<td>").append(replaceCharMail(rs.getString("CC_NOMBRE_CURSO"))).append("</td>");
                strXML.append("</tr>");
            }
            strXML.append("</table>"
                    + replaceCharMail(strPieCorreo)
                    + "</body>"
                    + "</html>");
            rs.close();
        } catch (SQLException ex) {
            System.out.println("Get MailCursos Instructor: " + ex.getLocalizedMessage());
        }

        return strXML.toString();
    }//Fin getMailInstructor

    public String replaceCharMail(String strChar) {
        if (strChar.contains("á")) {
            strChar = strChar.replace("á", "&aacute;");
        }
        if (strChar.contains("é")) {
            strChar = strChar.replace("é", "&eacute;");
        }
        if (strChar.contains("í")) {
            strChar = strChar.replace("í", "&iacute;");
        }
        if (strChar.contains("ó")) {
            strChar = strChar.replace("ó", "&oacute;");
        }
        if (strChar.contains("ú")) {
            strChar = strChar.replace("ú", "&uacute;");
        }
        if (strChar.contains("Á")) {
            strChar = strChar.replace("Á", "&Aacute;");
        }
        if (strChar.contains("É")) {
            strChar = strChar.replace("É", "&Eacute;");
        }
        if (strChar.contains("Í")) {
            strChar = strChar.replace("Í", "&Iacute;");
        }
        if (strChar.contains("Ó")) {
            strChar = strChar.replace("Ó", "&Oacute;");
        }
        if (strChar.contains("Ú")) {
            strChar = strChar.replace("Ú", "&Uacute;");
        }
        return strChar;
    }

%>