--  15.07.2024 Подготовка витрин для дашборда "Уровень принятия решения за 24 часа" (Elma)
-- https://utrack.etm.corp/issue/BI-684/BI-UL-podgotovka-vitrin-dlya-dashborda-Uroven-prinyatiya-resheniya-za-24-chasa-Elma

create table DataMart.DshLogistManag_AssessQltCompl (
    DataInfo date,
    Class132_Code_Level2 varchar(8),
    Class132_Code_Level4 varchar(20),
    ComplaintCountIn24 int,
    ComplaintCountOver24 int)
order by
    Class132_Code_Level2,
    Class132_Code_Level4,
    DataInfo
segmented by hash (
    DataMart.DshLogistManag_AssessQltCompl.Class132_Code_Level2,
    DataMart.DshLogistManag_AssessQltCompl.Class132_Code_Level4
    ) all nodes ksafe 1;

comment on table DataMart.DshLogistManag_AssessQltCompl is 'Витрина для дашборда "Уровень принятия решения за 24 часа" (Elma)';
comment on column DataMart.DshLogistManag_AssessQltCompl.DataInfo is 'Период (min гранулярность - месяц)';
comment on column DataMart.DshLogistManag_AssessQltCompl.Class132_Code_Level2 is 'ЛЦ - первые 4 символа кода 132-го склада';
comment on column DataMart.DshLogistManag_AssessQltCompl.Class132_Code_Level4 is 'ОП - первые 10 символов кода 132-го склада';
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