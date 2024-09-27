create table DataPrime.ECom_Counter (
    ID int,
    Name varchar(20)) unsegmented all nodes;

comment on table DataPrime.ECom_Counter is 'Справочник от АНАЛИТИКА ПЛЮС: Типы счетчиков Яндекс.Метрика';
comment on column DataPrime.ECom_Counter.ID is 'ID счетчика';
comment on column DataPrime.ECom_Counter.Name is 'Наименование счетчика';

create table DataPrime.ECom_Countries (
    ID int,
    Name varchar(80)) unsegmented all nodes;

comment on table DataPrime.ECom_Countries is 'Справочник от АНАЛИТИКА ПЛЮС: Страна';
comment on column DataPrime.ECom_Countries.ID is 'ID страны';
comment on column DataPrime.ECom_Countries.Name is 'Название страны';

create table DataPrime.ECom_Regions (
    CountryID int,
    RegionID int,
    Name varchar(100)) unsegmented all nodes;

comment on table DataPrime.ECom_Regions is 'Справочник от АНАЛИТИКА ПЛЮС: Регионы';
comment on column DataPrime.ECom_Regions.CountryID is 'ID страны';
comment on column DataPrime.ECom_Regions.RegionID is 'ID региона';
comment on column DataPrime.ECom_Regions.Name is 'Название региона';

create table DataPrime.ECom_Cities (
    CountryID int,
    RegionID int,
    CityID int,
    Name varchar(80)) unsegmented all nodes;

comment on table DataPrime.ECom_Cities is 'Справочник от АНАЛИТИКА ПЛЮС: Города';
comment on column DataPrime.ECom_Cities.CountryID is 'ID страны';
comment on column DataPrime.ECom_Cities.RegionID is 'ID региона';
comment on column DataPrime.ECom_Cities.CityID is 'ID города';
comment on column DataPrime.ECom_Cities.Name is 'Название города';

create table DataPrime.ECom_TrafficSource (
    ID int,
    Name varchar(30)) unsegmented all nodes;

comment on table DataPrime.ECom_TrafficSource is 'Справочник от АНАЛИТИКА ПЛЮС: Вид траффика';
comment on column DataPrime.ECom_TrafficSource.ID is 'ID вида траффика';
comment on column DataPrime.ECom_TrafficSource.Name is 'Наименование вида трафика';

create table DataPrime.ECom_SearchEngineRoot (
    ID int,
    Name varchar(30)) unsegmented all nodes;

comment on table DataPrime.ECom_SearchEngineRoot is 'Справочник от АНАЛИТИКА ПЛЮС: Поисковая система';
comment on column DataPrime.ECom_SearchEngineRoot.ID is 'ID поисковой системы';
comment on column DataPrime.ECom_SearchEngineRoot.Name is 'Наименование поисковой системы';

create table DataPrime.ECom_TrafficSourceFstLst (
    ID int,
    Name varchar(80)) unsegmented all nodes;

comment on table DataPrime.ECom_TrafficSourceFstLst is 'Справочник от АНАЛИТИКА ПЛЮС: Источник трафика в разрезе атрибуции (первый, автоматический, последний значимый)';
comment on column DataPrime.ECom_TrafficSourceFstLst.ID is 'ID вида траффика';
comment on column DataPrime.ECom_TrafficSourceFstLst.Name is 'Наименование вида трафика';

create table DataPrime.ECom_Status (
    DescRgd_Code int,
    "Status" varchar(50)) unsegmented all nodes;

comment on table DataPrime.ECom_Status is 'Справочник от АНАЛИТИКА ПЛЮС: Статус товара';
comment on column DataPrime.ECom_Status.DescRgd_Code is 'Код товара';
comment on column DataPrime.ECom_Status."Status" is 'Статус товара';

create table DataPrime.ECom_Campaign (
    ID int,
    Name varchar(150)) unsegmented all nodes;

comment on table DataPrime.ECom_Campaign is 'Справочник от АНАЛИТИКА ПЛЮС: Рекламные кампании';
comment on column DataPrime.ECom_Campaign.ID is 'ID рекламной кампании';
comment on column DataPrime.ECom_Campaign.Name is 'Название рекламной кампании';

create table DataPrime.ECom_Category (
    ID int,
    Name varchar(100)) unsegmented all nodes;

comment on table DataPrime.ECom_Category is 'Справочник от АНАЛИТИКА ПЛЮС: Направления';
comment on column DataPrime.ECom_Category.ID is 'ID направления';
comment on column DataPrime.ECom_Category.Name is 'Наименование направления';

create table DataPrime.ECom_TypeClient (
    ID int,
    Name varchar(30)) unsegmented all nodes;

comment on table DataPrime.ECom_TypeClient is 'Справочник от АНАЛИТИКА ПЛЮС: Типы клиента';
comment on column DataPrime.ECom_TypeClient.ID is 'ID типа клиента';
comment on column DataPrime.ECom_TypeClient.Name is 'Наименование типа клиента';

create table DataPrime.ECom_AdType (
    ID int,
    Name varchar(20)) unsegmented all nodes;

comment on table DataPrime.ECom_AdType is 'Справочник от АНАЛИТИКА ПЛЮС: Типы атрибуции';
comment on column DataPrime.ECom_AdType.ID is 'ID типа атрибуции';
comment on column DataPrime.ECom_AdType.Name is 'Наименование типа атрибуции';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
