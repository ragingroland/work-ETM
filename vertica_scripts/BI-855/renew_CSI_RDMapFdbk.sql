\set ON_ERROR_STOP ON;

create local temp table tmp_copy (
    DataInfo date,
    FeedbackID int,
    Rating float,
    CompanyID int,
    CompanyName varchar(50),
    CompanyCode varchar(50),
    Region varchar(100),
    City varchar(100),
    Street varchar(100),
    Housenumber varchar(100),
    ResponseTime float)
on commit preserve rows;

copy tmp_copy
from local '/autons/rocketdata/CSI_RDMapFdbk.csv'
    abort on error
    delimiter ','
    enclosed by '"'
    rejectmax 1
    rejected data '/autons/rocketdata/CSI_RDMapFdbk.rej'
    exceptions '/autons/rocketdata/CSI_RDMapFdbk.exc' direct skip 1;

delete from DataPrime.CSI_RDMapFdbk
where DataInfo >= (select min(DataInfo) from tmp_copy)
    and DataInfo <= (select max(DataInfo) from tmp_copy);
commit;

select purge_table('DataPrime.CSI_RDMapFdbk');

insert into DataPrime.CSI_RDMapFdbk
select
    DataInfo,
    FeedbackID,
    Rating,
    upper(City),
    CompanyCode
from tmp_copy;
commit;
