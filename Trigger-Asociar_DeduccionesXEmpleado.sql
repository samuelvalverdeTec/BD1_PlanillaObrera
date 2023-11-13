DROP TRIGGER Trigger_Asociar_Deducciones ON dbo.Empleado
AFTER INSERT
AS
BEGIN TRY

	DECLARE @idEmpleado INT =(SELECT Id FROM inserted )
	/*
	INSERT INTO dbo.DeduccionXEmpleado
		( [idEmpleado]
		 ,[idTipoDeduccion]
		 ,[Monto]
		 ,[Porcentaje]
		)
		SELECT @idEmpleado, TD.Id,
			   CASE 
					WHEN TD.Porcentual = 1 THEN TD.Valor
					ELSE NULL
			   END
			 , CASE 
					WHEN TD.Porcentual = 2 THEN TD.Valor
					ELSE NULL
			   END
		FROM dbo.TipoDeduccion TD
		WHERE TD.Obligatoria = 1
		*/
END TRY
BEGIN CATCH
    
END CATCH;
GO