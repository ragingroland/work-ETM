create table DataMart.DshECom_NomenclatureAnlsMnth (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(150),
    Status varchar(4),
    ActiveCards float,
    TotalCards float,
    TrfcPsCards float,
    AddBuskCards float,
    PurchasedCards float,
    ReplacedCards float)
order by
    Status,
    Class81_Code_1,
    Class81_Code_2,
    Class81_Code_3,
    MnfCode,
    Class81_Code_4,
    Series,
    DataInfo
segmented by hash (
    DataMart.DshECom_NomenclatureAnlsMnth.Status,
    DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsMnth.MnfCode,
    DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_4,
    DataMart.DshECom_NomenclatureAnlsMnth.Series) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsMnth is 'Витрина "Анализ номенклатуры" гранулярность месяц';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.Series is 'Серия';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.ReplacedCards is 'Карточек с заменой';
comment on column DataMart.DshECom_NomenclatureAnlsMnth.VisitsCnt is 'Количество визитов';

create table DataMart.DshECom_NomenclatureAnlsMnthCL33 (
    DataInfo date,
    Class33_Code_2 varchar(4),
    Class33_Code_3 varchar(6),
    Class33_Code_4 varchar(10),
    Status varchar(4),
    ActiveCards float,
    TotalCards float,
    TrfcPsCards float,
    AddBuskCards float,
    PurchasedCards float,
    ReplacedCards float)
order by
    Status,
    Class33_Code_2,
    Class33_Code_3,
    Class33_Code_4,
    DataInfo
segmented by hash (
    DataMart.DshECom_NomenclatureAnlsMnthCL33.Status,
    DataMart.DshECom_NomenclatureAnlsMnthCL33.Class33_Code_2,
    DataMart.DshECom_NomenclatureAnlsMnthCL33.Class33_Code_3,
    DataMart.DshECom_NomenclatureAnlsMnthCL33.Class33_Code_4) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsMnthCL33 is 'Витрина "Сводные данные по товарным отделам" гранулярность месяц в рамках 33 кл-ра';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.Class33_Code_2 is 'Кл-р 33 ур 2 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.Class33_Code_3 is 'Кл-р 33 ур 3 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.Class33_Code_4 is 'Кл-р 33 ур 4 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL33.ReplacedCards is 'Карточек с заменой';

create table DataMart.DshECom_NomenclatureAnlsMnthCL81 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    Status varchar(4),
    ActiveCards float,
    TotalCards float,
    TrfcPsCards float,
    AddBuskCards float,
    PurchasedCards float,
    ReplacedCards float)
order by
    Status,
    Class81_Code_1,
    Class81_Code_2,
    Class81_Code_3,
    Class81_Code_4,
    DataInfo
segmented by hash (
    DataMart.DshECom_NomenclatureAnlsMnthCL81.Status,
    DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_4) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsMnthCL81 is 'Витрина "Показатели по товарным группам и статусамы" гранулярность месяц в рамках 81 кл-ра';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsMnthCL81.ReplacedCards is 'Карточек с заменой';

create table DataMart.DshECom_NomenclatureAnlsMnthTrfc (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(150),
    Status varchar(4),
    TrafficSourceOrder float,
    SearchEngineRootOrder float,
    ActiveCards float,
    VisitsCnt float,
    Refusals float
    DirectActiveCards float,
    DirectVisitsCnt float,
    DirectRefusals float,
    YaActiveCards float,
    YaVisits float,
    YaRefusals float,
    GActiveCards float,
    GVisits float,
    GRefusals float,
    OtherActiveCards float,
    OtherVisits float,
    OtherRefusals float,
    OtherTrfcActiveCards float,
    OtherTrfcVisits float,
    OtherTrfcRefusals float)
order by
    Status,
    TrafficSourceID,
    SearchEngineRootID,
    Class81_Code_1,
    Class81_Code_2,
    Class81_Code_3,
    MnfCode,
    Class81_Code_4,
    Series,
    DataInfo
segmented by hash (
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.Status,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.TrafficSourceID,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.SearchEngineRootID,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.MnfCode,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_4,
    DataMart.DshECom_NomenclatureAnlsMnthTrfc.Series) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsMnthTrfc is 'Витрина "Анализ номенклатуры" (источник трафика на карточки) гранулярность месяц по трафику';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.TrafficSourceOrder is 'ID трафика';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.SearchEngineRootOrder is 'ID поисковой системы';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.Series is 'Серия';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.VisitsCnt is 'Количество визитов';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.Refusals is 'Количество отказов';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.DirectActiveCards is 'Карточки с просмотрами прямые входы';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.DirectVisitsCnt is 'Количество визитов прямые входы';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.DirectRefusals is 'Количество отказов прямые входы';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.YaActiveCards is 'Карточки с просмотрами Яндекс';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.YaVisits is 'Количество визитов Яндекс';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.YaRefusals is 'Количество отказов Яндекс';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.GActiveCards is 'Карточки с просмотрами Google';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.GVisits is 'Количество визитов Google';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.GRefusals is 'Количество отказов Google';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.OtherActiveCards is 'Карточки с просмотрами прочие поисковые системы';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.OtherVisits is 'Количество визитов прочие поисковые системы';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.OtherRefusals is 'Количество отказов прочие поисковые системы';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.OtherTrfcActiveCards is 'Карточки с просмотрами прочий трафик';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.OtherTrfcVisits is 'Количество визитов прочий трафик';
comment on column DataMart.DshECom_NomenclatureAnlsMnthTrfc.OtherTrfcRefusals is 'Количество отказов прочий трафик';

create table DataMart.DshECom_NomenclatureAnlsMnth_Inact (
    DataInfo date,
    Class33_Code_2 varchar(4),
    Class33_Code_3 varchar(6),
    Class33_Code_4 varchar(10),
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    MnfCode int,
    Series varchar(150),
    Status varchar(4),
    ActiveCards float,
    TotalCards float,
    TrfcPsCards float,
    AddBuskCards float,
    PurchasedCards float,
    ReplacedCards float)
order by
    Status,
    Class81_Code_1,
    Class33_Code_2,
    Class81_Code_2,
    Class33_Code_3,
    Class81_Code_3,
    MnfCode,
    Class81_Code_4,
    Class33_Code_4,
    Series,
    DataInfo
segmented by hash (
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Status,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class33_Code_2,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class33_Code_3,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.MnfCode,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_4,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class33_Code_4,
    DataMart.DshECom_NomenclatureAnlsMnth_Inact.Series) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsMnth_Inact is 'Витрина "Анализ номенклатуры" гранулярность месяц + неактивные карточки по 33 и 81 классификаторам';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class33_Code_2 is 'Кл-р 33 ур 2 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class33_Code_3 is 'Кл-р 33 ур 3 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class33_Code_4 is 'Кл-р 33 ур 4 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Series is 'Серия';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsMnth_Inact.ReplacedCards is 'Карточек с заменой';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
