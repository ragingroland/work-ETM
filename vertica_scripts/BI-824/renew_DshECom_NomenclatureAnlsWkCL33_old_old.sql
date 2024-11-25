/* из первички берутся нужные для расчетов мер и построения витрины столбцы
на основании максимальной даты из витрины, из первички берутся более свежие данные
т.к если брать за весь период, то получается очень много. это было необходимо только для первого наполнения */
create local temp table n_wk33
on commit preserve rows as
select
    nm.DataInfo,
    left(dr.Class33_Code, 5) as Class33_Code,
    nm.Status,
    nm.TrafficSourceID,
    nm.QltVisit,
    nm.QltAdd,
    nm.QltPurchaseProd,
    nm.QltClickReplace,
    nm.RgdCode
from DataPrime.ECom_NomenclatureWk nm
left join public.DescRgd dr on nm.RgdCode = dr.RgdCode
where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsWkCL33)
    --nm.DataInfo >= add_months(trunc(current_date, 'year')::date, - 12)
    and nm.Status != 'N';

create local temp table at_cards
on commit preserve rows as
with
main as ( -- неактивные карточки
    select
        DataInfo,
        Status,
        class33_code,
        cast(0 as float) as active,
        sum(Qlt_Inactive33) as inactive
    from DataPrime.ECom_InactiveCL33Wk
    where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsWkCL33)
    group by 1, 2, 3),
main2 as ( -- активные карточки
    select
        DataInfo,
        Status,
        class33_code,
        count(distinct rgdcode) as active,
        cast(0 as float) as inactive
    from n_wk33
    group by 1, 2, 3)
select
    DataInfo,
    Status,
    class33_code,
    active as ActiveCards,
    active + inactive as TotalCards,
    cast(0 as float) as TrfcPsCards,
    cast(0 as float) as AddBuskCards,
    cast(0 as float) as PurchasedCards,
    cast(0 as float) as ReplacedCards
from main
union -- склеиваются активные и неактивные
select
    DataInfo,
    Status,
    class33_code,
    active as ActiveCards,
    active + inactive as TotalCards,
    cast(0 as float) as TrfcPsCards,
    cast(0 as float) as AddBuskCards,
    cast(0 as float) as PurchasedCards,
    cast(0 as float) as ReplacedCards
from main2;

create local temp table trfcpscards -- карточек с трафиком из ПС
on commit preserve rows as
select
    DataInfo,
    Status,
    class33_code,
    count(distinct RgdCode) as TrfcPsCards
from n_wk33
where TrafficSourceID = 3
    and QltVisit != 0
group by 1, 2, 3;

create local temp table addbuskcards -- карточек с добавлением в корзину
on commit preserve rows as
select
    DataInfo,
    Status,
    class33_code,
    count(distinct RgdCode) as AddBuskCards
from n_wk33
where QltAdd != 0
group by 1, 2, 3;

create local temp table purchasedcards -- оформленные
on commit preserve rows as
select
    DataInfo,
    Status,
    class33_code,
    count(distinct RgdCode) as PurchasedCards
from n_wk33
where QltPurchaseProd > 0
group by 1, 2, 3;

create local temp table replacedcards -- замены
on commit preserve rows as
select
    DataInfo,
    Status,
    class33_code,
    count(distinct RgdCode) as ReplacedCards
from n_wk33
where QltClickReplace != 0
group by 1, 2, 3;

update at_cards m
set TrfcPsCards = tpc.TrfcPsCards
from trfcpscards tpc
where m.DataInfo = tpc.DataInfo
    and m.Class33_Code = tpc.Class33_Code
    and m.Status = tpc.Status;
commit;

update at_cards m
set AddBuskCards = abc.AddBuskCards
from addbuskcards abc
where m.DataInfo = abc.DataInfo
    and m.Class33_Code = abc.Class33_Code
    and m.Status = abc.Status;
commit;

update at_cards m
set PurchasedCards = pc.PurchasedCards
from purchasedcards pc
where m.DataInfo = pc.DataInfo
    and m.Class33_Code = pc.Class33_Code
    and m.Status = pc.Status;
commit;

update at_cards m
set ReplacedCards = rc.ReplacedCards
from replacedcards rc
where m.DataInfo = rc.DataInfo
    and m.Class33_Code = rc.Class33_Code
    and m.Status = rc.Status;
commit;

-- удаляются данные старше анализируемого периода
delete from DataMart.DshECom_NomenclatureAnlsWkCL33
where DataInfo < add_months(trunc(current_date, 'year')::date, - 12);
commit;

-- удалить из витрины данные большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_NomenclatureAnlsWkCL33
where DataInfo >= (select min(DataInfo) from at_cards);
commit;

select purge_table('DataMart.DshECom_NomenclatureAnlsWkCL33');

-- вставка в витрину с расшивкой 33 на уровни
insert into DataMart.DshECom_NomenclatureAnlsWkCL33
select
    DataInfo,
    left(Class33_Code, 2) as Class33_Code_2,
    left(Class33_Code, 3) as Class33_Code_3,
    Class33_Code as Class33_Code_4,
    Status,
    ActiveCards,
    TotalCards,
    TrfcPsCards,
    AddBuskCards,
    PurchasedCards,
    ReplacedCards
from at_cards;
commit;

select analyze_statistics('DataMart.DshECom_NomenclatureAnlsWkCL33');
