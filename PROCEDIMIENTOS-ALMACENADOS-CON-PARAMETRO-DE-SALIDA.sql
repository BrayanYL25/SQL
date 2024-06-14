/*
Semana 9 -  Viernes 24 Mayo 2024
*/

/*Este ejercicio declara una variable local @proveedor,
 le asigna un valor de tipo cadena usando el comod�n %, 
 y consulta la base de datos para buscar los art�culos 
 del proveedor cuyo nomProveedor 
 contiene la cadena MAHAN.
*/
USE MarketPERU
GO
SELECT * FROM PROVEEDOR
GO
DECLARE @proveedor varchar(40)
SET @proveedor = '%MAHAN%'
SELECT 
	P.IdProducto, 
	P.Nombre AS PRODUCTO,
	PV.Nombre AS PROVEEDOR
FROM				PRODUCTO		P
INNER JOIN		PROVEEDOR	PV ON P.IdProveedor =PV.IdProveedor
WHERE PV.Nombre LIKE @proveedor
GO
--
-- Generalizando para cualquier palabra 
--que contenga el nombre del proveedor 
SELECT * FROM PROVEEDOR
GO


CREATE PROCEDURE BuscaProve
	@nom VARCHAR(40)
AS
SELECT 
	P.IdProducto, 
	P.Nombre, 
	PV.Nombre
FROM				PRODUCTO		P
INNER JOIN		PROVEEDOR	PV ON P.IdProveedor =PV.IdProveedor
WHERE PV.Nombre LIKE '%' + @nom + '%'
GO
-- MAHAN
EXEC BuscaProve  'GOLO'
GO
EXEC BuscaProve  'MAHAN'
GO


USE MarketPERU
GO
-- Uso de SELECT para asignar un valor a una variable local
DECLARE @articulo varchar(40)
SELECT @articulo = 'JABON LIQUIDO'
SELECT @articulo AS Nombre
GO

-- asignar valores a variables
-- con el resultado de una consulta
DECLARE @articulo varchar(40), @stock SMALLINT
SELECT @articulo = Nombre, @stock =StockActual
FROM PRODUCTO
WHERE IdProducto = 50
SELECT @articulo AS Nombre_Producto,
				@stock    AS Existencia_Actual
GO
---
/*Uso de una variable global
Este ejercicio utiliza la 
variable global @@ROWCOUNT 
para averiguar el n�mero de filas 
recuperadas por la instrucci�n SELECT.
La variable global @@ROWCOUNT 
devuelve el n�mero de filas afectadas 
por la �ltima sentencia SQL ejecutada.
*/
USE MarketPERU
GO
SELECT Nombre, Direccion, Ciudad
FROM PROVEEDOR
WHERE Departamento <> 'Lima'
GO
SELECT @@ROWCOUNT
GO
--******
--CON PARAMETROS DE ENTRADA Y SALIDA (QUE RECIBE Y DEVUELVE)
USE Pruebas
GO
SP_HELP CLIENTES
GO
CREATE PROCEDURE buscarCliente
	@xcod INT,
	@xnombre CHAR(30) OUTPUT
AS
SELECT @xnombre = nombre FROM CLIENTES
WHERE Cod_cli=@xcod
GO
--PROBANDO EN EJECUCION
DECLARE @xnom CHAR(30)
EXEC buscarCliente 2, @xnom OUTPUT
SELECT @xnom
GO
-- ORO CASO
DECLARE @xnom CHAR(30)
EXEC buscarCliente 5, @xnom OUTPUT
SELECT @xnom
GO
/*Crear un Sp en Pubs que al ingresarle 
   el codigo de un libro, 
   devuelva el Titulo del mismo.             */

USE PUBS
GO
sp_help TITLES
GO
CREATE PROCEDURE BUSCAR_LIBRO
@xcod VARCHAR(6),
@xnombre VARCHAR(80) OUTPUT
AS
	SELECT @xnombre=title FROM titles
	WHERE title_id=@xcod
