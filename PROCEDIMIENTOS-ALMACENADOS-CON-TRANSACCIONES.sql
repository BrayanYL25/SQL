/*	PROCEDIMIENTOS ALMACENADOS CON TRANSACCIONES */
    --****************************************************************
   USE EduTec
   GO
   
   SP_help MATRICULA
   GO
   
   /*   Desarrollar un SP 
   que permita matricular a un Alumno en la 
     BD EduTec. 
	Se debe verificar 
	si existen vacantes y 
	si el curso esta activo, 
	adem�s se debe incrementar el numero de matriculados 
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
SP_HELP CURSOPROGRAMADO
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
EXEC @RET = spu_MatriculaAlumno 9,'A0010','20240611'
SELECT @RET
GO
-- Verificando si el Alumno esta matriculado
SELECT * FROM MATRICULA WHERE IDALUMNO='A0010'
SELECT * FROM CURSOPROGRAMADO WHERE IDCURSOPROG = 9
SELECT * FROM MATRICULA WHERE IDCURSOPROG = 9
GO
-- Con un Alumno no registrado.
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 9,'B0002','20240611'
SELECT @RET
GO
-- Con un curso no programado.
SELECT * FROM CursoProgramado
GO
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 51,'A0002','20240611'
SELECT @RET
GO
-- con un curso que no tiene vacantes
SELECT * FROM CursoProgramado
GO
UPDATE CursoProgramado SET Vacantes=0, Matriculados=20 
WHERE IdCursoProg = 44
GO
DECLARE @RET INT
EXEC @RET = spu_MatriculaAlumno 44,'A0009','20240611'
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
EXEC @RET = spu_MatriculaAlumno 43,'A0009','20240611'
SELECT @RET
GO