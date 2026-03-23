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

-- 196. Delete duplicate emails

delete p1 from person p1, person p2 where p1.email = p2.email and p1.id > p2.id;

-- 511. Game play analysis

select player_id, 
min(event_date) 
as first_login 
from activity group by player_id;

-- 5885. Customer placing the largest number of orders

select customer_number 
from orders 
group by customer_number 
order by count(order_number) 
desc limit 1;

-- 596. Classes whith atleast 5 students

select class 
from courses 
group by class 
having count(student) >= 5;

-- 607. Sales Person

with red_sales as(
    select o.sales_id 
    from Orders o
    join Company c 
    on (o.com_id = c.com_id) 
    where c.name = 'RED' 
)

select s.name 
from SalesPerson s 
where s.sales_id not in 
(select sales_id from red_sales);

-- 610 Traingle Judgement

select *,
if (x + y > z and y + z > x and z + x > y, "Yes", "No") 
as triangle from triangle;
