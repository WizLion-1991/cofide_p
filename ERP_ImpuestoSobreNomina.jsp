<%-- 
    Document   : ERP_ImpuestoSobreNomina
    Created on : Jul 17, 2015, 11:47:48 AM
    Author     : CasaJosefa
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.erp.reportes.RepoPreNomina"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="com.sun.xml.rpc.processor.modeler.j2ee.xml.string"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
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
                String strFecha_Ini = fecha.FormateaBD(request.getParameter("intFechaIni"), "/");
                String strFecha_Fin = fecha.FormateaBD(request.getParameter("intFechaFin"), "/");

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<nominas>";
                //Consultamos la info

                String strDescripcion = "";
                String strFechaIni = "";
                String strFechaFin = "";
                int intNominaId = 0;

                String strSql = "select RHN_ID,RHN_DESCRIPCION,RHN_FECHA_INICIAL,RHN_FECHA_FINAL from rhh_nominas_master where RHN_FECHA_INICIAL >= " + strFecha_Ini + " and RHN_FECHA_FINAL <= " + strFecha_Fin;
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {

                    strDescripcion = rs.getString("RHN_DESCRIPCION");
                    strFechaIni = rs.getString("RHN_FECHA_INICIAL");
                    strFechaFin = rs.getString("RHN_FECHA_FINAL");
                    intNominaId = rs.getInt("RHN_ID");

                    strXML += "<nominas_deta "
                            + " strDescripcion = \"" + strDescripcion + "\"  "
                            + " strFechaIni = \"" + fecha.FormateaDDMMAAAA(strFechaIni, "/") + "\"  "
                            + " strFechaFin = \"" + fecha.FormateaDDMMAAAA(strFechaFin, "/") + "\"  "
                            + " intNominaId = \"" + intNominaId + "\"  "
                            + " />";
                }
                rs.close();
                //El detalle

                strXML += "</nominas>";
                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado

            }

            if (strid.equals("2")) {

                int idArr = Integer.parseInt(request.getParameter("intlenghtArr"));
                int intSucId = Integer.parseInt(request.getParameter("intSucId"));

                String strIdsNom = "";
                int intNumeroEmpleados = 0;
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<ImpuestoSobreNomina>");

                for (int i = 0; i < idArr; i++) {

                    /*Obtenemos los id de las nominas*/
                    strIdsNom += request.getParameter("intNominaId" + i) + ",";
                }

                String strIdsNom1 = strIdsNom.substring(0, strIdsNom.length() - 1);

                try {
                    //Busca la lista de proveedores
                    String strSql = "SELECT COUNT(DISTINCT EMP_NUM) AS cantidad FROM rhh_nominas_master,rhh_nominas "
                            + " where rhh_nominas_master.RHN_ID = rhh_nominas.RHN_ID "
                            + " and rhh_nominas_master.RHN_ID in(" + strIdsNom1 + ");";
                    ResultSet rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {

                        intNumeroEmpleados = rs.getInt("cantidad");

                    }
                    rs.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }

                for (int i = 0; i < idArr; i++) {

                    /*Obtenemos los id de las nominas*/
                    strIdsNom += request.getParameter("intNominaId" + i) + ",";

                    int intIdNomAct = Integer.parseInt(request.getParameter("intNominaId" + i));

                    RepoPreNomina ci = new RepoPreNomina(oConn, varSesiones, intIdNomAct);
                    ci.RepoPreNomina_HacerReporte_ISN();

                    strXML.append(ci.GeneraXml_ImpSobreNomina(intNumeroEmpleados, intSucId));

                }

                strXML.append("</ImpuestoSobreNomina>");

                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado

            }

            if (strid.equals("3")) {

                int intIdPerc = Integer.parseInt(request.getParameter("intIdPerc"));
                int intIdSuc = Integer.parseInt(request.getParameter("intIdSuc"));

                String strSql = "INSERT INTO rhh_percepciones_no_impuesto "
                        + " ( PERNO_IMP_IDPERCEPCION, PERNO_IMP_IDSUCURSAL) values "
                        + " ( '" + intIdPerc + "', '" + intIdSuc + "')";

                oConn.runQueryLMD(strSql);

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<Percepcion>";

                try {
                    //Busca la lista de proveedores
                    String strSql1 = "select * from rhh_percepciones_no_impuesto where PERNO_IMP_IDSUCURSAL = " + intIdSuc;
                    ResultSet rs = oConn.runQuery(strSql1, true);
                    while (rs.next()) {

                        //Busca la lista de proveedores
                        String strSql2 = "select PERC_DESCRIPCION from rhh_percepciones where PERC_ID = " + rs.getString("PERNO_IMP_IDPERCEPCION");
                        ResultSet rs2 = oConn.runQuery(strSql2, true);
                        String strDescripcion = "";
                        while (rs2.next()) {

                            strDescripcion = rs2.getString("PERC_DESCRIPCION");

                        }
                        rs2.close();

                        strXML += "<Percepcion_deta "
                                + " strDescripcion = \"" + strDescripcion + "\"  "
                                + " strIdPerc = \"" + rs.getString("PERNO_IMP_IDPERCEPCION") + "\"  "
                                + " strIdSuc = \"" + rs.getString("PERNO_IMP_IDSUCURSAL") + "\"  "
                                + " />";

                    }
                    rs.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXML += "</Percepcion>";
                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }

            if (strid.equals("4")) {

                int intIdSuc = Integer.parseInt(request.getParameter("intIdSuc"));

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<Percepcion>";

                try {
                    //Busca la lista de proveedores
                    String strSql1 = "select * from rhh_percepciones_no_impuesto where PERNO_IMP_IDSUCURSAL = " + intIdSuc;
                    ResultSet rs = oConn.runQuery(strSql1, true);
                    while (rs.next()) {

                        //Busca la lista de proveedores
                        String strSql2 = "select PERC_DESCRIPCION from rhh_percepciones where PERC_ID = " + rs.getString("PERNO_IMP_IDPERCEPCION");
                        ResultSet rs2 = oConn.runQuery(strSql2, true);
                        String strDescripcion = "";
                        while (rs2.next()) {

                            strDescripcion = rs2.getString("PERC_DESCRIPCION");

                        }
                        rs2.close();

                        strXML += "<Percepcion_deta "
                                + " strDescripcion = \"" + strDescripcion + "\"  "
                                + " strIdPerc = \"" + rs.getString("PERNO_IMP_IDPERCEPCION") + "\"  "
                                + " strIdSuc = \"" + rs.getString("PERNO_IMP_IDSUCURSAL") + "\"  "
                                + " />";

                    }
                    rs.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXML += "</Percepcion>";
                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }

            if (strid.equals("5")) {

                String intIdPerc = request.getParameter("intIdPerc");
                String intIdSuc = request.getParameter("intIdSuc");

                String strDelete = "DELETE FROM rhh_percepciones_no_impuesto where PERNO_IMP_IDPERCEPCION =" + intIdPerc + " "
                        + "and PERNO_IMP_IDSUCURSAL = " + intIdSuc;
                oConn.runQueryLMD(strDelete);

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<Percepcion>";

                try {
                    //Busca la lista de proveedores
                    String strSql1 = "select * from rhh_percepciones_no_impuesto where PERNO_IMP_IDSUCURSAL = " + intIdSuc;
                    ResultSet rs = oConn.runQuery(strSql1, true);
                    while (rs.next()) {

                        //Busca la lista de proveedores
                        String strSql2 = "select PERC_DESCRIPCION from rhh_percepciones where PERC_ID = " + rs.getString("PERNO_IMP_IDPERCEPCION");
                        ResultSet rs2 = oConn.runQuery(strSql2, true);
                        String strDescripcion = "";
                        while (rs2.next()) {

                            strDescripcion = rs2.getString("PERC_DESCRIPCION");

                        }
                        rs2.close();

                        strXML += "<Percepcion_deta "
                                + " strDescripcion = \"" + strDescripcion + "\"  "
                                + " strIdPerc = \"" + rs.getString("PERNO_IMP_IDPERCEPCION") + "\"  "
                                + " strIdSuc = \"" + rs.getString("PERNO_IMP_IDSUCURSAL") + "\"  "
                                + " />";

                    }
                    rs.close();
                } catch (SQLException ex) {
                    ex.fillInStackTrace();
                }
                strXML += "</Percepcion>";
                //Mostramos el resultado
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado

            }
        }
    } else {
        out.println("Sin acceso");
    }
    oConn.close();


%>