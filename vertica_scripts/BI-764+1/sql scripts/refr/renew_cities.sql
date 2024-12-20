\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_Cities where CityID = 0;
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/Cities.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/Cities.rej'
exceptions '/autons/vertica/web_analitik_run/Cities.exc' direct skip 1;

truncate table DataPrime.ECom_Cities;
insert into DataPrime.ECom_Cities
select
    *
from tmp_local;
commit;