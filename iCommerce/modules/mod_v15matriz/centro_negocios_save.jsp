<%-- 
    Document   : centro_negocios_save
    Created on : 16-jul-2015, 12:28:17
    Author     : ZeusGalindo
--%>

<%@page import="com.mx.siweb.mlm.compensacion.wenow.ActivaBinario"%>
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
    if (varSesiones.getIntNoUser() != 0) {
        //Para manejo de fechas
        Fechas fecha = new Fechas();
        Periodos periodo = new Periodos();

        //Recuperamos todos los valores
        Conexion oConn2 = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn2.open();

        String strAnswer = request.getParameter("answer");
        String strCodigo = request.getParameter("mdlgn-codigo_promo");

        String strResult = "";
        int intDigito = 0;
        String strKey = "";
        int intPr_Id = 0;
        String strDescripcion = "";
        double dblPrecio = 0;
        double dblPuntos = 0;
        double dblNegocio = 0;
        String strRegimenFiscal = "";
        int intExento1 = 0;
        int intExento2 = 0;
        int intExento3 = 0;
        int intUnidadMedida = 0;
        String strUnidadMedida = "";

        boolean existsCodigo = false;
        if (strCodigo != "") {
            String strQuery = "select *  from mlm_codigo_promocion where  MCP_ACTIVO = '1' and MCP_USADO = '0'  and MCP_CODIGO_PROMOCION = '" + strCodigo + "' ";
            try {
                ResultSet rs1 = oConn2.runQuery(strQuery);
                while (rs1.next()) {
                    existsCodigo = true;
                }
                rs1.close();
            } catch (SQLException ex) {
                System.out.println(ex.getMessage());
            }

            if (existsCodigo) {
                //Validamos el captcha
                Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
                if (captcha.isCorrect(strAnswer)) {
                    //Abrimos la conexion
                    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
                    oConn.open();

                    String strSql = "update mlm_codigo_promocion set MCP_USADO = 1 where MCP_CODIGO_PROMOCION = '" + strCodigo + "';";
                    oConn.runQueryLMD(strSql);

                    //Validamos que el upline exista
                    boolean bolExiste = false;
                    strSql = "SELECT CT_ID from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
                    ResultSet rs2 = oConn.runQuery(strSql, true);
                    while (rs2.next()) {
                        bolExiste = true;
                    }
                    rs2.close();

                    //Solo si existe el upline
                    if (bolExiste) {

                        //Consultamos datos del cliente 
                        int intSC_ID = 0;
                        int intEMP_ID = 0;
                        int intMON_ID = 0;
                        int intTI_ID = 0;
                        int intSponzor = 0;

                        CIP_Tabla objTablaAct = new CIP_Tabla("", "", "", "", varSesiones);
                        objTablaAct.Init("CLIENTES", true, true, false, oConn);
                        objTablaAct.setBolGetAutonumeric(true);
                        objTablaAct.ObtenDatos(varSesiones.getintIdCliente(), oConn);

                        intSC_ID = objTablaAct.getFieldInt("SC_ID");
                        intSponzor = objTablaAct.getFieldInt("CT_SPONZOR");
                        intEMP_ID = objTablaAct.getFieldInt("EMP_ID");
                        intMON_ID = objTablaAct.getFieldInt("EMP_ID");
                        intTI_ID = objTablaAct.getFieldInt("TI_ID");
                        String strEmail1 = objTablaAct.getFieldString("CT_EMAIL1");
                        String strEmail2 = objTablaAct.getFieldString("CT_EMAIL2");

                        //Obtenemos la sucursal del clientex
                        double dblTasa1 = 0;
                        double dblTasa2 = 0;
                        double dblTasa3 = 0;
                        int intIdTasa1 = 0;
                        int intIdTasa2 = 0;
                        int intIdTasa3 = 0;
                        int intSImp1_2 = 0;
                        int intSImp1_3 = 0;
                        int intSImp2_3 = 0;
                        int intSucDefOfertas = 0;
                        int intLPrecios = 0;
                        int intCT_DIASCREDITO = 0;
                        double dblDescuento = 0;
                        //Obtenemos el nombre de la sucursal default
                        strSql = "select vta_sucursal.SC_ID,SC_CLAVE,SC_NOMBRE,"
                                + "SC_TASA1,SC_TASA2,SC_TASA3,SC_SOBRIMP1_2,SC_SOBRIMP1_3,SC_SOBRIMP2_3,SC_DIVISA,"
                                + "vta_sucursal.TI_ID,vta_sucursal.TI_ID2,vta_sucursal.TI_ID3,SC_ACTIVA_OFERTA,CT_DESCUENTO,CT_LPRECIOS "
                                + ",vta_cliente.MON_ID,CT_DIASCREDITO "
                                + " from vta_sucursal,vta_cliente "
                                + " where vta_sucursal.SC_ID = vta_cliente.SC_ID"
                                + " AND vta_cliente.CT_ID = " + varSesiones.getintIdCliente();
                        ResultSet rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                            dblTasa1 = rs.getDouble("SC_TASA1");
                            dblTasa2 = rs.getDouble("SC_TASA2");
                            dblTasa3 = rs.getDouble("SC_TASA3");
                            intIdTasa1 = rs.getInt("TI_ID");
                            intIdTasa2 = rs.getInt("TI_ID2");
                            intIdTasa3 = rs.getInt("TI_ID3");
                            intSImp1_2 = rs.getInt("SC_SOBRIMP1_2");
                            intSImp1_3 = rs.getInt("SC_SOBRIMP1_3");
                            intSImp2_3 = rs.getInt("SC_SOBRIMP2_3");
                            intSucDefOfertas = rs.getInt("SC_ACTIVA_OFERTA");
                            intLPrecios = rs.getInt("CT_LPRECIOS");
                            dblDescuento = rs.getDouble("CT_DESCUENTO");
                            intCT_DIASCREDITO = rs.getInt("CT_DIASCREDITO");
                        }
                        rs.close();

                        //obtenemos el regimen fiscal
                        strSql = "select REGF_DESCRIPCION from "
                                + " vta_empregfiscal,vta_regimenfiscal "
                                + " where vta_empregfiscal.REGF_ID = vta_regimenfiscal.REGF_ID"
                                + " AND EMP_ID = " + intEMP_ID + " ";
                        try {
                            rs2 = oConn.runQuery(strSql, true);
                            while (rs2.next()) {
                                strRegimenFiscal = rs2.getString("REGF_DESCRIPCION");
                            }
                            rs2.close();
                        } catch (SQLException ex) {
                            System.out.println("ERROR:" + ex.getMessage());
                        }

                        //Llamamos objeto para guardar los datos de la tabla
                        CIP_Tabla objTabla = new CIP_Tabla("", "", "", "", varSesiones);
                        objTabla.Init("CLIENTES", true, true, false, oConn);
                        objTabla.setBolGetAutonumeric(true);
                        out.clearBuffer();//Limpiamos buffer
                        objTabla.setFieldInt("SC_ID", intSC_ID);
                        objTabla.setFieldInt("EMP_ID", intEMP_ID);
                        objTabla.setFieldInt("CT_UPLINE", 4);
                        objTabla.setFieldInt("CT_ACTIVO", 1);
                        objTabla.setFieldInt("CT_LPRECIOS", 1);
                        objTabla.setFieldInt("MON_ID", intMON_ID);
                        objTabla.setFieldInt("CT_SPONZOR", intSponzor);
                        objTabla.setFieldInt("MPE_ID", periodo.getPeriodoActual(oConn));
                        objTabla.setFieldInt("KL_ID_MASTER", varSesiones.getintIdCliente());

                        objTabla.setFieldString("CT_RAZONSOCIAL", objTablaAct.getFieldString("CT_RAZONSOCIAL"));
                        objTabla.setFieldString("CT_NOMBRE", objTablaAct.getFieldString("CT_NOMBRE"));
                        objTabla.setFieldString("CT_APATERNO", objTablaAct.getFieldString("CT_APATERNO"));
                        objTabla.setFieldString("CT_AMATERNO", objTablaAct.getFieldString("CT_AMATERNO"));
                        objTabla.setFieldString("CT_RFC", objTablaAct.getFieldString("CT_RFC"));
                        objTabla.setFieldString("CT_CRED_ELECTOR", objTablaAct.getFieldString("CT_CRED_ELECTOR"));
                        objTabla.setFieldString("CT_CALLE", objTablaAct.getFieldString("CT_CALLE"));
                        objTabla.setFieldString("CT_NUMERO", objTablaAct.getFieldString("CT_NUMERO"));
                        objTabla.setFieldString("CT_NUMINT", objTablaAct.getFieldString("CT_NUMINT"));
                        objTabla.setFieldString("CT_COLONIA", objTablaAct.getFieldString("CT_COLONIA"));
                        objTabla.setFieldString("CT_MUNICIPIO", objTablaAct.getFieldString("CT_MUNICIPIO"));
                        objTabla.setFieldString("CT_LOCALIDAD", objTablaAct.getFieldString("CT_LOCALIDAD"));
                        objTabla.setFieldString("CT_ESTADO", objTablaAct.getFieldString("CT_ESTADO"));
                        objTabla.setFieldString("CT_CP", objTablaAct.getFieldString("CT_CP"));
                        objTabla.setFieldString("CT_TELEFONO1", objTablaAct.getFieldString("CT_TELEFONO1"));
                        objTabla.setFieldString("CT_TELEFONO2", objTablaAct.getFieldString("CT_TELEFONO2"));
                        objTabla.setFieldString("CT_CONTACTO1", objTablaAct.getFieldString("CT_CONTACTO1"));
                        objTabla.setFieldString("CT_EMAIL1", objTablaAct.getFieldString("CT_EMAIL1"));
                        objTabla.setFieldString("CT_EMAIL2", objTablaAct.getFieldString("CT_EMAIL2"));
                        objTabla.setFieldString("CT_CTABANCO1", objTablaAct.getFieldString("CT_CTABANCO1"));
                        objTabla.setFieldString("CT_CTABANCO2", objTablaAct.getFieldString("CT_CTABANCO2"));
                        objTabla.setFieldString("CT_CTA_BANCO1", objTablaAct.getFieldString("CT_CTA_BANCO1"));
                        objTabla.setFieldString("CT_CTA_BANCO2", objTablaAct.getFieldString("CT_CTA_BANCO2"));
                        objTabla.setFieldString("CT_CTA_SUCURSAL1", objTablaAct.getFieldString("CT_CTA_SUCURSAL1"));
                        objTabla.setFieldString("CT_CTA_SUCURSAL2", objTablaAct.getFieldString("CT_CTA_SUCURSAL2"));
                        objTabla.setFieldString("CT_CTA_CLABE1", objTablaAct.getFieldString("CT_CTA_CLABE1"));
                        objTabla.setFieldString("CT_CTA_CLABE2", objTablaAct.getFieldString("CT_CTA_CLABE2"));
                        objTabla.setFieldString("CT_FECHAREG", fecha.getFechaActual());
                        objTabla.setFieldString("CT_FECHA_NAC", objTablaAct.getFieldString("CT_FECHA_NAC"));
                        objTabla.setFieldString("CT_NOTAS", strDescripcion);
                        if (intPr_Id == 141) {
                            objTabla.setFieldInt("CT_CATEGORIA1", 1);
                        } else {
                            objTabla.setFieldInt("CT_CATEGORIA1", 2);
                        }

                        /**
                         * Generamos un password aleatorio
                         */
                        objTabla.setFieldString("CT_PASSWORD", "");

                        //Generamos una alta
                        strResult = objTabla.Agrega(oConn);
                        strKey = objTabla.getValorKey();
                        
                        ActivaBinario activador = new ActivaBinario(oConn);
                        activador.setIntUplineInicial(intSponzor);
                        activador.setIntUplineTemporal(4);
                        activador.activarDistribuidor(Integer.parseInt(objTabla.getValorKey()));

                        int idCt = 0;
                        if (!strKey.equals("") || strKey != null) {
                            idCt = Integer.parseInt(strKey);
                        }

                        int intNvoKey = 0;
                        try {
                            intNvoKey = Integer.valueOf(strKey);
                        } catch (NumberFormatException ex) {
                        }
                        String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
                        if (strfolio_GLOBAL == null) {
                            strfolio_GLOBAL = "SI";
                        }

                        /**
                         * Generamos una referencia RAP
                         */
                        //intDigito = DigitoVerificador.CalculaModulo10(strKey, true);
                    }
                    oConn.close();
                } else {
                    strResult = "ERROR:El texto de la imagen no coincide";
                }
            } else {
                strResult = "EL CÓDIGO DE PROMOCIÓN NO EXISTE O YA FUE OCUPADO";
            }

        }

        //Validamos si fue exitoso
        if (strResult.equals("OK")) {

%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Se ha registrado el nuevo centro de negocios con el siguiente numero:</br> <%=strKey%> </h3>
</div>
<%
} else {
%>
<!-- Mostramos los datos -->
<div class="well ">
    <h3 class="page-header">Error al registrar el nuevo distribuidor, mensaje de error <%=strResult%> </h3>
    <input type="button" name="back" value="Regresar" class="btn btn-primary btn" onClick="window.history.back()"/>
</div>
<%
        }

    }

%>