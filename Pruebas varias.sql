DECLARE @FechaAct DATE, @NumDiaSemana INT, @FechaFinSemana DATE, @FechaInicioSemana DATE, @idSemana INT
SELECT @FechaAct = CONVERT(DATE, '2023-07-13')
--SELECT CONVERT(TIME, '2023-07-07 2:00 pm')
--SELECT DATEDIFF(HOUR, '10:00 pm', '3:00 am')+24


SELECT @NumDiaSemana = DATEPART(weekday, @FechaAct)
--SELECT @NumDiaSemana as NumeroDiaSemana
IF @NumDiaSemana <= 5
BEGIN
	SELECT @FechaFinSemana = DATEADD(DAY, 5-@NumDiaSemana, @FechaAct)
	SELECT @FechaInicioSemana = DATEADD(DAY, -7, @FechaFinSemana)
END
ELSE
BEGIN
	SELECT @FechaInicioSemana = DATEADD(DAY, 5-@NumDiaSemana, @FechaAct)
	SELECT @FechaFinSemana = DATEADD(DAY, 7, @FechaInicioSemana)
END

SELECT @idSemana = SP.[Id]
FROM dbo.SemanaPlanilla SP
WHERE SP.[FechaInicio] = @FechaInicioSemana
AND SP.[FechaFinal] = @FechaFinSemana

--SELECT @idSemana

/*
SELECT MP.idEmpleado, SUM(MP.Monto) as SalarioBruto
FROM dbo.MovimientoPlanilla MP
INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
ON SPXE.Id = MP.idSemanaPlanillaXEmpleado
AND SPXE.idEmpleado = MP.idEmpleado
INNER JOIN dbo.SemanaPlanilla SP
ON SP.Id = SPXE.idSemanaPlanilla
WHERE @idSemana = SP.Id
GROUP BY MP.idEmpleado
*/
SELECT *
FROM dbo.DeduccionXEmpleado DXE
WHERE DXE.esActivo = 1

SELECT *
FROM dbo.SemanaPlanillaXEmpleado

SELECT *
FROM dbo.JornadaXEmpleadoXSemana
WHERE idSemanaPlanilla =2

SELECT  @FechaAct as FechaHoy
	  , Mov.Monto*-1 as Monto
	  , 5 as idTipoMovimiento
	  , Mov.idDXE as idDeduccionXEmpleado
	  , Mov.idEmpleado
	  , Mov.idSPXE as idSemanaPlanillaXEmpleado
FROM 
	(SELECT DXE.Id as idDXE, DXE.idEmpleado, DXE.Monto, SPXE.Id as idSPXE		
	FROM dbo.DeduccionXEmpleado DXE
	INNER JOIN dbo.Empleado E
	ON E.Id = DXE.idEmpleado
	INNER JOIN dbo.JornadaXEmpleadoXSemana JXEXS
	ON JXEXS.idEmpleado = E.Id
	AND JXEXS.idSemanaPlanilla = @idSemana
	INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
	ON SPXE.idEmpleado = E.Id
	AND SPXE.idSemanaPlanilla = @idSemana
	WHERE DXE.esActivo = 1
	) as Mov


SELECT  @FechaAct as FechaHoy
	  , Mov.SalarioBruto*TD.Valor as Monto
	  , 4 as idTipoMovimiento
	  , Mov.idEmpleado
	  , Mov.idSPXE as idSemanaPlanillaXEmpleado
FROM 
	(SELECT E.Id as idEmpleado, SPXE.SalarioBruto, SPXE.Id as idSPXE		
	FROM dbo.Empleado E
	INNER JOIN dbo.SemanaPlanillaXEmpleado SPXE
	ON SPXE.idEmpleado = E.Id
	AND SPXE.idSemanaPlanilla = @idSemana
	WHERE SPXE.idSemanaPlanilla = @idSemana
	) as Mov,
	dbo.TipoDeduccion TD
	WHERE TD.Obligatoria = 1
	AND TD.Porcentual = 2
	