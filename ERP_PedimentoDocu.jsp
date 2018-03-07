<%-- 
    Document   : ERP_PedimentoDocu
    Created on : 27/05/2014, 09:47:10 AM
    Author     : siwebmx5
--%>

<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.PedimentosDoc"%>
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
            //Abre el archivo Pdf del Documento asignado aun Pedimento
            if (strid.equals("1")) {
                String strPRE_ID = request.getParameter("PRE_ID");
                String strSQL = "Select PRE_DESCRIPCION From vta_pedimento_rep Where PRE_ID = "+strPRE_ID;
                String strRESP="";
                ResultSet rs = oConn.runQuery(strSQL);
                while(rs.next())
                {
                    strRESP = rs.getString("PRE_DESCRIPCION");
                }
                
                response.setCharacterEncoding("utf-8");
                response.setHeader("cache-control", "no-cache");
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRESP);//Mandamos a pantalla el resultado
            }
            //Elimina Archivo Pedimento
            if (strid.equals("2")) {
                String strPRE_ID = request.getParameter("PRE_ID");
                
                String strSQL = "Select PRE_PATH From vta_pedimento_rep Where PRE_ID = "+strPRE_ID;
                String strRESP="";
                ResultSet rs = oConn.runQuery(strSQL);
                while(rs.next())
                {
                    
                    File miArchivo = new File(rs.getString("PRE_PATH"));
                    if(miArchivo.exists())
                    {
                        miArchivo.delete();
                    }
                }
                rs.close();
                
                PedimentosDoc PD = new PedimentosDoc();
                PD.getPR().setFieldInt("PRE_ID", Integer.parseInt(strPRE_ID));
                String strResp =PD.delPedimentosDoc(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado
            }
        }
    }
%>