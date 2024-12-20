create table DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt (
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class55_Code varchar(2),
    Category varchar(16),
    TypeMotiv varchar(18),
    ManCount int,
    PCBNorm int)
order by
    TypeMotiv,
    Category,
    Class63_Code_2,
    Class55_Code,
    Class63_Code_3,
    DataInfo
segmented by hash (
    DshSalesManag_EfDSMSheet_ManNormFactCnt.TypeMotiv,
    DshSalesManag_EfDSMSheet_ManNormFactCnt.Category,
    DshSalesManag_EfDSMSheet_ManNormFactCnt.Class63_Code_2,
    DshSalesManag_EfDSMSheet_ManNormFactCnt.Class55_Code,
    DshSalesManag_EfDSMSheet_ManNormFactCnt.Class63_Code_3) all nodes ksafe;

comment on table DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt is 'Витрина по фиксации фактической численности менеджеров и их нормативов';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.Class63_Code_2 is '63 классификатор уровня 2';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.Class63_Code_3 is '63 классификатор уровня 3';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.Class55_Code is 'Специализация';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.Category is 'Статус менеджера, он же категория';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.TypeMotiv is 'Тип мотивации';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.ManCount is 'Численность менеджеров';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt.PCBNorm is 'ПКБ норматив';

create table DataMart.DshSalesManag_EfDSMSheet_ManNormFact (
    DataInfo date,
    CliManCode varchar(50),
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class55_Code varchar(2),
    Category varchar(16),
    TypeMotiv varchar(18),
    SumSaled float)
order by
    TypeMotiv,
    Category,
    Class63_Code_2,
    Class55_Code,
    Class63_Code_3,
    CliManCode,
    DataInfo
segmented by hash (
    DshSalesManag_EfDSMSheet_ManNormFact.TypeMotiv,
    DshSalesManag_EfDSMSheet_ManNormFact.Category,
    DshSalesManag_EfDSMSheet_ManNormFact.Class63_Code_2,
    DshSalesManag_EfDSMSheet_ManNormFact.Class55_Code,
    DshSalesManag_EfDSMSheet_ManNormFact.Class63_Code_3,
    DshSalesManag_EfDSMSheet_ManNormFact.CliManCode) all nodes ksafe;

comment on table DataMart.DshSalesManag_EfDSMSheet_ManNormFact is 'Витрина по фиксации ПКБ менеджеров';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.Class63_Code_2 is '63 классификатор уровня 2';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.Class63_Code_3 is '63 классификатор уровня 3';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.Class55_Code is 'Специализация';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.Category is 'Статус менеджера, он же категория';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.TypeMotiv is 'Тип мотивации';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.CliManCode is 'Код клиента_Код менеджера';
comment on column DataMart.DshSalesManag_EfDSMSheet_ManNormFact.SumSaled is 'Сумма ГО';


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
