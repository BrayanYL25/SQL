USE MASTER
GO

DROP DATABASE IF EXISTS FLORISTERIA
GO

-- BASE DE DATOS FLORISTERIA
CREATE DATABASE FLORISTERIA

--CREATE MAIN FILE
ON PRIMARY (
	NAME = "FLORISTERIA_MDF",
	FILENAME = "C:\SQL-2024-ISIL\EP1\floristeria.mdf",
	SIZE = 8MB,
	MAXSIZE = 200MB,
	FILEGROWTH = 2
)

-- CREATE LOG FILE
LOG ON (
	NAME = "FLORISTERIA_LDF",
	FILENAME = "C:\SQL-2024-ISIL\EP1\floristeria.ldf",
	SIZE = 8MB,
	MAXSIZE = 200MB,
	FILEGROWTH = 2
)
GO

USE FLORISTERIA
GO

CREATE TABLE ESPECIE (
	IdEspecie INT NOT NULL IDENTITY(1, 1),
	NomEspecie VARCHAR(40),
	EpocaFlorac VARCHAR(30),
	TipoSuelo VARCHAR(40)
)

CREATE TABLE FLOR (
	IdFlor INT NOT NULL IDENTITY(1, 1),
	IdEspecie INT, -- PRIMARY KEY FOR ESPECIE
	NombreFlor VARCHAR(40),
	UnidadVenta VARCHAR(30),
	PrecioAct MONEY
)

CREATE TABLE CLIENTE (
	IdCliente INT NOT NULL IDENTITY(1, 1),
	NomCli VARCHAR(30),
	ApeCli VARCHAR(30),
	DirCli VARCHAR(40),
	TelefCli VARCHAR(13)
)

CREATE TABLE VENDEDOR (
	IdVendedor INT NOT NULL IDENTITY(1, 1),
	NomVend VARCHAR(30),
	ApeVend VARCHAR(30),
	DniVend CHAR(8),
	TelefVend VARCHAR(13)
)

CREATE TABLE TRANSPORTISTA (
	IdTransp INT NOT NULL IDENTITY(1, 1),
	NomTransp VARCHAR(40),
	DirTransp VARCHAR(50),
	RucTransp CHAR(11),
	TelefTransp VARCHAR(13)
)

CREATE TABLE PEDIDO (
	NroPedido INT NOT NULL,
	Fecha DATETIME,
	Monto MONEY,
	IdCliente INT,
	IdVendedor INT,
	IdTransp INT
)

CREATE TABLE DETALLE_PEDIDO (
	NroPedido INT NOT NULL, -- PRIMARY KEY FOR PEDIDO
	IdFlor INT, -- PRIMARY KEY FOR FLOWER
	Cantidad INT,
	PreUniVen MONEY
)


-- 3. CREANDO LAS CLAVES PRIMARIAS
ALTER TABLE ESPECIE ADD CONSTRAINT CP_ESPECIE PRIMARY KEY (IdEspecie)
ALTER TABLE FLOR ADD CONSTRAINT CP_FLOR PRIMARY KEY (IdFlor)
ALTER TABLE PEDIDO ADD CONSTRAINT CP_PEDIDO PRIMARY KEY (NroPedido)
ALTER TABLE CLIENTE ADD CONSTRAINT CP_CLIENTE PRIMARY KEY (IdCliente)
ALTER TABLE VENDEDOR ADD CONSTRAINT CP_VENDEDOR PRIMARY KEY (IdVendedor)
ALTER TABLE TRANSPORTISTA ADD CONSTRAINT CP_TRANSPORTISTA PRIMARY KEY (IdTransp)

-- 4. CREANDO LLAVES FORANEAS
ALTER TABLE PEDIDO ADD CONSTRAINT CP_PEDIDO_CLIENTE FOREIGN KEY (IdCliente) REFERENCES CLIENTE
ALTER TABLE PEDIDO ADD CONSTRAINT CP_PEDIDO_VENDEDOR FOREIGN KEY (IdVendedor) REFERENCES VENDEDOR
ALTER TABLE PEDIDO ADD CONSTRAINT CP_PEDIDO_TRANSPORTISTA FOREIGN KEY (IdTransp) REFERENCES TRANSPORTISTA
ALTER TABLE DETALLE_PEDIDO ADD CONSTRAINT CP_DETALLE_PEDIDO FOREIGN KEY (NroPedido) REFERENCES PEDIDO
ALTER TABLE DETALLE_PEDIDO ADD CONSTRAINT CP_DETALLE_FLOR FOREIGN KEY (IdFlor) REFERENCES FLOR
ALTER TABLE FLOR ADD CONSTRAINT CP_FLOR_ESPECIE FOREIGN KEY (IdEspecie) REFERENCES ESPECIE

-- 5. CREANDO CONSTRAINT POR DEFECTO
ALTER TABLE CLIENTE ADD CONSTRAINT DEFAULT_DIR DEFAULT 'LIMA' FOR DirCli

-- 6. AGREGAR CAMPO "FECHA DE INGRESO" A LA TABLA VENDEDOR
ALTER TABLE VENDEDOR ADD FechaIngreso DATE

-- 7. LA FECHA DE INGRESO DE UN VENDEDOR NO PUEDE SER POSTERIOS A LA FECHA ACTUAL
ALTER TABLE VENDEDOR ADD CHECK (FechaIngreso < getDate())

