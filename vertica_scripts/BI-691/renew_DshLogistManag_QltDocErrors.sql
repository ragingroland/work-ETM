CREATE LOCAL TEMP TABLE tmp ON COMMIT PRESERVE ROWS
AS SELECT * FROM DataMart.DshLogistManag_QltDocErrors 
WHERE DataInfo = '0001-01-01';
TRUNCATE TABLE tmp;

INSERT INTO tmp
WITH
StartDate as (
   select ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'MM'), -24) as td --плавающие два года
),
--собираем уникальные 132е из элмы-рут
Uniq132 as (
    select
        distinct Store_Class132_Code uniqcl132
    from StartDate sd
    inner join DataPrime.ElmaRootProc erp on sd.td <= erp.Proc_StartDate
),
--к уникальным 132ым из элмы-рут джойним наши две таблицы, чтобы вытащить сторкод
--попутно складываем тип и имя рядом
StoreCodeLC as (
    select
         uniqcl132
        ,rdc.StoreCode
        ,rdc.TypeStore
        ,rdc.LogistikCentreName
        ,row_number() over(partition by uniqcl132) as rn
    from Uniq132
    left join DataPrime.StoreLinkClass132 cl132 on cl132.Class132_Code = Uniq132.uniqcl132
    left join public.RegionDescCommon rdc on rdc.StoreCode = cl132.StoreCodeSymb
    where rdc.TypeStore in ('ОП', 'ЛЦ', 'ЦРС', 'ПрямыеДоставки')
),
--сюда собираем альтернативный сторкод и имя ЛЦ
LC as (
    select
        StoreCode code,
        LogistikCentreName lname 
    from public.RegionDescCommon 
    where TypeStore in ('ЛЦ', 'ЦРС')
),
cte_root as (
            select
                RootProc_Id,
                trunc(Proc_StartDate, 'MM')::date as DataInfo,
                lc.code as StoreCode
            from StartDate sd
            inner join DataPrime.ElmaRootProc erp on sd.td <= erp.Proc_StartDate
            left join StoreCodeLC rn on erp.Store_Class132_Code = rn.uniqcl132 and rn.rn = 1
            left join LC lc on rn.LogistikCentreName = lc.lname
            where Proc_StartDate >= sd.td
            group by 1, 2, 3),
--все из элмы-чайлд
RowAll as (
select
	r.DataInfo,
    r.StoreCode as StoreCode_LC,
    coalesce(ece.Position, '') as ManPosition,
    -- coalesce(DescMan.ManPosition,'') as ManPosition,
    count(distinct ecp.RootProc_Id) as QltDocErr
from StartDate, DataPrime.ElmaChildProc ecp
inner join cte_root r on ecp.RootProc_Id = r.RootProc_Id
left join DataPrime.ElmaChildEmplErrorCode ece on ecp.Code_PosEmpl = ece.Code and "Use" = 1
-- left join public.DescMan on lower(DescMan.UserLoginAd) = lower(ecp.Stage_Performer)
where ecp.Reason_Code in(5, 6)
    and ecp.Stage_Code ='13'
        and not exists (
            select
                1
            from DataPrime.ElmaChildProc r2
            where r2.RootProc_Id = r.RootProc_Id
                and r2.Stage_Code = '9')
group by 1, 2, 3)
select
     DataInfo
    ,StoreCode_LC
    ,ManPosition
    ,QltDocErr
from RowAll
order by DataInfo, StoreCode_LC, ManPosition, QltDocErr;
COMMIT;

TRUNCATE TABLE DataMart.DshLogistManag_QltDocErrors;

INSERT INTO DataMart.DshLogistManag_QltDocErrors 
SELECT * FROM tmp;
COMMIT;