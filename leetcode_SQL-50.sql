-- 570. Managers with at Least 5 Direct Reports

select name 
from employee
where id in
(select managerid
from employee
group by managerid
having count(*) >= 5);
