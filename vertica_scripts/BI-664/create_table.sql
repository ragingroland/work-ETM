-- 02.07.2024 Разработка витрин для "Своевременность доставок"
-- https://utrack.etm.corp/issue/BI-664/BI-UL-razrabotka-vitrin-dlya-Svoevremennost-dostavok

create table DataMart.DshLogistManag_OnTimeDeliv_Day (
    DataInfo date,
    MnthStrt date,
    StoreCode int,
    ReqNum varchar(150),
    CliCode int,
    ReqID int,
    LateCode int)
order by
    LateCode,
    StoreCode,
    CliCode,
    ReqID,
    ReqNum,
    DataInfo
segmented by hash (
    DataMart.DshLogistManag_OnTimeDeliv_Day.LateCode,
    DataMart.DshLogistManag_OnTimeDeliv_Day.StoreCode,
    DataMart.DshLogistManag_OnTimeDeliv_Day.CliCode,
    DataMart.DshLogistManag_OnTimeDeliv_Day.ReqID,
    DataMart.DshLogistManag_OnTimeDeliv_Day.ReqNum
    ) all nodes ksafe 1;
    
create table DataMart.DshLogistManag_OnTimeDeliv_Mnth (
    MnthStrt date,
    StoreCode int,
    ReqNum varchar(150),
    CliCode int,
    ReqID int,
    LateCode int)
order by
    LateCode,
    StoreCode,
    CliCode,
    ReqID,
    ReqNum
segmented by hash (
    DataMart.DshLogistManag_OnTimeDeliv_Mnth.LateCode,
    DataMart.DshLogistManag_OnTimeDeliv_Mnth.StoreCode,
    DataMart.DshLogistManag_OnTimeDeliv_Mnth.CliCode,
    DataMart.DshLogistManag_OnTimeDeliv_Mnth.ReqID,
    DataMart.DshLogistManag_OnTimeDeliv_Mnth.ReqNum
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