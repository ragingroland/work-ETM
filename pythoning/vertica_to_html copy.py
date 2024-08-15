import vertica_python
import html

conn_info = {'host': '172.24.2.140',
             'port': 5433,
             'user': 'user_finebi_jdbc',
             'password': 'userfinebijdbcvert92',
             'database': 'DWH',
             'autocommit': False,
             'connection_load_balance': True}
conn = vertica_python.connect(**conn_info)
cur = conn.cursor()

# cur.execute("""
#             select
#                 at.table_name
#             from v_catalog.all_tables at
#             where schema_name != 'v_%';
#             """)
# vtables = [row[0] for row in cur.fetchall()]

cur.execute(f"""
            select
            	at.schema_name || '.' || at.table_name as table_name,
                '' as remarks,
                '' as column_name,
                '' as data_type,
                '' as comment,
                '' as tag
            from v_catalog.all_tables at
            left join v_catalog.columns cl on at.table_name = cl.table_name
            left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                and cl.table_name = cm.object_name
                and upper(cl.column_name) = upper(cm.child_object)
            left join DataPrime.DWHCatalog dc on at.table_name = dc.table_name
            where at.table_name = 'Class14'
                and at.schema_name != 'v_%'
                and dc.tag = 'refr'
            union
            select
                at.remarks,
                '' as table_name,
                '' as column_name,
                '' as data_type,
                '' as comment,
                '' as tag
            from v_catalog.all_tables at
            left join v_catalog.columns cl on at.table_name = cl.table_name
            left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                and cl.table_name = cm.object_name
                and upper(cl.column_name) = upper(cm.child_object)
            left join DataPrime.DWHCatalog dc on at.table_name = dc.table_name
            where at.table_name = 'Class14'
                and at.schema_name != 'v_%'
                and dc.tag = 'refr'
            union
            select
                '' as table_name,
                cl.column_name,
                cl.data_type,
                cm.comment,
                '' as remarks,
                '' as tag
            from v_catalog.all_tables at
            left join v_catalog.columns cl on at.table_name = cl.table_name
            left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                and cl.table_name = cm.object_name
                and upper(cl.column_name) = upper(cm.child_object)
            left join DataPrime.DWHCatalog dc on at.table_name = dc.table_name
            where at.table_name = 'Class14'
                and at.schema_name != 'v_%'
                and dc.tag = 'refr'
            order by 3;""")
data = cur.fetchall()
print(data)
description = data[1][0]
print(description)

conn.close()
