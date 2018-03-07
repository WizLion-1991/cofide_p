<%-- 
    Document   : ERP_ConAntProv
    Created on : 6/06/2014, 06:32:44 PM
    Author     : siwebmx5
--%>


<%@page import="ERP.ConsultaAnticiposProv"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
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
             String strXML= "";            
            String strPV_ID = "0";
            if(request.getParameter("PV_ID") !=null)
            {
                strPV_ID =request.getParameter("PV_ID");
            }
            String strMON_ID = "0";
            if(request.getParameter("MON_ID")!=null)
            {
                strMON_ID =request.getParameter("MON_ID");
            }
            String strCAP_UTILIZADOS = "0";
            if(request.getParameter("CAP_UTILIZADOS")!=null)
            {
                strCAP_UTILIZADOS =request.getParameter("CAP_UTILIZADOS");
            }
            
            String strAnulado = "0";
            if(request.getParameter("CAP_ANULADO")!=null)
            {
                strAnulado =request.getParameter("CAP_ANULADO");
            }
           ConsultaAnticiposProv CAP = new ConsultaAnticiposProv(oConn);
           strXML = CAP.getAnticiposProveedor(Integer.parseInt(strPV_ID), Integer.parseInt(strMON_ID), Integer.parseInt(strCAP_UTILIZADOS), Integer.parseInt(strAnulado));
             out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado   
        }
          if (strid.equals("2")) {
              String strPV_ID = request.getParameter("PV_ID");
             ConsultaAnticiposProv CAP =new ConsultaAnticiposProv(oConn);
             String strXML= CAP.getDatoProveedor(Integer.parseInt(strPV_ID));
             out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado
          }
          if (strid.equals("3")) {
             String strXML="";
             String strMP_ID = request.getParameter("MP_ID");
             ConsultaAnticiposProv CAP =new ConsultaAnticiposProv(oConn);
             strXML = CAP.getPagosAnticipos(Integer.parseInt(strMP_ID));
             out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML.toString());//Pintamos el resultado
         }
    }
   }
%>