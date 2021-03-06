<%@page import="java.sql.ResultSet"%>
<%@page import="com.mx.siweb.mlm.utilerias.Redes"%>
<%@page import="Tablas.vta_cliente"%>
<%@page import="com.mx.siweb.mlm.compensacion.Periodos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0) {

        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();

        //Parametros para visualizar acotado
        boolean bolAcotado = false;
        int intMaxNiveles = 3;
        String strCampoFiltro = "CT_UPLINE";
        String strTituloTipo = "Descendencia";
        int intContHijos = 0;

        //Cargamos datos iniciales
        Fechas fecha = new Fechas();
        Periodos periodo = new Periodos();
        String strPeriodo = periodo.getPeriodoActualNom(oConn);
        //Obtenemos datos del cliente
        vta_cliente cliente = new vta_cliente();
        cliente.ObtenDatos(varSesiones.getintIdCliente(), oConn);

        String strModo = request.getParameter("Modo");
        int intNumeroNiveles = 0;

        if (strModo != null) {

            strCampoFiltro = "CT_UPLINE";
            strTituloTipo = " - Mi red ";

        }

      //Obtenemos el nombre del cliente

%>
<link rel="stylesheet" href="../jqGrid/jOrgChart/css/bootstrap.min.css"/>
<link rel="stylesheet" href="../jqGrid/jOrgChart/css/jquery.jOrgChart.css"/>
<link rel="stylesheet" href="../jqGrid/jOrgChart/css/custom.css"/>
<link href="../jqGrid/jOrgChart/css/prettify.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../jqGrid/jOrgChart/prettify.js"></script>

<!-- jQuery includes -->
<script src="../jqGrid/jOrgChart/jquery.jOrgChart.js"></script>

<script>
    jQuery(document).ready(function () {
        $("#org").jOrgChart({
            chartElement: '#chart',
            dragAndDrop: true
        });
        $("#dialogDeta").dialog({autoOpen: false, draggable: true, modal: true, resizable: true, show: 'slide', position: 'top', width: "auto"});
    });
    /**Muestra la información del nodo seleccionado*/
    function ShowDetails(id) {
        $.ajax({
            type: "POST",
            data: "CT_ID=" + id,
            scriptCharset: "utf-8",
            contentType: "application/x-www-form-urlencoded;charset=utf-8",
            cache: false,
            dataType: "html",
            url: "modules/mod_fz/mlm_red_grid.jsp?ID=2",
            success: function (contenido) {
                document.getElementById("dialogDeta_inside").innerHTML = contenido;
                $("#dialogDeta").dialog("open");
            },
            error: function (objeto, quepaso, otroobj) {
                alert("detalle distribuidor" + objeto + " " + quepaso + " " + otroobj);
            }
        });

    }
</script>

