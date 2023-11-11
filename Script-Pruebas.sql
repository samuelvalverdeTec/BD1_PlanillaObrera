USE BD_Tarea3;

delete from DeduccionXEmpleado where Id>0;
DBCC CHECKIDENT ('DeduccionXEmpleado', RESEED, 0);

delete from MarcaAsistencia where Id>0;
DBCC CHECKIDENT ('MarcaAsistencia', RESEED, 0);

delete from JornadaXEmpleadoXSemana where Id>0;
DBCC CHECKIDENT ('JornadaXEmpleadoXSemana', RESEED, 0);

delete from SemanaPlanilla where Id>0;
DBCC CHECKIDENT ('SemanaPlanilla', RESEED, 0);

delete from MesPlanilla where Id>0;
DBCC CHECKIDENT ('MesPlanilla', RESEED, 0);

delete from Empleado where Id>0;
DBCC CHECKIDENT ('Empleado', RESEED, 0);

delete from Usuario where Id>3;
DBCC CHECKIDENT ('Usuario', RESEED, 3);

delete from Puesto where Id=1;
--DBCC CHECKIDENT ('Puesto', RESEED, 0);

delete from Departamento where Id=1;
--DBCC CHECKIDENT ('Departamento', RESEED, 0);

delete from TipoIdentificacion where Id=1;
--DBCC CHECKIDENT ('TipoIdentificacion', RESEED, 0);

INSERT dbo.Empleado (Nombre, idTipoIdentificacion, Identificacion, FechaNacimiento, idPuesto, idDepartamento) 
VALUES ('Erick',1,'118910818', NULL, 1, 1);

INSERT dbo.Puesto (Id, Nombre, SalarioXHora)
VALUES (1, 'Jefe', 5000000);

INSERT dbo.Departamento (Id, Nombre)
VALUES (1, 'Programacion');

INSERT dbo.TipoIdentificacion (Id, Nombre)
VALUES (1, 'Cedula');

SELECT * FROM Empleado; --Muestra toda la tabla
SELECT * FROM Puesto; --Muestra toda la tabla
SELECT * FROM Departamento; --Muestra toda la tabla
SELECT * FROM TipoIdentificacion; --Muestra toda la tabla
SELECT * FROM Usuario; --Muestra toda la tabla
SELECT * FROM TipoDeduccion; --Muestra toda la tabla
SELECT * FROM Feriado; --Muestra toda la tabla
SELECT * FROM TipoJornada; --Muestra toda la tabla
SELECT * FROM TipoMovimiento; --Muestra toda la tabla
SELECT * FROM DeduccionXEmpleado; --Muestra toda la tabla
SELECT * FROM JornadaXEmpleadoXSemana; --Muestra toda la tabla
SELECT * FROM MarcaAsistencia; --Muestra toda la tabla
SELECT * FROM MesPlanilla; --Muestra toda la tabla
SELECT * FROM SemanaPlanilla; --Muestra toda la tabla
SELECT * FROM DBErrors;

DECLARE @codigoError1 INT
EXEC ReadAndLoadXML 'D:\Erick_TEC_2S-2023\BD\Scripts-Tarea3\Catalogos2.xml', @codigoError1 OUTPUT;

DECLARE @codigoError2 INT
EXEC Obtener_Empleados_Orden_Alfabetico 1,'localhost','', @codigoError2 OUTPUT;

DECLARE @codigoError3 INT
EXEC Insertar_Empleado 1, 'localhost', 'Erick Kauffmann', 1, '118910818', NULL, 3, 3, 'erick25', 'ekp2511', @codigoError3 OUTPUT;
DECLARE @codigoError4 INT
EXEC Insertar_Empleado 1, 'localhost', 'Samuel Valverde', 5, '111100111', NULL, 2, 5, 'samVal123', 'SV12345', @codigoError4 OUTPUT;

--DECLARE @codigoError5 INT
--EXEC Insertar_Usuario 'erick25', 'ekp2511', 2, 1, @codigoError5 OUTPUT;
--DECLARE @codigoError6 INT
--EXEC Insertar_Usuario 'samVal', 'sV12345', 2, 2, @codigoError6 OUTPUT;
--DECLARE @codigoError7 INT
--EXEC Insertar_Usuario 'jUAn000', 'wkla019', 2, 3, @codigoError7 OUTPUT;

DECLARE @codigoError8 INT
EXEC Validar_Usuario 'localhost', 'erick25', 'ekp2511', @codigoError8 OUTPUT;
DECLARE @codigoError9 INT
EXEC Validar_Usuario 'localhost', 'Goku', '12345', @codigoError9 OUTPUT;


DECLARE @codigoError10 INT
--DECLARE @Fecha DATE
--SELECT @Fecha = CONVERT(DATE, '2023-07-06');
EXEC ReadAndLoadXMLOperaciones 'D:\Erick_TEC_2S-2023\BD\Scripts-Tarea3\OperacionesV2.xml', 
--@Fecha,
'2023-07-07',
@codigoError10 OUTPUT;
