

/*
Semana 10 -  Viernes 31 Mayo 2024
*/



/*Crear un SP en Pubs, que, al entregarle el codigo de un Autor, presente	los apellidos y 
nombres del autor, la Ciudad de prodecedencia, la cantidad de libros vendidos y 
el monto vendido correspondiente a dicho autor */
USE pubs
GO
SELECT A.au_id, A.au_lname, A.au_fname, A.city, SUM(S.qty), SUM(S.qty * T.price)
FROM			AUTHORS			A
INNER JOIN	TITLEAUTHOR		TA ON A.au_id=TA.au_id
INNER JOIN	TITLES					T   ON TA.title_id=T.title_id
INNER JOIN	SALES					S   ON T.title_id=S.title_id
GROUP BY A.au_id, A.au_lname, A.au_fname, A.city
HAVING A.au_id = '238-95-7766'
GO
-- 238-95-7766	Carson	  Cheryl 	Berkeley	30  	688.50
-- Convirtiendo a SP
CREATE PROCEDURE SPU_VENTASAUTOR
 @cod VARCHAR(11), @ape VARCHAR(40) OUTPUT, @nom VARCHAR(20) OUTPUT,
 @ciudad VARCHAR(20) OUTPUT, @can INT OUTPUT,	@monto MONEY  OUTPUT  
AS
SELECT @cod = A.au_id, @ape = A.AU_LNAME, @nom = A.AU_FNAME, @ciudad = A.CITY, 
	         @can = SUM(S.QTY), @monto = SUM(S.QTY*T.PRICE)
FROM			AUTHORS			A
INNER JOIN	TITLEAUTHOR		TA ON A.au_id=TA.au_id
INNER JOIN	TITLES					T   ON TA.title_id=T.title_id
INNER JOIN SALES					S   ON T.title_id=S.title_id
GROUP BY A.au_id, A.au_lname, A.au_fname, A.city
HAVING A.au_id = @cod
GO
-- Probando con datos prueba: 238-95-7766	 Carson	Cheryl		Berkeley	30 	688.50
DECLARE @a VARCHAR(40),@n VARCHAR(20), @cD VARCHAR(20), @cT INT, @m MONEY 
EXEC  SPU_VENTASAUTOR '238-95-7766',
           @a OUTPUT, @n OUTPUT, @cD OUTPUT, @cT OUTPUT, @m OUTPUT 
SELECT  @a AS APELLIDOS,@n AS NOMBRES,@cD AS CIUDAD,
               @cT AS CANTIDAD,@m AS MONTO
GO 
-- Probando con otro autor: 213-46-8915
DECLARE @a VARCHAR(40),@n VARCHAR(20), @cD VARCHAR(20), @cT INT, @m MONEY 
EXEC  SPU_VENTASAUTOR '213-46-8915',
           @a OUTPUT, @n OUTPUT, @cD OUTPUT, @cT OUTPUT, @m OUTPUT 
SELECT  @a AS APELLIDOS,@n AS NOMBRES,@cD AS CIUDAD,
               @cT AS CANTIDAD,@m AS MONTO
GO 
-- Green	Marjorie	Oakland	50	  404.50 




/*

Semana 10   
Viernes 31 Mayo 2024

*/

/* En Northwind, presentar el total de ventas de un producto, 
en un intervalo de fechas determinado.
   Mostrar tambien el nombre del producto*/
USE Northwind
GO 
SELECT *
FROM				Orders					O	
 INNER JOIN	[Order Details]	OD	ON	O.OrderID = OD.OrderID
 INNER JOIN   Products				P		ON	OD.ProductID = P.ProductID
GO
SELECT 
	OD.ProductID, 
	P.ProductName,
    ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)
FROM			Orders					O	
INNER JOIN	[Order Details]	OD	ON	O.OrderID = OD.OrderID
INNER JOIN Products				P		ON	OD.ProductID = P.ProductID
GROUP BY OD.ProductID, P.ProductName
GO
SELECT  
	OD.ProductID, 
	P.ProductName,
    ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)
FROM			Orders					O	
INNER JOIN	[Order Details]	OD	ON	O.OrderID = OD.OrderID
INNER JOIN Products				P		ON	OD.ProductID = P.ProductID
GROUP BY OD.ProductID, P.ProductName
HAVING OD.ProductID = 3
GO

SELECT 
	OD.ProductID, 
	P.ProductName,
    ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)
FROM			Orders					O	
INNER JOIN	[Order Details]	OD	ON	O.OrderID = OD.OrderID
INNER JOIN Products				P		ON	OD.ProductID = P.ProductID
WHERE O.OrderDate BETWEEN '19970101' AND '19970331'
GROUP BY OD.ProductID, P.ProductName
HAVING OD.ProductID = 3
GO
-- Entradas:	3	  '19970101'    '19970331' 
-- Salidas:	Aniseed Syrup  	544

-- CONVIRTIENDO LA CONSULTA EN SP:
 CREATE PROCEDURE spu_ventProFe 
	@cp INT, 
	@fi DATETIME, 
	@ff DATETIME, 
	@np NVARCHAR(40) OUTPUT, 
	@MV MONEY OUTPUT
 AS
 SELECT 
	@cp = OD.ProductID, 
	@np = P.ProductName,
    @MV = ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)
