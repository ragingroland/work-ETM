# import tkinter as tk
# from tkinter import ttk

# def toggle_expand(item_id):
#     current_state = tree.item(item_id, "open")
#     tree.item(item_id, open=not current_state)

# root = tk.Tk()

# # Create a Treeview
# tree = ttk.Treeview(root, columns=("Name", "Age"), show="headings")

# # Add data to the Treeview with parent-child relationships
# parent_item = tree.insert("", "end", values=("Parent", ""))
# tree.insert(parent_item, "end", values=("Child 1", 10))
# tree.insert(parent_item, "end", values=("Child 2", 15))

# # Create a vertical scrollbar
# scrollbar = tk.Scrollbar(root, command=tree.yview)

# # Set the Treeview's yscrollcommand to the scrollbar's set method
# tree.configure(yscrollcommand=scrollbar.set)

# # Pack the Treeview and scrollbar
# tree.pack(side=tk.LEFT, fill=tk.Y)
# scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

# # Create a button to toggle item expansion
# toggle_button = tk.Button(root, text="Toggle Expand", command=lambda: toggle_expand(parent_item))
# toggle_button.pack(pady=10)

# root.mainloop()

from collections import OrderedDict

data = [
    {'table_name': 'DataMart.CCBNorm4DSMng', 'column_name': 'Class55_Code', 'data_type': 'varchar(2)', 'comment': 'Специализация - Код класса 55-го классификатора'}),
    {'table_name': 'DataMart.CCBNorm4DSMng', 'column_name': 'Category', 'data_type': 'varchar(20)', 'comment': 'Категория (оно же статус)'}),
    {'table_name': 'DataMart.CCBNorm4DSMng', 'column_name': 'NormCCB', 'data_type': 'int', 'comment': 'Норматив по ПКБ '})
]

# Создаем пустой словарь
result = {}

# Итерируемся по списку OrderedDict
for item in data:
    # Используем 'table_name' в качестве ключа в словаре
    table_name = item['table_name']
    if table_name not in result:
        result[table_name] = []

    # Добавляем информацию о столбце в список
    result[table_name].append({
        'column_name': item['column_name'],
        'data_type': item['data_type'],
        'comment': item['comment']
    })

print(result)

{'table_name': 'DataMart.CCBNorm4DSMng', 'column_name': 'Class55_Code', 'data_type': 'varchar(2)', 'comment': 'Специализация - Код класса 55-го классификатора'}
{'table_name': 'DataMart.CCBNorm4DSMng', 'column_name': 'Category', 'data_type': 'varchar(20)', 'comment': 'Категория (оно же статус)'}
{'table_name': 'DataMart.CCBNorm4DSMng', 'column_name': 'NormCCB', 'data_type': 'int', 'comment': 'Норматив по ПКБ '}


import tkinter as tk
from tkinter import ttk, messagebox
from tkintertable import TableCanvas, TableModel

# Функция для обработки двойного клика на элементе в tkintertable
def table_click(event):
    try:
        row_id = table.get_row_clicked(event)
        if row_id is None:
            return
        row = table.model.getRecordAtRow(row_id)
        fullname = row['Table']
        schema_name, table_name = fullname.split('.')
        ddls = fullname
        
        cur.execute(f"""SELECT
                            at.schema_name || '.' || at.table_name AS table_name,
                            cl.column_name,
                            cl.data_type,
                            cm.comment
                        FROM v_catalog.all_tables at
                        LEFT JOIN v_catalog.columns cl ON at.table_name = cl.table_name
                        LEFT JOIN v_catalog.comments cm ON cl.table_schema = cm.object_schema
                            AND cl.table_name = cm.object_name
                            AND UPPER(cl.column_name) = UPPER(cm.child_object)
                        WHERE at.schema_name = '{schema_name}' AND at.table_name = '{table_name}';""")
        result = cur.fetchall()
        
        cur.execute(f"SELECT export_objects('', '{ddls}');")
        result2 = cur.fetchall()
        
        cur.execute(f"""SELECT
                            remarks
                        FROM v_catalog.all_tables
                        WHERE table_name = '{table_name}';""")
        result3 = cur.fetchall()
    except Exception as e:
        messagebox.showwarning('Ошибка', f'Не удалось получить информацию: {e}')
    else:
        # Преобразование результата в формат, ожидаемый tkintertable
        data = {i: {'Table': row[0], 'Column': row[1], 'Data Type': row[2], 'Comment': row[3]} for i, row in enumerate(result)}

        # Очистка и обновление данных в tkintertable
        table.model.deleteRows(table.model.data.keys())
        table.model.importDict(data)
        table.redraw()

        # Очистка и обновление текстовых полей
        text_field.delete('1.0', tk.END)
        for row in result2:
            text_field.insert(tk.INSERT, row[0])
        
        text_field2.delete('1.0', tk.END)
        for row in result3:
            text_field2.insert(tk.INSERT, row[0])

# Пример инициализации приложения Tkinter
root = tk.Tk()
root.title("Table Information")

frame = tk.Frame(root)
frame.pack(fill=tk.BOTH, expand=1)

# Пример инициализации объекта tkintertable
model = TableModel()
table = TableCanvas(frame, model=model)
table.show()
table.bind("<Double-1>", table_click)

# Пример инициализации текстовых полей
text_field = tk.Text(root, height=10, width=50)
text_field.pack(padx=10, pady=5)
text_field2 = tk.Text(root, height=5, width=50)
text_field2.pack(padx=10, pady=5)

# Пример данных для инициализации tkintertable
example_data = {
    0: {'Table': 'schema1.table1', 'Column': 'column1', 'Data Type': 'int', 'Comment': 'comment1'},
    1: {'Table': 'schema1.table2', 'Column': 'column2', 'Data Type': 'varchar', 'Comment': 'comment2'}
}
model.importDict(example_data)
table.redraw()

# Запуск основного цикла приложения
root.mainloop()
