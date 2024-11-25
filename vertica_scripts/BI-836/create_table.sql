create table DataPrime.Estaff_VacancyStatus (
    Num int,
    Code varchar(50),
    Name varchar(80))
order by Code, Name unsegmented all nodes;

comment on table DataPrime.Estaff_VacancyStatus is 'Cправочник статусов вакансий';
comment on column DataPrime.Estaff_VacancyStatus.Num is 'Целочисленный уникальный код';
comment on column DataPrime.Estaff_VacancyStatus.Code is 'Код статуса из Estaff';
comment on column DataPrime.Estaff_VacancyStatus.Name is 'Наименование статуса';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
