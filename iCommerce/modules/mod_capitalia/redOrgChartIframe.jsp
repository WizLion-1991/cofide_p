<%-- 
    Document   : redOrgChartIframe
    Created on : 30-ago-2014, 15:50:10
    Author     : ZeusGalindo
--%>

<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="comSIWeb.Utilerias.UtilJson"%>
<%@page import="com.mx.siweb.ui.web.TemplateParams"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
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
      //Obtenemos parametros generales de la pagina a mostrar
      Site webBase = new Site(oConn);

      //Inicializamos los parametros del template
      TemplateParams templateparams = new TemplateParams(oConn, "protostar", webBase.getStrLanguage());


      //Cargamos datos iniciales
      Periodos periodo = new Periodos();
      String strPeriodo = "";
      int intIdPeriodo = 0;
      if (request.getParameter("PeriodoReport") != null) {
         String strSql = "select MPE_ID,MPE_NOMBRE from mlm_periodos where  MPE_ABRV = '" + request.getParameter("PeriodoReport") + "'";
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            strPeriodo = rs.getString("MPE_NOMBRE");
            intIdPeriodo = rs.getInt("MPE_ID");
         }
         rs.close();

      } else {
         strPeriodo = periodo.getPeriodoActualNom(oConn);
         intIdPeriodo = periodo.getPeriodoActual(oConn);

      }
      UtilJson utilJosn = new UtilJson();
      //Obtenemos datos del cliente
      vta_cliente cliente = new vta_cliente();
      cliente.ObtenDatos(varSesiones.getintIdCliente(), oConn);
      double dblComisionPeriodo = 0;
      //Buscamos comisiones del periodo seleccionado
      String strSqlComis = "select CO_CHEQUE from mlm_comision where "
              + " MPE_ID = " + intIdPeriodo + " AND mlm_comision.CT_ID =" + varSesiones.getintIdCliente();
      ResultSet rsComis = oConn.runQuery(strSqlComis, true);
      while (rsComis.next()) {
         dblComisionPeriodo = rsComis.getDouble("CO_CHEQUE");
      }
      rsComis.close();

      int intDeepIni = cliente.getFieldInt("CT_ARMADODEEP");
      int intDeepMax = intDeepIni + 3;
      int intCuantos = 0;
      int intCuantosNiv1 = 0;
      int intCuantosNiv2 = 0;
      int intCuantosNiv3 = 0;

      //Solo tomamos los primeros n niveles
      StringBuilder strJsonMLM = new StringBuilder("");
      String strFiltro = " AND vta_cliente.CT_ARMADONUM >= (select a.CT_ARMADOINI from vta_cliente a where a.ct_id = " + varSesiones.getintIdCliente() + ")"
              + " and vta_cliente.CT_ARMADONUM <= (select a.CT_ARMADOFIN from vta_cliente a where a.ct_id =" + varSesiones.getintIdCliente() + ")  "
              + " and vta_cliente.CT_ARMADODEEP <= " + intDeepMax + " and vta_cliente.MPE_ID <= " + intIdPeriodo +" ";
      String strSql = "SELECT vta_cliente.CT_ID,CT_RAZONSOCIAL,CT_RFC,SC_NOMBRE,CT_CALLE,CT_NUMERO,CT_COLONIA,CT_ARMADODEEP,"
              + "CT_MUNICIPIO,CT_ESTADO,CT_CP,CT_TELEFONO1,CT_TELEFONO2,CT_CONTACTO1,CT_CONTACTO2,CT_EMAIL1,CT_EMAIL2,CT_UPLINE,CT_PPUNTOS,"
              + "CT_GPUNTOS,CT_GNEGOCIO,CT_PNEGOCIO,CT_NIVELRED,CT_DIASCREDITO,"
              + "(select CO_CHEQUE from mlm_comision where MPE_ID = " + intIdPeriodo + " AND mlm_comision.CT_ID = vta_cliente.CT_ID) as TOT_CHEQUE "
              + " FROM vta_cliente,vta_sucursal where  vta_cliente.SC_ID=vta_sucursal.SC_ID  " + strFiltro + " ORDER BY CT_ARMADONUM";
      try {
         ResultSet rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            //Verificamos la profundidad para la imagen
            String strImg = "";
            if ((rs.getInt("CT_ARMADODEEP") - intDeepIni) == 0) {
               strImg = webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/ICONO-01.png";
            }
            if ((rs.getInt("CT_ARMADODEEP") - intDeepIni) == 1) {
               strImg = webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/ICONO-02.png";
               intCuantosNiv1++;
            }
            if ((rs.getInt("CT_ARMADODEEP") - intDeepIni) == 2) {
               strImg = webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/ICONO-03.png";
               intCuantosNiv2++;
            }
            if ((rs.getInt("CT_ARMADODEEP") - intDeepIni) == 3) {
               strImg = webBase.getUrlSite() + "/templates/" + templateparams.getNombre() + "/images/ICONO-04.png";
               intCuantosNiv3++;
            }
            if (intCuantos > 0) {
               strJsonMLM.append(",");
            }
            strJsonMLM.append("{ id: " + rs.getInt("CT_ID") + ", "
                    + "parentId: " + (rs.getInt("CT_ID") == cliente.getFieldInt("CT_ID") ? "null" : rs.getInt("CT_UPLINE")) + ","
                    + "nombre: \"" + utilJosn.parse(rs.getString("CT_RAZONSOCIAL")) + "\", "
                    + "numero: \"" + rs.getInt("CT_ID") + "\", "
                    + "phone: \"" + utilJosn.parse(rs.getString("CT_TELEFONO1")) + "\" ,"
                    + "mail:\"" + utilJosn.parse(rs.getString("CT_EMAIL1")) + "\", "
                    + "puntos: " + rs.getDouble("CT_PPUNTOS") + ","
                    + "comision: " + rs.getDouble("TOT_CHEQUE") + ", "
                    + "image: \"" + strImg + "\" "
                    + "}");
            intCuantos++;
         }
         rs.close();
      } catch (Exception err) {
         String txt = "There was an error on this page.\n\n";
         txt += "Error description: " + err.getMessage() + " \n\n";
         txt += "Click OK to continue5.\n\n";
         System.out.println(txt);
      }




      //Obtenemos el nombre del cliente
      String strJson = strJsonMLM.toString();
