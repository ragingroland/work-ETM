create table DataMart.DshGenerManag_OtPlan (
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class305_Code_1 varchar(6),
    OtPlan float,
    OtFact float)
order by
    Class63_Code_2,
    Class305_Code_1,
    Class63_Code_3,
    DataInfo
segmented by hash(
    DataMart.DshGenerManag_OtPlan.Class63_Code_2,
    DataMart.DshGenerManag_OtPlan.Class305_Code_1,
    DataMart.DshGenerManag_OtPlan.Class63_Code_3) all nodes ksafe;

comment on table DataMart.DshGenerManag_OtPlan is 'Витрина с планами и фактами ТО для генерального дашборда в разрезе Class63_Code_2, Class63_Code_3, Class305_Code_1, DataInfo (месяцы , первый день) по BI-840';
comment on column DataMart.DshGenerManag_OtPlan.DataInfo is 'Дата';
comment on column DataMart.DshGenerManag_OtPlan.Class63_Code_2 is 'код 63 кл-ра ур 2';
comment on column DataMart.DshGenerManag_OtPlan.Class63_Code_3 is 'код 63 кл-ра ур 3';
comment on column DataMart.DshGenerManag_OtPlan.Class305_Code_1 is 'код 305 кл-ра ур 1';
comment on column DataMart.DshGenerManag_OtPlan.OtPlan is 'ТО план';
comment on column DataMart.DshGenerManag_OtPlan.OtFact is 'ТО факт';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
