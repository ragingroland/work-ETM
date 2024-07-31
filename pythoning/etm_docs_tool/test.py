import tkinter as tk
from tkinter import ttk

def toggle_expand(item_id):
    current_state = tree.item(item_id, "open")
    tree.item(item_id, open=not current_state)

root = tk.Tk()

# Create a Treeview
tree = ttk.Treeview(root, columns=("Name", "Age"), show="headings")

# Add data to the Treeview with parent-child relationships
parent_item = tree.insert("", "end", values=("Parent", ""))
tree.insert(parent_item, "end", values=("Child 1", 10))
tree.insert(parent_item, "end", values=("Child 2", 15))

# Create a vertical scrollbar
scrollbar = tk.Scrollbar(root, command=tree.yview)

# Set the Treeview's yscrollcommand to the scrollbar's set method
tree.configure(yscrollcommand=scrollbar.set)

# Pack the Treeview and scrollbar
tree.pack(side=tk.LEFT, fill=tk.Y)
scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

# Create a button to toggle item expansion
toggle_button = tk.Button(root, text="Toggle Expand", command=lambda: toggle_expand(parent_item))
toggle_button.pack(pady=10)

root.mainloop()