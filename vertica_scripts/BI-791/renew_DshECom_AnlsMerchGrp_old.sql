-- забираем самую позднюю дату из витрины и первички
create local temp table slice (
	martdate date,
	primedate date)
on commit preserve rows;

-- аналогично BI-767 берем макс.дату из витрины, либо за регламентированный срез + макс.дату первички
-- max(DataInfo) = ближайшая к текущему моменту дата в первичке и витрине
insert into slice
with
s1 as (
	select
		isnull(max(DataInfo), add_months(trunc(current_date, 'year'), -12)) as martdate
	from DataMart.DshECom_AnlsMerchGrp),
s2 as (
	select
		max(DataInfo) as primedate
	from DataPrime.ECom_AdConversion)
select *
from s1, s2;

-- основная выборка из первички + бренд + Series
create local temp table mainselect
on commit preserve rows as
select
    ac.DataInfo,
    left(dr.Class81_Code, 6) as Class81_Code,
    /* Если на карточке товара есть 488 признак (наличие записи с кодом товара в таблице DataPrime.RgdMnfBrand),
    выводим соответствующий NameBrand производителя из записи таблицы DataPrime.RgdMnfBrand.
    Иначе по действующему алгоритму (выводим NameBrand производителя, который указан по товару в справочнике товаров DescRgd) */
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
from slice, DataPrime.ECom_AdConversion ac
left join public.DescRgd dr on ac.RgdCode = dr.RgdCode
left join DataPrime.RgdMnfBrand rmb on dr.RgdCode = rmb.RgdCode
left join public.DescSeriesRgd dsr on rmb.RgdCode = dsr.RgdCode
left join DataPrime.ECom_Cities c on ac.CityID = c.CityID
where martdate <= ac.DataInfo and ac.DataInfo <= primedate -- добавлять сюда то, чего нет в витрине, аналогично ниже
	and CampaignID != 0
	and (c.CountryID = 19 or c.CountryID = 24);

-- переносим нужные данные из таблицы выше, чтобы считать меры по срезам
create local temp table forcalcs
on commit preserve rows as
select
    DataInfo,
    MnfCode,
    Series,
    UserID,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CountryID,
    RegionID,
    CityID,
    QltAddProd,
    QltPurchaseProd,
    WatchProd,
    TotalSum
from mainselect;

-- считаем меры
create local temp table userwtchprod
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    count(distinct UserID) as UserID
from forcalcs
where WatchProd > 0
group by 1, 2, 3, 4, 5, 6, 7;

create local temp table useraddbusk
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    count(distinct UserID) as UserID
from forcalcs
where QltAddProd > 0
group by 1, 2, 3, 4, 5, 6, 7;

create local temp table userwithordrs
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    cast(count(distinct UserID) as float) as UserID
from forcalcs
where QltPurchaseProd > 0
group by 1, 2, 3, 4, 5, 6, 7;

create local temp table sums
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    sum(QltPurchaseProd) as QltPurchaseProd,
    sum(TotalSum) as TotalSum
from forcalcs
where CampaignID != 0
group by 1, 2, 3, 4, 5, 6, 7;

-- таблица, предшествующая вставке в базу
create local temp table wb1
on commit preserve rows as
select
    DataInfo,
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
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;

-- апдейтятся меры
update wb1 cn
set UsersWtchProd = up.UserID
from userwtchprod up
where cn.DataInfo = up.DataInfo
	and cn.Class81_Code = up.Class81_Code
	and cn.AdTypeID = up.AdTypeID
	and cn.CampaignID = up.CampaignID
	and cn.CategoryID = up.CategoryID
	and cn.TypeClientID = up.TypeClientID
	and cn.CityID = up.CityID;

update wb1 cn
set UsersAddBusk = ub.UserID
from useraddbusk ub
where cn.DataInfo = ub.DataInfo
	and cn.Class81_Code = ub.Class81_Code
	and cn.AdTypeID = ub.AdTypeID
	and cn.CampaignID = ub.CampaignID
	and cn.CategoryID = ub.CategoryID
	and cn.TypeClientID = ub.TypeClientID
	and cn.CityID = ub.CityID;

update wb1 cn
set UsersWthOrdrs = uo.UserID
from userwithordrs uo
where cn.DataInfo = uo.DataInfo
	and cn.Class81_Code = uo.Class81_Code
	and cn.AdTypeID = uo.AdTypeID
	and cn.CampaignID = uo.CampaignID
	and cn.CategoryID = uo.CategoryID
	and cn.TypeClientID = uo.TypeClientID
	and cn.CityID = uo.CityID;

update wb1 cn
set OrdsCheckout = sm.QltPurchaseProd
from sums sm
where cn.DataInfo = sm.DataInfo
	and cn.Class81_Code = sm.Class81_Code
	and cn.AdTypeID = sm.AdTypeID
	and cn.CampaignID = sm.CampaignID
	and cn.CategoryID = sm.CategoryID
	and cn.TypeClientID = sm.TypeClientID
	and cn.CityID = sm.CityID;

update wb1 cn
set ChecksSum = sm.TotalSum
from sums sm
where cn.DataInfo = sm.DataInfo
	and cn.Class81_Code = sm.Class81_Code
	and cn.AdTypeID = sm.AdTypeID
	and cn.CampaignID = sm.CampaignID
	and cn.CategoryID = sm.CategoryID
	and cn.TypeClientID = sm.TypeClientID
	and cn.CityID = sm.CityID;

-- теперь нужно вставить в базу
insert into DataMart.DshECom_AnlsMerchGrp
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    Class81_Code as Class81_Code_3,
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
commit;

drop table userwtchprod;
drop table useraddbusk;
drop table userwithordrs;
drop table sums;
drop table wb1;

-------------------------------------
-- теперь нужно посчитать для брендов
-- считаем меры
create local temp table userwtchprod
on commit preserve rows as
select
    DataInfo,
	Class81_Code,
    MnfCode,
    Series,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    count(distinct UserID) as UserID
from forcalcs
where WatchProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

create local temp table useraddbusk
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
	MnfCode,
    Series,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    count(distinct UserID) as UserID
from forcalcs
where QltAddProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

create local temp table userwithordrs
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    cast(count(distinct UserID) as float) as UserID
from forcalcs
where QltPurchaseProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

create local temp table sums
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    MnfCode,
    Series,
    AdTypeID,
    CampaignID,
    CategoryID,
    TypeClientID,
    CityID,
    sum(QltPurchaseProd) as QltPurchaseProd,
    sum(TotalSum) as TotalSum
from forcalcs
where CampaignID != 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;

-- таблица, предшествующая вставке в базу
create local temp table wb2
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
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;

-- апдейтятся меры
update wb2 cn
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

update wb2 cn
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

update wb2 cn
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

update wb2 cn
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

update wb2 cn
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

-- теперь нужно вставить в базу
insert into DataMart.DshECom_AnlsMerchGrpBrnd
select
    DataInfo,
    MnfCode,
    Series,
    left(Class81_Code, 6) as Class81_Code_3,
	Class81_Code as Class81_Code_4,
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
from wb2;
commit;

-- удалить данные старше нужного среза
delete from DataMart.DshECom_AnlsMerchGrp
where min(DataInfo) < add_months(trunc(current_date, 'year'), -12);
commit;
delete from DataMart.DshECom_AnlsMerchGrpBrnd
where min(DataInfo) < add_months(trunc(current_date, 'year'), -12);
commit;
