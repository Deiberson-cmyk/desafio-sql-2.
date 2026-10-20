/*==========================================================
  DESAFÍO PRÁCTICO 2 - PRÁCTICA AVANZADA DE SQL:
  SELECT, UPDATE, DELETE, WHERE Y MANEJO DE VISTAS MYSQL
  INSTITUTO UNIVERSITARIO DE TECNOLOGÍA "ANTONIO JOSÉ DE SUCRE"
  DOCENTE: PROF. BEATRIZ CAMPOS
  ESCENARIO: TIENDA DE ROPA EN LÍNEA
==========================================================*/

/*VERIFICAMOS SI LA BASE DE DATOS YA EXISTE Y SI ES ASÍ LA BORRAMOS PARA VOLVERLA A CREAR*/
DROP DATABASE IF EXISTS tienda_ropa;

/*CREAMOS LA BASE DE DATOS*/
CREATE DATABASE tienda_ropa CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

/*UNA VEZ CREADA LA ACTIVAMOS PARA USARLA*/
USE tienda_ropa;


/*==========================================================
  CREACIÓN DE TABLAS (DDL)
  CREAMOS INICIALMENTE LAS TABLAS PRINCIPALES, ES DECIR,
  LAS QUE NO CONTIENEN CLAVES FORÁNEAS
==========================================================*/

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(150),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS productos (
    id_producto INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(255),
    precio DECIMAL(10,2),
    categoria VARCHAR(50),
    stock INT
) ENGINE=InnoDB;


/*LUEGO CREAMOS LAS TABLAS QUE CONTIENEN CLAVES FORÁNEAS
  TENIENDO EN CUENTA QUE LAS TABLAS A LAS QUE SE HACE REFERENCIA DEBEN EXISTIR*/

CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT NOT NULL PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE,
    estado VARCHAR(20),
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ventas (
    id_venta INT NOT NULL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT,
    precio_venta DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;


/*==========================================================
  INSERCIÓN DE REGISTROS EN LAS TABLAS (DML)
==========================================================*/

/*INSERTAMOS LOS REGISTROS EN LA TABLA CLIENTES*/
INSERT INTO clientes (id_cliente, nombre, apellido, direccion, correo_electronico, telefono) VALUES
(1, 'Carlos', 'Gómez', 'Av. Bolívar, Edif. Sol, Valencia', 'carlos.g@ejemplo.com', '0414-1234567'),
(2, 'María', 'Rodríguez', 'Calle 5, Urb. Los Pinos, Caracas', 'maria.r@ejemplo.com', '0424-7654321'),
(3, 'Pedro', 'Pérez', 'Av. Principal, Res. El Parque, Maracay', 'pedro.p@ejemplo.com', '0412-5555555'),
(4, 'Ana', 'López', 'Calle Mérida, Casa 12, Barquisimeto', 'ana.l@ejemplo.com', '0416-9999999'),
(5, 'Luis', 'Martínez', 'Av. Libertador, Torre Azul, Maracaibo', 'luis.m@ejemplo.com', '0414-3334444'),
(6, 'Laura', 'Fernández', 'Calle Sucre, Local 3, San Cristóbal', 'laura.f@ejemplo.com', '0426-1112222');

/*INSERTAMOS LOS REGISTROS EN LA TABLA PRODUCTOS*/
INSERT INTO productos (id_producto, nombre, descripcion, precio, categoria, stock) VALUES
(1, 'Camiseta Básica Blanca', 'Camiseta de algodón cuello redondo', 15.00, 'Camisetas', 100),
(2, 'Camiseta Estampada Negra', 'Camiseta con estampado gráfico', 20.00, 'Camisetas', 80),
(3, 'Camiseta Deportiva', 'Camiseta de secado rápido', 25.00, 'Camisetas', 60),
(4, 'Jean Clásico', 'Jean azul corte recto', 40.00, 'Pantalones', 50),
(5, 'Pantalón Cargo', 'Pantalón con bolsillos laterales', 45.00, 'Pantalones', 40),
(6, 'Chaqueta Casual', 'Chaqueta ligera de temporada', 80.00, 'Chaquetas', 30),
(7, 'Zapatillas Urbanas', 'Zapatillas de uso diario', 60.00, 'Calzado', 25);

/*INSERTAMOS LOS REGISTROS EN LA TABLA PEDIDOS
  (LOS PEDIDOS 1009 Y 1010 NO TIENEN VENTAS ASOCIADAS PARA DEMOSTRAR EL DELETE)*/
INSERT INTO pedidos (id_pedido, id_cliente, fecha, estado, total) VALUES
(1001, 1, CURDATE() - INTERVAL 5 DAY,   'Entregado', 70.00),
(1002, 2, CURDATE() - INTERVAL 12 DAY,  'Entregado', 75.00),
(1003, 1, CURDATE() - INTERVAL 20 DAY,  'Entregado', 130.00),
(1004, 3, CURDATE() - INTERVAL 25 DAY,  'Enviado',   100.00),
(1005, 4, CURDATE() - INTERVAL 45 DAY,  'Entregado', 90.00),
(1006, 1, CURDATE() - INTERVAL 90 DAY,  'Entregado', 60.00),
(1007, 2, CURDATE() - INTERVAL 200 DAY, 'Entregado', 40.00),
(1008, 5, CURDATE() - INTERVAL 400 DAY, 'Entregado', 80.00),
(1009, 3, CURDATE() - INTERVAL 8 DAY,   'Pendiente', 50.00),
(1010, 4, CURDATE() - INTERVAL 3 DAY,   'Cancelado', 35.00);

/*INSERTAMOS LOS REGISTROS EN LA TABLA VENTAS*/
INSERT INTO ventas (id_venta, id_pedido, id_producto, cantidad, precio_venta) VALUES
(1,  1001, 1, 2, 15.00),
(2,  1001, 4, 1, 40.00),
(3,  1002, 2, 3, 20.00),
(4,  1002, 1, 1, 15.00),
(5,  1003, 3, 2, 25.00),
(6,  1003, 6, 1, 80.00),
(7,  1004, 2, 2, 20.00),
(8,  1004, 7, 1, 60.00),
(9,  1005, 5, 2, 45.00),
(10, 1006, 1, 4, 15.00),
(11, 1007, 4, 1, 40.00),
(12, 1008, 6, 1, 80.00);


/*==========================================================
  a) CONSULTAS AVANZADAS CON SELECT
==========================================================*/

/*CONSULTA 1: OBTENER EL NOMBRE COMPLETO, DIRECCIÓN Y CORREO ELECTRÓNICO
  DE TODOS LOS CLIENTES QUE HAN REALIZADO PEDIDOS EN LOS ÚLTIMOS 30 DÍAS*/
SELECT DISTINCT
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    c.direccion,
    c.correo_electronico
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 30 DAY;

/*CONSULTA 2: MOSTRAR LOS PRODUCTOS CON MAYOR CANTIDAD DE VENTAS EN EL ÚLTIMO MES,
  JUNTO CON EL TOTAL VENDIDO DE CADA UNO*/
SELECT
    pr.nombre AS producto,
    SUM(v.cantidad) AS cantidad_vendida,
    SUM(v.cantidad * v.precio_venta) AS total_vendido
FROM ventas v
INNER JOIN productos pr ON v.id_producto = pr.id_producto
INNER JOIN pedidos p ON v.id_pedido = p.id_pedido
WHERE p.fecha >= CURDATE() - INTERVAL 1 MONTH
GROUP BY pr.id_producto, pr.nombre
ORDER BY cantidad_vendida DESC
LIMIT 3;

/*CONSULTA 3: LISTAR LOS CLIENTES QUE HAN REALIZADO MÁS PEDIDOS EN EL ÚLTIMO AÑO,
  ORDENADOS POR MAYOR CANTIDAD DE PEDIDOS*/
SELECT
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 1 YEAR
GROUP BY c.id_cliente, c.nombre, c.apellido
ORDER BY total_pedidos DESC, nombre_completo ASC;


/*==========================================================
  b) ACTUALIZACIONES CON UPDATE
==========================================================*/

/*ACTUALIZACIÓN 1: AUMENTAR EL PRECIO DE TODOS LOS PRODUCTOS
  DE LA CATEGORÍA "CAMISETAS" EN UN 10%*/
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Camisetas';

/*VERIFICAMOS LA ACTUALIZACIÓN DE PRECIOS*/
SELECT id_producto, nombre, categoria, precio FROM productos;


/*==========================================================
  c) ELIMINACIONES CON DELETE
==========================================================*/

/*ELIMINACIÓN 2: ELIMINAR LOS PEDIDOS QUE NO TENGAN VENTAS ASOCIADAS*/
DELETE FROM pedidos
WHERE id_pedido NOT IN (SELECT id_pedido FROM ventas);

/*VERIFICAMOS LA ELIMINACIÓN DE LOS PEDIDOS SIN VENTAS*/
SELECT * FROM pedidos;


/*==========================================================
  d) CREACIÓN Y USO DE VISTAS
==========================================================*/

/*VISTA 1: CREAR UNA VISTA LLAMADA "vista_clientes_pedidos" QUE MUESTRE
  EL NOMBRE COMPLETO DEL CLIENTE, LA FECHA DEL PEDIDO Y EL TOTAL DEL PEDIDO*/
CREATE OR REPLACE VIEW vista_clientes_pedidos AS
SELECT
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    p.fecha AS fecha_pedido,
    p.total AS total_pedido
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente;

/*UTILIZAMOS LA VISTA SELECCIONANDO TODOS SUS DATOS*/
SELECT * FROM vista_clientes_pedidos;

/*SI SE DESEA BORRAR LA VISTA SE UTILIZA: DROP VIEW vista_clientes_pedidos;*/
