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
