create table DataPrime.DWHCatalog (
    table_schema varchar(18),
    table_name varchar(94),
    objname varchar(112),
    tag varchar(8))
order by
    tag,
    table_schema,
    table_name
unsegmented all nodes ksafe 1;

comment on table DataPrime.DWHCatalog is 'Справочник тегов таблиц по принадлежности к фактам, справочникам или представлениям';
comment on column DataPrime.DWHCatalog.table_schema is 'Имя схемы';
comment on column DataPrime.DWHCatalog.table_name is 'Имя таблицы';
comment on column DataPrime.DWHCatalog.objname is 'Комбинация имени схемы и таблицы';
comment on column DataPrime.DWHCatalog.tag is 'Тег таблицы';

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