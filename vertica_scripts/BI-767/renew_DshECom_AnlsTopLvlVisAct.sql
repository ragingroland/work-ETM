---------------------------------------
-- интересующий временной срез
-- т.е нам нужно то, чего в витрине нет
create local temp table slice (
    martdate_tfc date,
    martdate_ord date)
on commit preserve rows;
-- все витрины в этой задаче (в т.ч во всём ECom) обновляются за одинаковый временной срез
-- max(DataInfo) = ближайшая к текущему моменту дата в первичке и витрине
-- отдельно для трафика
insert into slice (martdate_tfc, martdate_ord)
with
tfc as (
    select
        isnull(max(DataInfo), add_months(trunc(current_date, 'mm'), -13)) as martdate_tfc -- если даты в витрине нет (по какой-то причине),
    from DataMart.DshECom_AnlsTopLvlVisActTfc_1),                                         -- грузим всё за регламентированный срез;
-- отдельно для заказа
ord as (
    select
        isnull(max(DataInfo), add_months(trunc(current_date, 'mm'), -13)) as martdate_ord
    from DataMart.DshECom_AnlsTopLvlVisActOrd_1)
select martdate_tfc, martdate_ord from tfc, ord;                                  -- грузим всё за регламентированный срез;
--------------------------------------------------------
-- забираются нужные для счета и вообще поля из первички
-- плюс пара джойнов для 71, 72
create local temp table forcalcs
on commit preserve rows as
select
    DataInfo,
    coalesce(left(dk.Class71_Code, 2), '') as Class71_Code,
    coalesce(left(dk.Class72_Code, 2), '') as Class72_Code,
    left(Class81_Code, 8) as Class81_Code,
    wa.Class206_Code,
    RegUser,
    NewUser,
    CounterID,
    Device,
    TypeClientID,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    OrderID,
    UserID,
    VisitID,
    WatchProd,
    QltAddProd,
    WatchBusket,
    QltCheckOut,
    QltPRZ,
    QltPO,
    TotalSum,
    PricePRZ,
    PricePO
from DataPrime.ECom_WebAnalytics wa
left join public.DescUsers du on wa.ETMCliID = du.CliId
    and wa.Class206_Code = du.Class206_Code
left join public.DescKontrag dk on du.CliCode = dk.CliCode
-- на всякий случай выбираем меньшую из двух дат для выборки из первички
where CountryID in (19, 24) and (select least(martdate_tfc, martdate_ord) from slice) <= DataInfo;
----------------------------------------
-- ниже считается для траффика вкладка 1
-- пользователей и визитов
create local temp table userviscnt
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID,
    count(distinct VisitID) as VisitID
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- пользователей просмотревших товары
create local temp table userwtchprod
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID
from forcalcs
where WatchProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- пользователей добавивших товар в корзину
create local temp table useraddbusk -- используется также для заказа 1
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID
from forcalcs
where QltAddProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- пользователей просмотревших корзину
create local temp table userwtchbusk
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID
from forcalcs
where WatchBusket > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- пользователей с оформленными заказами
create local temp table userwithordrs -- используется также для заказа 1
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID
from forcalcs
where QltCheckOut > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- пользователей с размещенными заказами
create local temp table usersprz
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID
from forcalcs
where QltPRZ > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- пользователей с отгруженными заказами
create local temp table userspo
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID
from forcalcs
where QltPO > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- кол-во новых пользователей
create local temp table newusercnt
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    count(distinct UserID) as UserID
from forcalcs
where NewUser > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- таблица, для занесения мер
create local temp table tf1
on commit preserve rows as
select
    DataInfo,
    RegUser,
    TypeClientID,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    CounterID,
    Device,
    cast(0 as float) as UsersCount,
    cast(0 as float) as VisitsCount,
    cast(0 as float) as NewUsers,
    cast(0 as float) as UsersWtchProd,
    cast(0 as float) as UsersAddBusk,
    cast(0 as float) as UsersWtchBusk,
    cast(0 as float) as UsersWthOrdrs,
    cast(0 as float) as UsersPRZ,
    cast(0 as float) as UsersPO
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17;

