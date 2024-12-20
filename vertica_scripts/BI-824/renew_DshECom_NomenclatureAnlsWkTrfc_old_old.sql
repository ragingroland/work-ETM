/* из первички берутся нужные для расчетов мер и построения витрины столбцы
на основании максимальной даты из витрины, из первички берутся более свежие данные
т.к если брать за весь период, то получается очень много. это было необходимо только для первого наполнения */
create local temp table nm_trfc
on commit preserve rows as
select
    DataInfo,
    left(dr.Class81_Code, 8) as Class81_Code,
    isnull(rmb.MnfCode, dr.MnfCode) as MnfCode, -- BI-824 Заявленные аналитические срезы: п.6
    isnull(dsr.Series, '') as Series,
    Status,
    TrafficSourceID,
    SearchEngineRootID,
    nm.RgdCode,
    QltVisit,
    QltRefusal
from DataPrime.ECom_NomenclatureWk nm
left join DataPrime.RgdMnfBrand rmb on nm.RgdCode = rmb.RgdCode
left join public.DescSeriesRgd dsr on nm.RgdCode = dsr.RgdCode
left join public.DescRgd dr on nm.RgdCode = dr.RgdCode
where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsWkTrfc)
    --DataInfo >= add_months(trunc(current_date, 'year')::date, - 12)
    and Status != 'N';

-- все меры считаются за раз
create local temp table measures -- просмотренные карточки + визиты + отказы
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    TrafficSourceID,
    SearchEngineRootID,
    Series,
    Status,
    count(distinct RgdCode) as ActiveCards,
    sum(QltRefusal) as Refusals,
    sum(QltVisit) as VisitsCnt
from nm_trfc
group by 1, 2, 3, 4, 5, 6, 7;

-- промежуточная таблица, где будет нужный срез и меры, которые будут наполняться апдейтами ниже
create local temp table main
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    TrafficSourceID,
    SearchEngineRootID,
    MnfCode,
    Series,
    Status,
    cast(0 as float) as ActiveCards,
    cast(0 as float) as VisitsCnt,
    cast(0 as float) as Refusals
from nm_trfc
group by 1, 2, 3, 4, 5, 6, 7;

update main m
set ActiveCards = ac.ActiveCards
from measures ac
where m.DataInfo = ac.DataInfo
    and m.Class81_Code = ac.Class81_Code
    and m.MnfCode = ac.MnfCode
    and m.Series = ac.Series
    and m.Status = ac.Status
    and m.TrafficSourceID = ac.TrafficSourceID
    and m.SearchEngineRootID = ac.SearchEngineRootID;;
commit;

update main m
set VisitsCnt = vc.VisitsCnt
from measures vc
where m.DataInfo = vc.DataInfo
    and m.Class81_Code = vc.Class81_Code
    and m.MnfCode = vc.MnfCode
    and m.Series = vc.Series
    and m.Status = vc.Status
    and m.TrafficSourceID = vc.TrafficSourceID
    and m.SearchEngineRootID = vc.SearchEngineRootID;
commit;

update main m
set Refusals = r.Refusals
from measures r
where m.DataInfo = r.DataInfo
    and m.Class81_Code = r.Class81_Code
    and m.MnfCode = r.MnfCode
    and m.Series = r.Series
    and m.Status = r.Status
    and m.TrafficSourceID = r.TrafficSourceID
    and m.SearchEngineRootID = r.SearchEngineRootID;
commit;

-- удалаюятся данные старше анализируемого периода
delete from DataMart.DshECom_NomenclatureAnlsWkTrfc
where DataInfo < add_months(trunc(current_date, 'year')::date, - 12);
commit;

-- удалить из витрины данные большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_NomenclatureAnlsWkTrfc
where DataInfo >= (select min(DataInfo) from main);
commit;

select purge_table('DataMart.DshECom_NomenclatureAnlsWkTrfc');

-- вставка в витрину с расшивкой 81 по уровням
insert into DataMart.DshECom_NomenclatureAnlsWkTrfc
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    TrafficSourceID,
    SearchEngineRootID,
    MnfCode,
    replace(Series, '''', ''),
    Status,
    ActiveCards,
    VisitsCnt,
    Refusals
from main;
commit;

select analyze_statistics('DataMart.DshECom_NomenclatureAnlsWkTrfc');
