/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function rhh_UpIncidencias() {
}

function upFileIncid() {
    $("#dialogWait").dialog('open');

    var File = document.getElementById("INCID_FILE");
    if (File.value == "") {
        alert("Requiere seleccionar un archivo");
        File.focus();
    } else {
        if (Right(File.value.toUpperCase(), 3) == "XLS") {
            $.ajaxFileUpload({
                url: 'ERP_UpIncidencias.jsp',
                secureuri: false,
                fileElementId: "INCID_FILE",
                dataType: 'json',
                success: function (data, status)
                {
                    if (typeof (data.error) != 'undefined') {
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
                error: function (data, status, e) {
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
}

