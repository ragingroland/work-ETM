create local temp table tmp_local
on commit preserve rows as
select
    pcr.DataInfo,
    dayofweek_iso(pcr.DataInfo) as DataInfo_dayofweek,
    date_trunc('week', pcr.DataInfo)::date AS DataInfo_start_of_week,
    date_trunc('month', pcr.DataInfo)::date AS DataInfo_months_start,
    coalesce(pcr.region_id, por.region_id) as region_id,
    coalesce(pcr.NetNum, por.NetNum) as NetNum,
    pcs.Class33_Code_2 as Class3_Code_2,
    coalesce(dr.MnfCode, 0) as MnfCode,
    coalesce(pcr.company_name, por.company_name) as company_name,
    pcs.status as comp_status,
    coalesce(por.Price81, '0') as outlier,
    isnull(t10.MnfCode, '0') as isTOP10,
    isnull(t20.MnfCode, '0') as isTOP20,
    0 as Clust_Code,
    0 as SubClust_Code,
    0 as Clust_merch_count,
    round((
    	coalesce(pcr.PriceETM_NDS, por.PriceETM_NDS) /
    	coalesce(pcr.Comp_Price, por.Comp_Price) * 100) - 1, 2) as deviation
from DataPrime.Price_common_report pcr
left join DataPrime.Price_outliers_report por on pcr.DataInfo = por.DataInfo
    and pcr.region_id = por.region_id
    and pcr.NetNum = por.NetNum
    and pcr.RgdCode = por.RgdCode
    and pcr.PriceETM_NDS = por.PriceETM_NDS
    and pcr.Comp_Price = por.Comp_Price
left join DataPrime.price_comp_status pcs on pcr.company_name = pcs.company_name
    and pcr.NetNum = pcs.NetNum
    and pcr.comp_status = pcs.status
left join public.DescRgd dr on pcs.Class33_Code_2 = left(dr.Class3_Code, 2)
    and pcr.RgdCode = dr.RgdCode
left join DataMart.DshPricing_MnfCodeTop10 t10 on dr.MnfCode = t10.MnfCode
left join DataMart.DshPricing_MnfCodeTop20 t20 on dr.MnfCode = t20.MnfCode
where pcr.DataInfo >= add_months(trunc(current_date - 1, 'MM'), - 12)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, pcr.PriceETM_NDS, pcr.Comp_Price, por.PriceETM_NDS, por.Comp_Price;

select * from tmp_local;
select distinct istop10 from tmp_local;
select distinct istop20 from tmp_local;

drop table tmp_local2;

create local temp table tmp_local2
on commit preserve rows as
select
	DataInfo,
    region_id,
    NetNum,
    Class3_Code_2,
    MnfCode,
    deviation as d,
    case
    	when d <= -0.5
    		then 1
    	else 0
    end as Code,
    case
    	when d <= -0.5
    		then 101
    	when -0.5 < d and d < 1
    		then 102
    	when d >= 1
    		then 103
    	else 0
    end as SCode,
    count(Clust_merch_count) over(partition by Code, SCode) as merch_count
from tmp_local;

select * from tmp_local2 where SCode in (101, 102, 103);
group by 1, 2, 3, 4, 5, 6, 7;