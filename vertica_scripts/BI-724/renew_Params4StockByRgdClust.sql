create local temp table tmp_local (
    Class_Type int,
    Class_Code varchar(20),
    MnfCode int,
    K_1 float,
    K_2 float,
    K_3 float,
    K_4 float,
    Price_Type int,
    Clust_Code varchar(20))
on commit preserve rows;

copy tmp_local (
    Class_Type,
    Class_Code,
    MnfCode,
    K_1,
    K_2,
    K_3,
    K_4,
    Price_Type,
    Clust_Code)
from local 'path\KTZ.csv'
    delimiter '|'
    null ''
    enclosed by '"'
rejected data 'path\KTZ.rej'
exceptions 'path\KTZ.exc' direct;

create local temp table tmp_local2
on commit preserve rows as
with recursive
splits as (
    select
        Class_Type,
        Class_Code,
        MnfCode,
        K_1,
        K_2,
        K_3,
        K_4,
        Price_Type,
        trim(substring(Clust_Code, 1,
            case
	            when position(',' in Clust_Code) > 0
                	then position(',' in Clust_Code) - 1
            	else length(Clust_Code)
            end)) as Clust_Code,
    	case
        	when position(',' in Clust_Code) > 0
        		then trim(substring(Clust_Code, position(',' in Clust_Code) + 1))
    		else null
    	end as ostatok
    from tmp_local
    union all
    select
        Class_Type,
        Class_Code,
        MnfCode,
        K_1,
        K_2,
        K_3,
        K_4,
        Price_Type,
        trim(substring(ostatok, 1,
            case
	            when position(',' in ostatok) > 0
                	then position(',' in ostatok) - 1
                else length(ostatok)
            end)) as Clust_Code,
    	case
        	when position(',' in ostatok) > 0
        		then trim(substring(ostatok, position(',' in ostatok) + 1))
        	else null
        end
    from splits
    where ostatok is not null)
select
    Class_Type,
    Class_Code,
    MnfCode,
    K_1,
    K_2,
    K_3,
    K_4,
    Price_Type,
    Clust_Code
from splits
where Clust_Code is not null;

truncate table DataPrime.Params4StockByRgdClust;
insert into DataPrime.Params4StockByRgdClust
select
    Class_Type,
    trim(upper(Class_Code)) as Class_Code,
    MnfCode,
    K_1,
    K_2,
    K_3,
    K_4,
    Price_Type,
    Clust_Code::int
from tmp_local2;
commit;
