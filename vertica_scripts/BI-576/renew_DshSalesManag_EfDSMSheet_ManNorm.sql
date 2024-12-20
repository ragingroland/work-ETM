create local temp table tmp_local
on commit preserve rows as
with mans as (
	select
		DataInfo,
		coalesce(left(cg.classCodeGrp, 6), '') as Class63_Code,
		Class55_Code,
		Category,
		KeyCalcBonus,
		count(ManCode) as ManCount
	from public.Class37History c37
	left join public.classGroup cg
		on classTypeSrc = 37
	    and classTypeGrp = 63
	    and classCodeSrc = left(c37.class37_Code, 5)
	    and classCodeGrp LIKE 'УП%'
	where ManCode > 0
		and lower(Category) != 'уволен'
		and lower(Category) != 'стажер'
		and KeyCalcBonus != ''
		and not KeyCalcBonus is null
		and DataInfo >= greatest(add_months(trunc(current_date - 1 , 'year'), -24), '2023-11-01'::date)
	group by 1, 2, 3, 4, 5),
main as (
	select
		m.DataInfo,
		left(Class63_Code, 4) as Class63_Code_2,
		Class63_Code as Class63_Code_3,
		coalesce(m.Class55_Code, '') as Class55_Code,
		coalesce(m.Category, '') as Category,
		coalesce(m.KeyCalcBonus, '') as TypeMotiv,
		ManCount,
		ManCount * NormCCB as PCBNorm
	from mans m
	inner join DataPrime.NormativCCBMotivMng mm on m.KeyCalcBonus = mm.TypeMotiv
		and m.Category = mm.Category
		and m.Class55_Code = mm.Class55_Code
		and trunc(m.DataInfo, 'q')::date = mm.DataInfo
	where m.datainfo >= greatest(add_months(trunc(current_date - 1 , 'year'), -24), '2023-11-01'::date))
select * from main;

create local temp table tmp_local2
on commit preserve rows as
with mans as (
	select
		DataInfo,
		coalesce(left(cg.classCodeGrp, 6), '') as Class63_Code,
		ManCode,
		Class37_Code,
		Class55_Code,
		Category,
		KeyCalcBonus
	from public.Class37History с37
	left join public.classGroup cg
		on classTypeSrc = 37
	    and classTypeGrp = 63
	    and classCodeSrc = left(с37.class37_Code, 5)
	    and classCodeGrp LIKE 'УП%'
	where DataInfo >= greatest(add_months(trunc(current_date - 1 , 'year'), -24), '2023-11-01'::date)
		and ManCode > 0
		and KeyCalcBonus != ''
	group by 1, 2, 3, 4, 5, 6, 7),
main as (
	select
		ctd.DataInfo,
		ctd.CliCode || '_' || m.ManCode as CliManCode,
		left(Class63_Code, 4) as Class63_Code_2,
		Class63_Code as Class63_Code_3,
		m.Class55_Code,
		m.Category,
		m.KeyCalcBonus as TypeMotiv,
		sum(SumSaled) as SumSaled
	from public.CliTurnoverDtl ctd
	inner join mans m on ctd.DataInfo = m.DataInfo
		and ctd.ManCode = m.ManCode -- считается только в рамках менеджера
	inner join DataPrime.NormativCCBMotivMng mm on m.Class55_Code = mm.Class55_Code
		and m.Category = mm.Category
		and m.KeyCalcBonus = mm.TypeMotiv
		and trunc(m.DataInfo, 'q')::date = mm.DataInfo
	where ctd.datainfo >= greatest(add_months(trunc(current_date - 1 , 'year'), -24), '2023-11-01'::date)
	group by 1, 2, 3, 4, 5, 6, 7, MinBound
	having MinBound <= sum(SumSaled))
select * from main;

truncate table DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt;
insert into DataMart.DshSalesManag_EfDSMSheet_ManNormFactCnt
select * from tmp_local;
commit;

truncate table DataMart.DshSalesManag_EfDSMSheet_ManNormFact;
insert into DataMart.DshSalesManag_EfDSMSheet_ManNormFact
select * from tmp_local2;
commit;
