-- витрина для анализа по срезам "день"

create local temp table tmp_interval (
    targetdate date)
on commit preserve rows;
truncate table tmp_interval;

insert into tmp_interval (
    select trunc(ADD_MONTHS(CURRENT_DATE-1, -12), 'MM') as targetdate);

create local temp table tmp_otdd (
    DataInfo date,
    CliCode int,
    UsrInvNumReqDelivNum varchar(150),
    compose_key varchar(150),
    serial int)
on commit preserve rows;
truncate table tmp_otdd;

insert into tmp_otdd (
    select
        cdc.DataInfo,
        cdc.CliCode,
        cdc.UsrInvNumReqDelivNum,
        cdc.DataInfo || ' ' || cdc.CliCode || ' ' || cdc.UsrInvNumReqDelivNum as compose_key,
        row_number() over(order by compose_key) as serial
    from tmp_interval, DataPrime.CliDelivCtrl cdc
    where cdc.DataInfo >= targetdate);
commit;

create local temp table tmp_tcl (
    DataInfo date,
    DataReqDeliv date,
    UsrInvNumReqDelivNum varchar(150),
    CliCode int,
    delta interval,
    total_minutes numeric,
    compose_key varchar(150),
    LateCode varchar(50))
on commit preserve rows;
truncate table tmp_tcl;

insert into tmp_tcl (
    select
        cdc.DataInfo,
        cdc.DataReqDeliv,
        cdc.UsrInvNumReqDelivNum,
        cdc.CliCode,
        (DataReqDelivFact_date||' '||DataReqDelivFact_time)::timestamp - (DataReqDelivTo_date||' '||DataReqDelivTo_time)::timestamp as delta,
        case when EXTRACT(DAY FROM delta)*24*60 + EXTRACT(HOUR FROM delta)*60 + EXTRACT(MINUTE FROM delta) >= 0 
            then EXTRACT(DAY FROM delta)*24*60 + EXTRACT(HOUR FROM delta)*60 + EXTRACT(MINUTE FROM delta) 
            else 0 
        end as total_minutes,
        cdc.DataInfo || ' ' || cdc.CliCode || ' ' || cdc.UsrInvNumReqDelivNum as compose_key,
        case when delta is null 
            then null 
            else tcl.LateCode 
            end as LateCode
    from tmp_interval, DataMart.DshLogistManag_TypeCodeLate tcl, DataPrime.CliDelivCtrl cdc 
    where total_minutes > LowBound and total_minutes <= UpBound
        and cdc.DataInfo >= targetdate);
commit;

create local temp table tmp_main (
    DataInfo date,
    MnthStrt date,
    StoreCode varchar(150),
    ReqNum varchar(150),
    CliCode int,
    ReqID int,
    compose_key varchar(150),
    LateCode int)
on commit preserve rows;
truncate table tmp_main;

insert into tmp_main (
    select
        cdc.DataInfo as DataInfo,
        trunc(cdc.DataInfo, 'MM')::date as MnthStrt,
        coalesce(rdc.StoreCode::int, 0) as StoreCode,
        cdc.UsrInvNumReqDelivNum as ReqNum,
        cdc.CliCode as CliCode,
        0 as ReqID,
        cdc.DataInfo|| ' ' || cdc.CliCode || ' ' || cdc.UsrInvNumReqDelivNum as compose_key,
        0 as LateCode
    from tmp_interval, DataPrime.CliDelivCtrl cdc
    left join public.RegionDescCommon rdc on cdc.CliStoreCode = rdc.StoreCode
        and rdc.TypeStore = 'ЛЦ'
    inner join DataPrime.StoreLinkClass10 slc on cdc.CliStoreCode::varchar(21) = slc.StoreCodeSymb
        and slc.Class10_Code in ('НО', 'ОП', 'РЦ')
    where cdc.DataInfo >= targetdate);
commit;

create local temp table tmp_DshLogistManag_OnTimeDeliv_Day (
    DataInfo date,
    MnthStrt date,
    StoreCode int,
    ReqNum varchar(150),
    CliCode int,
    ReqID int,
    LateCode int)
on commit preserve rows;
truncate table tmp_DshLogistManag_OnTimeDeliv_Day;

insert into tmp_DshLogistManag_OnTimeDeliv_Day (
select 
    main.DataInfo,
    main.MnthStrt,
    main.StoreCode::int as StoreCode,
    main.ReqNum,
    main.CliCode,
    otd.serial as ReqID,
    tcl.LateCode::int as LateCode
from tmp_main main
inner join tmp_otdd otd on main.compose_key = otd.compose_key
inner join tmp_tcl tcl on otd.compose_key = tcl.compose_key
group by main.compose_key, 1, 2, 3, 4, 5, 6, 7);
commit;

truncate table DataMart.DshLogistManag_OnTimeDeliv_Day;
insert into DataMart.DshLogistManag_OnTimeDeliv_Day
select * from tmp_DshLogistManag_OnTimeDeliv_Day;
commit;