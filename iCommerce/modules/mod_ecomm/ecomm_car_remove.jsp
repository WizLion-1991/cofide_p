<%-- 
    Document   : ecomm_car_remove
    Created on : 03-sep-2014, 5:28:03
    Author     : ZeusGalindo
--%>

<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="com.siweb.utilerias.json.JSONObject"%>
<%@page import="comSIWeb.Utilerias.Sesiones"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
//Quitamos 
   String idRemove = request.getParameter("remove");
//Recuperamos la variable de sesion
   String strLst = Sesiones.gerVarSession(request, "CarSell");
   JSONObject objJsonCarrito = new JSONObject();
   JSONArray jsonChild = null;
   if (!strLst.equals("0")) {
      int intIdRemove = 0;
      try {
         intIdRemove = Integer.valueOf(idRemove);
      } catch (NumberFormatException ex) {
      }

      //Parseamos el objeto json
      objJsonCarrito = new JSONObject(strLst);
      jsonChild = objJsonCarrito.getJSONArray("carritoCompras");
      //Obtenemos el resumen del carrito
      for (int i = 0; i < jsonChild.length(); i++) {
         JSONObject row = jsonChild.getJSONObject(i);
         //if (row.getInt("ProducId") == intIdRemove) {
         if (i == intIdRemove) {
            jsonChild.remove(i);
            break;
         }
      }
      //Actualizamos el carrito
      Sesiones.SetSession(request, "CarSell", objJsonCarrito.toString());
   }

%>
<jsp:include page="../../modules/mod_ecomm/ecomm_car_view.jsp" />