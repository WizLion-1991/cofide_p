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
   if (1 ==1 /*varSesiones.getIntNoUser() != 0*/) {
      //Para manejo de fechas
      Fechas fecha = new Fechas();
      Periodos periodo = new Periodos();

      //Recuperamos todos los valores
      String strFolio = request.getParameter("num de folio");
      String strNombre = request.getParameter("nombre");
      String strAPaterno = request.getParameter("apaterno");
      String strAMaterno = request.getParameter("amaterno");
      String strRazonSocial = strNombre + " " + strAPaterno + " " + strAMaterno;
      String strSponsor = request.getParameter("sponsor");
      String strNacimiento = request.getParameter("nacimiento");
      if (strNacimiento != null) {
         strNacimiento = fecha.FormateaBD(strNacimiento, "/");
      }
      String strRfc = "";//request.getParameter("rfc");
      String strCalle = "";//request.getParameter("calle");
      String strNumero = "";//request.getParameter("numero");
      String strNumeroInterno = "";//request.getParameter("numeroInterno");
      String strColonia = "";//request.getParameter("colonia");
      String strMunicipio = "";//request.getParameter("municipio");
      String strLocalidad = "";//request.getParameter("localidad");
      String strEstado = "";//request.getParameter("estado");
      String strCp = "";//request.getParameter("cp");
      String strTelefono1 = request.getParameter("telefono1");
      String strTelefono2 = request.getParameter("telefono2");
      String strEmail1 = request.getParameter("email1");
      String strEmail2 = "";//request.getParameter("email2");
      String strContacto1 = "";//request.getParameter("contacto1");
      String strCuenta_bancaria1 = request.getParameter("cuenta_bancaria1");
      String strCuenta_bancaria2 = "";//request.getParameter("cuenta_bancaria2");
      String strBanco1 = request.getParameter("dir_ent_banco1");
      String strBanco2 = "";//request.getParameter("dir_ent_banco2");
      String strSucursal1 = request.getParameter("cuenta_suc1");
      String strSucursal2 = "";//request.getParameter("cuenta_suc2");
      String strClabe1 = request.getParameter("cuenta_clb1");
      String strClabe2 = "";//request.getParameter("cuenta_clb2");
      
      
      
      
      String strKit_ingreso = request.getParameter("kit_ingreso");
      String strAnswer = request.getParameter("answer");

      /*Recuperamos los parametros de direccion de entrega*/
      String strNombreEnt = "";//request.getParameter("dir_ent_nombre");
      String strTelefonoEnt = "";//request.getParameter("dir_ent_telefono");
      String strEmailEnt = "";//request.getParameter("dir_ent_email");
      String strCalleEnt = "";//request.getParameter("dir_ent_calle");
      String strNumeroEnt = "";//request.getParameter("dir_ent_numero");
      String strNunIntEnt = "";//request.getParameter("dir_ent_numeroInterno");
      String strColoniaEnt = "";//request.getParameter("dir_ent_colonia");
      String strEstadoEnt = "";//request.getParameter("dir_ent_estado");
      String strMunicipioEnt = "";//request.getParameter("dir_ent_mun");
      String strCpEnt = "";//request.getParameter("dir_ent_cp");
      String strDesc = "";//request.getParameter("texto").trim();




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
         //Consultamos datos de la mama
         int intSC_ID = 1;
         int intEMP_ID = 1;
         int intMON_ID = 0;
         int intTI_ID = 0;
         String strSql = "select SC_ID,EMP_ID,MON_ID,TI_ID from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            intSC_ID = 1;
            intEMP_ID = 1;
            intMON_ID = rs.getInt("EMP_ID");
            intTI_ID = rs.getInt("TI_ID");
         }
         rs.close();
         //Obtenemos la sucursal del cliente
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
         rs = oConn.runQuery(strSql, true);
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
         int intSponsor = 0;
         try {
            intSponsor = Integer.valueOf(strSponsor);
         } catch (NumberFormatException ex) {
            System.out.println("Error al convertir sponsor...");
         }
         //Obtenemos el id del kit de ingreso
         try {
            intPr_Id = Integer.valueOf(strKit_ingreso);
         } catch (NumberFormatException ex) {
            System.out.println("Error al convertir intPr_Id...");
         }
         //consultamos el precio del articulo
         strSql = "select PR_ID,PP_PRECIO,PP_APDESC,PP_PTOSLEAL,PP_PTOSLEALCAM "
                 + ",PP_PRECIO_USD,PP_PUNTOS,PP_NEGOCIO,PP_PPUBLICO,PP_APDESC,PP_APDESCPTO,PP_APDESCNEGO,PP_PUTILIDAD "
                 + " from vta_prodprecios where PR_ID = " + intPr_Id + " AND LP_ID= 1";
         ResultSet rs2;
         try {
            rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               dblPrecio = rs2.getDouble("PP_PRECIO");
               dblPuntos = rs2.getDouble("PP_PUNTOS");
               dblNegocio = rs2.getDouble("PP_NEGOCIO");
            }
            rs2.close();
         } catch (SQLException ex) {
            System.out.println("ERROR:" + ex.getMessage());
         }
         //Consultamos datos del producto
         strSql = "select PR_CODIGO,PR_DESCRIPCION,PR_EXENTO1,PR_EXENTO2,PR_EXENTO3,PR_UNIDADMEDIDA "
                 + " from vta_producto where PR_ID = " + intPr_Id + " ";
         try {
            rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               strCodigo = rs2.getString("PR_CODIGO");
               intExento1 = rs2.getInt("PR_EXENTO1");
               intExento2 = rs2.getInt("PR_EXENTO2");
               intExento3 = rs2.getInt("PR_EXENTO3");
               intUnidadMedida = rs2.getInt("PR_UNIDADMEDIDA");
               strDescripcion = rs2.getString("PR_DESCRIPCION");
            }
            rs2.close();
         } catch (SQLException ex) {
            System.out.println("ERROR:" + ex.getMessage());
         }
         //obtenemos la unidad de medida
         strSql = "select ME_DESCRIPCION from "
                 + " vta_unidadmedida "
                 + " where ME_ID = " + intUnidadMedida + " ";
         try {
            rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               strUnidadMedida = rs2.getString("ME_DESCRIPCION");
            }
            rs2.close();
         } catch (SQLException ex) {
            System.out.println("ERROR:" + ex.getMessage());
         }
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
         //atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML7
         //objTabla.ObtenParams(true, true, false, false, request, oConn);
         objTabla.setFieldInt("SC_ID", intSC_ID);
         objTabla.setFieldInt("EMP_ID", intEMP_ID);
         objTabla.setFieldInt("CT_UPLINE", 1);
         objTabla.setFieldInt("CT_ACTIVO", 1);
         objTabla.setFieldInt("CT_LPRECIOS", 1);
         objTabla.setFieldInt("MON_ID", intMON_ID);
         objTabla.setFieldInt("CT_SPONZOR", intSponsor);
         objTabla.setFieldInt("MPE_ID", periodo.getPeriodoActual(oConn));

         objTabla.setFieldString("CT_RAZONSOCIAL", strRazonSocial);
         objTabla.setFieldString("CT_NOMBRE", strNombre);
         objTabla.setFieldString("CT_APATERNO", strAPaterno);
         objTabla.setFieldString("CT_AMATERNO", strAMaterno);
         objTabla.setFieldString("CT_RFC", strRfc);
         objTabla.setFieldString("CT_CALLE", strCalle);
         objTabla.setFieldString("CT_NUMERO", strNumero);
         objTabla.setFieldString("CT_NUMINT", strNumeroInterno);
         objTabla.setFieldString("CT_COLONIA", strColonia);
         objTabla.setFieldString("CT_MUNICIPIO", strMunicipio);
         objTabla.setFieldString("CT_LOCALIDAD", strLocalidad);
         objTabla.setFieldString("CT_ESTADO", strEstado);
         objTabla.setFieldString("CT_CP", strCp);
         objTabla.setFieldString("CT_TELEFONO1", strTelefono1);
         objTabla.setFieldString("CT_TELEFONO2", strTelefono2);
         objTabla.setFieldString("CT_CONTACTO1", strContacto1);
         objTabla.setFieldString("CT_EMAIL1", strEmail1);
         objTabla.setFieldString("CT_EMAIL2", strEmail2);
         objTabla.setFieldString("CT_CTABANCO1", strCuenta_bancaria1);
         objTabla.setFieldString("CT_CTABANCO2", strCuenta_bancaria2);
         objTabla.setFieldString("CT_CTA_BANCO1", strBanco1);
         objTabla.setFieldString("CT_CTA_BANCO2", strBanco2);
         objTabla.setFieldString("CT_CTA_SUCURSAL1", strSucursal1);
         objTabla.setFieldString("CT_CTA_SUCURSAL2", strSucursal2);
         objTabla.setFieldString("CT_CTA_CLABE1", strClabe1);
         objTabla.setFieldString("CT_CTA_CLABE2", strClabe2);
         objTabla.setFieldString("CT_FECHAREG", fecha.getFechaActual());
         objTabla.setFieldString("CT_FECHA_NAC", strNacimiento);
         objTabla.setFieldString("CT_NOTAS", strDescripcion);
         objTabla.setFieldString("PROS_FOLIO", strFolio);
         /**
          * Generamos un password aleatorio
          */
         objTabla.setFieldString("CT_PASSWORD", generateData.getPassword(12));

         //Generamos una alta
         strResult = objTabla.Agrega(oConn);
         strKey = objTabla.getValorKey();

         int idCt = 0;
         if (!strKey.equals("") || strKey != null) {
            idCt = Integer.parseInt(strKey);
         }
         String strResEntrega = "";
         vta_cliente_dir_entrega dirEnt = new vta_cliente_dir_entrega();
         if (strResult.equals("OK")) {
            dirEnt.setFieldString("CDE_NOMBRE", strNombreEnt);
            dirEnt.setFieldString("CDE_TELEFONO1", strTelefonoEnt);
            dirEnt.setFieldString("CDE_EMAIL", strEmailEnt);
            dirEnt.setFieldString("CDE_CALLE", strCalleEnt);
            dirEnt.setFieldString("CDE_NUMERO", strNumeroEnt);
            dirEnt.setFieldString("CDE_NUMINT", strNunIntEnt);
            dirEnt.setFieldString("CDE_COLONIA", strColoniaEnt);
            dirEnt.setFieldString("CDE_ESTADO", strEstadoEnt);
            dirEnt.setFieldString("CDE_MUNICIPIO", strMunicipioEnt);
            dirEnt.setFieldString("CDE_CP", strCpEnt);
            dirEnt.setFieldString("CDE_LOCALIDAD", "MEXICO");
            dirEnt.setFieldString("CDE_DESCRIPCION", strDesc);
            dirEnt.setFieldInt("EMP_ID", intEMP_ID);
            dirEnt.setFieldInt("CT_ID", idCt);

            strResEntrega = dirEnt.Agrega(oConn);
         }


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
            /**
             * Generamos el pedido de ingreso
             */
            String strPedido = GeneraPedido(oConn, varSesiones,
                    intSC_ID, intNvoKey, intMON_ID, intTI_ID, fecha,
                    dblPrecio, dblTasa1, dblTasa2, dblTasa3,
                    intSImp1_2, intSImp1_3, intSImp2_3,
                    dblPuntos, dblNegocio, intCT_DIASCREDITO,
                    strRegimenFiscal,
                    intPr_Id, strDescripcion, strCodigo,
                    intExento1, intExento2, intExento3, strUnidadMedida, strfolio_GLOBAL);
            /**
             * Generamos una referencia RAP
             */
            intDigito = DigitoVerificador.CalculaModulo10(strKey, true);

            String strSqlUsuarios = "";
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

               strSqlUsuarios = "SELECT EMAIL FROM usuarios WHERE BOL_MAIL_INGRESOS=1";
               try {
                  rs = oConn.runQuery(strSqlUsuarios);

                  while (rs.next()) {
                     if (!rs.getString("EMAIL").equals("")) {
                        strLstMail += "," + rs.getString("EMAIL");
                     }
                  }

                  rs.close();
               } catch (SQLException ex) {
                  //this.strResultLast = "ERROR:" + ex.getMessage();
                  ex.fillInStackTrace();
               }
               //Intentamos mandar el mail
               mail.setBolDepuracion(false);
               mail.getTemplate("MSG_ING", oConn);
               mail.getMensaje();
               String strSqlEmp = "SELECT * FROM vta_cliente"
                       + " where CT_ID=" + objTabla.getValorKey() + "";
               try {
                  rs = oConn.runQuery(strSqlEmp);
                  mail.setReplaceContent(rs);
                  rs.close();
               } catch (SQLException ex) {
                  //this.strResultLast = "ERROR:" + ex.getMessage();
                  ex.fillInStackTrace();
               }
               if(strLstMail.startsWith(",")){
                  strLstMail= strLstMail.substring(1, strLstMail.length());
               }
               mail.setDestino(strLstMail);
               boolean bol = mail.sendMail();
               if (bol) {
                  //strResp = "MAIL ENVIADO.";
               } else {
                  //strResp = "FALLO EL ENVIO DEL MAIL.";
               }

            } else {
               //strResp = "ERROR: INGRESE UN MAIL";
            }
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
   <h3 class="page-header">Se ha registrado el nuevo distribuidor con el siguiente numero:</br> <%=strKey%> </h3>
   <h3 class="page-header">Referencia Bancaria:</br> <%=strKey + intDigito%> </h3>
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

