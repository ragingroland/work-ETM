-- Витрина #3 для анализа по дивизионам с учетом месяцев

create local temp table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_fact (-- врем.таблица для факта го
    DataInfo date,
    CustInn varchar(24),
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class294_Code varchar(4),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
on commit preserve rows;
truncate table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_fact;

create local temp table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_dsc ( -- врем.таблица для дсц
    DataInfo date,
    CustInn varchar(24),
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    Class294_Code varchar(4),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
on commit preserve rows;
truncate table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_dsc;

create local temp table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_7972 ( -- врем.таблица для 79 и 72
    CliInn varchar(24),
    MaxRang int,
    Class79_Code varchar(4))
on commit preserve rows 
order by CliInn;
truncate table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_7972;

create local temp table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_3763 ( -- врем.таблица для 37 и 63
    CliInn varchar(24),
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    SalesSubChannel varchar(8))
on commit preserve rows 
order by CliInn;
truncate table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_3763;

create local temp table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_merge -- врем.таблица для слияния факта и дсц
on commit preserve rows as
    select * from tmp_DshSalesManag_LongTerm_DivSpecInnMnth_fact
where tmp_DshSalesManag_LongTerm_DivSpecInnMnth_fact.DataInfo = '0001-01-01';
truncate table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_merge;


insert into tmp_DshSalesManag_LongTerm_DivSpecInnMnth_7972
select distinct 
    glepsfc.CliInn,
    max(cl72.RangValue) over(partition by glepsfc.CliInn) as MaxRang,
    max(left(klc79.Class79_Code, 2)) over(partition by glepsfc.CliInn) as Class79_Code
from DataPrime.GrpLegEntPersForCRM glepsfc
inner join public.DescKontrag dk on glepsfc.CliCode = dk.CliCode
inner join public.Class72 cl72 on dk.Class72_Code = cl72.Class72_Code
inner join public.KontragLinkclass79 klc79 on dk.CliCode = klc79.CliCode
    and klc79.class79_1 = 'G'
order by 1;
commit;

insert into tmp_DshSalesManag_LongTerm_DivSpecInnMnth_3763
select distinct 
    glepsfc.CliInn,
    klc37.DataInfo,
    coalesce(left(cg.classCodeGrp, 4), '') as Class63_Code_2,
    coalesce(left(cg.classCodeGrp, 6), '') as Class63_Code_3,
    klc37.SalesSubChannel
from DataPrime.GrpLegEntPersForCRM glepsfc
inner join public.KontragLinkclass37Hist klc37 on glepsfc.CliCode = klc37.CliCode  
    and klc37.SalesChannel = 'КПП'
left join public.classGroup cg on classTypeSrc = 37 
    and classTypeGrp = 63 
    and classCodeSrc = left(klc37.class37_Code, 5)
    and classCodeGrp LIKE 'УП%'
where klc37.DataInfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'YEAR'), -12)
order by 1;
commit;

insert into tmp_DshSalesManag_LongTerm_DivSpecInnMnth_fact -- наполнение таблицы для факта
select
    cbs.DataInfo,
    cbs.CustInn,
    cla2.Class63_Code_2,
    cla2.Class63_Code_3,
    left(cbs.Class294_Code, 2) as Class294_Code_,
    cla2.SalesSubChannel as SalesSubChannel_,
    cla.Class79_Code as Class79_Code_,
    cl72.Class72_Code as Class72_Code_,
    sum(cbs.SumShipped) as SumShipped,
    0 as LongTermGoalMnth
from public.CBStatTrader cbs
left join tmp_DshSalesManag_LongTerm_DivSpecInnMnth_7972 cla on cbs.CustInn = cla.CliInn
inner join Class72 cl72 on cla.MaxRang = cl72.RangValue
left join tmp_DshSalesManag_LongTerm_DivSpecInnMnth_3763 cla2 on cbs.CustInn = cla2.CliInn
    and cbs.DataInfo = cla2.DataInfo
where
    cbs.class295_Code = '00001'
    and cbs.DataInfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'YEAR'), -12)
group by 
    cbs.DataInfo, cbs.CustInn, Class63_Code_2, Class63_Code_3, Class294_Code_, SalesSubChannel_,
    Class79_Code_, Class72_Code_;
commit; 

insert into tmp_DshSalesManag_LongTerm_DivSpecInnMnth_dsc -- наполнение таблицы для дсц
with vw_ltgm as (
    select
        DataInfo, CliInn, Class294_Code, LongTermGoalMnth1 as LongTermGoalMnth
    from DataPrime.LongTermGoalDiv_LegEnt
        union
    select
        add_months(DataInfo, 1), CliInn, Class294_Code, LongTermGoalMnth2 as LongTermGoalMnth
    from DataPrime.LongTermGoalDiv_LegEnt
        union
    select
        add_months(DataInfo, 2), CliInn, Class294_Code, LongTermGoalMnth3 as LongTermGoalMnth
    from DataPrime.LongTermGoalDiv_LegEnt)
