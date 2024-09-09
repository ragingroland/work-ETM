import os
import re
import chardet

# def find_if_not_exist(root_dir):
    # results = []
    # for root, _, files in os.walk(root_dir):
    #     for file in files:
    #         if file.endswith(".bat"):
    #             file_path = os.path.join(root, file)
    #             with open(file_path, 'r', encoding = 'cp866') as f:
    #                 for line_number, line in enumerate(f, 1):
    #                     match = re.search(r"if\s+not\s+EXIST\s+H:\\OLAP", line, re.IGNORECASE)
    #                     if match:
    #                         results.append((file, root, line.strip()))
def find_copy_endget(root_dir):
    results = []
    for root, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".bat"):
                file_path = os.path.join(root, file)
                with open(file_path, 'rb') as f:
                    raw_data = f.read()
                    encoding = chardet.detect(raw_data)['encoding']
                with open(file_path, 'r', encoding='cp866') as f:
                    for line_number, line in enumerate(f, 1):
                        match = re.search(r"copy\s+[\w\:\/\\]+\s+endget\w+", line, re.IGNORECASE)
                        if match:
                            results.append((file, root, line.strip()))
    return results

# if __name__ == "__main__":
#     root_dir = r"H:\\"  # Задайте корневой каталог
#     results = find_if_not_exist(root_dir)

#     if results:
#         with open("results2.txt", 'w', encoding = 'utf-8') as f:
#             for file, folder, line in results:
#                 f.write(f"Файл: {file}\nПапка: {folder}\nСтрока: {line}\n\n")
#         print("Результаты поиска сохранены в файл results.txt")
#     else:
#         print("Инструкция 'IF NOT EXIST' не найдена в заданном каталоге.")

if __name__ == "__main__":
    root_dir = r"H:\\"  # Задайте корневой каталог
    # results_if_not_exist = find_if_not_exist(root_dir)
    results_copy_endget = find_copy_endget(root_dir)

    if results_copy_endget:
        with open("results.txt", 'w', encoding='utf-8') as f:
            if results_copy_endget:
                f.write("Инструкции 'copy ... endget':\n\n")
                for file, folder, line in results_copy_endget:
                    f.write(f"Файл: {file}\nПапка: {folder}\nСтрока: {line}\n\n")

        print("Результаты поиска сохранены в файл results.txt")
    else:
        print("Инструкции 'IF NOT EXIST' и 'copy ... endget' не найдены в заданном каталоге.")
