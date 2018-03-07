<%-- 
    Document   : ERP_Sucursales
    Created on : 26/09/2013, 03:43:26 PM
    Author     : siwebmx5
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.Sucursales"%>
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

        //Obtenemos parametros
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            //Guarda La Bodega en la Sucursal Adecuada
            if (strid.equals("1")) {
                String strSC_ID = request.getParameter("SC_ID");
                String strSM_ID = request.getParameter("SM_ID");
                Sucursales Suc = new Sucursales(varSesiones);

                Suc.getSMA().setFieldInt("SC_ID", Integer.valueOf(strSC_ID));
                Suc.getSMA().setFieldInt("SM_ID", Integer.valueOf(strSM_ID));

                String strRes = Suc.AltaDatos(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            //Elimina una Sucursal de la Lista
            if (strid.equals("2")) {
                String strSMA_ID = request.getParameter("SMA_ID");
                Sucursales Suc = new Sucursales(varSesiones);

                Suc.getSMA().setFieldInt("SMA_ID", Integer.valueOf(strSMA_ID));

                String strRes = Suc.deleteDatos(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            //Regresa toda la informacion de un 
            if (strid.equals("3")) {
                String strSM_ID = request.getParameter("SM_ID");
                String strSQL = "Select vta_sucursal_master_as.*,vta_sucursal.SC_NOMBRE "
                        + "From vta_sucursal_master_as Join vta_sucursal on  vta_sucursal_master_as.SC_ID = vta_sucursal.SC_ID "
                        + "Where vta_sucursal_master_as.SM_ID =" + strSM_ID;
                ResultSet rs = oConn.runQuery(strSQL, true);
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
                strXML.append("<Bodegas>");
                int intSMA_ID = 0;
                int intSM_ID = 0;
                int intSC_ID = 0;
                String strNombre = "";
                while (rs.next()) {
                    intSMA_ID = rs.getInt("SMA_ID");
                    intSM_ID = rs.getInt("SM_ID");
                    intSC_ID = rs.getInt("SC_ID");
                    strNombre = rs.getString("SC_NOMBRE");
                    strXML.append("<Bodega "
                            + " SMA_ID = \"" + intSMA_ID + "\"  "
                            + " SM_ID = \"" + intSM_ID + "\"  "
                            + " SC_ID = \"" + intSC_ID + "\"  "
                            + " SC_NOMBRE = \"" + strNombre + "\"  "
                            + " />");
                }
                rs.close();
                strXML.append("</Bodegas>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }
            if (strid.equals("4")) {
                String strSC_ID = request.getParameter("SC_ID");
                String strSQL = "Select * From vta_sucursal_master_as Where SC_ID = " + strSC_ID;
                String strRes = "OK.";
                ResultSet rs = oConn.runQuery(strSQL, true);
                while (rs.next()) {
                    strRes = "" + rs.getInt("SM_ID");
                    break;
                }
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            //Regresa las bodegas de una empresa
            if (strid.equals("5")) {
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
                strXML.append("<Bodegas>");

                String strEMP_ID = request.getParameter("EMP_ID");
                String strSQL = "Select SC_ID,SC_NOMBRE From vta_sucursal Where EMP_ID = " + strEMP_ID;
                ResultSet rs = oConn.runQuery(strSQL, true);
                while (rs.next()) {
                    strXML.append("<Bodega id=\"" + rs.getInt("SC_ID") + "\" nombre=\"" + rs.getString("SC_NOMBRE") + "\" />");
                }
                rs.close();
                strXML.append("</Bodegas>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML.toString());//Pintamos el resultado
            }
            //Regresa las sucursales de una empresa
            if (strid.equals("6")) {
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
                strXML.append("<Sucursales>");

                String strEMP_ID = request.getParameter("EMP_ID");
                String strSQL = "Select SM_ID,SM_NOMBRE From vta_sucursales_master Where EMP_ID = " + strEMP_ID;
                ResultSet rs = oConn.runQuery(strSQL, true);
                while (rs.next()) {
                    strXML.append("<Sucursal id=\"" + rs.getInt("SM_ID") + "\" nombre=\"" + rs.getString("SM_NOMBRE") + "\" />");
                }
                rs.close();
                strXML.append("</Sucursales>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML.toString());//Pintamos el resultado
            }
            //Regresa las bodegas de una sucursal
            if (strid.equals("7")) {
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
                strXML.append("<Bodegas>");

                String strSM_ID = request.getParameter("SM_ID");
                String strSQL = "SELECT  vta_sucursal.SC_ID,vta_sucursal.SC_NOMBRE "
                        + " FROM vta_sucursal_master_as,  vta_sucursal"
                        + " where  vta_sucursal_master_as.SC_ID =  vta_sucursal.SC_ID "
                        + " and vta_sucursal_master_as.SM_ID = " + strSM_ID;
                ResultSet rs = oConn.runQuery(strSQL, true);
                while (rs.next()) {
                    strXML.append("<Bodega id=\"" + rs.getInt("SC_ID") + "\" nombre=\"" + rs.getString("SC_NOMBRE") + "\" />");
                }
                rs.close();
                strXML.append("</Bodegas>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML.toString());//Pintamos el resultado
            }
            if (strid.equals("8")) {
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
                strXML.append("<Segmento>");
                String strSegmentoIp = "";
                String strSql = "select SC_SEGMENTO_IP from vta_sucursal where SC_ID = " + varSesiones.getIntSucursalDefault();
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    strSegmentoIp = rs.getString("SC_SEGMENTO_IP");
                }
                rs.close();
                strXML.append("<Direccion segmento=\"" + strSegmentoIp + "\" />");
                strXML.append("</Segmento>");
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML.toString());//Pintamos el resultado
            } //fin 8
        }
    }
%>