create schema minimarket_eperez;

use minimarket_eperez;
-- -----------------------------------------------------
-- ---------- Tabla de proveedores ---------------------
-- -----------------------------------------------------
CREATE TABLE proveedores (
  id_proveedor INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  razon_social VARCHAR(50) NOT NULL,
  rut VARCHAR(10) NOT NULL,
  nombre_representante VARCHAR(45),
  email VARCHAR(60) 
  
  );
  
-- -----------------------------------------------------
-- ---------- Tabla de categorias ---------------------
-- ----------------------------------------------------- 
CREATE TABLE categorias (
  id_categoria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL
  );

-- -----------------------------------------------------------
--  Tabla de relacion entre Proveedores - Categorias  
--     Un proveedor puede esta en muchas categorías
--     Una categoría puede tener muchos proveedores
-- -----------------------------------------------------------

CREATE TABLE proveedores_categorias(
	id_proveedorCategoria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_proveedor INT,
	id_categoria INT,
    
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
	FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) 
);

-- -----------------------------------------------------
-- ---------- Tabla de clientes ---------------------
-- -----------------------------------------------------
CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NULL,
  apellido VARCHAR(40) NULL,
  telefono VARCHAR(15) NULL
  
  );
  
-- -----------------------------------------------------
-- ---------- Tabla de productos ---------------------
-- -----------------------------------------------------
 CREATE TABLE productos (
  id_producto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NULL,
  precio_proveedor DOUBLE NULL,
  precio_venta DOUBLE NULL,
  stock INT NULL
  
  );
  
  -- -----------------------------------------------------
-- ---------- Tabla de detalles de ventas ---------------------
-- -----------------------------------------------------
  CREATE TABLE detalle_venta (
  id_detalle_venta INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  fecha_creacion DATETIME,
  cantidad_prducto INT,
  total DOUBLE
  
  );
-- ---------------------------------------------------------------------------------------
-- -----  Creamos la relacion entre tablas con las Foreing Key -------
-- -----------------------------------------------------------------------------------------
--       Foreing key en la tabla productos/categorias 

ALTER TABLE productos ADD fk_id_categoria INTEGER;  
ALTER TABLE productos ADD FOREIGN KEY (fk_id_categoria) REFERENCES categorias(id_categoria);

-- ------------------------------------------------------------------------------------------
--       Foreing key en la tabla detalle_venta/clientes 

ALTER TABLE detalle_venta ADD fk_id_cliente INTEGER;  
ALTER TABLE detalle_venta ADD FOREIGN KEY (fk_id_cliente) REFERENCES clientes(id_cliente);

-- -------------------------------------------------------------------------------------------
--       Foreing key en la tabla detalle_venta/productos

ALTER TABLE detalle_venta ADD fk_id_producto INTEGER;  
ALTER TABLE detalle_venta ADD FOREIGN KEY (fk_id_producto) REFERENCES productos(id_producto);

-- -------------------------------------------------------------------------------------------
-- -------------      AGREGAMOS 3 CLIENTE en la tabla clientes                   -----------
-- -------------------------------------------------------------------------------------------

INSERT INTO clientes (nombre, apellido, telefono) values 
("Brandon", "López", +56949874253),
("Elvis", "Pérez", +56949874743),
("Maria", "Loyo", +56912374253);

SELECT * FROM clientes; -- Consulta para verificar que se agregaron los Clientes

-- ---------------------------------------------------------------------
-- --------- AGREGAMOS 3 PROVEEDORES en la tabla proveedores -----------
-- ---------------------------------------------------------------------
INSERT INTO proveedores (razon_social, rut, nombre_representante, email) values 
("GENERATION SPA", "77478965", "Jesus P", "jesusp@brandomspa.cl"),
("PAMELA LTDA", "77478123", "Pamela", "pamela@pamelaltda.cl"),
("ALEJANDRO SPA", "77474565", "Ale Heredia", "alejandro@aleherediaspa.cl");

SELECT * FROM proveedores; -- Consulta para verificar que se agregaron los Proveedores
-- --------------------------------------------------------------------------------------
-- --------- AGREGAMOS 4 CATEGORIAS(Tipo de Productos) en la tabla categorias -----------
-- --------------------------------------------------------------------------------------
INSERT INTO categorias (nombre) values 
("HIGIENE PERSONAL Y ASEO"),
("BEBIDAS"),
("GOLOSINAS"),
("ALIMENTOS EMPAQUETADOS");