-- апдейтятся меры
update tf1 cn
set UsersCount = uc.UserID
from userviscnt uc
where cn.DataInfo = uc.DataInfo
    and cn.Class71_Code = uc.Class71_Code
    and cn.Class72_Code = uc.Class72_Code
    and cn.Class206_Code = uc.Class206_Code
    and cn.RegUser = uc.RegUser
    and cn.CounterID = uc.CounterID
    and cn.Device = uc.Device
    and cn.TypeClientID = uc.TypeClientID;
commit;

update tf1 cn
set VisitsCount = uc.VisitID
from userviscnt uc
where cn.DataInfo = uc.DataInfo
    and cn.Class71_Code = uc.Class71_Code
    and cn.Class72_Code = uc.Class72_Code
    and cn.Class206_Code = uc.Class206_Code
    and cn.RegUser = uc.RegUser
    and cn.CounterID = uc.CounterID
    and cn.Device = uc.Device
    and cn.TypeClientID = uc.TypeClientID;
commit;

update tf1 cn
set UsersWtchProd = up.UserID
from userwtchprod up
where cn.DataInfo = up.DataInfo
    and cn.Class71_Code = up.Class71_Code
    and cn.Class72_Code = up.Class72_Code
    and cn.Class206_Code = up.Class206_Code
    and cn.RegUser = up.RegUser
    and cn.CounterID = up.CounterID
    and cn.Device = up.Device
    and cn.TypeClientID = up.TypeClientID;
commit;

update tf1 cn
set UsersAddBusk = ub.UserID
from useraddbusk ub
where cn.DataInfo = ub.DataInfo
    and cn.Class71_Code = ub.Class71_Code
    and cn.Class72_Code = ub.Class72_Code
    and cn.Class206_Code = ub.Class206_Code
    and cn.RegUser = ub.RegUser
    and cn.CounterID = ub.CounterID
    and cn.Device = ub.Device
    and cn.TypeClientID = ub.TypeClientID;
commit;

update tf1 cn
set UsersWtchBusk = ub.UserID
from userwtchbusk ub
where cn.DataInfo = ub.DataInfo
    and cn.Class71_Code = ub.Class71_Code
    and cn.Class72_Code = ub.Class72_Code
    and cn.Class206_Code = ub.Class206_Code
    and cn.RegUser = ub.RegUser
    and cn.CounterID = ub.CounterID
    and cn.Device = ub.Device
    and cn.TypeClientID = ub.TypeClientID;
commit;

update tf1 cn
set UsersWthOrdrs = uo.UserID
from userwithordrs uo
where cn.DataInfo = uo.DataInfo
    and cn.Class71_Code = uo.Class71_Code
    and cn.Class72_Code = uo.Class72_Code
    and cn.Class206_Code = uo.Class206_Code
    and cn.RegUser = uo.RegUser
    and cn.CounterID = uo.CounterID
    and cn.Device = uo.Device
    and cn.TypeClientID = uo.TypeClientID;
commit;

update tf1 cn
set UsersPO = upo.UserID
from userspo upo
where cn.DataInfo = upo.DataInfo
    and cn.Class71_Code = upo.Class71_Code
    and cn.Class72_Code = upo.Class72_Code
    and cn.Class206_Code = upo.Class206_Code
    and cn.RegUser = upo.RegUser
    and cn.CounterID = upo.CounterID
    and cn.Device = upo.Device
    and cn.TypeClientID = upo.TypeClientID;
commit;

update tf1 cn
set UsersPRZ = uprz.UserID
from usersprz uprz
where cn.DataInfo = uprz.DataInfo
    and cn.Class71_Code = uprz.Class71_Code
    and cn.Class72_Code = uprz.Class72_Code
    and cn.Class206_Code = uprz.Class206_Code
    and cn.RegUser = uprz.RegUser
    and cn.CounterID = uprz.CounterID
    and cn.Device = uprz.Device
    and cn.TypeClientID = uprz.TypeClientID;
commit;

update tf1 cn
set NewUsers = nuc.UserID
from newusercnt nuc
where cn.DataInfo = nuc.DataInfo
    and cn.Class71_Code = nuc.Class71_Code
    and cn.Class72_Code = nuc.Class72_Code
    and cn.Class206_Code = nuc.Class206_Code
    and cn.RegUser = nuc.RegUser
    and cn.CounterID = nuc.CounterID
    and cn.Device = nuc.Device
    and cn.TypeClientID = nuc.TypeClientID;
commit;

