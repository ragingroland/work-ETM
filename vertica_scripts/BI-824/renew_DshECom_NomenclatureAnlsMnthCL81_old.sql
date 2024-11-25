/* из первички берутся нужные для расчетов мер и построения витрины столбцы
на основании максимальной даты из витрины, из первички берутся более свежие данные
т.к если брать за весь период, то получается очень много. это было необходимо только для первого наполнения */
create local temp table n_mnth81
on commit preserve rows as
select
    nm.DataInfo,
    left(dr.Class81_Code, 8) as Class81_Code,
    isnull(rmb.MnfCode, dr.MnfCode) as MnfCode, -- BI-824 Заявленные аналитические срезы: п.6
    dsr.Series,
    TrafficSourceID,
    nm.Status,
    nm.RgdCode,
    QltVisit,
    QltAdd,
    QltClickReplace,
    QltPurchaseProd
from DataPrime.ECom_NomenclatureMnth nm
left join DataPrime.RgdMnfBrand rmb on nm.RgdCode = rmb.RgdCode
left join public.DescSeriesRgd dsr on nm.RgdCode = dsr.RgdCode
left join public.DescRgd dr on nm.RgdCode = dr.RgdCode
where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsMnthCL81)
    -- nm.DataInfo >= add_months(trunc(current_date, 'year')::date, - 12)
    and nm.Status != 'N';

-- все меры считаются в конкретном срезе с конкретными условиями, по отдельности
create local temp table totalcards -- карточек всего
on commit preserve rows as
select
    n_mnth81.DataInfo,
    n_mnth81.Class81_Code,
    n_mnth81.Status,
    count(distinct RgdCode) + isnull(Qlt_Inactive81, 0) as TotalCards
from n_mnth81
left join DataPrime.ECom_InactiveCL81Mnth nm81 on nm81.DataInfo = n_mnth81.DataInfo
    and nm81.Status = n_mnth81.Status
    and nm81.Class81_Code = n_mnth81.Class81_Code
group by 1, 2, 3, Qlt_Inactive81;

create local temp table activecards -- просмотренные карточки
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    Status,
    count(distinct RgdCode) as ActiveCards
from n_mnth81
group by 1, 2, 3;

create local temp table trfcpscards -- карточек с трафиком из ПС
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    Status,
    count(distinct RgdCode) as TrfcPsCards
from n_mnth81
where TrafficSourceID = 3
    and QltVisit != 0
group by 1, 2, 3;

create local temp table addbuskcards -- добавленные в корзину
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    Status,
    count(distinct RgdCode) as AddBuskCards
from n_mnth81
where QltAdd != 0
group by 1, 2, 3;

create local temp table purchasedcards -- оформленные
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    Status,
    count(distinct RgdCode) as PurchasedCards
from n_mnth81
where QltPurchaseProd > 0
group by 1, 2, 3;

create local temp table replacedcards -- замены
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    Status,
    count(distinct RgdCode) as ReplacedCards
from n_mnth81
where QltClickReplace != 0
group by 1, 2, 3;

-- промежуточная таблица, где будет нужный срез и меры, которые будут наполняться апдейтами ниже
create local temp table main
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    Status,
    cast(0 as float) as ActiveCards,
    cast(0 as float) as TotalCards,
    cast(0 as float) as TrfcPsCards,
    cast(0 as float) as AddBuskCards,
    cast(0 as float) as PurchasedCards,
    cast(0 as float) as ReplacedCards
from n_mnth81
group by 1, 2, 3;

update main m
set ActiveCards = ac.ActiveCards
from activecards ac
where m.DataInfo = ac.DataInfo
    and m.Class81_Code = ac.Class81_Code
    and m.Status = ac.Status;
commit;

update main m
set TotalCards = tc.TotalCards
from totalcards tc
where m.DataInfo = tc.DataInfo
    and m.Class81_Code = tc.Class81_Code
    and m.Status = tc.Status;
commit;

update main m
set TrfcPsCards = tpc.TrfcPsCards
from trfcpscards tpc
where m.DataInfo = tpc.DataInfo
    and m.Class81_Code = tpc.Class81_Code
    and m.Status = tpc.Status;
commit;

update main m
set AddBuskCards = abc.AddBuskCards
from addbuskcards abc
where m.DataInfo = abc.DataInfo
    and m.Class81_Code = abc.Class81_Code
    and m.Status = abc.Status;
commit;

update main m
set PurchasedCards = pc.PurchasedCards
from purchasedcards pc
where m.DataInfo = pc.DataInfo
    and m.Class81_Code = pc.Class81_Code
    and m.Status = pc.Status;
commit;

update main m
set ReplacedCards = rc.ReplacedCards
from replacedcards rc
where m.DataInfo = rc.DataInfo
    and m.Class81_Code = rc.Class81_Code
    and m.Status = rc.Status;
commit;

-- удаляются данные старше анализируемого периода
delete from DataMart.DshECom_NomenclatureAnlsMnthCL81
where DataInfo < add_months(trunc(current_date, 'year')::date, - 12);
commit;

-- удалить из витрины данные большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_NomenclatureAnlsMnthCL81
where DataInfo >= (select min(DataInfo) from main);
commit;

select purge_table('DataMart.DshECom_NomenclatureAnlsMnthCL81');

-- вставка в витрину с расшивкой 81 по уровням
insert into DataMart.DshECom_NomenclatureAnlsMnthCL81
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    Status,
    ActiveCards,
    TotalCards,
    TrfcPsCards,
    AddBuskCards,
    PurchasedCards,
    ReplacedCards
from main;
commit;

select analyze_statistics('DataMart.DshECom_NomenclatureAnlsMnthCL81');
