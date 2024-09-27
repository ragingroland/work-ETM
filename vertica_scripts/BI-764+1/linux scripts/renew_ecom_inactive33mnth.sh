#!/bin/bash

# переход к нужному каталогу
cd /autons/vertica/web_analitik

# проверка наличия флага завершения выгрузки
while [ ! -f /autons/vertica/web_analitik/end_inact33_mnth.flg ];
    do
        echo "Файл end_inact33_mnth.flg не найден"
        sleep 100
done

# проверка наличия флага уже запущенного процесса (именно вот этого вот всего)
if [ -f /autons/vertica/web_analitik/start_inact33mnth.wrk ];
    then
        echo "Процесс уже запущен, выход."
        exit 0
    else
        # так как флага .wrk обнаружено не было, начинается процесс загрузки в базу
        echo "1_start: $(date)" > time_inactive33mnth.log
        echo "start: $(date)" > start_inact33mnth.wrk
        echo "подключение к вертике"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/inactive_33_month.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_inactive33mnth.vsql -A -q -o /autons/vertica/web_analitik_run/renew_inactive33mnth.vout
        fi
fi

if [ ! -f /autons/vertica/web_analitik_run/vertica_scripts/inactive_33_month.rej ];
    then
        rm /autons/vertica/web_analitik/inactive_33_month.csv
fi

rm start_inact33mnth.wrk
rm end_inact33_mnth.flg
echo "2_stop: $(date)" >> time_inactive33mnth.log
exit 0
