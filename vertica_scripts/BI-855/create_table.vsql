create table DataPrime.CSI_RDMapFdbk (
    DataInfo date,
    FeedbackID int,
    Rating float,
    City varchar(90),
    CompanyCode varchar(30))
order by
    City,
    CompanyCode,
    DataInfo
segmented by hash (
    DataPrime.CSI_RDMapFdbk.City,
    DataPrime.CSI_RDMapFdbk.CompanyCode) all nodes ksafe;

comment on table DataPrime.CSI_RDMapFdbk is 'Выгрузка из RocketData: Данные по оценкам с карт';
comment on column DataPrime.CSI_RDMapFdbk.DataInfo is 'Дата размещения оценки';
comment on column DataPrime.CSI_RDMapFdbk.FeedbackID is 'ID отзыва';
comment on column DataPrime.CSI_RDMapFdbk.Rating is 'Оценка';
comment on column DataPrime.CSI_RDMapFdbk.City is 'Город';
comment on column DataPrime.CSI_RDMapFdbk.CompanyCode is 'Код филиала';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
