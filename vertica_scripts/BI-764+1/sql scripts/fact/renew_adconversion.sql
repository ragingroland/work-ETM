\set ON_ERROR_STOP ON;

create local temp table tmp_local (
    AdTypeID int,
    TypeClientID int,
    DataInfo date,
    CityID int,
    CampaignID int,
    CategoryID int,
    RgdCode int,
    UserID varchar(150),
    WatchProd int,
    QltAddProd int,
    QltPurchaseProd int,
    TotalSum float)
on commit preserve rows;

copy tmp_local
from local '/autons/vertica/web_analitik/ad_conversion_81.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/ad_conversion_81.rej'
exceptions '/autons/vertica/web_analitik_run/ad_conversion_81.exc' direct skip 1;

create local temp table dates
on commit preserve rows as
select
    min(DataInfo) as mindate,
    max(DataInfo) as maxdate
from tmp_local;

delete from DataPrime.ECom_AdConversion
where DataInfo >= (select mindate from dates) and DataInfo <= (select maxdate from dates);
commit;

insert into DataPrime.ECom_AdConversion
select
	DataInfo,
    TypeClientID,
    isnull(CityID, 68) as CityID,
    AdTypeID,
    isnull(CampaignID, 0) as CampaignID,
    CategoryID,
    RgdCode,
    coalesce(UserID, '') as UserID,
    WatchProd,
    QltAddProd,
    TotalSum,
    QltPurchaseProd
from tmp_local;
commit;
