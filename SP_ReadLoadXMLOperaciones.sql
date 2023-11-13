USE [BD_Tarea3]
GO
/****** Object:  StoredProcedure [dbo].[ReadAndLoadXML]    Script Date: 11/6/2023 12:07:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Samuel Valverde A.
--				Erick Kauffmann
-- Create date: 30/10/2023
-- Description:	Read and Load XML Data in SQL Tables
-- =============================================

ALTER PROCEDURE [dbo].[ReadAndLoadXMLOperaciones]
	-- Add the parameters for the stored procedure here
	@inRutaXML NVARCHAR(500)
	, @inFecha VARCHAR(50)
	, @outResultCode INT OUTPUT
AS

BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		SET @outResultCode = 0;  -- no error code

		DECLARE @Datos XML	-- Variable de tipo XML

		DECLARE @outDatos xml -- parametro de salida del sql dinamico

		-- Para cargar el archivo con una variable, CHAR(39) son comillas simples
		DECLARE @Comando NVARCHAR(500)= 'SELECT @Datos = D FROM OPENROWSET (BULK '  + CHAR(39) + @inRutaXML + CHAR(39) + ', SINGLE_BLOB) AS Datos(D)' -- comando que va a ejecutar el sql dinamico

		DECLARE @Parametros NVARCHAR(500)
		SET @Parametros = N'@Datos xml OUTPUT' --parametros del sql dinamico

		EXECUTE sp_executesql @Comando, @Parametros, @Datos = @outDatos OUTPUT -- ejecutamos el comando que hicimos dinamicamente

		SET @Datos = @outDatos -- le damos el parametro de salida del sql dinamico a la variable para el resto del procedure
    
		DECLARE @hdoc int /*Creamos hdoc que va a ser un identificador*/
    
		EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/



		BEGIN TRANSACTION tProcesamientoXMLOperaciones
		

		DECLARE @FechaActMes DATE
		, @NumDia INT
		, @NumMes INT
		, @fecha_dia_uno DATE
		, @NumDiasMes INT
		, @FechaInicioMes DATE
		, @FechaFinMes DATE 
		, @FechaInicioSigMes DATE
		, @FechaFinSigMes DATE
		--SEMANA
		, @FechaAct DATE
		, @NumDiaSemana INT
		, @FechaInicioSemana DATE
		, @FechaFinSemana DATE 
		, @FechaInicioSigSemana DATE
		, @FechaFinSigSemana DATE
		--IDs
		,@idMes INT
		,@idMesSig INT
		,@idSemana INT
		,@idSemanaSig INT


		SELECT @FechaAct = CONVERT(DATE, @inFecha)
		SELECT @NumDiaSemana = DATEPART(weekday, @FechaAct)
		--SELECT @NumDiaSemana as NumeroDiaSemana
		IF @NumDiaSemana <= 5
		BEGIN
			SELECT @FechaFinSemana = DATEADD(DAY, 5-@NumDiaSemana, @FechaAct)
			SELECT @FechaInicioSemana = DATEADD(DAY, -7, @FechaFinSemana)
		END
		ELSE
		BEGIN
			SELECT @FechaInicioSemana = DATEADD(DAY, 5-@NumDiaSemana, @FechaAct)
			SELECT @FechaFinSemana = DATEADD(DAY, 7, @FechaInicioSemana)
		END


		SELECT @FechaActMes = CONVERT(DATE, @FechaFinSemana)
		SELECT @NumDia = DAY(@FechaActMes)
		SELECT @NumMes = MONTH(@FechaActMes)
		SELECT @fecha_dia_uno = DATEADD(DAY, -DATEPART(DAY, @FechaActMes) +1, @FechaActMes)
		SELECT @NumDiasMes = DATEDIFF(DD, @fecha_dia_uno, DATEADD(MM, 1, @fecha_dia_uno))
		SELECT @FechaInicioMes = DATEADD(DAY, -@NumDia+1, @FechaActMes)
		SELECT @FechaFinMes = DATEADD(DAY, @NumDiasMes-@NumDia, @FechaActMes)


		
		
		SELECT @FechaInicioSigSemana = @FechaFinSemana
			 , @FechaFinSigSemana = DATEADD(DAY, 7, @FechaInicioSigSemana)
			 , @FechaInicioSigMes = DATEADD(MONTH, 1, @FechaInicioMes)
			 , @FechaFinSigMes = DATEADD(DAY, -1, DATEADD(MONTH, 1, @FechaInicioSigMes))

		


		--LECTURA E INSERCION DE NUEVOS MESES

		IF NOT EXISTS(SELECT MP.[Id]
					  FROM dbo.MesPlanilla MP
					  WHERE MP.[FechaInicio] = @FechaInicioMes
					  AND MP.[FechaFinal] = @FechaFinMes)
		BEGIN
			INSERT INTO [dbo].[MesPlanilla]
			   ([FechaInicio]
			   ,[FechaFinal]
			   )/*Inserta en la tabla MesPlanilla*/
			   VALUES(@FechaInicioMes, @FechaFinMes)
			   
			 SELECT @idMes = @@IDENTITY
		END
		ELSE
		BEGIN
			SELECT @idMes = MP.[Id]
			FROM dbo.MesPlanilla MP
			WHERE MP.[FechaInicio] = @FechaInicioMes
			AND MP.[FechaFinal] = @FechaFinMes
		END

		IF NOT EXISTS(SELECT MP.[Id]
					  FROM dbo.MesPlanilla MP
					  WHERE MP.[FechaInicio] = @FechaInicioSigMes
					  AND MP.[FechaFinal] = @FechaFinSigMes)
		BEGIN
			INSERT INTO [dbo].[MesPlanilla]
			   ([FechaInicio]
			   ,[FechaFinal]
			   )/*Inserta en la tabla MesPlanilla*/
			   VALUES(@FechaInicioSigMes, @FechaFinSigMes)
			   
			 SELECT @idMesSig = @@IDENTITY
		END
		ELSE
		BEGIN
			SELECT @idMesSig = MP.[Id]
			FROM dbo.MesPlanilla MP
			WHERE MP.[FechaInicio] = @FechaInicioSigMes
			AND MP.[FechaFinal] = @FechaFinSigMes
		END

		
		
		--LECTURA E INSERCION DE NUEVAS SEMANAS
		
		IF NOT EXISTS (SELECT SP.[Id]
					   FROM dbo.SemanaPlanilla SP
					   WHERE SP.[FechaInicio] = @FechaInicioSemana
					   AND SP.[FechaFinal] = @FechaFinSemana)
		BEGIN
			INSERT INTO [dbo].[SemanaPlanilla]
			   ([FechaInicio]
			   ,[FechaFinal]
			   ,[idMesPlanilla]
			   )/*Inserta en la tabla SemanaPlanilla*/
			   VALUES (@FechaInicioSemana, @FechaFinSemana, @idMes)

			   SELECT @idSemana = @@IDENTITY
		END
		ELSE
		BEGIN
			SELECT @idSemana = SP.[Id]
			FROM dbo.SemanaPlanilla SP
			WHERE SP.[FechaInicio] = @FechaInicioSemana
			AND SP.[FechaFinal] = @FechaFinSemana
		END

		IF NOT EXISTS (SELECT SP.[Id]
					   FROM dbo.SemanaPlanilla SP
					   WHERE SP.[FechaInicio] = @FechaInicioSigSemana
					   AND SP.[FechaFinal] = @FechaFinSigSemana)
		BEGIN
			INSERT INTO [dbo].[SemanaPlanilla]
			   ([FechaInicio]
			   ,[FechaFinal]
			   ,[idMesPlanilla]
			   )/*Inserta en la tabla SemanaPlanilla*/
			   VALUES (@FechaInicioSigSemana, @FechaFinSigSemana,
					CASE WHEN MONTH(@FechaFinSemana) = MONTH(@FechaFinSigSemana)
						 THEN @idMes
						 ELSE @idMesSig
					END)

			   SELECT @idSemanaSig = @@IDENTITY
		END
		ELSE
		BEGIN
			SELECT @idSemanaSig = SP.[Id]
			FROM dbo.SemanaPlanilla SP
			WHERE SP.[FechaInicio] = @FechaInicioSigSemana
			AND SP.[FechaFinal] = @FechaFinSigSemana
		END



		--VARIABLE PARA ACCEDER A LOS NODOS DE NUEVOS EMPLEADOS DE UNA FECHA ESPECIFICA
		DECLARE @rutaNodoNuevosEmpleados VARCHAR(125);
		SELECT @rutaNodoNuevosEmpleados = '/Operacion/FechaOperacion[@Fecha="' + @inFecha + '"]/NuevosEmpleados/NuevoEmpleado'
		
		--LECTURA E INSERCION DE NUEVOS USUARIOS EMPLEADOS
		
		INSERT INTO [dbo].[Usuario]
           ([UserName]
		   ,[Password]
		   ,[TipoUsuario]
		   )/*Inserta en la tabla Usuario*/
		   SELECT Usuario, [Password] , 2 as TipoUsuario
		   FROM 
				(SELECT Usuario, [Password]
					FROM OPENXML(@hdoc, @rutaNodoNuevosEmpleados, 1)
					WITH(
					--Fecha VARCHAR(50) '../@Fecha',
					Usuario VARCHAR(50),
					Password VARCHAR(50)
					)
				) as Emp
				WHERE NOT EXISTS(
				SELECT 1 FROM dbo.[Usuario] 
				WHERE UserName = Emp.Usuario)
		

		--LECTURA E INSERCION DE NUEVOS EMPLEADOS
		
		INSERT INTO [dbo].[Empleado]
           ([Nombre]
		   ,[idTipoIdentificacion]
		   ,[Identificacion]
		   ,[idDepartamento]
		   ,[idPuesto]
		   ,[idUsuario]
		   )/*Inserta en la tabla Empleado*/
		   SELECT Emp.Nombre, Emp.IdTipoDocumento, Emp.ValorTipoDocumento, Emp.IdDepartamento, Emp.IdPuesto, U.Id
		   FROM
			(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoNuevosEmpleados, 1)
				WITH(
				--Fecha VARCHAR(50) '../@Fecha',
				Nombre VARCHAR(50),
				IdTipoDocumento VARCHAR(50),
				ValorTipoDocumento VARCHAR(50),
				IdDepartamento VARCHAR(50),
				IdPuesto VARCHAR(50),
				Usuario VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.[Usuario] U
			ON Emp.Usuario = U.UserName

		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
		SELECT 1, 'localhost', @inFecha, 
		'{"TipoAccion": "Insertar empleado exitoso", 
		"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+Emp.IdTipoDocumento+'", "'+Emp.ValorTipoDocumento+'", "'+Emp.Nombre+'", "'+Emp.IdPuesto+'", "'+Emp.IdDepartamento+'"}'
		FROM
		(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoNuevosEmpleados, 1)
				WITH(
				Nombre VARCHAR(50),
				IdTipoDocumento VARCHAR(50),
				ValorTipoDocumento VARCHAR(50),
				IdDepartamento VARCHAR(50),
				IdPuesto VARCHAR(50),
				Usuario VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.[Usuario] U
			ON Emp.Usuario = U.UserName
			INNER JOIN dbo.[Empleado] E
			ON Emp.ValorTipoDocumento = E.Identificacion


		INSERT INTO dbo.DeduccionXEmpleado
		( [idEmpleado]
		 ,[idTipoDeduccion]
		 ,[Monto]
		 ,[Porcentaje]
		)
		SELECT E.Id, TD.Id,
			   CASE 
					WHEN TD.Porcentual = 1 THEN TD.Valor
					ELSE NULL
			   END
			 , CASE 
					WHEN TD.Porcentual = 2 THEN TD.Valor
					ELSE NULL
			   END
		FROM dbo.TipoDeduccion TD
		, (SELECT *
				FROM OPENXML (@hdoc, @rutaNodoNuevosEmpleados, 1)
				WITH(
				Nombre VARCHAR(50),
				IdTipoDocumento VARCHAR(50),
				ValorTipoDocumento VARCHAR(50),
				IdDepartamento VARCHAR(50),
				IdPuesto VARCHAR(50),
				Usuario VARCHAR(50)
				)
			) Emp
		INNER JOIN dbo.[Empleado] E
		ON Emp.ValorTipoDocumento = E.Identificacion
		WHERE TD.Obligatoria = 1


		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
		SELECT 1, 'localhost', @inFecha, 
		'{"TipoAccion": "Asociacion empleado con deduccion exitoso", 
		"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+Emp.ValorTipoDocumento+'", "'+E.Nombre+'", "id tipo deduccion: '+CONVERT(VARCHAR, TD.Id)+'"}'
		FROM
		(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoNuevosEmpleados, 1)
				WITH(
				Nombre VARCHAR(50),
				IdTipoDocumento VARCHAR(50),
				ValorTipoDocumento VARCHAR(50),
				IdDepartamento VARCHAR(50),
				IdPuesto VARCHAR(50),
				Usuario VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.Empleado E
			ON E.Identificacion = Emp.ValorTipoDocumento
			INNER JOIN dbo.DeduccionXEmpleado DXE
			ON DXE.idEmpleado = E.Id
			INNER JOIN dbo.TipoDeduccion TD
			ON TD.Id = DXE.idTipoDeduccion
			



		--VARIABLE PARA ACCEDER A LOS NODOS DE ELIMINAR EMPLEADOS DE UNA FECHA ESPECIFICA
		DECLARE @rutaNodoEliminarEmpleados VARCHAR(125);
		SELECT @rutaNodoEliminarEmpleados = '/Operacion/FechaOperacion[@Fecha="' + @inFecha + '"]/EliminarEmpleados/EliminarEmpleado'
		
		--LECTURA Y ELIMINACION EMPLEADOS
		
		   UPDATE dbo.Empleado
		   SET    esActivo = 0
		   FROM dbo.Empleado E
		   INNER JOIN 
			(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoEliminarEmpleados , 1)
				WITH(
				ValorTipoDocumento VARCHAR(50)
				)
			) Emp
			ON E.Identificacion = ValorTipoDocumento
			

			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			SELECT 1, 'localhost', @inFecha, 
			'{"TipoAccion": "Borrar empleado exitoso", 
			"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+CONVERT(VARCHAR, E.idTipoIdentificacion)+'", "'+Emp.ValorTipoDocumento+'", "'+E.Nombre+'", "'+CONVERT(VARCHAR, E.idPuesto)+'", "'+CONVERT(VARCHAR, E.idDepartamento)+'"}'
			FROM
			(SELECT *
					FROM OPENXML (@hdoc, @rutaNodoEliminarEmpleados, 1)
					WITH(
					ValorTipoDocumento VARCHAR(50)
					)
				) Emp
				INNER JOIN dbo.[Empleado] E
				ON Emp.ValorTipoDocumento = E.Identificacion
			
		
		UPDATE dbo.DeduccionXEmpleado
		SET esActivo = 0
		FROM dbo.DeduccionXEmpleado DXE
		INNER JOIN dbo.Empleado E
		ON DXE.idEmpleado = E.Id
		INNER JOIN dbo.TipoDeduccion TD
		ON DXE.idTipoDeduccion = TD.Id
		INNER JOIN 
		(SELECT *
			FROM OPENXML (@hdoc, @rutaNodoEliminarEmpleados , 1)
			WITH(
			ValorTipoDocumento VARCHAR(50)
			)
		) Emp
		ON E.Identificacion = Emp.ValorTipoDocumento

		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
		SELECT 1, 'localhost', @inFecha, 
		'{"TipoAccion": "Desasociacion empleado con deduccion exitoso", 
		"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+Emp.ValorTipoDocumento+'", "'+E.Nombre+'", "id tipo deduccion: '+CONVERT(VARCHAR, TD.Id)+'"}'
		FROM
		(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoEliminarEmpleados, 1)
				WITH(
				ValorTipoDocumento VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.[Empleado] E
			ON Emp.ValorTipoDocumento = E.Identificacion
			INNER JOIN dbo.DeduccionXEmpleado DXE
			ON DXE.idEmpleado = E.Id
			INNER JOIN dbo.TipoDeduccion TD
			ON TD.Id = DXE.idTipoDeduccion



		--VARIABLE PARA ACCEDER A LOS NODOS DE ASOCIACION EMPLEADO DEDUCCIONES DE UNA FECHA ESPECIFICA
		DECLARE @rutaNodoAsociacionEmpleadoDeducciones VARCHAR(125);
		SELECT @rutaNodoAsociacionEmpleadoDeducciones = '/Operacion/FechaOperacion[@Fecha="' + @inFecha + '"]/AsociacionEmpleadoDeducciones/AsociacionEmpleadoConDeduccion'
		
		--LECTURA Y ASOCIACION DE EMPLEADOS CON DEDUCCIONES

		INSERT INTO dbo.DeduccionXEmpleado
		( [idEmpleado]
		 ,[idTipoDeduccion]
		 ,[Monto]
		 ,[Porcentaje]
		)
		SELECT E.Id
			 , TD.Id
			 , CASE 
					WHEN TD.Porcentual = 1 THEN Emp.Monto
					ELSE NULL
			   END
			 , CASE 
					WHEN TD.Porcentual = 2 THEN TD.Valor
					ELSE NULL
			   END
		FROM
		(SELECT *
			FROM OPENXML (@hdoc, @rutaNodoAsociacionEmpleadoDeducciones , 1)
			WITH(
			IdTipoDeduccion VARCHAR(50),
			ValorTipoDocumento VARCHAR(50),
			Monto VARCHAR(50)
			)
		) Emp
		INNER JOIN dbo.TipoDeduccion TD
		ON TD.Id = CONVERT(INT, Emp.IdTipoDeduccion)
		INNER JOIN dbo.Empleado E
		ON E.Identificacion = Emp.ValorTipoDocumento

		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
		SELECT 1, 'localhost', @inFecha, 
		'{"TipoAccion": "Asociacion empleado con deduccion exitoso", 
		"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+Emp.ValorTipoDocumento+'", "'+E.Nombre+'", "id tipo deduccion: '+Emp.IdTipoDeduccion+'", "monto: '+Emp.Monto+'"}'
		FROM
		(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoAsociacionEmpleadoDeducciones, 1)
				WITH(
				IdTipoDeduccion VARCHAR(50),
				ValorTipoDocumento VARCHAR(50),
				Monto VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.TipoDeduccion TD
			ON TD.Id = CONVERT(INT, Emp.IdTipoDeduccion)
			INNER JOIN dbo.Empleado E
			ON E.Identificacion = Emp.ValorTipoDocumento



		--VARIABLE PARA ACCEDER A LOS NODOS DE DESASOCIACION EMPLEADO DEDUCCIONES DE UNA FECHA ESPECIFICA
		DECLARE @rutaNodoDesasociacionEmpleadoDeducciones VARCHAR(125);
		SELECT @rutaNodoDesasociacionEmpleadoDeducciones = '/Operacion/FechaOperacion[@Fecha="' + @inFecha + '"]/DesasociacionEmpleadoDeducciones/DesasociacionEmpleadoConDeduccion'
		
		--LECTURA Y DESASOCIACION DE EMPLEADOS CON DEDUCCIONES

		UPDATE dbo.DeduccionXEmpleado
		SET esActivo = 0
		FROM dbo.DeduccionXEmpleado DXE
		INNER JOIN dbo.Empleado E
		ON DXE.idEmpleado = E.Id
		INNER JOIN 
		(SELECT *
			FROM OPENXML (@hdoc, @rutaNodoDesasociacionEmpleadoDeducciones , 1)
			WITH(
			IdTipoDeduccion VARCHAR(50),
			ValorTipoDocumento VARCHAR(50)
			)
		) Emp
		ON DXE.idTipoDeduccion = CONVERT(INT, Emp.IdTipoDeduccion)
		AND E.Identificacion = Emp.ValorTipoDocumento

		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
		SELECT 1, 'localhost', @inFecha, 
		'{"TipoAccion": "Desasociacion empleado con deduccion exitoso", 
		"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+Emp.ValorTipoDocumento+'", "'+E.Nombre+'", "id tipo deduccion: '+Emp.IdTipoDeduccion+'"}'
		FROM
		(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoDesasociacionEmpleadoDeducciones, 1)
				WITH(
				IdTipoDeduccion VARCHAR(50),
				ValorTipoDocumento VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.[Empleado] E
			ON Emp.ValorTipoDocumento = E.Identificacion
			INNER JOIN dbo.DeduccionXEmpleado DXE
			ON DXE.idEmpleado = E.Id
			AND DXE.idTipoDeduccion = CONVERT(INT, Emp.IdTipoDeduccion)


		
		--VARIABLE PARA ACCEDER A LOS NODOS DE JORNADAS PROXIMA SEMANA DE UNA FECHA ESPECIFICA
		DECLARE @rutaNodoJornadasProximaSemana VARCHAR(125);
		SELECT @rutaNodoJornadasProximaSemana = '/Operacion/FechaOperacion[@Fecha="' + @inFecha + '"]/JornadasProximaSemana/TipoJornadaProximaSemana'
		
		--LECTURA E INSERCION DE NUEVAS JORNADAS PROXIMA SEMANA
		
		INSERT INTO [dbo].[JornadaXEmpleadoXSemana]
           ([idTipoJornada]
		   ,[idEmpleado]
		   ,[idSemanaPlanilla]
		   )/*Inserta en la tabla JornadaXEmpleadoXSemana*/
		   SELECT Emp.IdTipoJornada, E.Id , @idSemanaSig
		   FROM 
				(SELECT ValorTipoDocumento, IdTipoJornada
					FROM OPENXML(@hdoc, @rutaNodoJornadasProximaSemana, 1)
					WITH(
					ValorTipoDocumento VARCHAR(50),
					IdTipoJornada VARCHAR(50)
					)
				) as Emp
				INNER JOIN dbo.Empleado E
				ON E.Identificacion = Emp.ValorTipoDocumento
				INNER JOIN dbo.TipoJornada TJ
				ON Emp.IdTipoJornada = TJ.Id

		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
		SELECT 1, 'localhost', @inFecha, 
		'{"TipoAccion": "Ingreso de nuevas jornadas exitoso", 
		"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+Emp.ValorTipoDocumento+'", "'+E.Nombre+'", "id tipo jornada: '+Emp.IdTipoJornada+'", "tipo jornada: '+TJ.Nombre+'"}'
		FROM
		(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoJornadasProximaSemana, 1)
				WITH(
				ValorTipoDocumento VARCHAR(50),
				IdTipoJornada VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.[Empleado] E
			ON Emp.ValorTipoDocumento = E.Identificacion
			INNER JOIN dbo.TipoJornada TJ
			ON Emp.IdTipoJornada = TJ.Id



		--VARIABLE PARA ACCEDER A LOS NODOS DE MARCAS DE ASISTENCIA EMPLEADO DE UNA FECHA ESPECIFICA
		DECLARE @rutaNodoMarcasAsistencia VARCHAR(125);
		SELECT @rutaNodoMarcasAsistencia = '/Operacion/FechaOperacion[@Fecha="' + @inFecha + '"]/MarcasAsistencia/MarcaDeAsistencia'
		
		--LECTURA Y MARCA DE ASISTENCIA DE EMPLEADOS

		INSERT INTO dbo.MarcaAsistencia
		( [FechaInicio]
		 ,[FechaSalida]
		 ,[idEmpleado]
		 ,[idJornadaXEmpleadoXSemana]
		)
		SELECT CONVERT(DATETIME, Emp.HoraEntrada)
			 , CONVERT(DATETIME, Emp.HoraSalida)
			 , E.Id
			 , JXEXS.Id
		FROM 
		(SELECT *
			FROM OPENXML (@hdoc, @rutaNodoMarcasAsistencia , 1)
			WITH(
			ValorTipoDocumento VARCHAR(50),
			HoraEntrada VARCHAR(50),
			HoraSalida VARCHAR(50)
			)
		) Emp
		INNER JOIN dbo.Empleado E
		ON E.Identificacion = Emp.ValorTipoDocumento
		INNER JOIN dbo.JornadaXEmpleadoXSemana JXEXS
		ON JXEXS.idEmpleado = E.Id
		AND JXEXS.idSemanaPlanilla = @idSemana

		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
		SELECT 1, 'localhost', @inFecha, 
		'{"TipoAccion": "Ingreso de nuevas marcas de asistencia exitoso", 
		"Descripcion": "'+CONVERT(VARCHAR, E.Id)+'", "'+Emp.ValorTipoDocumento+'", "'+E.Nombre+'", "id semana: '+CONVERT(VARCHAR, JXEXS.idSemanaPlanilla)+'", "hora de entrada: '+Emp.HoraEntrada+'", "hora de salida: '+Emp.HoraSalida+'"}'
		FROM
		(SELECT *
				FROM OPENXML (@hdoc, @rutaNodoMarcasAsistencia, 1)
				WITH(
				ValorTipoDocumento VARCHAR(50),
				HoraEntrada VARCHAR(50),
				HoraSalida VARCHAR(50)
				)
			) Emp
			INNER JOIN dbo.Empleado E
			ON E.Identificacion = Emp.ValorTipoDocumento
			INNER JOIN dbo.JornadaXEmpleadoXSemana JXEXS
			ON JXEXS.idEmpleado = E.Id
			AND JXEXS.idSemanaPlanilla = @idSemana
		

		COMMIT TRANSACTION tProcesamientoXMLOperaciones
		



		EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/


	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tProcesamientoXMLOperaciones; -- se deshacen los cambios realizados
		END;

		INSERT INTO dbo.DBErrors	VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			@inFecha
		);

		Set @outResultCode=50005;	-- Error
	
	END CATCH

END
