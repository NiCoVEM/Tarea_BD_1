USE CongresoDB;
GO

SET NOCOUNT ON;

-- 1. Crear tablas
IF OBJECT_ID('Revisor_Topicos', 'U') IS NOT NULL DROP TABLE Revisor_Topicos;
IF OBJECT_ID('ArticulosSimple', 'U') IS NOT NULL DROP TABLE ArticulosSimple;
IF OBJECT_ID('Revisores', 'U') IS NOT NULL DROP TABLE Revisores;
IF OBJECT_ID('Personas', 'U') IS NOT NULL DROP TABLE Personas;
IF OBJECT_ID('TopicoEspecialidad', 'U') IS NOT NULL DROP TABLE TopicoEspecialidad;
IF OBJECT_ID('DiccionarioDeDatos', 'U') IS NOT NULL DROP TABLE DiccionarioDeDatos;

CREATE TABLE TopicoEspecialidad (
    ID_topico_especialidad INT PRIMARY KEY,
    topico_especialidad VARCHAR(50)
);

CREATE TABLE Personas (
    Rut INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Email VARCHAR(80)
);

CREATE TABLE Revisores (
    Rut INT PRIMARY KEY,
    FOREIGN KEY (Rut) REFERENCES Personas(Rut)
);

CREATE TABLE Revisor_Topicos (
    Rut INT,
    ID_topico_especialidad INT,
    PRIMARY KEY (Rut, ID_topico_especialidad),
    FOREIGN KEY (Rut) REFERENCES Revisores(Rut),
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

CREATE TABLE DiccionarioDeDatos (
    Tabla VARCHAR(100),
    Columna VARCHAR(100),
    TipoDato VARCHAR(50),
    Descripcion TEXT,
    PermiteNULL VARCHAR(5),
    Clave VARCHAR(50)
);

-- 2. Insertar tópicos
INSERT INTO TopicoEspecialidad VALUES
(1, 'IA'), (2, 'Big Data'), (3, 'Ciberseguridad'), (4, 'Redes'), (5, 'Software'),
(6, 'Embebidos'), (7, 'Gráfica'), (8, 'BD'), (9, 'Blockchain'), (10, 'Robótica'),
(11, 'RA'), (12, 'IoT'), (13, 'ML'), (14, 'Cuántica'), (15, 'Bioinfo'),
(16, 'Lenguajes'), (17, 'Conocimiento'), (18, 'Distribuidos'), (19, 'DevOps'), (20, 'Algoritmos');

-- 3. Generar personas y revisores
DECLARE @nombres TABLE (Nombre VARCHAR(50));
INSERT INTO @nombres VALUES 
('Camila'), ('Sebastián'), ('Valentina'), ('Matías'), ('Javiera'), ('Felipe'),
('Antonia'), ('Diego'), ('Fernanda'), ('Cristóbal'), ('Josefa'), ('Benjamín'),
('Martina'), ('Vicente'), ('Isidora'), ('Ignacio'), ('Florencia'), ('Tomás'),
('Catalina'), ('Francisco'), ('Amanda'), ('Gaspar'), ('Emilia'), ('Agustín'),
('Trinidad'), ('Joaquín'), ('Paula'), ('Lucas'), ('Daniela'), ('Andrés'),
('Renata'), ('Maximiliano'), ('Pablo'), ('María'), ('Gabriel'),
('Daniel'), ('Ana'), ('Raúl'), ('Elena'), ('Leonardo'), ('Teresa'),
('Pedro'), ('Soledad'), ('Lautaro'), ('Carla'), ('Héctor'), ('Tamara'),
('Alonso'), ('Patricia');

DECLARE @rutBase INT = 10000000;
DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    DECLARE @nombre VARCHAR(50)
    SELECT TOP 1 @nombre = Nombre FROM @nombres ORDER BY NEWID();

    DECLARE @rut INT = @rutBase + @i;
    DECLARE @email VARCHAR(80) = LOWER(@nombre) + CAST(@rut AS VARCHAR) + '@correo.com';

    INSERT INTO Personas VALUES (@rut, @nombre, @email);

    IF @i > 50
    BEGIN
        INSERT INTO Revisores VALUES (@rut);

        DECLARE @numTopicos INT = 1 + ABS(CHECKSUM(NEWID())) % 3;
        DECLARE @j INT = 0;

        WHILE @j < @numTopicos
        BEGIN
            DECLARE @topicoID INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

            IF NOT EXISTS (
                SELECT 1 FROM Revisor_Topicos WHERE Rut = @rut AND ID_topico_especialidad = @topicoID
            )
            BEGIN
                INSERT INTO Revisor_Topicos VALUES (@rut, @topicoID);
                SET @j += 1;
            END
        END
    END
    SET @i += 1;
END

-- 4. Insertar artículos
DECLARE @artID INT = 1;
WHILE @artID <= 400
BEGIN
    DECLARE @titulo NVARCHAR(255) = CONCAT('Artículo_', @artID);
    DECLARE @fecha DATE = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
    DECLARE @resumen NVARCHAR(MAX) = CONCAT('Resumen del artículo ', @artID);
    DECLARE @topico1 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topico2 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topicos NVARCHAR(255) = 
        CASE WHEN @artID % 3 = 0 THEN @topico1 + ', ' + @topico2 ELSE @topico1 END;

    DECLARE @autor1 NVARCHAR(100) = (
        SELECT TOP 1 Nombre + ' <' + Email + '>' FROM Personas 
        WHERE Rut NOT IN (SELECT Rut FROM Revisores) ORDER BY NEWID()
    );
    DECLARE @autor2 NVARCHAR(100) = (
        SELECT TOP 1 Nombre + ' <' + Email + '>' FROM Personas 
        WHERE Rut NOT IN (SELECT Rut FROM Revisores) ORDER BY NEWID()
    );
    DECLARE @autores NVARCHAR(255) = 
        CASE WHEN @artID % 4 = 0 THEN @autor1 + ', ' + @autor2 ELSE @autor1 END;

    DECLARE @idTopicoPrincipal INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

    INSERT INTO ArticulosSimple 
    (ID_Art, Titulo, FechaEnvio, Resumen, Topicos, ID_Topico_Especialidad, Autores)
    VALUES 
    (@artID, @titulo, @fecha, @resumen, @topicos, @idTopicoPrincipal, @autores);

    SET @artID += 1;
END;

-- 5. Diccionario de datos
INSERT INTO DiccionarioDeDatos (Tabla, Columna, TipoDato, Descripcion, PermiteNULL, Clave) VALUES
('Personas', 'Rut', 'INT', 'Identificador único', 'NO', 'PK'),
('Personas', 'Nombre', 'VARCHAR(50)', 'Nombre completo', 'NO', ''),
('Personas', 'Email', 'VARCHAR(80)', 'Correo electrónico', 'NO', ''),
('Revisores', 'Rut', 'INT', 'Identificador revisor', 'NO', 'PK/FK'),
('Revisor_Topicos', 'Rut', 'INT', 'Identificador revisor', 'NO', 'FK'),
('Revisor_Topicos', 'ID_topico_especialidad', 'INT', 'Especialidad', 'NO', 'FK'),
('TopicoEspecialidad', 'ID_topico_especialidad', 'INT', 'ID del tópico', 'NO', 'PK'),
('TopicoEspecialidad', 'topico_especialidad', 'VARCHAR(50)', 'Nombre del tópico', 'NO', ''),
('ArticulosSimple', 'ID_Art', 'INT', 'ID del artículo', 'NO', 'PK'),
('ArticulosSimple', 'Titulo', 'NVARCHAR(255)', 'Título del artículo', 'NO', ''),
('ArticulosSimple', 'FechaEnvio', 'DATE', 'Fecha de envío', 'NO', ''),
('ArticulosSimple', 'Resumen', 'NVARCHAR(MAX)', 'Resumen del artículo', 'NO', ''),
('ArticulosSimple', 'Topicos', 'NVARCHAR(255)', 'Tópicos del artículo', 'NO', ''),
('ArticulosSimple', 'ID_Topico_Especialidad', 'INT', 'Tópico principal', 'NO', 'FK'),
('ArticulosSimple', 'Autores', 'NVARCHAR(255)', 'Autores del artículo', 'NO', '');
