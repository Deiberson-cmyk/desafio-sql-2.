-- ==========================================================
-- DESAFÍO PRÁCTICO 2 - PRÁCTICA AVANZADA DE SQL
-- SELECT, UPDATE, DELETE, WHERE Y MANEJO DE VISTAS (MySQL)
-- Instituto Universitario de Tecnología "Antonio José de Sucre"
-- Prof.: Julio Castillo
-- Escenario: Tienda de ropa en línea
-- ==========================================================
-- Nota: las fechas de prueba se generan con CURDATE() para que
-- los filtros de "últimos 30 días / último mes / último año"
-- devuelvan resultados sin importar el día en que se ejecute.
-- Para volver a ejecutar el script desde cero, descomente:
-- DROP DATABASE IF EXISTS tienda_ropa;
-- ==========================================================


-- ----------------------------------------------------------
-- 1. CREACIÓN DE LA BASE DE DATOS
-- ----------------------------------------------------------
CREATE DATABASE tienda_ropa CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE tienda_ropa;


-- ----------------------------------------------------------
-- 2. CREACIÓN DE TABLAS (con claves primarias y foráneas)
-- ----------------------------------------------------------
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(150),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(255),
    precio DECIMAL(10,2),
    categoria VARCHAR(50),
    stock INT
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE,
    estado VARCHAR(20),
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT,
    precio_venta DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


-- ----------------------------------------------------------
-- 3. INSERCIÓN DE REGISTROS
-- ----------------------------------------------------------
INSERT INTO clientes (id_cliente, nombre, apellido, direccion, correo_electronico, telefono) VALUES
(1, 'Carlos', 'Gómez', 'Av. Bolívar, Edif. Sol, Valencia', 'carlos.g@ejemplo.com', '0414-1234567'),
(2, 'María', 'Rodríguez', 'Calle 5, Urb. Los Pinos, Caracas', 'maria.r@ejemplo.com', '0424-7654321'),
(3, 'Pedro', 'Pérez', 'Av. Principal, Res. El Parque, Maracay', 'pedro.p@ejemplo.com', '0412-5555555'),
(4, 'Ana', 'López', 'Calle Mérida, Casa 12, Barquisimeto', 'ana.l@ejemplo.com', '0416-9999999'),
(5, 'Luis', 'Martínez', 'Av. Libertador, Torre Azul, Maracaibo', 'luis.m@ejemplo.com', '0414-3334444'),
(6, 'Laura', 'Fernández', 'Calle Sucre, Local 3, San Cristóbal', 'laura.f@ejemplo.com', '0426-1112222');

INSERT INTO productos (id_producto, nombre, descripcion, precio, categoria, stock) VALUES
(1, 'Camiseta Básica Blanca', 'Camiseta de algodón cuello redondo', 15.00, 'Camisetas', 100),
(2, 'Camiseta Estampada Negra', 'Camiseta con estampado gráfico', 20.00, 'Camisetas', 80),
(3, 'Camiseta Deportiva', 'Camiseta de secado rápido', 25.00, 'Camisetas', 60),
(4, 'Jean Clásico', 'Jean azul corte recto', 40.00, 'Pantalones', 50),
(5, 'Pantalón Cargo', 'Pantalón con bolsillos laterales', 45.00, 'Pantalones', 40),
(6, 'Chaqueta Casual', 'Chaqueta ligera de temporada', 80.00, 'Chaquetas', 30),
(7, 'Zapatillas Urbanas', 'Zapatillas de uso diario', 60.00, 'Calzado', 25);

-- Los pedidos 1009 y 1010 no tendrán ventas asociadas (se usarán en el DELETE)
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


-- ----------------------------------------------------------
-- 4. CONSULTAS AVANZADAS CON SELECT
-- ----------------------------------------------------------

-- Consulta 1: Nombre completo, dirección y correo de los clientes
-- que han realizado pedidos en los últimos 30 días
SELECT DISTINCT
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    c.direccion,
    c.correo_electronico
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 30 DAY;

-- Consulta 2: Productos con mayor cantidad de ventas en el último mes,
-- junto con el total vendido de cada uno (top 3)
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

-- Consulta 3: Clientes que han realizado más pedidos en el último año,
-- ordenados de mayor a menor cantidad de pedidos
SELECT
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 1 YEAR
GROUP BY c.id_cliente, c.nombre, c.apellido
ORDER BY total_pedidos DESC, nombre_completo ASC;


-- ----------------------------------------------------------
-- 5. ACTUALIZACIÓN CON UPDATE
-- ----------------------------------------------------------

-- Actualización 1: Aumentar 10% el precio de los productos de la
-- categoría "Camisetas"
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Camisetas';

-- Verificación
SELECT id_producto, nombre, categoria, precio FROM productos;


-- ----------------------------------------------------------
-- 6. ELIMINACIÓN CON DELETE
-- ----------------------------------------------------------

-- Eliminación 2: Eliminar los pedidos que no tengan ventas asociadas
DELETE FROM pedidos
WHERE id_pedido NOT IN (SELECT id_pedido FROM ventas);

-- Verificación
SELECT * FROM pedidos;


-- ----------------------------------------------------------
-- 7. CREACIÓN DE VISTAS
-- ----------------------------------------------------------

-- Vista 1: vista_clientes_pedidos
-- Muestra el nombre completo del cliente, la fecha y el total del pedido
CREATE VIEW vista_clientes_pedidos AS
SELECT
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    p.fecha AS fecha_pedido,
    p.total AS total_pedido
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- Consulta de la vista
SELECT * FROM vista_clientes_pedidos;
