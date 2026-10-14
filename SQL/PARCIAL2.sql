create database if not exists drogueria_bd;
use drogueria_bd;

create table if not exists laboratorios (
id_laboratorio int auto_increment primary key,
nombre_lab varchar(50) not null,
telefono varchar(20)
);

create table if not exists clientes (
id_cliente int auto_increment primary key,
cedula varchar(15) unique not null,
nombre_cliente varchar(80) not null,
telefono varchar(20)
);

create table if not exists medicamentos (
id_medicamento int auto_increment primary key,
nombre_med varchar(80) not null,
precio_unitario decimal(10, 2) not null,
stock int not null,
id_laboratorio int not null,
foreign key (id_laboratorio) references laboratorios(id_laboratorio)
);

create table if not exists ventas (
id_venta int auto_increment primary key,
fecha_venta date not null,
id_cliente int not null,
id_medicamento int not null,
cantidad int not null,
total_venta decimal(10, 2) not null,
foreign key (id_cliente) references clientes(id_cliente),
foreign key (id_medicamento) references medicamentos(id_medicamento)
);


-- =====================================================================
-- 2. procedimientos almacenados (inserción y consultas)
-- =====================================================================
delimiter //

create procedure laboratorios_proce(
in p_nombre_lab varchar(50),
in p_telefono varchar(20)
)
begin
insert into laboratorios (nombre_lab, telefono)
values (p_nombre_lab, p_telefono);
end //

create procedure clientes_proce(
in p_cedula varchar(15),
in p_nombre_cliente varchar(80),
in p_telefono varchar(20)
)
begin
insert into clientes (cedula, nombre_cliente, telefono)
values (p_cedula, p_nombre_cliente, p_telefono);
end //

create procedure medicamentos_proce(
in p_nombre_med varchar(80),
in p_precio_unitario decimal(10,2),
in p_stock int,
in p_id_laboratorio int
)
begin
insert into medicamentos (nombre_med, precio_unitario, stock, id_laboratorio)
values (p_nombre_med, p_precio_unitario, p_stock, p_id_laboratorio);
end //

create procedure ventas_proce(
in p_fecha_venta date,
in p_id_cliente int,
in p_id_medicamento int,
in p_cantidad int,
in p_total_venta decimal(10,2)
)
begin
insert into ventas (fecha_venta, id_cliente, id_medicamento, cantidad, total_venta)
values (p_fecha_venta, p_id_cliente, p_id_medicamento, p_cantidad, p_total_venta);
end //

create procedure consultar_ventas_detalladas()
begin
select 
v.id_venta,
v.fecha_venta,
c.nombre_cliente,
c.cedula,
m.nombre_med,
l.nombre_lab,
v.cantidad,
m.precio_unitario,
v.total_venta
from ventas v
inner join clientes c on v.id_cliente = c.id_cliente
inner join medicamentos m on v.id_medicamento = m.id_medicamento
inner join laboratorios l on m.id_laboratorio = l.id_laboratorio
order by v.fecha_venta desc;
end //

create procedure consultar_total_compras_por_cliente()
begin
select 
c.id_cliente,
c.cedula,
c.nombre_cliente,
count(v.id_venta) as total_transacciones,
sum(v.total_venta) as total_gastado
from clientes c
left join ventas v on c.id_cliente = v.id_cliente
group by c.id_cliente, c.cedula, c.nombre_cliente
order by total_gastado desc;
end //

create procedure consultar_medicamentos_mas_vendidos()
begin
select 
m.id_medicamento,
m.nombre_med,
l.nombre_lab,
sum(v.cantidad) as total_unidades_vendidas,
sum(v.total_venta) as total_recaudado
from ventas v
inner join medicamentos m on v.id_medicamento = m.id_medicamento
inner join laboratorios l on m.id_laboratorio = l.id_laboratorio
group by m.id_medicamento, m.nombre_med, l.nombre_lab
order by total_unidades_vendidas desc;
end //

create procedure consultar_ventas_por_laboratorio()
begin
select 
l.id_laboratorio,
l.nombre_lab,
count(v.id_venta) as cantidad_ventas,
sum(v.total_venta) as total_facturado
from laboratorios l
inner join medicamentos m on l.id_laboratorio = m.id_laboratorio
inner join ventas v on m.id_medicamento = v.id_medicamento
group by l.id_laboratorio, l.nombre_lab
order by total_facturado desc;
end //

