import vertica_python
import csv

conn_info = {'host': '172.24.2.140',
             'port': 5433,
             'user': 'user_finebi_jdbc',
             'password': 'userfinebijdbcvert92',
             'database': 'DWH',
             'autocommit': True,
             'connection_load_balance': True}
             
# with vertica_python.connect(**conn_info) as conn:
#     cur = conn.cursor()
#     tables = cur.execute('''
#         select 
#             schema_name,
#             table_name,
#             remarks
#         from v_catalog.all_tables
#         where schema_name not like 'v_%';
#         ''')
#     with open('tables_metadata.csv', 'w', newline='', encoding = 'utf-8') as csvfile:
#         writer = csv.writer(csvfile)
#         writer.writerow(['schema_name', 'table_name', 'remarks'])
#         writer.writerows(cur.fetchall())

# with vertica_python.connect(**conn_info) as conn:
#     cur = conn.cursor()
#     cur.execute('''
#         SELECT export_objects('', 'public');
#         ''')

#     with open('table_ddls.csv', 'w', newline = '') as f:
#         for row in cur.fetchall():
#             f.write(row[0] + '\n') 