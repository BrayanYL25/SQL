-- Convert
USE EduTec
GO
SELECT
CONVERT(CHAR(12), GETDATE(), 101) AS '101(USA)mm/dd/yy',
CONVERT(CHAR(12), GETDATE(), 102) AS '102(ANSI)yy/mm/dd',
CONVERT(CHAR(12), GETDATE(), 103) AS '103(UK)dd/mm/yy'
FROM Alumno

SELECT A.ApeAlumno, A.NomAlumno, CONVERT(CHAR(12), M.FecMatricula, 103), CP.IdCurso, CP.IdCiclo FROM Alumno A
INNER JOIN Matricula M ON A.IdAlumno = M.IdAlumno
INNER JOIN CursoProgramado CP ON M.IdCursoProg = CP.IdCursoProg

-- Tabla Temporal
SELECT A.ApeAlumno, A.NomAlumno, CONVERT(CHAR(12), M.FecMatricula, 103) AS 'Fecha de Matricula', CP.IdCurso, CP.IdCiclo
INTO #TabTempo1
FROM Alumno A
INNER JOIN Matricula M ON A.IdAlumno = M.IdAlumno
INNER JOIN CursoProgramado CP ON M.IdCursoProg = CP.IdCursoProg
-- e.g.
USE MarketPERU
GO
SELECT P.IdProveedor, P.Nombre, CONVERT(CHAR(12), G.FechaSalida, 103) AS 'Fecha de Salida', PR.Nombre AS Producto, GD.IdGuia
INTO #ProductosEnviados 
FROM PROVEEDOR P
INNER JOIN PRODUCTO PR ON P.IdProveedor = PR.IdProveedor
INNER JOIN GUIA_DETALLE GD ON GD.IdProducto = PR.IdProducto
INNER JOIN GUIA G ON G.IdGuia = GD.IdGuia

SELECT * FROM #ProductosEnviados
DROP TABLE #ProductosEnviados
-- Enviando Datos a una Tabla Permanente
USE MarketPERU
GO
SELECT P.Nombre, OD.CantidadRecibida, CONVERT(CHAR(12), O.FechaEntrada, 103) AS 'Fecha de Ingreso'
INTO IngresoDeProducto -- Sin el "#"
FROM PRODUCTO P
INNER JOIN ORDEN_DETALLE OD ON OD.IdProducto = P.IdProducto
INNER JOIN ORDEN O ON O.IdOrden = OD.IdOrden

SELECT * FROM IngresoDeProducto
-- e.g.
USE Northwind

SELECT R.RegionDescription, ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.discount)), 2) as Monto
INTO VentasRegion_1998
FROM Region R
inner join Territories T ON R.RegionID = T.RegionID
inner join EmployeeTerritories ET ON T.TerritoryID = ET.TerritoryID
inner join Employees E ON ET.EmployeeID = E.EmployeeID
inner join Orders O ON E.EmployeeID = O.EmployeeID
inner join [Order Details] OD ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1998
GROUP BY R.RegionDescription
order by 2 desc

-- CREACION DE VISTAS
USE PUBS

CREATE VIEW V_EDITORLIBRO
AS
SELECT P.PUB_NAME, P.COUNTRY, T.TITLE, T.PRICE
FROM publishers P INNER JOIN TITLES T ON P.pub_id = T.pub_id
GO

SELECT * FROM V_EDITORLIBRO
GO

SELECT * FROM publishers

UPDATE publishers SET pub_name = 'Algodata Infosystems'
where pub_name = 'El condor'

USE Northwind

SELECT 
C.CompanyName as [Nombre del Cliente],
COUNT(O.OrderID) as [Cantidad de pedidos realizados]
FROM Customers C
inner join Orders O on C.CustomerID = O.CustomerID
GROUP BY C.CompanyName
GO

CREATE VIEW PEDIDOSPORCLIENTE
AS
SELECT 
C.CompanyName as [Nombre del Cliente],
COUNT(O.OrderID) as [Cantidad de pedidos realizados]
FROM Customers C
inner join Orders O on C.CustomerID = O.CustomerID
GROUP BY C.CompanyName
GO

SELECT * FROM PEDIDOSPORCLIENTE

USE MarketPERU

SELECT
P.Nombre as [Nombre del Proveedor],
SUM(gd.Cantidad) as [Total de unidades vendidas]
FROM PROVEEDOR P
INNER JOIN PRODUCTO PD ON P.IdProveedor = PD.IdProveedor
INNER JOIN GUIA_DETALLE GD ON PD.IdProducto = GD.IdProducto
GROUP BY P.Nombre


CREATE VIEW TOTAL_PRODUCTOS
AS
SELECT
P.Nombre as [Nombre del Proveedor],
SUM(gd.Cantidad) as [Total de unidades vendidas]
FROM PROVEEDOR P
INNER JOIN PRODUCTO PD ON P.IdProveedor = PD.IdProveedor
INNER JOIN GUIA_DETALLE GD ON PD.IdProducto = GD.IdProducto
GROUP BY P.Nombre

SELECT * FROM TOTAL_PRODUCTOS

CREATE VIEW EJEMPLO2
AS
SELECT 
PD.IDPRODUCTO,
PD.NOMBRE AS PRODUCTO,
C.CATEGORIA,
P.NOMBRE AS PROVEEDOR,
PD.PRECIOPROVEEDOR
FROM PROVEEDOR P
INNER JOIN PRODUCTO PD ON P.IdProveedor = PD.IdProveedor
INNER JOIN CATEGORIA C ON PD.IdCategoria = C.IdCategoria
GO

SELECT * FROM EJEMPLO2

UPDATE EJEMPLO2 SET Categoria = 'DULCES'
WHERE Categoria = 'GOLOSINAS'


use Northwind

CREATE VIEW V_CLIENTESSUDAMERCA
AS 
SELECT * FROM CUSTOMERS
WHERE COUNTRY IN ('BRAZIL', 'ARGENTINA', 'VENEZUELA')
GO

EXEC sp_depends V_CLIENTESSUDAMERCA

SELECT * FROM V_CLIENTESSUDAMERCA