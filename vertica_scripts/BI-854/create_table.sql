create table DataPrime.CSI_ElmaClaims (
    DataInfo date,
    CliCode int,
    ProcID int,
    Mark int,
    Class132_Code varchar(30))
order by
    CliCode,
    Class132_Code,
    ProcID,
    DataInfo
segmented by hash (
    DataPrime.CSI_ElmaClaims.CliCode,
    DataPrime.CSI_ElmaClaims.Class132_Code,
    DataPrime.CSI_ElmaClaims.ProcID) all nodes ksafe;

comment on table DataPrime.CSI_ElmaClaims is 'Выгрузка из Elma: Рекламации';
comment on column DataPrime.CSI_ElmaClaims.DataInfo is 'Дата';
comment on column DataPrime.CSI_ElmaClaims.CliCode is 'Код клиента';
comment on column DataPrime.CSI_ElmaClaims.ProcID is 'ID процесса';
comment on column DataPrime.CSI_ElmaClaims.Mark is 'Оценка';
comment on column DataPrime.CSI_ElmaClaims.Class132_Code is 'Код 132 классификатора';

create table DataPrime.CSI_ElmaSrvcQlty (
    DataInfo date,
    CliCode int,
    ProcID int,
    Mark varchar(6),
    Code varchar(8),
    Class132_Code varchar(30))
order by
    Code,
    CliCode,
    Class132_Code,
    ProcID,
    DataInfo
segmented by hash (
    DataPrime.CSI_ElmaSrvcQlty.Code,
    DataPrime.CSI_ElmaSrvcQlty.CliCode,
    DataPrime.CSI_ElmaSrvcQlty.Class132_Code,
    DataPrime.CSI_ElmaSrvcQlty.ProcID) all nodes ksafe;

comment on table DataPrime.CSI_ElmaSrvcQlty is 'Выгрузка из Elma: Качество обслуживания';
comment on column DataPrime.CSI_ElmaSrvcQlty.DataInfo is 'Дата';
comment on column DataPrime.CSI_ElmaSrvcQlty.CliCode is 'Код клиента';
comment on column DataPrime.CSI_ElmaSrvcQlty.ProcID is 'ID процесса';
comment on column DataPrime.CSI_ElmaSrvcQlty.Mark is 'Оценка';
comment on column DataPrime.CSI_ElmaSrvcQlty.Code is 'Код причины';
comment on column DataPrime.CSI_ElmaSrvcQlty.Class132_Code is 'Код 132 классификатора';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
