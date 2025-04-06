SELECT TOP 10 * FROM ArticulosSimple;

SELECT * FROM Personas WHERE Rut BETWEEN '00000001-K' AND '00000050-K';

SELECT R.*, T.topico_especialidad
FROM Revisores R
JOIN TopicoEspecialidad T ON R.ID_topico_especialidad = T.ID_topico_especialidad;

SELECT * FROM TopicoEspecialidad;
