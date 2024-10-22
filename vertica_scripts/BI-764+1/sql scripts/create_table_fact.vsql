create table DataPrime.ECom_WebAnalytics (
    DataInfo date,
    CounterID int,
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
order by
    CounterID,
    TypeClient,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    CountryID,
    RegionID,
    Class206_Code,
    CityID,
    Class81_Code,
    DataInfo
segmented by hash (
    DataPrime.ECom_WebAnalytics.CounterID,
    DataPrime.ECom_WebAnalytics.TypeClient,
    DataPrime.ECom_WebAnalytics.TrafficSourceFirst,
    DataPrime.ECom_WebAnalytics.TrafficSourceAuto,
    DataPrime.ECom_WebAnalytics.TrafficSourceLast,
    DataPrime.ECom_WebAnalytics.CountryID,
    DataPrime.ECom_WebAnalytics.RegionID,
    DataPrime.ECom_WebAnalytics.Class206_Code,
    DataPrime.ECom_WebAnalytics.CityID,
    DataPrime.ECom_WebAnalytics.Class81_Code) all nodes ksafe;

comment on table DataPrime.ECom_WebAnalytics is 'Выгрузка веб-аналитики';
comment on column DataPrime.ECom_WebAnalytics.CounterID is 'ID счетчика';
comment on column DataPrime.ECom_WebAnalytics.DataInfo is 'Дата';
comment on column DataPrime.ECom_WebAnalytics.VisitID is 'ID визита';
comment on column DataPrime.ECom_WebAnalytics.OrderID is 'ID заказа';
comment on column DataPrime.ECom_WebAnalytics.UserID is 'ID пользователя';
comment on column DataPrime.ECom_WebAnalytics.RegUser is 'Авторизованный пользователь';
comment on column DataPrime.ECom_WebAnalytics.NewUser is 'Новый пользователь';
comment on column DataPrime.ECom_WebAnalytics.Class206_Code is 'Код класса 206-го классификатора';
comment on column DataPrime.ECom_WebAnalytics.ETMCliID is 'ID клиента ЭТМ';
comment on column DataPrime.ECom_WebAnalytics.CountryID is 'ID страны';
comment on column DataPrime.ECom_WebAnalytics.RegionID is 'ID региона';
comment on column DataPrime.ECom_WebAnalytics.CityID is 'ID города';
comment on column DataPrime.ECom_WebAnalytics.Device is 'Девайс';
comment on column DataPrime.ECom_WebAnalytics.TrafficSourceFirst is 'Источник трафика (Перв.)';
comment on column DataPrime.ECom_WebAnalytics.TrafficSourceAuto is 'Источник трафика (автоматический.)';
comment on column DataPrime.ECom_WebAnalytics.TrafficSourceLast is 'Источник трафика (Посл. Зн.)';
comment on column DataPrime.ECom_WebAnalytics.TypeClient is 'Тип клиента';
comment on column DataPrime.ECom_WebAnalytics.Class81_Code is 'Код класса 81-го классификатора';
comment on column DataPrime.ECom_WebAnalytics.WatchProd is 'Просмотр товаров';
comment on column DataPrime.ECom_WebAnalytics.QltAddProd is 'Добавление товара в корзину';
comment on column DataPrime.ECom_WebAnalytics.WatchBusket is 'Просмотр корзины';
comment on column DataPrime.ECom_WebAnalytics.QltCheckOut is 'Кол-во оформленных заказов';
comment on column DataPrime.ECom_WebAnalytics.OrderDate is 'Дата создания заказа';
comment on column DataPrime.ECom_WebAnalytics.QltPurchaseProd is 'Кол-во купленного товара';
comment on column DataPrime.ECom_WebAnalytics.TotalSum is 'Общая сумма товара';
comment on column DataPrime.ECom_WebAnalytics.DtTmRenew is 'Дата отгрузки';
comment on column DataPrime.ECom_WebAnalytics.PricePRZ is 'Цена за ед. товара (ПРЗ)-размещенные';
comment on column DataPrime.ECom_WebAnalytics.QltPRZ is 'Количество (ПРЗ)';
comment on column DataPrime.ECom_WebAnalytics.PricePO is 'Цена за ед. товара (ПО) - отгруженные';
comment on column DataPrime.ECom_WebAnalytics.QltPO is 'Количество (ПО)';

create table DataPrime.ECom_NomenclatureMnth (
    DataInfo date,
    CounterID int,
    RgdCode int,
    QltVisit int,
    TrafficSourceID int,
    SearchEngineRootID int,
    WatchCard int,
    QltAdd int,
    SumAdd int,
    QltClickReplace int,
    SumClickReplace int,
    QltPurchaseProd int,
    SumPurchaseProd int,
    QltRefusal int,
    RenameYM int
    Status varchar(4))
order by
    CounterID,
    Status,
    TrafficSourceID,
    SearchEngineRootID,
    RgdCode,
    DataInfo
segmented by hash (
    DataPrime.ECom_NomenclatureMnth.CounterID,
    DataPrime.ECom_NomenclatureMnth.Status,
    DataPrime.ECom_NomenclatureMnth.TrafficSourceID,
    DataPrime.ECom_NomenclatureMnth.SearchEngineRootID,
    DataPrime.ECom_NomenclatureMnth.RgdCode) all nodes ksafe;

comment on table DataPrime.ECom_NomenclatureMnth is 'Номенклатурная за неделю';
comment on column DataPrime.ECom_NomenclatureMnth.CounterID is 'ID счетчика';
comment on column DataPrime.ECom_NomenclatureMnth.RgdCode is 'Код товара';
comment on column DataPrime.ECom_NomenclatureMnth.DataInfo is 'Дата';
comment on column DataPrime.ECom_NomenclatureMnth.QltVisit is 'Кол-во визитов с КТ';
comment on column DataPrime.ECom_NomenclatureMnth.TrafficSourceID is 'Источник траффика';
comment on column DataPrime.ECom_NomenclatureMnth.SearchEngineRootID is 'Поисковая система';
comment on column DataPrime.ECom_NomenclatureMnth.WatchCard is 'Кол-во просмотров карточки';
comment on column DataPrime.ECom_NomenclatureMnth.QltAdd is 'Кол-во добавлений в корзину';
comment on column DataPrime.ECom_NomenclatureMnth.SumAdd is 'Кол-во добавлений в корзину (шт)';
comment on column DataPrime.ECom_NomenclatureMnth.QltClickReplace is 'Клик на подобрать замену';
comment on column DataPrime.ECom_NomenclatureMnth.SumClickReplace is 'Клик на подобрать замену (шт.)';
comment on column DataPrime.ECom_NomenclatureMnth.QltPurchaseProd is 'Кол-во купленного товара';
comment on column DataPrime.ECom_NomenclatureMnth.SumPurchaseProd is 'Кол-во купленного товара (шт.)';
comment on column DataPrime.ECom_NomenclatureMnth.QltRefusal is 'Кол-во отказов';
comment on column DataPrime.ECom_NomenclatureMnth.RenameYM is 'Фиксация изменения названия на ЯМ (true/false) если по коду товара (колонка 2 - RgdCode) на предыдущую дату (от даты в колонке 3) произошло изменение названия ЯМ, то фиксируем 1 (true), в ином случае 0 (false)';
COMMENT ON COLUMN DataPrime.ECom_NomenclatureMnth.Status IS 'Статус товара';

create table DataPrime.ECom_NomenclatureWk (
    DataInfo date,
    CounterID int,
    RgdCode int,
    QltVisit int,
    TrafficSourceID int,
    SearchEngineRootID int,
    WatchCard int,
    QltAdd int,
    SumAdd int,
    QltClickReplace int,
    SumClickReplace int,
    QltPurchaseProd int,
    SumPurchaseProd int,
    QltRefusal int,
    RenameYM int,
    Status varchar(4))
order by
    CounterID,
    Status,
    TrafficSourceID,
    SearchEngineRootID,
    RgdCode,
    DataInfo
segmented by hash (
    DataPrime.ECom_NomenclatureWk.CounterID,
    DataPrime.ECom_NomenclatureWk.Status,
    DataPrime.ECom_NomenclatureWk.TrafficSourceID,
    DataPrime.ECom_NomenclatureWk.SearchEngineRootID,
    DataPrime.ECom_NomenclatureWk.RgdCode) all nodes ksafe;

comment on table DataPrime.ECom_NomenclatureWk is 'Номенклатурная за неделю';
comment on column DataPrime.ECom_NomenclatureWk.CounterID is 'ID счетчика';
comment on column DataPrime.ECom_NomenclatureWk.RgdCode is 'Код товара';
comment on column DataPrime.ECom_NomenclatureWk.DataInfo is 'Дата';
comment on column DataPrime.ECom_NomenclatureWk.QltVisit is 'Кол-во визитов с КТ';
comment on column DataPrime.ECom_NomenclatureWk.TrafficSourceID is 'Источник траффика';
comment on column DataPrime.ECom_NomenclatureWk.SearchEngineRootID is 'Поисковая система';
comment on column DataPrime.ECom_NomenclatureWk.WatchCard is 'Кол-во просмотров карточки';
comment on column DataPrime.ECom_NomenclatureWk.QltAdd is 'Кол-во добавлений в корзину';
comment on column DataPrime.ECom_NomenclatureWk.SumAdd is 'Кол-во добавлений в корзину (шт)';
comment on column DataPrime.ECom_NomenclatureWk.QltClickReplace is 'Клик на подобрать замену';
comment on column DataPrime.ECom_NomenclatureWk.SumClickReplace is 'Клик на подобрать замену (шт.)';
comment on column DataPrime.ECom_NomenclatureWk.QltPurchaseProd is 'Кол-во купленного товара';
comment on column DataPrime.ECom_NomenclatureWk.SumPurchaseProd is 'Кол-во купленного товара (шт.)';
comment on column DataPrime.ECom_NomenclatureWk.QltRefusal is 'Кол-во отказов';
comment on column DataPrime.ECom_NomenclatureWk.RenameYM is 'Фиксация изменения названия на ЯМ (true/false) если по коду товара (колонка 2 - RgdCode) на предыдущую дату (от даты в колонке 3) произошло изменение названия ЯМ, то фиксируем 1 (true), в ином случае 0 (false)';
COMMENT ON COLUMN DataPrime.ECom_NomenclatureWk.Status IS 'Статус товара';

create table DataPrime.ECom_AdConversion (
    DataInfo date,
    TypeClientID int,
    CityID int,
    AdTypeID int,
    CampaignID int,
    CategoryID int,
    RgdCode int,
    UserID varchar(50),
    WatchProd int,
    QltAddProd int,
    TotalSum float,
    QltPurchaseProd int)
order by
    AdTypeID,
    TypeClientID,
    CategoryID,
    CampaignID,
    CityID,
    UserID,
    RgdCode,
    DataInfo
segmented by hash (
    DataPrime.ECom_AdConversion.AdTypeID,
    DataPrime.ECom_AdConversion.TypeClientID,
    DataPrime.ECom_AdConversion.CategoryID,
    DataPrime.ECom_AdConversion.CampaignID,
    DataPrime.ECom_AdConversion.CityID,
    DataPrime.ECom_AdConversion.UserID,
    DataPrime.ECom_AdConversion.RgdCode) all nodes ksafe;

comment on table DataPrime.ECom_AdConversion is 'Витрина от АНАЛИТИКА ПЛЮС: Атрибуции';
comment on column DataPrime.ECom_AdConversion.TypeClientID is 'Тип клиента';
comment on column DataPrime.ECom_AdConversion.CityID is 'ID города';
comment on column DataPrime.ECom_AdConversion.DataInfo is 'Дата';
comment on column DataPrime.ECom_AdConversion.AdTypeID is 'ID типа атрибуции';
comment on column DataPrime.ECom_AdConversion.CampaignID is 'ID кампании. Где 0 - там нет ID';
comment on column DataPrime.ECom_AdConversion.CategoryID is 'ID категории';
comment on column DataPrime.ECom_AdConversion.RgdCode is 'Код товара';
comment on column DataPrime.ECom_AdConversion.UserID is 'ID пользователя. Где 0 - там нет ID';
comment on column DataPrime.ECom_AdConversion.WatchProd is 'Просмотр товаров';
comment on column DataPrime.ECom_AdConversion.QltAddProd is 'Добавление товара в корзину';
comment on column DataPrime.ECom_AdConversion.QltPurchaseProd is 'Кол-во купленного товара';
comment on column DataPrime.ECom_AdConversion.TotalSum is 'Общая сумма товара';

create table DataPrime.ECom_DirectIndicators (
    DataInfo date,
    AdTypeID int,
    CampaignID int,
    CategoryID int,
    Impressions int,
    Cliks int,
    Visits int,
    Cost float,
    Transactions int,
    B2B_Transactions float,
    B2С_Transactions float,
    Purchase_Revenue float,
    B2B_revenue float,
    B2С_revenue float,
    goal_specification int,
    goal_smeta int,
    goal_registration_B2B int,
    goal_registration_B2C int,
    goal_specification_В2В int,
    goal_specification_В2С int,
    goal_smeta_B2B int,
    goal_smeta_B2С int)
order by
    AdTypeID,
    CategoryID,
    CampaignID,
    DataInfo
segmented by hash (
    DataPrime.ECom_DirectIndicators.AdTypeID,
    DataPrime.ECom_DirectIndicators.CategoryID,
    DataPrime.ECom_DirectIndicators.CampaignID) all nodes ksafe;

comment on table DataPrime.ECom_DirectIndicators is 'Витрина от АНАЛИТИКА ПЛЮС: Индикаторы';
comment on column DataPrime.ECom_DirectIndicators.DataInfo is 'Дата';
comment on column DataPrime.ECom_DirectIndicators.CampaignID is 'ID кампании. Где 0 - там нет ID';
comment on column DataPrime.ECom_DirectIndicators.CategoryID is 'ID категории';
comment on column DataPrime.ECom_DirectIndicators.AdTypeID is 'ID атрибуции';
comment on column DataPrime.ECom_DirectIndicators.Impressions is 'Количество показов';
comment on column DataPrime.ECom_DirectIndicators.Cliks is 'Количество кликов';
comment on column DataPrime.ECom_DirectIndicators.Cost is 'Стоимость кликов=расход';
comment on column DataPrime.ECom_DirectIndicators.Visits is 'Количество визитов';
comment on column DataPrime.ECom_DirectIndicators.Transactions is 'Количество заказов';
comment on column DataPrime.ECom_DirectIndicators.B2B_Transactions is 'Количество заказов ЮЛ';
comment on column DataPrime.ECom_DirectIndicators.B2С_Transactions is 'Количество заказов ФЛ';
comment on column DataPrime.ECom_DirectIndicators.Purchase_Revenue is 'Сумма заказов=доход';
comment on column DataPrime.ECom_DirectIndicators.B2B_revenue is 'Сумма заказов ЮЛ';
comment on column DataPrime.ECom_DirectIndicators.B2С_revenue is 'Сумма заказов ФЛ';
comment on column DataPrime.ECom_DirectIndicators.goal_specification is 'Количество достижений цели "создать спецификацию"';
comment on column DataPrime.ECom_DirectIndicators.goal_smeta is 'количество достижений цели "создать смету"';
comment on column DataPrime.ECom_DirectIndicators.goal_registration_B2B is 'Количество достижений цели "регистрация ЮЛ"';
comment on column DataPrime.ECom_DirectIndicators.goal_registration_B2C is 'Количество достижений цели "регистрация ФЛ"';
comment on column DataPrime.ECom_DirectIndicators.goal_specification_В2В is 'Количество достижений цели "создать спецификацию" ЮЛ';
comment on column DataPrime.ECom_DirectIndicators.goal_specification_В2С is 'Количество достижений цели "создать спецификацию" ФЛ';
comment on column DataPrime.ECom_DirectIndicators.goal_smeta_B2B is 'Количество достижений цели "создать смету" ЮЛ';
comment on column DataPrime.ECom_DirectIndicators.goal_smeta_B2С is 'Количество достижений цели "создать смету" ФЛ';

create table DataPrime.ECom_InactiveCL81Mnth (
    DataInfo date,
    MnfCode int,
    Series varchar(50),
    Class81_Code varchar(16),
    Status varchar(4),
    Qlt_Inactive81 int)
order by
    Status,
    Class81_Code,
    Series,
    MnfCode,
    DataInfo
segmented by hash(
    DataPrime.ECom_InactiveCL81Mnth.Status,
    DataPrime.ECom_InactiveCL81Mnth.Class81_Code,
    DataPrime.ECom_InactiveCL81Mnth.Series,
    DataPrime.ECom_InactiveCL81Mnth.MnfCode) all nodes ksafe;

comment on table DataPrime.ECom_InactiveCL81Mnth is 'Витрина от АНАЛИТИКА ПЛЮС: карточки без активности со статусами S,Z,Z1,Z2,R (гранулярность месяц)';
comment on column DataPrime.ECom_InactiveCL81Mnth.DataInfo is 'Дата';
comment on column DataPrime.ECom_InactiveCL81Mnth.MnfCode is 'Код производителя';
comment on column DataPrime.ECom_InactiveCL81Mnth.Series is 'Серия';
comment on column DataPrime.ECom_InactiveCL81Mnth.Class81_Code is 'Код 81-го классификатора';
comment on column DataPrime.ECom_InactiveCL81Mnth.Status is 'Статус товара';
comment on column DataPrime.ECom_InactiveCL81Mnth.Qlt_Inactive81 is 'Кол-во неактивных карточек';

create table DataPrime.ECom_InactiveCL81Wk (
    DataInfo date,
    MnfCode int,
    Series varchar(50),
    Class81_Code varchar(16),
    Status varchar(4),
    Qlt_Inactive81 int)
order by
    Status,
    Class81_Code,
    Series,
    MnfCode,
    DataInfo
segmented by hash(
    DataPrime.ECom_InactiveCL81Wk.Status,
    DataPrime.ECom_InactiveCL81Wk.Class81_Code,
    DataPrime.ECom_InactiveCL81Wk.Series,
    DataPrime.ECom_InactiveCL81Wk.MnfCode) all nodes ksafe;

comment on table DataPrime.ECom_InactiveCL81Wk is 'Витрина от АНАЛИТИКА ПЛЮС: карточки без активности со статусами S,Z,Z1,Z2,R (гранулярность неделя)';
comment on column DataPrime.ECom_InactiveCL81Wk.DataInfo is 'Дата';
comment on column DataPrime.ECom_InactiveCL81Wk.MnfCode is 'Код производителя';
comment on column DataPrime.ECom_InactiveCL81Wk.Series is 'Серия';
comment on column DataPrime.ECom_InactiveCL81Wk.Class81_Code is 'Код 81-го классификатора';
comment on column DataPrime.ECom_InactiveCL81Wk.Status is 'Статус товара';
comment on column DataPrime.ECom_InactiveCL81Wk.Qlt_Inactive81 is 'Кол-во неактивных карточек';

create table DataPrime.ECom_InactiveCL33Mnth (
    DataInfo date,
    Class33_Code varchar(10),
    Status varchar(4),
    Qlt_Inactive33 int)
order by
    Status,
    Class33_Code,
    DataInfo
segmented by hash(
    DataPrime.ECom_InactiveCL33Mnth.Status,
    DataPrime.ECom_InactiveCL33Mnth.Class33_Code) all nodes ksafe;

comment on table DataPrime.ECom_InactiveCL33Mnth is 'Витрина от АНАЛИТИКА ПЛЮС: карточки без активности со статусами S,Z,Z1,Z2,R (гранулярность месяц)';
comment on column DataPrime.ECom_InactiveCL33Mnth.DataInfo is 'Дата';
comment on column DataPrime.ECom_InactiveCL33Mnth.Class33_Code is 'Код 33-го классификатора';
comment on column DataPrime.ECom_InactiveCL33Mnth.Status is 'Статус товара';
comment on column DataPrime.ECom_InactiveCL33Mnth.Qlt_Inactive33 is 'Кол-во неактивных карточек';

create table DataPrime.ECom_InactiveCL33Wk (
    DataInfo date,
    Class33_Code varchar(10),
    Status varchar(4),
    Qlt_Inactive33 int)
order by
    Status,
    Class33_Code,
    DataInfo
segmented by hash(
    DataPrime.ECom_InactiveCL33Wk.Status,
    DataPrime.ECom_InactiveCL33Wk.Class33_Code) all nodes ksafe;

comment on table DataPrime.ECom_InactiveCL33Wk is 'Витрина от АНАЛИТИКА ПЛЮС: карточки без активности со статусами S,Z,Z1,Z2,R (гранулярность неделя)';
comment on column DataPrime.ECom_InactiveCL33Wk.DataInfo is 'Дата';
comment on column DataPrime.ECom_InactiveCL33Wk.Class33_Code is 'Код 33-го классификатора';
comment on column DataPrime.ECom_InactiveCL33Wk.Status is 'Статус товара';
comment on column DataPrime.ECom_InactiveCL33Wk.Qlt_Inactive33 is 'Кол-во неактивных карточек';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