create procedure consultar_inventario_medicamentos()
begin
select 
m.id_medicamento,
m.nombre_med,
l.nombre_lab,
m.precio_unitario,
m.stock as stock_actual,
(m.precio_unitario * m.stock) as valor_inventario
from medicamentos m
inner join laboratorios l on m.id_laboratorio = l.id_laboratorio
order by m.stock asc;
end //

create procedure consultar_historial_cliente(
in p_cedula varchar(15)
)
begin
select 
v.id_venta,
v.fecha_venta,
m.nombre_med,
v.cantidad,
v.total_venta
from ventas v
inner join clientes c on v.id_cliente = c.id_cliente
inner join medicamentos m on v.id_medicamento = m.id_medicamento
where c.cedula = p_cedula
order by v.fecha_venta desc;
end //

delimiter ;


-- =====================================================================
-- 3. inserción de datos mediante procedimientos almacenados
-- =====================================================================

call laboratorios_proce('Laboratorios Elma Canon', '6015550101');
call laboratorios_proce('Farmacéutica Rosa Melcacho', '6025550202');
call laboratorios_proce('Químicos Debora Dora', '6045550303');
call laboratorios_proce('BioSalud Lalocura', '6055550404');
call laboratorios_proce('Droguerías Aquiles Baeza', '6015550505');
call laboratorios_proce('Farma Elver Galarga', '6025550606');
call laboratorios_proce('Laboratorios Benito Camelo', '6045550707');
call laboratorios_proce('Genéricos Elsa Pito', '6055550808');

call clientes_proce('1082001', 'Goku Yandel Pérez Gómez', '3001110001');
call clientes_proce('1082002', 'Vegeta Anuel Rodríguez Díaz', '3101110002');
call clientes_proce('1082003', 'Naruto BadBunny Martínez López', '3201110003');
call clientes_proce('1082004', 'Sasuke Maluma Hernández García', '3011110004');
call clientes_proce('1082005', 'Batman Ozuna González Sánchez', '3111110005');
call clientes_proce('1082006', 'Wolverine Feid Ramírez Torres', '3151110006');
call clientes_proce('1082007', 'JohnCena DonOmar Flores Rivera', '3001110007');
call clientes_proce('1082008', 'Undertaker Tupac Morales Ortiz', '3121110008');
call clientes_proce('1082009', 'ReyMysterio Eminem Castro Vargas', '3161110009');
call clientes_proce('1082010', 'Luffy SnoopDogg Jiménez Mendoza', '3041110010');
call clientes_proce('1082011', 'Spiderman Arcángel Romero Suárez', '3181110011');
call clientes_proce('1082012', 'Saitama DaddyYankee Molina Rojas', '3211110012');
call clientes_proce('1082013', 'TripleH JBalvin Silva Ortega', '3021110013');
call clientes_proce('1082014', 'Deadpool Residente Delgado Cruz', '3141110014');
call clientes_proce('1082015', 'Inuyasha NickyJam Reyes Guerrero', '3171110015');
call clientes_proce('1082016', 'Kakashi Cosculluela Medina Peña', '3051110016');
call clientes_proce('1082017', 'Ironman Wisin Ríos Aguilar', '3131110017');
call clientes_proce('1082018', 'HulkTaker Farruko Navarro Vega', '3191110018');

call medicamentos_proce('Paracetamole el Cacho 500mg', 5000.00, 150, 1);
call medicamentos_proce('Besamestazona Crema íntima', 12000.00, 80, 2);
call medicamentos_proce('Diclofenaco pal Guayabo Fuerte', 4000.00, 200, 3);
call medicamentos_proce('Viagrol Parador Plus 100mg', 25000.00, 60, 4);
call medicamentos_proce('Aflojatodo Laxante Explosivo', 8500.00, 100, 5);
call medicamentos_proce('Desenfriolito Quita-Tusa Jarabe', 15000.00, 90, 6);
call medicamentos_proce('Ibuprofe-NoMeRaje 800mg', 6000.00, 120, 7);
call medicamentos_proce('Amoxici-Linda Sonrisa Caja x30', 18000.00, 70, 8);
call medicamentos_proce('Suero Levanta-Muertos Sabor Coco', 7500.00, 110, 1);
call medicamentos_proce('Pomada Sobar-ElLomo Caliente', 9500.00, 85, 2);
call medicamentos_proce('Gotas Quita-Pereza Extrema', 11000.00, 95, 3);
call medicamentos_proce('Pastillas Cierra-Pico 50mg', 14000.00, 65, 4);
call medicamentos_proce('Jarabe Tose-Mucho y Escupe', 13500.00, 75, 5);
call medicamentos_proce('Cápsulas Memoria de Elefante', 22000.00, 50, 6);
call medicamentos_proce('Supositorio El Destapador', 6500.00, 130, 7);
call medicamentos_proce('Vitamina P-Rreo Intenso 1000mg', 19000.00, 55, 8);

