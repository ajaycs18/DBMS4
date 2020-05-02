create database airlinedb;
use airlinedb;

CREATE TABLE FLIGHTS (
FLNO INTEGER PRIMARY KEY,
FFROM VARCHAR(15) NOT NULL,
TTO VARCHAR(15) NOT NULL,
DISTANCE INTEGER,
DEPARTS TIMESTAMP,
ARRIVES TIMESTAMP,
PRICE INTEGER
);


CREATE TABLE AIRCRAFT(
AID INTEGER PRIMARY KEY,
ANAME VARCHAR(10),
CRUISINGRANGE INTEGER
);

CREATE TABLE EMPLOYEES (
EID INTEGER PRIMARY KEY,
ENAME VARCHAR(15),
SALARY integer
);

CREATE TABLE CERTIFIED (
EID INTEGER NOT NULL,
AID INTEGER NOT NULL,
PRIMARY KEY (EID, AID),
FOREIGN KEY (EID) REFERENCES EMPLOYEES (EID),
FOREIGN KEY (AID) REFERENCES AIRCRAFT (AID)
);

insert into aircraft values (101,'747',3000), (102,'Boeing',900), (103,'647',800), (104,'Dreamliner',10000), (105,'Boeing',3500), (106,'707',1500), (107,'Dream', 120000);

insert into employees values (701,'A',50000), (702,'B',100000), (703,'C',150000), (704,'D',90000), (705,'E',40000), (706,'F',60000), (707,'G',90000);

insert into certified values(701,101), (701,102), (701,106), (701,105), (702,104), (703,104), (704,104), (702,107), (703,107), (704,107), (702,101), (703,105), (704,105), (705,103);

insert into flights values (101,'Bangalore','Delhi',2500,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP '2005-05-13 17:15:31',5000), (102,'Bangalore','Lucknow',3000,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP '2005-05-13 11:15:31',6000), (103,'Lucknow','Delhi',500,TIMESTAMP '2005-05-13 12:15:31',TIMESTAMP ' 2005-05-13 17:15:31',3000), (107,'Bangalore','Frankfurt',8000,TIMESTAMP '2005-05-13  07:15:31',TIMESTAMP '2005-05-13 22:15:31',60000), (104,'Bangalore','Frankfurt',8500,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP '2005-05-13 23:15:31',75000), (105,'Kolkata','Delhi',3400,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP  '2005-05-13 09:15:31',7000);

#1
select distinct a.aname
from aircraft a, employees e, certified c 
where e.salary > 80000
and e.eid = c.eid
and c.aid = a.aid;

#2
select c.eid, max(a.cruisingrange)
from aircraft a, certified c
where a.aid = c.aid
group by c.eid
having count(c.aid) > 3;

#3
SELECT DISTINCT E.ename
FROM Employees E
WHERE E.salary < ( 
			SELECT MIN(F.price)
			FROM Flights F
			WHERE F.ffrom = "Bangalore" AND F.tto = "Frankfurt"
            );

#4
select a.aname, avg(e.salary)
from aircraft a, certified c, employees e 
where cruisingrange > 1000
and a.aid = c.aid
and e.eid = c.eid
group by a.aname;

#5
SELECT DISTINCT E.ename
FROM Employees E, Certified C, Aircraft A
WHERE E.eid = C.eid AND C.aid = A.aid AND A.aname LIKE "Boeing%";

#6
SELECT A.aid
FROM Aircraft A
WHERE A.cruisingrange > ( 
			SELECT MIN(F.distance)
			FROM Flights F
			WHERE F.ffrom = "Bangalore" AND F.tto = "Frankfurt"
            );

#7
SELECT F.departs
FROM Flights F
WHERE F.flno IN ( ( SELECT F0.flno
 FROM Flights F0
 WHERE F0.ffrom = "Bangalore" AND F0.tto = "Delhi"
 AND extract(hour from F0.arrives) < 18 )
 UNION
( SELECT F0.flno
 FROM Flights F0, Flights F1
 WHERE F0.ffrom = "Bangalore" AND F0.tto <> "Delhi"
 AND F0.tto = F1.ffrom AND F1.tto = "Delhi"
 AND F1.departs > F0.arrives
 AND extract(hour from F1.arrives) < 18)
 UNION
( SELECT F0.flno
 FROM Flights F0, Flights F1, Flights F2
 WHERE F0.ffrom = "Bangalore"
 AND F0.tto = F1.ffrom
 AND F1.tto = F2.ffrom
 AND F2.tto = "Delhi"
 AND F0.tto <> "Delhi"
 AND F1.tto <> "Delhi"
 AND F1.departs > F0.arrives
 AND F2.departs > F1.arrives
 AND extract(hour from F2.arrives) < 18));

#8
SELECT E.ename, E.salary
FROM Employees E
WHERE E.eid NOT IN ( SELECT DISTINCT C.eid
 FROM Certified C )
AND E.salary >( SELECT AVG (E1.salary)
 FROM Employees E1
 WHERE E1.eid IN
( SELECT DISTINCT C1.eid
 FROM Certified C1 ) );
