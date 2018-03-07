<%-- 
    Document   : crm_historial_seg
    Created on : 17/03/2015, 04:43:44 PM
    Author     : siweb
--%>

<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_ContratoXMes"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_ClienteXMes"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Contrato"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Cliente"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Mes"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="com.mx.siweb.erp.reportes.RepoFacTimbFisc_Anio"%>
<%@page import="ERP.ContabilidadRestfulClient"%>
<%@page import="java.sql.ResultSet"%>
<%

   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();

   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad(); //Valida que la peticion se halla hecho desde el mismo sitio
   Fechas fecha = new Fechas();

   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      //Obtenemos parametros
      String strid = request.getParameter("id");
      //Si la peticion no fue nula proseguimos

      //Si la peticion no fue nula proseguimos
      if (!strid.equals(null)) {

         if (strid.equals("1")) {

            String CT_ID = request.getParameter("CT_ID");

            String strFechaAnt = "00000000";
            String strHoraAnt = "00:00:00";

            String strSql3 = "SELECT * FROM crm_historial_seguimiento WHERE HS_ID = (SELECT MAX(HS_ID) FROM crm_historial_seguimiento where ct_id = " + CT_ID + ")";
            ResultSet rs3 = oConn.runQuery(strSql3, true);
            while (rs3.next()) {
               if (rs3.getString("HS_FECHA") != "") {
                  if (rs3.getString("HS_HORA") != "") {
                     strFechaAnt = rs3.getString("HS_FECHA");
                     strHoraAnt = rs3.getString("HS_HORA");
                  }
               }
            }
            rs3.close();

            int year = Integer.parseInt(strFechaAnt.substring(0, 4));
            int month = Integer.parseInt(strFechaAnt.substring(4, 6));
            int day = Integer.parseInt(strFechaAnt.substring(6));

            int hour = Integer.parseInt(strHoraAnt.substring(0, 2));
            int min = Integer.parseInt(strHoraAnt.substring(3, 5));
            int sec = Integer.parseInt(strHoraAnt.substring(6));

            String HS_FECHA = fecha.getFechaActual();

            String HS_HORA = fecha.getHoraActualHHMMSS();

            int year1 = Integer.parseInt(HS_FECHA.substring(0, 4));
            int month1 = Integer.parseInt(HS_FECHA.substring(4, 6));
            int day1 = Integer.parseInt(HS_FECHA.substring(6));

            int hour1 = Integer.parseInt(HS_HORA.substring(0, 2));
            int min1 = Integer.parseInt(HS_HORA.substring(3, 5));
            int sec1 = Integer.parseInt(HS_HORA.substring(6));

            String HS_COMENTARIOS = request.getParameter("HS_COMENTARIOS");

            String HS_USER = request.getParameter("HS_USER");
            if (HS_USER.equals("")) {
               HS_USER = "0";
            }

            String CAM_ID = request.getParameter("CAM_ID");
            String EP_ID = request.getParameter("EP_ID");

            String HS_GENERAR_EVENTO = request.getParameter("HS_GENERAR_EVENTO");

            String HS_FECHA_SIGUIENTE_CONTACTO = fecha.FormateaBD(request.getParameter("HS_FECHA_SIGUIENTE_CONTACTO"), "/");

            Calendar cal1 = Calendar.getInstance();
            Calendar cal2 = Calendar.getInstance();

            cal1.set(year, month, day, hour, min, sec);
            cal2.set(year1, month1, day1, hour1, min1, sec1);

            //System.out.println("*****************************************");
            //System.out.println(year);
            //System.out.println(month);
            //System.out.println(day);
            //System.out.println(hour);
            //System.out.println(min);
            //System.out.println(sec);           
            //System.out.println("*****************************************");
            //System.out.println(year1);
            //System.out.println(month1);
            //System.out.println(day1);
            //System.out.println(hour1);
            //System.out.println(min1);
            //System.out.println(sec1);           
            //System.out.println("*****************************************");
            // conseguir la representacion de la fecha en milisegundos
            long milis1 = cal1.getTimeInMillis();
            long milis2 = cal2.getTimeInMillis();

            // calcular la diferencia en milisengundos
            long diff = milis2 - milis1;
            // calcular la diferencia en segundos
            long diffSeconds = diff / 1000;
            // calcular la diferencia en minutos
            long diffMinutes = diff / (60 * 1000);

            // calcular la diferencia en horas
            long diffHours = diff / (60 * 60 * 1000);
            // calcular la diferencia en dias
            //  long diffDays = diff / (24 * 60 * 60 * 1000);
            
            String HS_TIEMPO_ACUMULADO ="";
            if (strFechaAnt != "00000000") {
             HS_TIEMPO_ACUMULADO = String.valueOf(diffHours);
            }else{
              HS_TIEMPO_ACUMULADO = "0";
            }

            //System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //System.out.println(diff);
            //System.out.println(diffSeconds);
            //System.out.println(diffMinutes);
            //System.out.println(diffHours);
            //System.out.println(diffDays);
            String strSql = "INSERT INTO crm_historial_seguimiento (CT_ID,HS_FECHA,HS_HORA,HS_COMENTARIOS,HS_TIEMPO_ACUMULADO,HS_USER,CAM_ID,EP_ID,HS_GENERAR_EVENTO,HS_FECHA_SIGUIENTE_CONTACTO) values "
                    + "(" + CT_ID + ",'" + HS_FECHA + "','" + HS_HORA + "','" + HS_COMENTARIOS + "'," + HS_TIEMPO_ACUMULADO + ",'" + HS_USER + "'," + CAM_ID + "," + EP_ID + "," + HS_GENERAR_EVENTO + ",'" + HS_FECHA_SIGUIENTE_CONTACTO + "')";

            oConn.runQueryLMD(strSql);

            String XML_HS_FECHA = "";
            String XML_HS_HORA = "";
            String XML_HS_COMENTARIOS = "";
            String XML_HS_TIEMPO_ACUMULADO = "";
            String XML_EP_ID = "";
            String XML_HS_GENERAR_EVENTO = "";
            String XML_HS_FECHA_SIGUIENTE_CONTACTO = "";

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<crm_historial_seguimiento>";
            //Consultamos la info

            String strSql1 = "SELECT * FROM crm_historial_seguimiento WHERE HS_ID = (SELECT MAX(HS_ID) FROM crm_historial_seguimiento where ct_id = " + CT_ID + ")";
            ResultSet rs = oConn.runQuery(strSql1, true);
            while (rs.next()) {

               XML_HS_FECHA = rs.getString("HS_FECHA");
               XML_HS_HORA = rs.getString("HS_HORA");
               XML_HS_COMENTARIOS = rs.getString("HS_COMENTARIOS");
               XML_HS_TIEMPO_ACUMULADO = rs.getString("HS_TIEMPO_ACUMULADO");

               String strSql2 = "SELECT * FROM crm_prospecto_estatus WHERE ep_id =" + rs.getString("EP_ID");
               ResultSet rs2 = oConn.runQuery(strSql2, true);
               while (rs2.next()) {

                  XML_EP_ID = rs2.getString("EP_DESCRIPCION");
               }
               rs2.close();
               XML_HS_GENERAR_EVENTO = rs.getString("HS_GENERAR_EVENTO");
               XML_HS_FECHA_SIGUIENTE_CONTACTO = rs.getString("HS_FECHA_SIGUIENTE_CONTACTO");

               String strFechaSigCont = "";
               if (XML_HS_FECHA_SIGUIENTE_CONTACTO != "") {

                  strFechaSigCont = fecha.Formatea(XML_HS_FECHA_SIGUIENTE_CONTACTO, "/");

               }
               strXML += "<crm_historial_seguimiento1 "
                       + " HS_FECHA = \"" + fecha.Formatea(XML_HS_FECHA, "/") + "\"  "
                       + " HS_HORA = \"" + XML_HS_HORA + "\"  "
                       + " HS_COMENTARIOS = \"" + XML_HS_COMENTARIOS + "\"  "
                       + " HS_TIEMPO_ACUMULADO = \"" + XML_HS_TIEMPO_ACUMULADO + "\"  "
                       + " EP_ID = \"" + XML_EP_ID + "\"  "
                       + " HS_GENERAR_EVENTO = \"" + XML_HS_GENERAR_EVENTO + "\"  "
                       + " HS_FECHA_SIGUIENTE_CONTACTO = \"" + strFechaSigCont + "\"  "
                       + " />";

            }

            rs.close();

            strXML += "</crm_historial_seguimiento>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

         if (strid.equals("2")) {

            String CT_ID = request.getParameter("CT_ID");

            String XML_HS_FECHA = "";
            String XML_HS_HORA = "";
            String XML_HS_COMENTARIOS = "";
            String XML_HS_TIEMPO_ACUMULADO = "";
            String XML_EP_ID = "";
            String XML_HS_GENERAR_EVENTO = "";
            String XML_HS_FECHA_SIGUIENTE_CONTACTO = "";

            String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            strXML += "<crm_historial_seguimiento>";
            //Consultamos la info

            String strSql1 = "SELECT * FROM crm_historial_seguimiento WHERE  ct_id = " + CT_ID;
            ResultSet rs = oConn.runQuery(strSql1, true);
            while (rs.next()) {

               XML_HS_FECHA = rs.getString("HS_FECHA");
               XML_HS_HORA = rs.getString("HS_HORA");
               XML_HS_COMENTARIOS = rs.getString("HS_COMENTARIOS");
               XML_HS_TIEMPO_ACUMULADO = rs.getString("HS_TIEMPO_ACUMULADO");

               String strSql2 = "SELECT * FROM crm_prospecto_estatus WHERE ep_id =" + rs.getString("EP_ID");
               ResultSet rs2 = oConn.runQuery(strSql2, true);
               while (rs2.next()) {

                  XML_EP_ID = rs2.getString("EP_DESCRIPCION");
               }
               rs2.close();
               XML_HS_GENERAR_EVENTO = rs.getString("HS_GENERAR_EVENTO");
               XML_HS_FECHA_SIGUIENTE_CONTACTO = rs.getString("HS_FECHA_SIGUIENTE_CONTACTO");

               String strFechaSigCont = "";
               if (XML_HS_FECHA_SIGUIENTE_CONTACTO != "") {

                  strFechaSigCont = fecha.Formatea(XML_HS_FECHA_SIGUIENTE_CONTACTO, "/");

               }

               strXML += "<crm_historial_seguimiento1 "
                       + " HS_FECHA = \"" + fecha.Formatea(XML_HS_FECHA, "/") + "\"  "
                       + " HS_HORA = \"" + XML_HS_HORA + "\"  "
                       + " HS_COMENTARIOS = \"" + XML_HS_COMENTARIOS + "\"  "
                       + " HS_TIEMPO_ACUMULADO = \"" + XML_HS_TIEMPO_ACUMULADO + "\"  "
                       + " EP_ID = \"" + XML_EP_ID + "\"  "
                       + " HS_GENERAR_EVENTO = \"" + XML_HS_GENERAR_EVENTO + "\"  "
                       + " HS_FECHA_SIGUIENTE_CONTACTO = \"" + strFechaSigCont + "\"  "
                       + " />";

            }

            rs.close();

            strXML += "</crm_historial_seguimiento>";
            //Mostramos el resultado
            out.clearBuffer();//Limpiamos buffer
            atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
            out.println(strXML);//Pintamos el resultado
         }

      }
   }
   oConn.close();


%>
