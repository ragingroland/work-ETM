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

create local temp table n_wk
on commit preserve rows as
select
    DataInfo,
    left(dr.Class81_Code, 8) as Class81_Code,
    isnull(rmb.MnfCode, dr.MnfCode) as MnfCode, -- BI-824 Заявленные аналитические срезы: п.6
    isnull(dsr.Series, '') as Series,
    Status,
    TrafficSourceID,
    nm.RgdCode,
    QltVisit,
    QltAdd,
    QltClickReplace,
    QltPurchaseProd,
    QltRefusal
from DataPrime.ECom_NomenclatureWk nm
left join rgdrn rmb on nm.RgdCode = rmb.RgdCode and rn = 1
left join public.DescSeriesRgd dsr on nm.RgdCode = dsr.RgdCode
left join public.DescRgd dr on nm.RgdCode = dr.RgdCode
where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsWk)
    --DataInfo >= add_months(trunc(current_date, 'year')::date, - 12)
    and Status != 'N';

-- все меры считаются в конкретном срезе с конкретными условиями, по отдельности
create local temp table visitscnt -- количество визитов
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    sum(QltVisit) as VisitsCnt
from n_wk
group by 1, 2, 3, 4, 5;

create local temp table trfcpscards -- карточек с трафиком из ПС
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as TrfcPsCards
from n_wk
where TrafficSourceID = 3
    and QltVisit != 0
group by 1, 2, 3, 4, 5;

create local temp table addbuskcards -- карточек с добавлением в корзину
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as AddBuskCards
from n_wk
where QltAdd != 0
group by 1, 2, 3, 4, 5;

create local temp table purchasedcards -- оформленные
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as PurchasedCards
from n_wk
where QltPurchaseProd > 0
group by 1, 2, 3, 4, 5;

create local temp table replacedcards -- замены
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as ReplacedCards
from n_wk
where QltClickReplace != 0
group by 1, 2, 3, 4, 5;

create local temp table tmp_local
on commit preserve rows as
select
    DataInfo,
    Status,
    series,
    mnfcode,
    class81_code,
    count(distinct rgdcode) as active,
    cast(0 as float) as inactive,
    cast(0 as float) as TrfcPsCards,
    cast(0 as float) as AddBuskCards,
    cast(0 as float) as PurchasedCards,
    cast(0 as float) as ReplacedCards,
    cast(0 as float) as VisitsCnt
from n_wk
group by 1, 2, 3, 4, 5;

update tmp_local m
set VisitsCnt = vc.VisitsCnt
from visitscnt vc
where m.DataInfo = vc.DataInfo
    and m.Class81_Code = vc.Class81_Code
    and m.MnfCode = vc.MnfCode
    and m.Series = vc.Series
    and m.Status = vc.Status;
commit;

update tmp_local m
set TrfcPsCards = tpc.TrfcPsCards
from trfcpscards tpc
where m.DataInfo = tpc.DataInfo
    and m.Class81_Code = tpc.Class81_Code
    and m.MnfCode = tpc.MnfCode
    and m.Series = tpc.Series
    and m.Status = tpc.Status;
commit;

update tmp_local m
set AddBuskCards = abc.AddBuskCards
from addbuskcards abc
where m.DataInfo = abc.DataInfo
    and m.Class81_Code = abc.Class81_Code
    and m.MnfCode = abc.MnfCode
    and m.Series = abc.Series
    and m.Status = abc.Status;
commit;

update tmp_local m
set PurchasedCards = pc.PurchasedCards
from purchasedcards pc
where m.DataInfo = pc.DataInfo
    and m.Class81_Code = pc.Class81_Code
    and m.MnfCode = pc.MnfCode
    and m.Series = pc.Series
    and m.Status = pc.Status;
commit;

update tmp_local m
set ReplacedCards = rc.ReplacedCards
from replacedcards rc
where m.DataInfo = rc.DataInfo
    and m.Class81_Code = rc.Class81_Code
    and m.MnfCode = rc.MnfCode
    and m.Series = rc.Series
    and m.Status = rc.Status;
commit;

create local temp table at_cards
on commit preserve rows as
with
main as ( -- неактивные карточки
    select
        DataInfo,
        Status,
        series,
        mnfcode,
        class81_code,
        cast(0 as float) as active,
        sum(Qlt_Inactive81) as inactive,
        cast(0 as float) as TrfcPsCards,
        cast(0 as float) as AddBuskCards,
        cast(0 as float) as PurchasedCards,
        cast(0 as float) as ReplacedCards,
        cast(0 as float) as VisitsCnt
    from DataPrime.ECom_InactiveCL81Wk
    where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsWk)
    group by 1, 2, 3, 4, 5),
main2 as ( -- активные карточки
    select *
    from tmp_local)
select
    DataInfo,
    Status,
    series,
    mnfcode,
    class81_code,
    active as ActiveCards,
    active + inactive as TotalCards,
    TrfcPsCards,
    AddBuskCards,
    PurchasedCards,
    ReplacedCards,
    VisitsCnt
from main
union -- склеиваются активные и неактивные
select
    DataInfo,
    Status,
    series,
    mnfcode,
    class81_code,
    active as ActiveCards,
    active + inactive as TotalCards,
    TrfcPsCards,
    AddBuskCards,
    PurchasedCards,
    ReplacedCards,
    VisitsCnt
from main2;

-- удаляются данные старше анализируемого периода
delete from DataMart.DshECom_NomenclatureAnlsWk
where DataInfo < add_months(trunc(current_date, 'year')::date, - 12);
commit;

-- удалить из витрины данные большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_NomenclatureAnlsWk
where DataInfo >= (select min(DataInfo) from at_cards);
commit;

select purge_table('DataMart.DshECom_NomenclatureAnlsWk');

-- вставка в витрину с расшивкой 81 на уровни
insert into DataMart.DshECom_NomenclatureAnlsWk
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    MnfCode,
    replace(Series, '''', ''),
    Status,
    ActiveCards,
    TotalCards,
    TrfcPsCards,
    AddBuskCards,
    PurchasedCards,
    ReplacedCards,
    VisitsCnt
from at_cards;
commit;

select analyze_statistics('DataMart.DshECom_NomenclatureAnlsWk');
