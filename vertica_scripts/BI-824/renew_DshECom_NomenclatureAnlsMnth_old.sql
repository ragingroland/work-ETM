/* из первички берутся нужные для расчетов мер и построения витрины столбцы
на основании максимальной даты из витрины, из первички берутся более свежие данные
т.к если брать за весь период, то получается очень много. это было необходимо только для первого наполнения */
create local temp table n_mnth
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
from DataPrime.ECom_NomenclatureMnth nm
left join DataPrime.RgdMnfBrand rmb on nm.RgdCode = rmb.RgdCode
left join public.DescSeriesRgd dsr on nm.RgdCode = dsr.RgdCode
left join public.DescRgd dr on nm.RgdCode = dr.RgdCode
where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsMnth)
    -- DataInfo >= add_months(trunc(current_date, 'year')::date, - 12)
    and Status != 'N';


-- все меры считаются в конкретном срезе с конкретными условиями, по отдельности
create local temp table activecards -- считаются просмотренные карточки
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as ActiveCards
from n_mnth
group by 1, 2, 3, 4, 5;

create local temp table totalcards -- считаются карточки всего
on commit preserve rows as
select
    n.DataInfo,
    n.Class81_Code,
    n.MnfCode,
    n.Series,
    n.Status,
    count(distinct RgdCode) + isnull(Qlt_Inactive81, 0) as TotalCards
from n_mnth n
left join DataPrime.ECom_InactiveCL81Mnth n81 on n.DataInfo = n81.DataInfo
    and n.Class81_Code = n81.Class81_Code
    and n.MnfCode = n81.MnfCode
    and n.Series = n81.Series
    and n.Status = n81.Status
group by 1, 2, 3, 4, 5, Qlt_Inactive81;

create local temp table trfcpscards -- карточки с трафиком из ПС
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as TrfcPsCards
from n_mnth
where TrafficSourceID = 3
    and QltVisit != 0
group by 1, 2, 3, 4, 5;

create local temp table addbuskcards -- карточки с добавлением в корзину
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as AddBuskCards
from n_mnth
where QltAdd != 0
group by 1, 2, 3, 4, 5;

create local temp table purchasedcards -- купленные
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    Status,
    count(distinct RgdCode) as PurchasedCards
from n_mnth
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
from n_mnth
where QltClickReplace != 0
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
    cast(0 as float) as ActiveCards,
    cast(0 as float) as TotalCards,
    cast(0 as float) as TrfcPsCards,
    cast(0 as float) as AddBuskCards,
    cast(0 as float) as PurchasedCards,
    cast(0 as float) as ReplacedCards
from n_mnth
group by 1, 2, 3, 4, 5, 6;

update main m
set ActiveCards = ac.ActiveCards
from activecards ac
where m.DataInfo = ac.DataInfo
    and m.Class81_Code = ac.Class81_Code
    and m.MnfCode = ac.MnfCode
    and m.Series = ac.Series
    and m.Status = ac.Status;
commit;

update main m
set TotalCards = tc.TotalCards
from totalcards tc
where m.DataInfo = tc.DataInfo
    and m.Class81_Code = tc.Class81_Code
    and m.MnfCode = tc.MnfCode
    and m.Series = tc.Series
    and m.Status = tc.Status;
commit;

update main m
set TrfcPsCards = tpc.TrfcPsCards
from trfcpscards tpc
where m.DataInfo = tpc.DataInfo
    and m.Class81_Code = tpc.Class81_Code
    and m.MnfCode = tpc.MnfCode
    and m.Series = tpc.Series
    and m.Status = tpc.Status;
commit;

update main m
set AddBuskCards = abc.AddBuskCards
from addbuskcards abc
where m.DataInfo = abc.DataInfo
    and m.Class81_Code = abc.Class81_Code
    and m.MnfCode = abc.MnfCode
    and m.Series = abc.Series
    and m.Status = abc.Status;
commit;

update main m
set PurchasedCards = pc.PurchasedCards
from purchasedcards pc
where m.DataInfo = pc.DataInfo
    and m.Class81_Code = pc.Class81_Code
    and m.MnfCode = pc.MnfCode
    and m.Series = pc.Series
    and m.Status = pc.Status;
commit;

update main m
set ReplacedCards = rc.ReplacedCards
from replacedcards rc
where m.DataInfo = rc.DataInfo
    and m.Class81_Code = rc.Class81_Code
    and m.MnfCode = rc.MnfCode
    and m.Series = rc.Series
    and m.Status = rc.Status;
commit;

-- удалить данные старше анализируемого периода
delete from DataMart.DshECom_NomenclatureAnlsMnth
where DataInfo < add_months(trunc(current_date, 'year')::date, - 12);
commit;

-- удалить из витрины данные большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_NomenclatureAnlsMnth
where DataInfo >= (select min(DataInfo) from main);
commit;

select purge_table('DataMart.DshECom_NomenclatureAnlsMnth');

-- вставка в витрину с расшивкой 81
insert into DataMart.DshECom_NomenclatureAnlsMnth
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    MnfCode,
    Series,
    Status,
    ActiveCards,
    TotalCards,
    TrfcPsCards,
    AddBuskCards,
    PurchasedCards,
    ReplacedCards
from main;
commit;

select analyze_statistics('DataMart.DshECom_NomenclatureAnlsMnth');
