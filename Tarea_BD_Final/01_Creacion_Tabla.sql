USE CongresoDB;
GO

DROP TABLE IF EXISTS Revisor_Topicos;
DROP TABLE IF EXISTS Articulo_Topico;
DROP TABLE IF EXISTS ArticulosSimple;
DROP TABLE IF EXISTS DiccionarioDeDatos;
DROP TABLE IF EXISTS Revisores;
DROP TABLE IF EXISTS Autores;
DROP TABLE IF EXISTS Participantes;
DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS TopicoEspecialidad;
DROP TABLE IF EXISTS RevisionArticulos;

-- 1. Crear tablas
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

CREATE TABLE Autores (
    Rut INT PRIMARY KEY,
    FOREIGN KEY (Rut) REFERENCES Personas (Rut)
);

CREATE TABLE ArticulosSimple (
    ID_Art INT PRIMARY KEY,
    Titulo NVARCHAR(255),
    FechaEnvio DATE,
    Resumen NVARCHAR(MAX),
    Topicos NVARCHAR(255),
    ID_Topico_Especialidad INT,
    contacto NVARCHAR(255),
    FOREIGN KEY (ID_Topico_Especialidad) REFERENCES TopicoEspecialidad(ID_topico_especialidad)
);

CREATE TABLE RevisionArticulos (
    ID_Art INT,
    Rut_Revisor INT,
    PRIMARY KEY (ID_Art, Rut_Revisor),
    FOREIGN KEY (ID_Art) REFERENCES ArticulosSimple(ID_Art),
    FOREIGN KEY (Rut_Revisor) REFERENCES Revisores(Rut)
);


--uno a muchos

CREATE TABLE Articulo_Topico (
    ID_Art INT,
    ID_topico_especialidad INT,
    PRIMARY KEY (ID_Art, ID_topico_especialidad),
    FOREIGN KEY (ID_Art) REFERENCES ArticulosSimple(ID_Art),
    FOREIGN KEY (ID_topico_especialidad) REFERENCES TopicoEspecialidad(ID_topico_especialidad)
);

CREATE TABLE Participantes (
    ID_Art INT,
    contacto NVARCHAR(255),
    FOREIGN KEY (ID_Art) REFERENCES ArticulosSimple(ID_Art)
);

