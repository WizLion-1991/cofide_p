<%-- 
    Document   : ecomm_car_payment_client_dr
    Created on : 12-sep-2014, 19:01:37
    Author     : ZeusGalindo
--%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="ERP.movCliente"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@ page contentType="text/html;charset=ISO-8859-1" language="java" %>
<%--

/*
--------------------------------------------------------------------------------

This example assumes that a form has been sent to this example with the
required fields. The example then processes the command and displays the
receipt or error to a HTML page in the users web browser.

*****
NOTE:
*****

  For jdk1.2, 1.3
  * Must have jsse.jar, jcert.jar and jnet.jar in your classpath
  * Best approach is to make them installed extensions -
    i.e. put them in the jre/lib/ext directory.

  For jdk1.4 (jsse is already part of default installation - should run fine)
--------------------------------------------------------------------------------

 @author TNS Pty Ltd

------------------------------------------------------------------------------*/

--%>
<%@ page import="java.util.List,
         java.util.ArrayList,
         java.util.Collections,
         java.util.Comparator,
         java.util.Iterator,
         java.util.Enumeration,
         java.util.Date,
         java.util.Map,
         java.net.URLEncoder,
         javax.crypto.*,
         javax.crypto.spec.*,
         java.security.*,
         java.math.BigInteger,
         java.util.HashMap"%>

