USE CongresoDB;
GO

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
	Rut INT PRIMARY KEY
	FOREIGN KEY (Rut) REFERENCES Personas (Rut)
);

CREATE TABLE Participantes (
	contacto NVARCHAR(50)
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
    FOREIGN KEY (ID_Topico_Especialidad) REFERENCES TopicoEspecialidad(ID_topico_especialidad),
);

CREATE TABLE DiccionarioDeDatos (
    Tabla VARCHAR(100),
    Columna VARCHAR(100),
    TipoDato VARCHAR(50),
    Descripcion TEXT,
    PermiteNULL VARCHAR(5),
    Clave VARCHAR(50)
);

-- 2. Insertar t�picos
INSERT INTO TopicoEspecialidad VALUES
(1, 'IA'), (2, 'Big Data'), (3, 'Ciberseguridad'), (4, 'Redes'), (5, 'Software'),
(6, 'Embebidos'), (7, 'Gr�fica'), (8, 'BD'), (9, 'Blockchain'), (10, 'Rob�tica'),
(11, 'RA'), (12, 'IoT'), (13, 'ML'), (14, 'Cu�ntica'), (15, 'Bioinfo'),
(16, 'Lenguajes'), (17, 'Conocimiento'), (18, 'Distribuidos'), (19, 'DevOps'), (20, 'Algoritmos');

-- 3. Generar personas y revisores
DECLARE @nombres TABLE (Nombre VARCHAR(50));
INSERT INTO @nombres VALUES 
('Camila'), ('Sebasti�n'), ('Valentina'), ('Mat�as'), ('Javiera'), ('Felipe'),
('Antonia'), ('Diego'), ('Fernanda'), ('Crist�bal'), ('Josefa'), ('Benjam�n'),
('Martina'), ('Vicente'), ('Isidora'), ('Ignacio'), ('Florencia'), ('Tom�s'),
('Catalina'), ('Francisco'), ('Amanda'), ('Gaspar'), ('Emilia'), ('Agust�n'),
('Trinidad'), ('Joaqu�n'), ('Paula'), ('Lucas'), ('Daniela'), ('Andr�s'),
('Renata'), ('Maximiliano'), ('Pablo'), ('Mar�a'), ('Gabriel'),
('Daniel'), ('Ana'), ('Ra�l'), ('Elena'), ('Leonardo'), ('Teresa'),
('Pedro'), ('Soledad'), ('Lautaro'), ('Carla'), ('H�ctor'), ('Tamara'),
('Alonso'), ('Patricia');

DECLARE @nombres_art TABLE (Nombre_art VARCHAR(50));
INSERT INTO @nombres_art VALUES
('Optimizaci�n de redes IoT'),
('Orquestaci�n de microservicios'),
('Ontolog�as para datos m�dicos'),
('Predicci�n de fallas con ML'),
('An�lisis de sentimiento en Twitter'),
('Visi�n artificial para frutas'),
('Ciberseguridad en hogares inteligentes'),
('Clasificaci�n de texto con BERT'),
('Diagn�stico m�dico con CNN'),
('Blockchain para log�stica'),
('Interfaces accesibles en apps'),
('Simulaci�n de tr�fico urbano'),
('DevOps en proyectos acad�micos'),
('Estudio de algoritmos gen�ticos'),
('Visualizaci�n de datos cient�ficos'),
('Chatbots educativos en aulas'),
('Lenguajes para IA comparados'),
('Reconocimiento facial con OpenCV'),
('Rob�tica colaborativa en f�bricas'),
('Compresi�n de im�genes m�dicas'),
('Sistemas embebidos en dom�tica'),
('Algoritmos para cifrado cu�ntico'),
('An�lisis de patrones de consumo'),
('Asistentes virtuales con NLP'),
('Bases de datos NoSQL para e-commerce'),
('RA en videojuegos educativos'),
('Clasificaci�n de malware'),
('Redes vehiculares inteligentes'),
('Modelado 3D a partir de im�genes'),
('Miner�a de datos en educaci�n');

DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    DECLARE @nombre VARCHAR(50)
    SELECT TOP 1 @nombre = Nombre FROM @nombres ORDER BY NEWID();

    DECLARE @rut INT = 12000000 + ABS(CHECKSUM(NEWID())) % 10000000;
    DECLARE @email VARCHAR(80) = LOWER(@nombre) + CAST(@rut AS VARCHAR) + '@correo.com';

    INSERT INTO Personas VALUES (@rut, @nombre, @email);
	iF @i < 50

	BEGIN
		INSERT INTO Autores VALUES(@rut)
	END

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

