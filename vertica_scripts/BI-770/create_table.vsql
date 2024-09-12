create table DataPrime.BrandsTrdsExclCL295CRM (
    Class295_Code varchar(10)) unsegmented all nodes;

comment on table DataPrime.BrandsTrdsExclCL295CRM is 'Список классов 295-го классификатора, которые исключаются из расчета показателей CRM (физически - это классы 295-го классификатора, помеченные признаком с кодом 1096 в Progress)';
comment on column DataPrime.BrandsTrdsExclCL295CRM.Class295_Code is 'Код 295-го классификатора';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
