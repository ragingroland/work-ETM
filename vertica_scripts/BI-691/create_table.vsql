create table DataMart.DshLogistManag_QltDocErrTrn (
    DataInfo date,
    StoreCode_LC varchar(21),
    QltDocCount float,
    QltDocErr int)
order by
    StoreCode_LC,
    DataInfo
segmented by hash (
    DataMart.DshLogistManag_QltDocErrTrn.StoreCode_LC
    ) all nodes ksafe 1;

comment on table DataMart.DshLogistManag_QltDocErrTrn is 'Витрина для дашборда "Доля подтвержденных ошибок" (Elma) - ГО + док с ошибками';
comment on column DataMart.DshLogistManag_QltDocErrTrn.DataInfo is 'Период (min гранулярность - месяц)';
comment on column DataMart.DshLogistManag_QltDocErrTrn.StoreCode_LC is 'ЛЦ - StoreCode из public.RegionDescCommon где TypeStore для StoreCode или LogistikCentreName будет в ЛЦ или ЦРС';
comment on column DataMart.DshLogistManag_QltDocErrTrn.QltDocCount is 'Количество отгруженных документов';
comment on column DataMart.DshLogistManag_QltDocErrTrn.QltDocErr is 'Количество документов с ошибками';

create table DataMart.DshLogistManag_QltDocErrors (
    DataInfo date,
    StoreCode_LC varchar(21),
    ManPosition varchar(300),
    QltDocErr int)
order by
    StoreCode_LC,
    ManPosition,
    DataInfo
segmented by hash (
    DataMart.DshLogistManag_QltDocErrors.StoreCode_LC,
    DataMart.DshLogistManag_QltDocErrors.ManPosition
    ) all nodes ksafe 1;

comment on table DataMart.DshLogistManag_QltDocErrors is 'Витрина для дашборда "Доля подтвержденных ошибок" (Elma) - должность + док с ошибками';
comment on column DataMart.DshLogistManag_QltDocErrors.DataInfo is 'Период (min гранулярность - месяц)';
comment on column DataMart.DshLogistManag_QltDocErrors.StoreCode_LC is 'ЛЦ - StoreCode из public.RegionDescCommon где TypeStore для StoreCode или LogistikCentreName будет в ЛЦ или ЦРС';
comment on column DataMart.DshLogistManag_QltDocErrors.ManPosition is 'Должность';
comment on column DataMart.DshLogistManag_QltDocErrors.QltDocErr is 'Количество документов с ошибками';

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