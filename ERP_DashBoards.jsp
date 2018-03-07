<%-- 
    Document   : ERP_DashBoards
    Created on : 11-feb-2015, 12:51:40
    Author     : ZeusGalindo
--%>
<%@page import="com.siweb.utilerias.json.JSONArray"%>
<%@page import="Tablas.Dashboard_Params"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mx.siweb.erp.reportes.DashboardGenerator"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%
    Fechas fecha = new Fechas();
    /*Atributos generales de la pagina*/
    atrJSP.atrJSP(request, response, true, false);
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    Seguridad seg = new Seguridad();
    //Abrimos la conexion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("ID");

        if (strid == null) {
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<form id="dash_boards">
    <div id="DashBoardMain" class="panel">
        <h1>Tableros de control</h1>
    </div>
    <%
        //Recuperamos dashboards por mostrar
        ArrayList<DashboardGenerator> lst = DashboardGenerator.InitAllAbrvTipo(oConn, "VENTAS");
        Iterator<DashboardGenerator> it = lst.iterator();
        while (it.hasNext()) {
            DashboardGenerator board = it.next();
    %>
    <section class="panel widget  allow_push loading" id="dash<%=board.getDashboard().getFieldString("DB_ABRV")%>">
        <input type="hidden" id="Abrv" name="Abrv" value="<%=board.getDashboard().getFieldString("DB_ABRV")%>" />
        <header class="panel-heading">
            <i class="fa fa-bar-chart"></i> <%=board.getDashboard().getFieldString("DB_NOMBRE")%>
            <span class="panel-heading-action">
                <a title="configure" onclick="toggleDashConfig('dashproducts');
                        return false;" href="#" class="list-toolbar-btn">
                    <i class="fa fa-cog">&nbsp;Configurar</i>
                </a>
                <a title="refresh" onclick="InitDashBoards('dashproducts');
                        return false;" href="#" class="list-toolbar-btn">
                    <i class="fa fa-refresh">&nbsp;Actualizar</i>
                </a>
            </span>
        </header>

        <!-- Begin Tabs-->
        <div id="tabs<%=board.getDashboard().getFieldString("DB_ABRV")%>">
            <ul>
                <%
                    Iterator<TableMaster> itDeta = board.getLstDeta().iterator();
                    int intContaDeta = 0;
                    while (itDeta.hasNext()) {
                        TableMaster deta = itDeta.next();
                        //Solo visualizamos las graficas marcadas como activas...
                        if (deta.getFieldInt("DB_ACTIVO") == 1) {
                            intContaDeta++;
                %>
                <li><a href="#tabs-<%=intContaDeta%>"><%=deta.getFieldString("DB_TITULO")%></a></li>
                    <%
                       }
                   }%>
            </ul>

            <%
                intContaDeta = 0;
                itDeta = board.getLstDeta().iterator();
                while (itDeta.hasNext()) {
                    TableMaster deta = itDeta.next();
                    //Solo visualizamos las graficas marcadas como activas...
                    if (deta.getFieldInt("DB_ACTIVO") == 1) {
                        intContaDeta++;
                     //Ponemos los parametros configurados por la grafica
            %>
            <div class="dashboard_params">
                <%
                    //Variables para totales
                    String strNomNames = "";
                    String strNomTypes = "";
                    //Obtenemos los parametros
                    Iterator<TableMaster> itParams = board.getLstParams().iterator();
                    while (itParams.hasNext()) {
                        TableMaster param = (Dashboard_Params) itParams.next();
                        if (param.getFieldInt("DBD_ID") == deta.getFieldInt("DBD_ID")) {
                            String strName = deta.getFieldInt("DBD_ID") + param.getFieldString("DBP_NAME");
                            String strTitulo = param.getFieldString("DBP_TITLE");
                            String strTipo = param.getFieldString("DBP_TIPO");
                            String strValorDefa = board.GetValorDefault(param.getFieldString("DBP_VALOR_DEFA"), varSesiones);
                            //Juntamos los parametros
                            strNomNames += strName + "|";
                            strNomTypes += strTipo + "|";
                      //Dependiendo del tipo dibujamos los controles
                            //Texto
                            if (strTipo.equals("text")) {
                %>
                <%=strTitulo%>&nbsp;<input type="text" name="<%=strName%>" id="<%=strName%>" value="<%=strValorDefa%>" />
                <%
                    }
                    //Select
                    if (strTipo.equals("select")) {
                %>
                <%=strTitulo%>&nbsp;<select id="<%=strName%>">
                    <%
                        //EValuamos si podemos ejecutar la consulta
                        if (!param.getFieldString("DBP_TABLA").isEmpty()
                                && !param.getFieldString("DBP_KEY").isEmpty()
                                && !param.getFieldString("DBP_SHOW").isEmpty()) {
                            String strCondPost = param.getFieldString("DBP_POST");
                            //Reemplazamos variables de sesion
                            if (strCondPost.contains("[FECHA]")) {
                                strCondPost = strCondPost.replace("[FECHA]", fecha.getFechaActualDDMMAAAADiagonal());
                            }
                            if (strCondPost.contains("[HORA]")) {
                                strCondPost = strCondPost.replace("[HORA]", fecha.getHoraActual());
                            }
                            if (strCondPost.contains("[no_user]")) {
                                strCondPost = strCondPost.replace("[no_user]", varSesiones.getIntNoUser() + "");
                            }
                            if (strCondPost.contains("[anio]")) {
                                strCondPost = strCondPost.replace("[anio]", varSesiones.getIntAnioWork() + "");
                            }
                            if (strCondPost.contains("[ANIO]")) {
                                strCondPost = strCondPost.replace("[ANIO]", fecha.getAnioActual() + "");
                            }
                            if (strCondPost.contains("[MES]")) {
                                String strMes = "0" + fecha.getMesActual();
                                if (strMes.length() == 3) {
                                    strMes = strMes.substring(1, 3);
                                }
                                strCondPost = strCondPost.replace("[MES]", strMes);
                            }
                            if (strCondPost.contains("[Empresa]")) {
                                strCondPost = strCondPost.replace("[Empresa]", varSesiones.getIntClienteWork() + "");
                            }
                            if (strCondPost.contains("[idcliente]")) {
                                strCondPost = strCondPost.replace("[idcliente]", varSesiones.getintIdCliente() + "");
                            }
                            if (strCondPost.contains("[SUCURSAL]")) {
                                strCondPost = strCondPost.replace("[SUCURSAL]", varSesiones.getIntSucursalDefault() + "");
                            }
                            if (strCondPost.contains("[LSTSUCURSAL]")) {
                                strCondPost = strCondPost.replace("[LSTSUCURSAL]", varSesiones.getStrLstSucursales() + "");
                            }
                            if (strCondPost.toUpperCase().contains("[EMPRESADEF]")) {
                                strCondPost = strCondPost.replace("[EMPRESADEF]".toUpperCase(), varSesiones.getIntIdEmpresa() + "");
                            }

                            StringBuilder strSql = new StringBuilder("select ");
                            if (!param.getFieldString("DBP_PRE").isEmpty()) {
                                strSql.append(param.getFieldString("DBP_PRE"));
                            }
                            strSql.append(" " + param.getFieldString("DBP_KEY") + ","
                                    + " " + param.getFieldString("DBP_SHOW") + " from " + param.getFieldString("DBP_TABLA"));
                            if (!strCondPost.isEmpty()) {
                                strSql.append(strCondPost);
                            }
                            try {
                                ResultSet rs = oConn.runQuery(strSql.toString(), true);
                                while (rs.next()) {
                                    if (strValorDefa.equals(rs.getString(1))) {
                    %><option value="<%=rs.getString(1)%>" selected><%=rs.getString(2)%></option><%
                    } else {
                    %><option value="<%=rs.getString(1)%>"><%=rs.getString(2)%></option><%
                                }

                            }
                            rs.close();
                        } catch (Exception ex) {
                            System.out.println(" " + ex.getMessage());
                        }
                    } else {
                    %><option value="0">ERROR: LE FALTAN DATOS AL PARAMETRO</option><%                     }
                        %>
                </select>
                <%
                    }
                    //Fecha
                    if (strTipo.equals("date")) {
                %>
                <%=strTitulo%>&nbsp;<input type="text" name="<%=strName%>" id="<%=strName%>" value="<%=strValorDefa%>" />
                <%
                    }
                    //Oculto
                    if (strTipo.equals("hidden")) {
                %>
                <%=strTitulo%>&nbsp;<input type="hidden" name="<%=strName%>" id="<%=strName%>" value="<%=strValorDefa%>" />
                <%
                    }
                    //CheckBox
                    if (strTipo.equals("checkbox")) {
                %>
                <%=strTitulo%>&nbsp;<input type="checkbox" name="<%=strName%>" id="<%=strName%>" value="<%=strValorDefa%>" />
                <%
                    }
                    //Radio
                    if (strTipo.equals("radio")) {
                %>
                <%=strTitulo%>&nbsp;Si<input type="radio" name="<%=strName%>" id="<%=strName%>a" value="<%=strValorDefa%>" />
                &nbsp;No<input type="radio" name="<%=strName%>" id="<%=strName%>b" value="<%=strValorDefa%>" />
                <%
                            }
                        }
                    }
                %>
            </div>
            <input type="hidden" name="DashIds" id="DashIds" value="<%=deta.getFieldString("DBD_ID")%>">
            <input type="hidden" name="NamesDash" id="NamesDash" value="<%=deta.getFieldString("DB_NOMBRE")%>">
            <input type="hidden" name="NamesTypes" id="NamesTypes" value="<%=deta.getFieldString("DB_TIPO_GRAFICA")%>">
            <input type="hidden" name="lst_paramNames<%=deta.getFieldInt("DBD_ID")%>" id="lst_paramNames<%=deta.getFieldInt("DBD_ID")%>" value="<%=strNomNames%>" />
            <input type="hidden" name="lst_paramTypes<%=deta.getFieldInt("DBD_ID")%>" id="lst_paramTypes<%=deta.getFieldInt("DBD_ID")%>" value="<%=strNomTypes%>" />
            <div id="tabs-<%=intContaDeta%>">
                <div id="divChart<%=deta.getFieldString("DB_NOMBRE")%>" style="min-width:<%=deta.getFieldString("DB_WIDTH")%>px; height:<%=deta.getFieldString("DB_HEIGHT")%>px; margin: 0 auto" class="panel">
                </div>
            </div>
            <%
                 }
             }%>

        </div>
    </section>
</form>
<%
        }
    } else {
        if (strid.equals("1")) {
            JSONArray jsonChild = new JSONArray();
            ArrayList<DashboardGenerator> lstDash = DashboardGenerator.InitAllAbrvTipo(oConn, "VENTAS");
            Iterator<DashboardGenerator> it = lstDash.iterator();
            while (it.hasNext()) {
                DashboardGenerator dash = it.next();
                dash.GetParams(request);
                jsonChild.put(dash.DoDashboard());
            }
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
            out.println(jsonChild.toString());//Mandamos a pantalla el resultado
        }
    }
%>
<%         }
    oConn.close();
%>