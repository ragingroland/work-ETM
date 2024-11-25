\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_InactiveCL81Mnth where DataInfo = '0001-01-01';
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/inactive_81_month.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/inactive_81_month.rej'
exceptions '/autons/vertica/web_analitik_run/inactive_81_month.exc' direct skip 1;

create local temp table dates
on commit preserve rows as
select
    min(DataInfo) as mindate,
    max(DataInfo) as maxdate
from tmp_local;

delete from DataPrime.ECom_InactiveCL81Mnth
where DataInfo >= (select mindate from dates) and DataInfo <= (select maxdate from dates);
commit;

insert into DataPrime.ECom_InactiveCL81Mnth
select
    *
from tmp_local;
commit;
