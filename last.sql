/*
============================
Procedimientos Almacenados
(Parámetros de Entrada)
============================
*/

USE Pruebas
GO

SP_HELP CLIENTES

SELECT * FROM Clientes
GO

CREATE PROCEDURE Agregarclientes (
	@xcod INT,
	@xnombre CHAR(30),
	@xciudad VARCHAR(15),
	@xtelefono VARCHAR(8)='000-0000') -- "='000-0000'": Crea valor predeterminado en caso no se dé

AS
INSERT INTO Clientes
	VALUES(@xcod, @xnombre, @xciudad, @xtelefono)
GO
SELECT * FROM Clientes
/*
============================
Procedimiento creado en Databases/Pruebas/Programmability/Stored Procedures/ -> dbo.Agregarclientes
============================
*/
-- Ejecución del Procedimiento Almacenado (Agregarclientes)
EXEC Agregarclientes 6, 'Pedro Perez', 'Huaraz', '4568741'

-- (test: xtelefono default)
EXEC Agregarclientes 7, 'Vilma Perez', 'Huaraz'
-- =====================================================================================================
/*Crear un SP ena BD Edutec que permita ingresar un profesor si se omitiera el dito de la direccion, 
su valor predeterminado sera Lima
*/
USE EduTec
GO

SP_HELP PROFESOR
GO

CREATE PROCEDURE AgregarProfesor(
	@cod CHAR(4),
	@ape VARCHAR(30),
	@Nomprofesor VARCHAR(30),
	@tel VARCHAR(12),
	@email VARCHAR(50),
	@dirprof VARCHAR(50) = 'Lima')

AS
INSERT INTO Profesor
(IdProfesor, ApeProfesor, NomProfesor, TelProfesor, EmailProfesor, DirProfesor)
VALUES
(@cod, @ape, @Nomprofesor, @tel, @email, @dirprof)
SELECT * FROM Profesor
GO

-- Test N°1 (Todos los parámetros)
EXEC AgregarProfesor 'P050', 'Arias', 'Maribel', '5447781', 'abcd@yahoo.es', 'San Isidro'
-- Test N°2 (Test Default)
EXEC AgregarProfesor 'P060', 'Villalobos', 'Edita', '4667731', 'edita@yahoo.es'


/**
 * En la BD Northwind, crear una SP (Stored Procedure) que permita ingresar un proveedor. Considerar para el dato del pais,
 * como un valor predeterminado a Peru.
 */

 use Northwind
 GO

 SP_HELP SUPPLIERS
 GO

 -- Chinise characters use more

 CREATE PROCEDURE CreateSupplier(
	@companyName NVARCHAR(45),
	@country NVARCHAR(15) = 'Peru' 
 )
 AS
 INSERT INTO Suppliers(CompanyName, Country)
 VALUES (@companyName, @country)
 SELECT * FROM Suppliers
 GO
 
 EXEC CreateSupplier 'alfa', 'Bolivia'
 GO

 EXEC CreateSupplier 'Beta'
 GO
 
 -- En parcial mandar la carpeta Programmability, stored procedure y poner a prueba el procedimiento almacenado
 -- e.g. si uso un valor por defecto, probarlo

 /* Crear un SP en MARKETPERU para ingresar un nuevo local con todos tus datos, si no especificas el distrito, por defecto sera 'Independencia'*/

 USE MarketPERU
 GO

SP_HELP [LOCAL]
GO

 CREATE PROCEDURE CreateLocal(
	@id INT,
	@address VARCHAR(60),
	@phone VARCHAR(15),
	@distrit VARCHAR(20) = 'Independencia',
	@fax VARCHAR(15)
 )
 AS
 INSERT INTO LOCAL(IdLocal, Direccion, Distrito, Telefono, Fax)
 VALUES (@id, @address, @distrit, @phone, @fax)
 SELECT * FROM LOCAL
 GO

 -- trigger, transacciones
 -- Hacer un proyecto para la EP4 en grupo (5 persona): Una base de datos de una realidad
 EXEC CreateLocal 200, 'Calle Fresas', '9904704590', 'abcdefghijk', 'Surquillo'
 GO

 EXEC CreateLocal @id = 203, @address = 'Calle Turron', @phone = '7889911', @fax = 'salklkklqw'
 GO

 -- Valor de retorno (valor entero) != parametro de salida
 USE Pruebas

 SELECT * FROM Clientes
 GO

 CREATE PROCEDURE ClienteRepetido(
	@xcod INT
 )
 AS
 IF (SELECT COUNT(*) FROM CLIENTES WHERE cod_cli = @xcod) > 1
	RETURN 1
ELSE
	RETURN 2
GO

DECLARE @existe INT
EXEC @existe = ClienteRepetido @xcod = 1
PRINT @existe
GO

USE MarketPERU
GO

CREATE PROCEDURE CheckStock (
	@id INT
)
AS
IF(SELECT StockActual FROM PRODUCTO where IdProducto = @id)
<
(SELECT StockMinimo FROM PRODUCTO where IdProducto = @id)
	RETURN 4
ELSE
	RETURN 5
GO

DECLARE @existe INT
EXEC @existe = CheckStock @id = 1
PRINT @existe
GO

USE MarketPERU
GO

SELECT * FROM PRODUCTO
GO

CREATE PROCEDURE spu_VerificaCantidad
@cp INT, @can INT
AS
IF(SELECT StockActual FROM PRODUCTO where IdProducto = @cp) < @can
	RETURN 7
ELSE
	RETURN 2
GO


DECLARE @x INT
EXEC @x = spu_VerificaCantidad @cp = 1, @can = 201
PRINT @x
GO
