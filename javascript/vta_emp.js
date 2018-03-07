/* 
 * Realiza las operaciones especiales de la subida de archivos privados para
 * la firma electronica
 */
function vta_emp(){
}
/**Se encarga de subir la llave privada de la factura electronica*/
function UpPrivateKey(){
   ValidaClean("EMP_ID");
   ValidaClean("PassPrivate");
   ValidaClean("File1");
   ValidaClean("File2");
   if(document.getElementById("EMP_ID").value == "0"){
      ValidaShow("EMP_ID",lstMsg[11]);
      $("#dialogWait").dialog("close");
      return false;
   }
   if(document.getElementById("PassPrivate").value == ""){
      ValidaShow("PassPrivate",lstMsg[12]);
      return false;
   }
   if(document.getElementById("File1").value == ""){
      ValidaShow("File1",lstMsg[13]);
      return false;
   }
   if(Right(document.getElementById("File1").value.toUpperCase(), 3) != "KEY"){
      ValidaShow("File1",lstMsg[14]);
      return false;
   }
   if(document.getElementById("File2").value == ""){
      ValidaShow("File2",lstMsg[13]);
      return false;
   }
   if(Right(document.getElementById("File2").value.toUpperCase(), 3) != "CER"){
      ValidaShow("File2",lstMsg[61]);
      return false;
   }
   //Subimos los datos al servidor
   document.getElementById("form1").action = "UpKey.do";
   document.getElementById("form1").submit();
   return true;
}
