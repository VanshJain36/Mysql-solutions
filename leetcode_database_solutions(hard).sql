# 185. Department Top Three Salaries

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
