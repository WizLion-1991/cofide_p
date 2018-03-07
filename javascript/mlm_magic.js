/* 
 * Js de prueba de la funcionalidad de ejecucion de scripts personalizados en las ofertas
 * 
 */

function mlm_magic(){
   
}

/**Genera un codigo aleatorio*/
function MagicRandom(){
   alert("Script personalizado....");
   var number = 1 + Math.floor(Math.random() * 6);
   document.getElementById("FAC_NOTAS").value = "TEXTO PERSONALIZADO POR PROMOCION " + number;
}

