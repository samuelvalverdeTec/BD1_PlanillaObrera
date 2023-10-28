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
-- Description:	modifica un empleado de la tabla Empleado
-- =============================================
CREATE PROCEDURE [dbo].[Modificar_Empleado] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inIdEmpleadoBuscado INT
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
	DECLARE @idEmpleado INT;
	DECLARE @nombreAnterior VARCHAR(125);
	DECLARE @idTDAnterior INT;
	DECLARE @identificacionAnterior VARCHAR(125);
	DECLARE @fechaNacimientoAnterior DATETIME;
	DECLARE @idPuestoAnterior INT;
	DECLARE @idDepartamentoAnterior INT;
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0;  -- no error code
		IF EXISTS(SELECT E.[Id]
						 , E.[Nombre]
						 , E.[idTipoIdentificacion]
						 , E.[Identificacion]
						 , E.[FechaNacimiento]
						 , E.[idPuesto]
						 , E.[idDepartamento]
					FROM dbo.Empleado E 
					WHERE ((Identificacion = @inIdentificacion and Id <> @inIdEmpleadoBuscado) or (Nombre = @inNombre and Id <> @inIdEmpleadoBuscado)) and E.[esActivo] = 1)
		BEGIN
			SELECT @idEmpleado = E.[Id]
				, @nombreAnterior = E.[Nombre]
				, @idTDAnterior = E.[idTipoIdentificacion]
				, @identificacionAnterior = E.[Identificacion]
				, @fechaNacimientoAnterior = E.[FechaNacimiento]
				, @idPuestoAnterior = E.[idPuesto]
				, @idDepartamentoAnterior = E.[idDepartamento]
			FROM dbo.Empleado E 
			WHERE Id = @inIdEmpleadoBuscado and E.[esActivo] = 1;
			--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			--'{"TipoAccion": "Modificación de artículo no exitosa", 
			--"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo anterior: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código anterior: '+@codigoAnterior+'", "nombre anterior: '+@nombreAnterior+'", "precio anterior: '+CONVERT(VARCHAR, @precioAnterior)
			--+'", "id clase artículo nuevo: '+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "código nuevo: '+@inCodigo+'", "nombre nuevo: '+@inNombre+'", "precio nuevo: '+CONVERT(VARCHAR, @inPrecio)
			--+'", "descripción del error: '+ERROR_MESSAGE()+'"}');
		END
		ELSE
		BEGIN
			SELECT @idEmpleado = E.[Id]
				, @nombreAnterior = E.[Nombre]
				, @idTDAnterior = E.[idTipoIdentificacion]
				, @identificacionAnterior = E.[Identificacion]
				, @fechaNacimientoAnterior = E.[FechaNacimiento]
				, @idPuestoAnterior = E.[idPuesto]
				, @idDepartamentoAnterior = E.[idDepartamento]
			FROM dbo.Empleado E 
			WHERE Id = @inIdEmpleadoBuscado and E.[esActivo] = 1;

			BEGIN TRANSACTION tUpdateEmpleado 
				UPDATE dbo.Empleado
				SET    Nombre = @inNombre
					 , idTipoIdentificacion = @inIdTipoIdentificacion
					 , Identificacion = @inIdentificacion
					 , FechaNacimiento = @inFechaNacimiento
					 , idPuesto = @inIdPuesto
					 , idDepartamento = @inIdDepartamento
				WHERE Id = @inIdEmpleadoBuscado and esActivo = 1;
				--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
				--'{"TipoAccion": "Modificación de artículo exitosa", 
				--"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo anterior: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código anterior: '+@codigoAnterior+'", "nombre anterior: '+@nombreAnterior+'", "precio anterior: '+CONVERT(VARCHAR, @precioAnterior)
				--+'", "id clase artículo nuevo: '+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "código nuevo: '+@inCodigo+'", "nombre nuevo: '+@inNombre+'", "precio nuevo: '+CONVERT(VARCHAR, @inPrecio)+'"}');
			COMMIT TRANSACTION tUpdateEmpleado 
		END
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tUpdateEmpleado; -- se deshacen los cambios realizados
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
		SET @outResultCode = 50011;  -- código error en la modificación de artículo
	END CATCH
	

	
END