call ventas_proce('2026-10-01', 1, 1, 2, 10000.00);
call ventas_proce('2026-10-01', 2, 4, 1, 25000.00);
call ventas_proce('2026-10-01', 3, 5, 3, 25500.00);
call ventas_proce('2026-10-02', 4, 2, 2, 24000.00);
call ventas_proce('2026-10-02', 5, 7, 4, 24000.00);
call ventas_proce('2026-10-02', 6, 3, 5, 20000.00);
call ventas_proce('2026-10-03', 7, 16, 1, 19000.00);
call ventas_proce('2026-10-03', 8, 9, 2, 15000.00);
call ventas_proce('2026-10-03', 9, 15, 3, 19500.00);
call ventas_proce('2026-10-04', 10, 6, 1, 15000.00);
call ventas_proce('2026-10-04', 11, 8, 2, 36000.00);
call ventas_proce('2026-10-04', 12, 11, 1, 11000.00);
call ventas_proce('2026-10-05', 13, 14, 2, 44000.00);
call ventas_proce('2026-10-05', 14, 10, 1, 9500.00);
call ventas_proce('2026-10-05', 15, 12, 2, 28000.00);
call ventas_proce('2026-10-06', 16, 13, 1, 13500.00);
call ventas_proce('2026-10-06', 17, 4, 2, 50000.00);
call ventas_proce('2026-10-06', 18, 1, 3, 15000.00);
call ventas_proce('2026-10-07', 1, 7, 2, 12000.00);
call ventas_proce('2026-10-07', 2, 9, 4, 30000.00);
call ventas_proce('2026-10-07', 3, 16, 2, 38000.00);
call ventas_proce('2026-10-08', 5, 4, 1, 25000.00);
call ventas_proce('2026-10-08', 7, 2, 3, 36000.00);
call ventas_proce('2026-10-08', 9, 5, 2, 17000.00);
call ventas_proce('2026-10-09', 11, 15, 4, 26000.00);
call ventas_proce('2026-10-09', 12, 3, 6, 24000.00);
call ventas_proce('2026-10-09', 14, 14, 1, 22000.00);
call ventas_proce('2026-10-10', 1, 4, 3, 75000.00);
call ventas_proce('2026-10-10', 4, 11, 2, 22000.00);
call ventas_proce('2026-10-10', 6, 8, 1, 18000.00);
call ventas_proce('2026-10-11', 8, 6, 2, 30000.00);
call ventas_proce('2026-10-11', 10, 10, 3, 28500.00);
call ventas_proce('2026-10-11', 13, 12, 1, 14000.00);
call ventas_proce('2026-10-12', 15, 1, 5, 25000.00);
call ventas_proce('2026-10-12', 16, 7, 3, 18000.00);
call ventas_proce('2026-10-12', 17, 13, 2, 27000.00);
call ventas_proce('2026-10-13', 18, 15, 1, 6500.00);
call ventas_proce('2026-10-13', 2, 16, 1, 19000.00);
call ventas_proce('2026-10-13', 5, 9, 2, 15000.00);
call ventas_proce('2026-10-14', 1, 3, 4, 16000.00);

-- =====================================================================
-- 4. ejecución de prueba de consultas
-- =====================================================================
call consultar_ventas_detalladas();
call consultar_total_compras_por_cliente();
call consultar_medicamentos_mas_vendidos();
call consultar_ventas_por_laboratorio();
call consultar_inventario_medicamentos();
call consultar_historial_cliente('1082001');

