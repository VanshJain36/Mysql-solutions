-- 176. Second Highest Salary

select max(salary) as SecondHighestSalary 
from employee 
where salary < (select max(salary) from employee);

-- 177. Nth Highest Salary

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select salary from
      (select *, dense_rank() over (order by salary desc) as r 
      from employee) as temp
      where r = n
      limit 1
  );
END

-- 178. Rank Scores

SELECT score, DENSE_RANK() OVER (ORDER BY score DESC) as 'rank'
FROM Scores;

-- 180. Consecutive Numbers

select distinct l1.num as ConsecutiveNums 
from logs l1, logs l2, logs l3
where l1.num = l2.num
and l2.num = l3.num
and l1.id = l2.id + 1
and l2.id = l3.id + 1;

-- 184. Department Highest Salary

select d.name as department, e.name as employee, e.salary as salary 
from employee e 
join department d
on (e.departmentid = d.id)
where (e.departmentid, e.salary) in (
    select departmentid, max(salary) 
    from employee 
    group by departmentid
);

-- 570. Managers with at Least 5 Direct Reports

select name 
from employee 
where id in (
    select managerid 
    from employee
    group by managerid
    having count(*) >= 5 
)

-- 585. Investments in 2016
  
select round(sum(tiv_2016),2) as tiv_2016
from insurance
where (lat, lon) in (
    select lat, lon
    from insurance
    group by lat, lon
    having count(*) = 1
)
and tiv_2015 in (
    select tiv_2015
    from insurance
    group by tiv_2015
    having count(*) > 1
);

-- 602. Friend Requests II: Who Has the Most Friends
  
with num1 as(
    (
        select requester_id as id, count(requester_id) as num 
        from requestaccepted 
        group by requester_id
    )
union all
    (
        select accepter_id as id, count(accepter_id) as num 
        from requestaccepted 
        group by accepter_id
    )
)
select id, sum(num) as num
from num1
group by id
order by num desc
limit 1;

-- 608. Tree Node

select id, 
case
when p_id is null then 'Root'
when id in (select p_id from tree) then 'Inner'
else 'Leaf'
end as type
from tree;

-- 626. Exchange Seats

select case
when id % 2 != 0 and id != (select max(id) from seat) then id + 1
when id % 2 = 0 then id - 1
else id
end as id, student
from seat 
order by id asc;

-- 1045. Customers Who Bought All Products

select c.customer_id 
from customer c
group by c.customer_id
having count(distinct c.product_key) = (select count(p.product_key) from product p);

-- 1070. Product sales analysis III

with cte as (
    select product_id, min(year) as first_year
    from sales
    group by product_id
)

select product_id, year as first_year, quantity, price
from sales
where (product_id, year) in (
    select * from cte
);

-- 1158. Market Analysis I

select u.user_id as buyer_id, u.join_date, count(o.buyer_id) as orders_in_2019
from users u 
left join orders o 
on o.buyer_id = u.user_id 
and o.order_date >= '2019-01-01' and o.order_date <= '2019-12-31'
group by u.user_id;

-- 1164. Product Price at a Given Date

select distinct product_id, 10 as price 
from products 
where product_id 
not in (
    select distinct product_id 
    from products
    where change_date <= '2019-08-16' 
)
union
select product_id, new_price as price 
from products 
where (product_id, change_date) in (
    select product_id, max(change_date)
    from products
    where change_date <= '2019-08-16'
    group by product_id
);

-- 1174. Immediate Food Delivery II

select round((avg(order_date = customer_pref_delivery_date)) * 100, 2) as immediate_percentage
from delivery
where (customer_id, order_date) in (
    select customer_id, min(order_date)
    from delivery
    group by customer_id
);

-- 1193. Monthly Transactions I

select left(trans_date, 7) as month, 
country, 
count(id) as trans_count, 
sum(state = 'approved') as approved_count, 
sum(amount) as trans_total_amount, 
sum((state = 'approved') *  amount) as approved_total_amount
from transactions
group by month, country;

-- 1204. Last Person to Fit in the Bus

select person_name from
(
    select person_name, sum(weight) over (order by turn) as total_weight
    from queue  
) as t
where total_weight <= 1000
order by total_weight desc
limit 1;

-- 1321. Restaurant Growth

select distinct visited_on, sum(amount) over w as amount, 
round(((sum(amount) over w)/ 7),2) as average_amount
from customer
window w as (
    order by visited_on
    range between interval 6 day preceding and current row
)
limit 999 offset 6;
