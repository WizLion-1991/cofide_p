<%-- 
    Document   : COFIDE_ver_tmk_cam
    Created on : 13/04/2016, 11:59:36 AM
    Author     : JulioCesar
--%>
<%@page import="comSIWeb.Utilerias.UtilXml"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
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
    UtilXml util = new UtilXml();
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
        String strid = request.getParameter("ID");
        if (strid != null) {
            if (strid.equals("1")) { //consulta de la IP
                String strIp = request.getParameter("direccion_ip");
%>
<html>
    <title>Monitoreo VNC</title>
    <body>
    <center>
        <applet archive="vnc/tightvnc-jviewer.jar"
                code="com.glavsoft.viewer.Viewer"
                width="100" height="50">
            <param name="Host" value="<%=strIp%>" /> 
            <param name="Port" value="5900" /> 
            <param name="OpenNewWindow" value="yes" /> 
            <param name="ShowControls" value="yes" /> 
            <param name="ViewOnly" value="yes" /> 
            <param name="AllowClipboardTransfer" value="yes" /> 
            <param name="RemoteCharset" value="standard" /> 
            <param name="ShareDesktop" value="yes" />
            <param name="AllowCopyRect" value="yes" />
            <param name="Encoding" value="Tight" />
            <param name="CompressionLevel" value="" />
            <param name="JpegImageQuality" value="" />
            <param name="LocalPointer" value="On" /> 
            <param name="ConvertToASCII" value="no" />
            <param name="colorDepth" value="" />
            <param name="ScalingFactor" value="100" /> 
            <param name="sshHost" value="" />
            <param name="sshUser" value="" />
            <param name="sshPort" value="" />

        </applet>
        <br />
    </center>
</body>
</html>
<%
            } //1
        } // strid es diferente a vacio
    } //session
    //aqui se cierra el jsp
    oConn.close();
%>