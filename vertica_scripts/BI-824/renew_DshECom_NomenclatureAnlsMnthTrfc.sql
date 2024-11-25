/* из первички берутся нужные для расчетов мер и построения витрины столбцы
на основании максимальной даты из витрины, из первички берутся более свежие данные
т.к если брать за весь период, то получается очень много. это было необходимо только для первого наполнения */
create local temp table rgdrn -- из-за дублирующихся строк в RgdMnfBrand множились данные
on commit preserve rows as
select distinct
    RgdCode,
    MnfCode,
    row_number() over(partition by RgdCode, MnfCode) as rn -- возьмем первый
from DataPrime.RgdMnfBrand;

create local temp table nm_trfc
on commit preserve rows as
select
    DataInfo,
    left(dr.Class81_Code, 8) as Class81_Code,
    isnull(rgdrn.MnfCode, dr.MnfCode) as MnfCode, -- BI-824 Заявленные аналитические срезы: п.6
    isnull(dsr.Series, '') as Series,
    Status,
    TrafficSourceID,
    SearchEngineRootID,
    nm.RgdCode,
    QltVisit,
    QltRefusal
from DataPrime.ECom_NomenclatureMnth nm
left join rgdrn on nm.RgdCode = rgdrn.RgdCode and rn = 1
left join public.DescSeriesRgd dsr on nm.RgdCode = dsr.RgdCode
left join public.DescRgd dr on nm.RgdCode = dr.RgdCode
where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsMnthTrfc)
    --DataInfo >= add_months(trunc(current_date, 'year')::date, - 12)
    and Status != 'N';

create local temp table measures
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as ActiveCards,
    sum(QltVisit) as VisitsCnt,
    sum(QltRefusal) as Refusals
from nm_trfc
group by 1, 2, 3, 4, 5;

create local temp table directentry
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    0 as TrafficSourceOrder,
    count(distinct RgdCode) as ActiveCards,
    sum(QltVisit) as VisitsCnt,
    sum(QltRefusal) as Refusals
from nm_trfc
where TrafficSourceID = 7
group by 1, 2, 3, 4, 5;

create local temp table othertrfc
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    2 as TrafficSourceOrder,
    count(distinct RgdCode) as ActiveCards,
    sum(QltVisit) as VisitsCnt,
    sum(QltRefusal) as Refusals
from nm_trfc
where TrafficSourceID not in (3, 7)
group by 1, 2, 3, 4, 5;

create local temp table yandex
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    0 as SearchEngineRootOrder,
    count(distinct RgdCode) as ActiveCards,
    sum(QltVisit) as VisitsCnt,
    sum(QltRefusal) as Refusals
from nm_trfc
where TrafficSourceID = 3
    and SearchEngineRootID = 0
group by 1, 2, 3, 4, 5;

create local temp table google
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    1 as SearchEngineRootOrder,
    count(distinct RgdCode) as ActiveCards,
    sum(QltVisit) as VisitsCnt,
    sum(QltRefusal) as Refusals
from nm_trfc
where TrafficSourceID = 3
    and SearchEngineRootID = 4
group by 1, 2, 3, 4, 5;

create local temp table othersearch
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    2 as SearchEngineRootOrder,
    count(distinct RgdCode) as ActiveCards,
    sum(QltVisit) as VisitsCnt,
    sum(QltRefusal) as Refusals
from nm_trfc
where TrafficSourceID = 3
    and SearchEngineRootID not in (0, 4)
group by 1, 2, 3, 4, 5;

-- промежуточная таблица, где будет нужный срез и меры, которые будут наполняться апдейтами ниже
create local temp table main
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    null as TrafficSourceOrder,
    null as SearchEngineRootOrder,
    cast(0 as float) as ActiveCards,
    cast(0 as float) as VisitsCnt,
    cast(0 as float) as Refusals,
    cast(0 as float) as DirectActiveCards,
    cast(0 as float) as DirectVisitsCnt,
    cast(0 as float) as DirectRefusals,
    cast(0 as float) as YaActiveCards,
    cast(0 as float) as YaVisits,
    cast(0 as float) as YaRefusals,
    cast(0 as float) as GActiveCards,
    cast(0 as float) as GVisits,
    cast(0 as float) as GRefusals,
    cast(0 as float) as OtherActiveCards,
    cast(0 as float) as OtherVisits,
    cast(0 as float) as OtherRefusals,
    cast(0 as float) as OtherTrfcActiveCards,
    cast(0 as float) as OtherTrfcVisits,
    cast(0 as float) as OtherTrfcRefusals
