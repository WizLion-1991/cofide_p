<%-- 
    Document   : ecomm_cat
    Created on : 01-sep-2014, 4:06:06
    Author     : ZeusGalindo
--%>
<%@page import="comSIWeb.Utilerias.NumberString"%>
<%@page import="com.mx.siweb.ui.web.Site"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="comSIWeb.Operaciones.Conexion"%>
<%@page import="comSIWeb.ContextoApt.VariableSession"%>
<%
   //Iniciamos valores
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
//Abrimos la conexion
   Conexion oConn = new Conexion(null, this.getServletContext());
   oConn.open();
   //Obtenemos parametros generales de la pagina a mostrar
   Site webBase = new Site(oConn);
   String strCatId = request.getParameter("cat_id");
   if (strCatId == null) {
      strCatId = "0";
   }
   //Obtenemos la tasa de impuesto default
   double dblFactorImpuesto = 0;
   String strSqlI = "select * from vta_tasaiva where TI_ID = 1";
   ResultSet rsI = oConn.runQuery(strSqlI);
   while (rsI.next()) {
      dblFactorImpuesto = rsI.getDouble("TI_TASA");
   }
   rsI.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="content" style="border-left: 1px solid #333; padding-left:10px;">
   <div id="content-top">
   </div>
   <%
      //Consultamos las categorias

      String strSql = "select * "
              + "from vta_prodcat1 where PC_ID = " + strCatId;
      ResultSet rs = oConn.runQuery(strSql, true);
      while (rs.next()) {
         String strPC_IMAGEN = rs.getString("PC_IMAGEN");
         if (!strPC_IMAGEN.isEmpty()) {
   %>
   <div class="category-info">
      <div class="image"><img src="<%=webBase.getUrlSite() + strPC_IMAGEN%>" alt="<%=rs.getString("PC_DESCRIPCION")%>"></div>
   </div>

   <%         }
      }
      rs.close();
   %>


   <div class="product-list">
      <%
         //Consultamos las productos de esta categoria
         strSql = "select vta_prodcat2.PC2_DESCRIPCION, vta_prodcat2.PC2_ORDEN,vta_prodcat2.PC2_ID, "
                 + " PR_NOMIMG1,MIN(PR_ID) as IdProd "
                 + "from vta_prodcat2 INNER JOIN vta_producto ON vta_prodcat2.PC2_ID = vta_producto.PR_CATEGORIA2"
                 + " where PR_CATEGORIA1 = " + strCatId + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1"
                 + " GROUP BY vta_prodcat2.PC2_DESCRIPCION, vta_prodcat2.PC2_ORDEN";
         rs = oConn.runQuery(strSql, true);
         while (rs.next()) {
            int intPrId = rs.getInt("IdProd");
            //String strDes = rs.getString("PR_DESCRIPCION");
            String strImg1 = rs.getString("PR_NOMIMG1");
            String strModelo = rs.getString("PC2_DESCRIPCION");
            int intModelo = rs.getInt("PC2_ID");
            //precios
            double dblPrecio = 0;

            if (varSesiones.getIntNoUser() != 0) {
               strSql = "select PP_PRECIO "
                       + "from vta_prodprecios where PR_ID = " + intPrId + " AND LP_ID = 1";
            } else {
               strSql = "select PP_PRECIO "
                       + "from vta_prodprecios where PR_ID = " + intPrId + " AND LP_ID = 2";
            }
            ResultSet rs2 = oConn.runQuery(strSql, true);
            while (rs2.next()) {
               dblPrecio = rs2.getDouble("PP_PRECIO");
            }
            rs2.close();
            //Agregamos el impuesto
            //double dblImpuesto = dblPrecio * (dblFactorImpuesto / 100);
            //dblPrecio += dblImpuesto;
            //strImg1 = strImg1.replace(".jpg", "-203x191.jpg");
            //String strNombreImagen = webBase.getUrlSite().replace("/iCommerce/", "") + strImg1;
            //strNombreImagen = "http://casajosefa.com/image/cache/" + strImg1;

            String strNombreImagen = webBase.getUrlSite().replace("/iCommerce/", "") + strImg1;
            strNombreImagen = "http://casajosefa.com/" + strImg1;//.replace(".jpg", "-500x500.jpg");

      %>
      <!-- item -->
      <div class="clsProductBox_cat">
         <div class="image"><a href="index.jsp?mod=ecomm_cat_deta&product_id=<%=intPrId%>">
               <img alt="<%=strModelo%>" src="<%=strNombreImagen%>" width="127" height="191"></a></div>
         <div class="clsFbutton">
            <div class="name"><a href="index.jsp?mod=ecomm_cat_deta&product_id=<%=intPrId%>"><%=strModelo%></a></div>
            <div class="description"><%=""%></div>        	 
            <div class="price">
               $<%=NumberString.FormatearDecimal(dblPrecio,2)%>			
            </div>
            <div class="price">
               <%
                  //Listamos los colores definidos
                  strSql = "SELECT DISTINCT 	vta_prodcat4.PC4_ID, 	vta_prodcat4.PC4_DESCRIPCION, vta_prodcat4.PC4_ORDEN, 	"
                          + " vta_prodcat4.PC4_IMAGEN_22 "
                          + " FROM vta_producto INNER JOIN vta_prodcat4 ON vta_producto.PR_CATEGORIA4 = vta_prodcat4.PC4_ID"
                          + " where PR_CATEGORIA2 = " + intModelo + " AND PR_ACTIVO= 1 AND PR_ECOMM= 1 "
                          + " order by PC4_ORDEN";
                  rs2 = oConn.runQuery(strSql, true);
                  while (rs2.next()) {
               %>
               <img width="22px" height="22px" alt="<%=rs2.getString("PC4_DESCRIPCION")%>" src="http://casajosefa.com/image/cache/data/<%=rs2.getString("PC4_IMAGEN_22")%>">
               <%         }
                  rs2.close();
               %>

            </div>
         </div>
      </div>
      <!--item -->
      <%         }
         rs.close();
      %>
   </div>

   <div class="pagination">
      <!--<div class="links"> 
         <b>1</b><a href="http://casajosefa.com/index.php?route=product/category&amp;path=60_65&amp;page=2">2</a>  
         <a href="http://casajosefa.com/index.php?route=product/category&amp;path=60_65&amp;page=3">3</a>  
         <a href="http://casajosefa.com/index.php?route=product/category&amp;path=60_65&amp;page=4">4</a>  
         <a href="http://casajosefa.com/index.php?route=product/category&amp;path=60_65&amp;page=5">5</a>  
         <a href="http://casajosefa.com/index.php?route=product/category&amp;path=60_65&amp;page=2">&gt;</a> 
         <a href="http://casajosefa.com/index.php?route=product/category&amp;path=60_65&amp;page=5">&gt;|</a> 
      </div>
      <div class="results">Mostrando de 1 a 15 de 62 (5 Páginas)</div>
      -->
   </div>
</div>    
<%
   oConn.close();
%>