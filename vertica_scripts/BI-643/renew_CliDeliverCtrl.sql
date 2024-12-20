-- временная таблица
create local temp table tmp_CliDelivCtrl (
    DataInfo varchar(50),
    StoreCode varchar(50),
    TerrCode varchar(40),
    DataReqDeliv varchar(50),
    UsrInvNumReqDelivNum varchar(150),
    UsrInvNumReqDelivDocNum varchar(150),
    CliStoreCode varchar(50),
    EmptyRow varchar(12),
    isCliVIP varchar(6),
    CliCode varchar(50),
    DataReqDelivFrom varchar(50),
    DataReqDelivTo varchar(50),
    DataReqDelivFact varchar(50))
on commit preserve rows;
truncate table tmp_CliDelivCtrl;

copy tmp_CliDelivCtrl (
    DataInfo,
    StoreCode,
    TerrCode,
    DataReqDeliv,
    UsrInvNumReqDelivNum,
    UsrInvNumReqDelivDocNum,
    CliStoreCode,
    EmptyRow,
    isCliVIP,
    CliCode,
    DataReqDelivFrom,
    DataReqDelivTo,
    DataReqDelivFact)
from local 'H:\OLAP\CliDelivCtrl\DATA\t-rep005.vcsv'
delimiter ';'  null '' enclosed by '"' rejectmax 1
rejected data 'H:\OLAP\CliDelivCtrl\RUN\renew_CliDelivCtrl.rej'
exceptions 'H:\OLAP\CliDelivCtrl\RUN\renew_CliDelivCtrl.exc' direct skip 1;


-- код терр-ии в UPPER
update tmp_CliDelivCtrl
set TerrCode = upper(TerrCode);
commit;

-- преобразование дат
update tmp_CliDelivCtrl
set DataInfo = to_date(DataInfo, 'yyyy-mm-dd')::varchar(50),
DataReqDeliv = to_date(DataReqDeliv, 'yyyy-mm-dd')::varchar(50),
DataReqDelivFrom = to_timestamp(DataReqDelivFrom, 'yyyy-mm-dd hh:mi')::varchar(50),
DataReqDelivTo = to_timestamp(DataReqDelivTo, 'yyyy-mm-dd hh:mi')::varchar(50),
DataReqDelivFact = to_timestamp(DataReqDelivFact, 'yyyy-mm-dd hh:mi')::varchar(50);
commit;

-- почистить в исходных табличках срезы
delete
from DataPrime.CliDelivCtrl
where exists (
    select 1
    from tmp_CliDelivCtrl
    where tmp_CliDelivCtrl.DataInfo::date = DataPrime.CliDelivCtrl.DataInfo
    );
commit;

-- Очищает все проекции указанной таблицы
select purge_table('DataPrime.CliDelivCtrl');

-- загрузить в таблички
insert into DataPrime.CliDelivCtrl
select
    to_date(DataInfo, 'yyyy-mm-dd') as DataInfo,
    to_number(StoreCode) as StoreCode,
    TerrCode,
    to_date(DataReqDeliv, 'yyyy-mm-dd') as DataReqDeliv,
    UsrInvNumReqDelivNum,
    UsrInvNumReqDelivDocNum,
    to_number(CliStoreCode) as CliStoreCode,
    isCliVIP,
    to_number(CliCode) as CliCode,
    to_date(DataReqDelivFrom, 'yyyy-mm-dd') as DataReqDelivFrom_date,
    case when length(DataReqDelivFrom) < 11 then null
    	else substring(right(to_char(DataReqDelivFrom), 8), 1, 5)::time end as DataReqDelivFrom_time,
    to_date(DataReqDelivTo, 'yyyy-mm-dd') as DataReqDelivTo_date,
    case when length(DataReqDelivTo) < 11 then null
    	else substring(right(to_char(DataReqDelivTo), 8), 1, 5)::time end as DataReqDelivTo_time,
    to_date(DataReqDelivFact, 'yyyy-mm-dd') as DataReqDelivFact_date,
    case when length(DataReqDelivFact) < 11 then null
    	else substring(right(to_char(DataReqDelivFact), 8), 1, 5)::time end as DataReqDelivFact_time
from tmp_CliDelivCtrl;
commit;