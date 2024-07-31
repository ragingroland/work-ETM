from tkinter import Tk, Button, scrolledtext, INSERT, END, messagebox, Entry, X, Y, RIGHT, Listbox, BOTH, BOTTOM
from tkinter.ttk import Combobox, Treeview, Scrollbar
import vertica_python
# подключение к вертике
conn_info = {'host': '172.24.2.140',
             'port': 5433,
             'user': 'user_finebi_jdbc',
             'password': 'userfinebijdbcvert92',
             'database': 'DWH',
             'autocommit': False,
             'connection_load_balance': True}
conn = vertica_python.connect(**conn_info)
cur = conn.cursor()

def get_ddl(): # функция, которая забирает DDL
    ddls = combo_schema.get() + '.' + combo_table.get()
    try:
        cur.execute(f"select export_objects('', '{ddls}');")
    except Exception:
        messagebox.showwarning('Ошибка', 'Сначала выберите схему и таблицу.')
    finally:
        result = cur.fetchall()
        text_field.delete('1.0', END)
        for row in result:
            text_field.insert(INSERT, row[0])

def get_table_desc(): # функция, которая забирает описание таблицы
    table = combo_table.get()
    cur.execute(f"""select
                        remarks
                    from v_catalog.all_tables
                    where table_name = '{table}';
                    """)
    result = cur.fetchall()
    text_field2.delete('1.0', END)
    for row in result:
        text_field2.insert(INSERT, row[0])

def get_comms(): # функция, которая забирает информацию о таблицах и их столбцах
    try:
        cur.execute(f"""select
                            at.schema_name || '.' || at.table_name as table_name,
                            cl.column_name,
                            cl.data_type,
                            cm.comment
                        from v_catalog.all_tables at
                        left join v_catalog.columns cl on at.table_name = cl.table_name
                        left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                            and cl.table_name = cm.object_name
                            and upper(cl.column_name) = upper(cm.child_object)
                        where at.schema_name = '{combo_schema.get()}' and at.table_name = '{combo_table.get()}';
                        """)
    except Exception:
        messagebox.showwarning('Ошибка', 'Не получилось забрать комментарии.')
    finally:
        result = cur.fetchall()
        tree.delete(*tree.get_children())
        for row in result:
            tree.insert('', 'end', values=row)

def get_schema(): # хватаем список схем
    try:
        cur.execute("""
                    select distinct
                        table_schema
                    from tables
                    where table_schema != 'v_%'
                    """)
        return [row[0] for row in cur.fetchall()]
    except Exception:
        messagebox.showwarning('Ошибка', 'Что-то не так, невозможно получить схемы.')

def get_tables(): # на основании схем хватаем список таблиц схемы
    schema = combo_schema.get()
    try:
        cur.execute(f"""
                    select
                        table_name
                    from tables
                    where table_schema = '{schema}'
                    order by 1;
                    """)
        table_names = [row[0] for row in cur.fetchall()]
        combo_table['values'] = table_names  # обновляем список в combo_table при выборе схемы
    except Exception:
        messagebox.showwarning('Ошибка', 'Вы не выбрали схему?')
    finally:
        combo_table.current(0)

def tblname_search(): # поиск таблицы
    search = search_entry.get()
    tree.delete(*tree.get_children())
    text_field.delete('1.0', END)
    text_field2.delete('1.0', END)
    try:
        cur.execute(f"""
                    select
                        at.schema_name || '.' || at.table_name as table_name,
                        at.remarks
                    from v_catalog.all_tables at
                    where (lower(at.table_name) like (lower('%{search}%'))) 
                        and (schema_name not like ('v_%'));
                    """)
    except Exception:
        messagebox.showwarning('Ошибка', 'Не получилось найти такую таблицу.')
    finally:
        result = cur.fetchall()
        tree.delete(*tree.get_children())
        for row in result:
            tree.insert('', 'end', values=row)

