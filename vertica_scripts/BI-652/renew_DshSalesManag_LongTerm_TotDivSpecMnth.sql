-- Витрина #4 для анализа в целом по дивизионам (без разбивки) с учетом месяцев

create local temp table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_fact ( -- врем.таблица для факта го
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    SalesChannel varchar(2),
    SalesSubChannel varchar(8),
    Class79_Code varchar(6),
    Class72_Code varchar(4),
    SumShipped float,
    LongTermGoalMnth float)
on commit preserve rows;
truncate table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_fact;

create local temp table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_dsc -- врем.таблица для дсц
on commit preserve rows as
    select * from tmp_DshSalesManag_LongTerm_TotDivSpecMnth_fact;
truncate table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_dsc;

create local temp table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_7972 ( -- врем.таблица для 79 и 72
    CliInn varchar(24),
    MaxRang int,
    Class79_Code varchar(4))
on commit preserve rows 
order by CliInn;
truncate table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_7972;

create local temp table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_3763 ( -- врем.таблица для 37 и 63
    CliInn varchar(24),
    DataInfo date,
    Class63_Code_2 varchar(8),
    Class63_Code_3 varchar(12),
    SalesSubChannel varchar(8))
on commit preserve rows 
order by CliInn;
truncate table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_3763;

create local temp table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_merge -- врем.таблица для слияния факта и дсц
on commit preserve rows as
    select * from tmp_DshSalesManag_LongTerm_TotDivSpecMnth_fact;
truncate table tmp_DshSalesManag_LongTerm_TotDivSpecMnth_merge;

insert into tmp_DshSalesManag_LongTerm_TotDivSpecMnth_7972
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

insert into tmp_DshSalesManag_LongTerm_TotDivSpecMnth_3763
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
order by 1;
commit;

insert into tmp_DshSalesManag_LongTerm_TotDivSpecMnth_fact -- наполнение таблицы для факта
select
    cbs.DataInfo,
    cla2.Class63_Code_2,
    cla2.Class63_Code_3,
    coalesce(substring(sle.Class79_Code, 2, 1), '') as SalesChannel_,
    cla2.SalesSubChannel as SalesSubChannel_,
    cla.Class79_Code as Class79_Code_,
    cl72.Class72_Code as Class72_Code_,
    sum(cbs.SumShipped) as SumShipped,
    0 as LongTermGoalMnth
from public.CBStatTrader cbs
left join tmp_DshSalesManag_LongTerm_TotDivSpecMnth_7972 cla on cbs.CustInn = cla.CliInn
inner join Class72 cl72 on cla.MaxRang = cl72.RangValue
left join tmp_DshSalesManag_LongTerm_TotDivSpecMnth_3763 cla2 on cbs.CustInn = cla2.CliInn
    and cbs.DataInfo = cla2.DataInfo
left join (select DataPrime.SegmentCRM_LegEnt.DataInfo,
                  DataPrime.SegmentCRM_LegEnt.CliInn,
                  MAX(DataPrime.SegmentCRM_LegEnt.Class79_Code) AS  Class79_Code
                  from  DataPrime.SegmentCRM_LegEnt 
            GROUP BY DataPrime.SegmentCRM_LegEnt.DataInfo,
                  DataPrime.SegmentCRM_LegEnt.CliInn      
            ) sle on cbs.DataInfo = sle.DataInfo and cbs.CustInn = sle.CliInn
where
    cbs.class295_Code = '00001'
    and cbs.DataInfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'YEAR'), -12)
group by
    cbs.DataInfo, Class63_Code_2, Class63_Code_3, SalesChannel_, SalesSubChannel_,
    Class79_Code_, Class72_Code_;
commit;

insert into tmp_DshSalesManag_LongTerm_TotDivSpecMnth_dsc -- наполнение таблицы для дсц
with
    vw_ltgm as (
        select
            DataInfo, CliInn, LongTermGoalMnth1 as LongTermGoalMnth
        from DataPrime.LongTermGoalTot_LegEnt
            union
        select
            add_months(DataInfo, 1), CliInn, LongTermGoalMnth2 as LongTermGoalMnth
        from DataPrime.LongTermGoalTot_LegEnt
            union
        select
            add_months(DataInfo, 2), CliInn, LongTermGoalMnth3 as LongTermGoalMnth
        from DataPrime.LongTermGoalTot_LegEnt),
    vw_ltgmdistinn as (
        select DataInfo, CliInn from vw_ltgm)
