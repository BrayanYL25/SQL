USE EDUTEC2

EXEC sp_helpindex alumno
GO

Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno) Values('A0040','Yin Lin Mesias','Brayan')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno) Values('A0035','Santivanez Celis','Lorena')



CREATE CLUSTERED INDEX PKALUMNO ON ALUMNO (IDALUMNO)	-- No asegura la unicidad de los datos, no puede haber dos indices fisicos en la misma tabla
DROP INDEX Alumno.PKAlUMNO

SELECT * FROM Alumno

CREATE UNIQUE CLUSTERED INDEX PKALUMNO ON ALUMNO(IDALUMNO) -- NO CREO UN PRIMARY KEY

EXEC sp_helpconstraint ALUMNO

ALTER TABLE ALUMNO ADD PRIMARY KEY (IDALUMNO) -- CREA UN INDICE LOGICO

--limite de registro: 8kb

--FILL FACTOR: es lento

SELECT * FROM SYSINDEXES

SELECT NAME, OrigFillFactor FROM SYSINDEXES
WHERE NAME = 'PKALUMNO'


CREATE UNIQUE CLUSTERED INDEX PKALUMNO ON ALUMNO(IDALUMNO)
	WITH DROP_EXISTING,
	FILLFACTOR = 90
GO