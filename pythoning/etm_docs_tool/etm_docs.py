from tkinter import Tk, Label, Entry, Button, BooleanVar, Checkbutton, scrolledtext, INSERT, END, messagebox
from tkinter.ttk import Combobox
# import os
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


# сделат так штоп схема меналас тоесь столбетс ой тоесь когда схему выбераеш столбецы меняютсо
def get_tables():
    cur = conn.cursor()
    cur.execute(f"select table_name from tables where table_schema != 'v_%' and table_schema = '{combo_schema.get()}'")
    return [row[0] for row in cur.fetchall()]

def get_schema():
    cur = conn.cursor()
    cur.execute(f"select distinct table_schema from tables where table_schema != 'v_%'")
    get_tables()
    return [row[0] for row in cur.fetchall()]

# lbl.configure(text="Текст")
# messagebox.showerror('Кнопка нажимана', 'Произошло нажмание') 
# res = "Привет {}".format(txt.get())
# lbl.configure(text=res)

# основное окно
window = Tk()
window.title("ЭТМ-IT: Описание таблиц Vertica.")
window.geometry('800x300')
window.resizable(False, False)
# надпись в окне
lbl = Label(window, 
            text="Написано ",
            font=("Times New Roman", 20)
            )
lbl.grid(column=0, row=0)
# поле ввода
txt_input = Entry(window,
            width=10,
            state = 'normal'
            )
txt_input.grid(column=1, row=0)
txt_input.focus()
txt_input.delete(0, END)
# кнопка
btn = Button(window, 
            text="DDL",
            bg="white",
            fg="green",
            command = get_ddl
            )
btn.grid(column=2, row=0)
# выпадающий список
combo_schema = Combobox(window)
schema_names = get_schema()
combo_schema['values'] = schema_names
combo_schema.current(0)
combo_schema.grid(column=0, row=0)
combo_table = Combobox(window)
table_names = get_tables()
combo_table['values'] = table_names
combo_table.current(0)
combo_table.grid(column=0, row=1)
# чекбокс
chk_state = BooleanVar()
chk_state.set(False)
chk = Checkbutton(window, text='Чек', var=chk_state)
chk.grid(column=0, row=2)
# текстовое поле
text_field = scrolledtext.ScrolledText(window, width=80,height=10)
text_field.grid(column=0, row=3)
text_field.configure(state = 'disabled')
text_field.config(state = 'normal')

if __name__ == '__main__':
    window.mainloop()
    conn.close()