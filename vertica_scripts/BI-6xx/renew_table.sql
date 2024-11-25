create local temp table tmp_datamart1
on commit preserve rows as
    select * from datamart.datamart1
where datamart1.DataInfo = '0001-01-01';
truncate table tmp_datamart1;

insert into tmp_datamart1
select
    DataInfo,
    CliCode,
    CliInn,
    RgdCode,
    SalesChannel,
    SalesSubChannel,
    Class294_Code,
    Class79_Code,
    sum(SumSaled) as SumSaled
from public.CliTurnoverDtl as ctd
left join dataprime.GrpLegEntPersForCRM as glepfc on ctd.CliCode = glepfc.CliCode
left join dataprime.LongTermGoalDiv_Legent as ltgdl on glepfc.CliInn = ltgdl.CliInn
left join public.Class294 as cls294 on ltgdl.Class294_Code = cls294.Class294_Code;
commit;

truncate table datamart.tmp_datamart1;

insert into datamart.datamart1