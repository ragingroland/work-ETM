create local temp table tmp_local
on commit preserve rows as
with
c79 as (
	select
		cbs.CustInn,
		left(Class79_Code, 2) as Class79_Code,
		cbs.CustCode,
		row_number() over(partition by CustInn, CustCode) as rn
	from public.CBStatTrader cbs
	left join public.KontragLinkClass79 klc79 on cbs.CustCode = klc79.CliCode
	    and klc79.Class79_1 = 'G'),
notE as (
	select CustInn from public.CBStatTrader
	inner join public.KontragLinkClass79 on CustCode = CliCode and Class79_1 = 'E'
	where CBStatTrader.DataInfo >= add_months(trunc(current_date - 1 , 'year'), -24)
	group by 1)
select
    trunc(DataInfo, 'q')::date as DataInfo,
    QuartInfo,
    YearInfo,
	coalesce(left(cg.ClassCodeGrp, 4), '') as Class63_Code_2,
	coalesce(left(cg.ClassCodeGrp, 6), '') as Class63_Code_3,
    left(cbs.Class294_Code, 2) as Class294_Code,
    coalesce(cg298.ClassCodeGrp, '99999') as Code_QuasiBrand,
	coalesce(Class296_Code, '') as Class296_Code,
	coalesce(c79.Class79_Code, '') as Class79_Code,
    case
    	when Class295_Code = '00001'
    		then 1
    	else 0
    end as isETM,
    sum(SumShipped) as SumShipped
from public.CBStatTrader cbs
left join c79 on cbs.CustInn = c79.CustInn and rn = 1
left join public.ClassGroup cg on
    ClassTypeSrc = 14
    and ClassTypeGrp = 63
    and ClassCodeSrc = left(cbs.CustInn, 4)
left join public.ClassGroup cg298 on
    cg298.ClassTypeSrc = 295
    and cg298.ClassTypeGrp = 298
    and cg298.ClassCodeSrc = cbs.Class295_Code
left join KontragLinkClass296 klc296 on cbs.CustCode = klc296.CliCode
	and left(cbs.Class294_Code, 2) = left(klc296.Class294_Code, 2)
where cbs.DataInfo >= add_months(trunc(current_date - 1 , 'year'), -24)
	and not exists (select 1 from DataPrime.BrandsTrdsExclCL295CRM where Class295_Code = cbs.Class295_Code)
	and not exists (select 1 from notE where CustInn = cbs.CustInn)
group by trunc(DataInfo, 'q')::date, 2, 3, 4, 5, 6, 7, 8, 9, 10;

truncate table DataMart.DshMCB_GeneralSheet_MCBTrnFact;
SELECT PURGE_TABLE('DataMart.DshMCB_GeneralSheet_MCBTrnFact');
insert into DataMart.DshMCB_GeneralSheet_MCBTrnFact
select * from tmp_local;
commit;

select analyze_statistics('DataMart.DshMCB_GeneralSheet_MCBTrnFact');
