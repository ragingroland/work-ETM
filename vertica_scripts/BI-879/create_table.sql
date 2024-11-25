create table DataMart.DshMCB_KBWrkPCB (
    DataInfo date,
    CustInn varchar(24),
    Class63_Code_IG varchar(8),
    Class79_Code varchar(4),
    Class294_Code varchar(8),
    Class295_Code varchar(10),
    Class296_Code varchar(6),
    CliType_79X varchar(6),
    isRAEK int,
    isZKB int,
    isWarm int,
    SumShipped float)
order by
    isRAEK,
    isWarm,
    isZKB,
    CliType_79X,
    Class296_Code,
    Class63_Code_IG,
    Class294_Code,
    Class295_Code,
    Class79_Code,
    CustInn,
    DataInfo
segmented by hash (
    DataMart.DshMCB_KBWrkPCB.isRAEK,
    DataMart.DshMCB_KBWrkPCB.isWarm,
    DataMart.DshMCB_KBWrkPCB.isZKB,
    DataMart.DshMCB_KBWrkPCB.CliType_79X,
    DataMart.DshMCB_KBWrkPCB.Class296_Code,
    DataMart.DshMCB_KBWrkPCB.Class63_Code_IG,
    DataMart.DshMCB_KBWrkPCB.Class294_Code,
    DataMart.DshMCB_KBWrkPCB.Class295_Code,
    DataMart.DshMCB_KBWrkPCB.Class79_Code,
    DataMart.DshMCB_KBWrkPCB.CustInn) all nodes ksafe;

comment on table DataMart.DshMCB_KBWrkPCB is 'Витрина ПКБ для проекта BI-МКБ блока "Работа с КБ"';
comment on column DataMart.DshMCB_KBWrkPCB.DataInfo is 'Дата';
comment on column DataMart.DshMCB_KBWrkPCB.isRAEK is 'Флаг РАЭК 1 - да, 0 - нет';
comment on column DataMart.DshMCB_KBWrkPCB.isWarm is 'Флаг теплая база 1 - да, 0 - нет';
comment on column DataMart.DshMCB_KBWrkPCB.isZKB is 'Флаг ЗКБ 1 - да, 0 - нет';
comment on column DataMart.DshMCB_KBWrkPCB.CliType_79X is 'Код типа клиента';
comment on column DataMart.DshMCB_KBWrkPCB.Class296_Code is 'Крупность клиента';
comment on column DataMart.DshMCB_KBWrkPCB.Class63_Code_IG is 'Код 63 кл-ра ветка ИГ';
comment on column DataMart.DshMCB_KBWrkPCB.Class294_Code is 'Дивизион';
comment on column DataMart.DshMCB_KBWrkPCB.Class79_Code is 'Квази ЦКГ кл-р 79G';
comment on column DataMart.DshMCB_KBWrkPCB.Class295_Code is 'Бренд';
comment on column DataMart.DshMCB_KBWrkPCB.CustInn is 'ИНН';
comment on column DataMart.DshMCB_KBWrkPCB.SumShipped is 'ФАКТ ГО';

create table DataMart.DshMCB_KBWrkFact (
    DataInfo date,
    Class63_Code_IG varchar(8),
    Class79_Code varchar(4),
    Class294_Code varchar(8),
    Class295_Code varchar(10),
    Class296_Code varchar(6),
    CliType_79X varchar(6),
    isRAEK int,
    isZKB int,
    isWarm int,
    SumShipped float)
order by
    isRAEK,
    isWarm,
    isZKB,
    CliType_79X,
    Class296_Code,
    Class63_Code_IG,
    Class294_Code,
    Class295_Code,
    Class79_Code,
    DataInfo
segmented by hash (
    DataMart.DshMCB_KBWrkFact.isRAEK,
    DataMart.DshMCB_KBWrkFact.isWarm,
    DataMart.DshMCB_KBWrkFact.isZKB,
    DataMart.DshMCB_KBWrkFact.CliType_79X,
    DataMart.DshMCB_KBWrkFact.Class296_Code,
    DataMart.DshMCB_KBWrkFact.Class63_Code_IG,
    DataMart.DshMCB_KBWrkFact.Class294_Code,
    DataMart.DshMCB_KBWrkFact.Class295_Code,
    DataMart.DshMCB_KBWrkFact.Class79_Code) all nodes ksafe;

comment on table DataMart.DshMCB_KBWrkFact is 'Витрина ФАКТ ГО для проекта BI-МКБ блока "Работа с КБ"';
comment on column DataMart.DshMCB_KBWrkFact.DataInfo is 'Дата';
comment on column DataMart.DshMCB_KBWrkFact.isRAEK is 'Флаг РАЭК 1 - да, 0 - нет';
comment on column DataMart.DshMCB_KBWrkFact.isWarm is 'Флаг теплая база 1 - да, 0 - нет';
comment on column DataMart.DshMCB_KBWrkFact.isZKB is 'Флаг ЗКБ 1 - да, 0 - нет';
comment on column DataMart.DshMCB_KBWrkFact.CliType_79X is 'Код типа клиента';
comment on column DataMart.DshMCB_KBWrkFact.Class296_Code is 'Крупность клиента';
comment on column DataMart.DshMCB_KBWrkFact.Class63_Code_IG is 'Код 63 кл-ра ветка ИГ';
comment on column DataMart.DshMCB_KBWrkFact.Class294_Code is 'Дивизион';
comment on column DataMart.DshMCB_KBWrkFact.Class79_Code is 'Квази ЦКГ кл-р 79G';
comment on column DataMart.DshMCB_KBWrkFact.Class295_Code is 'Бренд';
comment on column DataMart.DshMCB_KBWrkFact.SumShipped is 'ФАКТ ГО';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
