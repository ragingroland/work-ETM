#!/bin/bash

# переход к нужному каталогу
cd /autons/vertica/web_analitik

# проверка наличия флага завершения выгрузки
while [ ! -f /autons/vertica/web_analitik/end_di.flg ];
    do
        echo "Файл end_di.flg не найден"
        sleep 100
done

# проверка наличия флага уже запущенного процесса (именно вот этого вот всего)
if [ -f /autons/vertica/web_analitik/start_di.wrk ];
    then
        echo "Процесс уже запущен, выход."
        exit 0
    else
        # так как флага .wrk обнаружено не было, начинается процесс загрузки в базу
        echo "1_start: $(date)" > time_di.log
        echo "start: $(date)" > start_di.wrk
        echo "подключение к вертике"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/direct_indicators.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_directindicators.vsql -A -q -o /autons/vertica/web_analitik_run/vertica_scripts/renew_directindicators.vout
        fi
fi

if [ ! -f /autons/vertica/web_analitik_run/vertica_scripts/direct_indicators.rej ];
    then
        rm /autons/vertica/web_analitik/direct_indicators.csv
fi

rm start_di.wrk
rm end_di.flg
echo "2_stop: $(date)" >> time_di.log
exit 0
