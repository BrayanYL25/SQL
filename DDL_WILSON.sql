




--================================================================
--	EJEMPLO DE UNA TRANSACCION QUE CONTROLA
--		 UN PROCESO DE VENTA
--================================================================

USE Master
GO

--***********************************
-- Crear la base de datos WILSON_MARKET 
--   ( debe existir la carpeta Data en la unidad E:\ ) 
--***********************************
USE MASTER
GO
CREATE DATABASE WILSON_MARKET
ON PRIMARY
( NAME = 'WILSON_MARKET_Data',
   FILENAME = 'D:\SQL-2024\WILSON\WILSON_MARKET_Data.mdf',
   SIZE = 5,
   MAXSIZE = 200,
   FILEGROWTH = 1 )
LOG ON
( NAME = 'WILSON_MARKET_Log',
   FILENAME = 'D:\SQL-2024\WILSON\WILSON_MARKET_Log.ndf',
   SIZE = 1MB,
   MAXSIZE = 100MB,
   FILEGROWTH = 1MB )
GO


USE WILSON_MARKET
GO

--****************************
-- Crear la tabla PRODUCTO
--****************************

CREATE TABLE PRODUCTO
  (
    ProCodigo 	INT IDENTITY(1,1) NOT NULL, 
    ProNombre 	VARCHAR(50) NOT NULL,
    ProPrecio 	DECIMAL(10,2) NOT NULL,
    ProStock 	INT NOT NULL
  )
GO

 
--******************************************************
-- Modificar la tabla para crear el PK (Primary key)
--******************************************************

ALTER TABLE PRODUCTO
    ADD CONSTRAINT pkProCodigo PRIMARY KEY (ProCodigo)
GO

--*******************************************
-- Modificar la tabla para crear un CHECK
--*******************************************

ALTER TABLE PRODUCTO
    ADD CONSTRAINT ckProStock CHECK (ProStock >= 0)
GO

--***********************************
-- Crear la tabla FACTURA
--***********************************

CREATE TABLE FACTURA
  (
    FacNumero 			INT IDENTITY(1,1) NOT NULL, 
    FacFecha 			DATETIME NOT NULL,
    FacRazonSocial 	VARCHAR(50) NOT NULL,
	 FacRUC				CHAR(11) NOT NULL
  )
GO

--************************************************************
-- Modificar la tabla para crear el PK (Primary key)
--************************************************************

ALTER TABLE FACTURA
    ADD CONSTRAINT pkFacNumero PRIMARY KEY (FacNumero)
GO

--*******************************************
-- Modificar la tabla para crear un DEFAULT
--*******************************************

ALTER TABLE FACTURA
    ADD CONSTRAINT dfFacFecha DEFAULT GetDate() FOR FacFecha
GO

 
--*******************************************
-- Modificar la tabla para crear un CHECK
--*******************************************

