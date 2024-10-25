create table DataMart.DshECom_AnlsTopLvlVisActTfc_1 (
    DataInfo date,
    Class71_Code varchar(4),
    Class72_Code varchar(4),
    Class206_Code_1 varchar(4),
    Class206_Code_2 varchar(8),
    RegUser int,
    TypeClientID int,
    CounterID int,
    Device varchar(14),
    UsersCount float,
    VisitsCount float,
    NewUsers float,
    UsersWtchProd float,
    UsersAddBusk float,
    UsersWtchBusk float,
    UsersWthOrdrs float,
    UsersPRZ float,
    UsersPO float,
    NewUsers float)
order by
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    Class72_Code,
    Class71_Code,
    Class206_Code_1,
    Class206_Code_2,
    DataInfo
segmented by hash(
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.RegUser,
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.CounterID,
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.Device,
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.TypeClientID,
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class72_Code,
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class71_Code,
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class206_Code_1,
    DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class206_Code_2) all nodes ksafe;

comment on table DataMart.DshECom_AnlsTopLvlVisActTfc_1 is 'Витрина для "Анализ верхнеуровневой активности посетителей" в рамках проекта E-Com для траффика вкладка 1';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class71_Code is 'ЦКГ';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class72_Code is 'Потенциал клиента';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class206_Code_1 is 'Роль ЛПР кл206 ур1';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.Class206_Code_2 is 'Роль ЛПР кл206 ур2';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.RegUser is 'Зарегистрированный пользователь да-1/нет-0';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.TypeClientID is 'Тип клиента';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.Device is 'Девайс';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.CounterID is 'Номер счетчика';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.UsersCount is 'Кол-во посетителей';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.VisitsCount is 'Кол-во визитов';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.NewUsers is 'Кол-во новых пользователей';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.UsersWtchProd is 'Пользователей, просмотревших товар';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.UsersAddBusk is 'Пользователей, добавивших товар в корзину';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.UsersWtchBusk is 'Пользователей, просмотревших корзину';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.UsersWthOrdrs is 'Пользователей, оформивших заказ';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.UsersPRZ is 'Пользователей с размещенными товарами';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.UsersPO is 'Пользователей с отгруженными товарами';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_1.NewUsers is 'Количество новых пользователей';


create table DataMart.DshECom_AnlsTopLvlVisActTfc_2 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    NewUser int,
    RegionID int,
    CityID int,
    TrafficSourceFirst int,
    TrafficSourceAuto int,
    TrafficSourceLast int,
    UsersCount float,
    VisitsCount float,
    UsersWtchProd float,
    UsersAddBusk float,
    UsersWtchBusk float,
    UsersWthOrdrs float,
    UsersPRZ float,
    UsersPO float,
    NewUsers float)
order by
    NewUser,
    TrafficSourceFirst,
    TrafficSourceLast,
    TrafficSourceAuto,
    Class81_Code_1,
    RegionID,
    Class81_Code_2,
    Class81_Code_3,
    CityID,
    Class81_Code_4,
    DataInfo
segmented by hash (
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.NewUser,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.TrafficSourceFirst,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.TrafficSourceLast,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.TrafficSourceAuto,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_1,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.RegionID,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_2,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_3,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.CityID,
    DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_4) all nodes ksafe;

comment on table DataMart.DshECom_AnlsTopLvlVisActTfc_2 is 'Витрина для "Анализ верхнеуровневой активности посетителей" в рамках проекта E-Com для траффика вкладка 2';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.NewUser is 'Новый пользователь да-1/нет-0';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_1 is 'Интернет-каталог кл81 ур1';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_2 is 'Интернет-каталог кл81 ур2';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_3 is 'Интернет-каталог кл81 ур3';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.Class81_Code_4 is 'Интернет-каталог кл81 ур4';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.TrafficSourceFirst is 'Источник траффика 1ый знач';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.TrafficSourceAuto is 'Источник траффика автомат.';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.TrafficSourceLast is 'Источник траффика посл.знач';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.RegionID is 'Регион';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.CityID is 'Город';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.UsersCount is 'Кол-во посетителей';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.VisitsCount is 'Кол-во визитов';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.UsersWtchProd is 'Пользователей, просмотревших товар';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.UsersAddBusk is 'Пользователей, добавивших товар в корзину';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.UsersWtchBusk is 'Пользователей, просмотревших корзину';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.UsersWthOrdrs is 'Пользователей, оформивших заказ';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.UsersPRZ is 'Пользователей с размещенными товарами';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.UsersPO is 'Пользователей с отгруженными товарами';
comment on column DataMart.DshECom_AnlsTopLvlVisActTfc_2.NewUsers is 'Количество новых пользователей';

