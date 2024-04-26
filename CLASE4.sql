USE Northwind

SELECT TOP 10 WITH TIES CustomerID, COUNT(OrderID) AS [NÚMERO DE PEDIDOS DEL CLIENTE]
FROM Orders
WHERE YEAR(OrderDate) = 1997
GROUP BY CustomerID
HAVING COUNT(OrderID) < 5
ORDER BY 2 DESC

SELECT PRODUCTID, SUM(QUANTITY) AS [TOTAL DE PEDIDOS], ROUND(SUM(QUANTITY * UnitPrice * (1 - Discount)), 2) AS [MONTO TOTAL DE VENTAS]
FROM [Order Details]
GROUP BY ProductID
HAVING ROUND(SUM(QUANTITY * UnitPrice * (1 - Discount)), 2) BETWEEN 15000 AND 20000
ORDER BY 3 DESC


USE EduTec
SELECT Alumno.ApeAlumno, NomAlumno, IdCursoProg, Promedio FROM ALUMNO
INNER JOIN MATRICULA ON ALUMNO.IdAlumno = Matricula.IdAlumno

USE pubs

SELECT TITLES.title, publishers.pub_name, publishers.country, TITLES.type, TITLES.price
FROM titles
INNER JOIN publishers ON publishers.pub_id = titles.pub_id

SELECT
T.title_id AS LIBRO,
T.type AS CATEGORIA,
P.pub_name AS EDITORIAL,
P.country AS [PAIS DE ORIGEN],
T.price
FROM publishers P
INNER JOIN titles T
ON T.pub_id = P.pub_id

use Northwind

SELECT
S.CompanyName AS [Compañia transportista],
SUM(O.Freight) AS [Total de gastos de flete]
FROM Shippers S
INNER JOIN Orders O
ON s.ShipperID = o.ShipVia
GROUP BY S.CompanyName
Order by 2 DESC
GO

SELECT
S.CompanyName AS Proveedor,
P.ProductName as Producto,
P.UnitsInStock as [Existencia actual]
FROM Suppliers S
INNER JOIN Products P
ON S.SupplierID = P.SupplierID
ORDER BY 1, 2

USE EduTec

SELECT
A.ApeAlumno + ', ' + A.NomAlumno "NOMBRE DE ALUMNO",
M.IdCursoProg "CODIGO DE CURSO PROGRAMADO",
C.IdProfesor "CODIGO DE PROFESOR",
M.Promedio "PROMEDIO"
FROM Alumno A
INNER JOIN Matricula M ON A.IdAlumno = M.IdAlumno
INNER JOIN CursoProgramado C ON M.IdCursoProg = C.IdCursoProg

USE MarketPERU

SELECT
P.Nombre "NOMBRE DEL PRODUCTO",
P.IdProducto "CODIGO DE PRODUCTO",
C.Categoria "CATEGORIA",
PR.Nombre "NOMBRE DEL PROVEEDOR",
P.StockActual "EXISTENCIA EN ALMACEN"
FROM CATEGORIA C
INNER JOIN PRODUCTO P ON C.IdCategoria = P.IdCategoria
INNER JOIN PROVEEDOR PR ON P.IdProveedor = PR.IdProveedor

SELECT
PD.NOMBRE "PRODUCTO",
P.Nombre "PROVEEDOR",
P.Departamento + '-' + P.Ciudad + '-' +P.Direccion "UBICACIÓN Y ORIGEN",
C.Categoria "CATEGORIA",
PD.PrecioProveedor "PRECIO",
PD.StockActual "EXISTENCIA"
FROM PROVEEDOR P
INNER JOIN PRODUCTO PD ON P.IdProveedor = PD.IdProveedor
INNER JOIN CATEGORIA C ON C.IdCategoria = PD.IdCategoria
WHERE
C.Categoria IN
('GOLOSINAS', 'EMBUTIDOS', 'LACTEOS', 'LICORES', 'GASEOSAS')

