USE CongresoDB;
GO

SELECT Titulo, Resumen 
FROM ArticulosSimple
WHERE Titulo LIKE 'O%'

SELECT * FROM Autores;
SELECT TOP 5 Rut, Nombre, Email FROM Personas WHERE Rut IN (SELECT Rut FROM Autores);