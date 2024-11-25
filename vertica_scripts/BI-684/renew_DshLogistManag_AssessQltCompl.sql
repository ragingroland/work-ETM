create local temp table tmp_local
on commit preserve rows as
WITH 
--собираем уникальные 132е из элмы
Uniq132 as (
    select
        distinct Store_Class132_Code uniqcl132
    from DataPrime.ElmaRootProc
),
--к уникальным 132ым из элмы джойним наши три таблицы, чтобы вытащить сторкод
--попутно складываем тип и имя рядом
--и нумеруем сторкоды в окне 132ого, чтобы потом взять только один единственный сторкод
RN as (
    select
         uniqcl132
        ,rdc.StoreCode
        ,rdc.TypeStore
        ,rdc.LogistikCentreName
        ,ROW_NUMBER() OVER (PARTITION BY uniqcl132) as rn
    from Uniq132
    left join DataPrime.StoreLinkClass132 cl132 on cl132.Class132_Code = Uniq132.uniqcl132
    left join public.RegionDescCommon rdc on rdc.StoreCode = cl132.StoreCodeSymb
    where rdc.TypeStore in ('ОП', 'ЛЦ', 'ЦРС', 'ПрямыеДоставки')
),
--сюда собираем сторкод и имя для тех, у кого тип будет не ЛЦ/ЦРС на момент определения столбца ЛЦ
LC as (
    select StoreCode code, LogistikCentreName lname from public.RegionDescCommon where TypeStore in ('ЛЦ', 'ЦРС')
)
    select
        RootProc_Id,
        coalesce(StoreCode,'') as StoreCode_OP,
        case when TypeStore in ('ЛЦ', 'ЦРС') then StoreCode else coalesce(LC.code,'') end as StoreCode_LC,
        Proc_StartDate,
        Stage_Amount_Hours,
        Stage_Code,
        RootProc_Id || '_' || Stage_Code as compose_key
    from DataPrime.ElmaRootProc erp
    left join RN on RN.uniqcl132 = erp.Store_Class132_Code and rn = 1
    left join LC on LC.lname = RN.LogistikCentreName
    where (Proc_EndDate is null
            or Proc_EndDate >= trunc(ADD_MONTHS(CURRENT_DATE-1, -24), 'MM'))
        and (Stage_Code = 4
            or Stage_Code = 5);

create local temp table tmp_local_max
on commit preserve rows as
    select distinct
        RootProc_Id,
        StoreCode_OP,
        StoreCode_LC,
        Proc_StartDate,
        Stage_Code,
        compose_key,
        max(Stage_Amount_Hours) over(partition by compose_key) as Stage_Amount_Hours_MAX
    from tmp_local;

create local temp table tmp_local_sum
on commit preserve rows as
    select
        RootProc_Id,
        StoreCode_OP,
        StoreCode_LC,
        Proc_StartDate,
        Stage_Amount_Hours_MAX,
        Stage_Code,
        compose_key,
        sum(Stage_Amount_Hours_MAX) over(partition by RootProc_Id) as Stage_Amount_Hours_SUM
    from tmp_local_max;

create local temp table tmp_local_grouped
on commit preserve rows as
    select
        RootProc_Id,
        StoreCode_OP,
        StoreCode_LC,
        Proc_StartDate,
        Stage_Amount_Hours_SUM
    from tmp_local_sum
    group by 1, 2, 3, 4, 5;

create local temp table tmp_local2
on commit preserve rows as
    select
        RootProc_Id,
        StoreCode_OP,
        StoreCode_LC,
        Proc_StartDate,
        Stage_Amount_Hours_SUM,
        case
            when dayofweek(Proc_StartDate) = 1
                then Stage_Amount_Hours_SUM - 8
            when dayofweek(Proc_StartDate) = 7
                then Stage_Amount_Hours_SUM - 32
            when dayofweek(Proc_StartDate) = 6 and IsWrkDay
                then Stage_Amount_Hours_SUM - 48
            when (dayofweek(Proc_StartDate) = 6 or dayofweek(Proc_StartDate) = 2) and not IsWrkDay
                then Stage_Amount_Hours_SUM - 72
            when (dayofweek(Proc_StartDate) <> 6 or dayofweek(Proc_StartDate) <> 2) and not IsWrkDay
                then Stage_Amount_Hours_SUM - 24
            else Stage_Amount_Hours_SUM
        end as Hours_,
        case 
            when Hours_ >= 0
                then Hours_
            else 0
        end as Hours_itog,
        trunc(TIMESTAMPADD(HOUR, - Hours_itog, Proc_StartDate::TIMESTAMP), 'MM') as DataInfo,
        case
            when Hours_itog <= 24
                then 1
            else 0
        end as In24,
        case 
            when Hours_itog <= 24
                then 0
            else 1
        end as Over24
    from tmp_local_grouped
    inner join DataPrime.InfoWrkDayAllMonth wd on wd.DataInfo = tmp_local_grouped.Proc_StartDate;

truncate table DataMart.DshLogistManag_AssessQltCompl;
insert into DataMart.DshLogistManag_AssessQltCompl
    select
        DataInfo::date,
        StoreCode_LC,
        StoreCode_OP,
        sum(In24) as ComplaintCountIn24,
        sum(Over24) as ComplaintCountOver24
    from tmp_local2
    group by 1, 2, 3;
commit;