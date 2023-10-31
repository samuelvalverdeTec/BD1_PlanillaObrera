USE [BD_Tarea3]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Samuel Valverde A.
--				Erick Kauffmann
-- Create date: 30/10/2023
-- Description:	Read and Load XML Data in SQL Tables
-- =============================================

CREATE PROCEDURE [dbo].[ReadAndLoadXML]
	-- Add the parameters for the stored procedure here
	@inRutaXML NVARCHAR(500)
	, @outResultCode INT OUTPUT
AS

BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		SET @outResultCode = 0;  -- no error code

		DECLARE @Datos XML	-- Variable de tipo XML

		DECLARE @outDatos xml -- parametro de salida del sql dinamico

		-- Para cargar el archivo con una variable, CHAR(39) son comillas simples
		DECLARE @Comando NVARCHAR(500)= 'SELECT @Datos = D FROM OPENROWSET (BULK '  + CHAR(39) + @inRutaXML + CHAR(39) + ', SINGLE_BLOB) AS Datos(D)' -- comando que va a ejecutar el sql dinamico

		DECLARE @Parametros NVARCHAR(500)
		SET @Parametros = N'@Datos xml OUTPUT' --parametros del sql dinamico

		EXECUTE sp_executesql @Comando, @Parametros, @Datos = @outDatos OUTPUT -- ejecutamos el comando que hicimos dinamicamente

		SET @Datos = @outDatos -- le damos el parametro de salida del sql dinamico a la variable para el resto del procedure
    
		DECLARE @hdoc int /*Creamos hdoc que va a ser un identificador*/
    
		EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/

		INSERT INTO [dbo].[TipoIdentificacion]
           ([Id]
           ,[Nombre])/*Inserta en la tabla TipoIdentificacion*/
		SELECT *
		FROM OPENXML (@hdoc, '/Catalogos/TiposdeDocumentodeIdentidad/TipoDocuIdentidad' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
		PATH del nodo y el 1 que sirve para retornar solo atributos*/
		WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
		Id VARCHAR(50),
		Nombre VARCHAR(50)
		)

		INSERT INTO [dbo].[Puesto]
           ([Id]
		   ,[Nombre]
		   ,[SalarioXHora])/*Inserta en la tabla Puesto*/
		SELECT *
		FROM OPENXML (@hdoc, '/Catalogos/Puestos/Puesto' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
		PATH del nodo y el 1 que sirve para retornar solo atributos*/
		WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
		Id VARCHAR(50),
		Nombre VARCHAR(50),
		SalarioXHora VARCHAR(50)
		)

		INSERT INTO [dbo].[Departamento]
           ([Id]
		   ,[Nombre])/*Inserta en la tabla Departamento*/
		SELECT *
		FROM OPENXML (@hdoc, '/Catalogos/Departamentos/Departamento' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
		PATH del nodo y el 1 que sirve para retornar solo atributos*/
		WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
		Id VARCHAR(50),
		Nombre VARCHAR(50)
		)

		EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/


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
GO

