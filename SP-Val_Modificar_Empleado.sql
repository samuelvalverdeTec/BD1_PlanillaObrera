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
-- Description:	valida que un articulo de la tabla Empleado exista para poder modificarlo
-- =============================================
ALTER PROCEDURE [dbo].[Validar_Modificar_Empleado] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inIdentificacion VARCHAR(32)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS(SELECT E.[Id]
					, E.[Nombre]
					, E.[idTipoIdentificacion]
					, E.[Identificacion]
					, E.[FechaNacimiento]
					, E.[idPuesto]
					, E.[idDepartamento]
					FROM dbo.Empleado E
					WHERE Identificacion = @inIdentificacion and E.[esActivo] = 1)
		BEGIN
			SET @outResultCode = 0;  -- no error code

			SELECT E.[Id]
					, E.[Nombre]
					, E.[idTipoIdentificacion]
					, E.[Identificacion]
					, E.[FechaNacimiento]
					, E.[idPuesto]
					, E.[idDepartamento]
					, P.[Nombre] NombrePuesto
			FROM dbo.Empleado E 
			INNER JOIN dbo.Puesto P 
			ON E.[idPuesto] = P.[Id]
			WHERE Identificacion = @inIdentificacion and E.[esActivo] = 1
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Intento de modificar empleado", 
			"Descripcion": "'+@inIdentificacion+'", "empleado existe"}');
		END
		ELSE
		BEGIN
			SET @outResultCode = 50009;  -- ERROR empleado no existe
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Intento de modificar empleado", 
			"Descripcion": "'+@inIdentificacion+'", "empleado no existe"}');
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
		SET @outResultCode = 50010;  -- código error en la validacion de modificar artículo
	END CATCH
	

	
END
