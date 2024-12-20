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
main as ( -- собираем все воедино
select
    trunc(cbs.DataInfo, 'q')::date as DataInfo,
    coalesce(left(cg1.ClassCodeGrp, 4), '') as Class63_Code_UP,
    coalesce(left(cg2.ClassCodeGrp, 4), '') as Class63_Code_IG,
    '03' as Class294_Code, -- принудительно указываем дивизион, потому что весь ЭТМ хочется видеть как "Электрика"
    Class295_Code,
    coalesce(klc296.Class296_Code, '') as Class296_Code,
    coalesce(cg298.ClassCodeGrp, '99999') as Code_QuasiBrand,
    coalesce(c79.Class79_Code, '') as Class79_Code,
    sum(SumShipped) as SumShipped
from sibistat cbs
left join c79 on cbs.CustInn = c79.CustInn and cbs.CustCode = c79.CustCode and rn = 1 -- берем первый попавшийся 79ЖЕ
left join public.ClassGroup cg1 on -- получаем 63 УП
    cg1.ClassTypeSrc = 14
    and cg1.ClassTypeGrp = 63
    and cg1.ClassCodeSrc = left(cbs.CustInn, 4)
    and cg1.ClassCodeGrp LIKE 'УП%'
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
    and cbs.Class294_Code = klc296.Class294_Code
where not exists (select 1 from DataPrime.BrandsTrdsExclCL295CRM where Class295_Code = cbs.Class295_Code) -- исключаем ИНН с признаком 1096
    and not exists (select 1 from notE where CustInn = cbs.CustInn) -- исключаем 79Е
    and cbs.Class295_Code = '00001' -- считаем суммы только для ЭТМ
group by trunc(cbs.DataInfo, 'q')::date, 2, 3, 4, 5, 6, 7, 8
union -- объединяются
select
    trunc(cbs.DataInfo, 'q')::date as DataInfo,
    coalesce(left(cg1.ClassCodeGrp, 4), '') as Class63_Code_UP,
    coalesce(left(cg2.ClassCodeGrp, 4), '') as Class63_Code_IG,
    cbs.Class294_Code, -- оставляем 294 как есть, потому что сейчас считается все, кроме ЭТМ
    Class295_Code,
    coalesce(klc296.Class296_Code, '') as Class296_Code,
    coalesce(cg298.ClassCodeGrp, '99999') as Code_QuasiBrand,
    coalesce(c79.Class79_Code, '') as Class79_Code,
    sum(SumShipped) as SumShipped
from sibistat cbs
left join c79 on cbs.CustInn = c79.CustInn and cbs.CustCode = c79.CustCode and rn = 1
left join public.ClassGroup cg1 on
    cg1.ClassTypeSrc = 14
    and cg1.ClassTypeGrp = 63
    and cg1.ClassCodeSrc = left(cbs.CustInn, 4)
    and cg1.ClassCodeGrp LIKE 'УП%'
left join public.ClassGroup cg2 on
    cg2.ClassTypeSrc = 14
    and cg2.ClassTypeGrp = 63
    and cg2.ClassCodeSrc = left(cbs.CustInn, 4)
    and cg2.ClassCodeGrp LIKE 'ИГ%'
left join public.ClassGroup cg298 on
    cg298.ClassTypeSrc = 295
    and cg298.ClassTypeGrp = 298
    and cg298.ClassCodeSrc = cbs.Class295_Code
left join DataPrime.KontragLinkClass296_CliInn klc296 on cbs.CustInn = klc296.CliInn
    and cbs.Class294_Code = klc296.Class294_Code
where not exists (select 1 from DataPrime.BrandsTrdsExclCL295CRM where Class295_Code = cbs.Class295_Code)
    and not exists (select 1 from notE where CustInn = cbs.CustInn)
    and not (cbs.Class294_Code = '03' and cbs.Class295_Code = '00001') -- считаем суммы для всего, что не ЭТМ-Электрика
group by trunc(cbs.DataInfo, 'q')::date, 2, 3, 4, 5, 6, 7, 8)
select -- делается итоговый селект нужных столбцов
    DataInfo,
    Class63_Code_UP,
    Class63_Code_IG,
    Class294_Code,
    Class295_Code,
    Class296_Code,
    Code_QuasiBrand,
    Class79_Code,
    SumShipped
from main;

truncate table DataMart.DshMCB_FedRepQrt_TrnOvr;
select purge_table('DataMart.DshMCB_FedRepQrt_TrnOvr');
insert into DataMart.DshMCB_FedRepQrt_TrnOvr
select * from tmp_local;
commit;

select analyze_statistics('DataMart.DshMCB_FedRepQrt_TrnOvr');