-------------------------------------------
-- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_AnlsTopLvlVisActTfc_1
where DataInfo >= (select min(DataInfo) from tf1);
commit;

delete from DataMart.DshECom_AnlsTopLvlVisActTfc_1
where DataInfo < add_months(trunc(current_date, 'mm'), -13);
commit;

select purge_table('DataMart.DshECom_AnlsTopLvlVisActTfc_1');

-- ну и сразу вставляем новые данные в базу
insert into DataMart.DshECom_AnlsTopLvlVisActTfc_1
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    left(Class206_Code, 2) as Class206_Code_1,
    Class206_Code as Class206_Code_2,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    UsersCount,
    VisitsCount,
    UsersWtchProd,
    UsersAddBusk,
    UsersWtchBusk,
    UsersWthOrdrs,
    UsersPRZ,
    UsersPO,
    NewUsers
from tf1;
commit;

-- все ненужные времянки дропаются
drop table userviscnt;
drop table newusercnt;
drop table userwtchprod;
drop table userwtchbusk;
drop table usersprz;
drop table userspo;
drop table tf1;

----------------------------------------
-- ниже считается для заказ вкладка 1
-- заказов оформленно
create local temp table ordcheckout
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    count(distinct OrderID) as OrderID
from forcalcs
where QltCheckOut > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- размещенных заказов
create local temp table ordPRZ
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    count(distinct OrderID) as OrderID
from forcalcs
where QltPRZ > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- заказов отгружено
create local temp table ordPO
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    count(distinct OrderID) as OrderID
from forcalcs
where QltPO > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- суммарная стоимость оформленных заказов
create local temp table totsum
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    sum(TotalSum) as TotalSum
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- суммарная стоимость размещенных заказов
create local temp table sumPRZ
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    sum(PricePRZ) as SumPRZ
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- суммарная стоимость отгруженных заказов
create local temp table sumPO
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    sum(PricePO) as SumPO
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

-- аналогичная tf1 таблица и так же апдейтятся меры
create local temp table od1
on commit preserve rows as
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    Class206_Code,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    cast(0 as float) as OrdsCheckout,
    cast(0 as float) as OrdsPRZ,
    cast(0 as float) as OrdsPO,
    cast(0 as float) as UsersAddBusk,
    cast(0 as float) as UsersWthOrdrs,
    cast(0 as float) as SumTot,
    cast(0 as float) as SumPRZ,
    cast(0 as float) as SumPO
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

update od1 cn
set OrdsCheckout = oc.OrderID
from ordcheckout oc
where cn.DataInfo = oc.DataInfo
    and cn.Class71_Code = oc.Class71_Code
    and cn.Class72_Code = oc.Class72_Code
    and cn.Class206_Code = oc.Class206_Code
    and cn.RegUser = oc.RegUser
    and cn.CounterID = oc.CounterID
    and cn.Device = oc.Device
    and cn.TypeClientID = oc.TypeClientID;
commit;

update od1 cn
set OrdsPRZ = op.OrderID
from ordprz op
where cn.DataInfo = op.DataInfo
    and cn.Class71_Code = op.Class71_Code
    and cn.Class72_Code = op.Class72_Code
    and cn.Class206_Code = op.Class206_Code
    and cn.RegUser = op.RegUser
    and cn.CounterID = op.CounterID
    and cn.Device = op.Device
    and cn.TypeClientID = op.TypeClientID;
commit;

update od1 cn
set OrdsPO = opo.OrderID
from ordpo opo
where cn.DataInfo = opo.DataInfo
    and cn.Class71_Code = opo.Class71_Code
    and cn.Class72_Code = opo.Class72_Code
    and cn.Class206_Code = opo.Class206_Code
    and cn.RegUser = opo.RegUser
    and cn.CounterID = opo.CounterID
    and cn.Device = opo.Device
    and cn.TypeClientID = opo.TypeClientID;
commit;

update od1 cn
set UsersAddBusk = ub.UserID
from useraddbusk ub
where cn.DataInfo = ub.DataInfo
    and cn.Class71_Code = ub.Class71_Code
    and cn.Class72_Code = ub.Class72_Code
    and cn.Class206_Code = ub.Class206_Code
    and cn.RegUser = ub.RegUser
    and cn.CounterID = ub.CounterID
    and cn.Device = ub.Device
    and cn.TypeClientID = ub.TypeClientID;