GO
--PROBANDO EL SP
SELECT * FROM titles WHERE title_id='BU2075'
go
DECLARE @xnom VARCHAR(80)
EXEC BUSCAR_LIBRO 'BU2075',@xnom OUTPUT
SELECT @xnom
GO
-- MC2222    otro caso
DECLARE @xnom VARCHAR(80)
EXEC BUSCAR_LIBRO 'MC2222',@xnom OUTPUT
SELECT @xnom
GO
--CREAR EN MARKETPERU UN SP 
-- QUE DEVUELVA EL NOMBRE DE UN PRODUCTO,
-- CUANDO SE LE ENTREGUE 
-- EL CODIGO DEL PRODUCTO COMO DATO DE ENTRADA
USE MarketPERU
GO
SP_HELP PRODUCTO
GO
CREATE PROCEDURE BuscarProducto
	@cod INT,
	@nombre VARCHAR(40) OUTPUT
AS
SELECT @nombre = nombre FROM PRODUCTO
WHERE idproducto = @cod
GO
--
DECLARE @n VARCHAR(40)
EXEC BuscarProducto 1, @n OUTPUT
SELECT @n
GO

/*Crear un Sp en Northwind, que al darle el 
  codigo de un empleado devuelva la fecha 
  de ingreso del empleado                              */

USE Northwind
GO
SP_HELP EMPLOYEES
GO
SELECT EmployeeID,HIREDATE 
FROM Employees
GO

SELECT EmployeeID,HIREDATE 
FROM Employees
WHERE EmployeeID = 1
GO
-- Convirtiendo la consulta en SP
CREATE PROCEDURE spu_FeIng
	@codEmp INT, 
	@FechaIn DATETIME OUTPUT
AS
SELECT @FechaIn = HireDate FROM Employees
WHERE EmployeeID = @codEmp
GO
-- Probando el SP
DECLARE @X DATETIME
EXEC spu_FeIng 9, @X OUTPUT
SELECT @X
GO
--====================================================
/* Crear un SP en Marketperu, 
que al entregarle el codigo de un producto, 
devuelva el nombre del producto y 
el nombre del Proveedor.    */

USE MarketPERU
GO
EXEC SP_HELP PRODUCTO
EXEC SP_HELP PROVEEDOR
GO
SELECT P.IdProducto, P.nombre, PV.nombre
FROM			PRODUCTO		P
INNER JOIN	PROVEEDOR	PV ON P.IdProveedor=PV.IdProveedor
GO
SELECT P.IdProducto,p.nombre,PV.nombre
FROM			PRODUCTO P
INNER JOIN	PROVEEDOR PV ON P.IdProveedor=PV.IdProveedor
WHERE P.IdProducto = 5
GO
-- 5	CHUPETES LOLY AMBROSOLI	        DISTRIBUIDORA DE GOLOSINAS FENIX
-- Convirtiendo la Consulta en SP
CREATE PROCEDURE spu_buscaprod
	@cp   INT,		
	@npd VARCHAR(40) OUTPUT, 	
	@pv   VARCHAR(40) OUTPUT
AS
SELECT @npd = P.nombre, @pv = PV.nombre
FROM 			PRODUCTO		P
INNER JOIN	PROVEEDOR	PV ON P.IdProveedor=PV.IdProveedor
WHERE P.IdProducto = @cp
GO
-- Probando el SP
DECLARE @X VARCHAR(40), @Y VARCHAR(40)
EXEC spu_buscaprod 125, @X OUTPUT, @Y OUTPUT
SELECT @X, @Y
GO
DECLARE @X VARCHAR(40), @Y VARCHAR(40)
EXEC spu_buscaprod 5, @X OUTPUT, @Y OUTPUT
SELECT @X, @Y
GO
/*Propuesto 1: 
Crear un SP en la bd PUBS, 
que al ingresarle 
	el codigo de un libro 
presente: 
	el nombre  del libro y 
	el nombre de la editorial 
*/
USE PUBS
GO
--CONSULTA
SELECT * FROM titles
sp_help publishers
GO
SELECT T.title_id,T.title,P.pub_name
FROM titles T
INNER JOIN publishers P
ON T.pub_id=P.pub_id
WHERE T.title_id='BU1032'
GO
-- BU1032	    The Busy Executive's Database Guide	  Algodata Infosystems
CREATE PROCEDURE BUSCA_LIBRO
	@cod varchar(6),
    @nomlibro varchar(80) output,
	@nomedit varchar(40) output