select
    vw_ltgm.DataInfo,
    cla2.Class63_Code_2,
    cla2.Class63_Code_3,
    coalesce(substring(sle.Class79_Code, 2, 1), '') as SalesChannel_,
    cla2.SalesSubChannel as SalesSubChannel_,
    cla.Class79_Code as Class79_Code_,
    cl72.Class72_Code as Class72_Code_,
    0 as SumShipped,
    sum(LongTermGoalMnth) as LongTermGoalMnth
from vw_ltgm
left join tmp_DshSalesManag_LongTerm_TotDivSpecMnth_7972 cla on vw_ltgm.CliInn = cla.CliInn
inner join Class72 cl72 on cla.MaxRang = cl72.RangValue
left join tmp_DshSalesManag_LongTerm_TotDivSpecMnth_3763 cla2 on vw_ltgm.CliInn = cla2.CliInn
    and vw_ltgm.DataInfo = cla2.DataInfo
left join (select DataPrime.SegmentCRM_LegEnt.DataInfo,
                  DataPrime.SegmentCRM_LegEnt.CliInn,
                  MAX(DataPrime.SegmentCRM_LegEnt.Class79_Code) AS  Class79_Code
                  from  DataPrime.SegmentCRM_LegEnt 
            GROUP BY DataPrime.SegmentCRM_LegEnt.DataInfo,
                  DataPrime.SegmentCRM_LegEnt.CliInn      
            ) sle on vw_ltgm.DataInfo = sle.DataInfo and vw_ltgm.CliInn = sle.CliInn
where
    vw_ltgm.DataInfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'YEAR'), -12)
group by 
    vw_ltgm.DataInfo, Class63_Code_2, Class63_Code_3, SalesSubChannel_,
    Class79_Code_, SalesChannel_, Class72_Code_;
commit;

insert into tmp_DshSalesManag_LongTerm_TotDivSpecMnth_merge -- слияние врем.таблиц выше
select
    coalesce(dsc.DataInfo, fact.DataInfo) as DataInfo,
    coalesce(dsc.Class63_Code_2, fact.Class63_Code_2) as Class63_Code_2,
    coalesce(dsc.Class63_Code_3, fact.Class63_Code_3) as Class63_Code_3,
    coalesce(dsc.SalesChannel, fact.SalesChannel) as SalesChannel,
    coalesce(dsc.SalesSubChannel, fact.SalesSubChannel) as SalesSubChannel,
    coalesce(dsc.Class79_Code, fact.Class79_Code) as Class79_Code,
    coalesce(dsc.Class72_Code, fact.Class72_Code) as Class72_Code,
    sum(coalesce(fact.SumShipped, 0)) as SumShipped,
    sum(coalesce(dsc.LongTermGoalMnth, 0)) as LongTermGoalMnth
from tmp_DshSalesManag_LongTerm_TotDivSpecMnth_fact fact
full join tmp_DshSalesManag_LongTerm_TotDivSpecMnth_dsc dsc
    on fact.DataInfo = dsc.DataInfo
    and fact.Class63_Code_2 = dsc.Class63_Code_2
    and fact.Class63_Code_3 = dsc.Class63_Code_3
    and fact.SalesChannel = dsc.SalesChannel
    and fact.SalesSubChannel = dsc.SalesSubChannel
    and fact.Class79_Code = dsc.Class79_Code
    and fact.Class72_Code = dsc.Class72_Code
group by
    coalesce(dsc.DataInfo, fact.DataInfo),
    coalesce(dsc.Class63_Code_2, fact.Class63_Code_2),
    coalesce(dsc.Class63_Code_3, fact.Class63_Code_3),
    coalesce(dsc.SalesChannel, fact.SalesChannel),
    coalesce(dsc.SalesSubChannel, fact.SalesSubChannel),
    coalesce(dsc.Class79_Code, fact.Class79_Code),
    coalesce(dsc.Class72_Code, fact.Class72_Code);
commit;

delete from tmp_DshSalesManag_LongTerm_TotDivSpecMnth_merge
where DataInfo < '2024-01-01'::date;
commit;

truncate table DataMart.DshSalesManag_LongTerm_TotDivSpecMnth;
insert into DataMart.DshSalesManag_LongTerm_TotDivSpecMnth
select
    DataInfo,
    Class63_Code_2,
    Class63_Code_3,
    case
        when SalesChannel = 'S'
            then 'КПП'
        when SalesChannel = 'B'
            then 'КОК'
        else ''
    end as SalesChanenel,
    SalesSubChannel,
    Class79_Code,
    Class72_Code,
    SumShipped,
    LongTermGoalMnth
from tmp_DshSalesManag_LongTerm_TotDivSpecMnth_merge;
commit;