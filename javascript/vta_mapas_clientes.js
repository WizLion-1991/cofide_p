/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function vta_mapas_clientes(){
   
}

function OpenMapaBancomer() {
   var strLink = "Bancomer_Mapas.jsp?clave={01}&nombre={02}&estatus={03}&fechaVisita={04}"
           + "&estado={05}&semana={06}&ingeniero={07}";

   var ST_CLAVEDELSITIO = encode(document.getElementById("ST_CLAVEDELSITIO").value);
   var ST_NOMBRESITIO = encode(document.getElementById("ST_NOMBRESITIO").value);
   var ST_ESTADO = document.getElementById("ST_ESTADO").value;
   var ST_STATUS = document.getElementById("ST_STATUS").value;
   var ST_GOG_IDC = document.getElementById("ST_GOG_IDC").value;
   var ST_FECHA_VISITA = document.getElementById("ST_FECHA_VISITA").value;
   var ST_SEMANA = document.getElementById("ST_SEMANA").value;


   strLink = strLink.replace("{01}", ST_CLAVEDELSITIO);
   strLink = strLink.replace("{02}", ST_NOMBRESITIO);
   strLink = strLink.replace("{03}", ST_ESTADO);
   strLink = strLink.replace("{04}", ST_STATUS);
   strLink = strLink.replace("{05}", ST_GOG_IDC);
   strLink = strLink.replace("{06}", ST_FECHA_VISITA);
   strLink = strLink.replace("{07}", ST_SEMANA);

   Abrir_Link(strLink, '_mapas_bancomer', 500, 600, 0, 0);
}