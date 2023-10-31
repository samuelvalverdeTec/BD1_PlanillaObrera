USE BD_Tarea3;

delete from Empleado where Id=1;
DBCC CHECKIDENT ('Empleado', RESEED, 0);

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
SELECT * FROM DBErrors;

DECLARE @codigoError1 INT
EXEC ReadAndLoadXML 'D:\Erick_TEC_2S-2023\BD\Scripts-Tarea3\Catalogos2.xml', @codigoError1 OUTPUT;

DECLARE @codigoError2 INT
EXEC Obtener_Empleados_Orden_Alfabetico 1,'localhost','', @codigoError2 OUTPUT;

DECLARE @codigoError3 INT
EXEC Insertar_Empleado 1, 'localhost', 'Erick Kauffmann', 1, '118910818', NULL, 3, 3, @codigoError3 OUTPUT;
DECLARE @codigoError4 INT
EXEC Insertar_Empleado 1, 'localhost', 'Samuel Valverde', 5, '111100111', NULL, 2, 5, @codigoError4 OUTPUT;

DECLARE @codigoError5 INT
EXEC Insertar_Usuario 'erick25', 'ekp2511', 2, 1, @codigoError5 OUTPUT;
DECLARE @codigoError6 INT
EXEC Insertar_Usuario 'samVal', 'sV12345', 2, 2, @codigoError6 OUTPUT;
DECLARE @codigoError7 INT
EXEC Insertar_Usuario 'jUAn000', 'wkla019', 2, 3, @codigoError7 OUTPUT;

DECLARE @codigoError8 INT
EXEC Validar_Usuario 'localhost', 'erick25', 'ekp2511', @codigoError8 OUTPUT;