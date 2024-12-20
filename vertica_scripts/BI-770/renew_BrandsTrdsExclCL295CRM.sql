create local temp table tmp_local
on commit preserve rows as
select * from DataPrime.BrandsTrdsExclCL295CRM where Class295_Code = 0;
truncate table tmp_local;

copy tmp_local
from local 'H:\OLAP\BrandsTrdsExclCL295CRM\DATA\BrandsTradersExcludedCLCCrm.csv'
    abort on error
    delimiter '|'
    null ''
    enclosed by '"'
    rejectmax 1
rejected data 'H:\OLAP\BrandsTrdsExclCL295CRM\RUN\BrandsTradersExcludedCLCCrm.rej'
exceptions 'H:\OLAP\BrandsTrdsExclCL295CRM\RUN\BrandsTradersExcludedCLCCrm.exc' direct;

-- загрузить данные в основу
truncate table DataPrime.BrandsTrdsExclCL295CRM;
insert into DataPrime.BrandsTrdsExclCL295CRM
select upper(Class295_Code)
from tmp_local;
commit;
