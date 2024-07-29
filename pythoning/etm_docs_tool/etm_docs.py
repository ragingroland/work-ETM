from tkinter import Tk, Button, scrolledtext, INSERT, END, Canvas, Frame, messagebox, Entry, X, Y, Listbox, RIGHT, BOTH
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
cur = conn.cursor()

def get_ddl(): # функция, которая забирает DDL
    try:
        target = combo_schema.get() + '.' + combo_table.get()
        cur.execute(f"select export_objects('', '{target}');")
    except Exception:
        messagebox.showwarning('Ошибка', 'Сначала выберите схему и таблицу.')
    finally:
        result = cur.fetchall()
        text_field.delete('1.0', END)
        for row in result:
            text_field.insert(INSERT, row[0])

def get_table_desc(): # функция, которая забирает описание таблицы
    target = combo_table.get()
    cur.execute(f"""select
                        remarks
                    from v_catalog.all_tables
                    where table_name = '{target}';""")
    result = cur.fetchall()
    text_field2.delete('1.0', END)
    for row in result:
        text_field2.insert(INSERT, row[0])

def get_comms(): # функция, которая забирает информацию и таблицах и их столбцах
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
                        where at.schema_name = '{combo_schema.get()}' and at.table_name = '{combo_table.get()}';""")
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
                    where table_schema != 'v_%'""")
    except Exception:
        messagebox.showwarning('Ошибка', 'Что-то не так, невозможно получить схемы.')
    finally:
        return [row[0] for row in cur.fetchall()]

def get_tables(): # на основании схем хватаем список таблиц схемы
    try:
        cur.execute(f"select table_name from tables where table_schema = '{combo_schema.get()}' order by 1")
        table_names = [row[0] for row in cur.fetchall()]
        combo_table['values'] = table_names  # обновляем список в combo_table при выборе схемы
    except Exception:
        messagebox.showwarning('Ошибка', 'Вы не выбрали схему?')
    finally:
        combo_table.current(0)

def tblname_search(): # поиск столбцов в других местах
    try:
        cur.execute(f"""
                    select
                        at.schema_name || '.' || at.table_name as table_name,
                        cm.comment
                    from v_catalog.all_tables at
                    left join v_catalog.comments cm on at.schema_name = cm.object_schema
                        and at.table_name = cm.object_name
                    where lower(at.table_name) like (lower('{search_entry.get()}%'));""")
    except Exception:
        messagebox.showwarning('Ошибка', 'Не получилось найти такую таблицу.')
    finally:
        result = cur.fetchall()
        tree.delete(*tree.get_children())
        for row in result:
            tree.insert('', 'end', values=row)

def tblname_search_ddl(): # функция, которая забирает DDL при поиске по названию таблицы
    try:
        cur = conn.cursor()
        cur.execute(f"""
                    select
                        table_schema || '.' || table_name as table_name
                    from tables
                    where lower(table_name) = lower('{search_entry.get()}');
                    """)
        target = [row[0] for row in cur.fetchall()]
    except Exception:
        messagebox.showwarning('Ошибка', 'Не нашелся DDL таблицы.')
    finally:
        cur.execute(f"select export_objects('', '{target[0]}');")
        result = cur.fetchall()
        text_field.delete('1.0', END)
        for row in result:
            text_field.insert(INSERT, row[0])

def tblname_search_table_desc(): # функция, которая забирает описание таблицы по результатам поиска таблицы
    target = search_entry.get()
    cur.execute(f"""
                select
                    remarks
                from v_catalog.all_tables
                where lower(table_name) = lower('{target}');""")
    result = cur.fetchall()
    text_field2.delete('1.0', END)
    for row in result:
        text_field2.insert(INSERT, row[0])

def comment_search(): # поиск по комментариям
    try:
        target = search_entry.get()
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
                    where lower(cm.comment) like '{target}%';
                    """)
    except Exception:
        messagebox.showwarning('Ошибка', 'Не получилось найти такой комментарий.')
    finally:
        result = cur.fetchall()
        tree.delete(*tree.get_children())
        for row in result:
            tree.insert('', 'end', values=row)

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
# выпадающие списки для схем и таблиц
# все виджеты размещаются в фрейме
combo_schema = Combobox(listbox, state = 'readonly', width = 50, justify = 'center')
schema_names = get_schema()
combo_schema['values'] = schema_names
combo_schema.set('Схема')
combo_schema.pack(pady = 5)
combo_table = Combobox(listbox, state = 'readonly', width = 50, justify = 'center')
combo_table.set('Таблица')
combo_table.pack(pady = 5)
combo_schema.bind('<<ComboboxSelected>>', lambda event: get_tables())
# волшебная кнопка для поиска информации по таблицам
btn = Button(listbox,
            text = ' Получить информацию о таблице ',
            bg = 'white',
            fg = 'green',
            command = lambda: [get_ddl(), get_comms(), get_table_desc()]
            )
btn.pack(pady = 5)
# отображение таблицы
tree = Treeview(listbox,
                columns = ('Table', 'Column', 'Data Type', 'Comment'),
                show = 'headings',
                height = 13)
tree.heading('Table', text = 'Таблица')
tree.heading('Column', text = 'Столбец')
tree.heading('Data Type', text = 'Тип данных')
tree.heading('Comment', text = 'Опис.столбца', )
tree.pack(pady = 5)

# горизонтальный скролл для дерева???

# отцентрировать содержимое???

# поиск
search_entry = Entry(listbox)
search_entry.insert(0, ' Поле для поиска... ')
search_entry.place(x = 660, y = 5)
search_entry.config(width = 50, justify = 'center')
search_entry.bind('<FocusIn>', lambda event: search_entry.delete(0, END))  # удаляем подсказку при фокусе
search_entry.bind('<FocusOut>', lambda event: search_entry.insert(0, ' Столбец для поиска ') if not search_entry.get() else None)  # возвращаем подсказку, если поле пустое
# search_entry.bind('<KeyRelease>', tblname_search)
# волшебная кнопка для поиска в базе по столбцам
btn_srch_tbl = Button(window,
            text = ' Поиск таблицы ',
            bg = 'white',
            fg = 'green',
            command = lambda: [tblname_search(), tblname_search_ddl(), tblname_search_table_desc()]
            )
btn_srch_tbl.place(x = 662, y = 30)
btn_srch_cmt = Button(window,
            text = ' Поиск комментария ',
            bg = 'white',
            fg = 'green',
            command = comment_search
            )
btn_srch_cmt.place(x = 770, y = 30)

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