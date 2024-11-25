\set ON_ERROR_STOP ON;

create local temp table tmp_local (
    CounterID int,
    RgdCode int,
    DataInfo date,
    Status varchar(4),
    QltVisit int,
    TrafficSourceID int,
    SearchEngineRootID int,
    WatchCard int,
    QltAdd varchar(10),
    SumAdd int,
    QltClickReplace varchar(10),
    SumClickReplace int,
    QltPurchaseProd varchar(10),
    SumPurchaseProd int,
    QltRefusal int,
    RenameYM int)
on commit preserve rows;

copy tmp_local (
	CounterID,
    RgdCode,
    DataInfo,
    Status,
    QltVisit,
    TrafficSourceID,
    SearchEngineRootID,
    WatchCard,
    QltAdd,
    SumAdd,
    QltClickReplace,
    SumClickReplace,
    QltPurchaseProd,
    SumPurchaseProd,
    QltRefusal,
    RenameYM)
from local '/autons/vertica/web_analitik/nomenklature_month.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/nomenklature_month.rej'
exceptions '/autons/vertica/web_analitik_run/nomenklature_month.exc' direct skip 1;

create local temp table dates
on commit preserve rows as
select
    min(DataInfo) as mindate,
    max(DataInfo) as maxdate
from tmp_local;

delete from DataPrime.ECom_NomenclatureMnth
where DataInfo >= (select mindate from dates) and DataInfo <= (select maxdate from dates);
commit;

insert into DataPrime.ECom_NomenclatureMnth
select
    DataInfo,
    CounterID,
    RgdCode,
    QltVisit,
    TrafficSourceID,
    SearchEngineRootID,
    WatchCard,
    case
        when QltAdd = 'TRUE'
            then 1
        else 0
    end as QltAdd,
    SumAdd,
    case
        when QltClickReplace = 'TRUE'
            then 1
        else 0
    end as QltClickReplace,
    SumClickReplace,
    case
        when QltPurchaseProd = 'TRUE'
            then 1
        else 0
    end as QltPurchaseProd,
    SumPurchaseProd,
    QltRefusal,
    RenameYM,
    isnull(Status, '') as Status
from tmp_local;
commit;
