--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
select t.Department, t.Employee, salary from(
select d.name as 'Department', e.name as 'Employee', salary,
dense_rank() over(partition by departmentId order by salary desc) as 'rnk'
from employee as e
left join department as d
on departmentId = d.id) as t
where t.rnk in (1,2,3)

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, status, SUM (payments.unit_price) AS costs 
from FamilyMembers
JOIN Payments ON familymembers.member_id = payments.family_member
WHERE year(payments.date) = 2005
GROUP BY Payments.family_member

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name 
from passenger 
group by name
having count(name) >1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from student 
where first_name like 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(distinct classroom) as count 
from schedule 
where date = '2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from student 
where first_name like 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select round(avg(TIMESTAMPDIFF(year, birthday, curdate())), 0) as age
from familymembers 

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(amount*unit_price) as costs
from GoodTypes
join goods on goodtypes.good_type_id = goods.type
join payments on goods.good_id = payments.good
where year(date) = 2005 
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select round(min(TIMESTAMPDIFF(year, birthday, curdate())), 0) as year 
from student 

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select max(TIMESTAMPDIFF(year, birthday, curdate()) as max_year
from Student
join Student_in_class
on student.id = Student_in_class.student
join slass 
on student_in_class.class = class.id
where class.name like "10%"

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select f.status, f.member_name, sum(p.amount*p.unit_price) as costs
from familymembers f
join Payments p 
on f.member_id =p.family_member
join Goods g
on p.good = g.good_id
join goodtypes gt 
on g.type = gt.good_type_id
where gt.good_type_name = 'entertainment'
group by f.status, f.member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete company
from  Company 
join Trip 
on company= Company.id
where Company.id in (select company from ( 
select company, count(ID) as x from Trip
group by Company 
having  x = (select min(x) 
from (select count(ID) as x 
from Trip 
group by company) as a0)) as a1)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom
from Schedule
group by classroom
having count (classroom) = 
(select count(classroom), dense_rank() over (order by count(classroom) desc) num
from Schedule
group by classroom
where num = 1
)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select t.last_name
from teacher t 
join Schedule s
on t.id = s.teacher
join subject sub 
on s.subject = sub.id
where sub.name = 'Physical Culture'
order by t.last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select concat(last_name, ' ', left(first_name, 1), '.', left(middle_name, 1, '.')) as name 
from student 