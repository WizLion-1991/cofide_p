/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function vta_CargaEmpleados()
{

}


function CargaEmpleados()
{

   //Validamos
   var File = document.getElementById("PATH_FILE");
   var btnBorrar = document.getElementById("BTN_BORRAR");
   if (File.value == "") {
      alert("Requiere seleccionar un archivo");
      File.focus();
   } else {
      if (Right(File.value.toUpperCase(), 3) == "XLS") {
         var intBorrar  =0;
         if(btnBorrar.checked){
            intBorrar  =1;
         }
         $.ajaxFileUpload({
            url: 'ERP_UPFileEmpleados.jsp?BTN_BORRAR=' + intBorrar,
            secureuri: false,
            fileElementId: "PATH_FILE",
            dataType: 'json',
            success: function(data, status)
            {
               if (typeof(data.error) != 'undefined') {
                  if (data.error != '') {
                     alert(data.error);
                  } else {
                     alert("Archivo guardado Correctamente!");
                  }
               } else {
                  alert("Archivo guardado Correctamente!");
               }
               $("#dialogWait").dialog('close');


            },
            error: function(data, status, e) {
               alert(e);
               $("#dialogWait").dialog('close');

            }
         }
         );
      } else {
         alert("Se aceptan archivos con extensión xls");
         File.focus();
      }
   }

}