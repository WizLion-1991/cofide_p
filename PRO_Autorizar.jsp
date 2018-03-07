<%-- 
    Document   : PRO_Autorizar
    Created on : 26/04/2013, 03:18:29 PM
    Author     : SIWEB
--%>


<%@page import="Tablas.cat_vencimiento"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mx.siweb.prosefi.Credito"%>
<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
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
    String strerror = "";
    String strmsg = "";
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        Fechas fecha = new Fechas();
        String strid = request.getParameter("ID");
        if (strid != null) {
        String strRes = "";
            if (strid.equals("2")) {
                
                String strIdCredito = request.getParameter("CTO_ID");
                String yaautorizado = "SELECT * FROM cat_credito WHERE CTO_AUTORIZADO = '1' AND CTO_ID = " + strIdCredito;
                ResultSet rs5 = oConn.runQuery(yaautorizado);
                if(rs5.next()){
                System.out.println("EL CREDITO YA ESTA AUTORIZADO");
                strRes = "EL CREDITO YA ESTA AUTORIZADO";
                //strRes = objCredito.autorizado(oConn);
                }else{
                //AUTORIZAMOS EL CREDITO
                String autorizado = "UPDATE cat_credito SET CTO_AUTORIZADO = '1', CTO_FECHA_AUTORIZADO = " + fecha.getFechaActual() + ", "
                        + "ID_USUARIO_AUTORIZO = " + varSesiones.getIntNoUser() + " WHERE CTO_ID = " + strIdCredito;
                oConn.runQueryLMD(autorizado);

                String strAutoriza = "SELECT * FROM cat_credito a, cat_monto b, cat_amortizacion_master c, cat_amortizacion_deta d "
                        + "where b.MTO_ID = a.MTO_ID AND c.MTO_ID = b.MTO_ID "
                        + "AND d.AMT_ID = c.AMT_ID AND a.CTO_ID = " + strIdCredito;
                //String strConsulta = "SELECT * FROM cat_credito c, cat_obligado o where c.CTO_ID = o.CTO_ID AND o.CTO_ID = " + strId;          
                ResultSet rs = oConn.runQuery(strAutoriza);
                
                Credito objCredito = new Credito();
                while (rs.next()) {

                    objCredito.getObjVencimiento().setFieldString("V_VENCIMIENTO", rs.getString("CT0_FVENCIMIENTO"));
                    objCredito.getObjVencimiento().setFieldInt("V_MOVIMIENTO", 1);
                    objCredito.getObjVencimiento().setFieldInt("CT_ID", rs.getInt("CT_ID"));
                    objCredito.getObjVencimiento().setFieldInt("CTO_ID", rs.getInt("CTO_ID"));
                    objCredito.getObjVencimiento().setFieldDouble("V_IMPORTE", rs.getFloat("AMTD_SALDO"));
                    objCredito.getObjVencimiento().setFieldDouble("V_IVA", rs.getFloat("AMTD_IVAINTERESES"));
                    objCredito.getObjVencimiento().setFieldDouble("V_SALDO", rs.getDouble("MTO_PAGOS"));
                    
                    objCredito.getObjVencimiento().setFieldDouble("V_VALOR_NEGOCIO", rs.getDouble("MTO_PAGOS"));
                    objCredito.getObjVencimiento().setFieldDouble("V_PUNTOS", rs.getDouble("MTO_PAGOS"));
                    
                    objCredito.getObjVencimiento().setFieldDouble("V_CAPITAL", rs.getFloat("AMTD_AMORTCAPITAL"));
                    objCredito.getObjVencimiento().setFieldDouble("V_INTERES", rs.getFloat("AMTD_INTERESES"));
                    strRes = objCredito.autorizado(oConn);
                }
                rs.close();

                
            }
                
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strRes);//Mandamos a pantalla el resultado

            }

        }
    }
%>           
