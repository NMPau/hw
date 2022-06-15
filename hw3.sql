--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select *
from product

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case when price > (select avg(price) from pc)
then 1
else 0
end flag
from printer


--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select name
from ships
where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.


with battle_name as
(select name, extract(year from date) as year
from battles b)
select name
from battle_name
where year not in (select launched from ships)



--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle
from outcomes 
join ships   
on ship = name
where class = 'Kongo'


--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag


create view all_products_flag_300 as select model, price, flag
from
(select *, case when price > 300 then 1
else 0
end flag 
from
(select product.model, price
from product
join laptop
on product.model=laptop.model 
union all 
select product.model, price
from product
join printer
on product.model=printer.model 
union all 
select product.model, price
from product
join pc
on product.model=pc.model)
)


--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag


create view all_products_flag_avg_price as select model, price, flag
from (
select *, 
case when price > (select avg(price) from a1) 
then 1 
else 0 
end flag
from (select * from
(select product.model, price
from product
join laptop
on product.model=laptop.model 
union all 
select product.model, price
from product
join printer
on product.model=printer.model 
union all 
select product.model, price
from product
join pc
on product.model=pc.model) a1



--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model


select printer.model
from printer 
join product 
on printer.model = product.model
where maker = 'A'
and price > (
	select avg(price) from printer 
	join product 
	on printer.model = product.model 
	where maker = 'D' and maker = 'C'
	)



--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with all_a as
(
select product.model, price
from laptop 
join product 
on laptop.model = product.model 
union all 
select product.model, price
from printer 
join product 
on printer.model = product.model 
union all 
select product.model, price
from pc 
join product 
on pc.model = product.model 
)
select distinct model from all_a
where price > 
(select avg(price) from printer
join product
on printer.model=product.model
where maker = 'D' or maker = 'C')

	
	
--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

with all_price as (select distinct p.model, price
from laptop l 
join product p 
on l.model=p.model 
where maker ='A'
union all 
select distinct p.model, price
from printer pr
join product p 
on pr.model=p.model 
where maker ='A'
union all 
select distinct p.model, price 
from pc
join product p 
on pc.model=p.model 
where maker ='A')
select avg(price) from all_price



--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count


create view count_products_by_makers as
select maker, count(*) 
from product
group by maker
order by maker



--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
select maker, count
from count_products_by_makers
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'count'})
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'


create table printer_updated as table printer
delete from printer_updated	
where model in (select model from product where maker = 'D')


--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code, printer_updated.model, color, printer_updated.type, price, maker
from printer_updated
join product
on printer_updated.model = product.model


--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)


create view sunk_ships_by_classes as
	with all_ships as
	(select name, class
	from ships
	union all
	select distinct ship, NULL as class
	from outcomes
	where ship not in (select name from ships) 
	)
	select class, count(*) from all_ships where name in
	(select ship
	from outcomes
	where result = 'sunk'
	) group by class
	

	
--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
request = """
select class, count
from sunk_ships_by_classes
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['class'].to_list(), y=df['count'].to_list(), labels={'x':'class', 'y':'count'})
fig.show()

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as
select *, case 
	when numguns > 9 then 1
	else 0
end flag
from classes 



--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select country, count(*)
from classes 
group by country
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['country'].to_list(), y=df['count'].to_list(), labels={'x':'country', 'y':'count'})
fig.show()


--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".


select count(*)
from ships
where name like 'O%' or name like 'M%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(*)
from ships
where name like '% %'


--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

request = """
select launched, count(*)
from ships 
group by launched 
order by launched 
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['launched'].to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'})
fig.show()

