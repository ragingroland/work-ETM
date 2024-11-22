#!/bin/bash

# переход к нужному каталогу
cd /autons/vertica/web_analitik
rm wbanl.flg
# проверка наличия флага завершения выгрузки
while [ ! -f /autons/vertica/web_analitik/end_wbanl.flg ];
    do
        echo "Файл end_wbanl.flg не найден"
        sleep 100
done

# проверка наличия флага уже запущенного процесса (именно вот этого вот всего)
if [ -f /autons/vertica/web_analitik/start_wa.wrk ];
    then
        echo "Процесс уже запущен, выход."
        exit 0
    else
        # так как флага .wrk обнаружено не было, начинается процесс загрузки в базу
        echo "1_start: $(date)" > time_wa.log
        echo "start: $(date)" > start_wa.wrk
        echo "подключение к вертике"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/dm_web_analytics.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_webanalytics.vsql -A -q -o /autons/vertica/web_analitik_run/renew_webanalytics.vout
        fi
fi

rm start_wa.wrk
echo "2_stop: $(date)" >> time_wa.log
if [ -f /autons/vertica/web_analitik/dm_web_analytics.csv ];
   then
       if [ ! -f /autons/vertica/web_analitik_run/web_analytics.exc ];
          then
               rm /autons/vertica/web_analitik/dm_web_analytics.csv
               rm end_wbanl.flg
               touch wbanl.flg
       fi
fi
exit 0
