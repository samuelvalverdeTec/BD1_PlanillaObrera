USE BD_Tarea3

--drop table dbo.Empleado;
--drop table dbo.Usuario;
--drop table dbo.TipoDeduccion;
--drop table dbo.DeduccionXEmpleado;

CREATE TABLE dbo.Empleado
(
	  Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY
	, Nombre VARCHAR(125) NOT NULL
	, idTipoIdentificacion INT NOT NULL
	, Identificacion VARCHAR(125) NOT NULL
	, FechaNacimiento DATETIME
	, idPuesto INT NOT NULL
	, idDepartamento INT NOT NULL
	, idUsuario INT NOT NULL
	, esActivo BIT NOT NULL DEFAULT (1)
);

CREATE TABLE dbo.TipoIdentificacion
(
	  Id INT NOT NULL PRIMARY KEY
	, Nombre VARCHAR(125) NOT NULL
);

CREATE TABLE dbo.Departamento
(
	  Id INT NOT NULL PRIMARY KEY
	, Nombre VARCHAR(125) NOT NULL
);

CREATE TABLE dbo.Puesto
(
	  Id INT NOT NULL PRIMARY KEY
	, Nombre VARCHAR(125) NOT NULL
	, SalarioXHora MONEY NOT NULL
);

ALTER TABLE [dbo].[Empleado] WITH CHECK ADD CONSTRAINT
[FK_Empleado_TipoIdentificacion] FOREIGN KEY([idTipoIdentificacion])
REFERENCES [dbo].[TipoIdentificacion] ([Id])

ALTER TABLE [dbo].[Empleado] WITH CHECK ADD CONSTRAINT
[FK_Empleado_Departamento] FOREIGN KEY([idDepartamento])
REFERENCES [dbo].[Departamento] ([Id])

ALTER TABLE [dbo].[Empleado] WITH CHECK ADD CONSTRAINT
[FK_Empleado_Puesto] FOREIGN KEY([idPuesto])
REFERENCES [dbo].[Puesto] ([Id])


CREATE TABLE dbo.TipoJornada
(
	  Id INT NOT NULL PRIMARY KEY
	, Nombre VARCHAR(50) NOT NULL
	, HoraInicio TIME NOT NULL
	, HoraFin TIME NOT NULL
);

CREATE TABLE dbo.JornadaXEmpleadoXSemana
(
	  Id INT IDENTITY NOT NULL PRIMARY KEY
	, idTipoJornada INT NOT NULL
	, idEmpleado INT NOT NULL
	, idSemanaPlanilla INT NOT NULL
);

CREATE TABLE dbo.MarcaAsistencia
(
	  Id INT IDENTITY NOT NULL PRIMARY KEY
	, FechaInicio DATETIME NOT NULL
	, FechaSalida DATETIME NOT NULL
	, idEmpleado INT NOT NULL
	, idJornadaXEmpleadoXSemana INT NOT NULL
);

CREATE TABLE dbo.SemanaPlanilla
(
	  Id INT IDENTITY NOT NULL PRIMARY KEY
	, FechaInicio DATETIME NOT NULL
	, FechaFinal DATETIME NOT NULL
	, idMesPlanilla INT NOT NULL
);

CREATE TABLE dbo.MesPlanilla
(
	  Id INT IDENTITY NOT NULL PRIMARY KEY
	, FechaInicio DATETIME NOT NULL
	, FechaFinal DATETIME NOT NULL
);

CREATE TABLE dbo.SemanaPlanillaXEmpleado
(
	  Id INT IDENTITY NOT NULL PRIMARY KEY
	, SalarioNeto MONEY NOT NULL
	, SalarioBruto MONEY NOT NULL
	, idSemanaPlanilla INT NOT NULL
	, idEmpleado INT NOT NULL
);

ALTER TABLE [dbo].[JornadaXEmpleadoXSemana] WITH CHECK ADD CONSTRAINT
[FK_JornadaXEmpleadoXSemana_TipoJornada] FOREIGN KEY([idTipoJornada])
REFERENCES [dbo].[TipoJornada] ([Id])

