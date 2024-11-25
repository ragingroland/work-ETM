create local temp table tmp_local
on commit preserve rows as
select
	trunc(DataInfo, 'q')::date as DataInfo,
	case
		when add_months(trunc(current_date, 'q')::date, - 15) = trunc(DataInfo, 'q')::date
			then 'X1'
		when add_months(trunc(current_date, 'q')::date, - 12) = trunc(DataInfo, 'q')::date
			then 'X2'
		when add_months(trunc(current_date, 'q')::date, - 9) = trunc(DataInfo, 'q')::date
			then 'X3'
		else 'X4'
	end as nmrs,
	CustInn,
	Class294_Code,
	case
		when sum(SumShipped) < 0
			then 0
		else sum(SumShipped)
	end as SumShipped
from public.CBStatTrader cbs
where (trunc(DataInfo, 'q')::date between add_months(trunc(current_date, 'q')::date, - 15) and add_months(trunc(current_date, 'q')::date, - 4))
group by trunc(DataInfo, 'q')::date, CustInn, Class294_Code;

create local temp table tmp_local2
on commit preserve rows as
with
inn294 as (
	select
		CustInn,
		Class294_Code
	from tmp_local
	group by 1, 2)
select
	d.CustInn,
	d.Class294_Code,
	coalesce(l1.SumShipped, 0) as SumsX1,
	coalesce(l2.SumShipped, 0) as SumsX2,
	coalesce(l3.SumShipped, 0) as SumsX3,
	coalesce(l4.SumShipped, 0) as SumsX4
from inn294 d
left join tmp_local l1 on d.CustInn = l1.CustInn
	and d.Class294_Code = l1.Class294_Code
	and l1.nmrs = 'X1'
left join tmp_local l2 on d.CustInn = l2.CustInn
	and d.Class294_Code = l2.Class294_Code
	and l2.nmrs = 'X2'
left join tmp_local l3 on d.CustInn = l3.CustInn
	and d.Class294_Code = l3.Class294_Code
	and l3.nmrs = 'X3'
left join tmp_local l4 on d.CustInn = l4.CustInn
	and d.Class294_Code = l4.Class294_Code
	and l4.nmrs = 'X4';

create local temp table tmp_local3
on commit preserve rows as
with
casey as (
	select
		CustInn,
		Class294_Code,
		case
			when SumsX1 != 0
				then ((SumsX1 + SumsX2 + SumsX3) / 3 + SumsX4) / 2
			when SumsX1 = 0 and SumsX2 != 0
				then ((SumsX2 + SumsX3) / 2 + SumsX4) / 2
			when SumsX1 = 0 and SumsX2 = 0 and SumsX3 != 0
				then (SumsX3 + SumsX4) / 2
			when SumsX1 = 0 and SumsX2 = 0 and SumsX3 = 0 and SumsX4 != 0
				then SumsX4
		end as supercase
	from tmp_local2)
select
	CustInn,
	Class294_Code,
	Class296_Code
from casey
left join public.Class296 on LowBound < supercase and supercase < UpBound;
