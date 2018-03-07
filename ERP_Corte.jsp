<%-- 
    Document   : ERP_Corte
    Este jsp se encarga de realizar las peticiones sobre el corte de caja
    Created on : 9/08/2010, 10:11:40 PM
    Author     : zeus
--%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Utilerias.Fechas" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="comSIWeb.Operaciones.TableMaster" %>
<%@ page import="Tablas.vta_cortecaja" %>
<%@ page import="ERP.CorteCaja" %>
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
               int intSuc = 0;
               if (request.getParameter("CCA_SUCURSAL") != null) {
                  intSuc = Integer.valueOf(request.getParameter("CCA_SUCURSAL"));
               }
               int intTurno = 0;
               if (request.getParameter("CCA_TURNO") != null) {
                  intTurno = Integer.valueOf(request.getParameter("CCA_TURNO"));
               }
               //Recuperamos el tipo de transaccion
               String strFecha = "";
               if (request.getParameter("CCA_FECHA") != null) {
                  strFecha = request.getParameter("CCA_FECHA");
                  strFecha = fecha.FormateaBD(strFecha, "/");
               }
               //Recuperamos los importes
               double dblCCA_EFECT = 0;
               if (request.getParameter("CCA_EFECT") != null) {
                  dblCCA_EFECT = Double.valueOf(request.getParameter("CCA_EFECT"));
               }
               double dblCCA_CHEQ = 0;
               if (request.getParameter("CCA_CHEQ") != null) {
                  dblCCA_CHEQ = Double.valueOf(request.getParameter("CCA_CHEQ"));
               }
               double dblCCA_TC = 0;
               if (request.getParameter("CCA_TC") != null) {
                  dblCCA_TC = Double.valueOf(request.getParameter("CCA_TC"));
               }
               double dblCCA_SALDO = 0;
               if (request.getParameter("CCA_SALDO") != null) {
                  dblCCA_SALDO = Double.valueOf(request.getParameter("CCA_SALDO"));
               }
               //Instanciamos el objeto que nos trae las listas de precios
               CorteCaja corte  = new CorteCaja(oConn, varSesiones, request);
               corte.getCorte().setFieldInt("SC_ID", intSuc);
               corte.getCorte().setFieldInt("CCJ_TURNO", intTurno);
               corte.getCorte().setFieldString("CCJ_FECHA", strFecha);
               corte.getCorte().setFieldDouble("CCJ_EFECTIVO", dblCCA_EFECT);
               corte.getCorte().setFieldDouble("CCJ_CHEQUE", dblCCA_CHEQ);
               corte.getCorte().setFieldDouble("CCJ_TC", dblCCA_TC);
               corte.getCorte().setFieldDouble("CCJ_SALDO", dblCCA_SALDO);
               corte.doTrx();
               String strRes = "";
               if (corte.getStrResultLast().equals("OK")) {
                  strRes = "OK." + corte.getCorte().getValorKey();
               } else {
                  strRes = corte.getStrResultLast();
               }
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println(strRes);//Pintamos el resultado
            }
            //Anula el corte de caja
            if (strid.equals("2")) {
               int intCCJ_ID = 0;
               //Recibimos el id del pago por cancelar
               if (request.getParameter("CCJ_ID") != null) {
                  try {
                     intCCJ_ID = Integer.valueOf(request.getParameter("CCJ_ID"));
                  } catch (NumberFormatException ex) {
                  }
               }
               //Instanciamos el objeto que nos trae las listas de precios
               CorteCaja corte  = new CorteCaja(oConn, varSesiones, request);
               corte.getCorte().setFieldInt("CCJ_ID", intCCJ_ID);
               //Inicializamos objeto
               corte.Init();
               corte.doTrxAnul();
               String strRes = "";
               if (corte.getStrResultLast().equals("OK")) {
                  strRes = "OK";
               } else {
                  strRes = corte.getStrResultLast();
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