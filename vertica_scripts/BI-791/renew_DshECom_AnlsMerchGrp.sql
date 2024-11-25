---------------------------------------
-- интересующий временной срез
-- т.е нам нужно то, чего в витрине нет
create local temp table slice (
    martdate date)
on commit preserve rows;

-- нужно проследить за тем, что может ли быть разница в дате между витринами
-- в тех местах, где у разных клиентов в разной атрибуции "сегодня" может не быть данных

-- все витрины в этой задаче (в т.ч во всём ECom) обновляются за одинаковый временной срез
-- поэтому не важно из какой именно витрины будет взята максимальная дата
-- ну и разумеется нам нужна максимальная дата в первичке
-- max(DataInfo) = ближайшая к текущему моменту дата в витрине
insert into slice
select
    isnull(max(DataInfo), add_months(trunc(current_date, 'mm'), -13)) as martdate
from DataMart.DshECom_AnlsMerchGrp_Ad1;

-- основная выборка из первички + бренд + Series
create local temp table mainselect
on commit preserve rows as
select
    ac.DataInfo,
    left(dr.Class81_Code, 8) as Class81_Code,
    isnull(rmb.MnfCode, dr.MnfCode) as MnfCode,
    coalesce(dsr.Series, '') as Series,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    ac.UserID,
    CountryID,
    RegionID,
    ac.CityID,
    WatchProd,
    QltAddProd,
    QltPurchaseProd,
    TotalSum
from DataPrime.ECom_AdConversion ac
left join public.DescRgd dr on ac.RgdCode = dr.RgdCode
left join DataPrime.RgdMnfBrand rmb on dr.RgdCode = rmb.RgdCode
left join public.DescSeriesRgd dsr on ac.RgdCode = dsr.RgdCode
inner join DataPrime.ECom_Cities c on ac.CityID = c.CityID
    and CountryID in (19, 24)
where -- ac.DataInfo >= add_months(trunc(current_date, 'mm'), -13)
    (select martdate from slice) <= ac.DataInfo -- добавлять сюда то, чего нет в витрине, аналогично ниже
    and CampaignID != 0;

-- считаем меры
create local temp table userwtchprod
on commit preserve rows as
select
    DataInfo,
    MnfCode,
    Series,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    count(distinct UserID) as UserID
from mainselect
where WatchProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

create local temp table useraddbusk
on commit preserve rows as
select
    DataInfo,
    MnfCode,
    Series,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    count(distinct UserID) as UserID
from mainselect
where QltAddProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

create local temp table userwithordrs
on commit preserve rows as
select
    DataInfo,
    MnfCode,
    Series,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    count(distinct UserID) as UserID
from mainselect
where QltPurchaseProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

create local temp table sums
on commit preserve rows as
select
    DataInfo,
    MnfCode,
    Series,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    sum(QltPurchaseProd) as QltPurchaseProd,
    sum(TotalSum) as TotalSum
from mainselect
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

-- таблица, предшествующая вставке в базу
create local temp table wb1
on commit preserve rows as
select
    DataInfo,
    MnfCode,
    Series,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CountryID,
    RegionID,
    CityID,
    cast(0 as float) as UsersWtchProd,
    cast(0 as float) as UsersAddBusk,
    cast(0 as float) as UsersWthOrdrs,
    cast(0 as float) as OrdsCheckout,
    cast(0 as float) as ChecksSum
from mainselect
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11;

-- апдейтятся меры в табличке wb1 выше
update wb1 cn
set UsersWtchProd = up.UserID
from userwtchprod up
where cn.DataInfo = up.DataInfo
    and cn.Class81_Code = up.Class81_Code
    and cn.MnfCode = up.MnfCode
    and cn.Series = up.Series
    and cn.AdTypeID = up.AdTypeID
    and cn.CampaignID = up.CampaignID
    and cn.CategoryID = up.CategoryID
    and cn.TypeClientID = up.TypeClientID
    and cn.CityID = up.CityID;
commit;

update wb1 cn
set UsersAddBusk = ub.UserID
from useraddbusk ub
where cn.DataInfo = ub.DataInfo
    and cn.Class81_Code = ub.Class81_Code
    and cn.MnfCode = ub.MnfCode
    and cn.Series = ub.Series
    and cn.AdTypeID = ub.AdTypeID
    and cn.CampaignID = ub.CampaignID
    and cn.CategoryID = ub.CategoryID
    and cn.TypeClientID = ub.TypeClientID
    and cn.CityID = ub.CityID;
commit;

update wb1 cn
set UsersWthOrdrs = uo.UserID
from userwithordrs uo
where cn.DataInfo = uo.DataInfo
    and cn.Class81_Code = uo.Class81_Code
    and cn.MnfCode = uo.MnfCode
    and cn.Series = uo.Series
    and cn.AdTypeID = uo.AdTypeID
    and cn.CampaignID = uo.CampaignID
    and cn.CategoryID = uo.CategoryID
    and cn.TypeClientID = uo.TypeClientID
    and cn.CityID = uo.CityID;
