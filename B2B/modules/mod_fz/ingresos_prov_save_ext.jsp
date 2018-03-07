<%-- 
    Document   : ingresos_save_ext
Este jsp se encarga de guardar un nuevo cliente
    Created on : 18-abr-2013, 0:13:44
    Author     : aleph_79
--%>

<%@page import="Tablas.vta_cliente_dir_entrega"%>
<%@page import="Tablas.vta_pedidosdeta"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="ERP.Impuestos"%>
<%@page import="ERP.Ticket"%>
<%@page import="nl.captcha.Captcha"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.DigitoVerificador"%>
<%@page import="comSIWeb.Utilerias.generateData"%>
<%@page import="java.util.Random"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio

    if (1 == 1 /*varSesiones.getIntNoUser() != 0*/) {
        //Para manejo de fechas
        Fechas fecha = new Fechas();
        Periodos periodo = new Periodos();

        //Recuperamos todos los valores
        Conexion oConn2 = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn2.open();
        /*String MySQL ="Select CC1_ID From vta_cliecat1 Where CC1_DESCRIPCION = '"+strTIngreso+"'";
         ResultSet rs10 = oConn2.runQuery(MySQL);
         while (rs10.next()) {
         strTIngreso = rs10.getString("CC1_ID");            
         }
         rs10.close();
         */

        String strRazonSocial = request.getParameter("razonSocial");
        String strrfc = request.getParameter("rfc");
        String strcalle = request.getParameter("calle");
        String strnumero = request.getParameter("numero");
        String strnumeroInterno = request.getParameter("numeroInterno");
        String strcolonia = request.getParameter("colonia");
        String strmunicipio = request.getParameter("municipio");
        String strpais = request.getParameter("pais");
        String strestado = request.getParameter("estado");
        String strcp = request.getParameter("cp");
        String strtelefono1 = request.getParameter("telefono1");
        String strEmail1 = request.getParameter("email1");
        String strcontacto = request.getParameter("contacto");
        String strtelefono2 = request.getParameter("telefono2");
        String strEmail2 = request.getParameter("email2");
        String strtexto = request.getParameter("texto");
        String strAnswer = request.getParameter("answer");
        String strNumeroCuentaBanc = request.getParameter("cuenbanc");


        
                      
        int intIdPais = 0;
        String strSql = "select PA_ID from paises where PA_NOMBRE = '" + strpais + "' ;";
        try {
            ResultSet rs2 = oConn2.runQuery(strSql, true);
            while (rs2.next()) {
                intIdPais = rs2.getInt("PA_ID");
            }
            rs2.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }

        
        String strResult = "";
        int intDigito = 0;
        String strKey = "";
        int intPr_Id = 0;
        String strDescripcion = "";
        double dblPrecio = 0;
        double dblPuntos = 0;
        double dblNegocio = 0;
        String strRegimenFiscal = "";
        String strCodigo = "";
        int intExento1 = 0;
        int intExento2 = 0;
        int intExento3 = 0;
        int intUnidadMedida = 0;
        String strUnidadMedida = "";
        //Validamos el captcha
        Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
        if (captcha.isCorrect(strAnswer)) {
            //Abrimos la conexion
            Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
            oConn.open();

            //Llamamos objeto para guardar los datos de la tabla
            CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
            objTabla.Init("PROVEEDOR", true, true, false, oConn);
            objTabla.setBolGetAutonumeric(true);
            out.clearBuffer();//Limpiamos buffer
            //atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML7
            //objTabla.ObtenParams(true, true, false, false, request, oConn);
            objTabla.setFieldInt("EMP_ID", 1);
            objTabla.setFieldInt("SC_ID", 1);
            objTabla.setFieldString("PV_RAZONSOCIAL", strRazonSocial);
            objTabla.setFieldString("PV_RFC", strrfc);
            objTabla.setFieldString("PV_CALLE", strcalle);
            objTabla.setFieldString("PV_NUMERO", strnumero);
            objTabla.setFieldString("PV_NUMINT", strnumeroInterno);
            objTabla.setFieldString("PV_COLONIA", strcolonia);
            objTabla.setFieldString("PV_MUNICIPIO", strmunicipio);
            objTabla.setFieldInt("PA_ID", intIdPais);
            objTabla.setFieldString("PV_ESTADO", strestado);
            objTabla.setFieldString("PV_CP", strcp);
            objTabla.setFieldString("PV_TELEFONO1", strtelefono1);
            objTabla.setFieldString("PV_EMAIL1", strEmail1);
            objTabla.setFieldString("PV_CONTACTO1", strcontacto);
            objTabla.setFieldString("PV_TELEFONO2", strtelefono2);
            objTabla.setFieldString("PV_EMAIL2", strEmail2);
            objTabla.setFieldString("PV_NOTAS", strtexto);
            objTabla.setFieldString("PV_BCO_CTA_BNCA", strNumeroCuentaBanc);
            

            /**
             * Generamos un password aleatorio
             */
            objTabla.setFieldString("PV_PASSWORD", generateData.getPassword(12));

            //Generamos una alta
            strResult = objTabla.Agrega(oConn);
            strKey = objTabla.getValorKey();

            int idCt = 0;
            if (!strKey.equals("") || strKey != null) {
                idCt = Integer.parseInt(strKey);
            }
            String strResEntrega = "OK";

            if (strResEntrega.equals("OK")) {

                int intNvoKey = 0;
                try {
                    intNvoKey = Integer.valueOf(strKey);
                } catch (NumberFormatException ex) {
                }
                String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
                if (strfolio_GLOBAL == null) {
                    strfolio_GLOBAL = "SI";
                }

                String strSqlUsuarios = "";
                //validamos que hallan puesto el mail
                Mail mail = new Mail();
                if (!strEmail1.isEmpty() || !strEmail2.isEmpty()) {
                    String strLstMail = "";
                    String strLstMailAdmin = "";
                    //Validamos si el mail del cliente es valido
                    if (mail.isEmail(strEmail1)) {
                        strLstMail += "," + strEmail1;
                    }
                    if (mail.isEmail(strEmail2)) {
                        strLstMail += "," + strEmail2;
                    }

                    strSqlUsuarios = "SELECT EMAIL FROM usuarios WHERE BOL_MAIL_PROVEEDORES=1";
                    try {
                        ResultSet rs = oConn.runQuery(strSqlUsuarios);

                        while (rs.next()) {
                            if (!rs.getString("EMAIL").equals("")) {
                                if (strLstMailAdmin.isEmpty()) {
                                    strLstMailAdmin += rs.getString("EMAIL");
                                } else {
                                    strLstMailAdmin += "," + rs.getString("EMAIL");
                                }

                            }
                        }

                        rs.close();
                    } catch (SQLException ex) {
                        //this.strResultLast = "ERROR:" + ex.getMessage();
                        ex.fillInStackTrace();
                    }
                    //Intentamos mandar el mail
                    mail.setBolDepuracion(false);
                    mail.getTemplate("MSG_ING_PROV", oConn);
                    mail.getMensaje();
                    String strSqlEmp = "select PV_RAZONSOCIAL,PV_ID,PV_PASSWORD,PV_CONTACTO1 from vta_proveedor where PV_ID =" + intNvoKey + "";
                    try {
                       ResultSet rs = oConn.runQuery(strSqlEmp);
                        mail.setReplaceContent(rs);
                        rs.close();
                    } catch (SQLException ex) {
                        //this.strResultLast = "ERROR:" + ex.getMessage();
                        ex.fillInStackTrace();
                    }
                    mail.setDestino(strLstMail);
                    boolean bol = mail.sendMail();
                    if (bol) {
                        //strResp = "MAIL ENVIADO.";
                    } else {
                        //strResp = "FALLO EL ENVIO DEL MAIL.";
                    }
                    //Envio administracion
                    if (!strLstMailAdmin.isEmpty()) {
                        System.out.println("Envio administrador...");
                        mail.setDestino(strLstMailAdmin);
                        bol = mail.sendMail();
                        if (bol) {
                            //System.out.println("MAIL ENVIADO.");
                        } else {
                            //System.out.println("FALLO EL ENVIO DEL MAIL.");
                        }
                    }

                } else {
                    //strResp = "ERROR: INGRESE UN MAIL";
                }

                GeneraMailNuevoProveedor(oConn, varSesiones, Integer.valueOf(objTabla.getValorKey()));
            }
            oConn.close();
        } else {
            strResult = "ERROR:El texto de la imagen no coincide";
        }
        //Validamos si fue exitoso
        if (strResult.equals("OK")) {

%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Se ha registrado el nuevo proveedor con el siguiente numero:</br> <%=strKey%> </h3>

</div>
<%
} else {
%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Error al registrar el nuevo proveedor  , mensaje de error <%=strResult%> </h3>
    <input type="button" name="back" value="Regresar" class="btn btn-primary btn" onClick="window.history.back()"/>
</div>
<%
        }

    }

