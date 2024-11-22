create local temp table tmp_local
on commit preserve rows as
with
sibistat as ( -- сразу берутся нужные данные из первички за конкретный период
    select
        DataInfo,
        CustInn,
        CustCode,
        left(Class294_Code, 2) as Class294_Code,
        Class295_Code,
        SumShipped
    from public.CBStatTrader
    where DataInfo >= add_months(trunc(current_date - 1 , 'year'), -24)),
c79 as ( -- ищем 79ЖЕ
    select
        cbs.CustInn,
        left(Class79_Code, 2) as Class79_Code,
        cbs.CustCode,
        row_number() over(partition by CustInn, CustCode) as rn
    from sibistat cbs
    left join public.KontragLinkClass79 klc79 on cbs.CustCode = klc79.CliCode
        and klc79.Class79_1 = 'G'),
notE as ( -- исключения для 79Е
    select CustInn from sibistat
    inner join public.KontragLinkClass79 on CustCode = CliCode and Class79_1 = 'E'
    group by 1),
isZKB as (
    select
        CliCode
    from sibistat
    inner join public.KontragLinkClass37Hist on CustCode = CliCode
        and sibistat.DataInfo = trunc(current_date - 1, 'mm')::date
    group by 1),
isWarm as (
    select
        CustCode,
        sum(SumShipped) as SumShipped
    from sibistat
    where Class295_Code = 00001
        and trunc(DataInfo, 'q')::date = trunc(add_months(current_date, -6), 'q')::date
    group by 1
    having sum(SumShipped) > 0),
etm79x as (
    select
        trunc(DataInfo, 'q')::date as DataInfo,
        CustInn,
        Class294_Code,
        1 as Class295_Code,
        sum(SumShipped) as SumShipped
    from sibistat
    inner join public.KontragLinkClass79 on CustCode = CliCode and Class79_1 = 'Х'
    where Class295_Code = 00001
    group by 1, 2, 3, 4),
nonetm79x as (
    select
        trunc(DataInfo, 'q')::date as DataInfo,
        CustInn,
        Class294_Code,
        2 as Class295_Code,
        sum(SumShipped) as SumShipped
    from sibistat
    inner join public.KontragLinkClass79 on CustCode = CliCode and Class79_1 = 'Х'
    where Class295_Code != 00001
    group by 1, 2, 3, 4),
x79 as (
    select
        trunc(cbs.DataInfo, 'q')::date as DataInfo,
        cbs.CustInn,
        cbs.Class294_Code,
        sum(etm79x.SumShipped) as SumShipped_etm,
        sum(nonetm79x.SumShipped) as SumShipped_nonetm,
        case
            when SumShipped_etm > 0 and SumShipped_nonetm > 0
                then '101'
            when SumShipped_etm > 0 and SumShipped_nonetm = 0
                then '102'
            when SumShipped_etm = 0 and SumShipped_nonetm > 0
                then '103'
        end as CliType_79X
    from sibistat cbs
    left join etm79x on etm79x.DataInfo = cbs.DataInfo
        and etm79x.CustInn = cbs.CustInn
        and etm79x.Class294_Code = cbs.Class294_Code
    left join nonetm79x on cbs.DataInfo = nonetm79x.DataInfo
        and cbs.CustInn = nonetm79x.CustInn
        and cbs.Class294_Code = nonetm79x.Class294_Code
    group by 1, 2, 3
    having SumShipped_etm >= 0
        and SumShipped_nonetm >= 0)
select
    trunc(cbs.DataInfo, 'q')::date as DataInfo,
    coalesce(left(cg2.ClassCodeGrp, 4), '') as Class63_Code_IG,
    coalesce(c79.Class79_Code, '') as Class79_Code,
    cbs.Class294_Code,
    Class295_Code,
    coalesce(klc296.Class296_Code, '') as Class296_Code,
    isnull(CliType_79X, '') as CliType_79X,
    case
        when cg298.ClassCodeGrp = 90004
            then 1
        else 0
    end as isRAEK,
    case
        when CliCode is not null
            then 1
        else 0
    end as isZKB,
    case
        when isWarm.CustCode is not null
            then 1
        else 0
    end as isWarm,
    sum(cbs.SumShipped) as SumShipped
from sibistat cbs
left join c79 on cbs.CustInn = c79.CustInn and cbs.CustCode = c79.CustCode and rn = 1 -- берем первый попавшийся 79ЖЕ
left join public.ClassGroup cg2 on -- получаем 63 ИГ
    cg2.ClassTypeSrc = 14
    and cg2.ClassTypeGrp = 63
    and cg2.ClassCodeSrc = left(cbs.CustInn, 4)
    and cg2.ClassCodeGrp LIKE 'ИГ%'
left join public.ClassGroup cg298 on -- получаем 298 (квази бренд)
    cg298.ClassTypeSrc = 295
    and cg298.ClassTypeGrp = 298
    and cg298.ClassCodeSrc = cbs.Class295_Code
left join DataPrime.KontragLinkClass296_CliInn klc296 on cbs.CustInn = klc296.CliInn -- получаем 296 (крупность клиента)
    and klc296.Class294_Code = cbs.Class294_Code
left join isZKB on cbs.CustCode = isZKB.CliCode -- флаг ЗКБ
left join isWarm on cbs.CustCode = isWarm.CustCode -- флаг теплой базы
left join x79 on cbs.DataInfo = x79.DataInfo -- код типа клиента
    and cbs.CustInn = x79.CustInn
    and cbs.Class294_Code = x79.Class294_Code
where not exists (select 1 from notE where CustInn = cbs.CustInn) -- исключаем 79Е
    and not exists (select 1 from DataPrime.BrandsTrdsExclCL295CRM where Class295_Code = cbs.Class295_Code) -- исключаем ИНН с признаком 1096
group by trunc(cbs.DataInfo, 'q')::date, 2, 3, 4, 5, 6, 7, 8, 9, 10;

truncate table DataMart.DshMCB_KBWrkFact;
insert into DataMart.DshMCB_KBWrkFact
select * from tmp_local;
commit;

select analyze_statistics('DataMart.DshMCB_KBWrkFact')
