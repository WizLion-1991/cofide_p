<%-- 
    Document   : COFIDE_Historial
    Created on : 14-ene-2016, 13:45:18
    Author     : juliocesar
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.sun.tools.xjc.api.S2JJAXBModel"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    Fechas fec = new Fechas();
    ResultSet rs;
    String strSql = "";
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        /*Definimos parametros de la aplicacion*/
        String strid = request.getParameter("ID");
        if (strid == null) {
            strid = "0";
        }
        if (strid.equals("1")) { //historial de llamadas
            UtilXml utilXML = new UtilXml();
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta>";
            String strNCliente = request.getParameter("CT_NO_CLIENTE");
            int intCL_ID = 0;
            String strCL_FECHA = "";
            String strCL_HORA = "";
            String strCL_USUARIO = "";
            int intID_CLIENTE = 0;
            int intID_BASE = 0;
            int intCL_EXITOSO = 0;
            int intCL_DESCARTADO = 0;
            String strCL_COMENTARIO = "";
            String strCL_CONTACTO = "";
            strSql = "select CL_FECHA, CL_HORA,CL_ID,cofide_llamada.CL_ID_CLIENTE,CL_ID_BASE,CL_EXITOSO,CL_DESCARTADO, CL_COMENTARIO, " //toma los registros de ese agente y el cliente
                    + "(select CT_RAZONSOCIAL from vta_cliente where vta_cliente.CT_ID = cofide_llamada.CL_ID_CLIENTE) as CL_CLIENTE, "
                    + "(select user from usuarios where usuarios.id_usuarios = cofide_llamada.CL_USUARIO ) as CL_AGENTE, CL_CONTACTO "
                    + "from cofide_llamada where CL_ID_CLIENTE = " + strNCliente;
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                intCL_ID = rs.getInt("CL_ID");
                strCL_FECHA = rs.getString("CL_FECHA");
                strCL_HORA = rs.getString("CL_HORA");
                strCL_USUARIO = rs.getString("CL_AGENTE");
                intID_CLIENTE = rs.getInt("CL_ID_CLIENTE");
                strCL_COMENTARIO = rs.getString("CL_COMENTARIO");
                strCL_CONTACTO = rs.getString("CL_CONTACTO");
                intID_BASE = rs.getInt("CL_ID_BASE");
                intCL_EXITOSO = rs.getInt("CL_EXITOSO");
                intCL_DESCARTADO = rs.getInt("CL_DESCARTADO");
                strXML += "<datos "
                        + " CL_ID = \"" + intCL_ID + "\"  "
                        + " CL_FECHA = \"" + strCL_FECHA + "\"  "
                        + " CL_HORA = \"" + strCL_HORA + "\" "
                        + " CL_USUARIO = \"" + strCL_USUARIO + "\" "
                        + " CL_ID_CLIENTE = \"" + intID_CLIENTE + "\" "
                        + " CL_COMENTARIO = \"" + strCL_COMENTARIO + "\" "
                        + " CL_CONTACTO = \"" + strCL_CONTACTO + "\" "
                        + " CL_ID_BASE = \"" + intID_BASE + "\" "
                        + " CL_EXITOSO = \"" + intCL_EXITOSO + "\" "
                        + " CL_DESCARTADO = \"" + intCL_DESCARTADO + "\" "
                        + " />";
            } //fin del while
            strXML += "</vta>";
            strXML.toString();
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
        } //fin del caso

        //historial de ventas
        if (strid.equals("2")) {

            String strFecInicial = request.getParameter("strFechaInicial");
            String strFecFinal = request.getParameter("strFechaFinal");
            String strFiltro = request.getParameter("filtro");
            String strBusqueda = request.getParameter("busqueda");

            String strRazonSocial = "";
            String strFac_tkt = " and FAC_ID = " + strBusqueda; //si es por busqueda
            String strIDCurso = " and CC_CURSO_ID = " + strBusqueda;
            String strStat = " and FAC_PAGADO = " + strBusqueda;

            strFecInicial = fec.FormateaBD(strFecInicial, "/");
            strFecFinal = fec.FormateaBD(strFecFinal, "/");

            strSql = "select *, "
                    + "(select vta_cliente.CT_RAZONSOCIAL from vta_cliente where vta_cliente.CT_ID = view_ventasglobales.CT_ID) as RAZONSOCIAL,"
                    + "(select usuarios.user from usuarios where usuarios.id_usuarios = view_ventasglobales.FAC_US_ALTA) as AGENTE "
                    + "from view_ventasglobales where FAC_FECHA >= '" + strFecInicial + "'  and FAC_FECHA <= '" + strFecFinal + "'";

            if (!strBusqueda.equals("")) {
                if (strFiltro.equals("2")) {
                    strSql += strFac_tkt;
                }
                if (strFiltro.equals("3")) {
                    strSql += strFac_tkt;
                }
                if (strFiltro.equals("4")) {
                    strSql += strStat;
                }
                if (strFiltro.equals("5")) {
                    strSql += strIDCurso;
                }
            }

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<Ventas>";
            rs = oConn.runQuery(strSql, true);
            int intCont = 1;
            while (rs.next()) {
                if (rs.getString("TIPO_DOC").equals("T")) {
                    strXML += "<datos "
                            + " CONTADOR = \"" + intCont + "\"  "
                            + " FAC_ID = \"" + rs.getString("FAC_ID") + "\"  "
                            + " FAC_FECHA = \"" + fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA"), "/") + "\"  "
                            + " FAC_TOTAL = \"" + rs.getDouble("FAC_TOTAL") + "\" "
                            + " RAZONSOCIAL = \"" + rs.getString("RAZONSOCIAL") + "\" "
                            + " FAC_FOLIO = \"" + rs.getString("FAC_FOLIO") + "\" "
                            + " AGENTE = \"" + rs.getString("AGENTE") + "\" "
                            + " FAC_METODODEPAGO = \"" + rs.getString("FAC_METODODEPAGO") + "\" "
                            + " FAC_HORA = \"" + rs.getString("FAC_HORA") + "\" "
                            + " FAC_IMPORTE = \"" + rs.getDouble("FAC_IMPORTE") + "\" "
                            + " CT_ID = \"" + rs.getString("CT_ID") + "\" "
                            + " SC_ID = \"" + rs.getString("SC_ID") + "\" "
                            + " DOC_TIPO = \"0\"  "
                            + " FAC_PAGADO = \"" + rs.getString("FAC_PAGADO") + "\" "
                            + " FAC_ANULADA = \"" + rs.getString("FAC_ANULADA") + "\" "
                            + " />";
                } else {
                    strXML += "<datos "
                            + " CONTADOR = \"" + intCont + "\"  "
                            + " FAC_ID = \"" + rs.getString("FAC_ID") + "\"  "
                            + " FAC_FECHA = \"" + fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA"), "/") + "\"  "
                            + " FAC_TOTAL = \"" + rs.getDouble("FAC_TOTAL") + "\" "
                            + " RAZONSOCIAL = \"" + rs.getString("RAZONSOCIAL") + "\" "
                            + " FAC_FOLIO = \"0\"  "
                            + " AGENTE = \"" + rs.getString("AGENTE") + "\" "
                            + " FAC_METODODEPAGO = \"" + rs.getString("FAC_METODODEPAGO") + "\" "
                            + " FAC_HORA = \"" + rs.getString("FAC_HORA") + "\" "
                            + " FAC_IMPORTE = \"" + rs.getDouble("FAC_IMPORTE") + "\" "
                            + " CT_ID = \"" + rs.getString("CT_ID") + "\" "
                            + " SC_ID = \"" + rs.getString("SC_ID") + "\" "
                            + " DOC_TIPO = \"1\"  "
                            + " FAC_PAGADO = \"" + rs.getString("FAC_PAGADO") + "\" "
                            + " FAC_ANULADA = \"" + rs.getString("FAC_ANULADA") + "\" "
                            + " />";
                }

                intCont = intCont + 1;
            } //fin del while
            strXML += "</Ventas>";

            strXML.toString();
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado

        } //fin del caso
        //historial de ventas por cte
        if (strid.equals("3")) {
            // int intCT_ID = varSesiones.getIntNoUser();
            int intCT_ID = Integer.parseInt(request.getParameter("intCTE"));
            strSql = "select *,"
                    + "(select vta_cliente.CT_RAZONSOCIAL from vta_cliente where vta_cliente.CT_ID = view_ventasglobales.CT_ID) as RAZONSOCIAL,"
                    + "(select usuarios.user from usuarios where usuarios.id_usuarios = view_ventasglobales.FAC_US_ALTA) as AGENTE "
                    + "from view_ventasglobales where CT_ID = " + intCT_ID + " order by FAC_FECHA desc";

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<Ventas>";
            rs = oConn.runQuery(strSql, true);
            int intCont = 1;
            while (rs.next()) {
                if (rs.getString("TIPO_DOC").equals("T")) {
                    strXML += "<datos "
                            + " CONTADOR = \"" + intCont + "\"  "
                            + " FAC_ID = \"" + rs.getString("FAC_ID") + "\"  "
                            + " FAC_FECHA = \"" + fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA"), "/") + "\"  "
                            + " FAC_TOTAL = \"" + rs.getDouble("FAC_TOTAL") + "\" "
                            + " RAZONSOCIAL = \"" + rs.getString("RAZONSOCIAL") + "\" "
                            + " FAC_FOLIO = \"" + rs.getString("FAC_FOLIO") + "\" "
                            + " AGENTE = \"" + rs.getString("AGENTE") + "\" "
                            + " FAC_METODODEPAGO = \"" + rs.getString("FAC_METODODEPAGO") + "\" "
                            + " FAC_HORA = \"" + rs.getString("FAC_HORA") + "\" "
                            + " FAC_IMPORTE = \"" + rs.getDouble("FAC_IMPORTE") + "\" "
                            + " CT_ID = \"" + rs.getString("CT_ID") + "\" "
                            + " SC_ID = \"" + rs.getString("SC_ID") + "\" "
                            + " DOC_TIPO = \"0\"  "
                            + " FAC_PAGADO = \"" + rs.getString("FAC_PAGADO") + "\" "
                            + " FAC_ANULADA = \"" + rs.getString("FAC_ANULADA") + "\" "
                            + " />";
                } else {
                    strXML += "<datos "
                            + " CONTADOR = \"" + intCont + "\"  "
                            + " FAC_ID = \"" + rs.getString("FAC_ID") + "\"  "
                            + " FAC_FECHA = \"" + fec.FormateaDDMMAAAA(rs.getString("FAC_FECHA"), "/") + "\"  "
                            + " FAC_TOTAL = \"" + rs.getDouble("FAC_TOTAL") + "\" "
                            + " RAZONSOCIAL = \"" + rs.getString("RAZONSOCIAL") + "\" "
                            + " FAC_FOLIO = \"0\"  "
                            + " AGENTE = \"" + rs.getString("AGENTE") + "\" "
                            + " FAC_METODODEPAGO = \"" + rs.getString("FAC_METODODEPAGO") + "\" "
                            + " FAC_HORA = \"" + rs.getString("FAC_HORA") + "\" "
                            + " FAC_IMPORTE = \"" + rs.getDouble("FAC_IMPORTE") + "\" "
                            + " CT_ID = \"" + rs.getString("CT_ID") + "\" "
                            + " SC_ID = \"" + rs.getString("SC_ID") + "\" "
                            + " DOC_TIPO = \"1\"  "
                            + " FAC_PAGADO = \"" + rs.getString("FAC_PAGADO") + "\" "
                            + " FAC_ANULADA = \"" + rs.getString("FAC_ANULADA") + "\" "
                            + " />";
                }
                intCont = intCont + 1;
            } //fin del while
            strXML += "</Ventas>";

            strXML.toString();
            rs.close();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
        } //3
        if (strid.equals("4")) {
            String strID_Fac_Tkt = request.getParameter("strFac_Tkt");
            String strTipoDoc = request.getParameter("strTipoDoc");
            String strCurso = "";
            String strFechaCurso = "";
            String strLimite = "";
            String strOcupado = "";
            String strCosto = "";
            if (strTipoDoc.equals("FAC")) {
                strSql = "select *,"
                        + "(select FACD_PORDESC FROM vta_facturasdeta where FAC_ID = vta_facturas.FAC_ID) as PORDESC,"
                        + "if((select CP_MATERIAL_IMPRESO from cofide_participantes where CP_FAC_ID = FAC_ID limit 1) = 1,1,0) as REQ_MATERIAL "
                        + "from vta_facturas where FAC_ID = " + strID_Fac_Tkt;
            }
            if (strTipoDoc.equals("TKT")) {
                strSql = "select *,"
                        + "(select TKTD_PORDESC FROM vta_ticketsdeta where TKT_ID = vta_tickets.TKT_ID) as PORDESC,"
                        + "if((select CP_MATERIAL_IMPRESO from cofide_participantes where CP_TKT_ID = TKT_ID limit 1) = 1,1,0) as REQ_MATERIAL "
                        + "from vta_tickets where TKT_ID = " + strID_Fac_Tkt;
            }
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<Ventas>";
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                String strSqlCurso = "select * from cofide_cursos where cc_curso_id = " + rs.getString("CC_CURSO_ID");
                ResultSet rs2 = oConn.runQuery(strSqlCurso, true);
                while (rs2.next()) {
                    strCurso = rs2.getString("CC_NOMBRE_CURSO");
                    strFechaCurso = rs2.getString("CC_FECHA_INICIAL");
                    strLimite = rs2.getString("CC_MONTAJE");
                    strOcupado = rs2.getString("CC_INSCRITOS");
                    strCosto = rs2.getString("CC_PRECIO_UNIT");
                }
                rs2.close();
                if (strTipoDoc.equals("FAC")) {
                    strXML += "<datos "
                            + " FAC_ID = \"" + rs.getString("FAC_ID") + "\"  "
                            + " CURSO = \"" + strCurso + "\"  "
                            + " CURSO_ID = \"" + rs.getString("CC_CURSO_ID") + "\"  "
                            + " CURSO_FECHA = \"" + strFechaCurso + "\"  "
                            + " LIMITE = \"" + strLimite + "\"  "
                            + " OCUPADOS = \"" + strOcupado + "\"  "
                            + " COSTO_UNIT = \"" + strCosto + "\"  "
                            + " COSTO_SUB = \"" + rs.getString("FAC_IMPORTE") + "\"  "
                            + " COSTO_TOT = \"" + rs.getString("FAC_TOTAL") + "\"  "
                            + " IVA = \"" + rs.getString("FAC_IMPUESTO1") + "\"  "
                            + " PORDESC = \"" + rs.getString("PORDESC") + "\"  "
                            + " DESCUENTO = \"" + rs.getString("FAC_DESCUENTO") + "\"  "
                            + " METPAGO = \"" + rs.getString("FAC_METODODEPAGO") + "\"  "
                            + " FECHA_PAGO = \"" + rs.getString("FAC_FECHA") + "\"  "
                            + " MAT_IMP = \"" + rs.getString("REQ_MATERIAL") + "\"  "
                            + " COMENTARIO = \"" + rs.getString("FAC_NOTASPIE") + "\"  "
                            + " />";
                } else {
                    strXML += "<datos "
                            + " FAC_ID = \"" + rs.getString("TKT_ID") + "\"  "
                            + " CURSO = \"" + strCurso + "\"  "
                            + " CURSO_ID = \"" + rs.getString("CC_CURSO_ID") + "\"  "
                            + " CURSO_FECHA = \"" + strFechaCurso + "\"  "
                            + " LIMITE = \"" + strLimite + "\"  "
                            + " OCUPADOS = \"" + strOcupado + "\"  "
                            + " COSTO_UNIT = \"" + strCosto + "\"  "
                            + " COSTO_SUB = \"" + rs.getString("TKT_IMPORTE") + "\"  "
                            + " COSTO_TOT = \"" + rs.getString("TKT_TOTAL") + "\"  "
                            + " IVA = \"" + rs.getString("TKT_IMPUESTO1") + "\"  "
                            + " DESCUENTO = \"" + rs.getString("TKT_DESCUENTO") + "\"  "
                            + " PORDESC = \"" + rs.getString("PORDESC") + "\"  "
                            + " METPAGO = \"" + rs.getString("TKT_METODODEPAGO") + "\"  "
                            + " FECHA_PAGO = \"" + rs.getString("TKT_FECHA") + "\"  "
                            + " MAT_IMP = \"" + rs.getString("REQ_MATERIAL") + "\"  "
                            + " COMENTARIO = \"" + rs.getString("TKT_NOTASPIE") + "\"  "
                            + " />";
                }

            }
            strXML += "</Ventas>";
            rs.close();
            strXML.toString();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
        } //4
        if (strid.equals("5")) { //monitoreo a los agentes
            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
            strXML.append("<vta>");
            //String strIdCTE = request.getParameter("CT_ID");
            String strID_FAC_TKT = request.getParameter("strFac_Tkt");
            String strTipoDoc = request.getParameter("strTipoDoc");
            String strCCO_ID = "";
            String strCCO_NOMBRE = "";
            String strCCO_APPAT = "";
            String strCCO_APMAT = "";
            String strCCO_TITULO = "";
            String strCCO_NOSOCIO = "";
            String strCCO_ASOC = "";
            String strCCO_CORREO = "";
            String strSqlCTE = "select * from cofide_participantes where CP_" + strTipoDoc + "_ID =  " + strID_FAC_TKT;
            try {
                ResultSet rsCTE = oConn.runQuery(strSqlCTE, true);
                while (rsCTE.next()) {
                    strCCO_ID = rsCTE.getString("CP_ID");
                    strCCO_NOMBRE = rsCTE.getString("CP_NOMBRE");
                    strCCO_APPAT = rsCTE.getString("CP_APPAT");
                    strCCO_APMAT = rsCTE.getString("CP_APMAT");
                    strCCO_TITULO = rsCTE.getString("CP_TITULO");
                    strCCO_NOSOCIO = rsCTE.getString("CCO_NOSOCIO");
                    strCCO_ASOC = rsCTE.getString("CP_ASCOC");
                    strCCO_CORREO = rsCTE.getString("CP_CORREO");

                    strXML.append("<datos ");
                    strXML.append(" CCO_ID = \"").append(strCCO_ID).append("\"");
                    strXML.append(" CCO_NOMBRE = \"").append(strCCO_NOMBRE).append("\"");
                    strXML.append(" CCO_APPATERNO = \"").append(strCCO_APPAT).append("\"");
                    strXML.append(" CCO_APMATERNO = \"").append(strCCO_APMAT).append("\"");
                    strXML.append(" CCO_TITULO = \"").append(strCCO_TITULO).append("\"");
                    strXML.append(" CCO_NOSOCIO = \"").append(strCCO_NOSOCIO).append("\"");
                    strXML.append(" CCO_ASOCIACION = \"").append(strCCO_ASOC).append("\"");
                    strXML.append(" CCO_CORREO = \"").append(strCCO_CORREO).append("\"");
                    strXML.append(" />");
                }
                rsCTE.close();
            } catch (SQLException e) {
                System.out.println("error " + e);
            }
            strXML.append("</vta>");
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado
        } //5
        if (strid.equals("6")) { //obtenemos datos de facturacion
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta>";
            int intIdCte = 0;
            String strNCliente = "";
            String strNombre = "";
            String strRfc = "";
            String strCalle = "";
            String strColonia = "";
            String strDelegacion = "";
            String strEstado = "";
            String strCP = "";
            String strTelefono = "";
            String strCorreo1 = "";
            String strCorreo2 = "";
            int DFA_ID = 0;
            String strID_FAC_TKT = request.getParameter("strFac_Tkt");
            String strTipoDoc = request.getParameter("strTipoDoc");
            //obtenemos el ID del cte con base al ID de la venta tkt o fac
            if (strTipoDoc.equals("FAC")) {
                strSql = "select CT_ID from vta_facturas where FAC_ID = " + strID_FAC_TKT;
            } else {
                strSql = "select CT_ID from vta_tickets where TKT_ID = " + strID_FAC_TKT;
            }
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                intIdCte = rs.getInt("CT_ID");
            }
            rs.close();
            // obtenemos las razones sociales
            strSql = "select DFA_RAZONSOCIAL, CT_ID, DFA_RFC, DFA_CALLE, DFA_COLONIA, DFA_MUNICIPIO, "
                    + "DFA_ESTADO, DFA_CP, DFA_TELEFONO, DFA_EMAIL, DFA_EMAI2 "
                    + "from vta_cliente_facturacion "
                    + "where CT_ID = " + intIdCte + " "
                    + "group by DFA_RAZONSOCIAL, CT_ID, DFA_RFC, DFA_CALLE, DFA_COLONIA, DFA_MUNICIPIO, "
                    + "DFA_ESTADO, DFA_CP, DFA_TELEFONO, DFA_EMAIL, DFA_EMAI2";
            //String strSql = "select * from vta_cliente_facturacion where CT_ID = " + intIdCte;
            rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
                strNCliente = rs.getString("CT_ID");
                strRfc = rs.getString("DFA_RFC");
                strNombre = rs.getString("DFA_RAZONSOCIAL");
                strCalle = rs.getString("DFA_CALLE");
                strColonia = rs.getString("DFA_COLONIA");
                strDelegacion = rs.getString("DFA_MUNICIPIO");
                strEstado = rs.getString("DFA_ESTADO");
                strCP = rs.getString("DFA_CP");
                strTelefono = rs.getString("DFA_TELEFONO");
                strCorreo1 = rs.getString("DFA_EMAIL");
                strCorreo2 = rs.getString("DFA_EMAI2");
                DFA_ID++;
                strXML += "<datos "
                        //+ " CEV_ID = \"" + rs.getInt("DFA_ID") + "\" "
                        + " CEV_ID = \"" + DFA_ID + "\" "
                        + " CEV_NUMERO = \"" + strNCliente + "\" "
                        + " CEV_RFC = \"" + strRfc + "\" "
                        + " CEV_NOMBRE = \"" + strNombre + "\" "
                        + " CEV_CALLE = \"" + strCalle + "\" "
                        + " CEV_COLONIA = \"" + strColonia + "\" "
                        + " CEV_MUNICIPIO = \"" + strDelegacion + "\" "
                        + " CEV_ESTADO = \"" + strEstado + "\" "
                        + " CEV_CP = \"" + strCP + "\" "
                        + " CEV_TELEFONO = \"" + strTelefono + "\" "
                        + " CEV_EMAIL1 = \"" + strCorreo1 + "\" "
                        + " CEV_EMAIL2 = \"" + strCorreo2 + "\" "
                        + " />";
                System.out.println(strNombre + " " + strRfc);
            }
            rs.close();

            strXML += "</vta>";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
        } //6

    } else {
        out.print("SIN ACCESO");
    }
    oConn.close();
%>
<%!
    public String getTktFolio(String strTKT_ID, Conexion oConn) {
        String strFolio = "";
        String strQuery = "select TKT_FOLIO from vta_tickets where TKT_ID = " + strTKT_ID;
        try {
            ResultSet rs = oConn.runQuery(strQuery);
            while (rs.next()) {
                strFolio = rs.getString("TKT_FOLIO");
            }
        } catch (SQLException ex) {
            ex.fillInStackTrace();
        }
        return strFolio;
    }
%>