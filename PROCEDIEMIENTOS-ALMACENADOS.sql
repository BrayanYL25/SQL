/*
Semana 7 - 17 de Mayo 2024

*/

--==================================================

-- Procedimientos Almacenados 
-- con parametros que recibe: 
-- (Paramentros de Entrada)
--==================================================

USE Pruebas
GO
sp_help CLIENTES
GO
SELECT * FROM Clientes
GO
CREATE PROCEDURE Agregarclientes
(	@xcod			INT,
	@xnombre	CHAR(30),
	@xciudad		VARCHAR(15),
	@xtelefono	VARCHAR(8) = '000-0000' )
AS
INSERT INTO CLIENTES 
       VALUES(@xcod,@xnombre,@xciudad,@xtelefono)
SELECT * FROM CLIENTES
GO
--EJECUCION
SELECT * FROM CLIENTES
GO
EXEC Agregarclientes
GO
EXEC Agregarclientes 8
GO
EXEC Agregarclientes 6,'Pedro Perez','Huaraz','4568741'
GO
EXEC Agregarclientes 7,'Vilma Perez','Huaraz'
GO
select*from CLIENTES
go
--Crear un SP en la BD Edutec que permita ingresar un profesor
--si se omitiera el dato de la direccion,su valor predeterminado
--sera Lima
USE EduTec
GO
SP_HELP PROFESOR
GO
CREATE PROCEDURE AgregarProfesor	
(	@cod					CHAR(4),							
	@ape					VARCHAR(30),
	@Nomprofesor		VARCHAR(30),	
	@tel						VARCHAR(12),
	@email					VARCHAR(50),				
	@dirprof				VARCHAR(50) = 'LIMA'	)
AS
INSERT INTO Profesor
(IdProfesor, ApeProfesor,NomProfesor,TelProfesor,EmailProfesor,DirProfesor)
VALUES 
(@cod, @ape, @Nomprofesor, @tel, @email, @dirprof	)
SELECT * FROM Profesor
GO
SELECT * FROM PROFESOR
GO
EXEC AgregarProfesor 
'P050','ARIAS','MARIBEL','5447781','abcd@yahoo.es','SAN ISIDRO'
GO
EXEC AgregarProfesor 
'P060','VILLALOBOS','EDITA','4667731','edita@yahoo.es'
GO
/*EN LA bd NORTHWIND, CREAR UNA SP QUE PERMITA INGRESAR 
UN PROVEEDOR. CONSIDERAR PARA EL DATO DEL PAIS, 
COMO VALOR PREDETERMINADO A PERU                                        */
USE Northwind
GO
SELECT * FROM Suppliers
GO
SP_HELP SUPPLIERS
GO
CREATE PROCEDURE spu_AgregarProve
(	@companyName	NVARCHAR(40),	
	@Country				NVARCHAR(15) = 'Peru')
AS 
INSERT INTO Suppliers (companyName, Country	)
                        VALUES(@companyName, @Country	)
SELECT * FROM Suppliers
GO
SELECT * FROM Suppliers
GO
EXEC spu_AgregarProve 'Alfa','Bolivia'
GO
EXEC spu_AgregarProve 'Beta'
GO

/*Crear un Sp en MarketPERU, 
para ingresar un nuevo Local.
Con todos sus datos.
Si no se especificara el Distrito, 
el sistema asumira "Independencia"
*/
USE MarketPERU
GO

SP_HELP LOCAL

GO
CREATE PROCEDURE AgregarLocal (
	@id INT,
	@direccion VARCHAR(60),
	@telefono VARCHAR(15),
	@fax VARCHAR(15),
	@distrito VARCHAR(60) = 'Independencia')
AS
INSERT INTO LOCAL (IdLocal, Direccion, Telefono, Fax, Distrito)
	VALUES (@id, @direccion, @telefono, @fax, @distrito)
SELECT * FROM LOCAL
GO
-- TEST N�1
EXEC AgregarLocal 6, 'AV LAS PALMERAS', '999666909', 'Fax1', 'Chorrillos'
-- TEST N�2
EXEC AgregarLocal 7, 'AV LAS GAVIOTAS', '999666999', 'Fax2'


--  Uso del Valor de Retorno 
-- (RETURN VALUE)
USE Pruebas
GO
SELECT * FROM CLIENTES
GO
CREATE PROCEDURE ClienteRepetido
	@xcod INT 
AS
IF (SELECT COUNT(*) FROM CLIENTES WHERE Cod_cli = @xcod) > 1
	RETURN 1
ELSE
	RETURN 2
GO
--EJECUCION
EXEC ClienteRepetido
go
EXEC ClienteRepetido 3
go
DECLARE @Existe INT
EXEC @Existe = ClienteRepetido 3
GO
DECLARE @Existe INT
EXEC @Existe = ClienteRepetido 3
SELECT @Existe
GO
select * from Clientes
go
DECLARE @Existe INT
EXEC @Existe=ClienteRepetido 6
SELECT @Existe
GO
--CREAR UN SP EN LA BD MARKETPERU QUE VERIFIQUE 
-- MEDIANTE UN RETURN VALUE
-- SI EL STOCK DEL PRODUCTO ESTA 
-- POR DEBAJO DEL MINIMO PERMITIDO.
USE MarketPERU
GO
SELECT 
IdProducto,Nombre,StockActual,StockMinimo 
FROM PRODUCTO
GO
SELECT 
IdProducto,Nombre,StockActual,StockMinimo 
FROM PRODUCTO WHERE StockActual < StockMinimo
GO
SP_HELP PRODUCTO
GO
CREATE PROCEDURE spu_VerificaMin
@cod INT
AS
IF 
(SELECT StockActual  FROM PRODUCTO WHERE IdProducto = @cod ) 
	< 
(SELECT StockMinimo FROM PRODUCTO WHERE IdProducto = @cod ) 
	RETURN 4
ELSE
	RETURN 5
GO
-- PROBANDO EL SP
DECLARE @X INT
EXEC @X  = spu_VerificaMin 26
SELECT @X
GO
SELECT 
IdProducto,Nombre,StockActual,StockMinimo 
FROM PRODUCTO WHERE IdProducto = 26
GO
-- OTRO CASO
DECLARE @X INT
EXEC @X  = spu_VerificaMin 27
SELECT @X
GO
-- VERIFICANDO
SELECT IdProducto,Nombre,StockActual,StockMinimo 
FROM PRODUCTO WHERE IdProducto = 27
GO
/*****************************
En MarketPeru crear un SP 
que verifique si el stock de un producto
esta por debajo de una cantidad determinada, 
para saber si se puede vender a no el producto.  
Usar un RETURN Value. */
USE MarketPERU
GO
SELECT * FROM PRODUCTO
GO
CREATE PROCEDURE spu_VerificaCantidad
	@cp INT, @Can INT  
AS
IF 
(SELECT StockActual FROM PRODUCTO WHERE IdProducto=@cp)  < @Can
   	RETURN 7
ELSE
	RETURN 2
GO
-- PROBANDO EL SP
SELECT * FROM PRODUCTO WHERE IdProducto = 1
GO
DECLARE @x INT
EXEC @x = spu_VerificaCantidad 1,200
PRINT @x
GO
-- OTRA PRUEBA
DECLARE @x INT
EXEC @x = spu_VerificaCantidad 1,201
PRINT @x
GO