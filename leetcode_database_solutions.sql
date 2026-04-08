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

-- 1327. List the Products Ordered in a Period

select p.product_name, sum(o.unit) as unit
from products p 
join orders o 
on (p.product_id = o.product_id) 
where o.order_date 
between '2020-02-01' and '2020-02-29' 
group by p.product_name
having sum(o.unit) >= 100;

-- 1407. Top Travellers

select u.name, ifnull(sum(r.distance), 0) as travelled_distance 
from users u 
left join rides r 
on u.id = r.user_id 
group by r.user_id 
order by travelled_distance desc, u.name asc;

-- 1484. Group Sold Products By The Date

select sell_date, 
count(distinct product) as num_sold,
group_concat(distinct product separator ',') as products 
from activities 
group by sell_date;

-- 1517. Find Users With Valid E-Mails

select * 
from users 
where
mail regexp '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\\.com$'
and mail like binary '%@leetcode.com';

-- 1527. Patients With a Condition

select * 
from patients 
where conditions like 'DIAB1%' 
or conditions like '% DIAB1%';

-- 1587. Bank Account Summary II

select u.name, sum(t.amount) as balance 
from users u 
join transactions t 
on (u.account = t.account) 
group by t.account
having balance > 10000;

-- 1633. Percentage of Users Attended a Contest

select r.contest_id , 
round(((count(r.contest_id)/ (select count(user_id) from users)) * 100), 2) as percentage 
from register r 
group by r.contest_id 
order by percentage desc, contest_id asc;

--1667. Fix Names in a Table

select user_id, 
concat(upper(left(name, 1)), lower(right(name,length(name) - 1))) as name 
from users 
order by user_id asc;

-- 1693. Daily Leads and Partners

select date_id, 
make_name, 
count(distinct lead_id) as unique_leads, 
count(distinct partner_id) as unique_partners 
from dailysales 
group by date_id, make_name;

-- 1729. Find Followers Count

select user_id, 
count(distinct follower_id) as followers_count 
from followers 
group by user_id;

-- 1731. The Number of Employees Which Report to Each Employee

select e.employee_id, e.name,
count(m.reports_to) as reports_count, 
round(avg(m.age)) as average_age 
from employees e 
join employees m 
on (e.employee_id = m.reports_to) 
group by e.employee_id
order by e.employee_id;

--1741. Find Total Time Spent by Each Employee

select event_day as day, 
emp_id, 
sum(out_time - in_time) as total_time 
from employees 
group by emp_id, event_day;

-- 1789. Primary Department for Each Employee

select employee_id, department_id
from employee 
where primary_flag = 'Y' 
or employee_id in 
(select employee_id 
from employee 
group by employee_id 
having count(employee_id) = 1);

-- 1795. Rearrange Products Table

select product_id, 'store1' as store, store1 as price 
from products 
where store1 != 'null'
union all
select product_id, 'store2' as store, store2 as price 
from products 
where store2 != 'null'
union all
select product_id, 'store3' as store, store3 as price 
from products 
where store3 != 'null';

-- 1873. Calculate Special Bonus

select employee_id, 
case
when employee_id % 2 = 0 then 0
when left(name, 1) = 'M' then 0
else salary
end as bonus
from employees
order by employee_id;

-- 1890. The Latest Login in 2020

select distinct user_id , max(time_stamp) as last_stamp 
from logins 
where time_stamp 
between '2020-01-01 00:00:00' and '2020-12-31 23:59:59' 
group by user_id;

-- 1965. Employees With Missing Information

select e.employee_id
from employees e 
left join salaries s 
on (e.employee_id = s.employee_id)
where salary is null

union

select s.employee_id
from salaries s
left join employees e 
on (s.employee_id = e.employee_id)
where e.employee_id is null
order by employee_id asc;

-- 1978. Employees Whose Manager Left the Company

select employee_id
from employees
where salary < 30000
and manager_id 
not in 
    (select employee_id from employees)
order by employee_id;

-- 2356. Number of Unique Subjects Taught by Each Teacher

select teacher_id, count(distinct subject_id) as cnt
from teacher
group by teacher_id;

-- 3436. Find Valid Emails

select user_id, email
from users
where email 
regexp '^[A-Za-z0-9_]+@[A-Za-z]+\\.com$'
order by user_id;

-- 3465. Find Products with Valid Serial Numbers

select *
from products
where regexp_like(description, '(^|[^A-Za-z0-9])SN[0-9]{4}-[0-9]{4}([^A-Za-z0-9]|$)', 'c')
order by product_id;

-- 3570. Find Books with No Available Copies

select l.book_id, l.title, l.author, l.genre, l.publication_year, (l.total_copies) as current_borrowers 
from library_books l 
join borrowing_records b 
on (l.book_id = b.book_id)
where b.return_date is null
group by l.book_id
having count(*) = l.total_copies
order by current_borrowers desc, l.title;

--3793. Find Users with High Token Usage

select user_id, count(prompt) as prompt_count, round(avg(tokens),2) as avg_tokens
from prompts
group by user_id
having prompt_count > 2
and max(tokens) > avg_tokens
order by avg_tokens desc, user_id asc;
