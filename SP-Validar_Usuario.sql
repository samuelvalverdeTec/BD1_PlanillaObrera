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
-- Description:	validar el usuario y password
-- =============================================
CREATE PROCEDURE [dbo].[Validar_Usuario] 
	-- Add the parameters for the stored procedure here
	@inPostIP VARCHAR(100)
	, @inUsuarioActual VARCHAR(16)
	, @inPassword VARCHAR(16)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @inIdUsuarioActual INT;
	SET NOCOUNT ON;

	BEGIN TRY
		IF EXISTS (SELECT U.[id]
						, U.[UserName]
						, U.[Password]
						, U.[TipoUsuario]
						, U.[idEmpleado]
						, E.[Nombre] NombreEmpleado
					FROM dbo.Usuario U
					INNER JOIN dbo.Empleado E
					ON U.[idEmpleado] = E.[Id]
					WHERE U.[UserName] = @inUsuarioActual 
					and U.[Password] = @inPassword)
		BEGIN
			SET @outResultCode = 0;  -- no error code, usuario y password correctos
			SELECT U.[id]
				, U.[UserName]
				, U.[Password]
				, U.[TipoUsuario]
				, U.[idEmpleado]
				, E.[Nombre] NombreEmpleado
			FROM dbo.Usuario U
			INNER JOIN dbo.Empleado E
			ON U.[idEmpleado] = E.[Id]
			WHERE U.[UserName] = @inUsuarioActual 
			and U.[Password] = @inPassword

			SELECT @inIdUsuarioActual = U.[id] 
			FROM dbo.Usuario U 
			WHERE U.[UserName] = @inUsuarioActual 
			and U.[Password] = @inPassword;
			--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Login exitoso", "Descripcion": "'+ @inUsuarioActual+'"}');
		END
		ELSE
		BEGIN
		--PRINT 'login no exitoso'
			SET @outResultCode = 500023;  -- usuario o password incorrecto
			--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			--VALUES (-1, @inPostIP, GETDATE(), '{"TipoAccion": "Login no exitoso", "Descripcion": "'+ @inUsuarioActual+'"}');
		END
		-- mostrar el usuario que corresponde al username y password ingresados
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
		SET @outResultCode = 50008;  -- código error en la búsqueda de usuario
	END CATCH
END
