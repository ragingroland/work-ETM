\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.CliDctdPriceInfo
where CliCode = -1;

copy tmp_local
from local 'H:\OLAP\CliDctdPriceInfo\DATA\CenaFrom522.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data 'H:\OLAP\CliDctdPriceInfo\RUN\CenaFrom522.rej'
exceptions 'H:\OLAP\CliDctdPriceInfo\RUN\CenaFrom522.exc' direct skip 1;

truncate table DataPrime.CliDctdPriceInfo;
insert into DataPrime.CliDctdPriceInfo
select *
from tmp_local;
commit;
