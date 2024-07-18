from tkinter import Tk, Button, scrolledtext, INSERT, END, Canvas, Frame
from tkinter.ttk import Combobox, Treeview, Scrollbar
import vertica_python

conn_info = {'host': '172.24.2.140',
             'port': 5433,
             'user': 'user_finebi_jdbc',
             'password': 'userfinebijdbcvert92',
             'database': 'DWH',
             'autocommit': True,
             'connection_load_balance': True}
conn = vertica_python.connect(**conn_info)

def get_ddl(): # функция, которая забирает DDL
    cur = conn.cursor()
    target = combo_schema.get() + '.' + combo_table.get()
    cur.execute(f"select export_objects('', '{target}');")
    result = cur.fetchall()
    text_field.delete('1.0', END)
    for row in result:
        text_field.insert(INSERT, row[0])

def get_comms(): # функция, которая забирает информацию и таблицах и их столбцах
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
    tree.delete(*tree.get_children())
    for row in result:
        tree.insert('', 'end', values=row)

def get_schema(): # хватаем список схем
    cur = conn.cursor()
    cur.execute(f"select distinct table_schema from tables where table_schema != 'v_%'")
    return [row[0] for row in cur.fetchall()]

def get_tables(): # на основании схем хватаем список таблиц схемы
    cur = conn.cursor()
    cur.execute(f"select table_name from tables where table_schema = '{combo_schema.get()}'")
    table_names = [row[0] for row in cur.fetchall()]
    combo_table['values'] = table_names  # обновляем список в combo_table при выборе схемы
    combo_table.current(0) 

# основное окно
window = Tk()
window.title("ЭТМ-IT: Описание таблиц Vertica.")
window.geometry('1024x768')
window.grid_rowconfigure(0, weight = 1)
window.grid_columnconfigure(0, weight = 1)
window.resizable(True, True)
# канвас для основного окна
content_canvas = Canvas(window)
content_canvas.grid(row=0, column=0, sticky="nsew")
scrollbar_y = Scrollbar(window, orient="vertical", command=content_canvas.yview)
scrollbar_y.grid(row=0, column=1, sticky="ns")
content_canvas.config(yscrollcommand=scrollbar_y.set)
# канвас помещается в фрейм
content_frame = Frame(content_canvas)
content_frame.grid(row = 0, column = 0, sticky = 'nsew')
# выпадающие списки для схем и таблиц
# все виджеты размещаются в фрейме
combo_schema = Combobox(content_frame, state = 'readonly')
schema_names = get_schema()
combo_schema['values'] = schema_names
combo_schema.pack(pady = 5)
combo_table = Combobox(content_frame, state = 'readonly')
combo_table.pack(pady = 5)
combo_schema.bind("<<ComboboxSelected>>", lambda event: get_tables())
# волшебная кнопка
btn = Button(content_frame, 
            text = " Получить информацию о таблице ",
            bg = "white",
            fg = "green",
            command = lambda: [get_ddl(), get_comms()]
            )
btn.pack(pady = 5)
# отображение таблицы
tree = Treeview(content_frame, 
                columns = ("Schema", "Table", "Remarks", "Column", "Data Type", "Comment"), 
                show = "headings",
                height = 15)
tree.heading("Schema", text = "Схема")
tree.heading("Table", text = "Таблица")
tree.heading("Remarks", text = "Опис.таблицы")
tree.heading("Column", text = "Столбец")
tree.heading("Data Type", text = "Тип данных")
tree.heading("Comment", text = "Опис.столбца")
tree.pack(pady = 5)
# сделать горизонтальный скролл для дерево смотреть
# текстовое поле с DDL
text_field = scrolledtext.ScrolledText(content_frame, width = 120,height = 30)
text_field.pack(pady = 5)
text_field.configure(state = 'disabled')
text_field.config(state = 'normal')
text_field2 = scrolledtext.ScrolledText(content_frame, width = 120,height = 30)
text_field2.pack(pady = 5)
text_field2.configure(state = 'disabled')
text_field2.config(state = 'normal')

content_window = content_canvas.create_window(0, 0, anchor="nw", window=content_frame)
content_canvas.bind("<Configure>", 
    lambda event: content_canvas.configure(scrollregion=content_canvas.bbox("all")))

if __name__ == '__main__':
    window.mainloop()
    conn.close()