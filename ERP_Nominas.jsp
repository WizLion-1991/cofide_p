<%-- 
    Document   : ERP_Nominas
Este jsp ejecuta las peticiones para las operaciones de negocio de las nóminas
    Created on : 05-mar-2014, 13:17:31
    Author     : ZeusGalindo
--%>

<%@page import="com.mx.siweb.erp.nominas.Entidades.AguinaldoEntidad"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mx.siweb.erp.nominas.CalculaAguinaldo"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="Core.FirmasElectronicas.Opalina"%>
<%@page import="ERP.Nominas"%>
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
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      String strid = request.getParameter("id");
      Fechas fecha = new Fechas();
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Timbrar los recibos de nomina
         if (strid.equals("1")) {
            //Recuperamos parametros
            String strFolioIni = request.getParameter("nom_folio1");
            String strFolioFin = request.getParameter("nom_folio2");

            //Recuperamos paths de web.xml
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");

            //objeto de nominas
            Nominas nomina = new Nominas(oConn, varSesiones, request);
            nomina.Init();
            nomina.setBolSendMailMasivo(false);
            nomina.setIntEMP_ID(varSesiones.getIntIdEmpresa());

            //Password
            String strPassB64 = this.getServletContext().getInitParameter("SecretWord");
            Opalina opa = new Opalina();
            String strMyPassSecret = opa.DesEncripta(strPassB64, "dWAM1YhbGAeu7CTULai4eQ==");

            nomina.setStrMyPassSecret(strMyPassSecret);
            nomina.setStrPATHFonts("");
            nomina.setStrPATHXml(strPathXML);
            nomina.setStrPATHKeys(strPathPrivateKeys);
            nomina.doTimbrado(varSesiones.getIntIdEmpresa(), "", 0, strFolioIni, strFolioFin);
            String strResult = nomina.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado
         }

         //Cancelar los recibos
         if (strid.equals("2")) {
            int intIdAnular = 0;
            //Recuperamos el parametro
            if (request.getParameter("idAnular") != null) {
               try {
                  intIdAnular = Integer.valueOf(request.getParameter("idAnular"));
               } catch (NumberFormatException ex) {
               }
            }
            //Recuperamos paths de web.xml
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");

            //objeto de nominas
            Nominas nomina = new Nominas(oConn, varSesiones, request);
            nomina.getDocument().setFieldInt("NOM_ID", intIdAnular);
            nomina.Init();
            nomina.setBolSendMailMasivo(false);
            nomina.setIntEMP_ID(varSesiones.getIntIdEmpresa());

            //Password
            String strPassB64 = this.getServletContext().getInitParameter("SecretWord");
            Opalina opa = new Opalina();
            String strMyPassSecret = opa.DesEncripta(strPassB64, "dWAM1YhbGAeu7CTULai4eQ==");

            nomina.setStrMyPassSecret(strMyPassSecret);
            nomina.setStrPATHFonts("");
            nomina.setStrPATHXml(strPathXML);
            nomina.setStrPATHKeys(strPathPrivateKeys);

            nomina.doTrxAnul();

            String strResult = nomina.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado

         }
         //Enviar por mail masivamente los recibos de nomina
         if (strid.equals("3")) {
            //Recuperamos parametros
            String strFolioIni = request.getParameter("nom_folio1");
            String strFolioFin = request.getParameter("nom_folio2");
            String strMailMas = request.getParameter("mail_envio");
            int intCopiaa = 0;
            if (request.getParameter("copia_a") != null) {
               try {
                  intCopiaa = Integer.valueOf(request.getParameter("copia_a"));
               } catch (NumberFormatException ex) {
                  System.out.println("copia_a: " + ex.getMessage());
               }
            }

            //Recuperamos paths de web.xml
            String strPathXML = this.getServletContext().getInitParameter("PathXml");
            String strPathBase = this.getServletContext().getRealPath("/");

            //objeto de nominas
            Nominas nomina = new Nominas(oConn, varSesiones, request);
            nomina.setStrPATHXml(strPathXML);
            nomina.setStrPATHBase(strPathBase);
            nomina.doEnvioMasivo(varSesiones.getIntIdEmpresa(), strFolioIni, strFolioFin, strMailMas, intCopiaa);

            String strResult = nomina.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado
         }
         //Genera las polizas contables de los recibos de nómina sin timbrar
         if (strid.equals("4")) {
            //Recuperamos parametros
            String strFolioIni = request.getParameter("nom_folio1");
            String strFolioFin = request.getParameter("nom_folio2");
            //objeto de nominas
            Nominas nomina = new Nominas(oConn, varSesiones, request);
            //      nomina.doGeneraContabilidad(varSesiones.getIntIdEmpresa(), strFolioIni, strFolioFin);
            String strResult = nomina.getStrResultLast();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strResult);//Pintamos el resultado
         }

         if (strid.equals("5")) {
            //Recuperamos parametros
            String intIdEmp = request.getParameter("intIdEmp");

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<empleados>";

            String strFECHA = "";
            String strUSUARIO = "";
            String strTIPO_CAMBIO = "";
            String strSALARIO_ANT = "";
            String strTIPO_SALARIO_ANT = "";
            String strNUEVO_SALARIO = "";
            String strTIPO_SALARIO_NVO = "";
            String strREGISTRO_PATRONAL_ANT = "";
            String strNOTAS = "";
            String strEMP_NUM = "";
            String strREGISTRO_PATRONAL_NVO = "";

            String strQuery1 = "select * from rhh_historial_movimientos where EMP_NUM =" + intIdEmp;

            ResultSet rs1 = oConn.runQuery(strQuery1, true);
            while (rs1.next()) {

               strFECHA = rs1.getString("RHI_FECHA");

               String strQuery2 = "select * from usuarios where id_usuarios =" + rs1.getString("RHI_USUARIO");

               ResultSet rs2 = oConn.runQuery(strQuery2, true);
               while (rs2.next()) {
                  strUSUARIO = rs2.getString("nombre_usuario");
               }
               rs2.close();

               strTIPO_CAMBIO = rs1.getString("RHI_TIPO_CAMBIO");
               strSALARIO_ANT = rs1.getString("RHI_SALARIO_ANT");
               strTIPO_SALARIO_ANT = rs1.getString("RHI_TIPO_SALARIO_ANT");
               strNUEVO_SALARIO = rs1.getString("RHI_NUEVO_SALARIO");
               strTIPO_SALARIO_NVO = rs1.getString("RHI_TIPO_SALARIO_NVO");
               strREGISTRO_PATRONAL_ANT = rs1.getString("RHI_REGISTRO_PATRONAL_ANT");
               strNOTAS = rs1.getString("RHI_NOTAS");
               strEMP_NUM = rs1.getString("EMP_NUM");
               strREGISTRO_PATRONAL_NVO = rs1.getString("RHI_REGISTRO_PATRONAL_NVO");

               String formFecha = fecha.Formatea(strFECHA, "/");

               strXML += "<empleados_deta "
                       + " strFECHA = \"" + formFecha + "\"  "
                       + " strUSUARIO = \"" + strUSUARIO + "\"  "
                       + " strTIPO_CAMBIO = \"" + strTIPO_CAMBIO + "\"  "
                       + " strSALARIO_ANT = \"" + strSALARIO_ANT + "\"  "
                       + " strTIPO_SALARIO_ANT = \"" + strTIPO_SALARIO_ANT + "\"  "
                       + " strNUEVO_SALARIO = \"" + strNUEVO_SALARIO + "\"  "
                       + " strTIPO_SALARIO_NVO = \"" + strTIPO_SALARIO_NVO + "\"  "
                       + " strREGISTRO_PATRONAL_ANT = \"" + strREGISTRO_PATRONAL_ANT + "\"  "
                       + " strNOTAS = \"" + strNOTAS + "\"  "
                       + " strEMP_NUM = \"" + strEMP_NUM + "\"  "
                       + " strREGISTRO_PATRONAL_NVO = \"" + strREGISTRO_PATRONAL_NVO + "\"  "
                       + " />";

            }
            strXML += "</empleados>";
            rs1.close();
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         if (strid.equals("6")) {

            int intIdNom = Integer.parseInt(request.getParameter("RHN_ID"));

            Nominas nomina = new Nominas(oConn, varSesiones);
            nomina.CalculaNomina(intIdNom);

            String strRes = "";
            if (nomina.getStrResultLast().equals("OK")) {
               strRes = "PROCESO TERMINADO";
            } else {
               strRes = nomina.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
            if (strid.equals("7")) {
                CalculaAguinaldo cAguinaldo = new CalculaAguinaldo(oConn, varSesiones);
                String strDiasAg = request.getParameter("DIAS_AG");
                String strAnioAg = request.getParameter("ANIO_AG");
                int intDias = Integer.parseInt(strDiasAg);
                if (strAnioAg == "0" || strAnioAg == "") {
                    Fechas fec = new Fechas();
                    int intAnio = Integer.parseInt(strAnioAg);
                    intAnio = fec.getAnioActual();
                    cAguinaldo.setIntAnio(intAnio);
                } else {
                    int intAnio = Integer.parseInt(strAnioAg);
                    cAguinaldo.setIntAnio(intAnio);
                }
                cAguinaldo.getEmpleados();
                cAguinaldo.setIntDias(intDias);
                cAguinaldo.getXML();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(cAguinaldo.getXML());//Pintamos el resultado
            }//Fin ID 7

            if (strid.equals("8")) {
                CalculaAguinaldo cAguinaldo = new CalculaAguinaldo(oConn, varSesiones);
                String strDiasAg = request.getParameter("DIAS_AG");
                String strAnioAg = request.getParameter("ANIO_AG");
                int intDias = Integer.parseInt(strDiasAg);
                if (strAnioAg == "0" || strAnioAg == "") {
                    Fechas fec = new Fechas();
                    int intAnio = Integer.parseInt(strAnioAg);
                    intAnio = fec.getAnioActual();
                    cAguinaldo.setIntAnio(intAnio);
                } else {
                    int intAnio = Integer.parseInt(strAnioAg);
                    cAguinaldo.setIntAnio(intAnio);
      }
                cAguinaldo.getEmpleados();
                cAguinaldo.setIntDias(intDias);
                cAguinaldo.getXML();
                ArrayList<AguinaldoEntidad> entidades = cAguinaldo.getLstAguinaldoCalc();

                String strRes = cAguinaldo.CalculaNomina(entidades);
                if (strRes.equals("OK")) {
                    strRes = "PROCESO TERMINADO";
   } else {
                    strRes = strRes;
   }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 8

        }

    } else {
    }
   oConn.close();
%>