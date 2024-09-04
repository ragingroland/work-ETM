\set ON_ERROR_STOP ON;

create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.price_comp_status
where NetNum = 0;
truncate table tmp_local;

copy tmp_local -- дальше копирование данных из файлов
from local 'H:\OLAP\price_comp_status\DATA\price_comp_status.vcsv'
    abort on error
    delimiter ';'
    null ''
    enclosed by '"'
rejected data 'H:\OLAP\price_comp_status\RUN\price_comp_status.rej'
exceptions 'H:\OLAP\price_comp_status\RUN\price_comp_status.exc' direct skip 1;

-- загрузить данные в основу
truncate table DataPrime.price_comp_status;
insert into DataPrime.price_comp_status
select
    company_name,
    NetNum,
    status,
    left(upper(Class33_Code_2), 2)
from tmp_local;
commit;
