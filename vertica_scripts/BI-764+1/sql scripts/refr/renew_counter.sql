\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_Counter where ID = 0;
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/Counter.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/Counter.rej'
exceptions '/autons/vertica/web_analitik_run/Counter.exc' direct skip 1;

truncate table DataPrime.ECom_Counter;
insert into DataPrime.ECom_Counter
select
    *
from tmp_local;
commit;
