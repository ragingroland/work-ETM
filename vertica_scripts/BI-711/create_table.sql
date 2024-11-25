create table DataPrime.RgdLinkClass220 (
    RgdCode int,
    Class220_Code varchar(4))
order by
    RgdCode
segmented by hash (
    DataPrime.RgdLinkClass220.RgdCode) all nodes ksafe 1;

comment on table DataPrime.RgdLinkClass220 is 'Табличка для хранения 220-й классификации товара';
comment on column DataPrime.RgdLinkClass220.RgdCode is 'Код товара';
comment on column DataPrime.RgdLinkClass220.Class220_Code is 'Код классификатора';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