CREATE TABLE Revisor_Topicos (
    Rut INT,
    ID_topico_especialidad INT,
    PRIMARY KEY (Rut, ID_topico_especialidad),
    FOREIGN KEY (Rut) REFERENCES Revisores(Rut),
    FOREIGN KEY (ID_topico_especialidad) REFERENCES TopicoEspecialidad(ID_topico_especialidad)
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

-- 3. Generar personas, autores y revisores
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

DECLARE @nombres_art TABLE (Nombre_art VARCHAR(50));
INSERT INTO @nombres_art VALUES
('Optimización de redes IoT'),
('Orquestación de microservicios'),
('Ontologías para datos médicos'),
('Predicción de fallas con ML'),
('Gestión de Proyectos Ágiles'),
('Patrones de diseño en Software Educativo'),
('Ciberseguridad en hogares inteligentes'),
('Clasificación de texto con BERT'),
('Gestión de Recursos en la Nube'),
('Blockchain para logística'),
('Interfaces accesibles en apps'),
('Técnicas de Gestión del Conocimiento'),
('DevOps en proyectos académicos'),
('Estudio de algoritmos genéticos'),
('Visualización de datos científicos'),
('Chatbots educativos en aulas'),
('Lenguajes para IA comparados'),
('Reconocimiento facial con OpenCV'),
('Robótica colaborativa en fábricas'),
('Compresión de imágenes médicas'),
('Sistemas embebidos en domótica'),
('Algoritmos para cifrado cuántico'),
('Análisis de patrones de consumo'),
('Asistentes virtuales con NLP'),
('Bases de datos NoSQL para e-commerce'),
('RA en videojuegos educativos'),
('Clasificación de malware'),
('Redes vehiculares inteligentes'),
('Modelado 3D a partir de imágenes'),
('Ingeniería de Software Ágil');

DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    DECLARE @nombre VARCHAR(50)
    SELECT TOP 1 @nombre = Nombre FROM @nombres ORDER BY NEWID();

    DECLARE @rut INT = 12000000 + ABS(CHECKSUM(NEWID())) % 10000000;
    DECLARE @email VARCHAR(80) = LOWER(@nombre) + CAST(@rut AS VARCHAR) + '@correo.com';

    INSERT INTO Personas VALUES (@rut, @nombre, @email);

    IF @i < 50
    BEGIN
        INSERT INTO Autores VALUES (@rut);
    END
    ELSE
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

-- 4. Generar artículos y relacionarlos con tópicos y autores
DECLARE @artID INT = 1;
DECLARE @titulo NVARCHAR(255);

WHILE @artID <= 400
BEGIN
    SELECT TOP 1 @titulo = Nombre_art FROM @nombres_art ORDER BY NEWID();
    DECLARE @fecha DATE = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
    DECLARE @resumen NVARCHAR(MAX) = CONCAT('Resumen del artículo ', @artID);
    DECLARE @topico1 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topico2 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topicos NVARCHAR(255) = 
        CASE WHEN @artID % 3 = 0 THEN @topico1 + ', ' + @topico2 ELSE @topico1 END;

    DECLARE @rutAutor1 INT = (SELECT TOP 1 Rut FROM Autores ORDER BY NEWID());
    DECLARE @autor1 NVARCHAR(255) = (SELECT Email FROM Personas WHERE Rut = @rutAutor1);

    DECLARE @idTopicoPrincipal INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

    INSERT INTO ArticulosSimple 
    (ID_Art, Titulo, FechaEnvio, Resumen, Topicos, ID_Topico_Especialidad, contacto)
    VALUES 
    (@artID, @titulo, @fecha, @resumen, @topicos, @idTopicoPrincipal, @autor1);

    INSERT INTO Participantes (ID_Art, contacto) VALUES (@artID, @autor1);

    DECLARE @numAutores INT = 1 + ABS(CHECKSUM(NEWID())) % 3;

    IF @numAutores >= 2
    BEGIN
        DECLARE @rutAutor2 INT = (SELECT TOP 1 Rut FROM Autores WHERE Rut != @rutAutor1 ORDER BY NEWID());
        DECLARE @autor2 NVARCHAR(255) = (SELECT Email FROM Personas WHERE Rut = @rutAutor2);
        INSERT INTO Participantes (ID_Art, contacto) VALUES (@artID, @autor2);
    END

    IF @numAutores = 3
    BEGIN
        DECLARE @rutAutor3 INT = (
            SELECT TOP 1 Rut FROM Autores 
            WHERE Rut NOT IN (@rutAutor1, @rutAutor2) ORDER BY NEWID()
        );
        DECLARE @autor3 NVARCHAR(255) = (SELECT Email FROM Personas WHERE Rut = @rutAutor3);
        INSERT INTO Participantes (ID_Art, contacto) VALUES (@artID, @autor3);
    END

    -- Insertar en Articulo_Topico
    DECLARE @topicoID1 INT = (SELECT ID_topico_especialidad FROM TopicoEspecialidad WHERE topico_especialidad = @topico1);
    INSERT INTO Articulo_Topico (ID_Art, ID_topico_especialidad) VALUES (@artID, @topicoID1);

    IF @artID % 3 = 0
    BEGIN
        DECLARE @topicoID2 INT = (SELECT ID_topico_especialidad FROM TopicoEspecialidad WHERE topico_especialidad = @topico2);
        IF @topicoID2 != @topicoID1
            INSERT INTO Articulo_Topico (ID_Art, ID_topico_especialidad) VALUES (@artID, @topicoID2);
    END

    SET @artID += 1;
END

DECLARE @revArtID INT = 1;
-- Ya NO declares @j de nuevo
DECLARE @numRevisores INT;
DECLARE @rutRevisor INT;

WHILE @revArtID <= 400
BEGIN
    SET @numRevisores = 1 + ABS(CHECKSUM(NEWID())) % 3;
    SET @j = 0;

    WHILE @j < @numRevisores
    BEGIN
        SELECT TOP 1 @rutRevisor = Rut FROM Revisores ORDER BY NEWID();

        IF NOT EXISTS (
            SELECT 1 FROM RevisionArticulos 
            WHERE ID_Art = @revArtID AND Rut_Revisor = @rutRevisor
        )
        BEGIN
            INSERT INTO RevisionArticulos (ID_Art, Rut_Revisor) 
            VALUES (@revArtID, @rutRevisor);
            SET @j += 1;
        END
    END

    SET @revArtID += 1;
END

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
