USE [PlanillaObrera]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Authors:		Samuel V., Erick K.
-- Create date: 09/10/2023
-- Description:	SP con el que se crean las tablas de la BD
-- =============================================

CREATE PROCEDURE [dbo].[CrearTablas] 
	-- Add the parameters for the stored procedure here
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY

		-- ************************************************************
		CREATE TABLE [dbo].[DBErrors](
		[ErrorID] [int] IDENTITY(1,1) NOT NULL,
		[UserName] [varchar](100) NULL,
		[ErrorNumber] [int] NULL,
		[ErrorState] [int] NULL,
		[ErrorSeverity] [int] NULL,
		[ErrorLine] [int] NULL,
		[ErrorProcedure] [varchar](max) NULL,
		[ErrorMessage] [varchar](max) NULL,
		[ErrorDateTime] [datetime] NULL
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

		SET @outResultCode = 0;  -- No hay error
	
	END TRY
	BEGIN CATCH
	
	
	
	END CATCH
END
GO
