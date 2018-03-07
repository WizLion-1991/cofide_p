<%-- 
    Document   :JSP que se encarga de haver el envio de mail a los clientes
    Created on :
    Author     : Soluciones
--%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Tablas.cuenta_contratada"%>
<%@page import="ERP.MailMasivo"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>

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
      //Si la peticion no fue nula proseguimos
      if (strid != null) {

         if (strid.equals("1")) {
            int intCT_ID = 0;
            int intSC_ID = 0;
            int intCat1 = 0;
            int intCat2 = 0;
            int intCat3 = 0;
            int intCat4 = 0;
            int intCat5 = 0;
            try {
               if (request.getParameter("CT_ID") != null) {
                  intCT_ID = Integer.parseInt(request.getParameter("CT_ID"));
               } else {
                  intCT_ID = 0;
               }
            } catch (NumberFormatException ex) {
               System.out.println("vta_mailmasivo CT_ID: " + ex.getMessage());
            }
            intSC_ID = Integer.parseInt(request.getParameter("SC_ID"));
            System.out.println("SC_ID: " + intSC_ID);
            intCat1 = Integer.parseInt(request.getParameter("CT_CATEGORIA1"));
            intCat2 = Integer.parseInt(request.getParameter("CT_CATEGORIA2"));
            intCat3 = Integer.parseInt(request.getParameter("CT_CATEGORIA3"));
            intCat4 = Integer.parseInt(request.getParameter("CT_CATEGORIA4"));
            intCat5 = Integer.parseInt(request.getParameter("CT_CATEGORIA5"));

            String strEsta = request.getParameter("CT_ESTADO");

            MailMasivo cliente = new MailMasivo();
            String strXML = cliente.generaXML(oConn, intCT_ID, strEsta, intSC_ID, intCat1, intCat2, intCat3, intCat4, intCat5);
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

         if (strid.equals("2")) {

            //Respuesta del servicio
            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<vta_mails>";
            //Cargamos datos del mail
            cuenta_contratada miCuenta = new cuenta_contratada();
            miCuenta.ObtenDatos(1, oConn);
            //Recibimos parametros
            String strlstCT_ID = request.getParameter("CT_ID");
            String strVIEW_COPIA = request.getParameter("VIEW_COPIA");
            String strVIEW_ASUNTO = request.getParameter("VIEW_ASUNTO");
            String strVIEW_MAIL = request.getParameter("VIEW_MAIL");

            if (strVIEW_COPIA == null) {
               strVIEW_COPIA = "";
            }
            //se validan los datos del mail de la cuenta
            //Validamos que todos los datos del mail esten completos
            if (!miCuenta.getFieldString("smtp_server").equals("")
                    && !miCuenta.getFieldString("smtp_user").equals("")
                    && !miCuenta.getFieldString("smtp_pass").equals("")
                    && !miCuenta.getFieldString("smtp_port").equals("")) {
               //separamos el id del cliente
               String[] lstCliente = strlstCT_ID.split(",");
               for (int i = 0; i < lstCliente.length; i++) {
                  System.out.println(i + ":" + lstCliente[i]);
                  //Recuperamos el id de cada cliente
                  int intCCT_ID = 0;
                  try {
                     intCCT_ID = Integer.valueOf(lstCliente[i]);
                  } catch (NumberFormatException ex) {
                  }

                  String strResp = "OK";
                  String strCode = "OK";
                  //Buscamos si EL CLIENTE tiene mail
                  String strMailCte = "";
                  String strMailCte2 = "";
                  String strSql = "select CT_EMAIL1,CT_EMAIL2 from vta_cliente where CT_ID =  " + intCCT_ID;
                  ResultSet rs = oConn.runQuery(strSql, true);
                  //Buscamos el nombre del archivo
                  while (rs.next()) {
                     strMailCte = rs.getString("CT_EMAIL1");
                     strMailCte2 = rs.getString("CT_EMAIL2");
                  }
                  rs.close();

                  //Si el cliente tiene mail lo enviamos
                  if (!strMailCte.equals("") || !strVIEW_COPIA.equals("")) {
                     //Mail personalizado
                     String strMailOK = new String(strVIEW_MAIL);
                     String strMailASOK = new String(strVIEW_ASUNTO);

                     //Lista de correo alos que se los enviaremos
                     String strEmailSend = "";
                     if (!strMailCte.equals("")) {
                        strEmailSend = strMailCte;
                     }
                     if (!strVIEW_COPIA.equals("")) {
                        if (!strMailCte.equals("")) {
                           strEmailSend += ",";
                        }
                        strEmailSend += strVIEW_COPIA;
                     }

                     //Mandamos el mail
                     Mail mail = new Mail();
                     mail.setBolDepuracion(false);
                     if (miCuenta.getFieldInt("SMTP_USATLS") == 1) {
                        mail.setBolUsaTls(true);
                     }
                     if (miCuenta.getFieldInt("SMTP_USASTLS") == 1) {
                        mail.setBolUsaStartTls(true);
                     }
                     mail.setHost(miCuenta.getFieldString("smtp_server"));
                     mail.setUsuario(miCuenta.getFieldString("smtp_user"));
                     mail.setContrasenia(miCuenta.getFieldString("smtp_pass"));
                     mail.setPuerto(miCuenta.getFieldString("smtp_port"));
                     //Adjuntamos archivos

                     mail.setAsunto(strMailASOK);
                     //Preparamos el mail
                     mail.setDestino(strEmailSend);
                     mail.setMensaje(strMailOK);
                     //Enviamos el mail
                     boolean bol = mail.sendMail();//
                     if (!bol) {
                        strResp = "NO SE PUDO ENVIAR EL MAIL.";
                     }
                  } else {
                     strResp = "NO EXISTEN MAILS.";
                  }
                  strXML += "<vta_mail id=\"" + intCCT_ID + "\" code=\"" + strCode + "\" res=\"" + strResp + "\" />";
               }
            }

            strXML += "</vta_mails>";
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);
         } else {
         }
      }
   }
   oConn.close();
%>