<%-- 
    Document   : valida_codigo
    Created on : 29/09/2015, 03:04:05 PM
    Author     : siweb
--%>


<%@page import="comSIWeb.Utilerias.UtilXml"%>
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

    UtilXml util = new UtilXml();
    String strid = request.getParameter("ID");
    String strCodigo = request.getParameter("CODIGO");
    if (strid != null) {
        if (strid.equals("1")) {
            
            String boolBandera = "";
            String strQuery = "select *  from mlm_codigo_promocion where  MCP_ACTIVO = '1' and MCP_USADO = '0'  and MCP_CODIGO_PROMOCION = '" + strCodigo + "' ";
            String strNomImg = "<img id=\'imgValida\' src = \'images/Itcancel.gif\'/>";
            boolBandera = "false";
            try {
                ResultSet rs = oConn.runQuery(strQuery);
                while (rs.next()) {
                    strNomImg = "<img id=\'imgValida\' src = \'images/Itsave1.gif\'/>";
                    boolBandera = "true";
                }
                rs.close();
            } catch (SQLException ex) {
                System.out.println(ex.getMessage());
            }

            StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
            strXML.append("<img1>");
            strXML.append(" <img_deta");
            strXML.append(" strNomImg= \"").append(util.Sustituye(strNomImg)).append("\" ");
            strXML.append(" bandera= \"").append(boolBandera).append("\" ");
            strXML.append("/>");
            strXML.append("</img1>");

            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
        }
    }
    oConn.close();


%>