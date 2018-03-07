<%-- 
    Document   : ERP_CuentasXPagarDocu
    Created on : 27/05/2014, 06:17:34 PM
    Author     : siwebmx5
--%>

<%@page import="ERP.CuentasXPagarDoc"%>
<%@page import="java.io.File"%>
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
            //Abre el archivo Pdf del Documento asignado a uan Cuenta Por Pagar
            if (strid.equals("1")) {
                String strCPR_ID = request.getParameter("CPR_ID");
                String strSQL = "Select CPR_DESCRIPCION From vta_cxp_rep Where CPR_ID = "+strCPR_ID;
                String strRESP="";
                ResultSet rs = oConn.runQuery(strSQL);
                while(rs.next())
                {
                    strRESP = rs.getString("CPR_DESCRIPCION");
                }
                
                response.setCharacterEncoding("utf-8");
                response.setHeader("cache-control", "no-cache");
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRESP);//Mandamos a pantalla el resultado
            }
            //Elimina Archivo Cuenta Por Pagar
            if (strid.equals("2")) {
                String strCPR_ID = request.getParameter("CPR_ID");
                
                String strSQL = "Select CPR_PATH From vta_cxp_rep Where CPR_ID = "+strCPR_ID;
               
                ResultSet rs = oConn.runQuery(strSQL);
                while(rs.next())
                {
                    
                    File miArchivo = new File(rs.getString("CPR_PATH"));
                    if(miArchivo.exists())
                    {
                        miArchivo.delete();
                    }
                }
                rs.close();
                
                CuentasXPagarDoc CPR = new CuentasXPagarDoc();
                CPR.getCPR().setFieldInt("CPR_ID", Integer.parseInt(strCPR_ID));
                String strResp =CPR.delCXPDoc(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado
            }
        }
    }
%>