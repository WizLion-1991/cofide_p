<%-- 
    Document   : pedidos_mak
    Created on : Dec 12, 2015, 10:42:04 AM
    Author     : Vladimir
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    /*Obtenemos las variables de sesion*/
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();

    //Abrimos la coneaxion
    Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
    oConn.open();
    //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
    Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
    if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {

        String strNomSucursal = "";
        int intSucursal = varSesiones.getIntSucursalDefault();
        String strSql = "Select SM_ID,SM_NOMBRE From vta_sucursales_master Where SM_ID = " + varSesiones.getIntSucursalMaster();

        ResultSet rs = oConn.runQuery(strSql, true);
        while (rs.next()) {
            strNomSucursal = rs.getString("SM_NOMBRE");
        }
        rs.getStatement().close();
        rs.close();

        /*Obtenemos los valores de los select*/
        StringBuilder strMoneda = new StringBuilder();
        StringBuilder strBodega = new StringBuilder();
        StringBuilder strNomProducto = new StringBuilder();
        StringBuilder strMedioCaptura = new StringBuilder();
        StringBuilder strTransporte = new StringBuilder();
        StringBuilder strVendedor = new StringBuilder();
        StringBuilder strListPrecio = new StringBuilder();

        String strSqlMonedas = "select MON_ID,MON_DESCRIPCION from vta_monedas";
        ResultSet rs1 = oConn.runQuery(strSqlMonedas, true);
        strMoneda.append("<option >Seleccione</option>");
        while (rs1.next()) {
            strMoneda.append("<option value='" + rs1.getInt("MON_ID") + "'>" + rs1.getString("MON_DESCRIPCION") + "</option>");
        }
        rs1.getStatement().close();
        rs1.close();

        String strSqlBodega = "SELECT  vta_sucursal.SC_ID,vta_sucursal.SC_NOMBRE  FROM vta_sucursal_master_as,  vta_sucursal where  vta_sucursal_master_as.SC_ID =  vta_sucursal.SC_ID  and vta_sucursal_master_as.SM_ID =" + varSesiones.getIntSucursalMaster();
        ResultSet rs2 = oConn.runQuery(strSqlBodega, true);
        strBodega.append("<option >Seleccione</option>");
        while (rs2.next()) {
            strBodega.append("<option value='" + rs2.getInt("SC_ID") + "'>" + rs2.getString("SC_NOMBRE") + "</option>");
        }
        rs2.getStatement().close();
        rs2.close();

        String strSqlTransporte = "select TR_ID,TR_TRANSPORTISTA from vta_transportista";
        ResultSet rs3 = oConn.runQuery(strSqlTransporte, true);
        strTransporte.append("<option >Seleccione</option>");
        while (rs3.next()) {
            strTransporte.append("<option value='" + rs3.getInt("TR_ID") + "'>" + rs3.getString("TR_TRANSPORTISTA") + "</option>");
        }
        rs3.getStatement().close();
        rs3.close();

        String strSqlVendedor = "select VE_ID,VE_NOMBRE from vta_vendedor";
        ResultSet rs4 = oConn.runQuery(strSqlVendedor, true);
        strVendedor.append("<option >Seleccione</option>");
        while (rs4.next()) {
            strVendedor.append("<option value='" + rs4.getInt("VE_ID") + "'>" + rs4.getString("VE_NOMBRE") + "</option>");
        }
        rs4.getStatement().close();
        rs4.close();

        String strSqlLprecios = "select LP_ID,LP_DESCRIPCION from vta_lprecios";
        ResultSet rs5 = oConn.runQuery(strSqlLprecios, true);
        strListPrecio.append("<option >Seleccione</option>");
        while (rs5.next()) {
            strListPrecio.append("<option value='" + rs5.getInt("LP_ID") + "'>" + rs5.getString("LP_DESCRIPCION") + "</option>");
        }
        rs5.getStatement().close();
        rs5.close();


%>


<!DOCTYPE html>
<html>
    <body>    
        <div id="div_principal">

            <div id="div_titulo" class="panel panel-default">
                <div class="panel-heading"></div>
                <table cellpadding="4" cellspacing="1" border="0" >

                    <td><font size=5>Pedido No.</font></td>
                    <td><input type="text" id="FAC_FOLIO" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;"/></td>
                    <td><font size=5>Sucursal</font></td>

                    <td><input type="text" id="cte_sucursal" value="<%=strNomSucursal%>" disabled="disabled" size="50"  style= "background-color:#C2C2C2;color:black;" /></td>                                        

                    <td style="visibility:hidden"><i class="fa fa-envelope" style="width: 600px; " align='right' onclick="MensajesPediMak();"></i></td>
                    <td style="right:inherit"><i class="fa fa-envelope" style="font-size:40px" align='right' onclick="MensajesPediMak();"></i></td>
                    <td style="right:inherit"><i class="fa fa-file-text-o" style="font-size:40px" align='right' onclick="ReporteEstClienteCteMak();"></i></td>
                    <td style="right:inherit"><i class="fa fa-user" style="font-size:40px" align='right' onclick="DatosClientePediMak();"></i></td>
                </table>
            </div>            

            <div id="div_infCte" class="panel panel-default">
                <div class="panel-heading"><font size=5>Info Cliente</font></div>
                <table cellpadding="4" cellspacing="1" border="0" >
                    <tr>
                        <td>Nombre:</td>
                        <td><input type="text" id="CT_NOM" value="" disabled="disabled" size="100" style= "background-color:#C2C2C2;color:black;"/></td>
                        <td>ID Cliente</td>
                        <td><input type="text" id="FCT_ID" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;"/></td>
                        <td>RFC:</td>
                        <td><input type="text" id="cte_rfc" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;"/></td> 
                        <td><a href="javascript:ObtieneClientePediMak();"><i class="fa fa-search"></i></a></td>

                    </tr>                    
                    <tr>
                        <td>Direcciòn:</td>
                        <td><input type="text" id="cte_direccion" value="" disabled="disabled"  size="100" style= "background-color:#C2C2C2;color:black;"/></td>                                            </tr>
                    <tr>
                        <td><font size=5>Info Subcliente</font></td>
                    </tr>
                    <tr>
                        <td>Nombre Subcliente:</td>
                        <td><input type="text" id="cte_nomSubcte" value="" disabled="disabled" size="100" style= "background-color:#C2C2C2;color:black;" /></td>
                        <td>RFC:</td>
                        <td><input type="text" id="cte_rfcSubcte" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;" /></td>

                        <td>ID SubCliente</td>
                        <td><input type="text" id="CT_CLIENTEFINAL" value="0" disabled="disabled" style= "background-color:#C2C2C2;color:black;" /></td>                                                                            
                        <td><a href="javascript:ObtieneSubClientePediMak();"><i class="fa fa-search"></i></a></td>
                        <td><a href="javascript:LimpiaSubClientePediMak();"><i class="fa fa-eraser"></i></a></td>
                    </tr>
                    <tr>
                        <td>Direcciòn:</td>
                        <td><input type="text" id="cte_direccionSubCliente" value="" disabled="disabled" size="100" style= "background-color:#C2C2C2;color:black;" /></td>

                        <td>Tel:</td>
                        <td><input type="text" id="cte_telSubcte" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;" /></td>                                                                            
                    </tr>

                </table>
            </div>
            <center>
                <div id="div_btnMosCte"><td><input id="btn_mosCte" type="button" value="Info Cliente" onclick="MostrarBotonesPediMak(1)"  > </td></div>
                <div id="div_btnOcuCte"><td><input id="btn_ocuCte" type="button" value="Info Cliente" onclick="OcultarBotonesPediMak(1)"  > </td></div>
            </center>

            <div id="div_pedidos" class="panel panel-default">
                <div class="panel-heading"><font size=5>Datos Pedido</font></div>
                <table cellpadding="4" cellspacing="1" border="0" >
                    <tr>
                        <td>Fecha Pedido:<span class="required">*</span></td>
                        <td><input type="text" id="FAC_FECHA" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;" /></td>
                        <td>Fecha Surtido:<span class="required">*</span></td>
                        <td><input type="text" id="pd_fech2" value=""  onblur="validaFechSurtidoPediMak(1)"/></td>                            
                        <td>Pedido Manual:</td>
                        <td><input type="text" id="pd_pdManual" value=""  /></td>
                    </tr>
                    <tr>
                        <td>Fecha Entrega:</td>
                        <td><input type="text" id="pd_fechValidez" value=""  onblur="validaFechSurtidoPediMak(2)"/></td>
                        <td>Contrato:</td>
                        <td><input type="text" id="pd_contrato" value=""  /></td>  
                        <td>Lista de precios:</td>
                        <td>&nbsp;
                            <select id="FCT_LPRECIOS"  name="moneda" class="combo1"  disabled="disabled" style= "background-color:#C2C2C2;color:black;">

                                <%=strListPrecio%>
                            </select>                             
                        </td>                         
                    </tr>
                    <tr>
                        <td>Moneda:<span class="required">*</span></td>
                        <td>&nbsp;
                            <select id="FAC_MONEDA" onchange="RefreshMonedaPediMak(this, 0)" name="moneda" class="combo1"  >                                
                                <%=strMoneda%>
                            </select>                             
                        </td>   
                        <td>Nombre Solicitante:</td>
                        <td><input type="text" id="pd_nomSolicit" value=""  /></td>
                    </tr>
                    <tr>
                        <td>Bodega:<span class="required">*</span></td>
                        <td>&nbsp;
                            <select id="pd_bodega" name="bodega" class="combo1"  placeholder="Bodega">                                
                                <%=strBodega%>
                            </select>                             
                        </td>
                        <td>Cotizaciòn Origen:</td>
                        <td><input type="text" id="pd_cotizaOrigen" value="0"  /></td>
                    </tr>
                    <tr>
                        <td>Vendedor:</td>
                        <td>&nbsp;
                            <select id="pd_vendedor" name="pd_vendedor" class="combo1"  placeholder="vendedor">                                  
                                <%=strVendedor%>
                            </select>
                        </td>
                        <td>O.C. Cliente:</td>
                        <td><input type="text" id="pd_ocCliente" value=""  /></td>
                    </tr>
                    <tr>                                
                        <td>Transporte:<span class="required">*</span></td>
                        <td>&nbsp;
                            <select id="TR_ID" name="transporte" class="combo1"  placeholder="Transporte">                                
                                <%=strTransporte%>
                            </select>                                  
                        </td>
                    </tr>
                </table>
            </div>
            <center>
                <div id="div_btnMosPed"><td><input id="btn_mosPed" type="button" value="Datos Pedido" onclick="MostrarBotonesPediMak(2)"  > </td></div>
                <div id="div_btnOcuPed"><td><input id="btn_ocuPed" type="button" value="Datos Pedido" onclick="OcultarBotonesPediMak(2)"  > </td></div>
            </center>
            <div id="div_gridpedido" class="panel panel-default">
                <div class="panel-heading"><font size=5>Pedido</font></div>  
                <table cellpadding="4" cellspacing="1" border="0" >
                    <tr>
                        <td>Lector/Còdigo</td>
                        <!-- onkeydown="AddItemEvt(event,this)" -->                        
                        <td><input type="text" id="FAC_PROD" value="" onkeydown="ObtieneProductoKeyPediMak(event)"/><a href="javascript:ObtieneProductoBtnPediMak();"><i class="fa fa-barcode fa-2x" ></i></a><font size=4>Pr</font></td> 
                        <td style="visibility:hidden"><i class="fa fa-envelope" style="width: 900px; " align='right' onclick="MensajesPediMak();"></i></td>
                        <td style="right:inherit"><i class="fa fa-cubes" style="font-size:40px" align='right' onclick="ExistenciasPediMak();"></i></td>
                        <td style="right:inherit"><i class="fa fa-pencil" style="font-size:40px" align='right' onclick="ModificarPrecioPediMak();"></i></td>
                        <td style="right:inherit"><i class="fa fa-trash" style="font-size:40px" align='right' onclick="BorrarRowPediMak();"></i></td>
                        <td style="right:inherit"><i class="fa fa-info-circle" style="font-size:40px" align='right' onclick="InformacionProductoPediMak();"></i></td>
                        <td style="right:inherit"><i class="fa fa-history" style="font-size:40px" align='right' onclick="HistorialPedidoPediMak();"></i></td>
                        <td style="right:inherit"><i class="fa fa fa-sort" style="font-size:40px" align='right' onclick="CamCatnidadbtnPediMak();"></i></td>

                        <td><input type="hidden" id="FAC_CANT" value="0"  /></td>                        
                        <td><input type="hidden" id="FAC_DESC" value=""  disabled="disabled" style= "background-color:#C2C2C2;color:black;"/></td>                        
                        <td><input type="hidden" id="FAC_PRECIO" value=""  disabled="disabled" style= "background-color:#C2C2C2;color:black;"/></td>

                    </tr>
                    <tr>
                    <table id="FAC_GRID" class="scroll" >      
                        <div id="pager1"></div>   
                    </table>
                    </tr>
                </table>
            </div>
            <center>
                <div id="div_btnMosGPedidos"><td><input id="btn_mosGPedidos" type="button" value="Pedido" onclick="MostrarBotonesPediMak(4)"  > </td></div>
                <div id="div_btnOcuGPedidos"><td><input id="btn_ocuGPedidos" type="button" value="Pedido" onclick="OcultarBotonesPediMak(4)"  > </td></div>
            </center>


            <div id="div_totalpedidos" class="panel panel-default">
                <div class="panel-heading"><font size=5>Total Pedidos</font></div>
                <table cellpadding="4" cellspacing="1" border="0" >
                    <tr>
                        <td>Importe:</td>
                        <td><input type="text" id="FAC_IMPORTE" value=""  disabled="disabled" style= "background-color:#C2C2C2;color:black;"/></td>   
                        <td>Descuento</td>
                        <td><input type="text" id="FAC_DESCUENTO" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;" /></td>                          
                    </tr>
                    <tr>
                        <td>IVA:</td>
                        <td><input type="text" id="FAC_IMPUESTO1" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;" /></td>
                        <td>Total:</td>
                        <td><input type="text" id="FAC_TOT" value="" disabled="disabled" style= "background-color:#C2C2C2;color:black;" /></td>                             
                    </tr>
                </table>
            </div>
            <center>
                <div id="div_btnMosTPedidos"><td><input id="btn_mosTPedidos" type="button" value="Total Pedido" onclick="MostrarBotonesPediMak(5)"  > </td></div>
                <div id="div_btnOcuTPedidos"><td><input id="btn_ocuTPedidos" type="button" value="Total Pedido" onclick="OcultarBotonesPediMak(5)"  > </td></div>
            </center>
            <div id="TOOLBAR"></div>
            <div id="div_camposhidden" class="panel panel-default">
                <div class="panel-heading"></div>
                <table cellpadding="4" cellspacing="1" border="0" >
                    <!--Aqui estan los campos hidden -->
                    <td><input type="hidden" id="SC_ID" value="<%=intSucursal%>" /></td>
                    <td><input type="hidden" id="FAC_TIPO" value="<%=3%>" /></td>
                    <td><input type="hidden" id="BOD_ID" value="<%=varSesiones.getIntSucursalDefault()%>" /></td>
                    <td><input type="hidden" id="EMP_ID" value="<%=varSesiones.getIntIdEmpresa()%>" /></td>
                    <td><input type="hidden" id="FAC_DEVO" value="0" /></td>
                    <td><input type="hidden" id="FAC_TTC_ID" value="0" /></td>
                    <td><input type="hidden" id="FCT_DESCUENTO" value="0" /></td>
                    <td><input type="hidden" id="FAC_DIASCREDITO" value="0" /></td>
                    <td><input type="hidden" id="FCT_MONTOCRED" value="0" /></td>
                    <td><input type="hidden" id="FAC_METODOPAGO" value="0" /></td>
                    <td><input type="hidden" id="FAC_FORMADEPAGO" value="0" /></td>
                    <td><input type="hidden" id="FAC_NUMCUENTA" value="0" /></td>
                    <td><input type="hidden" id="VE_ID" value="0" /></td>
                    <td><input type="hidden" id="FAC_TASASEL1" value="0" /></td>
                    <td><input type="hidden" id="FAC_USE_IMP1" value="0" /></td>
                    <td><input type="hidden" id="FAC_TASASEL2" value="0" /></td>
                    <td><input type="hidden" id="FAC_USE_IMP2" value="0" /></td>
                    <td><input type="hidden" id="FAC_TASASEL3" value="0" /></td>
                    <td><input type="hidden" id="FAC_USE_IMP3" value="0" /></td>
                    <td><input type="hidden" id="FAC_USO_IEPS1" value="0" /></td>
                    <td><input type="hidden" id="FAC_TASA_IEPS" value="0" /></td>
                    <td><input type="hidden" id="FAC_IMPORTE_IEPS" value="0" /></td>
                    <td><input type="hidden" id="FAC_IMPUESTO2" value="0" /></td>
                    <td><input type="hidden" id="FAC_IMPUESTO3" value="0" /></td>
                    <td><input type="hidden" id="FAC_PUNTOS" value="0" /></td>
                    <td><input type="hidden" id="FAC_NEGOCIO" value="0" /></td>
                    <td><input type="hidden" id="FAC_IMPORTE_REAL" value="0" /></td>
                    <td><input type="hidden" id="FAC_PZAS" value="0" /></td>
                    <td><input type="hidden" id="FAC_PUNTOS_REAL" value="0" /></td>
                    <td><input type="hidden" id="FAC_CREDITOS_REAL" value="0" /></td>
                    <td><input type="hidden" id="FAC_NEGOCIO_REAL" value="0" /></td>
                    <td><input type="hidden" id="FAC_IMPUESTO1_REAL" value="0" /></td>
                    <td><input type="hidden" id="FAC_IMPUESTO2_REAL" value="0" /></td>
                    <td><input type="hidden" id="FAC_IMPUESTO3_REAL" value="0" /></td>
                    <td><input type="hidden" id="FAC_RETISR" value="0" /></td>
                    <td><input type="hidden" id="FAC_RETIVA" value="0" /></td>
                    <td><input type="hidden" id="FAC_NETO" value="0" /></td>
                    <td><input type="hidden" id="PD_ID" value="0" /></td>
                    <td><input type="hidden" id="COT_ID" value="0" /></td>
                    <td><input type="hidden" id="FAC_NOTAS" value="" /></td>
                    <td><input type="hidden" id="FAC_NOTASPIE" value="" /></td>
                    <td><input type="hidden" id="FAC_REFERENCIA"value="0" /></td>
                    <td><input type="hidden" id="FAC_CONDPAGO" value="0"/></td>
                    <td><input type="hidden" id="FAC_NUMPEDI" value="0"/></td>
                    <td><input type="hidden" id="FAC_FECHAPEDI" value="0" /></td>
                    <td><input type="hidden" id="FAC_ADUANA" value="0"/></td>
                    <td><input type="hidden" id="FAC_TIPOCOMP" value="0"/></td>                    
                    <td><input type="hidden" id="ME_ID" value="0"/></td>
                    <td><input type="hidden" id="TF_ID" value="0"/></td>
                    <td><input type="hidden" id="CT_DIRENTREGA" value="0"/></td>
                    <td><input type="hidden" id="SYC_ID" value="0"/></td>
                    <td><input type="hidden" id="FAC_NUM_GUIA" value="0"/></td>
                    <td><input type="hidden" id="FAC_CONSIGNACION1" value="0"/></td>
                    <td><input type="hidden" id="FAC_ESRECU1" value="0"/></td>
                    <td><input type="hidden" id="FAC_PERIODICIDAD" value="0"/></td>
                    <td><input type="hidden" id="FAC_DIAPER" value="0"/></td>
                    <td><input type="hidden" id="FAC_NO_EVENTOS" value="0"/></td>
                    <td><input type="hidden" id="ADD_MABE" value="0"/></td>
                    <td><input type="hidden" id="ADD_SANOFI" value="0"/></td>
                    <td><input type="hidden" id="ADD_FEMSA" value="0"/></td>
                    <td><input type="hidden" id="VE_NOM" value="0"/></td>
                    <td><input type="hidden" id="FAC_LPRECIOS" value="0"/></td>
                    <td><input type="hidden" id="FAC_ESRECU2" value="0"/></td>
                    <td><input type="hidden" id="FAC_TASAPESO" value="1" /></td>                                                                            
                    <td><input type="hidden" id="PED_BAN_CODIGOINCOMPLETO" value="0" /></td>
                    <td><input type="hidden" id="PRECIOANTERIOR" value="0" /></td>
                    <td><input type="hidden" id="CANTIDADANTERIOR" value="0" /></td>
                    <td><input type="hidden" id="FACD_SUBTOTAL_A" value="0" /></td>
                    
                </table>
            </div>
        </div>    
    </body>
</html>


<%    }
    oConn.close();


%>