%>
<script src="../../../jqGrid/getorgchart/jquery.min.js"></script>
<script src="../../../jqGrid/getorgchart/getorgchart.js"></script>
<link href="../../../jqGrid/getorgchart/getorgchart.css" rel="stylesheet" />
<style type="text/css">
   html, body {margin: 0px; padding: 0px;width: 100%;height: 100%;overflow: hidden; }
   #people {width: 100%;height: 100%; }   
   .well {
      background-color: #f5f5f5;
      border: 1px solid #e3e3e3;
      border-radius: 4px;
      box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset;
      margin-bottom: 20px;
      min-height: 20px;
      padding: 19px;
   }
   .button {
      background: none repeat scroll 0 0 #000;
      border: medium none;
      color: #fff !important;
      cursor: pointer;
      display: inline-block;
      font-size: 12px;
      font-weight: bold;
      min-width: 130px;
      padding: 4px 10px;
      text-align: center;
      text-decoration: none;
   }
   .button span {
   }
   .type_button {
      background: none repeat scroll 0 0 #000;
      border: medium none;
      color: #fff;
      cursor: pointer;
      display: inline-block;
      font-size: 12px;
      font-weight: bold;
      min-width: 130px;
      padding: 4px 10px;
      text-align: center;
      text-decoration: none;
   }
   a.button:hover {
      background: none repeat scroll 0 0 #333;
   }
</style>
<script type="text/javascript">

   //Reporte por grafica
   function RedGrafica2(strAbrv) {
      document.getElementById("tree-form").action = "redOrgChartIframe.jsp?PeriodoReport=" + strAbrv;
      document.getElementById("tree-form").submit();
   }


</script>
<form action="index.jsp?mod=red_grafica2" method="post"   id="tree-form" class="form-inline">
   <h2>Periodo:
   <%
   //Consultamos los periodos
      strSql = "select MPE_ID,MPE_NOMBRE,MPE_ABRV from mlm_periodos order by MPE_ABRV";
      String strStilo = "";
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         if (rs.getInt("MPE_ID") == intIdPeriodo) {
            strStilo = "class=\"button\"";
         } else {
            strStilo = "";
         }
   %><button id="boton<%=rs.getString("MPE_ID")%>" onClick="RedGrafica2('<%=rs.getString("MPE_ABRV")%>')" <%=strStilo%> type="submit"><%=rs.getString("MPE_NOMBRE")%></button>&nbsp;<%
      }
      rs.close();
      oConn.close();
   %></h2>
</form>
<div id="estadisticas_mlm" class="well">
   <h3>  &nbsp;Periodo de comisiones:<%=strPeriodo%> &nbsp;Total de personas:<%=intCuantos - 1%> &nbsp;</h4>
   <h4><img src="<%=webBase.getUrlSite() + "/images/"%>/NIVEL 1.png" border="0" width="40" height="40" alt="Nivel 1" title="Nivel 1" />Personas en el nivel 1:<%=intCuantosNiv1%> </h4>
   <h4><img src="<%=webBase.getUrlSite() + "/images/"%>/NIVEL 2.png" border="0" width="40" height="40" alt="Nivel 2" title="Nivel 2" /> Personas en el nivel 2:<%=intCuantosNiv2%></h4>
   <h4><img src="<%=webBase.getUrlSite() + "/images/"%>/NIVEL 3.png" border="0" width="40" height="40" alt="Nivel 3" title="Nivel 3" /> Personas en el nivel 3:<%=intCuantosNiv3%> </h4>
   <h4><img src="<%=webBase.getUrlSite() + "/images/"%>/COMISION.png" border="0" width="40" height="40" alt="Comisiones" title="Comisiones" /> Total de comisiones en el periodo:$<%=NumberString.FormatearDecimal(dblComisionPeriodo, 2)%></h4>
</div>
<div id="people"></div>


<script type="text/ecmascript">
   $('#people').getOrgChart({
   theme: "cassandra",
   clickEvent: function( sender, args ) {} ,
   color: "neutralgrey",
   primaryColumns: ["nombre", "numero", ],
   imageColumn: "image",
   gridView: true,
   editable: false,
   orientation: getOrgChart.RO_LEFT,
   dataSource:[			
   <%=strJson%>
              ]
   });
   
</script>	
<%
      oConn.close();
   }
%>
