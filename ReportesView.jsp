<%-- 
    Document   : ReportesView
   Genera la pantalla de captura de parametros de un reporte
    Created on : 18-may-2013, 7:14:45
    Author     : ZeusGalindo
--%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="comSIWeb.Utilerias.Fechas"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Iterator"%>
<%@page import="comSIWeb.Operaciones.TableMaster"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Tablas.repo_params"%>
<%@page import="Tablas.repo_master"%>
<%@page import="comSIWeb.ContextoApt.Seguridad"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
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
      Fechas fecha = new Fechas();
      String strIdRepo = request.getParameter("IdRepo");
      int intIdRepo = 0;
      if (strIdRepo == null) {
         strIdRepo = "0";
      }
      try {
         intIdRepo = Integer.valueOf(strIdRepo);
      } catch (NumberFormatException ex) {
      }
      //Identificar reporte inside(dentro de otro modulo)
      String strInsideRepo = request.getParameter("InsideRepo");
      int intInsideRepo = 0;
      if (strInsideRepo == null) {
         strInsideRepo = "0";
      }
      try {
         intInsideRepo = Integer.valueOf(strInsideRepo);
      } catch (NumberFormatException ex) {
      }
      //Parametros desde el script
      String strParamsNames = request.getParameter("ParamName");
      String strParamsValues = request.getParameter("ParamValue");
      String strParamReadOnly = request.getParameter("ParamReadOnly");
      if (strParamsNames == null) {
         strParamsNames = "";
      }
      if (strParamsValues == null) {
         strParamsValues = "";
      }
      if (strParamReadOnly == null) {
         strParamReadOnly = "";
      }
      String[] lstParamsNames = strParamsNames.split(",");
      String[] lstParamsValues = strParamsValues.split(",");
      String[] lstParamReadOnly = strParamReadOnly.split(",");

      //Reporte maestro
      repo_master rM = new repo_master();
      rM.ObtenDatos(intIdRepo, oConn);
      //Obtenemos los parametros del reporte
      repo_params r = new repo_params();
      ArrayList<TableMaster> lstParams = r.ObtenDatosVarios(" REP_ID = " + intIdRepo + " order by REPP_ORDEN", oConn);

      StringBuilder strList_dates = new StringBuilder();
      StringBuilder strList_vars = new StringBuilder();
      StringBuilder strList_types = new StringBuilder();

      //Evaluamos si tenemos permiso o si es fza de ventas
      boolean bolPasa = true;
      if (varSesiones.getintIdCliente() == 0) {

         //BackOffice
         if (rM.getFieldInt("REP_PERMISO") != 0) {
            //Evaluamos si el cliente tiene cierto permiso
            String strSql = "SELECT PS_ID "
                    + "FROM perfiles_permisos where "
                    + " PS_ID in (" + rM.getFieldInt("REP_PERMISO") + ") AND  PF_ID = " + varSesiones.getIntIdPerfil() + " ";
            ResultSet rsCombo;
            bolPasa = false;
            try {
               rsCombo = oConn.runQuery(strSql, true);
               while (rsCombo.next()) {
                  if (rM.getFieldInt("REP_PERMISO") == rsCombo.getInt("PS_ID")) {
                     bolPasa = true;
                  }
               }
               rsCombo.close();
            } catch (SQLException ex) {
               ex.fillInStackTrace();
            }
         }
         //Evaluamos si tiene un listado de usuarios que tienen acceso al report
         if (rM.getFieldString("REP_USERS") != null) {
            if (!rM.getFieldString("REP_USERS").isEmpty() && !rM.getFieldString("REP_USERS").equals("null")) {
               bolPasa = false;
               String line = System.getProperty("line.separator");
               StringTokenizer st = new StringTokenizer(rM.getFieldString("REP_USERS"), line);
               while (st.hasMoreTokens()) {
                  String strElemen = st.nextToken();
                  if (varSesiones.getStrUser().equals(strElemen)) {
                     bolPasa = true;
                  }
               }
            }
         }
      } else {
         //Fza de ventas
         if (rM.getFieldInt("REP_FZA_VTAS") == 0) {
            bolPasa = false;
         }
      }
      //Si paso las validaciones pedimos los parametros del reporte
      if (bolPasa) {
         String strPost = "JasperReport";
%>
<form method="post" action="<%=strPost%>">
   <input type="hidden" value="<%=rM.getFieldInt("REP_ID")%>" name="REP_ID">
   <div id='Reporte'>
      <div id='repo_title'><H1><%=rM.getFieldString("REP_NOMBRE")%></H1></div>
      <div id='repo_desc'>Descripcion: <%=rM.getFieldString("REP_DESCRIPCION")%></div>
      <%

      %>
      <div id='repo_params'>
         <div id='repo_params_title'><h2>Parametros:</h2></div>
         <div id='repo_params_deta'>
            <%
               Iterator<TableMaster> it = lstParams.iterator();
               while (it.hasNext()) {
                  TableMaster tbn = it.next();
                  //Pintamos el parametro
                  strList_vars.append(tbn.getFieldString("REPP_VARIABLE") + ",");
                  strList_types.append(tbn.getFieldString("REPP_TIPO") + ",");
            %>
            <div id='repo_params_deta_a'>
               <label for="<%=tbn.getFieldString("REPP_VARIABLE")%>" ><%=tbn.getFieldString("REPP_NOMBRE")%>:</label>
               <%
                  String strDefault = tbn.getFieldString("REPP_DEFAULT");
                  //Reemplazamos variables de sesion
                  if (strDefault.equals("[FECHA]")) {
                     strDefault = fecha.getFechaActualDDMMAAAADiagonal();
                  }
                  if (strDefault.equals("[FECHA_INI]")) {
                     strDefault = "01" + fecha.getFechaActualDDMMAAAADiagonal().substring(2, fecha.getFechaActualDDMMAAAADiagonal().length());
                  }
                  if (strDefault.equals("[HORA]")) {
                     strDefault = fecha.getHoraActual();
                  }
                  if (strDefault.equals("[no_user]")) {
                     strDefault = varSesiones.getIntNoUser() + "";
                  }
                  if (strDefault.equals("[anio]")) {
                     strDefault = varSesiones.getIntAnioWork() + "";
                  }
                  if (strDefault.equals("[ANIO]")) {
                     strDefault = fecha.getAnioActual() + "";
                  }
                  if (strDefault.equals("[MES]")) {
                     String strMes = "0" + fecha.getMesActual();
                     if (strMes.length() == 3) {
                        strMes = strMes.substring(1, 3);
                     }
                     strDefault = strMes;
                  }
                  if (strDefault.equals("[Empresa]")) {
                     strDefault = varSesiones.getIntIdEmpresa() + "";
                  }
                  if (strDefault.equals("[idcliente]")) {
                     strDefault = varSesiones.getintIdCliente() + "";
                  }
                  if (strDefault.equals("[SUCURSAL]")) {
                     strDefault = varSesiones.getIntSucursalDefault() + "";
                  }
                  if (strDefault.equals("[EmpresaDef]")) {
                     strDefault = varSesiones.getIntIdEmpresa() + "";
                  }
                  //Revisamos si nos enviaron el default en el script
                  boolean bolReadOnly = false;
                  for (int iv = 0; iv < lstParamsNames.length; iv++) {
                     if (lstParamsNames[iv].equals(tbn.getFieldString("REPP_VARIABLE"))) {
                        strDefault = lstParamsValues[iv];
                        if (lstParamReadOnly[iv].equals("1")) {
                           bolReadOnly = true;
                        }
                        break;
                     }
                  }
                  //Bandera de solo lectura
                  String strReadOnly = "";
                  if (bolReadOnly) {
                     strReadOnly = " readonly ";
                  }
                  //Dependiendo del tipo de parametro es como se dibuja
                  //Tipo hidden
                  if (tbn.getFieldString("REPP_TIPO").equals("hidden")) {
               %>
               <input type="hidden" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id='<%=tbn.getFieldString("REPP_VARIABLE")%>' value='<%=strDefault%>'>
               <%
                  }
                  //Tipo text
                  if (tbn.getFieldString("REPP_TIPO").equals("text")) {
                     String strEvalNumeros = "";
                     if (tbn.getFieldString("REPP_DATO").equals("integer") || tbn.getFieldString("REPP_DATO").equals("double")) {
                        strEvalNumeros = " onkeypress=\"return solonumero(event,'');\"";
                     }
                     if (bolReadOnly) {
                        %>
                        <%=strDefault%><input type="hidden" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id='<%=tbn.getFieldString("REPP_VARIABLE")%>' value='<%=strDefault%>'>
                        <%

                     } else {
                        %>
                        <input type="text" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id='<%=tbn.getFieldString("REPP_VARIABLE")%>' value='<%=strDefault%>' <%=strEvalNumeros%> <%=strReadOnly%>>
                        <%
                     }

                  }
                  //Tipo date
                  if (tbn.getFieldString("REPP_TIPO").equals("date")) {
                     strList_dates.append(tbn.getFieldString("REPP_VARIABLE") + ",");
                     if (strDefault.equals("[FECHA]")) {
                        strDefault = fecha.getFechaActualDDMMAAAADiagonal();
                     }
                     if (strDefault.equals("[FECHA_1]")) {
                        strDefault = "01" + fecha.getFechaActualDDMMAAAADiagonal().substring(2, fecha.getFechaActualDDMMAAAADiagonal().length());
                     }
               %>
               <input type="text" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id='<%=tbn.getFieldString("REPP_VARIABLE")%>' value='<%=strDefault%>' >
               <%
                  }
                  //Tipo radio
                  if (tbn.getFieldString("REPP_TIPO").equals("radio")) {
                     String strChecked1 = "";
                     String strChecked2 = "";
                     if (strDefault.equals("1")) {
                        strChecked1 = " checked";
                     } else {
                        strChecked2 = " checked";
                     }
               %><input type="radio" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id="<%=tbn.getFieldString("REPP_VARIABLE")%>_1" value="1" <%=strChecked1%> >SI&nbsp;<input type="radio" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id="<%=tbn.getFieldString("REPP_VARIABLE")%>_2" value="0" <%=strChecked2%>>NO
               <%
                  }
                  //Tipo checkbox
                  if (tbn.getFieldString("REPP_TIPO").equals("check")) {
                     String strChecked1 = "";
                     if (strDefault.equals("1")) {
                        strChecked1 = " checked";
                     }
               %><input type="checkbox" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id="<%=tbn.getFieldString("REPP_VARIABLE")%>" value="1" <%=strChecked1%> >&nbsp;
               <%
                  }

                  //Tipo select de solo lectura(usamos un hidden)
                  if (tbn.getFieldString("REPP_TIPO").equals("select") && bolReadOnly) {
                     String strNameShow = "";
                     //EValuamos si podemos ejecutar la consulta
                     if (!tbn.getFieldString("REPP_TABLAEXT").isEmpty()
                             && !tbn.getFieldString("REPP_ENVIO").isEmpty()
                             && !tbn.getFieldString("REPP_MOSTRAR").isEmpty()) {
                        String strCondPost = tbn.getFieldString("REPP_POST");
                        //Reemplazamos variables de sesion
                        if (strCondPost.contains("[FECHA]")) {
                           strCondPost = strCondPost.replace("[FECHA]", fecha.getFechaActualDDMMAAAADiagonal());
                        }
                        if (strCondPost.contains("[HORA]")) {
                           strCondPost = strCondPost.replace("[HORA]", fecha.getHoraActual());
                        }
                        if (strCondPost.contains("[no_user]")) {
                           strCondPost = strCondPost.replace("[no_user]", varSesiones.getIntNoUser() + "");
                        }
                        if (strCondPost.contains("[anio]")) {
                           strCondPost = strCondPost.replace("[anio]", varSesiones.getIntAnioWork() + "");
                        }
                        if (strCondPost.contains("[ANIO]")) {
                           strCondPost = strCondPost.replace("[ANIO]", fecha.getAnioActual() + "");
                        }
                        if (strCondPost.contains("[MES]")) {
                           String strMes = "0" + fecha.getMesActual();
                           if (strMes.length() == 3) {
                              strMes = strMes.substring(1, 3);
                           }
                           strCondPost = strCondPost.replace("[MES]", strMes);
                        }
                        if (strCondPost.contains("[Empresa]")) {
                           strCondPost = strCondPost.replace("[Empresa]", varSesiones.getIntClienteWork() + "");
                        }
                        if (strCondPost.contains("[idcliente]")) {
                           strCondPost = strCondPost.replace("[idcliente]", varSesiones.getintIdCliente() + "");
                        }
                        if (strCondPost.contains("[SUCURSAL]")) {
                           strCondPost = strCondPost.replace("[SUCURSAL]", varSesiones.getIntSucursalDefault() + "");
                        }
                        if (strCondPost.toUpperCase().contains("[EMPRESADEF]")) {
                           strCondPost = strCondPost.replace("[EMPRESADEF]".toUpperCase(), varSesiones.getIntIdEmpresa() + "");
                        }

                        StringBuilder strSql = new StringBuilder("select ");
                        if (!tbn.getFieldString("REPP_PRE").isEmpty()) {
                           strSql.append(tbn.getFieldString("REPP_PRE"));
                        }
                        strSql.append(" " + tbn.getFieldString("REPP_ENVIO") + ","
                                + " " + tbn.getFieldString("REPP_MOSTRAR") + " from " + tbn.getFieldString("REPP_TABLAEXT"));
                        if (!strCondPost.isEmpty()) {
                           strSql.append(strCondPost);
                        }
                        try {
                           ResultSet rs = oConn.runQuery(strSql.toString(), true);
                           while (rs.next()) {
                              if (rs.getString(1).equals(strDefault)) {
                                 strNameShow = rs.getString(2);
                              }
                           }
                           rs.close();
                        } catch (Exception ex) {
                           System.out.println(" " + ex.getMessage());
                        }
                     }
               %>
               <%=strNameShow%><input type="hidden" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" id='<%=tbn.getFieldString("REPP_VARIABLE")%>' value='<%=strDefault%>'>
               <%
                  }
                  //Tipo select sin solo lectura
                  if (tbn.getFieldString("REPP_TIPO").equals("select") && !bolReadOnly) {

               %>
               <select id="<%=tbn.getFieldString("REPP_VARIABLE")%>" name="<%=tbn.getFieldString("REPP_VARIABLE")%>">
                  <%if (tbn.getFieldString("REPP_DATO").equals("integer") || tbn.getFieldString("REPP_DATO").equals("double")) { %>
                  <option value="0">Seleccione</option>
                  <%}else{%>
                  <option value="">Seleccione</option>
                  <%}%>
                  <%
                     //EValuamos si podemos ejecutar la consulta
                     if (!tbn.getFieldString("REPP_TABLAEXT").isEmpty()
                             && !tbn.getFieldString("REPP_ENVIO").isEmpty()
                             && !tbn.getFieldString("REPP_MOSTRAR").isEmpty()) {
                        String strCondPost = tbn.getFieldString("REPP_POST");
                        //Reemplazamos variables de sesion
                        if (strCondPost.contains("[FECHA]")) {
                           strCondPost = strCondPost.replace("[FECHA]", fecha.getFechaActualDDMMAAAADiagonal());
                        }
                        if (strCondPost.contains("[HORA]")) {
                           strCondPost = strCondPost.replace("[HORA]", fecha.getHoraActual());
                        }
                        if (strCondPost.contains("[no_user]")) {
                           strCondPost = strCondPost.replace("[no_user]", varSesiones.getIntNoUser() + "");
                        }
                        if (strCondPost.contains("[anio]")) {
                           strCondPost = strCondPost.replace("[anio]", varSesiones.getIntAnioWork() + "");
                        }
                        if (strCondPost.contains("[ANIO]")) {
                           strCondPost = strCondPost.replace("[ANIO]", fecha.getAnioActual() + "");
                        }
                        if (strCondPost.contains("[MES]")) {
                           String strMes = "0" + fecha.getMesActual();
                           if (strMes.length() == 3) {
                              strMes = strMes.substring(1, 3);
                           }
                           strCondPost = strCondPost.replace("[MES]", strMes);
                        }
                        if (strCondPost.contains("[Empresa]")) {
                           strCondPost = strCondPost.replace("[Empresa]", varSesiones.getIntClienteWork() + "");
                        }
                        if (strCondPost.contains("[idcliente]")) {
                           strCondPost = strCondPost.replace("[idcliente]", varSesiones.getintIdCliente() + "");
                        }
                        if (strCondPost.contains("[SUCURSAL]")) {
                           strCondPost = strCondPost.replace("[SUCURSAL]", varSesiones.getIntSucursalDefault() + "");
                        }
                        if (strCondPost.toUpperCase().contains("[EMPRESADEF]")) {
                           strCondPost = strCondPost.replace("[EMPRESADEF]".toUpperCase(), varSesiones.getIntIdEmpresa() + "");
                        }

                        StringBuilder strSql = new StringBuilder("select ");
                        if (!tbn.getFieldString("REPP_PRE").isEmpty()) {
                           strSql.append(tbn.getFieldString("REPP_PRE"));
                        }
                        strSql.append(" " + tbn.getFieldString("REPP_ENVIO") + ","
                                + " " + tbn.getFieldString("REPP_MOSTRAR") + " from " + tbn.getFieldString("REPP_TABLAEXT"));
                        if (!strCondPost.isEmpty()) {
                           strSql.append(strCondPost);
                        }
                        try {
                           ResultSet rs = oConn.runQuery(strSql.toString(), true);
                           while (rs.next()) {
                              if(strDefault.equals(rs.getString(1))){
                                 %><option value="<%=rs.getString(1)%>" selected><%=rs.getString(2)%></option><%
                              }else{
                                 %><option value="<%=rs.getString(1)%>"><%=rs.getString(2)%></option><%
                              }
                  
                        }
                        rs.close();
                     } catch (Exception ex) {
                        System.out.println(" " + ex.getMessage());
                     }
                  } else {
                  %><option value="0">ERROR: LE FALTAN DATOS AL PARAMETRO</option><%                     }
                     %>
               </select>
               <%
                  }

                  //Tipo select
                  if (tbn.getFieldString("REPP_TIPO").equals("PanelCheck")) {
                     //EValuamos si podemos ejecutar la consulta
                     if (!tbn.getFieldString("REPP_TABLAEXT").isEmpty()
                             && !tbn.getFieldString("REPP_ENVIO").isEmpty()
                             && !tbn.getFieldString("REPP_MOSTRAR").isEmpty()) {
                        StringBuilder strSql = new StringBuilder("select ");
                        if (!tbn.getFieldString("REPP_PRE").isEmpty()) {
                           strSql.append(tbn.getFieldString("REPP_PRE"));
                        }
                        strSql.append(" " + tbn.getFieldString("REPP_ENVIO") + ","
                                + " " + tbn.getFieldString("REPP_MOSTRAR") + " from " + tbn.getFieldString("REPP_TABLAEXT"));
                        if (!tbn.getFieldString("REPP_POST").isEmpty()) {
                           strSql.append(tbn.getFieldString("REPP_POST"));
                        }
                        try {
                           ResultSet rs = oConn.runQuery(strSql.toString(), true);
                           int intConta = 0;
                           int intContaTotal = 0;
               %><br>
               <table>

               
               <%
                           while (rs.next()) {
                              intConta++;
                              intContaTotal++;
                              //Añadimos un salto cada 3 elementos
                              if (intConta == 4) {
                                 %></tr><%
                                 intConta = 0;
                              }
                              if (intConta == 0) {
                                 %><tr><%
                                 intConta = 0;
                              }
               %>
               <td>
               <input type="checkbox" id="<%=intContaTotal + "_" + tbn.getFieldString("REPP_VARIABLE")%>" name="<%=tbn.getFieldString("REPP_VARIABLE")%>" value="<%=rs.getString(1)%>"><%=rs.getString(2)%>
               </td>
               <%

                  }
                           %>
               </tr>
               </table>
                           <%
                  rs.close();
               %>
               <input type="HIDDEN" id="conta_<%=tbn.getFieldString("REPP_VARIABLE")%>" name="conta_<%=tbn.getFieldString("REPP_VARIABLE")%>" value="<%=intContaTotal%>"><
               <%

                        } catch (Exception ex) {
                           System.out.println(" " + ex.getMessage());
                        }
                     } else {
                        //No hay datos
                     }
                  }
               %>

            </div>
            <%
               }
            %>
            <div id="repo_buttons">
               <h2>Seleccione el formato del reporte:</h2><br>
               <% if(rM.getFieldInt("REP_HTML") == 1){ %>
               <%if (intInsideRepo == 0) {%>
               <button type="button" id="boton_1" name="boton_1" value="HTML" onclick="jReportHtml()" ><img border="0" src="images/layout/jrepo_html.png" height="44" width="44" alt="Html" title="Html"> HTML</button>
                  <%} else {%>
               <button type="button" id="boton_1" name="boton_1" value="HTML" onclick="jReportHtmlInside(<%=intIdRepo%>)" ><img border="0" src="images/layout/jrepo_html.png" height="44" width="44" alt="Html" title="Html"> HTML</button>
                  <%}%>
               <% } %>
               <% if(rM.getFieldInt("REP_XLS") == 1){ %>
               <button type="submit" id="boton_2" name="boton_1" value="XLS"><img border="0" src="images/layout/jrepo_xls.png" height="44" width="44" alt="xls" title="xls"> XLS</button>
               <% } %>
               <% if(rM.getFieldInt("REP_PDF") == 1){ %>
               <button type="submit" id="boton_3" name="boton_1" value="PDF"><img border="0" src="images/layout/repo_pdf.png" height="44" width="44" alt="pdf" title="pdf"> PDF</button>
               <% } %>
               <% if(rM.getFieldInt("REP_XLS") == 1){ %>
               <button type="submit" id="boton_4" name="boton_1" value="DOC"><img border="0" src="images/layout/jrepo_doc.png" height="44" width="44" alt="doc" title="doc"> DOC</button>
               <% } %>
               <% if(rM.getFieldInt("REP_TXT") == 1){ %>
               <button type="submit" id="boton_5" name="boton_1" value="TXT"><img border="0" src="images/layout/repo_txt.png" height="44" width="44" alt="txt" title="txt"> TXT</button>
               <% } %>

            </div>
         </div>
         <input type="hidden" id="list_dates" name="list_dates" value="<%=strList_dates.toString()%>" />
         <input type="hidden" id="list_vars" name="list_vars" value="<%=strList_vars.toString()%>" />
         <input type="hidden" id="list_types" name="list_types" value="<%=strList_types.toString()%>" />
      </div>
      <div id="content_html" style=" OVERFLOW: auto; WIDTH: 736px; TOP: 48px; HEIGHT: 432px">

      </div>
   </div>
</form>
<%
} else {
%>
<div id='repo_error'>Lo sentimos no tiene permiso para poder emitir el reporte</div>
<%               }
   }
   oConn.close();
%>