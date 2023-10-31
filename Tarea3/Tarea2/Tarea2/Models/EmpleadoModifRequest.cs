using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tarea3.Models
{
    public class EmpleadoModifRequest {
        public int idUsuarioActual;
        public string postIP;
        public int idEmpleadoBuscado;
        public string Nombre;
        public int idTipoIdentificacion;
        public string Identificacion;
        public string FechaNacimiento;
        public int idPuesto;
        public int idDepartamento;
    }
}