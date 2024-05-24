USE MARKETPERU
GO

CREATE PROCEDURE BuscarProve
	@nom VARCHAR(40)
AS
SELECT * FROM PRODUCTO p
INNER JOIN PROVEEDOR PV ON PV.IdProveedor = P.IdProveedor
GO


SELECT Nombre, Direccion, Ciudad FROM PROVEEDOR
WHERE Departamento != 'Lima'
GO
SELECT @@ROWCOUNT
GO


-- ******************************************************
-- * CREAR PROCEDIMIENTO ALMACENADO DE ENTRADA Y SALIDA *
-- ******************************************************
USE Pruebas
GO

SP_HELP CLIENTES
GO

-- CREATE
CREATE PROCEDURE buscarCliente
	@xcod INT,
	@xnombre CHAR(30) OUTPUT --INDICATE WHAT IS THE OUTPUT
AS
SELECT @xnombre = nombre FROM Clientes WHERE cod_cli = @xcod
GO

-- TEST | RUNNING
DECLARE @xnom CHAR(30)
EXEC buscarCliente 2, @xnom OUTPUT
PRINT @xnom
GO

-- Crear un SP en Pubs que al ingresarle el codigo de un libro, devuelva el titulo del mismo

USE PUBS
GO

SP_HELP TITLES

CREATE PROCEDURE BUSCAR_LIBRO
	@xcod VARCHAR(6),
	@xnombre VARCHAR(80) OUTPUT
AS
	SELECT @xnombre = title FROM titles
	WHERE title_id = @xcod
GO

SELECT * FROM titles

DECLARE @Name VARCHAR(80)
EXEC BUSCAR_LIBRO 'BU1111', @Name OUTPUT
PRINT @Name
GO


USE MarketPERU
GO

SP_HELP PRODUCTO
GO

SELECT * FROM PRODUCTO

CREATE PROCEDURE SEARCH_PRODUCT
	@cod INT,
	@name VARCHAR(40) OUTPUT
AS
SELECT @name = Nombre FROM PRODUCTO
WHERE IdProducto = @cod
GO

DECLARE @product VARCHAR(40)
EXEC SEARCH_PRODUCT 11,
@product OUTPUT
PRINT @product
GO

USE Northwind
GO

CREATE PROCEDURE spu_felng
	@codEmployee INT,
	@FechaIn DATETIME OUTPUT
AS
SELECT @FechaIn = HireDate FROM Employees
WHERE EmployeeID = @codEmployee
GO

DECLARE @X DATETIME
EXEC spu_felng 9, @X OUTPUT
PRINT @x
GO

-- ****************************************
-- * PROCEDIMIENTOS CON MULTIPLES SALIDAS *
-- ****************************************

USE MarketPERU
GO

EXEC SP_HELP PRODUCTO
EXEC SP_HELP PROVEEDOR
GO

CREATE PROCEDURE SEARCH_PRODUCT_PROVIDER
	@cod INT,
	@product VARCHAR(40) OUTPUT,
	@provider VARCHAR(40) OUTPUT
AS
SELECT @product = P.Nombre, @provider = S.Nombre FROM PRODUCTO P
INNER JOIN PROVEEDOR S ON P.IdProveedor = S.IdProveedor
WHERE P.IdProveedor = @cod
GO

DECLARE @products VARCHAR(40)
DECLARE @providers VARCHAR(40)
EXEC SEARCH_PRODUCT_PROVIDER 1, @products OUTPUT, @providers OUTPUT
SELECT @products, @providers
GO

-- *****************************
-- * PROPUESTO 1:		       *
-- * STORAGE PROCEDURE:        *
-- * - INGRESA CODIGO DE LIBRO *
-- * - NOMBRE DEL LIBRO	       *
-- * - EDITORIAL               *  
-- *****************************

USE pubs
GO

EXEC SP_HELP PUBLISHERS
EXEC SP_HELP TITLES
GO

CREATE PROCEDURE SEARCH_DATA_TITLE
	@code CHAR(6),
	@title VARCHAR(80) OUTPUT,
	@publisher VARCHAR(40) OUTPUT
AS
SELECT @title = title, @publisher = pub_name FROM titles T
INNER JOIN publishers P ON T.pub_id = P.pub_id
WHERE title_id = @code
GO

DECLARE @x VARCHAR(80), @y VARCHAR(40)
EXEC SEARCH_DATA_TITLE 'BU2075', @x OUTPUT, @y OUTPUT
SELECT @x, @y
GO


EXEC SP_HELP AUTHORS
GO

CREATE PROCEDURE SEARCH_BOOK
	@cod CHAR(6),
	@title VARCHAR(80) OUTPUT,
	@name VARCHAR(40) OUTPUT,
	@surname VARCHAR(20) OUTPUT
AS
SELECT @title = T.title, @name = A.au_fname, @surname = A.au_lname FROM TITLES t
INNER JOIN titleauthor TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS A ON TA.au_id = A.au_id
WHERE T.title_id = @cod
GO

DROP PROCEDURE SEARCH_BOOK
GO

DECLARE @title VARCHAR(80), @name VARCHAR(40), @surname VARCHAR(20)
EXEC SEARCH_BOOK 'BU2075', @title OUTPUT, @name OUTPUT, @surname OUTPUT
SELECT @title, @name, @surname
GO

EXEC SEARCH_BOOK 'TC7777'
GO

ALTER PROCEDURE SEARCH_BOOK
	@cod CHAR(6)
AS
SELECT T.title, A.au_fname, A.au_lname FROM TITLES t
INNER JOIN titleauthor TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS A ON TA.au_id = A.au_id
WHERE T.title_id = @cod
GO

USE NORTHWIND
GO