create table DataMart.DshECom_AnlsTopLvlVisActOrd_1 (
    DataInfo date,
    Class71_Code varchar(4),
    Class72_Code varchar(4),
    Class206_Code_1 varchar(4),
    Class206_Code_2 varchar(8),
    RegUser int,
    TypeClientID int,
    CounterID int,
    Device varchar(14),
    OrdsCheckout float,
    OrdsPRZ float,
    OrdsPO float,
    UsersAddBusk float,
    UsersWthOrdrs float,
    SumTot float,
    SumPO float,
    SumPRZ float)
order by
    RegUser,
    CounterID,
    Device,
    TypeClientID,
    Class72_Code,
    Class71_Code,
    Class206_Code_1,
    Class206_Code_2,
    DataInfo
segmented by hash (
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.RegUser,
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.CounterID,
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.Device,
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.TypeClientID,
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class72_Code,
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class71_Code,
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class206_Code_1,
    DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class206_Code_2) all nodes ksafe;

comment on table DataMart.DshECom_AnlsTopLvlVisActOrd_1 is 'Витрина для "Анализ верхнеуровневой активности посетителей" в рамках проекта E-Com для заказа вкладка 1';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class71_Code is 'ЦКГ';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class72_Code is 'Потенциал клиента';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class206_Code_1 is 'Роль ЛПР кл206 ур1';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.Class206_Code_2 is 'Роль ЛПР кл206 ур2';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.RegUser is 'Зарегистрированный пользователь да-1/нет-0';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.TypeClientID is 'Тип клиента';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.Device is 'Девайс';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.CounterID is 'Номер счетчика';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.UsersAddBusk is 'Пользователей, добавивших товар в корзину';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.UsersWthOrdrs is 'Пользователей, оформивших заказ';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.OrdsCheckout is 'Оформленных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.OrdsPRZ is 'Размещенных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.OrdsPO is 'Отгруженных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.SumTot is 'Сумма оформленных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.SumPO is 'Сумма отгруженных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_1.SumPRZ is 'Сумма размещенных заказов';

create table DataMart.DshECom_AnlsTopLvlVisActOrd_2 (
    DataInfo date,
    Class81_Code_1 varchar(4),
    Class81_Code_2 varchar(8),
    Class81_Code_3 varchar(12),
    Class81_Code_4 varchar(16),
    NewUser int,
    RegionID int,
    CityID int,
    TrafficSourceFirst int,
    TrafficSourceAuto int,
    TrafficSourceLast int,
    OrdsCheckout float,
    OrdsPRZ float,
    OrdsPO float,
    UsersAddBusk float,
    UsersWthOrdrs float,
    SumTot float,
    SumPO float,
    SumPRZ float)
order by
    NewUser,
    TrafficSourceFirst,
    TrafficSourceLast,
    TrafficSourceAuto,
    Class81_Code_1,
    RegionID,
    Class81_Code_2,
    Class81_Code_3,
    CityID,
    Class81_Code_4,
    DataInfo
segmented by hash (
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.NewUser,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.TrafficSourceFirst,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.TrafficSourceLast,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.TrafficSourceAuto,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_1,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.RegionID,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_2,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_3,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.CityID,
    DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_4) all nodes ksafe;

comment on table DataMart.DshECom_AnlsTopLvlVisActOrd_2 is 'Витрина для "Анализ верхнеуровневой активности посетителей" в рамках проекта E-Com для заказа вкладка 2';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.DataInfo is 'Дата';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.NewUser is 'Новый пользователь да-1/нет-0';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_1 is 'Интернет-каталог кл81 ур1';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_2 is 'Интернет-каталог кл81 ур2';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_3 is 'Интернет-каталог кл81 ур3';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.Class81_Code_4 is 'Интернет-каталог кл81 ур4';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.TrafficSourceFirst is 'Источник траффика 1ый знач';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.TrafficSourceAuto is 'Источник траффика автомат.';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.TrafficSourceLast is 'Источник траффика посл.знач';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.RegionID is 'Регион';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.CityID is 'Город';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.UsersAddBusk is 'Пользователей, добавивших товар в корзину';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.UsersWthOrdrs is 'Пользователей, оформивших заказ';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.OrdsCheckout is 'Оформленных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.OrdsPRZ is 'Размещенных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.OrdsPO is 'Отгруженных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.SumTot is 'Сумма оформленных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.SumPO is 'Сумма отгруженных заказов';
comment on column DataMart.DshECom_AnlsTopLvlVisActOrd_2.SumPRZ is 'Сумма размещенных заказов';

GRANT USAGE ON SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RO_public_role;
GRANT ALL ON SCHEMA public, DataPrime, DataMart TO RW_public_role;
GRANT ALL ON ALL TABLES IN SCHEMA public, DataPrime, DataMart TO RW_public_role;
-- !!! для ED добавляем по роли etl_ed_role:
--                 public и dataprime - только смотрим
--                 datamart          - все
GRANT USAGE ON SCHEMA public, DataPrime TO etl_ed_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public, DataPrime  TO etl_ed_role;
GRANT ALL ON SCHEMA DataMart TO etl_ed_role;
GRANT ALL ON ALL TABLES IN SCHEMA DataMart TO etl_ed_role;
