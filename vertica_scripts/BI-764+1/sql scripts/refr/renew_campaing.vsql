\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_Campaign where ID = 0;
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/Campaing.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/Campaing.rej'
exceptions '/autons/vertica/web_analitik_run/Campaing.exc' direct skip 1;

truncate table DataPrime.ECom_Campaign;
insert into DataPrime.ECom_Campaign
select
    ID,
    coalesce(Name, '') as Name
from tmp_local;
commit;
