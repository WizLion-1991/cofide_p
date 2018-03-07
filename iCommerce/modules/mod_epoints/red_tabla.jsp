<%-- 
    Document   : red_tabla
    Created on : 23-abr-2013, 12:54:56
    Author     : aleph_79
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
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

        //Cargamos datos iniciales
        Fechas fecha = new Fechas();
        Periodos periodo = new Periodos();
        String strPeriodo = periodo.getPeriodoActualNom(oConn);
        //Obtenemos datos del cliente
        vta_cliente cliente = new vta_cliente();
        cliente.ObtenDatos(varSesiones.getintIdCliente(), oConn);

        //Obtenemos el nombre del cliente
        int intClienteActual = varSesiones.getintIdCliente();
        //Factor de conversión
        double dblFactorConv1 = 0;
        double dblFactorConv2 = 0;
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
        ResultSet rsCN = oConn.runQuery(strlSqlAdicional, true);
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
        
        String strSqlCN = "select KL_FACTOR_CONV1,KL_FACTOR_CONV2 from cuenta_contratada";
        rsCN = oConn.runQuery(strSqlCN, true);
        while (rsCN.next()) {
            dblFactorConv1 = rsCN.getDouble("KL_FACTOR_CONV1");
            dblFactorConv2 = rsCN.getDouble("KL_FACTOR_CONV2");
        }
        rsCN.close();
        //Comision en dinero
        String strComiGanada = NumberString.FormatearDecimal(cliente.getFieldDouble("CT_COMISION"), 2);
        String strComiDisponible = NumberString.FormatearDecimal(dblDisponible, 2);
        //En puntos
        
        String strPtosGanada = NumberString.FormatearDecimal(cliente.getFieldDouble("CT_COMISION") / dblFactorConv1, 2);
        String strPtosDisponible = NumberString.FormatearDecimal(dblDisponible / dblFactorConv1, 2);
        
        //Validamos que dashboard pintar
        String strNomEtapa = "Etapa:1";
        String strNomCiclo = "";
        String strNomCicloCerrado = "";
        String strImgDash = "modules/mod_epoints/images/etapa 1.png";
        if (cliente.getFieldInt("CT_ACTIVO") == 1) {
            strImgDash = "modules/mod_epoints/images/etapa 1.png";
        }

        //Validamos si cerramos un ciclo porque pasamos en automatico al siguiente
        if (intCicloActual == intCicloCerrado) {
            if (intCicloCerrado < 5) {
                intCicloActual++;
            }
        }
        if (intCicloCerrado == 1) {
            strNomCicloCerrado = "Etapa 1";
        }
        if (intCicloCerrado == 2) {
            strNomCicloCerrado = "Etapa 2";
        }
        if (intCicloCerrado == 3) {
            strNomCicloCerrado = "Etapa 3";
        }
        if (intCicloCerrado == 4) {
            strNomCicloCerrado = "Etapa 4";
        }
        if (intCicloCerrado == 5) {
            strNomCicloCerrado = "Etapa 5";
        }
        if (intCicloActual == 1) {
            strImgDash = "modules/mod_epoints/images/etapa 1.png";
            strNomCiclo = "Etapa 1";

        }
        if (intCicloActual == 2 && intKL_PLAN_ORO == 0) {
            strImgDash = "modules/mod_epoints/images/etapa 2.png";
            strNomCiclo = "Etapa 2";
        }
        if (intCicloActual == 3 && intKL_PLAN_ORO == 0) {
            strImgDash = "modules/mod_epoints/images/etapa 3.png";
            strNomCiclo = "Etapa 3";
        }
        if (intCicloActual == 4 && intKL_PLAN_ORO == 0) {
            strImgDash = "modules/mod_epoints/images/etapa 1.png";
            strNomCiclo = "Etapa 4";
        }

        
           //Puntos disponibles
   double dblDisponible1 = 0;
   String strSaldoDisponible1 = "SELECT  "
           + "	SUM(mlm_mov_comis.MMC_ABONO - mlm_mov_comis.MMC_CARGO) as TSALDO"
           + " FROM mlm_mov_comis WHERE CT_ID = " + varSesiones.getintIdCliente();
   ResultSet rsCN1 = oConn.runQuery(strSaldoDisponible1, true);
   while (rsCN1.next()) {
      dblDisponible1 = rsCN1.getDouble("TSALDO");
   }
   rsCN1.close();
%>
<script>
    //El orden del colmodel es el que debes de sefguir en el xml
    $(document).ready(function () {
        $("#list").jqGrid({
            url: "modules/mod_epoints/mlm_red_grid.jsp?ID=1",
            datatype: "xml",
            mtype: "GET",
            width: "auto",
            height: "auto",
            rowNum: '',
            colNames: ['CLAVE', 'NOMBRE', 'FECHA INGRESO'],
            colModel: [
                {name: 'ct_id', index: 'ct_id', width: 100},
                {name: 'ct_nombre', index: 'ct_nombre', width: 300, align: "left", search: true},
                {name: 'ct_ingreso', index: 'ct_nivelred', width: 100, sortable: false, align: "right", search: false}
            ],
            caption: "Aplicaci&oacute;n de mi c&oacute;digo <%=cliente.getFieldString("CT_RAZONSOCIAL")%>"

        });
        $("#list").jqGrid('filterToolbar', {
            autosearch: true
        });
    });
</script>

<!--Etapa de la red -->
<span >
    <img src="<%=strImgDash%>" border="0" alt="dash board" title="dash board" />
</span>
<span >
    <h3>
        <%=strNomEtapa%>
        <%=strNomCiclo%>
        Etapa Cerrada:<%=strNomCicloCerrado%>
        <!--Comision ganada:-->
       <!-- <br>Comisión ganada:<//%=strComiGanada%>&nbsp;&nbsp;Puntos:&nbsp;<//%=strPtosGanada%> -->
        <!--Comision disponible:-->
       <!-- <br>Comisión disponible:<//%=strComiDisponible%>&nbsp;&nbsp;Puntos:&nbsp;<//%=strPtosDisponible%>-->
       

        <br>Puntos Generados:&nbsp;<%=strPtosGanada%> 

        <br>Puntos Disponibles:&nbsp;<%=dblDisponible1%>
        
    </h3>

</span>

<!--GRID-->

<table id='list'></table>







<%
        oConn.close();
    }
%>
