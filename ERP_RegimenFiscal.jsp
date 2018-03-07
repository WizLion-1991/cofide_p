<%-- 
    Document   : uni_regimen
    Created on : 15-abr-2012, 12:17:02
    Author     : Sergio
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.SQLDataException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.VariableSession" %>
<%@page import="comSIWeb.ContextoApt.atrJSP" %>
<%@page import="comSIWeb.ContextoApt.Seguridad" %>
<%@page import="comSIWeb.Utilerias.Fechas" %>
<%@page import="comSIWeb.Operaciones.Conexion" %>
<%@page import="comSIWeb.Operaciones.TableMaster" %>
<%@page import="Tablas.vta_mov_cta_bcos" %>
<%@page import="Tablas.vta_mov_cta_bcos_deta" %>
<%@page import="ERP.Bancos" %>
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
        String strid = request.getParameter("ID");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            //Sirve para obtener los regimen fiscal de cierta empresa
            if (strid.equals("1")) {

                String strId = request.getParameter("idEmp");// es el id de la empresa
                int intCon = 0;
                String strXMLData = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                strXMLData += "<folios>";
                strXMLData += "<folio>";
                try {
                    //SACAMOS LAS PÀRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strSelect = "select a.REGF_ID,a.REGF_DESCRIPCION"
                            + " from vta_regimenfiscal a, vta_empregfiscal b"
                            + " where a.REGF_ID = b.REGF_ID"
                            + " and b.EMP_ID=" + strId;

                    ResultSet rs = oConn.runQuery(strSelect);
                    while (rs.next()) {
                        strXMLData += "<datos";
                        strXMLData += " REGF_ID" + intCon + "=\'" + rs.getInt("REGF_ID") + "\'";
                        strXMLData += " REGF_DESCRIPCION" + intCon + "=\'" + rs.getString("REGF_DESCRIPCION") + "\'";
                        strXMLData += "/>";
                    }

                    rs.close();

                } catch (SQLException ex) {
                    ex.fillInStackTrace();

                }
                strXMLData += "</folio>";
                strXMLData += "</folios>";

                String strRes = strXMLData;
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            //Sirve para eliminar un regimen fiscal
            if (strid.equals("2")) {
                String strId = request.getParameter("idReg");
                try {
                    //SACAMOS LAS PÀRTIDAS CORRESPONDIENTES AL PEDIDO
                    String strDelete = "DELETE FROM vta_empregfiscal"
                            + " WHERE EMPR_ID=" + strId;

                    oConn.runQueryLMD(strDelete);

                } catch (Exception ex) {
                    ex.fillInStackTrace();

                }
                String strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            //Sirve para dar de alta un regimen fiscal
            if (strid.equals("3")) {
                String strRes = "";
                String strId = request.getParameter("idReg");
                String strEmpId = request.getParameter("idEmp");
                boolean bolExist = false;
                try {
                    //buscamos si ya existe el regimen para la empresa
                    String strSelect = "select * from vta_empregfiscal"
                            + " where REGF_ID=" + strId
                            + " and EMP_ID=" + strEmpId;

                    ResultSet rs = oConn.runQuery(strSelect);
                    while (rs.next()) {
                        bolExist = true;//si existe ponemos verdadero
                        strRes = "NO";
                    }
                    rs.close();
                    if (bolExist==false) {
                        //SACAMOS LAS PÀRTIDAS CORRESPONDIENTES AL PEDIDO
                        String strInsert = "INSERT INTO vta_empregfiscal(EMP_ID,REGF_ID)"
                                + " VALUES(" + strEmpId + "," + strId + ")";

                        oConn.runQueryLMD(strInsert);
                        strRes = "OK";
                    }
                } catch (Exception ex) {
                    ex.fillInStackTrace();

                }

                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
        }
    } else {
    }
    oConn.close();
%>