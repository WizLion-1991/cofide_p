<%-- 
    Document   : PtoVtaPanResource
    Created on : 17-oct-2013, 3:27:06
    Author     : ZeusGalindo
--%>

<%@page import="ERP.Turnos"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="ERP.Globalizacion"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
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

         //Regresamos la categoria 1
         if (strid.equals("1")) {
            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strXML.append("<categorias>");
            String strSql = "select PC_ID,PC_DESCRIPCION from vta_prodcat1 order by pc1_orden";
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML.append("<categoria id=\"" + rs.getString("PC_ID") + "\" name=\"" + rs.getString("PC_DESCRIPCION") + "\" />");
            }
            rs.close();
            strXML.append("</categorias>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresamos la categoria 2
         if (strid.equals("2")) {
            String strValorCat1 = request.getParameter("categoria1");

            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strXML.append("<categorias>");
            String strSql = "select vta_prodcat2.PC2_ID , vta_prodcat2.PC2_DESCRIPCION "
                    + " from vta_prodcat2,vta_producto where vta_prodcat2.PC2_ID = vta_producto.PR_CATEGORIA2 "
                    + " and vta_producto.PR_CATEGORIA1 = " + strValorCat1;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML.append("<categoria id=\"" + rs.getString("PC2_ID") + "\" name=\"" + rs.getString("PC2_DESCRIPCION") + "\" />");
            }
            rs.close();
            strXML.append("</categorias>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresamos la categoria 3
         if (strid.equals("3")) {
            String strValorCat2 = request.getParameter("categoria2");

            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strXML.append("<categorias>");
            String strSql = "select vta_prodcat3.PC3_ID , vta_prodcat3.PC3_DESCRIPCION from vta_prodcat3,vta_producto "
                    + " where vta_prodcat3.PC3_ID = vta_producto.PR_CATEGORIA3 "
                    + " and vta_producto.PR_CATEGORIA2 " + strValorCat2;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML.append("<categoria id=\"" + rs.getString("PC3_ID") + "\" name=\"" + rs.getString("PC3_DESCRIPCION") + "\">");
            }
            rs.close();
            strXML.append("</categorias>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresamos productos de la categoria 1
         if (strid.equals("10")) {
            String strValorCat = request.getParameter("categoria");
            String strNumCat = request.getParameter("numCat");

            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            strXML.append("<categorias>");
            String strSql = "SELECT vta_producto.PR_ID, "
                    + "	vta_producto.PR_CODIGO, 	vta_producto.PR_DESCRIPCION,vta_producto.PR_PREC_PZA, 	"
                    + "vta_prodprecios.PP_PRECIO FROM vta_prodprecios INNER JOIN "
                    + "vta_producto ON vta_prodprecios.PR_ID = vta_producto.PR_ID "
                    + "WHERE vta_prodprecios.LP_ID = 1 and PR_CATEGORIA" + strNumCat + " = " + strValorCat;
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               strXML.append("<categoria id=\"" + rs.getString("PR_ID") + "\" "
                       + " name=\"" + rs.getString("PR_DESCRIPCION") + "\" "
                       + " precio=\"" + rs.getString("PP_PRECIO") + "\" "
                       + " prec_pza=\"" + rs.getString("PR_PREC_PZA") + "\" "
                       + "codigo=\"" + rs.getString("PR_CODIGO") + "\" />");
            }
            rs.close();
            strXML.append("</categorias>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Cierra el turno actual
         if (strid.equals("11")) {
            Turnos turno = new Turnos();
            turno.setoConn(oConn);
            int intTurno = turno.getTurn(varSesiones.getIntSucursalDefault());
            if (intTurno < 2) {
               turno.closeTurn(intTurno, varSesiones.getIntSucursalDefault(), varSesiones.getIntIdEmpresa(), varSesiones.getIntNoUser());
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println("Turno " + intTurno + " cerrado ");//Pintamos el resultad
            } else {
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println("Turno " + (--intTurno) + " ya estaba cerrado ");//Pintamos el resultad  
            }
         }
      }
   } else {
   }
   oConn.close();
%>