commit;

update od1 cn
set UsersWthOrdrs = uo.UserID
from userwithordrs uo
where cn.DataInfo = uo.DataInfo
    and cn.Class71_Code = uo.Class71_Code
    and cn.Class72_Code = uo.Class72_Code
    and cn.Class206_Code = uo.Class206_Code
    and cn.RegUser = uo.RegUser
    and cn.CounterID = uo.CounterID
    and cn.Device = uo.Device
    and cn.TypeClientID = uo.TypeClientID;
commit;

update od1 cn
set SumTot = TotalSum
from totsum st
where cn.DataInfo = st.DataInfo
    and cn.Class71_Code = st.Class71_Code
    and cn.Class72_Code = st.Class72_Code
    and cn.Class206_Code = st.Class206_Code
    and cn.RegUser = st.RegUser
    and cn.CounterID = st.CounterID
    and cn.Device = st.Device
    and cn.TypeClientID = st.TypeClientID;
commit;

update od1 cn
set SumPRZ = sprz.SumPRZ
from sumprz sprz
where cn.DataInfo = sprz.DataInfo
    and cn.Class71_Code = sprz.Class71_Code
    and cn.Class72_Code = sprz.Class72_Code
    and cn.Class206_Code = sprz.Class206_Code
    and cn.RegUser = sprz.RegUser
    and cn.CounterID = sprz.CounterID
    and cn.Device = sprz.Device
    and cn.TypeClientID = sprz.TypeClientID;
commit;

update od1 cn
set SumPO = spo.SumPO
from sumpo spo
where cn.DataInfo = spo.DataInfo
    and cn.Class71_Code = spo.Class71_Code
    and cn.Class72_Code = spo.Class72_Code
    and cn.Class206_Code = spo.Class206_Code
    and cn.RegUser = spo.RegUser
    and cn.CounterID = spo.CounterID
    and cn.Device = spo.Device
    and cn.TypeClientID = spo.TypeClientID;
commit;

-- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_AnlsTopLvlVisActOrd_1
where DataInfo >= (select min(DataInfo) from od1);
commit;

delete from DataMart.DshECom_AnlsTopLvlVisActOrd_1
where DataInfo < add_months(trunc(current_date, 'mm'), -13);
commit;

select purge_table('DataMart.DshECom_AnlsTopLvlVisActOrd_1');

-------
insert into DataMart.DshECom_AnlsTopLvlVisActOrd_1
select
    DataInfo,
    Class71_Code,
    Class72_Code,
    left(Class206_Code, 2) as Class206_Code_1,
    Class206_Code as Class206_Code_2,
    RegUser,
    TypeClientID,
    CounterID,
    Device,
    OrdsCheckout,
    OrdsPRZ,
    OrdsPO,
    UsersAddBusk,
    UsersWthOrdrs,
    SumTot,
    SumPo,
    SumPRZ
from od1;
commit;

-- все времянки дропаются
drop table useraddbusk;
drop table userwithordrs;
drop table ordcheckout;
drop table ordPRZ;
drop table ordPO;
drop table SumPO;
drop table SumPRZ;
drop table totsum;
drop table od1;

-- и дальше подобным образом для вкладок №2
----------------------------------------
-- ниже считается для траффика вкладка 2
create local temp table userviscnt
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID,
    count(distinct VisitID) as VisitID
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table userwtchprod
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID
from forcalcs
where WatchProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table useraddbusk
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID
from forcalcs
where QltAddProd > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table userwtchbusk
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID
from forcalcs
where WatchBusket > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table userwithordrs -- используется в т.ч в заказе 2
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID
from forcalcs
where QltCheckOut > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table usersprz
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID
from forcalcs
where QltPRZ > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table userspo
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID
from forcalcs
where QltPO > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table newusercnt
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct UserID) as UserID
from forcalcs
where NewUser > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table tf2
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    cast(0 as float) as UsersCount,
    cast(0 as float) as VisitsCount,
    cast(0 as float) as UsersWtchProd,
    cast(0 as float) as UsersAddBusk,
    cast(0 as float) as UsersWtchBusk,
    cast(0 as float) as UsersWthOrdrs,
    cast(0 as float) as UsersPRZ,
    cast(0 as float) as UsersPO,
    cast(0 as float) as NewUsers
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15;