SELECT
PD.NOMBRE "PRODUCTO",
P.Nombre "PROVEEDOR",
P.Departamento + '-' + P.Ciudad + '-' +P.Direccion "UBICACIÓN Y ORIGEN",
C.Categoria "CATEGORIA",
PD.PrecioProveedor "PRECIO",
PD.StockActual "EXISTENCIA"
FROM PROVEEDOR P
INNER JOIN PRODUCTO PD ON P.IdProveedor = PD.IdProveedor
INNER JOIN CATEGORIA C ON C.IdCategoria = PD.IdCategoria
WHERE
C.IdCategoria IN
(1, 2, 4, 5)

SELECT
PD.NOMBRE "PRODUCTO",
P.Nombre "PROVEEDOR",
P.Departamento + '-' + P.Ciudad + '-' +P.Direccion "UBICACIÓN Y ORIGEN",
C.Categoria "CATEGORIA",
PD.PrecioProveedor "PRECIO",
PD.StockActual "EXISTENCIA"
FROM PROVEEDOR P
INNER JOIN PRODUCTO PD ON P.IdProveedor = PD.IdProveedor
INNER JOIN CATEGORIA C ON C.IdCategoria = PD.IdCategoria
WHERE
C.IdCategoria NOT IN
(3, 6)


USE PUBS

SELECT TOP 3 WITH TIES
A.au_lname + ', ' +  A.au_fname "AUTOR",
SUM(S.qty) "EJEMPLARES VENDIDOS"
FROM authors A
INNER JOIN titleauthor TA ON TA.au_id = A.au_id
INNER JOIN titles T ON T.title_id = TA.title_id
INNER JOIN sales S ON T.title_id = S.title_id
GROUP BY A.au_lname, A.au_fname
ORDER BY SUM(S.qty) DESC

USE EduTec

SELECT
A.ApeAlumno + ', ' + A.NomAlumno "NOMBRE Y APELLIDO DEL ALUMNO",
CP.IdCursoProg "CURSO PROGRAMADO",
C.NomCurso "NOMBRE DE CURSO",
P.NomProfesor "NOMBRE DEL PROFESOR",
M.Promedio "PROMEDIO"
FROM ALUMNO A
INNER JOIN MATRICULA M ON M.IdAlumno = A.IdAlumno
INNER JOIN CURSOPROGRAMADO CP ON M.IdCursoProg = CP.IdCursoProg
INNER JOIN CURSO C ON CP.IdCurso = C.IdCurso
INNER JOIN Profesor P ON CP.IdProfesor = P.IdProfesor
ORDER BY 2

USE NORTHWIND

-- OJO CUIDADO CON LOS HOMONIMOS
SELECT TOP 3 WITH TIES
E.LastName,
E.FirstName,
E.EmployeeID,
ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 2) "MONTO"
FROM Employees E
INNER JOIN Orders O ON  E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
GROUP BY E.LastName, E.FirstName, E.EmployeeID
ORDER BY 4 DESC


SELECT
R.RegionDescription AS [NOMBRE DE REGION],
ROUND(SUM(OD.UnitPrice * OD.UnitPrice * (1 - OD.Discount)), 2) AS [MONTO DE VENTAS]
FROM REGION R
INNER JOIN Territories T ON R.RegionID = T.RegionID
INNER JOIN EmployeeTerritories ET ON ET.TerritoryID = T.TerritoryID
INNER JOIN Employees E ON ET.EmployeeID = E.EmployeeID
INNER JOIN Orders O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY R.RegionDescription
ORDER BY 2 DESC

SELECT
R.RegionDescription AS [NOMBRE DE REGION],
ROUND(SUM(OD.UnitPrice * OD.UnitPrice * (1 - OD.Discount)), 2) AS [MONTO DE VENTAS]
FROM REGION R
INNER JOIN Territories T ON R.RegionID = T.RegionID
INNER JOIN EmployeeTerritories ET ON ET.TerritoryID = T.TerritoryID
INNER JOIN Employees E ON ET.EmployeeID = E.EmployeeID
INNER JOIN Orders O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE O.OrderDate BETWEEN '19970101' AND '19970603'
GROUP BY R.RegionDescription
HAVING R.RegionDescription IN ('Northern', 'Southern')
ORDER BY 2 DESC

-- PRESENTAR EL MONTO DE VENTAS REGION Y CATEGORIA (LO QUE SE VENDIO EN )