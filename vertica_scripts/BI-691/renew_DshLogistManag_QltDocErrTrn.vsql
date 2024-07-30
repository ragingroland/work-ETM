create local temp table tmp_local
on commit preserve rows as
    with
        cte_132uniq as (
            select distinct
                Store_Class132_Code uniqcl132
            from DataPrime.ElmaRootProc
            where Proc_StartDate >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'MM'), -24)),
        cte_rn as (
            select
                uniqcl132,
                rdc.StoreCode,
                rdc.TypeStore,
                rdc.LogistikCentreName,
                row_number() over(partition by uniqcl132) as rn
            from cte_132uniq
            left join DataPrime.StoreLinkClass132 cl132 on cl132.Class132_Code = cte_132uniq.uniqcl132
            left join public.RegionDescCommon rdc on rdc.StoreCode = cl132.StoreCodeSymb
            where rdc.TypeStore in ('ОП', 'ЛЦ', 'ЦРС', 'ПрямыеДоставки')),
        cte_lc as (
            select
                StoreCode code,
                LogistikCentreName lname
            from public.RegionDescCommon
            where TypeStore in ('ЛЦ', 'ЦРС')),
        cte_dtl as (
            select
                DataInfo,
                lc.code as StoreCode,
                sum(ctd.QuantInv) as QuantInv
            from public.CliTurnoverDtl ctd
            left join public.RegionDescCommon rdc on rdc.StoreCode = ctd.StoreCode
            left join cte_lc lc on rdc.LogistikCentreName = lc.lname
            where datainfo >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'MM'), -24)
            	and rdc.TypeStore in ('ОП', 'ЛЦ', 'ЦРС', 'ПрямыеДоставки')
            group by 1, 2),
        cte_root as (
            select
                RootProc_Id,
                trunc(Proc_StartDate, 'MM')::date as DataInfo,
                lc.code as StoreCode
            from DataPrime.ElmaRootProc erp
            left join cte_rn rn on erp.Store_Class132_Code = rn.uniqcl132 and rn.rn = 1
            left join cte_lc lc on rn.LogistikCentreName = lc.lname
            where Proc_StartDate >= ADD_MONTHS(trunc(CURRENT_DATE - 1 , 'MM'), -24)
            group by 1, 2, 3),
        cte_main as (
            select
            	r.DataInfo,
                r.StoreCode,
                count(distinct ecp.RootProc_Id) as QltDocErr
            from DataPrime.ElmaChildProc ecp
            inner join cte_root r on ecp.RootProc_Id = r.RootProc_Id
            where ecp.Reason_Code in(5, 6)
                and ecp.Stage_Code ='13'
                    and not exists (
                        select
                            1
                        from DataPrime.ElmaChildProc r2
                        where r2.RootProc_Id = r.RootProc_Id
                            and r2.Stage_Code = '9')
            group by 1, 2)
select
	m.DataInfo as DataInfo,
	coalesce(m.StoreCode, '') as StoreCode_LC,
	coalesce(QuantInv, 0) as QltDocCount,
	QltDocErr
from cte_main m
left join cte_dtl dtl on m.DataInfo = dtl.DataInfo
	and m.StoreCode = dtl.StoreCode;

truncate table DataMart.DshLogistManag_QltDocErrTrn;
insert into DataMart.DshLogistManag_QltDocErrTrn
select * from tmp_local;
commit;