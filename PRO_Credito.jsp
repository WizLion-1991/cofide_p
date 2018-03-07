<%-- 
    Document   : credito
    Created on : 26/03/2013, 11:27:09 AM
    Author     : SIWEB
--%>


<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.lang.String"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.prosefi.Credito"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.CIP_Tabla" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad Cra no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        Fechas fecha = new Fechas();
        String strid = request.getParameter("ID");
        if (strid != null) {
            if (strid.equals("1")) {
                Credito objCredito = new Credito();
                //Credito objCredito = new Credito();
                int intCTO_ID = 0;
                //OBTENEMOS VALORES
                String CTO_ID = request.getParameter("CTO_ID");
                if (!CTO_ID.equals(null) && !CTO_ID.equals("")) {
                    intCTO_ID = Integer.parseInt(CTO_ID);
                }
                String CTO_NREFERENCIA = request.getParameter("CTO_NREFERENCIA");
                String SS_ID = request.getParameter("SS_ID");
                String F_ID = request.getParameter("F_ID");
                String CTO_FECHA = request.getParameter("CTO_FECHA");
                String CTO_NCUENTA = request.getParameter("CTO_NCUENTA");
                String TO_ID = request.getParameter("TO_ID");
                String IM_ID = request.getParameter("IM_ID");
                String MTO_ID = request.getParameter("MTO_ID");
                String TC_ID = request.getParameter("TC_ID");                
                String M_ID = request.getParameter("M_ID");
                //String SPC_ID = request.getParameter("SPC_ID");
                String CTO_HORA = request.getParameter("CTO_HORA");
                String CTO_NIC = request.getParameter("CTO_NIC");
                //String CTO_PCREDITO = request.getParameter("CTO_PCREDITO");
                //String CT0_FAPERTURA = request.getParameter("CT0_FAPERTURA");
                //String CT0_FVENCIMIENTO = request.getParameter("CT0_FVENCIMIENTO");
                String CT0_PPPERIODO = request.getParameter("CT0_PPPERIODO");
                //String CTO_SALDO = request.getParameter("CTO_SALDO");
                String CT_NOM = request.getParameter("CT_NOM");
                String F_NOM = request.getParameter("F_NOM");
                String CT_ID = request.getParameter("CT_ID");

                objCredito.getObjCredito().setFieldInt("CTO_ID", intCTO_ID);

                objCredito.getObjCredito().setFieldString("CTO_NREFERENCIA", CTO_NREFERENCIA);
                objCredito.getObjCredito().setFieldString("SS_ID", SS_ID);
                objCredito.getObjCredito().setFieldString("F_ID", F_ID);
                objCredito.getObjCredito().setFieldString("CTO_FECHA", CTO_FECHA);
                objCredito.getObjCredito().setFieldString("CTO_NCUENTA", CTO_NCUENTA);
                objCredito.getObjCredito().setFieldString("TO_ID", TO_ID);
                objCredito.getObjCredito().setFieldString("IM_ID", IM_ID);
                objCredito.getObjCredito().setFieldString("MTO_ID", MTO_ID);
                objCredito.getObjCredito().setFieldString("TC_ID", TC_ID);                
                objCredito.getObjCredito().setFieldString("M_ID", M_ID);
                //objCredito.getObjCredito().setFieldString("SPC_ID", SPC_ID);
                objCredito.getObjCredito().setFieldString("CTO_HORA", CTO_HORA);
                objCredito.getObjCredito().setFieldString("CTO_NIC", CTO_NIC);
                //objCredito.getObjCredito().setFieldString("CTO_PCREDITO", CTO_PCREDITO);
                objCredito.getObjCredito().setFieldString("CT0_FAPERTURA", fecha.FormateaBD(request.getParameter("CT0_FAPERTURA"), "/"));
                //objCredito.getObjCredito().setFieldString("CT0_FAPERTURA", CT0_FAPERTURA);
                objCredito.getObjCredito().setFieldString("CT0_FVENCIMIENTO", fecha.FormateaBD(request.getParameter("CT0_FVENCIMIENTO"), "/"));
                //objCredito.getObjCredito().setFieldString("CT0_FVENCIMIENTO", CT0_FVENCIMIENTO);
                objCredito.getObjCredito().setFieldString("CT0_PPPERIODO", CT0_PPPERIODO);
                //objCredito.getObjCredito().setFieldString("CTO_SALDO", CTO_SALDO);               
                objCredito.getObjCredito().setFieldString("CT_NOM", CT_NOM);
                objCredito.getObjCredito().setFieldString("F_NOM", F_NOM);
                //ACABO DE MOVER ESTA LINEA
                objCredito.getObjCredito().setFieldString("CT_ID", CT_ID);



                String OB_RAZONSOCIAL = request.getParameter("OB_RAZONSOCIAL");
                String OB_RFC = request.getParameter("OB_RFC");
                String OB_CALLE = request.getParameter("OB_CALLE");
                String OB_NUMERO = request.getParameter("OB_NUMERO");
                String OB_NUMEROIN = request.getParameter("OB_NUMEROIN");
                String OB_COLONIA = request.getParameter("OB_COLONIA");
                String OB_LOCALIDAD = request.getParameter("OB_LOCALIDAD");
                String OB_MUNICIPIO = request.getParameter("OB_MUNICIPIO");
                String OB_ESTADO = request.getParameter("OB_ESTADO");
                String OB_CP = request.getParameter("OB_CP");
                String OB_TELEFONO1 = request.getParameter("OB_TELEFONO1");
                String OB_TELEFONO2 = request.getParameter("OB_TELEFONO2");
                String OB_CONTACTO1 = request.getParameter("OB_CONTACTO1");
                String OB_CONTACTO2 = request.getParameter("OB_CONTACTO2");
                String OB_EMAIL1 = request.getParameter("OB_EMAIL1");
                String OB_EMAIL2 = request.getParameter("OB_EMAIL2");


                objCredito.getObjObligado().setFieldString("OB_RAZONSOCIAL", OB_RAZONSOCIAL);
                objCredito.getObjObligado().setFieldString("OB_RFC", OB_RFC);
                objCredito.getObjObligado().setFieldString("OB_CALLE", OB_CALLE);
                objCredito.getObjObligado().setFieldString("OB_NUMERO", OB_NUMERO);
                objCredito.getObjObligado().setFieldString("OB_NUMEROIN", OB_NUMEROIN);
                objCredito.getObjObligado().setFieldString("OB_COLONIA", OB_COLONIA);
                objCredito.getObjObligado().setFieldString("OB_LOCALIDAD", OB_LOCALIDAD);
                objCredito.getObjObligado().setFieldString("OB_MUNICIPIO", OB_MUNICIPIO);
                objCredito.getObjObligado().setFieldString("OB_ESTADO", OB_ESTADO);
                objCredito.getObjObligado().setFieldString("OB_CP", OB_CP);
                objCredito.getObjObligado().setFieldString("OB_TELEFONO1", OB_TELEFONO1);
                objCredito.getObjObligado().setFieldString("OB_TELEFONO2", OB_TELEFONO2);
                objCredito.getObjObligado().setFieldString("OB_CONTACTO1", OB_CONTACTO1);
                objCredito.getObjObligado().setFieldString("OB_CONTACTO2", OB_CONTACTO2);
                objCredito.getObjObligado().setFieldString("OB_EMAIL1", OB_EMAIL1);
                objCredito.getObjObligado().setFieldString("OB_EMAIL2", OB_EMAIL2);
                objCredito.getObjObligado().setFieldString("CTO_ID", CTO_ID);

                String strRes1 = objCredito.agrega(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos Para el XML               
                out.println(strRes1);//Pintamos el resultado  


                bitacorausers logUser = new bitacorausers();
                logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                logUser.setFieldString("BTU_NOMMOD", "CREDITO");
                logUser.setFieldString("BTU_NOMACTION", "ALTA");
                logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                String strRes = logUser.Agrega(oConn);
                String strResultLast = "";
                if (!strRes.equals("OK")) {
                    strResultLast = strRes;
                }

            }



            if (strid.equals("2")) {
                Credito objCredito = new Credito();
                //OBTENEMOS VALORES
                String CTO_ID = request.getParameter("CTO_ID");
                String CTO_NREFERENCIA = request.getParameter("CTO_NREFERENCIA");
                String SS_ID = request.getParameter("SS_ID");
                String F_ID = request.getParameter("F_ID");
                String CTO_FECHA = request.getParameter("CTO_FECHA");
                String CTO_NCUENTA = request.getParameter("CTO_NCUENTA");
                String TO_ID = request.getParameter("TO_ID");
                String IM_ID = request.getParameter("IM_ID");
                String MTO_ID = request.getParameter("MTO_ID");
                String TC_ID = request.getParameter("TC_ID");                
                String M_ID = request.getParameter("M_ID");
                //String SPC_ID = request.getParameter("SPC_ID");
                String CTO_HORA = request.getParameter("CTO_HORA");
                String CTO_NIC = request.getParameter("CTO_NIC");
                //String CTO_PCREDITO = request.getParameter("CTO_PCREDITO");
                //String CT0_FAPERTURA = request.getParameter("CT0_FAPERTURA");
                objCredito.getObjCredito().setFieldString("CT0_FAPERTURA", fecha.FormateaBD(request.getParameter("CT0_FAPERTURA"), "/"));
                //String CT0_FVENCIMIENTO = request.getParameter("CT0_FVENCIMIENTO");
                objCredito.getObjCredito().setFieldString("CT0_FVENCIMIENTO", fecha.FormateaBD(request.getParameter("CT0_FVENCIMIENTO"), "/"));
                String CT0_PPPERIODO = request.getParameter("CT0_PPPERIODO");
                //String CTO_SALDO = request.getParameter("CTO_SALDO");
                String CT_NOM = request.getParameter("CT_NOM");
                String F_NOM = request.getParameter("F_NOM");
                String CT_ID = request.getParameter("CT_ID");

                objCredito.getObjCredito().setFieldString("CTO_ID", CTO_ID);
                objCredito.getObjCredito().setFieldString("CTO_NREFERENCIA", CTO_NREFERENCIA);
                objCredito.getObjCredito().setFieldString("SS_ID", SS_ID);
                objCredito.getObjCredito().setFieldString("F_ID", F_ID);
                objCredito.getObjCredito().setFieldString("CTO_FECHA", CTO_FECHA);
                objCredito.getObjCredito().setFieldString("CTO_NCUENTA", CTO_NCUENTA);
                objCredito.getObjCredito().setFieldString("TO_ID", TO_ID);
                objCredito.getObjCredito().setFieldString("IM_ID", IM_ID);
                objCredito.getObjCredito().setFieldString("MTO_ID", MTO_ID);
                objCredito.getObjCredito().setFieldString("TC_ID", TC_ID);
                objCredito.getObjCredito().setFieldString("M_ID", M_ID);
                //objCredito.getObjCredito().setFieldString("SPC_ID", SPC_ID);
                objCredito.getObjCredito().setFieldString("CTO_HORA", CTO_HORA);
                objCredito.getObjCredito().setFieldString("CTO_NIC", CTO_NIC);
                //objCredito.getObjCredito().setFieldString("CTO_PCREDITO", CTO_PCREDITO);
                //objCredito.getObjCredito().setFieldString("CT0_FAPERTURA", CT0_FAPERTURA);
                //objCredito.getObjCredito().setFieldString("CT0_FVENCIMIENTO", CT0_FVENCIMIENTO);
                objCredito.getObjCredito().setFieldString("CT0_PPPERIODO", CT0_PPPERIODO);
                //objCredito.getObjCredito().setFieldString("CTO_SALDO", CTO_SALDO);               
                objCredito.getObjCredito().setFieldString("CT_NOM", CT_NOM);
                objCredito.getObjCredito().setFieldString("F_NOM", F_NOM);
                objCredito.getObjCredito().setFieldString("CT_ID", CT_ID);

                String strRazon = request.getParameter("OB_RAZONSOCIAL");
                String strRfc = request.getParameter("OB_RFC");
                String strCalle = request.getParameter("OB_CALLE");
                String strNumero = request.getParameter("OB_NUMERO");
                String strNumeroin = request.getParameter("OB_NUMEROIN");
                String strColonia = request.getParameter("OB_COLONIA");
                String strLocalidad = request.getParameter("OB_LOCALIDAD");
                String strMunicipo = request.getParameter("OB_MUNICIPIO");
                String strEstado = request.getParameter("OB_ESTADO");
                String strCodigop = request.getParameter("OB_CP");
                String strTelefono1 = request.getParameter("OB_TELEFONO1");
                String strTelefono2 = request.getParameter("OB_TELEFONO2");
                String strContacto1 = request.getParameter("OB_CONTACTO1");
                String strContacto2 = request.getParameter("OB_CONTACTO2");
                String strEmail1 = request.getParameter("OB_EMAIL1");
                String strEmail2 = request.getParameter("OB_EMAIL2");
                String strEdad = request.getParameter("OB_EDAD");
                String strN_id = request.getParameter("N_ID");
                String strEc_id = request.getParameter("EC_ID");
                String strRm_id = request.getParameter("RM_ID");
                String strNconyugue = request.getParameter("OB_NCONYUGUE");
                String strN_cid = request.getParameter("N_CID");
                String strCedad = request.getParameter("OB_CEDAD");
                String strCTO_ID = request.getParameter("CTO_ID");

                objCredito.getObjObligado().setFieldString("OB_RAZONSOCIAL", strRazon);
                objCredito.getObjObligado().setFieldString("OB_RFC", strRfc);
                objCredito.getObjObligado().setFieldString("OB_CALLE", strCalle);
                objCredito.getObjObligado().setFieldString("OB_NUMERO", strNumero);
                objCredito.getObjObligado().setFieldString("OB_NUMEROIN", strNumeroin);
                objCredito.getObjObligado().setFieldString("OB_COLONIA", strColonia);
                objCredito.getObjObligado().setFieldString("OB_LOCALIDAD", strLocalidad);
                objCredito.getObjObligado().setFieldString("OB_MUNICIPIO", strMunicipo);
                objCredito.getObjObligado().setFieldString("OB_ESTADO", strEstado);
                objCredito.getObjObligado().setFieldString("OB_CP", strCodigop);
                objCredito.getObjObligado().setFieldString("OB_TELEFONO1", strTelefono1);
                objCredito.getObjObligado().setFieldString("OB_TELEFONO2", strTelefono2);
                objCredito.getObjObligado().setFieldString("OB_CONTACTO1", strContacto1);
                objCredito.getObjObligado().setFieldString("OB_CONTACTO2", strContacto2);
                objCredito.getObjObligado().setFieldString("OB_EMAIL1", strEmail1);
                objCredito.getObjObligado().setFieldString("OB_EMAIL2", strEmail2);
                objCredito.getObjObligado().setFieldString("OB_EDAD", strEdad);
                objCredito.getObjObligado().setFieldString("N_ID", strN_id);
                objCredito.getObjObligado().setFieldString("EC_ID", strEc_id);
                objCredito.getObjObligado().setFieldString("RM_ID", strRm_id);
                objCredito.getObjObligado().setFieldString("OB_NCONYUGUE", strNconyugue);
                objCredito.getObjObligado().setFieldString("N_CID", strN_cid);
                objCredito.getObjObligado().setFieldString("OB_CEDAD", strCedad);
                objCredito.getObjCredito().setFieldString("CTO_ID", strCTO_ID);

                String strIdObligado = request.getParameter("CTO_ID");
                objCredito.getObjCredito().setFieldInt("CTO_ID", Integer.parseInt(strIdObligado));
               /* String strRes = objCredito.modifica(oConn, strIdObligado, strRazon, strRfc, strCalle,
                        strNumero, strNumeroin, strColonia, strLocalidad, strMunicipo, strEstado, strCodigop,
                        strTelefono1, strTelefono2, strContacto1, strContacto2, strEmail1, strEmail2);*/
                String strRes = objCredito.modifica(oConn, strIdObligado, strRazon, strRfc, strCalle, strNumero, 
                        strNumeroin, strColonia, strLocalidad, strMunicipo, strEstado, strCodigop, 
                        strTelefono1, strTelefono2, strContacto1, strContacto2, strEmail1, strEmail2, 
                        strEdad, strN_id, strEc_id, strRm_id, strNconyugue, strN_cid, strCedad);
                
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos Para el XML               
                out.println(strRes);//Pintamos el resultado  
                
                
                bitacorausers logUser = new bitacorausers();
                logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                logUser.setFieldString("BTU_NOMMOD", "CREDITO");
                logUser.setFieldString("BTU_NOMACTION", "MODIFICA");
                logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                String strRes1 = logUser.Agrega(oConn);
                String strResultLast = "";
                if (!strRes1.equals("OK")) {
                    strResultLast = strRes;
                }
                               
                
            }
            if (strid.equals("3")) {
                Credito objCredito = new Credito();
                String strID = request.getParameter("CTO_ID");
                objCredito.getObjCredito().setFieldInt("CTO_ID", Integer.parseInt(strID));
                String strRes = objCredito.elimina(oConn, strID);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
                
                bitacorausers logUser = new bitacorausers();
                logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                logUser.setFieldString("BTU_NOMMOD", "CREDITO");
                logUser.setFieldString("BTU_NOMACTION", "ELIMINA");
                logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                String strRes2 = logUser.Agrega(oConn);
                String strResultLast = "";
                if (!strRes2.equals("OK")) {
                    strResultLast = strRes;
                }                
                
            }

            if (strid.equals("4")) {
                //Credito objCredito = new Credito();
                Credito objCredito = new Credito();
                String strId = request.getParameter("CTO_ID");
                //String strRes = objCredito.getDatos(oConn, strID);
                String strRes = objCredito.getDatos(oConn, strId);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }

        }
    }
%>                              
