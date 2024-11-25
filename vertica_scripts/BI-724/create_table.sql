create table DataPrime.Params4StockByRgdClust  (
    Class_Type int,
    Class_Code varchar(20),
    MnfCode int,
    K_1 float,
    K_2 float,
    K_3 float,
    K_4 float,
    Price_Type int,
    Clust_Code int) unsegmented all nodes;

comment on table DataPrime.Params4StockByRgdClust is 'Справочник кластеров, видов, коеффициентов цен и классификатора для скидочных и акционных цен';
comment on column DataPrime.Params4StockByRgdClust.Class_Type is 'Тип классификатора';
comment on column DataPrime.Params4StockByRgdClust.Class_Code is 'Код классификатора';
comment on column DataPrime.Params4StockByRgdClust.MnfCode is 'Код производителя';
comment on column DataPrime.Params4StockByRgdClust.K_1 is 'Коэффициент 1 к цене';
comment on column DataPrime.Params4StockByRgdClust.K_2 is 'Коэффициент 2 к цене';
comment on column DataPrime.Params4StockByRgdClust.K_3 is 'Коэффициент 3 к цене';
comment on column DataPrime.Params4StockByRgdClust.K_4 is 'Коэффициент 4 к цене';
comment on column DataPrime.Params4StockByRgdClust.Price_Type is 'Вид цены';
comment on column DataPrime.Params4StockByRgdClust.Clust_Code is 'Номер кластера';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
