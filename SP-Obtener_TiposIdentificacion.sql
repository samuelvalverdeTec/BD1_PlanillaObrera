USE [BD_Tarea3]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 30/10/2023
-- Description:	obtener la lista de todos los tipos de identificacion de la BD en orden alfabético.
-- =============================================
CREATE PROCEDURE [dbo].[Obtener_TiposIdentificacion]  
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0;  -- no error code
		SELECT TI.[Id]
			 , Ti.[Nombre]
		FROM dbo.TipoIdentificacion TI
		ORDER BY Nombre ASC;
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
		SET @outResultCode = 50020;  -- código error en la búsqueda de tipos de identificacion
	END CATCH
END
