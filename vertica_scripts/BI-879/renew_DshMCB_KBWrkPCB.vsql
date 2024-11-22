create local temp table tmp_local
on commit preserve rows as
with
sibistat as ( -- сразу берутся нужные данные из первички за конкретный период
    select
        trunc(DataInfo, 'q')::date as DataInfo,
        CustInn,
        CustCode,
        left(Class294_Code, 2) as Class294_Code,
        Class295_Code,
        sum(SumShipped) as SumShipped
    from public.CBStatTrader
    where DataInfo >= add_months(trunc(current_date - 1 , 'year'), -24)
    group by 1, 2, 3, 4, 5
    having sum(SumShipped) > 0),
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
isZKB as ( -- для флага ЗКБ
    select
        CustInn
    from sibistat
    inner join public.KontragLinkClass37Hist on CustCode = CliCode
        and KontragLinkClass37Hist.DataInfo = trunc(current_date - 1, 'mm')::date
    where not exists (select 1 from DataPrime.Rules_ExclCl37FromACB4DtMarts -- исключения где шестой символ в 37 классе="У" или пятый символ в 37 = "Р"
            where public.KontragLinkClass37Hist.Class37_Code like DataPrime.Rules_ExclCl37FromACB4DtMarts.MaskCl37)
    group by 1),
isWarm as ( -- для флага теплой базы
    select
        DataInfo,
        CustInn
    from sibistat
    where Class295_Code = 00001
    group by 1, 2),
etm79x as ( -- поиск 79Х для ЭТМ
    select
        DataInfo,
        CustInn,
        Class294_Code,
        sum(SumShipped) as SumShipped
    from sibistat
    where Class295_Code = 00001
    group by 1, 2, 3),
nonetm79x as ( -- поиск 79Х для не-ЭТМ
    select
        DataInfo,
        CustInn,
        Class294_Code,
        sum(SumShipped) as SumShipped
    from sibistat
    where Class295_Code != 00001
    group by 1, 2, 3),
x79 as ( -- соединение данных первички + 79Х ЭТМ + 79Х не-ЭТМ с присвоением кода типа клиента
    select
        cbs.DataInfo,
        cbs.CustInn,
        cbs.Class294_Code,
        isnull(sum(etm79x.SumShipped), 0) as SumShipped_etm,
        isnull(sum(nonetm79x.SumShipped), 0) as SumShipped_nonetm,
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
    group by 1, 2, 3)
select
    cbs.DataInfo,
    cbs.CustInn,
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
        when isZKB.CustInn is not null
            then 1
        else 0
    end as isZKB,
    case
        when isWarm.CustInn is not null
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
left join isZKB on cbs.CustInn = isZKB.CustInn -- флаг ЗКБ
left join isWarm on cbs.CustInn = isWarm.CustInn -- флаг теплой базы
    and cbs.DataInfo = isWarm.DataInfo
left join x79 on cbs.DataInfo = x79.DataInfo -- код типа клиента
    and cbs.CustInn = x79.CustInn
    and cbs.Class294_Code = x79.Class294_Code
where not exists (select 1 from notE where CustInn = cbs.CustInn) -- исключаем 79Е
    and not exists (select 1 from DataPrime.BrandsTrdsExclCL295CRM where Class295_Code = cbs.Class295_Code) -- исключаем ИНН с признаком 1096
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11;

truncate table DataMart.DshMCB_KBWrkPCB;
insert into DataMart.DshMCB_KBWrkPCB
select * from tmp_local;
commit;

truncate table DataMart.DshMCB_KBWrkFact;
insert into DataMart.DshMCB_KBWrkFact
select
    DataInfo,
    Class63_Code_IG,
    Class79_Code,
    Class294_Code,
    Class295_Code,
    Class296_Code,
    CliType_79X,
    isRAEK,
    isZKB,
    isWarm,
    sum(SumShipped) as SumShipped
from DataMart.DshMCB_KBWrkPCB
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10;
commit;

select analyze_statistics('DataMart.DshMCB_KBWrkPCB');
select analyze_statistics('DataMart.DshMCB_KBWrkFact');
