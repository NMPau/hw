--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

select c.class, count(s.ship) 
from classes c
left join
(select o.ship, sh.class from outcomes o
left join ships sh on sh.name = o.ship
where o.result = 'sunk') as s 
on s.class = c.class or s.ship = c.class
group by c.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select c.class, y.min_year
from classes c
join 
(select class, min(launched) as min_year 
from ships s
group by class) as y 
on c.class = y.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
 

select c.class, count(outc.sunk)
from classes c
left join
(select x.name as name, x.class as class,
case when
o.result = 'sunk' then 1
else 0
end as sunk from
(select name,class from ships s
union all 
select ship,result from outcomes) as x
left join outcomes o on x.name=o.ship) outc
on outc.class=c.class 
group by c.class 
having count(distinct outc.name) >= 3 and sum(outc.sunk) > 0



--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).


    
select name
from(
select name as name, displacement, numguns 
from ships s inner join classes c on s.class = c.class 
union 
select ship as name, displacement, numguns from outcomes o inner join classes c on o.ship= c.class) as d1 
inner join (
select displacement, max(numGuns) as numguns from 
( 
select displacement, numguns from ships s inner join classes c on s.class = c.class 
union
select displacement, numguns from outcomes o inner join classes c on o.ship= c.class
) as a
group by displacement) as d2 
on d1.displacement=d2.displacement and d1.numguns =d2.numguns
    

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker


with a0 as
(select *
from product pr
join pc
on pr.model=pc.model 
where ram = (select min(ram) from pc) 
and speed = (select max(speed) from pc where ram = (select min(ram) from pc))
)
select model
from a0
where type = 'printer'

