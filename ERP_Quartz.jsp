<%-- 
    Document   : ERP_Quartz
    Created on : 28-mar-2016, 17:17:01
    Author     : ZeusSIWEB
--%>
<%@page import="com.mx.siweb.quartz.jobs.JobMailMasivo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.ContextoApt.atrJSP"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.quartz.JobExecutionContext"%>
<%@page import="java.util.List"%>
<%@page import="com.mx.siweb.erp.especiales.quartz.jobs.JobFtp"%>
<%@page import="com.mx.siweb.erp.especiales.quartz.jobs.JobXls"%>
<%@page import="org.quartz.impl.matchers.KeyMatcher"%>

<%@page import="org.quartz.CronTrigger"%>
<%@page import="org.quartz.Scheduler"%>
<%@page import="org.quartz.JobBuilder"%>
<%@page import="org.quartz.JobDetail"%>
<%@page import="org.quartz.JobKey"%>
<%@page import="org.quartz.impl.StdSchedulerFactory"%>
<%@page import="org.quartz.ee.servlet.QuartzInitializerListener"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
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
        String strid = request.getParameter("id");
        //Si la peticion no fue nula proseguimos
        if (strid != null) {
            //Objeto schedule
            StdSchedulerFactory factory = (StdSchedulerFactory) this.getServletContext().getAttribute(QuartzInitializerListener.QUARTZ_FACTORY_KEY);
            Scheduler sched = factory.getScheduler();
            if (strid.equals("1")) {
                //Recibimos parametros
                String strNameJob = request.getParameter("nameJob");
                String strNameTrigger = request.getParameter("nameTrigger");
                String strCron = request.getParameter("cron");
                //Seleccionamos que job arrancamos
                JobKey jobKey = null;
                JobBuilder jobBuilder = null;
                String strTriggerIdentity = null;
                String strGrupoDefa = "group1";
                strTriggerIdentity = strNameTrigger;
                jobKey = new JobKey(strNameJob, strGrupoDefa);
                if (strNameJob.equals("MAIL_MASIVO")) {
                    jobBuilder = JobBuilder.newJob(JobMailMasivo.class).withIdentity(jobKey);
                }
                if (strNameJob.equals("MASIVOS")) {
                    jobBuilder = JobBuilder.newJob(JobXls.class).withIdentity(jobKey);
                }
                if (strNameJob.equals("LeerFtp")) {
                    jobBuilder = JobBuilder.newJob(JobFtp.class).withIdentity(jobKey);
                }
                if (strNameJob.equals("ArchivosEntrada")) {
                    jobBuilder = JobBuilder.newJob(JobFtp.class).withIdentity(jobKey);
                }

                //Construccion del job
                JobDetail job = jobBuilder.build();
                CronTrigger triggerCron = org.quartz.TriggerBuilder.newTrigger()
                        .withIdentity(strTriggerIdentity, strGrupoDefa)
                        .withSchedule(org.quartz.CronScheduleBuilder.cronSchedule(strCron))
                        .build();
                sched.scheduleJob(job, triggerCron);

                String strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado

            }
            //Detenemos el job
            if (strid.equals("2")) {

                //Recibimos parametros
                String strNameJob = request.getParameter("nameJob");
                //Seleccionamos que job arrancamos
                JobKey jobKey = null;
                String strGrupoDefa = "group1";
                jobKey = new JobKey(strNameJob, strGrupoDefa);
                //sched.interrupt(jobKey);
                sched.deleteJob(jobKey);
                String strRes = "OK";
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
                out.println(strRes);//Pintamos el resultado
            }
            if (strid.equals("3")) {

                StringBuilder strXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
                strXML.append("<QUARTZ>");
                int intQTZ_ID = 0;
                String strQTZ_NOMBRE = "";
                String strQTZ_ABRV = "";
                String strQTZ_STATUS = "";
                String strSql = "SELECT * FROM qrtz_siweb_jobs";
                ResultSet rs = oConn.runQuery(strSql, true);
                while (rs.next()) {
                    intQTZ_ID = rs.getInt("QTZ_ID");
                    strQTZ_NOMBRE = rs.getString("QTZ_NOMBRE");
                    strQTZ_ABRV = rs.getString("QTZ_ABRV");
                    strQTZ_STATUS = rs.getString("QTZ_STATUS");
                    strXML.append("<datos");
                    strXML.append(" QTZ_ID = \"").append(intQTZ_ID).append("\"");
                    strXML.append(" QTZ_NOMBRE = \"").append(strQTZ_NOMBRE).append("\"");
                    strXML.append(" QTZ_ABRV = \"").append(strQTZ_ABRV).append("\"");
                    strXML.append(" QTZ_STATUS = \"").append(strQTZ_STATUS).append("\"");
                    strXML.append(" />");
                }
                strXML.append("</QUARTZ>");
                strXML.toString();
                rs.close();
                out.clearBuffer();//Limpiamos buffer
                atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
                out.println(strXML);//Pintamos el resultado
            }
            //Consultamos el estado de cada job
            if (strid.equals("4")) {
                //System.out.println("Leyendo archivos en ejecucion ");
                List<JobExecutionContext> list = sched.getCurrentlyExecutingJobs();
                Iterator<JobExecutionContext> it = list.iterator();
                while (it.hasNext()) {
                    JobExecutionContext job = it.next();
                }

            }
        }
    } else {
    }
    oConn.close();
%>