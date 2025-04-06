USE CongresoDB;
GO

-- Borrar los registros de la tabla intermedia y las tablas que dependen de ella
DELETE FROM Revisor_Topicos;
DELETE FROM ArticulosSimple;
DELETE FROM DiccionarioDeDatos;
DELETE FROM Revisores;
DELETE FROM Personas;
DELETE FROM TopicoEspecialidad;

-- Borrar las tablas
DROP TABLE IF EXISTS Revisor_Topicos;
DROP TABLE IF EXISTS ArticulosSimple;
DROP TABLE IF EXISTS DiccionarioDeDatos;
DROP TABLE IF EXISTS Revisores;
DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS TopicoEspecialidad;