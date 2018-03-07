<%-- 
    Document   : red_tabla
    Created on : 23-abr-2013, 12:54:56
    Author     : aleph_79
--%>

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

%>
<script>
   //El orden del colmodel es el que debes de sefguir en el xml
   $(document).ready(function() {
      $("#list").jqGrid({
         url: "modules/mod_prosperidad/mlm_red_grid.jsp?ID=1",
         datatype: "xml",
         mtype: "GET",
         width: "auto",
         height: "auto",
         rowNum: '',
         colNames: ['SUCURSAL', 'UPLINE', 'CLAVE', 'NOMBRE', 'SEMANA', '', '', '','TEL.1','TEL2.','CORREO','CUENTA','BANCO','COMISION', ''],
         colModel: [
            {name: 'sc_id', index: 'sc_id', width: 60, search:false},
            {name: 'ct_upline', index: 'ct_upline', width: 50},
            {name: 'ct_id', index: 'ct_id', width: 50},
            {name: 'ct_nombre', index: 'ct_nombre', width: 150, align: "left", search:true},
            {name: 'ct_semana', index: 'ct_semana', width: 60, align: "right", search:false},
            {name: 'ct_gpuntos', index: 'ct_gpuntos', width: 60, align: "right", search:false,hidden: true},
            {name: 'ct_pnegocio', index: 'ct_pnegocio', width: 60, sortable: false, align: "right", search:false,hidden: true},
            {name: 'ct_gnegocio', index: 'ct_gnegocio', width: 60, sortable: false, align: "right", search:false,hidden: true},
            {name: 'ct_telefono1', index: 'ct_telefono1', width: 80, sortable: false, align: "right", search:false},
            {name: 'ct_telefono2', index: 'ct_telefono2', width: 80, sortable: false, align: "right", search:false},
            {name: 'ct_email1', index: 'ct_email1', width: 90, sortable: false, align: "right", search:false},
            {name: 'ct_cuenta', index: 'ct_cuenta', width: 90, sortable: false, align: "right", search:false},
            {name: 'ct_banco', index: 'ct_banco', width: 90, sortable: false, align: "right", search:false},
            {name: 'ct_comision', index: 'ct_comision', width: 80, sortable: false, align: "right", search:false},
            {name: 'ct_nivelred', index: 'ct_nivelred', width: 20, sortable: false, align: "right",hidden: true}
         ],
         caption: "MI RED , <%=cliente.getFieldString("CT_NOMBRE")%>"

      });
      $("#list").jqGrid('filterToolbar', {
         autosearch: true
      });
   });
</script>


   
   


         <!--GRID-->
         
            
               <table id='list'></table>
            
         
 




<%
      oConn.close();
   }
%>
