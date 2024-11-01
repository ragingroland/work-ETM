create table DataMart.DshECom_AnlsAdvSumDataComp (
    DataInfo date,
    AdTypeID int,
    CampaignID int,
    CategoryID int,
    Clicks float,
    Impressions float,
    goal_smeta float,
    goal_specification float,
    goal_registration_B2B float,
    goal_registration_B2C float,
    Purchase_revenue float,
    Cost float,
    Transactions float)
order by
    AdTypeID,
    CategoryID,
    CampaignID,
    DataInfo
segmented by hash(
    DataMart.DshECom_AnlsAdvSumDataComp.AdTypeID,
    DataMart.DshECom_AnlsAdvSumDataComp.CategoryID,
    DataMart.DshECom_AnlsAdvSumDataComp.CampaignID) all nodes ksafe;

comment on table DataMart.DshECom_AnlsAdvSumDataComp is 'Сводные данные по рекламным кампаниям, витрина по кампаниям';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.AdTypeID is 'ID типа атрибуции';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.Clicks is 'Количество кликов';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.Impressions is 'Показы';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.goal_smeta is 'Цель: сметы';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.goal_specification is 'Цель: спецификации';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.goal_registration_B2B is 'Цель: регистрации ЮЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.goal_registration_B2C is 'Цель: регистрации ФЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.Purchase_revenue is 'Сумма заказов=доход';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.Cost is 'Стоимость кликов=расход';
comment on column DataMart.DshECom_AnlsAdvSumDataComp.Transactions is 'Транзакции';

create table DataMart.DshECom_AnlsAdvSumDataCli (
    DataInfo date,
    AdTypeID int,
    CampaignID int,
    CategoryID int,
    B2B_Transactions float,
    B2C_Transactions float,
    B2C_revenue float,
    B2B_revenue float,
    goal_specification_B2B float,
    goal_specification_B2C float,
    goal_smeta_B2B float,
    goal_smeta_B2C float,
    Purchase_revenue float,
    Cost float)
order by
    AdTypeID,
    CategoryID,
    CampaignID,
    DataInfo
segmented by hash(
    DataMart.DshECom_AnlsAdvSumDataCli.AdTypeID,
    DataMart.DshECom_AnlsAdvSumDataCli.CategoryID,
    DataMart.DshECom_AnlsAdvSumDataCli.CampaignID) all nodes ksafe;

comment on table DataMart.DshECom_AnlsAdvSumDataCli is 'Сводные данные по рекламным кампаниям, витрина по клиентам';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.AdTypeID is 'ID типа атрибуции';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.goal_smeta_B2B is 'Цель: сметы ЮЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.goal_smeta_B2C is 'Цель: сметы ФЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.B2B_Transactions is 'Кол-во заказов ЮЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.B2C_Transactions is 'Кол-во заказов ФЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.B2C_revenue is 'Сумма заказлв ФЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.B2B_revenue is 'Сумма заказов ЮЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.goal_specification_B2B is 'Цель: спецификации ЮЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.goal_specification_B2C is 'Цель: спецификации ФЛ';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.Purchase_revenue is 'Сумма заказов=доход';
comment on column DataMart.DshECom_AnlsAdvSumDataCli.Cost is 'Стоимость кликов=расход';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
