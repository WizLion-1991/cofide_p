<%-- 
    Document   : ERP_CalculoAnualISR
    Created on : Jul 28, 2015, 12:27:26 PM
    Author     : CasaJosefa
--%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.nominas.CalculoAnualISR"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%

    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

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

        //Si la peticion no fue nula proseguimos
        String strPathBaseimg = this.getServletContext().getRealPath("/");
        String strSeparatorimg = System.getProperty("file.separator");
        if (strSeparatorimg.equals("\\")) {
            strSeparatorimg = "/";
            strPathBaseimg = strPathBaseimg.replace("\\", "/");
        }

        //Si la peticion no fue nula proseguimos
        if (!strid.equals(null)) {

            if (strid.equals("1")) {

                String strAnio = request.getParameter("intAnio");
                String strTipoNomina = request.getParameter("intTipoNomina");

                CalculoAnualISR ca = new CalculoAnualISR(oConn, varSesiones, strAnio, strTipoNomina);
                ca.CalculoISR();

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(ca.GeneraXmlISR());//Pintamos el resultado
            }

            if (strid.equals("2")) {

                int idArr = Integer.parseInt(request.getParameter("intlenghtArr"));
                String strIdMaster = request.getParameter("intIdMaster");

                for (int i = 0; i < idArr; i++) {
                    String TOTAL_REMUN = request.getParameter("TOTAL_REMUN" + i);
                    String TOTAL_PRC_EX = request.getParameter("TOTAL_PRC_EX" + i);
                    String TOTAL_PRC_GRAV = request.getParameter("TOTAL_PRC_GRAV" + i);
                    String IMPUESTO_CALC = request.getParameter("IMPUESTO_CALC" + i);
                    String IMPUESTO_RET_AN = request.getParameter("IMPUESTO_RET_AN" + i);
                    String DIFERENCIA = request.getParameter("DIFERENCIA" + i);
                    String IdEmpleado = request.getParameter("IdEmpleado" + i);
                    String NombreEmpleado = request.getParameter("NombreEmpleado" + i);

                    String strSql = "insert into rhh_anual_isr_deta ( AND_ISR_TOTAL_REMUN, AND_ISR_DIFERENCIA, AN_ISR_ID, AND_ISR_IMPUESTO_RET_AN, AND_ISR_IMPUESTO_CALC, AND_ISR_TOTAL_PRC_GRAV, AND_ISR_TOTAL_PRC_EXC,AND_ISR_EMP_NUM,AND_ISR_EMP_NOMBRE) "
                            + "values ( '" + TOTAL_REMUN + "', '" + DIFERENCIA + "', '" + strIdMaster + "', '" + IMPUESTO_RET_AN + "', '" + IMPUESTO_CALC + "', '" + TOTAL_PRC_GRAV + "', '" + TOTAL_PRC_EX + "', '" + IdEmpleado + "', '" + NombreEmpleado + "')";

                    oConn.runQueryLMD(strSql);
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println("OK");//Pintamos el resultado
            }

            if (strid.equals("3")) {

                String intIdMaster = request.getParameter("intIdMaster");

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<ISR>";

                String strSql = "select * from rhh_anual_isr where AN_ISR_ID = " + intIdMaster;
                ResultSet rs = oConn.runQuery(strSql, true);

                while (rs.next()) {
                    strXML += "<ISR_Master "
                            + " dblTOTAL_REMUN = \"" + rs.getDouble("AN_ISR_TOTAL_REMUN") + "\"  "
                            + " dblTOTAL_PRC_EXC = \"" + rs.getDouble("AN_ISR_TOTAL_PRC_EXC") + "\"  "
                            + " dblTOTAL_PRC_GRAV = \"" + rs.getDouble("AN_ISR_TOTAL_PRC_GRAV") + "\"  "
                            + " dblIMPUESTO_CALC = \"" + rs.getDouble("AN_ISR_IMPUESTO_CALC") + "\"  "
                            + " dblIMPUESTO_RET_AN = \"" + rs.getDouble("AN_ISR_IMPUESTO_RET_AN") + "\"  "
                            + " dblDIFERENCIA = \"" + rs.getDouble("AN_ISR_DIFERENCIA") + "\"  "
                            + " />";
                }
                rs.close();

                String strSql1 = "select * from rhh_anual_isr_deta  where AN_ISR_ID =" + intIdMaster;
                ResultSet rs1 = oConn.runQuery(strSql1, true);

                while (rs1.next()) {
                    strXML += "<ISR_Deta "
                            + " dblTOTAL_REMUND = \"" + rs1.getDouble("AND_ISR_TOTAL_REMUN") + "\"  "
                            + " dblTOTAL_PRC_EXCD = \"" + rs1.getDouble("AND_ISR_TOTAL_PRC_EXC") + "\"  "
                            + " dblTOTAL_PRC_GRAVD = \"" + rs1.getDouble("AND_ISR_TOTAL_PRC_GRAV") + "\"  "
                            + " dblIMPUESTO_CALCD = \"" + rs1.getDouble("AND_ISR_IMPUESTO_CALC") + "\"  "
                            + " dblIMPUESTO_RET_AND = \"" + rs1.getDouble("AND_ISR_IMPUESTO_RET_AN") + "\"  "
                            + " dblDIFERENCIAD = \"" + rs1.getDouble("AND_ISR_DIFERENCIA") + "\"  "
                            + " intIdEmpleado = \"" + rs1.getInt("AND_ISR_EMP_NUM") + "\"  "
                            + " strNombreEmpleado = \"" + rs1.getString("AND_ISR_EMP_NOMBRE") + "\"  "
                            + " />";
                }
                rs1.close();

                strXML += "</ISR>";

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }

            if (strid.equals("4")) {

                int idArr = Integer.parseInt(request.getParameter("intlenghtArr"));
                String strIdMaster = request.getParameter("intIdMaster");

                String strDelete = "DELETE FROM rhh_anual_isr_deta where  AN_ISR_ID = " + strIdMaster + " ";
                oConn.runQueryLMD(strDelete);

                for (int i = 0; i < idArr; i++) {
                    String TOTAL_REMUN = request.getParameter("TOTAL_REMUN" + i);
                    String TOTAL_PRC_EX = request.getParameter("TOTAL_PRC_EX" + i);
                    String TOTAL_PRC_GRAV = request.getParameter("TOTAL_PRC_GRAV" + i);
                    String IMPUESTO_CALC = request.getParameter("IMPUESTO_CALC" + i);
                    String IMPUESTO_RET_AN = request.getParameter("IMPUESTO_RET_AN" + i);
                    String DIFERENCIA = request.getParameter("DIFERENCIA" + i);
                    String IdEmpleado = request.getParameter("IdEmpleado" + i);
                    String NombreEmpleado = request.getParameter("NombreEmpleado" + i);

                    String strSql = "insert into rhh_anual_isr_deta ( AND_ISR_TOTAL_REMUN, AND_ISR_DIFERENCIA, AN_ISR_ID, AND_ISR_IMPUESTO_RET_AN, AND_ISR_IMPUESTO_CALC, AND_ISR_TOTAL_PRC_GRAV, AND_ISR_TOTAL_PRC_EXC,AND_ISR_EMP_NUM,AND_ISR_EMP_NOMBRE) "
                            + "values ( '" + TOTAL_REMUN + "', '" + DIFERENCIA + "', '" + strIdMaster + "', '" + IMPUESTO_RET_AN + "', '" + IMPUESTO_CALC + "', '" + TOTAL_PRC_GRAV + "', '" + TOTAL_PRC_EX + "', '" + IdEmpleado + "', '" + NombreEmpleado + "')";

                    oConn.runQueryLMD(strSql);
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println("OK");//Pintamos el resultado
            }

            if (strid.equals("5")) {

                String strboton_1 = request.getParameter("boton_1");
                String strAnio = request.getParameter("intAnio");
                String strTipoNomina = request.getParameter("intTipoNomina");

                ServletOutputStream outputstream = response.getOutputStream();
                final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                String strTargetFileName = "rep_calcAnu_ISR" + ".pdf";
                String strPathBase = this.getServletContext().getRealPath("/");
                String strSeparator = System.getProperty("file.separator");
                String strReportFile = "rep_calcAnu_ISR.jrxml";
                String strReportPath = strPathBase + "/WEB-INF"
                        + strSeparator + "jreports"
                        + strSeparator + strReportFile;

                CalculoAnualISR ci = new CalculoAnualISR(oConn, varSesiones, strAnio, strTipoNomina);

                ci.GeneraBach();
                out.clearBuffer();//Limpiamos buffer
                //XLS
                if (strboton_1.equals("XLS")) {
                    strTargetFileName = strReportFile.replace(".jrxml", ".xls");
                    ci.RepContrato_getReportPrintBach(strReportPath, strTargetFileName, varSesiones, byteArrayOutputStream, 2, strAnio);
                    response.setContentType("application/vnd.ms-excel");
                    //Limpiamos cache y nombre del archivo
                    response.setHeader("Cache-Control", "max-age=0");
                    response.setHeader("Content-Disposition", "attachment; filename=" + strTargetFileName);
                    outputstream.write(byteArrayOutputStream.toByteArray());
                }
                // clear the output stream.
                outputstream.flush();
                outputstream.close();
            }
        }
    } else {
        out.println("Sin acceso");
    }
    oConn.close();


%>