from tkinter import Tk, Button, scrolledtext, INSERT, END
from tkinter.ttk import Combobox
import vertica_python

conn_info = {'host': '172.24.2.140',
             'port': 5433,
             'user': 'user_finebi_jdbc',
             'password': 'userfinebijdbcvert92',
             'database': 'DWH',
             'autocommit': True,
             'connection_load_balance': True}
conn = vertica_python.connect(**conn_info)

def get_ddl():
    cur = conn.cursor()
    target = combo_schema.get() + '.' + combo_table.get()
    cur.execute(f"select export_objects('', '{target}');")
    result = cur.fetchall()
    text_field.delete('1.0', END)
    for row in result:
        text_field.insert(INSERT, row[0])

def get_comms():
    cur = conn.cursor()
    cur.execute(f"""select distinct
                        '' as schema_name,
                        '' as table_name,
                        at.remarks,
                        '' as column_name,
                        '' as data_type,
                        '' as comment
                    from v_catalog.all_tables at
                    left join v_catalog.columns cl on at.table_name = cl.table_name
                    left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                        and cl.table_name = cm.object_name
                        and upper(cl.column_name) = upper(cm.child_object)
                    where at.schema_name = '{combo_schema.get()}' and at.table_name = '{combo_table.get()}'
                    union
                    select
                        at.schema_name,
                        at.table_name,
                        '' as remarks,
                        cl.column_name,
                        cl.data_type,
                        cm.comment
                    from v_catalog.all_tables at
                    left join v_catalog.columns cl on at.table_name = cl.table_name
                    left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                        and cl.table_name = cm.object_name
                        and upper(cl.column_name) = upper(cm.child_object)
                    where at.schema_name = '{combo_schema.get()}' and at.table_name = '{combo_table.get()}'
                    order by 2;""")
    result = cur.fetchall()
    text_field2.delete('1.0', END)
    for row in result:
        for i in range(len(row)):
            text_field2.insert(INSERT, row[i] if row[i] else '')
            if i < len(row) - 1:
                text_field2.insert(INSERT, ' ')
        text_field2.insert(INSERT, '\n') 

def get_schema():
    cur = conn.cursor()
    cur.execute(f"select distinct table_schema from tables where table_schema != 'v_%'")
    return [row[0] for row in cur.fetchall()]

def get_tables():
    cur = conn.cursor()
    cur.execute(f"select table_name from tables where table_schema = '{combo_schema.get()}'")
    table_names = [row[0] for row in cur.fetchall()]
    combo_table['values'] = table_names  # Обновляем список в combo_table
    combo_table.current(0) 

# основное окно
window = Tk()
window.title("ЭТМ-IT: Описание таблиц Vertica.")
window.geometry('680x720')
window.resizable(False, False)
btn = Button(window, 
            text=" Получить информацию о таблице ",
            bg="white",
            fg="green",
            command = lambda: [get_ddl(), get_comms()]
            )
btn.grid(column=0, row=3)
# выпадающий список
combo_schema = Combobox(window, state = 'readonly')
schema_names = get_schema()
combo_schema['values'] = schema_names
combo_schema.grid(column=0, row=0)
combo_table = Combobox(window, state = 'readonly')
combo_table.grid(column=0, row=1)
combo_schema.bind("<<ComboboxSelected>>", lambda event: get_tables())
text_field = scrolledtext.ScrolledText(window, width=80,height=20)
text_field.grid(column=0, row=4)
text_field.configure(state = 'disabled')
text_field.config(state = 'normal')
text_field2 = scrolledtext.ScrolledText(window, width=80,height=20)
text_field2.grid(column=0, row=5)
text_field2.configure(state = 'disabled')
text_field2.config(state = 'normal')

if __name__ == '__main__':
    window.mainloop()
    conn.close()