/*1.Consolidado General por Laboratorio (Sin parámetros): Cree el procedimiento Reporte_Laboratorios_Proce() que no reciba parámetros de entrada. Debe mostrar el nombre de cada laboratorio, la cantidad de ventas (facturas) en las que han participado sus productos (COUNT), el total de dinero recaudado (SUM) y el promedio de dinero por venta (AVG) redondeado a dos decimales.*/

delimiter //

create procedure reporte_laboratorios_proce()
begin
select 
l.nombre_lab,
count(v.id_venta) as cantidad_ventas,
sum(v.total_venta) as total_recaudado,
round(avg(v.total_venta), 2) as promedio_por_venta
from laboratorios l
inner join medicamentos m on l.id_laboratorio = m.id_laboratorio
inner join ventas v on m.id_medicamento = v.id_medicamento
group by l.id_laboratorio, l.nombre_lab;
end //

delimiter ;

/*2.Rendimiento Comercial de Medicamentos (Sin parámetros): Cree el procedimiento Reporte_Medicamentos_Proce() que no reciba parámetros. Debe listar el nombre del medicamento, el nombre de su laboratorio, el número de veces que ha sido facturado (COUNT), el total de unidades vendidas (SUM) y el promedio de unidades que llevan los clientes en cada compra (AVG).*/

delimiter //

create procedure reporte_medicamentos_proce()
begin
    select 
        m.nombre_med,
        l.nombre_lab,
        count(v.id_venta) as veces_facturado,
        sum(v.cantidad) as total_unidades_vendidas,
        round(avg(v.cantidad), 2) as promedio_unidades_por_compra
    from medicamentos m
    inner join laboratorios l on m.id_laboratorio = l.id_laboratorio
    inner join ventas v on m.id_medicamento = v.id_medicamento
    group by m.id_medicamento, m.nombre_med, l.nombre_lab;
end //

delimiter ;

/*3.Historial Financiero por Cédula de Cliente (1 parámetro de entrada): Cree el procedimiento Reporte_Cliente_Cedula_Proce(IN p_cedula VARCHAR(15)) que reciba como parámetro el número de cédula de un cliente. Debe mostrar el nombre del cliente, su teléfono, la cantidad total de compras realizadas (COUNT), el total de dinero gastado en la droguería (SUM) y el valor promedio de sus facturas (AVG).*/

delimiter //

create procedure reporte_cliente_cedula_proce(
    in p_cedula varchar(15)
)
begin
select 
c.nombre_cliente,
c.telefono,
count(v.id_venta) as total_compras,
sum(v.total_venta) as total_gastado,
round(avg(v.total_venta), 2) as valor_promedio_factura
from clientes c
inner join ventas v on c.id_cliente = v.id_cliente
where c.cedula = p_cedula
group by c.id_cliente, c.nombre_cliente, c.telefono;
end //

delimiter ;

/*4.Auditoría de Ventas de un Laboratorio Específico (1 parámetro de entrada): Cree el procedimiento Reporte_Medicamentos_Por_Lab_Proce(IN p_nombre_lab VARCHAR(50)) que reciba el nombre exacto de un laboratorio. Debe listar todos los medicamentos vendidos de ese laboratorio mostrando el nombre del medicamento, la cantidad de transacciones registradas (COUNT) y el recaudo total en dinero (SUM) generado por cada medicamento.*/

delimiter //

create procedure reporte_medicamentos_por_lab_proce(
    in p_nombre_lab varchar(50)
)
begin
select 
m.nombre_med,
count(v.id_venta) as cantidad_transacciones,
sum(v.total_venta) as recaudo_total
from laboratorios l
inner join medicamentos m on l.id_laboratorio = m.id_laboratorio
inner join ventas v on m.id_medicamento = v.id_medicamento
where l.nombre_lab = p_nombre_lab
group by m.id_medicamento, m.nombre_med;
end //

delimiter ;

/*5.Cierre de Caja por Rango de Fechas (2 parámetros de entrada): Cree el procedimiento Reporte_Ventas_Fechas_Proce(IN p_fecha_inicio DATE, IN p_fecha_fin DATE) que reciba una fecha inicial y una fecha final. Debe mostrar, agrupado por cliente, el nombre del cliente que compró en ese periodo, cuántas compras realizó (COUNT), el total de unidades de medicamentos que llevó (SUM) y el promedio en dinero gastado por compra (AVG) dentro de dicho rango de fechas.*/