def tblname_search_ddl(): # функция, которая забирает DDL при поиске по названию таблицы
    try:
        search = search_entry.get()
        cur.execute(f"""
                    select
                        table_schema || '.' || table_name as table_name
                    from tables
                    where lower(table_name) = lower('{search}');
                    """)
    except Exception:
        messagebox.showwarning('Ошибка', 'Не нашелся DDL таблицы.')
    finally:
        ddls = [row[0] for row in cur.fetchall()]
        if ddls != []:
            cur.execute(f"select export_objects('', '{ddls[0]}');")
            result = cur.fetchall()
            text_field.delete('1.0', END)
            for row in result:
                text_field.insert(INSERT, row[0])
        else:
            pass

def tblname_search_table_desc(): # функция, которая забирает описание таблицы по результатам поиска таблицы
    search = search_entry.get()
    cur.execute(f"""
                select
                    remarks
                from v_catalog.all_tables
                where lower(table_name) = lower('{search}');
                """)
    result = cur.fetchall()
    text_field2.delete('1.0', END)
    for row in result:
        text_field2.insert(INSERT, row[0])

def comment_search(): # поиск по комментариям
    search = search_entry.get()
    try:
        cur.execute(f"""
                    select
                    	at.schema_name || '.' || at.table_name as table_name,
                        cl.column_name,
                        cl.data_type,
                        cm.comment
                    from v_catalog.all_tables at
                    left join v_catalog.columns cl on at.table_name = cl.table_name
                    left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                        and cl.table_name = cm.object_name
                        and upper(cl.column_name) = upper(cm.child_object)
                    where lower(cm.comment) like lower('{search}%');
                    """)
    except Exception:
        messagebox.showwarning('Ошибка', 'Не получилось найти такой комментарий.')
    finally:
        result = cur.fetchall()
        tree.delete(*tree.get_children())
        for row in result:
            tree.insert('', 'end', values=row)

def remarks_search(): # поиск по описанию таблицы
    search = search_entry.get()
    try:
        cur.execute(f"""
                    select
                    	at.schema_name || '.' || at.table_name as table_name,
                        at.remarks
                    from v_catalog.all_tables at
                    where lower(at.remarks) like lower('{search}%');
                    """)
    except Exception:
        messagebox.showwarning('Ошибка', 'Не получилось найти такую таблицу.')
    finally:
        result = cur.fetchall()
        tree.delete(*tree.get_children())
        for row in result:
            tree.insert('', 'end', values=row)

def tree2click(event): # двойной клик для поиска таблицы в виджете Treeview
    try:
        item = tree.selection()[0]
        fullname = tree.item(item, 'values')[0]
        schema_name, table_name = fullname.split('.')
        ddls = fullname
        cur.execute(f"""select
                            at.schema_name || '.' || at.table_name as table_name,
                            cl.column_name,
                            cl.data_type,
                            cm.comment
                        from v_catalog.all_tables at
                        left join v_catalog.columns cl on at.table_name = cl.table_name
                        left join v_catalog.comments cm on cl.table_schema = cm.object_schema
                            and cl.table_name = cm.object_name
                            and upper(cl.column_name) = upper(cm.child_object)
                        where at.schema_name = '{schema_name}' and at.table_name = '{table_name}';
                        """)
        result = cur.fetchall()
        cur.execute(f"select export_objects('', '{ddls}');")
        result2 = cur.fetchall()
        cur.execute(f"""select
                        remarks
                    from v_catalog.all_tables
                    where table_name = '{table_name}';
                    """)
        result3 = cur.fetchall()
    except Exception:
        messagebox.showwarning('Ошибка', 'Не удалось получить информацию')
    finally:
        tree.delete(*tree.get_children())
        for row in result:
            tree.insert('', 'end', values=row)
        text_field.delete('1.0', END)
        for row in result2:
            text_field.insert(INSERT, row[0])
        text_field2.delete('1.0', END)
        for row in result3:
            text_field2.insert(INSERT, row[0])

