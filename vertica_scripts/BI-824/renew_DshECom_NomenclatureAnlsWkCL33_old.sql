/* из первички берутся нужные для расчетов мер и построения витрины столбцы
на основании максимальной даты из витрины, из первички берутся более свежие данные
т.к если брать за весь период, то получается очень много. это было необходимо только для первого наполнения */
create local temp table n_wk33
on commit preserve rows as
select
    nm.DataInfo,
    left(dr.Class33_Code, 5) as Class33_Code,
    nm.Status,
    nm.RgdCode
from DataPrime.ECom_NomenclatureWk nm
left join public.DescRgd dr on nm.RgdCode = dr.RgdCode
where DataInfo >= (select max(DataInfo) from DataMart.DshECom_NomenclatureAnlsWkCL33)
    -- nm.DataInfo >= add_months(trunc(current_date, 'year')::date, - 12)
    and nm.Status != 'N';

-- все меры считаются в конкретном срезе с конкретными условиями, по отдельности
create local temp table totalcards -- карточек всего
on commit preserve rows as
select
    n_wk33.DataInfo,
    n_wk33.Class33_Code,
    n_wk33.Status,
    count(distinct RgdCode) + isnull(Qlt_Inactive33, 0) as TotalCards
from n_wk33
left join DataPrime.ECom_InactiveCL33Wk nm33 on n_wk33.DataInfo = nm33.DataInfo
    and n_wk33.Status = nm33.Status
    and n_wk33.Class33_Code = nm33.Class33_Code
group by 1, 2, 3, Qlt_Inactive33;

create local temp table activecards -- просмотренных карточек
on commit preserve rows as
select
    DataInfo,
    Class33_Code,
    Status,
    count(distinct RgdCode) as ActiveCards
from n_wk33
group by 1, 2, 3;

-- промежуточная таблица, где будет нужный срез и меры, которые будут наполняться апдейтами ниже
create local temp table main
on commit preserve rows as
select
    DataInfo,
    Class33_Code,
    Status,
    cast(0 as float) as ActiveCards,
    cast(0 as float) as TotalCards
from n_wk33
group by 1, 2, 3;

update main m
set ActiveCards = ac.ActiveCards
from activecards ac
where m.DataInfo = ac.DataInfo
    and m.Class33_Code = ac.Class33_Code
    and m.Status = ac.Status;
commit;

update main m
set TotalCards = tc.TotalCards
from totalcards tc
where m.DataInfo = tc.DataInfo
    and m.Class33_Code = tc.Class33_Code
    and m.Status = tc.Status;
commit;

-- удаляются данные старше анализируемого периода
delete from DataMart.DshECom_NomenclatureAnlsWkCL33
where DataInfo < add_months(trunc(current_date, 'year')::date, - 12);
commit;

-- удалить из витрины данные большие или равные минимальной дате во временной таблице
delete from DataMart.DshECom_NomenclatureAnlsWkCL33
where DataInfo >= (select min(DataInfo) from main);
commit;

select purge_table('DataMart.DshECom_NomenclatureAnlsWkCL33');

-- вставка в витрину с расшивкой 33 на уровни
insert into DataMart.DshECom_NomenclatureAnlsWkCL33
select
    DataInfo,
    left(Class33_Code, 2) as Class33_Code_2,
    left(Class33_Code, 3) as Class33_Code_3,
    Class33_Code as Class33_Code_4,
    Status,
    ActiveCards,
    TotalCards
from main;
commit;

select analyze_statistics('DataMart.DshECom_NomenclatureAnlsWkCL33');
