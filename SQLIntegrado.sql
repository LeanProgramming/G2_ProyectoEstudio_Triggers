/*
CREACIÓN DE PROCEDIMIENTOS Y FUNCIONES ALMACENADAS
*/


--Creación de Función definida por el usuario para cálculo de edad
DROP FUNCTION IF EXISTS [CalcularEdad]
GO

CREATE FUNCTION [CalcularEdad] (
	@FechaNacimiento date
)
RETURNS int
AS
BEGIN
	RETURN DATEDIFF(YEAR, @FechaNacimiento, GETDATE())
END


--Creación de Procedimiento para cambiar la dirección de un consorcio
DROP PROCEDURE IF EXISTS [CambiarDireccionConsorcio]
GO

CREATE PROCEDURE [CambiarDireccionConsorcio] (
	@idprovincia int = null,
	@idlocalidad int = null,
	@idconsorcio int = null,
	@direccion varchar(250) = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	BEGIN TRAN
	UPDATE consorcio
	SET direccion=@direccion
	WHERE idprovincia=@idprovincia and idlocalidad=@idlocalidad and idconsorcio=@idconsorcio
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET @error = ERROR_MESSAGE()
	ROLLBACK TRAN;
	SET @exito = 0
END CATCH
END

-- Procedimiento para cambiar importe de gastos
DROP PROCEDURE IF EXISTS [CambiarImporteGasto]
GO

CREATE PROCEDURE [CambiarImporteGasto] (
	@idgasto int = null,
	@importe decimal(8,2) = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	BEGIN TRAN
	UPDATE gasto
	SET importe=@importe
	WHERE idgasto=@idgasto
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET @error = ERROR_MESSAGE()
	ROLLBACK TRAN;
	SET @exito = 0
END CATCH
END

--Creación de Procedimiento para cambiar residencia del administrador
DROP PROCEDURE IF EXISTS [CambiarResidenciaAdministrador]
GO

CREATE PROCEDURE [CambiarResidenciaAdministrador] (
	@idadmin int = null,
	@viveahi varchar(1) = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	BEGIN TRAN
	UPDATE administrador
	SET viveahi=@viveahi
	WHERE idadmin=@idadmin
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET @error = CASE
					WHEN ERROR_MESSAGE() LIKE '%CK_habitante_viveahi%' THEN 'Valor incorrecto para el campo viveahi. Los valores posibles son S y N.'
					ELSE ERROR_MESSAGE()
					END
	ROLLBACK TRAN;
	SET @exito = 0
END CATCH
END

-- Procedimiento para Eliminar Administrador

DROP PROCEDURE IF EXISTS [EliminarAdministrador]
GO

CREATE PROCEDURE [EliminarAdministrador] (
	@idadmin int = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	IF NOT EXISTS (SELECT * FROM administrador WHERE idadmin=@idadmin)
	BEGIN
		SET @exito = 0
		SET @error = 'Administrador inexistente'
		RETURN
	END
	BEGIN TRAN
	DELETE FROM administrador
	WHERE idadmin=@idadmin
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN;
	SET @error = ERROR_MESSAGE()
	SET @exito = 0
END CATCH
END

--Procedimiento para eliminar consorcio 
DROP PROCEDURE IF EXISTS [EliminarConsorcio]
GO

CREATE PROCEDURE [EliminarConsorcio] (
	@idprovincia int = null,
	@idlocalidad int = null,
	@idconsorcio int = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	IF NOT EXISTS (SELECT * FROM consorcio WHERE idprovincia=@idprovincia and idlocalidad=@idlocalidad and idconsorcio=@idconsorcio)
	BEGIN
		SET @exito = 0
		SET @error = 'Consorcio inexistente'
		RETURN
	END
	BEGIN TRAN
	DELETE FROM consorcio
	WHERE idprovincia=@idprovincia and idlocalidad=@idlocalidad and idconsorcio=@idconsorcio
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN;
	SET @error = ERROR_MESSAGE()
	SET @exito = 0
END CATCH
END

--Procedimiento para Eliminar gasto 
DROP PROCEDURE IF EXISTS [EliminarGasto]
GO

CREATE PROCEDURE [EliminarGasto] (
	@idgasto int = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	IF NOT EXISTS (SELECT * FROM gasto WHERE idgasto=@idgasto)
	BEGIN
		SET @exito = 0
		SET @error = 'Gasto inexistente'
		RETURN
	END
	BEGIN TRAN
	DELETE FROM gasto
	WHERE idgasto=@idgasto
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN;
	SET @error = ERROR_MESSAGE()
	SET @exito = 0
END CATCH
END

--Creación de Procedimiento para insertar administrador
DROP PROCEDURE IF EXISTS [InsertarAdministrador]
GO

CREATE PROCEDURE [InsertarAdministrador] (
	@apeynom varchar(50) = null,
	@viveahi varchar(1) = null,
	@tel varchar(20) = null,
	@sexo varchar(1) = null,
	@fechnac datetime  = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	BEGIN TRAN
	INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) 
	VALUES (@apeynom, @viveahi, @tel, @sexo, @fechnac)
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET @error = CASE
					WHEN ERROR_MESSAGE() LIKE '%CK_habitante_viveahi%' THEN 'Valor incorrecto para el campo viveahi. Los valores posibles son S y N.'
					ELSE ERROR_MESSAGE()
					END
	ROLLBACK TRAN;
	SET @exito = 0
END CATCH
END

--Creación de Procedimiento para insertar consorcio
DROP PROCEDURE IF EXISTS [InsertarConsorcio]
GO

CREATE PROCEDURE [InsertarConsorcio] (
	@idprovincia int = null,
	@idlocalidad int = null,
	@idconsorcio int = null,
	@nombre varchar(50) = null,
	@direccion varchar(250)  = null,
	@idzona int = null,
	@idconserje int = null,
	@idadmin int = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	BEGIN TRAN
	INSERT INTO consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (@idprovincia, @idlocalidad, @idconsorcio, @nombre, @direccion, @idzona, @idconserje, @idadmin)
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET @error = ERROR_MESSAGE()
	ROLLBACK TRAN;
	SET @exito = 0
END CATCH
END


--Creación de Procedimiento para insertar gasto
DROP PROCEDURE IF EXISTS [InsertarGasto]
GO

CREATE PROCEDURE [InsertarGasto] (
	@idprovincia int = null,
	@idlocalidad int = null,
	@idconsorcio int = null,
	@periodo int = null,
	@fechapago datetime  = null,
	@idtipogasto int = null,
	@importe decimal(8,2) = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	BEGIN TRAN
	INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (@idprovincia, @idlocalidad, @idconsorcio, @periodo, @fechapago, @idtipogasto, @importe)
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET @error = ERROR_MESSAGE()
	ROLLBACK TRAN;
	SET @exito = 0
END CATCH
END


/*
CREACIÓN DE TABLAS AUXILIARES DE AUDITORÍA Y CREACIÓN DE TRIGGERS
*/

--Creación de la tabla auditoriaConsorcio
CREATE TABLE auditoriaConsorcio
(idprovincia       int, 
 idlocalidad       int, 
 idconsorcio       int, 
 nombre			   VARCHAR(50), 
 direccion		   VARCHAR(250), 
 idzona			   int, 
 idconserje		   int,
 idadmin		   int,
 fechayhora		   date,
 usuario		   varchar(50),
 tipoOperacion	   varchar(50)
);
GO

--Trigger para la operación de UPDATE en la tabla consorcio
CREATE TRIGGER trg_auditConsorcio_update
ON consorcio
AFTER UPDATE
AS
BEGIN
        -- Registrar los valores antes de la modificación en una tabla auxiliar
        INSERT INTO auditoriaConsorcio
        SELECT * , GETDATE(), SUSER_NAME(), 'Update'
        FROM deleted;
END;
GO

--Trigger para la operación de DELETE en la tabla consorcio
CREATE TRIGGER trg_auditConsorcio_delete
ON consorcio
AFTER DELETE
AS
BEGIN
        -- Registrar los valores antes de la eliminación en una tabla auxiliar
        INSERT INTO auditoriaConsorcio
        SELECT * , GETDATE(), SUSER_NAME(), 'Delete'
        FROM deleted;
END;
GO

--Creación de la tabla auditoriaGasto
CREATE TABLE auditoriaGasto
(idgasto                INT, 
 idprovincia			INT, 
 idlocalidad			int, 
 idconsorcio			int, 
 periodo				int, 
 fechapago				DATE, 
 idtipogasto			int,
 importe				decimal(8,2),
 fechayhora				date,
 usuario				varchar(50),
 tipoOperacion			varchar(50)
);
GO

--Trigger para la operación de UPDATE en la tabla gasto
CREATE TRIGGER trg_auditGasto_update
ON gasto
AFTER UPDATE
AS
BEGIN
        -- Registrar los valores antes de la modificación en una tabla auxiliar
        INSERT INTO auditoriaGasto
        SELECT  * , GETDATE(), SUSER_NAME(), 'Update'
        FROM deleted;
END;
GO


--Trigger para la operación de DELETE en la tabla gasto
CREATE TRIGGER trg_auditGasto_delete
ON gasto
AFTER DELETE
AS
BEGIN
    -- Registrar los valores antes de la eliminación en una tabla auxiliar
    INSERT INTO auditoriaGasto
    SELECT * , GETDATE(),SUSER_NAME(), 'Delete'
    FROM deleted;
END
GO

--Creación de la tabla auditoriaAdministrador
CREATE TABLE auditoriaAdministrador
(idadmin                INT, 
 apeynom				VARCHAR(50), 
 viveahi				VARCHAR(1), 
 tel					VARCHAR(20), 
 sexo					VARCHAR(1), 
 fechanac				DATETIME,
 fechayhora				DATE,
 usuario				VARCHAR(50),
 tipoOperacion			VARCHAR(50)
);
GO

--Trigger para la operación de UPDATE en la tabla administración
CREATE TRIGGER trg_auditAdmin_update
ON administrador
AFTER UPDATE
AS
BEGIN
        -- Registrar los valores antes de la modificación en una tabla auxiliar
        INSERT INTO auditoriaAdministrador
        SELECT  * , GETDATE(), SUSER_NAME(), 'Update'
        FROM deleted;
END;
GO

--Trigger para la operación de DELETE en la tabla administración
CREATE TRIGGER trg_auditAdmin_delete
ON administrador
AFTER DELETE
AS
BEGIN
    -- Emite un mensaje y prevenir la operación de eliminación
    RAISERROR('La eliminación de registros en la tabla Administrador no está permitida.', 16, 1);
    ROLLBACK;
END
GO

/*
INDICES COLUMNARES
*/


/*
En el siguiente script se crea una tabla gastonew apartir de la tabla gasto para poder comparar
los tiempos de ejecucion de consultas entre una tabla indexada de manera columnar y otra que no.
*/

-- Se crea la tabla solicitada apartir de la tabla GASTO
CREATE TABLE [dbo].[gastonew](
    [idgasto] [int] IDENTITY(1,1) NOT NULL,
    [idprovincia] [int] NULL,
    [idlocalidad] [int] NULL,
    [idconsorcio] [int] NULL,
    [periodo] [int] NULL,
    [fechapago] [datetime] NULL,
    [idtipogasto] [int] NULL,
    [importe] [decimal](8, 2) NULL,
    CONSTRAINT [PK_gastonew] PRIMARY KEY CLUSTERED ([idgasto] ASC),
    CONSTRAINT [FK_gasto_consorcio_new] FOREIGN KEY ([idprovincia], [idlocalidad], [idconsorcio])
    REFERENCES [dbo].[consorcio] ([idprovincia], [idlocalidad], [idconsorcio]),
    CONSTRAINT [FK_gasto_tipo_new] FOREIGN KEY ([idtipogasto])
    REFERENCES [dbo].[tipogasto] ([idtipogasto])
);


/*
Se agrega el nonclustered columnstore index a todas las columnas de la tabla gastonew.
*/

-- Crear un �ndice columnar no agrupado 
CREATE NONCLUSTERED COLUMNSTORE INDEX IX_GASTONEW_Columnar
ON dbo.GASTONEW
(
    idprovincia,
    idlocalidad,
    idconsorcio,
    periodo,
    fechapago,
    idtipogasto,
    importe
);


/*
Luego se agrega un millon de registros en ambas tablas para poder comparar tiempos de ejecucion.
*/


-- Se inserta 1.000.000 de registros a la tabla GASTONEW

-- Deshabilita las restricciones de clave externa para un mejor rendimiento
ALTER TABLE dbo.gastonew NOCHECK CONSTRAINT ALL;

DECLARE @counter INT = 1;

WHILE @counter <= 1000000
BEGIN
    INSERT INTO dbo.gastonew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    VALUES (
        -- Valores aleatorios para cada columna
        CAST((RAND() * (5-1) + 1) AS INT), -- idprovincia (aleatorio entre 1 y 5)
        CAST((RAND() * (5-1) + 1) AS INT), -- idlocalidad (aleatorio entre 1 y 5)
        CAST((RAND() * (40-1) + 1) AS INT), -- idconsorcio (aleatorio entre 1 y 40)
        CAST((RAND() * (9-1) + 1) AS INT), -- periodo (aleatorio entre 1 y 9)
        GETDATE(), -- fechapago (fecha y hora actual)
        CAST((RAND() * (5-1) + 1) AS INT), -- idtipogasto (aleatorio entre 1 y 5)
        CAST((RAND() * (400000-55000) + 55000) AS DECIMAL(8,2)) -- importe (aleatorio entre 50000 y 300000)
    );
    
    SET @counter = @counter + 1;
END;

-- Vuelve a habilitar las restricciones de clave externa
ALTER TABLE dbo.gastonew CHECK CONSTRAINT ALL;
GO



-- Se completa a 1.000.000 de registros a la tabla GASTO

-- Deshabilita las restricciones de clave externa para un mejor rendimiento
ALTER TABLE dbo.gasto NOCHECK CONSTRAINT ALL;

DECLARE @counter INT = 1;

WHILE @counter <= 992000
BEGIN
    INSERT INTO dbo.gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    VALUES (
        -- Valores aleatorios para cada columna
        CAST((RAND() * (5-1) + 1) AS INT), -- idprovincia (aleatorio entre 1 y 5)
        CAST((RAND() * (5-1) + 1) AS INT), -- idlocalidad (aleatorio entre 1 y 5)
        CAST((RAND() * (40-1) + 1) AS INT), -- idconsorcio (aleatorio entre 1 y 400)
        CAST((RAND() * (9-1) + 1) AS INT), -- periodo (aleatorio entre 1 y 9)
        GETDATE(), -- fechapago (fecha y hora actual)
        CAST((RAND() * (5-1) + 1) AS INT), -- idtipogasto (aleatorio entre 1 y 5)
        CAST((RAND() * (400000-55000) + 55000) AS DECIMAL(8,2)) -- importe (aleatorio entre 50000 y 300000)
    );
    
    SET @counter = @counter + 1;
END;

-- Vuelve a habilitar las restricciones de clave externa
ALTER TABLE dbo.gasto CHECK CONSTRAINT ALL;
GO

