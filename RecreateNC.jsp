<%-- 
    Document   : testMemory
    Created on : 19/05/2009, 10:49:10 AM
    Author     : zeus
--%>
<%@page import="javax.crypto.BadPaddingException"%>
<%@page import="javax.crypto.IllegalBlockSizeException"%>
<%@page import="java.security.InvalidKeyException"%>
<%@page import="javax.crypto.NoSuchPaddingException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="Core.FirmasElectronicas.Opalina"%>
<%@page import="Core.FirmasElectronicas.SATXml"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
      /*Obtenemos las variables de sesion*/
      VariableSession varSesiones = new VariableSession(request);
      varSesiones.getVars();
      //Abrimos la conexion
      Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
      oConn.open();
      //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
      Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
      if (varSesiones.getIntNoUser() == 0) {
         //Recuperamos paths de web.xml
         String strPathXML = this.getServletContext().getInitParameter("PathXml");
         String strfolio_GLOBAL = this.getServletContext().getInitParameter("folio_GLOBAL");
         String strmod_Inventarios = this.getServletContext().getInitParameter("mod_Inventarios");
         String strPathPrivateKeys = this.getServletContext().getInitParameter("PathPrivateKey");
         String strPathFonts = this.getServletContext().getRealPath("/") + System.getProperty("file.separator") + "fonts";
         String strMyPassSecret = "";
         if (strfolio_GLOBAL == null) {
            strfolio_GLOBAL = "SI";
         }
         if (strmod_Inventarios == null) {
            strmod_Inventarios = "NO";
         }
         String strPassB64 = "";
         try {
            strPassB64 = this.getServletContext().getInitParameter("SecretWord");
            Opalina opa = new Opalina();
            strMyPassSecret = opa.DesEncripta(strPassB64, "dWAM1YhbGAeu7CTULai4eQ==");
         } catch (NoSuchAlgorithmException ex) {
            System.out.println("getPass:" + ex.getMessage());
         } catch (NoSuchPaddingException ex) {
            System.out.println("getPass:" + ex.getMessage());
         } catch (InvalidKeyException ex) {
            System.out.println("getPass:" + ex.getMessage());
         } catch (IllegalBlockSizeException ex) {
            System.out.println("getPass:" + ex.getMessage());
         } catch (BadPaddingException ex) {
            System.out.println("getPass:" + ex.getMessage());
         }

         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, false, false);//Definimos atributos para el XML
         String strSql = "SELECT NC_ID,EMP_ID,NC_NOAPROB,NC_FECHAAPROB FROM vta_ncredito where NC_ID>=73";
         ResultSet rs = oConn.runQuery(strSql);
         while (rs.next()) {
            int intFacId = rs.getInt("NC_ID");
            int intEMP_ID = rs.getInt("EMP_ID");
            String strNoAprob = rs.getString("NC_NOAPROB");
            String strFechaAprob = rs.getString("NC_FECHAAPROB");

            //Parametros de la empresa
            String strNoSerieCert = "";
            String strNomKey = "";
            String strNomCert = "";
            String strPassKey = "";

            //Obtenemos datos de la empresa
            //VERSION WEB
            strSql = "SELECT EMP_NOAPROB,EMP_FECHAPROB,EMP_NOSERIECERT,EMP_TIPOCOMP,"
                    + "EMP_NOMKEY,EMP_TIPOPERS,EMP_USECONTA,EMP_CTAVTA,EMP_CTAIVA,EMP_CTACTE,"
                    + "AES_DECRYPT(EMP_PASSKEY, '" + strMyPassSecret + "') AS unencrypted,"
                    + "EMP_FIRMA,EMP_PASSCP,EMP_USERCP,EMP_USACODBARR,EMP_NOMCERT "
                    + "FROM vta_empresas "
                    + "WHERE EMP_ID = " + intEMP_ID + "";
            try {
               ResultSet rs2 = oConn.runQuery(strSql, true);
               while (rs2.next()) {
                     strNoSerieCert = rs2.getString("EMP_NOSERIECERT");
                     strNomKey = rs2.getString("EMP_NOMKEY");
                     strPassKey = rs2.getString("unencrypted");
                     strNomCert = rs2.getString("EMP_NOMCERT");
               }
               rs2.close();
            } catch (SQLException ex) {
               ex.fillInStackTrace();
            }
            //Regeneramos el CFD
            SATXml SAT = new SATXml(intFacId, strPathXML,
                    strNoAprob, strFechaAprob, strNoSerieCert,
                    strPathPrivateKeys + "/" + strNomKey, strPassKey, varSesiones,
                    oConn);
            SAT.setBolSendMailMasivo(false);
            SAT.setBolEsNc(true);
            if(!strNomCert.isEmpty())SAT.setStrPathCert(strPathPrivateKeys + "/" + strNomCert);
            String strRes = SAT.GeneraXml();
            out.println("Regeneramos la nota de credito... " + intFacId + " " + strRes +  " <br>");
         }
         rs.close();
      } else {
      }
      oConn.close();
%>