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
-- Create date: 12/11/2023
-- Description:	Hace la simulacion de tiempo de la BD
-- =============================================

CREATE PROCEDURE [dbo].[Simulacion]
	-- Add the parameters for the stored procedure here
	  @inFechaInicio VARCHAR(50)
	, @inFechaFinal VARCHAR(50)
	, @outResultCode INT OUTPUT
AS

BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		SET @outResultCode = 0;  -- no error code

		DECLARE   @FechaAct DATE
				, @FechaFin DATE
		SELECT @FechaAct = CONVERT(DATE, @inFechaInicio)
		SELECT @FechaFin = CONVERT(DATE, @inFechaFinal)
		WHILE (@FechaAct <= @FechaFin)
		BEGIN
			DECLARE   @codigoError10 INT
					, @codigoError11 INT
			EXEC ReadAndLoadXMLOperaciones 'D:\Erick_TEC_2S-2023\BD\Scripts-Tarea3\OperacionesXML.xml', 
			@FechaAct,
			@codigoError10 OUTPUT;

			EXEC Calcular_Pagos @FechaAct,
			@codigoError11 OUTPUT;

			SELECT @FechaAct = DATEADD(DAY, 1, @FechaAct)
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
