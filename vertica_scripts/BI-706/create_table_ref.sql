create table DataPrime.ElmaChildEmplError (
    pos_ID int,
    Position_EmplErr varchar(150),
    "Use" int default 0)
unsegmented all nodes ksafe 1;

comment on table DataPrime.ElmaChildEmplError is 'Справочник "Должность сотрудника, допустившего ошибку"';
comment on column DataPrime.ElmaChildEmplError.pos_ID is 'Уникальный код должности';
comment on column DataPrime.ElmaChildEmplError.Position_EmplErr is 'Должность сотрудника, допустившего ошибку';
comment on column DataPrime.ElmaChildEmplError."Use" is 'Участвует ли в анализе (1 = ДА, 0 = НЕТ)';

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