\set ON_ERROR_STOP ON;

create local temp table tmp_local (
    CounterID int,
    DataInfo date,
    VisitID varchar(50),
    OrderID float,
    UserID varchar(50),
    RegUser int,
    NewUser int,
    Class206_Code varchar(50),
    ETMCliID varchar(50),
    CountryID int,
    RegionID int,
    CityID int,
    Device varchar(30),
    TrafficSourceFirst int,
    TrafficSourceAuto int,
    TrafficSourceLast int,
    TypeClient int,
    Class81_Code varchar(30),
    WatchProd int,
    QltAddProd int,
    WatchBusket int,
    QltCheckOut int,
    OrderDate date,
    QltPurchaseProd int,
    TotalSum float,
    DtTmRenew date,
    PricePRZ float,
    QltPRZ float,
    PricePO float,
    QltPO float)
on commit preserve rows;

copy tmp_local
from local '/autons/vertica/web_analitik/dm_web_analytics.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/web_analytics.rej'
exceptions '/autons/vertica/web_analitik_run/web_analytics.exc' direct skip 1;

create local temp table dates
on commit preserve rows as
select
    min(DataInfo) as mindate,
    max(DataInfo) as maxdate
from tmp_local;

delete from DataPrime.ECom_WebAnalytics
where DataInfo >= (select mindate from dates) and DataInfo <= (select maxdate from dates);
commit;

insert into DataPrime.ECom_WebAnalytics
select
	DataInfo,
	CounterID,
    VisitID::int,
    isnull(OrderID, 0) as OrderID,
    UserID,
    RegUser,
    NewUser,
    case
	    when Class206_Code = 'Нет данных'
	    	then ''
	    else coalesce(left(Class206_Code, 4), '')
	end as Class206_Code,
    isnull(ETMCliID, '') as ETMCliID,
    CountryID,
    RegionID,
    CityID,
    Device,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    TypeClient,
    case
	    when Class81_Code = 'Нет данных'
	    	then ''
	    else coalesce(Class81_Code, '')
	end as Class81_Code,
    WatchProd,
    QltAddProd,
    WatchBusket,
    QltCheckOut,
    OrderDate,
    QltPurchaseProd,
    TotalSum,
    DtTmRenew,
    PricePRZ,
    QltPRZ,
    PricePO,
    QltPO
from tmp_local;
commit;
