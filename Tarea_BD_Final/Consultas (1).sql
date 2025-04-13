USE CongresoDB;
GO


--1. Obtener los nombres y resúmenes de todos los artículos que comiencen con la letra O .
SELECT Titulo, Resumen 
FROM ArticulosSimple
WHERE Titulo LIKE 'O%'


--2. Obtener la cantidad de artículos enviados por cada autor

SELECT 
    p.Nombre,
    p.Email,
    COUNT(pa.ID_Art) AS Cantidad_Articulos
FROM 
    Participantes pa
JOIN 
    Personas p ON pa.contacto = p.Email
GROUP BY 
    p.Nombre, p.Email
ORDER BY 
    Cantidad_Articulos DESC;


--3. Obtener los títulos de los artículos que tienen más de un tópico asignado


SELECT a.Titulo
FROM ArticulosSimple a
JOIN Articulo_Topico at ON a.ID_Art = at.ID_Art
GROUP BY a.ID_Art, a.Titulo
HAVING COUNT(at.ID_topico_especialidad) > 1;


--4. Mostrar el título del artículo y toda la información acerca del autor de contacto para todos los artículos que contengan la palabra Software en el título

SELECT DISTINCT
    A.Titulo,
    P.Rut,
    P.Nombre,
    P.Email
FROM ArticulosSimple A
JOIN Personas P ON A.contacto = P.Email
WHERE A.Titulo LIKE '%Software%';

--5. Obtener el nombre y la cantidad de artículos asignados a cada revisor

SELECT 
    P.Nombre AS NombreRevisor,
    COUNT(A.ID_Art) AS CantidadArticulos
FROM 
    Revisores R
JOIN 
    Personas P ON R.Rut = P.Rut
JOIN 
    Revisor_Topicos RT ON R.Rut = RT.Rut
JOIN 
    ArticulosSimple A ON A.ID_Topico_Especialidad = RT.ID_topico_especialidad
GROUP BY 
    P.Nombre
ORDER BY 
    CantidadArticulos DESC;

--6. Obtener los nombres de los revisores que tienen asignados más de 3 artículos

SELECT 
    P.Nombre
FROM 
    Revisores R
JOIN 
    Personas P ON R.Rut = P.Rut
JOIN 
    Revisor_Topicos RT ON R.Rut = RT.Rut
JOIN 
    ArticulosSimple A ON A.ID_Topico_Especialidad = RT.ID_topico_especialidad
GROUP BY 
    P.Nombre
HAVING 
    COUNT(A.ID_Art) > 3;

--7. Obtener los títulos de los artículos y el nombre de los revisores asignados, pero solo para aquellos artículos que tengan la palabra Gestión en el título

SELECT DISTINCT
    A.Titulo AS Titulo_Articulo,
    P.Nombre AS Nombre_Revisor
FROM ArticulosSimple A
JOIN TopicoEspecialidad T ON A.ID_Topico_Especialidad = T.ID_topico_especialidad
JOIN Revisor_Topicos RT ON T.ID_topico_especialidad = RT.ID_topico_especialidad
JOIN Revisores R ON RT.Rut = R.Rut
JOIN Personas P ON R.Rut = P.Rut
WHERE A.Titulo LIKE N'%Gestión%';

--8. Obtener la cantidad de revisores que son especialistas en cada tópico (Ej: Bases de datos 5, Análisis de Sistemas: 3, Estadística: 8)

SELECT 
    T.topico_especialidad AS Topico,
    COUNT(RT.Rut) AS Cantidad_Revisores
FROM TopicoEspecialidad T
LEFT JOIN Revisor_Topicos RT ON T.ID_topico_especialidad = RT.ID_topico_especialidad
GROUP BY T.topico_especialidad
ORDER BY Cantidad_Revisores DESC;

--9. Obtener el Top 10 artículos mas antiguos ingresados en la BD

SELECT TOP 10 
    ID_Art,
    Titulo,
    FechaEnvio
FROM ArticulosSimple
ORDER BY FechaEnvio ASC;

--10. Obtener los nombres de los artículos, cuyos revisores (cada uno) participa en la revisión de 3 o más artículos

SELECT a.Titulo 
FROM ArticulosSimple a
WHERE NOT EXISTS (
    SELECT 1
    FROM RevisionArticulos r
    WHERE r.ID_Art = a.ID_Art
      AND (
        SELECT COUNT(*) 
        FROM RevisionArticulos r2 
        WHERE r2.Rut_Revisor = r.Rut_Revisor
      ) < 3
)
