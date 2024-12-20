merge into DataPrime.DWHCatalog as target -- тут мерджатся факты и справочники
using (
    select distinct
        projection_schema as table_schema,
        anchor_table_name as table_name,
        projection_schema || '.' || anchor_table_name as objname,
        case
            when segment_expression like 'hash%'
                then 'fact'
            when segment_expression is null
                then 'refr'
        end as tag
    from v_catalog.projections) as temp
on temp.objname = target.objname
when matched then update set
    table_schema = temp.table_schema,
    table_name = temp.table_name,
    objname = temp.objname,
    tag = temp.tag
when not matched then insert values (
    temp.table_schema,
    temp.table_name,
    temp.objname,
    temp.tag);

merge into DataPrime.DWHCatalog as target -- тут мерджатся вьюхи
using (
    select distinct
        table_schema,
        table_name,
        table_schema || '.' || table_name as objname,
        'view' as tag
    from v_catalog.views
    where table_schema != 'public') as temp
on temp.objname = target.objname
when matched then update set
    table_schema = temp.table_schema,
    table_name = temp.table_name,
    objname = temp.objname,
    tag = temp.tag
when not matched then insert values (
    temp.table_schema,
    temp.table_name,
    temp.objname,
    temp.tag);

delete from DataPrime.DWHCatalog
where objname not in (
	select distinct projection_schema || '.' || anchor_table_name as objname
	from v_catalog.projections) and tag in ('fact', 'refr');

delete from DataPrime.DWHCatalog
where objname not in (
    select distinct table_schema || '.' || table_name as objname
    from v_catalog.views
    where table_schema != 'public') and tag = 'view';

commit; -- тут коммит