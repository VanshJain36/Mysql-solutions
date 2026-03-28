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

-- 585. Customer placing the largest number of orders

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

-- 610. Traingle Judgement

select *,
if (x + y > z and y + z > x and z + x > y, "Yes", "No") 
as triangle from triangle;

-- 619. Biggest Single Number

select max(num) as num
from mynumbers
where num in (
    select num from 
    MyNumbers group by num 
    having count(num) = 1
);

-- 620. Not Boring Movies

select * 
from cinema 
where id % 2 = 1 
and description != 'boring' 
order by rating desc;

-- 627. Swap sex of employee

update salary set 
sex = case 
    when sex = 'm' then 'f'
    else 'm'
end;

-- 1050. Acotes and directors who cooperated atleast three times

select actor_id, director_id 
from actordirector 
group by actor_id, director_id 
having count(timestamp) >= 3;

-- 1075. Project Employees

select project_id, 
round(avg(e.experience_years), 2) as average_years 
from employee e 
join project p 
on 
(p.employee_id = e.employee_id) 
group by p.project_id;

-- 1084. Sales analysis III

select s.product_id, p.product_name 
from sales s 
join product p 
on 
(p.product_id = s.product_id) 
group by s.product_id, p.product_name 
having min(s.sale_date) >= '2019-01-01'  
and max(s.sale_date) <= '2019-03-31';

-- 1141. User Activity for the Past 30 Days I

select activity_date as day, 
count(distinct user_id) as active_users
from activity 
where activity_date > '2019-06-27' 
and activity_date <= '2019-07-27' 
group by activity_date;

-- 1179. Reformat Department Table

select 
    id,
    sum(case when month = 'Jan' then revenue end) as Jan_Revenue,
    sum(case when month = 'Feb' then revenue end) as Feb_Revenue,
    sum(case when month = 'Mar' then revenue end) as Mar_Revenue,
    sum(case when month = 'Apr' then revenue end) as Apr_Revenue,
    sum(case when month = 'May' then revenue end) as May_Revenue,
    sum(case when month = 'Jun' then revenue end) as Jun_Revenue,
    sum(case when month = 'Jul' then revenue end) as Jul_Revenue,
    sum(case when month = 'Aug' then revenue end) as Aug_Revenue,
    sum(case when month = 'Sep' then revenue end) as Sep_Revenue,
    sum(case when month = 'Oct' then revenue end) as Oct_Revenue,
    sum(case when month = 'Nov' then revenue end) as Nov_Revenue,
    sum(case when month = 'Dec' then revenue end) as Dec_Revenue
from department 
group by id;

-- 1211. Queries Quality and Percentage

select query_name,
round(avg(rating / position), 2) as quality, 
round(avg(case when rating < 3 then 1 else 0 end) * 100, 2) as poor_query_percentage 
from queries 
group by query_name;

-- 1251. Average Selling Price

select p.product_id,
ifNull(round(sum(u.units * p.price) / sum(u.units), 2), 0) as average_price 
from prices p
left join unitssold u  
on (p.product_id = u.product_id) 
and u.purchase_date between p.start_date and p.end_date 
group by product_id;
