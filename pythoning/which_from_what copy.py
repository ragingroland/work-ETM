import os
import re

def find_copy_endget(root_dir):
    results = []
    seen_lines = set()  # Множество для хранения уже найденных строк
    for root, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".bat"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='cp866') as f:
                    for line_number, line in enumerate(f, 1):
                        # Новое регулярное выражение:
                        match = re.search(r"copy\s+(.+)endget\w+", line, re.IGNORECASE)
                        if match and line not in seen_lines:  # Проверка на дубликат
                            results.append((file, root, line.strip()))
                            seen_lines.add(line)  # Добавление строки в множество
    return results

if __name__ == "__main__":
    root_dir = r"H:\\"  # Задайте корневой каталог
    results = find_copy_endget(root_dir)

    if results:
        with open("results.txt", 'w', encoding='utf-8') as f:
            for file, folder, line in results:
                f.write(f"Файл: {file}\nПапка: {folder}\nСтрока: {line}\n\n")
        print("Результаты поиска сохранены в файл results.txt")
    else:
        print("Инструкции 'copy ... endget...' не найдены в заданном каталоге.")