update tf2 cn
set UsersCount = uc.UserID
from userviscnt uc
where cn.DataInfo = uc.DataInfo
    and cn.Class81_Code = uc.Class81_Code
    and cn.NewUser = uc.NewUser
    and cn.RegionID = uc.RegionID
    and cn.CityID = uc.CityID
    and cn.TrafficSourceFirst = uc.TrafficSourceFirst
    and cn.TrafficSourceAuto = uc.TrafficSourceAuto
    and cn.TrafficSourceLast = uc.TrafficSourceLast;
commit;

update tf2 cn
set VisitsCount = uc.VisitID
from userviscnt uc
where cn.DataInfo = uc.DataInfo
    and cn.Class81_Code = uc.Class81_Code
    and cn.NewUser = uc.NewUser
    and cn.RegionID = uc.RegionID
    and cn.CityID = uc.CityID
    and cn.TrafficSourceFirst = uc.TrafficSourceFirst
    and cn.TrafficSourceAuto = uc.TrafficSourceAuto
    and cn.TrafficSourceLast = uc.TrafficSourceLast;
commit;

update tf2 cn
set UsersWtchProd = up.UserID
from userwtchprod up
where cn.DataInfo = up.DataInfo
    and cn.Class81_Code = up.Class81_Code
    and cn.NewUser = up.NewUser
    and cn.RegionID = up.RegionID
    and cn.CityID = up.CityID
    and cn.TrafficSourceFirst = up.TrafficSourceFirst
    and cn.TrafficSourceAuto = up.TrafficSourceAuto
    and cn.TrafficSourceLast = up.TrafficSourceLast;
commit;

update tf2 cn
set UsersAddBusk = ub.UserID
from useraddbusk ub
where cn.DataInfo = ub.DataInfo
    and cn.Class81_Code = ub.Class81_Code
    and cn.NewUser = ub.NewUser
    and cn.RegionID = ub.RegionID
    and cn.CityID = ub.CityID
    and cn.TrafficSourceFirst = ub.TrafficSourceFirst
    and cn.TrafficSourceAuto = ub.TrafficSourceAuto
    and cn.TrafficSourceLast = ub.TrafficSourceLast;
commit;

update tf2 cn
set UsersWtchBusk = ub.UserID
from userwtchbusk ub
where cn.DataInfo = ub.DataInfo
    and cn.Class81_Code = ub.Class81_Code
    and cn.NewUser = ub.NewUser
    and cn.RegionID = ub.RegionID
    and cn.CityID = ub.CityID
    and cn.TrafficSourceFirst = ub.TrafficSourceFirst
    and cn.TrafficSourceAuto = ub.TrafficSourceAuto
    and cn.TrafficSourceLast = ub.TrafficSourceLast;
commit;

update tf2 cn
set UsersWthOrdrs = uo.UserID
from userwithordrs uo
where cn.DataInfo = uo.DataInfo
    and cn.Class81_Code = uo.Class81_Code
    and cn.NewUser = uo.NewUser
    and cn.RegionID = uo.RegionID
    and cn.CityID = uo.CityID
    and cn.TrafficSourceFirst = uo.TrafficSourceFirst
    and cn.TrafficSourceAuto = uo.TrafficSourceAuto
    and cn.TrafficSourceLast = uo.TrafficSourceLast;
commit;

update tf2 cn
set UsersPO = upo.UserID
from userspo upo
where cn.DataInfo = upo.DataInfo
    and cn.Class81_Code = upo.Class81_Code
    and cn.NewUser = upo.NewUser
    and cn.RegionID = upo.RegionID
    and cn.CityID = upo.CityID
    and cn.TrafficSourceFirst = upo.TrafficSourceFirst
    and cn.TrafficSourceAuto = upo.TrafficSourceAuto
    and cn.TrafficSourceLast = upo.TrafficSourceLast;
commit;

update tf2 cn
set UsersPRZ = uprz.UserID
from usersprz uprz
where cn.DataInfo = uprz.DataInfo
    and cn.Class81_Code = uprz.Class81_Code
    and cn.NewUser = uprz.NewUser
    and cn.RegionID = uprz.RegionID
    and cn.CityID = uprz.CityID
    and cn.TrafficSourceFirst = uprz.TrafficSourceFirst
    and cn.TrafficSourceAuto = uprz.TrafficSourceAuto
    and cn.TrafficSourceLast = uprz.TrafficSourceLast;
