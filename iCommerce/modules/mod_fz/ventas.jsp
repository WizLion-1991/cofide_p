

<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    VariableSession varSesiones = new VariableSession(request);
    varSesiones.getVars();
    if (varSesiones.getIntNoUser() != 0) {

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
    oConn.close();
%>
<html lang="es">
    <head>
        <script>
            //var mydata = [ {id:"1",invdate:"2007-10-01",name:"test",note:"note",amount:"200.00",tax:"10.00",total:"210.00"}, {id:"2",invdate:"2007-10-02",name:"test2",note:"note2",amount:"300.00",tax:"20.00",total:"320.00"}, {id:"3",invdate:"2007-09-01",name:"test3",note:"note3",amount:"400.00",tax:"30.00",total:"430.00"}, {id:"4",invdate:"2007-10-04",name:"test",note:"note",amount:"200.00",tax:"10.00",total:"210.00"}, {id:"5",invdate:"2007-10-05",name:"test2",note:"note2",amount:"300.00",tax:"20.00",total:"320.00"}, {id:"6",invdate:"2007-09-06",name:"test3",note:"note3",amount:"400.00",tax:"30.00",total:"430.00"}, {id:"7",invdate:"2007-10-04",name:"test",note:"note",amount:"200.00",tax:"10.00",total:"210.00"}, {id:"8",invdate:"2007-10-03",name:"test2",note:"note2",amount:"300.00",tax:"20.00",total:"320.00"}, {id:"9",invdate:"2007-09-01",name:"test3",note:"note3",amount:"400.00",tax:"30.00",total:"430.00"} ];
            //El orden del colmodel es el que debes de sefguir en el xml
            $(document).ready(function(){
                $("#list").jqGrid({ 
                    url: "modules/mod_fz/Ventas_Opciones.jsp?ID=1",
                    datatype: "xml", 
                    mtype: "GET",
                    height: "", 
                    colNames:['ID','FECHA', 'FOLIO', 'TIPO DOCUMENTO','IMPORTE','IVA','TOTAL'], 
                    colModel:[ 
                        {name:'id',index:'id', width:20}, 
                        {name:'fecha',index:'fecha', width:150}, 
                        {name:'folio',index:'folio', width:100},
                        {name:'tipo_documento',index:'tipo_documento', width:80, align:"center"}, 
                        {name:'importe',index:'importe', width:80, align:"right"}, 
                        {name:'iva',index:'iva', width:80,align:"right"}, 
                        {name:'total',index:'total', width:90, sortable:false,align:"right"}
                    ], 
                    caption: "PEDIDOS"
                    
                });

                //for(var i=0;i<=mydata.length;i++) 
                //	jQuery("#list").jqGrid('addRowData',i+1,mydata[i]);
            });
        </script>
        <script>
            $(function(){
                $( "#FECHA_INICIAL" ).datepicker();
                $( "#FECHA_FINAL" ).datepicker();
            });
        </script>
    </head>
    <body>
        <div class="well ">
           <h3 class="page-header">Consulta de ventas</h3>
            <form class="form-inline">
                <div class="userdata">
                    <!--FECHA_INICIAL-->
                    <div id="form-new-finicial" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="FECHA INICIAL"/>
                                    <label for="fecha-inicial" >FECHA INICIAL: </label>                                
                                </span>
                                <input id="FECHA_INICIAL" type="text" name="finicial" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--FECHA_FINAL-->
                    <div id="form-new-ffinal" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="FECHA FINAL"/>
                                    <label for="fecha-final" >FECHA FINAL: </label>                                
                                </span>
                                <input id="FECHA_FINAL" type="text" name="ffinal" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/><span class="required">*</span>
                            </div>
                        </div>
                    </div>
                    <!--FECHA_FOLIO-->
                    <div id="form-new-folio" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="FOLIO"/>
                                    <label for="fecha-final" >FOLIO: </label>                                
                                </span>
                                <input id="FOLIO" type="text" name="folio" class="input-medium-ingresos" tabindex="0" size="30" maxlength="29" placeholder=" "/>
                            </div>
                        </div>
                    </div>
                    <!--FECHA_FOLIO-->
                    <div id="form-new-tdocumento" class="control-group">
                        <div class="controls">
                            <div class="input-prepend input-append">
                                <span class="add-on">
                                    <span title="TDocumento"/>
                                    <label for="TDocumento" >TIPO DOCUMENTO: </label>                                
                                </span>
                                <br><input id="tipo_doc1" type="radio" name="TIPO_DUCUMENTO" checked="true">PEDIDO
                                <br><input id="tipo_doc2" type="radio" name="TIPO_DUCUMENTO"  >FACTURA
                                <br><input id="tipo_doc3" type="radio" name="TIPO_DUCUMENTO"  >REMISION
                            </div>
                        </div>
                    </div>
                    <!--Boton-->
                    <br><br><br>
                    <div id="form-new-buscar" class="control-group">
                        <div class="controls">
                            <button type="button" tabindex="0" name="Buscar" class="btn btn-primary btn" onclick="Busca() " id="BTN_BUSCAR">BUSCAR</button>
                        </div>
                    </div>

                    <div id="formHidden" style="display:none"></div>
                    <!--GRID-->
                    <div id="form-new-grid">
                        <div class="controls">
                            <table id='list'></table>
                        </div>
                    </div>
                    <!--Boton-->
                    <br><br><br>


                </div>
            </form>
        </div>
    </body>
</html>
<script>
    function openReportVentas(){
        var grid = jQuery("#list");
        if (grid.getGridParam("selrow") != null) {
            var lstRow = grid.getRowData(grid.getGridParam("selrow"));
            var strTipo="hidden";
            var name;
            var value = lstRow.id;
            var strTipoDoc;
            
            if(document.getElementById("tipo_doc1").checked)
            {
                //alert("Es Pedido");
                name = "PD_ID";
                strTipoDoc = "PEDIDO";
            }
            if(document.getElementById("tipo_doc2").checked)
            {
                //alert("Es Factura");
                name = "FAC_ID";
                strTipoDoc = "FACTURA";
            }
            if(document.getElementById("tipo_doc3").checked)
            {
                //alert("Es Remision");
                name = "TKT_ID";
                strTipoDoc = "TICKET";
            }
            var strHtml = "<input type=\"" + strTipo +"\" name=\"" + name + "\" id=\"" + name + "\" value=\"" + value +"\" />";
            openFormat(strTipoDoc, "PDF", strHtml);
        }   
        
    }
    function Valida()
    {
        var boolValido = true;
        if(document.getElementById("FECHA_INICIAL").value == "")
        {
            alert("Tienes que asignar la Fecha Inicial");
            boolValido = false;
            document.getElementById("FECHA_INICIAL").focus();
        }
        if(document.getElementById("FECHA_FINAL").value == "")
        {
            alert("Tienes que asignar la Fecha Final");
            boolValido = false;
            document.getElementById("FECHA_FINAL").focus();
        }
        return boolValido;
    }
    function Busca()
    {
        if(Valida())
        {
            var FECHA_INI = document.getElementById("FECHA_INICIAL").value;
            var FECHA_FIN = document.getElementById("FECHA_FINAL").value;
            var FOLIO     = document.getElementById("FOLIO").value;
            var arreglo = document.getElementsByName("TIPO_DUCUMENTO");
            var ID = "<%=varSesiones.getIntNoUser()%>";
            //alert(ID);
            var RADIO;
            var i;
            for(i=0;i<arreglo.length;i++)
            {
                if(arreglo[i].checked)
                {
                    RADIO = i+1;
                    break;
                }
            }
            var strPOST = "&FAC_FOLIO="+FOLIO;
            strPOST +="&FECHA_INICIAL="+FECHA_INI;
            strPOST +="&FECHA_FINAL="+FECHA_FIN;
            strPOST +="&RADIO="+RADIO;
            strPOST +="&ID_C="+ID;
        
            var grid = jQuery("#list");
            grid.setGridParam({
                url: "modules/mod_fz/Ventas_Opciones.jsp?ID=1"+ strPOST
            });
            grid.trigger('reloadGrid');
        }
        else
        {
            
        }
    }
    /**Manda abrir un reporte*/
    function openFormat(strNomForm,strTipo,strHtmlControl,strMaskFolio){
        var strHtml = "<form action=\"../Formatos\" method=\"post\" target=\"_blank\" id=\"formSend\">";
        
        
        var strTipo="hidden";
        var name = "NomForm";
        var value = strNomForm;
        strHtml += "<input type=\"" + strTipo +"\" name=\"" + name + "\" id=\"" + name + "\" value=\"" + value +"\" />";
        
        
        
        //strHtml += CreaHidden("NomForm",strNomForm);
        if(strMaskFolio != undefined){
            strHtml += CreaHidden("MASK_FOLIO",strMaskFolio);  
        }
        var strTipo="hidden";
        var name = "report";
        strHtml += "<input type=\"" + strTipo +"\" name=\"" + name + "\" id=\"" + name + "\" value=\"PDF\" />";
        strHtml+= strHtmlControl;
        strHtml+= "</form>";
        document.getElementById("formHidden").innerHTML  = strHtml;
        document.getElementById("formSend").submit();
    }
</script>

<%         }
%>