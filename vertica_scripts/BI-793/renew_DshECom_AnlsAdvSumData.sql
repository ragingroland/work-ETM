-- т.к данных не много, берем за весь регламентированный срез
-- все суммы считаются сразу
create local temp table tmp_local
on commit preserve rows as
select
    DataInfo,
    AdTypeID,
    CampaignID,
    CategoryID,
    sum(Cliks) as Clicks,
    sum(Impressions) as Impressions,
    sum(goal_smeta) as goal_smeta,
    sum(goal_specification) as goal_specification,
    sum(goal_registration_B2B) as goal_registration_B2B,
    sum(goal_registration_B2C) as goal_registration_B2C,
    sum(Purchase_revenue) as PurchaseRevenue,
    sum(Cost) as Cost,
    sum(Transactions) as Transactions
from DataPrime.ECom_DirectIndicators
inner join DataPrime.ECom_Campaign on CampaignID = ID and Name != ''
where DataInfo >= add_months(trunc(current_date, 'mm'), -13)
group by 1, 2, 3, 4;

create local temp table tmp_local2
on commit preserve rows as
select
    DataInfo,
    AdTypeID,
    CampaignID,
    CategoryID,
    sum(B2B_Transactions) as transactions_B2B,
    sum(B2C_Transactions) as transactions_B2C,
    sum(B2C_revenue) as revenue_B2C,
    sum(B2B_revenue) as revenue_B2B,
    sum(goal_specification_B2B) as goal_specification_B2B,
    sum(goal_specification_B2C) as goal_specification_B2C,
    sum(goal_smeta_B2B) as goal_smeta_B2B,
    sum(goal_smeta_B2C) as goal_smeta_B2C,
    sum(Purchase_revenue) as PurchaseRevenue,
    sum(Cost) as Cost
from DataPrime.ECom_DirectIndicators
inner join DataPrime.ECom_Campaign on CampaignID = ID and Name != ''
where DataInfo >= add_months(trunc(current_date, 'mm'), -13)
group by 1, 2, 3, 4;

truncate table DataMart.DshECom_AnlsAdvSumDataComp;
insert into DataMart.DshECom_AnlsAdvSumDataComp
select * from tmp_local;
commit;

truncate table DataMart.DshECom_AnlsAdvSumDataCli;
insert into DataMart.DshECom_AnlsAdvSumDataCli
select * from tmp_local2;
commit;

select analyze_statistics('DataMart.DshECom_AnlsAdvSumDataComp');
select analyze_statistics('DataMart.DshECom_AnlsAdvSumDataCli');
