\set ON_ERROR_STOP ON;

create local temp table tmp_copy (
    ID int,
    DataInfo date,
    Mark int,
    CliCode int,
    Class132_Code varchar(30))
on commit preserve rows;

copy tmp_copy
from local 'H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ClaimsMark.csv'
    abort on error
    delimiter '|'
    enclosed by '"'
    rejectmax 1
    rejected data 'H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ClaimsMark.rej'
    exceptions 'H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ClaimsMark.exc' direct skip 1;

delete from DataPrime.CSI_ElmaClaims
where DataInfo >= (select min(DataInfo) from tmp_copy);
commit;

select purge_table('DataPrime.CSI_ElmaClaims');

insert into DataPrime.CSI_ElmaClaims
select
    DataInfo,
    CliCode,
    ID,
    Mark,
    Class132_Code
from tmp_copy;
commit;
