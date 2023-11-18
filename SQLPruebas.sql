USE [base_consorcio]
GO

--Inserción de lote de datos de prueba para Procedimientos y funciones almacenadas

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


--Inserción de lote de datos de prueba para Procedimientos y funciones almacenadas

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

-- Transacciones --

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

-------TRANSACCIONES ANIDADAS-------

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


