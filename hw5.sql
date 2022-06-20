--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

with all_pr as
(select product.model, price
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
on pc.model = product.model) 
select model
from all_pr
where price = (select max(price) from all_pr)

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) 
-- и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта 
-- в порядке возрастания цены (price_index). По этому price_index сделать индекс


create table all_products_with_index_task5 as 


select product.model, maker, price, product.type,
case when price > (select max(price) from printer) then 1
else 0
end flag
from (
select *, row_number () over (partition by type order by price asc) price_index
from
( 
select code, model, price 
   from pc 
   union all  
    select code, model, price 
    from printer  
   union all  
    select code, model, price 
    from laptop   
    )
    as foo 
    join product   
    on product.model = foo.model)
 
create index price_indx on all_products_with_index_task5 (price_index)










