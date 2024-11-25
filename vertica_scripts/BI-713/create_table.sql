create table DataMart.DshPricing_Clust1 (
    DataInfo date,
    DataInfo_dayofweek date,
    DataInfo_startingdayofweek date,
    DataInfo_monthstart date,
    region_id varchar(5),
    NetNum int,
    Class3_Code_2 varchar(4),
    MnfCode int,
    company_name varchar(50),
    comp_status varchar(20),
    outlier varchar(2),
    isTOP10 varchar(2),
    isTOP20 varchar(2),
    Clust_Code int,
    SubClust_Code int,
    Clust_merch_count int)
order by
    Clust_Code,
    isTOP10,
    isTOP20,
    company_name,
    comp_status,
    region_id,
    Class3_Code,
    DataInfo,
    DataInfo_monthstart,
    DataInfo_startingdayofweek,
    DataInfo_dayofweek
segmented by hash (
    DataMart.DshPricing_Clust1.Clust_Code,
    DataMart.DshPricing_Clust1.isTOP10,
    DataMart.DshPricing_Clust1.isTOP20,
    DataMart.DshPricing_Clust1.company_name,
    DataMart.DshPricing_Clust1.comp_status,
    DataMart.DshPricing_Clust1.region_id,
    DataMart.DshPricing_Clust1.Class3_Code) all nodes ksafe 1;

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
