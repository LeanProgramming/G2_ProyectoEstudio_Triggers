USE [base_consorcio]
GO

----------------------------------------Inserción de lote de datos de prueba para Procedimientos y funciones almacenadas---------------------------------------------------------

-- INSERTANDO UTILIZANDO PROCEDIMIENTO ALMACENADO
DECLARE @exito bit
DECLARE @error varchar(200)

EXEC dbo.InsertarAdministrador 'CAROLINA GARNACHO', 'S', '3794123456', 'S', '1975-06-15', @exito out, @error out
SELECT Exito=@exito, Error=@error
SELECT @exito=NULL, @error=NULL

EXEC dbo.InsertarAdministrador 'FERNANDA CORREA', 'N', '3794654987', 'F', '1966-03-06', @exito out, @error out
SELECT Exito=@exito, Error=@error
SELECT @exito=NULL, @error=NULL

EXEC dbo.InsertarAdministrador 'GASTON DE PAUL', 'N', '3795456123', 'M', '1956-05-24', @exito out, @error out
SELECT Exito=@exito, Error=@error
SELECT @exito=NULL, @error=NULL

-- ELIMINANDO UTILIZANDO PROCEDIMIENTO ALMACENADO
DECLARE @exito bit
DECLARE @error varchar(200)

EXEC dbo.EliminarAdministrador 15, @exito out, @error out
SELECT Exito=@exito, Error=@error
SELECT @exito=NULL, @error=NULL

-- MODIFICANDO UTILIZANDO PROCEDIMIENTO ALMACENADO
DECLARE @exito bit
DECLARE @error varchar(200)

EXEC dbo.CambiarResidenciaAdministrador 15, 'G', @exito out, @error out
SELECT Exito=@exito, Error=@error
SELECT @exito=NULL, @error=NULL

EXEC dbo.CambiarResidenciaAdministrador 15, 'S', @exito out, @error out
SELECT Exito=@exito, Error=@error
SELECT @exito=NULL, @error=NULL

-- UTILIZANDO FUNCION PARA CALCULAR EDAD

SELECT [Nombre y Apellido]=apeynom, [Edad]=dbo.[CalcularEdad](fechnac) FROM administrador 


------------------------------------------Inserción de lote de datos de prueba para Procedimientos y funciones almacenadas---------------------------------------------------------

/*Prueba para Insert, Update y Delete en la tabla administrador*/

INSERT into administrador values ('pepito','s','213457', 'm','19941120')

update administrador set apeynom = 'PEPIÑA' where idadmin = 175

delete from administrador where idadmin = 175
GO

/*Prueba para Insert y Update en la tabla consorcio*/

INSERT into consorcio values ( 1,3,1,'edificio-123', 'rioja Nº648',null,null,1) 

update consorcio set direccion = 'GOBERNADOR PAMPIN N° 337 - 2° piso - Unidad 9' where idadmin = 1

update consorcio set direccion = 'GOBERNADOR Lagraña N° 358 - 1° piso - Unidad 3' where idconsorcio = 1

update consorcio set direccion = 'Paraguay 387 - Planta Baja' where idconsorcio = 1

update consorcio set direccion = 'Paraguay 387 - Planta Baja' where idadmin = 1

SELECT * FROM auditoriaConsorcio
GO

SELECT * FROM consorcio

SELECT * FROM GASTO

/*Pruebas de borrado en tablas gasto, inmueble y consorcio*/

DELETE FROM GASTO WHERE idprovincia = 1 AND idlocalidad = 1 AND idconsorcio = 1

DELETE FROM INMUEBLE WHERE idprovincia = 1 AND idlocalidad = 1 AND idconsorcio = 1

SELECT * FROM INMUEBLE

DELETE FROM consorcio WHERE idprovincia =1 AND idlocalidad=1 AND idconsorcio=1

SELECT * FROM auditoriaConsorcio

---------------------------------------------------------- Transacciones -----------------------------------------------------------

