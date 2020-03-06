use lab1;
select name
from person
where driver_id in (
	select driver_id 
    from participated
    where damage_amount > (select avg(damage_amount) from participated)
    );
    
use lab2;
insert into ACCOUNTS values (1, 'SBI-MUM', 200);

use lab3;
select sname
from supplier
where sid in (
	select sid 
    from catalog
    where cost in (
		select sid, max(cost)
        from catalog
        group by pid
        having max(cost)
        )
	);
    
select sid, pid, max(cost)
        from catalog
        group by pid
        having max(cost)
