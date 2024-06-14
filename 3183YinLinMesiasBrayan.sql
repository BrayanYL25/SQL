--PREGUNTA 1
--En la Base de datos Northwind mostrar el monto total de cada pedido. (incluidos los descuentos).
--Presentar: El número de pedido, el monto bruto, el monto de descuento, 
--y el monto total del pedido. 
--Solo para los productos de dos categorías ingresadas por el usuario y 
--además, solo para los totales comprendidos entre dos montos ingresados por el usuario
USE NORTHWIND
EXEC SP_HELP CATEGORIES
GO

EXEC SP_HELP PRODUCTS
GO

SELECT * FROM Categories

SELECT
	O.OrderID as "NÚMERO DE ORDEN",
	ROUND(SUM(Quantity * P.UnitPrice), 2) AS [MONTO BRUTO],
	ROUND(SUM((Quantity * P.UnitPrice) * OD.DISCOUNT), 2) AS [DESCUENTO],
	ROUND(SUM((Quantity * P.UnitPrice) * (1 - OD.DISCOUNT)), 2) AS [MONTO TOTAL]
FROM Orders O
INNER JOIN [ORDER DETAILS] OD ON O.OrderID = OD.OrderID
INNER JOIN PRODUCTS P ON OD.ProductID = P.ProductID
INNER JOIN CATEGORIES C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName IN ('Beverages', 'Condiments')
GROUP BY O.OrderID
HAVING ROUND(SUM((Quantity * P.UnitPrice) * (1 - OD.DISCOUNT)), 2) BETWEEN 0 AND 10000
GO


CREATE PROCEDURE TOTAL_AMOUNT
	@categoryOne VARCHAR(30),
	@categoryTwo VARCHAR(30),
	@amountOne MONEY,
	@amountTwo MONEY
AS
SELECT
	O.OrderID as "NÚMERO DE ORDEN",
	ROUND(SUM(Quantity * P.UnitPrice), 2) AS "MONTO BRUTO",
	ROUND(SUM((Quantity * P.UnitPrice) * OD.DISCOUNT), 2) AS "DESCUENTO",
	ROUND(SUM((Quantity * P.UnitPrice) * (1 - OD.DISCOUNT)), 2) AS "MONTO TOTAL"
FROM Orders O
INNER JOIN [ORDER DETAILS] OD ON O.OrderID = OD.OrderID
INNER JOIN PRODUCTS P ON OD.ProductID = P.ProductID
INNER JOIN CATEGORIES C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName IN (@categoryOne, @categoryTwo)
GROUP BY O.OrderID
HAVING ROUND(SUM((OD.Quantity * OD.UnitPrice) * (1 - OD.DISCOUNT)), 2) BETWEEN @amountOne AND @amountTwo
GO

EXEC TOTAL_AMOUNT @categoryOne='Beverages', @categoryTwo='Condiments', @amountOne= 0, @amountTwo= 10000
GO

--PREGUNTA 2
--En Northwind crear un Procedimiento Almacenado que permita ingresar un nuevo Cliente.
--Se deben considerar los campos obligatorios y además el País.
--Si no se ingresara el País en forma predeterminada será Argentina.

SELECT * FROM Customers
GO

EXEC SP_HELP CUSTOMERS
GO

CREATE PROCEDURE CREATE_CUSTOMER
	@customerID NVARCHAR(10),
	@companyName NVARCHAR(80),
	@postalCode NVARCHAR(20),
	@city NVARCHAR(30),
	@region NVARCHAR(30),
	@country NVARCHAR(30) = 'Argentina'
	-- Campos No Obligatorios
	--@contactName NVARCHAR(60),
	--@contactTitle NVARCHAR(60),
	--@address NVARCHAR(120),
	--@phone NVARCHAR(48),
	--@fax NVARCHAR(48),
	--@country NVARCHAR(30) = 'Argentina'
AS
	IF (@customerID IS NULL) OR (@companyName IS NULL) OR (@postalCode IS NULL) OR (@city IS NULL) OR (@country IS NULL)
	BEGIN
		PRINT 'VALOR NULO'
		RETURN 1
	END
	BEGIN TRAN
		INSERT INTO CUSTOMERS (CustomerID, CompanyName, City, Region, PostalCode, Country)
		VALUES (@customerID, @companyName, @city, @region, @postalCode, @country)
		IF @@ERROR != 0
		BEGIN
			PRINT 'ERROR IN DATABASE'
			ROLLBACK TRAN
			RETURN 2
		END
	COMMIT TRAN
	RETURN 0
GO