---Con error en la transacción---
BEGIN TRY
	BEGIN TRAN
	
	--Inserción registro administrador
	INSERT INTO administrador(apeynom,viveahi,tel,sexo,fechnac) values ('Juan Pablo Duete', 'S', '3794000102', 'M', '19890625')
	
	--Inserción registro consorcio
	INSERT INTO consorcio(idprovincia,idlocalidad,idconsorcio, Nombre,direccion,idzona,idconserje,idadmin)
	VALUES (7, 7, 1, 'EDIFICIO-24500', '9 de julio Nº 1650', 2, Null, (select top 1 idadmin from administrador order by idadmin desc))--id del último administrador
	
	--Inserción 3 registros gasto
	INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
	VALUES (30, 7, 1,1,'20231005',2,5000.00)

	INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
	VALUES (7, 7, 1,1,'20231015',2,20000.00)

	INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
	VALUES (7, 7, 1,1,'20231028',2,10000.00)

	COMMIT TRAN
END TRY

BEGIN CATCH
	SELECT ERROR_MESSAGE() As Error-- Se captura el error y lo muestra.
	ROLLBACK TRAN
END CATCH
 
--Controlar la realizacion de las inserciones------------------------------------------------------------------
select * from administrador where apeynom = 'Juan Pablo Duete'
select * from consorcio where idprovincia = 7 --No existen en principio consorcios en la provincia de Corrientes
select * from gasto where idprovincia = 7
------------------------------------------------------------------------------------------------------------------

---Sin error en la transacción---
BEGIN TRY
	BEGIN TRAN
	
	--Inserción registro administrador
	INSERT INTO administrador(apeynom,viveahi,tel,sexo,fechnac) values ('Juan Pablo Duete', 'S', '3794000102', 'M', '19890625')
	
	--Inserción registro consorcio
	INSERT INTO consorcio(idprovincia,idlocalidad,idconsorcio, Nombre,direccion,idzona,idconserje,idadmin)
	VALUES (7, 7, 1, 'EDIFICIO-24500', '9 de julio Nº 1650', 2, Null, (select top 1 idadmin from administrador order by idadmin desc))--id del último administrador
	
	--Inserción 3 registros gasto
	INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
	VALUES (7, 7, 1,1,'20231005',2,5000.00)

	INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
	VALUES (7, 7, 1,1,'20231015',2,20000.00)

	INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
	VALUES (7, 7, 1,1,'20231028',2,10000.00)

	COMMIT TRAN
END TRY

BEGIN CATCH
	SELECT ERROR_MESSAGE() As Error-- Se captura el error y lo muestra.
	ROLLBACK TRAN
END CATCH

--Controlar la realizacion de las inserciones------------------------------------------------------------------
select * from administrador where apeynom = 'Juan Pablo Duete'
select * from consorcio where idprovincia = 7 --No existen en principio consorcios en la provincia de Corrientes
select * from gasto where idprovincia = 7
------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------TRANSACCIONES ANIDADAS----------------------------------------------------------------

---Con error en la transacción---
SET LANGUAGE Spanish; 

BEGIN TRY
	BEGIN TRAN TS_Anidadas
	SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos' --Esta sentencia cuenta el número de transacciones anidadas
		BEGIN TRAN TS_InsertarAdmin
			--Inserción registro administrador
			SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos'
			INSERT INTO administrador(apeynom,viveahi,tel,sexo,fechnac) values ('Juan José Paso', 'S', '3794000102', 'M', '19890625')
		COMMIT TRAN TS_InsertarAdmin	
		BEGIN TRAN TS_InsertarConsorcio
			--Inserción registro consorcio
			SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos'
			INSERT INTO consorcio(idprovincia,idlocalidad,idconsorcio, Nombre,direccion,idzona,idconserje,idadmin)
			VALUES (7, 7, 2, 'EDIFICIO-24500', '9 de julio Nº 1650', 2, Null, (select top 1 idadmin from administrador order by idadmin desc))
			--Para insertar el id del último administrador se hace un select del ultimo id de administrador insertado.
			
			BEGIN TRAN TS_InsertarGastos
				SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos'
				--Inserción 3 registros de gastos
				INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
				VALUES (7, 7, 2,1,'20231005',2,5000.00)

				INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
				VALUES (7, 7, 2,1,'20231015',2,20000.00)

				INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
				VALUES (7, 7, 10,1,'20231028',2,10000.00)
			COMMIT TRAN TS_InsertarGastos
		COMMIT TRAN TS_InsertarConsorcio
	COMMIT TRAN TS_Anidadas
