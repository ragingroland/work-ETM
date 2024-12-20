create table DataMart.DshECom_AnlsMerchGrp_Ad1Cli0 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad1Cli0 is 'Анализ по товарным группам 81 классификатора AdTypeID = 1, TypeClientID = 0';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli0.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad1Cli1 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad1Cli1 is 'Анализ по товарным группам 81 классификатора AdTypeID = 1, TypeClientID = 1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli1.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad1Cli2 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad1Cli2 is 'Анализ по товарным группам 81 классификатора AdTypeID = 1, TypeClientID = 2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli2.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad1Cli3 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad1Cli3 is 'Анализ по товарным группам 81 классификатора AdTypeID = 1, TypeClientID = 3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1Cli3.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad2Cli0 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad2Cli0 is 'Анализ по товарным группам 81 классификатора AdTypeID = 2, TypeClientID = 0';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli0.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad2Cli1 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad2Cli1 is 'Анализ по товарным группам 81 классификатора AdTypeID = 2, TypeClientID = 1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli1.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad2Cli2 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad2Cli2 is 'Анализ по товарным группам 81 классификатора AdTypeID = 2, TypeClientID = 2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli2.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad2Cli3 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(60),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad2Cli3 is 'Анализ по товарным группам 81 классификатора AdTypeID = 2, TypeClientID = 3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2Cli3.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad1 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(140),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad1.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad1.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad1.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad1.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad1.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad1.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad1.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad1 is 'Анализ по товарным группам 81 классификатора AdTypeID = 1, все клиенты';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad1.ChecksSum is 'Сумма оформленных заказов';

create table DataMart.DshECom_AnlsMerchGrp_Ad2 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(140),
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
    AdTypeID,
    TypeClientID,
    CategoryID,
    Series,
    Class81_Code_1,
    Class81_Code_2,
    CampaignID,
    CityID,
    Class81_Code_3,
    Class81_Code_4,
    MnfCode,
    Datainfo
segmented by hash(
    DataMart.DshECom_AnlsMerchGrp_Ad2.AdTypeID,
    DataMart.DshECom_AnlsMerchGrp_Ad2.TypeClientID,
    DataMart.DshECom_AnlsMerchGrp_Ad2.CategoryID,
    DataMart.DshECom_AnlsMerchGrp_Ad2.Series,
    DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_1,
    DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_2,
    DataMart.DshECom_AnlsMerchGrp_Ad2.CampaignID,
    DataMart.DshECom_AnlsMerchGrp_Ad2.CityID,
    DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_3,
    DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_4,
    DataMart.DshECom_AnlsMerchGrp_Ad2.MnfCode) all nodes ksafe;

comment on table DataMart.DshECom_AnlsMerchGrp_Ad2 is 'Анализ по товарным группам 81 классификатора AdTypeID = 2, все клиенты';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_1 is 'Интернет-каталог 81кл ур1';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_2 is 'Интернет-каталог 81кл ур2';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_3 is 'Интернет-каталог 81кл ур3';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.Class81_Code_4 is 'Интернет-каталог 81кл ур4';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.Series is 'Серия';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.AdTypeID is 'Тип атрибуции';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.CampaignID is 'ID кампании';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.CategoryID is 'ID категории';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.TypeClientID is 'ID тип клиента';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.CountryID is 'ID страны';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.RegionID is 'ID региона';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.CityID is 'ID города';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.UsersWtchProd is 'Пользователей, просмотревших товары';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.UsersAddBusk is 'Пользователей, добавивших товары в корзину';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.UsersWthOrdrs is 'Пользователей, оформивших заказы';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.ChecksAmount is 'Кол-во оформленных заказов';
comment on column DataMart.DshECom_AnlsMerchGrp_Ad2.ChecksSum is 'Сумма оформленных заказов';

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
