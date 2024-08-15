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

cur.execute("""
            select
                at.table_name
            from v_catalog.all_tables at
            where schema_name != 'v_%';
            """)
vtables = [row[0] for row in cur.fetchall()]

cur.execute("""
            select distinct
                tag
            from DataPrime.DWHCatalog;
            """)
tags = [row[0] for row in cur.fetchall()]

def tables_write(table, tag):
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
                where at.table_name = '{table}'
                    and at.schema_name != 'v_%'
                    and dc.tag = '{tag}'
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
                where at.table_name = '{table}'
                    and at.schema_name != 'v_%'
                    and dc.tag = '{tag}'
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
                where at.table_name = '{table}'
                    and at.schema_name != 'v_%'
                    and dc.tag = '{tag}'
                order by 3;""")
    data = cur.fetchall()
    print(data)
    description = data[0][0]
    print(description)
    html_code = f"""
    <!DOCTYPE html>
    <html>
    <head>
    <title>Данные из базы данных</title>
    <style>
      table {{
        border-collapse: collapse;
        width: 100%;
      }}

      th, td {{
        border: 1px solid black;
        padding: 8px;
        text-align: left;
      }}

      th {{
        background-color: #f0f0f0;
      }}
    </style>
    </head>
    <body>
      <h2>Таблица: {table}</h2>
      <h3>Описание:</h3>
      <p style="font-size: 24px; font-weight: bold;">{description}</p>
      <h3>Поля:</h3>
      <table>
        <thead>
          <tr>
            <th>Column Name</th>
            <th>Data Type</th>
            <th>Comment</th>
            <th>Table Type</th>
          </tr>
        </thead>
        <tbody>
    """

    # Формируем строки таблицы
    for row in data[1:]:
        html_code += f"""
          <tr>
            <td>{html.escape(str(row[1]))}</td>
            <td>{html.escape(str(row[2]))}</td>
            <td>{html.escape(str(row[3]))}</td>
            <td>{html.escape(str(row[4]))}</td>
          </tr>
        """

    html_code += """
                </tbody>
                </table>
                </body>
                </html>
                """
    file.write(html_code)

with open('data.html', 'a', encoding='utf-8') as file:
    for tag in tags:
        for vtable in vtables:
            tables_write(vtable, tag)

conn.close()
