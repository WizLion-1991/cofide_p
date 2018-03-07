<%-- 
    Document   : ERP_Descendencia
    Created on : 17/09/2014, 04:16:36 PM
    Author     : siwebmx5
--%>
<%@page import="com.mx.siweb.mlm.compensacion.casajosefa.CalculoUPLINE"%>
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
        String strid = request.getParameter("ID");

        if (strid != null) {
            int intMaxLvL= 3;
            //Obtenemos el nivel maximo donde puede colocar un cliente.
           
            if (strid.equals("1")) {
                int intCliente = 0;
                if (request.getParameter("CT_ID") != null) {
                    intCliente = Integer.parseInt(request.getParameter("CT_ID"));
                }
                String strResp = "";
                CalculoUPLINE cUPline= new CalculoUPLINE();
                cUPline.setIntMaxNivel(intMaxLvL);
                strResp+="OK"+cUPline.EncontrarNivelMaximo(intCliente, oConn);
                
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado
            }
            //Obtenemos el nivel maximo donde puede colocar un cliente.
            if (strid.equals("2")) {
                int intCliente = 0;
                if (request.getParameter("CT_ID") != null) {
                    intCliente = Integer.parseInt(request.getParameter("CT_ID"));
                }
                int intNivel = 0;
                if (request.getParameter("CT_NIVEL") != null) {
                    intNivel = Integer.parseInt(request.getParameter("CT_NIVEL"));
                }
                String strResp = "";
                CalculoUPLINE cUPline= new CalculoUPLINE();
                cUPline.setIntMaxNivel(intMaxLvL);
                strResp+="OK"+cUPline.DebajoDeQuien(intCliente,intNivel, oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado
            }
        }
    }
%>