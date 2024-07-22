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
            at.schema_name as schema,
            at.table_name as table,
            at.schema_name || '.' || at.table_name as fullname,
            '' as table_type
        from v_catalog.all_tables at
        where at.schema_name not like 'v_%';
        ''')
    with open('tables_metadata_types.csv', 'w', newline='', encoding = 'utf-8') as tables:
        writer = csv.writer(tables)
        writer.writerow(['schema', 'table', 'fullname', 'comment'])
        writer.writerows(cur.fetchall())