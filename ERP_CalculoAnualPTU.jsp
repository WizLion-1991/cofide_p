<%-- 
    Document   : ERP_CalculoAnualPTU
    Created on : Jul 23, 2015, 9:17:32 AM
    Author     : CasaJosefa
--%>


<%@page import="com.mx.siweb.erp.nominas.Entidades.CalculoAnualPTUE"%>
<%@page import="com.mx.siweb.erp.nominas.CalculoAnualPTU"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.mx.siweb.erp.reportes.RepoPreNomina"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="com.sun.xml.rpc.processor.modeler.j2ee.xml.string"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.ResultSet"%>
<%

    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad(); //Valida que la peticion se halla hecho desde el mismo sitio
    Fechas fecha = new Fechas();
    UtilXml util = new UtilXml();

    System.out.println();

    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        //Obtenemos parametros
        String strid = request.getParameter("id");

        //Si la peticion no fue nula proseguimos
        String strPathBaseimg = this.getServletContext().getRealPath("/");
        String strSeparatorimg = System.getProperty("file.separator");
        if (strSeparatorimg.equals("\\")) {
            strSeparatorimg = "/";
            strPathBaseimg = strPathBaseimg.replace("\\", "/");
        }

        //Si la peticion no fue nula proseguimos
        if (!strid.equals(null)) {

            if (strid.equals("1")) {

                String strAnio = request.getParameter("intAnio");
                String strTipoNomina = request.getParameter("intTipoNomina");
                double dblMontoDistribuir = Double.parseDouble(request.getParameter("dblMontoDistribuir"));

                CalculoAnualPTU ca = new CalculoAnualPTU(oConn, varSesiones, strAnio, strTipoNomina, dblMontoDistribuir);
                ca.CalculoPTU();

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(ca.GeneraXmlPTU());//Pintamos el resultado
            }

            if (strid.equals("2")) {

                ArrayList<CalculoAnualPTUE> entidades = new ArrayList();

                String strAnio = request.getParameter("intAnio");
                String strTipoNomina = request.getParameter("intTipoNomina");
                double dblMontoDistribuir = Double.parseDouble(request.getParameter("dblMontoDistribuir"));
                int idArr = Integer.parseInt(request.getParameter("intlenghtArr"));

                CalculoAnualPTU ca = new CalculoAnualPTU(oConn, varSesiones, strAnio, strTipoNomina, dblMontoDistribuir);

                for (int i = 0; i < idArr; i++) {
                    CalculoAnualPTUE e = new CalculoAnualPTUE();
                    e.setNumero(Integer.parseInt(request.getParameter("EMP_NUM" + i)));
                    e.setPtuDias(Double.parseDouble(request.getParameter("PTU_DIAS" + i)));
                    e.setPtuSalario(Double.parseDouble(request.getParameter("PTU_SALARIO" + i)));
                    e.setPtuTotal(Double.parseDouble(request.getParameter("PTU_TOTAL" + i)));

                    entidades.add(e);
                }

                String respuesta = ca.GuardaPtu(strAnio, entidades);

                String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXML += "<respuesta>";

                strXML += "<respuesta_deta "
                        + " strRespuesta = \"" + respuesta + "\"  "
                        + " />";

                strXML += "</respuesta>";

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }
        }
    } else {
        out.println("Sin acceso");
    }
    oConn.close();


%>