FROM			Orders					O	
INNER JOIN	[Order Details]	OD	ON	O.OrderID = OD.OrderID
INNER JOIN Products				P		ON	OD.ProductID = P.ProductID
WHERE O.OrderDate BETWEEN @fi AND @ff
GROUP BY OD.ProductID, P.ProductName
HAVING OD.ProductID = @cp
GO
-- PROBANDO EL SP:
 DECLARE @M MONEY, @N NVARCHAR(40)
 EXEC spu_ventProFe 3,'19970101','19970331',@N OUTPUT, @M OUTPUT
 SELECT @N, @M
 GO

 DECLARE @M MONEY, @N NVARCHAR(40)
 EXEC spu_ventProFe 20,'19980101','19980630',@N OUTPUT, @M OUTPUT
 SELECT @N, @M
 GO

 /* Tarea: Crear un sp con varios parametros de entrada y salida
  en las cuatro bd de prueba que tenemos de prueba */
--

  /*	PROCEDIMIENTOS ALMACENADOS CON TRANSACCIONES */
    --****************************************************************
   /*   Desarrollar un SP 
   que permita matricular 
   a un Alumno en la 
     BD EduTec.*/
	 USE EDUTEC
	 GO
	 SP_HELP MATRICULA
	 GO	 	 
	 /* 
	Se debe verificar si existen vacantes y si el curso esta activo, 
	además se debe incrementar el numero de matriculados 
	y disminuir las vacantes. 

	Escriba el Script necesario para probar el SP.
	Los valores de retorno son:
		0	Ok												
		1	Valor nulo
		2	Curso no programado					
		3	Alumno no registrado
		4	No hay vacantes para el curso	
		5	El curso ya no esta activo.
		6	Error de BD
SOLUCION:    */
USE EduTec
GO
--Se requieren tres parametros de entrada
CREATE PROCEDURE spu_MatriculaAlumno
	@cursoprog INT, 
	@idalumno CHAR(5),	
	@fecmatricula	 DATETIME
AS
	DECLARE @vacantes TINYINT
	DECLARE @activo BIT
IF (@cursoprog IS NULL)		OR 
	(@idalumno IS NULL)		OR 
	(@fecmatricula IS NULL)
	BEGIN
		PRINT 'VALOR NULO'
		RETURN 1
	END
IF NOT EXISTS(SELECT idcursoprog FROM cursoprogramado 
                            WHERE idcursoprog = @cursoprog)
	BEGIN
		PRINT 'ESTE CURSO NO ESTA PROGRAMADO'
		RETURN 2
	END
IF NOT EXISTS(SELECT apealumno + ', ' + nomalumno FROM alumno 
                            WHERE IDALUMNO = @idalumno)
	BEGIN
		PRINT 'EL ALUMNO NO ESTA REGISTRADO'
		RETURN 3
	END
SELECT @vacantes = vacantes, @activo = activo FROM cursoprogramado 
                WHERE idcursoprog = @cursoprog
	IF @vacantes = 0
	BEGIN
		PRINT 'YA NO HAY VACANTES PARA ESTE CURSO'
		RETURN 4
	END
	IF @activo = 0
	BEGIN
		PRINT 'EL CURSO YA NO ESTA ACTIVO'
		RETURN 5
	END
	BEGIN TRAN
		UPDATE CursoProgramado
		SET vacantes = vacantes -1, matriculados = matriculados + 1  
		            WHERE idcursoprog = @cursoprog
		INSERT INTO matricula (idcursoprog,idalumno,fecmatricula)
		                         VALUES (@cursoprog,@idalumno,@fecmatricula)
		IF @@ERROR <> 0
		BEGIN
			PRINT ' ERROR EN LA BD'
			ROLLBACK TRAN
			RETURN 6
		END
	COMMIT TRAN
	RETURN 0
GO
-- Prueba del SP -- Condiciones iniciales:
SELECT * FROM MATRICULA WHERE IDALUMNO='A0010'
SELECT * FROM CURSOPROGRAMADO WHERE IDCURSOPROG = 9
SELECT * FROM MATRICULA WHERE IDCURSOPROG = 9
GO
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 9,'A0010','20240531'
SELECT @RET
GO
-- Verificando si el Alumno esta matriculado
SELECT * FROM MATRICULA WHERE IDALUMNO='A0010'
SELECT * FROM CURSOPROGRAMADO WHERE IDCURSOPROG = 9
SELECT * FROM MATRICULA WHERE IDCURSOPROG = 9
GO
-- Con un Alumno no registrado.
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 9,'B0002','20240531'
SELECT @RET
GO
-- Con un curso no programado.
SELECT * FROM CursoProgramado
GO
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 51,'A0002','20240531'
SELECT @RET
GO
-- con un curso que no tiene vacantes
SELECT * FROM CursoProgramado
GO
UPDATE CursoProgramado SET Vacantes=0, Matriculados=20 
WHERE IdCursoProg = 44
GO
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 44,'A0009','20240531'
SELECT @RET
GO
--Caso de un curso que se ha desactivado
SELECT * FROM CursoProgramado WHERE IdCursoProg = 43
GO
UPDATE CursoProgramado SET Activo=0 WHERE IdCursoProg = 43
GO
SELECT * FROM CursoProgramado WHERE IdCursoProg = 43
GO
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 43,'A0009','20240531'
SELECT @RET
GO
--********************************************
/* Crear un SP en Northwind, que permita ingresar un detalle de pedido 
 para probar debera crear un nuevo pedido(sin detalles)
luego verificar el SP para los detalles del nuevo pedido
-La existencia del producto y pedido
-Verificar el stock del producto que se va a vender. 
Debe ser mayor o igual que la cantidad que se desea vender
-Verificar si el producto esta continuado, 
si es contrario no se puede vender el producto 
-Si se cumplen las condiciones crear el detalle
-Actualizar la tabla de productos para el stock vendido*/ 
USE Northwind
GO

---Tarea
---   para la Clase 11