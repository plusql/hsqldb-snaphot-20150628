/*s*/DROP tmptbl1 IF EXISTS;
/*s*/DROP tmptbl2 IF EXISTS;
/*s*/DROP user altuser1;
/*s*/DROP user altuser2;

CREATE USER altuser1 PASSWORD password;
CREATE USER altuser2 PASSWORD password;
/*u0*/GRANT CHANGE_AUTHORIZATION TO altuser1;
/*u0*/GRANT CHANGE_AUTHORIZATION TO altuser2;
/*u0*/CREATE TEMP TABLE tmptbl1 (i int);
/*u0*/CREATE TEMP TABLE tmptbl2 (i int);
/*u0*/GRANT ALL ON tmptbl1 TO altuser1;
/*u0*/GRANT ALL ON tmptbl2 TO altuser1;
SET AUTOCOMMIT false;
/*u1*/INSERT INTO tmptbl1 VALUES(1);
/*u1*/INSERT INTO tmptbl1 VALUES(2);
/*c2*/SELECT * FROM tmptbl1;
COMMIT;
/*u1*/INSERT INTO tmptbl2 VALUES(1);
/*u1*/INSERT INTO tmptbl2 VALUES(2);
/*c0*/SELECT * FROM tmptbl1;
/*c2*/SELECT * FROM tmptbl2;
COMMIT;

CONNECT USER altuser1 PASSWORD password;
/*c0*/SELECT * FROM tmptbl1;
/*c0*/SELECT * FROM tmptbl2;
COMMIT;

CONNECT USER altuser2 PASSWORD password;
/*e*/SELECT * FROM tmptbl1;
/*e*/SELECT * FROM tmptbl2;
CONNECT USER SA password "";
SHUTDOWN IMMEDIATELY;
