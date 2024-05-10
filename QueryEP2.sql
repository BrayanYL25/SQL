-- EVALUACION PERMANENTE 2
USE Northwind

-- 1. Monto total de pedido
SELECT 
	o.OrderID,
	SUM(od.UnitPrice * Quantity) as [Monto Bruto],
	ROUND(SUM((od.UnitPrice * Quantity) * Discount), 2) as [Monto Descuento],
	ROUND(SUM((od.UnitPrice * Quantity) * (1 - Discount)), 2) as [Monto Total]
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID

-- 2. Monto total de unidades vendidas por producto
SELECT
	ProductName as [Nombre Producto],
	SUM(Quantity) as [Unidades Vendidas]
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.OrderDate BETWEEN '19970501' AND '19970930'
GROUP BY ProductName

-- 3. Monto total de ventas de productos lacteos durante el año 1997
SELECT
	RegionDescription as [Region],
	CategoryName as [Categoria],
	ProductName as [Nombre Producto],
	ROUND(SUM((OD.UnitPrice * Quantity) * (1 - Discount)), 2) as [Total de ventas]
FROM Categories C
INNER JOIN Products P ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
INNER JOIN EmployeeTerritories ET ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories T ON ET.TerritoryID = T.TerritoryID
INNER JOIN Region R ON T.RegionID = R.RegionID
WHERE C.CategoryID = 4 AND YEAR(OrderDate) = 1997
GROUP BY RegionDescription, CategoryName, ProductName
ORDER BY 1

-- 4. Monto total de libros vendidos por ciudad
USE PUBS

SELECT 
	title AS [Libro],
	city AS [Ciudad],
	qty as [Total libros vendidos]
FROM titles T
INNER JOIN sales S ON T.title_id = S.title_id
INNER JOIN stores ST ON S.stor_id = ST.stor_id
WHERE title like 'Silicon%'