-- 8. EL DNI DE UN VENDEDOR NO SE PUEDE REPETIR
ALTER TABLE VENDEDOR ADD CONSTRAINT DNI_NO_REPETIBLE UNIQUE (DniVend)

-- 9. INSERTAR 4 REGISTROS A VENDEDOR, 3 A TRANSPORTISTAS Y 8 A CLIENTES
INSERT INTO VENDEDOR (NomVend, ApeVend, DniVend, TelefVend)
VALUES 
('Brayan', 'Yin Lin', '76950977', '1234567890123'),
('Jhonatan', 'Pedro', '76066590', '1238567890123'),
('Leonardo', 'Yaranga', '88997843', '1238567890122'),
('Luisa', 'Celis', '12345678', '1238567890122')

INSERT INTO TRANSPORTISTA (NomTransp, DirTransp, RucTransp, TelefTransp)
VALUES
('Cecilia', 'Santiago de Surco', '12345678901', '910102872'),
('Estrella', 'Chorrillos', '09876543211', '900876123'),
('Naomi', 'Shelby', '12380912309', '934567239')

INSERT INTO CLIENTE (NomCli, ApeCli, DirCli, TelefCli)
VALUES
('Mauricio', 'Romero', 'Surquillo', '0909090909'),
('Marcelo', 'Ortega', 'Ancon', '129019012938'),
('Jambert', 'Vazques', 'Miraflores', '12345678910'),
('Gianfranco', 'Llontop', 'San Miguel', '1230937458'),
('Eitan', 'Urbina', 'Villa el salvador', '123987465'),
('Samuel', 'Colina', 'La victoria', '138800123'),
('Dael', 'Ibarcena', 'Santiago de Surco', '23312441'),
('Estefano', 'Ibañez', 'Santiago de Surco', '9831202309')

-- 10. En la Tabla VENDEDOR Cambiar el Teléfono del segundo registro.

UPDATE VENDEDOR
SET TelefVend = '21333990122'
WHERE IdVendedor = 2

-- 11. Eliminar el último registro de la Tabla VENDEDOR.
DELETE FROM VENDEDOR WHERE IdVendedor = (SELECT COUNT(IdVendedor) FROM VENDEDOR)

-- 12. Ingresar 3 especies. Ingresar 5 flores. Ingresar 2 Pedidos. Ingresar dos detalles de pedidos por cada pedido.
INSERT INTO ESPECIE (NomEspecie, TipoSuelo, EpocaFlorac)
VALUES
('Tuliopis Ovidae', 'Arido', 'Otoño'),
('Grisalis Curtumus', 'Poroso', 'Verano'),
('Sopratare plantae', 'Humedo', 'Verano')

INSERT INTO FLOR (IdEspecie, NombreFlor, PrecioAct, UnidadVenta)
VALUES
(2, 'Margarita', 4.1, 'Unidad'),
(1, 'Tulipan', 2, 'Unidad'),
(2, 'Rosa', 3.3, 'Unidad'),
(3, 'Girasoles', 1, 'Unidad'),
(1, 'Rosas negra', 5, 'Unidad')

INSERT INTO PEDIDO (NroPedido, IdCliente, IdTransp, IdVendedor, Fecha, Monto)
VALUES
(123, 2, 2, 1, '2024-04-12', 20),
(124, 7, 3, 3, '2024-04-28', 80)

INSERT INTO DETALLE_PEDIDO (NroPedido, IdFlor, Cantidad, PreUniVen)
VALUES
(123, 5, 6, 10),
(123, 1, 3, 10),
(124, 2, 20, 40),
(124, 3, 15, 40)


-- 13. En la Base de Datos Northwind Presentar una lista de Productos que provengan de los Proveedores 1, 3, 5, 7, 9, 11 y 13. 
-- Además, que el stock de los productos sea mayor o igual a 20 unidades y menor o igual a 60 unidades.

USE Northwind

SELECT * FROM Products
WHERE SupplierID IN (1, 3, 5, 7, 9, 11, 13) AND UnitsInStock BETWEEN 20 AND 60


-- 14. En Northwind. Presentar una lista de Clientes cuyo representante tenga que ver con el Área de Marketing o el Área de Ventas.
SELECT * FROM Customers
WHERE ContactTitle = 'Marketing Manager' 
	OR ContactTitle = 'Sales Representative' 
	OR ContactTitle = 'Sales Associate' 
	OR ContactTitle = 'Sales Manager'
	OR ContactTitle = 'Sales Agent'


-- 15. En Northwind. Presentar una lista de los cuatro Países con mayor cantidad de Proveedores.
SELECT TOP 4 Country "Pais", COUNT(Country) "Proveedores" FROM Suppliers
GROUP BY Country
ORDER BY 2 DESC

-- 16. En Northwind presentar una lista de pedidos que se hayan entregado fuera del límite 
-- programado para la entrega. Mostrar el código del transportista que se encargó de llevar el pedido,
-- la fecha del pedido, la fecha requerida para se entregue el pedido la diferencia en días que se excedió la entrega.
SELECT 
FORMAT(OrderDate, 'dd-MM-yyyy') as [FECHA DE PEDIDO],
FORMAT(RequiredDate, 'dd-MM-yyyy') AS [FECHA ESTIMADA], 
FORMAT(ShippedDate, 'dd-MM-yyyy') AS [FECHA DE ENTREGA]
FROM Orders
WHERE ShippedDate > RequiredDate