$(document).ready(function() {
    // API URL to fetch articles
    const apiUrlEmpleados = 'http://localhost/Tarea3/empleados';
    const apiUrlPuestos = 'http://localhost/Tarea3/puestos';
    const apiUrlDepartamentos = 'http://localhost/Tarea3/departamentos';
    const apiUrlTiposIdentificacion = 'http://localhost/Tarea3/tiposIdentificacion';
    const apiUrlInsertar = 'http://localhost/Tarea3/insertarEmpleado';
    const apiUrlValModif = 'http://localhost/Tarea3/validarModificarEmpleado';
    const apiUrlModificar = 'http://localhost/Tarea3/modificarEmpleado';
    const apiUrlValBorrar = 'http://localhost/Tarea3/validarBorrarEmpleado';
    const apiUrlBorrar = 'http://localhost/Tarea3/borrarEmpleado';
    //const apiUrlUsuario = 'http://localhost/Tarea3/usuario';

    var idUsuarioAct = 1;//getQueryStringValues('idUsuario');
    var postIP = "localhost";
    var idEmpleadoBuscado = 0;
    //console.log(getQueryStringValues('idUsuario'));

    function mostrarPuestos() {
        $.ajax({
            url: apiUrlPuestos,
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                const puestosListInsertar = $('#PuestosInsertar');
                const puestosListModificar = $('#PuestosModif');
                puestosListInsertar.empty();
                data = JSON.parse(data);
                puestosListInsertar.append($('<option>', {
                    value: -1,
                    text: 'seleccione un puesto'
                }));
                puestosListModificar.append($('<option>', {
                    value: -1,
                    text: 'seleccione un puesto'
                }));
                if(data.CodigoError == 0){
                    // Iterar lista de articulos
                    data.ListaPuestos.forEach(function(puesto) {
                        // Create list item for each article
                        puestosListInsertar.append($('<option>', {
                            value: puesto.id,
                            text: puesto.Nombre
                        }));
                        puestosListModificar.append($('<option>', {
                            value: puesto.id,
                            text: puesto.Nombre
                        }));
                    });
                }
                else{
                    alert('Error: ' + data.CodigoError);
                }
            },
            error: function(error) {
                console.error('Error buscando puestos:', error);
            }
        });
    }

    function mostrarDepartamentos() {
        $.ajax({
            url: apiUrlDepartamentos,
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                const departamentosListInsertar = $('#DepartamentosInsertar');
                const departamentosListModificar = $('#DepartamentosModif');
                departamentosListInsertar.empty();
                data = JSON.parse(data);
                departamentosListInsertar.append($('<option>', {
                    value: -1,
                    text: 'seleccione un departamento'
                }));
                departamentosListModificar.append($('<option>', {
                    value: -1,
                    text: 'seleccione un departamento'
                }));
                if(data.CodigoError == 0){
                    // Iterar lista de articulos
                    data.ListaDepartamentos.forEach(function(departamento) {
                        // Create list item for each article
                        departamentosListInsertar.append($('<option>', {
                            value: departamento.id,
                            text: departamento.Nombre
                        }));
                        departamentosListModificar.append($('<option>', {
                            value: departamento.id,
                            text: departamento.Nombre
                        }));
                    });
                }
                else{
                    alert('Error: ' + data.CodigoError);
                }
            },
            error: function(error) {
                console.error('Error buscando departamentos:', error);
            }
        });
    }

    function mostrarTiposIdentificacion() {
        $.ajax({
            url: apiUrlTiposIdentificacion,
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                const tiposIdentificacionListInsertar = $('#IdTipoIdentificacionInsertar');
                const tiposIdentificacionListModificar = $('#IdTipoIdentificacionModif');
                tiposIdentificacionListInsertar.empty();
                data = JSON.parse(data);
                tiposIdentificacionListInsertar.append($('<option>', {
                    value: -1,
                    text: 'seleccione un tipo de identificacion'
                }));
                tiposIdentificacionListModificar.append($('<option>', {
                    value: -1,
                    text: 'seleccione un tipo de identificacion'
                }));
                if(data.CodigoError == 0){
                    // Iterar lista de articulos
                    data.ListaTiposIdentificacion.forEach(function(tipoIdentificacion) {
                        // Create list item for each article
                        tiposIdentificacionListInsertar.append($('<option>', {
                            value: tipoIdentificacion.id,
                            text: tipoIdentificacion.Nombre
                        }));
                        tiposIdentificacionListModificar.append($('<option>', {
                            value: tipoIdentificacion.id,
                            text: tipoIdentificacion.Nombre
                        }));
                    });
                }
                else{
                    alert('Error: ' + data.CodigoError);
                }
            },
            error: function(error) {
                console.error('Error buscando tipos de identificacion:', error);
            }
        });
    }



    function mostrarEmpleados(idUsuarioAct, postIP, filtroNombre) {
        $.ajax({
        type: "POST",
        url: apiUrlEmpleados,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "filtroNombre": filtroNombre
        }),
        success: function(data) {
            const empleadosList = $('#listEmpleado');
            empleadosList.empty();
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                // Iterar lista de articulos

                const listItem = $('<li class="list-group-item"></li>');

                // Create content for the list item
                const nombreEmpleado = $('<div class="col-3"><b>Nombre</b> </div>');
                const identificacionEmpleado = $('<div class="col-3"><b>Identificacion</b> </div>');
                const puestoEmpleado = $('<div class="col-3"><b>Puesto</b> </div>');

                const divEmpleado = ($('<div class="row"> </div>'));
                listItem.append(divEmpleado);
                divEmpleado.append(nombreEmpleado);
                divEmpleado.append(identificacionEmpleado);
                divEmpleado.append(puestoEmpleado);

                empleadosList.append(listItem);

                data.ListaEmpleados.forEach(function(empleado) {
                    // Create list item for each article
                    const listItem = $('<li class="list-group-item"></li>');

                    // Create content for the list item
                    const nombreEmpleado = $('<div class="col-3">' + empleado.Nombre + '</div>');
                    const identificacionEmpleado = $('<div class="col-3">' + empleado.Identificacion + '</div>');
                    const puestoEmpleado = $('<div class="col-3">' + empleado.NombrePuesto + '</div>');

                    const divEmpleado = ($('<div class="row"> </div>'));
                    listItem.append(divEmpleado);
                    divEmpleado.append(nombreEmpleado);
                    divEmpleado.append(identificacionEmpleado);
                    divEmpleado.append(puestoEmpleado);

                    empleadosList.append(listItem);
                });
            }
            else{
                alert('Error: ' + data.CodigoError);
            }
        },
        error: function(error) {
            console.error('Error buscando empleados:', error);
        }
        });        
    }


    function insertarEmpleado(idUsuarioAct, postIP, nombre, idTipoIdentificacion, identificacion, fechaNacimiento, idPuesto, idDepartamento) {
        $.ajax({
        type: "POST",
        url: apiUrlInsertar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "Nombre": nombre,
            "idTipoIdentificacion": idTipoIdentificacion,
            "Identificacion": identificacion,
            "FechaNacimiento": fechaNacimiento,
            "idPuesto": idPuesto,
            "idDepartamento": idDepartamento
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                alert("datos insertados ");
                mostrarEmpleados(idUsuarioAct, postIP, '');
                limpiarForm();
            }
            else{
                alert(data.Mensaje);
                //limpiarForm();
            }
        },
        error: function(error) {
        alert("error insertando");
        console.error('Error buscando empleados:', error);
        limpiarForm();
        }
        });        
    }

    function validarEmpleadoModif(idUsuarioAct, postIP, identificacion) {
        $('#Modificar_PopUp #datosModif').hide();
        $('#Modificar_PopUp #btnModificar').hide();
        $.ajax({
        type: "POST",
        url: apiUrlValModif,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "Identificacion": identificacion,
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){

                idEmpleadoBuscado = data.empleado.id;

                const nombreEmpleado = data.empleado.Nombre;
                const idTipoIdentificacion = data.empleado.idTipoIdentificacion;
                const identificacionEmpleado = data.empleado.Identificacion;
                const fechaNacimientoEmpleado = data.empleado.FechaNacimiento;
                const idPuesto = data.empleado.idPuesto;
                const idDepartamento = data.empleado.idDepartamento;

                mostrarInfoModificar(nombreEmpleado, idTipoIdentificacion, identificacionEmpleado, fechaNacimientoEmpleado, idPuesto, idDepartamento);

                $('#Modificar_PopUp #datosModif').show();
                $('#Modificar_PopUp #btnModificar').show();
            }
            else{
                alert('Error: ' + data.CodigoError + ' No existe un empleado con esa identificacion');
            }
        },
        error: function(error) {
            console.error('Error buscando empleado:', error);
        }
        });        
    }

    function modificarEmpleado(idUsuarioAct, postIP, idEmpleadoBuscado, nombre, idTipoIdentificacion, identificacion, fechaNacimiento, idPuesto, idDepartamento) {
        $.ajax({
        type: "POST",
        url: apiUrlModificar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "idEmpleadoBuscado": idEmpleadoBuscado,
            "Nombre": nombre,
            "idTipoIdentificacion": idTipoIdentificacion,
            "Identificacion": identificacion,
            "FechaNacimiento": fechaNacimiento,
            "idPuesto": idPuesto,
            "idDepartamento": idDepartamento
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                alert("empleado modificado ");
                mostrarEmpleados(idUsuarioAct, postIP, '');
                limpiarFormModif();
                $('#Modificar_PopUp #datosModif').hide();
                $('#Modificar_PopUp #btnModificar').hide();
            }
            else{
                alert(data.Mensaje);
                //limpiarFormModif();
            }
        },
        error: function(error) {
        alert("error modificando");
        console.error('Error buscando empleados:', error);
        limpiarFormModif();
        }
        });        
    }


    function validarEmpleadoBorrar(idUsuarioAct, postIP, identificacion) {
        $('#Borrar_PopUp #datosBorrar').hide();
        $('#Borrar_PopUp #btnBorrar').hide();
        $.ajax({
        type: "POST",
        url: apiUrlValBorrar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "Identificacion": identificacion,
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){

                const nombreEmpleado = data.empleado.Nombre;
                const idTipoIdentificacion = data.empleado.idTipoIdentificacion;
                const identificacionEmpleado = data.empleado.Identificacion;
                const fechaNacimientoEmpleado = data.empleado.FechaNacimiento;
                const idPuesto = data.empleado.idPuesto;
                const idDepartamento = data.empleado.idDepartamento;
                
                mostrarInfoBorrar(nombreEmpleado, idTipoIdentificacion, identificacionEmpleado, fechaNacimientoEmpleado, idPuesto, idDepartamento)
                $('#Borrar_PopUp #datosBorrar').show();
                $('#Borrar_PopUp #btnBorrar').show();
            }
            else{
                alert('Error: ' + data.CodigoError + ' No existe un empleado con esa identificacion');
            }
        },
        error: function(error) {
            console.error('Error buscando empleado:', error);
        }
        });        
    }

    function borrarEmpleado(idUsuarioAct, postIP, identificacion) {
        $.ajax({
        type: "POST",
        url: apiUrlBorrar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "Identificacion": identificacion,
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                alert("empleado borrado ");
                mostrarEmpleados(idUsuarioAct, postIP, '');
                limpiarFormBorrar();
                $('#Borrar_PopUp #datosBorrar').hide();
                $('#Borrar_PopUp #btnBorrar').hide();
            }
            else{
                alert(data.Mensaje);
                //limpiarFormBorrar();
            }
        },
        error: function(error) {
        alert("error borrando");
        console.error('Error buscando empleados:', error);
        limpiarFormModif();
        }
        });        
    }


    function getQueryStringValues(key) {
        var arrParamValues = [];
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < url.length; i++) {
            var arrParamInfo = url[i].split('=');
            if (arrParamInfo[0] == key || arrParamInfo[0] == key+'[]') {
                arrParamValues.push(decodeURIComponent(arrParamInfo[1]));
            }
        }
        return (arrParamValues.length > 0 ? (arrParamValues.length == 1 ? arrParamValues[0] : arrParamValues) : null);
    }


    


    mostrarPuestos();
    mostrarDepartamentos();
    mostrarTiposIdentificacion();
    mostrarEmpleados(idUsuarioAct, postIP, '');



    function limpiarForm(){
        $('#Insertar_PopUp #PuestosInsertar').val(-1);
        $('#Insertar_PopUp #DepartamentosInsertar').val(-1);
        $('#Insertar_PopUp #IdTipoIdentificacionInsertar').val(-1);
        $('#Insertar_PopUp #txtNombreEmpleado').val("");
        $('#Insertar_PopUp #txtIdentificacionEmpleado').val("");
        $('#Insertar_PopUp #txtFechaNacimientoEmpleado').val("");
    }

    function limpiarFormModif(){
        $('#Modificar_PopUp #txtIdentificacionModif').val("");
        $('#Modificar_PopUp #PuestosModif').val(-1);
        $('#Modificar_PopUp #DepartamentosModif').val(-1);
        $('#Modificar_PopUp #IdTipoIdentificacionModif').val(-1);
        $('#Modificar_PopUp #txtNombreEmpleadoModif').val("");
        $('#Modificar_PopUp #txtIdentificacionEmpleadoModif').val("");
        $('#Modificar_PopUp #txtFechaNacimientoEmpleadoModif').val("");
    }

    function limpiarFormBorrar(){
        $('#Borrar_PopUp #txtIdentificacionBorrar').val("");
        $('#Borrar_PopUp #PuestoEmpleadoBorrar').text("");
        $('#Borrar_PopUp #DepartamentoEmpleadoBorrar').text("");
        $('#Borrar_PopUp #IdTipoIdentificacionBorrar').text("");
        $('#Borrar_PopUp #txtNombreEmpleadoModif').text("");
        $('#Borrar_PopUp #txtIdentificacionEmpleadoModif').text("");
        $('#Borrar_PopUp #txtFechaNacimientoEmpleadoModif').text("");
    }

    function mostrarInfoModificar(nombreEmpleado, idTipoIdentificacion, identificacion, fechaNacimiento, idPuesto, idDepartamento){
        $('#Modificar_PopUp #txtNombreEmpleadoModif').val(nombreEmpleado);
        $('#Modificar_PopUp #IdTipoIdentificacionModif').val(idTipoIdentificacion);
        $('#Modificar_PopUp #txtIdentificacionEmpleadoModif').val(identificacion);
        $('#Modificar_PopUp #txtFechaNacimientoEmpleadoModif').val(fechaNacimiento);
        $('#Modificar_PopUp #PuestosModif').val(idPuesto);
        $('#Modificar_PopUp #DepartamentosModif').val(idDepartamento);
    }
    
    function mostrarInfoBorrar(nombreEmpleado, idTipoIdentificacion, identificacionEmpleado, fechaNacimientoEmpleado, idPuesto, idDepartamento){
        $('#Borrar_PopUp #PuestoEmpleadoBorrar').text(idPuesto);
        $('#Borrar_PopUp #DepartamentoEmpleadoBorrar').text(idDepartamento);
        $('#Borrar_PopUp #IdTipoIdentificacionBorrar').text(idTipoIdentificacion);
        $('#Borrar_PopUp #txtNombreEmpleadoModif').text(nombreEmpleado);
        $('#Borrar_PopUp #txtIdentificacionEmpleadoModif').text(identificacionEmpleado);
        $('#Borrar_PopUp #txtFechaNacimientoEmpleadoModif').text(fechaNacimientoEmpleado);
    }

    function isNumeric(str) {
        if (typeof str != "string"){
            return false // we only process strings!  
        } 
        return !isNaN(str) && // use type coercion to parse the entirety of the string (`parseFloat` alone does not do this)...
               !isNaN(parseFloat(str)) // ...and ensure strings of whitespace fail
    }

    $('#Insertar_PopUp').on('show.bs.modal', function (event) {
        limpiarForm();
    })
    $('#Modificar_PopUp').on('show.bs.modal', function (event) {
        limpiarFormModif();
    })
    $('#Borrar_PopUp').on('show.bs.modal', function (event) {
        limpiarFormBorrar();
    })

    $('#Insertar_PopUp #btnInsertar').click(function(){
        var idPuesto = $('#Insertar_PopUp #PuestosInsertar').find(":selected").val();
        var idDepartamento = $('#Insertar_PopUp #DepartamentosInsertar').find(":selected").val();
        var idTipoIdentificacion = $('#Insertar_PopUp #IdTipoIdentificacionInsertar').find(":selected").val();
        var nombreEmpleado = $('#Insertar_PopUp #txtNombreEmpleado').val();
        var identificacionEmpleado = $('#Insertar_PopUp #txtIdentificacionEmpleado').val();
        var fechaNacimientoEmpleado = $('#Insertar_PopUp #txtFechaNacimientoEmpleado').val();
        //alert("Nombre: " + nombreArticulo + "   Precio: " + precioArticulo);
        if(idPuesto == -1 || idDepartamento == -1 || idTipoIdentificacion == -1){
            alert("Seleccione alguna opcion para puesto, departamento y tipo de identificacion");
        }
        else{
            if(!isNumeric(nombreEmpleado)){
                insertarEmpleado(idUsuarioAct, postIP, nombreEmpleado, idTipoIdentificacion, identificacionEmpleado, fechaNacimientoEmpleado, idPuesto, idDepartamento);
            }
            else{
                alert("El nombre debe ser un string");
            }
        }
    })

    //$('#Val_Modif_PopUp #btnValModif').click(function(){
    //    var codigoArticulo = $('#Val_Modif_PopUp #txtCodigoModif').val();
    //    validarArticuloModif(idUsuarioAct, postIP, codigoArticulo);
    //})

    $('#openBorrar').click(function(){
        $('#Borrar_PopUp #datosBorrar').hide();
        $('#Borrar_PopUp #btnBorrar').hide();
        $('#Borrar_PopUp').modal();
    })

    $('#openModif').click(function(){
        $('#Modificar_PopUp #datosModif').hide();
        $('#Modificar_PopUp #btnModificar').hide();
        $('#Modificar_PopUp').modal();
    })


    $('#Modificar_PopUp #btnValModif').click(function(){
        var identificacionEmpleado = $('#Modificar_PopUp #txtIdentificacionModif').val();
        validarEmpleadoModif(idUsuarioAct, postIP, identificacionEmpleado);
    })

    $('#Modificar_PopUp #btnModificar').click(function(){
        var idPuesto = $('#Modificar_PopUp #PuestosModif').find(":selected").val();
        var idDepartamento = $('#Modificar_PopUp #DepartamentosModif').find(":selected").val();
        var idTipoIdentificacion = $('#Modificar_PopUp #IdTipoIdentificacionModif').find(":selected").val();
        var nombreEmpleado = $('#Modificar_PopUp #txtNombreEmpleadoModif').val();
        var identificacionEmpleado = $('#Modificar_PopUp #txtIdentificacionEmpleadoModif').val();
        var fechaNacimientoEmpleado = $('#Modificar_PopUp #txtFechaNacimientoEmpleadoModif').val();
        if(idPuesto == -1 || idDepartamento == -1 || idTipoIdentificacion == -1){
            alert("Seleccione alguna opcion para puesto, departamento y tipo de identificacion");
        }
        else{
            if(!isNumeric(nombreEmpleado)){
                modificarEmpleado(idUsuarioAct, postIP, idEmpleadoBuscado, nombreEmpleado, idTipoIdentificacion, identificacionEmpleado, fechaNacimientoEmpleado, idPuesto, idDepartamento);
            }
            else{
                alert("El nombre debe ser un string");
            }
        }
    })

    $('#Borrar_PopUp #btnValBorrar').click(function(){
        var identificacionEmpleado = $('#Borrar_PopUp #txtIdentificacionBorrar').val();
        validarEmpleadoBorrar(idUsuarioAct, postIP, identificacionEmpleado);
    })

    $('#Borrar_PopUp #btnBorrar').click(function(){
        var identificacionEmpleado = $('#Borrar_PopUp #txtIdentificacionBorrar').val();
        borrarEmpleado(idUsuarioAct, postIP, identificacionEmpleado);
    })


    $('#btnFiltrarNombre').click(function(){
        var nombreEmpleado = $('#fname').val();
        mostrarEmpleados(idUsuarioAct, postIP, nombreEmpleado);
    })
    


});
