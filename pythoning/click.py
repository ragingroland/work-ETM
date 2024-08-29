import clickhouse_connect

client = clickhouse_connect.get_client(
    username='etm_reader',
    password='Njk13!xS#a',
    database='jdbc:clickhouse://rc1b-798lj8cw1wonii6v.mdb.yandexcloud.net:8443/ssl=1&sslmode=none')

query = 'SELECT * FROM info_client LIMIT 10'
result = client.query(query)

for row in result.result_rows:
    print(row)
