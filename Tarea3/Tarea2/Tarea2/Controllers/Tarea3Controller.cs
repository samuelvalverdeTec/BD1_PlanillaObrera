using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Tarea3.Models;

namespace Tarea3.Controllers
{
    public class Tarea3Controller : ApiController
    {
        public string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        [HttpPost]
        [Route("empleados")]
        public IHttpActionResult getEmpleados(EmpleadoRequest request)
        {
            EmpleadoListResult result = new EmpleadoListResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Obtener_Empleados_Orden_Alfabetico"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual)); ;
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inFiltroNombre", request.filtroNombre));                 
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.ListaEmpleados = new List<Empleado>();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if(return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Empleado empleado = new Empleado();
                                    empleado.id = Convert.ToInt32(reader["id"]);
                                    empleado.Nombre = reader["Nombre"].ToString();
                                    empleado.idTipoIdentificacion = Convert.ToInt32(reader["idTipoIdentificacion"]);
                                    empleado.Identificacion = reader["Identificacion"].ToString();
                                    empleado.FechaNacimiento = reader["FechaNacimiento"].ToString();
                                    empleado.idPuesto = Convert.ToInt32(reader["idPuesto"]);
                                    empleado.idDepartamento = Convert.ToInt32(reader["idDepartamento"]);
                                    empleado.idUsuario = Convert.ToInt32(reader["idUsuario"]);
                                    empleado.NombrePuesto = reader["NombrePuesto"].ToString();
                                    result.ListaEmpleados.Add(empleado);
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 4;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 1;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }


        [HttpGet]
        [Route("puestos")]
        public IHttpActionResult getPuestos()
        {
            PuestoListResult result = new PuestoListResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Obtener_Puestos"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.ListaPuestos = new List<Puesto>();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Puesto puesto = new Puesto();
                                    puesto.id = Convert.ToInt32(reader["Id"]);
                                    puesto.Nombre = reader["Nombre"].ToString();
                                    puesto.SalarioXHora = Convert.ToDouble(reader["SalarioXHora"]);
                                    result.ListaPuestos.Add(puesto);
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 5;
                            result.Mensaje = "Error inesperado ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 2;
                result.Mensaje = "Error inesperado: " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }


        [HttpGet]
        [Route("departamentos")]
        public IHttpActionResult getDepartamentos()
        {
            DepartamentoListResult result = new DepartamentoListResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Obtener_Departamentos"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.ListaDepartamentos = new List<Departamento>();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Departamento departamento = new Departamento();
                                    departamento.id = Convert.ToInt32(reader["Id"]);
                                    departamento.Nombre = reader["Nombre"].ToString();
                                    result.ListaDepartamentos.Add(departamento);
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 17;
                            result.Mensaje = "Error inesperado ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 18;
                result.Mensaje = "Error inesperado: " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }


        [HttpGet]
        [Route("tiposIdentificacion")]
        public IHttpActionResult getTiposIdentificacion()
        {
            TipoIdentificacionListResult result = new TipoIdentificacionListResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Obtener_TiposIdentificacion"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.ListaTiposIdentificacion = new List<TipoIdentificacion>();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    TipoIdentificacion tipoIdentificacion = new TipoIdentificacion();
                                    tipoIdentificacion.id = Convert.ToInt32(reader["Id"]);
                                    tipoIdentificacion.Nombre = reader["Nombre"].ToString();
                                    result.ListaTiposIdentificacion.Add(tipoIdentificacion);
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 19;
                            result.Mensaje = "Error inesperado ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 20;
                result.Mensaje = "Error inesperado: " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }



        [HttpPost]
        [Route("insertarEmpleado")]
        public IHttpActionResult insertarEmpleado(EmpleadoInsertRequest request)
        {
            EmpleadoInsertResult result = new EmpleadoInsertResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Insertar_Empleado"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual)); ;
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inNombre", request.Nombre));
                        cmd.Parameters.Add(new SqlParameter("@inIdTipoIdentificacion", request.idTipoIdentificacion));
                        cmd.Parameters.Add(new SqlParameter("@inIdentificacion", request.Identificacion));
                        cmd.Parameters.Add(new SqlParameter("@inFechaNacimiento", request.FechaNacimiento));
                        cmd.Parameters.Add(new SqlParameter("@inIdPuesto", request.idPuesto));
                        cmd.Parameters.Add(new SqlParameter("@inIdDepartamento", request.idDepartamento));
                        cmd.Parameters.Add(new SqlParameter("@inUserName", request.UserName));
                        cmd.Parameters.Add(new SqlParameter("@inPassword", request.Password));

                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                result.CodigoError = 0;
                                result.Mensaje = "Se insertó el empleado correctamente";
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                if (resultado == 50003)
                                {
                                    result.Mensaje = "Error insertando: El empleado ya existe";
                                }
                                else if(resultado == 50004)
                                {
                                    result.Mensaje = "Error inesperado: " + resultado;
                                }                                
                            }
                        }
                        else
                        {
                            result.CodigoError = 6;
                            result.Mensaje = "Error inesperado";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 3;
                result.Mensaje = "Error inesperado: " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }




