create table DataPrime.Estaff_CandStatusBI (
    Code varchar(20),
    Name varchar(100))
order by Code unsegmented all nodes;

comment on table DataPrime.Estaff_CandStatusBI is 'Справочник статусов кандидатов (верхнеуровневые)';
comment on column DataPrime.Estaff_CandStatusBI.Code is 'Код статуса кандидата из Estaff';
comment on column DataPrime.Estaff_CandStatusBI.Name is 'Наименование статуса';

create table DataPrime.Estaff_CandStatus (
    Num int,
    Code varchar(80),
    Rejection int,
    Name varchar(100))
order by Code unsegmented all nodes;

comment on table DataPrime.Estaff_CandStatus is 'Cправочник статусов кандидатов (исходные)';
comment on column DataPrime.Estaff_CandStatus.Num is 'Уникальный код';
comment on column DataPrime.Estaff_CandStatus.Code is 'Код статуса кандидата из Estaff';
comment on column DataPrime.Estaff_CandStatus.Rejection is 'Признак для статуса отказа, 1 - да, является отказным статусом, 0 - не является';
comment on column DataPrime.Estaff_CandStatus.Name is 'Наименование статуса';

create table DataPrime.Estaff_Rejections (
    Num int,
    Code varchar(70),
    NameLvl1 varchar(80),
    NameLvl2 varchar(100))
order by Code unsegmented all nodes;

comment on table DataPrime.Estaff_Rejections is 'Cправочник причин отказа кандидатов (самоотказы или отклонение кандидата компанией)';
comment on column DataPrime.Estaff_Rejections.Num is 'Уникальный код';
comment on column DataPrime.Estaff_Rejections.Code is 'Код статуса кандидата из Estaff';
comment on column DataPrime.Estaff_Rejections.NameLvl1 is 'Наименование статуса уровень 1';
comment on column DataPrime.Estaff_Rejections.NameLvl2 is 'Наименование статуса уровень 2';

create table DataPrime.Estaff_CandStatusMap (
    BICode varchar(20),
    Code varchar(100))
order by CodeBI unsegmented all nodes;

comment on table DataPrime.Estaff_CandStatusMap is 'Cправочник соответствия этапов воронки (справочник CandStatusBI) и статусов кандидатов (справочник CandStatus)';
comment on column DataPrime.Estaff_CandStatusMap.BICode is 'Этап воронки';
comment on column DataPrime.Estaff_CandStatusMap.Code is 'Код статуса кандидата из Estaff';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
