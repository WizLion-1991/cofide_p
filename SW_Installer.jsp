<%-- 
    Document   : SW_Installer
Instalador para nuevos aplicaciones en SIWEB
Este programa solo debera distribuirse en el programa SIWEB
    Created on : 13-oct-2015, 10:49:49
    Author     : ZeusGalindo
--%>
<%@page import="com.mx.siweb.erp.especiales.siweb.InstaladorSIWEB"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion

   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (1 == 1 /*varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)*/) {
//no usar vta_ALDI
      String[] ConexionURL = new String[4];
      ConexionURL[0] = "jdbc:mysql://localhost:3309/vta_lms";// nousar ALDI

      ConexionURL[1] = "admin";
      ConexionURL[2] = "Pc6Hp,3IQnwu$k";
      ConexionURL[3] = "mysql";

      try {
         Conexion oConn = new Conexion(ConexionURL, null);
         oConn.open();
         oConn.setBolMostrarQuerys(true);
         String strNombreSitio = "Dixon"; 
         String strNombreBd = "vta_dixon"; 
         out.println("Creando el sitio: " + strNombreSitio);
         //Instalador...
         InstaladorSIWEB install = new InstaladorSIWEB(oConn, varSesiones);
         install.setStrNombreSistema(strNombreSitio);
         install.setStrNombreBaseDatos(strNombreBd);
         install.setStrTipoSistema("MLM");
         install.setStrPathCarpetaXMLOrigen("D:/SIWEB/SAT/CER_SELLO_BASE/");
         install.setStrNombreCarpetaXML(strNombreSitio.toUpperCase());
         install.setStrPathRepositorioXML("D:/SIWEB/SAT/");
         install.setStrPathBase("D:/SIWEB/SrvApp/sitesTomcat/ERPTomcat7/");
         install.setStrPathOrigen("D:/SIWEB/SrvApp/sitesTomcat/ERPTomcat7/LMS-Consultores/");//*obligatorio
         install.setStrPathFileBaseContext("D:/SIWEB/SrvApp/apache-tomcat-7.0.61/conf/Catalina/ventas.siwebmx.com/");
         install.setStrPathFileContextOrigen("D:/SIWEB/SrvApp/apache-tomcat-7.0.61/conf/Catalina/ventas.siwebmx.com/LMS-Consultores.xml");;//*obligatorio
         install.setStrPuertoBd("3309");
         install.setBolValidaDuplicidad(true);
         install.setBolCopiaSitio(true);
         install.setBolGeneraTablas(true);
         install.doTrx();
         System.out.println("Resultado creacion: " + install.getStrResultLast());
         out.println("Resultado creacion: " + install.getStrResultLast());
         oConn.close();
      } catch (Exception ex) {
         System.out.println("Error al instalar...." + ex.getMessage());
      }
   }

%>