create table DataMart.DshECom_NomenclatureAnlsWk (
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
    DataMart.DshECom_NomenclatureAnlsWk.Status,
    DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsWk.MnfCode,
    DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_4,
    DataMart.DshECom_NomenclatureAnlsWk.Series) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsWk is 'Витрина "Анализ номенклатуры" гранулярность неделя';
comment on column DataMart.DshECom_NomenclatureAnlsWk.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_NomenclatureAnlsWk.Series is 'Серия';
comment on column DataMart.DshECom_NomenclatureAnlsWk.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsWk.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsWk.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsWk.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsWk.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsWk.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsWk.ReplacedCards is 'Карточек с заменой';
comment on column DataMart.DshECom_NomenclatureAnlsWk.VisitsCnt is 'Количество визитов';

create table DataMart.DshECom_NomenclatureAnlsWkCL33 (
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
    DataMart.DshECom_NomenclatureAnlsWkCL33.Status,
    DataMart.DshECom_NomenclatureAnlsWkCL33.Class33_Code_2,
    DataMart.DshECom_NomenclatureAnlsWkCL33.Class33_Code_3,
    DataMart.DshECom_NomenclatureAnlsWkCL33.Class33_Code_4) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsWkCL33 is 'Витрина "Сводные данные по товарным отделам" гранулярность неделя в рамках 33 кл-ра';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.Class33_Code_2 is 'Кл-р 33 ур 2 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.Class33_Code_3 is 'Кл-р 33 ур 3 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.Class33_Code_4 is 'Кл-р 33 ур 4 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL33.ReplacedCards is 'Карточек с заменой';

create table DataMart.DshECom_NomenclatureAnlsWkCL81 (
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
    DataMart.DshECom_NomenclatureAnlsWkCL81.Status,
    DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_4) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsWkCL81 is 'Витрина "Показатели по товарным группам и статусамы" гранулярность неделя в рамках 81 кл-ра';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsWkCL81.ReplacedCards is 'Карточек с заменой';

create table DataMart.DshECom_NomenclatureAnlsWkTrfc (
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
    Refusals float,
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
    Class81_Code_1,
    Class81_Code_2,
    Class81_Code_3,
    MnfCode,
    Class81_Code_4,
    Series,
    DataInfo
segmented by hash (
    DataMart.DshECom_NomenclatureAnlsWkTrfc.Status,
    DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsWkTrfc.MnfCode,
    DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_4,
    DataMart.DshECom_NomenclatureAnlsWkTrfc.Series) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsWkTrfc is 'Витрина "Анализ номенклатуры" (источник трафика на карточки) гранулярность неделя по трафику';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.TrafficSourceOrder is 'Источник трафика, порядок';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.SearchEngineRootOrder is 'Поисковая система, порядок';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.Series is 'Серия';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.VisitsCnt is 'Количество визитов';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.Refusals is 'Количество отказов';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.DirectActiveCards is 'Карточки с просмотрами прямые входы';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.DirectVisitsCnt is 'Количество визитов прямые входы';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.DirectRefusals is 'Количество отказов прямые входы';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.YaActiveCards is 'Карточки с просмотрами Яндекс';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.YaVisits is 'Количество визитов Яндекс';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.YaRefusals is 'Количество отказов Яндекс';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.GActiveCards is 'Карточки с просмотрами Google';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.GVisits is 'Количество визитов Google';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.GRefusals is 'Количество отказов Google';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.OtherActiveCards is 'Карточки с просмотрами прочие поисковые системы';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.OtherVisits is 'Количество визитов прочие поисковые системы';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.OtherRefusals is 'Количество отказов прочие поисковые системы';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.OtherTrfcActiveCards is 'Карточки с просмотрами прочий трафик';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.OtherTrfcVisits is 'Количество визитов прочий трафик';
comment on column DataMart.DshECom_NomenclatureAnlsWkTrfc.OtherTrfcRefusals is 'Количество отказов прочий трафик';

create table DataMart.DshECom_NomenclatureAnlsWk_Inact (
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
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Status,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_1,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Class33_Code_2,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_2,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Class33_Code_3,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_3,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.MnfCode,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_4,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Class33_Code_4,
    DataMart.DshECom_NomenclatureAnlsWk_Inact.Series) all nodes ksafe;

comment on table DataMart.DshECom_NomenclatureAnlsWk_Inact is 'Витрина "Анализ номенклатуры" гранулярность неделя + неактивные карточки по 33 и 81 классификаторам';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.DataInfo is 'Дата';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Class33_Code_2 is 'Кл-р 33 ур 2 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Class33_Code_3 is 'Кл-р 33 ур 3 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Class33_Code_4 is 'Кл-р 33 ур 4 (Товарный отдел)';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_1 is 'Кл-р 81 ур 1 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_2 is 'Кл-р 81 ур 2 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_3 is 'Кл-р 81 ур 3 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Class81_Code_4 is 'Кл-р 81 ур 4 (Категория товара)';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.MnfCode is 'Код производителя';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Series is 'Серия';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.Status is 'Статус';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.ActiveCards is 'Карточки с просмотрами';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.TotalCards is 'Карточек всего + неактивные';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.TrfcPsCards is 'Карточек с трафиком из ПС';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.AddBuskCards is 'Карточек с добавлением в корзину';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.PurchasedCards is 'Карточек с оформлением';
comment on column DataMart.DshECom_NomenclatureAnlsWk_Inact.ReplacedCards is 'Карточек с заменой';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