commit;

update tf2 cn
set NewUsers = nuc.UserID
from newusercnt nuc
where cn.DataInfo = nuc.DataInfo
    and cn.Class81_Code = nuc.Class81_Code
    and cn.NewUser = nuc.NewUser
    and cn.RegionID = nuc.RegionID
    and cn.CityID = nuc.CityID
    and cn.TrafficSourceFirst = nuc.TrafficSourceFirst
    and cn.TrafficSourceAuto = nuc.TrafficSourceAuto
    and cn.TrafficSourceLast = nuc.TrafficSourceLast;
commit;

-- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_AnlsTopLvlVisActTfc_2
where DataInfo >= (select min(DataInfo) from tf2);
commit;

delete from DataMart.DshECom_AnlsTopLvlVisActTfc_2
where DataInfo < add_months(trunc(current_date, 'mm'), -13);
commit;

select purge_table('DataMart.DshECom_AnlsTopLvlVisActTfc_2');

-------
insert into DataMart.DshECom_AnlsTopLvlVisActTfc_2
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    left(Class81_Code, 8) as Class81_Code_4,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    UsersCount,
    VisitsCount,
    UsersWtchProd,
    UsersAddBusk,
    UsersWtchBusk,
    UsersWthOrdrs,
    UsersPRZ,
    UsersPO,
    NewUsers
from tf2;
commit;

drop table userviscnt;
drop table userwtchprod;
drop table userwtchbusk;
drop table usersprz;
drop table userspo;
drop table newusercnt;
drop table tf2;

----------------------------------------
-- ниже считается для заказ вкладка 2
create local temp table ordcheckout
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct OrderID) as OrderID
from forcalcs
where QltCheckOut > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table ordPRZ
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct OrderID) as OrderID
from forcalcs
where QltPRZ > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table ordPO
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    count(distinct OrderID) as OrderID
from forcalcs
where QltPO > 0
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table totsum
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    sum(TotalSum) as TotalSum
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table sumPRZ
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    sum(PricePRZ) as SumPRZ
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table sumPO
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    sum(PricePO) as SumPO
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

create local temp table od2
on commit preserve rows as
select
    DataInfo,
    Class81_Code,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    cast(0 as float) as OrdsCheckout,
    cast(0 as float) as OrdsPRZ,
    cast(0 as float) as OrdsPO,
    cast(0 as float) as UsersAddBusk,
    cast(0 as float) as UsersWthOrdrs,
    cast(0 as float) as SumTot,
    cast(0 as float) as SumPO,
    cast(0 as float) as SumPRZ
from forcalcs
group by 1, 2, 3, 4, 5, 6, 7, 8;

update od2 cn
set OrdsCheckout = oc.OrderID
from ordcheckout oc
where cn.DataInfo = oc.DataInfo
    and cn.Class81_Code = oc.Class81_Code
    and cn.NewUser = oc.NewUser
    and cn.RegionID = oc.RegionID
    and cn.CityID = oc.CityID
    and cn.TrafficSourceFirst = oc.TrafficSourceFirst
    and cn.TrafficSourceAuto = oc.TrafficSourceAuto
    and cn.TrafficSourceLast = oc.TrafficSourceLast;
commit;

update od2 cn
set OrdsPRZ = op.OrderID
from ordprz op
where cn.DataInfo = op.DataInfo
    and cn.Class81_Code = op.Class81_Code
    and cn.NewUser = op.NewUser
    and cn.RegionID = op.RegionID
    and cn.CityID = op.CityID
    and cn.TrafficSourceFirst = op.TrafficSourceFirst
    and cn.TrafficSourceAuto = op.TrafficSourceAuto
    and cn.TrafficSourceLast = op.TrafficSourceLast;
commit;

update od2 cn
set OrdsPO = opo.OrderID
from ordpo opo
where cn.DataInfo = opo.DataInfo
    and cn.Class81_Code = opo.Class81_Code
    and cn.NewUser = opo.NewUser
    and cn.RegionID = opo.RegionID
    and cn.CityID = opo.CityID
    and cn.TrafficSourceFirst = opo.TrafficSourceFirst
    and cn.TrafficSourceAuto = opo.TrafficSourceAuto
    and cn.TrafficSourceLast = opo.TrafficSourceLast;
