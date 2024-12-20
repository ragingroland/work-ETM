-- 20.06.2024 фиксация первичных данных по "Контроль своевременности прибытия к клиентам"
-- https://utrack.etm.corp/issue/BI-643/Vertica-fiksaciya-pervichnyh-dannyh-po-Kontrol-svoevremennosti-pribytiya-k-klientam

create table DataPrime.CliDelivCtrl (
    DataInfo date,
    StoreCode int,
    TerrCode varchar(40),
    DataReqDeliv date,
    UsrInvNumReqDelivNum varchar(150),
    UsrInvNumReqDelivDocNum varchar(150),
    CliStoreCode int,
    isCliVIP varchar(6),
    CliCode int,
    DataReqDelivFrom_date date default null,
    DataReqDelivFrom_time time default null,
    DataReqDelivTo_date date default null,
    DataReqDelivTo_time time default null,
    DataReqDelivFact_date date default null,
    DataReqDelivFact_time time default null
    )
order by
    isCliVIP,
    StoreCode,
    TerrCode,
    CliStoreCode,
    CliCode,
    DataReqDeliv,
    DataInfo
segmented by hash (
    DataPrime.CliDelivCtrl.isCliVIP,
    DataPrime.CliDelivCtrl.StoreCode,
    DataPrime.CliDelivCtrl.TerrCode,
    DataPrime.CliDelivCtrl.CliStoreCode,
    DataPrime.CliDelivCtrl.CliCode,
    DataPrime.CliDelivCtrl.DataReqDeliv
    ) all nodes ksafe 1;
    
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