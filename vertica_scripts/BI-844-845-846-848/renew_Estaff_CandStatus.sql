\set ON_ERROR_STOP ON;

create local temp table tmp_Estaff_CandStatus (
    Num int,
    Code varchar(80),
    Rejection int,
    Name varchar(100))
on commit preserve rows;

copy tmp_Estaff_CandStatus (
    Code,
    Rejection,
    Name)
from local 'H:\OLAP\Estaff_Desc_Data\DATA\CandidateStatus.vcsv'
    abort on error
    delimiter ';'
    null 'null'
    enclosed by '"'
    rejectmax 1
    rejected data 'H:\OLAP\Estaff_Desc_Data\RUN\CandidateStatus.rej'
    exceptions 'H:\OLAP\Estaff_Desc_Data\RUN\CandidateStatus.exc' direct skip 1;

INSERT INTO DataPrime.Estaff_CandStatus (Num, Code, Rejection, Name)
WITH
MaxCode as (
    select max(Num) as mc from DataPrime.Estaff_CandStatus
),
NameR as (
    select distinct tmp_Estaff_CandStatus.Code, tmp_Estaff_CandStatus.Rejection, tmp_Estaff_CandStatus.Name from tmp_Estaff_CandStatus
    left join DataPrime.Estaff_CandStatus Main on Main.Code = tmp_Estaff_CandStatus.Code
    where Main.Num is null
)
select
    coalesce(mc,0) + rank() over (order by NameR.Name),
    NameR.Code,
    NameR.Rejection,
    NameR.Name
from MaxCode, NameR;
commit;

update DataPrime.Estaff_CandStatus
set Rejection = t.Rejection, Name = t.Name
from tmp_Estaff_CandStatus t
where DataPrime.Estaff_CandStatus.Code = t.Code
    and DataPrime.Estaff_CandStatus.Name != t.Name
    and DataPrime.Estaff_CandStatus.Rejection != t.Rejection;
commit;
