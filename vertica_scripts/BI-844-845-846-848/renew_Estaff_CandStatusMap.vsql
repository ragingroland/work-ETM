\set ON_ERROR_STOP ON;

create local temp table tmp_Estaff_CandStatusMap (
    BICode varchar(20),
    Code varchar(100))
on commit preserve rows;

copy tmp_Estaff_CandStatusMap (
    BICode,
    Code)
from local 'H:\OLAP\Estaff_Desc_Data\DATA\CandidateStatusMapping.vcsv'
    abort on error
    delimiter ';'
    null 'null'
    enclosed by '"'
    rejectmax 1
    rejected data 'H:\OLAP\Estaff_Desc_Data\RUN\CandidateStatusMapping.rej'
    exceptions 'H:\OLAP\Estaff_Desc_Data\RUN\CandidateStatusMapping.exc' direct skip 1;

delete from tmp_Estaff_CandStatusMap
where BICode = '';
commit;

insert into DataPrime.Estaff_CandStatusMap (BICode, Code)
select * from tmp_Estaff_CandStatusMap
where not exists(select 1 from DataPrime.Estaff_CandStatusMap where BICode = tmp_Estaff_CandStatusMap.BICode);
commit;
