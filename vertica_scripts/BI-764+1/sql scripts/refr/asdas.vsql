create table DataPrime.ECom_NomenclatureMnth (
    DataInfo date,
    CounterID int,
    RgdCode int,
    QltVisit int,
    TrafficSourceID int,
    SearchEngineRootID int,
    WatchCard int,
    QltAdd int,
    SumAdd int,
    QltClickReplace int,
    SumClickReplace int,
    QltPurchaseProd int,
    SumPurchaseProd int,
    QltRefusal int,
    RenameYM int)
order by
    CounterID,
    TrafficSourceID,
    SearchEngineRootID,
    RgdCode,
    DataInfo
segmented by hash (
    DataPrime.ECom_NomenclatureMnth.CounterID,
    DataPrime.ECom_NomenclatureMnth.TrafficSourceID,
    DataPrime.ECom_NomenclatureMnth.SearchEngineRootID,
    DataPrime.ECom_NomenclatureMnth.RgdCode) all nodes ksafe;

comment on table DataPrime.ECom_NomenclatureMnth is 'Номенклатурная за неделю';
comment on column DataPrime.ECom_NomenclatureMnth.CounterID is 'ID счетчика';
comment on column DataPrime.ECom_NomenclatureMnth.RgdCode is 'Код товара';
comment on column DataPrime.ECom_NomenclatureMnth.DataInfo is 'Дата';
comment on column DataPrime.ECom_NomenclatureMnth.QltVisit is 'Кол-во визитов с КТ';
comment on column DataPrime.ECom_NomenclatureMnth.TrafficSourceID is 'Источник траффика';
comment on column DataPrime.ECom_NomenclatureMnth.SearchEngineRootID is 'Поисковая система';
comment on column DataPrime.ECom_NomenclatureMnth.WatchCard is 'Кол-во просмотров карточки';
comment on column DataPrime.ECom_NomenclatureMnth.QltAdd is 'Кол-во добавлений в корзину';
comment on column DataPrime.ECom_NomenclatureMnth.SumAdd is 'Кол-во добавлений в корзину (шт)';
comment on column DataPrime.ECom_NomenclatureMnth.QltClickReplace is 'Клик на подобрать замену';
comment on column DataPrime.ECom_NomenclatureMnth.SumClickReplace is 'Клик на подобрать замену (шт.)';
comment on column DataPrime.ECom_NomenclatureMnth.QltPurchaseProd is 'Кол-во купленного товара';
comment on column DataPrime.ECom_NomenclatureMnth.SumPurchaseProd is 'Кол-во купленного товара (шт.)';
comment on column DataPrime.ECom_NomenclatureMnth.QltRefusal is 'Кол-во отказов';
comment on column DataPrime.ECom_NomenclatureMnth.RenameYM is 'Фиксация изменения названия на ЯМ (true/false) если по коду товара (колонка 2 - RgdCode) на предыдущую дату (от даты в колонке 3) произошло изменение названия ЯМ, то фиксируем 1 (true), в ином случае 0 (false)';