# основное окно
window = Tk()
window.title('ЭТМ-IT: Описание таблиц Vertica.')
window.resizable(False, False)
window.update()
window.geometry(
                "+{}+{}".format(
                    (window.winfo_screenwidth() - window.winfo_width()) // 2,
                    (window.winfo_screenheight() - window.winfo_height()) // 2))
window.grid_rowconfigure(0, weight = 1)
window.grid_columnconfigure(0, weight = 1)

# листбокс для основного окна
listbox = Listbox(window)
listbox.pack(expand = True, fill = BOTH)
# все виджеты размещаются в листбоксе

# выпадающие списки для схем и таблиц
combo_schema = Combobox(listbox, state = 'readonly', width = 50, justify = 'center')
schema_names = get_schema()
combo_schema['values'] = schema_names
combo_schema.set('Схема')
combo_schema.pack(pady = 5)
combo_table = Combobox(listbox, state = 'readonly', width = 50, justify = 'center')
combo_table.set('Таблица')
combo_table.pack(pady = 5)
target_ddl = combo_schema.get() + '.' + combo_table.get()
target_table = combo_table.get()
target_schema = combo_schema.get()
combo_schema.bind('<<ComboboxSelected>>', lambda event: get_tables())

# волшебная кнопка для поиска информации по таблицам
btn = Button(listbox,
            text = ' Получить информацию о таблице ',
            bg = 'yellow',
            fg = 'black',
            command = lambda: [get_ddl(), get_comms(), get_table_desc()]
            )
btn.pack(pady = 5)

# отображение таблицы

tree = Treeview(listbox,
                columns = ('Table', 'Column', 'Data Type', 'Comment'),
                show = 'headings',
                height = 13,
                selectmode = 'browse')
tree.heading('Table', text = '')
tree.heading('Column', text = '')
tree.heading('Data Type', text = '')
tree.heading('Comment', text = '', )
tree.bind("<Double-1>", tree2click)
tree.pack(pady = 5, expand=True, fill="both")

# поиск
search_entry = Entry(listbox)
search_entry.insert(0, 'Поле для поиска...')
search_entry.place(x = 660, y = 5)
search_entry.config(width = 50, justify = 'center')
search_entry.bind('<FocusIn>', lambda event: search_entry.delete(0, END))  # удаляем подсказку при фокусе
search_entry.bind('<FocusOut>', lambda event: search_entry.insert(0, 'Поле для поиска...' if not search_entry.get() else None))  # возвращаем подсказку, если поле пустое
search_field = search_entry.get()

# волшебная кнопка для поиска в базе по столбцам
btn_srch_tbl = Button(window,
            text = ' Поиск таблицы ',
            bg = 'green',
            fg = 'white',
            command = tblname_search
            # command = lambda: [tblname_search(), tblname_search_ddl(), tblname_search_table_desc()]
            )
btn_srch_tbl.place(x = 662, y = 30)
btn_srch_cmt = Button(window,
            text = ' Поиск комментария ',
            bg = 'green',
            fg = 'white',
            command = comment_search
            )
btn_srch_cmt.place(x = 770, y = 30)
btn_srch_remrks = Button(window,
            text = ' Поиск по описанию таблицы ',
            bg = 'green',
            fg = 'white',
            command = remarks_search
            )
btn_srch_remrks.place(x = 662, y = 60)

# текстовое поле с DDL
text_field = scrolledtext.ScrolledText(listbox, width = 120,height = 25)
text_field.pack(pady = 5)
text_field.configure(state = 'disabled')
text_field.config(state = 'normal')
# текстовое поле с комментарием к таблице
text_field2 = scrolledtext.ScrolledText(listbox, width = 36, height = 5)
text_field2.place(x = 1, y = 1)
text_field2.configure(state = 'disabled')
text_field2.config(state = 'normal')

window.focus_set()
if __name__ == '__main__':
    try:
        window.mainloop()
    except Exception:
        print(Exception)
    finally:
        conn.close()