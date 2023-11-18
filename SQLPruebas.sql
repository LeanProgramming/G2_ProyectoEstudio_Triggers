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




