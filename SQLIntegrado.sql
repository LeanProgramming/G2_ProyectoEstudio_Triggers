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

/*
Creación de tablas auxiliares de auditoría y creación de TRIGGERS
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

USE [base_consorcio]
GO

DROP PROCEDURE IF EXISTS [CambiarImporteGasto]
GO

-- Procedimiento para cambiar importe de gastos

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