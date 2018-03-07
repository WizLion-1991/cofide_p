<%-- 
    Document   : COFIDE_Correo
    Created on : 28-mar-2016, 9:07:02
    Author     : juliocesar
--%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="com.mx.siweb.erp.especiales.cofide.COFIDE_Mail_cursos"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="comSIWeb.Utilerias.Mail"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();

    COFIDE_Mail_cursos cm = new COFIDE_Mail_cursos();
    String strIdCurso = request.getParameter("id_curso");
    //System.out.println("template 1 " + );
    int intTem1 = Integer.parseInt(request.getParameter("Template1"));
    //int intTem2 = Integer.parseInt(request.getParameter("Template2"));
    //int intTem3 = Integer.parseInt(request.getParameter("Template3"));
    //System.out.println(intTem1 + intTem2 + intTem3);
    String strTemplate1 = "";
    String strTemplate2 = "";
    String strTemplate3 = "";
    if (intTem1 == 1 || intTem1 == 4 || intTem1 == 5) {
        String strSqlTm1 = "select CTT_DESC from cofide_tipo_template where CTT_ID = " + intTem1;
        ResultSet rs = oConn.runQuery(strSqlTm1, true);
        while (rs.next()) {
            strTemplate1 = rs.getString("CTT_DESC");
        }
        rs.close();
        out.print(cm.Cofide_Mail_Cursos(oConn, strIdCurso, strTemplate1, varSesiones.getIntNoUser()));
        //out.print(cm.Cofide_Mail_Cursos(oConn, strIdCurso, strTemplate1));
        /*
    } else if (intTem2 == 4 || intTem2 == 5 || intTem2 == 5) {
        String strSqlTm2 = "select CTT_DESC from cofide_tipo_template where CTT_ID = " + intTem2;
        ResultSet rs2 = oConn.runQuery(strSqlTm2, true);
        while (rs2.next()) {
            strTemplate2 = rs2.getString("CTT_DESC");
        }
        rs2.close();
        out.print(cm.Cofide_Mail_Cursos(oConn, strIdCurso, strTemplate2));
    } else if (intTem3 == 4 || intTem3 == 5 || intTem3 == 5) {
        String strSqlTm3 = "select CTT_DESC from cofide_tipo_template where CTT_ID = " + intTem3;
        ResultSet rs3 = oConn.runQuery(strSqlTm3, true);
        while (rs3.next()) {
            strTemplate3 = rs3.getString("CTT_DESC");
        }
        rs3.close();
        out.print(cm.Cofide_Mail_Cursos(oConn, strIdCurso, strTemplate3));
         */
    } else {
        out.print("<h1> El Template 1 de este Curso Es Grupal </h>");
    }
    oConn.close();
%>

