--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

create view pages_all_products as    
select *, 
case when num % 2 = 0 
then num/2 else num/2 + 1 
end as page_num, 
case when total % 2 = 0 
then total/2 else total/2 + 1 
end as num_of_pages
from (select *, row_number() over(order by price desc) as num, 
count(*) over() as total 
from Laptop
) x

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)
create view distribution_by_type as

select maker, type,
cast(100.0*num/total as numeric(5,2))
from
(select *,
count(*) over() as total 
from (select maker, product.type, count(*) over () as num
from pc
join product 
on pc.model=product.model 
union all
select maker, product.type, count(*) over () as num
from printer 
join product 
on printer.model=product.model 
union all
select maker, product.type, count(*) over () as num
from laptop 
join product 
on laptop.model=product.model) X) X1


--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/
import plotly.express as px
request = """
select maker, type,
cast(100.0*num/total as numeric(5,2))
from
(select *,
count(*) over() as total 
from (select maker, product.type, count(*) over () as num
from pc
join product 
on pc.model=product.model 
union all
select maker, product.type, count(*) over () as num
from printer 
join product 
on printer.model=product.model 
union all
select maker, product.type, count(*) over () as num
from laptop 
join product 
on laptop.model=product.model) X) X1
"""
df = pd.read_sql_query(request, conn)

df = px.data.tips()
fig = px.pie(df, values='numeric', names='type')
fig.show()
--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as
select * from ships 
where name like '% %'


--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select name
from ships
where name like 'S%'
and class is null 

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

select pr.model,
row_number() over (partition by pr.model order by pr.price desc) as rn
from printer pr
join product p
on pr.model = p.model 
where maker = 'A'
and price > (select avg(price) from printer join product on printer.model=product.model where maker = 'C')
where rn < 4

