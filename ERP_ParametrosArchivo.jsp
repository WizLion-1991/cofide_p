<%-- 
    Document   : P_ParametrosArchivo
    Created on : 21/03/2013, 12:14:56 PM
    Author     : SIWEB
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Operaciones.bitacorausers"%>
<%@page import="com.mx.siweb.prosefi.Parametros_archivo"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
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
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request))
   {
       Fechas fecha = new Fechas();
       String strid = request.getParameter("ID");
       if (strid != null)
       {

           if(strid.equals("1"))
           {
               Parametros_archivo  PA = new Parametros_archivo(varSesiones);
               //OBTENEMOS VALORES
               String Clave = request.getParameter("CPM_ID");
               String Nombre = request.getParameter("CPMD_NOMBRE_CAMPO");
               String Tipo = request.getParameter("CPMD_TIPO");
               String Expresion = request.getParameter("CPMD_EXP_REG");
               String Orden = request.getParameter("CPMD_ORDEN");
               String ID = request.getParameter("CPMD_ID");
               
               PA.getPA().setFieldString("CPMD_ID", ID);
               PA.getPA().setFieldString("CPM_ID", Clave);
               PA.getPA().setFieldString("CPMD_NOMBRE_CAMPO", Nombre);
               PA.getPA().setFieldString("CPMD_TIPO", Tipo);
               PA.getPA().setFieldString("CPMD_EXP_REG", Expresion);
               PA.getPA().setFieldString("CPMD_ORDEN", Orden);
               String strRes = PA.AltaDatos(oConn);
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML               
               out.println(strRes);//Pintamos el resultado      

                bitacorausers logUser = new bitacorausers();
                logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                logUser.setFieldString("BTU_NOMMOD", "PARAMETRO ARCHIVO");
                logUser.setFieldString("BTU_NOMACTION", "ALTA");
                logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                String strRes1 = logUser.Agrega(oConn);
                String strResultLast = "";
                if (!strRes1.equals("OK")) {
                    strResultLast = strRes;
                }
                                                                 
           }
           
           
           //SIRVE PARA ACTUALIZAR 
           if(strid.equals("3"))
           {
               Parametros_archivo PA = new Parametros_archivo(varSesiones);
               
               String strClaveid     = request.getParameter("CPMD_ID");
               String strClave     = request.getParameter("CPM_ID");
               String strNombre    = request.getParameter("CPMD_NOMBRE_CAMPO");
               String strTipo      = request.getParameter("CPMD_TIPO");
               String strExpresion = request.getParameter("CPMD_EXP_REG");
               String strOrden     = request.getParameter("CPMD_ORDEN");
            
               PA.getPA().setFieldString("CPMD_ID", strClaveid);
               PA.getPA().setFieldString("CPM_ID", strClave);
               PA.getPA().setFieldString("CPMD_NOMBRE_CAMPO", strNombre);
               PA.getPA().setFieldString("CPMD_TIPO", strTipo);
               PA.getPA().setFieldString("CPMD_EXP_REG", strExpresion);
               PA.getPA().setFieldString("CPMD_ORDEN", strOrden);
               String strResXML = PA.updateDatos(oConn);
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strResXML);//Pintamos el resultado
               
                bitacorausers logUser = new bitacorausers();
                logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                logUser.setFieldString("BTU_NOMMOD", "PARAMETRO ARCHIVO");
                logUser.setFieldString("BTU_NOMACTION", "MODIFICA");
                logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                String strRes2 = logUser.Agrega(oConn);
                String strResultLast = "";
                if (!strRes2.equals("OK")) {
                    strResultLast = strResXML;
                }               
               
           }
           /*
           //SIRVE PARA OBTENER LA INFORMACION DE LA PESTAÑA DATOS BASICOS
           if(strid.equals("2"))
           {
               parametros_archivo PA = new parametros_archivo(varSesiones);
               String strResXML = PA.getDataDatosBasicos(oConn);
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strResXML);//Pintamos el resultado
           }
           
            //SIRVE PARA DAR DE ALTA UNA META EN ESTRATEGIAS
           if(strid.equals("4"))
           {
              parametros_archivo PA = new parametros_archivo(varSesiones);
              String Titulo = request.getParameter("ME_TITULO");
              String Descripcion = request.getParameter("ME_DESCRIPCION");
              PA.getPA().setFieldString("ME_TITULO", Titulo);
              PA.getPA().setFieldString("ME_DESCRIPCION", Descripcion);
              String strRes=PA.AltaDatos(oConn);
              out.clearBuffer();//Limpiamos buffer
              atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
              out.println(strRes);//Pintamos el resultado
           }*/
           //SIRVE PARA ACTUALIZAR UNA META EN ESTRATEGIAS
           if(strid.equals("5"))
           {
               Parametros_archivo PA = new Parametros_archivo(varSesiones);
               
               String strClave = request.getParameter("CPM_ID");
               String strNombre = request.getParameter("CPMD_NOMBRE_CAMPO");
               String strTipo = request.getParameter("CPMD_TIPO");
               String strExpresion = request.getParameter("CPMD_EXP_REG");
               String strOrden = request.getParameter("CPMD_ORDEN");
                             
               
               PA.getPA().setFieldString("CPM_ID", strClave);
               PA.getPA().setFieldString("CPMD_NOMBRE_CAMPO", strNombre);
               PA.getPA().setFieldString("CPMD_TIPO", strTipo);
               PA.getPA().setFieldString("CPMD_EXP_REG", strExpresion);
               PA.getPA().setFieldString("CPMD_ORDEN", strOrden);
               
               String strRes = PA.updateDatos(oConn);
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strRes);//Pintamos el resultado
               
                bitacorausers logUser = new bitacorausers();
                logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                logUser.setFieldString("BTU_NOMMOD", "PARAMETRO ARCHIVO");
                logUser.setFieldString("BTU_NOMACTION", "MODIFICA");
                logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                String strRes3 = logUser.Agrega(oConn);
                String strResultLast = "";
                if (!strRes3.equals("OK")) {
                    strResultLast = strRes;
                }                    
               
           }
           //SIRVE PARA ELIMINAR UNA META EN ESTRATEGIAS
           if(strid.equals("6"))
           {
               Parametros_archivo PA = new Parametros_archivo(varSesiones);
               String strID = request.getParameter("CPMD_ID");
               PA.getPA().setFieldInt("CPMD_ID", Integer.parseInt(strID));
               String strRes = PA.deleteDatos(oConn);
               out.clearBuffer();//Limpiamos buffer
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strRes);//Pintamos el resultado
               
                bitacorausers logUser = new bitacorausers();
                logUser.setFieldString("BTU_FECHA", fecha.getFechaActual());
                logUser.setFieldString("BTU_HORA", fecha.getHoraActual());
                logUser.setFieldString("BTU_NOMMOD", "PARAMETRO ARCHIVO");
                logUser.setFieldString("BTU_NOMACTION", "ELIMINA");
                logUser.setFieldInt("BTU_IDOPER", varSesiones.getIntNoUser());
                logUser.setFieldInt("BTU_IDUSER", varSesiones.getIntNoUser());
                logUser.setFieldString("BTU_NOMUSER", varSesiones.getStrUser());
                String strRes4 = logUser.Agrega(oConn);
                String strResultLast = "";
                if (!strRes4.equals("OK")) {
                    strResultLast = strRes;
                }                    
               
           }
           
           
           
                     }
             }
%>           