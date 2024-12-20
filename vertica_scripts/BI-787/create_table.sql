-- Разработка витрин для блока "Федеральный отчет по дивизионам" - BI-787
-- https://utrack.etm.corp/issue/BI-787/BI-MKB-Razrabotka-vitrin-dlya-bloka-Federalnyj-otchet-po-divizionam

create table DataMart.DshMCB_FedRepQrt_TrnOvrFact (
    DataInfo date,
	CustInn varchar(24),
	Class14_Code varchar(8),
    Class63_Code_UP varchar(8),
    Class63_Code_IG varchar(8),
    Class294_Code varchar(8),
    Class295_Code varchar(10),
    Class296_Code varchar(6),
    Code_QuasiBrand varchar(10),
    Class79_Code varchar(4),
    SumShipped float)
order by
    Class296_Code,
    Class63_Code_UP,
    Class63_Code_IG,
    Class294_Code,
    Class79_Code,
    Code_QuasiBrand,
    Class295_Code,
    Class14_Code,
    CustInn,
    DataInfo
segmented by hash (
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class296_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class63_Code_UP,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class63_Code_IG,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class294_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class79_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Code_QuasiBrand,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class295_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class14_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact.CustInn) all nodes ksafe;

comment on table DataMart.DshMCB_FedRepQrt_TrnOvrFact is 'Витрина ПКБ для блока "Федеральный отчет по дивизионам"';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class296_Code is 'Крупность клиента';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class63_Code_UP is '63 классификатор ветки УП';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class63_Code_IG is '63 классификатор ветки ИГ';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class294_Code is 'Дивизион';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class79_Code is 'Квази ЦКГ 79G';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Code_QuasiBrand is 'Квази бренд (кл298)';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class295_Code is 'Бренд игрока';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.Class14_Code is 'Территория';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.CustInn is 'ИНН игрока';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact.DataInfo is 'Дата';

create table DataMart.DshMCB_FedRepQrt_TrnOvr (
    DataInfo date,
    Class63_Code_UP varchar(8),
    Class63_Code_IG varchar(8),
    Class294_Code varchar(8),
    Class295_Code varchar(10),
    Class296_Code varchar(6),
    Code_QuasiBrand varchar(10),
    Class79_Code varchar(4),
    SumShipped float)
order by
    Class296_Code,
    Class63_Code_UP,
    Class63_Code_IG,
    Class294_Code,
    Class79_Code,
    Code_QuasiBrand,
    Class295_Code,
    DataInfo
segmented by hash (
    DataMart.DshMCB_FedRepQrt_TrnOvr.Class296_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvr.Class63_Code_UP,
    DataMart.DshMCB_FedRepQrt_TrnOvr.Class63_Code_IG,
    DataMart.DshMCB_FedRepQrt_TrnOvr.Class294_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvr.Class79_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvr.Code_QuasiBrand,
    DataMart.DshMCB_FedRepQrt_TrnOvr.Class295_Code) all nodes ksafe;

comment on table DataMart.DshMCB_FedRepQrt_TrnOvr is 'Витрина по ГО для блока "Федеральный отчет по дивизионам"';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.Class296_Code is 'Крупность клиента';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.Class63_Code_UP is '63 классификатор ветки УП';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.Class63_Code_IG is '63 классификатор ветки ИГ';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.Class294_Code is 'Дивизион';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.Class79_Code is 'Квази ЦКГ 79G';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.Code_QuasiBrand is 'Квази бренд (кл298)';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.Class295_Code is 'Бренд игрока';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvr.DataInfo is 'Дата';

create table DataMart.DshMCB_FedRepQrt_TrnOvrTerr (
    DataInfo date,
	Class14_Code varchar(8),
    Class63_Code_UP varchar(8),
    Class63_Code_IG varchar(8),
    Class294_Code varchar(8),
    Class295_Code varchar(10),
    Class296_Code varchar(6),
    Code_QuasiBrand varchar(10),
    Class79_Code varchar(4),
    SumShipped float)
order by
    Class296_Code,
    Class63_Code_UP,
    Class63_Code_IG,
    Class294_Code,
    Class79_Code,
    Code_QuasiBrand,
    Class295_Code,
    Class14_Code,
    DataInfo
segmented by hash (
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class296_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class63_Code_UP,
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class63_Code_IG,
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class294_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class79_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Code_QuasiBrand,
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class295_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class14_Code) all nodes ksafe;

comment on table DataMart.DshMCB_FedRepQrt_TrnOvrTerr is 'Витрина по ГО, детализованная по территориям, для блока "Федеральный отчет по дивизионам"';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class296_Code is 'Крупность клиента';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class63_Code_UP is '63 классификатор ветки УП';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class63_Code_IG is '63 классификатор ветки ИГ';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class294_Code is 'Дивизион';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class79_Code is 'Квази ЦКГ 79G';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Code_QuasiBrand is 'Квази бренд (кл298)';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class295_Code is 'Бренд игрока';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.Class14_Code is 'Территория';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrTerr.DataInfo is 'Дата';

create table DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB (
    DataInfo date,
    CustInn varchar(24),
    Class63_Code_UP varchar(8),
    Class63_Code_IG varchar(8),
    Code_QuasiBrand varchar(10),
    Class79_Code varchar(4),
    SumShipped float)
order by
    Class63_Code_UP,
    Class63_Code_IG,
    Class79_Code,
    Code_QuasiBrand,
    CustInn,
    DataInfo
segmented by hash (
    DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Class63_Code_UP,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Class63_Code_IG,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Class79_Code,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Code_QuasiBrand,
    DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.CustInn) all nodes ksafe;

comment on table DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB is 'Витрина ПКБ для блока "Федеральный отчет по дивизионам" как доработка от 11.10.2024';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Class63_Code_UP is '63 классификатор ветки УП';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Class63_Code_IG is '63 классификатор ветки ИГ';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Class79_Code is 'Квази ЦКГ 79G';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.Code_QuasiBrand is 'Квази бренд (кл298)';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.CustInn is 'ИНН игрока';
comment on column DataMart.DshMCB_FedRepQrt_TrnOvrFact_QB.DataInfo is 'Дата';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
