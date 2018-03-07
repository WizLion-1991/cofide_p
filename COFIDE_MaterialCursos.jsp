<%-- 
    Document   : COFIDE_MaterialCursos
    Created on : 30-oct-2016, 1:19:47
    Author     : Fernando
--%>

<%@page import="java.io.File"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.sql.SQLException"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    UtilXml util = new UtilXml();
    Fechas fec = new Fechas();
    String strRes = "";
    String strSql = "";
    ResultSet rs = null;

    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("id");
        if (strid != null) {
            //Consulta el Catalogo de Cursos para asignar material
            if (strid.equals("1")) {
                String strMes = request.getParameter("strMes");
                String strAnio = request.getParameter("strAnio");
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<CursosMaterial>");
                if (strMes.equals("0")) {
                    strMes = fec.getFechaActual().substring(4, 6);
                }
                strSql = "SELECT CC_CURSO_ID,CC_NOMBRE_CURSO,CC_SEDE,CC_FECHA_INICIAL,CC_MATERIAL "
                        + "FROM cofide_cursos where CC_FECHA_INICIAL like '%" + strAnio + strMes + "%' and CC_CLAVES <> '' order by CC_FECHA_INICIAL";
                try {
                    rs = oConn.runQuery(strSql, true);
                    while (rs.next()) {
                        String strSedeAsig = "";
                        String strFechaAsig = "";
                        if (rs.getString("CC_SEDE") != null) {
                            strSedeAsig = util.Sustituye(rs.getString("CC_SEDE"));
                        }
                        if (rs.getString("CC_FECHA_INICIAL") != null) {
                            strFechaAsig = fec.FormateaDDMMAAAA(rs.getString("CC_FECHA_INICIAL"), "/");
                        }
                        strXML.append("<datos");
                        strXML.append(" CC_CURSO_ID = \"").append(rs.getInt("CC_CURSO_ID")).append("\"");
                        strXML.append(" CC_NOMBRE_CURSO = \"").append(util.Sustituye(rs.getString("CC_NOMBRE_CURSO"))).append("\"");
                        strXML.append(" CC_SEDE = \"").append(util.Sustituye(strSedeAsig)).append("\"");
                        strXML.append(" CC_FECHA_INICIAL = \"").append(strFechaAsig).append("\"");
                        strXML.append(" CC_MATERIAL = \"").append((existMaterialCurso(oConn, rs.getInt("CC_CURSO_ID")) == true ? "SI" : "NO")).append("\"");
                        strXML.append(" />");
                    }
                    rs.close();
                    strXML.append("</CursosMaterial>");
                } catch (SQLException ex) {
                    System.out.println("Error GetConsulta CURSOS Material: " + ex.getLocalizedMessage());
                }
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado

            }//Fin ID 1

            //Consulta archivos de un fichero en especifico
            if (strid.equals("2")) {
                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<materialSelect>");
                String sDirectorio = getPathMaterial(oConn, varSesiones.getIntIdEmpresa());
                File f = new File(sDirectorio);
                File[] ficheros = f.listFiles();
                for (int x = 0; x < ficheros.length; x++) {
                    if (ficheros[x].isFile()) {
                        strXML.append("<datos");
                        strXML.append(" MC_NOMBRE_MATERIAL = \"").append(util.Sustituye(ficheros[x].getName())).append("\"");
                        strXML.append(" />");
                    }
                }
                strXML.append("</materialSelect>");
                strXML.toString();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }//Fin ID 2
            
            //Guarda un Registro del Material Asignado al curso
            if (strid.equals("3")) {
                strRes = "OK";
                String strIdCurso = request.getParameter("IdCurso");
                String strNomCurso = request.getParameter("NombreCurso");
                String strFechaDesde = request.getParameter("FechaDesde");
                String strFechaHasta = request.getParameter("FechaHasta");
                String strNombreMaterial = request.getParameter("NombreMaterial");
                strSql = "insert into cofide_material_cursos(CC_NOMBRE_CURSO, CC_CURSO_ID, MC_FECHA_HASTA, MC_FECHA_DESDE, MC_NOMBRE_MATERIAL) "
                        + "values ('" + strNomCurso + "', '" + strIdCurso + "', '" + fec.FormateaBD(strFechaDesde, "/") + "', '" + fec.FormateaBD(strFechaHasta, "/") + "', '" + strNombreMaterial + "')";
                oConn.runQueryLMD(strSql);
                if(oConn.getStrMsgError().equals("")){
                    strRes = "OK";
                }else{
                    strRes = oConn.getStrMsgError();
                }
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }//Fin ID 3
        }
        oConn.close();
    } else {
        out.print("Sin Acceso");
    }


%>

<%!

String strSql = "";
ResultSet rs = null;

public String getPathMaterial(Conexion oConn, int intEMP_ID){
    String strPathMat = "";
    strSql  = "select EMP_PATH_MATERIALES from vta_empresas where EMP_ID = " + intEMP_ID;
    try{
        rs = oConn.runQuery(strSql, true);
        while(rs.next()){
            strPathMat = rs.getString("EMP_PATH_MATERIALES");
        }
        rs.close();
    }catch(SQLException ex){
        System.out.println("Path Materiales curso [ERROR] : " + ex.getLocalizedMessage());
    }
    return strPathMat;
}

public boolean existMaterialCurso(Conexion oConn, int intCursoID){
    boolean blExist = false;
    strSql = "SELECT * from cofide_material_cursos where CC_CURSO_ID = " + intCursoID;
    try{
        rs = oConn.runQuery(strSql, true);
        while(rs.next()){
            blExist = true;
        }
        rs.close();
    }catch(SQLException ex){
        System.out.println("Existe Material para el curso [ERROR] : " + ex.getLocalizedMessage());
    }
    return blExist;
}

%>