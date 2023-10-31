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
-- Description:	insertar un usuario nuevo en la tabla Usuario
-- =============================================
ALTER PROCEDURE [dbo].[Insertar_Usuario] 
	-- Add the parameters for the stored procedure here
	@inUserName VARCHAR(125)
	, @inPassword VARCHAR(125)
	, @inTipoUsuario INT
	, @inIdEmpleado INT
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idEmpleado INT;
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS(SELECT U.[Id]
						 , U.[UserName]
						 , U.[Password]
						 , U.[TipoUsuario]
						 , U.[idEmpleado]
						 , E.[Nombre] NombreEmpleado
				 FROM dbo.Usuario U 
				 INNER JOIN dbo.Empleado E
				 ON U.[idEmpleado] = E.[Id]
				 WHERE (UserName = @inUserName) and E.[esActivo] = 1)
		BEGIN
			SET @outResultCode = 500021;  -- ERROR: el usuario ya existia

			SELECT @idEmpleado = E.[Id]
				 , @inUserName = U.[UserName]
				 , @inPassword = U.[Password]
				 , @inTipoUsuario = U.[TipoUsuario]
				 --, E.[Nombre] NombreEmpleado
			FROM dbo.Usuario U
			INNER JOIN dbo.Empleado E
			ON  U.[idEmpleado] = E.[Id]
			WHERE (UserName = @inUserName) and E.[esActivo] = 1;
			--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			--'{"TipoAccion": "Insertar articulo no exitoso", 
			--"Descripcion": "'+CONVERT(VARCHAR, @idArticulo)+'", "'+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "'+@inCodigo+'", "'+@inNombre+'", "'+CONVERT(VARCHAR, @inPrecio)+'"}');
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION tInsertUsuario
				SET @outResultCode = 0;  -- no error code
				INSERT INTO dbo.Usuario (UserName, Password, TipoUsuario, idEmpleado) 
				VALUES (@inUserName, @inPassword, @inTipoUsuario, @inIdEmpleado); 

				SELECT @idEmpleado = @@IDENTITY;
				-- si el articulo no existe inserta uno nuevo con los parametros
				--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
				--'{"TipoAccion": "Insertar articulo exitoso", 
				--"Descripcion": "'+CONVERT(VARCHAR, @idArticulo)+'", "'+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "'+@inCodigo+'", "'+@inNombre+'", "'+CONVERT(VARCHAR, @inPrecio)+'"}');
			COMMIT TRANSACTION tInsertUsuario
		END
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tInsertUsuario; -- se deshacen los cambios realizados
		END;

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
		SET @outResultCode = 50004;  -- código error en la inserción de artículos
	END CATCH
	

	
END
