--
-- TestSelf.txt
--

-- TestSelf.txt is used by TestSelf.java to test the database
--
-- Comment lines must start with -- and are ignored
-- Lines starting with spaces belongs to last line
-- Checked lines start with comments containing <tag> where <tag> is:
--   c <rows>     ResultSet expects a with <rows> rows
--   r <string>   ResultSet expected with <string> result in first row/column
--   u <count>    Update count <count> expected
--   e            Exception must occur

-- Miscelaneous tests by fredt
-- bug #897591
/*rgood*/CALL CASEWHEN(CURTIME() BETWEEN CAST('00:00:00'  AS  TIME) AND CAST('23:59:59'  AS TIME), 'good', 'bad')

-- Referential integrity with cascading delete
-- identity column
create table main(id int identity,name varchar(10))
create table ref(id int identity,idMain int,
  foreign key(idMain)references main(id) on delete cascade)
create table ref2(id int identity,idMain int,
  foreign key(idMain)references ref(id) on delete cascade)
/*u1*/  insert into main values(null,'test')
/*e*/   insert into ref values(null,2)
/*u1*/  insert into ref values(null,0)
/*u1*/  insert into main values(10,1)
-- next main.id value should be 11
/*u1*/  insert into main values(null,1)
/*u1*/  insert into ref values(null,11)
/*e*/   insert into ref values(null,12)
/*u1*/  insert into ref2 values(null,1)
/*u3*/  delete from main
/*c0*/  select * from main
/*c0*/  select * from ref
/*c0*/  select * from ref2
/*u1*/  insert into main values(1,'test')
/*u1*/  insert into main values(2,'test2')
/*u1*/  insert into ref values(2,2)
/*e*/   update main set id=2-id
/*e*/   drop table main;drop table ref; drop table ref2
drop table ref2;drop table ref;drop table main

-- Data Definition
create table T1(Nr integer)
create table T2(Nr integer primary Key)
create table T3(Nr integer,dbl double,vc varchar(10),cc char(1))
create table T4(nr integer,lvc longVarChar(100),dt date,tm time)
create table T5(dec decimal(10) primary key,b binary(1) not null)
create table "T6"("x" tinyint,s smallint not null,b bigint)
create table t7("-x's'-" real,f float(2),n numeric,t timestamp)
create table t8(bin binary,vb varbinary(10),lvb longvarbinary(100))
create table t9(nr integer not null,x smallint not null primary key)
create unique index it1 on t1(nr)
script
create index it2 on t2(nr)
create index it3 on t3(nr,dbl,vc,cc)
create unique index it4 on t4(nr,lvc,tm)
drop index it4
create unique index it4 on t4(nr,tm)
drop index it4
create index it4 on t4(tm,nr)
-- a duplicate index
create index it4b on t4(tm,nr)
create unique index it4c on t4(tm,nr)
drop index it4b
create index it9 on t9(nr,x);
drop table t1;drop table t2;drop table "T3";
DROP TABLE T4;Drop Table T5; drop table T6
drop table t7; drop table t8; drop table t9
create user "test" password "test-p"
GRANT CHANGE_AUTHORIZATION TO "test"
create table test (id integer)
revoke all on test from "test" restrict
select * from test order by test.id
grant all on test to "test"
grant select on test to "test"
revoke select,insert,update,delete on test from "test" restrict
connect user "test" password "test-p"
set password "test-p2"
connect user sa password ""
connect user "test" password "test-p2"
connect user sa password ""
set autocommit false
insert into test values (1)
update test set id = 3
rollback
insert into test values (2)
delete from test
rollback
commit
script
drop table test
drop user "test"
script
set autocommit true
create memory table test (id integer)
drop table test
-- still supporting noise word "null" after type definition
create cached table test (id integer null)
drop table test
-- Data Manipulation without result
create table address(nr integer,name varchar(16),placezip smallint)
insert into address values(1,'Boss',3000)
insert into address (nr,name,placezip) values(2,'Walt',8000)
insert into address values(-3,'',0)
insert into address select * from address where nr>0
update address set nr=4 where nr=-2
insert into address values(3,'x',3000)
insert into address (name,nr,placezip) values('y',4,8000)
insert into address (name,nr,placezip)
  select name,placezip,nr from address where name like 'x%'
delete from address where name like 'x%'
update address set name='Rene' where nr=4
update address set nr=5, name='What' where nr=1 and name='Boss'
create table place(zip smallint,name longvarchar(100),country char(4))
insert into place values(3000,'Langenthal\t1','CH')
insert into place values(0,'\\\\Heaven',null)
insert into place values(8000,'Z�rich','CH')
insert into place values(-1,'NULL','null')
create table invoice(addressnr integer,total decimal)
insert into invoice values(4,1003834.05)
insert into invoice values(2,-4987770.01)
insert into invoice select * from invoice where not total>=0.
update invoice set total=10 where total < 0
insert into invoice values(2,10)
set schema INFORMATION_SCHEMA
select * from system_tables
select * from SYSTEM_SESSIONINFO
set schema PUBLIC
create table t_double(id integer,d double,f double)
insert into t_double values(1,1.2,1.4)
insert into t_double values(2,1.4,1.0)
create table t_date (id integer,d date,t time,ts timestamp )
insert into t_DATE values(0,{d '1999-08-21'},'18:53:00',null)
insert into t_date values(1,'1999-08-22','17:00:01','2000-02-29 10:00:00')
create table t_bit (b1 boolean,b2 boolean)
insert into t_bit values(false,false)
insert into t_bit select b2,b1 from t_bit
insert into t_bit values(true,false)
insert into t_bit values(true,true)
create table Problem(Nr bigint,ClassNr bigint,StateNr bigint,Name varchar(40));
create table Class(Nr bigint, Name varchar(20), Node varchar(20));
insert into Problem values(10, 1, 3, 'Problem 10; Class 1; State 3');
insert into Problem values(20, 2, 2, 'Problem 20; Class 2; State 2');
insert into Problem values(30, 3, 2, 'Problem 30; Class 3; State 2');
insert into Class values(1, 'Class/State 1','Node A');
insert into Class values(2, 'Class/State 2','Node B');
insert into Class values(3, 'Class/State 3','Node C');
CREATE CACHED TABLE HLO(NRO INTEGER,NIMI VARCHAR(10),PTMP INTEGER)
CREATE INDEX INRO ON HLO(NRO)
INSERT INTO HLO VALUES(1,'hlo 1',0)
INSERT INTO HLO VALUES(2,'hlo 2',0)
INSERT INTO HLO VALUES(3,'hlo 3',0)
INSERT INTO HLO VALUES(4,'hlo 4',0)
INSERT INTO HLO VALUES(5,'hlo 5',0)
insert into hlo values(10,'10',0);
delete from hlo where nro=10;
DROP TABLE HLO

-- Select with update count
/*c6*/ select * from address
/*c0*/ select * from address where nr in(-1)
/*c4*/ select * from place
/*c4*/ select * from invoice
/*c1*/ select nr from address where nr<0
/*c0*/ select * from address where nr>=0 and nr<=0
/*c1*/ select count(*) from address where nr=-99
/*c0*/ select * from address where not name like '%'
/*c1*/ select * from address,place p where (nr=4) and p.zip=placezip
/*c1*/ select * from address,place p where (nr=4 or nr>3 and nr<2) and
  p.zip=placezip or (p.zip>0 and p.zip<-1 or p.zip=-2)
/*c1*/select * from address a,place p,invoice i where
  a.placezip=p.zip and a.nr=i.addressnr and i.addressnr=4
/*c1*/ select p.zip,p.*,country from address a,place p,invoice i where
  a.placezip=p.zip and a.nr=i.addressnr and i.addressnr=4
/*c7*/ select * from address union all select * from address where nr=4
/*c1*/ select max(place.zip) x from place
/*c0*/ select * from address where name like 'Wal_' escape 'l'
/*c2*/ select * from address where name like 'Wal_' escape '+'
/*c4*/ select total as x from invoice order by addressnr desc,total asc
/*c3*/ select place.* from place where not country = 'NULL' and
  not name is null and not name is NULL and
  not name = 'null' and not country = 'NULL' order by zip
/*c3*/ select * from address where nr in (1,5,99,5,4)
/*c1*/ select * from (select * from address) as address where nr=4
-- from 1.7.2, next result no longer returns null == null
/*c5*/ select p1.country from place p1,place p2 where p1.country=p2.country
/*c1*/ select * from t_double where id>-10 and d>1.3 and d>.3
/*c2*/ select * from t_double where d>-20 or f<10.2
/*c2*/ select d,t,d from t_date where d>'1900-08-21';
/*c1*/ select d,*,d from t_date where ts>'2000-01-01 00:00:00'
/*c0*/ select t_date.*,* from t_date where t<='01:00:00'
/*c2*/ select * from t_bit where b1<=false or b2>true
/*c2*/ select * from t_bit where not(b1<=false or b2>true)
/*c2*/ select P.*, C.Name ClassName from Problem P,Class C
  where P.Nr in(10,20) and P.ClassNr=C.Nr
/*c1*/ select P.*, S.Name StateName, S.Node StateNode,
  C.Name ClassName, C.Node ClassNode from Problem P, Class S, Class C
  where P.Nr = 10 and P.ClassNr = C.Nr and P.StateNr = S.Nr

-- ResultSet with value
/*u0*/ create table empty(c char);