from nm_trfc
group by 1, 2, 3, 4, 5, 6;

update main m
set ActiveCards = ac.ActiveCards,
    VisitsCnt = ac.VisitsCnt,
    Refusals = ac.Refusals
from measures ac
where m.DataInfo = ac.DataInfo
    and m.Class81_Code = ac.Class81_Code
    and m.MnfCode = ac.MnfCode
    and m.Series = ac.Series
    and m.Status = ac.Status;
commit;

update main m
set TrafficSourceOrder = d.TrafficSourceOrder,
    DirectActiveCards = d.ActiveCards,
    DirectVisitsCnt = d.VisitsCnt,
    DirectRefusals = d.Refusals
from directentry d
where m.DataInfo = d.DataInfo
    and m.Class81_Code = d.Class81_Code
    and m.MnfCode = d.MnfCode
    and m.Series = d.Series
    and m.Status = d.Status;
commit;

update main m
set SearchEngineRootOrder = y.SearchEngineRootOrder,
    YaActiveCards = y.ActiveCards,
    YaVisits = y.VisitsCnt,
    YaRefusals = y.Refusals
from yandex y
where m.DataInfo = y.DataInfo
    and m.Class81_Code = y.Class81_Code
    and m.MnfCode = y.MnfCode
    and m.Series = y.Series
    and m.Status = y.Status;
commit;

update main m
set SearchEngineRootOrder = g.SearchEngineRootOrder,
    GActiveCards = g.ActiveCards,
    GVisits = g.VisitsCnt,
    GRefusals = g.Refusals
from google g
where m.DataInfo = g.DataInfo
    and m.Class81_Code = g.Class81_Code
    and m.MnfCode = g.MnfCode
    and m.Series = g.Series
    and m.Status = g.Status;
commit;

update main m
set SearchEngineRootOrder = o.SearchEngineRootOrder,
    OtherActiveCards = o.ActiveCards,
    OtherVisits = o.VisitsCnt,
    OtherRefusals = o.Refusals
from othersearch o
where m.DataInfo = o.DataInfo
    and m.Class81_Code = o.Class81_Code
    and m.MnfCode = o.MnfCode
    and m.Series = o.Series
    and m.Status = o.Status;
commit;

update main m
set OtherTrfcActiveCards = o.ActiveCards,
    OtherTrfcVisits = o.VisitsCnt,
    OtherTrfcRefusals = o.Refusals
from othertrfc o
where m.DataInfo = o.DataInfo
    and m.Class81_Code = o.Class81_Code
    and m.MnfCode = o.MnfCode
    and m.Series = o.Series
    and m.Status = o.Status;
commit;

update main m
set TrafficSourceOrder = 1
where SearchEngineRootOrder is not null
    and TrafficSourceOrder is null;
commit;

-- данные старше анализируемого периода удаляются
delete from DataMart.DshECom_NomenclatureAnlsMnthTrfc
where DataInfo < add_months(trunc(current_date, 'year')::date, - 12);
commit;

---- удалить из витрины данные большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_NomenclatureAnlsMnthTrfc
where DataInfo >= (select min(DataInfo) from main);
commit;

select purge_table('DataMart.DshECom_NomenclatureAnlsMnthTrfc');

-- вставка в витрину с расшивкой 81 на уровни
insert into DataMart.DshECom_NomenclatureAnlsMnthTrfc
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    MnfCode,
    replace(Series, '''', ''),
    Status,
    TrafficSourceOrder,
    SearchEngineRootOrder,
    ActiveCards,
    VisitsCnt,
    Refusals,
    DirectActiveCards,
    DirectVisitsCnt,
    DirectRefusals,
    YaActiveCards,
    YaVisits,
    YaRefusals,
    GActiveCards,
    GVisits,
    GRefusals,
    OtherActiveCards,
    OtherVisits,
    OtherRefusals,
    OtherTrfcActiveCards,
    OtherTrfcVisits,
    OtherTrfcRefusals
from main;
commit;

select analyze_statistics('DataMart.DshECom_NomenclatureAnlsMnthTrfc');