<div class="well ">
    <h3 class="page-header">Mi red <%=cliente.getFieldString("CT_NOMBRE")%>&nbsp;<%=cliente.getFieldString("CT_APATERNO")%>&nbsp;<%=cliente.getFieldString("CT_AMATERNO")%>&nbsp;<%=strTituloTipo%>&nbsp;-<a href="index.jsp?mod=red_grafica">Ir al inicio&nbsp;-<a href="index.jsp?mod=FZWebRed">Otro tipo de red</a></h3>
    <div class="userdata">       
        <div id="form-new-submit" class="control-group">
            <div class="controls">
                <span class="required"></span>
            </div>

            <!--Lista para el organigrama-->
            <ul id="org" style="display:none">
                <!--Inicia lista-->
                <%
                    //Aqui generamos la lista con los 3 primeros niveles de la red
                    String strNodoHijo = request.getParameter("NodoHijo");
                    int intNodoHijo = 0;
                    try {
                        intNodoHijo = Integer.valueOf(strNodoHijo);
                    } catch (NumberFormatException ex) {
                    }
                    //Evaluamos si consultamos un nodo hijo o el nodo inicial
                    int intNodoPintar = 0;
                    if (intNodoHijo == 0) {
                        intNodoPintar = varSesiones.getintIdCliente();
                    } else {
                        //Validamos que el nodo hijo por pintar este en su red
                      /*boolean bolValido = Redes.esPartedelaRed(oConn, "vta_cliente", "CT_UPLINE", "CT_ID", varSesiones.getintIdCliente(), intNodoHijo);
                         if (bolValido) {*/
                        intNodoPintar = intNodoHijo;
                        /*} else {
                         intNodoPintar = varSesiones.getintIdCliente();
                         }*/
                    }

                    //Obtenemos datos del cliente por pintar
                    vta_cliente clientePintar = new vta_cliente();
                    clientePintar.ObtenDatos(intNodoPintar, oConn);
                %>
                <li>
                    <%=clientePintar.getFieldString("CT_ID")%>
                    <img src="../images/mlm/User.png" border="0" alt="" title="" />
                    <div class="nom_ini"><%=clientePintar.getFieldString("CT_RAZONSOCIAL")%></div>
                    <ul>
                        <%
                            //Consulta de hijos
                            int intNumGeneraciones = clientePintar.getFieldInt("CT_NUMGENERACIONES");

                            String strSql = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + intNodoPintar;
                            ResultSet rs = oConn.runQuery(strSql, true);
                            while (rs.next()) {
                                intContHijos++;
                                String strNomImg = "User.png";
                                if (rs.getDouble("CT_PPUNTOS") == 0) {
                                    strNomImg = "User_Inac.png";
                                }
                        %><li id="n1_<%=rs.getInt("CT_ID")%>">
                            <%=rs.getInt("CT_ID")%>
                            <a href="index.jsp?mod=red_grafica&NodoHijo=<%=rs.getInt("CT_ID")%>">
                                <img src="../images/mlm/<%=strNomImg%>" border="0" alt="<%=rs.getString("CT_RAZONSOCIAL")%>" title="<%=rs.getString("CT_RAZONSOCIAL")%>" /></a>
                            <a href="javascript:ShowDetails(<%=rs.getInt("CT_ID")%>)">(+)</a>
                            <div class="nom_small"><%=rs.getString("CT_RAZONSOCIAL")%>
                            </div>
                            <%
                                //Consultamos los nietos
                                boolean bolDrawUl = true;
                                String strSql2 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs.getInt("CT_ID");
                                ResultSet rs2 = oConn.runQuery(strSql2, true);
                                while (rs2.next()) {
                                    intContHijos++;
                                    String strNomImg2 = "User.png";
                                    if (rs2.getDouble("CT_PPUNTOS") == 0) {
                                        strNomImg2 = "User_Inac.png";
                                    }
                                    if (bolDrawUl) {
                                        out.println("<ul>");
                                        bolDrawUl = false;
                                    }
                            %><li id="n2_<%=rs2.getInt("CT_ID")%>">
                            <% out.print(rs2.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg2 + "\" border=\"0\" alt=\"" + rs2.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs2.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs2.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs2.getString("CT_RAZONSOCIAL") + "</div>");

                                //Consultamos los Bisnietos
                                boolean bolDrawUl3 = true;
                                String strSql3 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs2.getInt("CT_ID");
                                ResultSet rs3 = oConn.runQuery(strSql3, true);
                                while (rs3.next()) {
                                    intContHijos++;
                                    String strNomImg3 = "User.png";
                                    if (rs3.getDouble("CT_PPUNTOS") == 0) {
                                        strNomImg3 = "User_Inac.png";
                                    }
                                    if (bolDrawUl3) {
                                        out.println("<ul>");
                                        bolDrawUl3 = false;
                                    }
                            %><li id="n2_<%=rs3.getInt("CT_ID")%>">
                            <% out.print(rs3.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg3 + "\" border=\"0\" alt=\"" + rs3.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs3.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs3.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs3.getString("CT_RAZONSOCIAL") + "</div>");
                                /**
                                 * ** VALIDA 4 GENERACION *
                                 */
                                if (intNumGeneraciones >= 4) {
                                    //Consultamos la quinta generacion
                                    boolean bolDrawUl4 = true;
                                    String strSql4 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs3.getInt("CT_ID");
                                    ResultSet rs4 = oConn.runQuery(strSql4, true);

                                    while (rs4.next()) {
                                        String strNomImg4 = "User.png";
                                        if (rs4.getDouble("CT_PPUNTOS") == 0) {
                                            strNomImg4 = "User_Inac.png";
                                        }
                                        if (bolDrawUl4) {
                                            out.println("<ul>");
                                            bolDrawUl4 = false;
                                        }
                            %><li id="n3_<%=rs4.getInt("CT_ID")%>">
                            <% out.print(rs4.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg4 + "\" border=\"0\" alt=\"" + rs4.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs4.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs4.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs4.getString("CT_RAZONSOCIAL") + "</div>");
                                /**
                                 * ** VALIDA 5 GENERACION *
                                 */
                                if (intNumGeneraciones >= 5) {
                                    //Consultamos la sexta generacion
                                    boolean bolDrawUl5 = true;
                                    String strSql5 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs4.getInt("CT_ID");
                                    ResultSet rs5 = oConn.runQuery(strSql5, true);
                                    while (rs5.next()) {
                                        String strNomImg5 = "User.png";
                                        if (rs5.getDouble("CT_PPUNTOS") == 0) {
                                            strNomImg5 = "User_Inac.png";
                                        }
                                        if (bolDrawUl5) {
                                            out.println("<ul>");
                                            bolDrawUl5 = false;
                                        }
                            %><li id="n4_<%=rs5.getInt("CT_ID")%>">
                            <% out.print(rs5.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg5 + "\" border=\"0\" alt=\"" + rs5.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs5.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs5.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs5.getString("CT_RAZONSOCIAL") + "</div>");
                                /**
                                 * ** VALIDA 6 GENERACION *
                                 */
                                if (intNumGeneraciones >= 6) {
                                    //Consultamos la septima generacion
                                    boolean bolDrawUl6 = true;
                                    String strSql6 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs5.getInt("CT_ID");
                                    ResultSet rs6 = oConn.runQuery(strSql6, true);
                                    while (rs6.next()) {
                                        String strNomImg6 = "User.png";
                                        if (rs6.getDouble("CT_PPUNTOS") == 0) {
                                            strNomImg6 = "User_Inac.png";
                                        }
                                        if (bolDrawUl6) {
                                            out.println("<ul>");
                                            bolDrawUl6 = false;
                                        }
                            %><li id="n5_<%=rs6.getInt("CT_ID")%>">
                            <% out.print(rs6.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg6 + "\" border=\"0\" alt=\"" + rs6.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs6.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs6.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs6.getString("CT_RAZONSOCIAL") + "</div>");
                                /**
                                 * ** VALIDA 7 GENERACION *
                                 */
                                if (intNumGeneraciones >= 7) {
                                    //Consultamos la octava generacion
                                    boolean bolDrawUl7 = true;
                                    String strSql7 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs6.getInt("CT_ID");
                                    ResultSet rs7 = oConn.runQuery(strSql7, true);
                                    while (rs7.next()) {
                                        String strNomImg7 = "User.png";
                                        if (rs7.getDouble("CT_PPUNTOS") == 0) {
                                            strNomImg7 = "User_Inac.png";
                                        }
                                        if (bolDrawUl7) {
                                            out.println("<ul>");
                                            bolDrawUl7 = false;
                                        }
                            %><li id="n6_<%=rs7.getInt("CT_ID")%>">
                            <% out.print(rs7.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg7 + "\" border=\"0\" alt=\"" + rs7.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs7.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs7.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs7.getString("CT_RAZONSOCIAL") + "</div>");
                                /**
                                 * ** VALIDA 8 GENERACION *
                                 */
                                if (intNumGeneraciones >= 7) {
                                    //Consultamos la octava generacion
                                    boolean bolDrawUl8 = true;
                                    String strSql8 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs7.getInt("CT_ID");
                                    ResultSet rs8 = oConn.runQuery(strSql8, true);
                                    while (rs8.next()) {
                                        String strNomImg8 = "User.png";
                                        if (rs7.getDouble("CT_PPUNTOS") == 0) {
                                            strNomImg8 = "User_Inac.png";
                                        }
                                        if (bolDrawUl8) {
                                            out.println("<ul>");
                                            bolDrawUl8 = false;
                                        }
                            %><li id="n7_<%=rs8.getInt("CT_ID")%>">
                            <% out.print(rs8.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg8 + "\" border=\"0\" alt=\"" + rs8.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs8.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs8.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs8.getString("CT_RAZONSOCIAL") + "</div>");


                            %></li><%                             }
                                    //Si se pinto el ul inicial pintamos el cierre del mismo
                                    if (!bolDrawUl8) {
                                        out.println("</ul>");
                                    }
                                    rs8.close();
                                }
                                /**
                                 * ** FIN VALIDA 8 GENERACION *
                                 */
                            %></li><%
                                    }
                                    //Si se pinto el ul inicial pintamos el cierre del mismo
                                    if (!bolDrawUl7) {
                                        out.println("</ul>");
                                    }
                                    rs7.close();
                                }
                                /**
                                 * ** FIN VALIDA 7 GENERACION *
                                 */
                    %></li><%
                            }
                            //Si se pinto el ul inicial pintamos el cierre del mismo
                            if (!bolDrawUl6) {
                                out.println("</ul>");
                            }
                            rs6.close();
                        }
                        /**
                         * ** FIN VALIDA 6 GENERACION *
                         */
                %></li><%
                        }
                        //Si se pinto el ul inicial pintamos el cierre del mismo
                        if (!bolDrawUl5) {
                            out.println("</ul>");
                        }
                        rs5.close();
                    }
                    /**
                     * ** FIN VALIDA 5 GENERACION *
                     */
                %></li><%
                        }
                        //Si se pinto el ul inicial pintamos el cierre del mismo
                        if (!bolDrawUl4) {
                            out.println("</ul>");
                        }
                        rs4.close();
                    }
                    /**
                     * ** FIN VALIDA 4 GENERACION *
                     */
                %></li><%
                    }
                    //Si se pinto el ul inicial pintamos el cierre del mismo
                    if (!bolDrawUl3) {
                        out.println("</ul>");
                    }
                    rs3.close();
                    //Consultamos los nietos

                %></li><%                         }
                    //Si se pinto el ul inicial pintamos el cierre del mismo
                    if (!bolDrawUl) {
                        out.println("</ul>");
                    }
                    rs2.close();
                %>
                </li><%
                    }
                    rs.close();
                %>>
            </ul>
            </li>
            <!--Termina lista-->
            </ul>   
            <%
                String strQuery = "select count(KL_ID_MASTER) as nivel from vta_cliente where KL_ID_MASTER = '" + varSesiones.getintIdCliente() + "';";
                rs = oConn.runQuery(strQuery);
                int nivelRed = 0;
                while (rs.next()) {
                    nivelRed = rs.getInt("nivel");
                }
                rs.close();
                switch (nivelRed) {
                    case 0:
                        if (30 <= intContHijos) {
                            out.print("HAS COMPLETADO TU RED FAVOR DE LLENAR EL FORMULARIO DE TU VEHÍCULO.");
                        } else {
                            out.print("TE FALTAN " + (30 - intContHijos) + " PERSONAS PARA COMPLETAR TU RED.");
                        }
                        break;
                    case 1:
                        if (46 <= intContHijos) {
                            out.print("HAS COMPLETADO TU RED FAVOR DE LLENAR EL FORMULARIO DE TU VEHÍCULO.");
                        } else {
                            out.print("TE FALTAN " + (46 - intContHijos) + " PERSONAS PARA COMPLETAR TU RED.");
                        }
                        break;
                    case 2:
                        if (62 <= intContHijos) {
                            out.print("HAS COMPLETADO TU RED FAVOR DE LLENAR EL FORMULARIO DE TU VEHÍCULO.");
                        } else {
                            out.print("TE FALTAN " + (62 - intContHijos) + " PERSONAS PARA COMPLETAR TU RED.");
                        }
                        break;
                }

            %>
            <!--Lista para el organigrama-->
            <div id="chart" class="orgChart" style=" OVERFLOW: auto; WIDTH: auto; TOP: 18px; HEIGHT: auto"></div>

        </div>   

    </div>
</div>
<div id="dialogDeta" title="Detalle del distribuidor">
    <div id="dialogDeta_inside"></div>
</div>    
<%        oConn.close();
    }
%>
