create local temp table tmp_local (
    RgdCode int,
    Class220_Code varchar(4))
on commit preserve rows;

copy tmp_local (
    RgdCode,
    Class220_Code)
from local 'H:\OLAP\RgdLinkClass220\DATA\RgdLinkClass220.csv'
    delimiter '|'
    null ''
    enclosed by '"'
rejected data 'H:\OLAP\RgdLinkClass220\RUN\RgdLinkClass220.rej'
exceptions 'H:\OLAP\RgdLinkClass220\RUN\RgdLinkClass220.exc' direct;

truncate table DataPrime.RgdLinkClass220;
insert into DataPrime.RgdLinkClass220
select * from tmp_local;
commit;
