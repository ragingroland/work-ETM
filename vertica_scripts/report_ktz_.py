import datetime
import pandas as pd
import vertica_python
import os
import argparse

datetime_now = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
print(f'Started report generation at {datetime.datetime.now().strftime("%Y.%m.%d %H:%M:%S")}')

base_path = 'C:\\Users\\ivanov_vvx\\Downloads'
# base_path = '/home/manage/KTZ'
old_path = 'old'
upload_file_name = 'recom_ktz.csv'
report_file_name = f'report_ktz_{datetime_now}.csv'

# parser = argparse.ArgumentParser(description='Get days delta')
# parser.add_argument('days_delta', type=int, help='days delta')
# args = parser.parse_args()
# delta = args.days_delta

def clear_folder():
    for file in os.listdir(base_path):
        if file == upload_file_name:
            os.remove(os.path.join(base_path, file))
        elif '.csv' in file:
            os.rename(os.path.join(base_path, file), os.path.join(base_path, old_path, file))

def save_report(data, columns, file_name):
    file_path = os.path.join(base_path, file_name)
    upload_file_path = os.path.join(base_path, upload_file_name)
    clmns = []
    for clmn in columns:
        clmns.append(clmn[0])
    df = pd.DataFrame(data, columns=clmns, dtype='str')
    df.to_csv(file_path, sep=';', index=False, encoding='1251')
    df.to_csv(upload_file_path, sep=';', index=False, encoding='1251')
    print(f'Saved {df.shape[0]} lines to file {file_name} at {datetime.datetime.now().strftime("%Y.%m.%d %H:%M:%S")}')

conn_info = {
    'host': '172.24.2.140',
    'port': 5433,
    'user': 'user_etl',
    'password': 'useretlvert92',
    'database': 'DWH',
    # 'unicode_error': 'strict',
    # 'log_level': logging.DEBUG
}

# clear_folder()

with open(os.path.join(base_path, 'report_InfoClustRgd6ForActions_new.vsql'), 'r') as f:
    query = f.read()

# query = query.replace(':delta', str(delta))

try:
    connection = vertica_python.connect(**conn_info)
    cursor = connection.cursor()
    cursor.execute(query)
    # cursor.execute('select * from tmp_itog;')
    while True:
        rows = cursor.fetchall()
        print(rows)
        if not cursor.nextset():
            break
    #rows = cursor.fetchall()
    columns = cursor.description
    #print(rows)
    # save_report(rows, columns, report_file_name)

finally:
    connection.close()

print(f'Finished reports generation at {datetime.datetime.now().strftime("%Y.%m.%d %H:%M:%S")}')