create local temp table tmp_onec_unit (
    date_slice date,
    unit_id int,
    unit_name varchar(100),
    unit_type_id int,
    unit_type_name varchar(100),
    type varchar(30),
    region_id int,
    position_id varchar(30))
on commit preserve rows;
truncate table tmp_onec_unit;
    
insert into tmp_onec_unit (
    nel.date_slice,
    nel.unit_id,
    unit_name,
    unit_type_id int,
    unit_type_name,
    type,
    region_id,
    position_id
from DataPrime.OneC_NumberEmpl nel 
inner join DataPrime.OneC_Dismissal dsms on nel.unit_id = dsms.unit_id
where date_slice <= trunc(current_date - 1, 'month')::date
    and date_slice >= add_months(trunc(current_date - 1, 'month')::date, - 36)
    and type_of_employment_id = 3);