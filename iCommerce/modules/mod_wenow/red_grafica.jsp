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
      String strFiltroAdicional = "  " ;

      //Cargamos datos iniciales
      Fechas fecha = new Fechas();
      Periodos periodo = new Periodos();
      String strPeriodo = periodo.getPeriodoActualNom(oConn);
      int intWN_ID_AFILIADO = 0;
      int intWN_ID_GLOBAL = 0;
      //Obtenemos datos del cliente
      vta_cliente cliente = new vta_cliente();
      cliente.ObtenDatos(varSesiones.getintIdCliente(), oConn);

      String strModo = request.getParameter("Modo");
      String strCampoActivo = "CT_ACTIVO";

      if (strModo != null) {
         if (strModo.equals("Unilevel")) {
            strCampoFiltro = "CT_SPONZOR";
            strTituloTipo = " - Mi red Training Estructural";
            strCampoActivo = "CT_ACTIVO";
         }
         if (strModo.equals("Binario")) {
            strCampoFiltro = "CT_UPLINE";
            strTituloTipo = " - Mi red Training";
            strCampoActivo = "CT_ACTIVO";
         }
         if (strModo.equals("BinarioA")) {
            strCampoFiltro = "CT_SPONZOR";
            strTituloTipo = " - Mi red Redes Inteligentes";
            strCampoActivo = "WN_ACTIVO_AFILIADO";
            //Buscamos datos del otro centro de negocios
            /*String strSql = "select CT_ID,WN_ID_TRAINING,WN_ID_AFILIADO,WN_ID_GLOBAL from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intWN_ID_AFILIADO = rs.getInt("WN_ID_AFILIADO");
            }
            rs.close();*/
            intWN_ID_AFILIADO = varSesiones.getintIdCliente();
            strFiltroAdicional = "  AND  WN_AFILIADO = 1" ;//WN_ACTIVO_AFILIADO = 1  and 
         }
         if (strModo.equals("BinarioG")) {
            //strCampoFiltro = "CT_UPLINE";
            strCampoFiltro = "CT_SPONZOR";
            strTituloTipo = " - Mi red Asociados globales";
            //Buscamos datos del otro centro de negocios
            /*String strSql = "select CT_ID,WN_ID_TRAINING,WN_ID_AFILIADO,WN_ID_GLOBAL from vta_cliente where CT_ID = " + varSesiones.getintIdCliente();
            ResultSet rs = oConn.runQuery(strSql, true);
            while (rs.next()) {
               intWN_ID_GLOBAL = rs.getInt("WN_ID_GLOBAL");
            }
            rs.close();*/
            intWN_ID_GLOBAL = varSesiones.getintIdCliente();
            strFiltroAdicional = "  AND   WN_GLOBAL = 1" ;//WN_ACTIVO_GLOBAL = 1  and
            strCampoActivo = "WN_ACTIVO_GLOBAL";
         }
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
   <h3 class="page-header">Mi red <%=cliente.getFieldString("CT_NOMBRE")%>&nbsp;<%=cliente.getFieldString("CT_APATERNO")%>&nbsp;<%=cliente.getFieldString("CT_AMATERNO")%>&nbsp;<%=strTituloTipo%>&nbsp;-<a href="index.jsp?mod=red_grafica&Modo=<%=strModo%>">Ir al inicio&nbsp;-<a href="index.jsp?mod=FZWebRed">Otro tipo de red</a></h3>
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
                  if (strModo.equals("BinarioA")) {
                     intNodoPintar = intWN_ID_AFILIADO;
                  }
                  if (strModo.equals("BinarioG")) {
                     intNodoPintar = intWN_ID_GLOBAL;
                  }
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
                     String strSql = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS," +  strCampoActivo + "  from vta_cliente where " + strCampoFiltro + " = " + intNodoPintar + strFiltroAdicional;
                     ResultSet rs = oConn.runQuery(strSql, true);
                     while (rs.next()) { 
                        String strNomImg = "User.png";
                        if (rs.getInt(strCampoActivo) == 0) {
                           strNomImg = "User_Inac.png";
                        }
                  %><li id="n1_<%=rs.getInt("CT_ID")%>">
                     <%=rs.getInt("CT_ID")%>
                     <a href="index.jsp?mod=red_grafica&Modo=<%=strModo%>&NodoHijo=<%=rs.getInt("CT_ID")%>"><img src="../images/mlm/<%=strNomImg%>" border="0" alt="<%=rs.getString("CT_RAZONSOCIAL")%>" title="<%=rs.getString("CT_RAZONSOCIAL")%>" /></a>
                     <a href="javascript:ShowDetails(<%=rs.getInt("CT_ID")%>)">(+)</a><div class="nom_small"><%=rs.getString("CT_RAZONSOCIAL")%>
                     </div>
                     <%
                        //Consultamos los nietos
                        boolean bolDrawUl = true;
                        String strSql2 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS," +  strCampoActivo + " from vta_cliente where " + strCampoFiltro + " = " + rs.getInt("CT_ID") + strFiltroAdicional;
                        ResultSet rs2 = oConn.runQuery(strSql2, true);
                        while (rs2.next()) {
                           String strNomImg2 = "User.png";
                           if (rs2.getDouble(strCampoActivo) == 0) {
                              strNomImg2 = "User_Inac.png";
                           }
                           if (bolDrawUl) {
                              out.println("<ul>");
                              bolDrawUl = false;
                           }
                     %><li id="n2_<%=rs2.getInt("CT_ID")%>">
                     <% out.print(rs2.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&Modo=" + strModo + "&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg2 + "\" border=\"0\" alt=\"" + rs2.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs2.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs2.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs2.getString("CT_RAZONSOCIAL") + "</div>");

                        //Consultamos los Bisnietos
                        boolean bolDrawUl3 = true;
                        String strSql3 = "select CT_ID,CT_RAZONSOCIAL,CT_PPUNTOS," +  strCampoActivo + " from vta_cliente where " + strCampoFiltro + " = " + rs2.getInt("CT_ID")+ strFiltroAdicional;
                        ResultSet rs3 = oConn.runQuery(strSql3, true);
                        while (rs3.next()) {
                           String strNomImg3 = "User.png";
                           if (rs3.getDouble(strCampoActivo) == 0) {
                              strNomImg3 = "User_Inac.png";
                           }
                           if (bolDrawUl3) {
                              out.println("<ul>");
                              bolDrawUl3 = false;
                           }
                     %><li id="n2_<%=rs3.getInt("CT_ID")%>">
                     <% out.print(rs3.getInt("CT_ID") + "<a href=\"index.jsp?mod=red_grafica&Modo=" + strModo + "&NodoHijo=" + rs.getInt("CT_ID") + "\"><img src=\"../images/mlm/" + strNomImg3 + "\" border=\"0\" alt=\"" + rs3.getString("CT_RAZONSOCIAL") + "\" title=\"" + rs3.getString("CT_RAZONSOCIAL") + "\" /></a><a href=\"javascript:ShowDetails(" + rs3.getInt("CT_ID") + ")\">(+)</a><div class=\"nom_small\">" + rs3.getString("CT_RAZONSOCIAL") + "</div>");


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
<div id="dialogDeta" title="Detalle del distribuidor">
   <div id="dialogDeta_inside"></div>
</div>    
<%
      oConn.close();
   }
%>
