\set ON_ERROR_STOP ON;

create local temp table tmp_copy (
    ID int,
    DataInfo date,
    Mark varchar(6),
    CliCode int,
    Code1 varchar(200),
    Code2 varchar(300),
    Class132_Code varchar(30))
on commit preserve rows;

copy tmp_copy
from local 'H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ServiceQualityMark.csv'
    abort on error
    delimiter '|'
    enclosed by '"'
    rejectmax 1
    rejected data 'H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ServiceQualityMark.rej'
    exceptions 'H:\OLAP\CSI_ElmaSrvcQltyClms\DATA\ServiceQualityMark.exc' direct skip 1;

delete from DataPrime.CSI_ElmaSrvcQlty
where DataInfo >= (select min(DataInfo) from tmp_copy);
commit;

select purge_table('DataPrime.CSI_ElmaSrvcQlty');

create local temp table tmp_local
on commit preserve rows as
select
    DataInfo,
    CliCode,
    ID,
    Mark,
    case
        when Code1 = 'Работа персонала ЭТМ'
            then 'Работа персонала'
        else Code1
    end,
    Code2,
    Class132_Code
from tmp_copy;

insert into DataPrime.CSI_ElmaSrvcQlty
select
    DataInfo,
    CliCode,
    ID,
    case
        when Mark is null
            then ''
        else Mark
    end,
    esqr.Code,
    Class132_Code
from tmp_local
left join DataPrime.CSI_ElmaSrvcQltyRsns esqr on Code1 = CodeName_1 and Code2 = CodeName_2
where CliCode is not null;
commit;
