<%@page import="comSIWeb.Utilerias.NumberString"%>
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

      //Validamos si hay que mostrar un nodo en particular
      int intClienteActual = varSesiones.getintIdCliente();
      if (request.getParameter("cuentaSel") != null) {
         intClienteActual = Integer.valueOf(request.getParameter("cuentaSel"));
      }

      //Obtenemos datos del cliente
      vta_cliente cliente = new vta_cliente();
      cliente.ObtenDatos(intClienteActual, oConn);

      String strModo = request.getParameter("Modo");

      if (strModo != null) {
         if (strModo.equals("Unilevel")) {
            strCampoFiltro = "CT_SPONZOR";
            strTituloTipo = " - Mis recomendados";
         }
         if (strModo.equals("Binario")) {
            strCampoFiltro = "CT_UPLINE";
            strTituloTipo = " - Mi red binaria";
         }
      }
      //Obtenemos la lista de cuentas que podemos consultar
      String strOpts = "<option value=" + varSesiones.getintIdCliente() + ">" + varSesiones.getintIdCliente() + ".-" + varSesiones.getStrUser() + "</option>";
      if (intClienteActual == varSesiones.getintIdCliente()) {
         strOpts = "<option value=" + varSesiones.getintIdCliente() + " selected>" + varSesiones.getintIdCliente() + ".-" + varSesiones.getStrUser() + "</option>";
      }
      String strSqlCN = "select CT_ID,CT_RAZONSOCIAL from vta_cliente where KL_ID_MASTER = " + varSesiones.getintIdCliente();
      ResultSet rsCN = oConn.runQuery(strSqlCN, true);
      while (rsCN.next()) {
         if (intClienteActual == rsCN.getInt("CT_ID")) {
            strOpts += "<option value=" + rsCN.getInt("CT_ID") + " selected >" + rsCN.getInt("CT_ID") + ".-" + rsCN.getString("CT_RAZONSOCIAL") + "</option>";
         } else {
            strOpts += "<option value=" + rsCN.getInt("CT_ID") + ">" + rsCN.getInt("CT_ID") + ".-" + rsCN.getString("CT_RAZONSOCIAL") + "</option>";
         }
      }
      rsCN.close();
      //Factor de conversión
      double dblFactorConv1 = 0;
      double dblFactorConv2 = 0;
      strSqlCN = "select KL_FACTOR_CONV1,KL_FACTOR_CONV2 from cuenta_contratada";
      rsCN = oConn.runQuery(strSqlCN, true);
      while (rsCN.next()) {
         dblFactorConv1 = rsCN.getDouble("KL_FACTOR_CONV1");
         dblFactorConv2 = rsCN.getDouble("KL_FACTOR_CONV2");
      }
      rsCN.close();
      //Obtenemos la comision disponible
      int intCicloActual = 0;
      int intCicloCerrado = 0;
      int intKL_PLAN_ORO = 0;
      double dblDisponible = 0;
      double dblDisponibleComis1 = 0;
      double dblDisponibleComis2 = 0;
      double dblDisponibleComis3 = 0;
      double dblDisponibleComis4 = 0;
      double dblDisponibleComis5 = 0;
      String strlSqlAdicional = "select KL_CICLO_ACTUAL,KL_CICLO_CERRADO,KL_PLAN_ORO"
              + ", KL_CICLO1_COMIS"
              + ", KL_CICLO2_COMIS"
              + ", KL_CICLO3_COMIS"
              + ", KL_CICLO4_COMIS"
              + ", KL_CICLO5_COMIS"
              + ",(KL_CICLO1_COMIS"
              + "+ KL_CICLO2_COMIS"
              + "+ KL_CICLO3_COMIS"
              + "+ KL_CICLO4_COMIS"
              + "+ KL_CICLO5_COMIS) as DISPONIBLE"
              + " from vta_cliente where CT_ID = " + intClienteActual;
      rsCN = oConn.runQuery(strlSqlAdicional, true);
      while (rsCN.next()) {
         intCicloActual = rsCN.getInt("KL_CICLO_ACTUAL");
         intCicloCerrado = rsCN.getInt("KL_CICLO_CERRADO");
         intKL_PLAN_ORO = rsCN.getInt("KL_PLAN_ORO");
         dblDisponible = rsCN.getDouble("DISPONIBLE");
         dblDisponibleComis1 = rsCN.getDouble("KL_CICLO1_COMIS");
         dblDisponibleComis2 = rsCN.getDouble("KL_CICLO2_COMIS");
         dblDisponibleComis3 = rsCN.getDouble("KL_CICLO3_COMIS");
         dblDisponibleComis4 = rsCN.getDouble("KL_CICLO4_COMIS");
         dblDisponibleComis5 = rsCN.getDouble("KL_CICLO5_COMIS");
      }
      rsCN.close();
      //Comision en dinero
      String strComiGanada = NumberString.FormatearDecimal(cliente.getFieldDouble("CT_COMISION"), 2);
      String strComiDisponible = NumberString.FormatearDecimal(dblDisponible, 2);
      //En puntos
      String strPtosGanada = NumberString.FormatearDecimal(cliente.getFieldDouble("CT_COMISION")/dblFactorConv1, 2);
      String strPtosDisponible = NumberString.FormatearDecimal(dblDisponible/dblFactorConv1, 2);
      String strLinkUso = "";
      if (dblDisponible > 0) {
         strLinkUso = "<a href='index.jsp?mod=ecomm'>Da click aqui para cambiarlos por producto</a><br>";
         boolean bolCambioporDinero = true;
         if (intCicloCerrado == 4) {

         }
         if (bolCambioporDinero) {
            strLinkUso += "<a href='index.jsp?mod=FZWebKLCambio'>Da click aqui para cambiar los puntos por dinero</a><br>";
         }

      }
      //Validamos que dashboard pintar
      String strNomEtapa = "Etapa:1";
      String strNomCiclo = "";
      String strNomCicloCerrado = "";
      String strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy.jpg";
      if (cliente.getFieldInt("CT_ACTIVO") == 1) {
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy activa.jpg";

      }
      //Validamos si cerramos un ciclo porque pasamos en automatico al siguiente
      if (intCicloActual == intCicloCerrado) {
         if (intCicloCerrado < 5) {
            intCicloActual++;
         }
      }
      if (intCicloCerrado == 1) {
         strNomCicloCerrado = "Ciclo 1";
      }
      if (intCicloCerrado == 2) {
         strNomCicloCerrado = "Ciclo 2";
      }
      if (intCicloCerrado == 3) {
         strNomCicloCerrado = "Ciclo 3";
      }
      if (intCicloCerrado == 4) {
         strNomCicloCerrado = "Ciclo 4";
      }
      if (intCicloCerrado == 5) {
         strNomCicloCerrado = "Ciclo 5";
      }
      if (intCicloActual == 1) {
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy ciclo1.jpg";
         strNomCiclo = "Ciclo 1";

      }
      if (intCicloActual == 2 && intKL_PLAN_ORO == 0) {
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy ciclo2.jpg";
         strNomCiclo = "Ciclo 2";
      }
      if (intCicloActual == 3 && intKL_PLAN_ORO == 0) {
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy ciclo3.jpg";
         strNomCiclo = "Ciclo 3";
      }
      if (intCicloActual == 4 && intKL_PLAN_ORO == 0) {
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy ciclo4.jpg";
         strNomCiclo = "Ciclo 4";
      }
      if (intCicloActual == 1 && intKL_PLAN_ORO == 1) {
         strNomEtapa = "Etapa:2";
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy Premier ciclo1.jpg";
         strNomCiclo = "Ciclo 1 Premier";
      }
      if (intCicloActual == 2 && intKL_PLAN_ORO == 1) {
         strNomEtapa = "Etapa:2";
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy Premier ciclo2.jpg";
         strNomCiclo = "Ciclo 2 Premier";
      }
      if (intCicloActual == 3 && intKL_PLAN_ORO == 1) {
         strNomEtapa = "Etapa:2";
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy Premier ciclo3.jpg";
         strNomCiclo = "Ciclo 3 Premier";
      }
      if (intCicloActual == 4 && intKL_PLAN_ORO == 1) {
         strNomEtapa = "Etapa:2";
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy Premier ciclo4.jpg";
         strNomCiclo = "Ciclo 4 Premier";
      }
      if (intCicloActual == 5 && intKL_PLAN_ORO == 1) {
         strNomEtapa = "Etapa:2";
         strImgDash = "modules/mod_klensy/images/Dashboard cuenta Klensy Premier ciclo5.jpg";
         strNomCiclo = "Ciclo 5 Premier";
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
<form action="index.jsp?mod=FZWebRed" method="post"   id="tree-form" class="form-inline">
   <div class="well ">
      <h3 class="page-header">Mi red <%=cliente.getFieldString("CT_RAZONSOCIAL")%>&nbsp;</h3>
      <div class="userdata">       
         <div id="form-new-submit" class="control-group">
            <div class="controls">
               <span class="required">Seleccione su cuenta</span>
               <span class="required">
                  <select id="cuentaSel" name="cuentaSel" onBlur="ActualizaRed()">
                     <%=strOpts%>
                  </select>
                  </br>
                  </br>
               </span>
               <span >
                  <img src="<%=strImgDash%>" border="0" alt="dash board" title="dash board" />
               </span>
               <span >
                  <h3>
                     <%=strNomEtapa%>
                     <%=strNomCiclo%>
                     Ciclo cerrado:<%=strNomCicloCerrado%>
                     <!--Comision ganada:-->
                     <br>Comisión ganada:<%=strComiGanada%>&nbsp;&nbsp;Puntos:&nbsp;<%=strPtosGanada%>
                     <!--Comision disponible:-->
                     <br>Comisión disponible:<%=strComiDisponible%>&nbsp;&nbsp;Puntos:&nbsp;<%=strPtosDisponible %>
                     <br><%=strLinkUso%>
                  </h3>

               </span>
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
                     intNodoPintar = intClienteActual;
                  } else {
                     //Validamos que el nodo hijo por pintar este en su red
                     /*boolean bolValido = Redes.esPartedelaRed(oConn, "vta_cliente", "CT_UPLINE", "CT_ID", intClienteActual, intNodoHijo);
                      if (bolValido) {*/
                     intNodoPintar = intNodoHijo;
                     /*} else {
                      intNodoPintar = intClienteActual;
                      }*/
                  }

                  //Obtenemos datos del cliente por pintar
                  vta_cliente clientePintar = new vta_cliente();
                  clientePintar.ObtenDatos(intNodoPintar, oConn);
               %>
               <li>
                  <%=clientePintar.getFieldString("CT_ID")%>
                  <img src="modules/mod_klensy/images/Icono Red - Afiliado.jpg" border="0" alt="" title="" />
                  <div class="nom_ini"><%=clientePintar.getFieldString("CT_RAZONSOCIAL")%></div>
                  <ul>
                     <%
                        //Consulta de hijos
                        String strSql = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + intNodoPintar;
                        ResultSet rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                           String strNomImg = "User.png";
                           if (rs.getDouble("CT_PPUNTOS") == 0) {
                              strNomImg = "User_Inac.png";
                           }
                     %><li id="n1_<%=rs.getInt("CT_ID")%>">
                        <%=rs.getInt("CT_ID")%>
                        <a href="index.jsp?mod=red_grafica&NodoHijo=<%=rs.getInt("CT_ID")%>"><img src="modules/mod_klensy/images/Icono Red - Afiliado descendente.jpg" border="0" alt="<%=rs.getString("CT_RAZONSOCIAL")%>" title="<%=rs.getString("CT_RAZONSOCIAL")%>" /></a>
                        <a href="javascript:ShowDetails(<%=rs.getInt("CT_ID")%>)">(+)</a><div class="nom_small"><%=rs.getString("CT_RAZONSOCIAL")%>
                        </div>
                        <%
                           //Consultamos los nietos
                           boolean bolDrawUl = true;
                           String strSql2 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs.getInt("CT_ID");
                           ResultSet rs2 = oConn.runQuery(strSql2, true);
                           while (rs2.next()) {
                              String strNomImg2 = "User.png";
                              if (rs2.getDouble("CT_PPUNTOS") == 0) {
                                 strNomImg2 = "User_Inac.png";
                              }
                              if (bolDrawUl) {
                                 out.println("<ul>");
                                 bolDrawUl = false;
                              }
                        %><li id="n2_<%=rs2.getInt("CT_ID")%>">
                        <% out.print(rs2.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs2.getInt("CT_ID") + "\"><img src=\"modules/mod_klensy/images/Icono Red - Afiliado descendente.jpg\" border=\"0\" alt=\"" + rs2.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs2.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs2.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs2.getString("CT_RAZONSOCIAL") + "</div>");

                           //Consultamos los Bisnietos
                           boolean bolDrawUl3 = true;
                           String strSql3 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS from vta_cliente where " + strCampoFiltro + " = " + rs2.getInt("CT_ID");
                           ResultSet rs3 = oConn.runQuery(strSql3, true);
                           while (rs3.next()) {
                              String strNomImg3 = "User.png";
                              if (rs3.getDouble("CT_PPUNTOS") == 0) {
                                 strNomImg3 = "User_Inac.png";
                              }
                              if (bolDrawUl3) {
                                 out.println("<ul>");
                                 bolDrawUl3 = false;
                              }
                        %><li id="n2_<%=rs3.getInt("CT_ID")%>">
                        <% out.print(rs3.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&NodoHijo=" + rs3.getInt("CT_ID") + "\"><img src=\"modules/mod_klensy/images/Icono Red - Afiliado descendente.jpg\" border=\"0\" alt=\"" + rs3.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs3.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs3.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs3.getString("CT_RAZONSOCIAL") + "</div>");


                        %></li><%                        }
                           //Si se pinto el ul inicial pintamos el cierre del mismo
                           if (!bolDrawUl3) {
                              out.println("</ul>");
                           }
                           rs3.close();
                           //Consultamos los nietos

                        %></li><%                        }
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
            <!--Lista para el organigrama-->
            <div id="chart" class="orgChart" style=" OVERFLOW: auto; WIDTH: auto; TOP: 18px; HEIGHT: auto"></div>

         </div>   

      </div>
   </div>
</form>
<div id="dialogDeta" title="Detalle del distribuidor">
   <div id="dialogDeta_inside"></div>
</div>

<script type="text/javascript">

   //Reporte por grafica
   function ActualizaRed() {
      document.getElementById("tree-form").action = "index.jsp?mod=FZWebRed";
      document.getElementById("tree-form").submit();
   }


</script>
<%
      oConn.close();
   }
%>