AS
	SELECT @nomlibro=T.title,@nomedit=P.pub_name
	FROM			titles		  T
	INNER JOIN publishers P 	ON T.pub_id=P.pub_id
	WHERE T.title_id=@cod
GO
DECLARE @X VARCHAR(80)
DECLARE @y VARCHAR(40)
EXEC BUSCA_LIBRO 'BU1032',@X OUTPUT, @y OUTPUT 
SELECT @X,@y
GO

/*Crear un SP que al entregarle 
el codigo de un libro devuelva, 
El titulo del libro, 
los apellidos y nombres del autor
*/
USE PUBS
GO
SELECT 
*
FROM			TITLES				T
INNER JOIN TITLEAUTHOR	TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS			A   ON  TA.au_id = A.au_id
GO
SELECT 
T.title_id, T.title, A.au_lname, A.au_fname
FROM			TITLES				T
INNER JOIN TITLEAUTHOR	TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS			A   ON  TA.au_id = A.au_id
GO
SELECT 
T.title_id, T.title, A.au_lname, A.au_fname
FROM			TITLES					T
INNER JOIN TITLEAUTHOR		TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS			A   ON  TA.au_id = A.au_id
WHERE T.title_id ='PC1035'
GO
-- PC1035	     But Is It User Friendly?	     Carson	Cheryl
-- creando el sp
CREATE PROCEDURE spu_AutorLibro
	@codL	VARCHAR(6),
	@tl		VARCHAR(80) OUTPUT,
	@Au		VARCHAR(40) OUTPUT,	
	@Nu		VARCHAR(20) OUTPUT
AS
SELECT  
	@tl = T.title, @Au = A.au_lname, @Nu = A.au_fname
FROM			TITLES				T
INNER JOIN TITLEAUTHOR	TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS			A  ON  TA.au_id = A.au_id
WHERE T.title_id = @codL
GO
--PROBANDO EL SP con datos de prueba
-- PC1035		But Is It User Friendly?		Carson		Cheryl
DECLARE 	@tl VARCHAR(80), @Au VARCHAR(40), @Nu VARCHAR(20) 
EXEC spu_AutorLibro 'PC1035', @tl OUTPUT, @Au OUTPUT, @Nu OUTPUT 
SELECT  @tl, @Au, @Nu
GO
DECLARE 	@tl VARCHAR(80), @Au VARCHAR(40), @Nu VARCHAR(20) 
EXEC spu_AutorLibro 'TC7777', @tl OUTPUT, @Au OUTPUT, @Nu OUTPUT 
SELECT  @tl, @Au, @Nu
GO
SELECT 
T.title_id, T.title, A.au_lname, A.au_fname
FROM			TITLES					T
INNER JOIN TITLEAUTHOR		TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS			A   ON  TA.au_id = A.au_id
WHERE T.title_id ='TC7777'
GO


/*Como un libro puede tener varios autores, no se sabe la cantidad de paramentros 
de salida que se van a utilizar luego solo se podria presentar el resultado 
como una salida de consulta*/
ALTER PROCEDURE spu_AutorLibro
	@codL	VARCHAR(6)
AS
SELECT  
	T.title_id, T.title,A.au_lname,A.au_fname
FROM			TITLES					T
INNER JOIN TITLEAUTHOR		TA ON T.title_id = TA.title_id
INNER JOIN AUTHORS			A  ON  TA.au_id = A.au_id
WHERE T.title_id = @codL
GO
EXEC spu_AutorLibro 'TC7777'
GO
/*  
Crear un procedimiento almacenado 
en la BD Northwind que tenga 
como par�metro de entrada 
	el c�digo de un producto
y que devuelva en par�metros de salida 
	el nombre del producto, 	
	el nombre del proveedor,	
	el precio, 	
	la cantidad total vendida, 
	y el monto total vendido.  
*/
USE Northwind
GO
SELECT 
	*
FROM			Suppliers				S
INNER JOIN	Products				P		ON S.SupplierID=P.SupplierID
INNER JOIN	[Order Details]	OD	ON P.ProductID=OD.ProductID
GO