END TRY

BEGIN CATCH
	SELECT ERROR_MESSAGE() As Error -- Se captura el error y lo muestra.
	ROLLBACK TRAN TS_Anidadas
END CATCH


 ---Controlar la realizacion de las inserciones----------------------------------------------------------------------------------
select * from administrador where apeynom = 'Juan José Paso'
select * from consorcio where idprovincia = 7  and idconsorcio = 10 --No existe el consorcio n° 10 en la provincia de Corrientes
select * from gasto where idprovincia = 7 and idconsorcio = 10
---------------------------------------------------------------------------------------------------------------------------------

---Sin error en la transacción---
SET LANGUAGE Spanish; 

BEGIN TRY
	BEGIN TRAN TS_Anidadas
	SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos' --Esta sentencia cuenta el número de transacciones anidadas
		BEGIN TRAN TS_InsertarAdmin
			--Inserción registro administrador
			SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos'
			INSERT INTO administrador(apeynom,viveahi,tel,sexo,fechnac) values ('Juan José Paso', 'S', '3794000102', 'M', '19890625')
		COMMIT TRAN TS_InsertarAdmin	
		BEGIN TRAN TS_InsertarConsorcio
			--Inserción registro consorcio
			SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos'
			INSERT INTO consorcio(idprovincia,idlocalidad,idconsorcio, Nombre,direccion,idzona,idconserje,idadmin)
			VALUES (7, 7, 2, 'EDIFICIO-24500', '9 de julio Nº 1650', 2, Null, (select top 1 idadmin from administrador order by idadmin desc))
			--Para insertar el id del último administrador se hace un select del ultimo id de administrador insertado.
			
			BEGIN TRAN TS_InsertarGastos
				SELECT CONCAT('El nivel de anidamiento es ', @@TRANCOUNT) As 'Numero de anidamientos'
				--Inserción 3 registros de gastos
				INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
				VALUES (7, 7, 2,1,'20231005',2,5000.00)

				INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
				VALUES (7, 7, 2,1,'20231015',2,20000.00)

				INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
				VALUES (7, 7, 2,1,'20231028',2,10000.00)
			COMMIT TRAN TS_InsertarGastos
		COMMIT TRAN TS_InsertarConsorcio
	COMMIT TRAN TS_Anidadas
END TRY

BEGIN CATCH
	SELECT ERROR_MESSAGE() As Error -- Se captura el error y lo muestra.
	ROLLBACK TRAN TS_Anidadas
END CATCH


 ---Controlar la realizacion de las inserciones------------------------------------------------------------------------------------------------
select * from administrador where apeynom = 'Juan José Paso'
select * from consorcio where idprovincia = 7  and idconsorcio = 2 --No existe el consorcio n° 2 hasta el momento en la provincia de Corrientes
select * from gasto where idprovincia = 7 and idconsorcio = 2




/*
---------------------------------------------------------PRUEBAS PARA INDICES COLUMNARES---------------------------------------------------------
*/


-- Declarar variables de tiempo
DECLARE @StartTime DATETIME;
DECLARE @EndTime DATETIME;
DECLARE @ValorSinColumnstore BIGINT;
DECLARE @ValorConColumnstore BIGINT;

--TEST 1 SOBRE FUNCION SUM()

-- PARTE 1: TABLA GASTO
-- Ejecutar una consulta para comparar el rendimiento de ambas tablas
-- Tiempo de inicio
 
SET @StartTime = GETDATE();
-- Consulta en la tabla sin índice de Columnstore
SELECT @ValorSinColumnstore = SUM(importe) FROM gasto;
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 1) SUM(importe) sin columnstore' AS Tabla, @ValorSinColumnstore AS Cantidad, DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;


