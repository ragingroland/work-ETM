#!/bin/bash

# переход к нужному каталогу
cd /autons/vertica/web_analitik

# проверка наличия флага завершения выгрузки
while [ ! -f /autons/vertica/web_analitik/end_nomwk.flg ];
    do
        echo "Файл end_nomwk.flg не найден"
        sleep 100
done

# проверка наличия флага уже запущенного процесса (именно вот этого вот всего)
if [ -f /autons/vertica/web_analitik/start_nomenwk.wrk ];
    then
        echo "Процесс уже запущен, выход."
        exit 0
    else
        # так как флага .wrk обнаружено не было, начинается процесс загрузки в базу
        echo "1_start: $(date)" > time_nomenwk.log
        echo "start: $(date)" > start_nomenwk.wrk
        echo "подключение к вертике"

        PATH=/opt/vertica/bin:$PATH:.; export PATH
        if [ -f /autons/vertica/web_analitik/nomenklature_week.csv ];
            then
                vsql -U user_etl_adm -w useretladmvert92 -h 172.24.2.140 -p 5433 -d DWH -C -f /autons/vertica/web_analitik_run/vertica_scripts/renew_nomenclaturew.vsql -A -q -o /autons/vertica/web_analitik_run/renew_nomenclaturew.vout
        fi
fi

rm start_nomenwk.wrk
rm end_nomwk.flg
echo "2_stop: $(date)" >> time_nomenwk.log
if [ -f /autons/vertica/web_analitik/nomenklature_week.csv ];
   then
       if [ ! -f /autons/vertica/web_analitik_run/nomenklature_week.exc ];
          then
               rm /autons/vertica/web_analitik/nomenklature_week.csv
       fi
fi
exit 0