SELECT 
	P.ProductID,
	P.ProductName,
	S.CompanyName,
	OD.UnitPrice, 
	SUM(OD.Quantity),
	ROUND(SUM(OD.Quantity * OD.UnitPrice * ( 1 - OD.Discount)),2)
FROM			Suppliers				S
INNER JOIN	Products				P		ON S.SupplierID=P.SupplierID
INNER JOIN	[Order Details]		OD	ON P.ProductID=OD.ProductID
GROUP BY P.ProductID, P.ProductName, S.CompanyName,OD.UnitPrice
ORDER BY 1
GO

SELECT 
	P.ProductID,
	P.ProductName,
	S.CompanyName,
	ROUND(AVG(OD.UnitPrice),2), 
	SUM(OD.Quantity),
	ROUND(SUM(OD.Quantity * OD.UnitPrice * ( 1 - OD.Discount)),2)
FROM			Suppliers				S
INNER JOIN	Products				P		ON S.SupplierID=P.SupplierID
INNER JOIN	[Order Details]		OD	ON P.ProductID=OD.ProductID
GROUP BY P.ProductID, P.ProductName, S.CompanyName
GO

SELECT 
	P.ProductID,
	P.ProductName,
	S.CompanyName,
	ROUND(AVG(OD.UnitPrice),2), 
	SUM(OD.Quantity),
	ROUND(SUM(OD.Quantity * OD.UnitPrice * ( 1 - OD.Discount)),2)
FROM			Suppliers				S
INNER JOIN	Products				P		ON S.SupplierID=P.SupplierID
INNER JOIN	[Order Details]		OD	ON P.ProductID=OD.ProductID
WHERE P.ProductID=1
GROUP BY P.ProductID, P.ProductName, S.CompanyName
GO
SELECT 
	P.ProductID,
	P.ProductName,
	S.CompanyName,
	ROUND(AVG(OD.UnitPrice),2), 
	SUM(OD.Quantity),
	ROUND(SUM(OD.Quantity * OD.UnitPrice * ( 1 - OD.Discount)),2)
FROM			Suppliers				S
INNER JOIN	Products				P		ON S.SupplierID=P.SupplierID
INNER JOIN	[Order Details]		OD	ON P.ProductID=OD.ProductID
GROUP BY P.ProductID, P.ProductName, S.CompanyName
HAVING P.ProductID = 1
GO
-- 1	Chai	Exotic Liquids	  17.15	   828	  12788.1
-- CONVIRTIENDO LA CONSULTA EN SP
SP_HELP SUPPLIERS
GO
CREATE PROCEDURE spu_Product_Ventas
	@cp			INT, 
	@nprod		NVARCHAR(40)	OUTPUT, 	
	@nprove	NVARCHAR(40)	OUTPUT, 
	@pv			MONEY				OUTPUT, 	
	@can		INT						OUTPUT, 
	@monto	MONEY				OUTPUT
AS
SELECT 
	@cp			= P.ProductID,			
	@nprod		= P.ProductName,
	@nprove	= S.CompanyName,
	@pv			= ROUND(AVG(OD.UnitPrice),2), 
	@can		= SUM(OD.Quantity),
	@monto    = ROUND(SUM(OD.Quantity * OD.UnitPrice * ( 1 - OD.Discount)),2)
FROM			Suppliers				S
INNER JOIN	Products				P		ON S.SupplierID=P.SupplierID
INNER JOIN	[Order Details]	OD	ON P.ProductID=OD.ProductID
GROUP BY P.ProductID, P.ProductName, S.CompanyName
HAVING P.ProductID = @cp
GO
-- PROBANDO EL SP con datos de prueba:
--  1		Chai		Exotic Liquids		17.15		 828		12788.1
DECLARE @nprod	VARCHAR(40),@nprove VARCHAR(40),@pv MONEY,@can INT,@monto MONEY
EXEC spu_Product_Ventas 1,@nprod OUTPUT,@nprove OUTPUT,@pv OUTPUT,
                                                 @can OUTPUT, @monto OUTPUT
SELECT 	@nprod, 	@nprove, 	@pv, 	@can, 	@monto
GO

---   FIN DE LA CLASE 9