ALTER TABLE [dbo].[JornadaXEmpleadoXSemana] WITH CHECK ADD CONSTRAINT
[FK_JornadaXEmpleadoXSemana_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([Id])

ALTER TABLE [dbo].[JornadaXEmpleadoXSemana] WITH CHECK ADD CONSTRAINT
[FK_JornadaXEmpleadoXSemana_SemanaPlanilla] FOREIGN KEY([idSemanaPlanilla])
REFERENCES [dbo].[SemanaPlanilla] ([Id])

ALTER TABLE [dbo].[MarcaAsistencia] WITH CHECK ADD CONSTRAINT
[FK_MarcaAsistencia_JornadaXEmpleadoXSemana] FOREIGN KEY([idJornadaXEmpleadoXSemana])
REFERENCES [dbo].[JornadaXEmpleadoXSemana] ([Id])

ALTER TABLE [dbo].[MarcaAsistencia] WITH CHECK ADD CONSTRAINT
[FK_MarcaAsistencia_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([Id])

ALTER TABLE [dbo].[SemanaPlanillaXEmpleado] WITH CHECK ADD CONSTRAINT
[FK_SemanaPlanillaXEmpleado_SemanaPlanilla] FOREIGN KEY([idSemanaPlanilla])
REFERENCES [dbo].[SemanaPlanilla] ([Id])

ALTER TABLE [dbo].[SemanaPlanillaXEmpleado] WITH CHECK ADD CONSTRAINT
[FK_SemanaPlanillaXEmpleado_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([Id])

ALTER TABLE [dbo].[SemanaPlanilla] WITH CHECK ADD CONSTRAINT
[FK_SemanaPlanilla_MesPlanilla] FOREIGN KEY([idMesPlanilla])
REFERENCES [dbo].[MesPlanilla] ([Id])


CREATE TABLE dbo.TipoMovimiento
(
	  Id INT NOT NULL PRIMARY KEY
	, Nombre VARCHAR(50) NOT NULL
	, Accion INT NOT NULL
);

CREATE TABLE dbo.MovimientoPlanilla
(
	  Id INT IDENTITY NOT NULL PRIMARY KEY
	, Nombre VARCHAR(50) NOT NULL
	, Fecha DATETIME 
	, Monto MONEY NOT NULL
	, idTipoMovimiento INT NOT NULL
	, CantidadHoras INT
	, TipoHora INT
	, idMarcaAsistencia INT
	, idDeduccionXEmpleado INT
);

ALTER TABLE [dbo].[MovimientoPlanilla] WITH CHECK ADD CONSTRAINT
[FK_MovimientoPlanilla_TipoMovimiento] FOREIGN KEY(idTipoMovimiento)
REFERENCES [dbo].[TipoMovimiento] ([Id])

ALTER TABLE [dbo].[MovimientoPlanilla] WITH CHECK ADD CONSTRAINT
[FK_MovimientoPlanilla_MarcaAsistencia] FOREIGN KEY(idMarcaAsistencia)
REFERENCES [dbo].[MarcaAsistencia] ([Id])

ALTER TABLE [dbo].[MovimientoPlanilla] WITH CHECK ADD CONSTRAINT
[FK_MovimientoPlanilla_DeduccionXEmpleado] FOREIGN KEY(idDeduccionXEmpleado)
REFERENCES [dbo].[DeduccionXEmpleado] ([Id])


CREATE TABLE dbo.TipoDeduccion
(
	  Id INT NOT NULL PRIMARY KEY
	, Nombre VARCHAR(50) NOT NULL
	, Obligatoria INT NOT NULL -- 1:si / 2:no
	, Porcentual INT NOT NULL -- 1:fija(noPorcentual) / 2:porcentual
	, Valor FLOAT NOT NULL
);

CREATE TABLE dbo.DeduccionXEmpleado
(
	  Id INT IDENTITY NOT NULL PRIMARY KEY
	, idEmpleado INT NOT NULL
	, idTipoDeduccion INT NOT NULL
	, Monto MONEY
	, Porcentaje FLOAT
	, esActivo BIT NOT NULL DEFAULT 1
);
--ALTER TABLE [dbo].[DeduccionXEmpleado]
--ADD esActivo BIT NOT NULL DEFAULT 1
--ALTER TABLE [dbo].[DeduccionXEmpleado]
--DROP CONSTRAINT DF__Deduccion__esAct__2BFE89A6
--ALTER TABLE [dbo].[DeduccionXEmpleado]
--DROP COLUMN esActivo

ALTER TABLE [dbo].[DeduccionXEmpleado] WITH CHECK ADD CONSTRAINT
[FK_DeduccionXEmpleado_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([Id])

ALTER TABLE [dbo].[DeduccionXEmpleado] WITH CHECK ADD CONSTRAINT
[FK_DeduccionXEmpleado_TipoDeduccion] FOREIGN KEY([idTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([Id])



CREATE TABLE dbo.Feriado
(
	  Id INT NOT NULL PRIMARY KEY
	, Nombre VARCHAR(50) NOT NULL
	, Fecha DATE NOT NULL
);


CREATE TABLE dbo.Usuario
(
	  Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY
	, UserName VARCHAR(125) NOT NULL
	, Password VARCHAR(125) NOT NULL
	, TipoUsuario INT NOT NULL
);

ALTER TABLE [dbo].[Empleado] WITH CHECK ADD CONSTRAINT
[FK_Empleado_Usuario] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuario] ([Id])

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