--PARTE 2: TABLA GASTONEW
-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla con índice de Columnstore
SELECT @ValorConColumnstore = SUM(importe) FROM gastonew ;
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 1) SUM(importe) con columnstore' AS Tabla, @ValorConColumnstore AS Cantidad, DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;

------------------------------------------------------------------------------------------
--TEST 2: FUNCION AVG()

--PARTE 1: TABLA GASTO

-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla sin índice de Columnstore
SELECT @ValorSinColumnstore = AVG(importe) FROM gasto;
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 2) AVG(importe) sin columnstore' AS Tabla, @ValorSinColumnstore AS Cantidad, DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;


--PARTE 2: TABLA GASTONEW
 
-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla con índice de Columnstore
SELECT @ValorConColumnstore = AVG(importe) FROM gastonew;
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 2) AVG(importe) con columnstore' AS Tabla, @ValorConColumnstore AS Cantidad, DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;

------------------------------------------------------------------------------------------
--TEST 3: FUNCION COUNT()

--PARTE 1: TABLA GASTO

-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla sin índice de Columnstore
SELECT @ValorSinColumnstore = COUNT(*) FROM gasto WHERE idconsorcio <= 250;
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 3) COUNT(*) sin columnstore' AS Tabla, @ValorSinColumnstore AS Cantidad, DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;


--PARTE 2: TABLA GASTONEW
 
-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla con índice de Columnstore
SELECT @ValorConColumnstore = COUNT(*) FROM gastonew WHERE idconsorcio <= 250;
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 3) COUNT(*) con columnstore' AS Tabla, @ValorConColumnstore AS Cantidad, DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;

------------------------------------------------------------------------------------------
--TEST 4: CONSULTA CON SELECT

--PARTE 1: TABLA GASTO
 
-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla sin índice de Columnstore
SELECT *
FROM gasto
WHERE idconsorcio <= 250
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 4) SELECT sin columnstore' AS Tabla,  DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;

--PARTE 2: TABLA GASTONEW

-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla con índice de Columnstore 
SELECT *
FROM gastonew
WHERE idconsorcio <= 250
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 4) SELECT con columnstore' AS Tabla,  DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;

 ------------------------------------------------------------------------------------------

--TEST 5: USO DE COMBINACIONES JOIN

--PARTE 1: TABLA GASTO
 
-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla sin índice de Columnstore
SELECT gn.* , pro.*
FROM gasto as gn
join provincia as pro on gn.idprovincia = pro.idprovincia
WHERE idconsorcio <= 250 and pro.idprovincia = 1
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 5) SELECT/JOIN sin columnstore' AS Tabla,  DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;

--PARTE 2: TABLA GASTONEW
 
-- Tiempo de inicio
SET @StartTime = GETDATE();
-- Consulta en la tabla con índice de Columnstore 
SELECT gn.* , pro.*
FROM gastonew as gn
join provincia as pro on gn.idprovincia = pro.idprovincia
WHERE idconsorcio <= 250 and pro.idprovincia = 1
-- Tiempo de finalización
SET @EndTime = GETDATE();
-- Calcular el tiempo transcurrido
SELECT 'TEST 5) SELECT/JOIN con columnstore' AS Tabla,  DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS TiempoTranscurrido;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------Backup y Restore. Backup en Linea ---------------------------------------------------------


--Use Master

------------------------------------------------------------------------------------------------------

/* 1)Verificar que el mode de recuperación de la base de datos este en el modo adecuado para realizar backup en linea */
------------------------------------------------------------------------------------------------------

/* Esta línea indica que se seleccionarán dos columnas de la tabla sys.databases. 
Estas columnas son name (que contiene el nombre de la base de datos) y recovery_model_desc 
(que contiene el modo de recuperación de la base de datos). */
SELECT name, recovery_model_desc

/* Esta línea especifica la tabla de la cual se seleccionarán los datos. sys.databases es una 
vista del sistema en SQL Server que contiene información sobre todas las bases de datos en la instancia de SQL Server. */
FROM sys.databases

/* Esta línea especifica la tabla de la cual se seleccionarán los datos. sys.databases es una vista del sistema en SQL Server que contiene información sobre todas las bases de datos en la instancia de SQL Server.*/
WHERE name = 'base_consorcio'

