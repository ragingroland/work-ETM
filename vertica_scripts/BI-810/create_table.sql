-- https://utrack.etm.corp/issue/BI-810/Vertica.-Cifrovaya-ten-Vertica-fiksaciya-dannyh-iz-522-h-priznakov-k-organizaciyam-po-predostavlyaemym-cenam
-- (Vertica. Цифровая тень) Vertica - фиксация данных из 522-х признаков к организациям по предоставляемым ценам

create table DataPrime.CliDctdPriceInfo (
    CliCode int,
    PriceDctd float,
    PricePreDctd float,
    DctDateFrom date,
    DctDateTo date)
order by
    CliCode,
    DctDateFrom
segmented by hash (
    DataPrime.CliDctdPriceInfo.CliCode) all nodes ksafe;

comment on table DataPrime.CliDctdPriceInfo is 'Информация о ценах клиента по скидкам';
comment on column DataPrime.CliDctdPriceInfo.CliCode is 'Код клиента';
comment on column DataPrime.CliDctdPriceInfo.PriceDctd is 'Цена со скидкой';
comment on column DataPrime.CliDctdPriceInfo.PricePreDctd is 'Цена до скидки';
comment on column DataPrime.CliDctdPriceInfo.DctDateFrom is 'Скидка действует с *дата*';
comment on column DataPrime.CliDctdPriceInfo.DctDateTo is 'Скидка действует по *дата*';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
