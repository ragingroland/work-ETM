-- Витрина #1 для анализа по дивизионам с учетом месяцев

create local temp table tmp_DshSalesManag_LongTerm_DivMnth_fact -- врем.таблица для факта го
on commit preserve rows as
    select * from DataMart.DshSalesManag_LongTerm_DivMnth
where DshSalesManag_LongTerm_DivMnth.DataInfo = '0001-01-01';
truncate table tmp_DshSalesManag_LongTerm_DivMnth_fact;

create local temp table tmp_DshSalesManag_LongTerm_DivMnth_dsc -- врем.таблица для дсц
on commit preserve rows as
    select * from DataMart.DshSalesManag_LongTerm_DivMnth
where DshSalesManag_LongTerm_DivMnth.DataInfo = '0001-01-01';
truncate table tmp_DshSalesManag_LongTerm_DivMnth_dsc;
 
create local temp table tmp_DshSalesManag_LongTerm_DivMnth_7972 ( -- врем.таблица для общих классификаторов
    CliInn varchar(24),
    MaxRang int,
    Class79_Code varchar(4))
on commit preserve rows 
order by CliInn;
truncate table tmp_DshSalesManag_LongTerm_DivMnth_7972;

create local temp table tmp_DshSalesManag_LongTerm_DivMnth_merge -- врем.таблица для слияния факта и дсц
on commit preserve rows as
    select * from DataMart.DshSalesManag_LongTerm_DivMnth
where DshSalesManag_LongTerm_DivMnth.DataInfo = '0001-01-01';
truncate table tmp_DshSalesManag_LongTerm_DivMnth_merge;


insert into tmp_DshSalesManag_LongTerm_DivMnth_7972
select distinct 
    glepsfc.CliInn,
    max(cl72.RangValue) over(partition by glepsfc.CliInn) as MaxRang,
    max(left(klc79.Class79_Code, 2)) over(partition by glepsfc.CliInn) as Class79_Code
from DataPrime.GrpLegEntPersForCRM glepsfc
inner join public.DescKontrag dk on glepsfc.CliCode = dk.CliCode
inner join public.Class72 cl72 on dk.Class72_Code = cl72.Class72_Code
inner join public.KontragLinkClass79 klc79 on dk.CliCode = klc79.CliCode
    and klc79.Class79_1 = 'G'
order by 1;
commit;

insert into tmp_DshSalesManag_LongTerm_DivMnth_fact -- наполнение таблицы для факта
select
    cbs.DataInfo,
    coalesce(left(cg.ClassCodeGrp, 4), '') as Class63_Code_2,
    coalesce(left(cg.ClassCodeGrp, 6), '') as Class63_Code_3,
    left(cbs.Class294_Code, 2) as Class294_Code_,
    cla.Class79_Code as cl_79,
    cl72.Class72_Code as cl_72,
    sum(cbs.SumShipped) as SumShipped,
    0 as LongTermGoalMnth
    from public.CBStatTrader cbs
left join tmp_DshSalesManag_LongTerm_DivMnth_7972 cla on cbs.CustInn = cla.CliInn
inner join Class72 cl72 on cla.MaxRang = cl72.RangValue
left join public.ClassGroup cg on 
    ClassTypeSrc = 14 
    and ClassTypeGrp = 63 
    and ClassCodeSrc = left(cbs.CustInn, 4) 
    and ClassCodeGrp LIKE 'УП%'
where
    cbs.Class295_Code = '00001'
    and cbs.DataInfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'YEAR'), -12)
group by 
    cbs.DataInfo, Class63_Code_2, Class63_Code_3, Class294_Code_, 
    cl_79, cl_72;
commit; 

insert into tmp_DshSalesManag_LongTerm_DivMnth_dsc -- наполнение таблицы для дсц
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
    coalesce(left(cg.ClassCodeGrp, 4), '') as Class63_Code_2,
    coalesce(left(cg.ClassCodeGrp, 6), '') as Class63_Code_3,
    left(vw_ltgm.Class294_Code, 2) as Class294_Code_,
    Class79_Code as Class79_Code_,
    Class72_Code as Class72_Code_,
    0 as SumShipped,
    sum(LongTermGoalMnth) as LongTermGoalMnth
from vw_ltgm
left join tmp_DshSalesManag_LongTerm_DivMnth_7972 cla on vw_ltgm.CliInn = cla.CliInn
inner join Class72 cl72 on cla.MaxRang = cl72.RangValue
left join public.ClassGroup cg on
    ClassTypeSrc = 14
    and ClassTypeGrp = 63
    and ClassCodeSrc = left(vw_ltgm.CliInn, 4)
    and ClassCodeGrp LIKE 'УП%'
where
    vw_ltgm.DataInfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'YEAR'), -12)
group by
    vw_ltgm.DataInfo, Class63_Code_2, Class63_Code_3, Class294_Code_,
    Class79_Code_, Class72_Code_;
commit;

insert into tmp_DshSalesManag_LongTerm_DivMnth_merge -- слияние врем.таблиц выше
select
    coalesce(dsc.DataInfo, fact.DataInfo) as DataInfo,
    coalesce(dsc.Class63_Code_2, fact.Class63_Code_2) as Class63_Code_2,
    coalesce(dsc.Class63_Code_3, fact.Class63_Code_3) as Class63_Code_3,
    coalesce(dsc.Class294_Code, fact.Class294_Code) as Class294_Code,
    coalesce(dsc.Class79_Code, fact.Class79_Code) as Class79_Code,
    coalesce(dsc.Class72_Code, fact.Class72_Code) as Class72_Code,
    sum(coalesce(fact.SumShipped, 0)) as SumShipped,
    sum(coalesce(dsc.LongTermGoalMnth, 0)) as LongTermGoalMnth
from tmp_DshSalesManag_LongTerm_DivMnth_fact fact
full join tmp_DshSalesManag_LongTerm_DivMnth_dsc dsc
	on fact.DataInfo = dsc.DataInfo
    and fact.Class63_Code_2 = dsc.Class63_Code_2
    and fact.Class63_Code_3 = dsc.Class63_Code_3
    and fact.Class294_Code = dsc.Class294_Code
    and fact.Class79_Code = dsc.Class79_Code
    and fact.Class72_Code = dsc.Class72_Code
where dsc.LongTermGoalMnth > 0
group by
    coalesce(dsc.DataInfo, fact.DataInfo),
    coalesce(dsc.Class63_Code_2, fact.Class63_Code_2),
    coalesce(dsc.Class63_Code_3, fact.Class63_Code_3),
    coalesce(dsc.Class294_Code, fact.Class294_Code),
    coalesce(dsc.Class79_Code, fact.Class79_Code),
    coalesce(dsc.Class72_Code, fact.Class72_Code);
commit;

delete from tmp_DshSalesManag_LongTerm_DivMnth_merge
where DataInfo < '2024-01-01'::date;
commit;

truncate table DataMart.DshSalesManag_LongTerm_DivMnth;
insert into DataMart.DshSalesManag_LongTerm_DivMnth
select * from tmp_DshSalesManag_LongTerm_DivMnth_merge;
commit;

drop table tmp_DshSalesManag_LongTerm_DivMnth_fact;
drop table tmp_DshSalesManag_LongTerm_DivMnth_dsc;
drop table tmp_DshSalesManag_LongTerm_DivMnth_merge;
drop table tmp_DshSalesManag_LongTerm_DivMnth_7972;