commit;

update wb1 cn
set OrdsCheckout = sm.QltPurchaseProd
from sums sm
where cn.DataInfo = sm.DataInfo
    and cn.Class81_Code = sm.Class81_Code
    and cn.MnfCode = sm.MnfCode
    and cn.Series = sm.Series
    and cn.AdTypeID = sm.AdTypeID
    and cn.CampaignID = sm.CampaignID
    and cn.CategoryID = sm.CategoryID
    and cn.TypeClientID = sm.TypeClientID
    and cn.CityID = sm.CityID;
commit;

update wb1 cn
set ChecksSum = sm.TotalSum
from sums sm
where cn.DataInfo = sm.DataInfo
    and cn.Class81_Code = sm.Class81_Code
    and cn.MnfCode = sm.MnfCode
    and cn.Series = sm.Series
    and cn.AdTypeID = sm.AdTypeID
    and cn.CampaignID = sm.CampaignID
    and cn.CategoryID = sm.CategoryID
    and cn.TypeClientID = sm.TypeClientID
    and cn.CityID = sm.CityID;
commit;

-- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
create local temp table tmp_date
on commit preserve rows as
select min(DataInfo) as DataInfo
from wb1;

-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli0
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- -- теперь нужно вставить в базу
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad1Cli0
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 1
--     and TypeClientID = 0
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli1
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad1Cli1
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 1
--     and TypeClientID = 1
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli2
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad1Cli2
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 1
--     and TypeClientID = 2
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli3
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad1Cli3
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 1
--     and TypeClientID = 3
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli0
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad2Cli0
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 2
--     and TypeClientID = 0
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli1
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad2Cli1
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 2
--     and TypeClientID = 1
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli2
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad2Cli2
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 2
--     and TypeClientID = 2
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli3
-- where DataInfo >= (select DataInfo from tmp_date);
-- commit;
-- -------
-- insert into DataMart.DshECom_AnlsMerchGrp_Ad2Cli3
-- select
--     DataInfo,
--     left(Class81_Code, 2) as Class81_Code_1,
--     left(Class81_Code, 4) as Class81_Code_2,
--     left(Class81_Code, 6) as Class81_Code_3,
--     Class81_Code as Class81_Code_4,
--     MnfCode,
--     Series,
--     AdTypeID,
--     CampaignID,
--     CategoryID,
--     TypeClientID,
--     CountryID,
--     RegionID,
--     CityID,
--     UsersWtchProd,
--     UsersAddBusk,
--     UsersWthOrdrs,
--     OrdsCheckout,
--     ChecksSum
-- from wb1
-- where AdTypeID = 2
--     and TypeClientID = 3
-- group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
-- commit;

-- -- удалить по дате всё старже нужного
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli0
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli1
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli2
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad1Cli3
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli0
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli1
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli2
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;
-- delete from DataMart.DshECom_AnlsMerchGrp_Ad2Cli3
-- where DataInfo < (select add_months(trunc(current_date, 'mm'), -13))
-- commit;

-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad1Cli0');
-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad1Cli1');
-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad1Cli2');
-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad1Cli3');
-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad2Cli0');
-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad2Cli1');
-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad2Cli2');
-- select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad2Cli3');

-- ВРЕМЕННОЕ (ПОСТОЯННОЕ) РЕШЕНИЕ
-- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_AnlsMerchGrp_Ad1
where DataInfo >= (select DataInfo from tmp_date);
commit;

delete from DataMart.DshECom_AnlsMerchGrp_Ad1
where DataInfo < (select add_months(trunc(current_date, 'mm'), -13));
commit;

select purge_table('DataMart.DshECom_AnlsMerchGrp_Ad1');

-------
insert into DataMart.DshECom_AnlsMerchGrp_Ad1
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    MnfCode,
    Series,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CountryID,
    RegionID,
    CityID,
    UsersWtchProd,
    UsersAddBusk,
    UsersWthOrdrs,
    OrdsCheckout,
    ChecksSum
from wb1
where AdTypeID = 1
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
commit;

-- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_AnlsMerchGrp_Ad2
where DataInfo >= (select DataInfo from tmp_date);
commit;

delete from DataMart.DshECom_AnlsMerchGrp_Ad2
where DataInfo < (select add_months(trunc(current_date, 'mm'), -13));
commit;

select purge_table('DataMart.DshECom_AnlsMerchGrp_Ad2');

-------
insert into DataMart.DshECom_AnlsMerchGrp_Ad2
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    MnfCode,
    Series,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CountryID,
    RegionID,
    CityID,
    UsersWtchProd,
    UsersAddBusk,
    UsersWthOrdrs,
    OrdsCheckout,
    ChecksSum
from wb1
where AdTypeID = 2
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;
commit;

select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad1');
select analyze_statistics('DataMart.DshECom_AnlsMerchGrp_Ad2');