/*u0*/ create table test(nr integer,name char(5));
/*r0*/ select count(*) from test;
/*u1*/ insert into test values(1,null);
/*r1*/ select nr from test group by nr;
/*r2*/ update test set nr=2;select avg(nr) from test
/*r3*/ update test set nr=1+1*2;select sum(nr) from test
/*r-3*/ update test set nr=-(select max(t2.nr) from test t2);select nr from test
/*r4*/ update test set nr=2*(1- -1);select nr from test
/*r4*/ select sum(nr) from test where nr in(select t2.nr from test t2)
/*e*/ update test set nr=1/0
update test set nr=null;
/*rNULL*/ select nr from test
update test set nr=null;
/*rNULL*/ select nr from test
/*r2*/ update test set nr=4/2;select "TEST"."NR" from test
/*r34   */ update test set name='3' || '4';select distinct name from test
/*rHo*/ select 'Ho' as hhoo from TEsT where name in ('34','y','z')
/*rNULL*/ update test set name=null;select name from "TEST"
-- case sensitivity tests
create table "t6"("x" char(6),s smallint not null,b bigint, c binary);
/*r0*/ select count(*) from "t6"
/*u1*/ insert into "t6" values('CaseS',100, 1000000000000, null);
/*rCaseS */ select "x" from "t6"
/*u1*/ delete from "t6"
/*u1*/ insert into "t6" values(null,100, 1000000000000, null);
/*u1*/ delete from "t6"
-- Finish
drop table address drop table place drop table invoice
drop table t_double;drop table t_date drop table t_bit
drop table problem; drop table class

-- Other tests
CREATE TABLE Address(ID INTEGER PRIMARY KEY,organization VARCHAR(20),
  address1 VARCHAR(20),address2 VARCHAR(20),address3 VARCHAR(20),city VARCHAR(20),
  state VARCHAR(20),zipCode VARCHAR(20),countryID INTEGER,phone VARCHAR(20),
  phoneExtension VARCHAR(20),fax VARCHAR(20),eMail VARCHAR(20))
CREATE TABLE Country(ID INTEGER PRIMARY KEY,name VARCHAR(20))
INSERT INTO COUNTRY(ID, name) VALUES(23, 'USA')
INSERT INTO ADDRESS(ID, countryID) VALUES(5,
  (SELECT ID FROM Country WHERE name = 'USA'))
SELECT * FROM ADDRESS INNER JOIN COUNTRY ON CountryID = COUNTRY.ID
SELECT * FROM ADDRESS LEFT JOIN COUNTRY ON CountryID = COUNTRY.ID
INSERT INTO ADDRESS(ID) VALUES(6)
/*c1*/SELECT * FROM ADDRESS ad INNER JOIN COUNTRY ON ad.CountryID = COUNTRY.ID
/*c2*/SELECT * FROM ADDRESS LEFT JOIN COUNTRY ON CountryID = COUNTRY.ID
SELECT * FROM Address,Country
  WHERE Address.countryID=Country.ID AND
  EXISTS (SELECT C.Name FROM Country AS C WHERE C.ID=Country.ID) AND
  EXISTS (SELECT * FROM Country AS C WHERE C.ID=Address.countryID)


-- retain metadata
CREATE TABLE META_TEST( ID numeric(10), GEOX decimal(10,2), BLURB VARCHAR(50));


-- ignorecase tests
create table test_ic(name varchar_ignorecase(20))
insert into test_ic values('Hello')
insert into test_ic values('World')
/*c0*/select * from test_ic where name like 'HALLO'
/*c1*/select * from test_ic where name like 'HELLO'
/*c1*/select * from test_ic where 'HELLO' like name
/*c1*/select * from test_ic where name = 'world'
drop table test_ic

-- test maxrows
create table test_maxrows(id int)
insert into test_maxrows values(0);
insert into test_maxrows select id+1 from test_maxrows;
insert into test_maxrows select id+2 from test_maxrows;
insert into test_maxrows select id+4 from test_maxrows;
/*r
 4
 3
 2
 1
*/select id from test_maxrows order by id desc limit 4 offset 3
/*r
 4
 3
 2
 1
*/select id from test_maxrows order by id desc offset 3 fetch 4 rows only
/*r
 4
 3
*/select id from test_maxrows order by id desc limit 2 offset 3
set maxrows 3
/*c3*/select * from test_maxrows
set maxrows 3
/*c3*/select id from test_maxrows order by id desc
set maxrows 3
/*r
 7
 6
 5
*/select id from test_maxrows order by id desc
set maxrows 3
/*r
 4
 3
 2
*/select id from test_maxrows order by id desc limit 4 offset 3
set maxrows 3
/*r
 4
 3
*/select id from test_maxrows order by id desc limit 2 offset 3
set maxrows 3
/*r8*/select count(*) from test_maxrows
set maxrows 3
/*r7*/select max(id) from test_maxrows
set maxrows 3
/*c0*/select id from test_maxrows except select id from test_maxrows
set maxrows 3
/*c3*/select id from test_maxrows group by id
set maxrows 0
/*c8*/select * from test_maxrows
drop table test_maxrows

-- test functions
CREATE TABLE Product(ID INTEGER PRIMARY KEY,Name VARCHAR(255),Cost DECIMAL(10,4))
insert into product values (0,'Test',10.3444)
/*r10.34E0*/select round(cost,2) from product
/*r10.3444*/select cost from product
drop table product

-- IN (subquery)
create table A ( C1 VARCHAR(10))
create table B ( C1 VARCHAR(10))
insert into A (C1) values ('one')
insert into A (C1) values ('two')
insert into B (C1) values ('one')
/*c1*/ select * from B where C1 in (select C1 from A)
drop table A
drop table B

-- simple transactional tests
CREATE TABLE PRODUCT(ID INTEGER PRIMARY KEY,NAME VARCHAR(20),COST DECIMAL(10,4))
INSERT INTO PRODUCT VALUES(0,'Iron',5.4)
INSERT INTO PRODUCT VALUES(1,'Wood',24.8)
INSERT INTO PRODUCT VALUES(2,'Fire',24.8)
SET AUTOCOMMIT FALSE
INSERT INTO PRODUCT VALUES(3,'ERR1',0.0)
INSERT INTO PRODUCT VALUES(4,'ERR1',0.0)
DELETE FROM PRODUCT WHERE ID=2
UPDATE PRODUCT SET NAME='ERR2' WHERE NAME<>'ERR1'
/*c2*/ SELECT * FROM PRODUCT WHERE NAME='ERR1'
/*c2*/ SELECT * FROM PRODUCT WHERE NAME='ERR2'
/*c4*/ SELECT * FROM PRODUCT
ROLLBACK
/*c0*/ SELECT * FROM PRODUCT WHERE NAME='ERR1'
/*c0*/ SELECT * FROM PRODUCT WHERE NAME='ERR2'
/*c3*/ SELECT * FROM PRODUCT
SET AUTOCOMMIT TRUE
DROP TABLE PRODUCT




