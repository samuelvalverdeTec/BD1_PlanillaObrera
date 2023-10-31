USE [BD_Tarea3]
GO
/****** Object:  StoredProcedure [dbo].[Obtener_Empleados_Orden_Alfabetico]    Script Date: 10/31/2023 12:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 25/10/2023
-- Description:	obtener la lista de todos los empleados de la BD en orden alfabético.
--				si se recibe por parámetro algún filtro se hace la búsqueda de los empleados que contengan ese filtro
--				(se hace el filtro)
-- =============================================
ALTER PROCEDURE [dbo].[Obtener_Empleados_Orden_Alfabetico] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inFiltroNombre VARCHAR(128)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	BEGIN TRY
		
		SET @outResultCode = 0;  -- no error code
			IF(@inFiltroNombre is NULL) or (@inFiltroNombre = '')
			BEGIN
					SELECT E.[Id]
						 , E.[Nombre]
						 , E.[idTipoIdentificacion]
						 , E.[Identificacion]
						 , E.[FechaNacimiento]
						 , E.[idPuesto]
						 , E.[idDepartamento]
						 , E.[idUsuario]
						 , P.[Nombre] NombrePuesto
					FROM dbo.Empleado E 
					INNER JOIN dbo.Puesto P
					ON E.[idPuesto] = P.[Id]
					WHERE E.[esActivo] = 1
					ORDER BY Nombre ASC; -- mostrar la tabla completa con todos los empleados en orden alfabético
			END
			ELSE
			BEGIN
				SELECT E.[Id]
					 , E.[Nombre]
					 , E.[idTipoIdentificacion]
					 , E.[Identificacion]
					 , E.[FechaNacimiento]
					 , E.[idPuesto]
					 , E.[idDepartamento]
					 , E.[idUsuario]
					 , P.[Nombre] NombrePuesto
				FROM dbo.Empleado E 
				INNER JOIN dbo.Puesto P
				ON E.[idPuesto] = P.[Id]
				WHERE E.[Nombre] like '%'+@inFiltroNombre+'%'
				and E.[esActivo] = 1
				ORDER BY Nombre ASC; -- mostrar la tabla con filtro con los empleados en orden alfabético
			END

		
--		INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
--		VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Consulta por nombre", "Descripcion": "'+ ISNULL(@inFiltroNombre,'nulo')+'"}');

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
		SET @outResultCode = 50001;  -- código error en la búsqueda de artículos
	END CATCH
END