/* Esta parte de la sentencia indica que se realizará una acción en la base de datos llamada "base_consorcio". Específicamente, se realizará un cambio en su configuración. */
ALTER DATABASE base_consorcio SET RECOVERY FULL;

/* Esta parte de la sentencia establece el nuevo modo de recuperación de la base de datos como "FULL". En el modo de recuperación completa, SQL Server mantiene un registro completo de todas las transacciones, lo que permite realizar copias de seguridad en línea y restauraciones hasta el punto exacto de una transacción. */
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio'


------------------------------------------------
/* 2) Realizar un backup full de la base de datos */
------------------------------------------------

Use base_consorcio

/* Aquí se declara una variable llamada @Fecha con un tipo de datos VARCHAR de longitud 200. Esta variable se usará para almacenar la fecha y hora actual en un formato específico. */
DECLARE @Fecha VARCHAR(200)

/* Aquí se asigna un valor a la variable @Fecha la cual sera el resultado de la siguiente operacion, la cual convierte a VARCHAR la fecha actual */
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

/* Se declara una segunda variable llamada @DireccionCarpeta con un tipo de datos VARCHAR de longitud 400. Esta variable se usará para almacenar la ruta del archivo de respaldo de la base de datos. */
Declare @DireccionCarpeta Varchar(400)

/* En esta línea,se asigna el valor que tomara la variable @DireccionCarpeta la cual sera la ruta del archivo de respaldo para la base de datos */
Set @DireccionCarpeta = 'C:\Backup\Consorcio ' + @Fecha + '.bak'

/* Esta es la sentencia donde se ejecuta el BACKUP de la base de datos llamada base_consorcio en el archivo especificado por la variable @DireccionCarpeta */
BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta

/* WITH INIT: Indica que se está realizando una copia de seguridad inicial. Si ya existen copias de seguridad en el archivo de respaldo, esta opción las sobrescribe.
NAME = 'base_consorcio': Aquí se asigna un nombre a la copia de seguridad.
STATS = 10: Muestra información de progreso en la operación de copia de seguridad cada vez que se completen 10 porcentajes de la operación. */
WITH INIT, NAME = 'base_consorcio', STATS = 10

-----------------------------------------------
/* 3) Generar 10 inserts sobre la  tabla gasto */
-----------------------------------------------

INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,6,'20130720',5,708.97)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,3,'20130312',3,58026.65)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,7,'20130709',3,72573.61)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,7,'20130718',3,11137.20)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,8,'20130802',2,2033.99)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,1,'20130111',4,532.22)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,7,'20130426',4,5243.66)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,8,'20130802',3,2910.70)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,8,'20130823',3,403.09)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,3,'20130311',3,8853.68)

Select * From gasto

-----------------------------------------------------------------------
/* 4) Realizar backup del archivo de log y registrar la hora del backup */
------------------------------------------------------------------------

--Para realizar el backup de log, utilizamos la misma sentencia que para el backup con la extension .bak, solamente cambiamos algunos parametros, como el nombre del archivo y la extension.

DECLARE @Fecha VARCHAR(200)
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

Declare @DireccionCarpeta Varchar(400)
Set @DireccionCarpeta = 'C:\Backup\LogBackupConsorcio ' + @Fecha + '.trn'

BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta
WITH INIT, NAME = 'base_consorcio', STATS = 10

----------------------------------------------------
/* 5) Generar otros 10 insert sobre la tabla gasto. */
----------------------------------------------------

INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,3,1,11,'20161105',1,4888.92)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,3,1,7,'20160722',5,970.72)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,2,'20160224',4,8264.97)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,7,'20160728',1,3317.89)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,2,'20160212',1,9002.84)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,3,'20160319',2,4043.28)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,2,'20160218',5,288.56)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,8,'20160818',5,426.35)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,8,'20160802',4,4789.37)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,10,'20161022',5,431.32)

Select * From gasto

---------------------------------------------------------------------------
/* 6) Realizar nuevamente backup de archivo de log  en otro archivo fisico. */
---------------------------------------------------------------------------

