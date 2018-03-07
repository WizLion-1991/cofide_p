<%-- 
    Document   : mlm_personared
   Este jsp despliega la descendencia de un red de MLM
    Created on : 23/03/2012, 12:56:24 AM
    Author     : zeus
--%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
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

      int intIdCliente = 0;
      if (request.getParameter("IdCliente") != null) {
         try {
            intIdCliente = Integer.valueOf(request.getParameter("IdCliente"));
         } catch (NumberFormatException ex) {
         }
      }
      int intIdClienteRaiz = 0;
      if (request.getParameter("IdClienteRaiz") != null) {
         try {
            intIdClienteRaiz = Integer.valueOf(request.getParameter("IdClienteRaiz"));
         } catch (NumberFormatException ex) {
         }
      }
      Fechas fecha = new Fechas();
      //Obtenemos los datos del cliente
      String strNombre = null;
      String strTelefono1 = null;
      String strTelefono2 = null;
      String strEmail1 = null;
      String strCalle = null;
      String strMunicipio = null;
      String strEstado = null;
      String strCP = null;
      String strFechaUltimo = null;
      int intUpline = 0;
      String strNombrePadre = "";
      String strSql = "select * from vta_cliente where CT_ID = " + intIdCliente;
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         strNombre = rs.getString("CT_RAZONSOCIAL");
         strTelefono1 = rs.getString("CT_TELEFONO1");
         strTelefono2 = rs.getString("CT_TELEFONO2");
         strEmail1 = rs.getString("CT_EMAIL1");
         strCalle = rs.getString("CT_CALLE");
         strMunicipio = rs.getString("CT_MUNICIPIO");
         strEstado = rs.getString("CT_ESTADO");
         strCP = rs.getString("CT_CP");
         strFechaUltimo = rs.getString("CT_FECHAULTIMOCONTACTO");
         if (strFechaUltimo.length() == 8) {
            strFechaUltimo = fecha.FormateaDDMMAAAA(strFechaUltimo, "/");
         }
         intUpline = rs.getInt("CT_UPLINE");
      }
      rs.close();
      //Obtenemos datos del padre
      strSql = "select * from vta_cliente where CT_ID = " + intUpline;
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         strNombrePadre = rs.getString("CT_RAZONSOCIAL");
      }
      rs.close();
      //Obtenemos datos de las clasificaciones
      HashMap map1 = new HashMap();
      strSql = "select * from vta_cliecat1 order by CC1_ID";
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         map1.put(rs.getString("CC1_ID"), rs.getString("CC1_DESCRIPCION"));
      }
      rs.close();
      HashMap map2 = new HashMap();
      strSql = "select * from vta_cliecat2 order by CC2_ID";
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         map2.put(rs.getString("CC2_ID"), rs.getString("CC2_DESCRIPCION"));
      }
      rs.close();
      HashMap map3 = new HashMap();
      strSql = "select * from vta_cliecat3 order by CC3_ID";
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         map3.put(rs.getString("CC3_ID"), rs.getString("CC3_DESCRIPCION"));
      }
      rs.close();
      HashMap map4 = new HashMap();
      strSql = "select * from vta_cliecat4 order by CC4_ID";
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         map4.put(rs.getString("CC4_ID"), rs.getString("CC4_DESCRIPCION"));
      }
      rs.close();
      HashMap map5 = new HashMap();
      strSql = "select * from vta_cliecat5 order by CC5_ID";
      rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         map5.put(rs.getString("CC5_ID"), rs.getString("CC5_DESCRIPCION"));
      }
      rs.close();

