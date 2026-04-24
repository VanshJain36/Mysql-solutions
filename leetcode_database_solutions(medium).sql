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

--  1341. Movie Rating

(select u.name as results
from users u 
join movierating mr 
on (u.user_id = mr.user_id)
group by mr.user_id
order by count(*) desc, u.name
limit 1
)

union all

(select m.title as results
from movies m 
join movierating mr 
on (m.movie_id = mr.movie_id)
where mr.created_at >= '2020-02-01' and mr.created_at <=  '2020-02-29'
group by m.title
order by avg(rating) desc, m.title
limit 1
);

-- 1393. Capital Gain/Loss

with stock_sum as(
    select stock_name, sum(price) as capital_gain_loss
    from stocks
    where operation = 'Buy'
    group by stock_name
),

    stock_diff as(
    select stock_name, sum(price) as capital_gain_loss
    from stocks
    where operation = 'Sell'
    group by stock_name
)

select ss.stock_name, sd.capital_gain_loss - ss.capital_gain_loss as capital_gain_loss
from stock_sum ss
join stock_diff sd
on (ss.stock_name =  sd.stock_name);

-- 1907. Count Salary Categories

select 'Low Salary' as category,
sum(income < 20000) as accounts_count
from accounts

union all

select 'Average Salary' as category,
sum(income <= 50000 and income >= 20000) as accounts_count
from accounts

union all

select 'High Salary' as category,
sum(income > 50000) as accounts_count
from accounts;

-- 1934. Confirmation Rate

select s.user_id , round(avg(if(c.action = 'confirmed', 1, 0)), 2) as confirmation_rate
from signups s
left join confirmations c
on (s.user_id = c.user_id)
group by user_id;

-- 3220. Odd and Even Transactions

select transaction_date, 
sum(case when amount % 2 = 1 then amount else 0 end) as odd_sum,
sum(case when amount % 2 = 0 then amount else 0 end) as even_sum
from transactions
group by transaction_date
order by transaction_date asc;

-- 3475. DNA Pattern Recognition 

select sample_id, 
dna_sequence, 
species, 
sum(if(dna_sequence like 'ATG%', 1, 0)) as has_start,

(dna_sequence LIKE '%TAA' 
        OR dna_sequence LIKE '%TAG' 
        OR dna_sequence LIKE '%TGA') AS has_stop,

sum(if(dna_sequence like '%ATAT%', 1, 0)) as has_atat,
sum(if(dna_sequence like '%GGG%', 1, 0)) as has_ggg
from samples
group by dna_sequence;

-- 3497. Analyze Subscription Conversion 

with free as (
    select user_id, round(avg(activity_duration), 2) as trial_avg_duration
    from useractivity
    where activity_type = 'free_trial'
    group by user_id
),

paid as(
    select user_id, round(avg(activity_duration), 2) as paid_avg_duration
    from useractivity
    where activity_type = 'paid'
    group by user_id
)

select p.user_id, f.trial_avg_duration, p.paid_avg_duration
from paid p
join free f
on (p.user_id = f.user_id);

-- 3521. Find Product Recommendation Pairs

select p1.product_id as product1_id,
p2.product_id as product2_id,
i1.category as product1_category,
i2.category as product2_category,
count(p1.user_id) as customer_count
from ProductPurchases p1
inner join ProductPurchases p2 
on (p1.user_id = p2.user_id)
and p1.product_id < p2.product_id
left join productinfo i1
on (p1.product_id = i1.product_id)
left join productinfo i2
on (p2.product_id = i2.product_id)
group by product1_id, product2_id
having customer_count > 2
order by customer_count desc, product1_id, product2_id;

-- 3580. Find Consistently Improving Employees

with review_rank as(
    select p.employee_id, e.name, p.review_date, p.rating,
    dense_rank() over (partition by p.employee_id order by p.review_date desc) as rnk
    from performance_reviews p
    join employees e
    on (e.employee_id = p.employee_id)
),
last3 as (
    select * 
    from review_rank
    where rnk <= 3
),
increase as (
    select *,
    lag(rating, 1) over (partition by employee_id order by review_date) as prev,
    lag(rating, 2) over (partition by employee_id order by review_date) as prev2
    from last3
)
select employee_id, name, rating - prev2 as improvement_score
from increase
where prev is not null
and rating > prev
and prev > prev2
order by improvement_score desc, name asc;
