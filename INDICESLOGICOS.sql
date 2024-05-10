-- ORDER BY CONSUME MUCHO
-- (NONCLUSTERED)(LOGICOS)

USE EDUTEC2

EXEC sp_helpindex ALUMNO
GO

SELECT * FROM Alumno
GO

SELECT * FROM Alumno ORDER BY ApeAlumno
GO

CREATE NONCLUSTERED INDEX APELLIDO
ON ALUMNO(ApeAlumno)

EXEC sp_helpindex ALUMNO
GO

SELECT * FROM Alumno ORDER BY ApeAlumno
GO

EXEC sp_helpindex PROFESOR
GO

CREATE CLUSTERED INDEX DIRAPE
ON PROFESOR(DirProfesor, ApeProfesor)
GO

-- DROP INDEX PROFESOR ON PROFESOR

EXEC sp_helpindex PROFESOR
GO

SELECT * FROM Profesor ORDER BY DirProfesor, ApeProfesor

USE Northwind

--sP_HELPINDEX PRODUCTS

use EduTec

SELECT * FROM Tarifa
SELECT * FROM Alumno
SELECT * FROM Curso
SELECT * FROM Profesor

-- LEE LOTE POR LOTE, LOS LOTES SE DEFINEN CON GO, LAS VARIABLES TIENEN UN ALCANCE DE LOTE
DECLARE @MiMensaje VARCHAR(50)
SET @MiMensaje = 'VIVAN LOS PRETZELS'
PRINT @MiMensaje
SELECT @MiMensaje
GO

-- TRANSACCIONES

USE EDUTEC2

CREATE TABLE DEMO07 (
	COLA INT PRIMARY KEY,
	COLB CHAR(3)
)
GO

-- LOS ERRORES DE SINTAXIS DETIENEN TODA LA EJECUCION DEL PROGRAMA
INSERT INTO DEMO07 VALUES (1, 'AAA')
INSERT INTO DEMO07 VALUES (2, 'BBB')
INSERT INTO DEMO07 VALUES (3, 'CCC')


CREATE TABLE DEMO08 (
	COLA INT PRIMARY KEY,
	COLB CHAR(3)
)
GO


-- LOS ERRORES DE DATOS (REPETIDOS) PERMITEN LAS EJECUCIÓN HASTA EL ERROR HALLADO
INSERT INTO DEMO08 VALUES (1, 'AAA')
INSERT INTO DEMO08 VALUES (2, 'BBB')
INSERT INTO DEMO08 VALUES (3, 'CCC')
INSERT INTO DEMO08 VALUES (3, 'CCC')

USE EDUTEC

SELECT * FROM Tarifa
SELECT * FROM Curso

BEGIN TRAN -- EJECUTA CAMBIOS MOMENTANEOS EN RAM
UPDATE Tarifa SET PreTarifa = PreTarifa * 2
GO

INSERT INTO Curso VALUES ('C900', 'C', 'PHP')
SELECT * FROM Tarifa
COMMIT TRAN --MANDA TODOS LOS CAMBIOS AL DISCO DURO

DELETE FROM Curso WHERE IdCurso = 'C900'
UPDATE Tarifa SET PreTarifa = PreTarifa / 2

-- CONTROL DE ERRORES

CREATE TABLE TA (A CHAR(1) PRIMARY KEY)
CREATE TABLE TB (B CHAR(1) REFERENCES TA)

CREATE TABLE TC (C CHAR(1))
GO
-- PROCEDIMIENTOS ALMACENADOS

CREATE PROCEDURE TEST1
AS
	BEGIN TRAN
		INSERT TC VALUES('X')
		INSERT TB VALUES('X')
	COMMIT TRAN
GO

execute TEST1
go

exec TEST1
go

-- version mas corta solo funciona con una linea en el lote
TEST1
go

SELECT * FROM TA
SELECT * FROM TB
SELECT * FROM TC
GO

CREATE PROCEDURE TEST2
AS
	BEGIN TRAN
		INSERT TC VALUES ('Y')
		IF (@@ERROR <> 0) GOTO on_error
		INSERT TB VALUES ('Y')
		IF (@@ERROR <> 0) GOTO on_error
	COMMIT TRAN
	RETURN (0)
on_error:
	ROLLBACK TRAN
	RETURN (1)
GO

INSERT INTO TA VALUES ('Y')

EXEC TEST2
GO

SELECT * FROM TA
SELECT * FROM TB
SELECT * FROM TC

CREATE DATABASE Pruebas
GO
USE Pruebas
GO
/*Tabla de ejemplo Clientes*/
CREATE TABLE Clientes (
	cod_cli   INT				NOT NULL ,
	nombre  CHAR(30)			NOT NULL ,
	ciudad   VARCHAR(15)		NOT NULL ,	
	telefono VARCHAR(8)		    NULL ) 
GO
SELECT * FROM Clientes
GO
--CLIENTES
insert into Clientes values(1,'Maria Euguren','Lima','3245876')
insert into Clientes values(2,'Alejandro Mezco Caballero','La Plata','4959554')
insert into Clientes values(3,'Daniela Velasquez Marquez','Arequipa','4791004')
insert into Clientes values(4,'Daniel Hacha Gonzales','Lima','4151004')
insert into Clientes values(5,'Jose Pe�a','Huaraz','4568741')
insert into Clientes values(6,'Pedro Perez','Huaraz','4568741')
GO

select * from Clientes
GO


CREATE PROCEDURE LISTACLIENTE
AS
SELECT * FROM Clientes
GO

EXEC LISTACLIENTE
GO





/*Crear SP que presente una lista 
de los proveedores de la bd 
Northwind y el monto total 
de ventas correspondientes
a los productos relacionados 
con cada proveedor. */

USE Northwind
GO

SELECT 
*
FROM		Suppliers		S
INNER JOIN	Products		P	ON	S.SupplierID = P.SupplierID
INNER JOIN	[Order Details]	OD	ON	P.ProductID =OD.ProductID
GO

SELECT 
S.CompanyName											AS Proveedor, 
ROUND(SUM(OD.UnitPrice*OD.Quantity*(1-OD.DISCOUNT)),2)  AS [Monto de Ventas]
FROM		Suppliers		S
INNER JOIN	Products		P	ON	S.SupplierID = P.SupplierID
INNER JOIN	[Order Details]	OD	ON	P.ProductID =OD.ProductID
GROUP BY S.CompanyName
GO


CREATE PROCEDURE VentasProveedor
AS
SELECT 
S.CompanyName											AS Proveedor, 
ROUND(SUM(OD.UnitPrice*OD.Quantity*(1-OD.DISCOUNT)),2)  AS [Monto de Ventas]
FROM		Suppliers		S
INNER JOIN	Products		P	ON	S.SupplierID = P.SupplierID
INNER JOIN	[Order Details]	OD	ON	P.ProductID =OD.ProductID
GROUP BY S.CompanyName
GO

EXEC VentasProveedor
GO