DECLARE @code INT
EXEC @code = CREATE_CUSTOMER 'JLQJ', 'Apple', 12209, 'Lima', NULL, 'Perú'
PRINT @code
GO

--PREGUNTA 3
--Crear Procedimiento Almacenado que presente una lista 
--en Northwind que presente el monto total 
--de ventas correspondientes
--a cada Región por cada empleado.
--Se debe mostrar el nombre de la región, 
--los Apellidos y nombres del empleado y 
--el monto total de las ventas que realizo en cada región.


CREATE PROCEDURE REGION_EMPLOYEE
AS
SELECT
	RegionDescription AS [REGION],
	LastName + ' ' + FirstName AS [NOMBRE EMPLEADO],
	ROUND(SUM(Quantity * OD.UnitPrice), 2) AS [MONTO BRUTO],
	ROUND(SUM((Quantity * OD.UnitPrice) * OD.DISCOUNT), 2) AS [DESCUENTO],
	ROUND(SUM((Quantity * OD.UnitPrice) * (1 - OD.DISCOUNT)), 2) AS [MONTO TOTAL]
FROM [ORDER DETAILS] OD
INNER JOIN ORDERS O ON OD.OrderID = O.OrderID
INNER JOIN EMPLOYEES E ON O.EmployeeID = E.EmployeeID
INNER JOIN EMPLOYEETERRITORIES ET ON E.EmployeeID = ET.EmployeeID
INNER JOIN TERRITORIES T ON ET.TerritoryID = T.TerritoryID
INNER JOIN REGION R ON T.RegionID = R.RegionID
GROUP BY RegionDescription, LastName + ' ' + FirstName
GO

EXEC REGION_EMPLOYEE
GO

-- PREGUNTA 4
--En la Base de datos Northwind, crear un Procedimiento Almacenado que muestre 
--a todos los clientes de Sudamérica, cuyo Nombre de la empresa 
--termine en una letra que se debe ingresar como dato de entrada   
--Presentar el nombre de la empresa cliente, el país de procedencia.

SELECT
	CompanyName AS [EMPRESA],
	ContactName AS [CLIENTE],
	Country AS [PAIS]
FROM Customers C
WHERE C.CompanyName LIKE '%' + 'e' AND Country IN ('Venezuela', 'Argentina', 'Brazil')
GO

CREATE PROCEDURE FILER_BY_LETTER_CONTINENT
	@letter CHAR(1)
AS
SELECT
	CompanyName AS [EMPRESA],
	ContactName AS [CLIENTE],
	Country AS [PAIS]
FROM Customers C
WHERE C.CompanyName LIKE '%' + @letter AND Country IN ('Venezuela', 'Argentina', 'Brazil')
GO

EXEC FILER_BY_LETTER_CONTINENT @letter = 'a'
GO

--PREGUNTA 5
--En Northwind crear un Procedimiento Almacenado que verifique 
--si el stock de un producto está por debajo de 
--una cantidad determinada, 
--para saber si se puede vender a no el producto.  
--Usar un RETURN Value.

EXEC SP_HELP PRODUCTS
GO

CREATE PROCEDURE IS_AVAILABLE
	@product NVARCHAR(80),
	@stockToCheck SMALLINT
AS
	IF (SELECT UnitsInStock FROM PRODUCTS WHERE PRODUCTNAME = @product) < @stockToCheck
	BEGIN
		PRINT 'NO STOCK'
		RETURN 1
	END
	PRINT 'STOCK AVAILABLE'
	RETURN 0
GO

DECLARE @code INT
EXEC @code = IS_AVAILABLE 'Chai', 23
PRINT @code
GO

--PREGUNTA 6
--Crear un Procedimiento Almacenado en Northwind, que al entregarle el código 
--de un producto, devuelva el nombre del producto y 
--el nombre del Proveedor y el total de unidades vendidas del producto 
USE Northwind
GO

EXEC SP_HELP PRODUCTS
GO

EXEC SP_HELP SUPPLIERS
GO

ALTER PROCEDURE GET_PRODUCT_SALES
	@productID INT
AS
	SELECT 
		ProductName AS [PRODUCTO],
		CompanyName AS [COMPAÑIA PROVEEDORA],
		ContactName AS [PROVEEDOR],
		ROUND(SUM(OD.Quantity), 2) AS [UNIDADES VENDIDAS]
	FROM PRODUCTS P
	INNER JOIN SUPPLIERS S ON P.SupplierID = S.SupplierID
	INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
	WHERE P.ProductID = @productID
	GROUP BY ProductName, CompanyName,ContactName
GO

EXEC GET_PRODUCT_SALES @productID = 5
GO