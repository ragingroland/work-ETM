\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_TrafficSource where ID = 0;
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/TrafficSource.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/TrafficSource.rej'
exceptions '/autons/vertica/web_analitik_run/TrafficSource.exc' direct skip 1;

truncate table DataPrime.ECom_TrafficSource;
insert into DataPrime.ECom_TrafficSource
select
    *
from tmp_local;
commit;
