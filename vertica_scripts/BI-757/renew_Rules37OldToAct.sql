create local temp table tmp_local (
	op varchar(100),
	store varchar(50),
	"37old" varchar(18),
	"37new" varchar(18))
on commit preserve rows;

copy tmp_local -- дальше копирование данных из файлов
from local 'H:\OLAP\Rules37OldToAct\DATA\Rules37OldToAct.vcsv'
    abort on error
    delimiter ';'
    null ''
    enclosed by '"'
rejected data 'H:\OLAP\Rules37OldToAct\RUN\Rules37OldToAct.rej'
exceptions 'H:\OLAP\Rules37OldToAct\RUN\Rules37OldToAct.exc' direct skip 1;

-- загрузить данные в основу
truncate table DataPrime.Rules37OldToAct;
insert into DataPrime.Rules37OldToAct
select
    upper("37old") as Class37_Code_Wrng,
    upper("37new") as Class37_Code_Right
from tmp_local;
commit;
