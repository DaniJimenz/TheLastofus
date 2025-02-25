//CREACIÓN TABLAS

CREATE TABLE carrera 
(
    gpid VARCHAR2(4) CHECK (gpid LIKE 'GP__') PRIMARY KEY,
    gp VARCHAR2(30) UNIQUE NOT NULL,
    fecha DATE,
    ubicacion VARCHAR2(30)
);

CREATE TABLE piloto
(
    id NUMERIC(2) PRIMARY KEY,
    nombre VARCHAR2(30) UNIQUE NOT NULL,
    equipo VARCHAR2(30)
);

CREATE TABLE car_pos_piloto
(
    gpid VARCHAR2(4),
    pid NUMERIC(2),
    puntos NUMERIC(2),
    
    CONSTRAINT pk_car_pos_piloto PRIMARY KEY (gpid, pid),
    CONSTRAINT fk_gp_car_pos_piloto FOREIGN KEY (gpid) REFERENCES carrera(gpid),
    CONSTRAINT fk_pid_car_pos_piloto FOREIGN KEY (pid) REFERENCES piloto(id) 
);

INSERT INTO carrera VALUES ('GP01','Bahrein','02/03/2024','Sakhir');
INSERT INTO carrera VALUES ('GP02','Arabia Saudita','09/03/2024','Yeda');
INSERT INTO carrera VALUES ('GP03','Australia','24/03/2024','Melbourne');
INSERT INTO carrera VALUES ('GP04','Japón','07/04/2024','Suzuka');
INSERT INTO carrera VALUES ('GP05','China','21/04/2024','Shangai');

INSERT INTO piloto VALUES (1, 'Max Verstappen', 'Red Bull', 'NED');
INSERT INTO piloto VALUES (2, 'Sergio Perez', 'Red Bull', 'MEX');
INSERT INTO piloto VALUES (3, 'Lewis Hamilton', 'Mercedes', 'GBR');
INSERT INTO piloto VALUES (4, 'George Russell', 'Mercedes', 'GBR');
INSERT INTO piloto VALUES (5, 'Charles Leclerc', 'Ferrari', 'MON');
INSERT INTO piloto VALUES (6, 'Carlos Sainz', 'Ferrari', 'ESP');
INSERT INTO piloto VALUES (7, 'Lando Norris', 'McLaren', 'GBR');
INSERT INTO piloto VALUES (8, 'Oscar Piastri', 'McLaren', 'AUS');
INSERT INTO piloto VALUES (9, 'Fernando Alonso', 'Aston Martin', 'ESP');
INSERT INTO piloto VALUES (10, 'Lance Stroll', 'Aston Martin', 'CAN');

INSERT INTO car_pos_piloto VALUES ('GP01', 1, 25);
INSERT INTO car_pos_piloto VALUES ('GP01', 2, 18);
INSERT INTO car_pos_piloto VALUES ('GP01', 6, 15);
INSERT INTO car_pos_piloto VALUES ('GP02', 1, 25);
INSERT INTO car_pos_piloto VALUES ('GP02', 5, 18);
INSERT INTO car_pos_piloto VALUES ('GP02', 3, 15);
INSERT INTO car_pos_piloto VALUES ('GP03', 6, 25);
INSERT INTO car_pos_piloto VALUES ('GP03', 5, 18);
INSERT INTO car_pos_piloto VALUES ('GP03', 1, 15);
INSERT INTO car_pos_piloto VALUES ('GP04', 1, 25);
INSERT INTO car_pos_piloto VALUES ('GP04', 6, 18);
INSERT INTO car_pos_piloto VALUES ('GP04', 4, 15);
INSERT INTO car_pos_piloto VALUES ('GP05', 1, 25);
INSERT INTO car_pos_piloto VALUES ('GP05', 7, 18);
INSERT INTO car_pos_piloto VALUES ('GP05', 9, 15);


ALTER TABLE carrera MODIFY fecha DATE CHECK (fecha BETWEEN '29-02-2024' AND '08-12-2024'); 


ALTER TABLE piloto ADD nacionalidad VARCHAR2(3);

//Consultas 

//2
SELECT SUM(puntos)
FROM car_pos_piloto
JOIN piloto ON id = pid
WHERE nacionalidad = 'ESP';

//3
UPDATE car_pos_piloto
SET puntos = 19
WHERE pid = (
    SELECT id
    FROM piloto
    WHERE nombre LIKE 'Charles Leclerc')
    AND gpid = (
        SELECT gpid
        FROM carrera 
        WHERE gp LIKE 'Arabia Saudita');

//4
SELECT equipo, AVG(puntos)
FROM piloto
JOIN car_pos_piloto ON pid = id
GROUP BY equipo;

//5
SELECT DISTINCT equipo
FROM piloto
JOIN car_pos_piloto cl ON pid = id
WHERE puntos = 25 AND equipo IN(
    SELECT equipo
    FROM piloto
    JOIN car_pos_piloto ON pid = id
    WHERE puntos = 1 AND gpid = cl.gpid);

//6
SELECT nombre 
FROM piloto
JOIN car_pos_piloto ON pid = id
GROUP BY nombre 
HAVING COUNT (DISTINCT gpid) = (
SELECT COUNT (DISTINCT gpid)
FROM car_pos_piloto);

//7
SELECT nombre 
FROM piloto 
JOIN car_pos_piloto ON pid = id
GROUP BY nombre
HAVING COUNT (DISTINCT puntos) = 3;

//8
SELECT nombre 
FROM piloto 
WHERE id IN (
    SELECT pid 
    FROM car_pos_piloto
    WHERE puntos = 25
    GROUP BY pid
    HAVING COUNT (*) = 1);

//9
SELECT nombre, equipo, id
FROM piloto 
JOIN car_pos_piloto ON pid = id 
GROUP BY nombre, equipo
HAVING SUM (puntos) >= ALL (SELECT SUM(puntos) FROM car_pos_piloto GROUP BY pid)
ON SUM (puntos) <= ALL (SELECT SUM (puntos) FROM car_pos_piloto GROUP BY pid);

//10


//11
SELECT nombre 
FROM piloto 
JOIN car_pos_piloto ON pid = id
WHERE gpid = 'GP01'
INTERSECT
SELECT nombre 
FROM piloto 
JOIN car_pos_piloto ON pid = id
WHERE gpid = 'GP02'
INTERSECT
SELECT nombre 
FROM piloto 
JOIN car_pos_piloto ON pid = id
WHERE gpid = 'GP03'
INTERSECT
SELECT nombre 
FROM piloto 
JOIN car_pos_piloto ON pid = id
WHERE gpid = 'GP04'
INTERSECT
SELECT nombre 
FROM piloto 
JOIN car_pos_piloto ON pid = id
WHERE gpid = 'GP05'

//12
ALTER TABLE carrera RENAME COLUMN gp to nombre;
ALTER TABLE carrera MODIFY nombre VARCHAR2(30) CHECK (nombre LIKE 'Gran premio de%');







