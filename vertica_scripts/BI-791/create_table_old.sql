create table DataMart.DshECom_AnlsMerchGrp (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    AdTypeID int,
    CampaignID int,
    CategoryID int,
    TypeClientID int,
    CountryID int,
    RegionID int,
    CityID int,
    UsersWtchProd float,
	UsersAddBusk float,
	UsersWthOrdrs float,
	ChecksAmount float,
	ChecksSum float)
order by
    CountryID,
    AdTypeID,
    TypeClientID,
    CategoryID,
	Class81_Code_1,
	RegionID,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp.CountryID,
    DataMart.DshECom_AnlsMerchGrp.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp.CategoryID,
    DataMart.DshECom_AnlsMerchGrp.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp.RegionID,
    DataMart.DshECom_AnlsMerchGrp.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp.CampaignID,
    DataMart.DshECom_AnlsMerchGrp.CityID,
    DataMart.DshECom_AnlsMerchGrp.Class81_Code_3) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp is 'Анализ по товарным группам 81 классификатора';
comment on column DataMart.DshECom_AnlsMerchGrp.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrpBrnd (
    DataInfo date,
    MnfCode int,
    Series varchar(60),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    AdTypeID int,
    CampaignID int,
    CategoryID int,
    TypeClientID int,
    CountryID int,
    RegionID int,
    CityID int,
    UsersWtchProd float,
	UsersAddBusk float,
	UsersWthOrdrs float,
	ChecksAmount float,
	ChecksSum float)
order by
    CountryID,
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
	RegionID,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrpBrnd.CountryID,
    DataMart.DshECom_AnlsMerchGrpBrnd.AdTypeID,
    DataMart.DshECom_AnlsMerchGrpBrnd.TypeClientID,
    DataMart.DshECom_AnlsMerchGrpBrnd.CategoryID,
    DataMart.DshECom_AnlsMerchGrpBrnd.Series,
    DataMart.DshECom_AnlsMerchGrpBrnd.RegionID,
    DataMart.DshECom_AnlsMerchGrpBrnd.CampaignID,
    DataMart.DshECom_AnlsMerchGrpBrnd.CityID,
    DataMart.DshECom_AnlsMerchGrpBrnd.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrpBrnd.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrpBrnd.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrpBrnd is 'Анализ по товарным группам 81 классификатора в рамках бренда';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.AdTypeID is 'ID типа атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.TypeClientID is 'ID типа клиента';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.CountryID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.RegionID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrpBrnd.ChecksSum is 'Сумма оформленных заказов';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
-- !!! для ED добавляем по роли etl_ed_role:
--                 public и dataprime - только смотрим
--                 datamart          - все
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