        [HttpPost]
        [Route("usuario")]
        public IHttpActionResult getUsuario(UsuarioRequest request)
        {
            UsuarioResult result = new UsuarioResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Validar_Usuario"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inUsuarioActual", request.parametroNombre));
                        cmd.Parameters.Add(new SqlParameter("@inPassword", request.parametroPassword));
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.Usuario = new Usuario();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Usuario usuario = new Usuario();
                                    usuario.id = Convert.ToInt32(reader["id"]);
                                    usuario.Nombre = reader["UserName"].ToString();
                                    usuario.Password = reader["Password"].ToString();
                                    usuario.TipoUsuario = Convert.ToInt32(reader["TipoUsuario"]);
                                    //usuario.NombreEmpleado = reader["NombreEmpleado"].ToString();
                                    result.Usuario = usuario;
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 7;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 8;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }



        [HttpPost]
        [Route("validarModificarEmpleado")]
        public IHttpActionResult validarModificarEmpleado(EmpleadoValModifRequest request)
        {
            EmpleadoValModifResult result = new EmpleadoValModifResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Validar_Modificar_Empleado"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual));
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inIdentificacion", request.Identificacion));
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.empleado = new Empleado();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Empleado empleado = new Empleado();
                                    empleado.id = Convert.ToInt32(reader["Id"]);
                                    empleado.Nombre = reader["Nombre"].ToString();
                                    empleado.idTipoIdentificacion = Convert.ToInt32(reader["idTipoIdentificacion"]);
                                    empleado.Identificacion = reader["Identificacion"].ToString();
                                    empleado.FechaNacimiento = reader["FechaNacimiento"].ToString();
                                    empleado.idPuesto = Convert.ToInt32(reader["idPuesto"]);
                                    empleado.idDepartamento = Convert.ToInt32(reader["idDepartamento"]);
                                    empleado.NombrePuesto = reader["NombrePuesto"].ToString();
                                    result.empleado = empleado;
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 9;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 10;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }

        //metodo modificar
        [HttpPost]
        [Route("modificarEmpleado")]
        public IHttpActionResult modificarEmpleado(EmpleadoModifRequest request)
        {
            EmpleadoModifResult result = new EmpleadoModifResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Modificar_Empleado"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual));
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inIdEmpleadoBuscado", request.idEmpleadoBuscado));
                        cmd.Parameters.Add(new SqlParameter("@inNombre", request.Nombre));
                        cmd.Parameters.Add(new SqlParameter("@inIdTipoIdentificacion", request.idTipoIdentificacion));
                        cmd.Parameters.Add(new SqlParameter("@inIdentificacion", request.Identificacion));
                        cmd.Parameters.Add(new SqlParameter("@inFechaNacimiento", request.FechaNacimiento));
                        cmd.Parameters.Add(new SqlParameter("@inIdPuesto", request.idPuesto));
                        cmd.Parameters.Add(new SqlParameter("@inIdDepartamento", request.idDepartamento));
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                result.CodigoError = 0;
                                result.Mensaje = "Se modificó el empleado correctamente";
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 13;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 14;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }



        [HttpPost]
        [Route("validarBorrarEmpleado")]
        public IHttpActionResult validarBorrarEmpleado(EmpleadoValDeleteRequest request)
        {
            EmpleadoValDeleteResult result = new EmpleadoValDeleteResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Validar_Borrar_Empleado"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual));
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inIdentificacion", request.Identificacion));
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.empleado = new Empleado();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Empleado empleado = new Empleado();
                                    empleado.id = Convert.ToInt32(reader["Id"]);
                                    empleado.Nombre = reader["Nombre"].ToString();
                                    empleado.idTipoIdentificacion = Convert.ToInt32(reader["idTipoIdentificacion"]);
                                    empleado.Identificacion = reader["Identificacion"].ToString();
                                    empleado.FechaNacimiento = reader["FechaNacimiento"].ToString();
                                    empleado.idPuesto = Convert.ToInt32(reader["idPuesto"]);
                                    empleado.idDepartamento = Convert.ToInt32(reader["idDepartamento"]);
                                    empleado.NombrePuesto = reader["NombrePuesto"].ToString();
                                    result.empleado = empleado;
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 11;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 12;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }

        //metodo borrar
        [HttpPost]
        [Route("borrarEmpleado")]
        public IHttpActionResult borrarEmpleado(EmpleadoDeleteRequest request)
        {
            EmpleadoDeleteResult result = new EmpleadoDeleteResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Borrar_Empleado"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual));
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inIdentificacion", request.Identificacion));
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                result.CodigoError = 0;
                                result.Mensaje = "Se borró el empleado correctamente";
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 15;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 16;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }



        // GET api/values
        [HttpGet]
        [Route("get")]
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/values/5
        [HttpGet]
        [Route("getVal")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        public void Delete(int id)
        {
        }
    }
}