%>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Red de la persona</title>
   </head>
   <body>

      <table border="0" cellpadding="1" class="listas">
         <tr>
            <td valign="top">
               <h1>Información de la persona:<%=strNombre%></h1>
               <table border="0" cellpadding="1">
                  <tbody>
                     <tr>
                        <th>Id Socio:</td>
                        <td><%=intIdCliente%></td>
                        <th>Nombre:</td>
                        <td><%=strNombre%></td>
                     </tr>
                     <tr>
                        <th >Id Socio Padre:</td>
                        <td><%=intUpline%></td>
                        <th>Nombre Socio Padre:</td>
                        <td><%=strNombrePadre%></td>
                     </tr>
                     <tr>
                        <th>Celular:</td>
                        <td><%=strTelefono2%></td>
                        <th>Telefóno:</td>
                        <td><%=strTelefono1%></td>
                     </tr>
                     <tr>
                        <th>Email:</td>
                        <td><%=strEmail1%></td>
                        <th>Dirección:</td>
                        <td><%=strCalle%></td>
                     </tr>
                     <tr>
                        <th>Ciudad:</td>
                        <td><%=strMunicipio%></td>
                        <th>Estado:</td>
                        <td><%=strEstado%></td>
                     </tr>
                     <tr>
                        <th>Código Postal:</td>
                        <td><%=strCP%></td>
                        <td></td>
                        <td></td>
                     </tr>
                     <tr>
                        <th>Última conferencia:</td>
                        <td></td>
                        <th>Último contacto:</td>
                        <td><%=strFechaUltimo%></td>
                     </tr>
                     <tr>
                        <td><button id="Regresar" onclick="CancelSave()">Regresar</button>  </td>
                        <td><button id="EditarDetalle" onclick="EditarDeta(<%=intIdCliente%>)">Editar</button>  </td>
                        <td><button id="AgregarHijo" onclick="NuevaPersona(<%=intIdCliente%>)">Agregar Hijo</button>  </td>
                        <td></td>
                     </tr>
                  </tbody>
               </table>

            </td>
            <td valign="top">
         <center>
            <h1>Linea del multinivel:</h1>

            <h1>Linea ascendente:</h1>
            <table border="0" cellpadding="1" class="listas">
               <thead>
                  <tr>
                     <th class="head">Persona</th>
                     <th class="head">Celular</th>
                     <th class="head">Telefono</th>
                     <th class="head">Email</th>
                     <th class="head">Asiste a nuestras conferencias</th>
                     <th class="head">Quiere que le mantengamos informado</th>
                     <th class="head">Como prefiere que lo contactemos</th>
                     <th class="head">Resultado contacto</th>
                     <th class="head">Nivel de interes</th>
                     <th class="head">Actualizado</th>
                     <th class="head"></th>
                  </tr>
               </thead>
               <tbody>
                  <%
                     //Obtenemos lista de ASCENDENTES
                     //Ciclo hasta llegar al nodo anterior al raiz
                     int intNodoIni = 0;
                     //Aplica unicamente si el cliente raiz es diferente del cliente actual
                     if (intIdClienteRaiz != intIdCliente) {
                        if (intIdClienteRaiz == intIdCliente || intIdClienteRaiz == intUpline || intUpline == 1) {
                           intNodoIni = intIdClienteRaiz;
                        } else {
                           int intUplineTmp = intUpline;
                           while (intNodoIni == 0) {
                              boolean bolExists = false;
                              strSql = "SELECT CT_UPLINE from vta_cliente WHERE CT_ID = " + intUplineTmp + "";
                              rs = oConn.runQuery(strSql, true);
                              while (rs.next()) {
                                 bolExists = true;
                                 if (rs.getInt("CT_UPLINE") == intIdClienteRaiz || rs.getInt("CT_UPLINE") == 0) {
                                    intNodoIni = intUplineTmp;
                                 } else {
                                    intUplineTmp = rs.getInt("CT_UPLINE");
                                 }
                              }
                              //Se sale si ya no encontramos nada en el resultset
                              if (!bolExists) {
                                 if (intUplineTmp == 0) {
                                    intNodoIni = -1;
                                 } else {
                                    intNodoIni = intUplineTmp;
                                 }
                              }
                              rs.close();
                           }
                        }
                        if (intIdClienteRaiz == intIdCliente || intIdClienteRaiz == intUpline || intUpline == 1) {
                           strSql = "SELECT CT_ID,CT_UPLINE,CT_RAZONSOCIAL,CT_TELEFONO1,"
                                   + "CT_TELEFONO2,CT_EMAIL1,CT_ARMADODEEP,CT_ARMADOINI,CT_ARMADOFIN,CT_FECHAULTIMOCONTACTO,"
                                   + "CT_CATEGORIA1,CT_CATEGORIA2,CT_CATEGORIA3,CT_CATEGORIA4,CT_CATEGORIA5"
                                   + " FROM vta_cliente WHERE "
                                   + " CT_ID=" + intIdClienteRaiz + ""
                                   + " ORDER BY CT_ARMADONUM";
                        } else {
                           strSql = "SELECT CT_ID,CT_UPLINE,CT_RAZONSOCIAL,CT_TELEFONO1,"
                                   + "CT_TELEFONO2,CT_EMAIL1,CT_ARMADODEEP,CT_ARMADOINI,CT_ARMADOFIN,CT_FECHAULTIMOCONTACTO,"
                                   + "CT_CATEGORIA1,CT_CATEGORIA2,CT_CATEGORIA3,CT_CATEGORIA4,CT_CATEGORIA5"
                                   + " FROM vta_cliente WHERE "
                                   + " (CT_ARMADONUM=(SELECT CT_ARMADOINI FROM vta_cliente where CT_ID = " + intIdClienteRaiz + ")"
                                   + " OR CT_ARMADONUM>=(SELECT CT_ARMADOINI FROM vta_cliente where CT_ID = " + intNodoIni + ")) AND "
                                   + " CT_ARMADONUM<=(SELECT CT_ARMADOFIN FROM vta_cliente where CT_ID = " + intNodoIni + ")"
                                   + " AND CT_ARMADONUM<(SELECT CT_ARMADOINI FROM vta_cliente where CT_ID = " + intIdCliente + ")"
                                   + " ORDER BY CT_ARMADONUM";
                        }
                        rs = oConn.runQuery(strSql, true);
                        while (rs.next()) {
                           StringBuilder strDeep = new StringBuilder("");
                           for (int h = 1; h <= rs.getInt("CT_ARMADODEEP"); h++) {
                              strDeep.append("|");
                           }
                           strDeep.append("-");
                           String strFechaUltimo2 = rs.getString("CT_FECHAULTIMOCONTACTO");
                           if (strFechaUltimo2.length() == 8) {
                              strFechaUltimo2 = fecha.FormateaDDMMAAAA(strFechaUltimo2, "/");
                           }
                           String strCat1 = "";
                           if (map1.containsKey(rs.getString("CT_CATEGORIA1"))) {
                              strCat1 = map1.get(rs.getString("CT_CATEGORIA1")).toString();
                           }
                           String strCat2 = "";
                           if (map2.containsKey(rs.getString("CT_CATEGORIA2"))) {
                              strCat2 = map2.get(rs.getString("CT_CATEGORIA2")).toString();
                           }
                           String strCat3 = "";
                           if (map3.containsKey(rs.getString("CT_CATEGORIA3"))) {
                              strCat3 = map3.get(rs.getString("CT_CATEGORIA3")).toString();
                           }
                           String strCat4 = "";
                           if (map4.containsKey(rs.getString("CT_CATEGORIA4"))) {
                              strCat4 = map4.get(rs.getString("CT_CATEGORIA4")).toString();
                           }
                           String strCat5 = "";
                           if (map5.containsKey(rs.getString("CT_CATEGORIA5"))) {
                              strCat5 = map5.get(rs.getString("CT_CATEGORIA5")).toString();
                           }
                  %>
                  <tr>
                     <td nowrap><a href="javascript:uniRed(<%=rs.getString("CT_ID")%>)"><%=strDeep + " " + rs.getString("CT_ID") + ".-&nbsp;" + rs.getString("CT_RAZONSOCIAL")%></a></td>
                     <td><%=rs.getString("CT_TELEFONO1")%></td>
                     <td><%=rs.getString("CT_TELEFONO2")%></td>
                     <td><%=rs.getString("CT_EMAIL1")%></td>
                     <td><%=strCat1%></td>
                     <td><%=strCat2%></td>
                     <td><%=strCat3%></td>
                     <td><%=strCat4%></td>
                     <td><%=strCat5%></td>
                     <td><%=strFechaUltimo2%></td>
                     <td></td>
                  </tr>
                  <%                        }
                        rs.close();
                     }
                  %>
                  <tr>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                  </tr>
               </tbody>
            </table>
            <h1>Linea descendente:</h1>

            <table border="0" cellpadding="1" class="listas">
               <thead>
                  <tr>
                     <th class="head">Persona</th>
                     <th class="head">Celular</th>
                     <th class="head">Telefono</th>
                     <th class="head">Email</th>
                     <th class="head">Asiste a nuestras conferencias</th>
                     <th class="head">Quiere que le mantengamos informado</th>
                     <th class="head">Como prefiere que lo contactemos</th>
                     <th class="head">Resultado contacto</th>
                     <th class="head">Nivel de interes</th>
                     <th class="head">Actualizado</th>
                     <th class="head">Borrar</th>
                  </tr>
               </thead>
               <tbody>
                  <%
                     //Obtenemos lista de clientes
                     int intConta = 0;
                     strSql = "SELECT CT_ID,CT_UPLINE,CT_RAZONSOCIAL,CT_TELEFONO1,"
                             + "CT_TELEFONO2,CT_EMAIL1,CT_ARMADODEEP,CT_ARMADOINI,"
                             + "CT_ARMADOFIN,CT_FECHAULTIMOCONTACTO,"
                             + "CT_CATEGORIA1,CT_CATEGORIA2,CT_CATEGORIA3,CT_CATEGORIA4,CT_CATEGORIA5"
                             + " FROM vta_cliente WHERE "
                             + " CT_ARMADONUM>=(SELECT CT_ARMADOINI FROM vta_cliente where CT_ID = " + intIdCliente + ") AND "
                             + " CT_ARMADONUM<=(SELECT CT_ARMADOFIN FROM vta_cliente where CT_ID = " + intIdCliente + ") "
                             + " ORDER BY CT_ARMADONUM";
                     rs = oConn.runQuery(strSql, true);
                     while (rs.next()) {
                        intConta++;
                        StringBuilder strDeep = new StringBuilder("");
                        for (int h = 1; h <= rs.getInt("CT_ARMADODEEP"); h++) {
                           strDeep.append("|");
                        }
                        strDeep.append("-");
                        String strFechaUltimo2 = rs.getString("CT_FECHAULTIMOCONTACTO");
                        if (strFechaUltimo2.length() == 8) {
                           strFechaUltimo2 = fecha.FormateaDDMMAAAA(strFechaUltimo2, "/");
                        }
                        String strCat1 = "";
                        if (map1.containsKey(rs.getString("CT_CATEGORIA1"))) {
                           strCat1 = map1.get(rs.getString("CT_CATEGORIA1")).toString();
                        }
                        String strCat2 = "";
                        if (map2.containsKey(rs.getString("CT_CATEGORIA2"))) {
                           strCat2 = map2.get(rs.getString("CT_CATEGORIA2")).toString();
                        }
                        String strCat3 = "";
                        if (map3.containsKey(rs.getString("CT_CATEGORIA3"))) {
                           strCat3 = map3.get(rs.getString("CT_CATEGORIA3")).toString();
                        }
                        String strCat4 = "";
                        if (map4.containsKey(rs.getString("CT_CATEGORIA4"))) {
                           strCat4 = map4.get(rs.getString("CT_CATEGORIA4")).toString();
                        }
                        String strCat5 = "";
                        if (map5.containsKey(rs.getString("CT_CATEGORIA5"))) {
                           strCat5 = map5.get(rs.getString("CT_CATEGORIA5")).toString();
                        }
                  %>
                  <tr>
                     <td nowrap><a href="javascript:uniRed(<%=rs.getString("CT_ID")%>)"><%=strDeep + " " + rs.getString("CT_ID") + ".-&nbsp;" + rs.getString("CT_RAZONSOCIAL")%></a></td>
                     <td><%=rs.getString("CT_TELEFONO1")%></td>
                     <td><%=rs.getString("CT_TELEFONO2")%></td>
                     <td><%=rs.getString("CT_EMAIL1")%></td>
                     <td><%=strCat1%></td>
                     <td><%=strCat2%></td>
                     <td><%=strCat3%></td>
                     <td><%=strCat4%></td>
                     <td><%=strCat5%></td>
                     <td><%=strFechaUltimo2%></td>
                     <%
                     if(intConta >1 ){
                        %>
                        <td><a href="javascript:BorraHijo(<%=rs.getString("CT_ID")%> ,<%=intIdCliente%>)">Borrar</a></td>
                        <%
                     }else{
                        %>
                        <td>&nbsp;</td>
                        <%
                     }
                     %>
                     
                  </tr>
                  <%                        }
                     rs.close();
                  %>
                  <tr>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                  </tr>
               </tbody>
            </table>
            <center>
               </td>
               </tr>
               </table>

               </body>
               </html>

               <%            }
               %>
