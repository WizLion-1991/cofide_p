<%-- 
    Document   : valida_codigo
    Created on : 29/09/2015, 03:04:05 PM
    Author     : siweb
--%>


<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();

        String strid = request.getParameter("ID");
        String strCodigo = request.getParameter("CODIGO");
        if (strid != null) {
            if (strid.equals("1")) {
                String strQuery = "select *  from mlm_codigo_promocion where  MCP_ACTIVO = '1' and MCP_USADO = '0'  and MCP_CODIGO_PROMOCION = '" + strCodigo + "' ";
                String strNomImg = "<img id=\"imgValida\" src = \"images/Itcancel.gif\"/>";
                try {
                    ResultSet rs = oConn.runQuery(strQuery);
                    while (rs.next()) {
                        strNomImg = "<img id=\"imgValida\" src = \"images/Itsave1.gif\"/>";
                    }
                    rs.close();
                } catch (SQLException ex) {
                    System.out.println(ex.getMessage());
                }
                
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strNomImg);//Pintamos el resultado
            }
        }
        oConn.close();


%>