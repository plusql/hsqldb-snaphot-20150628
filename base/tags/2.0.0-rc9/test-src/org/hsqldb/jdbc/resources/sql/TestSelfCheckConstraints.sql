DROP TABLE "Tab" IF EXISTS;
DROP TABLE TC0 IF EXISTS;
DROP TABLE TC1 IF EXISTS;
DROP TABLE TC2 IF EXISTS;
DROP TABLE TC3 IF EXISTS;
DROP TABLE TC4 IF EXISTS;
DROP TABLE TC5 IF EXISTS;
CREATE TABLE "TAB"("a" INT, "b" INT, "c" INT, CONSTRAINT CC CHECK("a" > "b" AND "b">"c"));
/*e*/INSERT INTO TAB VALUES(null,2,3);
INSERT INTO TAB VALUES(2,1,null);
INSERT INTO TAB VALUES(NULL,2,NULL);
INSERT INTO TAB VALUES(NULL,NULL,NULL);
/*e*/ALTER TABLE TAB DROP COLUMN "b";
ALTER TABLE TAB DROP CONSTRAINT CC;
ALTER TABLE TAB ADD CONSTRAINT CC CHECK ("b" > 0);
ALTER TABLE TAB DROP COLUMN "b"
--

CREATE TABLE TC0(A INT, B INT, C INT, CHECK(A > B AND B>C));
CREATE TABLE TC1(A CHAR(10), B CHAR(10), C CHAR(10), CHECK(TRIM(BOTH '*' FROM A) > TRIM(LEADING FROM B)));
CREATE TABLE TC2(A CHAR(10), B CHAR(10), C CHAR(10), CHECK(TRIM(TRAILING '*' FROM A) > UPPER(B)));
CREATE TABLE TC3(A CHAR(10), B CHAR(10), C CHAR(10), CHECK(A LIKE B ESCAPE ';' AND B LIKE 'test%'));
CREATE TABLE TC4(A CHAR(10), B CHAR(10), C CHAR(10), D INT, CHECK(SUBSTRING(A FROM D FOR 3) LIKE C ESCAPE ';'));
CREATE TABLE TC5(A CHAR(10), B CHAR(10), C CHAR(10), D INT, CHECK(A IN (B,C, 'Sunday', 'Monday')));
INSERT INTO TC5(A,C) VALUES ('Sunday', null);
INSERT INTO TC5(A,C) VALUES ('Today', 'Today');
INSERT INTO TC5(A,C) VALUES ('Tomorrow', 'Tomorrow');
/*e*/INSERT INTO TC5(A,C) VALUES ('Yesterday', 'Tomorrow');
INSERT INTO TC5(A,C) VALUES (null, null);
/*c4*/SELECT * FROM TC5;
ALTER TABLE TC5 DROP COLUMN D
/*c4*/SELECT * FROM TC5;
INSERT INTO TC5(A) VALUES ('Monday');
UPDATE TC5 SET A='Monday' WHERE B IS NULL;
/*e*/INSERT INTO TC5(A,C) VALUES ('Yesterday', 'Tomorrow');
/*e*/CREATE TABLE TC6(A CHAR, B CHAR, C CHAR, D INT, CHECK(A IN (SELECT A FROM TC5)));
CREATE TABLE TC6(A INT, CHECK(A IS NULL OR A > 1));
INSERT INTO TC6(A) VALUES (2);
INSERT INTO TC6(A) VALUES (null);
/*e*/INSERT INTO TC6(A) VALUES (0);
CREATE TABLE TC7(A INT, B TIMESTAMP, CONSTRAINT CH1 CHECK(B > CURRENT_TIMESTAMP));
INSERT INTO TC7 VALUES (10, '2015-01-01 12:00:00');
/*e*/INSERT INTO TC7 VALUES (10, '2004-01-01 12:00:00');
INSERT INTO TC7 VALUES (11, NULL);
SCRIPT
-- some type conversion tests
ALTER TABLE TC7 ALTER COLUMN A DECIMAL(6,2);
/*e*/ALTER TABLE TC7 ALTER COLUMN B DATE;
/*r
 10.00,2015-01-01 12:00:00.000000
 11.00,NULL
*/SELECT * FROM TC7 ORDER BY A;
ALTER TABLE TC7 DROP CONSTRAINT CH1;
ALTER TABLE TC7 ALTER COLUMN B DATE;
/*r
 10.00,2015-01-01
 11.00,NULL
*/SELECT * FROM TC7 ORDER BY A;
CREATE TABLE TST(A VARCHAR(10),B VARCHAR(10),C VARCHAR(10))
INSERT INTO TST VALUES ('A','B','C');
INSERT INTO TST VALUES (NULL,NULL,NULL);
ALTER TABLE TST ADD CONSTRAINT K1 CHECK (CASE WHEN (A IS NULL) THEN
 ((B IS NULL) AND (C IS NULL)) ELSE TRUE END )
/*e*/INSERT INTO TST VALUES (NULL,'B','C');
INSERT INTO TST VALUES (NULL,NULL,NULL);



