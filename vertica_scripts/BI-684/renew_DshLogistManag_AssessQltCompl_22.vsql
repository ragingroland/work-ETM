create local temp table tmp_local
on commit preserve rows as
    select
        RootProc_Id,
        left(Store_Class132_Code, 4) as Class132_Code2,
        left(Store_Class132_Code, 10) as Class132_Code4,
        Proc_StartDate,
        Stage_Amount_Hours,
        Stage_Code,
        RootProc_Id || '_' || Stage_Code as compose_key
    from DataPrime.ElmaRootProc erp
    where (Proc_EndDate is null
            or Proc_EndDate >= trunc(ADD_MONTHS(CURRENT_DATE-1, -24), 'MM'))
        and (Stage_Code = 4
            or Stage_Code = 5);

create local temp table tmp_local_max
on commit preserve rows as
    select distinct
        RootProc_Id,
        Class132_Code2,
        Class132_Code4,
        Proc_StartDate,
        Stage_Code,
        compose_key,
        max(Stage_Amount_Hours) over(partition by compose_key) as Stage_Amount_Hours_MAX
    from tmp_local;

create local temp table tmp_local_sum
on commit preserve rows as
    select
        RootProc_Id,
        Class132_Code2,
        Class132_Code4,
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
        Class132_Code2,
        Class132_Code4,
        Proc_StartDate,
        Stage_Amount_Hours_SUM
    from tmp_local_sum
    group by 1, 2, 3, 4, 5;

create local temp table tmp_local2
on commit preserve rows as
    select
        RootProc_Id,
        Class132_Code2,
        Class132_Code4,
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
        Class132_Code2 as Class132_Code_Level2,
        Class132_Code4 as Class132_Code_Level4,
        sum(In24) as ComplaintCountIn24,
        sum(Over24) as ComplaintCountOver24
    from tmp_local2
    group by 1, 2, 3;
commit;