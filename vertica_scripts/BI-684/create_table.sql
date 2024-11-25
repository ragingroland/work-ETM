--  15.07.2024 Подготовка витрин для дашборда "Уровень принятия решения за 24 часа" (Elma)
-- https://utrack.etm.corp/issue/BI-684/BI-UL-podgotovka-vitrin-dlya-dashborda-Uroven-prinyatiya-resheniya-za-24-chasa-Elma

create table DataMart.DshLogistManag_AssessQltCompl (
    DataInfo date,
    StoreCode_LC varchar(21),
    StoreCode_OP varchar(21),
    ComplaintCountIn24 int,
    ComplaintCountOver24 int)
order by
    StoreCode_LC,
    StoreCode_OP,
    DataInfo
segmented by hash (
    DataMart.DshLogistManag_AssessQltCompl.StoreCode_LC,
    DataMart.DshLogistManag_AssessQltCompl.StoreCode_OP
    ) all nodes ksafe 1;

comment on table DataMart.DshLogistManag_AssessQltCompl is 'Витрина для дашборда "Уровень принятия решения за 24 часа" (Elma)';
comment on column DataMart.DshLogistManag_AssessQltCompl.DataInfo is 'Период (min гранулярность - месяц)';
comment on column DataMart.DshLogistManag_AssessQltCompl.StoreCode_LC is 'ЛЦ - StoreCode из public.RegionDescCommon где TypeStore для StoreCode или LogistikCentreName будет в ЛЦ или ЦРС';
comment on column DataMart.DshLogistManag_AssessQltCompl.StoreCode_OP is 'ОП - StoreCode из public.RegionDescCommon где TypeStore для StoreCode будет в ОП, ЛЦ, ЦРС или ПрямыеДоставки';
comment on column DataMart.DshLogistManag_AssessQltCompl.ComplaintCountIn24 is 'Количество обращений в разрезе диапазонов до 24 часов';
comment on column DataMart.DshLogistManag_AssessQltCompl.ComplaintCountOver24 is 'Количество обращений в разрезе диапазонов более 24 часов';

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