DECLARE @Fecha VARCHAR(200)
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

Declare @DireccionCarpeta Varchar(400)
Set @DireccionCarpeta = 'C:\Backup\LogBackupConsorcio ' + @Fecha + '.trn'

BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta
WITH INIT, NAME = 'base_consorcio', STATS = 10

------------------------------------------------------------------------------------------------------------------------------
/* 7) Restaurar la base de datos al momento del primer backup del archivo de log. Es decir después de los primeros 10 insert. */
------------------------------------------------------------------------------------------------------------------------------

/* Para realizar la restauracion utilizamos la misma sentencia que para la restauracion de la base de datos con los archivos '.bak' solamente realizacion unas modificaciones en la extension del archivo busado */

use master

DECLARE @NombreDataBase VARCHAR(200) = 'base_consorcio';

DECLARE @Ubicacion NVARCHAR(128);

SELECT @Ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
  AND RIGHT(m.physical_device_name, 4) = '.trn' -- Filtrar por la extensión ".trn"
  AND m.physical_device_name LIKE '%LogBackupConsorcio Nov 29 2023  5.12PM%' -- Filtrar por el nombre del archivo
ORDER BY b.backup_start_date DESC;

RESTORE Database base_consorcio
FROM DISK = @Ubicacion
WITH REPLACE;

--use base_consorcio

--select * from gasto

-----------------------------------------------------------------
/* 8) Restaurar la base de datos aplicando ambos archivos de log. */
----------------------------------------------------------------

--use master

--Restauracion de los 2 archivos de log. 

DECLARE @NombreDataBase VARCHAR(200) = 'base_consorcio';
DECLARE @Ubicacion NVARCHAR(128);

SELECT @Ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
  AND RIGHT(m.physical_device_name, 4) = '.trn' -- Filtrar por la extensión ".trn"
  AND m.physical_device_name LIKE '%LogBackupConsorcio Nov 29 2023  5.12PM%' -- Filtrar por el nombre del archivo
ORDER BY b.backup_start_date DESC;

RESTORE Database base_consorcio
FROM DISK = @Ubicacion
WITH REPLACE;

SELECT @Ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
  AND RIGHT(m.physical_device_name, 4) = '.trn' -- Filtrar por la extensión ".trn"
  AND m.physical_device_name LIKE '%LogBackupConsorcio Nov 29 2023  5.19PM%' -- Filtrar por el nombre del archivo
ORDER BY b.backup_start_date DESC;

RESTORE Database base_consorcio
FROM DISK = @Ubicacion
WITH REPLACE;

--use base_consorcio

--Select * From gasto

--------------------------------------------------------VISTAS INDEXADAS. ---------------------------------------------------------
USE base_consorcio;
GO
/*
Crear una vista sobre la tabla administrador que solo muestre los campos apynom, sexo y fecha de nacimiento.
*/
CREATE VIEW VistaAdministrador
AS SELECT apeynom, sexo, fechnac
FROM administrador;
go

/*
Realizar insert de un lote de datos sobre la vista recien creada. Verificar el resultado en la tabla administrador.
*/
INSERT INTO VistaAdministrador (apeynom, sexo, fechnac) VALUES ('ROMAN GABRIEL ESTEBAN', 'M', '19981222');
INSERT INTO VistaAdministrador (apeynom, sexo, fechnac) VALUES ('GARCETTE FERNANDO', 'M', '19971018');
SELECT * FROM administrador;
SELECT * FROM VistaAdministrador;
go

/*
Realizar update sobre algunos de los registros creados y volver a verificar el resultado en la tabla.
*/
UPDATE VistaAdministrador
SET apeynom = 'ROMAN GABRIEL'
WHERE apeynom = 'ROMAN GABRIEL ESTEBAN'
go

