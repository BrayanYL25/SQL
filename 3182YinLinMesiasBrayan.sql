﻿--PREGUNTA 1
USE NORTHWIND
EXEC SP_HELP CATEGORIES
GO

EXEC SP_HELP PRODUCTS
GO

SELECT * FROM Categories
GO

CREATE PROCEDURE TOTAL_AMOUNT
	@categoryOne INT,
	@categoryTwo INT,
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
WHERE C.CategoryID IN (@categoryOne, @categoryTwo)
GROUP BY O.OrderID
HAVING ROUND(SUM((OD.Quantity * OD.UnitPrice) * (1 - OD.DISCOUNT)), 2) BETWEEN @amountOne AND @amountTwo
ORDER BY 1
GO

EXEC TOTAL_AMOUNT @categoryOne=1, @categoryTwo=3, @amountOne= 0, @amountTwo= 10000
GO

--PREGUNTA 2
EXEC SP_HELP CUSTOMERS
GO

CREATE PROCEDURE CREATE_CUSTOMER
	@customerID NVARCHAR(10),
	@companyName NVARCHAR(80),
	@country NVARCHAR(30) = 'Argentina'
AS
	IF (@customerID IS NULL) OR (@companyName IS NULL)
	BEGIN
		PRINT 'VALOR NULO'
		RETURN 1
	END
	BEGIN TRAN
		INSERT INTO CUSTOMERS (CustomerID, CompanyName, Country)
		VALUES (@customerID, @companyName,  @country)
		IF @@ERROR != 0
		BEGIN
			PRINT 'ERROR IN DATABASE'
			ROLLBACK TRAN
			RETURN @@ERROR
		END
	COMMIT TRAN
	RETURN 0
GO

DELETE FROM CUSTOMERS WHERE CustomerID = 'JLQY'

-- VALOR NULO
DECLARE @code INT
EXEC @code = CREATE_CUSTOMER NULL, 'Apple', 'Perú'
PRINT @code
GO

-- VALOR CORRECTO
DECLARE @code INT
EXEC @code = CREATE_CUSTOMER 'JLQY', 'Apple', 'Perú'
PRINT @code
SELECT  * FROM CUSTOMERS WHERE CustomerID = 'JLQY'
GO

--PREGUNTA 3
EXEC SP_HELP [ORDER DETAILS]
GO

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
EXEC SP_HELP CUSTOMERS
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

EXEC FILER_BY_LETTER_CONTINENT @letter = 'e'
GO

--PREGUNTA 5

EXEC SP_HELP PRODUCTS
GO

CREATE PROCEDURE IS_AVAILABLE
	@product NVARCHAR(80),
	@stockToCheck SMALLINT
AS
	IF (@product IS NULL) OR (@stockToCheck IS NULL)
	BEGIN
		PRINT 'NULL VALUE'
		RETURN 1
	END
	IF (SELECT UnitsInStock FROM PRODUCTS WHERE PRODUCTNAME = @product) < @stockToCheck
	BEGIN
		PRINT 'NO STOCK'
		RETURN 2
	END
	IF (SELECT Discontinued FROM PRODUCTS WHERE PRODUCTNAME = @product) = 1
	BEGIN
		PRINT 'THIS PRODUCT IS DISCONTINUED'
		RETURN 3
	END
	PRINT 'STOCK AVAILABLE'
	RETURN 0
GO

DECLARE @code INT
EXEC @code = IS_AVAILABLE 'Chai', 23
PRINT @code
GO

--PREGUNTA 6
USE Northwind
GO

EXEC SP_HELP PRODUCTS
GO

EXEC SP_HELP SUPPLIERS
GO

CREATE PROCEDURE GET_PRODUCT_SALES
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
	GROUP BY ProductName, CompanyName, ContactName
GO

EXEC GET_PRODUCT_SALES @productID = 5
GO

