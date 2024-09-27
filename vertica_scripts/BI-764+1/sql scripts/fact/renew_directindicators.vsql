\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.ECom_DirectIndicators where DataInfo = '0001-01-01';
truncate table tmp_local;

copy tmp_local
from local '/autons/vertica/web_analitik/direct_indicators.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data '/autons/vertica/web_analitik_run/direct_indicators.rej'
exceptions '/autons/vertica/web_analitik_run/direct_indicators.exc' direct skip 1;

create local temp table dates
on commit preserve rows as
select
    min(DataInfo) as mindate,
    max(DataInfo) as maxdate
from tmp_local;

delete from DataPrime.ECom_DirectIndicators
where DataInfo >= (select mindate from dates) and DataInfo <= (select maxdate from dates);
commit;

insert into DataPrime.ECom_DirectIndicators
select
	DataInfo,
    AdTypeID,
    isnull(CampaignID, 0) as CampaignID,
    CategoryID,
    Impressions,
    Cliks,
    Visits,
    Cost,
    Transactions,
    B2B_Transactions,
    B2C_Transactions,
    Purchase_Revenue,
    B2B_revenue,
    B2C_revenue,
    goal_specification,
    goal_smeta,
    goal_registration_B2B,
    goal_registration_B2C,
    goal_specification_B2B,
    goal_specification_B2C,
    goal_smeta_B2B,
    goal_smeta_B2C
from tmp_local;
commit;
