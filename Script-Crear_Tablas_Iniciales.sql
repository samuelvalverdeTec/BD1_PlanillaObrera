USE BD_Tarea3

--drop table dbo.Empleado;

CREATE TABLE dbo.Empleado
(
	  Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY
	, Nombre VARCHAR(125) NOT NULL
	, idTipoIdentificacion INT NOT NULL
	, Identificacion VARCHAR(125) NOT NULL
	, FechaNacimiento DATETIME NOT NULL
	, idPuesto INT NOT NULL
	, idDepartamento INT NOT NULL
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
REFERENCES [dbo].[TipoIdentificacion] ([Id])ALTER TABLE [dbo].[Empleado] WITH CHECK ADD CONSTRAINT
[FK_Empleado_Departamento] FOREIGN KEY([idDepartamento])
REFERENCES [dbo].[Departamento] ([Id])ALTER TABLE [dbo].[Empleado] WITH CHECK ADD CONSTRAINT
[FK_Empleado_Puesto] FOREIGN KEY([idPuesto])
REFERENCES [dbo].[Puesto] ([Id])CREATE TABLE dbo.UsuarioAdministrador(	  Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY	, Nombre VARCHAR(125) NOT NULL	, Password VARCHAR(125) NOT NULL	, TipoUsuario INT NOT NULL);CREATE TABLE [dbo].[DBErrors](
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