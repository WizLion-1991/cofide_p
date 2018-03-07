<%-- 
    Document   : ERP_DevCte
    Created on : 14/10/2013, 03:42:28 PM
    Author     : siwebmx5
--%>

<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
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
        //Inicializamos datos
        Fechas fecha = new Fechas();

        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            //Genera una nueva operacion de pagos en base a la transaccion que nos envian
            if (strid.equals("1")) {
                String strCT_ID = request.getParameter("CT_ID");
                int intMON_ID=0;
                String strSQL = "Select MON_ID From vta_cliente Where CT_ID = "+strCT_ID;
                ResultSet rs = oConn.runQuery(strSQL, true);
                while (rs.next()) {
                    intMON_ID = rs.getInt("MON_ID");
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.print(intMON_ID);//Pintamos el resultado
            }
        }
    }
 %>