%>

<%!
    public String GeneraMailNuevoProveedor(Conexion oConn, VariableSession varSesiones, int intNvoKey) {
        String strRes = "";
        String strEmail1 = "";
        String strEmail2 = "";

        //Buscamos los datos del sponzor
        String strSqlUsuarios = "select PV_EMAIL1,PV_EMAIL2 from vta_proveedor where PV_ID = " + intNvoKey;
        try {
            ResultSet rs = oConn.runQuery(strSqlUsuarios);

            while (rs.next()) {

                strEmail1 = rs.getString("PV_EMAIL1");
                strEmail2 = rs.getString("PV_EMAIL2");
            }

            rs.close();
        } catch (SQLException ex) {
            System.out.println("ERROR:" + ex.getMessage());

        }

        //validamos que hallan puesto el mail
        Mail mail = new Mail();
        if (!strEmail1.isEmpty() || !strEmail2.isEmpty()) {
            String strLstMail = "";
            //Validamos si el mail del cliente es valido
            if (mail.isEmail(strEmail1)) {
                strLstMail += "," + strEmail1;
            }
            if (mail.isEmail(strEmail2)) {
                strLstMail += "," + strEmail2;
            }

            //Intentamos mandar el mail
            mail.setBolDepuracion(true);
            mail.getTemplate("MSG_ING_PROV", oConn);
            mail.getMensaje();
            String strSqlEmp = "select PV_RAZONSOCIAL,PV_ID,PV_PASSWORD,PV_CONTACTO1 from vta_proveedor where PV_ID =" + intNvoKey + "";
            try {
                ResultSet rs = oConn.runQuery(strSqlEmp);
                mail.setReplaceContent(rs);
                rs.close();
            } catch (SQLException ex) {
                //this.strResultLast = "ERROR:" + ex.getMessage();
                ex.fillInStackTrace();
            }
            mail.setDestino(strLstMail);
            boolean bol = mail.sendMail();
            if (bol) {
                //System.out.println("MAIL ENVIADO.");
            } else {
                //System.out.println("FALLO EL ENVIO DEL MAIL.") ;
            }

        } else {
            //strResp = "ERROR: INGRESE UN MAIL";
        }
        return strRes;
    }

%>