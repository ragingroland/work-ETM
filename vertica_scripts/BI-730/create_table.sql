-- Разработка витрин для блока "Общие показатели МКБ" BI-730
-- https://utrack.etm.corp/issue/BI-730/BI-MKB-Razrabotka-vitrin-dlya-bloka-Obshie-pokazateli-MKB

create table DataMart.DshMCB_GeneralSheet_MCBTrnFact ( -- витрина по ГО
    DataInfo         date,
    QuartInfo        int,
    YearInfo         int,
    Class63_Code_2   varchar(8),
    Class63_Code_3   varchar(12),
    Class294_Code    varchar(4),
    Code_QuasiBrand /*Class295_Code*/    varchar(10),
    Class296_Code    varchar(6),
    Class79_Code     varchar(4),
    isETM            varchar(2),
    SumShipped       float
    )
order by
    isETM,
    YearInfo,
    QuartInfo,
    Class294_Code,
    Class63_Code_2,
    Class296_Code.
    Class79_Code,
    Class63_Code_3
    Code_QuasiBrand,
    DataInfo
segmented by hash (
    DataMart.DshMCB_GeneralSheet_MCBTrnFact.isETM,
    DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class294_Code,
    DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class63_Code_2,
    DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class296_Code,
    DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class79_Code,
    DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class63_Code_3,
    DataMart.DshMCB_GeneralSheet_MCBTrnFact.Code_QuasiBrand) all nodes ksafe 1;

comment on table DataMart.DshMCB_GeneralSheet_MCBTrnFact is 'Витрина по ГО игроков и ЭТМ за квартал';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.DataInfo is 'Дата певрого дня первого месяца квартала';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.QuartInfo is 'Квартал';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.YearInfo is 'Год';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class294_Code is 'Код 294-го классификатора 1-го уровня (дивизион)';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.Code_QuasiBrand is 'Бренд игрока';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class296_Code is 'Крупность клиента';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.Class79_Code is 'Код 79-го классификатора ветки G, "КвазиЦКГ"';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.isETM is 'Флаг ЭТМ/не ЭТМ';
comment on column DataMart.DshMCB_GeneralSheet_MCBTrnFact.SumShipped is 'Сумма ГО за квартал';


create table DataMart.DshMCB_GeneralSheet_MCBCCBFact ( -- витрина по ПКБ
    DataInfo           date,
    QuartInfo          int,
    YearInfo           int,
    CustInn            varchar(24),
    Class63_Code_2     varchar(8),
    Class63_Code_3     varchar(12),
    Class294_Code      varchar(4),
    Code_QuasiBrand /*Class295_Code*/      varchar(10),
    Class296_Code      varchar(6),
    Class79_Code       varchar(4),
    isETM              varchar(2),
    QntINN             varchar(2)
    )
order by
    isETM,
    QntINN,
    YearInfo,
    QuartInfo,
    Class294_Code,
    Class63_Code_2,
    Class296_Code,
    Class79_Code,
    Class63_Code_3,
    Code_QuasiBrand,
    CustInn,
    DataInfo
segmented by hash (
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.isETM,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.QntINN,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.YearInfo,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.QuartInfo,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class294_Code,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class63_Code_2,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class296_Code,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class79_Code,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class63_Code_3,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.Code_QuasiBrand,
    DataMart.DshMCB_GeneralSheet_MCBCCBFact.CustInn) all nodes ksafe 1;

comment on table DataMart.DshMCB_GeneralSheet_MCBCCBFact is 'Витрина по ГО игроков и ЭТМ за квартал';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.DataInfo is 'Дата певрого дня первого месяца квартала';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.QuartInfo is 'Квартал';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.YearInfo is 'Год';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.CustInn is 'ИНН покупателя';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class294_Code is 'Код 294-го классификатора 1-го уровня (дивизион)';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.Code_QuasiBrand is 'Бренд игрока';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class296_Code is 'Крупность клиента';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.Class79_Code is 'Код 79-го классификатора ветки G, "КвазиЦКГ"';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.isETM is 'Флаг ЭТМ/не ЭТМ';
comment on column DataMart.DshMCB_GeneralSheet_MCBCCBFact.QntINN is 'ПКБ (Если сумма ГО >= 100, то 1, в противном случае 0)';


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
