--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
Select name, class from ships
Where launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
Select name, class from ships
Where launched between 1920 and 1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
Select class, count(name)
From ships
Group by class


-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
Select distinct class, country
From classes
Where bore > 15

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--

Select outcomes.ship
From battles
Join outcomes 
On outcomes.battle = battles.name 
Where battles.name = 'North Atlantic'
And outcomes.result = 'sunk'


-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select ship 
From outcomes
Join battles
On outcomes.battle = battles.name
where result = 'sunk'
and
date = (select max(date) from battles)



-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
Select outcomes.ship, ships.class
From ships
Join outcomes
On ships.name = outcomes.ship
where result = 'sunk'

--and where date = 
(select max(date)
From outcomes
Join battles
On outcomes.battle = battles.name)




-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--


select name, ships.class
from ships
join classes
on ships.class = classes.class
where bore >= 16

(Select outcomes.ship, ships.class
From ships
Join outcomes
On ships.name = outcomes.ship
Where result = 'sunk')


-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
Select class
From classes
Where country = 'USA'
-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

Select ships.name, ships.class
From ships
Join classes
On ships.class = classes.class
Where country = 'USA'



 
