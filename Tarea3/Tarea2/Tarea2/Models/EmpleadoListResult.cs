using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tarea3.Models
{
    public class EmpleadoListResult
    {
        public int CodigoError;
        public string Mensaje;
        public List<Empleado> ListaEmpleados;
    }
}