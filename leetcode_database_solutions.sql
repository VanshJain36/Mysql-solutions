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

-- 182. Duplicate Emails

select 
email as Email 
from person 
group by email 
having 
count(email) > 1;

-- 183. Customers who never order

select c.name as Customers 
from customers c 
left join 
orders o on 
(c.id = o.customerId) 
where 
o.id is Null;
