import vertica_python
import csv

conn_info = {'host': '172.24.2.140',
             'port': 5433,
             'user': 'user_finebi_jdbc',
             'password': 'userfinebijdbcvert92',
             'database': 'DWH',
             'autocommit': True,
             'connection_load_balance': True}
             
with vertica_python.connect(**conn_info) as conn:
    cur = conn.cursor()
    tables = cur.execute('''
        select
            at.schema_name,
            at.table_name,
            at.remarks,
            cl.column_name,
            cl.data_type,
            cm.comment
        from v_catalog.all_tables at
        left join v_catalog.columns cl on at.table_name = cl.table_name
        left join v_catalog.comments cm on cl.table_schema = cm.object_schema
            and cl.table_name = cm.object_name
            and upper(cl.column_name) = upper(cm.child_object)
        where at.schema_name not like 'v_%';
        ''')
    with open('tables_metadata.csv', 'w', newline='', encoding = 'utf-8') as tables:
        writer = csv.writer(tables)
        writer.writerow(['schema_name', 'table_name', 'remarks', 'column_name', 'data_type', 'comment'])
        writer.writerows(cur.fetchall())
    tables_ddls = cur.execute('''
        select export_objects('', 'DWH');
        ''')
    with open('tables_ddls.csv', 'w', newline = '', encoding = 'utf-8') as tables:
        writer = csv.writer(tables)
        writer.writerow(['ddl'])
        writer.writerows(cur.fetchall())
    # public_ddls = cur.execute('''
    #     select export_objects('', 'public');
    #     ''')
    # with open('public_ddls.csv', 'w', newline = '', encoding = 'utf-8') as public:
    #     writer = csv.writer(public)
    #     writer.writerow(['ddl'])
    #     writer.writerows(cur.fetchall())
    # dm_ddls = cur.execute('''
    #     select export_objects('', 'DataMart');
    #     ''')
    # with open('dm_ddls.csv', 'w', newline = '', encoding = 'utf-8') as dm:
    #     writer = csv.writer(dm)
    #     writer.writerow(['ddl'])
    #     writer.writerows(cur.fetchall())
    # dp_ddls = cur.execute('''
    #     select export_objects('', 'DataPrime');
    #     ''')
    # with open('dp_ddls.csv', 'w', newline = '', encoding = 'utf-8') as dp:
    #     writer = csv.writer(dp)
    #     writer.writerow(['ddl'])
    #     writer.writerows(cur.fetchall())