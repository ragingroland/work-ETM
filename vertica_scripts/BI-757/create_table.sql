create table DataPrime.Rules37OldToAct (
    Class37_Code_Wrng varchar(18),
    Class37_Code_Right varchar(18)) unsegmented all nodes;

comment on table DataPrime.Rules37OldToAct is 'Табличка конвертации старого 37-го в новый для учета ПЦВ в витринах по эффективности МОПП';
comment on column DataPrime.Rules37OldToAct.Class37_Code_Wrng is 'Код класса 37-го классификатора (стар)';
comment on column DataPrime.Rules37OldToAct.Class37_Code_Right is 'Код класса 37-го классификатора (нов)';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
