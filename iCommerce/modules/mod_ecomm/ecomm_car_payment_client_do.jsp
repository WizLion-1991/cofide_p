<%-- 
    Document   : ecomm_car_payment_client_do
    Created on : 12-sep-2014, 18:59:52
    Author     : ZeusGalindo
--%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@ page contentType="text/html;charset=ISO-8859-1" language="java" %>
<%--


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

 @author Transaction Network Service Pty Ltd Group

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
   // This is secret for encoding the SHA256 hash
   // This secret will vary from merchant to merchant
      //Iniciamos valores
            
   static final String SECURE_SECRET = "3F606DC6B1102BBF11340B065A339A39";
   // This is an array for creating hex chars
   static final char[] HEX_TABLE = new char[]{
      '0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
//  ----------------------------------------------------------------------------
   String hashKeys = new String();
   String hashValues = new String();

   /**
    * This method is for sorting the fields and creating a SHA256 secure hash.
    *
    * @param fields is a map of all the incoming hey-value pairs from the VPC
    * @param buf is the hash being returned for comparison to the incoming hash
    */
   void appendQueryFields(StringBuffer buf, Map fields) {

      // create a list
      List fieldNames = new ArrayList(fields.keySet());
      Iterator itr = fieldNames.iterator();

      // move through the list and create a series of URL key/value pairs
      while (itr.hasNext()) {
         String fieldName = (String) itr.next();
         String fieldValue = (String) fields.get(fieldName);

         if ((fieldValue != null) && (fieldValue.length() > 0)) {
            // append the URL parameters
            buf.append(URLEncoder.encode(fieldName));
            buf.append('=');
            buf.append(URLEncoder.encode(fieldValue));
         }

         // add a '&' to the end if we have more fields coming.
         if (itr.hasNext()) {
            buf.append('&');
         }
      }

   }

   String SHAhashAllFields(Map fields) {

      hashKeys = "";
      hashValues = "";

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
         hashKeys += fieldName + ", ";
         if ((fieldValue != null) && (fieldValue.length() > 0)) {
            buf.append(fieldName + "=" + fieldValue);
            if (itr.hasNext()) {
               buf.append('&');
            }
         }
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
   /**
    * Returns Hex output of byte array
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
%>

<%
   // *******************************************
   // START OF MAIN PROGRAM
   // *******************************************

   // The Page does a transaction using the Virtual Payment Client

   // retrieve all the parameters into a hash map
   Map fields = new HashMap();
   Enumeration e = request.getParameterNames();

   while (e.hasMoreElements()) {
      String fieldName = (String) e.nextElement();
      String fieldValue = request.getParameter(fieldName);
      if ((fieldValue != null) && (fieldValue.length() > 0)) {
         fields.put(fieldName, fieldValue);
      }
   }

   // no need to send the vpc url and submit button to the vpc
   String vpcURL = (String) fields.remove("virtualPaymentClientURL");
   fields.remove("virtualPaymentClientURL");
   fields.remove("SubButL");

   // Create SHA256 secure hash and insert it into the hash map if it was created
   // created. Remember if SECURE_SECRET = "" it will not be created
   if (SECURE_SECRET != null && SECURE_SECRET.length() > 0) {
      String secureHash = SHAhashAllFields(fields);
      fields.put("vpc_SecureHash", secureHash);
      fields.put("vpc_SecureHashType", "SHA256");
   }

   // Create a redirection URL
   StringBuffer buf = new StringBuffer();
   buf.append(vpcURL).append('?');
   appendQueryFields(buf, fields);

   // Redirect to Virtual PaymentClient
   response.sendRedirect(buf.toString());
   //out.println(buf.toString());
%>