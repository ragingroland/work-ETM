create table DataMart.DescClustCmpPrcEtmMarkt (
    Clust_Code int,
    Clust_Name varchar(76)) unsegmented all nodes;

create table DataMart.DescSubClustCmpPrcEtmMarkt (
    Clust_Code int,
    SubClust_Code int,
    LowBound float,
    UpBound float,
    Clust_Name varchar(76),
    SubClust_Name varchar(78)) unsegmented all nodes;

comment on table DataMart.DescClustCmpPrcEtmMarkt is 'справочник кластеров анализа товаров по ЦО ЭТМ (код кластера и наименование кластера)';
comment on column DataMart.DescClustCmpPrcEtmMarkt.Clust_Code is 'код кластера';
comment on column DataMart.DescClustCmpPrcEtmMarkt.Clust_Name is 'название кластера';

comment on table DataMart.DescSubClustCmpPrcEtmMarkt is 'справочник содержимого кластеров товаров по ЦО ЭТМ (код кластера, код подкластера, название подкластера, величина левой границы подкластера, величина правой границы подкластера)';
comment on column DataMart.DescSubClustCmpPrcEtmMarkt.Clust_Code is 'код кластера';
comment on column DataMart.DescSubClustCmpPrcEtmMarkt.SubClust_Code is 'код подкластера';
comment on column DataMart.DescSubClustCmpPrcEtmMarkt.LowBound is 'нижняя граница';
comment on column DataMart.DescSubClustCmpPrcEtmMarkt.UpBound is 'верхняя граница';
comment on column DataMart.DescSubClustCmpPrcEtmMarkt.Clust_Name is 'название кластера';
comment on column DataMart.DescSubClustCmpPrcEtmMarkt.SubClust_Name is 'название подкластера';

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