select
    vw_ltgm.DataInfo,
    vw_ltgm.CliInn,
    cla2.Class63_Code_2,
    cla2.Class63_Code_3,
    left(vw_ltgm.Class294_Code, 2) as Class294_Code_,
    cla2.SalesSubChannel as SalesSubChannel_,
    Class79_Code as Class79_Code_,
    Class72_Code as Class72_Code_,
    0 as SumShipped,
    sum(LongTermGoalMnth) as LongTermGoalMnth
from vw_ltgm
left join tmp_DshSalesManag_LongTerm_DivSpecInnMnth_7972 cla on vw_ltgm.CliInn = cla.CliInn
inner join Class72 cl72 on cla.MaxRang = cl72.RangValue
left join tmp_DshSalesManag_LongTerm_DivSpecInnMnth_3763 cla2 on vw_ltgm.CliInn = cla2.CliInn
    and vw_ltgm.DataInfo = cla2.DataInfo
where
    vw_ltgm.DataInfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'YEAR'), -12)
group by 
    vw_ltgm.DataInfo, vw_ltgm.CliInn, Class63_Code_2, Class63_Code_3, Class294_Code_, SalesSubChannel_,
    Class79_Code_, Class72_Code_;
commit; 

insert into tmp_DshSalesManag_LongTerm_DivSpecInnMnth_merge -- слияние врем.таблиц выше
select
    coalesce(dsc.DataInfo, fact.DataInfo) as DataInfo,
    coalesce(dsc.CustInn, fact.CustInn) as CliInn,
    coalesce(dsc.Class63_Code_2, fact.Class63_Code_2) as Class63_Code_2,
    coalesce(dsc.Class63_Code_3, fact.Class63_Code_3) as Class63_Code_3,
    coalesce(dsc.Class294_Code, fact.Class294_Code) as Class294_Code,
    coalesce(dsc.SalesSubChannel, fact.SalesSubChannel) as SalesSubChannel,
    coalesce(dsc.Class79_Code, fact.Class79_Code) as Class79_Code,
    coalesce(dsc.Class72_Code, fact.Class72_Code) as Class72_Code,
    sum(coalesce(fact.SumShipped, 0)) as SumShipped,
    sum(coalesce(dsc.LongTermGoalMnth, 0)) as LongTermGoalMnth
from tmp_DshSalesManag_LongTerm_DivSpecInnMnth_fact fact
full join tmp_DshSalesManag_LongTerm_DivSpecInnMnth_dsc dsc
    on fact.DataInfo = dsc.DataInfo
    and fact.CustInn = dsc.CustInn
    and fact.Class63_Code_2 = dsc.Class63_Code_2
    and fact.Class63_Code_3 = dsc.Class63_Code_3
    and fact.Class294_Code = dsc.Class294_Code
    and fact.SalesSubChannel = dsc.SalesSubChannel
    and fact.Class79_Code = dsc.Class79_Code
    and fact.Class72_Code = dsc.Class72_Code
where dsc.LongTermGoalMnth > 0
group by
    coalesce(dsc.DataInfo, fact.DataInfo),
    coalesce(dsc.CustInn, fact.CustInn),
    coalesce(dsc.Class63_Code_2, fact.Class63_Code_2),
    coalesce(dsc.Class63_Code_3, fact.Class63_Code_3),
    coalesce(dsc.Class294_Code, fact.Class294_Code),
    coalesce(dsc.SalesSubChannel, fact.SalesSubChannel),
    coalesce(dsc.Class79_Code, fact.Class79_Code),
    coalesce(dsc.Class72_Code, fact.Class72_Code);
commit;

delete from tmp_DshSalesManag_LongTerm_DivSpecInnMnth_merge
where DataInfo < '2024-01-01'::date;
commit;

truncate table DataMart.DshSalesManag_LongTerm_DivSpecInnMnth;
insert into DataMart.DshSalesManag_LongTerm_DivSpecInnMnth
select
    DataInfo,
    CustInn as CliInn,
    coalesce(Class63_Code_2, '') as Class63_Code_2,
    coalesce(Class63_Code_3, '') as Class63_Code_3,
    Class294_Code,
    coalesce(SalesSubChannel, '') as SalesSubChannel,
    Class79_Code,
    Class72_Code,
    SumShipped,
    LongTermGoalMnth
from tmp_DshSalesManag_LongTerm_DivSpecInnMnth_merge;
commit;

drop table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_fact;
drop table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_dsc;
drop table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_merge;
drop table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_7972;
drop table tmp_DshSalesManag_LongTerm_DivSpecInnMnth_3763;