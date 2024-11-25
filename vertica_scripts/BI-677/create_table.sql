-- 10.07.2024 Организовать хранение в Vertica (отчет WMS по операциям) - "Производительность СК ЛЦ"
-- https://utrack.etm.corp/issue/BI-677/BI-UL-Organizovat-hranenie-v-Vertica-otchet-WMS-po-operaciyam-Proizvoditelnost-SK-LC

create table DataPrime.WMSInfoOper_Perf (
    StoreCode int,
    DataInfo date,
    EmpNum varchar(30),
    ops_ID int,
    WrkOpCount int,
    OpZone varchar(10) default '',
    pos_ID int,
    Internship varchar(2))
order by
    StoreCode,
    OpZone,
    EmpNum,
    DataInfo
segmented by hash (
    DataPrime.WMSInfoOper_Perf.StoreCode,
    DataPrime.WMSInfoOper_Perf.OpZone,
    DataPrime.WMSInfoOper_Perf.EmpNum
    ) all nodes ksafe 1;
comment on table DataPrime.WMSInfoOper_Perf is 'Таблица, содержащая в себе выгрузку отчета по операциям из WMS для дашборда "Производительность СК ЛЦ"';
comment on column DataPrime.WMSInfoOper_Perf.DataInfo is 'Дата';
comment on column DataPrime.WMSInfoOper_Perf.StoreCode is 'Код склада';
comment on column DataPrime.WMSInfoOper_Perf.EmpNum is 'Таб.номер работника';
comment on column DataPrime.WMSInfoOper_Perf.pos_ID is 'Должность работника, которая тянется из WMSInfoOper_Perf_pos';
comment on column DataPrime.WMSInfoOper_Perf.ops_ID is 'Вид совершенной операции, которая тянется из WMSInfoOper_Perf_ops';
comment on column DataPrime.WMSInfoOper_Perf.WrkOpCount is 'Количество совершенных операций';
comment on column DataPrime.WMSInfoOper_Perf.OpZone is 'Зона совершенной операции';
comment on column DataPrime.WMSInfoOper_Perf.Internship is 'Является ли работник стажером Yes/No';

create table DataPrime.WMSInfoOper_Perf_pos (
    pos_ID int,
    EmpPos varchar(80))
unsegmented all nodes ksafe 1;
comment on table DataPrime.WMSInfoOper_Perf_pos is 'Справочник для DataPrime.WMSInfoOper_Perf, содержащий в себе должности';
comment on column DataPrime.WMSInfoOper_Perf_pos.pos_ID is 'ID номер для должности';
comment on column DataPrime.WMSInfoOper_Perf_pos.EmpPos is 'Должность работника';

create table DataPrime.WMSInfoOper_Perf_ops (
    ops_ID int,
    WrkOp varchar(100))
unsegmented all nodes ksafe 1;
comment on table DataPrime.WMSInfoOper_Perf_ops is 'Справочник для DataPrime.WMSInfoOper_Perf, содержащий в себе наименования операций';
comment on column DataPrime.WMSInfoOper_Perf_ops.ops_ID is 'ID номер для операции';
comment on column DataPrime.WMSInfoOper_Perf_ops.WrkOp is 'Вид совершенной операции';

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