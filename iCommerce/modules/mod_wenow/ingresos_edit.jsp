<%-- 
    Document   : ingresos_edit
    Created on : 6/05/2013, 03:36:21 PM
    Author     : N4v1d4d3s
--%>

<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
    /*Inicializamos las variables de sesion limpias*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0) {

        Fechas fecha = new Fechas();
        //Recuperamos los nombres de los estados
        ArrayList<String> lstEstado = new ArrayList<String>();
        //Abrimos la conexion
        Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
        oConn.open();
        //Consultamos los estados
        String strSql = "select * from estadospais where PA_ID = 1";
        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            lstEstado.add(rs.getString("ESP_NOMBRE"));
        }
        rs.close();

        String strRazonsocial = "";
        String strNombre = "";
        String strApaterno = "";
        String strAmaterno = "";
        String stRFC = "";
        String strCalle = "";
        String strNumero = "";
        String strNumint = "";
        String strColonia = "";
        String strMunicipio = "";
        String strLocalidad = "";
        String strEstado = "";
        String strCP = "";
        String strTelefono1 = "";
        String strTelefono2 = "";
        String strContacto1 = "";
        String strEmail1 = "";
        String strCTABANCO1 = "";
        String strCTABANCO2 = "";
        String strCTA_BANCO1 = "";
        String strCTA_BANCO2 = "";
        String strCTA_SUCURSAL1 = "";
        String strCTA_SUCURSAL2 = "";
        String strCta_clabe1 = "";
        String strCta_clabe2 = "";
        String strCta_clabeInterbancaria = "";
        int intBanco1 = 0;
        String strFechaReg = "";
        String strFechaNac = "";
        String strNotas = "";

        int intUpline = 0;
        int intSponzor = 0;

        String strDir_Nombre = "";
        String strDir_Telefono = "";
        String strDir_Email = "";
        String strDir_Calle = "";
        String strDir_Numero = "";
        String strDir_NumInt = "";
        String strDir_Colonia = "";
        String strDir_Estado = "";
        String strDir_Municipio = "";
        String strDir_Cp = "";
        String strDir_Descripcion = "";

        int intDir_Id = 0;

        //Recuperamos los datos del distribuidor a editar
        String strSelectCliente = "select b.CDE_ID,b.CDE_NOMBRE,b.CDE_TELEFONO1,b.CDE_EMAIL,b.CDE_CALLE,b.CDE_NUMERO,b.CDE_NUMINT,b.CDE_COLONIA,b.CDE_ESTADO,b.CDE_MUNICIPIO,b.CDE_CP,b.CDE_DESCRIPCION, "
                + " a.CT_RAZONSOCIAL,a.CT_NOMBRE,a.CT_APATERNO,a.CT_AMATERNO,a.CT_RFC,a.CT_CALLE,a.CT_NUMERO,a.CT_NUMINT,a.CT_COLONIA,a.CT_MUNICIPIO,a.CT_LOCALIDAD "
                + " ,a.CT_ESTADO,a.CT_CP,a.CT_TELEFONO1,a.CT_TELEFONO2,a.CT_CONTACTO1,a.CT_EMAIL1,a.CT_CTABANCO1,a.CT_CTABANCO2,a.CT_CTA_BANCO1,a.CT_CTA_BANCO2 "
                + " ,a.CT_CTA_SUCURSAL1,a.CT_CTA_SUCURSAL2,a.CT_CTA_CLABE1,a.CT_CTA_CLABE2,a.CT_CLABE_INTERBANCARIA,a.CT_BANCO1,a.CT_FECHAREG,a.CT_FECHA_NAC,a.CT_NOTAS,a.CT_UPLINE,a.CT_SPONZOR "
                + " from vta_cliente a left join vta_cliente_dir_entrega b on a.CT_ID = b.CT_ID  where a.CT_ID = " + varSesiones.getIntNoUser();
        rs = oConn.runQuery(strSelectCliente, true);
        while (rs.next()) {

            intUpline = rs.getInt("CT_UPLINE");
            intSponzor = rs.getInt("CT_SPONZOR");

            strRazonsocial = rs.getString("CT_RAZONSOCIAL");
            strNombre = rs.getString("CT_NOMBRE");
            strApaterno = rs.getString("CT_APATERNO");
            strAmaterno = rs.getString("CT_AMATERNO");
            stRFC = rs.getString("CT_RFC");
            strCalle = rs.getString("CT_CALLE");
            strNumero = rs.getString("CT_NUMERO");
            strNumint = rs.getString("CT_NUMINT");
            strColonia = rs.getString("CT_COLONIA");
            strMunicipio = rs.getString("CT_MUNICIPIO");
            strLocalidad = rs.getString("CT_LOCALIDAD");
            strEstado = rs.getString("CT_ESTADO");
            strCP = rs.getString("CT_CP");
            strTelefono1 = rs.getString("CT_TELEFONO1");
            strTelefono2 = rs.getString("CT_TELEFONO2");
            strContacto1 = rs.getString("CT_CONTACTO1");
            strEmail1 = rs.getString("CT_EMAIL1");
            strCTABANCO1 = rs.getString("CT_CTABANCO1");
            strCTABANCO2 = rs.getString("CT_CTABANCO2");
            strCTA_BANCO1 = rs.getString("CT_CTA_BANCO1");
            strCTA_BANCO2 = rs.getString("CT_CTA_BANCO2");
            strCTA_SUCURSAL1 = rs.getString("CT_CTA_SUCURSAL1");
            strCTA_SUCURSAL2 = rs.getString("CT_CTA_SUCURSAL2");
            strCta_clabe1 = rs.getString("CT_CTA_CLABE1");
            strCta_clabe2 = rs.getString("CT_CTA_CLABE2");
            strCta_clabeInterbancaria = rs.getString("CT_CLABE_INTERBANCARIA");
            intBanco1 = rs.getInt("CT_BANCO1");
            strFechaReg = rs.getString("CT_FECHAREG");

            if (rs.getString("CT_FECHA_NAC").equals(null) || rs.getString("CT_FECHA_NAC").equals("")) {
                strDir_Nombre = "";
            } else {
                strFechaNac = fecha.Formatea(rs.getString("CT_FECHA_NAC"), "/");
            }

            strNotas = rs.getString("CT_NOTAS");

            strDir_Nombre = rs.getString("CDE_NOMBRE");
            strDir_Telefono = rs.getString("CDE_TELEFONO1");
            strDir_Email = rs.getString("CDE_EMAIL");
            strDir_Calle = rs.getString("CDE_CALLE");
            strDir_Numero = rs.getString("CDE_NUMERO");
            strDir_NumInt = rs.getString("CDE_NUMINT");
            strDir_Colonia = rs.getString("CDE_COLONIA");
            strDir_Estado = rs.getString("CDE_ESTADO");
            strDir_Municipio = rs.getString("CDE_MUNICIPIO");
            strDir_Cp = rs.getString("CDE_CP");
            strDir_Descripcion = rs.getString("CDE_DESCRIPCION");
            intDir_Id = rs.getInt("CDE_ID");
            if (strDir_Nombre == null) {
                strDir_Nombre = "";
            }
            if (strDir_Telefono == null) {
                strDir_Telefono = "";
            }
            if (strDir_Email == null) {
                strDir_Email = "";
            }
            if (strDir_Calle == null) {
                strDir_Calle = "";
            }
            if (strDir_Numero == null) {
                strDir_Numero = "";
            }
            if (strDir_NumInt == null) {
                strDir_NumInt = "";
            }
            if (strDir_Colonia == null) {
                strDir_Colonia = "";
            }
            if (strDir_Estado == null) {
                strDir_Estado = "";
            }
            if (strDir_Municipio == null) {
                strDir_Municipio = "";
            }
            if (strDir_Cp == null) {
                strDir_Cp = "";
            }
            if (strDir_Descripcion == null) {
                strDir_Descripcion = "";
            }

        }
        rs.close();

        String strListaBco = "";
        strListaBco += "<option id='0'>Seleccione...</option>";
        String strQueryBco = "select * from rhh_bancos ";
        ResultSet rs1 = oConn.runQuery(strQueryBco);
        while (rs1.next()) {
            if (intBanco1 == rs1.getInt("RBK_ID")) {
                strListaBco += " <option value='" + rs1.getInt("RBK_ID") + "' selected >"
                        + rs1.getString("RBK_NOMBRE_CORTO") + "</option>";
            } else {
                strListaBco += " <option value='" + rs1.getInt("RBK_ID") + "'>"
                        + rs1.getString("RBK_NOMBRE_CORTO") + "</option>";
            }
        }
        rs1.close();

        oConn.close();
%>
<div class="well ">
    <h3 class="page-header">Modificar Datos de <%=strRazonsocial%></h3>
    <form action="index.jsp?mod=FZWebEditIngresosSave" method="post" onsubmit="return  EvaluaFormulario();" id="login-form" class="form-inline"  >
        <div class="userdata">
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <span class="required">* Los campos marcados en rojo son obligatorios</span>
                </div>
            </div>




            <!--Nombre-->
            <div id="form-new-nombre" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Nombre"/>
                            <label for="modlgn-nombre" >Nombre:</label>
                        </span>
                        <input id="modlgn-nombre" type="text" name="nombre" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Nombre" value="<%=strNombre%>"/> <span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Apellido Paterno-->
            <div id="form-new-apaterno" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Apellido Paterno"/>
                            <label for="modlgn-apaterno" >Apellido Paterno:</label>
                        </span>
                        <input id="modlgn-apaterno" type="text" name="apaterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Apellido Paterno" value="<%=strApaterno%>"/><span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Apellido Materno-->
            <div id="form-new-amaterno" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Apellido Materno"/>
                            <label for="modlgn-amaterno" >Apellido Materno:</label>
                        </span>
                        <input id="modlgn-amaterno" type="text" name="amaterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Apellido Materno" value="<%=strAmaterno%>"/><span class="required">*</span>
                    </div>
                </div>
            </div>

            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="Fecha Ingreso"/>
                        <label for="modlgn-fingreso" >Fecha ingreso:</label>
                    </span>
                    <input id="modlgn-fingreso" type="text" name="fecha_ingreso" class="input-medium-ingresos" tabindex="0" size="12" maxlength="12" placeholder="Fecha Ingreso" readOnly="true" value="<%=strFechaReg%>"/> 
                </div>
            </div>
        

        <!--Fecha de nacimiento-->
        <div id="form-new-nacimiento" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="Fecha de nacimiento"/>
                        <label for="modlgn-nacimiento" >Fecha de nacimiento:</label>
                    </span>
                    <input id="modlgn-nacimiento" type="text" name="nacimiento" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Fecha de nacimiento" value="<%=strFechaNac%>"/><span class="required">*</span>
                </div>
            </div>
        </div>

        <!--Calle-->
        <div id="form-new-calle" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="Calle"/>
                        <label for="modlgn-calle" >Calle:</label>
                    </span>
                    <input id="modlgn-calle" type="text" name="calle" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Calle" value="<%=strCalle%>"/><span class="required">*</span>
                </div>
            </div>
        </div>
        <!--Numero-->
        <div id="form-new-numero" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="numero"/>
                        <label for="modlgn-numero" >Numero:</label>
                    </span>
                    <input id="modlgn-numero" type="text" name="numero" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Numero" value="<%=strNumero%>"/><span class="required">*</span>
                </div>
            </div>
        </div>
        <!--Boton-->
        <!--Numero interno-->
        <div id="form-new-numeroInterno" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="numeroInterno"/>
                        <label for="modlgn-numeroInterno" >Numero Interno:</label>
                    </span>
                    <input id="modlgn-numeroInterno" type="text" name="numeroInterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Numero Interno" value="<%=strNumint%>"/>
                </div>
            </div>
        </div>
        <!--Colonia-->
        <div id="form-new-colonia" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="colonia"/>
                        <label for="modlgn-colonia" >Colonia:</label>
                    </span>
                    <input id="modlgn-colonia" type="text" name="colonia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Colonia" value="<%=strColonia%>"/><span class="required">*</span>
                </div>
            </div>
        </div>

        <!--Municipio-->
        <div id="form-new-municipio" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="municipio"/>
                        <label for="modlgn-municipio" >Municipio</label>
                    </span>
                    <input id="modlgn-municipio" type="text" name="municipio" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Municipio" value="<%=strMunicipio%>"/><span class="required">*</span>
                </div>
            </div>
        </div>
        <!--Localidad-->
        <div id="form-new-localidad" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="localidad"/>
                        <label for="modlgn-localidad" >Localidad</label>
                    </span>
                    <input id="modlgn-localidad" type="text" name="localidad" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Localidad" value="<%=strLocalidad%>"/>
                </div>
            </div>
        </div>
        <!--Estado-->
        <div id="form-new-estado" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="estado"/>
                        <label for="modlgn-estado" >Estado:</label>
                    </span>
                    <select id="modlgn-estado" name="estado" class="combo1"  placeholder="Estado" >
                        <option id="">Seleccione</option>
                        <%
                            //Mostramos los estados.
                            Iterator<String> it1 = lstEstado.iterator();
                            while (it1.hasNext()) {
                                String strEstado1 = it1.next();
                                if (strEstado1.equals(strEstado)) {
                        %><option id="<%=strEstado1%>" selected=""><%=strEstado1%> </option><%
                        } else {
                        %><option id="<%=strEstado1%>"><%=strEstado1%></option><%
                                }
                            }

                        %>
                    </select>
                    <span class="required">*</span>
                </div>
            </div>
        </div>
        <!--Codigo Postal-->
        <div id="form-new-cp" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="cp"/>
                        <label for="modlgn-cp" >C&oacute;digo Postal:</label>
                    </span>
                    <input id="modlgn-cp" type="text" name="cp" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="C&oacute;digo Postal" value="<%=strCP%>"/><span class="required">*</span>
                </div>
            </div>
        </div>
        <!--Telefono 1-->
        <div id="form-new-telefono1" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="telefono1"/>
                        <label for="modlgn-telefono1" >Telefono casa(10 digitos):</label>
                    </span>
                    <input id="modlgn-telefono1" type="text" name="telefono1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono casa" value="<%=strTelefono1%>"/><span class="required">*</span>
                </div>
            </div>
        </div>
        <!--Telefono 2-->
        <div id="form-new-telefono2" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="telefono2"/>
                        <label for="modlgn-telefono2" >Telefono celular(10 digitos):</label>
                    </span>
                    <input id="modlgn-telefono2" type="text" name="telefono2" class="input-medium-ingresos" tabindex="0" size="30" maxlength="45" placeholder="Telefono celular" value="<%=strTelefono2%>"/><span class="required">*</span>
                </div>
            </div>
        </div>
        <!--Email 1-->
        <div id="form-new-email1" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="email1"/>
                        <label for="modlgn-email1" >Cuenta de correo electr&oacute;nico:</label>
                    </span>
                    <input id="modlgn-email1" type="text" name="email1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="60" placeholder="Cuenta de correo electr&oacute;nico" value="<%=strEmail1%>"/>
                </div>
            </div>
        </div>
        <!--Beneficiario 1-->
        <div id="form-new-contacto1" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="contacto1"/>
                        <label for="modlgn-contacto1" >Beneficiario:</label>
                    </span>
                    <input id="modlgn-contacto1" type="text" name="contacto1" class="input-medium-ingresos" tabindex="0" size="30" maxlength="30" placeholder="Beneficiario" value="<%=strContacto1%>"/>
                </div>
            </div>
        </div>
        <!--Numero de cuenta de banco 1-->
        <div id="form-new-cuenta_bancaria1" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="cuenta_bancaria1"/>
                        <label for="modlgn-cuenta_bancaria1" >Cuenta Bancaria 1:</label>
                    </span>
                    <input id="modlgn-cuenta_bancaria1" type="text" name="cuenta_bancaria1" class="input-medium" tabindex="0" size="30" maxlength="60" placeholder="Cuenta Bancaria 1" value="<%=strCTABANCO1%>"/>
                </div>
            </div>
        </div>
        <!--Numero de cuenta de banco 2-->
        <div id="form-new-cuenta_bancaria2" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="cuenta_bancaria2"/>
                        <label for="modlgn-cuenta_bancaria2" >Cuenta Bancaria 2:</label>
                    </span>
                    <input id="modlgn-cuenta_bancaria2" type="text" name="cuenta_bancaria2" class="input-medium" tabindex="0" size="10" maxlength="10" placeholder="Cuenta Bancaria 2" value="<%=strCTABANCO2%>"/>                  
                </div>
            </div>
        </div>                         



        <!--Bancos-->

        <div id="form-new-banco" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="banco"/>
                        <label for="modlgn-banco" >Banco:</label>
                    </span>
                    <select id="modlgn-banco" name="banco"  placeholder="banco" >
                        <%=strListaBco%>

                    </select>                
                </div>
            </div>
        </div>


        <!--Clabe Interbancaria-->
        <div id="form-new-clabe_interbancaria" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="clabe_interbancaria"/>
                        <label for="modlgn-clabe_interbancaria" >Clabe Interbancaria:</label>
                    </span>
                    <input id="modlgn-clabe_interbancaria" type="text" name="clabe_interbancaria" class="input-medium" tabindex="0" size="18" maxlength="18" placeholder="Clabe Interbancaria" value="<%=strCta_clabeInterbancaria%>" />                  
                </div>
            </div>
        </div>

        <!--CURP-->
        <!--         <div id="form-new-curp" class="control-group">
                    <div class="controls">
                       <div class="input-prepend input-append">
                          <span class="add-on">
                             <span title="curp"/>
                             <label for="modlgn-curp" >CURP:</label>
                          </span>
                          <input id="modlgn-curp" type="text" name="curp" class="input-medium" tabindex="0" size="10" maxlength="10" placeholder="CURP"/>         
                       </div>
                    </div>
                 </div>
        -->


        <div id="tabs-2" >
            <h4>Direccion de entrega</h4>

            <!--Nombre-->
            <div id="form-new-nombre" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Nombre"/>
                            <label for="modlgn-nombre" >Nombre:</label>
                        </span>
                        <input id="dir_ent_nombre" type="text" name="dir_ent_nombre" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Nombre" value="<%=strDir_Nombre%>"/> <span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Telefono-->
            <div id="form-new-nombre" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Nombre"/>
                            <label for="modlgn-nombre" >Tel&eacute;fono:</label>
                        </span>
                        <input id="dir_ent_telefono" type="text" name="dir_ent_telefono" class="input-medium-ingresos" tabindex="0" size="30" maxlength="15" placeholder="Telefono" value="<%=strDir_Telefono%>"/> <span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Email-->
            <div id="form-new-nombre" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Nombre"/>
                            <label for="modlgn-nombre" >Email:</label>
                        </span>
                        <input id="dir_ent_email" type="text" name="dir_ent_email" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder="Email" value="<%=strDir_Email%>"/>
                    </div>
                </div>
            </div>
            <!--Calle-->
            <div id="form-new-nombre" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="Nombre"/>
                            <label for="modlgn-nombre" >Calle:</label>
                        </span>
                        <input id="dir_ent_calle" type="text" name="dir_ent_calle" class="input-medium-ingresos" tabindex="0" size="30" maxlength="50" placeholder="Calle" value="<%=strDir_Calle%>"/> <span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Numero-->
            <div id="form-new-numero" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="numero"/>
                            <label for="modlgn-numero" >N&uacute;mero:</label>
                        </span>
                        <input id="dir_ent_numero" type="text" name="dir_ent_numero" class="input-medium-ingresos" tabindex="0" size="30" maxlength="10" placeholder="Numero" value="<%=strDir_Numero%>"/><span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Boton-->
            <!--Numero interno-->
            <div id="form-new-numeroInterno" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="numeroInterno"/>
                            <label for="modlgn-numeroInterno" >N&uacute;mero Interno:</label>
                        </span>
                        <input id="dir_ent_numeroInterno" type="text" name="dir_ent_numeroInterno" class="input-medium-ingresos" tabindex="0" size="30" maxlength="25" placeholder="Numero Interno" value="<%=strDir_NumInt%>"/>
                    </div>
                </div>
            </div>
            <!--Colonia-->
            <div id="form-new-colonia" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="colonia"/>
                            <label for="modlgn-colonia" >Colonia:</label>
                        </span>
                        <input id="dir_ent_colonia" type="text" name="dir_ent_colonia" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Colonia" value="<%=strDir_Colonia%>"/><span class="required">*</span>
                    </div>
                </div>
            </div>
            <!--Estado-->
            <div id="form-new-estado" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="estado"/>
                            <label for="modlgn-estado" >Estado:</label>
                        </span>
                        <select id="dir_ent_estado" name="dir_ent_estado" class="combo1"  placeholder="Estado" value="<%=strDir_Estado%>">
                            <option id="">Seleccione</option>
                            <%
                                //Mostramos los estados.
                                Iterator<String> it = lstEstado.iterator();
                                while (it.hasNext()) {
                                    String strEstado1 = it.next();
                                    if (strEstado1.equals(strDir_Estado)) {
                            %><option id="<%=strEstado1%>" selected=""><%=strEstado1%> </option><%
                            } else {
                            %><option id="<%=strEstado1%>"><%=strEstado1%></option><%
                                    }
                                }

                            %>
                        </select>
                        <span class="required">*</span>
                    </div>
                </div>
            </div>



        </div>
        <!--Municipio-->
        <div id="form-new-cp" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="cp"/>
                        <label for="modlgn-cp" >Municipio:</label>
                    </span>
                    <input id="dir_ent_mun" type="text" name="dir_ent_mun" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="Municipio" value="<%=strDir_Municipio%>"/><span class="required">*</span>
                </div>
            </div>
        </div>

        <!--CP-->
        <div id="form-new-cp" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <span class="add-on">
                        <span title="cp"/>
                        <label for="modlgn-cp" >C&oacute;digo Postal:</label>
                    </span>
                    <input id="dir_ent_cp" type="text" name="dir_ent_cp" class="input-medium-ingresos" tabindex="0" size="30" maxlength="80" placeholder="C&oacute;digo Postal" value="<%=strDir_Cp%>"/><span class="required">*</span>
                </div>
            </div>
        </div>

        <!--Referencia-->
        <div id="form-new-mensaje" class="control-group">
            <div class="controls">
                <div class="input-prepend input-append">
                    <label for="modlgn-cp" >Referencia:</label>
                </div>
                <TEXTAREA COLS=100 ROWS=10 id="Texto" style="width: 334px; height: 162px;" onBlur="pasaValor()" >
                    <%=strDir_Descripcion%>
                    </TEXTAREA> 
                    <input type="hidden" id="texto" name="texto" value="<%=strDir_Descripcion%>"/>
                </div>
            </div>  
                <!--hiddden para id-->
            <div >
                
                    <input type="hidden" id="id" name="id" value="<%=intDir_Id%>"/>
            </div>   

            <div id="form-new-answer" class="control-group">
                <div class="controls">
                    <div class="input-prepend input-append">
                        <span class="add-on">
                            <span title="answer"/>
                            <label for="modlgn-cuenta_answer" >&nbsp;</label>
                        </span>
                        <img alt="Captcha"  src="../stickyImg" /><input id="modlgn-answer" type="text" name="answer" class="input-medium-ingresos" tabindex="0" size="10" maxlength="10" placeholder="Escriba el texto de la imagen"/><span class="required">*</span>
                    </div>
                </div>
            </div>         




            <br>
            <br>
            <!--Boton-->
            <div id="form-new-submit" class="control-group">
                <div class="controls">
                    <button type="submit" tabindex="0" name="Submit" class="btn btn-primary btn" >Guardar</button>
                </div>
            </div>
                            
                            
        </div>
    </form>
</div>
<script type="text/javascript">
    $("#modlgn-nacimiento").datepicker({
        changeMonth: true,
        changeYear: true
    });




    /*Valida los campos de direccion de entrega*/
    function EvaluaFormulario() {


        if (document.getElementById("modlgn-nombre").value == "") {
            alert("Es necesario que capture el nombre");
            document.getElementById("modlgn-nombre").focus();
            return false;
        }
        if (document.getElementById("modlgn-apaterno").value == "") {
            alert("Es necesario que capture el apellido paterno");
            document.getElementById("modlgn-apaterno").focus();
            return false;
        }
        if (document.getElementById("modlgn-amaterno").value == "") {
            alert("Es necesario que capture el apellido materno");
            document.getElementById("modlgn-amaterno").focus();
            return false;
        }
        if (document.getElementById("modlgn-nacimiento").value == "") {
            alert("Es necesario que capture la fecha de nacimiento");
            document.getElementById("modlgn-nacimiento").focus();
            return false;
        }
        if (document.getElementById("modlgn-calle").value == "") {
            alert("Es necesario que capture la calle");
            document.getElementById("modlgn-calle").focus();
            return false;
        }
        if (document.getElementById("modlgn-numero").value == "") {
            alert("Es necesario que capture el numero");
            document.getElementById("modlgn-numero").focus();
            return false;
        }
        if (document.getElementById("modlgn-colonia").value == "") {
            alert("Es necesario que capture la colonia");
            document.getElementById("modlgn-colonia").focus();
            return false;
        }
        if (document.getElementById("modlgn-municipio").value == "") {
            alert("Es necesario que capture la municipio");
            document.getElementById("modlgn-municipio").focus();
            return false;
        }
        var combo = document.getElementById("modlgn-estado");
        var selected = combo.options[combo.selectedIndex].text;
        if (selected == "Seleccione") {
            alert("Es necesario que capture el estado");
            document.getElementById("modlgn-estado").focus();
            return false;
        }
        if (document.getElementById("modlgn-cp").value == "") {
            alert("Es necesario que capture el codigo postal");
            document.getElementById("modlgn-cp").focus();
            return false;
        }
        if (document.getElementById("modlgn-telefono1").value == "") {
            alert("Es necesario que capture el telefono de casa");
            document.getElementById("modlgn-telefono1").focus();
            return false;
        }
        if (document.getElementById("modlgn-telefono2").value == "") {
            alert("Es necesario que capture el telefono celular");
            document.getElementById("modlgn-telefono2").focus();
            return false;
        }

        //Codigo postal
        if (document.getElementById("modlgn-cp").value != "") {
            var bolExpReg = _EvalExpReg(document.getElementById("modlgn-cp").value, "^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$");
            if (!bolExpReg) {
                alert("El formato del codigo postal es incorrecto");
                document.getElementById("modlgn-cp").focus();
                return false;
            }
        }
        //Fecha de nacimiento
        if (document.getElementById("modlgn-nacimiento").value != "") {
            var bolExpReg = validateMXDate(document.getElementById("modlgn-nacimiento").value);
            if (!bolExpReg) {
                alert("El formato de la fecha de nacimiento es incorrecto");
                document.getElementById("modlgn-nacimiento").focus();
                return false;
            }
        }
        //Telefono
        if (document.getElementById("modlgn-telefono1").value != "") {
            var bolExpReg = _EvalExpReg(document.getElementById("modlgn-telefono1").value, "^[0-9]{10}$");
            if (!bolExpReg) {
                alert("El formato del numero de telefono es incorrecto");
                document.getElementById("modlgn-telefono1").focus();
                return false;
            }
        }
        //Telefono
        if (document.getElementById("modlgn-telefono2").value != "") {
            var bolExpReg = _EvalExpReg(document.getElementById("modlgn-telefono2").value, "^[0-9]{10}$");
            if (!bolExpReg) {
                alert("El formato del numero de telefono es incorrecto");
                document.getElementById("modlgn-telefono2").focus();
                return false;
            }
        }



        /*Datos de direcciones de entrega*/
        if (document.getElementById("dir_ent_nombre").value == "") {
            alert("Es necesario que capture el nombre");
            document.getElementById("dir_ent_nombre").focus();
            return false;
        }

        //Telefono
        if (document.getElementById("dir_ent_telefono").value != "") {
            var bolExpReg = _EvalExpReg(document.getElementById("dir_ent_telefono").value, "^[0-9]{10}$");
            if (!bolExpReg) {
                alert("El formato del numero de telefono es incorrecto");
                document.getElementById("dir_ent_telefono").focus();
                return false;
            }
        } else {
            alert("Captura un Numero de Telefono");
            document.getElementById("dir_ent_telefono").focus();
            return false;

        }

        if (document.getElementById("dir_ent_calle").value == "") {
            alert("Es necesario que capture una calle");
            document.getElementById("dir_ent_calle").focus();
            return false;
        }

        if (document.getElementById("dir_ent_numero").value == "") {
            alert("Es necesario que capture un numero o s/n.");
            document.getElementById("dir_ent_numero").focus();
            return false;
        }

        if (document.getElementById("dir_ent_colonia").value == "") {
            alert("Es necesario que capture una colonia.");
            document.getElementById("dir_ent_colonia").focus();
            return false;
        }
        var combo = document.getElementById("dir_ent_estado");
        var selected = combo.options[combo.selectedIndex].text;
        if (selected == "Seleccione") {
            alert("Es necesario que seleccione un estado.");
            document.getElementById("dir_ent_estado").focus();
            return false;
        }

        if (document.getElementById("dir_ent_mun").value == "") {
            alert("Es necesario que capture un municipio.");
            document.getElementById("dir_ent_mun").focus();
            return false;
        }
        if (document.getElementById("dir_ent_cp").value == "") {
            alert("Es necesario que capture un Codigo postal.");
            document.getElementById("dir_ent_cp").focus();
            return false;
        }

        if (document.getElementById("texto").value == "") {
            alert("Capture alguna referencia");
            document.getElementById("Texto").focus();
            return false;
        }

        //CAPTCHA
        if (document.getElementById("modlgn-answer").value == "") {
            alert("Es necesario que capture el CAPTCHA");
            document.getElementById("modlgn-answer").focus();
            return false;
        }



        return true;
    }

    //Valida un cadena conforme una expresion regular
    function _EvalExpReg(YourValue, YourExp)
    {
        var Template = new RegExp(YourExp)
        return (Template.test(YourValue)) ? 1 : 0 //Compara "YourAlphaNumeric" con el formato "Template" y si coincidevuelve verdadero si no devuelve falso
    }

    function validateMXDate(strValue) {
        /************************************************
         DESCRIPTION: Validates that a string contains only
         valid dates with 2 digit month, 2 digit day,
         4 digit year. Date separator can be ., -, or /.
         Uses combination of regular expressions and
         string parsing to validate date.
         Ex. mm/dd/yyyy or mm-dd-yyyy or mm.dd.yyyy
         
         PARAMETERS:
         strValue - String to be tested for validity
         
         RETURNS:
         True if valid, otherwise false.
         
         REMARKS:
         Avoids some of the limitations of the Date.parse()
         method such as the date separator character.
         *************************************************/
        var objRegExp = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/

        //check to see if in correct format
        if (!objRegExp.test(strValue))
            return false; //doesn't match pattern, bad date
        else {
            var strSeparator = strValue.substring(2, 3)
            var arrayDate = strValue.split(strSeparator);
            //create a lookup for months not equal to Feb.
            var arrayLookup = {'01': 31, '03': 31,
                '04': 30, '05': 31,
                '06': 30, '07': 31,
                '08': 31, '09': 30,
                '10': 31, '11': 30, '12': 31}
            var intDay = parseInt(arrayDate[0], 10);

            //check if month value and day value agree
            if (arrayLookup[arrayDate[1]] != null) {
                if (intDay <= arrayLookup[arrayDate[1]] && intDay != 0)
                    return true; //found in lookup table, good date
            }

            //check for February (bugfix 20050322)
            //bugfix  for parseInt kevin
            //bugfix  biss year  O.Jp Voutat
            var intMonth = parseInt(arrayDate[1], 10);
            if (intMonth == 2) {
                var intYear = parseInt(arrayDate[2]);
                if (intDay > 0 && intDay < 29) {
                    return true;
                }
                else if (intDay == 29) {
                    if ((intYear % 4 == 0) && (intYear % 100 != 0) ||
                            (intYear % 400 == 0)) {
                        // year div by 4 and ((not div by 100) or div by 400) ->ok
                        return true;
                    }
                }
            }
        }
        return false; //any other values, bad date
    }


    /*PASA LO QUE ESCRIBES EN TEXTAREA A UN HIDDEN PARA VALIDARLO*/
    function pasaValor() {

        document.getElementById("texto").value = document.getElementById("Texto").value.trim();
    }


</script>

<%         }
%>
