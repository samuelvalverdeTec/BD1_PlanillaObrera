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
-- Description:	borra un empleado de la tabla Empleado
-- =============================================
CREATE PROCEDURE [dbo].[Borrar_Empleado] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inIdentificacion VARCHAR(125)
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
	SELECT @idEmpleado = E.[Id]
		, @nombreAnterior = E.[Nombre]
		, @idTDAnterior = E.[idTipoIdentificacion]
		, @identificacionAnterior = E.[Identificacion]
		, @fechaNacimientoAnterior = E.[FechaNacimiento]
		, @idPuestoAnterior = E.[idPuesto]
		, @idDepartamentoAnterior = E.[idDepartamento]
	FROM dbo.Empleado E 
	WHERE Identificacion = @inIdentificacion and E.[esActivo] = 1;
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
					WHERE Identificacion = @inIdentificacion and E.[esActivo] = 1)
		BEGIN
			SELECT @idEmpleado = E.[Id]
				, @nombreAnterior = E.[Nombre]
				, @idTDAnterior = E.[idTipoIdentificacion]
				, @identificacionAnterior = E.[Identificacion]
				, @fechaNacimientoAnterior = E.[FechaNacimiento]
				, @idPuestoAnterior = E.[idPuesto]
				, @idDepartamentoAnterior = E.[idDepartamento]
			FROM dbo.Empleado E 
			WHERE Identificacion = @inIdentificacion and E.[esActivo] = 1;

			BEGIN TRANSACTION tDeleteEmpleado
			UPDATE dbo.Empleado
			SET    esActivo = 0
			WHERE Identificacion = @inIdentificacion;
			--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			--'{"TipoAccion": "Borrado de artículo exitosa", 
			--"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código: '+@codigoAnterior+'", "nombre: '+@nombreAnterior+'", "precio: '+CONVERT(VARCHAR, @precioAnterior)+'"}');
			COMMIT TRANSACTION tDeleteEmpleado
		END
		--ELSE
		--BEGIN
			--INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			--VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			--'{"TipoAccion": "Borrado de artículo no exitosa", 
			--"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código: '+@codigoAnterior+'", "nombre: '+@nombreAnterior+'", "precio: '+CONVERT(VARCHAR, @precioAnterior)
			--+'", "descripción del error: '+ERROR_MESSAGE()+'"}');
		--END
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tDeleteEmpleado; -- se deshacen los cambios realizados
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
		SET @outResultCode = 50014;  -- código error en la modificación de artículo
	END CATCH
	

	
END
