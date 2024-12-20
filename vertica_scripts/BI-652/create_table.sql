-- 24.06.2024 Разработка витрин по ДСЦ для дашборда УП
-- https://utrack.etm.corp/issue/BI-652/Vertica-Razrabotka-vitrin-po-DSC-dlya-dashborda-UP

create table DataMart.DshSalesManag_LongTerm_DivMnth ( -- Витрина для анализа по дивизионам с учетом месяцев
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class294_Code varchar(4),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class294_Code,
    Class72_Code,
    Class63_Code_2,
    Class63_Code_3,
    Class79_Code,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_DivMnth.Class294_Code,
    DataMart.DshSalesManag_LongTerm_DivMnth.Class72_Code,
    DataMart.DshSalesManag_LongTerm_DivMnth.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_DivMnth.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_DivMnth.Class79_Code) all nodes ksafe 1;
    
create table DataMart.DshSalesManag_LongTerm_TotDivMnth ( -- Витрина для анализа в целом по дивизионам (без разбивки) с учетом месяцев
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SalesChannel varchar(6),
    SumShipped float,
    LongTermGoalMnth float)
order by
    SalesChannel,
    Class72_Code,
    Class63_Code_2,
    Class63_Code_3,
    Class79_Code,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_TotDivMnth.SalesChannel,
    DataMart.DshSalesManag_LongTerm_TotDivMnth.Class72_Code,
    DataMart.DshSalesManag_LongTerm_TotDivMnth.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_TotDivMnth.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_TotDivMnth.Class79_Code) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_TotDivMnth is 'Витрина для анализа в целом по дивизионам (без разбивки) с учетом месяцев';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.SalesChannel is 'Канал КПП(S) или КОК(B)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала) из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_DivSpecMnth ( -- Витрина для анализа по дивизионам с учетом месяцев
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class294_Code varchar(4),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class294_Code,
    Class72_Code,
    Class63_Code_2,
    SalesSubChannel,
    Class63_Code_3,
    Class79_Code,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_DivSpecMnth.Class294_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecMnth.Class72_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecMnth.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_DivSpecMnth.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_DivSpecMnth.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_DivSpecMnth.Class79_Code) all nodes ksafe 1;
    
create table DataMart.DshSalesManag_LongTerm_TotDivSpecMnth (
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    SalesChannel varchar(6),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    SalesChannel,
    Class72_Code,
    Class63_Code_2,
    SalesSubChannel,
    Class63_Code_3,
    Class79_Code,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_TotDivSpecMnth.SalesChannel,
    DataMart.DshSalesManag_LongTerm_TotDivSpecMnth.Class72_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecMnth.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_TotDivSpecMnth.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_TotDivSpecMnth.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_TotDivSpecMnth.Class79_Code) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_TotDivMnth is 'Витрина для анализа в целом по дивизионам (без разбивки) с учетом месяцев';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.SalesChannel is 'Канал КПП(S) или КОК(B)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecMnth.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_TotDivMnth.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала) из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth ( -- Витрина для анализа по дивизионам с учетом месяцев
    DataInfo date,
    CliInn varchar(24),
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class294_Code varchar(4),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class294_Code,
    Class72_Code,
    Class63_Code_2,
    SalesSubChannel,
    Class63_Code_3,
    Class79_Code,
    CliInn,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class294_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class72_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class79_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.CliInn) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth is 'Витрина для анализа в целом по дивизионам с учетом месяцев расшитая до ИНН';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.CliInn is 'ИНН клиента';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class294_Code is 'Код 294-го классификатора 1-го уровня (дивизион)';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала) из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth (
    DataInfo date,
    CliInn varchar(24),
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    SalesChannel varchar(6),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    SalesChannel,
    Class72_Code,
    Class63_Code_2,
    SalesSubChannel,
    Class63_Code_3,
    Class79_Code,
    CliInn,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.SalesChannel,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class72_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class79_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.CliInn) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth is 'Витрина для анализа в целом по дивизионам (без разбивки) с учетом месяцев расшитая до ИНН';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.CliInn is 'ИНН клиента';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.SalesChannel is 'Канал КПП(S) или КОК(B)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала) из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1 (
    DataInfo date,
    CliInn varchar(24),
    Class294_Code varchar(4),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class294_Code,
    Class72_Code,
    SalesSubChannel,
    Class79_Code,
    CliInn,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.Class294_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.Class72_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.Class79_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.CliInn) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1 is 'Витрина для анализа по дивизионам с учетом месяцев расшитая до ИНН';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.CliInn is 'ИНН клиента';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.Class294_Code is 'Код 294-го классификатора 1-го уровня (дивизион)';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj1.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1 (
    DataInfo date,
    CliInn varchar(24),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class72_Code,
    SalesSubChannel,
    Class79_Code,
    CliInn,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.Class72_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.Class79_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.CliInn) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1 is 'Витрина для анализа по дивизионам (без разбивки) с учетом месяцев расшитая до ИНН';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.CliInn is 'ИНН клиента';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj1.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2 (
    DataInfo date,
    CliInn varchar(24),
    SalesSubChannel varchar(8),
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class72_Code,
    SalesSubChannel,
    Class63_Code_3,
    Class79_Code,
    CliInn,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.Class72_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.Class79_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.CliInn) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2 is 'Витрина для анализа по дивизионам (без разбивки) с учетом месяцев расшитая до ИНН с группировкой по 63_3';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.CliInn is 'ИНН клиента';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj2.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3 (
    DataInfo date,
    CliInn varchar(24),
    SalesSubChannel varchar(8),
    Class63_Code_2 varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class72_Code,
    Class63_Code_2,
    SalesSubChannel,
    Class79_Code,
    CliInn,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.Class72_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.Class79_Code,
    DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.CliInn) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3 is 'Витрина для анализа по дивизионам (без разбивки) с учетом месяцев расшитая до ИНН с группировкой по 63_2';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.CliInn is 'ИНН клиента';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_TotDivSpecInnMnth_Prj3.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала из таблицы DataPrime.LongTermGoalTot_LegEnt';

create table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2 (
    DataInfo date,
    CliInn varchar(24),
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class294_Code varchar(4),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
order by
    Class294_Code,
    Class72_Code,
    Class63_Code_2,
    SalesSubChannel,
    Class63_Code_3,
    Class79_Code,
    CliInn,
    DataInfo
segmented by hash (
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class294_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class72_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class63_Code_2,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.SalesSubChannel,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class63_Code_3,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class79_Code,
    DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.CliInn) all nodes ksafe 1;

comment on table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2 is 'Витрина для анализа по дивизионам с учетом месяцев расшитая до ИНН';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.DataInfo is 'Дата';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.CliInn is 'ИНН клиента';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class63_Code_2 is '63-й классификатор ветки УП (управленческая структура) уровень региона';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class63_Code_3 is '63-й классификатор ветки УП (управленческая структура) уровень ДП';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class294_Code is 'Код 294-го классификатора 1-го уровня (дивизион)';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.SalesSubChannel is 'Специализация (на основе public.KontragLinkClass37Hist.SalesSubChannel)';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class79_Code is 'код 79-го классификатора ветки G';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.Class72_Code is 'Потенциал';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.SumShipped is 'ГО ЭТМ';
comment on column DataMart.DshSalesManag_LongTerm_DivSpecInnMnth_Prj2.LongTermGoalMnth is 'это ДСЦ в рамках каждого из месяцев квартала из таблицы DataPrime.LongTermGoalTot_LegEnt';

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
