--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case
when grades.grade >= 8
then students.name
else null
end,
grades.grade, students.marks
from students
inner join grades 
on students.marks between grades.min_mark and grades.max_mark
order by grades.grade desc, students.name asc, students.marks asc;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select 
min(case when occupation = 'Doctor' then name else NULL end),
min(case when occupation = 'Professor' then name else NULL end),
min(case when occupation = 'Singer' then name else NULL end),
min(case when occupation = 'Actor' then name else NULL end)
from
(select occupation, name, row_number() over (partition by occupation order by name) as o
from occupations) as o1
group by o

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct(city) 
from station 
where left(city,1) not in ('A','E','I','O','U');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct(city) 
from station 
where right(city,1) not in ('A','E','I','O','U');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct(city)
from station
where left(city,1) not in ('A','E','I','O','U')
or right(city,1) not in ('A','E','I','O','U');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct(city)
from station
where left(city,1) not in ('A','E','I','O','U')
and right(city,1) not in ('A','E','I','O','U');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name
from employee
where salary > 2000
and months < 10
order by employee_id asc

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case
when grades.grade >= 8
then students.name
else null
end,
grades.grade, students.marks
from students
inner join grades 
on students.marks between grades.min_mark and grades.max_mark
order by grades.grade desc, students.name asc, students.marks asc;