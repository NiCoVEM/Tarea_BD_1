CREATE TABLE TopicoEspecialidad (
    ID_topico_especialidad INT PRIMARY KEY,
    topico_especialidad VARCHAR(50)
);

CREATE TABLE Personas (
    Rut CHAR(10) PRIMARY KEY,
    Nombre VARCHAR(50),
    Email VARCHAR(80)
);

CREATE TABLE Revisores (
    Rut CHAR(10) PRIMARY KEY,
    Nombre VARCHAR(50),
    Email VARCHAR(80),
    ID_topico_especialidad INT,
    FOREIGN KEY (ID_topico_especialidad) REFERENCES TopicoEspecialidad(ID_topico_especialidad)
);

CREATE TABLE ArticulosSimple (
    ID_Art INT PRIMARY KEY,
    Titulo NVARCHAR(255),
    FechaEnvio DATE,
    Resumen NVARCHAR(MAX),
    Topicos NVARCHAR(255),
    ID_Topico_Especialidad INT,
    Autores NVARCHAR(255),
    FOREIGN KEY (ID_Topico_Especialidad) REFERENCES TopicoEspecialidad(ID_topico_especialidad)
);


INSERT INTO TopicoEspecialidad (ID_topico_especialidad, topico_especialidad)
VALUES 
(1, 'Inteligencia Artificial'),
(2, 'Big Data'),
(3, 'Ciberseguridad'),
(4, 'Redes'),
(5, 'Ingeniería de Software'),
(6, 'Sistemas Embebidos'),
(7, 'Computación Gráfica'),
(8, 'Bases de Datos'),
(9, 'Blockchain'),
(10, 'Robótica'),
(11, 'Realidad Aumentada'),
(12, 'Internet de las Cosas'),
(13, 'Machine Learning'),
(14, 'Computación Cuántica'),
(15, 'Bioinformática'),
(16, 'Lenguajes de Programación'),
(17, 'Ingeniería del Conocimiento'),
(18, 'Sistemas Distribuidos'),
(19, 'DevOps'),
(20, 'Algoritmos');

-- ========================
-- 3. Insertar Personas (Autores 1 a 50)
-- ========================
DECLARE @i INT = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO Personas (Rut, Nombre, Email)
    VALUES (
        RIGHT('00000000' + CAST(@i AS VARCHAR), 8) + '-K',
        CONCAT('Autor_', @i),
        CONCAT('autor', @i, '@correo.com')
    );
    SET @i = @i + 1;
END;

-- ========================
-- 4. Insertar Revisores (Personas 51 a 100)
-- ========================
SET @i = 51;
WHILE @i <= 100
BEGIN
    DECLARE @rut CHAR(10) = RIGHT('00000000' + CAST(@i AS VARCHAR), 8) + '-K';
    DECLARE @nombre VARCHAR(50) = CONCAT('Revisor_', @i);
    DECLARE @email VARCHAR(80) = CONCAT('revisor', @i, '@correo.com');
    DECLARE @idTopico INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

    -- Insertar como persona
    INSERT INTO Personas (Rut, Nombre, Email)
    VALUES (@rut, @nombre, @email);

    -- Insertar como revisor
    INSERT INTO Revisores (Rut, Nombre, Email, ID_topico_especialidad)
    VALUES (@rut, @nombre, @email, @idTopico);

    SET @i = @i + 1;
END;

-- ========================
-- 5. Insertar Artículos Simples (400 registros)
-- ========================
DECLARE @artID INT = 1;
WHILE @artID <= 400
BEGIN
    DECLARE @titulo NVARCHAR(255) = CONCAT('Artículo_', @artID);
    DECLARE @fecha DATE = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
    DECLARE @resumen NVARCHAR(MAX) = CONCAT('Este es el resumen del artículo número ', @artID);

    -- Seleccionar 1 a 2 tópicos aleatorios
    DECLARE @topico1 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topico2 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topicos NVARCHAR(255) = 
        CASE WHEN @artID % 3 = 0 THEN CONCAT(@topico1, ', ', @topico2) ELSE @topico1 END;

    -- Seleccionar 1 a 2 autores aleatorios
    DECLARE @autor1 NVARCHAR(100) = (SELECT TOP 1 Nombre + ' <' + Email + '>' FROM Personas WHERE Rut BETWEEN '00000001-K' AND '00000050-K' ORDER BY NEWID());
    DECLARE @autor2 NVARCHAR(100) = (SELECT TOP 1 Nombre + ' <' + Email + '>' FROM Personas WHERE Rut BETWEEN '00000001-K' AND '00000050-K' ORDER BY NEWID());
    DECLARE @autores NVARCHAR(255) = 
        CASE WHEN @artID % 4 = 0 THEN CONCAT(@autor1, ', ', @autor2) ELSE @autor1 END;

    -- Asignar un ID de tópico principal
    DECLARE @idTopicoPrincipal INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

    -- Insertar artículo
    INSERT INTO ArticulosSimple (ID_Art, Titulo, FechaEnvio, Resumen, Topicos, ID_Topico_Especialidad, Autores)
    VALUES (
        @artID,
        @titulo,
        @fecha,
        @resumen,
        @topicos,
        @idTopicoPrincipal,
        @autores
    );

    SET @artID = @artID + 1;
END;
