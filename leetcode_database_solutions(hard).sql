-- 185. Department Top Three Salaries

with cte as(
    select d.name as d_name, e.name as e_name, e.salary as salary,
    dense_rank() over (partition by e.departmentId order by e.salary desc) as denserank
    from employee e
    join department d
    on (e.departmentId = d.id)
)

select d_name as Department, e_name as Employee, salary as Salary
from cte
where denserank < 4;

-- 262. Trips and Users

select request_at as Day, 
round(sum(
    case when status like 'cancelled%' then 1 else 0 end) / count(request_at), 2) 
    as "Cancellation Rate"
from trips t
join users u1
on (t.client_id = u1.users_id)
and u1.banned = 'No'
join users u2
on (t.driver_id = u2.users_id)
and u2.banned = 'No'
where request_at between '2013-10-01' and '2013-10-03'
group by request_at
order by request_at asc;

-- 601. Human Traffic of Stadium

select * 
from stadium
where id in (
    select s1.id
    from stadium s1
    join stadium s2 on s1.id = s2.id - 1
    join stadium s3 on s2.id = s3.id - 1
    where s1.people >= 100 and s2.people >= 100 and s3.people >= 100

    union

    select s2.id
    from stadium s1
    join stadium s2 on s1.id = s2.id - 1
    join stadium s3 on s2.id = s3.id - 1
    where s1.people >= 100 and s2.people >= 100 and s3.people >= 100

    union

    select s3.id
    from stadium s1
    join stadium s2 on s1.id = s2.id - 1
    join stadium s3 on s2.id = s3.id - 1
    where s1.people >= 100 and s2.people >= 100 and s3.people >= 100
)
group by visit_date;
