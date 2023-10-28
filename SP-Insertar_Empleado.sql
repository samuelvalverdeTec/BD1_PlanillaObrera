USE [BD_Tarea3]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 25/10/2023
-- Description:	insertar un empleado nuevo en la tabla Empleado
-- =============================================
CREATE PROCEDURE [dbo].[Insertar_Empleado] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inNombre VARCHAR(125)
	, @inIdTipoIdentificacion INT
	, @inIdentificacion VARCHAR(125)
	, @inFechaNacimiento DATETIME
	, @inIdPuesto INT
	, @inIdDepartamento INT
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idEmpleado INT;
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
				 WHERE (Nombre = @inNombre or Identificacion = @inIdentificacion) and E.[esActivo] = 1)
		BEGIN
			SET @outResultCode = 50003;  -- ERROR: el empleado ya existia

			SELECT @idEmpleado = E.[Id]
				 , @inNombre = E.[Nombre]
				 , @inIdentificacion = E.[idTipoIdentificacion]
				 , @inIdentificacion = E.[Identificacion]
				 , @inFechaNacimiento = E.[FechaNacimiento]
				 , @inIdPuesto = E.[idPuesto]
				 , @inIdDepartamento = E.[idDepartamento]
			FROM dbo.Empleado E 
			WHERE (Nombre = @inNombre or Identificacion = @inIdentificacion) and E.[esActivo] = 1;
			--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			--'{"TipoAccion": "Insertar articulo no exitoso", 
			--"Descripcion": "'+CONVERT(VARCHAR, @idArticulo)+'", "'+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "'+@inCodigo+'", "'+@inNombre+'", "'+CONVERT(VARCHAR, @inPrecio)+'"}');
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION tInsertEmpleado
				SET @outResultCode = 0;  -- no error code
				INSERT INTO dbo.Empleado (Nombre, idTipoIdentificacion, Identificacion, FechaNacimiento, idPuesto, idDepartamento) 
				VALUES (@inNombre, @inIdTipoIdentificacion, @inIdentificacion, @inFechaNacimiento, @inIdPuesto, @inIdDepartamento); 

				SELECT @idEmpleado = @@IDENTITY;
				-- si el articulo no existe inserta uno nuevo con los parametros
				--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
				--'{"TipoAccion": "Insertar articulo exitoso", 
				--"Descripcion": "'+CONVERT(VARCHAR, @idArticulo)+'", "'+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "'+@inCodigo+'", "'+@inNombre+'", "'+CONVERT(VARCHAR, @inPrecio)+'"}');
			COMMIT TRANSACTION tInsertEmpleado
		END
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tInsertEmpleado; -- se deshacen los cambios realizados
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