/* 
Crear una vista que muestre los datos de las columnas de las siguientes tablas: 
(Administrador->Apeynom, consorcio->Nombre, gasto->periodo, gasto->fechaPago, tipoGasto->descripcion) .
*/
CREATE VIEW vista_adm_gasto_consorcio WITH SCHEMABINDING AS
	SELECT
		a.apeynom as nombre_admin,
		c.nombre as nombre_consorcio,
		g.idgasto as idGasto,
		g.periodo as periodo,
		g.fechapago as fecha_pago,
		tp.descripcion as tipo_gasto
	FROM 
		dbo.administrador a 
		JOIN dbo.consorcio c ON a.idadmin = c.idadmin
		JOIN dbo.gasto g ON c.idadmin = g.idconsorcio
		JOIN dbo.tipogasto tp ON g.idtipogasto = tp.idtipogasto
GO
select * from vista_adm_gasto_consorcio;

--index único agrupado
CREATE UNIQUE CLUSTERED INDEX UX_aplicacion ON vista_adm_gasto_consorcio(nombre_admin, nombre_consorcio, idGasto);

--index no agrupado
CREATE NONCLUSTERED INDEX IDX_fechapago ON vista_adm_gasto_consorcio(fecha_pago);

/*
ver estadistica de la vista indexada 
*/
DBCC SHOW_STATISTICS('dbo.vista_adm_gasto_consorcio', 'IDX_fechapago');

/*
Creamos un vista donde la consula nos devolvera datos del administrador del consorcio (idAdministrador, 
nombre_administrador, nombre_consorcio) y el monto total de los gastos realizados(gasto_total) acompañado del
numero total de gastos realizados(row_count).
Esta vista es para entender como se crea un indice. Ya que es una vista con pocos registros.
*/
CREATE VIEW vista_ejemplo_index WITH SCHEMABINDING AS
	SELECT 
		a.idadmin as idAdministrador,
		a.apeynom as nombre_administrador,
		c.nombre as nombre_consorcio,
		SUM(ISNULL(g.importe, 0)) as gasto_total,
		COUNT_BIG(*) as row_count
	FROM 
		dbo.administrador a 
		JOIN dbo.consorcio c ON a.idadmin = c.idadmin
		JOIN dbo.gasto g ON c.idconsorcio = g.idconsorcio
	GROUP BY a.idadmin, a.apeynom, c.nombre;
GO

/* Se crea un indice cluster sobre la columna idAdministrador, nombre_administrador, nombre_consorcio */
CREATE UNIQUE CLUSTERED INDEX IDX_ejemplo_id 
	ON vista_ejemplo_index(idAdministrador, nombre_administrador, nombre_consorcio);
GO 

DBCC SHOW_STATISTICS('dbo.vista_ejemplo_index', 'IDX_ejemplo_id');
GO

---------------------------
---Vistas segunda parte.---
---------------------------

/*
	Se puede agregar el indice no cluster a la vista que ya se presento.
*/
GO
CREATE VIEW vista_gastos WITH SCHEMABINDING AS
SELECT 
		c.nombre,
		tp.descripcion,
		g.importe,
		g.idgasto
FROM dbo.gasto g
	JOIN dbo.consorcio c ON g.idprovincia = c.idprovincia AND g.idlocalidad = c.idlocalidad AND g.idconsorcio = c.idconsorcio
	JOIN dbo.tipogasto tp ON g.idtipogasto = tp.idtipogasto
GO

CREATE UNIQUE CLUSTERED INDEX IDX_cluster_vista_gastos_idgasto ON vista_gastos(idgasto);
CREATE NONCLUSTERED INDEX IDX_ncluster_vista_gastos_tipogasto ON vista_gastos(descripcion);
GO

/*
	En este caso para no incluir tantos campos utilizamos como cluster en consorcio->nombre, aunque no es porque se puede crear
	un consorcio con el mismo nombre.
*/
CREATE VIEW vista_consorcios WITH SCHEMABINDING AS
SELECT 
	c.nombre AS nombreConsorcio,
	i.cant_dpto AS cantDepartamentos,
	p.descripcion AS provincia,
	l.descripcion AS localidad,
	z.descripcion AS zona
FROM dbo.consorcio c 
	JOIN dbo.zona z ON c.idzona = z.idzona 
	JOIN dbo.provincia p ON c.idprovincia = p.idprovincia
	JOIN dbo.localidad l ON c.idprovincia = l.idprovincia AND c.idlocalidad = l.idlocalidad
	JOIN dbo.inmueble i ON c.idprovincia = i.idprovincia AND c.idlocalidad = i.idlocalidad AND c.idconsorcio = i.idconsorcio