<%!
// #################### Funciones   ####################
   public String GeneraPedido(Conexion oConn, VariableSession varSesiones,
           int intSC_ID, int intCT_ID, int intMON_ID, int intTI_ID, Fechas fecha,
           double dblPrecio, double dblTasa1, double dblTasa2, double dblTasa3,
           int intSImp1_2, int intSImp1_3, int intSImp2_3,
           double dblPuntos, double dblNegocio, int intCT_DIASCREDITO,
           String strRegimenFiscal,
           int intPR_ID, String strDescripcion, String strCodigo,
           int intExento1, int intExento2, int intExento3,
           String strUnidadMedida, String strfolio_GLOBAL) {
      //Instanciamos el objeto que generara la venta
      Ticket ticket = new Ticket(oConn, varSesiones, null);
      //Recibimos parametros
      String strPrefijoMaster = "PD";
      String strPrefijoDeta = "PDD";
      String strTipoVtaNom = Ticket.PEDIDO;
      ticket.setStrTipoVta(strTipoVtaNom);
      //Validamos si tenemos un empresa seleccionada
      if (varSesiones.getIntIdEmpresa() != 0) {
         //Asignamos la empresa seleccionada
         ticket.setIntEMP_ID(varSesiones.getIntIdEmpresa());
      }
      //Validamos si usaremos un folio global
      if (strfolio_GLOBAL.equals("NO")) {
         ticket.setBolFolioGlobal(false);
      }
      ticket.getDocument().setFieldInt("SC_ID", intSC_ID);
      ticket.getDocument().setFieldInt("CT_ID", intCT_ID);
      ticket.getDocument().setFieldInt(strPrefijoMaster + "_MONEDA", intMON_ID);
      //Clave de vendedor
      int intVE_ID = 0;

      //Tarifas de IVA
      int intTI_ID2 = 0;
      int intTI_ID3 = 0;
      //Tipo de comprobante
      int intFAC_TIPOCOMP = 1;
      //Asignamos los valores al objeto
      ticket.getDocument().setFieldInt("VE_ID", intVE_ID);
      ticket.getDocument().setFieldInt("TI_ID", intTI_ID);
      ticket.getDocument().setFieldInt("TI_ID2", intTI_ID2);
      ticket.getDocument().setFieldInt("TI_ID3", intTI_ID3);
      ticket.setIntFAC_TIPOCOMP(intFAC_TIPOCOMP);
      ticket.getDocument().setFieldString(strPrefijoMaster + "_FECHA", fecha.getFechaActual());
      ticket.getDocument().setFieldString(strPrefijoMaster + "_FOLIO", "");
      ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTAS", "Kit de ingreso");
      ticket.getDocument().setFieldString(strPrefijoMaster + "_NOTASPIE", "");
      ticket.getDocument().setFieldString(strPrefijoMaster + "_REFERENCIA", "");
      ticket.getDocument().setFieldString(strPrefijoMaster + "_CONDPAGO", "");
      ticket.getDocument().setFieldString(strPrefijoMaster + "_METODODEPAGO", "NO IDENTIFICADO");
      ticket.getDocument().setFieldString(strPrefijoMaster + "_NUMCUENTA", "");
      ticket.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", "En una sola Exhibicion");
      //ticket.getDocument().setFieldString(strPrefijoMaster + "_FORMADEPAGO", "En una sola Exhibicion");
      //Calculo de los importes
      double dblImporte = dblPrecio;
      double dblImpuesto1 = 0;
      double dblImpuesto2 = 0;
      double dblImpuesto3 = 0;
      double dblTotal = 0;
      Impuestos impuesto = new Impuestos(dblTasa1, dblTasa2, dblTasa3,
              intSImp1_2, intSImp1_3, intSImp2_3);
      impuesto.CalculaImpuestoMas(dblImporte, dblImporte, dblImporte);
      dblImpuesto1 = impuesto.getDblImpuesto1();
      dblTotal = dblImporte + dblImpuesto1 + dblImpuesto2 + dblImpuesto3;

      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE", dblImporte);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO1", dblImpuesto1);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO2", dblImpuesto2);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPUESTO3", dblImpuesto3);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TOTAL", dblTotal);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA1", dblTasa1);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA2", dblTasa2);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASA3", dblTasa3);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_TASAPESO", 1);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_PUNTOS", dblPuntos);
      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_IMPORTE_NEGOCIO", dblNegocio);

      ticket.getDocument().setFieldDouble(strPrefijoMaster + "_DIASCREDITO", intCT_DIASCREDITO);
      ticket.getDocument().setFieldString(strPrefijoMaster + "_REGIMENFISCAL", strRegimenFiscal);

      TableMaster deta = new vta_pedidosdeta();

      deta.setFieldInt("SC_ID", intSC_ID);
      deta.setFieldInt("PR_ID", intPR_ID);
      deta.setFieldInt(strPrefijoDeta + "_EXENTO1", intExento1);
      deta.setFieldInt(strPrefijoDeta + "_EXENTO2", intExento2);
      deta.setFieldInt(strPrefijoDeta + "_EXENTO3", intExento3);
      deta.setFieldInt(strPrefijoDeta + "_ESREGALO", 0);
      deta.setFieldString(strPrefijoDeta + "_CVE", strCodigo);
      deta.setFieldString(strPrefijoDeta + "_DESCRIPCION", strDescripcion);
      deta.setFieldString(strPrefijoDeta + "_NOSERIE", "");
      deta.setFieldDouble(strPrefijoDeta + "_IMPORTE", dblImporte);
      deta.setFieldDouble(strPrefijoDeta + "_CANTIDAD", 1);
      deta.setFieldDouble(strPrefijoDeta + "_TASAIVA1", dblTasa1);
      deta.setFieldDouble(strPrefijoDeta + "_TASAIVA2", dblTasa2);
      deta.setFieldDouble(strPrefijoDeta + "_TASAIVA3", dblTasa3);
      deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO1", dblImpuesto1);
      deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO2", dblImpuesto2);
      deta.setFieldDouble(strPrefijoDeta + "_IMPUESTO3", dblImpuesto3);
      deta.setFieldDouble(strPrefijoDeta + "_IMPORTEREAL", dblImporte);
      deta.setFieldDouble(strPrefijoDeta + "_PRECIO", dblImporte);
      deta.setFieldDouble(strPrefijoDeta + "_DESCUENTO", 0);
      deta.setFieldDouble(strPrefijoDeta + "_PORDESC", 0);
      deta.setFieldDouble(strPrefijoDeta + "_PRECREAL", dblImporte);
      deta.setFieldInt(strPrefijoDeta + "_PRECFIJO", 0);
      deta.setFieldInt(strPrefijoDeta + "_ESREGALO", 0);
      deta.setFieldString(strPrefijoDeta + "_COMENTARIO", "");
      //UNIDAD DE MEDIDA UNIDAD_MEDIDA
      deta.setFieldString(strPrefijoDeta + "_UNIDAD_MEDIDA", strUnidadMedida);

      //MLM
      deta.setFieldDouble(strPrefijoDeta + "_PUNTOS", dblPuntos);
      deta.setFieldDouble(strPrefijoDeta + "_VNEGOCIO", dblNegocio);
      deta.setFieldDouble(strPrefijoDeta + "_IMP_PUNTOS", dblPuntos);
      deta.setFieldDouble(strPrefijoDeta + "_IMP_VNEGOCIO", dblNegocio);
      deta.setFieldDouble(strPrefijoDeta + "_DESC_ORI", 0);
      deta.setFieldInt(strPrefijoDeta + "_DESC_PREC", 0);
      deta.setFieldInt(strPrefijoDeta + "_DESC_PUNTOS", 0);
      deta.setFieldInt(strPrefijoDeta + "_DESC_VNEGOCIO", 0);
      deta.setFieldInt(strPrefijoDeta + "_REGALO", 0);
      deta.setFieldInt(strPrefijoDeta + "_ID_PROMO", 0);
      ticket.AddDetalle(deta);

      //Guardamos el pedido
      ticket.Init();
      //Generamos transaccion
      ticket.doTrx();

      String strRes = "";
      if (ticket.getStrResultLast().equals("OK")) {
         strRes = "OK." + ticket.getDocument().getValorKey();
      } else {
         strRes = ticket.getStrResultLast();
      }
      return strRes;
   }
%>