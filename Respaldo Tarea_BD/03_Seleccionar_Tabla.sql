USE CongresoDB;
GO

	-- Ver los primeros artículos
SELECT * FROM ArticulosSimple;

-- Ver autores
SELECT * FROM Personas;

-- Ver revisores con tópicos
SELECT R.Rut, P.Nombre, P.Email, T.topico_especialidad
FROM Revisores R
JOIN Personas P ON R.Rut = P.Rut
JOIN Revisor_Topicos RT ON R.Rut = RT.Rut
JOIN TopicoEspecialidad T ON RT.ID_topico_especialidad = T.ID_topico_especialidad;

-- Consultar el Diccionario de Datos
SELECT * FROM DiccionarioDeDatos;
SELECT * FROM Autores;
SELECT Titulo, Resumen 
FROM ArticulosSimple
WHERE Titulo LIKE 'O%'

SELECT * FROM Autores;
SELECT TOP 5 Rut, Nombre, Email FROM Personas WHERE Rut IN (SELECT Rut FROM Autores);