GO

CREATE UNIQUE CLUSTERED INDEX IDX_cluster_vista_consorcios_nombreConsorcio ON vista_consorcios(nombreConsorcio);
CREATE NONCLUSTERED INDEX IDX_ncluster_vista_consorcios_zona ON vista_consorcios(zona);
GO

/**/
CREATE VIEW vista_conserjes WITH SCHEMABINDING AS
	SELECT
		c.idconserje AS idConserje,
		conserje.apeynom AS nombreConserje,
		p.descripcion AS provincia,
		l.descripcion AS localidad
	FROM dbo.consorcio c 
		JOIN dbo.conserje  ON c.idconserje = conserje.idconserje
		JOIN dbo.provincia p ON c.idprovincia = p.idprovincia
		JOIN dbo.localidad l ON c.idprovincia = l.idprovincia AND c.idlocalidad = l.idlocalidad 
GO

CREATE UNIQUE CLUSTERED INDEX IDX_cluster_vista_conserje_idConserje ON vista_conserjes (idConserje);
CREATE NONCLUSTERED INDEX IDX_ncluster_vista_conserje_zona ON vista_conserjes (provincia);
GO

-------------------------------------------------------------------------------------------------------------
/*
Definimos un vista donde la consula nos devolvera información sobre provincias (idprovincia, descripcion), localidades (descripcion) y consorcios (nombre).
Solo muestra las provincias que tienen asociado un consorcio.
*/

CREATE VIEW vista_provincia_consorcio_localidad WITH SCHEMABINDING AS
SELECT 
       p.idprovincia,
       p.descripcion AS "Provincia",
       l.descripcion AS "Localidad", 
	   c.nombre AS "Consorcio"
FROM  dbo.provincia p
JOIN  dbo.localidad l ON p.idprovincia = l.idprovincia
JOIN  dbo.consorcio c ON l.idprovincia = c.idprovincia AND l.idlocalidad = c.idlocalidad
GO
--index único agrupado
CREATE UNIQUE CLUSTERED INDEX UX_VistaProvinciaConsorcioLocalidad 
ON dbo.vista_provincia_consorcio_localidad (idprovincia, Provincia, Localidad, Consorcio);
GO

SELECT * FROM vista_provincia_consorcio_localidad
GO

------------------------------*-*-Vista de cada Tabla-*-*------------------------------------
/*
Crear la vista para filtrar información sensible del conserje
*/
CREATE VIEW dbo.VistaConserje WITH SCHEMABINDING AS
SELECT
    idconserje,
    apeynom AS nombre,
    tel AS telefono
FROM 
    dbo.conserje;
GO

-- Crear la vista indexada
CREATE UNIQUE CLUSTERED INDEX IX_VistaConserje_idconserje
ON dbo.VistaConserje (idconserje);
GO

/*
Crea una vista de la tabla Administrador que muestra solo el id y el nombre completo del administrador 
*/
CREATE VIEW dbo.VistaAdministradorWS WITH SCHEMABINDING AS
SELECT
     idadmin,
	 apeynom AS "Apellido y Nombre"
FROM
   dbo.administrador;
GO

--Crear la vista indexada
CREATE UNIQUE CLUSTERED INDEX IX_VistaAdministrador_idadmin
ON dbo.VistaAdministradorWS (idadmin);
GO

/*
Crea la vista correspondiente a la tabla Consorcio. Muestra solo la información del consorcio. 
*/
CREATE VIEW dbo.VistaConsorcio WITH SCHEMABINDING AS
SELECT
    idprovincia,
    idlocalidad,
    idconsorcio,
    nombre,
    direccion,
    idzona
FROM
    dbo.consorcio;
GO

-- Crear un índice en la tabla base (consorcio)
CREATE UNIQUE CLUSTERED INDEX IX_VistaConsorcio
ON dbo.VistaConsorcio (idprovincia, idlocalidad, idconsorcio);
GO

