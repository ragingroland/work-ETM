create local temp table tmp_local (
    company_name varchar(50),
    NetNum varchar(20),
    region_id varchar(20))
on commit preserve rows;

copy tmp_local (
    company_name,
    NetNum,
    region_id)
from local 'H:\OLAP\price_comp_parse_nets\DATA\price_comp_parse_nets.vcsv'
    delimiter ';'
    null ''
    enclosed by '"'
rejected data 'H:\OLAP\price_comp_parse_nets\DATA\price_comp_parse_nets.rej'
exceptions 'H:\OLAP\price_comp_parse_nets\DATA\price_comp_parse_nets.exc' direct skip 1;

truncate table DataPrime.price_comp_parse_nets;
insert into DataPrime.price_comp_parse_nets 
select
    company_name,
    NetNum::int,
    region_id
from tmp_local;

commit;
