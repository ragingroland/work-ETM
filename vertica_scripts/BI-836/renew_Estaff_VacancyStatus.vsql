\set ON_ERROR_STOP ON;

create local temp table tmp_local (
    Code varchar(50),
    Name varchar(80))
on commit preserve rows;

copy tmp_local (
    Code,
    Name)
from local 'H:\OLAP\Estaff_VacancyStatus\DATA\VacancyStatus.vcsv'
    abort on error
    delimiter ';'
    null 'null'
    enclosed by '"'
    rejectmax 1
    rejected data 'H:\OLAP\Estaff_VacancyStatus\VacancyStatus.rej'
    exceptions 'H:\OLAP\Estaff_VacancyStatus\VacancyStatus.exc' direct skip 1;

INSERT INTO DataPrime.Estaff_VacancyStatus (Num, Code, Name)
WITH
MaxCode as (
    select max(Num) as mc from DataPrime.Estaff_VacancyStatus
),
NameR as (
    select distinct tmp_local.Code, tmp_local.Name as rd from tmp_local
    left join DataPrime.Estaff_VacancyStatus Main on Main.Code = tmp_local.Code
    where Main.Num is null
)
select
    coalesce(mc,0) + rank() over (order by NameR.rd),
    NameR.Code,
    NameR.rd
from MaxCode, NameR;
commit;

update DataPrime.Estaff_VacancyStatus
set Name = t.Name
from tmp_local t
where DataPrime.Estaff_VacancyStatus.Code = t.Code and DataPrime.Estaff_VacancyStatus.Name != t.Name;
commit;
