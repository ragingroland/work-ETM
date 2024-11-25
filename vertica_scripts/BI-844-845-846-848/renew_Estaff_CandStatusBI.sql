\set ON_ERROR_STOP ON;

create local temp table tmp_Estaff_CandStatusBI (
    Code varchar(20),
    Name varchar(100))
on commit preserve rows;

copy tmp_Estaff_CandStatusBI (
    Code,
    Name)
from local 'H:\OLAP\Estaff_Desc_Data\DATA\CandidateStatusBI.vcsv'
    abort on error
    delimiter ';'
    null 'null'
    enclosed by '"'
    rejectmax 1
    rejected data 'H:\OLAP\Estaff_Desc_Data\RUN\CandidateStatusBI.rej'
    exceptions 'H:\OLAP\Estaff_Desc_Data\RUN\CandidateStatusBI.exc' direct skip 1;

insert into DataPrime.Estaff_CandStatusBI (Code, Name)
select * from tmp_Estaff_CandStatusBI
where not exists(select 1 from DataPrime.Estaff_CandStatusBI where Code = tmp_Estaff_CandStatusBI.Code);
commit;
