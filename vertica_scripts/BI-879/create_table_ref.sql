create table DataMart.DshMCB_KBWrkCliTypeRef (
    Code varchar(6),
    Name varchar(36))
order by Code unsegmented all nodes;

comment on table DataMart.DshMCB_KBWrkCliTypeRef is 'Справочник кодов и наименований типов клиентов для витрин по МКБ блок "Работа с КБ"';
comment on column DataMart.DshMCB_KBWrkCliTypeRef.Code is 'Код типа клиента';
comment on column DataMart.DshMCB_KBWrkCliTypeRef.Name is 'Наименование типа клиента';


insert into DataMart.DshMCB_KBWrkCliTypeRef values(101, 'Общие клиенты');
insert into DataMart.DshMCB_KBWrkCliTypeRef values(102, 'Поляна ЭТМ');
insert into DataMart.DshMCB_KBWrkCliTypeRef values(103, 'Поляна конкурентов');

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