<%    /*
     Fechas fec = new Fechas();

     protected String GeneraMailDip_Sem(Conexion oConn, String strMailCte, String idCurso, String strUser) {
     String strSqlCurso = "Select * from cofide_cursos where cc_curso_id = " + idCurso;
     String strFechaInicial = "";
     String strDuracion = "";
     String strPrecio = "";
     String NOM_CURSO = "";
     try {
     ResultSet rsCurso = oConn.runQuery(strSqlCurso, true);
     while (rsCurso.next()) {
     strFechaInicial = rsCurso.getString("CC_FECHA_INICIAL");
     strDuracion = rsCurso.getString("CC_DURACION_HRS");
     strPrecio = rsCurso.getString("CC_PRECIO_PRES");
     NOM_CURSO = rsCurso.getString("CC_NOMBRE_CURSO");
     }
     } catch (SQLException e) {
     System.out.println(e);
     }
     String strdía = strFechaInicial.substring(6, 8);
     String strMes = strFechaInicial.substring(4, 6);
     String strAño = strFechaInicial.substring(0, 4);
     String strNomMes = "";
     int intMes = Integer.parseInt(strMes);
     if (intMes == 1) {
     strNomMes = "Enero";
     }
     if (intMes == 2) {
     strNomMes = "Febrero";
     }
     if (intMes == 3) {
     strNomMes = "Marzo";
     }
     if (intMes == 4) {
     strNomMes = "Abril";
     }
     if (intMes == 5) {
     strNomMes = "Mayo";
     }
     if (intMes == 6) {
     strNomMes = "Junio";
     }
     if (intMes == 7) {
     strNomMes = "Julio";
     }
     if (intMes == 8) {
     strNomMes = "Agosto";
     }
     if (intMes == 9) {
     strNomMes = "Septiembre";
     }
     if (intMes == 10) {
     strNomMes = "Octubre";
     }
     if (intMes == 11) {
     strNomMes = "Noviembre";
     }
     if (intMes == 12) {
     strNomMes = "Diciembre";
     }
     String strResp = "OK";
     //Nombre de archivo
     //Obtenemos datos del smtp
     String strsmtp_server = "";
     String strsmtp_user = "";
     String strsmtp_pass = "";
     String strsmtp_port = "";
     String strsmtp_usaTLS = "";
     String strsmtp_usaSTLS = "";
     //Buscamos los datos del SMTP
     String strSql = "select * from cuenta_contratada where ctam_id = 1";
     ResultSet rs;
     try {
     rs = oConn.runQuery(strSql, true);
     while (rs.next()) {
     strsmtp_server = rs.getString("smtp_server");
     strsmtp_user = rs.getString("smtp_user");
     strsmtp_pass = rs.getString("smtp_pass");
     strsmtp_port = rs.getString("smtp_port");
     strsmtp_usaTLS = rs.getString("smtp_usaTLS");
     strsmtp_usaSTLS = rs.getString("smtp_usaSTLS");
     }
     rs.close();
     } catch (SQLException ex) {
     System.out.println(ex.getMessage());
     }
     //Obtenemos los textos para el envio del mail
     String strNomTemplate = "DIP_SEM";
     String[] lstMail = getMailTemplate(oConn, strNomTemplate);

        
     // Si estan llenos todos los datos mandamos el mail
        
     if (!strsmtp_server.equals("")
     && !strsmtp_user.equals("")
     && !strsmtp_pass.equals("")) {
     //armamos el mail
     Mail mail = new Mail();
     mail.setBolDepuracion(false);
     //Activamos envio de acuse de recibo
     mail.setBolAcuseRecibo(true);
     //Obtenemos los usuarios a los que mandaremos el mail
     String strLstMail = "";
     //Validamos si el mail del cliente es valido
     if (mail.isEmail(strMailCte)) {
     strLstMail += "," + strMailCte;
     }
     //Mandamos mail si hay usuarios
     if (!strLstMail.equals("")) {
     String strMsgMail = lstMail[1];
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_D}", strdía);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_M}", strNomMes);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_A}", strAño);
     strMsgMail = strMsgMail.replace("{CC_DURACION_HRS}", strDuracion);
     strMsgMail = strMsgMail.replace("{CC_NOMBRE_CURSO}", NOM_CURSO);
     strMsgMail = strMsgMail.replace("{CC_PRECIO_PRES}", strPrecio);
     strMsgMail = strMsgMail.replace("{CC_AGENTE}", strUser);
     //Establecemos parametros
     mail.setUsuario(strsmtp_user);
     mail.setContrasenia(strsmtp_pass);
     mail.setHost(strsmtp_server);
     mail.setPuerto(strsmtp_port);
     mail.setAsunto(lstMail[0].replace("{CC_NOMBRE_CURSO}", NOM_CURSO));
     mail.setDestino(strLstMail);

     mail.setMensaje(strMsgMail);
     //Adjuntamos XML y PDF
     if (strsmtp_usaTLS.equals("1")) {
     mail.setBolUsaTls(true);
     }
     if (strsmtp_usaSTLS.equals("1")) {
     mail.setBolUsaStartTls(true);
     }
     boolean bol = mail.sendMail();
     if (!bol) {
     strResp = "Fallo el envio del Mail.";
     }
     }
     }
     return strResp;
     }

     //diplomado
     protected String GeneraMailDiplomado(Conexion oConn, String strMailCte, String strUser) {
     String strFecha = fec.addFecha(fec.getFechaActual(), 5, -10); //fecha, 10 dias antes
     String strSqlCurso = "select * from cofide_cursos where cc_fecha_inicial >= '" + strFecha + "' and cc_is_diplomado = 1 order by cc_fecha_inicial";
     String strFechaInicial = "";
     String strDuracion = "";
     String strPrecio = "";
     String NOM_CURSO = "";
     String strSede = "";
     String strDeta = "";
     String strEncab = "";
     String strTema = "";
     try {
     ResultSet rsCurso = oConn.runQuery(strSqlCurso, true);
     while (rsCurso.next()) {
     strFechaInicial = rsCurso.getString("CC_FECHA_INICIAL");
     strDuracion = rsCurso.getString("CC_DURACION_HRS");
     strPrecio = rsCurso.getString("CC_PRECIO_PRES");
     NOM_CURSO = rsCurso.getString("CC_NOMBRE_CURSO");
     strSede = rsCurso.getString("CC_SEDE");
     strDeta = rsCurso.getString("CC_DETALLE");
     strEncab = rsCurso.getString("CC_ENCABEZADO");
     strTema = rsCurso.getString("CC_TEMARIO");
     }
     } catch (SQLException e) {
     System.out.println(e);
     }
     String strdía = strFechaInicial.substring(6, 8);
     String strMes = strFechaInicial.substring(4, 6);
     String strAño = strFechaInicial.substring(0, 4);
     String strNomMes = "";
     int intMes = Integer.parseInt(strMes);
     if (intMes == 1) {
     strNomMes = "Enero";
     }
     if (intMes == 2) {
     strNomMes = "Febrero";
     }
     if (intMes == 3) {
     strNomMes = "Marzo";
     }
     if (intMes == 4) {
     strNomMes = "Abril";
     }
     if (intMes == 5) {
     strNomMes = "Mayo";
     }
     if (intMes == 6) {
     strNomMes = "Junio";
     }
     if (intMes == 7) {
     strNomMes = "Julio";
     }
     if (intMes == 8) {
     strNomMes = "Agosto";
     }
     if (intMes == 9) {
     strNomMes = "Septiembre";
     }
     if (intMes == 10) {
     strNomMes = "Octubre";
     }
     if (intMes == 11) {
     strNomMes = "Noviembre";
     }
     if (intMes == 12) {
     strNomMes = "Diciembre";
     }
     String strResp = "OK";
     //Nombre de archivo
     //Obtenemos datos del smtp
     String strsmtp_server = "";
     String strsmtp_user = "";
     String strsmtp_pass = "";
     String strsmtp_port = "";
     String strsmtp_usaTLS = "";
     String strsmtp_usaSTLS = "";
     //Buscamos los datos del SMTP
     String strSql = "select * from cuenta_contratada where ctam_id = 1";
     ResultSet rs;
     try {
     rs = oConn.runQuery(strSql, true);
     while (rs.next()) {
     strsmtp_server = rs.getString("smtp_server");
     strsmtp_user = rs.getString("smtp_user");
     strsmtp_pass = rs.getString("smtp_pass");
     strsmtp_port = rs.getString("smtp_port");
     strsmtp_usaTLS = rs.getString("smtp_usaTLS");
     strsmtp_usaSTLS = rs.getString("smtp_usaSTLS");
     }
     rs.close();
     } catch (SQLException ex) {
     System.out.println(ex.getMessage());
     }
     //Obtenemos los textos para el envio del mail
     String strNomTemplate = "DIPLOMADO";
     String[] lstMail = getMailTemplate(oConn, strNomTemplate);

        
     //  Si estan llenos todos los datos mandamos el mail
         
     if (!strsmtp_server.equals("")
     && !strsmtp_user.equals("")
     && !strsmtp_pass.equals("")) {
     //armamos el mail
     Mail mail = new Mail();
     mail.setBolDepuracion(false);
     //Activamos envio de acuse de recibo
     mail.setBolAcuseRecibo(true);
     //Obtenemos los usuarios a los que mandaremos el mail
     String strLstMail = "";
     //Validamos si el mail del cliente es valido
     if (mail.isEmail(strMailCte)) {
     strLstMail += "," + strMailCte;
     }
     //Mandamos mail si hay usuarios
     if (!strLstMail.equals("")) {
     String strMsgMail = lstMail[1];
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_D}", strdía);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_M}", strNomMes);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_A}", strAño);
     strMsgMail = strMsgMail.replace("{CC_DURACION_HRS}", strDuracion);
     strMsgMail = strMsgMail.replace("{CC_NOMBRE_CURSO}", NOM_CURSO);
     strMsgMail = strMsgMail.replace("{CC_PRECIO_PRES}", strPrecio);
     strMsgMail = strMsgMail.replace("{CC_AGENTE}", strUser);
     strMsgMail = strMsgMail.replace("{CC_SEDE}", strSede);
     strMsgMail = strMsgMail.replace("{CC_DETALLE}", strDeta);
     strMsgMail = strMsgMail.replace("{CC_ENCABEZADO}", strEncab);
     strMsgMail = strMsgMail.replace("{CC_TEMARIO}", strTema);
     //Establecemos parametros
     mail.setUsuario(strsmtp_user);
     mail.setContrasenia(strsmtp_pass);
     mail.setHost(strsmtp_server);
     mail.setPuerto(strsmtp_port);
     mail.setAsunto(lstMail[0].replace("{CC_NOMBRE_CURSO}", NOM_CURSO));
     mail.setDestino(strLstMail);
     mail.setMensaje(strMsgMail);
     //Adjuntamos XML y PDF
     if (strsmtp_usaTLS.equals("1")) {
     mail.setBolUsaTls(true);
     }
     if (strsmtp_usaSTLS.equals("1")) {
     mail.setBolUsaStartTls(true);
     }
     boolean bol = mail.sendMail();
     if (!bol) {
     strResp = "Fallo el envio del Mail.";
     }
     }
     }
     return strResp;
     }

     //Seminario
     protected String GeneraMailSeminario(Conexion oConn, String strMailCte, String strUser) {
     String strFecha = fec.addFecha(fec.getFechaActual(), 5, 10); //fecha, 10 dias antes
     String strSqlCurso = "select * from cofide_cursos where cc_fecha_inicial >= '" + strFecha + "' and cc_is_seminario = 1 order by cc_fecha_inicial";
     String strFechaInicial = "";
     String strDuracion = "";
     String strPrecio = "";
     String NOM_CURSO = "";
     String strSede = "";
     String strDeta = "";
     String strEncab = "";
     String strTema = "";
     try {
     ResultSet rsCurso = oConn.runQuery(strSqlCurso, true);
     while (rsCurso.next()) {
     strFechaInicial = rsCurso.getString("CC_FECHA_INICIAL");
     strDuracion = rsCurso.getString("CC_DURACION_HRS");
     strPrecio = rsCurso.getString("CC_PRECIO_PRES");
     NOM_CURSO = rsCurso.getString("CC_NOMBRE_CURSO");
     strSede = rsCurso.getString("CC_SEDE");
     strDeta = rsCurso.getString("CC_DETALLE");
     strEncab = rsCurso.getString("CC_ENCABEZADO");
     strTema = rsCurso.getString("CC_TEMARIO");
     }
     } catch (SQLException e) {
     System.out.println(e);
     }
     String strdía = strFechaInicial.substring(6, 8);
     String strMes = strFechaInicial.substring(4, 6);
     String strAño = strFechaInicial.substring(0, 4);
     String strNomMes = "";
     int intMes = Integer.parseInt(strMes);
     if (intMes == 1) {
     strNomMes = "Enero";
     }
     if (intMes == 2) {
     strNomMes = "Febrero";
     }
     if (intMes == 3) {
     strNomMes = "Marzo";
     }
     if (intMes == 4) {
     strNomMes = "Abril";
     }
     if (intMes == 5) {
     strNomMes = "Mayo";
     }
     if (intMes == 6) {
     strNomMes = "Junio";
     }
     if (intMes == 7) {
     strNomMes = "Julio";
     }
     if (intMes == 8) {
     strNomMes = "Agosto";
     }
     if (intMes == 9) {
     strNomMes = "Septiembre";
     }
     if (intMes == 10) {
     strNomMes = "Octubre";
     }
     if (intMes == 11) {
     strNomMes = "Noviembre";
     }
     if (intMes == 12) {
     strNomMes = "Diciembre";
     }
     String strResp = "OK";
     //Nombre de archivo
     //Obtenemos datos del smtp
     String strsmtp_server = "";
     String strsmtp_user = "";
     String strsmtp_pass = "";
     String strsmtp_port = "";
     String strsmtp_usaTLS = "";
     String strsmtp_usaSTLS = "";
     //Buscamos los datos del SMTP
     String strSql = "select * from cuenta_contratada where ctam_id = 1";
     ResultSet rs;
     try {
     rs = oConn.runQuery(strSql, true);
     while (rs.next()) {
     strsmtp_server = rs.getString("smtp_server");
     strsmtp_user = rs.getString("smtp_user");
     strsmtp_pass = rs.getString("smtp_pass");
     strsmtp_port = rs.getString("smtp_port");
     strsmtp_usaTLS = rs.getString("smtp_usaTLS");
     strsmtp_usaSTLS = rs.getString("smtp_usaSTLS");
     }
     rs.close();
     } catch (SQLException ex) {
     System.out.println(ex.getMessage());
     }
     //Obtenemos los textos para el envio del mail
     String strNomTemplate = "SEMINARIO";
     String[] lstMail = getMailTemplate(oConn, strNomTemplate);

        
     //  Si estan llenos todos los datos mandamos el mail
         
     if (!strsmtp_server.equals("")
     && !strsmtp_user.equals("")
     && !strsmtp_pass.equals("")) {
     //armamos el mail
     Mail mail = new Mail();
     mail.setBolDepuracion(false);
     //Activamos envio de acuse de recibo
     mail.setBolAcuseRecibo(true);
     //Obtenemos los usuarios a los que mandaremos el mail
     String strLstMail = "";
     //Validamos si el mail del cliente es valido
     if (mail.isEmail(strMailCte)) {
     strLstMail += "," + strMailCte;
     }
     //Mandamos mail si hay usuarios
     if (!strLstMail.equals("")) {
     String strMsgMail = lstMail[1];
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_D}", strdía);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_M}", strNomMes);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_A}", strAño);
     strMsgMail = strMsgMail.replace("{CC_DURACION_HRS}", strDuracion);
     strMsgMail = strMsgMail.replace("{CC_NOMBRE_CURSO}", NOM_CURSO);
     strMsgMail = strMsgMail.replace("{CC_PRECIO_PRES}", strPrecio);
     strMsgMail = strMsgMail.replace("{CC_AGENTE}", strUser);
     strMsgMail = strMsgMail.replace("{CC_SEDE}", strSede);
     strMsgMail = strMsgMail.replace("{CC_DETALLE}", strDeta);
     strMsgMail = strMsgMail.replace("{CC_ENCABEZADO}", strEncab);
     strMsgMail = strMsgMail.replace("{CC_TEMARIO}", strTema);
     //Establecemos parametros
     mail.setUsuario(strsmtp_user);
     mail.setContrasenia(strsmtp_pass);
     mail.setHost(strsmtp_server);
     mail.setPuerto(strsmtp_port);
     mail.setAsunto(lstMail[0].replace("{CC_NOMBRE_CURSO}", NOM_CURSO));
     mail.setDestino(strLstMail);
     mail.setMensaje(strMsgMail);
     //Adjuntamos XML y PDF
     if (strsmtp_usaTLS.equals("1")) {
     mail.setBolUsaTls(true);
     }
     if (strsmtp_usaSTLS.equals("1")) {
     mail.setBolUsaStartTls(true);
     }
     boolean bol = mail.sendMail();
     if (!bol) {
     strResp = "Fallo el envio del Mail.";
     }
     }
     }
     return strResp;
     }
     //Seminario

     protected String GeneraMail3_Curso(Conexion oConn, String strMailCte, String idCurso, String strUser) {
     String strSqlCurso = "Select * from cofide_cursos where cc_curso_id = " + idCurso;
     String strFechaInicial = "";
     String strDuracion = "";
     String strPrecio = "";
     String NOM_CURSO = "";
     String strSede = "";
     String strDeta = "";
     String strEncab = "";
     String strTema = "";
     try {
     ResultSet rsCurso = oConn.runQuery(strSqlCurso, true);
     while (rsCurso.next()) {
     strFechaInicial = rsCurso.getString("CC_FECHA_INICIAL");
     strDuracion = rsCurso.getString("CC_DURACION_HRS");
     strPrecio = rsCurso.getString("CC_PRECIO_PRES");
     NOM_CURSO = rsCurso.getString("CC_NOMBRE_CURSO");
     strSede = rsCurso.getString("CC_SEDE");
     strDeta = rsCurso.getString("CC_DETALLE");
     strEncab = rsCurso.getString("CC_ENCABEZADO");
     strTema = rsCurso.getString("CC_TEMARIO");
     }
     } catch (SQLException e) {
     System.out.println(e);
     }
     String strdía = strFechaInicial.substring(6, 8);
     String strMes = strFechaInicial.substring(4, 6);
     String strAño = strFechaInicial.substring(0, 4);
     String strNomMes = "";
     int intMes = Integer.parseInt(strMes);
     if (intMes == 1) {
     strNomMes = "Enero";
     }
     if (intMes == 2) {
     strNomMes = "Febrero";
     }
     if (intMes == 3) {
     strNomMes = "Marzo";
     }
     if (intMes == 4) {
     strNomMes = "Abril";
     }
     if (intMes == 5) {
     strNomMes = "Mayo";
     }
     if (intMes == 6) {
     strNomMes = "Junio";
     }
     if (intMes == 7) {
     strNomMes = "Julio";
     }
     if (intMes == 8) {
     strNomMes = "Agosto";
     }
     if (intMes == 9) {
     strNomMes = "Septiembre";
     }
     if (intMes == 10) {
     strNomMes = "Octubre";
     }
     if (intMes == 11) {
     strNomMes = "Noviembre";
     }
     if (intMes == 12) {
     strNomMes = "Diciembre";
     }
     String strResp = "OK";
     //Nombre de archivo
     //Obtenemos datos del smtp
     String strsmtp_server = "";
     String strsmtp_user = "";
     String strsmtp_pass = "";
     String strsmtp_port = "";
     String strsmtp_usaTLS = "";
     String strsmtp_usaSTLS = "";
     //Buscamos los datos del SMTP
     String strSql = "select * from cuenta_contratada where ctam_id = 1";
     ResultSet rs;
     try {
     rs = oConn.runQuery(strSql, true);
     while (rs.next()) {
     strsmtp_server = rs.getString("smtp_server");
     strsmtp_user = rs.getString("smtp_user");
     strsmtp_pass = rs.getString("smtp_pass");
     strsmtp_port = rs.getString("smtp_port");
     strsmtp_usaTLS = rs.getString("smtp_usaTLS");
     strsmtp_usaSTLS = rs.getString("smtp_usaSTLS");
     }
     rs.close();
     } catch (SQLException ex) {
     System.out.println(ex.getMessage());
     }
     //Obtenemos los textos para el envio del mail
     String strNomTemplate = "SEMINARIO";
     String[] lstMail = getMailTemplate(oConn, strNomTemplate);

        
     //  Si estan llenos todos los datos mandamos el mail
         
     if (!strsmtp_server.equals("")
     && !strsmtp_user.equals("")
     && !strsmtp_pass.equals("")) {
     //armamos el mail
     Mail mail = new Mail();
     mail.setBolDepuracion(false);
     //Activamos envio de acuse de recibo
     mail.setBolAcuseRecibo(true);
     //Obtenemos los usuarios a los que mandaremos el mail
     String strLstMail = "";
     //Validamos si el mail del cliente es valido
     if (mail.isEmail(strMailCte)) {
     strLstMail += "," + strMailCte;
     }
     //Mandamos mail si hay usuarios
     if (!strLstMail.equals("")) {
     String strMsgMail = lstMail[1];
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_D}", strdía);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_M}", strNomMes);
     strMsgMail = strMsgMail.replace("{CC_FECHA_INICIAL_A}", strAño);
     strMsgMail = strMsgMail.replace("{CC_DURACION_HRS}", strDuracion);
     strMsgMail = strMsgMail.replace("{CC_NOMBRE_CURSO}", NOM_CURSO);
     strMsgMail = strMsgMail.replace("{CC_PRECIO_PRES}", strPrecio);
     strMsgMail = strMsgMail.replace("{CC_AGENTE}", strUser);
     strMsgMail = strMsgMail.replace("{CC_SEDE}", strSede);
     strMsgMail = strMsgMail.replace("{CC_DETALLE}", strDeta);
     strMsgMail = strMsgMail.replace("{CC_ENCABEZADO}", strEncab);
     strMsgMail = strMsgMail.replace("{CC_TEMARIO}", strTema);
     //Establecemos parametros
     mail.setUsuario(strsmtp_user);
     mail.setContrasenia(strsmtp_pass);
     mail.setHost(strsmtp_server);
     mail.setPuerto(strsmtp_port);
     mail.setAsunto(lstMail[0].replace("{CC_NOMBRE_CURSO}", NOM_CURSO));
     mail.setDestino(strLstMail);
     mail.setMensaje(strMsgMail);
     //Adjuntamos XML y PDF
     if (strsmtp_usaTLS.equals("1")) {
     mail.setBolUsaTls(true);
     }
     if (strsmtp_usaSTLS.equals("1")) {
     mail.setBolUsaStartTls(true);
     }
     boolean bol = mail.sendMail();
     if (!bol) {
     strResp = "Fallo el envio del Mail.";
     }
     }
     }
     return strResp;
     }

     public String[] getMailTemplate(Conexion oConn, String strNom) { //obtenemos la informacion que se encuentre en el template
     String[] listValores = new String[2];
     String strSql = "select MT_ASUNTO,MT_CONTENIDO from mailtemplates where MT_ABRV ='" + strNom + "'";
     ResultSet rs;
     try {
     rs = oConn.runQuery(strSql, true);
     while (rs.next()) {
     listValores[0] = rs.getString("MT_ASUNTO");
     listValores[1] = rs.getString("MT_CONTENIDO");
     }
     rs.close();
     } catch (SQLException ex) {
     System.out.println(ex.getMessage());
     }
     return listValores;
     }
     */
%>
