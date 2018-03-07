<%-- 
    Document   : ERP_Bancos
    Este jsp se encarga de procesar todas las peticiones referentes a bancos
    Created on : 10/08/2010, 12:06:36 AM
    Author     : zeus
--%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
<%@page import="Tablas.vta_mov_cta_bcos" %>
<%@page import="Tablas.vta_mov_cta_bcos_deta" %>
<%@page import="ERP.Bancos" %>
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
      Fechas fecha = new Fechas();
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos
      if (strid != null) {
         //Genera una nueva operacion de pagos en base a la transaccion que nos envian
         if (strid.equals("1")) {
            //Anticipo de proveedor
            int intId_AnticipoProv = 0;
            double dblTASA_CAMBIO = 0.0;
            double dblIMPORTE_DEVOLVER = 0.0;
            if (request.getParameter("ID_ANTICIPOPROV") != null) {
               intId_AnticipoProv = Integer.valueOf(request.getParameter("ID_ANTICIPOPROV"));
               dblTASA_CAMBIO = Float.valueOf(request.getParameter("TASA_CAMBIO_ANTI"));
               dblIMPORTE_DEVOLVER = Float.valueOf(request.getParameter("IMPORTE_DEVOLVER"));
            }
            //Anticipo de cliente
            int intId_AnticipoClie = 0;
            double dblIMPORTE_DEVOLVER_clie = 0.0;
            if (request.getParameter("ID_ANTICIPO_CLIE") != null) {
               intId_AnticipoClie = Integer.valueOf(request.getParameter("ID_ANTICIPO_CLIE"));
               dblTASA_CAMBIO = Float.valueOf(request.getParameter("TASA_CAMBIO_ANTI_CLIE"));
               dblIMPORTE_DEVOLVER_clie = Float.valueOf(request.getParameter("IMPORTE_DEVOLVER_CLIE"));
            }
            
            int intMCB_ID = 0;
            //Recibimos el id del pago por cancelar
            if (request.getParameter("MCB_ID") != null) {
               try {
                  intMCB_ID = Integer.valueOf(request.getParameter("MCB_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            int intBco = 0;
            if (request.getParameter("BC_ID") != null) {
               intBco = Integer.valueOf(request.getParameter("BC_ID"));
            }
            int intSuc = 0;
            if (request.getParameter("SC_ID") != null) {
               intSuc = Integer.valueOf(request.getParameter("SC_ID"));
            }

            //Si la sucursal esta en ceros obtenemos el numero de sucursal default del banco
            if (intSuc == 0) {
               String strSql = "SELECT SC_ID FROM vta_bcos where BC_ID = " + intBco;
               ResultSet rs = oConn.runQuery(strSql, true);
               while (rs.next()) {
                  intSuc = rs.getInt("SC_ID");
               }
               rs.close();
            }
            int intConciliado = 0;
            if (request.getParameter("MCB_CONCILIADO") != null) {
               intConciliado = Integer.valueOf(request.getParameter("MCB_CONCILIADO"));
            }

            int intNoIdentificado = 0;
            if (request.getParameter("MCB_TIPO1") != null) {
               intNoIdentificado = Integer.valueOf(request.getParameter("MCB_TIPO1"));
            }

            int intEntregaDoc = 0;
            if (request.getParameter("MCB_TIPO2") != null) {
               intEntregaDoc = Integer.valueOf(request.getParameter("MCB_TIPO2"));
            }

            int intBandera3 = 0;
            if (request.getParameter("MCB_TIPO3") != null) {
               intBandera3 = Integer.valueOf(request.getParameter("MCB_TIPO3"));
            }

            String strFechaEntrega = "";
            if (request.getParameter("MCB_FECENTREGA") != null) {
               strFechaEntrega = request.getParameter("MCB_FECENTREGA");
               strFechaEntrega = fecha.FormateaBD(strFechaEntrega, "/");
            }
            final String strNotas = URLDecoder.decode(new String(request.getParameter("MCB_NOTAS_ENT").getBytes(
                       "iso-8859-1")), "UTF-8");
            
            String strFecha = "";
            if (request.getParameter("MCB_FECHA") != null) {
               strFecha = request.getParameter("MCB_FECHA");
               strFecha = fecha.FormateaBD(strFecha, "/");
               
            }
            String strMCB_CONCEPTO = "";
            if (request.getParameter("MCB_CONCEPTO") != null) {
            final String strConcepto1 = URLDecoder.decode(new String(request.getParameter("MCB_CONCEPTO").getBytes(
                       "iso-8859-1")), "UTF-8");
               strMCB_CONCEPTO = strConcepto1;
            }
            String strMCB_BENEFICIARIO = "";
            if (request.getParameter("MCB_BENEFICIARIO") != null) {
            final String strBeneficiario1 = URLDecoder.decode(new String(request.getParameter("MCB_BENEFICIARIO").getBytes(
                       "iso-8859-1")), "UTF-8");
               strMCB_BENEFICIARIO = strBeneficiario1;
            }
            String strMCB_NOCHEQUE = "";
            if (request.getParameter("MCB_NOCHEQUE") != null) {
               strMCB_NOCHEQUE = request.getParameter("MCB_NOCHEQUE");
            }
            //Recuperamos los importes
            double dblMCB_DEPOSITO = 0;
            if (request.getParameter("MCB_DEPOSITO") != null) {
               dblMCB_DEPOSITO = Double.valueOf(request.getParameter("MCB_DEPOSITO"));
            }
            double dblMCB_RETIRO = 0;
            if (request.getParameter("MCB_RETIRO") != null) {
               dblMCB_RETIRO = Double.valueOf(request.getParameter("MCB_RETIRO"));
            }
            int intMoneda = 0;
            double dblParidad = 0;
            if (request.getParameter("MCB_PARIDAD") != null) {
               dblParidad = Double.valueOf(request.getParameter("MCB_PARIDAD"));
            }
            if (request.getParameter("MCB_MONEDA") != null) {
               intMoneda = Integer.valueOf(request.getParameter("MCB_MONEDA"));
            }
            
            //nuevos campos para el traspaso
            int intMCB_TRASPASO = 0;
            if (request.getParameter("MCB_TRASPASO") != null) {
               intMCB_TRASPASO = Integer.valueOf(request.getParameter("MCB_TRASPASO"));
            }
            int intBco2 = 0;
            if (request.getParameter("BC_ID2") != null) {
               intBco2 = Integer.valueOf(request.getParameter("BC_ID2"));
            }
             double dblParidad2 = 0;
            if (request.getParameter("MCB_PARIDAD2") != null) {
               dblParidad2 = Double.valueOf(request.getParameter("MCB_PARIDAD2"));
            }
            
            
            int intMCB_TRAS_ORIGEN = 0;
            if (request.getParameter("MCB_TRAS_ORIGEN") != null) {
               if(intMCB_TRASPASO == 1){
                  intMCB_TRAS_ORIGEN = Integer.valueOf(request.getParameter("MCB_ID"));
               }
            }
            
            String strRFCBeneficiario = "";
            if (request.getParameter("BNK_RFC_BENEFICIARIO") != null) {
               strRFCBeneficiario = request.getParameter("BNK_RFC_BENEFICIARIO");               
            }
            
            int intEsTransferencia =0;
            if (request.getParameter("BNK_ESTRANSFERENCIA") != null) {
               intEsTransferencia = Integer.valueOf(request.getParameter("BNK_ESTRANSFERENCIA"));               
            }
            String strBcoDestino = "";
            if (request.getParameter("BNK_BCO_DEST") != null) {
               strBcoDestino = request.getParameter("BNK_BCO_DEST");               
            }
            
            String strCtaBeneficiario ="";
            if (request.getParameter("BNK_CTA_DEST") != null) {
               strCtaBeneficiario = request.getParameter("BNK_CTA_DEST");               
            }
            
            
            //Instanciamos el objeto que nos trae las listas de precios
            Bancos banco = new Bancos(oConn, varSesiones, request);
            banco.getCta_bcos().setFieldInt("MCB_ID", intMCB_ID);
            if (intMCB_ID != 0) {
               banco.Init();
            } else {
               banco.getCta_bcos().setFieldInt("ID_USUARIOS", varSesiones.getIntNoUser());
            }
            banco.getCta_bcos().setFieldInt("BC_ID", intBco);
            banco.getCta_bcos().setFieldInt("SC_ID", intSuc);
            banco.getCta_bcos().setFieldInt("MCB_CONCILIADO", intConciliado);
            banco.getCta_bcos().setFieldInt("MCB_TIPO1", intNoIdentificado);
            banco.getCta_bcos().setFieldInt("MCB_TIPO2", intEntregaDoc);
            banco.getCta_bcos().setFieldInt("MCB_TIPO3", intBandera3);
            banco.getCta_bcos().setFieldString("MCB_FECHA", strFecha);
            banco.getCta_bcos().setFieldDouble("MCB_DEPOSITO", dblMCB_DEPOSITO);
            banco.getCta_bcos().setFieldDouble("MCB_RETIRO", dblMCB_RETIRO);
            banco.getCta_bcos().setFieldString("MCB_CONCEPTO", strMCB_CONCEPTO);
            banco.getCta_bcos().setFieldString("MCB_BENEFICIARIO", strMCB_BENEFICIARIO);
            banco.getCta_bcos().setFieldString("MCB_NOCHEQUE", strMCB_NOCHEQUE);
            banco.getCta_bcos().setFieldString("MCB_FECENTREGADOC", strFechaEntrega);
            banco.getCta_bcos().setFieldString("MCB_NOTAS_ENT", strNotas);
            banco.getCta_bcos().setFieldInt("MCB_MONEDA", intMoneda);
            banco.getCta_bcos().setFieldDouble("MCB_PARIDAD", dblParidad);
            
            
            //NUEVOS CAMPOS PARA EL TRASPASO
            banco.getCta_bcos().setFieldInt("MCB_TRASPASO", intMCB_TRASPASO);
            banco.getCta_bcos().setFieldInt("BC_ID2", intBco2);
            banco.getCta_bcos().setFieldDouble("MCB_PARIDAD2", dblParidad2);
            banco.getCta_bcos().setFieldInt("MCB_TRAS_ORIGEN", intMCB_TRAS_ORIGEN);
            banco.getCta_bcos().setFieldString("RBK_CVE", strBcoDestino);
            banco.getCta_bcos().setFieldString("MCB_CTA_DESTINO", strCtaBeneficiario);
            banco.getCta_bcos().setFieldString("MCB_RFCBENEFICIARIO", strRFCBeneficiario);
            banco.getCta_bcos().setFieldInt("MCB_ES_TRASPASO", intEsTransferencia);
            
            
            
            //Validamos si tenemos un empresa seleccionada
            if (varSesiones.getIntIdEmpresa() != 0) {
               //Asignamos la empresa seleccionada
               banco.getCta_bcos().setFieldInt("EMP_ID", varSesiones.getIntIdEmpresa());
            }
            //Validamos si es un devolucion de proveedores
            if (intId_AnticipoProv != 0) {
               banco.setIntIdAnticipDevProv(intId_AnticipoProv);
               banco.setDblAnticipoImporteDevolver(dblIMPORTE_DEVOLVER);
            }
            if (intId_AnticipoClie != 0) {
               banco.setIntIdAnticipDevClie(intId_AnticipoClie);
               banco.setDblAnticipoImporteDevolver(dblIMPORTE_DEVOLVER_clie);            
            }
            banco.getCta_bcos().setFieldDouble("MCB_PARIDAD_DEV", dblTASA_CAMBIO);
            //Recibimos las partidas del movimiento de bancos
            //Recuperamos los pagos que se van a guardar
            String[] lstGT_ID = request.getParameterValues("GT_ID");
            String[] lstCC_ID = request.getParameterValues("CC_ID");
            String[] lstMCBD_CONCEPTO = request.getParameterValues("MCBD_CONCEPTO");
            String[] lstMCBD_IMPORTE = request.getParameterValues("MCBD_IMPORTE");
            for (int i = 0; i < lstMCBD_IMPORTE.length; i++) {
               //Recuperamos el id de gatos
               int intGT_ID = Integer.valueOf(lstGT_ID[i]);
               //Recuperamos el id de centro de costos
               int intCC_ID = Integer.valueOf(lstCC_ID[i]);
               //Recuperamos el importe por el concepto
               double dblMCBD_IMPORTE = Double.valueOf(lstMCBD_IMPORTE[i]);
               String strMCBD_CONCEPTO = lstMCBD_CONCEPTO[i];
               //Anexamos el detalle
               vta_mov_cta_bcos_deta movdeta = new vta_mov_cta_bcos_deta();
               movdeta.setFieldInt("GT_ID", intGT_ID);
               movdeta.setFieldInt("CC_ID", intCC_ID);
               movdeta.setFieldDouble("MCBD_IMPORTE", dblMCBD_IMPORTE);
               movdeta.setFieldString("MCBD_CONCEPTO", strMCBD_CONCEPTO);
               banco.AddDetalle(movdeta);
            }
            if (intMCB_ID != 0) {
               banco.doTrxMod();
            } else {
               banco.doTrx();
            }
            String strRes = "";
            if (banco.getStrResultLast().equals("OK")) {
               strRes = "OK." + banco.getCta_bcos().getValorKey();
            } else {
               strRes = banco.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Anula el MOVIMIENTO del banco
         if (strid.equals("2")) {
            int intMCB_ID = 0;
            //Recibimos el id del pago por cancelar
            if (request.getParameter("MCB_ID") != null) {
               try {
                  intMCB_ID = Integer.valueOf(request.getParameter("MCB_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Bancos banco = new Bancos(oConn, varSesiones, request);
            banco.getCta_bcos().setFieldInt("MCB_ID", intMCB_ID);
            //Inicializamos objeto
            banco.Init();
            banco.doTrxAnul();
            String strRes = "";
            if (banco.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = banco.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //realiza el MOVIMIENTO de conciliacion
         if (strid.equals("3")) {
            int intMCB_ID = 0;
            //Recibimos el id del movimiento por cancelar
            if (request.getParameter("MCB_ID") != null) {
               try {
                  intMCB_ID = Integer.valueOf(request.getParameter("MCB_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Recibimos si marcamos conciliado o no
            boolean bolConcilia = false;
            if (request.getParameter("MCB_CONCILIADO") != null) {
               try {
                  bolConcilia = Boolean.valueOf(request.getParameter("MCB_CONCILIADO"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Bancos banco = new Bancos(oConn, varSesiones, request);
            banco.getCta_bcos().setFieldInt("MCB_ID", intMCB_ID);
            //Inicializamos objeto
            banco.Init();
            banco.doConcilia(bolConcilia);
            String strRes = "";
            if (banco.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = banco.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //Obtiene los datos del MOVIMIENTO de banco
         //Para la edicion del mismo
         if (strid.equals("4")) {
            int intMCB_ID = 0;
            //Recibimos el id del movimiento por cancelar
            if (request.getParameter("MCB_ID") != null) {
               try {
                  intMCB_ID = Integer.valueOf(request.getParameter("MCB_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Bancos banco = new Bancos(oConn, varSesiones, request);
            banco.getCta_bcos().setFieldInt("MCB_ID", intMCB_ID);
            //Inicializamos objeto
            banco.Init();
            String strXML = banco.getXMLMovimiento();
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }
         //realiza el MOVIMIENTO de entrega de documentacion
         if (strid.equals("5")) {
            int intMCB_ID = 0;
            //Recibimos el id del movimiento por cancelar
            if (request.getParameter("MCB_ID") != null) {
               try {
                  intMCB_ID = Integer.valueOf(request.getParameter("MCB_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Recibimos si marcamos conciliado o no
            boolean bolEntrega = false;
            if (request.getParameter("MCB_TIPO2") != null) {
               try {
                  bolEntrega = Boolean.valueOf(request.getParameter("MCB_TIPO2"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Bancos banco = new Bancos(oConn, varSesiones, request);
            banco.getCta_bcos().setFieldInt("MCB_ID", intMCB_ID);
            //Inicializamos objeto
            banco.Init();
            banco.doEntrega(bolEntrega);
            String strRes = "";
            if (banco.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = banco.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //realiza el MOVIMIENTO de ststus3
         if (strid.equals("6")) {
            int intMCB_ID = 0;
            //Recibimos el id del movimiento por cancelar
            if (request.getParameter("MCB_ID") != null) {
               try {
                  intMCB_ID = Integer.valueOf(request.getParameter("MCB_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Recibimos si marcamos conciliado o no
            boolean bolStatus3 = false;
            if (request.getParameter("MCB_TIPO3") != null) {
               try {
                  bolStatus3 = Boolean.valueOf(request.getParameter("MCB_TIPO3"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Bancos banco = new Bancos(oConn, varSesiones, request);
            banco.getCta_bcos().setFieldInt("MCB_ID", intMCB_ID);
            //Inicializamos objeto
            banco.Init();
            banco.doStatus3(bolStatus3);
            String strRes = "";
            if (banco.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = banco.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
         //cambia el status a si del deposito no identificado
         if (strid.equals("7")) {
            int intMCB_ID = 0;
            //Recibimos el id del movimiento por cancelar
            if (request.getParameter("MCB_ID") != null) {
               try {
                  intMCB_ID = Integer.valueOf(request.getParameter("MCB_ID"));
               } catch (NumberFormatException ex) {
               }
            }
            //Recibimos si marcamos conciliado o no
            boolean bolDeposito = false;
            if (request.getParameter("MCB_TIPO1") != null) {
               try {
                  bolDeposito = Boolean.valueOf(request.getParameter("MCB_TIPO1"));
               } catch (NumberFormatException ex) {
               }
            }
            //Instanciamos el objeto que nos trae las listas de precios
            Bancos banco = new Bancos(oConn, varSesiones, request);
            banco.getCta_bcos().setFieldInt("MCB_ID", intMCB_ID);
            //Inicializamos objeto
            banco.Init();
            banco.doUsoDeposito(bolDeposito);
            String strRes = "";
            if (banco.getStrResultLast().equals("OK")) {
               strRes = "OK";
            } else {
               strRes = banco.getStrResultLast();
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(strRes);//Pintamos el resultado
         }
      }
   } else {
   }
   oConn.close();
%>