SELECT * FROM categorias; -- Consulta para verificar que se agregaron los categoria

-- --------------------------------------------------------------------------------------
-- --------- AGREGAMOS la relación entre categorias y proveedores             -----------
-- --------------------------------------------------------------------------------------
INSERT INTO proveedores_categorias(id_proveedor, id_categoria) values 
("1","1"),
("1","2"),
("2","4"),
("3","3"),
("3","2");

SELECT * FROM proveedores_categorias;
-- ------------------------------------------------------------------------------------------
-- --------- AGREGAMOS 7 PRODUCTOS en la tabla productos --------------------------------------
-- ------------------------------------------------------------------------------------------
INSERT INTO productos(nombre, precio_proveedor, precio_venta, stock, fk_id_categoria) VALUES 
("Pasta",750,1000,10,4),
("Arroz",850,1100,10,4),
("Azúcar",600,900,10,4),
("Desodorante",2000,3000,10,1),
("Refresco",1100,1800,10,2),
("Galletas",300,600,10,3),
("Caramelos",100,300,10,3);

SELECT * FROM productos;
SELECT * FROM productos INNER JOIN categorias ON productos.fk_id_categoria = categorias.id_categoria;

-- -----------------------------------------------------------------------------------
-- --------- AGREGAMOS 4 detalles de ventas en la tabla detalle_venta -----------------
-- para el datatime:   YYYY-MM-DD HH:MM:SS    |  '2023-03-15 12:30:00' ----------------
INSERT INTO detalle_venta(fecha_creacion, cantidad_prducto, total, fk_id_cliente, fk_id_producto) values 
("2022-03-15", "2","2200", "1","2"),
("2022-12-15", "3","3000", "2","1"),
("2023-03-15", "3","2400", "3","4"),
("2023-04-20", "1","1000", "2","3");

UPDATE detalle_venta SET total = '9000' WHERE id_detalle_venta = "3";
UPDATE detalle_venta SET total = '900' WHERE id_detalle_venta = "4";
SELECT * FROM detalle_venta;

-- --------------------------------------------------------------------------------------
-- --------------------- CONSULTAS PARA CALCULOS ----------------------------------------
-- ---------------------------------------------------------------------------------------

SELECT detalle_venta.id_detalle_venta, detalle_venta.fecha_creacion, detalle_venta.cantidad_prducto, productos.nombre, productos.precio_venta, detalle_venta.total 
FROM detalle_venta INNER JOIN productos ON detalle_venta.fk_id_producto = productos.id_producto;

-- ---------------- QUERY para calcular el TOTAL DE las ventas de todos los AÑOS ----------------------
SELECT SUM(total) AS VentasTotales FROM detalle_venta;

-- ------------   Query para mostrar LAS VENTAS y GANANCIA por VENTA en el AÑO 2022     -------------------------------
SELECT detalle_venta.id_detalle_venta, detalle_venta.fecha_creacion, productos.nombre, detalle_venta.cantidad_prducto, productos.precio_venta, detalle_venta.total
FROM detalle_venta INNER JOIN productos ON detalle_venta.fk_id_producto = productos.id_producto 
WHERE fecha_creacion BETWEEN "2022-01-01" AND "2022-12-31";

-- ---------------- QUERY para calcular el TOTAL DE las ventas del AÑO 2022 ----------------------
SELECT SUM(total) AS Ventas_2022 FROM detalle_venta WHERE fecha_creacion BETWEEN "2022-01-01" AND "2022-12-31";

-- ------------   Query para mostrar LAS VENTAS y GANANCIA por VENTA en el AÑO 2023     -------------------------------
SELECT detalle_venta.id_detalle_venta, detalle_venta.fecha_creacion, productos.nombre, detalle_venta.cantidad_prducto, productos.precio_venta, detalle_venta.total
FROM detalle_venta INNER JOIN productos ON detalle_venta.fk_id_producto = productos.id_producto 
WHERE fecha_creacion BETWEEN "2023-01-01" AND "2023-12-31";

-- ---------------- QUERY para calcular el TOTAL DE las ventas del AÑO 2023 ----------------------
SELECT SUM(total) AS Ventas_2023 FROM detalle_venta WHERE fecha_creacion BETWEEN "2023-01-01" AND "2023-12-31";
