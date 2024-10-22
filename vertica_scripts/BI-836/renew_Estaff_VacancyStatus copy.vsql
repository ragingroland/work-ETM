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
    null ''
    enclosed by '"'
rejected data 'H:\OLAP\Estaff_VacancyStatus\VacancyStatus.rej'
exceptions 'H:\OLAP\Estaff_VacancyStatus\VacancyStatus.exc' direct skip 1;

merge into DataPrime.Estaff_VacancyStatus as target
using (
    select distinct
        Code,
        Name
    from tmp_local) as temp
on temp.Name = target.Name
when matched then update set
    Code = temp.Code,
    Name = temp.Name
when not matched then insert values (
    temp.Code,
    temp.Name);

insert into DataPrime.Estaff_VacancyStatus (Code, Name)
select * from tmp_local
where not exists (select 1 from DataPrime.Estaff_VacancyStatus where Name = tmp_local.Name);
commit;
