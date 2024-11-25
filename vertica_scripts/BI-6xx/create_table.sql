create table datamart.datamart1 (
    DataInfo date,
    CliCode int,
    CliInn int,
    RgdCode int,
    SalesChannel varchar(6),
    SalesSubChannel varchar(8),
    Class294_Code varchar(12),
    Class79_Code varchar(6),
    SumSaled float);

create projection datamart.datamart1 (
    DataInfo,
    CliCode,
    CliInn,
    RgdCode,
    SalesChannel,
    SalesSubChannel,
    Class294_Code,
    Class79_Code,
    SumSaled)
as select
    datamart1.DataInfo,
    datamart1.CliCode,
    datamart1.CliInn,
    datamart1.RgdCode,
    datamart1.SalesChannel,
    datamart1.SalesSubChannel,
    datamart1.Class294_Code,
    datamart1.Class79_Code,
    datamart1.SumSaled
from datamart.datamart1
order by
    datamart1.CliCode,
    datamart1.RgdCode,
    datamart1.Class294_Code,
    datamart1.Class79_Code
segmented by hash (
    datamart1.DataInfo,
    datamart1.CliCode,
    datamart1.CliInn,
    datamart1.RgdCode,
    datamart1.SalesChannel,
    datamart1.SalesSubChannel,
    datamart1.Class294_Code,
    datamart1.Class79_Code,
    datamart1.SumSaled) all nodes ksafe 1;

select mark_design_ksafe(1); -- нужно?