ALTER TABLE FACTURA
   ADD CONSTRAINT ckFacRUC 
	CHECK 
	(FacRUC Like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO


--***********************************
-- Crear la Tabla DETALLE
--***********************************

CREATE TABLE DETALLE
  (
    FacNumero		INT NOT NULL, 
    ProCodigo		INT NOT NULL,
    DetPrecio 		DECIMAL(10,2) NOT NULL,
    DetCantidad 	INT NOT NULL
  )
GO

--************************************************************
-- Modificar la tabla para crear el PK (Primary key)
--************************************************************

ALTER TABLE DETALLE
    ADD CONSTRAINT pk_DETALLE PRIMARY KEY (FacNumero, ProCodigo)
GO

--*******************************************
-- Modificar la tabla para crear un CHECK
--*******************************************

ALTER TABLE DETALLE
   ADD CONSTRAINT ckDetCantidad CHECK (DetCantidad > 0)
GO

--********************************************************
-- Modificar la tabla para crear los FK (Foreign Key)
--********************************************************

ALTER TABLE DETALLE
		ADD CONSTRAINT fk_FacNumero 
		FOREIGN KEY (FacNumero) REFERENCES FACTURA
GO

ALTER TABLE DETALLE
      ADD CONSTRAINT fk_ProCodigo 
		FOREIGN KEY (ProCodigo) REFERENCES PRODUCTO
GO



--================================================================
--	EJEMPLO DE UNA TRANSACCION QUE CONTROLA
--		 UN PROCESO DE VENTA
--================================================================

USE Master
GO

----***********************************
---- Crear la base de datos WILSON_MARKET 
----   ( debe existir la carpeta Data en la unidad E:\ ) 
----***********************************
----USE MASTER
----GO
----CREATE DATABASE WILSON_MARKET
----ON PRIMARY
----( NAME = 'WILSON_MARKET_Data',
----   FILENAME = 'G:\MisDatos\WILSON_MARKET_Data.mdf',
----   SIZE = 5,
----   MAXSIZE = 200,
----   FILEGROWTH = 1 )
----LOG ON
----( NAME = 'WILSON_MARKET_Log',
----   FILENAME = 'G:\MisDatos\WILSON_MARKET_Log.ndf',
----   SIZE = 1MB,
----   MAXSIZE = 100MB,
----   FILEGROWTH = 1MB )
----GO


----USE WILSON_MARKET
----GO

----****************************
---- Crear la tabla PRODUCTO
----****************************

--CREATE TABLE PRODUCTO
--  (
--    ProCodigo 	INT IDENTITY(1,1) NOT NULL, 
--    ProNombre 	VARCHAR(50) NOT NULL,
--    ProPrecio 	DECIMAL(10,2) NOT NULL,
--    ProStock 	INT NOT NULL
--  )
--GO

 
----******************************************************
---- Modificar la tabla para crear el PK (Primary key)
----******************************************************

--ALTER TABLE PRODUCTO
--    ADD CONSTRAINT pkProCodigo PRIMARY KEY (ProCodigo)
--GO

----*******************************************
---- Modificar la tabla para crear un CHECK
----*******************************************

--ALTER TABLE PRODUCTO
--    ADD CONSTRAINT ckProStock CHECK (ProStock >= 0)
--GO

----***********************************
---- Crear la tabla FACTURA
----***********************************

--CREATE TABLE FACTURA
--  (
--    FacNumero 			INT IDENTITY(1,1) NOT NULL, 
--    FacFecha 			DATETIME NOT NULL,
--    FacRazonSocial 	VARCHAR(50) NOT NULL,
--	 FacRUC				CHAR(11) NOT NULL
--  )
--GO

----************************************************************
---- Modificar la tabla para crear el PK (Primary key)
----************************************************************

--ALTER TABLE FACTURA
--    ADD CONSTRAINT pkFacNumero PRIMARY KEY (FacNumero)
--GO

----*******************************************
---- Modificar la tabla para crear un DEFAULT
----*******************************************

--ALTER TABLE FACTURA
--    ADD CONSTRAINT dfFacFecha DEFAULT GetDate() FOR FacFecha
--GO

 
----*******************************************
---- Modificar la tabla para crear un CHECK
----*******************************************

--ALTER TABLE FACTURA
--   ADD CONSTRAINT ckFacRUC 
--	CHECK 
--	(FacRUC Like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--GO


----***********************************
---- Crear la Tabla DETALLE
----***********************************

--CREATE TABLE DETALLE
--  (
--    FacNumero		INT NOT NULL, 
--    ProCodigo		INT NOT NULL,
--    DetPrecio 		DECIMAL(10,2) NOT NULL,
--    DetCantidad 	INT NOT NULL
--  )
--GO

----************************************************************
---- Modificar la tabla para crear el PK (Primary key)
----************************************************************

--ALTER TABLE DETALLE
--    ADD CONSTRAINT pk_DETALLE PRIMARY KEY (FacNumero, ProCodigo)
--GO

----*******************************************
---- Modificar la tabla para crear un CHECK
----*******************************************

--ALTER TABLE DETALLE
--   ADD CONSTRAINT ckDetCantidad CHECK (DetCantidad > 0)
--GO

----********************************************************
---- Modificar la tabla para crear los FK (Foreign Key)
----********************************************************

--ALTER TABLE DETALLE
--		ADD CONSTRAINT fk_FacNumero 
--		FOREIGN KEY (FacNumero) REFERENCES FACTURA
--GO

--ALTER TABLE DETALLE
--      ADD CONSTRAINT fk_ProCodigo 
--		FOREIGN KEY (ProCodigo) REFERENCES PRODUCTO
--GO


--Use WILSON_MARKET
--GO
USE WILSON_MARKET
GO
--**************************************************
-- Agregar registros de ejemplo a la tabla PRODUCTO
--**************************************************
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('MEMORIA SODIMM PATRIOT',131,100)
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('COOLER PARA PROCESADOR',103,100)
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('FUENTE DE PODER 1ST PLAYER',284,100)
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('MAINBOARD ASUS PRIME',267,100)
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('TARJETA VIDEO ZOTAC',247,100)
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('DISCO SOLIDO SSD LEXAR',249,100)
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('FUENTE DE PODER EVGA',959,100)
INSERT Producto (ProNombre, ProPrecio, ProStock) Values('CASE ANTRYX ELEGANT',149,100)
GO

--********************************************
-- Mostrar los registros de las tablas 
--********************************************
SELECT * FROM PRODUCTO
SELECT * FROM FACTURA
SELECT * FROM DETALLE
GO


CREATE PROCEDURE usp_Venta
	@FacNumero 			INT						OUTPUT,      
	@FacRazonSocial 	VARCHAR(50), 
	@FacRUC					CHAR(11),      
	@Detalle					VARCHAR(500)
AS
	SET NOCOUNT ON	
	BEGIN TRANSACTION 
	DECLARE @varError INT, 
	@varRegAfec INT,
	@varCASO INT
	DECLARE
		@ProCodigo INT, 
		@DetPrecio DECIMAL(10,2), 
		@DetCantidad INT

INSERT INTO FACTURA (FacRazonSocial, FacRUC) 
                         VALUES (@FacRazonSocial, @FacRUC)
SELECT 
		@varError = @@ERROR, 
		@varRegAFec = @@ROWCOUNT, 
		@varCASO = 1
	IF @varError<>0 OR @varRegAfec = 0
		GOTO MensajeError

	SET @FacNumero = @@IDENTITY

	WHILE LEN(@Detalle) > 0        -- AQUI EMPIEZA EL BUCLE HASTA QUE @Detalle SEA CERO OSEA QUE YA NO HAYA DETALLES
	  BEGIN
		 SET @ProCodigo = CONVERT(INT, LEFT(@Detalle, CHARINDEX(',',@Detalle,1) - 1))
		 SET @Detalle = RIGHT(@Detalle, LEN(@Detalle) - CHARINDEX(',',@Detalle,1))

		 IF CHARINDEX(',',@Detalle,1) = 0 
			BEGIN
				SET @DetCantidad = CONVERT(INT, @Detalle)
				SET @Detalle = ''
			END
		 ELSE
			BEGIN
				SET @DetCantidad = CONVERT(INT, LEFT(@Detalle, CHARINDEX(',',@Detalle,1) - 1))
				SET @Detalle = RIGHT(@Detalle, LEN(@Detalle) - CHARINDEX(',',@Detalle,1))
			END

SELECT @DetPrecio = ProPrecio FROM PRODUCTO 
WHERE ProCodigo = @ProCodigo 

SELECT @varError = @@ERROR, @varRegAFec = @@ROWCOUNT, @varCASO = 2

		IF @varError<>0 OR @varRegAfec = 0
			GOTO MensajeError

INSERT INTO DETALLE 
	VALUES (@FacNumero, @ProCodigo, @DetPrecio, @DetCantidad)

SELECT @varError = @@ERROR, @varRegAFec = @@ROWCOUNT, @varCASO = 3

IF @varError<>0 OR @varRegAfec = 0    GOTO MensajeError
			
UPDATE PRODUCTO SET ProStock = ProStock - @DetCantidad 
   						WHERE ProCodigo = @ProCodigo			
SELECT @varError = @@ERROR, @varRegAFec = @@ROWCOUNT, @varCASO = 4

IF @varError<>0 OR @varRegAfec = 0    GOTO MensajeError

END	--  AQUI SE REGRESA AL PRINCIPIO DEL BUCLE
	
-- GUARDAR LA TRANSACCION ACTUAL
COMMIT TRANSACTION
	RETURN 0
	
MensajeError:
	-- CANCELAR LA TRANSACCION ACTUAL
      ROLLBACK TRANSACTION
            IF @varCASO = 1
		RAISERROR('ERROR: Al insertar la cabecera de la FACTURA',16,1)
	IF @varCASO = 2
		RAISERROR('ERROR: Al Seleccionar un PRODUCTO',16,1)
	IF @varCASO = 3
		RAISERROR('ERROR: Al insertar un detalle de la FACTURA',16,1)
	IF @varCASO = 4
		RAISERROR('ERROR: Al actualizar un PRODUCTO',16,1)

      SET @FacNumero = 0
	 RETURN 1
GO

DECLARE @numero INT
EXEC usp_Venta
	@FacNumero = @numero OUTPUT,
	@FacRazonSocial = 'PERUDEV',
	@FacRUC = '12345678900',
	@Detalle = '2,4,5,2,8,3'
SELECT @numero AS FacNumero
SELECT * FROM FACTURA
SELECT * FROM DETALLE
SELECT * FROM PRODUCTO
GO

