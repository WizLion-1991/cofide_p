<%-- 
    Document   : testNoProduction
      Este jsp esta prohibido usarlo en produccion, aqui podremos ejecutar clases que solucionen o corrijan datos
    Created on : 13-jul-2013, 16:24:29
    Author     : ZeusGalindo
--%>



<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.util.Date"%>

<%@page import="Core.FirmasElectronicas.Addendas.SATAddendaSanofi"%>
<%@page import="java.sql.SQLException"%>
<%@page import="javax.crypto.BadPaddingException"%>
<%@page import="javax.crypto.IllegalBlockSizeException"%>
<%@page import="java.security.InvalidKeyException"%>
<%@page import="javax.crypto.NoSuchPaddingException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="Core.FirmasElectronicas.Opalina"%>
<%@page import="ERP.Ticket"%>
<%@page import="Core.FirmasElectronicas.SATXml3_0"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.reportes.ReporteVentasDetalle"%>
<%@page import="ERP.ProductosLoteRepair"%>
<%@page import="ERP.GeneraFolios"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="com.mx.siweb.prosefi.Credito"%>
<%@page import="comSIWeb.Utilerias.DigitoVerificador"%>
<%@page import="com.mx.siweb.mlm.utilerias.Redes"%>
<%@page import="ERP.Importar"%>
<%@page import="ERP.Pedimentos"%>/WEB-INF/classes/Tablas/
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="ERP.Paridades"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
            //Mail mail = new Mail();
         //mail.RecibirMail("pop.fibonacciworld.com","oficinavirtual@fibonacciworld.com", "100%exito");
         String strsmtp_server = "192.168.2.242";
         String strsmtp_user = "facturacion@cofide.org";
         String strsmtp_pass = "Fct.C0f1d3.6464#";
         String strsmtp_port = "465";
         String strsmtp_usaTLS = "1";
         String strsmtp_usaSTLS = "0";
           Mail mail = new Mail();
         //mail.setBolDepuracion(true);
         mail.setUsuario(strsmtp_user);
         mail.setContrasenia(strsmtp_pass);
         mail.setHost(strsmtp_server);
         mail.setPuerto(strsmtp_port);
         mail.setAsunto("SiWeb.Ventas.Mensaje de prueba");
         mail.setDestino(strsmtp_user);
         mail.setMensaje("<b>Esta es una prueba</b> de envio de mail");
         if(strsmtp_usaTLS.equals("1"))mail.setBolUsaTls(true);
         if(strsmtp_usaSTLS.equals("1"))mail.setBolUsaStartTls(true);
         mail.setBolDepuracion(true);
         boolean bol = mail.sendMail();
         System.out.println("bol:" + bol + " " + mail.getErrMsg());
         System.out.println("server:" + strsmtp_server);
         System.out.println("smtp_user:" + strsmtp_user);
         System.out.println("smtp_pass:*******");
         System.out.println("smtp_port:" + strsmtp_port);
   oConn.close();
%>
