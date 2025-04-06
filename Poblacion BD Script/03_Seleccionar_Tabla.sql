USE CongresoDB;
GO

-- Ver los primeros artículos
SELECT * FROM ArticulosSimple;

-- Ver autores
SELECT * FROM Personas;

-- Ver revisores con tópicos
SELECT R.Rut, R.Nombre, R.Email, T.topico_especialidad
FROM Revisores R
JOIN Revisor_Topicos RT ON R.Rut = RT.Rut
JOIN TopicoEspecialidad T ON RT.ID_topico_especialidad = T.ID_topico_especialidad;

-- Consultar el Diccionario de Datos
SELECT * FROM DiccionarioDeDatos;