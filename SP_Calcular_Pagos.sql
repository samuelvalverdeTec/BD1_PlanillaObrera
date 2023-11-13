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
-- Create date: 11/11/2023
-- Description:	Calcular los Pagos
-- =============================================

ALTER PROCEDURE [dbo].[Calcular_Pagos]
	-- Add the parameters for the stored procedure here
	@inFecha VARCHAR(50)
	, @outResultCode INT OUTPUT
AS

BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		SET @outResultCode = 0;  -- no error code

		
		DECLARE @FechaAct DATE, @NumDiaSemana INT, @FechaFinSemana DATE, @FechaInicioSemana DATE, @idSemana INT
		SELECT @FechaAct = CONVERT(DATE, @inFecha)
		--SELECT CONVERT(TIME, '2023-07-07 2:00 pm')
		--SELECT DATEDIFF(HOUR, '10:00 pm', '3:00 am')+24


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

		SELECT @idSemana = SP.[Id]
		FROM dbo.SemanaPlanilla SP
		WHERE SP.[FechaInicio] = @FechaInicioSemana
		AND SP.[FechaFinal] = @FechaFinSemana


		INSERT INTO dbo.SemanaPlanillaXEmpleado (SalarioBruto, SalarioNeto, idSemanaPlanilla, idEmpleado)
		SELECT 0, 0, @idSemana, MA.idEmpleado
		FROM dbo.MarcaAsistencia MA
		WHERE CONVERT(DATE, MA.FechaSalida) = @FechaAct
		AND MA.idEmpleado NOT IN (SELECT SPXE.idEmpleado
								  FROM dbo.SemanaPlanillaXEmpleado SPXE
								  WHERE SPXE.idSemanaPlanilla = @idSemana)
 

		IF (@NumDiaSemana = 1)OR EXISTS (SELECT * FROM dbo.Feriado F WHERE F.Fecha = @FechaAct)
		BEGIN
			INSERT INTO dbo.MovimientoPlanilla (Fecha, Monto, idTipoMovimiento, CantidadHoras, TipoHora, idMarcaAsistencia, idEmpleado, idSemanaPlanillaXEmpleado)
			SELECT  CONVERT(DATE, Mov.FechaSalida) --as FechaHoy
				  , Mov.CantidadHorasDobleExtraordinarias*Mov.SalarioXHora*2 --as Monto
				  , 3 --as idTipoMovimiento
				  , Mov.CantidadHorasDobleExtraordinarias --as CantidadHoras
				  , 3 --as TipoHora
				  , Mov.Id
				  , Mov.idEmpleado
				  , Mov.idSPXE --as idSemanaPlanillaXEmpleado
			FROM 
				(SELECT MA.Id, MA.FechaInicio, MA.FechaSalida, MA.idEmpleado, MA.idJornadaXEmpleadoXSemana, P.SalarioXHora, SPXE.Id as idSPXE 
					, DATEDIFF(HOUR, MA.FechaInicio, MA.FechaSalida) as CantidadHorasDobleExtraordinarias
				FROM dbo.MarcaAsistencia MA
				INNER JOIN dbo.Empleado E
				ON E.Id = MA.idEmpleado
				INNER JOIN dbo.Puesto P
				ON P.Id = E.idPuesto
				INNER JOIN dbo.JornadaXEmpleadoXSemana JXEXS
				ON JXEXS.Id = MA.idJornadaXEmpleadoXSemana
				AND JXEXS.idSemanaPlanilla = @idSemana
				INNER JOIN dbo.TipoJornada TJ
				ON JXEXS.idTipoJornada = TJ.Id
				INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
				ON SPXE.idEmpleado = E.Id
				AND SPXE.idSemanaPlanilla = @idSemana
				WHERE CONVERT(DATE, MA.FechaSalida) = @FechaAct
				) as Mov
			WHERE Mov.CantidadHorasDobleExtraordinarias > 0
		END
		ELSE
		BEGIN

			INSERT INTO dbo.MovimientoPlanilla (Fecha, Monto, idTipoMovimiento, CantidadHoras, TipoHora, idMarcaAsistencia, idEmpleado, idSemanaPlanillaXEmpleado)
			SELECT  CONVERT(DATE, Mov.FechaSalida) --as FechaHoy
				  , Mov.CantidadHorasOrdinarias*Mov.SalarioXHora --as Monto
				  , 1 --as idTipoMovimiento
				  , Mov.CantidadHorasOrdinarias --as CantidadHoras
				  , 1 --as TipoHora
				  , Mov.Id
				  , Mov.idEmpleado
				  , Mov.idSPXE --as idSemanaPlanillaXEmpleado
			FROM 
				(SELECT MA.Id, MA.FechaInicio, MA.FechaSalida, MA.idEmpleado, MA.idJornadaXEmpleadoXSemana, P.SalarioXHora, SPXE.Id as idSPXE
						, CASE WHEN TJ.HoraFin >= CONVERT(TIME, MA.FechaSalida)
							 THEN DATEDIFF(HOUR, MA.FechaInicio, MA.FechaSalida) 
							 ELSE CASE WHEN DATEDIFF(HOUR, CONVERT(TIME, MA.FechaInicio), TJ.HoraFin) < 0
									   THEN DATEDIFF(HOUR, CONVERT(TIME, MA.FechaInicio), TJ.HoraFin)+24
									   ELSE DATEDIFF(HOUR, CONVERT(TIME, MA.FechaInicio), TJ.HoraFin)
								  END
						  END
						  as CantidadHorasOrdinarias
				FROM dbo.MarcaAsistencia MA
				INNER JOIN dbo.Empleado E
				ON E.Id = MA.idEmpleado
				INNER JOIN dbo.Puesto P
				ON P.Id = E.idPuesto
				INNER JOIN dbo.JornadaXEmpleadoXSemana JXEXS
				ON JXEXS.Id = MA.idJornadaXEmpleadoXSemana
				AND JXEXS.idSemanaPlanilla = @idSemana
				INNER JOIN dbo.TipoJornada TJ
				ON JXEXS.idTipoJornada = TJ.Id
				INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
				ON SPXE.idEmpleado = E.Id
				AND SPXE.idSemanaPlanilla = @idSemana
				WHERE CONVERT(DATE, MA.FechaSalida) = @FechaAct
				) as Mov


			INSERT INTO dbo.MovimientoPlanilla (Fecha, Monto, idTipoMovimiento, CantidadHoras, TipoHora, idMarcaAsistencia, idEmpleado, idSemanaPlanillaXEmpleado)
			SELECT  CONVERT(DATE, Mov.FechaSalida) --as FechaHoy
				  , Mov.CantidadHorasExtraordinarias*Mov.SalarioXHora*1.5 --as Monto
				  , 2 --as idTipoMovimiento
				  , Mov.CantidadHorasExtraordinarias --as CantidadHoras
				  , 2 --as TipoHora
				  , Mov.Id
				  , Mov.idEmpleado
				  , Mov.idSPXE --as idSemanaPlanillaXEmpleado
			FROM 
				(SELECT MA.Id, MA.FechaInicio, MA.FechaSalida, MA.idEmpleado, MA.idJornadaXEmpleadoXSemana, P.SalarioXHora, SPXE.Id as idSPXE 
					, CASE WHEN TJ.HoraFin >= CONVERT(TIME, MA.FechaSalida)
						 THEN 0 
						 ELSE CASE WHEN DATEDIFF(HOUR, TJ.HoraFin, CONVERT(TIME, MA.FechaSalida)) < 0
								   THEN DATEDIFF(HOUR, TJ.HoraFin, CONVERT(TIME, MA.FechaSalida))+24
								   ELSE DATEDIFF(HOUR, TJ.HoraFin, CONVERT(TIME, MA.FechaSalida))
							  END
					  END
					  as CantidadHorasExtraordinarias
				FROM dbo.MarcaAsistencia MA
				INNER JOIN dbo.Empleado E
				ON E.Id = MA.idEmpleado
				INNER JOIN dbo.Puesto P
				ON P.Id = E.idPuesto
				INNER JOIN dbo.JornadaXEmpleadoXSemana JXEXS
				ON JXEXS.Id = MA.idJornadaXEmpleadoXSemana
				AND JXEXS.idSemanaPlanilla = @idSemana
				INNER JOIN dbo.TipoJornada TJ
				ON JXEXS.idTipoJornada = TJ.Id
				INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
				ON SPXE.idEmpleado = E.Id
				AND SPXE.idSemanaPlanilla = @idSemana
				WHERE CONVERT(DATE, MA.FechaSalida) = @FechaAct
				) as Mov
			WHERE Mov.CantidadHorasExtraordinarias > 0
		END


		IF(@NumDiaSemana = 5)
		BEGIN

			UPDATE dbo.SemanaPlanillaXEmpleado
			SET SalarioBruto = MovsCPXE.SalarioBruto
			FROM dbo.SemanaPlanillaXEmpleado SPXE
			INNER JOIN
			(SELECT MP.idEmpleado, SUM(MP.Monto) as SalarioBruto
			FROM dbo.MovimientoPlanilla MP
			INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
			ON SPXE.Id = MP.idSemanaPlanillaXEmpleado
			AND SPXE.idEmpleado = MP.idEmpleado
			INNER JOIN dbo.SemanaPlanilla SP
			ON SP.Id = SPXE.idSemanaPlanilla
			WHERE @idSemana = SP.Id
			AND MP.idTipoMovimiento <= 3
			GROUP BY MP.idEmpleado) as MovsCPXE
			ON SPXE.idEmpleado = MovsCPXE.idEmpleado


			INSERT INTO dbo.MovimientoPlanilla (Fecha, Monto, idTipoMovimiento, idDeduccionXEmpleado, idEmpleado, idSemanaPlanillaXEmpleado)
			SELECT  @FechaAct --as FechaHoy
				  , Mov.Monto/4 --as Monto
				  , 5 --as idTipoMovimiento
				  , Mov.idDXE --as idDeduccionXEmpleado
				  , Mov.idEmpleado
				  , Mov.idSPXE --as idSemanaPlanillaXEmpleado
			FROM 
				(SELECT DXE.Id as idDXE, DXE.idEmpleado, DXE.Monto, SPXE.Id as idSPXE		
				FROM dbo.DeduccionXEmpleado DXE
				INNER JOIN dbo.Empleado E
				ON E.Id = DXE.idEmpleado
				INNER JOIN dbo.JornadaXEmpleadoXSemana JXEXS
				ON JXEXS.idEmpleado = E.Id
				AND JXEXS.idSemanaPlanilla = @idSemana
				INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
				ON SPXE.idEmpleado = E.Id
				AND SPXE.idSemanaPlanilla = @idSemana
				WHERE DXE.esActivo = 1
				AND DXE.idTipoDeduccion > 3
				) as Mov

			INSERT INTO dbo.MovimientoPlanilla (Fecha, Monto, idTipoMovimiento, idEmpleado, idSemanaPlanillaXEmpleado)
			SELECT  @FechaAct --as FechaHoy
					, Mov.SalarioBruto*Mov.ValPorcentaje --as Monto
					, 4 --as idTipoMovimiento
					, Mov.idEmpleado
					, Mov.idSPXE --as idSemanaPlanillaXEmpleado
			FROM 
				(SELECT E.Id as idEmpleado, SPXE.SalarioBruto, SPXE.Id as idSPXE, DXE.Porcentaje as ValPorcentaje		
				FROM dbo.Empleado E
				INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
				ON SPXE.idEmpleado = E.Id
				AND SPXE.idSemanaPlanilla = @idSemana
				INNER JOIN dbo.DeduccionXEmpleado DXE
				ON DXE.idEmpleado = E.Id
				WHERE SPXE.idSemanaPlanilla = @idSemana
				AND DXE.idTipoDeduccion <= 3
				) as Mov
				
				--,
				--dbo.TipoDeduccion TD
				--WHERE TD.Obligatoria = 1
				--AND TD.Porcentual = 2


			UPDATE dbo.SemanaPlanillaXEmpleado
			SET SalarioNeto = SalarioBruto - MovsDPXE.TotalDeducciones
			FROM dbo.SemanaPlanillaXEmpleado SPXE
			INNER JOIN
			(SELECT MP.idEmpleado, SUM(MP.Monto) as TotalDeducciones
			FROM dbo.MovimientoPlanilla MP
			INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
			ON SPXE.Id = MP.idSemanaPlanillaXEmpleado
			AND SPXE.idEmpleado = MP.idEmpleado
			INNER JOIN dbo.SemanaPlanilla SP
			ON SP.Id = SPXE.idSemanaPlanilla
			WHERE @idSemana = SP.Id
			AND MP.idTipoMovimiento > 3
			GROUP BY MP.idEmpleado) as MovsDPXE
			ON SPXE.idEmpleado = MovsDPXE.idEmpleado
			

		END




	END TRY
	BEGIN CATCH

		INSERT INTO dbo.DBErrors	VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);

		Set @outResultCode=50005;	-- Error
	
	END CATCH

END