-- 4. Insertar art�culos
DECLARE @artID INT = 1;
DECLARE @titulo NVARCHAR(255)
WHILE @artID <= 400
BEGIN
	SELECT TOP 1 @titulo = Nombre_art FROM @nombres_art ORDER BY NEWID();
    DECLARE @fecha DATE = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
    DECLARE @resumen NVARCHAR(MAX) = CONCAT('Resumen del art�culo ', @artID);
    DECLARE @topico1 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topico2 NVARCHAR(50) = (SELECT TOP 1 topico_especialidad FROM TopicoEspecialidad ORDER BY NEWID());
    DECLARE @topicos NVARCHAR(255) = 
        CASE WHEN @artID % 3 = 0 THEN @topico1 + ', ' + @topico2 ELSE @topico1 END;

	-- Elegir RUTs desde la tabla Autores
	DECLARE @rutAutor1 INT = (SELECT TOP 1 Rut FROM Autores ORDER BY NEWID());
	DECLARE @rutAutor2 INT = (SELECT TOP 1 Rut FROM Autores WHERE Rut != @rutAutor1 ORDER BY NEWID());
	DECLARE @rutAutor3 INT = (SELECT TOP 1 Rut FROM Autores WHERE Rut NOT IN (@rutAutor1, @rutAutor2) ORDER BY NEWID());

	-- Obtener los datos de cada autor desde Personas
	DECLARE @autor1 NVARCHAR(100) = (SELECT Nombre + ' <' + Email + '>' FROM Personas WHERE Rut = @rutAutor1);
	DECLARE @autor2 NVARCHAR(100) = (SELECT Nombre + ' <' + Email + '>' FROM Personas WHERE Rut = @rutAutor2);
	DECLARE @autor3 NVARCHAR(100) = (SELECT Nombre + ' <' + Email + '>' FROM Personas WHERE Rut = @rutAutor3);

	-- Definir autores combinados con l�gica aleatoria
	DECLARE @autores NVARCHAR(255) = 
    CASE 
        WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN @autor1 + ', ' + @autor2 + ', ' + @autor3
        WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN @autor1 + ', ' + @autor2
        ELSE @autor1 
    END;


    DECLARE @idTopicoPrincipal INT = 1 + ABS(CHECKSUM(NEWID())) % 20;

    INSERT INTO ArticulosSimple 
    (ID_Art, Titulo, FechaEnvio, Resumen, Topicos, ID_Topico_Especialidad, Autores)
    VALUES 
    (@artID, @titulo, @fecha, @resumen, @topicos, @idTopicoPrincipal, @autores);

    SET @artID += 1;
END;

-- 5. Diccionario de datos
INSERT INTO DiccionarioDeDatos (Tabla, Columna, TipoDato, Descripcion, PermiteNULL, Clave) VALUES
('Personas', 'Rut', 'INT', 'Identificador �nico', 'NO', 'PK'),
('Personas', 'Nombre', 'VARCHAR(50)', 'Nombre completo', 'NO', ''),
('Personas', 'Email', 'VARCHAR(80)', 'Correo electr�nico', 'NO', ''),
('Revisores', 'Rut', 'INT', 'Identificador revisor', 'NO', 'PK/FK'),
('Revisor_Topicos', 'Rut', 'INT', 'Identificador revisor', 'NO', 'FK'),
('Revisor_Topicos', 'ID_topico_especialidad', 'INT', 'Especialidad', 'NO', 'FK'),
('TopicoEspecialidad', 'ID_topico_especialidad', 'INT', 'ID del t�pico', 'NO', 'PK'),
('TopicoEspecialidad', 'topico_especialidad', 'VARCHAR(50)', 'Nombre del t�pico', 'NO', ''),
('ArticulosSimple', 'ID_Art', 'INT', 'ID del art�culo', 'NO', 'PK'),
('ArticulosSimple', 'Titulo', 'NVARCHAR(255)', 'T�tulo del art�culo', 'NO', ''),
('ArticulosSimple', 'FechaEnvio', 'DATE', 'Fecha de env�o', 'NO', ''),
('ArticulosSimple', 'Resumen', 'NVARCHAR(MAX)', 'Resumen del art�culo', 'NO', ''),
('ArticulosSimple', 'Topicos', 'NVARCHAR(255)', 'T�picos del art�culo', 'NO', ''),
('ArticulosSimple', 'ID_Topico_Especialidad', 'INT', 'T�pico principal', 'NO', 'FK'),
('ArticulosSimple', 'Autores', 'NVARCHAR(255)', 'Autores del art�culo', 'NO', '');
