\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_AdType where ID = 0;
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/AdType.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/AdType.rej'
exceptions '/autons/vertica/web_analitik_run/AdType.exc' direct skip 1;

truncate table DataPrime.ECom_AdType;
insert into DataPrime.ECom_AdType
select
    *
from tmp_local;
commit;
