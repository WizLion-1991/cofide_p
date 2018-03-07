<%-- 
    Document   : CIP_Salir
    Salir
    Jsp que limpia las variables de sesion
    Created on : 15-jun-2012, 0:16:37
    Author     : aleph_79
--%>
<%@page import="java.util.Calendar"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.usuarios_accesos"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   String strUserNameLast = varSesiones.getStrUser();
   int intIdUsuario = varSesiones.getIntNoUser();
   int intIdCliente = varSesiones.getintIdCliente();
   varSesiones.SetVars(0, 0, 0, 0, "", "", 0, "", 0);
//Obtenemos la sesion Actual y la limpiamos
   //session.invalidate();
//Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Limpiamos usuario normal
   if (intIdCliente == 0) {
      String strUpdate = "update usuarios set IS_LOGGED=0 where id_usuarios =  " + intIdUsuario;
      oConn.runQueryLMD(strUpdate);
   } else {
      //Limpiamos cliente
      String strUpdate = "update vta_cliente set CT_IS_LOGGED=0 where CT_ID=  " + intIdCliente;
      oConn.runQueryLMD(strUpdate);
   }
   
   //Guardamos bitacora de acceso
   Fechas fecha = new Fechas();
   java.util.Date today = (java.util.Date) Calendar.getInstance().getTime();
   usuarios_accesos bitaAcceso = new usuarios_accesos();
   bitaAcceso.setFieldInt("id_usuario", intIdUsuario);
   bitaAcceso.setFieldString("seg_nombre_user", strUserNameLast);
   bitaAcceso.setFieldString("seg_fecha", fecha.getFechaActual());
   bitaAcceso.setFieldString("seg_hora", fecha.getHoraActualHHMMSS());
   bitaAcceso.setFieldString("seg_ip_remote", request.getRemoteAddr());
   bitaAcceso.setFieldString("seg_computer_name", request.getRemoteHost());
   bitaAcceso.setFieldString("seg_session_id", request.getSession().getId());
   bitaAcceso.setFieldLong("seg_date", today.getTime());
   bitaAcceso.setFieldInt("seg_total_time", 0);
   bitaAcceso.setFieldInt("seg_tipo_ini_fin", 99);
   //Guardamos estadistica
   bitaAcceso.Agrega(oConn);

   //Aqui se guarda la bitacora de cuando se salio el cliente del sistema
   oConn.close();
%>
%>
<jsp:forward page="Login.do"/>