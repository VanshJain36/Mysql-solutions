-- 175. Combine two tables

select firstName, lastName, city, state 
from person p 
left join address a 
on (p.personId = a.personId);


-- 181. employees earning more than their anagers

select name as Employee 
from employee as e 
where 
salary > (select salary from employee where id = e.managerId);
