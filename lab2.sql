create database lab2;
use lab2;

create table BRANCH(
branch_name varchar(30),
branch_city varchar(30),
assets REAL
);

alter table BRANCH add primary key(branch_name);

create table ACCOUNTS(
accno int,
branch_name varchar(30),
balance REAL,
primary key(accno),
foreign key(branch_name)references BRANCH(branch_name));

create table DEPOSITOR(
customer_name varchar(30),
accno int,
primary key(accno),
foreign key(customer_name) references CUSTOMER(customer_name)
);

drop table DEPOSITOR;

alter table DEPOSITOR drop constraint customer_name;

create table LOAN(
loan_number int,
branch_name varchar(30),
amount real,
primary key(loan_number),
foreign key(branch_name) references BRANCH(branch_name)
);

create table CUSTOMER(
customer_name varchar(30),
cutomer_street varchar(30),
customer_city varchar(30),
primary key(customer_name)
);

insert into BRANCH values ('SBI-BLR', 'Bangalore', 17.89);
insert into BRANCH values ('SBI-MUM', 'Mumbai', 19.65);
insert into BRANCH values ('SBI-KOL', 'Kolkata', 10.20);
insert into BRANCH values ('SBI-DEL', 'Delhi', 164.52);
insert into BRANCH values ('SBI-CHE', 'Chennai', 52.2);

insert into ACCOUNTS values (1, 'SBI-BLR', 100.0);
insert into ACCOUNTS values (2, 'SBI-MUM', 120.0);
insert into ACCOUNTS values (3, 'SBI-KOL', 360.0);
insert into ACCOUNTS values (4, 'SBI-DEL', 200.0);
insert into ACCOUNTS values (5, 'SBI-CHE', 150.0);

insert into DEPOSITOR values ('Ajay', 1);
insert into DEPOSITOR values ('Jack', 2);
insert into DEPOSITOR values ('John', 3);
insert into DEPOSITOR values ('Sam', 4);
insert into DEPOSITOR values ('Mike', 5);

insert into LOAN values (1, 'SBI-BLR', 10.2);
insert into LOAN values (2, 'SBI-MUM', 12.2);
insert into LOAN values (3, 'SBI-KOL', 16.4);
insert into LOAN values (4, 'SBI-DEL', 20.8);
insert into LOAN values (5, 'SBI-CHE', 50.4);

insert into CUSTOMER values ('Ajay', 'street1', 'Bangalore');
insert into CUSTOMER values ('Jack', 'street2', 'Mumbai');
insert into CUSTOMER values ('John', 'street3', 'Kolkata');
insert into CUSTOMER values ('Sam', 'street4', 'Delhi');
insert into CUSTOMER values ('Mike', 'street5', 'Chennai');
