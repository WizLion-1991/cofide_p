<%-- 
    Document   : ERP_ConAntCte
    Created on : 5/06/2014, 11:07:40 AM
    Author     : siwebmx5
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="ERP.ConsultaAnticiposCte"%>
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

         //Regresa los periodos
         if (strid.equals("1")) {
            String strXML = "";

            String strCT_ID = "0";
            if (request.getParameter("CT_ID") != null) {
               strCT_ID = request.getParameter("CT_ID");
            }
            String strMON_ID = "0";
            if (request.getParameter("MON_ID") != null) {
               strMON_ID = request.getParameter("MON_ID");
            }
            String strCAC_UTILIZADOS = "0";
            if (request.getParameter("CAC_UTILIZADOS") != null) {
               strCAC_UTILIZADOS = request.getParameter("CAC_UTILIZADOS");
            }

            String strAnulado = "0";
            if (request.getParameter("CAC_ANULADO") != null) {
               strAnulado = request.getParameter("CAC_ANULADO");
            }
            ConsultaAnticiposCte CAC = new ConsultaAnticiposCte(oConn);
            strXML = CAC.getAnticiposCliente(Integer.parseInt(strCT_ID), Integer.parseInt(strMON_ID), Integer.parseInt(strCAC_UTILIZADOS), Integer.parseInt(strAnulado));
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
         }
         //Regresa datos del Cliente
         if (strid.equals("2")) {
            String strCTE_ID = request.getParameter("CT_ID");
            ConsultaAnticiposCte CAC = new ConsultaAnticiposCte(oConn);
            String strXML = CAC.getDatoCliente(Integer.parseInt(strCTE_ID));
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado
         }
         if (strid.equals("3")) {
            String strXML = "";
            String strMC_ID = request.getParameter("MC_ID");
            ConsultaAnticiposCte CAC = new ConsultaAnticiposCte(oConn);
            strXML = CAC.getPagosAnticipos(Integer.parseInt(strMC_ID));
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado
         }
      }
   } else {
      /**
       * **************Acceso externo*******
       */
      if (seg.ValidaURL(request)) {
         String strid = request.getParameter("id");
         //Si la peticion no fue nula proseguimos
         if (strid != null) {
            //Regresa datos basicos del Cliente
            if (strid.equals("2")) {
               String strCTE_ID = request.getParameter("CT_ID");
               StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
               strXML.append("<clientes>\n");

               String strSql = "select CT_ID,CT_RAZONSOCIAL,MON_ID "
                       + " from vta_cliente where CT_ID = " + strCTE_ID;
               try {
                  ResultSet rs = oConn.runQuery(strSql, true);
                  while (rs.next()) {
                     strXML.append("<cliente ");
                     strXML.append(" CT_RAZONSOCIAL = \"").append(rs.getString("CT_RAZONSOCIAL")).append("\" ");
                     strXML.append(" />\n");
                  }

               } catch (SQLException ex) {
                  System.out.println(ex.getMessage());
               }
               strXML.append("</clientes>\n");

               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strXML.toString());//Pintamos el resultado
            }
         }
      }
   }
%>