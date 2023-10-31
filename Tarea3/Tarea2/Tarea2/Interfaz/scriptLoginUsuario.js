$(document).ready(function() {
    // API URL to fetch articles
    const apiUrlUsuario = 'http://localhost/Tarea3/usuario';

    var postIP = "localhost";


    function validarUsuario(postIP, NombreUsuario, Password) {
        $.ajax({
        type: "POST",
        url: apiUrlUsuario,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "postIP": postIP,
            "parametroNombre": NombreUsuario,
            "parametroPassword": Password
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                if(data.Usuario.TipoUsuario == 1){
                    alert('Bienvenido usuario administrador');
                    window.location = "./empleados.html?idUsuario="+data.Usuario.id;
                }
                else{
                    alert('Bienvenido usuario empleado');
                }
            }
            else{
                alert('Error: ' + data.CodigoError + ' Usuario o Password incorrecto');
            }
        },
        error: function(error) {
            console.error('Error buscando usuario:', error);
        }
        });        
    }


    $('#btnValidarUsuario').click(function(){
        var UserName = $('#txtUserName').val();
        var Password = $('#txtPassword').val();
        // $('#aioConceptName').find(":selected").val();
        validarUsuario(postIP, UserName, Password);
    })


});
