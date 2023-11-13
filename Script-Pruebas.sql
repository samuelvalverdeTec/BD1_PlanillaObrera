USE BD_Tarea3;

--STORED PROCEDURE QUE REALIZA LA SIMULACION
DECLARE @codigoError INT
EXEC Simulacion '2023-07-06', '2023-11-30', @codigoError OUTPUT;


--BORRADO DE TABLAS PARA REPETIR PRUEBAS
delete from MovimientoPlanilla where Id>0;
DBCC CHECKIDENT ('MovimientoPlanilla', RESEED, 0);

delete from SemanaPlanillaXEmpleado where Id>0;
DBCC CHECKIDENT ('SemanaPlanillaXEmpleado', RESEED, 0);

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

delete from EventLog where Id>0;
DBCC CHECKIDENT ('EventLog', RESEED, 0);

delete from Usuario where Id>3;
DBCC CHECKIDENT ('Usuario', RESEED, 3);



--SELECTS DE TODAS LAS TABLAS PARA HACER REVISIONES
SELECT * FROM Empleado --where Id = 1; --Muestra toda la tabla
SELECT * FROM Puesto --where Id = 1; --Muestra toda la tabla
SELECT * FROM Departamento; --Muestra toda la tabla
SELECT * FROM TipoIdentificacion; --Muestra toda la tabla
SELECT * FROM Usuario; --Muestra toda la tabla
SELECT * FROM TipoDeduccion; --Muestra toda la tabla
SELECT * FROM Feriado; --Muestra toda la tabla
SELECT * FROM TipoJornada; --Muestra toda la tabla
SELECT * FROM TipoMovimiento; --Muestra toda la tabla
SELECT * FROM DeduccionXEmpleado; --Muestra toda la tabla
SELECT * FROM JornadaXEmpleadoXSemana; --Muestra toda la tabla
SELECT * FROM MarcaAsistencia --where idEmpleado = 14 and FechaInicio >= '2023-09-28' and FechaInicio < '2023-10-06'; --Muestra toda la tabla
SELECT * FROM MesPlanilla; --Muestra toda la tabla
SELECT * FROM SemanaPlanilla --where Id = 14; --Muestra toda la tabla
SELECT * FROM SemanaPlanillaXEmpleado --where idEmpleado = 1; --Muestra toda la tabla
SELECT * FROM MovimientoPlanilla --where idEmpleado = 1; --Muestra toda la tabla
SELECT * FROM DBErrors;
SELECT * FROM EventLog;


--STORED PROCEDURE QUE LEE EL CATALOGO DE INFORMACION INICIAL DE LA BD
DECLARE @codigoError1 INT
EXEC ReadAndLoadXML 'D:\Erick_TEC_2S-2023\BD\Scripts-Tarea3\Catalogos2.xml', @codigoError1 OUTPUT;



--PRUEBAS INICIALES
--DECLARE @codigoError2 INT
--EXEC Obtener_Empleados_Orden_Alfabetico 1,'localhost','', @codigoError2 OUTPUT;

--DECLARE @codigoError3 INT
--EXEC Insertar_Empleado 1, 'localhost', 'Erick Kauffmann', 1, '118910818', NULL, 3, 3, 'erick25', 'ekp2511', @codigoError3 OUTPUT;
--DECLARE @codigoError4 INT
--EXEC Insertar_Empleado 1, 'localhost', 'Samuel Valverde', 5, '111100111', NULL, 2, 5, 'samVal123', 'SV12345', @codigoError4 OUTPUT;

--DECLARE @codigoError5 INT
--EXEC Insertar_Usuario 'erick25', 'ekp2511', 2, 1, @codigoError5 OUTPUT;
--DECLARE @codigoError6 INT
--EXEC Insertar_Usuario 'samVal', 'sV12345', 2, 2, @codigoError6 OUTPUT;
--DECLARE @codigoError7 INT
--EXEC Insertar_Usuario 'jUAn000', 'wkla019', 2, 3, @codigoError7 OUTPUT;

--DECLARE @codigoError8 INT
--EXEC Validar_Usuario 'localhost', 'erick25', 'ekp2511', @codigoError8 OUTPUT;
--DECLARE @codigoError9 INT
--EXEC Validar_Usuario 'localhost', 'Goku', '12345', @codigoError9 OUTPUT;

/*
DECLARE @FechaAct DATE, @FechaFin DATE
SELECT @FechaAct = CONVERT(DATE, '2023-07-06')
SELECT @FechaFin = CONVERT(DATE, '2023-11-30')
WHILE (@FechaAct <= @FechaFin)
BEGIN

	DECLARE @codigoError10 INT
	--DECLARE @Fecha DATE
	--SELECT @Fecha = CONVERT(DATE, '2023-07-06');
	EXEC ReadAndLoadXMLOperaciones 'D:\Erick_TEC_2S-2023\BD\Scripts-Tarea3\OperacionesXML.xml', 
	@FechaAct,
	--'2023-07-06',
	@codigoError10 OUTPUT;

	DECLARE @codigoError11 INT
	--DECLARE @Fecha DATE
	--SELECT @Fecha = CONVERT(DATE, '2023-07-06');
	EXEC Calcular_Pagos @FechaAct, --'2023-07-06',
	@codigoError11 OUTPUT;

	SELECT @FechaAct = DATEADD(DAY, 1, @FechaAct)
END
*/