create table DataPrime.CSI_ElmaSrvcQltyRsns (
    Code varchar(8),
    CodeName_1 varchar(100),
    CodeName_2 varchar(220))
order by Code unsegmented all nodes;

comment on table DataPrime.CSI_ElmaSrvcQltyRsns is 'Справочник для хранения кодов, названий и ветвлений названий причин по выгрузке из Elma';
comment on column DataPrime.CSI_ElmaSrvcQltyRsns.Code is 'Код причины';
comment on column DataPrime.CSI_ElmaSrvcQltyRsns.CodeName_1 is 'Название причины';
comment on column DataPrime.CSI_ElmaSrvcQltyRsns.CodeName_2 is 'Детализация причины';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
