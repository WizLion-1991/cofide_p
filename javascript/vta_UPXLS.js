/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function vta_UPXLS() {
}

function InitUPXLS(){
    document.getElementById("btn1").setAttribute("class", "Oculto");
}
/**Verifica la extension del Archivo XLS al servidor*/
function UPARCHIVOXLS() {
    
    $("#dialogWait").dialog('open');
    
    var File = document.getElementById("PATHXLS");
    if (File.value == "") {
        alert("Requiere seleccionar un archivo");
        File.focus();
    } else {
        if (Right(File.value.toUpperCase(), 3) == "XLS" || Right(File.value.toUpperCase(), 4) == "XLSX" ) {
            $.ajaxFileUpload({
                url: 'ERP_SubirArchivoXLS.jsp',
                secureuri: false,
                fileElementId: "PATHXLS",
                dataType: 'json',
                success: function(data, status)
                {
                    if (typeof (data.error) != 'undefined') {
                        if (data.error != '') {
                            alert(data.error);
                        } else {
                            document.getElementById("DIVXLS").innerHTML = data.strUUID;
                        }
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
            alert("Solo se aceptan archivos con extensión XLS");
            File.focus();
        }
    }

} //FIN function UPARCHIVOXLS

/*Sube el archivo al servidor*/
function ajaxFileUpload(strNomFile){
   $("#dialogWait").dialog('open');
   //Subimos el archivo con ajaxUpload
   $.ajaxFileUpload
           (
                   {
                      url: 'ERP_SubirArchivoXLS.jsp',
                      secureuri: false,
                      fileElementId: strNomFile,
                      dataType: 'json',
                      success: function(data, status)
                      {
                         if (typeof(data.error) != 'undefined') {
                            if (data.error != '') {
                               alert(data.error);
                            }
                         }
                         $("#dialogWait").dialog('close');
                         alert("Archivo subido correctamente!");
                      },
                      error: function(data, status, e) {
                         alert(e);
                         $("#dialogWait").dialog('close');
                      }
                   }
           )
   return false;
}// FIn function ajaxImageUpload(strNomFile)

