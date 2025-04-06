USE CongresoDB;
GO

-- =============================================
-- 1. CREACI�N DE TABLAS
-- =============================================

-- Crear la tabla de T�picos de Especialidad
CREATE TABLE TopicoEspecialidad (
    ID_topico_especialidad INT PRIMARY KEY,
    topico_especialidad VARCHAR(50)
);

-- Crear la tabla de Personas (Autores y Revisores)
CREATE TABLE Personas (
    Rut INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Email VARCHAR(80)
);

-- Crear la tabla de Revisores
CREATE TABLE Revisores (
    Rut INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Email VARCHAR(80)
);

-- Crear la tabla intermedia para asociar Revisores con T�picos de Especialidad
CREATE TABLE Revisor_Topicos (
    Rut INT,
    ID_topico_especialidad INT,
    PRIMARY KEY (Rut, ID_topico_especialidad),
    FOREIGN KEY (Rut) REFERENCES Revisores(Rut),
    FOREIGN KEY (ID_topico_especialidad) REFERENCES TopicoEspecialidad(ID_topico_especialidad)
);

-- Crear la tabla de Art�culos
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

-- Crear la tabla Diccionario de Datos
CREATE TABLE DiccionarioDeDatos (
    Tabla VARCHAR(100),
    Columna VARCHAR(100),
    TipoDato VARCHAR(50),
    Descripcion TEXT,
    PermiteNULL VARCHAR(5),
    Clave VARCHAR(50)
);

-- =============================================
-- 2. INSERTAR T�PICOS DE ESPECIALIDAD
-- =============================================
INSERT INTO TopicoEspecialidad (ID_topico_especialidad, topico_especialidad)
VALUES 
(1, 'Inteligencia Artificial'), (2, 'Big Data'), (3, 'Ciberseguridad'), (4, 'Redes'),
(5, 'Ingenier�a de Software'), (6, 'Sistemas Embebidos'), (7, 'Computaci�n Gr�fica'),
(8, 'Bases de Datos'), (9, 'Blockchain'), (10, 'Rob�tica'), (11, 'Realidad Aumentada'),
(12, 'Internet de las Cosas'), (13, 'Machine Learning'), (14, 'Computaci�n Cu�ntica'),
(15, 'Bioinform�tica'), (16, 'Lenguajes de Programaci�n'), (17, 'Ingenier�a del Conocimiento'),
(18, 'Sistemas Distribuidos'), (19, 'DevOps'), (20, 'Algoritmos');

-- =============================================
-- 3. PERSONAS Y REVISORES CON RUTS RANDOM
-- =============================================
CREATE TABLE #RutsUsados (Rut INT PRIMARY KEY);