-- Exceptions
/*e*/ +
/*e*/ select nr from address union select nr,nr from address
/*e*/ create something
/*e*/ create index x on address (nr +
/*e*/ create table p2 (id integer primary key, id2 integer primary key)
/*e*/ create table p3 (id integer primary key + 2)
/*e*/ drop index x
/*e*/ drop all
/*e*/ create table test(nr integer); insert into test values (10 and)
/*e*/ select oh from test
/*e*/ create table test(nr integer)
/*e*/ create user 'test' password 'test';connect user 'test' password 'test';
  select * from test;
/*e*/ connect user 'sa' password ''; drop user 'test'; drop it now
/*e*/ insert into test values(1);insert into test rows
/*e*/ create unique index i1 on test(id);select * from (oh what)
/*e*/ insert into test values(2); update test set id=1;
/*e*/ select * from test where id in (1 (2) 3)
/*e*/ select o.* from test
/*e*/ select * from test where id like '0' escape 'maybe'
/*e*/ insert into test (nr and so on) values (1)
/*e*/ insert into test values (select * from test union select * from test)
/*e*/ update test set nr=1+(3+5 'x'
/*e*/ update test set nr=1.....3
/*e*/ select *.* from test
/*e*/ select * from test where id>2 and (id>3;
/*e*/ select * from test order it
/*e*/ creat unique index 1
/*e*/ select id from test where yes>2;
/*e*/ select id from test where id has 5
/*e*/ grant access
/*e*/ connect user or maybe not
/*e*/ set parameter
/*e*/ set autocommit and
/*e*/ select column as column plus
/*e*/ select * from hm
/*e*/ grant all about it
/*e*/ create table wrong(id usertype)
/*e*/ select #strange#
/*e*/ create table mem(i int)drop table mem",

-- ResultSet with sizes
drop table test;
create table test(nr integer,name char(5), other varchar(10));
/*r0*/ select count(*) from test;
insert into test values(1,null,null);
/*r1*/ select nr from test group by nr;
/*e*/ insert into test values(2,'1234567','');
/*u1*/ insert into test values(2,'12345','');
/*r12345*/ select name from test where nr=2;
/*r123  */insert into test values(3,'123',''); select name from test where nr=3;
/*r12345*/ insert into test values(4,'','12345'); select other from test where nr=4;
insert into test values(5,'','123');
/*r123*/ select other from test where nr=5;
drop table test;

DROP TABLE POS IF EXISTS
DROP TABLE DOCUMENT IF EXISTS
DROP TABLE PRODUCT IF EXISTS
DROP TABLE ADDRESS IF EXISTS
CREATE TABLE ADDRESS(ID INTEGER PRIMARY KEY,FIRSTNAME VARCHAR(255),
    LASTNAME VARCHAR(255),STREET VARCHAR(255),CITY VARCHAR(255))
CREATE TABLE PRODUCT(ID INTEGER PRIMARY KEY,NAME VARCHAR(255),COST DECIMAL)
CREATE TABLE DOCUMENT(ID INTEGER PRIMARY KEY,ADDRESSID INTEGER,TOTAL DECIMAL)
CREATE TABLE POS(DOCUMENTID INTEGER,POS INTEGER,PRODUCTID INTEGER,
    QUANTITY INTEGER,PRICE DECIMAL,
    CONSTRAINT SYSTEM_PK PRIMARY KEY(DOCUMENTID,POS))
INSERT INTO ADDRESS VALUES(0,'Laura','Steel','429 Seventh Av.','Dallas')
INSERT INTO ADDRESS VALUES(1,'Susanne','King','366 - 20th Ave.','Olten')
INSERT INTO ADDRESS VALUES(2,'Anne','Miller','20 Upland Pl.','Lyon')
INSERT INTO ADDRESS VALUES(3,'Michael','Clancy','542 Upland Pl.','San Francisco')
INSERT INTO ADDRESS VALUES(4,'Sylvia','Ringer','365 College Av.','Dallas')
INSERT INTO ADDRESS VALUES(5,'Laura','Miller','294 Seventh Av.','Paris')
INSERT INTO ADDRESS VALUES(6,'Laura','White','506 Upland Pl.','Palo Alto')
INSERT INTO ADDRESS VALUES(7,'James','Peterson','231 Upland Pl.','San Francisco')
INSERT INTO ADDRESS VALUES(8,'Andrew','Miller','288 - 20th Ave.','Seattle')
INSERT INTO ADDRESS VALUES(9,'James','Schneider','277 Seventh Av.','Berne')
INSERT INTO ADDRESS VALUES(10,'Anne','Fuller','135 Upland Pl.','Dallas')
INSERT INTO ADDRESS VALUES(11,'Julia','White','412 Upland Pl.','Chicago')
INSERT INTO ADDRESS VALUES(12,'George','Ott','381 Upland Pl.','Palo Alto')
INSERT INTO ADDRESS VALUES(13,'Laura','Ringer','38 College Av.','New York')
INSERT INTO ADDRESS VALUES(14,'Bill','Karsen','53 College Av.','Oslo')
INSERT INTO ADDRESS VALUES(15,'Bill','Clancy','319 Upland Pl.','Seattle')
INSERT INTO ADDRESS VALUES(16,'John','Fuller','195 Seventh Av.','New York')
INSERT INTO ADDRESS VALUES(17,'Laura','Ott','443 Seventh Av.','Lyon')
INSERT INTO ADDRESS VALUES(18,'Sylvia','Fuller','158 - 20th Ave.','Paris')
INSERT INTO ADDRESS VALUES(19,'Susanne','Heiniger','86 - 20th Ave.','Dallas')
INSERT INTO ADDRESS VALUES(20,'Janet','Schneider','309 - 20th Ave.','Oslo')
INSERT INTO ADDRESS VALUES(21,'Julia','Clancy','18 Seventh Av.','Seattle')
INSERT INTO ADDRESS VALUES(22,'Bill','Ott','250 - 20th Ave.','Berne')
INSERT INTO ADDRESS VALUES(23,'Julia','Heiniger','358 College Av.','Boston')
INSERT INTO ADDRESS VALUES(24,'James','Sommer','333 Upland Pl.','Olten')
INSERT INTO ADDRESS VALUES(25,'Sylvia','Steel','269 College Av.','Paris')
INSERT INTO ADDRESS VALUES(26,'James','Clancy','195 Upland Pl.','Oslo')
INSERT INTO ADDRESS VALUES(27,'Bob','Sommer','509 College Av.','Seattle')
INSERT INTO ADDRESS VALUES(28,'Susanne','White','74 - 20th Ave.','Lyon')
INSERT INTO ADDRESS VALUES(29,'Andrew','Smith','254 College Av.','New York')
INSERT INTO ADDRESS VALUES(30,'Bill','Sommer','362 - 20th Ave.','Olten')
INSERT INTO ADDRESS VALUES(31,'Bob','Ringer','371 College Av.','Olten')
INSERT INTO ADDRESS VALUES(32,'Michael','Ott','339 College Av.','Boston')
INSERT INTO ADDRESS VALUES(33,'Mary','King','491 College Av.','Oslo')
INSERT INTO ADDRESS VALUES(34,'Julia','May','33 Upland Pl.','Seattle')
INSERT INTO ADDRESS VALUES(35,'George','Karsen','412 College Av.','Chicago')
INSERT INTO ADDRESS VALUES(36,'John','Steel','276 Upland Pl.','Dallas')
INSERT INTO ADDRESS VALUES(37,'Michael','Clancy','19 Seventh Av.','Dallas')
INSERT INTO ADDRESS VALUES(38,'Andrew','Heiniger','347 College Av.','Lyon')
INSERT INTO ADDRESS VALUES(39,'Mary','Karsen','202 College Av.','Chicago')
INSERT INTO ADDRESS VALUES(40,'Susanne','Miller','440 - 20th Ave.','Dallas')
INSERT INTO ADDRESS VALUES(41,'Bill','King','546 College Av.','New York')
INSERT INTO ADDRESS VALUES(42,'Robert','Ott','503 Seventh Av.','Oslo')
INSERT INTO ADDRESS VALUES(43,'Susanne','Smith','2 Upland Pl.','Dallas')
INSERT INTO ADDRESS VALUES(44,'Sylvia','Ott','361 College Av.','New York')
INSERT INTO ADDRESS VALUES(45,'Janet','May','396 Seventh Av.','Oslo')
INSERT INTO ADDRESS VALUES(46,'Andrew','May','172 Seventh Av.','New York')
INSERT INTO ADDRESS VALUES(47,'Janet','Fuller','445 Upland Pl.','Dallas')
INSERT INTO ADDRESS VALUES(48,'Robert','White','549 Seventh Av.','San Francisco')
INSERT INTO ADDRESS VALUES(49,'George','Fuller','534 - 20th Ave.','Olten')
INSERT INTO PRODUCT VALUES(0,'Iron Iron',5.4)
INSERT INTO PRODUCT VALUES(1,'Chair Shoe',24.8)
INSERT INTO PRODUCT VALUES(2,'Telephone Clock',24.8)
INSERT INTO PRODUCT VALUES(3,'Chair Chair',25.4)
INSERT INTO PRODUCT VALUES(4,'Ice Tea Shoe',12.8)
INSERT INTO PRODUCT VALUES(5,'Clock Clock',23.6)
INSERT INTO PRODUCT VALUES(6,'Ice Tea Chair',9.8)
INSERT INTO PRODUCT VALUES(7,'Telephone Shoe',8.4)
INSERT INTO PRODUCT VALUES(8,'Ice Tea Clock',22.6)
INSERT INTO PRODUCT VALUES(9,'Clock Telephone',17.2)
INSERT INTO PRODUCT VALUES(10,'Telephone Ice Tea',20.4)
INSERT INTO PRODUCT VALUES(11,'Telephone Iron',8.8)
INSERT INTO PRODUCT VALUES(12,'Clock Ice Tea',16.8)
INSERT INTO PRODUCT VALUES(13,'Telephone Clock',18.0)
INSERT INTO PRODUCT VALUES(14,'Telephone Iron',12.4)
INSERT INTO PRODUCT VALUES(15,'Ice Tea Chair',9.4)
INSERT INTO PRODUCT VALUES(16,'Ice Tea Shoe',19.4)
INSERT INTO PRODUCT VALUES(17,'Clock Ice Tea',22.0)
INSERT INTO PRODUCT VALUES(18,'Chair Clock',17.2)
INSERT INTO PRODUCT VALUES(19,'Ice Tea Ice Tea',11.0)
INSERT INTO PRODUCT VALUES(20,'Ice Tea Telephone',20.0)
INSERT INTO PRODUCT VALUES(21,'Chair Chair',11.4)
INSERT INTO PRODUCT VALUES(22,'Iron Iron',6.6)
INSERT INTO PRODUCT VALUES(23,'Shoe Chair',7.6)
INSERT INTO PRODUCT VALUES(24,'Chair Shoe',7.2)
INSERT INTO PRODUCT VALUES(25,'Shoe Shoe',16.2)
INSERT INTO PRODUCT VALUES(26,'Shoe Shoe',25.2)
INSERT INTO PRODUCT VALUES(27,'Telephone Iron',23.0)
INSERT INTO PRODUCT VALUES(28,'Clock Iron',3.0)
INSERT INTO PRODUCT VALUES(29,'Chair Telephone',11.2)
INSERT INTO PRODUCT VALUES(30,'Shoe Iron',23.2)
INSERT INTO PRODUCT VALUES(31,'Ice Tea Telephone',4.8)
INSERT INTO PRODUCT VALUES(32,'Clock Iron',19.0)
INSERT INTO PRODUCT VALUES(33,'Iron Chair',18.2)
INSERT INTO PRODUCT VALUES(34,'Chair Iron',25.6)
INSERT INTO PRODUCT VALUES(35,'Telephone Shoe',7.6)
INSERT INTO PRODUCT VALUES(36,'Ice Tea Iron',3.2)
INSERT INTO PRODUCT VALUES(37,'Clock Shoe',9.4)
INSERT INTO PRODUCT VALUES(38,'Clock Ice Tea',21.6)
INSERT INTO PRODUCT VALUES(39,'Ice Tea Shoe',15.4)
INSERT INTO PRODUCT VALUES(40,'Shoe Clock',2.8)
INSERT INTO PRODUCT VALUES(41,'Clock Ice Tea',20.6)
INSERT INTO PRODUCT VALUES(42,'Iron Chair',19.8)
INSERT INTO PRODUCT VALUES(43,'Telephone Clock',9.4)
INSERT INTO PRODUCT VALUES(44,'Ice Tea Ice Tea',9.6)
INSERT INTO PRODUCT VALUES(45,'Iron Ice Tea',18.0)
INSERT INTO PRODUCT VALUES(46,'Ice Tea Clock',6.2)
INSERT INTO PRODUCT VALUES(47,'Ice Tea Iron',17.8)
INSERT INTO PRODUCT VALUES(48,'Clock Clock',21.0)
INSERT INTO PRODUCT VALUES(49,'Iron Iron',2.2)
INSERT INTO DOCUMENT VALUES(0,0,2607.60)
INSERT INTO DOCUMENT VALUES(1,33,1610.70)
INSERT INTO DOCUMENT VALUES(2,23,3789.00)
INSERT INTO DOCUMENT VALUES(3,21,5974.50)
INSERT INTO DOCUMENT VALUES(4,30,1953.00)
INSERT INTO DOCUMENT VALUES(5,34,4182.90)
INSERT INTO DOCUMENT VALUES(6,19,3340.20)
INSERT INTO DOCUMENT VALUES(7,26,5328.60)
INSERT INTO DOCUMENT VALUES(8,29,2675.10)
INSERT INTO DOCUMENT VALUES(9,38,6982.20)
INSERT INTO DOCUMENT VALUES(10,24,3274.50)
INSERT INTO DOCUMENT VALUES(11,24,2532.30)
INSERT INTO DOCUMENT VALUES(12,23,4578.30)
INSERT INTO DOCUMENT VALUES(13,39,7001.70)
INSERT INTO DOCUMENT VALUES(14,35,4940.40)
INSERT INTO DOCUMENT VALUES(15,39,1027.80)
INSERT INTO DOCUMENT VALUES(16,45,3657.30)
INSERT INTO DOCUMENT VALUES(17,46,3776.40)
INSERT INTO DOCUMENT VALUES(18,4,3772.80)
INSERT INTO DOCUMENT VALUES(19,9,804.30)
INSERT INTO DOCUMENT VALUES(20,19,3139.20)
INSERT INTO DOCUMENT VALUES(21,8,3740.10)
INSERT INTO DOCUMENT VALUES(22,40,2289.90)
INSERT INTO DOCUMENT VALUES(23,36,5166.60)
INSERT INTO DOCUMENT VALUES(24,15,4344.30)
INSERT INTO DOCUMENT VALUES(25,31,2054.10)
INSERT INTO DOCUMENT VALUES(26,27,4972.80)
INSERT INTO DOCUMENT VALUES(27,24,583.50)
INSERT INTO DOCUMENT VALUES(28,35,1664.40)
INSERT INTO DOCUMENT VALUES(29,46,2515.50)
INSERT INTO DOCUMENT VALUES(30,13,2117.40)
INSERT INTO DOCUMENT VALUES(31,22,2715.90)
INSERT INTO DOCUMENT VALUES(32,20,1098.60)
INSERT INTO DOCUMENT VALUES(33,40,4300.20)
INSERT INTO DOCUMENT VALUES(34,33,4290.60)
INSERT INTO DOCUMENT VALUES(35,4,3102.60)
INSERT INTO DOCUMENT VALUES(36,42,3200.10)
INSERT INTO DOCUMENT VALUES(37,39,7331.10)
INSERT INTO DOCUMENT VALUES(38,46,6373.80)
INSERT INTO DOCUMENT VALUES(39,5,1311.60)
INSERT INTO DOCUMENT VALUES(40,4,5288.40)
INSERT INTO DOCUMENT VALUES(41,19,5475.60)
INSERT INTO DOCUMENT VALUES(42,38,1436.40)
INSERT INTO DOCUMENT VALUES(43,13,4827.60)
INSERT INTO DOCUMENT VALUES(44,32,3388.20)
INSERT INTO DOCUMENT VALUES(45,42,4731.00)
INSERT INTO DOCUMENT VALUES(46,24,5827.20)
INSERT INTO DOCUMENT VALUES(47,45,2320.80)
INSERT INTO DOCUMENT VALUES(48,22,3494.70)
INSERT INTO DOCUMENT VALUES(49,32,4944.30)
INSERT INTO POS VALUES(0,0,7,12,12.60)
INSERT INTO POS VALUES(0,1,14,19,18.60)
INSERT INTO POS VALUES(0,2,47,3,26.70)
INSERT INTO POS VALUES(0,3,1,9,37.20)
INSERT INTO POS VALUES(0,4,47,1,26.70)
INSERT INTO POS VALUES(0,5,12,15,25.20)
INSERT INTO POS VALUES(0,6,16,9,29.10)
INSERT INTO POS VALUES(0,7,7,10,12.60)
INSERT INTO POS VALUES(0,8,0,23,8.10)
INSERT INTO POS VALUES(0,9,35,4,11.40)
INSERT INTO POS VALUES(0,10,4,8,19.20)
INSERT INTO POS VALUES(0,11,12,4,25.20)
INSERT INTO POS VALUES(0,12,1,11,37.20)
INSERT INTO POS VALUES(1,0,40,8,4.20)
INSERT INTO POS VALUES(1,1,0,9,8.10)
INSERT INTO POS VALUES(1,2,19,6,16.50)
INSERT INTO POS VALUES(1,3,38,8,32.40)
INSERT INTO POS VALUES(1,4,16,16,29.10)
INSERT INTO POS VALUES(1,5,25,9,24.30)
INSERT INTO POS VALUES(1,6,25,19,24.30)
INSERT INTO POS VALUES(2,0,4,18,19.20)
INSERT INTO POS VALUES(2,1,25,3,24.30)
INSERT INTO POS VALUES(2,2,11,9,13.20)
INSERT INTO POS VALUES(2,3,19,13,16.50)
INSERT INTO POS VALUES(2,4,38,18,32.40)
INSERT INTO POS VALUES(2,5,30,4,34.80)
INSERT INTO POS VALUES(2,6,43,8,14.10)
INSERT INTO POS VALUES(2,7,30,5,34.80)
INSERT INTO POS VALUES(2,8,39,2,23.10)
INSERT INTO POS VALUES(2,9,18,7,25.80)
INSERT INTO POS VALUES(2,10,49,11,3.30)
INSERT INTO POS VALUES(2,11,42,21,29.70)
INSERT INTO POS VALUES(2,12,21,15,17.10)
INSERT INTO POS VALUES(2,13,12,1,25.20)
INSERT INTO POS VALUES(2,14,48,19,31.50)
INSERT INTO POS VALUES(2,15,0,18,8.10)
INSERT INTO POS VALUES(2,16,36,24,4.80)
INSERT INTO POS VALUES(3,0,11,21,13.20)
INSERT INTO POS VALUES(3,1,1,20,37.20)
INSERT INTO POS VALUES(3,2,49,3,3.30)
INSERT INTO POS VALUES(3,3,0,22,8.10)
INSERT INTO POS VALUES(3,4,20,12,30.00)
INSERT INTO POS VALUES(3,5,30,10,34.80)
INSERT INTO POS VALUES(3,6,13,18,27.00)
INSERT INTO POS VALUES(3,7,26,4,37.80)
INSERT INTO POS VALUES(3,8,49,9,3.30)
INSERT INTO POS VALUES(3,9,29,17,16.80)
INSERT INTO POS VALUES(3,10,10,17,30.60)
INSERT INTO POS VALUES(3,11,7,11,12.60)
INSERT INTO POS VALUES(3,12,41,22,30.90)
INSERT INTO POS VALUES(3,13,41,2,30.90)
INSERT INTO POS VALUES(3,14,17,22,33.00)
INSERT INTO POS VALUES(3,15,23,18,11.40)
INSERT INTO POS VALUES(3,16,19,11,16.50)
INSERT INTO POS VALUES(3,17,30,17,34.80)
INSERT INTO POS VALUES(4,0,28,9,4.50)
INSERT INTO POS VALUES(4,1,35,15,11.40)
INSERT INTO POS VALUES(4,2,41,23,30.90)
INSERT INTO POS VALUES(4,3,23,20,11.40)
INSERT INTO POS VALUES(4,4,9,18,25.80)
INSERT INTO POS VALUES(4,5,37,24,14.10)
INSERT INTO POS VALUES(5,0,9,5,25.80)
INSERT INTO POS VALUES(5,1,9,23,25.80)
INSERT INTO POS VALUES(5,2,20,18,30.00)
INSERT INTO POS VALUES(5,3,24,12,10.80)
INSERT INTO POS VALUES(5,4,32,14,28.50)
INSERT INTO POS VALUES(5,5,46,15,9.30)
INSERT INTO POS VALUES(5,6,7,9,12.60)
INSERT INTO POS VALUES(5,7,2,4,37.20)
INSERT INTO POS VALUES(5,8,20,3,30.00)
INSERT INTO POS VALUES(5,9,37,9,14.10)
INSERT INTO POS VALUES(5,10,28,18,4.50)
INSERT INTO POS VALUES(5,11,38,23,32.40)
INSERT INTO POS VALUES(5,12,8,15,33.90)
INSERT INTO POS VALUES(5,13,18,17,25.80)
INSERT INTO POS VALUES(6,0,15,20,14.10)
INSERT INTO POS VALUES(6,1,38,21,32.40)
INSERT INTO POS VALUES(6,2,23,8,11.40)
INSERT INTO POS VALUES(6,3,30,2,34.80)
INSERT INTO POS VALUES(6,4,31,20,7.20)
INSERT INTO POS VALUES(6,5,14,20,18.60)
INSERT INTO POS VALUES(6,6,37,22,14.10)
INSERT INTO POS VALUES(6,7,26,10,37.80)
INSERT INTO POS VALUES(6,8,41,19,30.90)
INSERT INTO POS VALUES(6,9,19,2,16.50)
INSERT INTO POS VALUES(6,10,16,13,29.10)
INSERT INTO POS VALUES(6,11,44,1,14.40)
INSERT INTO POS VALUES(7,0,43,16,14.10)
INSERT INTO POS VALUES(7,1,23,12,11.40)
INSERT INTO POS VALUES(7,2,27,17,34.50)
INSERT INTO POS VALUES(7,3,30,2,34.80)
INSERT INTO POS VALUES(7,4,2,13,37.20)
INSERT INTO POS VALUES(7,5,24,10,10.80)
INSERT INTO POS VALUES(7,6,14,4,18.60)
INSERT INTO POS VALUES(7,7,2,22,37.20)
INSERT INTO POS VALUES(7,8,42,19,29.70)
INSERT INTO POS VALUES(7,9,9,21,25.80)
INSERT INTO POS VALUES(7,10,7,1,12.60)
INSERT INTO POS VALUES(7,11,19,13,16.50)
INSERT INTO POS VALUES(7,12,40,16,4.20)
INSERT INTO POS VALUES(7,13,32,23,28.50)
INSERT INTO POS VALUES(7,14,47,14,26.70)
INSERT INTO POS VALUES(7,15,24,17,10.80)
INSERT INTO POS VALUES(7,16,7,12,12.60)
INSERT INTO POS VALUES(7,17,40,1,4.20)
INSERT INTO POS VALUES(7,18,23,5,11.40)
INSERT INTO POS VALUES(8,0,34,15,38.40)
INSERT INTO POS VALUES(8,1,44,16,14.40)
INSERT INTO POS VALUES(8,2,11,8,13.20)
INSERT INTO POS VALUES(8,3,41,16,30.90)
INSERT INTO POS VALUES(8,4,15,8,14.10)
INSERT INTO POS VALUES(8,5,24,18,10.80)
INSERT INTO POS VALUES(8,6,15,19,14.10)
INSERT INTO POS VALUES(8,7,6,5,14.70)
INSERT INTO POS VALUES(8,8,38,7,32.40)
INSERT INTO POS VALUES(8,9,21,23,17.10)
INSERT INTO POS VALUES(9,0,45,8,27.00)
INSERT INTO POS VALUES(9,1,18,21,25.80)
INSERT INTO POS VALUES(9,2,29,12,16.80)
INSERT INTO POS VALUES(9,3,4,14,19.20)
INSERT INTO POS VALUES(9,4,36,16,4.80)
INSERT INTO POS VALUES(9,5,6,2,14.70)
INSERT INTO POS VALUES(9,6,18,10,25.80)
INSERT INTO POS VALUES(9,7,2,22,37.20)
INSERT INTO POS VALUES(9,8,24,11,10.80)
INSERT INTO POS VALUES(9,9,13,6,27.00)
INSERT INTO POS VALUES(9,10,38,11,32.40)
INSERT INTO POS VALUES(9,11,12,16,25.20)
INSERT INTO POS VALUES(9,12,25,23,24.30)
INSERT INTO POS VALUES(9,13,42,13,29.70)
INSERT INTO POS VALUES(9,14,15,8,14.10)
INSERT INTO POS VALUES(9,15,48,23,31.50)
INSERT INTO POS VALUES(9,16,24,10,10.80)
INSERT INTO POS VALUES(9,17,13,17,27.00)
INSERT INTO POS VALUES(9,18,3,12,38.10)
INSERT INTO POS VALUES(9,19,48,23,31.50)
INSERT INTO POS VALUES(10,0,20,1,30.00)
INSERT INTO POS VALUES(10,1,33,17,27.30)
INSERT INTO POS VALUES(10,2,7,9,12.60)
INSERT INTO POS VALUES(10,3,46,1,9.30)
INSERT INTO POS VALUES(10,4,10,24,30.60)
INSERT INTO POS VALUES(10,5,5,24,35.40)
INSERT INTO POS VALUES(10,6,18,14,25.80)
INSERT INTO POS VALUES(10,7,4,13,19.20)
INSERT INTO POS VALUES(10,8,22,11,9.90)
INSERT INTO POS VALUES(10,9,5,10,35.40)
INSERT INTO POS VALUES(11,0,45,10,27.00)
INSERT INTO POS VALUES(11,1,21,21,17.10)
INSERT INTO POS VALUES(11,2,0,3,8.10)
INSERT INTO POS VALUES(11,3,32,21,28.50)
INSERT INTO POS VALUES(11,4,47,16,26.70)
INSERT INTO POS VALUES(11,5,19,2,16.50)
INSERT INTO POS VALUES(11,6,0,12,8.10)
INSERT INTO POS VALUES(11,7,48,22,31.50)
INSERT INTO POS VALUES(11,8,20,1,30.00)
INSERT INTO POS VALUES(12,0,1,24,37.20)
INSERT INTO POS VALUES(12,1,41,19,30.90)
INSERT INTO POS VALUES(12,2,6,5,14.70)
INSERT INTO POS VALUES(12,3,0,18,8.10)
INSERT INTO POS VALUES(12,4,20,11,30.00)
INSERT INTO POS VALUES(12,5,37,17,14.10)
INSERT INTO POS VALUES(12,6,31,15,7.20)
INSERT INTO POS VALUES(12,7,48,7,31.50)
INSERT INTO POS VALUES(12,8,48,2,31.50)
INSERT INTO POS VALUES(12,9,25,22,24.30)
INSERT INTO POS VALUES(12,10,46,19,9.30)
INSERT INTO POS VALUES(12,11,28,16,4.50)
INSERT INTO POS VALUES(12,12,13,12,27.00)
INSERT INTO POS VALUES(12,13,36,21,4.80)
INSERT INTO POS VALUES(12,14,25,11,24.30)
INSERT INTO POS VALUES(12,15,22,16,9.90)
INSERT INTO POS VALUES(12,16,0,9,8.10)
INSERT INTO POS VALUES(12,17,31,15,7.20)
INSERT INTO POS VALUES(12,18,9,4,25.80)
INSERT INTO POS VALUES(13,0,16,10,29.10)
INSERT INTO POS VALUES(13,1,1,1,37.20)
INSERT INTO POS VALUES(13,2,13,20,27.00)
INSERT INTO POS VALUES(13,3,32,2,28.50)
INSERT INTO POS VALUES(13,4,26,21,37.80)
INSERT INTO POS VALUES(13,5,22,19,9.90)
INSERT INTO POS VALUES(13,6,19,8,16.50)
INSERT INTO POS VALUES(13,7,29,24,16.80)
INSERT INTO POS VALUES(13,8,48,11,31.50)
INSERT INTO POS VALUES(13,9,24,10,10.80)
INSERT INTO POS VALUES(13,10,45,24,27.00)
INSERT INTO POS VALUES(13,11,14,3,18.60)
INSERT INTO POS VALUES(13,12,17,3,33.00)
INSERT INTO POS VALUES(13,13,10,20,30.60)
INSERT INTO POS VALUES(13,14,1,12,37.20)
INSERT INTO POS VALUES(13,15,0,20,8.10)
INSERT INTO POS VALUES(13,16,22,23,9.90)
INSERT INTO POS VALUES(13,17,32,18,28.50)
INSERT INTO POS VALUES(13,18,0,16,8.10)
INSERT INTO POS VALUES(13,19,42,18,29.70)
INSERT INTO POS VALUES(13,20,5,19,35.40)
INSERT INTO POS VALUES(13,21,40,1,4.20)
INSERT INTO POS VALUES(14,0,42,18,29.70)
INSERT INTO POS VALUES(14,1,9,22,25.80)
INSERT INTO POS VALUES(14,2,15,18,14.10)
INSERT INTO POS VALUES(14,3,34,11,38.40)
INSERT INTO POS VALUES(14,4,41,17,30.90)
INSERT INTO POS VALUES(14,5,11,8,13.20)
INSERT INTO POS VALUES(14,6,26,18,37.80)
INSERT INTO POS VALUES(14,7,43,4,14.10)
INSERT INTO POS VALUES(14,8,23,7,11.40)
INSERT INTO POS VALUES(14,9,13,16,27.00)
INSERT INTO POS VALUES(14,10,44,16,14.40)
INSERT INTO POS VALUES(14,11,25,15,24.30)
INSERT INTO POS VALUES(14,12,4,20,19.20)
INSERT INTO POS VALUES(14,13,11,23,13.20)
INSERT INTO POS VALUES(15,0,17,12,33.00)
INSERT INTO POS VALUES(15,1,13,21,27.00)
INSERT INTO POS VALUES(15,2,24,6,10.80)
INSERT INTO POS VALUES(16,0,18,15,25.80)
INSERT INTO POS VALUES(16,1,36,20,4.80)
INSERT INTO POS VALUES(16,2,20,15,30.00)
INSERT INTO POS VALUES(16,3,0,3,8.10)
INSERT INTO POS VALUES(16,4,10,24,30.60)
INSERT INTO POS VALUES(16,5,11,15,13.20)
INSERT INTO POS VALUES(16,6,44,7,14.40)
INSERT INTO POS VALUES(16,7,8,17,33.90)
INSERT INTO POS VALUES(16,8,13,17,27.00)
INSERT INTO POS VALUES(16,9,11,10,13.20)
INSERT INTO POS VALUES(16,10,43,8,14.10)
INSERT INTO POS VALUES(16,11,24,7,10.80)
INSERT INTO POS VALUES(16,12,18,2,25.80)
INSERT INTO POS VALUES(16,13,20,1,30.00)
INSERT INTO POS VALUES(16,14,0,19,8.10)
INSERT INTO POS VALUES(16,15,12,3,25.20)
INSERT INTO POS VALUES(17,0,16,8,29.10)
INSERT INTO POS VALUES(17,1,19,19,16.50)
INSERT INTO POS VALUES(17,2,44,11,14.40)
INSERT INTO POS VALUES(17,3,24,4,10.80)
INSERT INTO POS VALUES(17,4,23,2,11.40)
INSERT INTO POS VALUES(17,5,44,1,14.40)
INSERT INTO POS VALUES(17,6,43,6,14.10)
INSERT INTO POS VALUES(17,7,6,15,14.70)
INSERT INTO POS VALUES(17,8,49,8,3.30)
INSERT INTO POS VALUES(17,9,8,15,33.90)
INSERT INTO POS VALUES(17,10,10,12,30.60)
INSERT INTO POS VALUES(17,11,45,10,27.00)
INSERT INTO POS VALUES(17,12,22,16,9.90)
INSERT INTO POS VALUES(17,13,41,5,30.90)
INSERT INTO POS VALUES(17,14,18,2,25.80)
INSERT INTO POS VALUES(17,15,35,10,11.40)
INSERT INTO POS VALUES(17,16,8,16,33.90)
INSERT INTO POS VALUES(17,17,7,5,12.60)
INSERT INTO POS VALUES(17,18,5,9,35.40)
INSERT INTO POS VALUES(17,19,46,12,9.30)
INSERT INTO POS VALUES(18,0,32,1,28.50)
INSERT INTO POS VALUES(18,1,33,12,27.30)
INSERT INTO POS VALUES(18,2,40,12,4.20)
INSERT INTO POS VALUES(18,3,19,8,16.50)
INSERT INTO POS VALUES(18,4,28,6,4.50)
INSERT INTO POS VALUES(18,5,15,6,14.10)
INSERT INTO POS VALUES(18,6,29,4,16.80)
INSERT INTO POS VALUES(18,7,15,14,14.10)
INSERT INTO POS VALUES(18,8,1,24,37.20)
INSERT INTO POS VALUES(18,9,2,2,37.20)
INSERT INTO POS VALUES(18,10,34,18,38.40)
INSERT INTO POS VALUES(18,11,30,8,34.80)
INSERT INTO POS VALUES(18,12,37,12,14.10)
INSERT INTO POS VALUES(18,13,14,12,18.60)
INSERT INTO POS VALUES(18,14,28,20,4.50)
INSERT INTO POS VALUES(18,15,44,20,14.40)
INSERT INTO POS VALUES(18,16,31,12,7.20)
INSERT INTO POS VALUES(18,17,8,1,33.90)
INSERT INTO POS VALUES(18,18,10,1,30.60)
INSERT INTO POS VALUES(19,0,12,7,25.20)
INSERT INTO POS VALUES(19,1,31,2,7.20)
INSERT INTO POS VALUES(19,2,4,22,19.20)
INSERT INTO POS VALUES(19,3,49,23,3.30)
INSERT INTO POS VALUES(19,4,36,24,4.80)
INSERT INTO POS VALUES(20,0,47,15,26.70)
INSERT INTO POS VALUES(20,1,29,6,16.80)
INSERT INTO POS VALUES(20,2,24,22,10.80)
INSERT INTO POS VALUES(20,3,25,14,24.30)
INSERT INTO POS VALUES(20,4,30,13,34.80)
INSERT INTO POS VALUES(20,5,8,14,33.90)
INSERT INTO POS VALUES(20,6,20,2,30.00)
INSERT INTO POS VALUES(20,7,9,9,25.80)
INSERT INTO POS VALUES(20,8,44,18,14.40)
INSERT INTO POS VALUES(20,9,12,8,25.20)
INSERT INTO POS VALUES(20,10,25,11,24.30)
INSERT INTO POS VALUES(20,11,15,8,14.10)
INSERT INTO POS VALUES(21,0,9,10,25.80)
INSERT INTO POS VALUES(21,1,38,19,32.40)
INSERT INTO POS VALUES(21,2,31,17,7.20)
INSERT INTO POS VALUES(21,3,30,13,34.80)
INSERT INTO POS VALUES(21,4,49,22,3.30)
INSERT INTO POS VALUES(21,5,27,18,34.50)
INSERT INTO POS VALUES(21,6,26,7,37.80)
INSERT INTO POS VALUES(21,7,8,9,33.90)
INSERT INTO POS VALUES(21,8,44,19,14.40)
INSERT INTO POS VALUES(21,9,35,17,11.40)
INSERT INTO POS VALUES(21,10,19,14,16.50)
INSERT INTO POS VALUES(21,11,20,11,30.00)
INSERT INTO POS VALUES(22,0,9,6,25.80)
INSERT INTO POS VALUES(22,1,30,11,34.80)
INSERT INTO POS VALUES(22,2,12,20,25.20)
INSERT INTO POS VALUES(22,3,22,5,9.90)
INSERT INTO POS VALUES(22,4,5,21,35.40)
INSERT INTO POS VALUES(22,5,24,5,10.80)
INSERT INTO POS VALUES(22,6,4,11,19.20)
INSERT INTO POS VALUES(22,7,21,6,17.10)
INSERT INTO POS VALUES(22,8,3,2,38.10)
INSERT INTO POS VALUES(22,9,23,1,11.40)
INSERT INTO POS VALUES(23,0,48,22,31.50)
INSERT INTO POS VALUES(23,1,26,8,37.80)
INSERT INTO POS VALUES(23,2,33,18,27.30)
INSERT INTO POS VALUES(23,3,40,19,4.20)
INSERT INTO POS VALUES(23,4,23,19,11.40)
INSERT INTO POS VALUES(23,5,32,14,28.50)
INSERT INTO POS VALUES(23,6,16,1,29.10)
INSERT INTO POS VALUES(23,7,39,3,23.10)
INSERT INTO POS VALUES(23,8,6,17,14.70)
INSERT INTO POS VALUES(23,9,20,18,30.00)
INSERT INTO POS VALUES(23,10,4,18,19.20)
INSERT INTO POS VALUES(23,11,41,8,30.90)
INSERT INTO POS VALUES(23,12,4,17,19.20)
INSERT INTO POS VALUES(23,13,14,17,18.60)
INSERT INTO POS VALUES(23,14,44,2,14.40)
INSERT INTO POS VALUES(23,15,13,17,27.00)
INSERT INTO POS VALUES(23,16,8,11,33.90)
INSERT INTO POS VALUES(24,0,43,14,14.10)
INSERT INTO POS VALUES(24,1,46,18,9.30)
INSERT INTO POS VALUES(24,2,38,10,32.40)
INSERT INTO POS VALUES(24,3,17,23,33.00)
INSERT INTO POS VALUES(24,4,15,17,14.10)
INSERT INTO POS VALUES(24,5,35,16,11.40)
INSERT INTO POS VALUES(24,6,40,3,4.20)
INSERT INTO POS VALUES(24,7,7,13,12.60)
INSERT INTO POS VALUES(24,8,5,18,35.40)
INSERT INTO POS VALUES(24,9,21,8,17.10)
INSERT INTO POS VALUES(24,10,27,4,34.50)
INSERT INTO POS VALUES(24,11,1,4,37.20)
INSERT INTO POS VALUES(24,12,0,8,8.10)
INSERT INTO POS VALUES(24,13,15,21,14.10)
INSERT INTO POS VALUES(24,14,1,13,37.20)
INSERT INTO POS VALUES(24,15,39,17,23.10)
INSERT INTO POS VALUES(25,0,5,15,35.40)
INSERT INTO POS VALUES(25,1,43,13,14.10)
INSERT INTO POS VALUES(25,2,13,8,27.00)
INSERT INTO POS VALUES(25,3,19,4,16.50)
INSERT INTO POS VALUES(25,4,47,10,26.70)
INSERT INTO POS VALUES(25,5,10,5,30.60)
INSERT INTO POS VALUES(25,6,21,18,17.10)
INSERT INTO POS VALUES(25,7,16,8,29.10)
INSERT INTO POS VALUES(25,8,38,3,32.40)
INSERT INTO POS VALUES(26,0,42,16,29.70)
INSERT INTO POS VALUES(26,1,43,21,14.10)
INSERT INTO POS VALUES(26,2,33,7,27.30)
INSERT INTO POS VALUES(26,3,16,3,29.10)
INSERT INTO POS VALUES(26,4,46,7,9.30)
INSERT INTO POS VALUES(26,5,38,4,32.40)
INSERT INTO POS VALUES(26,6,7,23,12.60)
INSERT INTO POS VALUES(26,7,4,16,19.20)
INSERT INTO POS VALUES(26,8,40,13,4.20)
INSERT INTO POS VALUES(26,9,1,23,37.20)
INSERT INTO POS VALUES(26,10,34,16,38.40)
INSERT INTO POS VALUES(26,11,18,3,25.80)
INSERT INTO POS VALUES(26,12,27,20,34.50)
INSERT INTO POS VALUES(26,13,13,10,27.00)
INSERT INTO POS VALUES(26,14,26,6,37.80)
INSERT INTO POS VALUES(26,15,8,6,33.90)
INSERT INTO POS VALUES(26,16,30,4,34.80)
INSERT INTO POS VALUES(27,0,24,15,10.80)
INSERT INTO POS VALUES(27,1,45,15,27.00)
INSERT INTO POS VALUES(27,2,19,1,16.50)
INSERT INTO POS VALUES(28,0,35,13,11.40)
INSERT INTO POS VALUES(28,1,15,13,14.10)
INSERT INTO POS VALUES(28,2,44,22,14.40)
INSERT INTO POS VALUES(28,3,6,3,14.70)
INSERT INTO POS VALUES(28,4,45,17,27.00)
INSERT INTO POS VALUES(28,5,49,4,3.30)
INSERT INTO POS VALUES(28,6,33,16,27.30)
INSERT INTO POS VALUES(28,7,28,8,4.50)
INSERT INTO POS VALUES(28,8,28,6,4.50)
INSERT INTO POS VALUES(29,0,33,17,27.30)
INSERT INTO POS VALUES(29,1,38,12,32.40)
INSERT INTO POS VALUES(29,2,17,23,33.00)
INSERT INTO POS VALUES(29,3,7,21,12.60)
INSERT INTO POS VALUES(29,4,4,7,19.20)
INSERT INTO POS VALUES(29,5,31,13,7.20)
INSERT INTO POS VALUES(29,6,4,16,19.20)
INSERT INTO POS VALUES(29,7,5,1,35.40)
INSERT INTO POS VALUES(29,8,35,6,11.40)
INSERT INTO POS VALUES(30,0,14,7,18.60)
INSERT INTO POS VALUES(30,1,16,19,29.10)
INSERT INTO POS VALUES(30,2,10,18,30.60)
INSERT INTO POS VALUES(30,3,33,2,27.30)
INSERT INTO POS VALUES(30,4,34,2,38.40)
INSERT INTO POS VALUES(30,5,43,23,14.10)
INSERT INTO POS VALUES(30,6,14,23,18.60)
INSERT INTO POS VALUES(31,0,33,10,27.30)
INSERT INTO POS VALUES(31,1,4,23,19.20)
INSERT INTO POS VALUES(31,2,4,3,19.20)
INSERT INTO POS VALUES(31,3,12,10,25.20)
INSERT INTO POS VALUES(31,4,8,14,33.90)
INSERT INTO POS VALUES(31,5,1,4,37.20)
INSERT INTO POS VALUES(31,6,26,16,37.80)
INSERT INTO POS VALUES(31,7,38,3,32.40)
INSERT INTO POS VALUES(31,8,7,5,12.60)
INSERT INTO POS VALUES(31,9,14,15,18.60)
INSERT INTO POS VALUES(31,10,0,3,8.10)
INSERT INTO POS VALUES(32,0,35,11,11.40)
INSERT INTO POS VALUES(32,1,30,13,34.80)
INSERT INTO POS VALUES(32,2,1,14,37.20)
INSERT INTO POS VALUES(33,0,36,5,4.80)
INSERT INTO POS VALUES(33,1,10,21,30.60)
INSERT INTO POS VALUES(33,2,36,16,4.80)
INSERT INTO POS VALUES(33,3,48,1,31.50)
INSERT INTO POS VALUES(33,4,24,1,10.80)
INSERT INTO POS VALUES(33,5,8,11,33.90)
INSERT INTO POS VALUES(33,6,17,16,33.00)
INSERT INTO POS VALUES(33,7,43,10,14.10)
INSERT INTO POS VALUES(33,8,3,15,38.10)
INSERT INTO POS VALUES(33,9,29,5,16.80)
INSERT INTO POS VALUES(33,10,24,9,10.80)
INSERT INTO POS VALUES(33,11,5,7,35.40)
INSERT INTO POS VALUES(33,12,16,23,29.10)
INSERT INTO POS VALUES(33,13,25,16,24.30)
INSERT INTO POS VALUES(33,14,44,13,14.40)
INSERT INTO POS VALUES(33,15,38,7,32.40)
INSERT INTO POS VALUES(34,0,10,22,30.60)
INSERT INTO POS VALUES(34,1,4,3,19.20)
INSERT INTO POS VALUES(34,2,28,22,4.50)
INSERT INTO POS VALUES(34,3,44,15,14.40)
INSERT INTO POS VALUES(34,4,27,1,34.50)
INSERT INTO POS VALUES(34,5,45,13,27.00)
INSERT INTO POS VALUES(34,6,32,7,28.50)
INSERT INTO POS VALUES(34,7,21,22,17.10)
INSERT INTO POS VALUES(34,8,3,1,38.10)
INSERT INTO POS VALUES(34,9,8,17,33.90)
INSERT INTO POS VALUES(34,10,41,16,30.90)
INSERT INTO POS VALUES(34,11,4,17,19.20)
INSERT INTO POS VALUES(34,12,43,21,14.10)
INSERT INTO POS VALUES(34,13,30,14,34.80)
INSERT INTO POS VALUES(34,14,46,7,9.30)
INSERT INTO POS VALUES(35,0,20,17,30.00)
INSERT INTO POS VALUES(35,1,3,9,38.10)
INSERT INTO POS VALUES(35,2,14,4,18.60)
INSERT INTO POS VALUES(35,3,27,10,34.50)
INSERT INTO POS VALUES(35,4,14,17,18.60)
INSERT INTO POS VALUES(35,5,33,5,27.30)
INSERT INTO POS VALUES(35,6,5,4,35.40)
INSERT INTO POS VALUES(35,7,22,15,9.90)
INSERT INTO POS VALUES(35,8,0,1,8.10)
INSERT INTO POS VALUES(35,9,19,1,16.50)
INSERT INTO POS VALUES(35,10,17,11,33.00)
INSERT INTO POS VALUES(35,11,44,9,14.40)
INSERT INTO POS VALUES(35,12,7,23,12.60)
INSERT INTO POS VALUES(35,13,19,17,16.50)
INSERT INTO POS VALUES(36,0,18,13,25.80)
INSERT INTO POS VALUES(36,1,15,23,14.10)
INSERT INTO POS VALUES(36,2,1,6,37.20)
INSERT INTO POS VALUES(36,3,10,8,30.60)
INSERT INTO POS VALUES(36,4,40,5,4.20)
INSERT INTO POS VALUES(36,5,25,8,24.30)
INSERT INTO POS VALUES(36,6,39,20,23.10)
INSERT INTO POS VALUES(36,7,39,19,23.10)
INSERT INTO POS VALUES(36,8,4,21,19.20)
INSERT INTO POS VALUES(36,9,31,18,7.20)
INSERT INTO POS VALUES(36,10,47,11,26.70)
INSERT INTO POS VALUES(36,11,44,9,14.40)
INSERT INTO POS VALUES(37,0,41,24,30.90)
INSERT INTO POS VALUES(37,1,15,20,14.10)
INSERT INTO POS VALUES(37,2,36,8,4.80)
INSERT INTO POS VALUES(37,3,26,7,37.80)
INSERT INTO POS VALUES(37,4,13,20,27.00)
INSERT INTO POS VALUES(37,5,1,14,37.20)
INSERT INTO POS VALUES(37,6,34,12,38.40)
INSERT INTO POS VALUES(37,7,24,19,10.80)
INSERT INTO POS VALUES(37,8,46,9,9.30)
INSERT INTO POS VALUES(37,9,47,16,26.70)
INSERT INTO POS VALUES(37,10,1,18,37.20)
INSERT INTO POS VALUES(37,11,30,5,34.80)
INSERT INTO POS VALUES(37,12,24,23,10.80)
INSERT INTO POS VALUES(37,13,32,3,28.50)
INSERT INTO POS VALUES(37,14,12,3,25.20)
INSERT INTO POS VALUES(37,15,32,12,28.50)
INSERT INTO POS VALUES(37,16,27,8,34.50)
INSERT INTO POS VALUES(37,17,38,18,32.40)
INSERT INTO POS VALUES(37,18,26,22,37.80)
INSERT INTO POS VALUES(37,19,19,20,16.50)
INSERT INTO POS VALUES(37,20,14,1,18.60)
INSERT INTO POS VALUES(37,21,6,9,14.70)
INSERT INTO POS VALUES(38,0,48,14,31.50)
INSERT INTO POS VALUES(38,1,45,13,27.00)
INSERT INTO POS VALUES(38,2,4,8,19.20)
INSERT INTO POS VALUES(38,3,27,19,34.50)
INSERT INTO POS VALUES(38,4,45,14,27.00)
INSERT INTO POS VALUES(38,5,48,17,31.50)
INSERT INTO POS VALUES(38,6,5,19,35.40)
INSERT INTO POS VALUES(38,7,15,1,14.10)
INSERT INTO POS VALUES(38,8,40,10,4.20)
INSERT INTO POS VALUES(38,9,27,20,34.50)
INSERT INTO POS VALUES(38,10,4,18,19.20)
INSERT INTO POS VALUES(38,11,19,18,16.50)
INSERT INTO POS VALUES(38,12,1,18,37.20)
INSERT INTO POS VALUES(38,13,8,7,33.90)
INSERT INTO POS VALUES(38,14,20,7,30.00)
INSERT INTO POS VALUES(38,15,47,10,26.70)
INSERT INTO POS VALUES(38,16,40,18,4.20)
INSERT INTO POS VALUES(38,17,32,4,28.50)
INSERT INTO POS VALUES(38,18,28,20,4.50)
INSERT INTO POS VALUES(38,19,4,7,19.20)
INSERT INTO POS VALUES(39,0,10,12,30.60)
INSERT INTO POS VALUES(39,1,24,6,10.80)
INSERT INTO POS VALUES(39,2,39,16,23.10)
INSERT INTO POS VALUES(39,3,20,17,30.00)
INSERT INTO POS VALUES(40,0,46,24,9.30)
INSERT INTO POS VALUES(40,1,45,24,27.00)
INSERT INTO POS VALUES(40,2,4,5,19.20)
INSERT INTO POS VALUES(40,3,26,10,37.80)
INSERT INTO POS VALUES(40,4,18,13,25.80)
INSERT INTO POS VALUES(40,5,32,18,28.50)
INSERT INTO POS VALUES(40,6,28,12,4.50)
INSERT INTO POS VALUES(40,7,31,1,7.20)
INSERT INTO POS VALUES(40,8,11,4,13.20)
INSERT INTO POS VALUES(40,9,40,17,4.20)
INSERT INTO POS VALUES(40,10,6,11,14.70)
INSERT INTO POS VALUES(40,11,27,2,34.50)
INSERT INTO POS VALUES(40,12,35,13,11.40)
INSERT INTO POS VALUES(40,13,6,8,14.70)
INSERT INTO POS VALUES(40,14,4,24,19.20)
INSERT INTO POS VALUES(40,15,22,12,9.90)
INSERT INTO POS VALUES(40,16,27,16,34.50)
INSERT INTO POS VALUES(40,17,4,20,19.20)
INSERT INTO POS VALUES(40,18,33,11,27.30)
INSERT INTO POS VALUES(40,19,7,23,12.60)
INSERT INTO POS VALUES(40,20,4,16,19.20)
INSERT INTO POS VALUES(41,0,5,24,35.40)
INSERT INTO POS VALUES(41,1,47,19,26.70)
INSERT INTO POS VALUES(41,2,36,2,4.80)
INSERT INTO POS VALUES(41,3,29,20,16.80)
INSERT INTO POS VALUES(41,4,16,22,29.10)
INSERT INTO POS VALUES(41,5,9,21,25.80)
INSERT INTO POS VALUES(41,6,17,11,33.00)
INSERT INTO POS VALUES(41,7,22,18,9.90)
INSERT INTO POS VALUES(41,8,9,22,25.80)
INSERT INTO POS VALUES(41,9,26,21,37.80)
INSERT INTO POS VALUES(41,10,24,20,10.80)
INSERT INTO POS VALUES(41,11,48,15,31.50)
INSERT INTO POS VALUES(42,0,48,9,31.50)
INSERT INTO POS VALUES(42,1,18,21,25.80)
INSERT INTO POS VALUES(42,2,40,19,4.20)
INSERT INTO POS VALUES(42,3,40,14,4.20)
INSERT INTO POS VALUES(42,4,48,15,31.50)
INSERT INTO POS VALUES(43,0,15,22,14.10)
INSERT INTO POS VALUES(43,1,18,19,25.80)
INSERT INTO POS VALUES(43,2,2,15,37.20)
INSERT INTO POS VALUES(43,3,6,18,14.70)
INSERT INTO POS VALUES(43,4,32,22,28.50)
INSERT INTO POS VALUES(43,5,33,6,27.30)
INSERT INTO POS VALUES(43,6,24,1,10.80)
INSERT INTO POS VALUES(43,7,11,15,13.20)
INSERT INTO POS VALUES(43,8,44,8,14.40)
INSERT INTO POS VALUES(43,9,7,23,12.60)
INSERT INTO POS VALUES(43,10,35,1,11.40)
INSERT INTO POS VALUES(43,11,49,23,3.30)
INSERT INTO POS VALUES(43,12,40,24,4.20)
INSERT INTO POS VALUES(43,13,44,22,14.40)
INSERT INTO POS VALUES(43,14,3,18,38.10)
INSERT INTO POS VALUES(43,15,48,7,31.50)
INSERT INTO POS VALUES(43,16,38,12,32.40)
INSERT INTO POS VALUES(44,0,33,20,27.30)
INSERT INTO POS VALUES(44,1,34,17,38.40)
INSERT INTO POS VALUES(44,2,17,14,33.00)
INSERT INTO POS VALUES(44,3,3,14,38.10)
INSERT INTO POS VALUES(44,4,12,3,25.20)
INSERT INTO POS VALUES(44,5,41,22,30.90)
INSERT INTO POS VALUES(44,6,14,15,18.60)
INSERT INTO POS VALUES(44,7,49,17,3.30)
INSERT INTO POS VALUES(44,8,28,23,4.50)
INSERT INTO POS VALUES(45,0,44,6,14.40)
INSERT INTO POS VALUES(45,1,11,6,13.20)
INSERT INTO POS VALUES(45,2,46,8,9.30)
INSERT INTO POS VALUES(45,3,14,11,18.60)
INSERT INTO POS VALUES(45,4,3,14,38.10)
INSERT INTO POS VALUES(45,5,45,17,27.00)
INSERT INTO POS VALUES(45,6,39,5,23.10)
INSERT INTO POS VALUES(45,7,6,24,14.70)
INSERT INTO POS VALUES(45,8,9,2,25.80)
INSERT INTO POS VALUES(45,9,26,18,37.80)
INSERT INTO POS VALUES(45,10,41,24,30.90)
INSERT INTO POS VALUES(45,11,31,22,7.20)
INSERT INTO POS VALUES(45,12,32,13,28.50)
INSERT INTO POS VALUES(45,13,47,8,26.70)
INSERT INTO POS VALUES(45,14,3,16,38.10)
INSERT INTO POS VALUES(46,0,5,21,35.40)
INSERT INTO POS VALUES(46,1,12,24,25.20)
INSERT INTO POS VALUES(46,2,30,14,34.80)
INSERT INTO POS VALUES(46,3,21,19,17.10)
INSERT INTO POS VALUES(46,4,17,5,33.00)
INSERT INTO POS VALUES(46,5,25,9,24.30)
INSERT INTO POS VALUES(46,6,41,18,30.90)
INSERT INTO POS VALUES(46,7,49,9,3.30)
INSERT INTO POS VALUES(46,8,8,22,33.90)
INSERT INTO POS VALUES(46,9,7,4,12.60)
INSERT INTO POS VALUES(46,10,11,24,13.20)
INSERT INTO POS VALUES(46,11,1,4,37.20)
INSERT INTO POS VALUES(46,12,21,24,17.10)
INSERT INTO POS VALUES(46,13,36,20,4.80)
INSERT INTO POS VALUES(46,14,24,10,10.80)
INSERT INTO POS VALUES(46,15,40,11,4.20)
INSERT INTO POS VALUES(46,16,46,21,9.30)
INSERT INTO POS VALUES(46,17,12,23,25.20)
INSERT INTO POS VALUES(47,0,23,15,11.40)
INSERT INTO POS VALUES(47,1,23,13,11.40)
INSERT INTO POS VALUES(47,2,17,6,33.00)
INSERT INTO POS VALUES(47,3,1,4,37.20)
INSERT INTO POS VALUES(47,4,15,1,14.10)
INSERT INTO POS VALUES(47,5,40,8,4.20)
INSERT INTO POS VALUES(47,6,8,10,33.90)
INSERT INTO POS VALUES(47,7,28,14,4.50)
INSERT INTO POS VALUES(47,8,16,2,29.10)
INSERT INTO POS VALUES(47,9,32,9,28.50)
INSERT INTO POS VALUES(47,10,45,2,27.00)
INSERT INTO POS VALUES(47,11,35,10,11.40)
INSERT INTO POS VALUES(47,12,12,20,25.20)
INSERT INTO POS VALUES(47,13,33,8,27.30)
INSERT INTO POS VALUES(48,0,6,23,14.70)
INSERT INTO POS VALUES(48,1,26,23,37.80)
INSERT INTO POS VALUES(48,2,23,10,11.40)
INSERT INTO POS VALUES(48,3,10,2,30.60)
INSERT INTO POS VALUES(48,4,48,4,31.50)
INSERT INTO POS VALUES(48,5,24,16,10.80)
INSERT INTO POS VALUES(48,6,11,17,13.20)
INSERT INTO POS VALUES(48,7,30,19,34.80)
INSERT INTO POS VALUES(48,8,5,12,35.40)
INSERT INTO POS VALUES(48,9,35,17,11.40)
INSERT INTO POS VALUES(48,10,41,10,30.90)
INSERT INTO POS VALUES(49,0,18,6,25.80)
INSERT INTO POS VALUES(49,1,22,16,9.90)
INSERT INTO POS VALUES(49,2,29,6,16.80)
INSERT INTO POS VALUES(49,3,17,19,33.00)
INSERT INTO POS VALUES(49,4,47,14,26.70)
INSERT INTO POS VALUES(49,5,16,1,29.10)
INSERT INTO POS VALUES(49,6,29,15,16.80)
INSERT INTO POS VALUES(49,7,6,21,14.70)
INSERT INTO POS VALUES(49,8,48,24,31.50)
INSERT INTO POS VALUES(49,9,7,24,12.60)
INSERT INTO POS VALUES(49,10,30,16,34.80)
INSERT INTO POS VALUES(49,11,40,15,4.20)
INSERT INTO POS VALUES(49,12,21,17,17.10)
INSERT INTO POS VALUES(49,13,6,22,14.70)
INSERT INTO POS VALUES(49,14,23,5,11.40)
INSERT INTO POS VALUES(49,15,19,24,16.50)
INSERT INTO POS VALUES(49,16,24,18,10.80)
CREATE VIEW DOC_ADDR AS SELECT D.ID,D.TOTAL,A.CITY FROM DOCUMENT D, ADDRESS A
    WHERE D.ADDRESSID=A.ID AND A.ID < 10
/*c88*/SELECT * FROM DOC_ADDR D, POS P WHERE P.DOCUMENTID = D.ID



