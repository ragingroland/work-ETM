create local temp table pre
on commit preserve rows as
select
    pcr.DataInfo,
    pcr.RgdCode,
    region_id,
    NetNum,
    left(Class3_Code, 2) as Class3_2,
    dr.MnfCode,
    company_name,
    comp_status,
    '0' as outlier,
    coalesce(PriceETM_NDS, 0) as PriceETM_NDS,
    min(coalesce(Comp_Price, 0)) over(partition by DataInfo, pcr.RgdCode, company_name, region_id, NetNum) as min_Comp_Price
from DataPrime.Price_common_report pcr
left join public.DescRgd dr on pcr.RgdCode = dr.RgdCode
where DataInfo >= add_months(trunc(current_date - 1, 'MM'), - 12)
group by 1, 2, 3, 4, 5, 6, 7, 8, pcr.PriceETM_NDS, Comp_Price
union all
select
    DataInfo,
    por.RgdCode,
    region_id,
    por.NetNum,
    left(Class3_Code, 2) as Class3_2,
    dr.MnfCode,
    por.company_name,
    status as comp_status,
    '1' as outlier,
    coalesce(PriceETM_NDS, 0) as PriceETM_NDS,
    min(coalesce(Comp_Price, 0)) over(partition by DataInfo, por.RgdCode, por.company_name, region_id, por.NetNum) as min_Comp_Price
from DataPrime.Price_outliers_report por
left join public.DescRgd dr on por.RgdCode = dr.RgdCode
left join DataPrime.price_comp_status pcs on por.company_name = pcs.company_name
    and por.NetNum = pcs.NetNum
	and left(dr.Class3_Code, 2) = pcs.Class33_Code_2
where DataInfo >= add_months(trunc(current_date - 1, 'MM'), - 12)
group by 1, 2, 3, 4, 5, 6, 7, 8, por.PriceETM_NDS, Comp_Price;

drop table tmp_local;

create local temp table tmp_local
on commit preserve rows as
select
    pre.DataInfo,
    region_id,
    pre.NetNum,
    Class3_2,
    pre.MnfCode,
    company_name,
    comp_status,
    outlier,
    t10.MnfCode as isTOP10,
    t20.MnfCode as isTOP20,
    (PriceETM_NDS / min_Comp_Price) - 1 as d
from pre
left join DataMart.DshPricing_MnfCodeTop10 t10 on pre.MnfCode = t10.MnfCode
	and trunc(pre.DataInfo, 'mm')::date = t10.DataInfo
left join DataMart.DshPricing_MnfCodeTop20 t20 on pre.MnfCode = t20.MnfCode
	and trunc(pre.DataInfo, 'mm')::date = t20.DataInfo;
group by 1, 9, 2, 3, 4, 5, 6, 7, 8, 10, 11, t20.MnfCode, PriceETM_NDS, min_Comp_Price;

select distinct istop20 from tmp_local;

drop table post;

create local temp table post
on commit preserve rows as
select
	DataInfo,
	dayofweek_iso(DataInfo) as DataInfo_dayofweek,
    date_trunc('week', DataInfo)::date AS DataInfo_start_of_week,
    date_trunc('month', DataInfo)::date AS DataInfo_months_start,
    region_id,
    NetNum,
    Class3_2,
    MnfCode,
    company_name,
    comp_status,
    outlier,
    isTOP10,
    isTOP20,
    case
    	when isTOP10 is null
    		then 0
    	else 1
    end as TOP10,
    case
    	when isTOP20 is null
    		then 0
    	else 1
    end as TOP20,
    Clust_Code,
	SubClust_Code,
	count(*) over(partition by clust_code, subclust_code, datainfo, region_id, netnum, class3_2, mnfcode, company_name, comp_status, outlier) as merch_count
from tmp_local
left join DataMart.DescSubClustCmpPrcEtmMarkt on lowbound < d and d <= upbound;

select * from post
group by clust_code, subclust_code, region_id, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, merch_count, netnum;
select distinct subclust_code, merch_count from post;
