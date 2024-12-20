create local temp table tmp_WMSInfoOper_Perf ( -- создать врем.таблицу и
    StoreCode int,                              -- наполнить её из файлов
    DataInfo date,
    EmpNum varchar(100),
    WrkOp varchar(100),
    WrkOpCount int,
    OpZone varchar(100) default '',
    EmpPos varchar(100),
    Internship varchar(2))
on commit preserve rows;

copy tmp_WMSInfoOper_Perf ( -- дальше копирование данных из файлов
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\EKB.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\EKB.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\EKB.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\KZN.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\KZN.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\KZN.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\MSK.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\MSK.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\MSK.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\MY.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\MY.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\MY.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\NSK.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\NSK.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\NSK.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\RND.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\RND.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\RND.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\SAM.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\SAM.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\SAM.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\SPB.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\SPB.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\SPB.exc' direct skip 1;

copy tmp_WMSInfoOper_Perf (
    StoreCode,
    DataInfo format 'yyyy#mm#dd',
    EmpNum,
    WrkOp,
    WrkOpCount,
    OpZone,
    EmpPos,
    Internship)
from local 'H:\OLAP\WMSInfoOper_Perf\DATA\VRN.vcsv'
    delimiter ';'  
    null '' 
    enclosed by '"' 
rejected data 'H:\OLAP\WMSInfoOper_Perf\RUN\VRN.rej'
exceptions 'H:\OLAP\WMSInfoOper_Perf\RUN\VRN.exc' direct skip 1;

-- обновление справочников
insert into DataPrime.WMSInfoOper_Perf_pos -- должности
with maxID as (
    select max(pos_ID) as mid from DataPrime.WMSInfoOper_Perf_pos),
emppos as (
    select distinct upper(tmp_WMSInfoOper_Perf.EmpPos) as ep from tmp_WMSInfoOper_Perf
    left join DataPrime.WMSInfoOper_Perf_pos main on main.EmpPos = upper(tmp_WMSInfoOper_Perf.EmpPos)
    where main.pos_ID is null)
select 
    coalesce(mid,0) + rank() over(order by emppos.ep),
    emppos.ep
from maxID, emppos;
insert into DataPrime.WMSInfoOper_Perf_ops -- рабочие операции
with maxID as (
    select max(ops_ID) as mid from DataPrime.WMSInfoOper_Perf_ops),
wrkop as (
    select distinct upper(tmp_WMSInfoOper_Perf.WrkOp) as ep from tmp_WMSInfoOper_Perf
    left join DataPrime.WMSInfoOper_Perf_ops main on main.WrkOp = upper(tmp_WMSInfoOper_Perf.WrkOp)
    where main.ops_ID is null)
select 
    coalesce(mid,0) + rank() over(order by wrkop.ep),
    wrkop.ep
from maxID, wrkop;
commit;

-- очищает все проекции указанной таблицы
select purge_table('DataPrime.WMSInfoOper_Perf');

-- почистить в исходных табличках срезы по дате
delete
from DataPrime.WMSInfoOper_Perf
where exists (
    select 1
    from tmp_WMSInfoOper_Perf
    where tmp_WMSInfoOper_Perf.DataInfo = DataPrime.WMSInfoOper_Perf.DataInfo);

-- загрузить данные в основу
insert into DataPrime.WMSInfoOper_Perf
select
    StoreCode,
    DataInfo,
    EmpNum,
    o.ops_ID,
    WrkOpCount,
    OpZone,
    p.pos_ID,
    Internship
from tmp_WMSInfoOper_Perf w
left join DataPrime.WMSInfoOper_Perf_pos p on upper(w.EmpPos) = upper(p.EmpPos)
left join DataPrime.WMSInfoOper_Perf_ops o on upper(w.WrkOp) = upper(o.WrkOp);
commit;