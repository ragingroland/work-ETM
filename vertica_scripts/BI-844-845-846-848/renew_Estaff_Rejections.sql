\set ON_ERROR_STOP ON;

create local temp table tmp_Estaff_Rejections (
    Num int,
    Code varchar(70),
    NameLvl1 varchar(80),
    NameLvl2 varchar(100))
on commit preserve rows;

copy tmp_Estaff_Rejections (
    Code,
    NameLvl1,
    NameLvl2)
from local 'H:\OLAP\Estaff_Desc_Data\DATA\Rejection.vcsv'
    abort on error
    delimiter ';'
    null 'null'
    enclosed by '"'
    rejectmax 1
    rejected data 'H:\OLAP\Estaff_Desc_Data\RUN\Rejection.rej'
    exceptions 'H:\OLAP\Estaff_Desc_Data\RUN\Rejection.exc' direct skip 1;

INSERT INTO DataPrime.Estaff_Rejections (Num, Code, NameLvl1, NameLvl2)
WITH
MaxCode as (
    select max(Num) as mc from DataPrime.Estaff_Rejections
),
NameR as (
    select distinct tmp_Estaff_Rejections.Code, tmp_Estaff_Rejections.NameLvl1, tmp_Estaff_Rejections.NameLvl2
    from tmp_Estaff_Rejections
    left join DataPrime.Estaff_Rejections Main on Main.Code = tmp_Estaff_Rejections.Code
    where Main.Num is null
)
select
    coalesce(mc,0) + rank() over (order by NameR.NameLvl1, NameR.NameLvl2),
    NameR.Code,
    NameR.NameLvl1,
    NameR.NameLvl2
from MaxCode, NameR;
commit;

update DataPrime.Estaff_Rejections
set NameLvl1 = t.NameLvl1, NameLvl2 = t.NameLvl2
from tmp_Estaff_Rejections t
where DataPrime.Estaff_Rejections.Code = t.Code
    and DataPrime.Estaff_Rejections.NameLvl1 != t.NameLvl1
    and DataPrime.Estaff_Rejections.NameLvl2 != t.NameLvl2;
commit;