<%! // Define Constants
   // ****************
    /* Note:
    ----
    In a proper production environment, only the retrieving of all the input
    parameters and the HTML output would be in this file. The following
    constants and all other methods would be contained in a separate helper
    class so that users could not gain access to these values. */
   // This is secret for encoding the SHA256 hash
   // This secret will vary from merchant to merchant
   static final String SECURE_SECRET = "3F606DC6B1102BBF11340B065A339A39";
   // This is an array for creating hex chars
   static final char[] HEX_TABLE = new char[]{
      '0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

//  ----------------------------------------------------------------------------
   /**
    * This method is for sorting the fields and creating a SHA256 secure hash.
    *
    * @param fields is a map of all the incoming hey-value pairs from the VPC
    * @return is the hash being returned for comparison to the incoming hash
    */
   String SHAhashAllFields(Map fields) {

      //hashKeys = "";
      //hashValues = "";

      // create a list and sort it
      List fieldNames = new ArrayList(fields.keySet());
      Collections.sort(fieldNames);

      // create a buffer for the SHA256 input
      StringBuffer buf = new StringBuffer();

      // iterate through the list and add the remaining field values
      Iterator itr = fieldNames.iterator();
      while (itr.hasNext()) {
         String fieldName = (String) itr.next();
         String fieldValue = (String) fields.get(fieldName);
         //hashKeys += fieldName + ", ";
         //if ((fieldValue != null) && (fieldValue.length() > 0)) {
         buf.append(fieldName + "=" + fieldValue);
         if (itr.hasNext()) {
            buf.append('&');
         }
         //}
      }

      byte[] mac = null;
      try {
         byte[] b = new BigInteger(SECURE_SECRET, 16).toByteArray();
         SecretKey key = new SecretKeySpec(b, "HmacSHA256");
         Mac m = Mac.getInstance("HmacSHA256");
         m.init(key);
         //String values = new String(buf.toString(), "UTF-8");
         m.update(buf.toString().getBytes("ISO-8859-1"));
         mac = m.doFinal();
      } catch (Exception e) {
      }
      String hashValue = hex(mac);
      return hashValue;

   } // end hashAllFields()

//  ----------------------------------------------------------------------------

   /*
    * This method takes a byte array and returns a string of its contents
    *
    * @param input - byte array containing the input data
    * @return String containing the output String
    */
   static String hex(byte[] input) {
      // create a StringBuffer 2x the size of the hash array
      StringBuffer sb = new StringBuffer(input.length * 2);

      // retrieve the byte array data, convert it to hex
      // and add it to the StringBuffer
      for (int i = 0; i < input.length; i++) {
         sb.append(HEX_TABLE[(input[i] >> 4) & 0xf]);
         sb.append(HEX_TABLE[input[i] & 0xf]);
      }
      return sb.toString();
   }

//  ----------------------------------------------------------------------------

   /*
    * This method takes a data String and returns a predefined value if empty
    * If data Sting is null, returns string "No Value Returned", else returns input
    *
    * @param in String containing the data String
    * @return String containing the output String
    */
   private static String null2unknown(String in) {
      if (in == null || in.length() == 0) {
         return "No Value Returned";
      } else {
         return in;
      }
   } // null2unknown()

//  ----------------------------------------------------------------------------

   /*
    * This function uses the returned status code retrieved from the Digital
    * Response and returns an appropriate description for the code
    *
    * @param vResponseCode String containing the vpc_TxnResponseCode
    * @return description String containing the appropriate description
    */
   String getResponseDescription(String vResponseCode) {

      String result = "";

      // check if a single digit response code
      if (vResponseCode.length() != 1) {

         // Java cannot switch on a string so turn everything to a char
         char input = vResponseCode.charAt(0);

         switch (input) {
            case '0':
               result = "Transaction Successful";
               break;
            case '1':
               result = "Transaction Declined";
               break;
            case '2':
               result = "Bank Declined Transaction";
               break;
            case '3':
               result = "No Reply from Bank";
               break;
            case '4':
               result = "Expired Card";
               break;
            case '5':
               result = "Insufficient Funds";
               break;
            case '6':
               result = "Error Communicating with Bank";
               break;
            case '7':
               result = "Payment Server detected an error";
               break;
            case '8':
               result = "Transaction Type Not Supported";
               break;
            case '9':
               result = "Bank declined transaction (Do not contact Bank)";
               break;
            case 'A':
               result = "Transaction Aborted";
               break;
            case 'B':
               result = "Transaction Declined - Contact the Bank";
               break;
            case 'C':
               result = "Transaction Cancelled";
               break;
            case 'D':
               result = "Deferred transaction has been received and is awaiting processing";
               break;
            case 'E':
               result = "Transaction Declined - Refer to card issuer";
               break;
            case 'F':
               result = "3-D Secure Authentication failed";
               break;
            case 'I':
               result = "Card Security Code verification failed";
               break;
            case 'L':
               result = "Shopping Transaction Locked (Please try the transaction again later)";
               break;
            case 'M':
               result = "Transaction Submitted (No response from acquirer)";
               break;
            case 'N':
               result = "Cardholder is not enrolled in Authentication scheme";
               break;
            case 'P':
               result = "Transaction has been received by the Payment Adaptor and is being processed";
               break;
            case 'R':
               result = "Transaction was not processed - Reached limit of retry attempts allowed";
               break;
            case 'S':
               result = "Duplicate SessionID";
               break;
            case 'T':
               result = "Address Verification Failed";
               break;
            case 'U':
               result = "Card Security Code Failed";
               break;
            case 'V':
               result = "Address Verification and Card Security Code Failed";
               break;
            case '?':
               result = "Transaction status is unknown";
               break;
            default:
               result = "Unable to be determined";
               break;
         }

         return result;
      } else {
         return "No Value Returned";
      }
   } // getResponseDescription()

//  ----------------------------------------------------------------------------
   /**
    * This function uses the QSI AVS Result Code retrieved from the Digital
    * Receipt and returns an appropriate description for this code.
    *
    * @param vAVSResultCode String containing the vpc_AVSResultCode
    * @return description String containing the appropriate description
    */
   private String displayAVSResponse(String vAVSResultCode) {

      String result = "";
      if (vAVSResultCode != null || vAVSResultCode.length() == 0) {

         if (vAVSResultCode.equalsIgnoreCase("Unsupported") || vAVSResultCode.equalsIgnoreCase("No Value Returned")) {
            result = "AVS not supported or there was no AVS data provided";
         } else {
            // Java cannot switch on a string so turn everything to a char
            char input = vAVSResultCode.charAt(0);

            switch (input) {
               case 'X':
                  result = "Exact match - address and 9 digit ZIP/postal code";
                  break;
               case 'Y':
                  result = "Exact match - address and 5 digit ZIP/postal code";
                  break;
               case 'S':
                  result = "Service not supported or address not verified (international transaction)";
                  break;
               case 'G':
                  result = "Issuer does not participate in AVS (international transaction)";
                  break;
               case 'C':
                  result = "Street Address and Postal Code not verified for International Transaction due to incompatible formats.";
                  break;
               case 'I':
                  result = "Visa Only. Address information not verified for international transaction.";
                  break;
               case 'A':
                  result = "Address match only";
                  break;
               case 'W':
                  result = "9 digit ZIP/postal code matched, Address not Matched";
                  break;
               case 'Z':
                  result = "5 digit ZIP/postal code matched, Address not Matched";
                  break;
               case 'R':
                  result = "Issuer system is unavailable";
                  break;
               case 'U':
                  result = "Address unavailable or not verified";
                  break;
               case 'E':
                  result = "Address and ZIP/postal code not provided";
                  break;
               case 'B':
                  result = "Street Address match for international transaction. Postal Code not verified due to incompatible formats.";
                  break;
               case 'N':
                  result = "Address and ZIP/postal code not matched";
                  break;
               case '0':
                  result = "AVS not requested";
                  break;
               case 'D':
                  result = "Street Address and postal code match for international transaction.";
                  break;
               case 'M':
                  result = "Street Address and postal code match for international transaction.";
                  break;
               case 'P':
                  result = "Postal Codes match for international transaction but street address not verified due to incompatible formats.";
                  break;
               case 'K':
                  result = "Card holder name only matches.";
                  break;
               case 'F':
                  result = "Street address and postal code match. Applies to U.K. only.";
                  break;
               default:
                  result = "Unable to be determined";
                  break;
            }
         }
      } else {
         result = "null response";
      }
      return result;
   }

//  ----------------------------------------------------------------------------
   /**
    * This function uses the QSI CSC Result Code retrieved from the Digital
    * Receipt and returns an appropriate description for this code.
    *
    * @param vCSCResultCode String containing the vpc_CSCResultCode
    * @return description String containing the appropriate description
    */
   private String displayCSCResponse(String vCSCResultCode) {

      String result = "";
      if (vCSCResultCode != null || vCSCResultCode.length() == 0) {

         if (vCSCResultCode.equalsIgnoreCase("Unsupported") || vCSCResultCode.equalsIgnoreCase("No Value Returned")) {
            result = "CSC not supported or there was no CSC data provided";
         } else {
            // Java cannot switch on a string so turn everything to a char
            char input = vCSCResultCode.charAt(0);

            switch (input) {
               case 'M':
                  result = "Exact code match";
                  break;
               case 'S':
                  result = "Merchant has indicated that CSC is not present on the card (MOTO situation)";
                  break;
               case 'P':
                  result = "Code not processed";
                  break;
               case 'U':
                  result = "Card issuer is not registered and/or certified";
                  break;
               case 'N':
                  result = "Code invalid or not matched";
                  break;
               default:
                  result = "Unable to be determined";
            }
         }

      } else {
         result = "null response";
      }
      return result;
   }

//  ----------------------------------------------------------------------------
   /**
    * This method uses the 3DS verStatus retrieved from the Response and returns
    * an appropriate description for this code.
    *
    * @param vpc_VerStatus String containing the status code
    * @return description String containing the appropriate description
    */
   private String getStatusDescription(String vStatus) {

      String result = "";
      if (vStatus != null && !vStatus.equals("")) {

         if (vStatus.equalsIgnoreCase("Unsupported") || vStatus.equals("No Value Returned")) {
            result = "3DS not supported or there was no 3DS data provided";
         } else {

            // Java cannot switch on a string so turn everything to a character
            char input = vStatus.charAt(0);

            switch (input) {
               case 'Y':
                  result = "The cardholder was successfully authenticated.";
                  break;
               case 'E':
                  result = "The cardholder is not enrolled.";
                  break;
               case 'N':
                  result = "The cardholder was not verified.";
                  break;
               case 'U':
                  result = "The cardholder's Issuer was unable to authenticate due to some system error at the Issuer.";
                  break;
               case 'F':
                  result = "There was an error in the format of the request from the merchant.";
                  break;
               case 'A':
                  result = "Authentication of your Merchant ID and Password to the ACS Directory Failed.";
                  break;
               case 'D':
                  result = "Error communicating with the Directory Server.";
                  break;
               case 'C':
                  result = "The card type is not supported for authentication.";
                  break;
               case 'S':
                  result = "The signature on the response received from the Issuer could not be validated.";
                  break;
               case 'P':
                  result = "Error parsing input from Issuer.";
                  break;
               case 'I':
                  result = "Internal Payment Server system error.";
                  break;
               default:
                  result = "Unable to be determined";
                  break;
            }
         }
      } else {
         result = "null response";
      }
      return result;
   }

//  ----------------------------------------------------------------------------
%>

<%
   System.out.println("PAYMENT CLIENT PROGRAMA...");
   System.out.println("Respuesta de banamex....");
   // *******************************************
   // START OF MAIN PROGRAM
   // *******************************************

   // The Page does a display to a browser

   // retrieve all the incoming parameters into a hash map
   Map fields = new HashMap();
   Map hashFields = new HashMap();
   StringBuffer testFields = new StringBuffer();
   testFields.append("Fields: ");
   for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
      String fieldName = (String) e.nextElement();
      String fieldValue = request.getParameter(fieldName);
      if ((!fieldName.equals("vpc_SecureHash") && !fieldName.equals("vpc_SecureHashType")) && fieldName.substring(0, 4).equals("vpc_") || fieldName.substring(0, 5).equals("user_")) {
         hashFields.put(fieldName, fieldValue);
         testFields.append(fieldName + "=" + fieldValue + "<br />");
      }
      if ((fieldValue != null) && (fieldValue.length() > 0)) {
         fields.put(fieldName, fieldValue);
      }

   }

   String hashedFieldsDisplay = testFields.toString();
   /*  If there has been a merchant secret set then sort and loop through all the
    data in the Virtual Payment Client response. while we have the data, we can
    append all the fields that contain values (except the secure hash) so that
    we can create a hash and validate it against the secure hash in the Virtual
    Payment Client response.

    NOTE: If the vpc_TxnResponseCode in not a single character then
    there was a Virtual Payment Client error and we cannot accurately validate
    the incoming data from the secure hash. */

   // remove the vpc_TxnResponseCode code from the response fields as we do not
   // want to include this field in the hash calculation
   String vpc_Txn_Secure_Hash = null2unknown((String) fields.remove("vpc_SecureHash"));
   String secureHash = new String();
   String hashValidated = null;

   // defines if error message should be output
   boolean errorExists = false;
   boolean boolHashValidated = false;

   if (SECURE_SECRET != null && SECURE_SECRET.length() > 0
           && (fields.get("vpc_TxnResponseCode") != null || fields.get("vpc_TxnResponseCode") != "No Value Returned")) {

      // create secure hash and append it to the hash map if it was created
      // remember if SECURE_SECRET = "" it wil not be created

      secureHash = SHAhashAllFields(hashFields);


      // Validate the Secure Hash
      if (vpc_Txn_Secure_Hash.equalsIgnoreCase(secureHash)) {
         // Secure Hash validation succeeded, add a data field to be
         // displayed later.
         hashValidated = "<font color='#00AA00'><strong>CORRECT</strong></font>";
         boolHashValidated = true;
      } else {
         // Secure Hash validation failed, add a data field to be
         // displayed later.
         errorExists = true;
         hashValidated = "<font color='#FF0066'><strong>INVALID HASH</strong></font>";
      }
   } else {
      // Secure Hash was not validated,
      hashValidated = "<font color='orange'><strong>Not Calculated - No 'SECURE_SECRET' present.</strong></font>";
   }

   // Extract the available receipt fields from the VPC Response
   // If not present then let the value be equal to 'Unknown'
   // Standard Receipt Data
   String amount = null2unknown((String) fields.get("vpc_Amount"));
   String locale = null2unknown((String) fields.get("vpc_Locale"));
   String batchNo = null2unknown((String) fields.get("vpc_BatchNo"));
   String command = null2unknown((String) fields.get("vpc_Command"));
   String message = null2unknown((String) fields.get("vpc_Message"));
   String version = null2unknown((String) fields.get("vpc_Version"));
   String cardType = null2unknown((String) fields.get("vpc_Card"));
   String orderInfo = null2unknown((String) fields.get("vpc_OrderInfo"));
   String receiptNo = null2unknown((String) fields.get("vpc_ReceiptNo"));
   String merchantID = null2unknown((String) fields.get("vpc_Merchant"));
   String merchTxnRef = null2unknown((String) fields.get("vpc_MerchTxnRef"));
   String authorizeID = null2unknown((String) fields.get("vpc_AuthorizeId"));
   String transactionNo = null2unknown((String) fields.get("vpc_TransactionNo"));
   String acqResponseCode = null2unknown((String) fields.get("vpc_AcqResponseCode"));
   String txnResponseCode = null2unknown((String) fields.get("vpc_TxnResponseCode"));
   String vpcHash = null2unknown((String) fields.get("vpc_SecureHash"));
   String riskOverallresult = null2unknown((String) fields.get("vpc_RiskOverallResult"));

   // CSC Receipt Data
   String vCSCResultCode = null2unknown((String) fields.get("vpc_CSCResultCode"));
   String vCSCRequestCode = null2unknown((String) fields.get("vpc_CSCRequestCode"));
   String vACQCSCRespCode = null2unknown((String) fields.get("vpc_AcqCSCRespCode"));

   // AVS Receipt Data
   String vAVS_City = null2unknown((String) fields.get("vpc_AVS_City"));
   String vAVS_Country = null2unknown((String) fields.get("vpc_AVS_Country"));
   String vAVS_Street01 = null2unknown((String) fields.get("vpc_AVS_Street01"));
   String vAVS_PostCode = null2unknown((String) fields.get("vpc_AVS_PostCode"));
   String vAVS_StateProv = null2unknown((String) fields.get("vpc_AVS_StateProv"));
   String vAVSResultCode = null2unknown((String) fields.get("vpc_AVSResultCode"));
   String vAVSRequestCode = null2unknown((String) fields.get("vpc_AVSRequestCode"));
   String vACQAVSRespCode = null2unknown((String) fields.get("vpc_AcqAVSRespCode"));

   // 3-D Secure Data
   String transType3DS = null2unknown((String) fields.get("vpc_VerType"));
   String verStatus3DS = null2unknown((String) fields.get("vpc_VerStatus"));
   String token3DS = null2unknown((String) fields.get("vpc_VerToken"));
   String secureLevel3DS = null2unknown((String) fields.get("vpc_VerSecurityLevel"));
   String enrolled3DS = null2unknown((String) fields.get("vpc_3DSenrolled"));
   String xid3DS = null2unknown((String) fields.get("vpc_3DSXID"));
   String eci3DS = null2unknown((String) fields.get("vpc_3DSECI"));
   String status3DS = null2unknown((String) fields.get("vpc_3DSstatus"));

   String error = "";
   // Show this page as an error page if error condition
   if (txnResponseCode.equals("7") || txnResponseCode.equals("No Value Returned") || errorExists) {
      error = "Error ";
   }

   // FINISH TRANSACTION - Process the VPC Response Data
   // =====================================================
   // For the purposes of demonstration, we simply display the Result fields on a
   // web page.

   response.setHeader("Content-Type", "text/html, charset=ISO-8859-1");
   response.setHeader("Expires", "Mon, 26 Jul 1997 05:00:00 GMT");
   response.setDateHeader("Last-Modified", new Date().getTime());
   response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
   response.setHeader("Pragma", "no-cache");

   //Escribimos en el log las respuestas para revisiones futuras
   System.out.println("*****************Response PaymentClient*****************");
   System.out.println("error:" + error);
   System.out.println("version:" + version);
   System.out.println("command:" + command);
   System.out.println("merchTxnRef:" + merchTxnRef);
   System.out.println("merchantID:" + merchantID);
   System.out.println("orderInfo:" + orderInfo);
   System.out.println("amount:" + amount);
   System.out.println("locale:" + locale);
   System.out.println("txnResponseCode:" + txnResponseCode);
   System.out.println("getResponseDescription:" + getResponseDescription(txnResponseCode));
   System.out.println("message:" + message);
   System.out.println("hashValidated:" + hashValidated);
   //Redireccionamos

   // only display the following fields if not an error condition
   if (!txnResponseCode.equals("7") && !txnResponseCode.equals("No Value Returned")) {
      System.out.println("receiptNo:" + receiptNo);
      System.out.println("transactionNo:" + transactionNo);
      System.out.println("acqResponseCode:" + acqResponseCode);
      System.out.println("authorizeID:" + authorizeID);
      System.out.println("batchNo:" + batchNo);
      System.out.println("cardType:" + cardType);
      System.out.println("riskOverallresult:" + (riskOverallresult == null ? "" : riskOverallresult));

   }
   //Valuamos que pagina mostramos
   //Iniciamos valores
   VariableSession varSesiones = new VariableSession(request);
   //Abrimos la conexion
   Conexion oConn = new Conexion(null, this.getServletContext());
   oConn.open();
   //Configuracion sitio
   Site webBase = new Site(oConn);

   if (boolHashValidated) {
      //Si es cero el pago esta aprobado
      if (txnResponseCode.equals("0")) {
         //Generamos un pago como anticipo
         //Enviamos correo

         String strIdPedido = merchTxnRef;
         //Instanciamos objeto para mails
         Mail mail = new Mail();
         String strLstMail = "";
         //Buscaos usuario que reciban notificaciones
         String strSqlUsuarios = "SELECT EMAIL FROM usuarios WHERE BOL_MAIL_PAGOS_WEB=1";
         try {
            ResultSet rs = oConn.runQuery(strSqlUsuarios);

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
         //Variables para la generación del anticipo
         int intCliente = 0;
         double dblMontoPago = 0;
         //Si hay correos enviamos el mail
         if (!strLstMail.isEmpty()) {
            //Intentamos mandar el mail
            mail.setBolDepuracion(false);
            mail.getTemplate("PAGO_WEB", oConn);
            mail.getMensaje();
            mail.setDestino(strLstMail);
            String strSqlEmp = "SELECT *,DATE_FORMAT(CURDATE(), '%d/%m/%Y') as FECHA,'Banamex TC' as MEDIO_PAGO FROM vta_pedidos"
                    + " where PD_ID=" + strIdPedido + "";
            try {
               ResultSet rs = oConn.runQuery(strSqlEmp);
               mail.setReplaceContent(rs);
               //Nos movemos al inicio
               rs.beforeFirst();
               while (rs.next()) {
                  intCliente = rs.getInt("CT_ID");
                  dblMontoPago = rs.getDouble("PD_TOTAL");
               }
               rs.close();
            } catch (SQLException ex) {
               //this.strResultLast = "ERROR:" + ex.getMessage();
               ex.fillInStackTrace();
            }
            mail.setDestino(strLstMail);


            boolean bol = mail.sendMail();
            if (bol) {
            }
         }
         //Generamos un anticipo
         if (intCliente != 0) {
            //Instanciamos el objeto 
            Fechas fecha = new Fechas();
            movCliente movCte = new movCliente(oConn, varSesiones, request);
            //Inicializamos objeto
            movCte.Init();
            movCte.setBolEsAnticipo(true);
            movCte.getCta_clie().setFieldInt("CT_ID", intCliente);
            movCte.getCta_clie().setFieldInt("MC_ANTICIPO", 1);
            movCte.getCta_clie().setFieldString("MC_FECHA", fecha.getFechaActual());
            movCte.getCta_clie().setFieldString("MC_NOTAS", "BANAMEX AUTOMATICO...");

            movCte.getCta_clie().setFieldInt("EMP_ID", webBase.getIntEMP_ID());
            movCte.getCta_clie().setFieldInt("SC_ID", webBase.getIntSC_ID());
            movCte.getCta_clie().setFieldInt("MC_MONEDA", webBase.getIntMON_ID());
            movCte.getCta_clie().setFieldDouble("MC_TASAPESO", 1.0);
            movCte.getCta_clie().setFieldInt("FAC_ID", 0);
            movCte.getCta_clie().setFieldInt("TKT_ID", 0);
            movCte.getCta_clie().setFieldInt("MC_ESPAGO", 1);
            movCte.getCta_clie().setFieldDouble("MC_ABONO", dblMontoPago);
            movCte.doTrx();
         }
         //Limpiamos el carrito de compras anterior
         Sesiones.SetSession(request, "CarSell", "0");
         //Pagina de exito
         response.sendRedirect(webBase.getUrlSite() + "index.jsp?mod=ecomm_car_checkout_sucess"
                 + "&banamex=1"  
                 + "&orderInfo=" + orderInfo
                 + "&receiptNo=" + receiptNo
                 + "&transactionNo=" + transactionNo
                 + "&authorizeID=" + authorizeID
                 );
      } else {
         //Pagina de error
         response.sendRedirect(webBase.getUrlSite() + "index.jsp?mod=ecomm_checkout");
      }

   } else {
      //Pagina de error
      response.sendRedirect(webBase.getUrlSite() + "index.jsp?mod=ecomm_checkout");
   }
   oConn.close();
%>

