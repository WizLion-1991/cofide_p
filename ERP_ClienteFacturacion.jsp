<%-- 
    Document   : ERP_ClienteFacturacion
    Created on : 10/04/2014, 07:02:56 PM
    Author     : siwebmx5
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="ERP.ClienteFacturacion"%>
<%@page import="Tablas.vta_cliente_facturacion"%>
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
            //OBTENEMOS LAS DIRECCIONES DE ENTREGA DEL CLIENTE SELECCIONADO
            if (strid.equals("1")) {
                ClienteFacturacion CF = new ClienteFacturacion(varSesiones);
                int intId = 0;
                if (request.getParameter("ct_id") != null) {
                    intId = Integer.parseInt(request.getParameter("ct_id"));
                }
                
                String strRespXML = CF.getDirecciones(intId, oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado
              
            }
            
            //SIRVE PARA DAR DE ALTA UNA NUEVA DIRECCION DE ENTREGA
            if (strid.equals("2")) {
                ClienteFacturacion dir = new ClienteFacturacion(varSesiones);
                int intId = 0;

                dir.getCF().setFieldString("DFA_CALLE", request.getParameter("DFA_CALLE"));
                dir.getCF().setFieldString("DFA_COLONIA", request.getParameter("DFA_COLONIA"));
                dir.getCF().setFieldString("DFA_LOCALIDAD", request.getParameter("DFA_LOCALIDAD"));
                dir.getCF().setFieldString("DFA_MUNICIPIO", request.getParameter("DFA_MUNICIPIO"));
                dir.getCF().setFieldString("DFA_ESTADO", request.getParameter("DFA_ESTADO"));
                dir.getCF().setFieldString("DFA_CP", request.getParameter("DFA_CP"));
                dir.getCF().setFieldString("DFA_NUMERO", request.getParameter("DFA_NUMERO"));
                dir.getCF().setFieldString("DFA_NUMINT", request.getParameter("DFA_NUMINT"));
                dir.getCF().setFieldString("DFA_TELEFONO", request.getParameter("DFA_TELEFONO"));
                dir.getCF().setFieldString("DFA_RAZONSOCIAL", request.getParameter("DFA_RAZONSOCIAL"));
                dir.getCF().setFieldString("DFA_RFC", request.getParameter("DFA_RFC"));
                dir.getCF().setFieldString("DFA_EMAIL", request.getParameter("DFA_EMAIL"));
                dir.getCF().setFieldString("DFA_PAIS", request.getParameter("DFA_PAIS"));
                dir.getCF().setFieldInt("DFA_VISIBLE", Integer.parseInt(request.getParameter("DFA_VISIBLE")));
                
                if (request.getParameter("CT_ID") != null) {
                    try {
                        intId = Integer.parseInt(request.getParameter("CT_ID"));
                    } catch (NumberFormatException e) {
                        e.getMessage();
                    }
                }
                dir.getCF().setFieldInt("CT_ID", intId);
                

                String strRespXML = dir.saveClienteFacturacion(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado

            }
            
            //NOS REGRESA TRUE O FALSE DE SI YA FUE USADA LA DIRECCION
            if (strid.equals("3")) {

                int intIdDir = 0;
                ResultSet rs;
                String strResp = "";
                if (request.getParameter("id_dir") != null) {
                    intIdDir = Integer.parseInt(request.getParameter("id_dir"));
                }

                try {
                    String strSelect = "SELECT count(DFA_ID) as NUM FROM vta_facturas WHERE DFA_ID =" + intIdDir;
                    rs = oConn.runQuery(strSelect);

                    while (rs.next()) {

                        strResp = "OK";
                    }

                } catch (SQLException Ex) {
                    strResp = Ex.getMessage();
                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado

            }
            //SIRVE PARA BORRAR UNA DIRECCION DE ENTREGA DE LA BASE DE DATOS
            if (strid.equals("4")) {
                ClienteFacturacion dir = new ClienteFacturacion(varSesiones);
                int intId = 0;
                if (request.getParameter("dir_id") != null) {
                    intId = Integer.parseInt(request.getParameter("dir_id"));
                    dir.getCF().setFieldInt("CDE_ID", intId);
                }
                String strResp = dir.delClienteFacturacion(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado

            }
            //SIRVE PARA BORRAR UNA DIRECCION DE ENTREGA DE LA BASE DE DATOS
            if (strid.equals("4")) {
                ClienteFacturacion dir = new ClienteFacturacion(varSesiones);
                int intId = 0;
                if (request.getParameter("dir_id") != null) {
                    intId = Integer.parseInt(request.getParameter("dir_id"));
                    dir.getCF().setFieldInt("DFA_ID", intId);
                }
                String strResp = dir.delClienteFacturacion(oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strResp);//Mandamos a pantalla el resultado

            }
            if (strid.equals("5")) {
                ClienteFacturacion CF = new ClienteFacturacion(varSesiones);
                int intId = 0;
                if (request.getParameter("ct_id") != null) {
                    intId = Integer.parseInt(request.getParameter("ct_id"));
                }
                
                String strRespXML = CF.getNombres(intId, oConn);
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRespXML);//Mandamos a pantalla el resultado
              
            }
        }
    }
 %>