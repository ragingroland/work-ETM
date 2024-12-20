\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_Regions where CountryID = 0;
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/Regions.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/Regions.rej'
exceptions '/autons/vertica/web_analitik_run/Regions.exc' direct skip 1;

truncate table DataPrime.ECom_Regions;
insert into DataPrime.ECom_Regions
select
    *
from tmp_local;
commit;