DECLARE @nombres TABLE (Nombre VARCHAR(50));
INSERT INTO @nombres VALUES 
('Camila'), ('Sebasti�n'), ('Valentina'), ('Mat�as'), ('Javiera'), ('Felipe'),
('Antonia'), ('Diego'), ('Fernanda'), ('Crist�bal'), ('Josefa'), ('Benjam�n'),
('Martina'), ('Vicente'), ('Isidora'), ('Ignacio'), ('Florencia'), ('Tom�s'),
('Catalina'), ('Francisco'), ('Amanda'), ('Gaspar'), ('Emilia'), ('Agust�n'),
('Trinidad'), ('Joaqu�n'), ('Paula'), ('Lucas'), ('Daniela'), ('Andr�s'),
('Renata'), ('Maximiliano'), ('Jose'), ('Pablo'), ('Mar�a'), ('Gabriel'),
('Daniel'), ('Ana'), ('Ra�l'), ('Elena'), ('Leonardo'), ('Teresa'),
('Pedro'), ('Soledad'), ('Lautaro'), ('Carla'), ('H�ctor'), ('Tamara'),
('Alonso'), ('Patricia');

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    DECLARE @rut INT;
    DECLARE @existe INT = 1;

    WHILE @existe = 1
    BEGIN
        SET @rut = 8000000 + ABS(CHECKSUM(NEWID())) % 13000000;
        SET @existe = (SELECT COUNT(*) FROM #RutsUsados WHERE Rut = @rut);
    END

    INSERT INTO #RutsUsados VALUES (@rut);

    DECLARE @nombre VARCHAR(50);
    SELECT TOP 1 @nombre = Nombre FROM @nombres ORDER BY NEWID();

    DECLARE @email VARCHAR(80) = LOWER(@nombre) + CAST(@rut AS VARCHAR) + '@correo.com';

    INSERT INTO Personas (Rut, Nombre, Email)
    VALUES (@rut, @nombre, @email);

    IF @i > 50
    BEGIN
        INSERT INTO Revisores (Rut, Nombre, Email)
        VALUES (@rut, @nombre, @email);

        DECLARE @numTopicos INT = 1 + ABS(CHECKSUM(NEWID())) % 3;
        DECLARE @j INT = 1;
        DECLARE @topicosUsados TABLE (ID_topico_especialidad INT);

        WHILE @j <= @numTopicos
        BEGIN
            DECLARE @idTopico INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

            IF NOT EXISTS (SELECT 1 FROM @topicosUsados WHERE ID_topico_especialidad = @idTopico)
            BEGIN
                INSERT INTO @topicosUsados VALUES (@idTopico);
                INSERT INTO Revisor_Topicos (Rut, ID_topico_especialidad)
                VALUES (@rut, @idTopico);
                SET @j += 1;
            END
        END
    END

    SET @i += 1;
END

DROP TABLE #RutsUsados;

-- =============================================
-- 4. ART�CULOS (400)
-- =============================================
DECLARE @artID INT = 1;
WHILE @artID <= 400
BEGIN
    DECLARE @titulo NVARCHAR(255) = CONCAT('Art�culo_', @artID);
    DECLARE @fecha DATE = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
    DECLARE @resumen NVARCHAR(MAX) = CONCAT('Este es el resumen del art�culo n�mero ', @artID);

    DECLARE @topico1 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topico2 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topicos NVARCHAR(255) = 
        CASE WHEN @artID % 3 = 0 THEN CONCAT(@topico1, ', ', @topico2) ELSE @topico1 END;

    DECLARE @autor1 NVARCHAR(100) = (
        SELECT TOP 1 Nombre + ' <' + Email + '>' 
        FROM Personas 
        WHERE Rut NOT IN (SELECT Rut FROM Revisores) 
        ORDER BY NEWID()
    );
    DECLARE @autor2 NVARCHAR(100) = (
        SELECT TOP 1 Nombre + ' <' + Email + '>' 
        FROM Personas 
        WHERE Rut NOT IN (SELECT Rut FROM Revisores) 
        ORDER BY NEWID()
    );
    DECLARE @autores NVARCHAR(255) = 
        CASE WHEN @artID % 4 = 0 THEN CONCAT(@autor1, ', ', @autor2) ELSE @autor1 END;

    DECLARE @idTopicoPrincipal INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

    INSERT INTO ArticulosSimple (ID_Art, Titulo, FechaEnvio, Resumen, Topicos, ID_Topico_Especialidad, Autores)
    VALUES (
        @artID, @titulo, @fecha, @resumen, @topicos, @idTopicoPrincipal, @autores
    );

    SET @artID += 1;
END;

-- =============================================
-- 5. DICCIONARIO DE DATOS
-- =============================================
INSERT INTO DiccionarioDeDatos (Tabla, Columna, TipoDato, Descripcion, PermiteNULL, Clave)
VALUES
('Personas', 'Rut', 'INT', 'N�mero de identificaci�n �nico de la persona.', 'NO', 'PK'),
('Personas', 'Nombre', 'VARCHAR(50)', 'Nombre de la persona (Autor o Revisor).', 'NO', ''),
('Personas', 'Email', 'VARCHAR(80)', 'Direcci�n de correo electr�nico de la persona.', 'NO', ''),
('ArticulosSimple', 'ID_Art', 'INT', 'Identificador �nico del art�culo.', 'NO', 'PK'),
('ArticulosSimple', 'Titulo', 'NVARCHAR(255)', 'T�tulo del art�culo.', 'NO', ''),
('ArticulosSimple', 'FechaEnvio', 'DATE', 'Fecha de env�o del art�culo.', 'NO', ''),
('ArticulosSimple', 'Resumen', 'NVARCHAR(MAX)', 'Resumen del art�culo.', 'NO', ''),
('ArticulosSimple', 'Topicos', 'NVARCHAR(255)', 'Lista de t�picos asociados con el art�culo.', 'NO', ''),
('ArticulosSimple', 'ID_Topico_Especialidad', 'INT', 'Identificador del t�pico especializado.', 'NO', 'FK'),
('ArticulosSimple', 'Autores', 'NVARCHAR(255)', 'Listado de autores con nombre y correo.', 'NO', ''),
('Revisores', 'Rut', 'INT', 'N�mero de identificaci�n �nico del revisor.', 'NO', 'PK'),
('Revisores', 'Nombre', 'VARCHAR(50)', 'Nombre del revisor.', 'NO', ''),
('Revisores', 'Email', 'VARCHAR(80)', 'Correo electr�nico del revisor.', 'NO', ''),
('Revisor_Topicos', 'Rut', 'INT', 'Rut del revisor relacionado con un t�pico.', 'NO', 'FK'),
('Revisor_Topicos', 'ID_topico_especialidad', 'INT', 'T�pico de especialidad del revisor.', 'NO', 'FK');
