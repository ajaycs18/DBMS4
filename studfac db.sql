use studentDB;

create table student (
	snum integer primary key,
    sname varchar(20),
    major varchar(20),
    lvl varchar(20),
    age integer
);

create table class (
	cname varchar(20) primary key,
    meets_at time,
    room varchar(20),
    fid integer
);
alter table class 
add constraint 
foreign key (fid) references faculty(fid);

create table enrolled (
	snum integer,
	cname varchar(20),
    primary key (snum, cname),
    foreign key (snum) references student(snum),
    foreign key (cname) references class(cname)
);

create table faculty (
	fid integer primary key,
    fname varchar(20),
    deptid integer
);	

INSERT INTO student VALUES 
	(1, 'jhon', 'CS', 'Sr', 19), 
	(2, 'Smith', 'CS', 'Jr', 20), 
	(3, 'Jacob', 'CV', 'Sr', 20), 
    (4, 'Tom ', 'CS', 'Jr', 20), 
    (5, 'Rahul', 'CS', 'Jr', 20), 
    (6, 'Rita', 'CS', 'Sr', 21)
;

INSERT INTO faculty VALUES
	(11, 'Harish', 1000),
	(12, 'MV', 1000),
	(13 , 'Mira', 1001),
	(14, 'Shiva', 1002),
	(15, 'Nupur', 1000)
;

INSERT INTO class VALUES 
	('class1', '12/11/15 10:15:16', 'R1', 14),
    ('class10', '12/11/15 10:15:16', 'R128', 14),
    ('class2', '12/11/15 10:15:20', 'R2', 12),
    ('class3', '12/11/15 10:15:25', 'R3', 11),
    ('class4', '12/11/15 20:15:20', 'R4', 14),
    ('class5', '12/11/15 20:15:20', 'R3', 15),
    ('class6', '12/11/15 13:20:20', 'R2', 14),
    ('class7', '12/11/15 10:10:10', 'R3', 14)
;

INSERT INTO enrolled VALUES 
	(1, 'class1'),
    (2, 'class1'),
    (3, 'class3'),
    (4, 'class3'),
    (5, 'class4'),
    (2, 'class5'),
    (3, 'class5'),
    (4, 'class5'),
    (5, 'class5'),
    (1, 'class5')
;

# 1
SELECT s.sname 
FROM  student s, faculty f, class c, enrolled e
WHERE f.fid = c.fid 
AND c.cname = e.cname
AND e.snum = s.snum
AND f.fname = 'Harish'
AND s.lvl = 'Jr';

#2
SELECT cname
FROM class 
WHERE room = 'R128'
OR cname in (
	SELECT cname
	FROM enrolled 
    GROUP BY cname
    HAVING COUNT(*) >= 5
);

#3
SELECT DISTINCT sname
FROM student s, class c1, class c2, enrolled e1, enrolled e2
WHERE s.snum = e1.snum
AND e2.snum = e1.snum
AND e1.cname = c1.cname
AND e2.cname = c2.cname
AND c1.cname != c2.cname
AND c1.meets_at = c2.meets_at;

#4
SELECT f.fname
FROM faculty f
WHERE (select count(distinct room) from class) = (select count(*) from class c where c.fid = f.fid);

#5
SELECT f.fname
FROM faculty f
WHERE (select COUNT(e.snum) from class c, enrolled e where c.fid = f.fid and c.cname = e.cname) < 5;

#6
SELECT s.sname
FROM student s
WHERE s.snum NOT IN (select e.snum from enrolled e);

#7
SELECT S.age, S.lvl
FROM student S
GROUP BY S.age, S.lvl
HAVING S.lvl IN ( 
				SELECT S1.lvl FROM student S1
				WHERE S1.age = S.age
				GROUP BY S1.lvl, S1.age
				HAVING COUNT (*) >= ALL (
					SELECT COUNT (*)
					FROM student S2
					WHERE S1.age = S2.age
					GROUP BY S2.lvl, S2.age);