commit;

update od2 cn
set UsersAddBusk = ub.UserID
from useraddbusk ub
where cn.DataInfo = ub.DataInfo
    and cn.Class81_Code = ub.Class81_Code
    and cn.NewUser = ub.NewUser
    and cn.RegionID = ub.RegionID
    and cn.CityID = ub.CityID
    and cn.TrafficSourceFirst = ub.TrafficSourceFirst
    and cn.TrafficSourceAuto = ub.TrafficSourceAuto
    and cn.TrafficSourceLast = ub.TrafficSourceLast;
commit;

update od2 cn
set UsersWthOrdrs = uo.UserID
from userwithordrs uo
where cn.DataInfo = uo.DataInfo
    and cn.Class81_Code = uo.Class81_Code
    and cn.NewUser = uo.NewUser
    and cn.RegionID = uo.RegionID
    and cn.CityID = uo.CityID
    and cn.TrafficSourceFirst = uo.TrafficSourceFirst
    and cn.TrafficSourceAuto = uo.TrafficSourceAuto
    and cn.TrafficSourceLast = uo.TrafficSourceLast;
commit;

update od2 cn
set SumTot = TotalSum
from totsum st
where cn.DataInfo = st.DataInfo
    and cn.Class81_Code = st.Class81_Code
    and cn.NewUser = st.NewUser
    and cn.RegionID = st.RegionID
    and cn.CityID = st.CityID
    and cn.TrafficSourceFirst = st.TrafficSourceFirst
    and cn.TrafficSourceAuto = st.TrafficSourceAuto
    and cn.TrafficSourceLast = st.TrafficSourceLast;
commit;

update od2 cn
set SumPRZ = sprz.SumPRZ
from sumprz sprz
where cn.DataInfo = sprz.DataInfo
    and cn.Class81_Code = sprz.Class81_Code
    and cn.NewUser = sprz.NewUser
    and cn.RegionID = sprz.RegionID
    and cn.CityID = sprz.CityID
    and cn.TrafficSourceFirst = sprz.TrafficSourceFirst
    and cn.TrafficSourceAuto = sprz.TrafficSourceAuto
    and cn.TrafficSourceLast = sprz.TrafficSourceLast;
commit;

update od2 cn
set SumPO = spo.SumPO
from sumpo spo
where cn.DataInfo = spo.DataInfo
    and cn.Class81_Code = spo.Class81_Code
    and cn.NewUser = spo.NewUser
    and cn.RegionID = spo.RegionID
    and cn.CityID = spo.CityID
    and cn.TrafficSourceFirst = spo.TrafficSourceFirst
    and cn.TrafficSourceAuto = spo.TrafficSourceAuto
    and cn.TrafficSourceLast = spo.TrafficSourceLast;
commit;

-- нужно удалить из витрины даты большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_AnlsTopLvlVisActOrd_2
where DataInfo >= (select min(DataInfo) from od2);
commit;

delete from DataMart.DshECom_AnlsTopLvlVisActOrd_2
where DataInfo < add_months(trunc(current_date, 'mm'), -13);
commit;

select purge_table('DataMart.DshECom_AnlsTopLvlVisActOrd_2');

-------
insert into DataMart.DshECom_AnlsTopLvlVisActOrd_2
select
    DataInfo,
    left(Class81_Code, 2) as Class81_Code_1,
    left(Class81_Code, 4) as Class81_Code_2,
    left(Class81_Code, 6) as Class81_Code_3,
    Class81_Code as Class81_Code_4,
    NewUser,
    RegionID,
    CityID,
    TrafficSourceFirst,
    TrafficSourceAuto,
    TrafficSourceLast,
    OrdsCheckout,
    OrdsPRZ,
    OrdsPO,
    UsersAddBusk,
    UsersWthOrdrs,
    SumTot,
    SumPO,
    SumPRZ
from od2;
commit;

---------------------------
select analyze_statistics('DataMart.DshECom_AnlsTopLvlVisActTfc_1');
select analyze_statistics('DataMart.DshECom_AnlsTopLvlVisActTfc_2');
select analyze_statistics('DataMart.DshECom_AnlsTopLvlVisActOrd_1');
select analyze_statistics('DataMart.DshECom_AnlsTopLvlVisActOrd_2');
